CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0082" IS
                                                       
                                                                  
                                                   
    g_skip_parse VARCHAR2(1 CHAR) := 'N';


PROCEDURE P_DMF0082_GET_MAIN_DATA
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , p_plant_site_id  IN  VARCHAR2 DEFAULT 'ALL'                                                                            
  , p_project_code   IN  VARCHAR2 DEFAULT 'ALL'                                                       
  , p_owner          IN  VARCHAR2 DEFAULT 'ALL'                                                     
  , p_sender_code    IN  VARCHAR2 DEFAULT 'ALL'                                                                                
  , O_RC1            OUT SYS_REFCURSOR
  , O_RC2            OUT SYS_REFCURSOR
  , O_RC3            OUT SYS_REFCURSOR
  , O_RC4            OUT SYS_REFCURSOR
  , O_RC5            OUT SYS_REFCURSOR
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
                                                                                                                                                       
                                        
                                 
                                      
                
                                                                                                                                                       
                                            
                                                                                                                                                       
                                                                                            
                                                                                         
                                                                                                                             
                                                                                                   
                                                                                                                                   
                                                                                                       
                                                                                       
                                                                                                                 
                                                                                                                                                 
                                                                         
                                                                        
                                                                                                        
                                                                                                     
                                                                                                             
                                                                                          
                                                                                                                                                         
                                                                                                       
IS
                                       
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR);
    VA_SHEET_NAME       VARCHAR2(50 CHAR);

                               
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;
    V_PV_COL_LIST       CLOB;
    V_QTY_SUM           CLOB;
    V_PV_COLUMN_NAME    VARCHAR2(100 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

                           
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);
    V_FROM_RESULT       VARCHAR2(8 CHAR);                                                       

                                
    V_CUR_COLUMN_NAME   VARCHAR2(100 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(10 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

                           
    V_GROUP_ID          VARCHAR2(50 CHAR);

                            
    V_SQL               CLOB;

                        
    V_LOG_TYPE          VARCHAR2(10 CHAR) := 'I';
    N_LOG_COUNT         NUMBER(10)        := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE              := SYSDATE;
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

                              
                                                              
                                                                   
                                                              
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                                               AS COLUMN_NAME
              , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD                          AS PV_NAME
              , A.BASIS_YYYYMMDD || '_31'                                                             AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')                                       AS COLUMN_NAME
              , '''W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0') || ''' AS W_' || A.BASIS_YYYYMM || LPAD(A.ISO_WEEK,2,'0')  AS PV_NAME
              , A.BASIS_START_DATE || '_21'                                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                                                 AS COLUMN_NAME
              , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM                              AS PV_NAME
              , MIN(A.BASIS_START_DATE) || '_01'                                                      AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

                             
    CURSOR C_TITLE IS
        SELECT * FROM (                                                               
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                    WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                    ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = VA_PROGRAM_ID
        AND    U.SHEET_NAME  = VA_SHEET_NAME
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                                                                                        
                                                                                                           
        AND    U.COLUMN_NAME IN (
                 'DIVISION_ID','PROJECT_CODE','END_CUSTOMER','SCM_SITE_ID','ITEM_ID','DOM_EXP','FCST_TYPE','INCOTERMS'
                ,'MEASURE','PLANT_SITE_ID','CELL_PROD_SITE_ID','BUCKET_TYPE','BUCKET_KEY','QTY','MEASURE_GROUP'
                ,'CELL_MODEL','NICK_NAME','DMS_SALES','DMS_CUSTOMER','OWNER','DEPT_ID','DEPT_NAME_KO'
                ,'FORECAST_INFO_CELL_PACK_COUNT','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','BIZ_TYPE'
                ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','PROJECT_STATUS','ITEM_NAME','VMI_YN'
                ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_ALL','FORECAST_INFO_SPEC'
                ,'FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME','CELL_PER_CAR','CELL_PER_MODULE'
                ,'MODULE_PER_CAR','SORT_ORDER_NO','ENERGE','CELL_QUANTITY','AS_FROM_SITE'
                ,'CREATE_DATE','LAST_UPDATED_BY','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT'
                ,'CURRENCY','VERSION_NO','CUTOFF_YYYYMMDD','NOTATION','EDIT_FLAG','SORT_KEY','GROUP_ID'
                ,'SUN','MON','TUE','WED','THU','FRI','SAT','YYYYMM','YYYYMMWW','WEEK_END_YN','MONTH_END_YN'
                ,'AS_YN','ATTR1','VMI_STD_DIO','NEW_FLAG'
                ,'TEAM_ID','TEAM_NAME_KO','FORECAST_INFO_CELL_MODEL','LAST_UPDATE_DATE','BUCKET' )
        UNION ALL
                                                                            
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO,85) - 0.5 ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = ' '                                                                                                                   
        AND    C.VALID_YN     = 'Y'
                                                                                         
                                                                                                                                           
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U2
                   WHERE  U2.PROGRAM_ID  = C.PROGRAM_ID
                   AND    U2.SHEET_NAME  = C.SHEET_NAME
                   AND    U2.COLUMN_NAME = C.COLUMN_NAME
                   AND    U2.USER_ID     = p_created_by
                   AND    U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               )
        ) ORDER BY TO_NUMBER(SORT_ORDER_NO);                                                                                                 

                                                                                   
                                                                     
                                                                  
                                                
    V_CUTOFF_FROM       VARCHAR2(8 CHAR);
    V_CUTOFF_TO         VARCHAR2(8 CHAR);

BEGIN

                                                                       

                                                                      

                                                                 

                                                 

                                                         

                                                              

    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_project_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_project_code, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_owner', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_owner, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_sender_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_sender_code, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_team_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_team_id, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));

                                                                                              
                                                                                       
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

    V_PROC_INPUT := JSON_OBJECT(
        'p_division_id'   VALUE p_division_id,
        'p_team_id'       VALUE p_team_id,
        'p_customer'      VALUE p_customer,
        'p_biz_type'      VALUE p_biz_type,
        'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
        'p_to_yyyymmdd'   VALUE p_to_yyyymmdd,
        'p_scm_site_id'   VALUE p_scm_site_id,
        'p_item_id'       VALUE p_item_id,
        'p_version_type'  VALUE p_version_type,
        'p_qty_yn'        VALUE p_qty_yn,
        'p_created_by'    VALUE p_created_by,
        'p_user_group'    VALUE p_user_group,
        'p_plant_site_id' VALUE p_plant_site_id,
        'p_project_code'  VALUE p_project_code,
        'p_owner'         VALUE p_owner,
        'p_sender_code'   VALUE p_sender_code
    );

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '시작', 'P_DMF0082_GET_MAIN_DATA START',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

                                                                          
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

                                                                                                        
                              
                           
                           
                           
                                                                                                           
                     
                                                                                                           

    VA_PROGRAM_ID := 'DMF0082';
    VA_SHEET_NAME := 'FcstNPrice';

                   
    SELECT COUNT(*) INTO V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'C'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE                                                                                   
             , p_created_by
             , SYSDATE                                                                                   
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

               
    SELECT COUNT(*) INTO V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID
        , PROGRAM_ID
        , SHEET_NAME
        , USER_INQUIRY_COLUMN_TYPE_CODE
        , COLUMN_NAME
        , SORT_ORDER_NO
        , SUB_TOTAL_FLAG
        , DATA_SORT_METHOD_CODE
        , CREATED_BY
        , CREATION_DATE
        , LAST_UPDATED_BY
        , LAST_UPDATE_DATE
        )
        SELECT p_created_by
             , C.PROGRAM_ID
             , VA_SHEET_NAME                                                                          
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE                                                                                   
             , p_created_by
             , SYSDATE                                                                                   
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME                                                         
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;

                           
                           
                           
                                                                                                        
                      
                         
                         
                         
                                                            
                                                                                                           
                   
                                                                                                           

                                                    
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_QTY_SUM, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
            V_QTY_SUM     := 'NVL(' || V_PV_COLUMN_NAME || ',0)';
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
            V_QTY_SUM     := V_QTY_SUM     || '+NVL(' || V_PV_COLUMN_NAME || ',0)';
        END IF;
    END LOOP;
    CLOSE C_BUCKET;

                         
                         
                         
                                                                                                        
                          
                          
                          
                                                                                                           
                    
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_T_VERSION;

    IF p_version_type LIKE '%SP%' OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
                                                                                          
        INSERT INTO SCM_MGR.GT_DMF0082_T_VERSION (VERSION_NO, VERSION_NO_W, NOW_YYYYMMDD, SP_VERSION_NO)
        SELECT A.TOKEN      AS VERSION_NO
             , CASE WHEN D.DM_RTF_YN = 'N' THEN A.TOKEN || '(' || C.ISO_YYYYWW || ') (NO PLAN)'
                    ELSE A.TOKEN || '(' || C.ISO_YYYYWW || ')'
               END          AS VERSION_NO_W
             , TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') - 7, 'YYYYMMDD') AS NOW_YYYYMMDD
             , (SELECT MAX(V2.VERSION_NO)
                FROM   SCM_MGR.DM_MST_VERSION V2
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M CM
                    ON  V2.YYYYMMDD = CM.BASIS_YYYYMMDD
                WHERE  V2.VERSION_TYPE LIKE 'SP%'
                AND    V2.DIVISION_ID  = B.DIVISION_ID
                AND    CM.ISO_YYYYWW   = C.ISO_YYYYWW) AS SP_VERSION_NO
        FROM   (SELECT REGEXP_SUBSTR(p_version_type, '[^,]+', 1, LEVEL) AS TOKEN
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_version_type, ',') + 1) A
        INNER JOIN SCM_MGR.DM_MST_VERSION B
            ON  B.VERSION_NO  = A.TOKEN
            AND B.DIVISION_ID = p_division_id
        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
            ON  C.BASIS_YYYYMMDD = B.YYYYMMDD
        LEFT JOIN SCM_MGR.SCP_PLN_INTERFACE_YN D
            ON  D.DIVISION_ID        = B.DIVISION_ID
            AND D.PLAN_START_YYYYMMDD = C.BASIS_START_DATE;
    END IF;

                                                                                                                                                                                                                               

                                                         
                                                                               
                                                                                           
                                                    
    SELECT NVL(MIN(B.YYYYMMDD),'00000000'), NVL(MAX(B.YYYYMMDD),'99999999')
      INTO V_CUTOFF_FROM, V_CUTOFF_TO
      FROM SCM_MGR.GT_DMF0082_T_VERSION V
      JOIN SCM_MGR.DM_MST_VERSION B
        ON B.VERSION_NO = V.VERSION_NO AND B.DIVISION_ID = p_division_id;


                          
                          
                          
                                                                                                        
                           
                                                                                     
                                                                          
                                                          
                                                                                                           
                    
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_T_WS_FCST;

    INSERT INTO SCM_MGR.GT_DMF0082_T_WS_FCST (FCST_TYPE)
    SELECT DISTINCT A.SEGMENT1 AS FCST_TYPE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'SALES_TYPE_CODE';

                                                                                                                                                                                                                               

                                                                                                           
               
                                                                                                           

                                                                       
                                                                                    
                                                                      
                                                                       
                                                                      
    V_FROM_YYYYMMDD := p_from_yyyymmdd;
    V_TO_YYYYMMDD   := p_to_yyyymmdd;

                                                
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD)
        INTO   V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.ISO_YYYYWW = (SELECT MIN(ISO_YYYYWW)
                               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD'));
    EXCEPTION WHEN OTHERS THEN V_FROM_YYYYMMDD := p_from_yyyymmdd;
    END;

                                     
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = p_from_yyyymmdd;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_FROM_RESULT := p_from_yyyymmdd;
    END;

                                                     
    BEGIN
        SELECT C.BASIS_START_DATE INTO V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  C.BASIS_YYYYMMDD = p_to_yyyymmdd;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_TO_RESULT := p_to_yyyymmdd;
    END;

                                                        
    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN                                   
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_TO_RESULT   := V_FROM_YYYYMMDD;                              
    ELSE                                                           
        V_TO_YYYYMMDD  := p_to_yyyymmdd;
        V_FROM_RESULT  := '19000101';
        V_TO_RESULT    := '19000101';
    END IF;

                                                                                                           
                                                                
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V;

                                            
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , T1.ITEM_NAME
         , T1.ITEM_CLASS
         , T1.ITEM_CLASS_NAME
         , T1.NICK_NAME
         , T1.ITEM_TYPE
         , T1.MATERIAL_CLASS_NAME
         , T1.ITEM_UOM
         , T1.SPEC
         , T1.MDM_PROJECT_NAME
         , T1.MIN_CAPACITY
         , T1.ACTIVE_FLAG
         , T1.ENERGE
         , T1.CELL_QUANTITY
         , T1.SCP_EXTRA_SPEC
         , T1.FORECAST_INFO_BIZ_TYPE
         , T1.FORECAST_INFO_PRODUCT_GROUP
         , T1.FORECAST_INFO_CELL_MODEL
         , T1.FORECAST_INFO_CELL_PACK_COUNT
         , T1.FORECAST_INFO_SPEC
         , T1.FORECAST_INFOR_VERSION
         , T1.CELL_TYPE
                                                                                     
    FROM   SCM_MGR.SCM_ITEM_M_SN T1
    WHERE  T1.DIVISION_ID = p_division_id
      AND  T1.ACTIVE_FLAG = 'Y'
                                                  
                                                  
                                                                         
                                                        
                                                          
                                                              
    AND  SUBSTR(T1.ITEM_ID,1,12) IN (
           SELECT SUBSTR(S.ITEM_ID,1,12)
             FROM SCM_MGR.SCM_MST_SITE_ITEM S
            WHERE S.DIVISION_ID = p_division_id );
                                            

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_ORI_V', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                                         
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V;

                                          
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)                                AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)                               AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)                          AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)                                AS NICK_NAME
         , CASE MIN(CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                         WHEN T1.ITEM_TYPE = 'H' THEN 2
                         WHEN T1.ITEM_TYPE = 'Q' THEN 3
                         ELSE 4 END)
                WHEN 1 THEN 'P'
                WHEN 2 THEN 'H'
                WHEN 3 THEN 'Q'
                ELSE 'R'
           END                                              AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME)                      AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)                                 AS ITEM_UOM
         , MAX(T1.SPEC)                                     AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)                         AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)                             AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)                              AS ACTIVE_FLAG
         , MAX(T1.ENERGE)                                   AS ENERGE
         , MAX(T1.CELL_QUANTITY)                            AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)                           AS SCP_EXTRA_SPEC
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V T1
    WHERE  1 = 1
    GROUP BY T1.DIVISION_ID, T1.ITEM_ID;
                                          

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_A_V', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                                                      
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V;

                                          
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V
    (
        DIVISION_ID, ITEM_ID
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
    )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12)                           AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)                      AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)                 AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)                    AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)               AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)                          AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)                      AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                                   AS CELL_TYPE
    FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_ORI_V
    GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);
                                          

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_B_V', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                                                            
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V;

                                        
    INSERT INTO SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V
    (
        DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME
      , ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY
      , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
      , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT
      , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    )
    SELECT DIVISION_ID
         , ITEM_ID
         , ITEM_NAME
         , ITEM_CLASS
         , ITEM_CLASS_NAME
         , NICK_NAME
         , ITEM_TYPE
         , MATERIAL_CLASS_NAME
         , ITEM_UOM
         , SPEC
         , MDM_PROJECT_NAME
         , MIN_CAPACITY
         , FORECAST_INFO_BIZ_TYPE
         , FORECAST_INFO_PRODUCT_GROUP
         , FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC
         , FORECAST_INFOR_VERSION
         , ACTIVE_FLAG
         , CELL_TYPE
         , CASE WHEN TO_NUMBER(ENERGE DEFAULT NULL ON CONVERSION ERROR) IS NOT NULL
                THEN ROUND(TO_NUMBER(ENERGE) / 1000, 4)
                ELSE NULL
           END                                              AS ENERGE                
         , CELL_QUANTITY
         , SCP_EXTRA_SPEC
    FROM (
        SELECT T2X.DIVISION_ID
             , T2X.ITEM_ID
             , T2X.ITEM_NAME
             , T2X.ITEM_CLASS
             , T2X.ITEM_CLASS_NAME
             , T2X.NICK_NAME
             , T2X.ITEM_TYPE
             , T2X.MATERIAL_CLASS_NAME
             , T2X.ITEM_UOM
             , T2X.SPEC
             , T2X.MDM_PROJECT_NAME
             , T2X.MIN_CAPACITY
             , T2X.FORECAST_INFO_BIZ_TYPE
             , T2X.FORECAST_INFO_PRODUCT_GROUP
             , T2X.FORECAST_INFO_CELL_MODEL
             , T2X.FORECAST_INFO_CELL_PACK_COUNT
             , T2X.FORECAST_INFO_SPEC
             , T2X.FORECAST_INFOR_VERSION
             , T2X.ACTIVE_FLAG
             , T2X.CELL_TYPE
             , T2X.ENERGE
             , T2X.CELL_QUANTITY
             , T2X.SCP_EXTRA_SPEC
        FROM (
            SELECT T1.DIVISION_ID
                 , T1.ITEM_ID
                 , T1.ITEM_NAME
                 , T1.ITEM_CLASS
                 , T1.ITEM_CLASS_NAME
                 , T1.NICK_NAME
                 , T1.ITEM_TYPE
                 , T1.MATERIAL_CLASS_NAME
                 , T1.ITEM_UOM
                 , T1.SPEC
                 , T1.MDM_PROJECT_NAME
                 , T1.MIN_CAPACITY
                 , T2.FORECAST_INFO_BIZ_TYPE
                 , T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL
                 , T2.FORECAST_INFO_CELL_PACK_COUNT
                 , T2.FORECAST_INFO_SPEC
                 , T2.FORECAST_INFOR_VERSION
                 , T1.ACTIVE_FLAG
                 , T2.CELL_TYPE
                 , T1.ENERGE
                 , T1.CELL_QUANTITY
                 , T1.SCP_EXTRA_SPEC
            FROM   SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_A_V T1
            INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_B_V T2
                ON  T1.DIVISION_ID = T2.DIVISION_ID
                AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
            WHERE 1 = 1
        ) T2X
        INNER JOIN (
            SELECT DISTINCT '%' || TOKEN || '%' AS TST
            FROM (
                SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id, ',') + 1
            )
        ) B
            ON  T2X.ITEM_ID   LIKE B.TST
             OR T2X.NICK_NAME LIKE B.TST
        WHERE  T2X.DIVISION_ID = p_division_id
    )
    GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
           , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
           , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
           , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC;
                                        

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MST_ITEM_SINGLE_V', NO_INVALIDATE => FALSE);                                                                  

                                                                                                        
                              
                                                                                                           
                                                                                      
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL;

                              
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
      , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , T2.NICK_NAME
         , F.ATTRIBUTE1                                     AS DMS_SALES
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER
         , (SELECT LISTAGG(X.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY X.USER_NAME_EN)
            FROM   (SELECT DISTINCT ZA.USER_NAME_EN
                    FROM   (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL) AS TOK                                                             
                            FROM   DUAL
                            CONNECT BY LEVEL <= REGEXP_COUNT(F.OWNER, ',') + 1) TK
                    JOIN   SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = TK.TOK) X
           )                                                AS OWNER
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT
           END                                              AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.ITEM_TYPE
         , F.PROJECT_CODE                                   AS PROJECT_NAME
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , ''                                               AS BIZ_TYPE
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY_NAME
         , H.CITY_NAME
         , ''                                               AS PROJECT_STATUS
         , T2.ITEM_NAME
         , S.VMI_YN
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , TO_NUMBER(T2.MIN_CAPACITY DEFAULT NULL ON CONVERSION ERROR) AS MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE
           END                                              AS FORECAST_INFO_BIZ_TYPE
         , LOOK.NAME                                        AS CELL_TYPE
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_CAR
         , TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR) AS CELL_PER_MODULE
         , TO_NUMBER(F.CELL_PER_CAR    DEFAULT NULL ON CONVERSION ERROR)
           / CASE WHEN NVL(TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR), 0) = 0 THEN 1
                  ELSE TO_NUMBER(F.CELL_PER_MODULE DEFAULT NULL ON CONVERSION ERROR)
             END                                             AS MODULE_PER_CAR
         , NULL                                             AS SORT_ORDER_NO
         , TO_CHAR(T2.ENERGE)                               AS ENERGE
         , TO_NUMBER(T2.CELL_QUANTITY DEFAULT NULL ON CONVERSION ERROR) AS CELL_QUANTITY
         , '-'                                               AS PLANT_SITE_ID                         
         , F.VALID_YN                                       AS ITEM_VALID_YN
         , S.END_CUSTOMER
         , NULL                                              AS PROJECT_S_OP_REPORT                                                            
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN (
        SELECT DISTINCT '%' || TOKEN || '%' AS TST
        FROM (
            SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
            FROM   DUAL
            CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id, ',') + 1
        )
    ) B
        ON  F.ITEM_ID     LIKE B.TST
         OR T2.NICK_NAME  LIKE B.TST
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY        = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY     = I.COUNTRY
    LEFT JOIN (
        SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
            ON B2.DEPT_ID = C.DEPT_ID
    ) TEAM
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                                THEN F.OWNER
                                ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                           END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0
                             THEN F.OWNER
                             ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1)
                        END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                             ELSE F.DEPT_ID                                                                    
                        END
    LEFT JOIN (
        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
    ) LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GT_DMF0082_MST_ITEM_SINGLE_V T4
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (
        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
        FROM (
            SELECT SEGMENT2 AS MODEL
                 , SEGMENT3 AS BIZ_TYPE
                 , SEGMENT4 AS CELL_PACK_COUNT
                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
              AND  SEGMENT1    = '40'
        ) A
        WHERE MODEL_RANK = 1
    ) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = p_division_id
    AND    (p_scm_site_id = 'ALL' OR F.SCM_SITE_ID IN (
                SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
    AND    (p_customer = 'ALL' OR F.PROJECT_CODE IN (
                SELECT REGEXP_SUBSTR(p_customer, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= REGEXP_COUNT(p_customer, ',') + 1))
    AND    (p_biz_type = 'ALL' OR
                CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                     ELSE T2.FORECAST_INFO_BIZ_TYPE
                END IN (
                    SELECT REGEXP_SUBSTR(p_biz_type, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= REGEXP_COUNT(p_biz_type, ',') + 1));
                              

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM_ALL', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                           
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM;

                           
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
    (
        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
      , CELL_MODEL, DMS_SALES, DMS_CUSTOMER, OWNER
      , DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT
      , ITEM_TYPE, PROJECT_OWNER, BIZ_TYPE
      , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS
      , ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE
      , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE
      , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
      , CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR
      , SORT_ORDER_NO, ENERGE, CELL_QUANTITY, PLANT_SITE_ID
      , ITEM_VALID_YN, END_CUSTOMER, PROJECT_S_OP_REPORT
    )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                      AS CELL_MODEL
         , MAX(DMS_SALES)                       AS DMS_SALES
         , MAX(DMS_CUSTOMER)                    AS DMS_CUSTOMER
         , MAX(OWNER)                           AS OWNER
         , MAX(DEPT_ID)                         AS DEPT_ID
         , MAX(DEPT_NAME_KO)                    AS DEPT_NAME_KO
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)   AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(ITEM_TYPE)                       AS ITEM_TYPE
         , MAX(PROJECT_OWNER)                   AS PROJECT_OWNER
         , MAX(BIZ_TYPE)                        AS BIZ_TYPE
         , MAX(SOLDTO_CUSTOMER)                 AS SOLDTO_CUSTOMER
         , MAX(COUNTRY_NAME)                    AS COUNTRY_NAME
         , MAX(CITY_NAME)                       AS CITY_NAME
         , MAX(PROJECT_STATUS)                  AS PROJECT_STATUS
         , MAX(ITEM_NAME)                       AS ITEM_NAME
         , MAX(VMI_YN)                          AS VMI_YN
         , MAX(CUST_GROUP)                      AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                  AS CUST_GROUP_DTL
         , MAX(APPLICATION)                     AS APPLICATION
         , MAX(ROUTE)                           AS ROUTE
         , MAX(MDM_PROJECT_NAME)                AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                    AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)          AS FORECAST_INFO_BIZ_TYPE
         , MAX(CELL_TYPE)                       AS CELL_TYPE
         , MAX(FORECAST_INFO_ALL)               AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)              AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)          AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)            AS CELL_MODEL_NICK_NAME
         , MAX(CELL_PER_CAR)                    AS CELL_PER_CAR
         , MAX(CELL_PER_MODULE)                 AS CELL_PER_MODULE
         , MAX(MODULE_PER_CAR)                  AS MODULE_PER_CAR
         , MAX(SORT_ORDER_NO)                   AS SORT_ORDER_NO
         , MAX(ENERGE)                          AS ENERGE
         , MAX(CELL_QUANTITY)                   AS CELL_QUANTITY
         , MAX(PLANT_SITE_ID)                   AS PLANT_SITE_ID
         , MAX(ITEM_VALID_YN)                   AS ITEM_VALID_YN
         , MAX(END_CUSTOMER)                    AS END_CUSTOMER
         , MAX(PROJECT_S_OP_REPORT)             AS PROJECT_S_OP_REPORT
    FROM   SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM_ALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
                           

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_SITE_ITEM', NO_INVALIDATE => FALSE);                                                                  

                              
                                                                                                        
                                                                           
                                  
                                
                                                                                                           
                                    
                                                                                                           





    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE;

    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT U.COLUMN_NAME                          AS MEASURE
         , NVL(M.ATTRIBUTE5, U.COLUMN_NAME)       AS RESULT_MEASURE
         , U.COLUMN_NAME                          AS MEASURE_GROUP
         , U.SORT_ORDER_NO
         , U.USER_ID
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    INNER JOIN SCM_MGR.SCM_MST_SHEET_MEASURE M
        ON  M.PROGRAM_ID  = U.PROGRAM_ID
        AND M.SHEET_NAME  = U.SHEET_NAME
        AND M.COLUMN_NAME = U.COLUMN_NAME
        AND M.VALID_YN    = 'Y'
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;



    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, 'ING', 'VA_PROGRAM_ID:' || VA_PROGRAM_ID || + ',VA_SHEET_NAME:' || VA_SHEET_NAME || ',p_created_by:' ||p_created_by,
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

                                                                          
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE
        (MEASURE, RESULT_MEASURE, MEASURE_GROUP, SORT_ORDER_NO, USER_ID)
    SELECT M.COLUMN_NAME, M.COLUMN_NAME, M.COLUMN_NAME, M.SORT_ORDER_NO, 'DM_ADMIN'
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE M
    WHERE  M.PROGRAM_ID  = VA_PROGRAM_ID
    AND    M.SHEET_NAME  = VA_SHEET_NAME
    AND    M.COLUMN_NAME IN ('LOC', 'KRW', 'FCST_GAP', 'RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW', 'SCM_FCST', 'MKT_FCST')
    AND    NOT EXISTS (
               SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE X
               WHERE X.MEASURE = M.COLUMN_NAME
           );

                                                                                                                                                                                                                                         

                                                                                                           
                                                            
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE;

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;           

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT /*+ LEADING(A) USE_HASH(C) */                                           
                                                                                
                                                                          
                                                                                              
                                                                       
           A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;           

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST',  NO_INVALIDATE => FALSE);                                                                  
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                               
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C;
    DELETE FROM SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C;

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, VERSION_NO, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.VERSION_NO;
    END IF;           

    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO                        
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE
    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
         , MAX(A.CREATION_DATE) AS CREATE_DATE
         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
    FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
        ON  C.DIVISION_ID  = A.DIVISION_ID
        AND C.PROJECT_CODE = A.PROJECT_CODE
        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
        AND C.ITEM_ID      = A.ITEM_ID
    INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION V
        ON  V.VERSION_NO = A.VERSION_NO
    WHERE  A.DIVISION_ID = p_division_id
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    END IF;           

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_FCST_C',  NO_INVALIDATE => FALSE);                                                                  
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                           
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;

                                                                   
                            
                                                                   
    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%' THEN

                                               
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                 
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;           

                                        
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                 
             , A.YYYYMMDD
             , NVL(A.PRICE, 0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , '-' AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;                                                         
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT /*+ LEADING(A) USE_HASH(B) USE_HASH(C) */                             
                                                                  
                                                                           
                                                                               
                                                                      
               A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , '-' AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        WHERE  1 = 1
                                                                             
                                                                                   
                                                           
                                                        
        AND    EXISTS (SELECT 1
                       FROM   SCM_MGR.GT_DMF0082_T_WS_FCST D
                       WHERE  D.FCST_TYPE = A.FCST_TYPE)
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;                                                         
        END IF;           

                                           
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE                                                                                                                                                                  
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , A.CURRENCY
             , 'Current' AS VERSION_NO
             , NULL AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
                                                                                        
                                                                                                
                                                                                             
            ON  B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF;              

                                                                   
                       
                                                                   
    IF p_version_type LIKE '%MF%' THEN

                           
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                 
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , F.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.PROJECT_STATUS
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR
             , C.CELL_PER_MODULE
             , C.MODULE_PER_CAR
             , B.SORT_ORDER_NO
             , C.ENERGE
             , C.CELL_QUANTITY
             , A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE
             , '' AS SENDER_NAME
             , C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY
             , F.VERSION_NO
             , A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO = A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL) AS TOKEN
                    FROM   DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id, ',') + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;           

                                             
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-'            , A.YYYYMMDD, NVL(A.PRICE,0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO                        
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;                                                         
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0)
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'MF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;                                                         
        END IF;           

                                                
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'MF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF;         

                                                                   
                       
                                                                   
    IF p_version_type LIKE '%SF%' THEN

                              
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

                                                             
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE                                      , A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID, '-'            , A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , '' AS CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  A.MEASURE = 'MKT_FCST' AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0;
        END IF;           

                                                
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SF%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

                                                  
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE                                      , A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-'            , A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO                        
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F
            ON  F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SF%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        END IF;           

    END IF;         

                                                                                                           
                                           
                                                                                                           
    IF p_version_type LIKE '%SP%' THEN

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
                     
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE                                      , A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , '-'            , A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    A.CUTOFF_YYYYMMDD BETWEEN V_CUTOFF_FROM AND V_CUTOFF_TO                        
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        ELSE
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
                     
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID
             , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID, A.YYYYMMDD, NVL(A.PRICE,0), B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, '-' AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN SCM_MGR.GT_DMF0082_T_VERSION F ON F.VERSION_NO=A.VERSION_NO AND F.VERSION_NO LIKE 'SP%'
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
        AND    A.YYYYMMDD >= F.NOW_YYYYMMDD;
        END IF;           

                   
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL, C.NICK_NAME, C.DMS_SALES, C.DMS_CUSTOMER, C.OWNER
             , C.DEPT_ID, C.DEPT_NAME_KO, C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE, C.PROJECT_NAME, C.PROJECT_OWNER, C.BIZ_TYPE
             , C.SOLDTO_CUSTOMER, C.COUNTRY_NAME, C.CITY_NAME, C.PROJECT_STATUS
             , C.ITEM_NAME, C.VMI_YN, C.CUST_GROUP, C.CUST_GROUP_DTL
             , C.APPLICATION, C.ROUTE, C.MDM_PROJECT_NAME, C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE, C.CELL_TYPE, C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC, C.FORECAST_INFOR_VERSION, C.CELL_MODEL_NICK_NAME
             , C.CELL_PER_CAR, C.CELL_PER_MODULE, C.MODULE_PER_CAR, B.SORT_ORDER_NO
             , C.ENERGE, C.CELL_QUANTITY, A.ATTRIBUTE10 AS AS_FROM_SITE
             , LD.CREATE_DATE, LD.LAST_UPDATED_BY
             , '' AS SENDER_CODE, '' AS SENDER_NAME, C.PROJECT_S_OP_REPORT
             , A.CURRENCY, F.VERSION_NO, A.CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT_C A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B ON B.RESULT_MEASURE = A.MEASURE
        LEFT JOIN (                                                                                                                
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                     , MAX(CREATE_DATE) AS CREATE_DATE
                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST_C
                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            ) LD
                ON  LD.DIVISION_ID  = A.DIVISION_ID
                AND LD.PROJECT_CODE = A.PROJECT_CODE
                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
                AND LD.ITEM_ID      = A.ITEM_ID
                AND LD.DOM_EXP      = A.DOM_EXP
                AND LD.FCST_TYPE    = A.FCST_TYPE
                AND LD.INCOTERMS    = A.INCOTERMS
                AND LD.MEASURE      = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID=A.DIVISION_ID AND C.PROJECT_CODE=A.PROJECT_CODE
            AND C.SCM_SITE_ID=A.SCM_SITE_ID AND C.ITEM_ID=A.ITEM_ID AND C.ITEM_VALID_YN='Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D ON D.FCST_TYPE=A.FCST_TYPE
        INNER JOIN (SELECT * FROM SCM_MGR.GT_DMF0082_T_VERSION WHERE VERSION_NO LIKE 'SP%') F
            ON  A.VERSION_NO = F.SP_VERSION_NO
        WHERE  A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id='ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) FROM DUAL
                    CONNECT BY LEVEL<=REGEXP_COUNT(p_scm_site_id,',')+1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;

    END IF;         

                                                                                                           
                                   
                                                                                                           

                                                                                                           
                                                                                                        
    MERGE /*+ LEADING(B) USE_HASH(A) */ INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                                                                                                                        
    USING (
               SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID, MAX(CURRENCY) AS CURRENCY
               FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
               WHERE  MEASURE = 'LOC'
               AND    YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID
                    , INCOTERMS, DOM_EXP, FCST_TYPE, CELL_PROD_SITE_ID
           ) B
    ON (    A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID )
    WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
    WHERE  A.CURRENCY IS NULL
    AND    A.MEASURE NOT LIKE 'VMI%'
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                   
                                                                                                           

                                                                                   
                                                                              
    IF p_version_type LIKE '%Current%' OR p_version_type LIKE '%current%'
       OR p_version_type LIKE '%MF%' OR p_version_type LIKE '%SF%' THEN
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
                         
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , CASE D.MEASURE
               WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
               WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'   THEN A.QTY ELSE 0 END) <> 0
                                    THEN SUM(CASE WHEN A.MEASURE='MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                       / SUM(CASE WHEN A.MEASURE='RTF_SYS_RP'  THEN A.QTY ELSE 0 END)
                                    ELSE 0 END
           END AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , MAX(A.AS_FROM_SITE), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE IN ('LOC','KRW')
    WHERE  A.MEASURE IN ('RTF_SYS_RP','MKT_AMT_LOC','MKT_AMT_KRW')
    AND    A.YYYYMMDD >= p_from_yyyymmdd
    AND    A.YYYYMMDD < V_TO_RESULT
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD
    UNION ALL
                                     
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
         , SUM(CASE WHEN A.MEASURE='SCM_FCST' THEN A.QTY * -1 ELSE A.QTY END) AS QTY
         , MAX(D.MEASURE_GROUP)
         , MAX(A.CELL_MODEL), MAX(A.NICK_NAME), MAX(A.DMS_SALES), MAX(A.DMS_CUSTOMER)
         , MAX(A.OWNER), MAX(A.DEPT_ID), MAX(A.DEPT_NAME_KO)
         , MAX(A.FORECAST_INFO_CELL_PACK_COUNT), MAX(A.ITEM_TYPE)
         , MAX(A.PROJECT_NAME), MAX(A.PROJECT_OWNER), MAX(A.BIZ_TYPE)
         , MAX(A.SOLDTO_CUSTOMER), MAX(A.COUNTRY_NAME), MAX(A.CITY_NAME)
         , MAX(A.PROJECT_STATUS), MAX(A.ITEM_NAME), MAX(A.VMI_YN)
         , MAX(A.CUST_GROUP), MAX(A.CUST_GROUP_DTL), MAX(A.APPLICATION)
         , MAX(A.ROUTE), MAX(A.MDM_PROJECT_NAME), MAX(A.MIN_CAPACITY)
         , MAX(A.FORECAST_INFO_BIZ_TYPE), MAX(A.CELL_TYPE)
         , MAX(A.FORECAST_INFO_ALL), MAX(A.FORECAST_INFO_SPEC)
         , MAX(A.FORECAST_INFOR_VERSION), MAX(A.CELL_MODEL_NICK_NAME)
         , MAX(A.CELL_PER_CAR), MAX(A.CELL_PER_MODULE), MAX(A.MODULE_PER_CAR)
         , MAX(D.SORT_ORDER_NO), MAX(A.ENERGE), MAX(A.CELL_QUANTITY)
         , MAX(A.AS_FROM_SITE), MAX(A.CREATE_DATE), MAX(A.LAST_UPDATED_BY)
         , MAX(A.SENDER_CODE), MAX(A.SENDER_NAME), MAX(A.PROJECT_S_OP_REPORT)
         , MAX(A.CURRENCY), A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , 'INTEGER' AS NOTATION
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    JOIN   SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D ON D.MEASURE = 'FCST_GAP'
    WHERE  A.MEASURE IN ('MKT_FCST','SCM_FCST')
    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
           , A.CELL_PROD_SITE_ID, A.CURRENCY, A.YYYYMMDD, D.MEASURE
           , A.VERSION_NO, A.CUTOFF_YYYYMMDD;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_TEMP_FCST_N_PRICE', NO_INVALIDATE => FALSE);                                                                  
    END IF;

    IF p_version_type LIKE '%SP%' THEN

                                                                                 
                                                                     
                                                                                  
                                                        
                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
    SELECT A.DIVISION_ID
         , A.PROJECT_CODE
         , A.PROJECT_CODE AS END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.DOM_EXP
         , A.FCST_TYPE
         , A.INCOTERMS
         , D.MEASURE
         , A.PLANT_SITE_ID
         , A.CELL_PROD_SITE_ID
         , A.YYYYMMDD
         , CASE D.MEASURE
               WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END                                               
               WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END                                               
           END AS QTY
         , D.MEASURE_GROUP
         , A.CELL_MODEL, A.NICK_NAME, A.DMS_SALES, A.DMS_CUSTOMER, A.OWNER, A.DEPT_ID, A.DEPT_NAME_KO
         , A.FORECAST_INFO_CELL_PACK_COUNT, A.ITEM_TYPE, A.PROJECT_NAME, A.PROJECT_OWNER, A.BIZ_TYPE
         , A.SOLDTO_CUSTOMER, A.COUNTRY_NAME, A.CITY_NAME, A.PROJECT_STATUS, A.ITEM_NAME, A.VMI_YN
         , A.CUST_GROUP, A.CUST_GROUP_DTL, A.APPLICATION, A.ROUTE, A.MDM_PROJECT_NAME, A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE, A.CELL_TYPE, A.FORECAST_INFO_ALL, A.FORECAST_INFO_SPEC
         , A.FORECAST_INFOR_VERSION, A.CELL_MODEL_NICK_NAME, A.CELL_PER_CAR, A.CELL_PER_MODULE
         , A.MODULE_PER_CAR
         , D.SORT_ORDER_NO
         , A.ENERGE, A.CELL_QUANTITY
         , CASE D.MEASURE WHEN 'LOC' THEN B.AS_FROM_SITE    WHEN 'KRW' THEN C.AS_FROM_SITE    END AS AS_FROM_SITE
         , CASE D.MEASURE WHEN 'LOC' THEN B.CREATE_DATE     WHEN 'KRW' THEN C.CREATE_DATE     END AS CREATE_DATE
         , CASE D.MEASURE WHEN 'LOC' THEN B.LAST_UPDATED_BY WHEN 'KRW' THEN C.LAST_UPDATED_BY END AS LAST_UPDATED_BY
         , A.SENDER_CODE, A.SENDER_NAME, A.PROJECT_S_OP_REPORT
         , B.CURRENCY
         , A.VERSION_NO, A.CUTOFF_YYYYMMDD
         , CASE WHEN D.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
    FROM   ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , MAX(A.CELL_MODEL) AS CELL_MODEL
                     , MAX(A.NICK_NAME) AS NICK_NAME
                     , MAX(A.DMS_SALES) AS DMS_SALES
                     , MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
                     , MAX(A.OWNER) AS OWNER
                     , MAX(A.DEPT_ID) AS DEPT_ID
                     , MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
                     , MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                     , MAX(A.ITEM_TYPE) AS ITEM_TYPE
                     , MAX(A.PROJECT_NAME) AS PROJECT_NAME
                     , MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
                     , MAX(A.BIZ_TYPE) AS BIZ_TYPE
                     , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
                     , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
                     , MAX(A.CITY_NAME) AS CITY_NAME
                     , MAX(A.PROJECT_STATUS) AS PROJECT_STATUS
                     , MAX(A.ITEM_NAME) AS ITEM_NAME
                     , MAX(A.VMI_YN) AS VMI_YN
                     , MAX(A.CUST_GROUP) AS CUST_GROUP
                     , MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
                     , MAX(A.APPLICATION) AS APPLICATION
                     , MAX(A.ROUTE) AS ROUTE
                     , MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
                     , MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
                     , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
                     , MAX(A.CELL_TYPE) AS CELL_TYPE
                     , MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
                     , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
                     , MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
                     , MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
                     , MAX(A.CELL_PER_CAR) AS CELL_PER_CAR
                     , MAX(A.CELL_PER_MODULE) AS CELL_PER_MODULE
                     , MAX(A.MODULE_PER_CAR) AS MODULE_PER_CAR
                     , MAX(A.SORT_ORDER_NO) AS SORT_ORDER_NO
                     , MAX(A.ENERGE) AS ENERGE
                     , MAX(A.CELL_QUANTITY) AS CELL_QUANTITY
                     , MAX(A.AS_FROM_SITE) AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE) AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                     , MAX(A.SENDER_CODE) AS SENDER_CODE
                     , MAX(A.SENDER_NAME) AS SENDER_NAME
                     , MAX(A.PROJECT_S_OP_REPORT) AS PROJECT_S_OP_REPORT
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'RTF_SYS_RP'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) A
    LEFT JOIN ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , A.VERSION_NO
                     , A.CUTOFF_YYYYMMDD
                     , MAX(A.AS_FROM_SITE)    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_LOC'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD, A.VERSION_NO, A.CUTOFF_YYYYMMDD
              ) B
                ON (    A.DIVISION_ID       = B.DIVISION_ID
                    AND A.PROJECT_CODE      = B.PROJECT_CODE
                    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
                    AND A.ITEM_ID           = B.ITEM_ID
                    AND A.INCOTERMS         = B.INCOTERMS
                    AND A.DOM_EXP           = B.DOM_EXP
                    AND A.FCST_TYPE         = B.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD          = B.YYYYMMDD
                    AND A.VERSION_NO        = B.VERSION_NO
                    AND A.CUTOFF_YYYYMMDD   = B.CUTOFF_YYYYMMDD
                    AND A.QTY <> 0 )
    LEFT JOIN ( SELECT
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.CURRENCY, A.YYYYMMDD, SUM(A.QTY) AS QTY
                     , MAX(A.AS_FROM_SITE)    AS AS_FROM_SITE
                     , MAX(A.CREATE_DATE)     AS CREATE_DATE
                     , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
                FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
                WHERE  A.YYYYMMDD >= p_from_yyyymmdd
                AND    A.YYYYMMDD <  V_TO_RESULT
                AND    A.MEASURE = 'MKT_AMT_KRW'
                GROUP BY
                       A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                     , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
                     , A.CELL_PROD_SITE_ID
                     , A.MEASURE, A.CURRENCY, A.YYYYMMDD
              ) C
                ON (    A.DIVISION_ID       = C.DIVISION_ID
                    AND A.PROJECT_CODE      = C.PROJECT_CODE
                    AND A.SCM_SITE_ID       = C.SCM_SITE_ID
                    AND A.PLANT_SITE_ID     = C.PLANT_SITE_ID
                    AND A.ITEM_ID           = C.ITEM_ID
                    AND A.INCOTERMS         = C.INCOTERMS
                    AND A.DOM_EXP           = C.DOM_EXP
                    AND A.FCST_TYPE         = C.FCST_TYPE
                    AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
                    AND A.YYYYMMDD          = C.YYYYMMDD
                    AND A.QTY <> 0 )
    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE D
                ON  D.MEASURE IN ('LOC', 'KRW')
    WHERE  (CASE D.MEASURE
                WHEN 'LOC' THEN CASE WHEN A.QTY <> 0 THEN B.QTY / A.QTY ELSE 0 END
                WHEN 'KRW' THEN CASE WHEN A.QTY <> 0 THEN C.QTY / A.QTY ELSE 0 END
            END) IS NOT NULL;

    END IF;

                                                                                                           
                                                 
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
        WHERE  B.MEASURE  = A.MEASURE
        AND    B.USER_ID  = 'DM_ADMIN'
    );

                                                                                                           
                                          
                                                                                                           

    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE QTY = 0;
    END IF;

                                                                                                           
                                                                                
                                                                                             
                                                                                                           

    IF p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  PLANT_SITE_ID NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id'));
    END IF;

                                                                                                           
                                                                                                   
                                                                                                           

    IF p_project_code IS NOT NULL AND p_project_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(PROJECT_CODE, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_project_code'));
    END IF;

    IF p_owner IS NOT NULL AND p_owner <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(OWNER, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_owner'));
    END IF;

                                                                                        
    IF p_sender_code IS NOT NULL AND p_sender_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(SENDER_CODE, ' ') <> ' '
        AND    SENDER_CODE NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_sender_code'));
    END IF;

                                                                                                           
                                                                               
                                                                     
                                                                                                           

    IF p_team_id IS NOT NULL AND p_team_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        WHERE  NVL(DEPT_ID, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_team_id'));



    END IF;

                                                                                  
                                           
                                                                     
                                                        
                                                                          
                                                     
                                                           
                                                                         
                                                               
        UPDATE SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
           SET PLANT_SITE_ID = '-'
         WHERE PLANT_SITE_ID IS NULL
            OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IS NULL
            OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), '')) IN ('-', '--');

                                                                     
                              
                                                                      
                                           
                                                              
        DELETE FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
         WHERE ROWID IN (SELECT RID
                     FROM  (SELECT ROWID AS RID,
                                   ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, MEASURE_GROUP, CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO, FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE, SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN, CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE, CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION
                                                      ORDER BY QTY DESC NULLS LAST, ROWID) AS RN
                            FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE)
                     WHERE RN > 1);


                                                                                                           
                               
                                                                                                           

    V_COLUMN  := '';
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;
        IF V_COLUMN IS NULL THEN
            V_COLUMN  := V_CUR_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, ' || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN V_CUR_COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || V_CUR_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' || V_CUR_COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;
    CLOSE C_TITLE;

                                       
                                                                      
    V_COLUMN  := CASE WHEN V_COLUMN  IS NULL THEN 'NOTATION'              ELSE V_COLUMN  || ', NOTATION' END;
    V_GROUPBY := CASE WHEN V_GROUPBY IS NULL THEN ' GROUP BY EDIT_FLAG, SORT_ORDER_NO' ELSE V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO' END;
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');

                                                                                                           
               
                                                                                                           

    V_GROUP_ID := '';

    DECLARE
        V_ADMIN_CNT NUMBER;
    BEGIN
        SELECT COUNT(1) INTO V_ADMIN_CNT
        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN    = 'Y'
        AND (SEGMENT1 = p_user_group                                               
             OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
        AND    SEGMENT2    = 'ALL';

        IF V_ADMIN_CNT > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
    END;

                                                                                                           
                                               
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE;

                                                                          
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE (MEASURE, GROUP_MEASURE)
    SELECT A.SEGMENT4 AS MEASURE
         , A.SEGMENT1 AS GROUP_MEASURE
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND (A.SEGMENT1 = p_user_group                                               
             OR A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
    AND    A.SEGMENT2    = VA_PROGRAM_ID
    AND    A.SEGMENT3    = p_division_id;

                                                                                                                                                                                                                                             

                                                                                                           
                                             
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE;

                                                            
    INSERT INTO SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE (MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST)
    SELECT A.SEGMENT4 AS MEASURE
         , CASE WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.GT_DMF0082_TEMP_INTO_GROUP_MEASURE B
                    WHERE  B.MEASURE = A.SEGMENT4
               ) THEN 'Y' ELSE 'N' END AS EDIT_AUTH_YN
         , CASE WHEN A.ATTRIBUTE1 IS NOT NULL THEN 'Y' ELSE 'N' END AS TODAY_LIMIT_YN
         , A.ATTRIBUTE1 AS TODAY_DAY_LIST
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT2    = VA_PROGRAM_ID
    GROUP BY A.SEGMENT4, A.ATTRIBUTE1;

                                                                                                                                                                                                                                              

                                                                                                           
                                             
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE;
    DELETE FROM SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE;

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_MONTH_END_DATE (BASIS_YYYYMM, MONTH_END_DATE, M3_CUTOFF_DATE)
    SELECT A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.BASIS_YYYYMM;

    INSERT INTO SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE (ISO_WEEK, BASIS_YYYYMM, WEEK_END_DATE, M3_CUTOFF_DATE)
    SELECT A.ISO_WEEK
         , A.BASIS_YYYYMM
         , MAX(A.BASIS_YYYYMMDD) AS WEEK_END_DATE
         , TO_CHAR(ADD_MONTHS(TO_DATE(MIN(A.BASIS_YYYYMMDD),'YYYYMMDD'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
    WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY A.ISO_WEEK, A.BASIS_YYYYMM;

                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                        

                                                                                                           
                                    
                                                                                          
                                                                                         
                                                                                                           

    DELETE FROM SCM_MGR.GT_DMF0082_MF_SP;

    INSERT                                                                                 INTO SCM_MGR.GT_DMF0082_MF_SP
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, BUCKET_TYPE, BUCKET_KEY, QTY, MEASURE_GROUP
    , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
    , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
    , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
    , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
    , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
    , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION, EDIT_FLAG, SORT_KEY, GROUP_ID
    , SUN, MON, TUE, WED, THU, FRI, SAT
    , YYYYMM, YYYYMMWW, WEEK_END_YN, MONTH_END_YN
    , NEW_FLAG, AS_YN)                                                                
    SELECT F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
         , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
         , F.CELL_PROD_SITE_ID
         , CAL.BUCKET_TYPE
         , CAL.BUCKET_KEY
         , SUM(F.QTY) AS QTY
         , MAX(F.MEASURE_GROUP)
         , MAX(F.CELL_MODEL), MAX(F.NICK_NAME), MAX(F.DMS_SALES), MAX(F.DMS_CUSTOMER)
         , MAX(F.OWNER), MAX(F.DEPT_ID), MAX(F.DEPT_NAME_KO)
         , MAX(F.FORECAST_INFO_CELL_PACK_COUNT), MAX(F.ITEM_TYPE)
         , MAX(F.PROJECT_NAME), MAX(F.PROJECT_OWNER), MAX(F.BIZ_TYPE)
         , MAX(F.SOLDTO_CUSTOMER), MAX(F.COUNTRY_NAME), MAX(F.CITY_NAME)
         , MAX(F.PROJECT_STATUS), MAX(F.ITEM_NAME), MAX(F.VMI_YN)
         , MAX(F.CUST_GROUP), MAX(F.CUST_GROUP_DTL), MAX(F.APPLICATION)
         , MAX(F.ROUTE), MAX(F.MDM_PROJECT_NAME), MAX(F.MIN_CAPACITY)
         , MAX(F.FORECAST_INFO_BIZ_TYPE), MAX(F.CELL_TYPE)
         , MAX(F.FORECAST_INFO_ALL), MAX(F.FORECAST_INFO_SPEC)
         , MAX(F.FORECAST_INFOR_VERSION), MAX(F.CELL_MODEL_NICK_NAME)
         , MAX(F.CELL_PER_CAR), MAX(F.CELL_PER_MODULE), MAX(F.MODULE_PER_CAR)
         , MAX(F.SORT_ORDER_NO), MAX(F.ENERGE), MAX(F.CELL_QUANTITY)
         , MAX(F.AS_FROM_SITE), MAX(F.CREATE_DATE), MAX(F.LAST_UPDATED_BY)
         , MAX(F.SENDER_CODE), MAX(F.SENDER_NAME), MAX(F.PROJECT_S_OP_REPORT)
         , MAX(F.CURRENCY), MAX(F.VERSION_NO), MAX(F.CUTOFF_YYYYMMDD)
         , MAX(F.NOTATION)
                                                   
         , CASE WHEN V_GROUP_ID = 'ADMIN' THEN 'Y'
                WHEN EXISTS (
                    SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE MA
                    WHERE  MA.MEASURE = F.MEASURE
                    AND    MA.EDIT_AUTH_YN = 'Y'
                    AND   (MA.TODAY_LIMIT_YN = 'N'
                           OR (MA.TODAY_LIMIT_YN = 'Y'
                               AND INSTR(
                                       REPLACE(TRIM(MA.TODAY_DAY_LIST),' ',''),
                                       CASE TO_NUMBER(TO_CHAR(SYSDATE,'D'))
                                           WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON'
                                           WHEN 3 THEN 'TUE' WHEN 4 THEN 'WED'
                                           WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                                           WHEN 7 THEN 'SAT'
                                       END) > 0))
                ) THEN 'Y'
                ELSE 'N'
           END AS EDIT_FLAG
                                                                
                                                                                      
                                                                           
         , 999 AS SORT_KEY
                                                                       
         , NULL AS GROUP_ID
                                       
         , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
                                                                              
         , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN
                                                                           
                                                                                    
         , MAX('N') AS NEW_FLAG
         , MAX(CASE WHEN p_scm_site_id IS NULL OR p_scm_site_id = 'ALL' THEN 'N'
                    WHEN EXISTS (SELECT 1 FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') SA
                                 JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                   ON SA.TOKEN = SB.SEGMENT1 AND SB.LOOKUP_TYPE = 'AS_SITE_PLANT')
                    THEN 'Y' ELSE 'N' END) AS AS_YN
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    INNER JOIN (
                                     
        SELECT D.BASIS_YYYYMMDD
             , D.BASIS_YYYYMM || D.ISO_WEEK AS WEEK_KEY
             , CASE WHEN D.BASIS_YYYYMM || D.ISO_WEEK = WE.ISO_WEEK || WE.BASIS_YYYYMM
                    THEN WE.WEEK_END_DATE ELSE D.BASIS_YYYYMMDD END AS BUCKET_TYPE_KEY
             , TO_CHAR(D.BASIS_YYYYMMDD) AS BUCKET_KEY
             , 'D' AS BUCKET_TYPE
                                                                                                    
                                                                               
             , D.BASIS_YYYYMM AS YYYYMM
             , D.BASIS_YYYYMM || LPAD(TRIM(D.ISO_WEEK), 2, '0') AS YYYYMMWW
             , CASE WHEN WE2.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
             , CASE WHEN ME.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M D
        LEFT JOIN SCM_MGR.GT_DMF0082_CAL_WEEK_END_DATE WE
            ON  WE.ISO_WEEK     = D.ISO_WEEK
            AND WE.BASIS_YYYYMM = D.BASIS_YYYYMM
                                                                
        LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
                   FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                   WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
                   GROUP BY BASIS_YYYYMM, ISO_WEEK) WE2
            ON  WE2.WEEK_END_DATE = D.BASIS_YYYYMMDD
                                                         
        LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
                   FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                   WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
                   GROUP BY BASIS_YYYYMM) ME
            ON  ME.MONTH_END_DATE = D.BASIS_YYYYMMDD
        WHERE  D.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND V_EXP_YYYYMMDD
    ) CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD
                                                                                  
                                                                                         
                                                                       
    LEFT JOIN (
        SELECT BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
             , MAX(CASE WHEN BC.YYYYMMDD = 'SUN' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SUN
             , MAX(CASE WHEN BC.YYYYMMDD = 'MON' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS MON
             , MAX(CASE WHEN BC.YYYYMMDD = 'TUE' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS TUE
             , MAX(CASE WHEN BC.YYYYMMDD = 'WED' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS WED
             , MAX(CASE WHEN BC.YYYYMMDD = 'THU' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS THU
             , MAX(CASE WHEN BC.YYYYMMDD = 'FRI' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS FRI
             , MAX(CASE WHEN BC.YYYYMMDD = 'SAT' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SAT
        FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
        GROUP BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
    ) PVT ON  PVT.DIVISION_ID = F.DIVISION_ID
          AND PVT.SCM_SITE_ID = F.SCM_SITE_ID
          AND PVT.INCOTERMS   = F.INCOTERMS
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
           , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN;

                                                                                   
                                                                            
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_DMF0082_MF_SP', NO_INVALIDATE => FALSE);                                                                  

                                                                                                           
                                                                                             
                                                                                                 
                                                                                          
                                                                                                                     
                                                                                                          
                                                                                                           

                                                                             
                                                          

                                                                          
    NULL;

    IF p_division_id = '40' THEN
                                                                                                            
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/'
                       || CASE
                              WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                               AND A.QTY >
                                   CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                                 + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                              THEN 'P'
                              ELSE 'A'
                          END AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, A.FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_MKT_FCST A
                WHERE  A.DIVISION_ID = p_division_id
                  AND  A.MEASURE     = 'MKT_FCST'
                  AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                  AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL )
                  AND  A.QTY <> 0
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            )
        ) S
        ON (    T.DIVISION_ID  = S.DIVISION_ID
            AND T.PROJECT_CODE = S.PROJECT_CODE
            AND T.SCM_SITE_ID  = S.SCM_SITE_ID
            AND T.ITEM_ID      = S.ITEM_ID
            AND T.DOM_EXP      = S.DOM_EXP
            AND T.FCST_TYPE    = S.FCST_TYPE
            AND T.INCOTERMS    = S.INCOTERMS)
        WHEN MATCHED THEN UPDATE SET T.ATTR1 = S.ATTR1;

    ELSIF p_division_id = '82' THEN
                                                                                             
        MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T
        USING (
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                DOM_EXP, FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/A' AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_PR_DETAIL A
                WHERE  A.DIVISION_ID = p_division_id
                  AND  A.YYYYMMDD   BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            )
        ) S
        ON (    T.DIVISION_ID  = S.DIVISION_ID
            AND T.PROJECT_CODE = S.PROJECT_CODE
            AND T.SCM_SITE_ID  = S.SCM_SITE_ID
            AND T.ITEM_ID      = S.ITEM_ID
            AND T.DOM_EXP      = S.DOM_EXP
            AND T.FCST_TYPE    = S.FCST_TYPE
            AND T.INCOTERMS    = S.INCOTERMS)
        WHEN MATCHED THEN UPDATE SET T.ATTR1 = S.ATTR1;

                                                                                                                 
        UPDATE SCM_MGR.GT_DMF0082_MF_SP T
        SET    T.VMI_STD_DIO = (
                   SELECT MAX(A.VMI_YN || '^' || NVL(TO_CHAR(A.ATTRIBUTE5),''))
                   FROM   SCM_MGR.SCM_MST_SITE A
                   WHERE  A.DIVISION_ID = '82'
                   AND    A.SCM_SITE_ID = T.SCM_SITE_ID);
    END IF;

                                                                         
    IF p_division_id = '82' THEN
        UPDATE SCM_MGR.GT_DMF0082_MF_SP SET EDIT_FLAG = 'N';
    END IF;

                                                                                                           
                                                                           
                                                                         
                                                                                                           
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM);     EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS MESSAGE, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

                                                                                                           
                                        
                                                                                                           

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

                                                                                                           
                                                                
                                                                         
                                                                                 
                                                                                       
                                                                                             
                                                                             
                                                       
                                                                                                           
    V_SQL := '
    SELECT [@V_COLUMN]
    , ([@V_QTY_SUM]) AS QTY
    , [@V_PV_COL_LIST]
    FROM (
        SELECT [@V_COLUMN], SORT_ORDER_NO, ''D_'' || BUCKET_KEY AS PIVOT_BUCKET, QTY
        FROM ( [@SRC0] ) F
        WHERE ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''W_'' || YYYYMMWW AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')
                    THEN CASE WHEN WEEK_END_YN = ''Y'' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE NOT IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMMWW, WEEK_END_YN, MEASURE

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''W_'' || YYYYMMWW AS PIVOT_BUCKET, AVG(QTY) AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMMWW

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''M_'' || YYYYMM AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN (''BALANCE'',''VMI_Inv'',''AS_Inv'')
                    THEN CASE WHEN MONTH_END_YN = ''Y'' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE NOT IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMM, MONTH_END_YN, MEASURE

        UNION ALL

        SELECT [@V_COLUMN], SORT_ORDER_NO, ''M_'' || YYYYMM AS PIVOT_BUCKET, AVG(QTY) AS QTY
        FROM ( [@SRC0] ) F
        WHERE MEASURE IN (''KRW'',''USD'',''LOC'')
        AND ((MEASURE NOT IN (''SCM_FCST'',''FCST_GAP'') AND QTY <> 0) OR MEASURE IN (''SCM_FCST'',''FCST_GAP''))
        [@V_GROUPBY], NOTATION, YYYYMM
    ) SRC
    PIVOT (SUM(QTY) FOR PIVOT_BUCKET IN ( [@V_PV_LIST] ))
    [@V_ORDERBY]';

                                                                                                       
    V_SQL := REPLACE(V_SQL, '[@SRC0]', 'SELECT MSP.*, MSP.DEPT_ID AS TEAM_ID, MSP.DEPT_NAME_KO AS TEAM_NAME_KO /*[UICATEGORY 2026-08-07]*/, MSP.CELL_MODEL AS FORECAST_INFO_CELL_MODEL, NVL(TO_CHAR(MSP.CREATE_DATE, ''YYYY-MM-DD HH24:MI:SS''), '' '') AS LAST_UPDATE_DATE, NVL(TO_CHAR(MSP.SUN),''0'')||NVL(TO_CHAR(MSP.MON),''0'')||NVL(TO_CHAR(MSP.TUE),''0'')||NVL(TO_CHAR(MSP.WED),''0'')||NVL(TO_CHAR(MSP.THU),''0'')||NVL(TO_CHAR(MSP.FRI),''0'')||NVL(TO_CHAR(MSP.SAT),''0'') AS BUCKET FROM SCM_MGR.GT_DMF0082_MF_SP MSP');
    V_SQL := REPLACE(V_SQL, '[@V_QTY_SUM]',     V_QTY_SUM);
    V_SQL := REPLACE(V_SQL, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
    V_SQL := REPLACE(V_SQL, '[@V_PV_LIST]',     V_PV_LIST);
    V_SQL := REPLACE(V_SQL, '[@V_GROUPBY]',     V_GROUPBY);
    V_SQL := REPLACE(V_SQL, '[@V_COLUMN]',      V_COLUMN);
    V_SQL := REPLACE(V_SQL, '[@V_ORDERBY]',     V_ORDERBY);

    OPEN O_RC1 FOR V_SQL;

    DBMS_LOB.FREETEMPORARY(V_SQL);
    DBMS_LOB.FREETEMPORARY(V_PV_LIST);
    DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST);
    DBMS_LOB.FREETEMPORARY(V_QTY_SUM);

                                                                                                           
                                           
                                                                                                           

    OPEN O_RC2 FOR
        SELECT A.BASIS_YYYYMM
             , MAX(A.BASIS_YYYYMMDD) AS MONTH_END_DATE
             , TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(MIN(A.BASIS_YYYYMMDD), 'YYYYMMDD'), 'MM'), 3), 'YYYYMMDD') AS M3_CUTOFF_DATE
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY A.BASIS_YYYYMM;

                                                                                                           
                                     
                                                                                                           

    OPEN O_RC3 FOR
        SELECT TO_CHAR(SYSDATE, 'YYYYMMDD') AS TODAY_DATE
             , CASE TO_NUMBER(TO_CHAR(SYSDATE, 'D'))
                   WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON' WHEN 3 THEN 'TUE'
                   WHEN 4 THEN 'WED' WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                   WHEN 7 THEN 'SAT'
               END AS TODAY_DAY
             , SUBSTR(REPLACE(TO_CHAR(SYSDATE, 'HH24:MI:SS'), ':', ''), 1, 4) AS TODAY_TIME
        FROM   DUAL;

                                                                                                           
                                                   
                                                                                                           

    OPEN O_RC4 FOR
        SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST
        FROM   SCM_MGR.GT_DMF0082_TEMP_ADMIN_GROUP_MEASURE
        ORDER BY MEASURE;

                                                                                                           
                                                  
                                                                                                           

                                                 
    OPEN O_RC5 FOR
        SELECT A.BASIS_YYYYMMDD
             , A.BASIS_YYYYMM
             , CASE WHEN SUBSTR(A.BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(A.BASIS_START_DATE,'YYYYMMDD')+7,'YYYYMMDD'),1,6)
                         = SUBSTR(A.BASIS_START_DATE,1,6)
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG
             , COUNT(*) OVER (PARTITION BY A.BASIS_YYYYMM) AS MONTH_DAY_CNT
             , COUNT(*) OVER (PARTITION BY A.ISO_WEEK) AS WEEK_DAY_CNT
             , A.ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY A.BASIS_YYYYMMDD;

                                                                                                                                                                        
                                             
                                                                                                                                                                        
                                        
                                        
                                           
                                           
                              
                              
                                                                                                                         
                                                                                                                       
                         
                                                                                
                                                    
                    
                          
                                                    
                      
                                   
                                   
                                   
                              
                                   
                                   
                                                                        
                                                                                       
                                                                                     
                                                          
                                              
                                                                                             
                                                                               
                                                                                                                      
                                                                                                        
                                                         
                                                       
                                           
                                                                                                                                             
                                        
                                            
                                      
                                  
                                                                                                             
                                                                                                                                 
                                                                                                                                 
                                                                                                                                  
                                                                          
                                                                              
                                                                           
                                                                               
                                                                                                      
                                                                                                      
                                                                                   
                                  
                          
                          
                                          
                         
                     
                     
                       
                       
                           
                                    
                      
                 
                           
                        
                       
                       
                          
                     
                     
                          
                                           
                       
                          
                           
                      
                             
                          
                       
                            
                       
                    
                        
                            
                           
                     
                              
                          
                                    
                       
                                                                                                                                         
                                                            
                                               
                                                     
                                                 
                                                                                                               
                                                                                                                   
                                                                                                                                                                        

                                                                                                           
                             
                                                                                                           

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG FROM DUAL;

    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, 'I', 0, '정상종료', 'P_DMF0082_GET_MAIN_DATA END',
            SYSDATE, V_PROC_INPUT, NULL, NULL, NULL
        );
    END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_QTY_SUM); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'E', 0
              , 'ERROR: ' || V_SQL_ERRMSG
              , 'P_DMF0082_GET_MAIN_DATA ERROR'
              , SYSDATE
              , V_PROC_INPUT
              , V_SQL_CODE
              , V_SQL_ERRMSG
              , V_BACKTRACE
            );
        END;
        RAISE_APPLICATION_ERROR(-20001, '['|| $$PLSQL_UNIT ||'] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_MAIN_DATA;


PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO
(
    P_START_YYYYMMDD   IN  VARCHAR2,
    P_END_YYYYMMDD     IN  VARCHAR2,
    P_USER_ID          IN VARCHAR2,              
    P_MNU_ID           IN VARCHAR2,              
    O_RC1              OUT SYS_REFCURSOR,
    O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
AS
  
                                              
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                     
                                                               
   
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT YYYYMMDD,
               SUBSTR(YYYYMMDD, 1, 6) AS YYYYMM,
               t1.DIVISION_ID,
               CURRENCY,
               UNIT_CURRENCY,
               EXCHANGE_PRICE,
               NVL(T2.EDIT_YN,'N') AS EDIT_YN
          FROM SCM_MGR.DM_MST_EXCHANGE_RATE t1
              LEFT JOIN (SELECT *                                                                                     
                FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                WHERE USER_ID = P_USER_ID
                AND MNU_ID = P_MNU_ID
                AND UNIT_TP_CD = 'D') T2
                ON T1.DIVISION_ID = T2.UNIT_ID
                     WHERE YYYYMMDD >= P_START_YYYYMMDD
                       AND YYYYMMDD <= P_END_YYYYMMDD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
                             'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                             'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                             'P_USER_ID'        VALUE P_USER_ID,
                             'P_MNU_ID'         VALUE P_MNU_ID
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_FUTUREPRICE_INFO;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO
(
    P_USER_ID         IN VARCHAR2,              
    P_MNU_ID          IN VARCHAR2,              
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
  
                                               
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                     
   
IS
               
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

                         
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
                                              
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT
                                       
                                       
     CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS LOOKUP_CODE
    ,CASE WHEN COLUMN_NAME = 'RTF_SYS_RP' THEN 'RTF' ELSE COLUMN_NAME END AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    ,SORT_ORDER_NO AS DISPLAY_SEQ
    ,NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
        LEFT JOIN (SELECT *                                                                                     
         FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
         WHERE USER_ID = P_USER_ID
         AND MNU_ID = P_MNU_ID
         AND UNIT_TP_CD = 'D') T2
         ON T2.UNIT_ID in (
             SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
             FROM   DUAL
             CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
     )
    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice'                                                    
    AND VALID_YN = 'Y'
    AND COLUMN_NAME IN ('RTF_SYS_RP','KRW','USD','LOC')
    ORDER BY SORT_ORDER_NO;
      
                                                                                    
                                     
                        
                         
                                     
             
                                                                                    
                                     
                        
                        
                                     
                        
      

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO;


PROCEDURE P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE
(
    P_USER_ID         IN VARCHAR2,              
    P_MNU_ID          IN VARCHAR2,              
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
  
                                               
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                     
                                                               
   
IS
               
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

                         
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
                                              
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT DISTINCT
                                      
                                       
    COLUMN_NAME AS LOOKUP_CODE
    ,COLUMN_NAME AS DESCRIPTION
    , 99 AS DISPLAY_ALL
    , NVL(T2.EDIT_YN,'N') AS EDIT_YN
    FROM  SCM_MGR.SCM_MST_SHEET_MEASURE T1
        LEFT JOIN (SELECT *                                                                                     
     FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
     WHERE USER_ID = P_USER_ID
     AND MNU_ID = P_MNU_ID
     AND UNIT_TP_CD = 'D') T2
     ON T2.UNIT_ID in (
         SELECT TRIM(REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL))
         FROM   DUAL
         CONNECT BY REGEXP_SUBSTR(T1.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
         )

    WHERE  PROGRAM_ID = 'DMF0082'
    AND SHEET_NAME = 'FcstNPrice'                                                    
    AND VALID_YN = 'Y'
    AND COLUMN_NAME = 'LOC';
                                                                            
                                         
                            
                             
                                         
                 
      
                                                                         
                                      
                         
                         
                                      
     

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
      	V_PROC_INPUT  := JSON_OBJECT(
            'P_USER_ID'   VALUE P_USER_ID,
            'P_MNU_ID'   VALUE P_MNU_ID
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
END P_DMF0082_POPUP_GET_MEASURE_COUNTINFO_SAVE_PRICE;


PROCEDURE P_DMF0082_POPUP_GET_WEEKDATA
(
    P_YYYYMMDD          IN  VARCHAR2,
    O_RC1               OUT SYS_REFCURSOR,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
  
                                      
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                     
                                                               
   
IS
               
    V_PROGRAM_NAME      VARCHAR2(200 CHAR);
    V_LOG_TYPE          VARCHAR2(100 CHAR);
    N_LOG_COUNT         PLS_INTEGER := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE := SYSDATE;

                         
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100 CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
BEGIN
                                              
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
    SELECT BASIS_START_DATE, BASIS_YYYYMMDD
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD <= P_YYYYMMDD
    ORDER BY BASIS_YYYYMMDD DESC
    FETCH FIRST 7 ROWS ONLY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_YYYYMMDD' VALUE P_YYYYMMDD
        );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_WEEKDATA;


PROCEDURE P_DMF0082_EXCEL_UPLOAD 
(
    p_mode           IN  NUMBER
  , p_created_by     IN  VARCHAR2
  , p_program_id     IN  VARCHAR2 DEFAULT 'DMF0082'                                                                           
  , p_sheet_name     IN  VARCHAR2 DEFAULT 'FcstNPrice'
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR                                                
)
  
                                        
                                        
                  
                                                                                                    
                                            
                                                                                                    
                                              
                                                                                                     
                                                                                                    
                       
                                                                                       
                                                                                   
                                                                                                                  
                                                          
                                            
                                                                                              
                                                                    
                                                                                      
                                                                                                
                                                                                      
                                                                                                               
                                                                       
                                                                                                  
                                                                                                    
                                                                                                                                    
                                                
                                                                      
                                                         
                                                                                        
                                                                                    
   
                                             
IS
    v_program_id      VARCHAR2(40 CHAR)  := NVL(p_program_id, 'DMF0082');                   
    v_sheet_name      VARCHAR2(40 CHAR)  := NVL(p_sheet_name, 'FcstNPrice');
    v_creation_date   VARCHAR2(40 CHAR);
    v_count           NUMBER;
    v_start_yyyymmdd  VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');                                                  
    v_end_yyyymmdd    VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 12), 'YYYYMM');                                                 
    v_division        VARCHAR2(10 CHAR);

                  
    v_log_type        VARCHAR2(30 CHAR);                         
    n_log_count       NUMBER := 0;
    v_log_message     VARCHAR2(1000 CHAR);
    v_description     VARCHAR2(500 CHAR);
    d_event_date      DATE;

             
    n_row_cnt         NUMBER := 0;
    n_success_cnt     NUMBER := 0;
    n_error_cnt       NUMBER := 0;
                                        
    v_rc_a           SYS_REFCURSOR;
    v_rc_b           SYS_REFCURSOR;
    v_rc_c           SYS_REFCURSOR;
    v_rc_save        SYS_REFCURSOR;
    v_save_code      VARCHAR2(10  CHAR);
    v_save_msg       VARCHAR2(4000 CHAR);
    v_save_event     VARCHAR2(400 CHAR);
    n_save_cnt       PLS_INTEGER := 0;

               
    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(20 CHAR);
    V_SQL_ERRMSG      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
BEGIN

  
                   
                  
                 
                                               
                      
                                                  
                       
                     
  

    V_PROC_INPUT := JSON_OBJECT('p_mode' VALUE p_mode, 'p_created_by' VALUE p_created_by);

    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by
    AND    T.UPLOAD_STATUS_CODE = 'UPLOAD';

    IF v_creation_date IS NULL THEN
        v_log_type    := 'END';
        v_log_message := '########## END of procedure ##########';
        v_description := 'Data Not Found [' || NVL(SUBSTR(v_creation_date, 1, 19), '') || ']';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;
    END IF;

                                                   
    BEGIN
        SELECT ATTRIBUTE1
        INTO   v_division
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    ATTRIBUTE1 != 'Div'
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

                                
    IF NVL(p_mode, 0) = 0 THEN

        DBMS_OUTPUT.PUT_LINE(v_division);                                 

                                                                                
                                
                                                                                
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
        SET    T.UPLOAD_STATUS_CODE = 'UPLOAD'
             , T.MESSAGE_TEXT       = NULL
        WHERE  T.PROGRAM_ID = v_program_id
        AND    T.SHEET_NAME = v_sheet_name
        AND    T.CREATED_BY = p_created_by
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;
                                                          

                                                                                
                                                                        
                                                                                
        v_log_type    := '1';
        v_log_message := '########## RESET Status = UPLOAD ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                                
                             
                                                                                
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = '@TITLE'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPPER(ATTRIBUTE1) = 'DIV';

                                                                                
                                                                        
                                                                                
        v_log_type    := '2';
        v_log_message := '########## TITLE Header Line ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                           

                                                               
                       
                        
                                 
                               
                          
                              
                              
                                     
                                   
                             
                            
                                                                
                                                                
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = CASE WHEN ATTRIBUTE1  IS NULL THEN 'NULL Div'
                                         WHEN ATTRIBUTE2  IS NULL THEN 'NULL End Customer'
                                         WHEN ATTRIBUTE3  IS NULL THEN 'NULL Sales Site'
                                         WHEN ATTRIBUTE4  IS NULL THEN 'NULL Model'
                                         WHEN ATTRIBUTE5  IS NULL THEN 'NULL Incoterms'
                                         WHEN ATTRIBUTE6  IS NULL THEN 'NULL FCST Type'
                                         WHEN ATTRIBUTE7  IS NULL THEN 'NULL Customs Handbook'
                                         WHEN ATTRIBUTE8  IS NULL THEN 'NULL Cell Prod Site'
                                         WHEN (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL) THEN 'NULL Currency'                                   
                                         WHEN ATTRIBUTE10 IS NULL THEN 'NULL Measure'
                                    END
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (   ATTRIBUTE1  IS NULL
                OR ATTRIBUTE2  IS NULL
                OR ATTRIBUTE3  IS NULL
                OR ATTRIBUTE4  IS NULL
                OR ATTRIBUTE5  IS NULL
                OR ATTRIBUTE6  IS NULL
                OR ATTRIBUTE7  IS NULL
                OR ATTRIBUTE8  IS NULL
                OR (ATTRIBUTE10 = 'Unit Price(LOC)' AND ATTRIBUTE9 IS NULL)
                OR ATTRIBUTE10 IS NULL
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## ERROR NULL Column Data ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                               
                   
                                                      
                                                                                
                                                               
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Duplication Model.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    EXISTS (SELECT 1
                       FROM  (                                     
                              SELECT X.ATTRIBUTE1           AS COL1        
                                   , X.ATTRIBUTE2           AS COL2                 
                                   , X.ATTRIBUTE3           AS COL3               
                                   , X.ATTRIBUTE4           AS COL4           
                                   , X.ATTRIBUTE5           AS COL5              
                                   , X.ATTRIBUTE6           AS COL6              
                                   , X.ATTRIBUTE7           AS COL7                     
                                   , X.ATTRIBUTE8           AS COL8                   
                                   , NVL(X.ATTRIBUTE9, '-') AS COL9             
                                   , X.ATTRIBUTE10          AS COL10           
                              FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD X
                              WHERE  X.PROGRAM_ID = v_program_id
                              AND    X.SHEET_NAME = v_sheet_name
                              AND    X.CREATED_BY = p_created_by
                              AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
                              AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                              GROUP BY X.ATTRIBUTE1
                                     , X.ATTRIBUTE2
                                     , X.ATTRIBUTE3
                                     , X.ATTRIBUTE4
                                     , X.ATTRIBUTE5
                                     , X.ATTRIBUTE6
                                     , X.ATTRIBUTE7
                                     , X.ATTRIBUTE8
                                     , NVL(X.ATTRIBUTE9, '-')
                                     , X.ATTRIBUTE10
                              HAVING COUNT(*) > 1
                             ) T
                       WHERE 1 = 1
                       AND   T.COL1  = A.ATTRIBUTE1
                       AND   T.COL2  = A.ATTRIBUTE2
                       AND   T.COL3  = A.ATTRIBUTE3
                       AND   T.COL4  = A.ATTRIBUTE4
                       AND   T.COL5  = A.ATTRIBUTE5
                       AND   T.COL6  = A.ATTRIBUTE6
                       AND   T.COL7  = A.ATTRIBUTE7
                       AND   T.COL8  = A.ATTRIBUTE8
                       AND   T.COL9  = NVL(A.ATTRIBUTE9, '-')
                       AND   T.COL10 = A.ATTRIBUTE10
                      );

                                                                                
                                                                         
                                                                                
        v_log_type    := 'UPDATE';
        v_log_message := '########## ERROR Model Duplication ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                         
                                 
                                                 
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE301 = A.ATTRIBUTE1
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE1 = '40';

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ',Invalid Division(40 Only).'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE301 IS NULL;

                                                                                
                                                                    
                                                                                
        v_log_type    := 'UPDATE';
        v_log_message := '########## Invalid Division ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                           
                                                           
                                                                  
                                                                                             
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE302 = (SELECT MAX(EC.CODE)
                                 FROM  (SELECT DISTINCT SI.PROJECT_CODE AS CODE
                                             , NVL(D.SEGMENT3, SI.PROJECT_CODE) AS NAME
                                        FROM   SCM_MGR.SCM_MST_SITE_ITEM SI
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO UI
                                            ON SI.OWNER = UI.USER_ID
                                        INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO DI
                                            ON UI.DEPT_ID = DI.DEPT_ID
                                        LEFT OUTER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D
                                            ON  SI.DIVISION_ID  = D.SEGMENT1
                                            AND SI.PROJECT_CODE = D.SEGMENT2
                                            AND D.LOOKUP_TYPE   = 'END_CUSTOMER'
                                            AND D.VALID_YN      = 'Y'
                                                                                        
                                        WHERE  UI.USER_ID = CASE WHEN INSTR(SI.OWNER, ',') = 0 THEN SI.OWNER
                                                                 ELSE SUBSTR(SI.OWNER, 1, INSTR(SI.OWNER, ',') - 1) END
                                        AND    UI.DEPT_ID     = DI.DEPT_ID
                                        AND    SI.DIVISION_ID = '40'
                                        AND    SI.VALID_YN    = 'Y'
                                        UNION
                                        SELECT SEGMENT2 AS CODE
                                             , SEGMENT3 AS NAME
                                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                        WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
                                        AND    SEGMENT2 <> '-'
                                        AND    VALID_YN = 'Y'
                                        AND    SEGMENT1 = '40') EC
                                 WHERE EC.NAME = A.ATTRIBUTE2)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE2 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid End Customer'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE302 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                         
                                                         
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE303 = (SELECT MAX(MS.SCM_SITE_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 WHERE  MS.SITE_TYPE   = 'SALES'
                                 AND    MS.VALID_YN    = 'Y'
                                 AND    MS.DIVISION_ID = '40'
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE3)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE3 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Sales Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE303 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                           
                                           
                                                           
                                                           
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.UPLOAD_STATUS_CODE = 'ERROR'
             , A.MESSAGE_TEXT       = A.MESSAGE_TEXT || ', Invalid End Customer/Sales Site.'
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.SCM_MST_SITE MS
                           LEFT JOIN SCM_MGR.SCM_MST_SITE_ITEM SI
                               ON  MS.DIVISION_ID = SI.DIVISION_ID
                               AND MS.SCM_SITE_ID = SI.SCM_SITE_ID
                           WHERE  1 = 1
                           AND    MS.SITE_TYPE    = 'SALES'
                           AND    MS.VALID_YN     = 'Y'
                           AND    MS.DIVISION_ID  = '40'
                           AND    SI.PROJECT_CODE = A.ATTRIBUTE302
                           AND    MS.SCM_SITE_ID  = A.ATTRIBUTE303
                          );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid END CUSTOMER / SALES SITE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                               
                                               
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE304 = (SELECT MAX(MS.ITEM_ID)
                                 FROM   SCM_MGR.SCM_MST_SITE_ITEM MS
                                 INNER JOIN SCM_MGR.SCM_MST_ITEM_SN SN
                                     ON  MS.DIVISION_ID = SN.DIVISION_ID
                                     AND MS.ITEM_ID     = SN.ITEM_ID
                                     AND SN.ACTIVE_FLAG = 'Y'
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301       
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303              
                                 AND    MS.ITEM_ID     = A.ATTRIBUTE4           
                                 AND    MS.VALID_YN    = 'Y')
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE4 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Model.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE304 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid MODEL ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                  
                                                   
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE305 = (SELECT MAX(L.SEGMENT2)                       
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'INCOTERMS'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE5)
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE5 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Incoterms.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE305 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid INCOTERMS ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                        
                                                        
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE306 = (SELECT MAX(L.SEGMENT1)                       
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                                 AND    NVL(L.ATTRIBUTE2, '-') <> 'Y'                                     
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE6)                    
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE6 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Fcst Type'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE306 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid FCST TYPE ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                          
                                                          
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE307 = (SELECT MAX(L.SEGMENT1)                       
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'DM_CUSTOMS_HANDBOOK_40'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE7)                    
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE7 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Customs Handbook'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE307 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Customs Handbook ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                              
                                                              
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE308 = (SELECT MAX(M.SEGMENT1)
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
                                 WHERE  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'
                                 AND    M.VALID_YN    = 'Y'
                                 AND    M.ATTRIBUTE1  = A.ATTRIBUTE8)                     
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE8 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Cell Prod Site'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE308 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid Cell Prod Site ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                                
                                                   
                                                 
                                                        
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE310 = (SELECT MAX(L.SEGMENT3)
                                 FROM   SCM_MGR.SCM_MST_SITE MS
                                 INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                     ON  L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
                                     AND L.SEGMENT1    = 'DMF0082'                   
                                     AND L.VALID_YN    = 'Y'                   
                                     AND L.ATTRIBUTE1  = 'Y'                           
                                     AND L.SEGMENT2    = MS.DIVISION_ID
                                     AND (
                                          ( NVL(MS.VMI_YN,'N') = 'N' AND L.ATTRIBUTE3 <> 'Y' )                                              
                                          OR
                                          ( NVL(MS.VMI_YN,'N') = 'Y' )                              
                                                                  
                                         )
                                 WHERE  MS.DIVISION_ID = A.ATTRIBUTE301        
                                 AND    MS.SCM_SITE_ID = A.ATTRIBUTE303               
                                                                                            
                                                                                                  
                                                                                                             
                                 AND    L.SEGMENT4     = A.ATTRIBUTE10)                 
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    A.ATTRIBUTE10 IS NOT NULL;

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid Measure'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    ATTRIBUTE310 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                                 
                               
                                                              
                                                       
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
        SET    A.ATTRIBUTE309 = (SELECT MAX(L.SEGMENT1)                       
                                 FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                 WHERE  L.LOOKUP_TYPE = 'CURRENCY_LIST'
                                 AND    L.VALID_YN    = 'Y'
                                 AND    L.SEGMENT2    = A.ATTRIBUTE9)                    
        WHERE  A.PROGRAM_ID = v_program_id
        AND    A.SHEET_NAME = v_sheet_name
        AND    A.CREATED_BY = p_created_by
        AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    A.UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(A.ATTRIBUTE310, '-') = 'LOC';                               

        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid CURRENCY.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    NVL(ATTRIBUTE310, '-') = 'LOC'                                  
        AND    ATTRIBUTE309 IS NULL;

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid CURRENCY. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                             
                                                                     
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Invalid NUMERIC.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 0) OR     
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 0) OR     
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 0) OR     
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 0) OR     
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 0) OR     
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 0) OR     
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 0) OR      
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 0) OR      
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 0) OR      
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 0) OR      
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 0) OR      
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 0) OR      
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 0)                                                 
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Invalid NUMERIC. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                           
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Negative Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) < 0) OR     
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE20 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE21 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE22 DEFAULT NULL ON CONVERSION ERROR) < 0) OR      
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE23 DEFAULT NULL ON CONVERSION ERROR) < 0)                                                 
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Negative Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                  
                                                               
                                                                  
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'ERROR'
             , MESSAGE_TEXT       = MESSAGE_TEXT || ', Zero Number.'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD'
        AND    (
                   (ATTRIBUTE11 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE11 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE11 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE12 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE12 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE12 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE13 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE13 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE13 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE14 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE14 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE14 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE15 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE15 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE15 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE16 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE16 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE16 DEFAULT NULL ON CONVERSION ERROR) = 0) OR     
                   (ATTRIBUTE17 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE17 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE17 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE18 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE18 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE18 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE19 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE19 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE19 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE20 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE20 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE20 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE21 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE21 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE21 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE22 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE22 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE22 DEFAULT NULL ON CONVERSION ERROR) = 0) OR      
                   (ATTRIBUTE23 IS NOT NULL AND VALIDATE_CONVERSION(ATTRIBUTE23 AS NUMBER) = 1 AND TO_NUMBER(ATTRIBUTE23 DEFAULT NULL ON CONVERSION ERROR) = 0)                                                 
               );

        n_row_cnt     := SQL%ROWCOUNT;
        v_log_type    := 'UPDATE';
        n_log_count   := n_log_count + 1;
        v_log_message := '########## Zero Number. ##########';
        v_description := TO_CHAR(n_row_cnt);
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                         
        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        SET    UPLOAD_STATUS_CODE = 'SUCCESS'
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
        AND    UPLOAD_STATUS_CODE = 'UPLOAD';

                                                                                    
                                                                         
                                                                                    
        v_log_type    := '16';
        v_log_message := '########## SUCCESS ##########';
        v_description := '';
        d_event_date  := SYSDATE;
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                            
                                                                                                     
                                                                           
                                                                 


    ELSE
                                                                                                          
                                                                    
                                                                          
                                                                       
                                                                             
                                                         
                                                                         
                                                                                                          
        SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
             , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
        INTO   n_success_cnt, n_error_cnt
        FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
        WHERE  PROGRAM_ID = v_program_id
        AND    SHEET_NAME = v_sheet_name
        AND    CREATED_BY = p_created_by
        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

                                                                     
        IF n_error_cnt > 0 OR n_success_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NOT_SAVABLE (SUCCESS=' || TO_CHAR(n_success_cnt)
                       || ', ERROR=' || TO_CHAR(n_error_cnt) || ')' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

                                                                                
                                                          
                                                                                
        SCM_MGR.PKG_DMF0082.P_DMF0082_GET_EXCEL_UPLOAD_DATA(p_created_by, v_rc_a, v_rc_b, v_rc_c);
        BEGIN IF v_rc_a IS NOT NULL THEN CLOSE v_rc_a; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN IF v_rc_b IS NOT NULL THEN CLOSE v_rc_b; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN IF v_rc_c IS NOT NULL THEN CLOSE v_rc_c; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                                
                                                                 
                                                              
                                              
                                                                                
        INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
        ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
        , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
        , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
        , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY )
        SELECT U.DIVISION_ID, U.END_CUSTOMER, U.SCM_SITE_ID, U.ITEM_ID, U.INCOTERMS
             , U.FCST_TYPE, U.DOM_EXP, U.CELL_PROD_SITE, U.CURRENCY, U.MEASURE
             , U.KEY_VALUE, U.YYYYMM, U.YYYYMM || '01', NULL
             , 1, U.QTY, U.QTY, 'Y', U.QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT U
        WHERE  U.MEASURE = 'VMI_In_Req'
        AND    NVL(U.QTY, 0) <> 0;

                                                                                
                                                                  
                                                                   
                                                                                
        COMMIT;

                                                                                
                                       
                                                                                        
                                                                  
                                                                         
                                                                          
                                                                                
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;

        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT 'M'                                                       
             , D.DIVISION_ID
             , D.END_CUSTOMER                                                           
             , D.END_CUSTOMER
             , D.SCM_SITE_ID
             , D.ITEM_ID
             , D.DOM_EXP
             , D.FCST_TYPE
             , D.INCOTERMS
             , D.MEASURE
             , NVL( (SELECT MAX(X.PLANT_SITE_ID)
                       FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                      WHERE X.DIVISION_ID       = D.DIVISION_ID
                        AND X.PROJECT_CODE      = D.END_CUSTOMER
                        AND X.SCM_SITE_ID       = D.SCM_SITE_ID
                        AND X.ITEM_ID           = D.ITEM_ID
                        AND X.DOM_EXP           = D.DOM_EXP
                        AND X.FCST_TYPE         = D.FCST_TYPE
                        AND X.INCOTERMS         = D.INCOTERMS
                        AND X.CELL_PROD_SITE_ID = D.CELL_PROD_SITE)
                  , '-' )
             , D.CELL_PROD_SITE
             , D.BASIS_YYYYMMDD
             , D.CURRENCY
             , D.DAILY_QTY
             , p_created_by
             , '', '', '', '', '', '', '', '', '', '', '', ''
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY D
        WHERE  NVL(D.MONTHLY_QTY, 0) <> 0;

        SELECT COUNT(*) INTO n_save_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;
        COMMIT;

        IF n_save_cnt = 0 THEN
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS RESULT_CODE
                     , 'NO_TARGET_ROW (입력된 값이 없습니다)' AS RESULT_MSG
                     , TO_CHAR(NVL(p_mode, 0)) AS EVENT
                FROM   DUAL;
            RETURN;
        END IF;

                                                                                
                                                                  
                                                                                
        g_skip_parse := 'Y';
        BEGIN
            SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(
                'M', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
              , NULL, NULL, NULL, NULL, NULL, p_created_by, NULL, v_rc_save);
        EXCEPTION
            WHEN OTHERS THEN
                g_skip_parse := 'N';
                RAISE;
        END;
        g_skip_parse := 'N';

        v_save_code := NULL; v_save_msg := NULL; v_save_event := NULL;
        BEGIN
            FETCH v_rc_save INTO v_save_code, v_save_msg, v_save_event;
            CLOSE v_rc_save;
        EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                       
        IF NVL(v_save_code, 'F') = '0' THEN
            UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SAVED'
                 , LAST_UPDATED_BY    = p_created_by
                 , LAST_UPDATE_DATE   = SYSDATE
             WHERE PROGRAM_ID = v_program_id
             AND   SHEET_NAME = v_sheet_name
             AND   CREATED_BY = p_created_by
             AND   TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
             AND   UPLOAD_STATUS_CODE = 'SUCCESS';
            COMMIT;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT NVL(v_save_code, 'F') AS RESULT_CODE
                 , CASE WHEN NVL(v_save_code, 'F') = '0'
                        THEN 'SAVED=' || TO_CHAR(n_save_cnt)
                        ELSE NVL(v_save_msg, 'SAVE FAILED') END AS RESULT_MSG
                 , TO_CHAR(NVL(p_mode, 0)) AS EVENT
            FROM   DUAL;
        RETURN;

    END IF;

                                                                                
                                                                     
                                                                                
    v_log_type    := '21';
    v_log_message := '########## INSERT DMF0028_EXCEL_UPLOAD END ##########';
    v_description := TO_CHAR(p_mode);                                              
    d_event_date  := SYSDATE;
    BEGIN
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                                
                                            
                                                                                
    SELECT COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'SUCCESS' THEN 1 END)
         , COUNT(CASE WHEN UPLOAD_STATUS_CODE = 'ERROR'   THEN 1 END)
    INTO   n_success_cnt, n_error_cnt
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD
    WHERE  PROGRAM_ID = v_program_id
    AND    SHEET_NAME = v_sheet_name
    AND    CREATED_BY = p_created_by
    AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT CASE WHEN n_error_cnt > 0 THEN '1' ELSE '0' END AS RESULT_CODE
             , 'SUCCESS=' || TO_CHAR(n_success_cnt) || ', ERROR=' || TO_CHAR(n_error_cnt) AS RESULT_MSG
             , TO_CHAR(NVL(p_mode, 0)) AS EVENT
        FROM   DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_EXCEL_UPLOAD;


PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA 
(
    p_created_by     IN  VARCHAR2
  , O_RC1            OUT SYS_REFCURSOR                              
  , O_RC2            OUT SYS_REFCURSOR                                       
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR                                                
)
                                                                                                                                                       
                                              
                                                                                                        
                                                                           
                                      
                
                                                                                                                                                       
                                        
                                                                                                                                                       
                                          
                                                                                                          
                                                                                                                                                       
                       
                                                                                                                                   
                                                                                                                  
                                                                                                                      
                                                                                                         
                                                                                                                           
                                                           
                                                                                                               
                                                                      
                                                         
                                                                                            
                                                
                                                                             
                                                                                 
                                                                                     
                                                                                                                                                       
IS
    v_program_id     VARCHAR2(40 CHAR)  := 'DMF0082';
    v_sheet_name     VARCHAR2(40 CHAR)  := 'FcstNPrice';
    v_creation_date  VARCHAR2(40 CHAR);
    v_start_yyyymm   VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 4), 'YYYYMM');
    v_end_yyyymm     VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(SYSDATE, 16), 'YYYYMM');
    v_division       VARCHAR2(10 CHAR);
    v_defaultLocBucketDay VARCHAR2(10 CHAR);

                                                    
    V_CONCAT_PIVOT   CLOB;                                                             
    V_SQL            CLOB;
    V_PIVOT_PIECE    VARCHAR2(100 CHAR);
    V_PRINT_POS      PLS_INTEGER;
    V_PRINT_LEN      PLS_INTEGER;

                     
    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(20 CHAR);
    V_SQL_ERRMSG     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);

                                           
    CURSOR C_PIVOT IS
        SELECT 'D' || A.BASIS_YYYYMMDD AS PV_KEY
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  1 = 1
        AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
        ORDER BY A.BASIS_YYYYMMDD;

BEGIN
                                                   
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';


    V_PROC_INPUT := JSON_OBJECT('p_created_by' VALUE p_created_by);

    SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
    INTO   v_creation_date
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD T
    WHERE  T.PROGRAM_ID = v_program_id
    AND    T.SHEET_NAME = v_sheet_name
    AND    T.CREATED_BY = p_created_by;

    IF v_creation_date IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('NO EXCEL DATA');                                              
    END IF;

                                                                                                        
                                                                                  
                                                                                                        
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
    DELETE FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;

                                                                                                        
                
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , M4, M5, M6, M7, M8, M9, M10, M11, M12, M13, M14, M15, M16)
    SELECT A.ATTRIBUTE301 AS DIVISION_ID
         , A.ATTRIBUTE302 AS END_CUSTOMER
         , A.ATTRIBUTE303 AS SCM_SITE_ID
         , A.ATTRIBUTE304 AS ITEM_ID
         , A.ATTRIBUTE305 AS INCOTERMS
         , A.ATTRIBUTE306 AS FCST_TYPE
         , A.ATTRIBUTE307 AS DOM_EXP
         , A.ATTRIBUTE308 AS CELL_PROD_SITE
         , A.ATTRIBUTE309 AS CURRENCY
         , A.ATTRIBUTE310 AS MEASURE
         , A.ATTRIBUTE2   AS END_CUSTOMER_NAME
         , A.ATTRIBUTE3   AS SCM_SITE_ID_NAME
         , A.ATTRIBUTE6   AS FCST_TYPE_NAME
         , A.ATTRIBUTE8   AS CELL_PROD_SITE_NAME
         , A.ATTRIBUTE10  AS MEASURE_NAME
         , A.ATTRIBUTE11  AS M4
         , A.ATTRIBUTE12  AS M5
         , A.ATTRIBUTE13  AS M6
         , A.ATTRIBUTE14  AS M7
         , A.ATTRIBUTE15  AS M8
         , A.ATTRIBUTE16  AS M9
         , A.ATTRIBUTE17  AS M10
         , A.ATTRIBUTE18  AS M11
         , A.ATTRIBUTE19  AS M12
         , A.ATTRIBUTE20  AS M13
         , A.ATTRIBUTE21  AS M14
         , A.ATTRIBUTE22  AS M15
         , A.ATTRIBUTE23  AS M16
    FROM   SCM_MGR.SCM_ADM_EXCEL_UPLOAD A
    WHERE  1 = 1
    AND    A.PROGRAM_ID = v_program_id
    AND    A.SHEET_NAME = v_sheet_name
    AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
    AND    A.UPLOAD_STATUS_CODE = 'SUCCESS';

                                                                       
    BEGIN
        SELECT DIVISION_ID
        INTO   v_division
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN v_division := NULL;
    END;

                    
    v_defaultLocBucketDay := 'MON';

                                                                                                        
             
                                                           
                                                                            
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , END_CUSTOMER_NAME, SCM_SITE_ID_NAME, FCST_TYPE_NAME, CELL_PROD_SITE_NAME, MEASURE_NAME
    , KEY_VALUE, YYYYMM, QTY)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.END_CUSTOMER_NAME
         , A.SCM_SITE_ID_NAME
         , A.FCST_TYPE_NAME
         , A.CELL_PROD_SITE_NAME
         , A.MEASURE_NAME
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , A.QTY
    FROM  (SELECT A.DIVISION_ID
                , A.END_CUSTOMER
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , A.FCST_TYPE
                , A.DOM_EXP
                , A.CELL_PROD_SITE
                , A.CURRENCY
                , A.MEASURE
                , A.END_CUSTOMER_NAME
                , A.SCM_SITE_ID_NAME
                , A.FCST_TYPE_NAME
                , A.CELL_PROD_SITE_NAME
                , A.MEASURE_NAME
                , A.DIVISION_ID || A.END_CUSTOMER || A.SCM_SITE_ID || A.ITEM_ID || A.INCOTERMS
                  || A.FCST_TYPE || A.DOM_EXP || A.CELL_PROD_SITE || A.CURRENCY || A.MEASURE AS KEY_VALUE
                , A.YYYYMM
                                                                                  
                , CAST(TO_NUMBER(NVL(A.QTY, '0')) AS NUMBER(23,2)) AS QTY
                                                                                  
           FROM  SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
           UNPIVOT INCLUDE NULLS (QTY FOR YYYYMM IN
                 ( M4  AS 'M4',  M5  AS 'M5',  M6  AS 'M6',  M7  AS 'M7'
                 , M8  AS 'M8',  M9  AS 'M9',  M10 AS 'M10', M11 AS 'M11'
                 , M12 AS 'M12', M13 AS 'M13', M14 AS 'M14', M15 AS 'M15', M16 AS 'M16')) A
          ) A
    JOIN  (SELECT DISTINCT A.BASIS_YYYYMM
                , 'M' || TO_CHAR(DENSE_RANK() OVER (ORDER BY A.BASIS_YYYYMM) + 3) AS RN
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm) CM
      ON  (CM.RN = A.YYYYMM);

                                                                                                        
                
                                         
                                                     
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, BASIS_YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW)
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT BC.DIVISION_ID
                , BC.SCM_SITE_ID
                , BC.INCOTERMS
                , BC.BUCKET_PER
                , BC.YYYYMMDD
                , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
           WHERE  1 = 1
           AND    BC.DIVISION_ID = v_division) BC
      ON  (BC.DIVISION_ID = A.DIVISION_ID
     AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
     AND   BC.INCOTERMS   = A.INCOTERMS
     AND   BC.YYYYMMDD    = CM.DAYOFWEEK
     AND   BC.BUCKET_PER  = 'Y')
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'

    UNION ALL

                                                                      
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
           WHERE  1 = 1
           AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
           AND    L.VALID_YN    = 'Y'
           AND    L.SEGMENT1    = v_division
           AND    L.SEGMENT2    = 'MONTHLY') BC
      ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                       WHERE  1 = 1
                       AND    X.DIVISION_ID = A.DIVISION_ID
                       AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                       AND    X.INCOTERMS   = A.INCOTERMS
                       AND    X.BUCKET_PER  = 'Y');

                                                                                                        
                
                   
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, ISO_YYYYWW, WEEK_DAY_CNT, MONTHLY_QTY, WEEKLY_QTY)
    WITH W_WEEKLY AS (
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.ISO_YYYYWW
             , CM.WEEK_DAY_CNT
             , A.QTY AS MONTHLY_QTY
             , FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT) AS TEMP_WEEKLY_QTY
             , SUM(FLOOR(A.QTY / CM.EOM * CM.WEEK_DAY_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.YYYYMM, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.ISO_YYYYWW) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_WEEK_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.ISO_YYYYWW
                    , COUNT(1) AS WEEK_DAY_CNT
                                                                                               
                    , TO_NUMBER(TO_CHAR(LAST_DAY(MAX(A.BASIS_DATE)), 'DD')) AS EOM
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               GROUP BY A.BASIS_YYYYMM
                      , A.ISO_YYYYWW
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        JOIN  (SELECT DISTINCT PB.KEY_VALUE
                    , PB.BASIS_YYYYMM
                    , PB.ISO_YYYYWW
               FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET PB) PB                        
          ON  (A.KEY_VALUE  = PB.KEY_VALUE
         AND   A.YYYYMM     = PB.BASIS_YYYYMM
         AND   CM.ISO_YYYYWW = PB.ISO_YYYYWW)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.ISO_YYYYWW
         , A.WEEK_DAY_CNT
         , A.MONTHLY_QTY
         , CASE WHEN A.LAST_WEEK_YN = 'Y' THEN A.MONTHLY_QTY - A.CUM_SUM
                ELSE A.TEMP_WEEKLY_QTY END AS WEEKLY_QTY
    FROM   W_WEEKLY A
    WHERE  1 = 1
    AND    A.MEASURE = 'MKT_FCST'
    ORDER BY A.KEY_VALUE, A.YYYYMM;

                                                                                                        
                
                    
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, INCOTERMS
    , FCST_TYPE, DOM_EXP, CELL_PROD_SITE, CURRENCY, MEASURE
    , KEY_VALUE, YYYYMM, BASIS_YYYYMMDD, ISO_YYYYWW
    , BUCKET_CNT, MONTHLY_QTY, WEEKLY_QTY, LAST_DAY_YN, DAILY_QTY)
    WITH W_DAILY AS (
                             
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , BC.BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY / BC.BUCKET_CNT))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT BC.DIVISION_ID
                    , BC.SCM_SITE_ID
                    , BC.INCOTERMS
                    , BC.BUCKET_PER
                    , BC.YYYYMMDD
                    , COUNT(BC.BUCKET_PER) OVER (PARTITION BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS) AS BUCKET_CNT
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
               WHERE  1 = 1
               AND    BC.DIVISION_ID = '40') BC                                   
          ON  (BC.DIVISION_ID = A.DIVISION_ID
         AND   BC.SCM_SITE_ID = A.SCM_SITE_ID
         AND   BC.INCOTERMS   = A.INCOTERMS
         AND   BC.YYYYMMDD    = CM.DAYOFWEEK
         AND   BC.BUCKET_PER  = 'Y')

        UNION ALL

                        
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.YYYYMM
             , CM.BASIS_YYYYMMDD
             , CM.ISO_YYYYWW
             , 1 AS BUCKET_CNT
             , A.MONTHLY_QTY
             , A.WEEKLY_QTY
             , FLOOR(A.WEEKLY_QTY) AS TEMP_DAILY_QTY
             , SUM(FLOOR(A.WEEKLY_QTY))
                   OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                         ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD
                         ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) AS CUM_SUM
             , CASE WHEN LEAD(A.ISO_YYYYWW, 1)
                        OVER (PARTITION BY A.KEY_VALUE, A.YYYYMM, A.ISO_YYYYWW
                              ORDER BY A.KEY_VALUE, A.YYYYMM, CM.BASIS_YYYYMMDD) IS NULL
                    THEN 'Y' ELSE 'N' END AS LAST_DAY_YN
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
              ) CM
          ON  (A.YYYYMM     = CM.BASIS_YYYYMM
         AND   A.ISO_YYYYWW = CM.ISO_YYYYWW)
        JOIN  (SELECT L.SEGMENT3 AS DAYOFWEEK
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
               WHERE  1 = 1
               AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'
               AND    L.VALID_YN    = 'Y'
               AND    L.SEGMENT1    = v_division
               AND    L.SEGMENT2    = 'MONTHLY') BC
          ON  (BC.DAYOFWEEK = CM.DAYOFWEEK)
        WHERE  1 = 1
        AND    A.MEASURE = 'MKT_FCST'
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION X
                           WHERE  1 = 1
                           AND    X.DIVISION_ID = A.DIVISION_ID
                           AND    X.SCM_SITE_ID = A.SCM_SITE_ID
                           AND    X.INCOTERMS   = A.INCOTERMS
                           AND    X.BUCKET_PER  = 'Y')
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , A.YYYYMM
         , A.BASIS_YYYYMMDD
         , A.ISO_YYYYWW
         , A.BUCKET_CNT
         , A.MONTHLY_QTY
         , A.WEEKLY_QTY
         , A.LAST_DAY_YN
         , CASE WHEN A.LAST_DAY_YN = 'Y' THEN A.WEEKLY_QTY - NVL(A.CUM_SUM, 0)
                ELSE A.TEMP_DAILY_QTY END AS DAILY_QTY
    FROM   W_DAILY A
    WHERE  1 = 1
    ORDER BY A.KEY_VALUE, A.YYYYMM;

                                                                                                        
           
                     
                                                                                                        
    INSERT INTO SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
    ( DIVISION_ID
    , END_CUSTOMER
    , SCM_SITE_ID
    , ITEM_ID
    , INCOTERMS
    , FCST_TYPE
    , DOM_EXP
    , CELL_PROD_SITE
    , CURRENCY
    , MEASURE
    , KEY_VALUE
    , YYYYMM
    , BASIS_YYYYMMDD
    , ISO_YYYYWW
    , BUCKET_CNT
    , MONTHLY_QTY
    , WEEKLY_QTY
    , LAST_DAY_YN
    , DAILY_QTY
    )
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , A.CURRENCY
         , A.MEASURE
         , A.KEY_VALUE
         , CM.BASIS_YYYYMM AS YYYYMM
         , CM.BASIS_YYYYMMDD
         , CM.ISO_YYYYWW
         , NULL AS BUCKET_CNT
         , NULL AS MONTHLY_QTY
         , NULL AS WEEKLY_QTY
         , NULL AS LAST_DAY_YN                                                            
         , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
    FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
    JOIN  (SELECT A.BASIS_YYYYMM
                , A.BASIS_YYYYMMDD
                , A.ISO_YYYYWW
                , A.DAYOFWEEK
           FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
           WHERE  1 = 1
           AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
           AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
          ) CM
      ON  (A.YYYYMM = CM.BASIS_YYYYMM)
    WHERE  1 = 1
    AND    A.MEASURE = 'LOC';

                                                                                                        
                                                             
                                                                                                        
    OPEN O_RC1 FOR
                  
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , A.BASIS_YYYYMMDD
             , CAST(A.DAILY_QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
        UNION ALL
             
        SELECT A.DIVISION_ID
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.FCST_TYPE
             , A.DOM_EXP
             , A.CELL_PROD_SITE
             , A.CURRENCY
             , A.MEASURE
             , A.KEY_VALUE
             , CM.BASIS_YYYYMMDD
             , CAST(A.QTY AS NUMBER(23,2)) AS DAILY_QTY
        FROM   SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT A
        JOIN  (SELECT A.BASIS_YYYYMM
                    , A.BASIS_YYYYMMDD
                    , A.ISO_YYYYWW
                    , A.DAYOFWEEK
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
               WHERE  1 = 1
               AND    A.BASIS_YYYYMM BETWEEN v_start_yyyymm AND v_end_yyyymm
               AND    (A.DAYOFWEEK = v_defaultLocBucketDay OR A.CALENDAR_DAY = '01')
              ) CM
          ON  (A.YYYYMM = CM.BASIS_YYYYMM)
        WHERE  1 = 1
        AND    A.MEASURE = 'LOC'
        ORDER BY KEY_VALUE, BASIS_YYYYMMDD;
                                                               

                                                                                                        
                                                                
                                                                        
                                                                                                        
    DBMS_LOB.CREATETEMPORARY(V_CONCAT_PIVOT, TRUE);

    OPEN C_PIVOT;
    LOOP
        FETCH C_PIVOT INTO V_PIVOT_PIECE;
        EXIT WHEN C_PIVOT%NOTFOUND;
        IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
            V_CONCAT_PIVOT := '''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        ELSE
            V_CONCAT_PIVOT := V_CONCAT_PIVOT || ',''' || V_PIVOT_PIECE || ''' AS ' || V_PIVOT_PIECE;
        END IF;
    END LOOP;
    CLOSE C_PIVOT;

                                                                         
    IF DBMS_LOB.GETLENGTH(V_CONCAT_PIVOT) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS RESULT_CODE, 'NO_CALENDAR_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

                                                                                          
    V_SQL := '
    SELECT A.*
      FROM (
    SELECT A.DIVISION_ID
         , A.END_CUSTOMER
         , B.END_CUSTOMER_NAME
         , A.SCM_SITE_ID
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , B.FCST_TYPE_NAME
         , A.DOM_EXP
         , A.CELL_PROD_SITE
         , B.CELL_PROD_SITE_NAME
         , A.CURRENCY
         , A.MEASURE
         , B.MEASURE_NAME
         , ''D'' || A.BASIS_YYYYMMDD AS BASIS_YYYYMMDD
         , A.DAILY_QTY
      FROM SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY A
      JOIN SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT B
        ON (A.KEY_VALUE = B.KEY_VALUE))
      PIVOT (MAX(DAILY_QTY) FOR BASIS_YYYYMMDD IN (' || V_CONCAT_PIVOT || '
    )) A';

    OPEN O_RC2 FOR V_SQL;

                                                                                                
    V_PRINT_POS := 1;
    V_PRINT_LEN := NVL(DBMS_LOB.GETLENGTH(V_SQL), 0);
    WHILE V_PRINT_POS <= V_PRINT_LEN
    LOOP
        DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 4000, V_PRINT_POS));
        V_PRINT_POS := V_PRINT_POS + 4000;
    END LOOP;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
                                                              

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL);          EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_CONCAT_PIVOT); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', 0
              , '########## FAIL END of procedure ##########', ''
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_EXCEL_UPLOAD_DATA;


PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT 
                                                                                                                                                                                                                                        
(
    p_division_id    IN  VARCHAR2
  , p_team_id        IN  VARCHAR2
  , p_customer       IN  VARCHAR2
  , p_biz_type       IN  VARCHAR2
  , p_from_yyyymmdd  IN  VARCHAR2
  , p_to_yyyymmdd    IN  VARCHAR2
  , p_scm_site_id    IN  VARCHAR2
  , p_item_id        IN  VARCHAR2
  , p_version_type   IN  VARCHAR2
  , p_qty_yn         IN  VARCHAR2
  , p_created_by     IN  VARCHAR2
  , p_user_group     IN  VARCHAR2
  , p_plant_site_id  IN  VARCHAR2 DEFAULT 'ALL'                                                                            
  , p_project_code   IN  VARCHAR2 DEFAULT 'ALL'                                                       
  , p_owner          IN  VARCHAR2 DEFAULT 'ALL'                                                     
  , p_sender_code    IN  VARCHAR2 DEFAULT 'ALL'                                                                                
  , O_RC1            OUT SYS_REFCURSOR                           
  , O_RC2            OUT SYS_REFCURSOR                                                       
  , O_RC3            OUT SYS_REFCURSOR                       
  , O_RC4            OUT SYS_REFCURSOR                                                   
  , O_RC5            OUT SYS_REFCURSOR                                          
  , O_RESULT_CURSOR  OUT SYS_REFCURSOR                                                
)
                                                                                                                                                       
                                              
                                 
                                      
                
                                                                                                                                                       
                                            
                                                                                                                                                       
                                                        
                                                                                                              
  
                                                                                                                              
                                                                                                                                                       
                                 
                                                                                               
                                                                                                                                              
                                                                                                                                                                  
                                                                                                                                  
                                                                                                                                                            
                          
                                                                                     
                                                                                                         
                                                                                           
                                                                                  
                                                                                                
                                                                                                               
                                      
                                                                                                                                      
                                                                                                         
                                                                                                         
                                                                                                  
                                                       
                                                                                                                                   
                                                                                         
                                                                                                                        
                                                                                                         
                                                                                                                     
                                                                                              
                                                                                                                    
                                                                                                                                    
                                                        
                                                                                                                   
                                                                                    
                                                                                                       
                                                                                    
                                                                                      
                                                                                               
                                                                                                        
                                                                                                                                                       
IS
                                                                                                                                   
                                                             
                                                                                                                                   
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

                                                                                                                                   
                           
                                                                                                                                   
    V_USER_COL_CNT      NUMBER := 0;
    V_USER_MEA_CNT      NUMBER := 0;
    VA_PROGRAM_ID       VARCHAR2(50 CHAR) := 'DMF0082';
    VA_SHEET_NAME       VARCHAR2(50 CHAR) := 'FcstNPrice';

                                                                                                                                   
                                                     
                                                                                                                                   
    V_EXP_YYYYMMDD      VARCHAR2(8 CHAR);
    V_PV_LIST           CLOB;                                                                
    V_PV_COL_LIST       CLOB;                                                           
    V_PV_COLUMN_NAME    VARCHAR2(200 CHAR);
    V_PV_NAME           VARCHAR2(200 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(50 CHAR);

                           
    V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
    V_FROM_RESULT       VARCHAR2(8 CHAR);
    V_TO_RESULT         VARCHAR2(8 CHAR);
    V_USER_TIME_ZONE    VARCHAR2(50 CHAR);

                                 
    V_CUR_COLUMN_NAME   VARCHAR2(200 CHAR);
    V_CUR_PROGRAM_ID    VARCHAR2(50 CHAR);
    V_CUR_SHEET_NAME    VARCHAR2(100 CHAR);
    V_CUR_SORT_ORDER_NO VARCHAR2(50 CHAR);

                                           
    V_COLUMN            VARCHAR2(4000 CHAR);
    V_GROUPBY           VARCHAR2(4000 CHAR);
    V_ORDERBY           VARCHAR2(4000 CHAR);

                           
    V_GROUP_ID          VARCHAR2(50 CHAR) := '';
    V_ADMIN_CNT         NUMBER := 0;
    V_MEASURE_CNT       NUMBER := 0;
    V_LIMIT_CNT         NUMBER := 0;

                         
    V_SQL_TEXT          CLOB;

                  
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);

                                                                                                                                   
                                                        
                                                                                               
                                                                                    
                                                                                                                                   
    CURSOR C_BUCKET IS
        SELECT 'D_' || A.BASIS_YYYYMMDD                                            AS COLUMN_NAME
             , '''D_' || A.BASIS_YYYYMMDD || ''' AS D_' || A.BASIS_YYYYMMDD        AS PV_NAME
             , A.BASIS_YYYYMMDD || '_31'                                           AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= V_EXP_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK                                AS COLUMN_NAME
             , '''W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ''' AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS PV_NAME
             , A.BASIS_START_DATE || '_21'                                         AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM                                              AS COLUMN_NAME
             , '''M_' || A.BASIS_YYYYMM || ''' AS M_' || A.BASIS_YYYYMM            AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_01'                                    AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M A
        WHERE  A.BASIS_YYYYMMDD >= p_from_yyyymmdd
        AND    A.BASIS_YYYYMMDD <= p_to_yyyymmdd
        GROUP BY A.BASIS_YYYYMM
        ORDER BY SORT_ORDER_NO;

                                                                                                                                   
                                                                  
                                                                                                                                   
    CURSOR C_TITLE IS
        SELECT * FROM (                                                               
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , CASE WHEN U.COLUMN_NAME = 'LAST_UPDATE_DATE' THEN '800'
                    WHEN U.COLUMN_NAME = 'LAST_UPDATED_BY'  THEN '560'
                    ELSE TO_CHAR(U.SORT_ORDER_NO) END AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_TITLESET_USER U
             , SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    U.PROGRAM_ID  = C.PROGRAM_ID
        AND    U.SHEET_NAME  = C.SHEET_NAME
        AND    U.COLUMN_NAME = C.COLUMN_NAME
        AND    U.PROGRAM_ID  = VA_PROGRAM_ID
        AND    U.SHEET_NAME  = VA_SHEET_NAME
        AND    U.USER_ID     = p_created_by
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                                                                                            
                                                                                     
        AND    U.COLUMN_NAME IN (
                 'DIVISION_ID','SCM_SITE_ID','PLANT_SITE_ID','PROJECT_CODE','ITEM_ID','INCOTERMS','FCST_TYPE','DOM_EXP'
                ,'MEASURE','END_CUSTOMER','NICK_NAME','DMS_SALES','DMS_CUSTOMER','YYYYMM','YYYYMMWW','YYYYMMDD','DAYOFWEEK'
                ,'FORECAST_INFO_CELL_MODEL','TEAM_ID','TEAM_NAME_KO','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','OWNER'
                ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','ITEM_NAME','VMI_YN','CELL_PROD_SITE_ID'
                ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_CELL_PACK_COUNT'
                ,'FORECAST_INFO_ALL','FORECAST_INFO_SPEC','FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME'
                ,'QTY','MONTH_END_YN','WEEK_END_YN','EDIT_FLAG','SORT_ORDER_NO','MEASURE_GROUP','NEW_FLAG','BUCKET','SORT_KEY'
                ,'LAST_UPDATE_DATE','LAST_UPDATED_BY','NOTATION','CURRENCY','VERSION_NO','CUTOFF_YYYYMMDD'
                ,'AS_YN','ATTR1','VMI_STD_DIO','BIZ_TYPE','PROJECT_STATUS','ENERGE','CELL_QUANTITY'
                ,'CELL_PER_CAR','CELL_PER_MODULE','MODULE_PER_CAR','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT','AS_FROM_SITE' )
        UNION ALL
                                                                                   
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , TO_CHAR(CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO, 85) - 0.5
                            ELSE C.SORT_ORDER_NO END) AS SORT_ORDER_NO
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER U
            ON  U.PROGRAM_ID  = C.PROGRAM_ID
            AND U.SHEET_NAME  = C.SHEET_NAME
            AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND U.COLUMN_NAME IN ('ITEM_ID')
            AND U.USER_ID     = p_created_by
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = ' '                                                                                                                
                                                                                                                                                     
        AND    C.VALID_YN     = 'Y'
                                                                                                           
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U2
                   WHERE  U2.PROGRAM_ID  = C.PROGRAM_ID
                   AND    U2.SHEET_NAME  = C.SHEET_NAME
                   AND    U2.COLUMN_NAME = C.COLUMN_NAME
                   AND    U2.USER_ID     = p_created_by
                   AND    U2.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
               )
        ) ORDER BY TO_NUMBER(SORT_ORDER_NO);                                                                                                 

BEGIN

                                                                       

                                                                      

                                                                 

                                                 

                                                         

                                                              

    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_project_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_project_code, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_owner', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_owner, ','));

    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)

    SELECT 'p_sender_code', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_sender_code, ','));

                                                                                              
                                                                                       
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
                                                                                     
    V_PROC_INPUT := JSON_OBJECT(
        'p_division_id'   VALUE p_division_id,
        'p_team_id'       VALUE p_team_id,
        'p_customer'      VALUE p_customer,
        'p_biz_type'      VALUE p_biz_type,
        'p_from_yyyymmdd' VALUE p_from_yyyymmdd,
        'p_to_yyyymmdd'   VALUE p_to_yyyymmdd,
        'p_scm_site_id'   VALUE p_scm_site_id,
        'p_item_id'       VALUE p_item_id,
        'p_version_type'  VALUE p_version_type,
        'p_qty_yn'        VALUE p_qty_yn,
        'p_created_by'    VALUE p_created_by,
        'p_user_group'    VALUE p_user_group,
        'p_plant_site_id' VALUE p_plant_site_id,
        'p_project_code'  VALUE p_project_code,
        'p_owner'         VALUE p_owner,
        'p_sender_code'   VALUE p_sender_code
    );

                                                                                                                                   
                                                             
                                                                                                                                   
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                                                           
    IF p_from_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_from_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_from_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_from_yyyymmdd: ' || NVL(p_from_yyyymmdd, '<NULL>'));
    END IF;
    IF p_to_yyyymmdd IS NULL OR NOT REGEXP_LIKE(p_to_yyyymmdd, '^[0-9]{8}$')
       OR SUBSTR(p_to_yyyymmdd, 1, 4) = '0000' THEN
        RAISE_APPLICATION_ERROR(-20002, 'Invalid p_to_yyyymmdd: ' || NVL(p_to_yyyymmdd, '<NULL>'));
    END IF;

                                                                                                                                   
                        
                                                                                                                                   
    SELECT COUNT(*)
    INTO   V_USER_COL_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_COL_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'C', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
                                                                                                                                   
                                          
                                                                                                                                   
    SELECT COUNT(*)
    INTO   V_USER_MEA_CNT
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = VA_PROGRAM_ID
    AND    U.SHEET_NAME = VA_SHEET_NAME
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.USER_ID    = p_created_by;

    IF V_USER_MEA_CNT = 0 THEN
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
        ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
        , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by, C.PROGRAM_ID, C.SHEET_NAME, 'M', C.COLUMN_NAME
             , C.SORT_ORDER_NO, 'N', '', p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
             , p_created_by, TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE C
        WHERE  1 = 1
        AND    C.PROGRAM_ID   = VA_PROGRAM_ID
        AND    C.SHEET_NAME   = VA_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y';
    END IF;
                                                                                                                                   
                      
                                                                                                                                   

                                                                                                                                   
                                                                 
                                                                                                                                   
                                                                                                              
    V_EXP_YYYYMMDD := TO_CHAR(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD') + (50 * 7), 'YYYYMMDD');

    DBMS_LOB.CREATETEMPORARY(V_PV_LIST, TRUE);
    DBMS_LOB.CREATETEMPORARY(V_PV_COL_LIST, TRUE);

    OPEN C_BUCKET;
    LOOP
        FETCH C_BUCKET INTO V_PV_COLUMN_NAME, V_PV_NAME, V_SORT_ORDER_NO;
        EXIT WHEN C_BUCKET%NOTFOUND;                                       
        IF DBMS_LOB.GETLENGTH(V_PV_COL_LIST) = 0 THEN
            V_PV_COL_LIST := V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_NAME;
        ELSE
            V_PV_COL_LIST := V_PV_COL_LIST || ',' || V_PV_COLUMN_NAME;
            V_PV_LIST     := V_PV_LIST     || ',' || V_PV_NAME;
        END IF;
    END LOOP;
    CLOSE C_BUCKET;
                                                                                                                                   
                            
                                                                                                                                   

                                                                                                                                   
                               
                                                                                                                                   
                       
                                                                                                                                   
                             
                                                                                                                                   

                                                                                                                                   
                                                                                                 
                                                                                                                                   
    DELETE FROM SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEMALL;
    DELETE FROM SCM_MGR.GTT_TEMPSITEITEM;
    DELETE FROM SCM_MGR.GTT_TEMPSELECTMEASURE;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST;
    DELETE FROM SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE;
    DELETE FROM SCM_MGR.GTT_T_WS_FCST;
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE;
    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE;
    DELETE FROM SCM_MGR.GTT_CAL_MONTH_END_DATE;
    DELETE FROM SCM_MGR.GTT_CAL_WEEK_END_DATE;
    DELETE FROM SCM_MGR.GTT_MF_SP;

                                                                                                                                   
                                   
                                                                                   
                                                                                                              
                                                                        
                                                        
                                                                                                                                   
    INSERT INTO SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V
    ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
    , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
    , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
    , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
    , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME
         , NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME, ITEM_UOM, SPEC
         , MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, ACTIVE_FLAG, CELL_TYPE
         , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
    FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V
    WHERE  DIVISION_ID = '40'
    AND    ACTIVE_FLAG = 'Y';

                                                                                                                                                                                                                                        

                                                                                                                                   
                                     
                                                                                                                                   
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEMALL
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT F.DIVISION_ID
         , F.PROJECT_CODE
         , F.SCM_SITE_ID
         , F.ITEM_ID
         , T2.NICK_NAME
         , F.PROJECT_CODE                                   AS PROJECT_NAME
         , F.ATTRIBUTE5                                     AS CELL_MODEL
         , S.END_CUSTOMER
         , S.SOLDTO_CUSTOMER
         , I.COUNTRY
         , I.COUNTRY_NAME
         , H.CITY
         , H.CITY_NAME
                                                                                       
         , (SELECT LISTAGG(XA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY XA.USER_NAME_EN)
            FROM  (SELECT DISTINCT ZA.USER_NAME_EN
                   FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                   WHERE  ZA.USER_ID IN (SELECT REGEXP_SUBSTR(F.OWNER, '[^,]+', 1, LEVEL)
                                         FROM   DUAL
                                         CONNECT BY LEVEL <= NVL(REGEXP_COUNT(F.OWNER, ','), 0) + 1)) XA
           )                                                AS OWNER
         , J.USER_NAME_EN                                   AS PROJECT_OWNER
         , J.USER_ID
         , T2.ITEM_NAME
         , T2.ITEM_TYPE
         , F.CUST_GROUP
         , F.CUST_GROUP_DTL
         , F.APPLICATION
         , F.ROUTE
         , T2.MDM_PROJECT_NAME
         , T2.MIN_CAPACITY
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                ELSE T2.FORECAST_INFO_BIZ_TYPE END          AS FORECAST_INFO_BIZ_TYPE
         , T2.FORECAST_INFO_PRODUCT_GROUP
         , LOOK.NAME                                        AS CELL_TYPE
         , CASE WHEN F.ITEM_ID = LOOKA.MODEL
                THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT DEFAULT NULL ON CONVERSION ERROR)
                ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END   AS FORECAST_INFO_CELL_PACK_COUNT
         , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL
         , T2.FORECAST_INFO_SPEC                            AS FORECAST_INFO_SPEC
         , T2.FORECAST_INFOR_VERSION                        AS FORECAST_INFOR_VERSION
         , T4.NICK_NAME                                     AS CELL_MODEL_NICK_NAME                                                  
         , S.VMI_YN
         , F.ATTRIBUTE1                                     AS DMS_SALES                                                             
         , F.ATTRIBUTE2                                     AS DMS_CUSTOMER                                                          
         , TEAM.DEPT_ID
         , TEAM.DEPT_NAME_KO
         , F.VALID_YN                                       AS ITEM_VALID_YN
    FROM   SCM_MGR.SCM_MST_SITE_ITEM F
    INNER JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T2
        ON  F.DIVISION_ID = T2.DIVISION_ID
        AND F.ITEM_ID     = T2.ITEM_ID
    INNER JOIN (SELECT DISTINCT '%' || TOKEN || '%' AS TST
                FROM  (SELECT REGEXP_SUBSTR(p_item_id, '[^,]+', 1, LEVEL) AS TOKEN
                       FROM   DUAL
                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_item_id, ','), 0) + 1)) B
        ON  (F.ITEM_ID LIKE B.TST OR T2.NICK_NAME LIKE B.TST)
    INNER JOIN SCM_MGR.SCM_MST_SITE S
        ON  F.DIVISION_ID = S.DIVISION_ID
        AND F.SCM_SITE_ID = S.SCM_SITE_ID
        AND S.SITE_TYPE   = 'SALES'
    INNER JOIN SCM_MGR.SCM_MST_CITY H
        ON  S.CITY = H.CITY
    INNER JOIN SCM_MGR.SCM_MST_COUNTRY I
        ON  S.COUNTRY = I.COUNTRY
    LEFT JOIN (SELECT B2.USER_ID, B2.USER_NAME, B2.USER_NAME_EN, B2.DEPT_ID, C.DEPT_NAME_KO
               FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B2
               INNER JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO C
                   ON B2.DEPT_ID = C.DEPT_ID) TEAM
                                                                                                  
        ON TEAM.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                               ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
                                                                                     
        ON J.USER_ID = CASE WHEN INSTR(F.OWNER, ',') = 0 THEN F.OWNER
                            ELSE SUBSTR(F.OWNER, 1, INSTR(F.OWNER, ',') - 1) END
    LEFT JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
                                                                                                     
        ON K.DEPT_ID = CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID ELSE F.DEPT_ID END
    LEFT JOIN (SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
               FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
               WHERE  LOOKUP_TYPE = 'CELL_TYPE') LOOK
        ON LOOK.CODE = T2.CELL_TYPE
    LEFT JOIN SCM_MGR.GTT_TEMP_DM_MST_ITEM_SINGLE_V T4
                                                                                      
        ON  T2.DIVISION_ID = T4.DIVISION_ID
        AND T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
    LEFT JOIN (SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
               FROM  (SELECT SEGMENT2 AS MODEL
                           , SEGMENT3 AS BIZ_TYPE
                           , SEGMENT4 AS CELL_PACK_COUNT
                           , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                      WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40'
                      AND    SEGMENT1    = '40') A
               WHERE  A.MODEL_RANK = 1) LOOKA
        ON LOOKA.MODEL = F.ITEM_ID
    WHERE  F.DIVISION_ID = '40'                                                    
                                                                           
    AND    (p_scm_site_id = 'ALL' OR F.SCM_SITE_ID IN (
                SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
    AND    (p_customer = 'ALL' OR F.PROJECT_CODE IN (
                SELECT REGEXP_SUBSTR(p_customer, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_customer, ','), 0) + 1))
    AND    (p_biz_type = 'ALL' OR
                CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                     ELSE T2.FORECAST_INFO_BIZ_TYPE END IN (
                SELECT REGEXP_SUBSTR(p_biz_type, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_biz_type, ','), 0) + 1));
                                                                                                                                   
                                 
                                                                                                                                   
                                                                                                                                                                                                                              

                                                                                                                                   
                                
                                                                                                                                   
    INSERT INTO SCM_MGR.GTT_TEMPSITEITEM
    ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
    , CELL_MODEL, END_CUSTOMER, SOLDTO_CUSTOMER
    , COUNTRY, COUNTRY_NAME, CITY, CITY_NAME
    , OWNER, PROJECT_OWNER, USER_ID, ITEM_NAME, ITEM_TYPE
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME
    , MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
    , CELL_MODEL_NICK_NAME, VMI_YN, DMS_SALES, DMS_CUSTOMER, DEPT_ID, DEPT_NAME_KO
    , ITEM_VALID_YN )
    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME
         , MAX(CELL_MODEL)                     AS CELL_MODEL
         , MAX(END_CUSTOMER)                   AS END_CUSTOMER
         , MAX(SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
         , MAX(COUNTRY)                        AS COUNTRY
         , MAX(COUNTRY_NAME)                   AS COUNTRY_NAME
         , MAX(CITY)                           AS CITY
         , MAX(CITY_NAME)                      AS CITY_NAME
         , MAX(OWNER)                          AS OWNER
         , MAX(PROJECT_OWNER)                  AS PROJECT_OWNER
         , MAX(USER_ID)                        AS USER_ID
         , MAX(ITEM_NAME)                      AS ITEM_NAME
         , MAX(ITEM_TYPE)                      AS ITEM_TYPE
         , MAX(CUST_GROUP)                     AS CUST_GROUP
         , MAX(CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
         , MAX(APPLICATION)                    AS APPLICATION
         , MAX(ROUTE)                          AS ROUTE
         , MAX(MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
         , MAX(MIN_CAPACITY)                   AS MIN_CAPACITY
         , MAX(FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)    AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(CELL_TYPE)                      AS CELL_TYPE
         , MAX(FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
         , MAX(FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
         , MAX(CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
         , MAX(VMI_YN)                         AS VMI_YN
         , MAX(DMS_SALES)                      AS DMS_SALES
         , MAX(DMS_CUSTOMER)                   AS DMS_CUSTOMER
         , MAX(DEPT_ID)                        AS DEPT_ID
         , MAX(DEPT_NAME_KO)                   AS DEPT_NAME_KO
         , MAX(ITEM_VALID_YN)                  AS ITEM_VALID_YN
    FROM   SCM_MGR.GTT_TEMPSITEITEMALL
    GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, NICK_NAME, PROJECT_NAME;
                                                                                                                                   
                                                                                            
                                                                                                                                   
                                                                                                                                                                                                                           
                                                                                                                                   
                                 
                                                                                                                                   

                              
    V_FROM_YYYYMMDD := '';                             
    V_TO_YYYYMMDD   := '';                           
    V_FROM_RESULT   := '';                               
    V_TO_RESULT     := '';                             
    V_USER_TIME_ZONE := '';

    BEGIN
        SELECT U.TIMEZONE
        INTO   V_USER_TIME_ZONE
        FROM   SCM_MGR.TB_FX_USER U
        WHERE  U.USERID = p_created_by;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_USER_TIME_ZONE := NULL;
        WHEN TOO_MANY_ROWS THEN V_USER_TIME_ZONE := NULL;
    END;

                                               
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD)
        INTO   V_FROM_YYYYMMDD
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
             , (SELECT DISTINCT ISO_YYYYWW
                FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                WHERE  1 = 1
                                                                                                 
                AND    BASIS_YYYYMMDD = TO_CHAR(SCM_MGR.FN_MULTY_TIME(V_USER_TIME_ZONE), 'YYYYMMDD')
               ) T
        WHERE  1 = 1
        AND    C.ISO_YYYYWW = T.ISO_YYYYWW;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_YYYYMMDD := NULL;
    END;

                                 
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_FROM_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_from_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_FROM_RESULT := NULL;
    END;

                               
    BEGIN
        SELECT C.BASIS_START_DATE
        INTO   V_TO_RESULT
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M C
        WHERE  1 = 1
        AND    C.BASIS_YYYYMMDD = p_to_yyyymmdd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_TO_RESULT := NULL;
    END;

    IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
                 
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_TO_RESULT   := V_FROM_YYYYMMDD;                        
    ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
                
        V_TO_YYYYMMDD := p_to_yyyymmdd;
        V_FROM_RESULT := '19000101';                                                                   
        V_TO_RESULT   := '19000101';                                                                    
    ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
                  
        V_FROM_YYYYMMDD := '19000101';
        V_TO_YYYYMMDD   := '19000101';
        V_FROM_RESULT   := p_from_yyyymmdd;                          
        V_TO_RESULT     := p_to_yyyymmdd;                        
    ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
                
        V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
        V_FROM_RESULT := p_from_yyyymmdd;
        V_TO_RESULT   := p_to_yyyymmdd;
    END IF;
                              

                                                                                                                                                      
                                
                                                                                                                                                      
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT DISTINCT U.PROGRAM_ID                        AS PROGRAM_ID
         , U.SHEET_NAME                                 AS SHEET_NAME
         , U.USER_ID                                    AS USER_ID
         , U.COLUMN_NAME                                AS MEASURE_GROUP
         , U.COLUMN_NAME                                AS MEASURE
         , NVL(SMSM.ATTRIBUTE5, U.COLUMN_NAME)          AS RESULT_MEASURE                                 
         , TO_CHAR(U.SORT_ORDER_NO)                     AS SORT_ORDER_NO
    FROM   SCM_MGR.SCM_MST_TITLESET_USER U                                                               
    JOIN   SCM_MGR.SCM_MST_SHEET_MEASURE SMSM
        ON  U.PROGRAM_ID                    = SMSM.PROGRAM_ID
        AND U.SHEET_NAME                    = SMSM.SHEET_NAME
        AND U.COLUMN_NAME                   = SMSM.COLUMN_NAME
        AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
        AND SMSM.VALID_YN                   = 'Y'
    WHERE  1 = 1
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
    AND    U.PROGRAM_ID = VA_PROGRAM_ID             
    AND    U.SHEET_NAME = VA_SHEET_NAME                
    AND    U.USER_ID    = p_created_by;

                                                                                                    
                                                                               
                                                                                        
                                                                                                    
    SELECT COUNT(*)
    INTO   V_MEASURE_CNT
    FROM   SCM_MGR.GTT_TEMPSELECTMEASURE A
    WHERE  1 = 1
    AND    A.MEASURE IN ('LOC', 'KRW', 'FCST_GAP');                                                                     

    IF V_MEASURE_CNT > 0 THEN
        INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
        ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
        WITH W_TARGET_MEASURE AS (
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'LOC' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_LOC')
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'KRW' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('RTF_SYS_RP', 'MKT_AMT_KRW')
                                                                                                   
            UNION ALL
            SELECT A.PROGRAM_ID
                 , A.SHEET_NAME
                 , 'FCST_GAP' AS TARGET_MEASURE
                 , A.COLUMN_NAME AS MEASURE_GROUP
                 , A.COLUMN_NAME AS MEASURE
                 , A.COLUMN_NAME AS RESULT_MEASURE
                 , TO_CHAR(A.SORT_ORDER_NO) AS SORT_ORDER_NO
            FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
            WHERE  1 = 1
            AND    A.PROGRAM_ID = VA_PROGRAM_ID
            AND    A.SHEET_NAME = VA_SHEET_NAME
            AND    A.COLUMN_NAME IN ('MKT_FCST', 'SCM_FCST')
                                                                                                 
        )
        SELECT DISTINCT
               W.PROGRAM_ID
             , W.SHEET_NAME
             , 'DM_ADMIN'       AS USER_ID                                                                
             , W.MEASURE_GROUP
             , W.MEASURE
             , W.RESULT_MEASURE
             , W.SORT_ORDER_NO
        FROM   W_TARGET_MEASURE W
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE T
            ON  (W.PROGRAM_ID     = T.PROGRAM_ID
           AND   W.SHEET_NAME     = T.SHEET_NAME
           AND   W.TARGET_MEASURE = T.MEASURE)
        WHERE  1 = 1
        AND    NOT EXISTS (SELECT 1
                           FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                           WHERE  1 = 1
                           AND    X.MEASURE = W.MEASURE);
    END IF;
                                                                                                    
                                                                                      
                                                                                                    

                                                                                                 
                                                         
                                                             
    INSERT INTO SCM_MGR.GTT_TEMPSELECTMEASURE
    ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, RESULT_MEASURE, SORT_ORDER_NO )
    SELECT A.PROGRAM_ID
         , A.SHEET_NAME
         , 'DM_ADMIN'
         , A.COLUMN_NAME AS MEASURE_GROUP
         , A.COLUMN_NAME AS MEASURE
         , A.COLUMN_NAME AS RESULT_MEASURE
         , TO_CHAR(A.SORT_ORDER_NO)
    FROM   SCM_MGR.SCM_MST_SHEET_MEASURE A
    WHERE  1 = 1
    AND    A.PROGRAM_ID  = VA_PROGRAM_ID
    AND    A.SHEET_NAME  = VA_SHEET_NAME
    AND    A.COLUMN_NAME = 'LOC'
    AND    NOT EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMPSELECTMEASURE X
                       WHERE  1 = 1
                       AND    X.MEASURE = A.COLUMN_NAME);
                                                                                               

                                                                                                                                                                                                                                
                                

                                                                                                                                                      
                                                                          
                                                                                                                                                      
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN                                                                

                                                                                                                             
                             
                                                                                    
                                                        
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE                                                    
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_MKT_FCST A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
                                                                                  
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
                               
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL                                               
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE                                                    
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = (CASE WHEN B.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP'
                                        WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                        ELSE B.MEASURE END)
               WHERE  A.DIVISION_ID = p_division_id
                                                                                  
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
                               
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL                                               
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;           
                                         

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
                               
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        ELSE
        INSERT INTO SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY )
        SELECT X.DIVISION_ID, X.PROJECT_CODE, X.SCM_SITE_ID, X.ITEM_ID, X.DOM_EXP, X.FCST_TYPE, X.INCOTERMS, X.MEASURE
             , X.LAST_UPDATE_DATE, X.LAST_UPDATED_BY
        FROM  (SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                    , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD') AS LAST_UPDATE_DATE
                    , A.LAST_UPDATED_BY AS LAST_UPDATED_BY
                    , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
                                         ORDER BY A.LAST_UPDATE_DATE) AS RN
               FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
               INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
                   ON A.MEASURE = B.MEASURE
               WHERE  A.DIVISION_ID = p_division_id
               AND    A.YYYYMMDD >= TO_CHAR(ADD_MONTHS(TO_DATE(p_from_yyyymmdd, 'YYYYMMDD'), -12), 'YYYYMMDD')
               AND    A.YYYYMMDD <= p_to_yyyymmdd
                               
              ) X
        WHERE  X.PROJECT_CODE IS NOT NULL
        AND    X.SCM_SITE_ID  IS NOT NULL
        AND    X.ITEM_ID      IS NOT NULL
        AND    X.RN = 1;
        END IF;           
                                          

                                                                                                                                                                                                                                          
                                                                                                                                                                                                                                          
    END IF;

                                                                                                                                                      
                     
                                                                                                                                                      
    INSERT INTO SCM_MGR.GTT_T_WS_FCST ( FCST_TYPE )
    SELECT SEGMENT1
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'SALES_TYPE_CODE';

                                                                                                                                                                                                                        

                                                                                                                                                      
                                                 
                                                                                                                                                      
    IF UPPER(p_version_type) LIKE '%CURRENT%' THEN

        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                         
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

                                                       
                          
                                       
                                    
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                  
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
                                                                                 
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY                                                 
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
                                                                                                          
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION                                        
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
                                                                                                         
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                                                             
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
                                                           

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                  
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY                                                 
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_MKT_FCST A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER                                            
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                  
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD                                             
                        

        UNION ALL

                                                    
                                                                                                    
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE        
             , A.PLANT_SITE_ID
             , '-' AS CELL_PROD_SITE_ID                                                                                                       
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
                                                                                                                            
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A                                                                    
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        ELSE
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )

                                                       
                          
                                       
                                    
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , CASE WHEN A.MEASURE IN ('MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL') THEN 'MKT_FCST_PP' ELSE A.MEASURE END AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
                                                                                 
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY                                                 
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
                                                                                                          
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION                                        
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON A.MEASURE = (CASE WHEN B.MEASURE IN ('RTF_RP_CAR','RTF_SYS_RP_CAR','RTF_RP_CELL','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF'
                                 WHEN B.MEASURE IN ('RTF_SYS_RP_CAR','RTF_SYS_RP_CELL', 'RTF_ENERGY') THEN 'RTF_SYS_RP'
                            ELSE B.MEASURE END)
                                                                                                         
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                                                             
        AND    (
                   (A.MEASURE <> 'SCM_FCST' AND A.QTY <> 0)
                   OR
                   (A.MEASURE = 'SCM_FCST')
               )
                                                           

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , 'MKT_FCST_PP' AS MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , '-' AS CURRENCY                                                 
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = 'MKT_FCST'
            AND B.MEASURE = 'MKT_FCST_PP'
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
        AND    A.QTY <> 0

        UNION ALL

        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , A.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
             , A.YYYYMMDD
             , NVL(A.PRICE, 0) AS QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
             , A.CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_PRICE LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD                                             
                        

        UNION ALL

                                                    
                                                                                                    
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , B.MEASURE AS MEASURE        
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                                                                      
             , A.YYYYMMDD
             , A.QTY
             , B.MEASURE_GROUP
             , C.CELL_MODEL
             , C.NICK_NAME
             , C.DMS_SALES
             , C.DMS_CUSTOMER
             , C.OWNER
             , C.DEPT_ID
             , C.DEPT_NAME_KO
             , C.FORECAST_INFO_CELL_PACK_COUNT
             , C.ITEM_TYPE
             , C.PROJECT_NAME
             , C.PROJECT_OWNER
             , C.SOLDTO_CUSTOMER
             , C.COUNTRY_NAME
             , C.CITY_NAME
             , C.ITEM_NAME
             , C.VMI_YN
             , C.CUST_GROUP
             , C.CUST_GROUP_DTL
             , C.APPLICATION
             , C.ROUTE
             , C.MDM_PROJECT_NAME
             , C.MIN_CAPACITY
             , C.FORECAST_INFO_BIZ_TYPE
             , C.CELL_TYPE
             , C.FORECAST_INFO_ALL
             , C.FORECAST_INFO_SPEC
             , C.FORECAST_INFOR_VERSION
             , C.CELL_MODEL_NICK_NAME
             , B.SORT_ORDER_NO
             , LD.CREATE_DATE
             , LD.LAST_UPDATED_BY
                                                                                                                            
             , CASE WHEN A.MEASURE LIKE 'VMI%' THEN NULL ELSE A.CURRENCY END AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN A.MEASURE IN ('KRW', 'USD', 'LOC', 'MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.DM_PLN_SALES_PLAN_RESULT A                                                                    
        INNER JOIN SCM_MGR.GTT_TEMPSELECTMEASURE B
            ON  A.MEASURE = B.RESULT_MEASURE
        LEFT JOIN LATERAL (SELECT LD.CREATE_DATE, LD.LAST_UPDATED_BY
                           FROM   SCM_MGR.GTT_T_LAST_DATA_SETUP_FCST LD
                           WHERE  LD.DIVISION_ID = A.DIVISION_ID AND LD.PROJECT_CODE = A.PROJECT_CODE AND LD.SCM_SITE_ID = A.SCM_SITE_ID AND LD.ITEM_ID = A.ITEM_ID
                           AND    LD.DOM_EXP = A.DOM_EXP AND LD.FCST_TYPE = A.FCST_TYPE AND LD.INCOTERMS = A.INCOTERMS AND LD.MEASURE = A.MEASURE
                           ORDER BY LD.CREATE_DATE DESC
                           FETCH FIRST 1 ROWS ONLY) LD ON 1 = 1
        INNER JOIN SCM_MGR.GTT_TEMPSITEITEM C
            ON  A.DIVISION_ID   = C.DIVISION_ID
            AND A.PROJECT_CODE  = C.PROJECT_CODE
            AND A.SCM_SITE_ID   = C.SCM_SITE_ID
            AND A.ITEM_ID       = C.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GTT_T_WS_FCST D
            ON A.FCST_TYPE = D.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    (p_scm_site_id = 'ALL' OR A.SCM_SITE_ID IN (
                    SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                    FROM   DUAL
                    CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
        AND    A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < V_TO_RESULT
        AND    A.QTY <> 0;
        END IF;           

                                                                                                                                  
                                                                                                                    
                                                                                                                                  
        MERGE INTO SCM_MGR.GTT_TEMPFCSTNPRICE A
        USING (SELECT SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID
                    , MAX(SP.CURRENCY) AS CURRENCY
                                                                  
               FROM   SCM_MGR.GTT_TEMPFCSTNPRICE SP                                           
               WHERE  1 = 1
               AND    SP.DIVISION_ID = p_division_id
               AND    (p_scm_site_id = 'ALL' OR SP.SCM_SITE_ID IN (
                           SELECT REGEXP_SUBSTR(p_scm_site_id, '[^,]+', 1, LEVEL)
                           FROM   DUAL
                           CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_scm_site_id, ','), 0) + 1))
               AND    SP.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD
               AND    SP.MEASURE = 'LOC'
               GROUP BY SP.DIVISION_ID, SP.PROJECT_CODE, SP.SCM_SITE_ID, SP.PLANT_SITE_ID, SP.ITEM_ID
                    , SP.INCOTERMS, SP.DOM_EXP, SP.FCST_TYPE, SP.CELL_PROD_SITE_ID) SP
        ON (    A.DIVISION_ID       = SP.DIVISION_ID
            AND A.PROJECT_CODE      = SP.PROJECT_CODE
            AND A.SCM_SITE_ID       = SP.SCM_SITE_ID
            AND A.PLANT_SITE_ID     = SP.PLANT_SITE_ID
            AND A.ITEM_ID           = SP.ITEM_ID
            AND A.INCOTERMS         = SP.INCOTERMS
            AND A.DOM_EXP           = SP.DOM_EXP
            AND A.FCST_TYPE         = SP.FCST_TYPE
            AND A.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID)
        WHEN MATCHED THEN UPDATE
            SET A.CURRENCY = SP.CURRENCY
            WHERE A.YYYYMMDD BETWEEN p_from_yyyymmdd AND V_TO_YYYYMMDD                       
            AND   A.CURRENCY IS NULL                                                                                 
            AND   A.MEASURE NOT LIKE 'VMI%';

                                                                                                                   
                                                        
                                       
                                       
                                                                                                                   
        INSERT INTO SCM_MGR.GTT_TEMPFCSTNPRICE
        ( DIVISION_ID       , PROJECT_CODE                  , END_CUSTOMER           , SCM_SITE_ID            , ITEM_ID              , DOM_EXP            , FCST_TYPE          , INCOTERMS        , MEASURE                 , PLANT_SITE_ID
        , CELL_PROD_SITE_ID , YYYYMMDD                      , QTY                    , MEASURE_GROUP          , CELL_MODEL           , NICK_NAME          , DMS_SALES          , DMS_CUSTOMER     , OWNER                   , DEPT_ID
        , DEPT_NAME_KO      , FORECAST_INFO_CELL_PACK_COUNT , ITEM_TYPE              , PROJECT_NAME           , PROJECT_OWNER
        , SOLDTO_CUSTOMER   , COUNTRY_NAME                  , CITY_NAME
        , ITEM_NAME         , VMI_YN                        , CUST_GROUP             , CUST_GROUP_DTL         , APPLICATION          , ROUTE              , MDM_PROJECT_NAME   , MIN_CAPACITY     , FORECAST_INFO_BIZ_TYPE  , CELL_TYPE
        , FORECAST_INFO_ALL , FORECAST_INFO_SPEC            , FORECAST_INFOR_VERSION , CELL_MODEL_NICK_NAME
        , SORT_ORDER_NO
        , CREATE_DATE       , LAST_UPDATED_BY
        , CURRENCY          , VERSION_NO                    , CUTOFF_YYYYMMDD        , NOTATION )
                                                                                                                
        SELECT A.DIVISION_ID
             , A.PROJECT_CODE
             , A.PROJECT_CODE AS END_CUSTOMER
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.DOM_EXP
             , A.FCST_TYPE
             , A.INCOTERMS
             , D.MEASURE
             , A.PLANT_SITE_ID
             , A.CELL_PROD_SITE_ID                                                     
             , A.YYYYMMDD
                                                    
             , CASE D.MEASURE
                    WHEN 'LOC' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_LOC' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                                         ELSE 0 END
                    WHEN 'KRW' THEN CASE WHEN SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END) <> 0
                                         THEN SUM(CASE WHEN A.MEASURE = 'MKT_AMT_KRW' THEN A.QTY ELSE 0 END)
                                              / SUM(CASE WHEN A.MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
                                         ELSE 0 END
               END AS QTY
             , MAX(D.MEASURE_GROUP) AS MEASURE_GROUP
             , MAX(A.CELL_MODEL) AS CELL_MODEL
             , MAX(A.NICK_NAME) AS NICK_NAME
             , MAX(A.DMS_SALES) AS DMS_SALES
             , MAX(A.DMS_CUSTOMER) AS DMS_CUSTOMER
             , MAX(A.OWNER) AS OWNER
             , MAX(A.DEPT_ID) AS DEPT_ID
             , MAX(A.DEPT_NAME_KO) AS DEPT_NAME_KO
             , MAX(A.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(A.ITEM_TYPE) AS ITEM_TYPE
             , MAX(A.PROJECT_NAME) AS PROJECT_NAME
             , MAX(A.PROJECT_OWNER) AS PROJECT_OWNER
             , MAX(A.SOLDTO_CUSTOMER) AS SOLDTO_CUSTOMER
             , MAX(A.COUNTRY_NAME) AS COUNTRY_NAME
             , MAX(A.CITY_NAME) AS CITY_NAME
             , MAX(A.ITEM_NAME) AS ITEM_NAME
             , MAX(A.VMI_YN) AS VMI_YN
             , MAX(A.CUST_GROUP) AS CUST_GROUP
             , MAX(A.CUST_GROUP_DTL) AS CUST_GROUP_DTL
             , MAX(A.APPLICATION) AS APPLICATION
             , MAX(A.ROUTE) AS ROUTE
             , MAX(A.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
             , MAX(A.MIN_CAPACITY) AS MIN_CAPACITY
             , MAX(A.FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
             , MAX(A.CELL_TYPE) AS CELL_TYPE
             , MAX(A.FORECAST_INFO_ALL) AS FORECAST_INFO_ALL
             , MAX(A.FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
             , MAX(A.FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
             , MAX(A.CELL_MODEL_NICK_NAME) AS CELL_MODEL_NICK_NAME
             , MAX(D.SORT_ORDER_NO) AS SORT_ORDER_NO
             , MAX(A.CREATE_DATE) AS CREATE_DATE
             , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
             , MAX(A.CURRENCY) AS CURRENCY
             , 'CURRENT' AS VERSION_NO
             , NULL      AS CUTOFF_YYYYMMDD
             , CASE WHEN D.MEASURE IN ('KRW', 'USD', 'LOC','MKT_AMT_LOC', 'MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
        FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
        JOIN   SCM_MGR.GTT_TEMPSELECTMEASURE D
            ON D.MEASURE IN ('LOC', 'KRW')
        WHERE  1 = 1
        AND    A.MEASURE IN ('RTF_SYS_RP', 'MKT_AMT_LOC', 'MKT_AMT_KRW')
        AND    A.YYYYMMDD >= p_from_yyyymmdd
        AND    A.YYYYMMDD <  V_TO_RESULT
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
               , A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID
               , A.CELL_PROD_SITE_ID                                                     
               , A.CURRENCY, A.YYYYMMDD, D.MEASURE;
                                                                                                                   
                                                                                                
                                                                                                                   
    END IF;
                                                                                                                                                      
                                                 
                                                                                                                                                      

                                                                                                   
                                                                  
                                                       
                                                                                                   
    DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE A
    WHERE  EXISTS (SELECT 1
                   FROM   SCM_MGR.GTT_TEMPSELECTMEASURE B
                   WHERE  A.MEASURE = B.MEASURE
                   AND    B.USER_ID = 'DM_ADMIN');
                                                                                                   
                                                                
                                                                                                   

                                                                                               
    IF p_plant_site_id IS NOT NULL AND p_plant_site_id <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  PLANT_SITE_ID NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id'));
    END IF;

                                                                                   
                                                                                                  
    IF p_project_code IS NOT NULL AND p_project_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  NVL(PROJECT_CODE, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_project_code'));
    END IF;

    IF p_owner IS NOT NULL AND p_owner <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_TEMPFCSTNPRICE
        WHERE  NVL(OWNER, ' ') NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_owner'));
    END IF;

                                                                                                                                                                                                                             

                                                                                                                                                      
                                                   
                                                                                                                                                      
    V_COLUMN  := '';      
    V_GROUPBY := '';
    V_ORDERBY := '';

    OPEN C_TITLE;
    LOOP
        FETCH C_TITLE INTO V_CUR_PROGRAM_ID, V_CUR_SHEET_NAME, V_CUR_COLUMN_NAME, V_CUR_SORT_ORDER_NO;
        EXIT WHEN C_TITLE%NOTFOUND;                                       
        IF V_COLUMN IS NULL THEN                                                                   
            V_COLUMN  := V_CUR_COLUMN_NAME;
            V_GROUPBY := ' GROUP BY ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := ' ORDER BY SORT_KEY, ' || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN V_CUR_COLUMN_NAME ELSE '' END;
        ELSE
            V_COLUMN  := V_COLUMN  || ', ' || V_CUR_COLUMN_NAME;
            V_GROUPBY := V_GROUPBY || ', ' || V_CUR_COLUMN_NAME;
            V_ORDERBY := V_ORDERBY || CASE WHEN V_CUR_COLUMN_NAME NOT IN ('SORT_KEY','EDIT_FLAG') THEN ', ' || V_CUR_COLUMN_NAME ELSE '' END;
        END IF;
    END LOOP;
    CLOSE C_TITLE;

                                                                         
    V_COLUMN := CASE WHEN V_COLUMN IS NULL THEN 'NOTATION' ELSE V_COLUMN || ',NOTATION' END;                        
                            

    V_GROUPBY := CASE WHEN V_GROUPBY IS NULL THEN ' GROUP BY EDIT_FLAG, SORT_ORDER_NO' ELSE V_GROUPBY || ', EDIT_FLAG, SORT_ORDER_NO' END;
    V_ORDERBY := REPLACE(V_ORDERBY, 'MEASURE_GROUP', ' CAST(SORT_ORDER_NO AS NUMBER(10,2))');                               
    V_ORDERBY := REPLACE(V_ORDERBY, ', MEASURE', '');
                       

                                                                                     
                                        
                                                                                     
    V_GROUP_ID := '';

    SELECT COUNT(1)
    INTO   V_ADMIN_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN = 'Y'
    AND (SEGMENT1 = p_user_group                                               
             OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
    AND    SEGMENT2 = 'ALL';
                                           

    IF NVL(V_ADMIN_CNT, 0) > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
                                                                                     
                                     
                                                                                     

                                                                                                                             
                                                                         
                                               
                                                       
                                                                
                                                                  
                                                                      
                                  
                                                                                                                             
                                                     
                                                                                      
                                                                                                                                  
                                                                                                      
    INSERT INTO SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE
    ( USER_GROUP, DIVISION_ID, MEASURE, DAYS, FROM_TIME, TO_TIME, LIMIT_MEASURE )
    SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM  (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, DT.TOKEN AS DAYS
                , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
                               FROM   DUAL
                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(A.ATTRIBUTE1, ','), 0) + 1) DT
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND (A.SEGMENT1 = p_user_group                                               
             OR A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN (p_user_group, p_created_by) AND G.USE_YN = 'Y'))
           AND    A.SEGMENT2 = VA_PROGRAM_ID
           AND    A.SEGMENT3 = p_division_id
          ) B
    CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) AS TOKEN
                        FROM   DUAL
                        CONNECT BY LEVEL <= NVL(REGEXP_COUNT(B.LIMIT_MEASURE, ','), 0) + 1) LM
    WHERE (REPLACE(B.DAYS, ' ', '') IS NULL
           OR B.DAYS = TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'))                  
    AND   (REPLACE(B.FROM_TIME, ' ', '') IS NULL
           OR B.FROM_TIME <= TO_CHAR(SYSDATE, 'HH24MI'))
    AND   (REPLACE(B.TO_TIME, ' ', '') IS NULL
           OR B.TO_TIME >= TO_CHAR(SYSDATE, 'HH24MI'));

                                                                                                      
    INSERT INTO SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE ( MEASURE, EDIT_FLAG )
    SELECT A.MEASURE
         , CASE WHEN B.MEASURE IS NULL THEN 'N' ELSE 'Y' END AS EDIT_FLAG                                                
    FROM  (SELECT A.SEGMENT4 AS MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND    A.SEGMENT2 = VA_PROGRAM_ID             
           GROUP BY A.SEGMENT4 ) A
    LEFT OUTER JOIN (SELECT B.MEASURE
                     FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                     GROUP BY B.MEASURE ) B
        ON A.MEASURE = B.MEASURE;

                                                                                               
    SELECT COUNT(A.LIMIT_MEASURE)
    INTO   V_LIMIT_CNT
    FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE A
    WHERE  A.LIMIT_MEASURE IS NOT NULL;                                               

    IF V_LIMIT_CNT >= 1 THEN
                                                               
        UPDATE SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
        SET    A.EDIT_FLAG = 'N'
        WHERE  EXISTS (SELECT 1
                       FROM   SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE B
                       WHERE  A.MEASURE = B.LIMIT_MEASURE);
    END IF;

                                                                                 
    DELETE FROM SCM_MGR.GTT_TEMP_INTO_GROUP_MEASURE;
                                                                                      
                                                                                                                             

                                                                                                                                                      
                                
                                                                                                                                                      
    INSERT INTO SCM_MGR.GTT_CAL_MONTH_END_DATE ( MONTH_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY BASIS_YYYYMM;

                               
    INSERT INTO SCM_MGR.GTT_CAL_WEEK_END_DATE ( WEEK_END_DATE )
    SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
    GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME;

                                                                                                                                                      
                                
                                                                                                                                                      
    INSERT INTO SCM_MGR.GTT_MF_SP
    ( DIVISION_ID, SCM_SITE_ID, PLANT_SITE_ID, PROJECT_CODE, ITEM_ID, INCOTERMS, FCST_TYPE, DOM_EXP, MEASURE
    , END_CUSTOMER, NICK_NAME, DMS_SALES, DMS_CUSTOMER
    , YYYYMM, YYYYMMWW, YYYYMMDD, DAYOFWEEK
    , FORECAST_INFO_CELL_MODEL, TEAM_ID, TEAM_NAME_KO
    , ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, OWNER
    , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, ITEM_NAME, VMI_YN, CELL_PROD_SITE_ID
    , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
    , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_CELL_PACK_COUNT
    , FORECAST_INFO_ALL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME
    , QTY, MONTH_END_YN, WEEK_END_YN, EDIT_FLAG
    , SORT_ORDER_NO, MEASURE_GROUP, NEW_FLAG, BUCKET, SORT_KEY
    , LAST_UPDATE_DATE, LAST_UPDATED_BY, NOTATION, CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD
                                                                                       
                                                                        
    , AS_YN, ATTR1, VMI_STD_DIO, BIZ_TYPE, PROJECT_STATUS, ENERGE, CELL_QUANTITY
    , CELL_PER_CAR, CELL_PER_MODULE, MODULE_PER_CAR, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT, AS_FROM_SITE )
    SELECT A.DIVISION_ID
         , A.SCM_SITE_ID
         , A.PLANT_SITE_ID
         , A.PROJECT_CODE
         , A.ITEM_ID
         , A.INCOTERMS
         , A.FCST_TYPE
         , A.DOM_EXP
         , A.MEASURE
         , A.END_CUSTOMER
         , A.NICK_NAME
         , A.DMS_SALES
         , A.DMS_CUSTOMER
         , C.BASIS_YYYYMM  AS YYYYMM
         , C.BASIS_YYYYMM || C.ISO_WEEK AS YYYYMMWW
         , C.BASIS_YYYYMMDD AS YYYYMMDD
         , C.DAYOFWEEK
         , A.CELL_MODEL   AS FORECAST_INFO_CELL_MODEL
         , A.DEPT_ID      AS TEAM_ID
         , A.DEPT_NAME_KO AS TEAM_NAME_KO
         , A.ITEM_TYPE
         , A.PROJECT_NAME
         , A.PROJECT_OWNER
         , A.OWNER
         , A.SOLDTO_CUSTOMER
         , A.COUNTRY_NAME
         , A.CITY_NAME
         , A.ITEM_NAME
         , A.VMI_YN
         , A.CELL_PROD_SITE_ID
         , A.CUST_GROUP
         , A.CUST_GROUP_DTL
         , A.APPLICATION
         , A.ROUTE
         , A.MDM_PROJECT_NAME
         , A.MIN_CAPACITY
         , A.FORECAST_INFO_BIZ_TYPE
         , A.CELL_TYPE
         , A.FORECAST_INFO_CELL_PACK_COUNT
         , A.FORECAST_INFO_ALL
         , A.FORECAST_INFO_SPEC
         , A.FORECAST_INFOR_VERSION
         , A.CELL_MODEL_NICK_NAME
         , CAST(A.QTY AS NUMBER(36,10)) AS QTY
         , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
         , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
         , CASE
               WHEN MA.DEPT_ID IS NOT NULL AND A.MEASURE_GROUP NOT IN ('CUST_FCST_2','CUST_FCST_3','TMM_FCST') AND A.MEASURE = M1.SEGMENT3                           
                   THEN 'Y'
               WHEN (V_GROUP_ID = 'ADMIN') AND A.MEASURE_GROUP <> 'TMM_FCST' AND A.MEASURE = M1.SEGMENT3                               
                   THEN 'Y'
               ELSE 'N'
           END AS EDIT_FLAG
         , A.SORT_ORDER_NO                                                            
         , A.MEASURE_GROUP                                                            
         , 'N' AS NEW_FLAG
         , NVL(BK.BUCKET, '0000000') AS BUCKET
         , 999 AS SORT_KEY
         , CASE WHEN A.CREATE_DATE     IS NULL THEN ' ' ELSE A.CREATE_DATE END     AS LAST_UPDATE_DATE                                        
         , CASE WHEN A.LAST_UPDATED_BY IS NULL THEN ' ' ELSE A.LAST_UPDATED_BY END AS LAST_UPDATED_BY
         , A.NOTATION
         , A.CURRENCY
         , A.VERSION_NO
         , A.CUTOFF_YYYYMMDD
                                                                               
         , NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   SCM_MGR.GTT_TEMPFCSTNPRICE A
    INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
        ON C.BASIS_YYYYMMDD = A.YYYYMMDD
                                                                                                                                                
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_MONTH_END_DATE C2
        ON A.YYYYMMDD = C2.MONTH_END_DATE
    LEFT OUTER JOIN SCM_MGR.GTT_CAL_WEEK_END_DATE C3
        ON A.YYYYMMDD = C3.WEEK_END_DATE
                                                                                                                      
    LEFT JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M1                                                             
        ON  A.DIVISION_ID  = M1.SEGMENT2                                                                                                                    
        AND A.MEASURE      = M1.SEGMENT3            
        AND M1.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
        AND M1.SEGMENT1    = 'DMF0082'
        AND M1.ATTRIBUTE2  = 'Y'                       
        AND M1.VALID_YN    = 'Y'                        
    LEFT OUTER JOIN (
                                                                                                                   
        SELECT PVT.DIVISION_ID, PVT.SCM_SITE_ID, PVT.INCOTERMS
             , TO_CHAR(NVL(PVT.SUN,0)) || TO_CHAR(NVL(PVT.MON,0)) || TO_CHAR(NVL(PVT.TUE,0)) || TO_CHAR(NVL(PVT.WED,0))
               || TO_CHAR(NVL(PVT.THU,0)) || TO_CHAR(NVL(PVT.FRI,0)) || TO_CHAR(NVL(PVT.SAT,0)) AS BUCKET
        FROM  (SELECT DIVISION_ID, SCM_SITE_ID, INCOTERMS, YYYYMMDD
                    , CASE WHEN BUCKET_PER = 'Y' THEN 1 ELSE 0 END AS BUCKET_PER
               FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION
               WHERE  DIVISION_ID = p_division_id)
        PIVOT ( MAX(BUCKET_PER) FOR YYYYMMDD IN ('SUN' AS SUN, 'MON' AS MON, 'TUE' AS TUE, 'WED' AS WED, 'THU' AS THU, 'FRI' AS FRI, 'SAT' AS SAT) ) PVT
    ) BK
        ON  A.DIVISION_ID = BK.DIVISION_ID
        AND A.SCM_SITE_ID = BK.SCM_SITE_ID
        AND A.INCOTERMS   = BK.INCOTERMS
               
    LEFT OUTER JOIN (
        SELECT LOOK.SEGMENT3 AS DEPT_ID
        FROM   SCM_MGR.TB_FX_USER USR
        INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
            ON USR.DEPT_ID = LOOK.SEGMENT1 AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING' AND LOOK.VALID_YN = 'Y'
        WHERE  USR.USERID = p_created_by
        UNION              
        SELECT DEPT_ID
        FROM   SCM_MGR.TB_FX_USER
        WHERE  USERID = p_created_by
    ) MA
        ON A.DEPT_ID = MA.DEPT_ID
    WHERE  1 = 1
    AND    (p_team_id = 'ALL' OR A.DEPT_ID IN (
                SELECT REGEXP_SUBSTR(p_team_id, '[^,]+', 1, LEVEL)
                FROM   DUAL
                CONNECT BY LEVEL <= NVL(REGEXP_COUNT(p_team_id, ','), 0) + 1));
                                       

                                                                                                                  
    IF p_sender_code IS NOT NULL AND p_sender_code <> 'ALL' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP
        WHERE  NVL(SENDER_CODE, ' ') <> ' '
        AND    SENDER_CODE NOT IN (
                   SELECT TOKEN
                   FROM   (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_sender_code'));
    END IF;

                                                                            
    IF p_division_id = '82' THEN
        UPDATE SCM_MGR.GTT_MF_SP SET EDIT_FLAG = 'N';
    END IF;

                                                                                                                                                                                                                    

                                                              
    IF p_qty_yn = 'Y' THEN
        DELETE FROM SCM_MGR.GTT_MF_SP SP
        WHERE  NOT EXISTS (SELECT 1
                           FROM  (SELECT DIVISION_ID
                                       , SCM_SITE_ID
                                       , PROJECT_CODE
                                       , ITEM_ID
                                       , INCOTERMS
                                       , FCST_TYPE
                                       , DOM_EXP
                                       , END_CUSTOMER
                                       , CELL_PROD_SITE_ID
                                  FROM   SCM_MGR.GTT_MF_SP
                                  WHERE  MEASURE IN ('MKT_FCST','SCM_FCST')                                                                      
                                  GROUP BY DIVISION_ID
                                         , SCM_SITE_ID
                                         , PROJECT_CODE
                                         , ITEM_ID
                                         , INCOTERMS
                                         , FCST_TYPE
                                         , DOM_EXP
                                         , END_CUSTOMER
                                         , CELL_PROD_SITE_ID
                                  HAVING SUM(QTY) <> 0
                                 ) TT
                           WHERE  1 = 1
                           AND    TT.DIVISION_ID       = SP.DIVISION_ID
                           AND    TT.SCM_SITE_ID       = SP.SCM_SITE_ID
                           AND    TT.PROJECT_CODE      = SP.PROJECT_CODE
                           AND    TT.ITEM_ID           = SP.ITEM_ID
                           AND    TT.INCOTERMS         = SP.INCOTERMS
                           AND    TT.FCST_TYPE         = SP.FCST_TYPE
                           AND    TT.DOM_EXP           = SP.DOM_EXP
                           AND    TT.END_CUSTOMER      = SP.END_CUSTOMER
                           AND    TT.CELL_PROD_SITE_ID = SP.CELL_PROD_SITE_ID
                          );
    END IF;

                                                                                                                                                      
                                                                                        
                                                                                                                                                      
    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC2 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC3 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC4 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RC5 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS RESULT_CODE, 'NO_BUCKET_DATA' AS RESULT_MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

                                                                                                                                                      
                                                                           
                                                                                                                                                      
    DBMS_LOB.CREATETEMPORARY(V_SQL_TEXT, TRUE);

    V_SQL_TEXT := '
    SELECT [@V_COLUMN], SORT_ORDER_NO, [@V_PV_COL_LIST]
    FROM (      SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
                FROM   SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') ) --[PJ2025-50188] FCST Gap 메저 추가 (MKT FCST - SCM FCST)
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv'' ) AND F.WEEK_END_YN = ''Y'' THEN  SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW, F.WEEK_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Weekly Sum 에서 LOC,KRW,USD 는 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''W_'' || F.YYYYMMWW AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE  IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMMWW

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , CASE WHEN F.MEASURE IN (''BALANCE'', ''VMI_Inv'', ''AS_Inv''  ) AND F.MONTH_END_YN = ''Y'' THEN SUM (F.QTY)
                               ELSE SUM(F.QTY)
                            END AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE NOT IN  (''KRW'', ''USD'', ''LOC''  ) -- LOC는 하단에서 별도 조회 [PJ2025-50188] 실적 Unit Price 로직 변경
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 START
                AND (
                        (F.MEASURE NOT IN (''SCM_FCST'', ''FCST_GAP'') AND F.QTY <> 0)
                        OR
                        (F.MEASURE IN (''SCM_FCST'', ''FCST_GAP'') )
                    )
                --[PJ2025-50188]SCM_FCST가 0인 대상도 조회 가능하도록 로직 수정 END
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM, F.MONTH_END_YN, F.MEASURE

                -------------------------------------------------------------------------------
                -- [PJ2025-50188] 실적 Unit Price 로직 변경 : Monthly Sum 에서 LOC,KRW,USD 는 월 마지막 일자와 상관없이 일자 전체 평균값으로 보이도록 소스 분리
                -------------------------------------------------------------------------------

                UNION ALL

                SELECT [@V_COLUMN], F.SORT_ORDER_NO, ''M_'' || F.YYYYMM AS YYYYMMDD
                        , AVG(QTY) AS QTY
                FROM SCM_MGR.GTT_MF_SP F
                WHERE 1=1
                  AND F.MEASURE IN  (''KRW'', ''USD'', ''LOC''  )
                GROUP BY [@V_COLUMN], F.SORT_ORDER_NO, F.YYYYMM
        )
    PIVOT (SUM(QTY) FOR YYYYMMDD IN ( [@V_PV_LIST] )) PVT
    [@V_ORDERBY]
    ';
                                                      

                                                                                   
                                                                                                
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_PV_LIST]',     V_PV_LIST);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_COLUMN]',      V_COLUMN);
    V_SQL_TEXT := REPLACE(V_SQL_TEXT, '[@V_ORDERBY]',     V_ORDERBY);

                               
                                                            

                       
    OPEN O_RC1 FOR V_SQL_TEXT;

    BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;

                                                                                                                                                      
                       
                                                                                                                   
                                                                             
                                                             
                                                                                                                   
    OPEN O_RC2 FOR
        SELECT MONTH_NAME, ISO_WEEK
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
                                                                         
        WHERE  BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(SYSDATE, 3), 'YYYYMM')
        ORDER BY BASIS_YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;                     

                                                                                                                                                      
                               
                                                                                                                                                      
    OPEN O_RC3 FOR
        SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM
             , A.ISO_WEEK
        FROM  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')                                                        
              ) A
        JOIN  (SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')                                            
              ) B ON 1 = 1;

                                                                                                                                                      
                                       
                                                                                          
                                                                                             
                                                                                              
                                                                                                                                                      
                                                                           
                                                                                            
                                                                         
                                                                   
                                                                     
                                                                   
    OPEN O_RC4 FOR
        SELECT A.MEASURE
             , A.EDIT_FLAG              AS EDIT_AUTH_YN
             , CAST(NULL AS VARCHAR2(1))   AS TODAY_LIMIT_YN
             , CAST(NULL AS VARCHAR2(100)) AS TODAY_DAY_LIST
        FROM   SCM_MGR.GTT_TEMP_ADMIN_GROUP_MEASURE A
        ORDER BY A.MEASURE;
                                                                                           
                                                                                        

                                                                                                                                                      
                        
                                                              
                                                                                                                                                      
    OPEN O_RC5 FOR
        SELECT BASIS_YYYYMMDD                                                   
             , BASIS_YYYYMM                                                   
                                                           
             , CASE WHEN SUBSTR(BASIS_START_DATE, -2) = '01' THEN 'Y' ELSE 'N' END AS FIRST_WEEK_FLAG                             
                                                                                                                            
             , CASE WHEN SUBSTR(TO_CHAR(TO_DATE(BASIS_START_DATE, 'YYYYMMDD') + 7, 'YYYYMMDD'), 1, 6)           
                         =
                         SUBSTR(BASIS_START_DATE, 1, 6)                                                                          
                    THEN 'N' ELSE 'Y' END AS END_MONTH_FLAG                                             
             , COUNT(*) OVER (PARTITION BY BASIS_YYYYMM) AS MONTH_DAY_CNT                                             
             , COUNT(*) OVER (PARTITION BY ISO_YYYYWW || PARTIAL_WEEK_NAME) AS WEEK_DAY_CNT                           
             , ISO_YYYYWW                      
        FROM   SCM_MGR.SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
        ORDER BY BASIS_YYYYMMDD;
                                                            

                                                                                                                                                      
                                  
                                                                                                                                                      
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN
        SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, p_created_by);
    EXCEPTION WHEN OTHERS THEN NULL; END;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT);    EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;
        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        BEGIN
            SCM_MGR.PR_DM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', N_LOG_COUNT
              , '########## FAIL END of procedure ##########', V_DESCRIPTION
              , SYSDATE, p_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
        EXCEPTION WHEN OTHERS THEN NULL; END;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);

END P_DMF0082_GET_MAIN_DATA_CURRENT;


PROCEDURE P_DMF0082_GET_SPREAD_TITLE 
(
    p_start_yyyymmdd  IN VARCHAR2,
    p_end_yyyymmdd    IN VARCHAR2,
	p_created_by	  IN VARCHAR2,
	p_division_id	  IN VARCHAR2,
	O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS

    v_user_col_cnt INTEGER;
    v_program_id VARCHAR2(4000 CHAR);
    v_sheet_name VARCHAR2(4000 CHAR);
BEGIN




	v_program_id := 'DMF0082';
	v_sheet_name := 'FcstNPrice';
	v_user_col_cnt := 0;

	SELECT COUNT(*)
  INTO v_user_col_cnt
	FROM   SCM_MST_TITLESET_USER U
	WHERE  1 = 1
	AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_ID    = p_created_by;


	IF v_user_col_cnt > 0 THEN
		OPEN O_RESULT_CURSOR FOR
		SELECT U.PROGRAM_ID
				, U.SHEET_NAME
				, U.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, U.SORT_ORDER_NO                                                    
				, U.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
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
		FROM   SCM_MST_TITLESET_USER U
				, SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    U.PROGRAM_ID  = C.PROGRAM_ID
		AND    U.SHEET_NAME  = C.SHEET_NAME
		AND    U.COLUMN_NAME = C.COLUMN_NAME
		AND    U.PROGRAM_ID  = v_program_id
		AND    U.SHEET_NAME  = v_sheet_name
		AND    U.USER_ID     = p_created_by
		AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
		AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		                       
		UNION ALL
		SELECT C.PROGRAM_ID
				, C.SHEET_NAME
				, C.COLUMN_NAME
				, C.COLUMN_LABEL_NAME
				, C.SORT_ORDER_NO                                                   
				, C.DATA_SORT_METHOD_CODE
				, C.SMALL_CLASS_LABEL_NAME
				, C.LARGE_CLASS_LABEL_NAME
				, '' AS DAY_CODE
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
		FROM   SCM_MST_SHEET_COLUMNS C
		WHERE  1 = 1
		AND    C.PROGRAM_ID  = v_program_id
		AND    C.SHEET_NAME  = v_sheet_name
		AND    C.VISIBLE_FLAG = 'N'
		AND    C.DEFAULT_FLAG IS NULL
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		                       

		UNION ALL

		SELECT v_program_id   AS PROGRAM_ID
				, v_sheet_name AS SHEET_NAME
				, T.COLUMN_NAME
				, T.COLUMN_LABEL_NAME
				, T.SORT_ORDER_NO
				, ''         AS DATA_SORT_METHOD_CODE
				, T.SMALL_CLASS_LABEL_NAME
				, T.LARGE_CLASS_LABEL_NAME
				, T.DAY_CODE
				, ''         AS FIXED_FLAG
				, 90         AS COLUMN_WIDTH
				, T.CELL_CONTROL_OBJECT_TYPE_CODE                                                
				, ''         AS CELL_COMBO_DATA_TYPE
				, 3         AS DATA_SCALE_NUMBER                   
				, 0         AS DATA_MAX_LENGTH
				, 'R'        AS HORIZONTAL_ALIGN_CODE
				, 'Y'        AS UPPERCASE_APPLY_FLAG
				, 'Y'        AS VISIBLE_FLAG
				, ''         AS DEFAULT_FLAG
				, ''         AS USER_SELECTABLE_FLAG
				, ''         AS VALID_YN
				, ''			AS DIVISION_ID
		FROM  (
				SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
					, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
					, A.DAYOFWEEK               AS DAY_CODE
					, CAST(A.BASIS_YYYYMMDD || '31' AS NUMBER(10,0)) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
				AND    A.basis_yyyymmdd <= p_end_yyyymmdd                                                             
				                                                    
				           
				                                                 
				                                                   
				                                                                        
				                                                                  
				                                                                
				                                                        
				                                          
				                                                    
				                                              
				                             
				                                                                                      
				                                                                                                        
				UNION ALL
				SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	           
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
					, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
					, ''                   AS DAY_CODE
					, CAST(A.BASIS_START_DATE || '21' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM   SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd                                                             
				GROUP BY A.BASIS_YYYYMM
						, A.ISO_WEEK
						, A.WEEK_NAME
						, PARTIAL_WEEK_NAME	           
						, A.MONTH_NAME
						, A.BASIS_START_DATE
				                                                    
				           
				                                                             
				                                                                        
				                                                                  
				                                                         
				                                                                        
				                                                                  
				                                                           
				                                                    
				                                      
				                                                      
				                                              
				                             
				                                                                                      
				                                                                                                        
				                         
				                
				                 
				                                   
				                  
				                        
				UNION ALL
				SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
						, A.MONTH_NAME          AS COLUMN_LABEL_NAME
						, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
						, ''                    AS DAY_CODE
						, CAST(MIN(A.BASIS_START_DATE) || '01' AS NUMBER(10, 0)) AS SORT_ORDER_NO
						, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
				FROM    SCM_SYS_CALENDAR_M A
				WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
				AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd                                                             
				GROUP BY A.BASIS_YYYYMM
						, A.MONTH_NAME
				                                                    
				           
				                                               
				                                            
				                                                
				                                                
				                                        
				                                                            
				                                               
				                              
				                                                                                      
				                                                                                                        
				                         
				                  
				                        
			) T
		  ORDER BY SORT_ORDER_NO   ;
	  ELSE
			OPEN O_RESULT_CURSOR FOR
			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO                                                   
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.DEFAULT_FLAG = 'Y'
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		                       

			UNION ALL

			SELECT C.PROGRAM_ID
					, C.SHEET_NAME
					, C.COLUMN_NAME
					, C.COLUMN_LABEL_NAME
					, C.SORT_ORDER_NO                                                   
					, C.DATA_SORT_METHOD_CODE
					, C.SMALL_CLASS_LABEL_NAME
					, C.LARGE_CLASS_LABEL_NAME
					, '' AS DAY_CODE
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
			FROM   SCM_MST_SHEET_COLUMNS C
			WHERE  1 = 1
			AND    C.PROGRAM_ID  = v_program_id
			AND    C.SHEET_NAME  = v_sheet_name
			AND    C.VISIBLE_FLAG = 'N'
			AND    C.DEFAULT_FLAG IS NULL
			AND    C.VALID_YN     = 'Y'
			AND	 p_division_id IN (SELECT token FROM TABLE(SCM_MGR.UF_FX_STRING_SPLIT(C.DIVISION_ID ,',')) )		                       

			UNION ALL

			SELECT v_program_id   AS PROGRAM_ID
					, v_sheet_name AS SHEET_NAME
					, T.COLUMN_NAME
					, T.COLUMN_LABEL_NAME
					, T.SORT_ORDER_NO
					, ''         AS DATA_SORT_METHOD_CODE
					, T.SMALL_CLASS_LABEL_NAME
					, T.LARGE_CLASS_LABEL_NAME
					, T.DAY_CODE
					, ''         AS FIXED_FLAG
					, 90         AS COLUMN_WIDTH
					, 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
					, ''         AS CELL_COMBO_DATA_TYPE
					, 0         AS DATA_SCALE_NUMBER
					, 0         AS DATA_MAX_LENGTH
					, 'R'        AS HORIZONTAL_ALIGN_CODE
					, 'Y'        AS UPPERCASE_APPLY_FLAG
					, 'Y'        AS VISIBLE_FLAG
					, ''         AS DEFAULT_FLAG
					, ''         AS USER_SELECTABLE_FLAG
					, ''         AS VALID_YN
					, ''			AS DIVISION_ID
			FROM  (
					SELECT 'D_'  ||  A.BASIS_YYYYMMDD   AS COLUMN_NAME
						, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END               AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
						, A.DAYOFWEEK               AS DAY_CODE
						, CAST(A.BASIS_YYYYMMDD || '31' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
					AND    A.basis_yyyymmdd <= p_end_yyyymmdd                                                             
					                                                    
					           
					                                                 
					                                                   
					                                                                        
					                                                                 
					                                                               
					                                                        
					                                          
					                                                    
					                             
					                                                                                      
					                                                                                                        
					UNION ALL
					SELECT 'W_'  ||  A.BASIS_YYYYMM  ||  A.ISO_WEEK   AS COLUMN_NAME
						, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END AS COLUMN_LABEL_NAME	           
					, CASE WHEN INSTR(PARTIAL_WEEK_NAME, 'A') <> 0 THEN A.WEEK_NAME  ||  '+'
						WHEN INSTR(PARTIAL_WEEK_NAME, 'B') <> 0 THEN '+'  ||  A.WEEK_NAME
						ELSE A.WEEK_NAME END          AS SMALL_CLASS_LABEL_NAME
						, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
						, ''                   AS DAY_CODE
						, CAST(A.BASIS_START_DATE || '21' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM   SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd                                                             
					GROUP BY A.BASIS_YYYYMM
							, A.ISO_WEEK
							, A.WEEK_NAME
							, PARTIAL_WEEK_NAME	           
							, A.MONTH_NAME
							, A.BASIS_START_DATE
					                                                    
					           
					                                                             
					                                                                        
					                                                                 
					                                                        
					                                                                       
					                                                                 
					                                                          
					                                                    
					                                      
					                                                      
					                             
					                                                                                      
					                                                                                                        
					                         
					                
					                 
					                                   
					                  
					                        
					UNION ALL
					SELECT 'M_'  ||  A.BASIS_YYYYMM  AS COLUMN_NAME
							, A.MONTH_NAME          AS COLUMN_LABEL_NAME
							, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
							, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
							, ''                    AS DAY_CODE
							, CAST(MIN(A.BASIS_START_DATE) || '01' AS NUMBER(10, 0)) AS SORT_ORDER_NO
					FROM    SCM_SYS_CALENDAR_M A
					WHERE  A.BASIS_YYYYMMDD >= p_start_yyyymmdd                                         
					AND    A.BASIS_YYYYMMDD <= p_end_yyyymmdd                                                             
					GROUP BY A.BASIS_YYYYMM
							, A.MONTH_NAME
					                                                    
					           
					                                               
					                                            
					                                                
					                                                
					                                        
					                                                            
					                              
					                                                                                      
					                                                                                                        
					                         
					                  
					                        
				) T
			  ORDER BY SORT_ORDER_NO   ;
		  END IF;
END P_DMF0082_GET_SPREAD_TITLE;


PROCEDURE P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP 
                                                                                                                                                                         
(
    p_division_id			IN	VARCHAR2,
	p_dept_id				IN	VARCHAR2,	            
    p_end_customer			IN	VARCHAR2,	             
	p_scm_site_id			IN	VARCHAR2,
	p_plant_site_id			IN	VARCHAR2,
    p_project_code			IN	VARCHAR2,
	p_item_id				IN	VARCHAR2,
	p_customer_project_code	IN	VARCHAR2,
	p_customer_model		IN	VARCHAR2,
	p_from_yyyymmdd			IN	VARCHAR2,
	p_to_yyyymmdd			IN	VARCHAR2,
	p_biztype				IN	VARCHAR2,
	p_created_by			IN	VARCHAR2,
	p_userinfo				IN	VARCHAR2,
	p_owner					IN	VARCHAR2,
	p_over_range	        IN  VARCHAR2,                          
	p_invalid_exec	        IN  VARCHAR2,                                              
	O_CURSOR                OUT SYS_REFCURSOR
)
AS
    v_group_id VARCHAR2(50 CHAR) := NULL;
    p_program_id VARCHAR2(4000 CHAR) := 'DMF0082';		               
    p_valid_yn VARCHAR2(10 CHAR) := 'Y';                                                              
    V_Prod VARCHAR2(32767);
    V_Prod_Cols VARCHAR2(32767);                                                           
    v_nsql VARCHAR2(4000 CHAR);
    v_cnt_1 INTEGER := 0;
	v_to_yyyymmdd2 VARCHAR2(8 CHAR);                                    
BEGIN
                                                                       
                                                                      
                                                                 
                                                 
                                                         
                                                              
    DELETE FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN;
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_division_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_division_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_scm_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_scm_site_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_plant_site_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_plant_site_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_dept_id', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_dept_id, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_end_customer', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_end_customer, ','));
    INSERT INTO SCM_MGR.GT_DMF0082_PARAM_TOKEN (PARAM_NM, TOKEN)
    SELECT 'p_biztype', COLUMN_VALUE FROM TABLE(UF_FX_String_SplitForIN(p_biztype, ','));

                                                   
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

	                                                                       
	           
	                                                                       
                                               
	                        

	                                                                                 
	                                                                     
	                                                                                 
	SELECT COUNT(1)
	INTO v_cnt_1
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
	AND VALID_YN = 'Y'
	AND SEGMENT2 = 'ALL'                                                               
	AND (SEGMENT1 = p_userinfo                                               
	     OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
	                     WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'));

	IF v_cnt_1 > 0 THEN
		v_group_id := 'ADMIN';

		                                                                                
		                                                                   
		                                                                                
  		V_Prod := '';
		v_to_yyyymmdd2 := TO_CHAR(TO_DATE(p_to_yyyymmdd, 'YYYYMMDD') + 7, 'YYYYMMDD');


		                    
		DELETE FROM SCM_MGR.GTT_OVER_RANGE;
		DELETE FROM SCM_MGR.GTT_OVER_RANGE_LIST;
		DELETE FROM SCM_MGR.GTT_DM_MST_ITEM_SINGLE_V;
		DELETE FROM SCM_MGR.GTT_PLAN_DATA;
		DELETE FROM SCM_MGR.GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE;
		DELETE FROM SCM_MGR.GTT_MST_FUTURE_PRICE_SAVE_PRICE;
		DELETE FROM SCM_MGR.GTT_SALES_SITE_MODEL;
		DELETE FROM SCM_MGR.GTT_SALES_SITE_MODEL_ALL;


		                                              
		IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                             
		INSERT INTO GTT_OVER_RANGE (
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			YYYYMMDD,
			CELL_PROD_SITE_ID
		)
		SELECT
			DISTINCT AA.DIVISION_ID,
			AA.PROJECT_CODE,
			AA.SCM_SITE_ID,
			AA.PLANT_SITE_ID,
			AA.ITEM_ID,
			AA.CURRENCY,
			AA.MEASURE,
			AA.DOM_EXP,
			AA.FCST_TYPE,
			AA.INCOTERMS,
			AA.YYYYMMDD,
			AA.CELL_PROD_SITE_ID
		FROM (
			        
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID,                
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN
			                              
			FROM SCM_MST_FUTURE_PRICE A                         
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
		) AA
		LEFT OUTER JOIN (
			                  
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID, CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID,                
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ORDER BY YYYYMMDD) AS RN
			                              
			FROM SCM_MST_FUTURE_PRICE A                         
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
		) BB
			ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
			AND AA.CURRENCY = BB.CURRENCY
			AND AA.MEASURE = BB.MEASURE
			AND AA.DOM_EXP = BB.DOM_EXP
			AND AA.FCST_TYPE = BB.FCST_TYPE
			AND AA.INCOTERMS = BB.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = BB.CELL_PROD_SITE_ID
			AND AA.RN = BB.RN + 1
		LEFT JOIN (
			                              
			SELECT
				A.DIVISION_ID,
				A.PROJECT_CODE,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.ITEM_ID,
				A.CURRENCY,
				A.MEASURE,
				A.DOM_EXP,
				A.FCST_TYPE,
				A.INCOTERMS,
				A.PRICE,
				A.YYYYMMDD,
				'-' AS CELL_PROD_SITE_ID          
			                              
			FROM SCM_MST_FUTURE_PRICE A                         
			JOIN (
				SELECT
					DIVISION_ID,
					PROJECT_CODE,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					ITEM_ID,
					CURRENCY,
					MEASURE,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					'-' AS CELL_PROD_SITE_ID,                
					MAX(YYYYMMDD) AS YMD
				                              
				FROM SCM_MST_FUTURE_PRICE A                         
				WHERE DIVISION_ID = p_division_id
				AND MEASURE = 'LOC'
				AND YYYYMMDD < p_from_yyyymmdd
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
			) B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.YYYYMMDD = B.YMD
		) CC
			ON AA.DIVISION_ID = CC.DIVISION_ID
			AND AA.PROJECT_CODE = CC.PROJECT_CODE
			AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
			AND AA.ITEM_ID = CC.ITEM_ID
			AND AA.CURRENCY = CC.CURRENCY
			AND AA.MEASURE = CC.MEASURE
			AND AA.DOM_EXP = CC.DOM_EXP
			AND AA.FCST_TYPE = CC.FCST_TYPE
			AND AA.INCOTERMS = CC.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = CC.CELL_PROD_SITE_ID
			AND AA.RN = 1
		JOIN (
			SELECT
				SEGMENT1 AS DIVISION_ID,
				SEGMENT2 AS LIMIT
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE  VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
		) L
			ON AA.DIVISION_ID = L.DIVISION_ID
		WHERE
			CASE WHEN AA.RN = 1  AND (AA.PRICE * L.LIMIT) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
		       WHEN AA.RN <> 1 AND (BB.PRICE * L.LIMIT) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
			   ELSE 'N'
		    END = 'Y'
		;
		ELSE
		INSERT INTO GTT_OVER_RANGE (
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			YYYYMMDD,
			CELL_PROD_SITE_ID
		)
		SELECT
			DISTINCT AA.DIVISION_ID,
			AA.PROJECT_CODE,
			AA.SCM_SITE_ID,
			AA.PLANT_SITE_ID,
			AA.ITEM_ID,
			AA.CURRENCY,
			AA.MEASURE,
			AA.DOM_EXP,
			AA.FCST_TYPE,
			AA.INCOTERMS,
			AA.YYYYMMDD,
			AA.CELL_PROD_SITE_ID
		FROM (
			        
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				CELL_PROD_SITE_ID,
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS RN
			                              
			FROM DM_PLN_CFM_SELLING_PRICE A
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
		) AA
		LEFT OUTER JOIN (
			                  
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID, CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				PRICE,
				YYYYMMDD,
				CELL_PROD_SITE_ID,
				ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS RN
			                              
			FROM DM_PLN_CFM_SELLING_PRICE A
			WHERE DIVISION_ID = p_division_id
			AND MEASURE = 'LOC'
			AND YYYYMMDD BETWEEN p_from_yyyymmdd AND v_to_yyyymmdd2
		) BB
			ON AA.DIVISION_ID = BB.DIVISION_ID
			AND AA.PROJECT_CODE = BB.PROJECT_CODE
			AND AA.SCM_SITE_ID = BB.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = BB.PLANT_SITE_ID
			AND AA.ITEM_ID = BB.ITEM_ID
			AND AA.CURRENCY = BB.CURRENCY
			AND AA.MEASURE = BB.MEASURE
			AND AA.DOM_EXP = BB.DOM_EXP
			AND AA.FCST_TYPE = BB.FCST_TYPE
			AND AA.INCOTERMS = BB.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = BB.CELL_PROD_SITE_ID
			AND AA.RN = BB.RN + 1
		LEFT JOIN (
			                              
			SELECT
				A.DIVISION_ID,
				A.PROJECT_CODE,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.ITEM_ID,
				A.CURRENCY,
				A.MEASURE,
				A.DOM_EXP,
				A.FCST_TYPE,
				A.INCOTERMS,
				A.PRICE,
				A.YYYYMMDD,
				A.CELL_PROD_SITE_ID
			                              
			FROM DM_PLN_CFM_SELLING_PRICE A
			JOIN (
				SELECT
					DIVISION_ID,
					PROJECT_CODE,
					SCM_SITE_ID,
					PLANT_SITE_ID,
					ITEM_ID,
					CURRENCY,
					MEASURE,
					DOM_EXP,
					FCST_TYPE,
					INCOTERMS,
					CELL_PROD_SITE_ID,
					MAX(YYYYMMDD) AS YMD
				                              
				FROM DM_PLN_CFM_SELLING_PRICE A
				WHERE DIVISION_ID = p_division_id
				AND MEASURE = 'LOC'
				AND YYYYMMDD < p_from_yyyymmdd
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID
			) B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				AND A.MEASURE = B.MEASURE
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				AND A.YYYYMMDD = B.YMD
		) CC
			ON AA.DIVISION_ID = CC.DIVISION_ID
			AND AA.PROJECT_CODE = CC.PROJECT_CODE
			AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
			AND AA.PLANT_SITE_ID = CC.PLANT_SITE_ID
			AND AA.ITEM_ID = CC.ITEM_ID
			AND AA.CURRENCY = CC.CURRENCY
			AND AA.MEASURE = CC.MEASURE
			AND AA.DOM_EXP = CC.DOM_EXP
			AND AA.FCST_TYPE = CC.FCST_TYPE
			AND AA.INCOTERMS = CC.INCOTERMS
			AND AA.CELL_PROD_SITE_ID = CC.CELL_PROD_SITE_ID
			AND AA.RN = 1
		JOIN (
			SELECT
				SEGMENT1 AS DIVISION_ID,
				SEGMENT2 AS LIMIT
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL
			WHERE  VALID_YN = 'Y'
			AND LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE'
		) L
			ON AA.DIVISION_ID = L.DIVISION_ID
		WHERE
			CASE WHEN AA.RN = 1  AND (AA.PRICE * L.LIMIT) < ABS(CC.PRICE - AA.PRICE) THEN 'Y'
		       WHEN AA.RN <> 1 AND (BB.PRICE * L.LIMIT) < ABS(BB.PRICE - AA.PRICE) THEN 'Y'
			   ELSE 'N'
		    END = 'Y'
		;
		END IF;              



		                                                        
		INSERT INTO GTT_OVER_RANGE_LIST
		SELECT
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			PLANT_SITE_ID,
			ITEM_ID,
			CURRENCY,
			MEASURE,
			DOM_EXP,
			FCST_TYPE,
			INCOTERMS,
			CELL_PROD_SITE_ID,
			REPLACE(NVL(1, NULL),',','')  || NVL(2, NULL)  || NVL(3, NULL)  || NVL(4, NULL) || NVL(5, NULL) || NVL(6, NULL) || NVL(7, NULL) || NVL(8, NULL) || NVL(9, NULL) || NVL(10, NULL)
				 || NVL(11, NULL) || NVL(12, NULL) || NVL(13, NULL) || NVL(14, NULL) || NVL(15, NULL) || NVL(16, NULL) || NVL(17, NULL) || NVL(18, NULL) || NVL(19, NULL) || NVL(20, NULL)
				 || NVL(21, NULL) || NVL(22, NULL) || NVL(23, NULL) || NVL(24, NULL) || NVL(25, NULL) || NVL(26, NULL) || NVL(27, NULL) || NVL(28, NULL) || NVL(29, NULL) || NVL(30, NULL)
				 || NVL(31, NULL) || NVL(32, NULL) || NVL(33, NULL) || NVL(34, NULL) || NVL(35, NULL) || NVL(36, NULL) || NVL(37, NULL) || NVL(38, NULL) || NVL(39, NULL) || NVL(40, NULL)
				 || NVL(41, NULL) || NVL(42, NULL) || NVL(43, NULL) || NVL(44, NULL) || NVL(45, NULL) || NVL(46, NULL) || NVL(47, NULL) || NVL(48, NULL) || NVL(49, NULL) || NVL(50, NULL)
				 || NVL(51, NULL) || NVL(52, NULL) AS COL_LIST
		FROM (
			SELECT
				DIVISION_ID,
				PROJECT_CODE,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				ITEM_ID,
				CURRENCY,
				MEASURE,
				DOM_EXP,
				FCST_TYPE,
				INCOTERMS,
				CELL_PROD_SITE_ID,
				',W_' || YYYYMMDD AS YYYYMMDD,
				ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, CELL_PROD_SITE_ID ORDER BY YYYYMMDD) AS ROW_NUM
			FROM GTT_OVER_RANGE
		) A
		PIVOT (
			MAX(YYYYMMDD) AS UNPVT FOR ROW_NUM IN ( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52 )
		)
		;

	END IF;


	                                                                          

	                                                                  
	INSERT INTO GTT_DM_MST_ITEM_SINGLE_V
	SELECT *
	FROM DM_MST_ITEM_SINGLE_V
	WHERE DIVISION_ID = p_division_id;

	                                            
	IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                             
	INSERT INTO GTT_PLAN_DATA (
		DIVISION_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		PROJECT_CODE,
		ITEM_ID,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		'-' AS CELL_PROD_SITE_ID                
	FROM SCM_MST_FUTURE_PRICE A                         
	WHERE 1 = 1
	AND A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_division_id') P
		WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.TOKEN
	)
	AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') P
		WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.TOKEN
	)
	AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id') P
		WHERE (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.TOKEN
	)
	                                                    
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE B
		WHERE A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND B.VALID_YN = 'Y'
	)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE_ITEM B
		WHERE A.DIVISION_ID	= B.DIVISION_ID
		AND A.PROJECT_CODE = B.PROJECT_CODE
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND A.ITEM_ID = B.ITEM_ID
		AND B.VALID_YN = 'Y'                                                   
	)
	GROUP BY
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP                          
	;
	ELSE
	INSERT INTO GTT_PLAN_DATA (
		DIVISION_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		PROJECT_CODE,
		ITEM_ID,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.CELL_PROD_SITE_ID
	FROM DM_PLN_CFM_SELLING_PRICE A
	WHERE 1 = 1
	AND A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
	AND CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_division_id') P
		WHERE (CASE WHEN p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.TOKEN
	)
	AND CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') P
		WHERE (CASE WHEN p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.TOKEN
	)
	AND CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END IN (
		SELECT *
		FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_plant_site_id') P
		WHERE (CASE WHEN p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.TOKEN
	)
	                                                    
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE B
		WHERE A.DIVISION_ID = B.DIVISION_ID
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND B.VALID_YN = 'Y'
	)
	AND EXISTS(
		SELECT
			B.DIVISION_ID
		FROM SCM_MST_SITE_ITEM B
		WHERE A.DIVISION_ID	= B.DIVISION_ID
		AND A.PROJECT_CODE = B.PROJECT_CODE
		AND A.SCM_SITE_ID = B.SCM_SITE_ID
		AND A.ITEM_ID = B.ITEM_ID
		AND B.VALID_YN = 'Y'                                                   
	)
	GROUP BY
		A.DIVISION_ID,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.PROJECT_CODE,
		A.ITEM_ID,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.CELL_PROD_SITE_ID
	;
	END IF;              

	                                                                                                                                                             

	                                                       
	                                                                                                  
	DELETE FROM SCM_MGR.GT_DMF0082_SP_FILTER;
	INSERT INTO SCM_MGR.GT_DMF0082_SP_FILTER (FILTER_TYPE, FILTER_VALUE)
		SELECT 'PROJECT', TOKEN FROM TABLE(fn_string_split(p_project_code, ','))
		WHERE p_project_code IS NOT NULL AND p_project_code <> 'ALL';
	INSERT INTO SCM_MGR.GT_DMF0082_SP_FILTER (FILTER_TYPE, FILTER_VALUE)
		SELECT 'OWNER', TOKEN FROM TABLE(fn_string_split(p_owner, ','))
		WHERE p_owner IS NOT NULL AND p_owner <> 'ALL';

	                                                                                                        
	                                                                                                            
	DELETE FROM SCM_MGR.GT_DMF0082_PJT;
	INSERT INTO SCM_MGR.GT_DMF0082_PJT (DIVISION_ID, PROJECT_CODE, PROJECT_NAME, PROJECT_OWNER, PROJECT_STATUS, BIZ_TYPE, SCM_SITE_ID, ITEM_ID, DEPT_ID, DEPT_NAME_KO, USER_ID, USER_NAME, USER_NAME_EN)
	SELECT B.DIVISION_ID, B.PROJECT_CODE, B.PROJECT_NAME, B.PROJECT_OWNER, B.PROJECT_STATUS, B.BIZ_TYPE, '', '', '', '', SU.USER_ID, SU.USER_NAME, SU.USER_NAME_EN
	FROM SCM_MST_PROJECT B, SCM_MST_SSO_USER_INFO SU
	WHERE B.DIVISION_ID <> '40' AND B.DIVISION_ID = p_division_id AND UPPER(TRIM(B.PROJECT_OWNER)) = UPPER(TRIM(SU.USER_ID))                                           
	UNION
	SELECT SI.DIVISION_ID, SI.PROJECT_CODE, '', SUBSTR(SI.OWNER,1,20), '', '', SI.SCM_SITE_ID, SI.ITEM_ID, SU.DEPT_ID, TM.DEPT_NAME_KO, SU.USER_ID, SU.USER_NAME, SU.USER_NAME_EN
	FROM SCM_MST_SITE_ITEM SI
		OUTER APPLY (SELECT TOKEN FROM TABLE(fn_string_split(SI.OWNER, ',')) WHERE ROWNUM = 1) OT                                                         
		LEFT JOIN SCM_MST_SSO_USER_INFO SU ON UPPER(TRIM(SU.USER_ID)) = UPPER(TRIM(OT.TOKEN))                           
		LEFT JOIN SCM_MST_SSO_DEPT_INFO TM ON SU.DEPT_ID = TM.DEPT_ID
	WHERE SI.DIVISION_ID = '40' AND p_division_id = '40';
	                                                                                                                     

	                                                                                        
	INSERT INTO GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE (
		DIVISION_ID,
		DIVISION_NAME,
		UPPER_DEPT_ID,
		DEPT_ID,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		SITE_DESCRIPTION,
		END_CUSTOMER,
		                                                                                                                                  
		                                                                                                                 
		PROJECT_CODE,
		PROJECT_NAME,
		BIZ_TYPE_NAME,
		PROJECT_STATUS,
		PROJECT_OWNER,
		ITEM_ID,
		ITEM_CLASS_NAME,
		ITEM_NAME,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		AUTHORITY_YN,
		NICK_NAME,
		CELL_PROD_SITE_ID
	)
	SELECT
		A.DIVISION_ID,
		B.DIVISION_NAME,
   DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
                               
   CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END DEPT_ID,
                                                                                                                                                                             
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   C.SITE_DESCRIPTION,
   NVL(C.END_CUSTOMER, NULL) AS END_CUSTOMER,
   A.PROJECT_CODE,
   PJT.PROJECT_NAME,
   PJT.BIZ_TYPE as BIZ_TYPE_NAME,
                       
   PJT.PROJECT_STATUS,
   PJT.PROJECT_OWNER,
   A.ITEM_ID,
   ITEM.ITEM_CLASS_NAME,
   NVL(ITEM.ITEM_NAME, NULL)AS ITEM_NAME,
   A.INCOTERMS,
                        
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP,
                                    
                         
                                                                                                                    
   CASE WHEN ((FN_GET_DEPT_LIST(p_created_by,
		              
		CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID ELSE TEAM.DEPT_ID END
		) = 'Y') OR v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
                
   ,ITEM.NICK_NAME           
             
   ,A.CELL_PROD_SITE_ID
FROM GTT_PLAN_DATA A
	INNER JOIN SCM_MST_DIVISION B
		ON A.DIVISION_ID = B.DIVISION_ID
		AND B.VALID_YN = 'Y'

	INNER JOIN SCM_MST_SITE C
		ON	A.DIVISION_ID = C.DIVISION_ID
		AND A.SCM_SITE_ID = C.SCM_SITE_ID
		AND C.SITE_TYPE = 'SALES'
		AND C.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SITE D
		ON	A.DIVISION_ID = D.DIVISION_ID
		AND A.SCM_SITE_ID = D.SCM_SITE_ID
		AND C.SITE_TYPE = 'PLANT'
		AND D.VALID_YN = 'Y'

	LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM
                                                                                     
		                                                                                                    
		                                                                                                  
		ON C.DEPT_ID = TEAM.DEPT_ID AND TEAM.VALID_YN = 'Y'                            

	LEFT JOIN SCM_MST_SSO_DEPT_INFO DEPRTMENT
		ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
		AND DEPRTMENT.VALID_YN = 'Y'

	INNER JOIN GTT_DM_MST_ITEM_SINGLE_V ITEM
		ON	A.DIVISION_ID = ITEM.DIVISION_ID
		AND A.ITEM_ID  = ITEM.ITEM_ID
	                                                                                                                         
	LEFT JOIN GT_DMF0082_PJT PJT
		ON	A.DIVISION_ID = PJT.DIVISION_ID
		AND A.PROJECT_CODE = PJT.PROJECT_CODE
		AND CASE WHEN p_division_id = '40' THEN PJT.SCM_SITE_ID ELSE A.SCM_SITE_ID END =  A.SCM_SITE_ID                                
		AND CASE WHEN p_division_id = '40' THEN PJT.ITEM_ID ELSE A.ITEM_ID END = A.ITEM_ID

	LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM  WHERE VALID_YN = 'Y') SITE_ITEM
		ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
		AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
		AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
		AND SITE_ITEM.ITEM_ID = A.ITEM_ID

	LEFT JOIN SCM_MST_SSO_USER_INFO USER_INFO	          
		ON SITE_ITEM.OWNER = USER_INFO.USER_ID
		                                                                                               
			                                                                                           
			INNER JOIN ( SELECT '%' || FILTER_VALUE || '%' tst FROM SCM_MGR.GT_DMF0082_SP_FILTER WHERE FILTER_TYPE = 'PROJECT'
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_project_code IS NULL OR p_project_code = 'ALL') ) b1
			ON      (p_project_code IS NULL OR p_project_code = 'ALL')
			OR      PJT.PROJECT_CODE  like  b1.tst
			OR      PJT.PROJECT_NAME  like  b1.tst
		                                                                                               
	                                                                                           
	                                                                                 
	                                                                                            
	INNER JOIN (
		SELECT
			DISTINCT X.OWNER
		FROM SCM_MST_SITE_ITEM X
		INNER JOIN (
			SELECT '%' || FILTER_VALUE || '%' tst FROM SCM_MGR.GT_DMF0082_SP_FILTER WHERE FILTER_TYPE = 'OWNER'
		) C
			ON (
					FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') LIKE C.tst
					OR
					X.OWNER LIKE C.tst
					OR
					FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') LIKE  C.tst
			)
		WHERE X.DIVISION_ID = p_division_id
		AND NOT (p_owner IS NULL OR p_owner = 'ALL')

		UNION ALL

		SELECT '11' FROM dual
		WHERE (p_owner IS NULL OR p_owner = 'ALL')
	) X
		ON  (p_owner IS NULL OR p_owner = 'ALL')
		OR  NVL(SITE_ITEM.OWNER,'xxxx') = X.owner
	                                                                                               
	            
  
                                    
                                    
                               
                               
                                                                   
                            

      

                                    
                                    
                               
                               
                                                                   
                           
               

	WHERE CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
		ELSE
			CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID
			ELSE TEAM.DEPT_ID END
		END IN (
			SELECT
				*
			FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_dept_id') P
			WHERE (
				CASE WHEN p_dept_id = 'ALL' THEN 'ALL'
				ELSE
					CASE WHEN A.DIVISION_ID = '40' THEN PJT.DEPT_ID
					ELSE TEAM.DEPT_ID END
				END
			) = P.TOKEN
		)
		AND CASE WHEN p_end_customer = 'ALL' THEN 'ALL'
			ELSE NVL(CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END, NULL)
			END IN (
				SELECT
					*
				FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_end_customer') P
				WHERE CASE WHEN p_end_customer = 'ALL' THEN 'ALL' ELSE NVL(CASE WHEN p_division_id <> '40' THEN C.END_CUSTOMER ELSE A.PROJECT_CODE END, NULL) END = P.TOKEN
			)
		AND CASE WHEN p_biztype = 'ALL' THEN 'ALL'            
			ELSE CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
			END IN (
					SELECT
						*
					FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_biztype') P
					WHERE CASE WHEN p_biztype = 'ALL' THEN 'ALL'
						ELSE CASE WHEN p_division_id <> '40' THEN PJT.BIZ_TYPE ELSE FORECAST_INFO_BIZ_TYPE END
						END = P.TOKEN
           )
		GROUP BY
			A.DIVISION_ID,
			B.DIVISION_NAME,
			DEPRTMENT.DEPT_ID,
			TEAM.DEPT_ID,
			PJT.DEPT_ID,
			A.SCM_SITE_ID,
			A.PLANT_SITE_ID,
			C.SITE_DESCRIPTION,
			NVL(C.END_CUSTOMER, NULL),
			A.PROJECT_CODE,
			PJT.PROJECT_NAME,
			PJT.BIZ_TYPE,
			PJT.PROJECT_STATUS,
			PJT.PROJECT_OWNER,
			A.ITEM_ID,
			ITEM.ITEM_CLASS_NAME,
			NVL(ITEM.ITEM_NAME, NULL),
			A.INCOTERMS,
			A.FCST_TYPE,
			A.DOM_EXP,
			A.CURRENCY,
			                      
			                      
			                                                                                                                                   
			             
			ITEM.NICK_NAME,
			A.CELL_PROD_SITE_ID
		;
		                                                                                                                                                                                   


		              

		                      
		IF (p_over_range = 'Y') THEN
		    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                             
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, C.COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			INNER JOIN SCM_MST_FUTURE_PRICE B            
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
			                               
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				                             
			INNER JOIN GTT_OVER_RANGE_LIST C
				ON A.DIVISION_ID = C.DIVISION_ID
				AND A.PROJECT_CODE = C.PROJECT_CODE
				AND A.SCM_SITE_ID = C.SCM_SITE_ID
				AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
				AND A.ITEM_ID = C.ITEM_ID
				AND A.CURRENCY = C.CURRENCY
				                           
				AND A.DOM_EXP = C.DOM_EXP
				AND A.FCST_TYPE = C.FCST_TYPE
				AND A.INCOTERMS = C.INCOTERMS
				AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
				                             
				                                                                                               
			                                                                                                                   
			INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE  b2.tst
				OR A.NICK_NAME  LIKE  b2.tst
				                                                                                               
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
			ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
			;                  
		    ELSE
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, C.COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			INNER JOIN DM_PLN_CFM_SELLING_PRICE B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
			                               
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				                             
			INNER JOIN GTT_OVER_RANGE_LIST C
				ON A.DIVISION_ID = C.DIVISION_ID
				AND A.PROJECT_CODE = C.PROJECT_CODE
				AND A.SCM_SITE_ID = C.SCM_SITE_ID
				AND A.PLANT_SITE_ID = C.PLANT_SITE_ID
				AND A.ITEM_ID = C.ITEM_ID
				AND A.CURRENCY = C.CURRENCY
				                           
				AND A.DOM_EXP = C.DOM_EXP
				AND A.FCST_TYPE = C.FCST_TYPE
				AND A.INCOTERMS = C.INCOTERMS
				AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID
				                             
				                                                                                               
			                                                                                                                   
			INNER JOIN ( SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			             UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE  b2.tst
				OR A.NICK_NAME  LIKE  b2.tst
				                                                                                               
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
			ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
			;                  
		    END IF;              
		ELSE
		    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN                                             
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, '' AS COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			                             
			INNER JOIN SCM_MST_FUTURE_PRICE B            
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				                           
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				                             
				                                                                                               
			                                                                                                                   
			INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			            UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE b2.tst
				OR A.NICK_NAME  LIKE b2.tst
				                                                                                               
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
				ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd;                  
		    ELSE
		    INSERT INTO GTT_MST_FUTURE_PRICE_SAVE_PRICE
			SELECT
				A.DIVISION_ID,
				A.DIVISION_NAME,
				A.UPPER_DEPT_ID,
				A.DEPT_ID	,
				A.SCM_SITE_ID,
				A.PLANT_SITE_ID,
				A.SITE_DESCRIPTION,
				A.END_CUSTOMER,
				A.PROJECT_CODE AS END_CUSTOMER40,
				A.PROJECT_CODE,
				A.PROJECT_NAME,
				A.BIZ_TYPE_NAME,
				A.PROJECT_STATUS,
				A.ITEM_ID,
				A.ITEM_CLASS_NAME,
				A.ITEM_NAME,
				A.INCOTERMS,
				A.CURRENCY,
				A.FCST_TYPE,
				A.DOM_EXP,
				B.MEASURE,
				MEASURE.DISPLAY_SEQ,
				A.AUTHORITY_YN,
				'W_'  ||  B.YYYYMMDD AS YYYYMMDD,
				NVL(B.PRICE,0) AS PRICE
				, A.NICK_NAME
				, A.CELL_PROD_SITE_ID
				, '' AS COL_LIST
			FROM GTT_TMP_MST_FUTURE_PRICE_SAVE_PRICE A
			                             
			INNER JOIN DM_PLN_CFM_SELLING_PRICE B
				ON A.DIVISION_ID = B.DIVISION_ID
				AND A.PROJECT_CODE = B.PROJECT_CODE
				AND A.SCM_SITE_ID = B.SCM_SITE_ID
				AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
				AND A.ITEM_ID = B.ITEM_ID
				AND A.CURRENCY = B.CURRENCY
				                           
				AND A.DOM_EXP = B.DOM_EXP
				AND A.FCST_TYPE = B.FCST_TYPE
				AND A.INCOTERMS = B.INCOTERMS
				AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
				                             
				                                                                                               
			                                                                                                                   
			INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
			            UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL') ) b2
				ON (p_item_id IS NULL OR p_item_id = 'ALL')
				OR A.ITEM_ID  LIKE b2.tst
				OR A.NICK_NAME  LIKE b2.tst
				                                                                                               
			INNER JOIN (
				SELECT
					COLUMN_NAME AS LOOKUP_CODE,
					COLUMN_LABEL_NAME AS DESCRIPTION,
					SORT_ORDER_NO AS DISPLAY_SEQ
				FROM SCM_MST_SHEET_MEASURE
				WHERE (PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice')
			) MEASURE
				ON B.MEASURE = MEASURE.LOOKUP_CODE
			WHERE B.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd;                  
		    END IF;              
		END IF;

		                                                                                               
		                    
		                                               
		          
		                    
		                      
		                      
		                 
		                    
		                      
		                         
		                     
		                                       
		                     
		                     
		                      
		                       
		                
		                        
		                  
		                  
		                 
		                  
		                
		                
		                    
		                     
		                                                                            
		                                   
		                                                   
		                   
		                                                      
		                                          
		                           
		                    
		                      
		                      
		                 
		                    
		                      
		                         
		                     
		                       
		                     
		                     
		                      
		                       
		                
		                        
		                  
		                  
		                 
		                  
		                
		                
		                    
		                     
		                  
		                                                     
		                                                 

	                           
	                                                 

	SELECT LISTAGG('''' || A.YYYYMMDD || ''' AS "' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD)                                                           
	     , LISTAGG('"' || A.YYYYMMDD || '"', ',') WITHIN GROUP (ORDER BY YYYYMMDD)
	INTO V_Prod, V_Prod_Cols
	FROM (
	    SELECT DISTINCT YYYYMMDD FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE
	) A;

	                                           
	IF V_Prod IS NULL THEN
	    V_Prod := '''D_99999999'' AS "D_99999999"'; V_Prod_Cols := '"D_99999999"';                                                           
	END IF;


	                                                                 
	IF p_division_id = '82' AND p_invalid_exec = 'N' THEN

		                                                                  
		INSERT INTO GTT_SALES_SITE_MODEL_ALL                                                         
		( DIVISION_ID, DEPT_ID, END_CUSTOMER, END_CUSTOMER40, SCM_SITE_ID, SCM_SITE_ID40
		, PROJECT_CODE, PROJECT_NAME, PROJECT_STATUS, SALES_PLAN_ADJUST_YN
		, ITEM_CLASS_NAME, ITEM_ID, ITEM_NAME, NICK_NAME, CURRENCY )
		SELECT
			SITE_PROJECT.DIVISION_ID,
			TEAM.DEPT_ID,                                                                                     
			SITE.END_CUSTOMER,
			SITE.END_CUSTOMER AS END_CUSTOMER40,
			SITE_PROJECT.SCM_SITE_ID,
			SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40,
			SITE_PROJECT.PROJECT_CODE,
			PJT.PROJECT_NAME,
			PJT.PROJECT_STATUS,
			SITE_ITEM.SALES_PLAN_ADJUST_YN,
			SITE_ITEM.ITEM_CLASS_NAME,
			SITE_ITEM.ITEM_ID,
			SITE_ITEM.ITEM_NAME,
			SITE_ITEM.NICK_NAME,
			SITE_ITEM.CURRENCY
		FROM (
			SELECT
				DISTINCT A.DIVISION_ID,
				SCM_SITE_ID,
				PROJECT_CODE,
				NVL(MAX(VALID_YN),'Y') AS VALID_YN
			FROM SCM_MST_SITE_ITEM A
			INNER JOIN SCM_MST_ITEM_SN B
				ON A.ITEM_ID = B.ITEM_ID
			GROUP BY A.DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
		) SITE_PROJECT
		LEFT JOIN SCM_MST_PROJECT PJT
			ON SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
			AND	SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
		LEFT JOIN SCM_MST_SITE SITE
			ON SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID
			AND	SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
		LEFT JOIN SCM_MST_SSO_DEPT_INFO TEAM                        
			ON SITE.DEPT_ID = TEAM.DEPT_ID
		LEFT JOIN (
			SELECT
				T1.DIVISION_ID,
				T1.SCM_SITE_ID,
				T1.PROJECT_CODE,
				T1.ITEM_ID,
				T2.ITEM_NAME,
				T2.ITEM_TYPE,
				T2.ITEM_CLASS_NAME,
				T1.SALES_PLAN_ADJUST_YN,
				T2.NICK_NAME,
				T1.CURRENCY,
				T1.VALID_YN,
				T1.OWNER,
				T1.PARTIAL_PLAN_YN                                                                 
			FROM SCM_MST_SITE_ITEM		T1
			INNER JOIN DM_MST_ITEM_SINGLE_V	T2
				ON T1.DIVISION_ID = T2.DIVISION_ID
				AND	T1.ITEM_ID = T2.ITEM_ID
			WHERE (T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
				OR T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END
			)
		) SITE_ITEM
			ON SITE_PROJECT.DIVISION_ID = SITE_ITEM.DIVISION_ID
			AND	SITE_PROJECT.SCM_SITE_ID = SITE_ITEM.SCM_SITE_ID
			AND	SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
		LEFT JOIN SCM_MST_SITE_CUSTOMER SITE_CUST
			ON SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
			AND SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
			AND	SITE_CUST.REP_YN      = 'Y'
		LEFT JOIN SCM_MST_CUSTOMER CUST
			ON SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
			AND SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
			AND	SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
		LEFT JOIN (
			SELECT
				DIVISION_ID,
				MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL,
				SCM_SITE_ID,
				PROJECT_CODE,
				ITEM_ID
			FROM DM_MST_CUSTOMER_MODEL
			WHERE  VALID_YN = 'Y'
			GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
		) CUST_ITEM
			ON SITE_ITEM.ITEM_ID = CUST_ITEM.ITEM_ID
			AND	SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
			AND	SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
			AND SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
		LEFT JOIN SCM_MST_SSO_USER_INFO SU
			ON SITE_ITEM.owner = SU.USER_ID
		INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_item_id,','))
				UNION ALL SELECT '%' tst FROM DUAL WHERE (p_item_id IS NULL OR p_item_id = 'ALL')) b                          
			ON (p_item_id IS NULL OR p_item_id = 'ALL')                  
			OR SITE_ITEM.ITEM_ID   LIKE b.tst
			OR SITE_ITEM.NICK_NAME LIKE b.tst
		INNER JOIN (SELECT '%' || token || '%' tst FROM TABLE(fn_string_split(p_project_code,','))
				UNION ALL SELECT '%' tst FROM DUAL WHERE (p_project_code IS NULL OR p_project_code = 'ALL')) b1                          
			ON (p_project_code IS NULL OR p_project_code = 'ALL')                  
			OR PJT.PROJECT_CODE LIKE b1.tst
			OR PJT.PROJECT_NAME LIKE b1.tst
		INNER JOIN (
			SELECT
				DISTINCT X.OWNER
			FROM SCM_MST_SITE_ITEM X
			LEFT JOIN SCM_MST_SSO_USER_INFO UI
				ON X.PROJECT_CODE = UI.USER_ID
			INNER JOIN ( SELECT '%' || token || '%'                      tst FROM TABLE(fn_string_split(p_owner,',')) ) c
				ON (CASE WHEN p_owner IS NULL THEN p_owner ELSE FN_GET_MULTI_OWNER_NAME(x.OWNER, ',', '1') END like  c.tst
				OR CASE WHEN p_owner IS NULL THEN p_owner ELSE X.OWNER END like  c.tst
				OR CASE WHEN p_owner IS NULL THEN p_owner ELSE FN_GET_MULTI_OWNER_NAME(X.OWNER, ',', '2') END like  c.tst
			)
			WHERE X.DIVISION_ID = p_division_id
			AND p_owner IS NOT NULL AND p_owner <> 'ALL'                                             
			UNION all
			SELECT '11' FROM dual WHERE (p_owner IS NULL OR p_owner = 'ALL')                  
		) X
			ON NVL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN p_owner IS NULL THEN  NVL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner  END
		WHERE  1 = 1                                                                      
		AND CASE WHEN p_division_id = 'ALL' THEN p_division_id
			ELSE SITE_PROJECT.DIVISION_ID
 			END IN (SELECT token FROM TABLE(fn_string_split(p_division_id,',')))
		AND CASE WHEN p_dept_id = 'ALL' THEN p_dept_id
                                                                             
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_dept_id,',')) )
		AND CASE WHEN p_end_customer = 'ALL' THEN p_end_customer
			ELSE SITE.END_CUSTOMER
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_end_customer,',')) )
		AND CASE WHEN p_scm_site_id = 'ALL' THEN p_scm_site_id
			ELSE SITE_PROJECT.SCM_SITE_ID                                                                             
 			END IN ( SELECT token FROM TABLE(fn_string_split(p_scm_site_id,',')) )
		AND SITE.SITE_TYPE <> 'PLANT'
		;


		                                                          
		INSERT INTO GTT_SALES_SITE_MODEL
		SELECT
			DIVISION_ID,
			DEPT_ID,
			END_CUSTOMER,
			END_CUSTOMER40,
			SCM_SITE_ID,
			SCM_SITE_ID40,
			PROJECT_CODE,
			PROJECT_NAME,
			PROJECT_STATUS,
			SALES_PLAN_ADJUST_YN,
			ITEM_CLASS_NAME,
			ITEM_ID,
			ITEM_NAME,
			NICK_NAME,
			CURRENCY,
			B.MEASURE,
			B.DISPLAY_SEQ
		FROM GTT_SALES_SITE_MODEL_ALL a
		CROSS JOIN (
			SELECT
				COLUMN_NAME AS MEASURE,
				COLUMN_LABEL_NAME AS DESCRIPTION,
				SORT_ORDER_NO AS DISPLAY_SEQ
			FROM SCM_MST_SHEET_MEASURE
			WHERE PROGRAM_ID = 'DMF0082'
			AND SHEET_NAME = 'FcstNPrice'
		) b
		;

		v_nsql := '
			SELECT * FROM (   /* 2026.08.13 AJS 인라인뷰 개시 누락 복원 */
			SELECT a.DIVISION_ID,
				b.DIVISION_NAME,
				b.UPPER_DEPT_ID,
				a.DEPT_ID	,
				a.SCM_SITE_ID,
				b.PLANT_SITE_ID,
				b.SITE_DESCRIPTION,
				a.END_CUSTOMER,
				b.END_CUSTOMER40,
				a.PROJECT_CODE,
				a.PROJECT_NAME,
				b.BIZ_TYPE_NAME,
				a.PROJECT_STATUS,
				a.ITEM_ID,
				a.ITEM_CLASS_NAME,
				a.ITEM_NAME,
				b.INCOTERMS,
				(CASE WHEN division_name is null THEN a.CURRENCY
					  ELSE b.CURRENCY
				 END) AS CURRENCY, --[C20200702-000136] ESS사업부 조회 구간 Currency 변경
				b.FCST_TYPE,
				b.DOM_EXP,
				(CASE WHEN division_name is null THEN (
					CASE WHEN ((FN_GET_DEPT_LIST( '''|| p_created_by ||''', a.DEPT_ID ) = ''Y'')  OR '''|| v_group_id ||''' =''ADMIN'') THEN ''Y''
					ELSE ''N''
					END)
				ELSE b.AUTHORITY_YN
				END) AS AUTHORITY_YN,
				a.DISPLAY_SEQ,
				a.NICK_NAME,
				b.CELL_PROD_SITE_ID, /* 2026.08.14 AJS 콤마 누락 */
				b.COL_LIST,
				(CASE WHEN division_name is null THEN ''Y'' ELSE ''N'' END) AS NEW_FLAG,
				a.MEASURE,
				b.PRICE,
				b.YYYYMMDD
			FROM GTT_SALES_SITE_MODEL A
			LEFT JOIN GTT_MST_FUTURE_PRICE_SAVE_PRICE B
				ON ( a.division_id =  b.division_id
					AND a.dept_id = b.dept_id
					AND a.scm_site_id = b.scm_site_id
					AND a.item_id = b.item_id
					AND a.project_code = b.project_code
					AND a.measure = b.measure
				)
			WHERE A.MEASURE = ''LOC''
			) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod || ')
			)
			ORDER BY
				DIVISION_ID,
				division_name,
				DEPT_ID,
				END_CUSTOMER,
				SCM_SITE_ID,
				PROJECT_CODE,
				PROJECT_STATUS,
				BIZ_TYPE_NAME,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				FCST_TYPE,
				DOM_EXP,
				CURRENCY,
				PLANT_SITE_ID,
				CELL_PROD_SITE_ID,
				DISPLAY_SEQ,
				MEASURE,
				COL_LIST --PJ20200138 범위를 초과하는 YYYYMMDD List
		'
		;
		                                                               
	ELSE

		v_nsql := '
			SELECT
				DIVISION_ID,
				DIVISION_NAME,
				UPPER_DEPT_ID,
				DEPT_ID	,
				SCM_SITE_ID,
				PLANT_SITE_ID,
				SITE_DESCRIPTION,
				END_CUSTOMER,
				END_CUSTOMER40,
				PROJECT_CODE,
				PROJECT_NAME,
				BIZ_TYPE_NAME,
				PROJECT_STATUS,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				CURRENCY,
				FCST_TYPE,
				DOM_EXP,
				AUTHORITY_YN,
				DISPLAY_SEQ,
				NICK_NAME,
				CELL_PROD_SITE_ID,
				COL_LIST, --PJ20200138 범위를 초과하는 YYYYMMDD List
				''N'' AS NEW_FLAG,
				MEASURE,
				' || V_Prod_Cols || '
			FROM(
				SELECT
					*
				FROM GTT_MST_FUTURE_PRICE_SAVE_PRICE
				WHERE MEASURE = ''LOC''
			) T
			PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' || v_prod || '))
			ORDER BY
				DIVISION_ID,
				DEPT_ID,
				END_CUSTOMER,
				SCM_SITE_ID,
				PROJECT_CODE,
				PROJECT_STATUS,
				BIZ_TYPE_NAME,
				ITEM_ID,
				ITEM_CLASS_NAME,
				ITEM_NAME,
				INCOTERMS,
				FCST_TYPE,
				DOM_EXP,
				CURRENCY,
				PLANT_SITE_ID,
				CELL_PROD_SITE_ID,
				DISPLAY_SEQ,
				MEASURE,
				COL_LIST --PJ20200138 범위를 초과하는 YYYYMMDD List
			'
			;
	END IF;

              
	OPEN O_CURSOR FOR V_NSQL;



                             
                              



END P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP;


PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE 
(
 p_start_dt      IN VARCHAR2,
 p_end_dt        IN VARCHAR2,
 p_created_by    IN VARCHAR2,
 p_division_id   IN VARCHAR2,
 O_RESULT_CURSOR OUT SYS_REFCURSOR
                                                                                                      
)
AS
    p_program_id VARCHAR2(50 CHAR) := 'DMF0082';
    p_sheet_name VARCHAR2(50 CHAR) := 'Sales Price Save All';
    i_Count INTEGER := 0;
BEGIN
                                                   
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';



    SELECT  Count(*)
  INTO i_Count
    FROM   SCM_MST_TITLESET_USER U
                                    
    WHERE  1 = 1
                                         
                                         
                                          
    AND    U.PROGRAM_ID  = p_program_id
    AND    U.SHEET_NAME  = p_sheet_name
    AND    U.USER_ID     = p_created_by
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

      
                 
 BEGIN
              
  OPEN O_RESULT_CURSOR FOR
  SELECT
     C.PROGRAM_ID
         , C.SHEET_NAME
         , C.COLUMN_NAME
         , C.COLUMN_LABEL_NAME
         , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO                                                  
         , C.DATA_SORT_METHOD_CODE
         , C.SMALL_CLASS_LABEL_NAME
         , C.LARGE_CLASS_LABEL_NAME
   , '' AS DAY_CODE
         , C.FIXED_FLAG
         , C.COLUMN_WIDTH
         , C.CELL_CONTROL_OBJECT_TYPE_CODE
         , C.CELL_COMBO_DATA_TYPE
         , TO_CHAR(C.DATA_SCALE_NUMBER)
         , TO_CHAR(C.DATA_MAX_LENGTH)
         , C.HORIZONTAL_ALIGN_CODE
         , C.UPPERCASE_APPLY_FLAG
         , C.VISIBLE_FLAG
         , C.DEFAULT_FLAG
         , C.USER_SELECTABLE_FLAG
         , C.VALID_YN
                                                    
                                                                                                      
                                  
   , '0' AS SEQ
                        
   FROM SCM_MST_SHEET_COLUMNS C
   WHERE 1 = 1
    AND    C.PROGRAM_ID  = p_program_id
    AND    C.SHEET_NAME  = p_sheet_name
    AND    ( C.DEFAULT_FLAG = 'Y' OR
     (    C.VISIBLE_FLAG = 'N'
     AND    C.DEFAULT_FLAG IS NULL
     AND    C.VALID_YN     = 'Y'
     )
     )
    AND p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )                         
              
  UNION ALL
  SELECT
   p_program_id   AS PROGRAM_ID
   , p_sheet_name AS SHEET_NAME
   , MA.COLUMN_NAME
   , MA.COLUMN_LABEL_NAME
   , MA.SORT_ORDER_NO
   , ''         AS DATA_SORT_METHOD_CODE
   , MA.SMALL_CLASS_LABEL_NAME
   , MA.LARGE_CLASS_LABEL_NAME
   , MA.DAY_CODE
   , ''         AS FIXED_FLAG
   , 120         AS COLUMN_WIDTH
   , MA.CELL_CONTROL_OBJECT_TYPE_CODE                                                
   , ''         AS CELL_COMBO_DATA_TYPE
                                       
   , '3'         AS DATA_SCALE_NUMBER            
   , ''         AS DATA_MAX_LENGTH
   , 'R'        AS HORIZONTAL_ALIGN_CODE
   , 'Y'        AS UPPERCASE_APPLY_FLAG
   , 'Y'        AS VISIBLE_FLAG
   , ''         AS DEFAULT_FLAG
   , ''         AS USER_SELECTABLE_FLAG
   , ''         AS VALID_YN
   , ''   AS DIVISION_ID
  FROM  (
   SELECT
    'W_'  ||  MIN(BASIS_START_DATE)    AS COLUMN_NAME
    , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
    , ''             AS DAY_CODE
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
   FROM SCM_SYS_CALENDAR_M
   WHERE  BASIS_YYYYMMDD >= p_start_dt
    AND    BASIS_YYYYMMDD <= p_end_dt
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

   UNION ALL

   SELECT
    'M_'  ||  MIN(BASIS_START_DATE)    AS COLUMN_NAME
    , SUBSTR(BASIS_START_DATE, 5, 4)  AS COLUMN_LABEL_NAME
    , WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
    , MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
    , ''             AS DAY_CODE
    , MIN(BASIS_START_DATE)      AS SORT_ORDER_NO
    , 'FPNumber'          AS CELL_CONTROL_OBJECT_TYPE_CODE
   FROM SCM_SYS_CALENDAR_M
   WHERE  BASIS_YYYYMMDD >= p_start_dt
    AND BASIS_YYYYMMDD <= p_end_dt
    AND CALENDAR_DAY = '01'
   GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4), MONTH_NAME

  ) MA
  ORDER BY SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_NAME;

                               

 END;
                         
        
                
                       
                    
                     
                           
                                                                          
                               
                                
                                
                      
                    
                      
                                       
                              
                           
                         
                               
                              
                      
                      
                              
                    
                                                     
                                                                                                      
                                  
                
                                  
                               
                
                                       
                                       
                                        
                                       
                                       
                                       
                                                
                                                                                                                 
             
                       
                    
                     
                           
                                                                          
                               
                                
                                
                      
                    
                      
                                       
                              
                           
                         
                               
                              
                      
                      
                              
                  
                
                                  
                
                                       
                                       
                               
                                 
                               
                                                                                                                 
                                 
                
             
          
                                 
                                 
                     
                           
                       
                                          
                                
                                
                  
                               
                                  
                                                                                       
                                         
                                         
                                                   
                                    
                                          
                                         
                                 
                                 
                                         
                             
                          
           
           
                                                    
                                                            
                                                    
                                                    
                                  
                                                   
                                                            
                            
                                        
                                       
                                                                                 

              

           
                                                    
                                                            
                                                    
                                                    
                                  
                                                   
                                                            
                            
                                        
                                    
                             
                                                                                 

        
                                                          
      

END P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE;


PROCEDURE P_DMF0082_SAVE_MAIN_DATA 
(   p_active_flag         IN VARCHAR2
  , p_division_id         IN VARCHAR2
  , p_project_code        IN VARCHAR2
  , p_end_customer        IN VARCHAR2
  , p_scm_site_id         IN VARCHAR2
  , p_item_id             IN VARCHAR2
  , p_dom_exp             IN VARCHAR2
  , p_fcst_type           IN VARCHAR2
  , p_incoterms           IN VARCHAR2
  , p_measure             IN VARCHAR2
  , p_plant_site_id       IN VARCHAR2
  , p_cell_prod_site_id   IN VARCHAR2
  , p_yyyymmdd            IN VARCHAR2
  , p_currency            IN VARCHAR2
  , p_qty                 IN VARCHAR2
  , p_created_by          IN VARCHAR2
  , p_as_from_site        IN VARCHAR2 DEFAULT NULL                                                               
  , O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
                                                                                                  

                                                                                                                              
                                         
                                 
                                      
                
                                                                                                                               
                                       
                                                                                                                               
                                                                                
                                                                             
                                                                                               
                                                                                                                             
                                                                                    
                                                                           
                                                                          
                                                                                                                      
                                                                  
                                                                 
                                                                  
                                                          
                                                                  
                                                                                
                                                                              
                                                                                 
                                                                         
                                                                        
                                                                                                             
                                                                                                                            
                                                                                                                  
                                                                                                            
                                                                                                                                
IS
                                                                                                                                       
                  
                                                                                                                                       
    e_validation_error  EXCEPTION;
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER          := 0;
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    D_EVENT_DATE        DATE;
    V_SQL_CODE          VARCHAR2(20 CHAR);
    V_SQL_ERRMSG        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_PROC_INPUT        VARCHAR2(4000 CHAR);
                                                                                                                                       
                                       
                                                                                                                                       
    v_created_by        VARCHAR2(500 CHAR);               
    n_update_cnt        NUMBER          := 0;                      
                                                                                                                                       
                                     
                                                                                                                                       
                                                                                                                                       
                 
                                                                                                                                       
    v_err_code          NUMBER;
    v_err_message       VARCHAR2(4000 CHAR) := '';

    V_DIVISION_ID       VARCHAR2(10 CHAR)   := '40';
    v_valid_item_id     VARCHAR2(4000 CHAR);
    v_plan_start_yyyymmdd VARCHAR2(8 CHAR);                          
    v_valid_shipto      VARCHAR2(4000 CHAR);
    V_EDIT_CNT          NUMBER;

                                            
    v_is_81             VARCHAR2(1 CHAR) := 'N';
    v_div_cnt           NUMBER := 0;
    V_VALID_PROJECT_CODE VARCHAR2(200 CHAR);
    V_VALID_TYPE        VARCHAR2(100 CHAR);
    V_DESC_81           VARCHAR2(4000 CHAR);

                     
    v_p_active_flag     VARCHAR2(4000 CHAR);
    v_p_division_id     VARCHAR2(4000 CHAR);
    v_p_project_code    VARCHAR2(4000 CHAR);
    v_p_end_customer    VARCHAR2(4000 CHAR);
    v_p_scm_site_id     VARCHAR2(4000 CHAR);
    v_p_item_id         VARCHAR2(4000 CHAR);
    v_p_dom_exp         VARCHAR2(4000 CHAR);
    v_p_fcst_type       VARCHAR2(4000 CHAR);
    v_p_incoterms       VARCHAR2(4000 CHAR);
    v_p_measure         VARCHAR2(4000 CHAR);
    v_p_plant_site_id   VARCHAR2(4000 CHAR);
    v_p_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_p_yyyymmdd        VARCHAR2(4000 CHAR);
    v_p_currency        VARCHAR2(4000 CHAR);
    v_p_qty             VARCHAR2(4000 CHAR);
    v_p_created_by_raw  VARCHAR2(4000 CHAR);
    v_p_as_from_site_raw VARCHAR2(4000 CHAR);                   
                                                                                          
    v_skip_parse        VARCHAR2(1 CHAR);

                
    v_active_flag       VARCHAR2(4000 CHAR);
    v_p_division_id_val VARCHAR2(4000 CHAR);
    v_project_code      VARCHAR2(4000 CHAR);
    v_end_customer      VARCHAR2(4000 CHAR);
    v_scm_site_id       VARCHAR2(4000 CHAR);
    v_item_id           VARCHAR2(4000 CHAR);
    v_dom_exp           VARCHAR2(4000 CHAR);
    v_fcst_type         VARCHAR2(4000 CHAR);
    v_incoterms         VARCHAR2(4000 CHAR);
    v_measure           VARCHAR2(4000 CHAR);
    v_plant_site_id     VARCHAR2(4000 CHAR);
    v_cell_prod_site_id VARCHAR2(4000 CHAR);
    v_yyyymmdd          VARCHAR2(4000 CHAR);
    v_currency          VARCHAR2(4000 CHAR);
    v_qty_str           VARCHAR2(4000 CHAR);
    v_p_created_by_val  VARCHAR2(4000 CHAR);
    v_as_from_site      VARCHAR2(4000 CHAR);                   

                        
    v_inner_result_cursor   SYS_REFCURSOR;

             
    v_index_active_flag     NUMBER;
    v_index_division_id     NUMBER;
    v_index_project_code    NUMBER;
    v_index_end_customer    NUMBER;
    v_index_scm_site_id     NUMBER;
    v_index_item_id         NUMBER;
    v_index_dom_exp         NUMBER;
    v_index_fcst_type       NUMBER;
    v_index_incoterms       NUMBER;
    v_index_measure         NUMBER;
    v_index_plant_site_id   NUMBER;
    v_index_cell_prod_site_id NUMBER;
    v_index_yyyymmdd        NUMBER;
    v_index_currency        NUMBER;
    v_index_qty             NUMBER;
    v_index_created_by      NUMBER;
    v_index_as_from_site    NUMBER;                   

    i_count             NUMBER  := 0;
    v_idx               NUMBER  := 1;

                                                                                                                                
                       
                                                                                                                                
    V_TARGET_DATE       VARCHAR2(10 CHAR);
    V_MEASURE_VAR       VARCHAR2(100 CHAR);
    V_FROM_TIME         VARCHAR2(4 CHAR);
    V_TO_TIME           VARCHAR2(4 CHAR);
    V_MIN_DATE          CHAR(8 CHAR);
    V_MAX_DATE          CHAR(8 CHAR);
    V_FROM_DATE         CHAR(8 CHAR);
    V_TO_DATE           CHAR(8 CHAR);
    s_BLOCK_Model       VARCHAR2(4000 CHAR);
    v_BIZ_TYPE_CHECK    VARCHAR2(500 CHAR);
    V_ROWCNT            NUMBER;
    V_I                 NUMBER;
    V_CNT               NUMBER;
    V_EXCEPTION_DIVISION_ID VARCHAR2(8 CHAR);
    V_EXCEPTION_ITEM_ID     VARCHAR2(50 CHAR);
    V_EXCEPTION_ITEM_TYPE   VARCHAR2(8 CHAR);
    V_EXCEPTION_COUNT       NUMBER  := 0;
    v_CELL_TYPE_CHECK   VARCHAR2(500 CHAR);
    s_cell_prod_valid   VARCHAR2(1000 CHAR);
    s_unit_price_valid  VARCHAR2(4000 CHAR);
    v_valid_bom         VARCHAR2(4000 CHAR);
    v_invalid_Site      VARCHAR2(200 CHAR);
    n_Dflag_chk         NUMBER  := 0;
    n_EE_chk            NUMBER  := 0;
    V_GETDATE           DATE;

                      
    v_cnt_check         NUMBER;

BEGIN
                                                   
        EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

                                                                                                                                       
                    
                                                                                                                                       
    V_PROC_INPUT := JSON_OBJECT(
        'p_active_flag'       VALUE p_active_flag,
        'p_division_id'       VALUE p_division_id,
        'p_project_code'      VALUE p_project_code,
        'p_end_customer'      VALUE p_end_customer,
        'p_scm_site_id'       VALUE p_scm_site_id,
        'p_item_id'           VALUE p_item_id,
        'p_dom_exp'           VALUE p_dom_exp,
        'p_fcst_type'         VALUE p_fcst_type,
        'p_incoterms'         VALUE p_incoterms,
        'p_measure'           VALUE p_measure,
        'p_plant_site_id'     VALUE p_plant_site_id,
        'p_cell_prod_site_id' VALUE p_cell_prod_site_id,
        'p_yyyymmdd'          VALUE p_yyyymmdd,
        'p_currency'          VALUE p_currency,
        'p_qty'               VALUE p_qty,
        'p_created_by'        VALUE p_created_by
    );

                                                                                                                                       
                  
                                                                                                                                       
                                       
    v_created_by := SUBSTR(p_created_by, 1,
                        CASE WHEN INSTR(p_created_by, '^') > 1
                             THEN INSTR(p_created_by, '^') - 1
                             ELSE 100 END);
                                     

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'START', N_LOG_COUNT,
        '########## Start of procedure ##########', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A001--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                   
                                                                                    
                                                                                                                                   
                                    
                                                                   
                                                                     
    v_skip_parse := NVL(g_skip_parse, 'N');
    g_skip_parse := 'N';

    IF v_skip_parse = 'N' THEN
        DELETE FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;
    DELETE FROM SCM_MGR.GT_PRDM1_T_PRICE;
    DELETE FROM SCM_MGR.GT_PRDM1_T_FCST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO;
    DELETE FROM SCM_MGR.GT_PRDM1_TEMP_EXCH;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU1;
    DELETE FROM SCM_MGR.GT_PRDM1_MSHYCHU2;
                                                                                                                                   
                                                                                  
                                                                                                                                   

                                                                         
                                          
                                                                         
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00B--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_skip_parse = 'N' THEN                                  
                            
    v_p_active_flag       := RTRIM(p_active_flag)       || '^';
    v_p_division_id       := RTRIM(p_division_id)       || '^';
    v_p_project_code      := RTRIM(p_project_code)      || '^';
    v_p_end_customer      := RTRIM(p_end_customer)      || '^';
    v_p_scm_site_id       := RTRIM(p_scm_site_id)       || '^';
    v_p_item_id           := RTRIM(p_item_id)           || '^';
    v_p_dom_exp           := RTRIM(p_dom_exp)           || '^';
    v_p_fcst_type         := RTRIM(p_fcst_type)         || '^';
    v_p_incoterms         := RTRIM(p_incoterms)         || '^';
    v_p_measure           := RTRIM(p_measure)           || '^';
    v_p_plant_site_id     := RTRIM(p_plant_site_id)     || '^';
    v_p_cell_prod_site_id := RTRIM(p_cell_prod_site_id) || '^';
    v_p_yyyymmdd          := RTRIM(p_yyyymmdd)          || '^';
    v_p_currency          := RTRIM(p_currency)          || '^';
    v_p_qty               := RTRIM(p_qty)               || '^';
    v_p_created_by_raw    := RTRIM(p_created_by)        || '^';
    v_p_as_from_site_raw  := RTRIM(NVL(p_as_from_site, '')) || '^';                                       

                                       
    i_count := LENGTH(RTRIM(v_p_division_id)) - LENGTH(REPLACE(RTRIM(v_p_division_id), '^', ''));

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A00C--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF i_count > 0 THEN

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
            '■ : A00D--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(i_count), '', SYSDATE,
            v_created_by,
            V_PROC_INPUT, NULL, NULL, NULL); END;

        WHILE v_idx <= i_count LOOP
            v_idx := v_idx + 1;

            v_index_active_flag       := INSTR(v_p_active_flag,       '^');
            v_index_division_id       := INSTR(v_p_division_id,       '^');
            v_index_project_code      := INSTR(v_p_project_code,      '^');
            v_index_end_customer      := INSTR(v_p_end_customer,      '^');
            v_index_scm_site_id       := INSTR(v_p_scm_site_id,       '^');
            v_index_item_id           := INSTR(v_p_item_id,           '^');
            v_index_dom_exp           := INSTR(v_p_dom_exp,           '^');
            v_index_fcst_type         := INSTR(v_p_fcst_type,         '^');
            v_index_incoterms         := INSTR(v_p_incoterms,         '^');
            v_index_measure           := INSTR(v_p_measure,           '^');
            v_index_plant_site_id     := INSTR(v_p_plant_site_id,     '^');
            v_index_cell_prod_site_id := INSTR(v_p_cell_prod_site_id, '^');
            v_index_yyyymmdd          := INSTR(v_p_yyyymmdd,          '^');
            v_index_currency          := INSTR(v_p_currency,          '^');
            v_index_qty               := INSTR(v_p_qty,               '^');
            v_index_created_by        := INSTR(v_p_created_by_raw,    '^');
            v_index_as_from_site      := INSTR(v_p_as_from_site_raw,  '^');                   

            v_active_flag       := SUBSTR(v_p_active_flag,       1, v_index_active_flag       - 1);
            v_p_division_id_val := SUBSTR(v_p_division_id,       1, v_index_division_id       - 1);
            v_project_code      := SUBSTR(v_p_project_code,      1, v_index_project_code      - 1);
            v_end_customer      := SUBSTR(v_p_end_customer,      1, v_index_end_customer      - 1);
            v_scm_site_id       := SUBSTR(v_p_scm_site_id,       1, v_index_scm_site_id       - 1);
            v_item_id           := SUBSTR(v_p_item_id,           1, v_index_item_id           - 1);
            v_dom_exp           := SUBSTR(v_p_dom_exp,           1, v_index_dom_exp           - 1);
            v_fcst_type         := SUBSTR(v_p_fcst_type,         1, v_index_fcst_type         - 1);
            v_incoterms         := SUBSTR(v_p_incoterms,         1, v_index_incoterms         - 1);
            v_measure           := SUBSTR(v_p_measure,           1, v_index_measure           - 1);
            v_plant_site_id     := SUBSTR(v_p_plant_site_id,     1, v_index_plant_site_id     - 1);
            v_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, 1, v_index_cell_prod_site_id - 1);
            v_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          1, v_index_yyyymmdd          - 1);
            v_currency          := SUBSTR(v_p_currency,          1, v_index_currency          - 1);
            v_qty_str           := SUBSTR(v_p_qty,               1, v_index_qty               - 1);
            v_p_created_by_val  := SUBSTR(v_p_created_by_raw,   1, v_index_created_by        - 1);
            v_as_from_site      := SUBSTR(v_p_as_from_site_raw, 1, v_index_as_from_site      - 1);                               

                         
            v_p_active_flag       := SUBSTR(v_p_active_flag,       LENGTH(RTRIM(v_active_flag)             || '^') + 1, LENGTH(RTRIM(v_p_active_flag)));
            v_p_division_id       := SUBSTR(v_p_division_id,       LENGTH(RTRIM(v_p_division_id_val)       || '^') + 1, LENGTH(RTRIM(v_p_division_id)));
            v_p_project_code      := SUBSTR(v_p_project_code,      LENGTH(RTRIM(v_project_code)            || '^') + 1, LENGTH(RTRIM(v_p_project_code)));
            v_p_end_customer      := SUBSTR(v_p_end_customer,      LENGTH(RTRIM(v_end_customer)            || '^') + 1, LENGTH(RTRIM(v_p_end_customer)));
            v_p_scm_site_id       := SUBSTR(v_p_scm_site_id,       LENGTH(RTRIM(v_scm_site_id)             || '^') + 1, LENGTH(RTRIM(v_p_scm_site_id)));
            v_p_item_id           := SUBSTR(v_p_item_id,           LENGTH(RTRIM(v_item_id)                 || '^') + 1, LENGTH(RTRIM(v_p_item_id)));
            v_p_dom_exp           := SUBSTR(v_p_dom_exp,           LENGTH(RTRIM(v_dom_exp)                 || '^') + 1, LENGTH(RTRIM(v_p_dom_exp)));
            v_p_fcst_type         := SUBSTR(v_p_fcst_type,         LENGTH(RTRIM(v_fcst_type)               || '^') + 1, LENGTH(RTRIM(v_p_fcst_type)));
            v_p_incoterms         := SUBSTR(v_p_incoterms,         LENGTH(RTRIM(v_incoterms)               || '^') + 1, LENGTH(RTRIM(v_p_incoterms)));
            v_p_measure           := SUBSTR(v_p_measure,           LENGTH(RTRIM(v_measure)                 || '^') + 1, LENGTH(RTRIM(v_p_measure)));
            v_p_plant_site_id     := SUBSTR(v_p_plant_site_id,     LENGTH(RTRIM(v_plant_site_id)           || '^') + 1, LENGTH(RTRIM(v_p_plant_site_id)));
            v_p_cell_prod_site_id := SUBSTR(v_p_cell_prod_site_id, LENGTH(RTRIM(v_cell_prod_site_id)       || '^') + 1, LENGTH(RTRIM(v_p_cell_prod_site_id)));
            v_p_yyyymmdd          := SUBSTR(v_p_yyyymmdd,          LENGTH(RTRIM(v_yyyymmdd)                || '^') + 1, LENGTH(RTRIM(v_p_yyyymmdd)));
            v_p_currency          := SUBSTR(v_p_currency,          LENGTH(RTRIM(v_currency)                || '^') + 1, LENGTH(RTRIM(v_p_currency)));
            v_p_qty               := SUBSTR(v_p_qty,               LENGTH(RTRIM(v_qty_str)                 || '^') + 1, LENGTH(RTRIM(v_p_qty)));
            v_p_created_by_raw    := SUBSTR(v_p_created_by_raw,    LENGTH(RTRIM(v_p_created_by_val)        || '^') + 1, LENGTH(RTRIM(v_p_created_by_raw)));
            v_p_as_from_site_raw  := SUBSTR(v_p_as_from_site_raw,  LENGTH(RTRIM(v_as_from_site)            || '^') + 1, LENGTH(RTRIM(v_p_as_from_site_raw)));                   

                                                                             
            v_active_flag       := TRIM(v_active_flag);
            v_p_division_id_val := TRIM(v_p_division_id_val);
            v_project_code      := TRIM(v_project_code);
            v_end_customer      := TRIM(v_end_customer);
            v_scm_site_id       := TRIM(v_scm_site_id);
                                                                                                       
            v_item_id           := REPLACE(REPLACE(REPLACE(REPLACE(TRIM(v_item_id), CHR(13), ''), CHR(10), ''), CHR(9), ''), ' ', '');
            v_dom_exp           := TRIM(v_dom_exp);
            v_fcst_type         := TRIM(v_fcst_type);
            v_incoterms         := TRIM(v_incoterms);
            v_measure           := TRIM(v_measure);
            v_plant_site_id     := TRIM(v_plant_site_id);
            v_cell_prod_site_id := TRIM(v_cell_prod_site_id);
            v_yyyymmdd          := TRIM(v_yyyymmdd);
            v_qty_str           := TRIM(v_qty_str);
            v_currency          := TRIM(v_currency);
            v_p_created_by_val  := TRIM(v_p_created_by_val);
            v_as_from_site      := TRIM(v_as_from_site);                   
                                               

            BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
                '■ : A00E--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || ' / ' || TO_CHAR(v_idx), '', SYSDATE,
                v_created_by,
                V_PROC_INPUT, NULL, NULL, NULL); END;

            INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
            ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
            , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
            , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
            VALUES
            ( v_active_flag, v_p_division_id_val, v_project_code, v_end_customer, v_scm_site_id, v_item_id
            , v_dom_exp, v_fcst_type, v_incoterms, v_measure
            , v_plant_site_id, v_cell_prod_site_id, v_yyyymmdd, v_currency
            , TO_NUMBER(NVL(v_qty_str, '0') DEFAULT 0 ON CONVERSION ERROR)
            , v_p_created_by_val
                                                                
            , '', '', '', '', '', '', '', '', '', v_as_from_site, '', '' );

        END LOOP;

    END IF;
    END IF;                                 

    BEGIN
        SELECT COUNT(1) INTO V_EDIT_CNT FROM SCM_MGR.GT_PRDM1_T_MAIN;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_EDIT_CNT := 0;
    END;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

                                                                                                                                
                                                                            
                                                                                                   
                                                       
                                                                                                                                
    SELECT COUNT(DISTINCT DIVISION_ID) INTO v_div_cnt FROM SCM_MGR.GT_PRDM1_T_MAIN;

    IF v_div_cnt > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '복수 Division 데이터는 동시에 저장할 수 없습니다. 단일 Division 으로 저장하세요.';
        RAISE e_validation_error;
    END IF;

    IF v_div_cnt = 1 THEN
        SELECT MIN(DIVISION_ID) INTO V_DIVISION_ID FROM SCM_MGR.GT_PRDM1_T_MAIN;
    END IF;

                                                                                                                                
                                                                                        
                                                                        
                                                                                                                                
    IF V_DIVISION_ID = '82' THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '82 사업부는 조회 전용입니다. 저장할 수 없습니다.';
        RAISE e_validation_error;
    END IF;

    IF (V_DIVISION_ID LIKE '81%' OR V_DIVISION_ID = '82') THEN
        v_is_81 := 'Y';
                                                                                            
                                                                       
        UPDATE SCM_MGR.GT_PRDM1_T_MAIN
        SET END_CUSTOMER = '-', CELL_PROD_SITE_ID = '-';
    END IF;
                                                                                                                                
                                  
                                                                                                                                

                                                                                                                                   
                                        
                                                                                                                                   
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 1. PARAMETER TO #T_MAIN IMPORT';
    N_LOG_COUNT   := i_count;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                   
                                      
                                                                                                                                   

    n_update_cnt := 0;                                   
                                                                                                                                
                            
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 2. VALIDATION CHECK START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                          
                                                                                                                                

                                                                                                                                
                              
                                                                                                                                
                                                                                                                                
                                                             
                                                                                                                                
                                                                                                                                
                                                     
                                                                                                                                
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_DAYINFO (DAYOFWEEKS)
    SELECT DAYOFWEEK
    FROM SCM_MGR.SCM_SYS_CALENDAR_M
    WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_DAYINFO');

    BEGIN
        SELECT A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
        INTO   V_TARGET_DATE, V_FROM_TIME, V_TO_TIME, V_MEASURE_VAR
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
            AND (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
            AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
                BETWEEN TRUNC(TO_NUMBER(B.ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR))
                    AND TRUNC(TO_NUMBER(B.ATTRIBUTE3 DEFAULT NULL ON CONVERSION ERROR))
            AND B.SEGMENT3 = V_DIVISION_ID
        ) A
        GROUP BY A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, ATTRIBUTE4;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
        WHEN TOO_MANY_ROWS THEN
            V_TARGET_DATE := NULL; V_FROM_TIME := NULL; V_TO_TIME := NULL; V_MEASURE_VAR := NULL;
    END;

    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    INNER JOIN (
        SELECT A.SEGMENT3 AS DIVISION_ID, A.ATTRIBUTE1 AS TARGET_DATE, A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME
             , REGEXP_SUBSTR(A.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS MEASURE
        FROM (
            SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4
            FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
            WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
            AND B.VALID_YN = 'Y'
            AND B.SEGMENT2 = 'DMF0082'
            AND B.ATTRIBUTE4 IS NOT NULL
        ) A
        CONNECT BY LEVEL <= REGEXP_COUNT(A.ATTRIBUTE4, ',') + 1
             AND PRIOR A.SEGMENT3 = A.SEGMENT3 AND PRIOR A.ATTRIBUTE1 = A.ATTRIBUTE1
             AND PRIOR SYS_GUID() IS NOT NULL
    ) C ON A.DIVISION_ID = C.DIVISION_ID
          AND A.MEASURE  = C.MEASURE
    WHERE A.QTY_PRICE <> 0
    AND (C.TARGET_DATE = 'ALL' OR C.TARGET_DATE IN (SELECT DAYOFWEEKS FROM SCM_MGR.GT_PRDM1_TEMP_DAYINFO))
    AND TRUNC(TO_NUMBER(REPLACE(SUBSTR(TO_CHAR(SYSDATE, 'HH24:MI:SS'), 1, 5), ':', '')))
        BETWEEN TRUNC(TO_NUMBER(C.FROM_TIME DEFAULT NULL ON CONVERSION ERROR))
            AND TRUNC(TO_NUMBER(C.TO_TIME   DEFAULT NULL ON CONVERSION ERROR));

    IF v_cnt_check > 1 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := V_MEASURE_VAR || ' 메져는 "' || V_TARGET_DATE || '" 요일의 '
                      || SUBSTR(V_FROM_TIME, 1, 2) || ':' || SUBSTR(V_FROM_TIME, 3, 2)
                      || ' ~ ' || SUBSTR(V_TO_TIME, 1, 2) || ':' || SUBSTR(V_TO_TIME, 3, 2)
                      || ' 시간에는 수정 불가능합니다.';
        RAISE e_validation_error;
    END IF;
                                                                                                                                
                                                   
                                                                                                                                
                                                                                                                                
                              
                                                                                                                                
    BEGIN
        SELECT MIN(BASIS_START_DATE), MAX(BASIS_END_DATE)
        INTO   V_MIN_DATE, V_MAX_DATE
        FROM SCM_MGR.SCM_SYS_CALENDAR_M M
                                                                                                      
        WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')            
        AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD');               
                                         
    EXCEPTION WHEN NO_DATA_FOUND THEN V_MIN_DATE := NULL; V_MAX_DATE := NULL;
    END;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A003--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                           
                                                                                  
                                                                                                                                
    IF v_is_81 = 'N' THEN                        
    INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
    , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
    SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
         , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
    FROM (
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
                            
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE B
              ON A.DIVISION_ID       = B.DIVISION_ID
             AND A.PROJECT_CODE      = B.PROJECT_CODE
             AND A.END_CUSTOMER      = B.END_CUSTOMER
             AND A.SCM_SITE_ID       = B.SCM_SITE_ID
                                                                                                 
                                                                                   
             AND CASE WHEN TRIM(A.PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END
               = CASE WHEN TRIM(B.PLANT_SITE_ID) IS NULL OR B.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE B.PLANT_SITE_ID END
             AND CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
               = CASE WHEN TRIM(B.CELL_PROD_SITE_ID) IS NULL OR B.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE B.CELL_PROD_SITE_ID END
             AND A.ITEM_ID           = B.ITEM_ID
             AND A.DOM_EXP           = B.DOM_EXP
             AND A.FCST_TYPE         = B.FCST_TYPE
             AND A.INCOTERMS         = B.INCOTERMS
            WHERE B.DIVISION_ID  = A.DIVISION_ID
              AND B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
                                                                                                                                        
                                                       
                                                                                                                
                                                                                                                                        
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) A
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS
    ) AA;
    ELSE
                                                                                            
                                                                                         
        INSERT INTO SCM_MGR.GT_PRDM1_T_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
        , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE )
        SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
             , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
        FROM (
                                                                           
            SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, '-' AS END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID
                          , '-' AS CELL_PROD_SITE_ID, B.ITEM_ID
                          , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            JOIN SCM_MGR.SCM_MST_FUTURE_PRICE B
              ON A.DIVISION_ID   = B.DIVISION_ID
             AND A.PROJECT_CODE  = B.PROJECT_CODE
             AND A.SCM_SITE_ID   = B.SCM_SITE_ID
             AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
             AND A.ITEM_ID       = B.ITEM_ID
             AND A.DOM_EXP       = B.DOM_EXP
             AND A.FCST_TYPE     = B.FCST_TYPE
             AND A.INCOTERMS     = B.INCOTERMS
            WHERE B.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND B.PRICE <> 0
              AND B.MEASURE = 'LOC'
            UNION
                                                 
            SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID
                          , A.CELL_PROD_SITE_ID, A.ITEM_ID
                          , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE A.YYYYMMDD BETWEEN V_MIN_DATE AND V_MAX_DATE
              AND A.QTY_PRICE <> 0
              AND A.MEASURE = 'LOC'
        ) AA81
        GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
               , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS;
    END IF;                        

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_PRICE');
                                                                                                                                
                                                         
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A004--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                             
                                                        
                                                                                                                                
    IF v_is_81 = 'N' THEN                                             
    INSERT INTO SCM_MGR.GT_PRDM1_T_FCST
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID
    , ITEM_ID, YYYYMMDD, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS )
    SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID
                  , B.ITEM_ID, B.YYYYMMDD, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
    FROM SCM_MGR.GT_PRDM1_T_MAIN A
    JOIN SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN B
      ON A.DIVISION_ID  = B.DIVISION_ID
     AND A.PROJECT_CODE = B.PROJECT_CODE
     AND A.END_CUSTOMER = B.END_CUSTOMER
     AND A.SCM_SITE_ID  = B.SCM_SITE_ID
     AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
                                                    
     AND A.ITEM_ID      = B.ITEM_ID
     AND A.DOM_EXP      = B.DOM_EXP
     AND A.FCST_TYPE    = B.FCST_TYPE
     AND A.INCOTERMS    = B.INCOTERMS
     AND A.YYYYMMDD     = B.YYYYMMDD
     AND A.MEASURE      = B.MEASURE
    WHERE B.DIVISION_ID = A.DIVISION_ID
      AND B.QTY <> 0
                                     
      AND A.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'SCM_FCST');                                       

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_FCST');
    END IF;                   
                                                                                                                                
                                           
                                                                                                                                
                                                           
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A005--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                      
                                                                                                                                
                                                                                                                                
                                       
                                                                                                                                
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET A.V_VMI_YN = (SELECT CASE WHEN B.VMI_YN = 'Y' THEN 'Y' ELSE 'N' END
                      FROM SCM_MGR.SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID
                      FETCH FIRST 1 ROWS ONLY)
    WHERE EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE B
                  WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.SCM_SITE_ID);

                                                                                                                                
                                                   
                                                                                                                                
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_ATTRIBUTE10 = NULL
    WHERE SCM_SITE_ID = V_ATTRIBUTE10;

                                                                                                                                
                                                    
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A006--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                 
                                                                                                                                
    BEGIN
        SELECT MIN(C.BASIS_YYYYMMDD), MAX(C.BASIS_YYYYMMDD)
        INTO   V_FROM_DATE, V_TO_DATE
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M C
          ON C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
        WHERE L.LOOKUP_TYPE = 'DM_LONG_PLAN' AND L.SEGMENT1 = '40' AND L.SEGMENT2 = 'MKT FCST' AND L.VALID_YN = 'Y';
    EXCEPTION WHEN NO_DATA_FOUND THEN V_FROM_DATE := NULL; V_TO_DATE := NULL;
    END;

                                                                                                                               
                                       
                                                 
                                                                                                                               
    IF V_DIVISION_ID = '40' THEN
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.YYYYMMDD < V_FROM_DATE OR R.YYYYMMDD > V_TO_DATE;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := V_FROM_DATE || ' ~ ' || V_TO_DATE || ' 구간 내의 데이터만 수정할 수 있습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
                                                                                                                                
                                               
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A007--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                
                                                                                                                                
    IF V_DIVISION_ID = '40' OR v_is_81 = 'Y' THEN                                                    
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE R.INCOTERMS IN (
            SELECT OLD_VALUE1 FROM SCM_MGR.NERP_CONV_MASTER
            WHERE CODETYPE = 'INCOTERMS_ID'
            GROUP BY OLD_VALUE1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '구코드 INCOTERMS는 저장할 수 없습니다.';
            RAISE e_validation_error;
        END IF;
    END IF;
                                                                                                                                
                                                              
                                                                                                                                

                                                                                                                                
                                                                      
                                                                                                                                
    s_BLOCK_Model := '';
    BEGIN
        SELECT ITEM_ID INTO s_BLOCK_Model
        FROM (
            SELECT A.ITEM_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE (
                SELECT COUNT(1) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'FCST_EXCEPT_MODEL' AND SEGMENT1 = '40' AND VALID_YN = 'Y' AND SEGMENT2 = A.ITEM_ID
            ) > 0
            AND A.QTY_PRICE <> 0
            FETCH FIRST 1 ROWS ONLY
        );
    EXCEPTION WHEN NO_DATA_FOUND THEN s_BLOCK_Model := '';
    END;

    IF s_BLOCK_Model IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := 'Model : ' || s_BLOCK_Model || CHR(10) || 'FCST INPUT BLOCK Model. contact 영업관리팀';
        RAISE e_validation_error;
    END IF;
                                                                                                                                
                                                                    
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A008--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                     
                                                                                                                                
    BEGIN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE NOT EXISTS (
                SELECT ITEM.DIVISION_ID
                FROM SCM_MGR.SCM_MST_SITE_ITEM ITEM
                   , SCM_MGR.SCM_MST_ITEM_SN SN
                WHERE ITEM.DIVISION_ID = A.DIVISION_ID
                  AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                  AND ITEM.ITEM_ID     = A.ITEM_ID
                  AND ITEM.DIVISION_ID = SN.DIVISION_ID
                  AND ITEM.ITEM_ID     = SN.ITEM_ID
                  AND SN.ACTIVE_FLAG   = 'Y'
                  AND ITEM.VALID_YN    = 'Y'
            )
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END;
                                                                                                                                
                                                                   
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A009--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                        
                                                                                                                                
    v_BIZ_TYPE_CHECK := NULL;
                                                                                                              

    IF v_is_81 = 'N' THEN                                                       
                                                                                                                                
                                                                       
                                                                                                                                
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE
    ( DIVISION_ID, ITEM_ID, ITEM_TYPE, SEQ )
    SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS ITEM_TYPE
         , ROW_NUMBER() OVER (ORDER BY ROWNUM) AS SEQ
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE LOOKUP_TYPE = 'EXCEPTION_BIZ_TYPE'
    AND VALID_YN = 'Y'
    AND SEGMENT1 = V_DIVISION_ID;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE');

                                                                                                                                
                                                           
                                                           
                                                             
                                                                                                                                
    V_ROWCNT := SQL%ROWCOUNT;

    BEGIN
        SELECT 1, COUNT(*) INTO V_I, V_CNT
        FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_I := 1; V_CNT := 0;
    END;

    V_EXCEPTION_COUNT := 0;

    WHILE V_I <= V_CNT LOOP
        BEGIN
            SELECT A.DIVISION_ID, A.ITEM_ID, A.ITEM_TYPE
            INTO V_EXCEPTION_DIVISION_ID, V_EXCEPTION_ITEM_ID, V_EXCEPTION_ITEM_TYPE
            FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_BIZ_TYPE A
            WHERE SEQ = V_I;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
        END;

        INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST
        ( DIVISION_ID, ITEM_ID, ITEM_TYPE )
        SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, V_EXCEPTION_ITEM_TYPE AS ITEM_TYPE
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE A.DIVISION_ID = V_EXCEPTION_DIVISION_ID
        AND   A.ITEM_ID LIKE '' || V_EXCEPTION_ITEM_ID || '%';

        V_I := V_I + 1;
    END LOOP;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST');

                                                                                                                                
                                                                                   
                                                                                                                                
    BEGIN
        v_BIZ_TYPE_CHECK := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_BIZ_TYPE_CHECK
            FROM (
                SELECT T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN LATERAL (
                    SELECT T2.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
                    FROM SCM_MGR.SCM_ITEM_M_SN T2
                    WHERE T1.DIVISION_ID = T2.DIVISION_ID
                      AND T1.ITEM_ID     = T2.ITEM_ID
                      AND T2.ACTIVE_FLAG = 'Y'
                ) T2 ON 1=1
                WHERE T1.ACTION = 'I'
                AND T2.FORECAST_INFO_BIZ_TYPE IS NULL
                GROUP BY T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
            ) A
            WHERE NOT EXISTS (
                SELECT B.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_TEMP_EXCEPTION_ITEM_LIST B
                WHERE A.DIVISION_ID = B.DIVISION_ID
                  AND A.ITEM_ID     = B.ITEM_ID
                  AND A.ITEM_TYPE   = B.ITEM_TYPE
            )
            GROUP BY A.ITEM_ID
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_BIZ_TYPE_CHECK := NULL;
        END;

                                                                                                                
        IF v_BIZ_TYPE_CHECK IS NOT NULL THEN
                                          
            V_DESCRIPTION := 'Model*: ' || v_BIZ_TYPE_CHECK || '는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;                  
                                                                                                                                
                                                      
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A010--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                                 
                                                                                                                                
    v_CELL_TYPE_CHECK := NULL;

    IF v_is_81 = 'N' THEN                                                                  
    BEGIN
        v_CELL_TYPE_CHECK := NULL;
        BEGIN
            SELECT LISTAGG(A.ITEM_ID, ',') WITHIN GROUP (ORDER BY A.ITEM_ID)
            INTO v_CELL_TYPE_CHECK
            FROM (
                SELECT T1.ITEM_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN T1
                LEFT JOIN SCM_MGR.SCM_ITEM_M_SN T2
                  ON T1.DIVISION_ID = T2.DIVISION_ID AND T1.ITEM_ID = T2.ITEM_ID
                WHERE (T2.FORECAST_INFO_BIZ_TYPE = 'CELL' OR T1.ITEM_ID LIKE 'MC%')
                  AND T1.CELL_PROD_SITE_ID = '-'
                  AND T2.ACTIVE_FLAG = 'Y'
                  AND NVL(T1.QTY_PRICE, 0) <> 0
                  AND (T1.ACTION = 'I'
                    OR NOT EXISTS (
                        SELECT 1 FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN X
                        WHERE T1.DIVISION_ID       = X.DIVISION_ID
                          AND T1.PROJECT_CODE      = X.PROJECT_CODE
                          AND T1.END_CUSTOMER      = X.END_CUSTOMER
                          AND T1.SCM_SITE_ID       = X.SCM_SITE_ID
                          AND T1.PLANT_SITE_ID     = X.PLANT_SITE_ID
                          AND T1.CELL_PROD_SITE_ID = X.CELL_PROD_SITE_ID
                          AND T1.ITEM_ID           = X.ITEM_ID
                          AND T1.DOM_EXP           = X.DOM_EXP
                          AND T1.FCST_TYPE         = X.FCST_TYPE
                          AND T1.INCOTERMS         = X.INCOTERMS
                          AND X.MEASURE            = 'MKT_FCST'
                          AND X.YYYYMMDD           >= v_plan_start_yyyymmdd
                          AND X.QTY                <> 0
                    ))
                GROUP BY T1.ITEM_ID
                FETCH FIRST 10 ROWS ONLY
            ) A;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_CELL_TYPE_CHECK := NULL;
        END;

        IF v_CELL_TYPE_CHECK IS NOT NULL THEN
            V_DESCRIPTION := 'Model*: ' || v_CELL_TYPE_CHECK || '는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;                  
                                                                                                                                
                                                                                               
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A011--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                         
                                                                                                                                
    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN                                   
    BEGIN
        BEGIN
            SELECT A.ITEM_ID INTO s_cell_prod_valid
            FROM (
                SELECT P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.YYYYMMDD
                     , P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID AS CELL_PROD_SITE_FCST, T.CELL_PROD_SITE_ID AS CELL_PROD_SITE_MAIN
                FROM SCM_MGR.GT_PRDM1_T_FCST P
                INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN T
                  ON T.DIVISION_ID      = P.DIVISION_ID
                 AND T.PROJECT_CODE     = P.PROJECT_CODE
                 AND T.END_CUSTOMER     = P.END_CUSTOMER
                 AND T.SCM_SITE_ID      = P.SCM_SITE_ID
                 AND T.PLANT_SITE_ID    = P.PLANT_SITE_ID
                 AND T.ITEM_ID          = P.ITEM_ID
                 AND T.YYYYMMDD         = P.YYYYMMDD
                 AND T.MEASURE          = P.MEASURE
                 AND T.DOM_EXP          = P.DOM_EXP
                 AND T.FCST_TYPE        = P.FCST_TYPE
                 AND T.INCOTERMS        = P.INCOTERMS
                 AND T.CELL_PROD_SITE_ID <> P.CELL_PROD_SITE_ID
                WHERE T.ACTION = 'I'
                GROUP BY P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID
                       , P.ITEM_ID, P.YYYYMMDD, P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID, T.CELL_PROD_SITE_ID
                HAVING P.CELL_PROD_SITE_ID = '-' OR T.CELL_PROD_SITE_ID = '-'
            ) A
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;                  
                                                                                                                                
                                                                                       
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A012--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                            
                                                                                        
                                                                                                                                
    s_cell_prod_valid := NULL;

    IF v_is_81 = 'N' THEN                                   
    BEGIN
        BEGIN
            SELECT 'N' INTO s_cell_prod_valid
            FROM (
                SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                     , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                     , LISTAGG(CASE WHEN T.CELL_PROD_SITE_ID = '-' THEN 'XX' ELSE T.CELL_PROD_SITE_ID END, ', ')
                        WITHIN GROUP (ORDER BY T.CELL_PROD_SITE_ID) AS CELL_PROD_ALL
                FROM SCM_MGR.GT_PRDM1_T_MAIN T
                WHERE T.ACTION = 'I'
                GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
                       , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
                HAVING COUNT(*) > 1
            ) A
            WHERE INSTR(A.CELL_PROD_ALL, 'XX') > 0
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN s_cell_prod_valid := NULL;
        END;

        IF s_cell_prod_valid IS NOT NULL THEN
            V_DESCRIPTION := 'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.';
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;
    END;
    END IF;                  

                                                                                                                                
                                                                                          
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A013--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                              
                                                                                                                                
                                                                              
    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU1 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST                                                        
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'MEASURE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU1');

    INSERT INTO SCM_MGR.GT_PRDM1_MSHYCHU2 (SEGMENT2)
    SELECT MST.SEGMENT2
    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND MST.SEGMENT1      = 'FCST_TYPE'
    AND MST.VALID_YN      = 'Y';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_MSHYCHU2');

    s_unit_price_valid := NULL;
    BEGIN
        SELECT 'End Customer________ : '   || NVL(A.END_CUSTOMER,  '')
            || CHR(10) || 'Sales site_____________ : ' || NVL(A.SCM_SITE_ID,   '')
            || CHR(10) || 'Model________________ : '   || NVL(A.ITEM_ID,       '')
            || CHR(10) || 'Customs Handbook__ : '      || NVL(A.DOM_EXP,       '')
            || CHR(10) || 'Fcst Type_____________ : '  || NVL((
                SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = A.FCST_TYPE
                FETCH FIRST 1 ROWS ONLY), '')
            || CHR(10) || 'Incoterms____________ : '   || NVL(A.INCOTERMS,     '')
            || CHR(10) || 'Plant Site___________ : '   || NVL(A.PLANT_SITE_ID, '')
            || CHR(10) || 'Cell Prod Site___________ : '|| NVL(A.CELL_PROD_SITE_ID, '')
            || CHR(10) || 'YYYYMMDD_________ : '       || NVL(MIN(M.BASIS_START_DATE), '') || ' ~ ' || NVL(MAX(M.BASIS_START_DATE), '')
            || CHR(10) || CHR(10)
        INTO s_unit_price_valid
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM Z
                ON A.DIVISION_ID = Z.DIVISION_ID
               AND A.PROJECT_CODE          = Z.PROJECT_CODE
               AND A.SCM_SITE_ID           = Z.SCM_SITE_ID
               AND A.ITEM_ID               = Z.ITEM_ID
               AND Z.VALID_YN              = 'Y'
               AND (Z.SALES_PLAN_ADJUST_YN = 'Y' OR Z.SALES_PLAN_ADJUST_YN IS NULL)
        LEFT JOIN (
            SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M M
                                                                                                                                               
                                                                                                          
            WHERE M.BASIS_YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')            
            AND   M.BASIS_YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')               
                                             
                                                                                                                                               
            GROUP BY BASIS_START_DATE
        ) M ON 1=1
        LEFT JOIN SCM_MGR.GT_PRDM1_T_PRICE P
               ON A.DIVISION_ID       = P.DIVISION_ID
              AND A.PROJECT_CODE      = P.PROJECT_CODE
              AND A.END_CUSTOMER      = P.END_CUSTOMER
              AND A.SCM_SITE_ID       = P.SCM_SITE_ID
                                                                                          
              AND CASE WHEN TRIM(A.PLANT_SITE_ID) IS NULL OR A.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END
                = CASE WHEN TRIM(P.PLANT_SITE_ID) IS NULL OR P.PLANT_SITE_ID IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
              AND CASE WHEN TRIM(A.CELL_PROD_SITE_ID) IS NULL OR A.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE A.CELL_PROD_SITE_ID END
                = CASE WHEN TRIM(P.CELL_PROD_SITE_ID) IS NULL OR P.CELL_PROD_SITE_ID IN ('-','--') THEN '-' ELSE P.CELL_PROD_SITE_ID END
              AND A.ITEM_ID           = P.ITEM_ID
              AND A.DOM_EXP           = P.DOM_EXP
              AND A.FCST_TYPE         = P.FCST_TYPE
              AND A.INCOTERMS         = P.INCOTERMS
              AND P.YYYYMMDD          = M.BASIS_START_DATE
              AND P.PRICE             > 0
        WHERE P.YYYYMMDD IS NULL                 
          AND A.MEASURE IN (SELECT SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU1)
          AND A.QTY_PRICE <> 0
                                                                              
                                                                                               
                                                                                   
                                                
                                                                     
                                                                                
                                                                        
                                                                           
                                                                
          AND A.FCST_TYPE NOT IN (
                  SELECT X.SEGMENT2 FROM SCM_MGR.GT_PRDM1_MSHYCHU2 X                         
                  UNION ALL
                  SELECT L.SEGMENT2                                                          
                  FROM   SCM_MGR.GT_PRDM1_MSHYCHU2 X
                  JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                         ON L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND L.VALID_YN    = 'Y'
                        AND L.SEGMENT1    = X.SEGMENT2 )
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE
               , A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY;
    EXCEPTION WHEN NO_DATA_FOUND THEN s_unit_price_valid := NULL;
    END;

    IF s_unit_price_valid IS NOT NULL THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := s_unit_price_valid || 'Unit Price Not Found !' || CHR(10)
                      || '해당주차의 Sales Price 값을 입력하시기 바랍니다.' || CHR(10)
                      || '미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.';
        RAISE e_validation_error;
    END IF;

                                                                                                                                
                                                            
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A014--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                             
                                                                                                                                
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE = 'RMA'
      AND MEASURE IN ('MKT_FCST', 'SCM_FCST')
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) > 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '반품수량(RMA)은 음수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
                                                                                                                                
                                                                                           
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A015--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                      
                                                                                                                                
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE FCST_TYPE <> 'RMA'
      AND NVL(CAST(QTY_PRICE AS NUMBER(30,10)), 0) < 0;

    IF v_cnt_check > 0 THEN
        V_LOG_TYPE    := 'INVALID';
        V_DESCRIPTION := '정수값만 입력가능합니다 !';
        RAISE e_validation_error;
    END IF;
                                                                                                                                
                                                    
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A016--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                         
                                                  
                                                                                                                                
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET V_BOM_YN = 'N'
    WHERE EXISTS (
        SELECT 1
        FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
        JOIN SCM_MGR.SCM_MST_ITEM_SN C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
        JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL D ON D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS' AND D.VALID_YN = 'Y' AND C.EVAL_CLASS = D.SEGMENT1
        WHERE B.LOOKUP_TYPE = 'AS_SITE_PLANT'
          AND B.SEGMENT3    = V_DIVISION_ID
          AND B.VALID_YN    = 'Y'
          AND A.V_ATTRIBUTE10 = B.SEGMENT2
    )
    AND A.DIVISION_ID = V_DIVISION_ID
    AND A.MEASURE IN ('MKT_FCST', 'SCM_FCST');                        

    SELECT COUNT(*) INTO v_cnt_check FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE V_BOM_YN IS NULL;

    IF v_cnt_check > 0 THEN
                     
        v_valid_bom  := NULL;
        v_valid_shipto := NULL;

        BEGIN
            SELECT A.ITEM_ID INTO v_valid_bom
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                    ON A.ITEM_ID       = C.ITEM_ID
                   AND A.DIVISION_ID   = C.DIVISION_ID
                   AND C.ITEM_TYPE IN ('P', 'H')
                   AND C.ACTIVE_FLAG   = 'Y'
            LEFT JOIN SCM_MGR.SCM_MST_BOM_ENG_SN X
                   ON A.DIVISION_ID = X.DIVISION_ID AND A.ITEM_ID = X.PARENT_ITEM_ID
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END FROM_SITE                                                                                          
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END                                                                                          
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST')                        
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')              
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 10, 'YYYYMMDD')                     
              AND A.QTY_PRICE > 0
              AND X.PARENT_ITEM_ID IS NULL              
              AND A.ITEM_ID NOT IN ('ECE0074N5-01')
              AND A.ITEM_ID NOT IN ('MCCH120022B2-K', 'MCCH120022B2-GD')
              AND A.V_BOM_YN IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_bom := NULL;
        END;

        IF v_valid_bom IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_bom || '] BOM does not exist !';
            RAISE e_validation_error;
        END IF;
    END IF;

                                                                                                                                
                                                       
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A017--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                            
                                                       
                                                                                                                                
    BEGIN
        v_valid_shipto := NULL;
        BEGIN
            SELECT A.SCM_SITE_ID INTO v_valid_shipto
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT JOIN SCM_MGR.SCM_MST_SITE_CUSTOMER X
                   ON A.DIVISION_ID = X.DIVISION_ID
                  AND A.SCM_SITE_ID = X.SCM_SITE_ID
                  AND X.VALID_YN    = 'Y'
                  AND X.REP_YN      = 'Y'
            LEFT JOIN (
                SELECT DIVISION_ID
                     , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END FROM_SITE                                                                                          
                     , TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
                FROM SCM_MGR.SCP_MST_BOD_V
                WHERE PRIORITY = 1
                GROUP BY DIVISION_ID
                       , CASE WHEN DIVISION_ID IN ('82','40') THEN '-' ELSE FROM_SITE END                                                                                          
                       , TO_SITE, INCOTERMS
            ) BOD ON A.DIVISION_ID  = BOD.DIVISION_ID
                 AND A.PLANT_SITE_ID = BOD.FROM_SITE
                 AND A.SCM_SITE_ID   = BOD.TO_SITE
                 AND A.INCOTERMS     = BOD.INCOTERMS
            WHERE A.MEASURE IN ('MKT_FCST', 'Vmi_In_Req', 'SCM_FCST')                                       
              AND A.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')              
              AND A.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') + NVL(BOD.LT_TOTAL, 0) + 7 * 3, 'YYYYMMDD')                 
              AND A.QTY_PRICE > 0
              AND X.SHIPTO_CODE IS NULL
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_shipto := NULL;
        END;

        IF v_valid_shipto IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_shipto || '] SITE SHIP-TO does not exist !';
            RAISE e_validation_error;
        END IF;
    END;
                                                                                                                                
                                                          
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                          
                                                                                                                                
    v_plan_start_yyyymmdd := TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');             

    IF v_is_81 = 'N' THEN                                               
                                                                            
                                                                                          
                                                                                  
                                                                        
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN
       SET DIVISION_ID       = NVL(DIVISION_ID,       '-')
         , PROJECT_CODE      = NVL(PROJECT_CODE,      '-')
         , END_CUSTOMER      = NVL(END_CUSTOMER,      '-')
         , SCM_SITE_ID       = NVL(SCM_SITE_ID,       '-')
         , ITEM_ID           = NVL(ITEM_ID,           '-')
         , DOM_EXP           = NVL(DOM_EXP,           '-')
         , FCST_TYPE         = NVL(FCST_TYPE,         '-')
         , INCOTERMS         = NVL(INCOTERMS,         '-')
         , MEASURE           = NVL(MEASURE,           '-')
         , PLANT_SITE_ID     = NVL(PLANT_SITE_ID,     '-')
         , CELL_PROD_SITE_ID = NVL(CELL_PROD_SITE_ID, '-')
         , YYYYMMDD          = NVL(YYYYMMDD,          '-')
         , CURRENCY          = NVL(CURRENCY,          '-')
     WHERE DIVISION_ID   IS NULL OR PROJECT_CODE      IS NULL OR END_CUSTOMER      IS NULL
        OR SCM_SITE_ID   IS NULL OR ITEM_ID           IS NULL OR DOM_EXP           IS NULL
        OR FCST_TYPE     IS NULL OR INCOTERMS         IS NULL OR MEASURE           IS NULL
        OR PLANT_SITE_ID IS NULL OR CELL_PROD_SITE_ID IS NULL OR YYYYMMDD          IS NULL
        OR CURRENCY      IS NULL;
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE = 'RTF_SYS_RP'
      AND A.YYYYMMDD >= v_plan_start_yyyymmdd            
      AND EXISTS (
            SELECT RSLT.DIVISION_ID
            FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
               , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
              AND RSLT.ITEM_ID             = ITEM.ITEM_ID
              AND A.DIVISION_ID            = RSLT.DIVISION_ID
              AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
              AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
              AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
              AND A.ITEM_ID                = RSLT.ITEM_ID
              AND A.DOM_EXP                = RSLT.DOM_EXP
              AND A.FCST_TYPE              = RSLT.FCST_TYPE
              AND A.INCOTERMS              = RSLT.INCOTERMS
              AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
              AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
              AND ITEM.ACTIVE_FLAG         = 'Y'
              AND RSLT.FCST_TYPE           = 'RMA'
      );

    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
    , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
    , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
    , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
    SELECT RSLT.DIVISION_ID, RSLT.PROJECT_CODE, RSLT.END_CUSTOMER, RSLT.SCM_SITE_ID, RSLT.ITEM_ID
         , RSLT.DOM_EXP, RSLT.FCST_TYPE, RSLT.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
         , RSLT.PLANT_SITE_ID, RSLT.YYYYMMDD
                                                 
         , NVL(RSLT.QTY_PRICE, 0) AS QTY_PRICE                                 
                                               
         , 'SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
         , RSLT.V_ATTRIBUTE1, RSLT.V_ATTRIBUTE2, RSLT.V_ATTRIBUTE3, RSLT.V_ATTRIBUTE4, RSLT.V_ATTRIBUTE5
         , RSLT.V_ATTRIBUTE6, RSLT.V_ATTRIBUTE7, RSLT.V_ATTRIBUTE8, RSLT.V_ATTRIBUTE9, RSLT.V_ATTRIBUTE10
         , RSLT.CELL_PROD_SITE_ID
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
    INNER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
            ON RSLT.DIVISION_ID  = ITEM.DIVISION_ID
           AND RSLT.ITEM_ID      = ITEM.ITEM_ID
           AND ITEM.ACTIVE_FLAG  = 'Y'
           AND RSLT.FCST_TYPE    = 'RMA'
    WHERE RSLT.MEASURE IN ('MKT_FCST', 'SCM_FCST')                         
      AND RSLT.YYYYMMDD >= v_plan_start_yyyymmdd;            
    END IF;                   

                                                                                                                                
                                                                        
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A018_cont--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                      
                                                
                                                                                                                                
    SELECT COUNT(*) INTO v_cnt_check
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE (DIVISION_ID LIKE '81%' OR DIVISION_ID = '82' OR DIVISION_ID = '40');

    IF v_cnt_check > 0 THEN
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE_ITEM ITEM
                         ON ITEM.DIVISION_ID = A.DIVISION_ID
                        AND ITEM.SCM_SITE_ID = A.SCM_SITE_ID
                        AND ITEM.ITEM_ID     = A.ITEM_ID
                        AND ITEM.VALID_YN    = 'Y'
            LEFT OUTER JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V SN
                         ON ITEM.DIVISION_ID = SN.DIVISION_ID
                        AND ITEM.ITEM_ID     = SN.ITEM_ID
                        AND SN.ACTIVE_FLAG   = 'Y'
            WHERE A.QTY_PRICE <> 0
              AND (ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL)
            FETCH FIRST 1 ROWS ONLY;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Site Item ID !';
            RAISE e_validation_error;
        END IF;
    END IF;

                                                                                                                                
                                                                    
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A019--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                   
                                                                                                                                
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN A
    SET ACTION = (
        SELECT CASE WHEN SUM(B.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW || D.PARTIAL_WEEK_NAME) = 0 THEN 'D' ELSE 'M' END
        FROM SCM_MGR.GT_PRDM1_T_MAIN B
        JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON B.YYYYMMDD = D.BASIS_YYYYMMDD
        WHERE B.MEASURE = 'LOC' AND B.ACTION <> 'I'
          AND B.YYYYMMDD = A.YYYYMMDD
        FETCH FIRST 1 ROWS ONLY
    )
    WHERE A.MEASURE = 'LOC' AND A.ACTION <> 'I';
                                                                                                                                
                                                                                
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A020--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                         
                                                                                                                                
    v_invalid_Site := NULL;
    n_Dflag_chk    := 0;

                                                                                                                                       
                                      
                                                                                                                                       
    SELECT COUNT(*) INTO n_Dflag_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE = 'LOC' AND ACTION = 'D';                                                   

    IF n_Dflag_chk > 0 THEN
      IF v_is_81 = 'N' THEN                                                                               
                                                                                                                                           
                                                                      
                                                                                                                                           
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST')                         
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                                                                                                                                                         
                                                                                         
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                                                 
                                                                                                                                                         
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0             
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )                              
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

                                                                                                                                           
                                                                      
                                                                                                                                           
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req', 'SCM_FCST')                          
                      AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                                                                                                                                                         
                                                                                                                    
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')                  
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')              
                                                 
                                                                                                                                                         
                      AND F.QTY <> 0             
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )                              
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      ELSE
                                                                                              
                                                                                                           
                                 
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON F.YYYYMMDD = B.BASIS_YYYYMMDD
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    JOIN SCM_MGR.SCM_SYS_CALENDAR_M D ON A.YYYYMMDD = D.BASIS_YYYYMMDD
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND B.ISO_YYYYWW = D.ISO_YYYYWW
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;

                           
        BEGIN
            v_invalid_Site := NULL;
            BEGIN
                SELECT '● Sales Site : ' || F.SCM_SITE_ID || ' / ● Model : ' || F.ITEM_ID
                INTO v_invalid_Site
                FROM SCM_MGR.DM_PLN_MKT_FCST F
                WHERE EXISTS (
                    SELECT A.DIVISION_ID
                    FROM SCM_MGR.GT_PRDM1_T_MAIN A
                    WHERE A.ACTION         = 'D'
                      AND F.DIVISION_ID    = A.DIVISION_ID
                      AND F.PROJECT_CODE   = A.PROJECT_CODE
                      AND F.SCM_SITE_ID    = A.SCM_SITE_ID
                      AND F.PLANT_SITE_ID  = A.PLANT_SITE_ID
                      AND F.ITEM_ID        = A.ITEM_ID
                      AND F.DOM_EXP        = A.DOM_EXP
                      AND F.FCST_TYPE      = A.FCST_TYPE
                      AND F.INCOTERMS      = A.INCOTERMS
                      AND A.MEASURE        = 'LOC'
                      AND F.MEASURE IN ('MKT_FCST', 'RTF_SCP', 'AS_In_Req')
                      AND F.YYYYMMDD >= TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND F.YYYYMMDD  < TO_CHAR(SCM_MGR.FN_NEXT_DAY(SYSDATE, 'MON') - 7 + 52 * 7, 'YYYYMMDD')
                      AND F.QTY <> 0
                      AND F.FCST_TYPE NOT IN (
                            SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL MST
                            WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT4 = 'FREE'
                            GROUP BY SEGMENT1
                      )
                )
                FETCH FIRST 1 ROWS ONLY;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_invalid_Site := NULL;
            END;

            IF v_invalid_Site IS NOT NULL THEN
                V_DESCRIPTION := 'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.' || CHR(10) || v_invalid_Site;
                V_LOG_TYPE    := 'INVALID';
                RAISE e_validation_error;
            END IF;
        END;
      END IF;                  
    END IF;

                                                                                                                                
                                                                                       
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A021--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                                                                                                
                                                                                                                                
    IF v_is_81 = 'Y' THEN

                                                                                          
        SELECT COUNT(*) INTO v_cnt_check
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        WHERE NVL(A.DIVISION_ID, '-')   = '-'
           OR NVL(A.PROJECT_CODE, '-')  = '-'
           OR NVL(A.SCM_SITE_ID, '-')   = '-'
           OR NVL(A.ITEM_ID, '-')       = '-'
           OR NVL(A.DOM_EXP, '-')       = '-'
           OR NVL(A.FCST_TYPE, '-')     = '-'
           OR NVL(A.INCOTERMS, '-')     = '-'
           OR NVL(A.MEASURE, '-')       = '-'
           OR NVL(A.PLANT_SITE_ID, '-') = '-';

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := ' Check Mandatory Columns ( Fcst type or Incoterms or Customs Handbook or Plant Site ) !';
            RAISE e_validation_error;
        END IF;

                                                                                         
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
          ON   A.DIVISION_ID  = B.SEGMENT3
         AND   A.SCM_SITE_ID  = B.SEGMENT1
         AND   B.LOOKUP_TYPE  = 'AS_SITE_PLANT'
         AND   B.VALID_YN     = 'Y'
        LEFT   JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.DIVISION_ID  = C.SEGMENT1
         AND   A.INCOTERMS    = C.SEGMENT2
         AND   C.VALID_YN     = 'Y'
        WHERE  C.SEGMENT1 IS NULL;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS In Request 메저는 지정된 Incoterms 만 사용가능합니다.';
            RAISE e_validation_error;
        END IF;

                                                                        
        V_VALID_PROJECT_CODE := NULL;
        BEGIN
            SELECT A.PROJECT_CODE INTO V_VALID_PROJECT_CODE
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (
                       SELECT C.DIVISION_ID
                       FROM   SCM_MGR.SCM_MST_PROJECT C
                       WHERE  A.DIVISION_ID  = C.DIVISION_ID
                         AND  A.PROJECT_CODE = C.PROJECT_CODE
                         AND  C.DIVISION_ID <> '40'
                   )
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_PROJECT_CODE := NULL;
        END;

        IF V_VALID_PROJECT_CODE IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || V_VALID_PROJECT_CODE || '] Invalid Project Code !';
            RAISE e_validation_error;
        END IF;

                                                                                              
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            LEFT   JOIN SCM_MGR.SCM_MST_SITE_ITEM F
              ON   A.DIVISION_ID  = F.DIVISION_ID
             AND   A.ITEM_ID      = F.ITEM_ID
             AND   A.PROJECT_CODE = F.PROJECT_CODE
             AND   A.SCM_SITE_ID  = F.SCM_SITE_ID
            JOIN   SCM_MGR.DM_MST_ITEM_SINGLE_V X
              ON   A.DIVISION_ID = X.DIVISION_ID
             AND   A.ITEM_ID     = X.ITEM_ID
            WHERE  CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Cell')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        WHEN INSTR(X.ITEM_CLASS_NAME,'Pack')   > 0 AND NVL(F.CELL_PER_CAR,0) = 0 THEN 1
                        ELSE 0
                   END = 1
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            BEGIN
                SELECT CASE WHEN INSTR(X.ITEM_CLASS_NAME,'Module') > 0 THEN 'Cell/Car or Cell/Module'
                            ELSE 'Cell/Car' END
                INTO   V_VALID_TYPE
                FROM   SCM_MGR.DM_MST_ITEM_SINGLE_V X
                WHERE  X.ITEM_ID = v_valid_item_id
                  AND  ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN V_VALID_TYPE := '-';
            END;
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] ' || V_VALID_TYPE || ' does not exist !';
            RAISE e_validation_error;
        END IF;

                                                                                                     
        V_DESC_81 := NULL;
        BEGIN
            SELECT V_DESCRIPTION_81 INTO V_DESC_81
            FROM (
                SELECT '[' || RTRIM(A.ITEM_ID) || '] '
                    || CASE WHEN (NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                                  OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0)
                            THEN 'Kwh/Cell does not exist !'
                            WHEN B.ATTRIBUTE10 NOT IN (
                                     SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND (SEGMENT1 LIKE '81%' OR SEGMENT1 = '82') AND VALID_YN = 'Y'
                                 )
                            THEN 'CELL_TYPE does not exist !'
                            WHEN NVL(B.CELL_PER_CAR,0) <= 0
                            THEN 'Cell/Car does not exist !'
                       END
                    || CHR(10) || 'Sales Site Project Model 에서 해당 항목을 채워주세요.' AS V_DESCRIPTION_81
                FROM SCM_MGR.GT_PRDM1_T_MAIN A
                JOIN SCM_MGR.SCM_MST_SITE_ITEM B
                  ON A.DIVISION_ID  = B.DIVISION_ID
                 AND A.PROJECT_CODE = B.PROJECT_CODE
                 AND A.SCM_SITE_ID  = B.SCM_SITE_ID
                 AND A.ITEM_ID      = B.ITEM_ID
                JOIN SCM_MGR.DM_MST_ITEM_SINGLE_V C
                  ON A.DIVISION_ID  = C.DIVISION_ID
                 AND A.ITEM_ID      = C.ITEM_ID
                 AND C.ITEM_TYPE    = 'P'
                WHERE (
                        ( NOT REGEXP_LIKE(NVL(B.ATTRIBUTE8,'-'), '^[0-9.]+$')
                          OR TO_NUMBER(CASE WHEN REGEXP_LIKE(NVL(B.ATTRIBUTE8,'0'), '^[0-9.]+$') THEN B.ATTRIBUTE8 ELSE '0' END) <= 0 )
                        OR B.ATTRIBUTE10 NOT IN (
                               SELECT SEGMENT2 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                               WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO' AND (SEGMENT1 LIKE '81%' OR SEGMENT1 = '82') AND VALID_YN = 'Y'
                           )
                        OR NVL(B.CELL_PER_CAR,0) <= 0
                      )
                ORDER BY A.ITEM_ID
                FETCH FIRST 1 ROW ONLY
            );
        EXCEPTION WHEN NO_DATA_FOUND THEN V_DESC_81 := NULL;
        END;

        IF V_DESC_81 IS NOT NULL THEN
            V_DESCRIPTION := V_DESC_81;
            V_LOG_TYPE    := 'INVALID';
            RAISE e_validation_error;
        END IF;

                                                                 
        v_valid_item_id := NULL;
        BEGIN
            SELECT A.ITEM_ID INTO v_valid_item_id
            FROM   SCM_MGR.GT_PRDM1_T_MAIN A
            WHERE  NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I WHERE I.ITEM_ID = A.ITEM_ID)
              AND  ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN v_valid_item_id := NULL;
        END;

        IF v_valid_item_id IS NOT NULL THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '[' || v_valid_item_id || '] Invalid Item ID !';
            RAISE e_validation_error;
        END IF;

                                                                                                     
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  R.MEASURE = 'LOC'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_SITE S
                   WHERE  S.DIVISION_ID = R.DIVISION_ID
                     AND  S.SCM_SITE_ID = R.SCM_SITE_ID
                     AND  S.SITE_TYPE   = 'SALES'
                     AND  S.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Sales Site ! (Sales Site 마스터 미등록/무효 - Sales Price 는 저장해도 조회되지 않아 저장 차단)';
            RAISE e_validation_error;
        END IF;

                                                                                     
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN R
        WHERE  R.ACTION <> 'D'
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_ITEM_SN I
                   WHERE  I.DIVISION_ID = R.DIVISION_ID
                     AND  I.ITEM_ID     = R.ITEM_ID
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'Invalid Item for Division ! (해당 사업부 Item 마스터 미등록 - 저장 차단)';
            RAISE e_validation_error;
        END IF;

                                                                               
        SELECT COUNT(1) INTO v_cnt_check
        FROM (
            SELECT 1 AS DUP
            FROM SCM_MGR.GT_PRDM1_T_MAIN
            WHERE MEASURE = 'LOC' AND NVL(QTY_PRICE, 0) <> 0
            GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
            HAVING COUNT(CURRENCY) > 1
        );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

                                                                              
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE S
        WHERE  EXISTS (
                   SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN R
                   WHERE  S.DIVISION_ID   = R.DIVISION_ID
                     AND  S.PROJECT_CODE  = R.PROJECT_CODE
                     AND  S.SCM_SITE_ID   = R.SCM_SITE_ID
                     AND  S.PLANT_SITE_ID = R.PLANT_SITE_ID
                     AND  S.ITEM_ID       = R.ITEM_ID
                     AND  S.YYYYMMDD      = R.YYYYMMDD
                     AND  S.MEASURE       = R.MEASURE
                     AND  S.DOM_EXP       = R.DOM_EXP
                     AND  S.FCST_TYPE     = R.FCST_TYPE
                     AND  S.INCOTERMS     = R.INCOTERMS
                     AND  R.ACTION        = 'I'
                     AND  R.MEASURE       = 'LOC'
               )
          AND  ROWNUM = 1;

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := '동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.';
            RAISE e_validation_error;
        END IF;

                                                                                                         
                                                                                                    
        SELECT COUNT(1) INTO v_cnt_check
        FROM   SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL C
          ON   A.FCST_TYPE   = C.SEGMENT1
         AND   C.LOOKUP_TYPE = 'SALES_TYPE_CODE'
         AND   C.ATTRIBUTE2  = 'Y'
        WHERE  A.ACTION = 'I'
          AND  (A.V_ATTRIBUTE10 IS NULL OR TRIM(A.V_ATTRIBUTE10) = '')                                           
          AND  NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL B
                   WHERE  A.SCM_SITE_ID = B.SEGMENT1
                     AND  B.LOOKUP_TYPE = 'AS_SITE_PLANT'
                     AND  B.SEGMENT3    = A.DIVISION_ID
                     AND  B.VALID_YN    = 'Y'
               );

        IF v_cnt_check > 0 THEN
            V_LOG_TYPE    := 'INVALID';
            V_DESCRIPTION := 'AS 관련 FCST TYPE 의 신규 입력은 AS FROM SITE 지정이 필요합니다.';                   
            RAISE e_validation_error;
        END IF;

    END IF;
                                                                                                                                
                                        
                                                                                                                                

                                                                                                                                
                            
                                                                                                                                
                                                                                                                                
                            
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 3. VALIDATION CHECK END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                          
                                                                                                                                

                                                                                                                                
                                     
                                              
                        
                                  
                                                                                                                                
                                                                                                                                
                   
                                                                                                                                
    INSERT INTO SCM_MGR.GT_PRDM1_TEMP_EXCH
    ( DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE )
    SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
    FROM SCM_MGR.DM_MST_EXCHANGE_RATE A
    JOIN SCM_MGR.GT_PRDM1_T_MAIN B
      ON A.DIVISION_ID = B.DIVISION_ID
     AND A.YYYYMMDD   = SUBSTR(B.YYYYMMDD, 1, 6) || '01'
     AND A.CURRENCY   = 'KRW'
    WHERE B.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_TEMP_EXCH');

                                                                                                                                
                                   
                                                                                                                                
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'KRW' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
                                                 
         , ROUND(NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END, 3) AS QTY_PRICE                                 
                                               
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND EX.CURRENCY      = 'KRW'
    WHERE T.MEASURE = 'LOC'
    UNION ALL
    SELECT T.ACTION, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
         , 'USD' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
                                                 
         , ROUND(ROUND((NVL(T.QTY_PRICE, 0) * CASE WHEN T.CURRENCY = 'KRW' THEN 1 ELSE EX.EXCHANGE_PRICE END), 3) / USD.EXCHANGE_PRICE, 3) AS QTY_PRICE                                 
                                               
         , T.CREATED_BY, '', '', '', '', '', '', '', '', '', '', '', ''
    FROM SCM_MGR.GT_PRDM1_T_MAIN T
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH EX
                 ON EX.DIVISION_ID   = T.DIVISION_ID
                AND EX.UNIT_CURRENCY = T.CURRENCY
                AND EX.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
    LEFT OUTER JOIN SCM_MGR.GT_PRDM1_TEMP_EXCH USD
                 ON USD.DIVISION_ID   = T.DIVISION_ID
                AND USD.YYYYMMDD     LIKE SUBSTR(T.YYYYMMDD, 1, 6) || '%'
                AND USD.CURRENCY      = 'KRW'
                AND USD.UNIT_CURRENCY = 'USD'
    WHERE T.MEASURE = 'LOC';

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A022--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                   
                                                                                                                                
    IF v_is_81 = 'N' THEN                                                                   
    INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
    ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
    , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY
    , QTY_PRICE, CREATED_BY
    , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4, V_ATTRIBUTE5, V_ATTRIBUTE6
    , V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
    SELECT AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID, AMT.DOM_EXP, AMT.FCST_TYPE
         , AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD, MAX(AMT.CURRENCY) AS CURRENCY
         , SUM(AMT.QTY) AS QTY
         , MAX(AMT.CREATED_BY) AS CREATED_BY, MAX(AMT.V_ATTRIBUTE1) AS V_ATTRIBUTE1, MAX(AMT.V_ATTRIBUTE2) AS V_ATTRIBUTE2
         , MAX(AMT.V_ATTRIBUTE3) AS V_ATTRIBUTE3, MAX(AMT.V_ATTRIBUTE4) AS V_ATTRIBUTE4, MAX(AMT.V_ATTRIBUTE5) AS V_ATTRIBUTE5
         , MAX(AMT.V_ATTRIBUTE6) AS V_ATTRIBUTE6, MAX(AMT.V_ATTRIBUTE7) AS V_ATTRIBUTE7, MAX(AMT.V_ATTRIBUTE8) AS V_ATTRIBUTE8
         , MAX(AMT.V_ATTRIBUTE9) AS V_ATTRIBUTE9, MAX(AMT.V_ATTRIBUTE10) AS V_ATTRIBUTE10
         , MAX(AMT.V_BOM_YN) AS V_BOM_YN, MAX(AMT.V_VMI_YN) AS V_VMI_YN
    FROM (
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
                                                     
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
                                                   
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
        UNION ALL
        SELECT W.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
                                                     
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY_PRICE, 0) * NVL(SP.PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
                                                   
             , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN W
        INNER JOIN SCM_MGR.DM_PLN_CFM_SELLING_PRICE SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
                            AND W2.MEASURE IN ('LOC', 'KRW'))
        UNION ALL
        SELECT SP.ACTION AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID
             , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
             , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW'
                    WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
               END AS MEASURE
             , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
                                                     
             , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
                    WHEN SP.MEASURE = 'LOC' THEN CAST(TO_CHAR(NVL(W.QTY, 0) * NVL(SP.QTY_PRICE, 0), 'FM99999999999999999990.99999') AS NUMBER(30, 10))
               END AS QTY
                                                   
             , SP.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN W
        INNER JOIN SCM_MGR.GT_PRDM1_T_MAIN SP
                ON SP.DIVISION_ID       = W.DIVISION_ID
               AND SP.PROJECT_CODE      = W.PROJECT_CODE
               AND SP.END_CUSTOMER      = W.END_CUSTOMER
               AND SP.SCM_SITE_ID       = W.SCM_SITE_ID
               AND SP.ITEM_ID           = W.ITEM_ID
               AND SP.DOM_EXP           = W.DOM_EXP
               AND SP.FCST_TYPE         = W.FCST_TYPE
               AND SP.INCOTERMS         = W.INCOTERMS
               AND SP.PLANT_SITE_ID     = W.PLANT_SITE_ID
               AND SP.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
               AND SP.YYYYMMDD = (SELECT BASIS_START_DATE FROM SCM_MGR.SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = W.YYYYMMDD)
               AND SP.MEASURE IN ('LOC', 'KRW')
        WHERE W.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W2
                          WHERE W2.DIVISION_ID       = W.DIVISION_ID
                            AND W2.PROJECT_CODE      = W.PROJECT_CODE
                            AND W2.END_CUSTOMER      = W.END_CUSTOMER
                            AND W2.SCM_SITE_ID       = W.SCM_SITE_ID
                            AND W2.ITEM_ID           = W.ITEM_ID
                            AND W2.DOM_EXP           = W.DOM_EXP
                            AND W2.FCST_TYPE         = W.FCST_TYPE
                            AND W2.INCOTERMS         = W.INCOTERMS
                            AND W2.PLANT_SITE_ID     = W.PLANT_SITE_ID
                            AND W2.CELL_PROD_SITE_ID = W.CELL_PROD_SITE_ID
                            AND W2.YYYYMMDD          = W.YYYYMMDD
                            AND W2.MEASURE           = W.MEASURE)
                                                                                           
        UNION ALL
        SELECT T.ACTION AS ACT, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID
             , T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, B.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
                                                     
             , NVL(T.QTY_PRICE, 0) AS QTY_PRICE                                 
                                                   
             , T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4
             , '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8
             , '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
        FROM (SELECT * FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE QTY_PRICE = 0 AND MEASURE = 'MKT_FCST') T,
        (SELECT 'MKT_AMT_KRW' MEASURE FROM DUAL
         UNION
         SELECT 'MKT_AMT_LOC' MEASURE FROM DUAL
        ) B
                                                                                         
    ) AMT
    GROUP BY AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID
           , AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD;

    n_update_cnt := SQL%ROWCOUNT;                                   
    ELSE
        n_update_cnt := 0;
    END IF;                          

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRDM1_T_MAIN');

                                                                                                                                
                                   
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A023--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                       
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 4. MKT_AMT_KRW, MKT_AMT_LOC, LOC, KRW #T_MAIN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                     
                                                                                                                                

                                                                                                                                
                                                 
                                                                                                                                
                                                                                        
                                                                                          
                                                                                  
                                                        
    UPDATE SCM_MGR.GT_PRDM1_T_MAIN
       SET DIVISION_ID       = NVL(DIVISION_ID,       '-')
         , PROJECT_CODE      = NVL(PROJECT_CODE,      '-')
         , END_CUSTOMER      = NVL(END_CUSTOMER,      '-')
         , SCM_SITE_ID       = NVL(SCM_SITE_ID,       '-')
         , ITEM_ID           = NVL(ITEM_ID,           '-')
         , DOM_EXP           = NVL(DOM_EXP,           '-')
         , FCST_TYPE         = NVL(FCST_TYPE,         '-')
         , INCOTERMS         = NVL(INCOTERMS,         '-')
         , MEASURE           = NVL(MEASURE,           '-')
         , PLANT_SITE_ID     = NVL(PLANT_SITE_ID,     '-')
         , CELL_PROD_SITE_ID = NVL(CELL_PROD_SITE_ID, '-')
         , YYYYMMDD          = NVL(YYYYMMDD,          '-')
         , CURRENCY          = NVL(CURRENCY,          '-')
     WHERE DIVISION_ID   IS NULL OR PROJECT_CODE      IS NULL OR END_CUSTOMER      IS NULL
        OR SCM_SITE_ID   IS NULL OR ITEM_ID           IS NULL OR DOM_EXP           IS NULL
        OR FCST_TYPE     IS NULL OR INCOTERMS         IS NULL OR MEASURE           IS NULL
        OR PLANT_SITE_ID IS NULL OR CELL_PROD_SITE_ID IS NULL OR YYYYMMDD          IS NULL
        OR CURRENCY      IS NULL;
    V_GETDATE := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN                                                                                     
                                                            
    DELETE FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    WHERE EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID, M.PLANT_SITE_ID
                 , M.CELL_PROD_SITE_ID, M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                  , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
          AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
          AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
    );

                                                                       
    MERGE INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID
                                                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.YYYYMMDD          = B.YYYYMMDD
    AND A.MEASURE           = B.MEASURE
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS)
    WHEN MATCHED THEN
    UPDATE
    SET A.CURRENCY         = B.CURRENCY
      , A.PRICE            = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
                                                                                                           
        DELETE FROM SCM_MGR.SCM_MST_FUTURE_PRICE A
        WHERE EXISTS (
            SELECT 1 FROM (
                SELECT M.DIVISION_ID, M.PROJECT_CODE, M.SCM_SITE_ID, M.PLANT_SITE_ID
                     , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.QTY_PRICE
                     , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                      , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                      , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                      , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('KRW', 'USD', 'LOC')
            ) B
            WHERE RN = 1
              AND B.QTY_PRICE = 0
              AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE
              AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
              AND B.ITEM_ID = A.ITEM_ID AND B.YYYYMMDD = A.YYYYMMDD AND B.MEASURE = A.MEASURE
              AND B.DOM_EXP = A.DOM_EXP AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS
        );

                                                                                                                     
        MERGE INTO SCM_MGR.SCM_MST_FUTURE_PRICE A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.PLANT_SITE_ID
                                                         , M.ITEM_ID, M.YYYYMMDD, M.MEASURE, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('KRW', 'USD', 'LOC') AND M.QTY_PRICE <> 0)
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.YYYYMMDD          = B.YYYYMMDD
        AND A.MEASURE           = B.MEASURE
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS)
        WHEN MATCHED THEN
        UPDATE
        SET A.CURRENCY         = B.CURRENCY
          , A.PRICE            = CAST(B.QTY_PRICE AS NUMBER(20,10))
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE
        , DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.YYYYMMDD, B.CURRENCY, B.MEASURE
        , B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, CAST(B.QTY_PRICE AS NUMBER(20,10)), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    END IF;                     

    n_update_cnt := SQL%ROWCOUNT;                                   

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_SELLING_PRICE END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                               
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A024--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                  
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 5. DM_PLN_CFM_SELLING_PRICE IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                
                                                                                                                                

                                                                                                                                
                                                   
                                                   
                                                       
                                                   
                                                                                                                                
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                     
                                                     
    IF v_is_81 = 'N' THEN                                  
    DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    WHERE A.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
      AND EXISTS (
        SELECT 1 FROM (
            SELECT M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER, M.SCM_SITE_ID
                 , M.ITEM_ID, M.DOM_EXP, M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                 , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD, M.QTY_PRICE
                 , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                  , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                  , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                  , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
            FROM SCM_MGR.GT_PRDM1_T_MAIN M WHERE M.MEASURE IN ('MKT_AMT_KRW', 'MKT_AMT_LOC')
        ) B
        WHERE RN = 1
          AND B.QTY_PRICE = 0
          AND B.DIVISION_ID = A.DIVISION_ID AND B.PROJECT_CODE = A.PROJECT_CODE AND B.END_CUSTOMER = A.END_CUSTOMER
          AND B.SCM_SITE_ID = A.SCM_SITE_ID AND B.ITEM_ID = A.ITEM_ID AND B.DOM_EXP = A.DOM_EXP
          AND B.FCST_TYPE = A.FCST_TYPE AND B.INCOTERMS = A.INCOTERMS AND B.MEASURE = A.MEASURE
          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID AND B.YYYYMMDD = A.YYYYMMDD
    );
    END IF;                              

                                                                                                    
    IF v_is_81 = 'Y' THEN
        INSERT INTO SCM_MGR.GT_PRDM1_T_MAIN
        ( ACTION, DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY
        , V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
        , V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN )
        SELECT A.ACTION, A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'VMI_In_Req' AS MEASURE
             , A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.CURRENCY, A.QTY_PRICE, A.CREATED_BY
             , A.V_ATTRIBUTE1, A.V_ATTRIBUTE2, A.V_ATTRIBUTE3, A.V_ATTRIBUTE4
             , A.V_ATTRIBUTE5, A.V_ATTRIBUTE6, A.V_ATTRIBUTE7, A.V_ATTRIBUTE8, A.V_ATTRIBUTE9, A.V_ATTRIBUTE10, A.V_BOM_YN, A.V_VMI_YN
        FROM SCM_MGR.GT_PRDM1_T_MAIN A
        JOIN SCM_MGR.SCM_MST_SITE B
          ON A.SCM_SITE_ID = B.SCM_SITE_ID
         AND A.DIVISION_ID = B.DIVISION_ID
         AND B.VMI_YN      = 'Y'
        WHERE A.MEASURE = 'MKT_FCST'
          AND NOT EXISTS (
                SELECT 1 FROM SCM_MGR.GT_PRDM1_T_MAIN W
                WHERE W.DIVISION_ID   = A.DIVISION_ID
                  AND W.PROJECT_CODE  = A.PROJECT_CODE
                  AND W.SCM_SITE_ID   = A.SCM_SITE_ID
                  AND W.ITEM_ID       = A.ITEM_ID
                  AND W.DOM_EXP       = A.DOM_EXP
                  AND W.FCST_TYPE     = A.FCST_TYPE
                  AND W.INCOTERMS     = A.INCOTERMS
                  AND W.PLANT_SITE_ID = A.PLANT_SITE_ID
                  AND W.YYYYMMDD      = A.YYYYMMDD
                  AND W.MEASURE       = 'VMI_In_Req'
          );
    END IF;

                                                                                                    
                                        
    IF v_is_81 = 'N' THEN                                                                                  
    MERGE INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
    USING (SELECT * FROM (
               SELECT M.*
                    , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE, M.END_CUSTOMER
                                                     , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                     , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                     , M.PLANT_SITE_ID, M.CELL_PROD_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
               FROM SCM_MGR.GT_PRDM1_T_MAIN M
               WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST')                         
                 AND M.QTY_PRICE <> 0)
           WHERE RN = 1) B
    ON (A.DIVISION_ID       = B.DIVISION_ID
    AND A.PROJECT_CODE      = B.PROJECT_CODE
    AND A.END_CUSTOMER      = B.END_CUSTOMER
    AND A.SCM_SITE_ID       = B.SCM_SITE_ID
    AND A.ITEM_ID           = B.ITEM_ID
    AND A.DOM_EXP           = B.DOM_EXP
    AND A.FCST_TYPE         = B.FCST_TYPE
    AND A.INCOTERMS         = B.INCOTERMS
    AND A.MEASURE           = B.MEASURE
    AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
    AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    AND A.YYYYMMDD          = B.YYYYMMDD)
    WHEN MATCHED THEN
    UPDATE
    SET A.QTY              = B.QTY_PRICE
      , A.LAST_UPDATED_BY  = B.CREATED_BY
      , A.LAST_UPDATE_DATE = V_GETDATE
    WHEN NOT MATCHED THEN
    INSERT
    ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
    , CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
    VALUES
    ( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
    , B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE);
    ELSE
                                                                                                        
                                                                                                 
        MERGE INTO SCM_MGR.DM_PLN_MKT_FCST A
        USING (SELECT * FROM (
                   SELECT M.*
                        , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.PROJECT_CODE
                                                         , M.SCM_SITE_ID, M.ITEM_ID, M.DOM_EXP
                                                         , M.FCST_TYPE, M.INCOTERMS, M.MEASURE
                                                         , M.PLANT_SITE_ID, M.YYYYMMDD ORDER BY ROWNUM) AS RN
                   FROM SCM_MGR.GT_PRDM1_T_MAIN M
                   WHERE M.MEASURE IN ('MKT_FCST', 'VMI_In_Req'))
               WHERE RN = 1) B
        ON (A.DIVISION_ID       = B.DIVISION_ID
        AND A.PROJECT_CODE      = B.PROJECT_CODE
        AND A.SCM_SITE_ID       = B.SCM_SITE_ID
        AND A.ITEM_ID           = B.ITEM_ID
        AND A.DOM_EXP           = B.DOM_EXP
        AND A.FCST_TYPE         = B.FCST_TYPE
        AND A.INCOTERMS         = B.INCOTERMS
        AND A.MEASURE           = B.MEASURE
        AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
        AND A.YYYYMMDD          = B.YYYYMMDD)
        WHEN MATCHED THEN
        UPDATE
        SET A.QTY              = NVL(B.QTY_PRICE, 0)
          , A.LAST_UPDATED_BY  = B.CREATED_BY
          , A.LAST_UPDATE_DATE = V_GETDATE
          , A.ATTRIBUTE10      = NVL(NULLIF(B.V_ATTRIBUTE10, ''), A.ATTRIBUTE10)                                       
        WHEN NOT MATCHED THEN
        INSERT
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
        , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        VALUES
        ( B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID, B.YYYYMMDD
        , NVL(B.QTY_PRICE, 0), B.CREATED_BY, V_GETDATE, B.CREATED_BY, V_GETDATE
        , NULL, NULL, NULL, NULL, NULL
        , NULL, NULL, NULL, NULL, NULLIF(B.V_ATTRIBUTE10, '') );
    END IF;                     

    n_update_cnt := SQL%ROWCOUNT;                                   

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                 
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                    
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 6. DM_PLN_CFM_MKT_DEMAND_PLAN IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                  
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A025_EE--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                                                                            
                                                                                                                                                  
                                                                                                                                
                                                        
                                                                                                                                
    n_EE_chk := 0;
    IF v_is_81 = 'N' THEN                                         
    SELECT COUNT(*) INTO n_EE_chk
    FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
       , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
    WHERE RSLT.DIVISION_ID = ITEM.DIVISION_ID
      AND RSLT.ITEM_ID     = ITEM.ITEM_ID
      AND ITEM.ACTIVE_FLAG = 'Y'
                                       
      AND RSLT.ITEM_ID IN (
            SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
            WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
      );

    IF n_EE_chk > 0 THEN
        DELETE FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd            
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID         = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID             = ITEM.ITEM_ID
                  AND A.DIVISION_ID            = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE           = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER           = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID            = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID                = RSLT.ITEM_ID
                  AND A.DOM_EXP                = RSLT.DOM_EXP
                  AND A.FCST_TYPE              = RSLT.FCST_TYPE
                  AND A.INCOTERMS              = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID          = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID      = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG         = 'Y'
                                                   
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )                             
          );

        INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
        , PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
        , ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
             , 'RTF_SYS_RP' AS MEASURE
             , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, 'DMF0082_SYSTEM' AS CREATED_BY, SYSDATE AS CREATION_DATE
             , 'DMF0082_SYSTEM' AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
             , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID
        FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.MEASURE = (SELECT MEASURE FROM SCM_MGR.GT_PRDM1_T_MAIN WHERE MEASURE IN ('SCM_FCST', 'MKT_FCST') GROUP BY MEASURE FETCH FIRST 1 ROWS ONLY)
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd            
          AND EXISTS (
                SELECT RSLT.DIVISION_ID
                FROM SCM_MGR.GT_PRDM1_T_MAIN RSLT
                   , SCM_MGR.DM_MST_ITEM_SINGLE_V ITEM
                WHERE RSLT.DIVISION_ID    = ITEM.DIVISION_ID
                  AND RSLT.ITEM_ID        = ITEM.ITEM_ID
                  AND A.DIVISION_ID       = RSLT.DIVISION_ID
                  AND A.PROJECT_CODE      = RSLT.PROJECT_CODE
                  AND A.END_CUSTOMER      = RSLT.END_CUSTOMER
                  AND A.SCM_SITE_ID       = RSLT.SCM_SITE_ID
                  AND A.ITEM_ID           = RSLT.ITEM_ID
                  AND A.DOM_EXP           = RSLT.DOM_EXP
                  AND A.FCST_TYPE         = RSLT.FCST_TYPE
                  AND A.INCOTERMS         = RSLT.INCOTERMS
                  AND A.PLANT_SITE_ID     = RSLT.PLANT_SITE_ID
                  AND A.CELL_PROD_SITE_ID = RSLT.CELL_PROD_SITE_ID
                  AND ITEM.ACTIVE_FLAG    = 'Y'
                                                   
                  AND RSLT.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'
                  )                             
          );

                                                                                                
        UPDATE SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A
        SET A.ATTRIBUTE2 = (SELECT LOOK.SEGMENT3 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                             WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                               AND A.DIVISION_ID = LOOK.SEGMENT1 AND ROWNUM = 1)
        WHERE A.MEASURE  = 'RTF_SYS_RP'
          AND A.YYYYMMDD >= v_plan_start_yyyymmdd
          AND EXISTS (
                SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                WHERE LOOK.LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID' AND LOOK.VALID_YN = 'Y'
                  AND A.DIVISION_ID = LOOK.SEGMENT1
                  AND A.ITEM_ID LIKE '' || NVL(LOOK.ATTRIBUTE1, A.ITEM_ID) || '%'
                  AND A.ITEM_ID IN (
                        SELECT K.ITEM_ID FROM SCM_MGR.SCM_MST_ITEM_SN K
                        WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = LOOK.SEGMENT2 AND K.ACTIVE_FLAG = 'Y'
                  )
          );
                                                                                              

        n_update_cnt := SQL%ROWCOUNT;                                   

                                                                                                                                    
                                                           
                                                                                                                                    
        V_LOG_TYPE    := 'ING';
        V_LOG_MESSAGE := '■ 6_EE. DM_PLN_CFM_MKT_DEMAND_PLAN_EE IMPORT';
        N_LOG_COUNT   := n_update_cnt;
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;

        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                    
                                                         
                                                                                                                                    
    END IF;
    END IF;                  
                                                                                                                                
                                                      
                                                                                                                                
                                                                                                                                                
                                                                                                                                                                                            

                                                                                                                                
                                                   
                                                                                                                                
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN                    
    INSERT INTO SCM_MGR.DM_PLN_CFM_SELLING_PRICE_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_SELLING_PRICE_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE, SYSDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('KRW', 'USD', 'LOC');
                                                                      
    ELSE
                                                                    
        INSERT INTO SCM_MGR.SCM_MST_FUTURE_PRICE_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
        , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE, CREATED_BY, CREATION_DATE
        , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD
             , CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE
             , CREATED_BY, V_GETDATE
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('KRW', 'USD', 'LOC');
    END IF;                    

    n_update_cnt := SQL%ROWCOUNT;                                   

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                 
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A026--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                    
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 7. DM_PLN_CFM_SELLING_PRICE_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                  
                                                                                                                                

                                                                                                                                
                                                     
                                                                                                                                
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H START', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

    IF v_is_81 = 'N' THEN                    
    INSERT INTO SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_H
    ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
    , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
    , LAST_UPDATED_BY, LAST_UPDATE_DATE )
    SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_CFM_MKT_DEMAND_PLAN_H.NEXTVAL, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
         , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY, V_GETDATE
         , CREATED_BY, V_GETDATE
    FROM SCM_MGR.GT_PRDM1_T_MAIN
    WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req', 'MKT_AMT_KRW', 'MKT_AMT_LOC', 'SCM_FCST');
                                                                      
    ELSE
                                                                                                                  
        INSERT INTO SCM_MGR.DM_PLN_MKT_FCST_H
        ( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
        , YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
        , LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
        , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DIVISION_ID, SCM_MGR.SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
             , YYYYMMDD, NVL(QTY_PRICE, 0), CREATED_BY, V_GETDATE, CREATED_BY
             , V_GETDATE, NULL, NULL, NULL, NULL, NULL
             , NULL, NULL, NULL, NULL, NULLIF(V_ATTRIBUTE10, '')
        FROM SCM_MGR.GT_PRDM1_T_MAIN
        WHERE MEASURE IN ('MKT_FCST', 'VMI_In_Req');
    END IF;                    

    n_update_cnt := SQL%ROWCOUNT;                                   

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H END', '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                   
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A027--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                
                                                      
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 8. DM_PLN_CFM_MKT_DEMAND_PLAN_H IMPORT';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                    
                                                                                                                                

                                                                                                                                
                                                      
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 9. PR_DM_PLN_CFM_TO_MKT_FCST START';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                    
                                                                                                                                

                                                                                                                                
                                         
                                                                                                                                
                                                                                                   
                                                         
                                                                                             
                                                                                           
                                                                                  
    IF v_is_81 = 'N' THEN
        SCM_MGR.PR_DM_PLN_CFM_TO_MKT_FCST(v_created_by, v_inner_result_cursor);
    END IF;
                                                                                                                                
                                       
                                                                                                                                

                                                                                                                                
                                                  
                                                                                                                                
    V_LOG_TYPE    := 'ING';
    V_LOG_MESSAGE := '■ 10. PR_DM_PLN_CFM_TO_MKT_FCST END';
    N_LOG_COUNT   := n_update_cnt;
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                                                                                
                                                  
                                                                                                                                

    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ING', N_LOG_COUNT,
        '■ : A028--' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), '', SYSDATE,
        v_created_by,
        V_PROC_INPUT, NULL, NULL, NULL); END;

                                                                                                                                   
                     
                                                                                                                                   
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## SUCCESS END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

                                                                             
                                                                                                                  
    BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
        D_EVENT_DATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;
                                                                           
                                                                                                                                   
                   
                                                                                                                                   

                                                                                                                                   
                      
                                                                                                                                   
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN e_validation_error THEN
        ROLLBACK;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', N_LOG_COUNT,
            '########## FAIL-2 END of procedure ##########', V_DESCRIPTION,
            SYSDATE, v_created_by, V_PROC_INPUT, NULL, NULL, NULL); END;

                          
        OPEN O_RESULT_CURSOR FOR
            SELECT 'F' AS RESULT_CODE, V_DESCRIPTION AS RESULT_MSG, 'Validation Check' AS ERR_EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := '########## FAIL-1 END of procedure ##########';
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SUBSTR(SQLERRM, 1, 4000);
        V_BACKTRACE   := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
        D_EVENT_DATE  := SYSDATE;
        BEGIN SCM_MGR.PR_DM_SYS_LOG_BATCH(
            $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION,
            D_EVENT_DATE, v_created_by, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
        ); END;
        RAISE_APPLICATION_ERROR(-20001, V_SQL_ERRMSG || ' ' || V_BACKTRACE);

END P_DMF0082_SAVE_MAIN_DATA;


                                                                               
                                                               
  
                
                                                            
                                                                  
                                                         
                                                                                  
                                                                            
                                                                                
                                                                           
                                                       
                                                                        
                                                                                                 
                                                                         
                                                                         
                                                                              
                                                                            
                                                                              
                                                                            
                                                                                         
                                                                           
                                                    
                                                            
                                                  
                                                                               
PROCEDURE P_DMF0082_GET_EXCEL_FORM_DATA (
    p_division_id               IN  VARCHAR2
  , p_dept_id                   IN  VARCHAR2
  , p_end_customer              IN  VARCHAR2
  , p_biz_type                  IN  VARCHAR2
  , p_from_yyyymmdd             IN  VARCHAR2
  , p_to_yyyymmdd               IN  VARCHAR2
  , p_sales_site                IN  VARCHAR2
  , p_item_id                   IN  VARCHAR2
  , p_version_type              IN  VARCHAR2
  , p_qty_yn                    IN  VARCHAR2
  , p_ses_user_id               IN  VARCHAR2
  , p_user_group                IN  VARCHAR2
  , p_plant_site_id             IN  VARCHAR2 DEFAULT 'ALL'
  , p_project_code              IN  VARCHAR2 DEFAULT 'ALL'
  , p_owner                     IN  VARCHAR2 DEFAULT 'ALL'
  , p_sender_code               IN  VARCHAR2 DEFAULT 'ALL'
  , o_rc1                       OUT SYS_REFCURSOR
  , o_result_cursor             OUT SYS_REFCURSOR
)
AS
    v_rc_main                   SYS_REFCURSOR;
    v_rc_d1                     SYS_REFCURSOR;
    v_rc_d2                     SYS_REFCURSOR;
    v_rc_d3                     SYS_REFCURSOR;
    v_rc_d4                     SYS_REFCURSOR;
    v_rc_res                    SYS_REFCURSOR;
    n_key_cnt                   PLS_INTEGER := 0;

    V_PROC_INPUT                VARCHAR2(4000 CHAR);
    V_BACKTRACE                 VARCHAR2(4000 CHAR);
    V_SQL_CODE                  VARCHAR2(100  CHAR);
    V_SQL_ERRMSG                VARCHAR2(1000 CHAR);
    n_log_count                 PLS_INTEGER := 0;
    V_PROGRAM_NAME              VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN
                                                                            
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

                                                                            
                                                             
                                              
                                                                            
    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id, p_dept_id, p_end_customer, p_biz_type
      , p_from_yyyymmdd, p_to_yyyymmdd, p_sales_site, p_item_id
      , p_version_type, p_qty_yn, p_ses_user_id, p_user_group
      , p_plant_site_id, p_project_code, p_owner, p_sender_code
      , v_rc_main, v_rc_d1, v_rc_d2, v_rc_d3, v_rc_d4, v_rc_res
    );
    BEGIN IF v_rc_main IS NOT NULL THEN CLOSE v_rc_main; END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d1   IS NOT NULL THEN CLOSE v_rc_d1;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d2   IS NOT NULL THEN CLOSE v_rc_d2;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d3   IS NOT NULL THEN CLOSE v_rc_d3;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_d4   IS NOT NULL THEN CLOSE v_rc_d4;   END IF; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN IF v_rc_res  IS NOT NULL THEN CLOSE v_rc_res;  END IF; EXCEPTION WHEN OTHERS THEN NULL; END;

    SELECT COUNT(*) INTO n_key_cnt FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE;

                                                                            
                                                         
                                                                            
    OPEN o_rc1 FOR
    WITH WT_KEY AS (
        SELECT G.DIVISION_ID
             , G.END_CUSTOMER
             , G.SCM_SITE_ID
             , G.ITEM_ID
             , G.INCOTERMS
             , G.FCST_TYPE
             , G.DOM_EXP
             , G.CELL_PROD_SITE_ID
                                                  
             , NVL(MAX(CASE WHEN G.MEASURE = 'LOC' THEN G.CURRENCY END), MAX(G.CURRENCY)) AS CURRENCY
                                                           
             , MAX(G.DEPT_ID)                        AS TEAM_ID
             , MAX(G.DEPT_NAME_KO)                   AS TEAM_NAME_KO
             , MAX(G.SOLDTO_CUSTOMER)                AS SOLDTO_CUSTOMER
             , MAX(G.COUNTRY_NAME)                   AS COUNTRY_NAME
             , MAX(G.CITY_NAME)                      AS CITY_NAME
             , MAX(G.ITEM_NAME)                      AS ITEM_NAME
             , MAX(G.NICK_NAME)                      AS NICK_NAME
             , MAX(G.ITEM_TYPE)                      AS ITEM_TYPE
             , MAX(G.CUST_GROUP)                     AS CUST_GROUP
             , MAX(G.CUST_GROUP_DTL)                 AS CUST_GROUP_DTL
             , MAX(G.OWNER)                          AS OWNER
             , MAX(G.APPLICATION)                    AS APPLICATION
             , MAX(G.ROUTE)                          AS ROUTE
             , MAX(G.MDM_PROJECT_NAME)               AS MDM_PROJECT_NAME
             , MAX(G.MIN_CAPACITY)                   AS MIN_CAPACITY
             , MAX(G.FORECAST_INFO_BIZ_TYPE)         AS FORECAST_INFO_BIZ_TYPE
             , MAX(G.CELL_TYPE)                      AS CELL_TYPE
             , MAX(G.CELL_MODEL)                     AS FORECAST_INFO_CELL_MODEL
             , MAX(G.FORECAST_INFO_CELL_PACK_COUNT)  AS FORECAST_INFO_CELL_PACK_COUNT
             , MAX(G.FORECAST_INFO_ALL)              AS FORECAST_INFO_ALL
             , MAX(G.FORECAST_INFO_SPEC)             AS FORECAST_INFO_SPEC
             , MAX(G.FORECAST_INFOR_VERSION)         AS FORECAST_INFOR_VERSION
             , MAX(G.CELL_MODEL_NICK_NAME)           AS CELL_MODEL_NICK_NAME
             , MAX(G.VMI_YN)                         AS VMI_YN
             , MAX(G.DMS_SALES)                      AS DMS_SALES
             , MAX(G.DMS_CUSTOMER)                   AS DMS_CUSTOMER
             , MAX(G.AS_FROM_SITE)                   AS AS_FROM_SITE
             , MAX(G.LAST_UPDATED_BY)                AS LAST_UPDATED_BY
             , MAX(G.SENDER_NAME)                    AS SENDER_NAME
          FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE G
         GROUP BY G.DIVISION_ID, G.END_CUSTOMER, G.SCM_SITE_ID, G.ITEM_ID
                , G.INCOTERMS, G.FCST_TYPE, G.DOM_EXP, G.CELL_PROD_SITE_ID
    )
                                                
    , WT_MEASURE AS (
        SELECT L.SEGMENT2  AS DIVISION_ID
             , L.SEGMENT3  AS MEASURE_CODE
             , L.SEGMENT4  AS MEASURE_NAME
             , L.ATTRIBUTE3 AS VMI_COND
             , ROW_NUMBER() OVER (PARTITION BY L.SEGMENT2 ORDER BY L.SEGMENT3) AS MEASURE_SORT
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
         INNER JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER M
            ON  M.LOOKUP_TYPE = L.LOOKUP_TYPE
            AND M.VALID_YN    = 'Y'
         WHERE L.LOOKUP_TYPE = 'DM_UI_EDITABLE_MEASURE'
           AND L.SEGMENT1    = 'DMF0082'
           AND L.VALID_YN    = 'Y'
           AND L.ATTRIBUTE1  = 'Y'                                       
    )
                                                  
    , WT_EC AS (
        SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS EC_CODE, MAX(SEGMENT3) AS EC_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'END_CUSTOMER' AND VALID_YN = 'Y' AND SEGMENT2 <> '-'
         GROUP BY SEGMENT1, SEGMENT2
    )
                                               
    , WT_FCST AS (
        SELECT SEGMENT1 AS FCST_CODE, MAX(SEGMENT2) AS FCST_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND VALID_YN = 'Y'
           AND NVL(ATTRIBUTE2, '-') <> 'Y'
         GROUP BY SEGMENT1
    )
                                                    
    , WT_CPS AS (
        SELECT SEGMENT1 AS CPS_CODE, MAX(ATTRIBUTE1) AS CPS_NAME
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND VALID_YN = 'Y'
         GROUP BY SEGMENT1
    )
    SELECT K.DIVISION_ID
         , NVL(EC.EC_NAME, K.END_CUSTOMER)      AS END_CUSTOMER
         , K.SCM_SITE_ID
         , K.ITEM_ID
         , K.INCOTERMS
         , NVL(FT.FCST_NAME, K.FCST_TYPE)       AS FCST_TYPE
         , K.DOM_EXP
         , NVL(CP.CPS_NAME, K.CELL_PROD_SITE_ID) AS CELL_PROD_SITE_ID
         , K.CURRENCY
         , MSR.MEASURE_NAME                      AS MEASURE
           
         , K.TEAM_ID, K.TEAM_NAME_KO, K.SOLDTO_CUSTOMER, K.COUNTRY_NAME, K.CITY_NAME
         , K.ITEM_NAME, K.NICK_NAME, K.ITEM_TYPE, K.CUST_GROUP, K.CUST_GROUP_DTL
         , K.OWNER, K.APPLICATION, K.ROUTE, K.MDM_PROJECT_NAME, K.MIN_CAPACITY
         , K.FORECAST_INFO_BIZ_TYPE, K.CELL_TYPE, K.FORECAST_INFO_CELL_MODEL
         , K.FORECAST_INFO_CELL_PACK_COUNT, K.FORECAST_INFO_ALL, K.FORECAST_INFO_SPEC
         , K.FORECAST_INFOR_VERSION, K.CELL_MODEL_NICK_NAME, K.VMI_YN
         , K.DMS_SALES, K.DMS_CUSTOMER, K.AS_FROM_SITE, K.LAST_UPDATED_BY, K.SENDER_NAME
                                                                     
                                                                                                          
                                                             
         , RTRIM(
             CASE WHEN EC.EC_NAME IS NULL AND K.END_CUSTOMER NOT IN (
                       SELECT SI.PROJECT_CODE FROM SCM_MGR.SCM_MST_SITE_ITEM SI
                        WHERE SI.DIVISION_ID = K.DIVISION_ID AND SI.VALID_YN = 'Y')
                  THEN 'EC,' ELSE '' END ||
             CASE WHEN CP.CPS_NAME IS NULL THEN 'CELL_PROD_SITE,' ELSE '' END ||
             CASE WHEN NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LI
                                    WHERE LI.LOOKUP_TYPE = 'INCOTERMS' AND LI.VALID_YN = 'Y'
                                      AND LI.SEGMENT2 = K.INCOTERMS)
                  THEN 'INCOTERMS,' ELSE '' END
           , ',') AS FORM_WARN
      FROM WT_KEY K
     INNER JOIN WT_MEASURE MSR
        ON MSR.DIVISION_ID = K.DIVISION_ID
      LEFT OUTER JOIN SCM_MGR.SCM_MST_SITE MS
        ON  MS.DIVISION_ID = K.DIVISION_ID
        AND MS.SCM_SITE_ID = K.SCM_SITE_ID
      LEFT OUTER JOIN WT_EC EC
        ON  EC.DIVISION_ID = K.DIVISION_ID
        AND EC.EC_CODE     = K.END_CUSTOMER
      LEFT OUTER JOIN WT_FCST FT
        ON  FT.FCST_CODE   = K.FCST_TYPE
      LEFT OUTER JOIN WT_CPS CP
        ON  CP.CPS_CODE    = K.CELL_PROD_SITE_ID
                                                                    
     WHERE ( ( NVL(MS.VMI_YN, 'N') = 'N' AND MSR.VMI_COND <> 'Y' )
             OR NVL(MS.VMI_YN, 'N') = 'Y' )
     ORDER BY K.END_CUSTOMER, K.SCM_SITE_ID, K.ITEM_ID, K.FCST_TYPE
            , K.INCOTERMS, K.DOM_EXP, K.CELL_PROD_SITE_ID, MSR.MEASURE_SORT;

    OPEN o_result_cursor FOR
        SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, TO_CHAR(n_key_cnt) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'p_division_id'    VALUE p_division_id
          , 'p_dept_id'        VALUE p_dept_id
          , 'p_end_customer'   VALUE SUBSTR(p_end_customer, 1, 200)
          , 'p_from_yyyymmdd'  VALUE p_from_yyyymmdd
          , 'p_to_yyyymmdd'    VALUE p_to_yyyymmdd
          , 'p_sales_site'     VALUE SUBSTR(p_sales_site, 1, 200)
          , 'p_item_id'        VALUE SUBSTR(p_item_id, 1, 200)
          , 'p_version_type'   VALUE p_version_type
          , 'p_ses_user_id'    VALUE p_ses_user_id
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

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

END P_DMF0082_GET_EXCEL_FORM_DATA;


                                                                                                       
                                                                                       
                                                         
                                                      
                                                                                                       
PROCEDURE P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE
(
    p_start_yyyymmdd  IN  VARCHAR2
  , p_end_yyyymmdd    IN  VARCHAR2
  , p_created_by      IN  VARCHAR2
  , O_RC1             OUT SYS_REFCURSOR
  , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
  
                                                     
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                     
                                                   
   
    V_PROGRAM_NAME  VARCHAR2(200 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;
BEGIN
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        V_PROGRAM_NAME := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT MIN(BASIS_START_DATE)         AS BASIS_START_DATE
             , BASIS_YYYYMM
             , WEEK_NAME
             , SUBSTR(BASIS_START_DATE, 5, 4) AS DATE_SHORT1_NAME
          FROM SCM_MGR.SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= p_start_yyyymmdd
           AND BASIS_YYYYMMDD <= p_end_yyyymmdd
         GROUP BY BASIS_YYYYMM, WEEK_NAME, SUBSTR(BASIS_START_DATE, 5, 4)
         ORDER BY BASIS_START_DATE;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE,
               'SUCCESS' AS MSG,
               CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
                             'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
                             'p_end_yyyymmdd'   VALUE p_end_yyyymmdd,
                             'p_created_by'     VALUE p_created_by
                         );
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); EXCEPTION WHEN OTHERS THEN NULL; END;

        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );
END P_DMF0082_POPUP_GET_SPREAD_TITLE_DATE;

END PKG_DMF0082;
/
