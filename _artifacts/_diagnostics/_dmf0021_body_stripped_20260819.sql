PACKAGE BODY           "PKG_DMF0021" AS

  PROCEDURE P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX 
                                                                                                                                                                                           
(
      p_division_id      IN  VARCHAR2                                               
    , p_dept_id          IN  VARCHAR2                                                      
    , p_end_customer     IN  VARCHAR2                                                             
    , p_scm_site_id      IN  VARCHAR2                                                            
    , p_project_code     IN  VARCHAR2                                                       
    , p_item_id          IN  VARCHAR2                                                        
    , p_item_type        IN  VARCHAR2                                                       
    , p_from_yyyymmdd    IN  VARCHAR2                                            
    , p_now_yyyymmdd     IN  VARCHAR2                                                           
    , p_to_yyyymmdd      IN  VARCHAR2                                            
    , p_created_by       IN  VARCHAR2                                                   
    , p_plant_site_id    IN  VARCHAR2                                                              
    , p_biztype          IN  VARCHAR2                                                         
    , p_owner            IN  VARCHAR2                                                        
    , p_internal_yn      IN  VARCHAR2                                               
    , p_userinfo         IN  VARCHAR2                                              
    , p_bucket           IN  VARCHAR2                                                                                    
    , p_user_dept_id     IN  VARCHAR2                                                               
    , p_cur_result       OUT SYS_REFCURSOR                                   
    , p_cur_calendar     OUT SYS_REFCURSOR                           
    , p_cur_edit_auth    OUT SYS_REFCURSOR                                                             
)
                                                               
                                                      
                                                                
                                                                                  
                                                               
                                                                               
                                    
                                                                                                                                     
                                                               
                                                                                                      
                                                                                                  
                                                                               
  
                                                                                                  
                                                                             
                                                                                               
                                                                                        
                                                                                                 
                                                                                                            
                                                            
                                                                                 
                                                                       
  
           
                                                      
                                                                      
                                                                             
                                                                            
                                                                      
                                                                       
                                                                       
                                                                
                                                                      
                                                                
                                                            
                                                                              
                                                                         
                                                                  
                                                               
                                                             
                                                                           
                                                                   
                                                                        
                                                                     
                                                                                  
  
                                                                                       
                                                                                              
                                                                                           
                                                                                                   
                                                                                      
                                                                                                  
                                                                                                        
                                                    
                                                                              
                                                                                                            
                                                                                                    
                                                                                                           
                                                                
                                                                                    
                                                                          
                                                                                   
                                                                                                                       
                                                                                                        
                                                                                                 
                                                                                                       
                                                                                                    
                                                    
  
         
                                                                                                 
                                                                                                
                                                                                                 
                                                                                            
                                                                                 
                                                                         
  
         
                                                              
                                           
                                                              
                                                     
                                                         
                                                                               
                                                                                            
                                                                     
                                                                                                                
                                           
                                                                                                
                                                                    
                                                                                     
                                                                                                                      
                                                              
                                                   
                                                                     
                                                                        
                                                                               
                                                                                                                                
                                                           
                                                              
                                                                             
                                                              
                                                        
                                                                                                    
                                                                                          
                                                                                       
                                                                                                       
                                                                              
                                                                                                            
                                                                                                      
                                                               
                                                                      
                                                                                          
                                                                  
                                                      
                                                                  
                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
IS
                                                                                                                                       
                       
                                                                                                                                       
    v_Prod                  CLOB;
    v_ColList               CLOB;
    v_OrderList             CLOB;
    v_nsql                  CLOB;
    v_nsql2                 CLOB;
    v_p_program_id          VARCHAR2(50 CHAR)   := 'DMF0021';
    v_p_sheet_name          VARCHAR2(50 CHAR)   := 'Sales Plan';
    v_dept_list             VARCHAR2(4000 CHAR) := '';
    v_group_id              VARCHAR2(50 CHAR)   := '';

    v_MEASURE               PLS_INTEGER := 0;
    v_i_count               PLS_INTEGER := 0;
                                       
    v_user_mea_cnt          PLS_INTEGER := 0;
                                                                       
    v_start_yyyymmdd        VARCHAR2(8 CHAR);

    v_admin_cnt             PLS_INTEGER := 0;
    v_meas_cnt              PLS_INTEGER := 0;

                                                
    v_EDIT_AUTH_SalesAmt_LOC  VARCHAR2(1 CHAR) := 'N';               
    v_EDIT_AUTH_RTF_SYS_RP    VARCHAR2(1 CHAR) := 'N';             

                 
    v_sql_text              CLOB;
    v_PV_LIST               CLOB;
    v_PV_COL_LIST           CLOB;
    v_column_name           VARCHAR2(100 CHAR);
    v_column                VARCHAR2(1000 CHAR);
    v_orderby               VARCHAR2(1000 CHAR);
    v_column_text           VARCHAR2(1000 CHAR);
    v_PV_column_name        VARCHAR2(100 CHAR);
    v_PV_NAME               VARCHAR2(50 CHAR);
    v_column_type           VARCHAR2(50 CHAR);
    v_column_value          VARCHAR2(50 CHAR);
    v_sort_order_no         VARCHAR2(50 CHAR);
    v_sum_qty               VARCHAR2(1000 CHAR);
    v_qty_div               VARCHAR2(1000 CHAR);
    v_avg_qty               VARCHAR2(1000 CHAR);

                                
    v_SHIP_DIVISION_ID            VARCHAR2(30 CHAR);
    v_SHIP_PLAN_START_YYYYMMDD    VARCHAR2(8 CHAR);
    v_SHIP_PLAN_TYPE              VARCHAR2(50 CHAR);
    v_SHIP_PPLAN_SEQ              PLS_INTEGER;
    v_SHIP_PPLAN_ID               VARCHAR2(30 CHAR);
    v_SHIP_PMODELING_ID           VARCHAR2(30 CHAR);

                                
    v_SQL_SELECT            CLOB;
    v_SQL_GROUPBY           CLOB;
    v_I                     PLS_INTEGER;
    v_CNT                   PLS_INTEGER;
                                                                                                                                       
                     
                                                                                                                                       
BEGIN
                                                                                                
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
                                                                                
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A001--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    v_ColList   := '';
    v_OrderList := '';
    v_Prod      := '';

                                                                       
    SELECT BASIS_START_DATE
      INTO v_start_yyyymmdd
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD = p_from_yyyymmdd;

                                                                                                                                       
                                  
                                                                           
                                                                                                                                       
    DELETE FROM GT_DMF0021_SCM_MST_SHEET_MEASURE;
    DELETE FROM GT_DMF0021_SELECT_MEASURE;
    DELETE FROM GT_DMF0021_RAW_DATA;
    DELETE FROM GT_DMF0021_SCM_MST_SITE_ITEM;
    DELETE FROM GT_DMF0021_SHIPMENT_SITE;
    DELETE FROM GT_DMF0021_SHIPMENT_SITE_ROW;
    DELETE FROM GT_DMF0021_SCM_MST_SITE;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_A;
    DELETE FROM GT_DMF0021_DM_MST_ITEM_SINGLE_B;
    DELETE FROM GT_DMF0021_COLUMN_SETUP;
    DELETE FROM GT_DMF0021_T;
                                                                                                                                       
                                
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A002--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                    
                                                                                                                                       
                                                      
    SELECT COUNT(1)
      INTO v_admin_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN    = 'Y'
       AND (SEGMENT1 = p_userinfo                                               
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND SEGMENT2    = 'ALL'
                                              
    ;
    IF NVL(v_admin_cnt, 0) > 0 THEN
        v_group_id := 'ADMIN';
    END IF;

                                                                                                                                       
                                                                                              
                                                                          
                                                                                                                                       
    SELECT COUNT(1)
      INTO v_meas_cnt
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND VALID_YN    = 'Y'
       AND (SEGMENT1 = p_userinfo                                               
            OR SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))                                                             
       AND SEGMENT2    = v_p_program_id
                                                               
                                                                             
       AND SEGMENT3    = p_division_id
       AND SEGMENT4    = 'SalesAmt_LOC';
    IF NVL(v_meas_cnt, 0) > 0 THEN
        v_EDIT_AUTH_SalesAmt_LOC := 'Y';
    END IF;

    SELECT COUNT(1)
      INTO v_meas_cnt
                                                                                     
                                                                     
                                                                               
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
     WHERE L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
       AND L.VALID_YN    = 'Y'
       AND (L.SEGMENT1 = p_userinfo                                               
            OR L.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                            WHERE G.USER_ID IN (p_userinfo, p_created_by) AND G.USE_YN = 'Y'))
       AND L.SEGMENT2    = v_p_program_id
                                                                              
       AND L.SEGMENT3    = p_division_id
       AND L.SEGMENT4    = 'RTF_SYS_RP'
                                                                                         
                                                                               
                                                                          
                                                                
                                                                      
                                                                                           
                                                                   
                                                                          
                                                                                  
                                                                                    
                                                                   
       AND (L.ATTRIBUTE1 IS NULL
            OR (SELECT COUNT(DISTINCT V.YYYYMMDD)
                  FROM DM_MST_VERSION V
                 WHERE V.VERSION_TYPE  = 'SP_W'
                   AND V.DIVISION_ID   = p_division_id
                   AND V.CREATION_DATE >
                       (CASE WHEN TRUNC(SYSDATE, 'IW')
                                  + DECODE(L.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                  + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 1, 2)), 0) / 24
                                  + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 3, 2)), 0) / 1440 > SYSDATE
                             THEN TRUNC(SYSDATE, 'IW') - 7 ELSE TRUNC(SYSDATE, 'IW') END)
                       + DECODE(L.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                       + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 1, 2)), 0) / 24
                       + NVL(TO_NUMBER(SUBSTR(L.ATTRIBUTE2, 3, 2)), 0) / 1440) = 1);
    IF NVL(v_meas_cnt, 0) > 0 THEN
        v_EDIT_AUTH_RTF_SYS_RP := 'Y';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A003--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                                        
                                                         
                                                                                                                                       
    SELECT LISTAGG(D.SEGMENT3, ',') WITHIN GROUP (ORDER BY D.SEGMENT3) AS SEGMENT
      INTO v_dept_list
      FROM (
            SELECT LOOK.SEGMENT1, LOOK.SEGMENT3
              FROM TB_FX_User USR
              INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                      ON USR.DEPT_ID     = LOOK.SEGMENT1
                     AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                     AND LOOK.VALID_YN   = 'Y'
             WHERE LOOK.VALID_YN = 'Y'
               AND USR.USERID    = p_created_by
             UNION
                              
            SELECT DEPT_ID AS SEGMENT1, DEPT_ID AS SEGMENT3
              FROM TB_FX_User
             WHERE USERID = p_created_by
           ) D
     WHERE D.SEGMENT1 = ( SELECT DEPT_ID FROM TB_FX_User WHERE UserID = p_created_by );

                         
                            
           
                                                 
         
                                                                                                                                       
                  
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A004--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                  
                           
                                                                         
                  

                                                                                                                                       
                      
                                                                                                                                       
                                       
    SELECT COUNT(*)
      INTO v_user_mea_cnt
      FROM SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID                    = v_p_program_id
       AND U.SHEET_NAME                    = v_p_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID                       = p_created_by;

    IF v_user_mea_cnt = 0 THEN
        INSERT INTO SCM_MST_TITLESET_USER
            ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE, COLUMN_NAME
            , SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE, CREATED_BY, CREATION_DATE
            , LAST_UPDATED_BY, LAST_UPDATE_DATE )
        SELECT p_created_by
             , C.PROGRAM_ID
             , C.SHEET_NAME
             , 'M'
             , C.COLUMN_NAME
             , C.SORT_ORDER_NO
             , 'N'
             , ''
             , p_created_by
             , SYSDATE                                                                                  
             , p_created_by
             , SYSDATE                                                                                  
          FROM SCM_MST_SHEET_MEASURE C
         WHERE 1 = 1
           AND C.PROGRAM_ID   = v_p_program_id
           AND C.SHEET_NAME   = v_p_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN     = 'Y';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A005--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                          
                                                                    
                                                              
                                                                             
                                                                                                                                       
                                                                              
                                                                        
    INSERT INTO GT_DMF0021_SCM_MST_SHEET_MEASURE ( USER_ID, MEASURE, SORT_ORDER_NO, SYSTEM_ADD, DIVISION_ID )
    SELECT U.USER_ID, U.COLUMN_NAME AS MEASURE, U.SORT_ORDER_NO, 'N' AS SYSTEM_ADD, p_division_id AS DIVISION_ID
      FROM SCM_MST_TITLESET_USER U
      INNER JOIN SCM_MST_SHEET_MEASURE B
              ON U.PROGRAM_ID  = B.PROGRAM_ID
             AND U.SHEET_NAME  = B.SHEET_NAME
             AND U.COLUMN_NAME = B.COLUMN_NAME
     WHERE 1 = 1
       AND U.PROGRAM_ID                    = v_p_program_id
       AND U.SHEET_NAME                    = v_p_sheet_name
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
       AND U.USER_ID                       = p_created_by
       AND B.VALID_YN                      = 'Y'
       AND ',' || B.DIVISION_ID || ',' LIKE '%,' || p_division_id || ',%';

    INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SORT_ORDER_NO, SYSTEM_ADD )
    SELECT DISTINCT U.MEASURE, U.SORT_ORDER_NO, U.SYSTEM_ADD
      FROM GT_DMF0021_SCM_MST_SHEET_MEASURE U
      LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
             ON U.USER_ID      = T.SEGMENT4                                      
            AND p_created_by   = T.SEGMENT4             
            AND T.LOOKUP_TYPE  = 'TMM_MEASURE_ADMIN'
            AND T.VALID_YN     = 'Y'                        
     WHERE 1 = 1
       AND U.USER_ID = CASE WHEN U.MEASURE = 'TMM_FCST' THEN T.SEGMENT4 ELSE p_created_by END;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A006--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                         
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'LOC', 'KRW' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP'   AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'SALESAMT_KRW' AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'SALESAMT_LOC' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'MKT_FCST_RP' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'MKT_FCST'   AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

                                                                                                                                       
                                                                            
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_PR' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

                                                                                                                                       
                                       
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'RTF_BALANCE' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL
                 UNION ALL
                 SELECT 'RTF_PR'     AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;

                                                                                                                                       
                                                            
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'SCM_FCST' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_SELECT_MEASURE ( MEASURE, SYSTEM_ADD )
        SELECT A.MEASURE, 'Y'
          FROM ( SELECT 'RTF_SYS_RP' AS MEASURE FROM DUAL ) A
          LEFT OUTER JOIN GT_DMF0021_SELECT_MEASURE B ON A.MEASURE = B.MEASURE
         WHERE B.MEASURE IS NULL;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A007--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                           
                                                                                                                                       
    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )                                      
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         , A.PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY, 'P' AS PLAN_RESULT
                                                                               
         , NVL(A.CELL_PROD_SITE_ID, '-') AS CELL_PROD_SITE_ID
      FROM DM_PLN_SALES_PLAN A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
      JOIN SCM_MST_SITE C
        ON A.DIVISION_ID = C.DIVISION_ID
       AND A.SCM_SITE_ID = C.SCM_SITE_ID
       AND C.VALID_YN    = 'Y'
     WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' ))                 
                              
       AND A.FCST_TYPE NOT IN ( SELECT DISTINCT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                   AND VALID_YN    = 'Y'
                                   AND SEGMENT1    = A.DIVISION_ID )
       AND A.ITEM_ID   NOT IN ( SELECT DISTINCT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'DM_SALES_PLAN_WATERFALL_SP_W_ADD'
                                   AND VALID_YN    = 'Y'
                                   AND SEGMENT1    = A.DIVISION_ID )
       AND A.MEASURE   NOT IN ( SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE = 'SALES_PLAN_CATCHUP'
                                   AND VALID_YN    = 'Y' );

                                                                                                                                       
                                                       
                                                                                                                                       
    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         , A.PLANT_SITE_ID, A.ITEM_ID, A.REMARK_TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, NULL AS COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY, 'P' AS PLAN_RESULT, '-' AS CELL_PROD_SITE_ID
      FROM DM_PLN_SALES_ETC_PLAN A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
      JOIN SCM_MST_SITE C
        ON A.DIVISION_ID = C.DIVISION_ID
       AND A.SCM_SITE_ID = C.SCM_SITE_ID
       AND C.VALID_YN    = 'Y'
     WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND A.QTY <> 0;

    INSERT INTO GT_DMF0021_RAW_DATA
        ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
        , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
        , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
        , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
    SELECT 'CURRENT' AS VERSION_NO, NULL AS CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
         , A.PLANT_SITE_ID, A.ITEM_ID, NVL(A.ATTRIBUTE9,'') AS TEXT, A.INCOTERMS, A.DOM_EXP
         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.MEASURE, A.YYYYMMDD
         , A.QTY + CASE WHEN p_internal_yn = 'Y' AND p_division_id = '82'
                             AND ( CASE WHEN REGEXP_LIKE(A.ATTRIBUTE2, '^[0-9]+(\.[0-9]+)?$') THEN 1 ELSE 0 END ) > 0
                        THEN CAST(A.ATTRIBUTE2 AS NUMBER) ELSE 0 END AS QTY
         , 'R' AS PLAN_RESULT
         , A.CELL_PROD_SITE_ID                                           
      FROM DM_PLN_SALES_PLAN_RESULT A
      JOIN GT_DMF0021_SELECT_MEASURE B
        ON A.MEASURE = B.MEASURE
     WHERE A.YYYYMMDD >= p_from_yyyymmdd AND A.YYYYMMDD < p_now_yyyymmdd
       AND A.DIVISION_ID = p_division_id
       AND (( A.MEASURE <> 'RTF_SYS_RP' AND A.QTY <> 0 ) OR ( A.MEASURE = 'RTF_SYS_RP' ))                 
       AND A.MEASURE NOT IN ('RTF_PR');                                        
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A009--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                        
    UPDATE GT_DMF0021_RAW_DATA
       SET PLANT_SITE_ID = '-'
     WHERE PLANT_SITE_ID IS NULL
        OR TRIM(REPLACE(PLANT_SITE_ID, CHR(0), ' ')) IS NULL
        OR TRIM(PLANT_SITE_ID) IN ('-','--');


    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'MKT_FCST_RP' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE
             , SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
             , QTY, A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE A.MEASURE = 'MKT_FCST'
           AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                  ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END                                                      
           AND A.YYYYMMDD <= p_to_yyyymmdd;

        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'MKT_FCST_RP' AS MEASURE, YYYYMMDD
             , QTY, PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END;                                                 
    END IF;

                                                                                                                                       
                                                                            
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'RTF_PR' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'RTF_PR' AS MEASURE, YYYYMMDD
             , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A010--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                       
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'RTF_BALANCE' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
                          
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'RTF_BALANCE' AS MEASURE, A.YYYYMMDD
             , ( SUM(CASE WHEN MEASURE = 'RTF_SYS_RP' THEN A.QTY ELSE 0 END)
               - SUM(CASE WHEN MEASURE = 'RTF_PR'     THEN A.QTY ELSE 0 END) ) AS QTY
             , 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE A.MEASURE IN ('RTF_SYS_RP','RTF_PR')
           AND A.YYYYMMDD >= CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                  ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                             END
           AND A.YYYYMMDD <= p_to_yyyymmdd
           AND A.QTY > 0
         GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID;
    END IF;

                                                                                                                                       
                                                            
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'SCM_FCST' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT VERSION_NO, A.CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
             , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
             , FCST_TYPE, CURRENCY, COMPANY_ID, 'SCM_FCST' AS MEASURE, YYYYMMDD
             , QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
         WHERE MEASURE = 'RTF_SYS_RP'
           AND A.YYYYMMDD >= p_from_yyyymmdd
           AND A.YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                 ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                            END;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A011--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));
                                                                                                                                       
                    
                                                                                                                                       

                                                                                                                                       
                                               
                                                                                                             
                                                                                                                                       
    MERGE INTO GT_DMF0021_RAW_DATA A
    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, CURRENCY
              FROM SCM_MST_SITE_ITEM ) B
       ON ( A.DIVISION_ID = B.DIVISION_ID
        AND A.PROJECT_CODE = B.PROJECT_CODE
        AND A.SCM_SITE_ID = B.SCM_SITE_ID
        AND A.ITEM_ID = B.ITEM_ID )
     WHEN MATCHED THEN UPDATE SET A.CURRENCY = B.CURRENCY
                                                                                                                     
        WHERE NVL(A.CURRENCY,'CHR#') = 'CHR#';

    IF ( p_internal_yn <> 'Y' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA
         WHERE SCM_SITE_ID IN ( SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN );
    END IF;

                                                                                                                                       
                                                                                    
                                                                                                                                       
                                       
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_ORI
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
        , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG
        , ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC
        , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
                                                                                           
    SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
         , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME
         , CASE WHEN REGEXP_LIKE(MIN_CAPACITY, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(MIN_CAPACITY) ELSE NULL END AS MIN_CAPACITY
         , ACTIVE_FLAG
         , ENERGE
         , CASE WHEN REGEXP_LIKE(CELL_QUANTITY, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(CELL_QUANTITY) ELSE NULL END AS CELL_QUANTITY
         , SCP_EXTRA_SPEC
         , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
         , CASE WHEN REGEXP_LIKE(FORECAST_INFO_CELL_PACK_COUNT, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(FORECAST_INFO_CELL_PACK_COUNT) ELSE NULL END AS FORECAST_INFO_CELL_PACK_COUNT
         , FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE
      FROM SCM_MST_ITEM_SN
     WHERE DIVISION_ID = p_division_id;

                                        
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_A
        ( DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE
        , MATERIAL_CLASS_NAME, ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, ACTIVE_FLAG, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC )
    SELECT T1.DIVISION_ID
         , T1.ITEM_ID
         , MAX(T1.ITEM_NAME)              AS ITEM_NAME
         , MAX(T1.ITEM_CLASS)             AS ITEM_CLASS
         , MAX(T1.ITEM_CLASS_NAME)        AS ITEM_CLASS_NAME
         , MAX(T1.NICK_NAME)              AS NICK_NAME
         , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                          WHEN T1.ITEM_TYPE = 'H' THEN 2
                          WHEN T1.ITEM_TYPE = 'Q' THEN 3
                     ELSE 4 END )
                            WHEN 1 THEN 'P'
                            WHEN 2 THEN 'H'
                            WHEN 3 THEN 'Q'
                            ELSE 'R' END  AS ITEM_TYPE
         , MAX(T1.MATERIAL_CLASS_NAME)    AS MATERIAL_CLASS_NAME
         , MAX(T1.ITEM_UOM)               AS ITEM_UOM
         , MAX(T1.SPEC)                   AS SPEC
         , MAX(T1.MDM_PROJECT_NAME)       AS MDM_PROJECT_NAME
         , MAX(T1.MIN_CAPACITY)           AS MIN_CAPACITY
         , MAX(T1.ACTIVE_FLAG)            AS ACTIVE_FLAG
         , MAX(T1.ENERGE)                 AS ENERGE
         , MAX(T1.CELL_QUANTITY)          AS CELL_QUANTITY
         , MAX(T1.SCP_EXTRA_SPEC)         AS SCP_EXTRA_SPEC
      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI T1
     WHERE 1=1
     GROUP BY T1.DIVISION_ID, T1.ITEM_ID;

                                        
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_B
        ( DIVISION_ID, ITEM_ID, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL
        , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_TYPE )
    SELECT DIVISION_ID
         , SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
         , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
         , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
         , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
         , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
         , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
         , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
         , MAX(CELL_TYPE)                     AS CELL_TYPE
      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_ORI T2
     GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12);

                                
                                                                                       
    INSERT INTO GT_DMF0021_DM_MST_ITEM_SINGLE_V
        ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_PRODUCT_GROUP
        , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION, CELL_QUANTITY, MDM_PROJECT_NAME, CELL_TYPE
        , ENERGE_WH, ENERGE )
                                                                                        
                                                                              
    SELECT /*+ NO_PUSH_PRED(LOOKA) NO_MERGE(LOOKA) */ DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS, A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
         , CASE WHEN A.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE        ELSE A.FORECAST_INFO_BIZ_TYPE        END AS FORECAST_INFO_BIZ_TYPE
         , CASE WHEN A.ITEM_ID = LOOKA.MODEL
                THEN CASE WHEN REGEXP_LIKE(LOOKA.CELL_PACK_COUNT, '^-?[0-9]+(\.[0-9]+)?$') THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT) ELSE NULL END
                ELSE A.FORECAST_INFO_CELL_PACK_COUNT END AS FORECAST_INFO_CELL_PACK_COUNT                                      

         , A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
         , A.CELL_QUANTITY, A.MDM_PROJECT_NAME, A.CELL_TYPE
         , A.ENERGE AS ENERGE_WH
         , CASE WHEN ( CASE WHEN REGEXP_LIKE(A.ENERGE, '^[0-9]+(\.[0-9]+)?$') THEN 1 ELSE 0 END ) > 0
                THEN ROUND( TO_NUMBER(A.ENERGE) / 1000, 7) ELSE NULL END AS ENERGE
      FROM (
            SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
                 , T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
                 , T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION, T1.ACTIVE_FLAG
                 , T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
              FROM GT_DMF0021_DM_MST_ITEM_SINGLE_A T1
              INNER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_B T2
                      ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
             WHERE 1=1
           ) A
      LEFT JOIN ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK
                    FROM ( SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT
                                , RANK () OVER ( PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC ) AS MODEL_RANK
                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40' ) A
                   WHERE MODEL_RANK = '1' ) LOOKA ON LOOKA.MODEL = A.ITEM_ID
      JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DMF0021_RAW_DATA ) B
        ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
     WHERE A.DIVISION_ID = p_division_id;

                                                                            
                                                                                                                               
                                                                                                                                       
                                            
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A013--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                     
                                                                                                                                       
    INSERT INTO GT_DMF0021_SCM_MST_SITE_ITEM
        ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
        , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL
        , CELL_PER_CAR, CELL_PER_MODULE, CURRENCY
        , SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN
        , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
        , OWNER, OWNER_NAME, OWNER_NAME_KO, DEPT_ID, VALID_YN )                                                                                              
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
         , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL, CELL_PER_CAR, CELL_PER_MODULE
         , CURRENCY, SALES_COMPANY, SALES_PLANT, SALES_PLAN_ADJUST_YN
         , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
         , A.OWNER                            
         , FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'EN' ) AS OWNER_NAME
         , FN_GET_DM_MKT_OWNER_NAME( A.OWNER, ',', 'KO' ) AS OWNER_NAME_KO
         , ( SELECT SU.DEPT_ID
               FROM SCM_MST_SSO_USER_INFO SU
              WHERE SU.USER_ID = REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)                                                                
           ) AS DEPT_ID
         , VALID_YN
      FROM SCM_MST_SITE_ITEM A
      JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_DMF0021_RAW_DATA ) B
        ON A.DIVISION_ID = B.DIVISION_ID
       AND A.SCM_SITE_ID = B.SCM_SITE_ID
       AND A.PROJECT_CODE = B.PROJECT_CODE
       AND A.ITEM_ID = B.ITEM_ID
     WHERE A.DIVISION_ID = p_division_id;
                                                                                                                                       
                                                                   
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A014--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                      
                                                                                      
                                                                                                                                       
    MERGE INTO GT_DMF0021_RAW_DATA A
    USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, YYYYMMDD
                 , ATTRIBUTE1, REMARK_TEXT                                              
                 , '-' AS CELL_PROD_SITE_ID                                      
                                                                                  
                                                                  
                                                                        
              FROM ( SELECT E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID, E.DOM_EXP, E.FCST_TYPE
                          , E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD, E.ATTRIBUTE1, E.REMARK_TEXT
                          , ROW_NUMBER() OVER ( PARTITION BY E.DIVISION_ID, E.PROJECT_CODE, E.SCM_SITE_ID, E.ITEM_ID
                                                    , E.DOM_EXP, E.FCST_TYPE, E.INCOTERMS, E.PLANT_SITE_ID, E.YYYYMMDD
                                                ORDER BY E.LAST_UPDATE_DATE DESC, E.MEASURE ) AS RN
                       FROM DM_PLN_SALES_ETC_PLAN E                 
                      WHERE E.DIVISION_ID = '40'
                        AND E.FCST_TYPE   = 'ETC'
                        AND E.YYYYMMDD >= p_now_yyyymmdd AND E.YYYYMMDD <= p_to_yyyymmdd
                        AND E.QTY <> 0 )
             WHERE RN = 1 ) B
       ON ( A.DIVISION_ID      = B.DIVISION_ID
        AND A.PROJECT_CODE     = B.PROJECT_CODE
        AND A.SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.ITEM_ID          = B.ITEM_ID
        AND A.DOM_EXP          = B.DOM_EXP
        AND A.FCST_TYPE        = B.FCST_TYPE
        AND A.INCOTERMS        = B.INCOTERMS
        AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
        AND A.YYYYMMDD         = B.YYYYMMDD
        AND NVL(A.TEXT,'#') = NVL(B.REMARK_TEXT,'#')                                                     
        AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID )                 
     WHEN MATCHED THEN UPDATE SET A.ATTRIBUTE1 = B.ATTRIBUTE1;
                                                                                                                                       
                                               
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A015--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                              
                                                                                                           
                                                                                                                                       
    IF ( p_project_code IS NOT NULL ) THEN                                                                          
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_PROJECT B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_project_code,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_project_code,',')+1) ) C
                    ON ( B.PROJECT_CODE LIKE '%' || C.TOKEN || '%' OR B.PROJECT_NAME LIKE '%' || C.TOKEN || '%' )
                 WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE );
    END IF;

    IF ( p_item_id IS NOT NULL ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id,',')+1) ) C
                    ON A.ITEM_ID LIKE '%' || C.TOKEN || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_id,',')+1) ) D
                    ON B.NICK_NAME LIKE '%' || D.TOKEN || '%'
                 WHERE A.ITEM_ID = B.ITEM_ID
                   AND ( C.TOKEN IS NOT NULL OR D.TOKEN IS NOT NULL ) );
    END IF;

    IF ( p_owner IS NOT NULL ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_SCM_MST_SITE_ITEM B
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) C
                    ON B.OWNER LIKE '%' || C.TOKEN || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) D
                    ON B.OWNER_NAME LIKE '%' || D.TOKEN || '%'
                  LEFT OUTER JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_owner,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_owner,',')+1) ) E
                    ON B.OWNER_NAME_KO LIKE '%' || E.TOKEN || '%'
                 WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE
                   AND ( C.TOKEN IS NOT NULL OR D.TOKEN IS NOT NULL OR E.TOKEN IS NOT NULL ) );
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A016--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_dept_id <> 'ALL' ) THEN
                                                
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE <> 'ETC'
           AND NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_SCM_MST_SITE_ITEM B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                    ON B.DEPT_ID = C.TOKEN
                 WHERE A.ITEM_ID = B.ITEM_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE );

                          
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE = 'ETC' AND A.DIVISION_ID <> '40'                                                       
           AND NOT EXISTS (
                SELECT 1
                  FROM SCM_MST_SITE B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                    ON B.DEPT_ID = C.TOKEN
                 WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = p_division_id );

                                     
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE A.FCST_TYPE = 'ETC' AND A.DIVISION_ID = '40'
           AND NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_dept_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_dept_id,',')+1) ) C
                 WHERE A.ATTRIBUTE1 = C.TOKEN );                                                  
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A017--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_end_customer <> 'ALL' ) THEN
        IF ( p_division_id = '40' ) THEN
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_end_customer,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_end_customer,',')+1) ) C
                     WHERE A.PROJECT_CODE = C.TOKEN );
        ELSE
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM SCM_MST_SITE B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_end_customer,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_end_customer,',')+1) ) C
                        ON B.END_CUSTOMER = C.TOKEN
                     WHERE A.SCM_SITE_ID = B.SCM_SITE_ID AND B.DIVISION_ID = p_division_id );
        END IF;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A018--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_scm_site_id <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_scm_site_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_scm_site_id,',')+1) ) C
                 WHERE A.SCM_SITE_ID = C.TOKEN );
    END IF;

    IF ( p_plant_site_id <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1 FROM ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_plant_site_id,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_plant_site_id,',')+1) ) C
                 WHERE A.PLANT_SITE_ID = C.TOKEN );
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A019--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF ( p_item_type <> 'ALL' ) THEN
        DELETE FROM GT_DMF0021_RAW_DATA A
         WHERE NOT EXISTS (
                SELECT 1
                  FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                  JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_item_type,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_item_type,',')+1) ) C
                    ON B.ITEM_TYPE = C.TOKEN
                 WHERE A.ITEM_ID = B.ITEM_ID );
    END IF;

    IF ( p_biztype <> 'ALL' ) THEN
        IF ( p_division_id = '40' ) THEN
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM GT_DMF0021_DM_MST_ITEM_SINGLE_V B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_biztype,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_biztype,',')+1) ) C
                        ON B.FORECAST_INFO_BIZ_TYPE = C.TOKEN
                     WHERE A.ITEM_ID = B.ITEM_ID );
        ELSE
            DELETE FROM GT_DMF0021_RAW_DATA A
             WHERE NOT EXISTS (
                    SELECT 1
                      FROM SCM_MST_PROJECT B
                      JOIN ( SELECT DISTINCT token FROM (SELECT REGEXP_SUBSTR(p_biztype,'[^,]+',1,LEVEL) AS token FROM DUAL CONNECT BY LEVEL <= REGEXP_COUNT(p_biztype,',')+1) ) C
                        ON B.BIZ_TYPE LIKE '%' || C.TOKEN || '%'
                     WHERE A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE );
        END IF;
    END IF;
                                                                                                                                       
                            
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A020--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                            
                                                                                                                                       
                
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'LOC' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'LOC' AS MEASURE, A.YYYYMMDD
             , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'RTF_SYS_RP'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) A
          JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'SalesAmt_LOC'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) B
            ON A.VERSION_NO    = B.VERSION_NO
           AND A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           AND A.CURRENCY      = B.CURRENCY
           AND A.YYYYMMDD      = B.YYYYMMDD
           AND NVL(A.COMPANY_ID,'#') = NVL(B.COMPANY_ID,'#')
           AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A021--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE = 'KRW' AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, 'KRW' AS MEASURE, A.YYYYMMDD
             , CASE WHEN A.QTY <> 0 THEN B.QTY/A.QTY ELSE 0 END AS QTY, 'R' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'RTF_SYS_RP'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) A
          JOIN ( SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                      , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                      , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, SUM(A.QTY) AS QTY, A.CELL_PROD_SITE_ID
                   FROM GT_DMF0021_RAW_DATA A
                  WHERE YYYYMMDD >= v_start_yyyymmdd
                    AND YYYYMMDD < CASE WHEN VERSION_NO = 'CURRENT' THEN p_now_yyyymmdd
                                        ELSE TO_CHAR( FN_NEXT_DAY( TO_DATE(CUTOFF_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                                   END
                    AND A.MEASURE = 'SalesAmt_KRW'
                  GROUP BY A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                         , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                         , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
               ) B
            ON A.VERSION_NO    = B.VERSION_NO
           AND A.DIVISION_ID   = B.DIVISION_ID
           AND A.PROJECT_CODE  = B.PROJECT_CODE
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
           AND A.ITEM_ID       = B.ITEM_ID
           AND A.INCOTERMS     = B.INCOTERMS
           AND A.DOM_EXP       = B.DOM_EXP
           AND A.FCST_TYPE     = B.FCST_TYPE
           AND A.CURRENCY      = B.CURRENCY
           AND A.YYYYMMDD      = B.YYYYMMDD
           AND NVL(A.COMPANY_ID,'#') = NVL(B.COMPANY_ID,'#')
           AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID;
    END IF;
                                                                                                                                       
                          
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A022--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                            
                                                                                                    
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ( 'KRW', 'LOC', 'USD' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        IF ( p_division_id = '40' ) THEN
            INSERT INTO GT_DMF0021_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
                , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
                , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
                , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
                                                                      
                                                                                                                                               
            SELECT /*+ LEADING(A B C D) USE_HASH(B) USE_HASH(C) USE_HASH(D) NO_SWAP_JOIN_INPUTS(C) */
                   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
                 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                          , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                          , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                       FROM GT_DMF0021_RAW_DATA A
                      WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
                        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )
                   ) A
              JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
              JOIN DM_PLN_CFM_SELLING_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
                                                                             
                                                                                           
                                                                                             
               AND C.DIVISION_ID      = p_division_id
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.CELL_PROD_SITE_ID = C.CELL_PROD_SITE_ID                 
               AND A.PLANT_SITE_ID    = CASE WHEN C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(C.PLANT_SITE_ID, CHR(0), ' ')) IS NULL OR TRIM(C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE C.PLANT_SITE_ID END                                                                              
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND B.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD         <= p_to_yyyymmdd
              JOIN GT_DMF0021_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        ELSE                             
            INSERT INTO GT_DMF0021_RAW_DATA
                ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
                , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
                , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
                , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
                                                                      
                                                                                               
            SELECT /*+ LEADING(A B C D) USE_HASH(B) USE_HASH(C) USE_HASH(D) NO_SWAP_JOIN_INPUTS(C) */
                   A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                 , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                 , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, C.MEASURE, A.YYYYMMDD
                 , C.PRICE, 'P' AS PLAN_RESULT, A.CELL_PROD_SITE_ID
              FROM ( SELECT DISTINCT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
                          , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
                          , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, A.YYYYMMDD, A.CELL_PROD_SITE_ID
                       FROM GT_DMF0021_RAW_DATA A
                      WHERE A.YYYYMMDD >= p_now_yyyymmdd AND A.YYYYMMDD <= p_to_yyyymmdd
                        AND A.MEASURE IN ( 'RTF_SYS_RP', 'MKT_FCST_RP', 'MKT_FCST', 'RTF_SCP', 'SalesAmt_LOC', 'SalesAmt_USD', 'SalesAmt_KRW', 'Catch_Up' )
                   ) A
              JOIN SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
              JOIN SCM_MST_FUTURE_PRICE C
                ON A.DIVISION_ID      = C.DIVISION_ID
                                                                             
                                                                            
               AND C.DIVISION_ID      = p_division_id
               AND A.PROJECT_CODE     = C.PROJECT_CODE
               AND A.SCM_SITE_ID      = C.SCM_SITE_ID
               AND A.PLANT_SITE_ID    = CASE WHEN C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(C.PLANT_SITE_ID, CHR(0), ' ')) IS NULL OR TRIM(C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE C.PLANT_SITE_ID END                                                 
               AND A.ITEM_ID          = C.ITEM_ID
               AND A.INCOTERMS        = C.INCOTERMS
               AND A.DOM_EXP          = C.DOM_EXP
               AND A.FCST_TYPE        = C.FCST_TYPE
               AND B.BASIS_START_DATE = C.YYYYMMDD
               AND C.YYYYMMDD         <= p_to_yyyymmdd
              JOIN GT_DMF0021_SELECT_MEASURE D ON C.MEASURE = D.MEASURE;
        END IF;
    END IF;
                                                                                                                                       
                          
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A023--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                             
                                                                                                                                       
    DELETE FROM GT_DMF0021_RAW_DATA A
     WHERE EXISTS ( SELECT 1 FROM GT_DMF0021_SELECT_MEASURE B
                     WHERE A.MEASURE = B.MEASURE AND B.SYSTEM_ADD = 'Y' );

                                                                                                                                       
                                              
                                                                                                                           
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE
     WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY' ) AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CAR','RTF_RP_CAR','RTF_SYS_RP_CAR')
                    THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0   AND D.CELL_PER_CAR > 0 THEN A.QTY / D.CELL_PER_CAR
                              WHEN INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 AND D.CELL_PER_CAR > 0 AND D.CELL_PER_MODULE > 0 THEN A.QTY / ( D.CELL_PER_CAR / D.CELL_PER_MODULE )
                              WHEN INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0   THEN A.QTY
                              ELSE 0
                         END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID LIKE '81%'
                    THEN CASE WHEN INSTR(C.ITEM_CLASS_NAME, 'Cell') > 0 AND D.CELL_PER_CAR > 0 THEN A.QTY
                              WHEN ( INSTR(C.ITEM_CLASS_NAME, 'Module') > 0 OR INSTR(C.ITEM_CLASS_NAME, 'Pack') > 0 ) AND D.CELL_PER_MODULE > 0 THEN A.QTY * D.CELL_PER_MODULE
                              ELSE 0
                         END
                    WHEN B.MEASURE_CALC IN ('MKT_FCST_RP_CELL','RTF_RP_CELL','RTF_SYS_RP_CELL') AND A.DIVISION_ID = '82' THEN A.QTY * C.CELL_QUANTITY
                                                                          
                    WHEN B.MEASURE_CALC = 'RTF_ENERGY'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                                                                               
                    WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'RTF_SYS_RP' AND A.PLAN_RESULT = 'R'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                    ELSE 0
               END
             , A.PLAN_RESULT
             , A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
          JOIN ( SELECT CASE WHEN A.MEASURE LIKE 'MKT_FCST_RP%' THEN 'MKT_FCST_RP' ELSE 'RTF_SYS_RP' END AS MEASURE_ORI
                      , A.MEASURE AS MEASURE_CALC
                   FROM GT_DMF0021_SELECT_MEASURE A
                  WHERE MEASURE IN ( 'MKT_FCST_RP_CAR', 'MKT_FCST_RP_CELL', 'RTF_SYS_RP_CAR', 'RTF_SYS_RP_CELL', 'RTF_ENERGY', 'MKT_FCST_ENERGY' )
               ) B ON A.MEASURE = B.MEASURE_ORI
          JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
         WHERE A.MEASURE IN ( 'MKT_FCST_RP', 'RTF_SYS_RP' );
    END IF;
                                                                                                                                       
                                            
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A024--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                       
                                                                                                                                       
    SELECT COUNT(*) INTO v_meas_cnt FROM GT_DMF0021_SELECT_MEASURE WHERE MEASURE IN ('MKT_FCST_ENERGY') AND ROWNUM = 1;
    IF v_meas_cnt > 0 THEN
        INSERT INTO GT_DMF0021_RAW_DATA
            ( VERSION_NO, CUTOFF_YYYYMMDD, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
            , PLANT_SITE_ID, ITEM_ID, TEXT, INCOTERMS, DOM_EXP
            , FCST_TYPE, CURRENCY, COMPANY_ID, MEASURE, YYYYMMDD
            , QTY, PLAN_RESULT, CELL_PROD_SITE_ID )
        SELECT A.VERSION_NO, A.CUTOFF_YYYYMMDD, A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID
             , A.PLANT_SITE_ID, A.ITEM_ID, A.TEXT, A.INCOTERMS, A.DOM_EXP
             , A.FCST_TYPE, A.CURRENCY, A.COMPANY_ID, B.MEASURE_CALC, A.YYYYMMDD
             , CASE WHEN B.MEASURE_CALC = 'MKT_FCST_ENERGY' AND B.MEASURE_ORI = 'MKT_FCST_RP' AND A.PLAN_RESULT = 'P'
                    THEN CASE WHEN C.ENERGE IS NOT NULL THEN (A.QTY * C.ENERGE)/1000 END
                    ELSE 0
               END
             , A.PLAN_RESULT, A.CELL_PROD_SITE_ID
          FROM GT_DMF0021_RAW_DATA A
          JOIN ( SELECT 'MKT_FCST_RP' AS MEASURE_ORI, A.MEASURE AS MEASURE_CALC
                   FROM GT_DMF0021_SELECT_MEASURE A
                  WHERE MEASURE IN ('MKT_FCST_ENERGY')
               ) B ON A.MEASURE = B.MEASURE_ORI
          JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V C ON A.ITEM_ID = C.ITEM_ID AND A.DIVISION_ID = C.DIVISION_ID
          LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM D
                       ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND A.PROJECT_CODE = D.PROJECT_CODE AND A.ITEM_ID = D.ITEM_ID
         WHERE A.MEASURE IN ( 'MKT_FCST_RP' );
    END IF;
                                                                                                                                       
                                                                     
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A025--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                                           
                                                                                                                                       
    v_PV_LIST     := '';
    v_PV_COL_LIST := '';

    FOR rec IN (
        SELECT '[D_' || A.BASIS_YYYYMMDD || '] AS D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
             , '[D_' || A.BASIS_YYYYMMDD || ']' AS PV_NAME
             , A.BASIS_YYYYMMDD || '_' || TO_CHAR(31) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
           AND p_bucket = 'DAILY'
        UNION ALL
        SELECT '[W_' || A.BASIS_YYYYMM || A.ISO_WEEK || '] AS W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
             , '[W_' || A.BASIS_YYYYMM || A.ISO_WEEK || ']' AS PV_NAME
             , MAX(A.BASIS_START_DATE) || '_' || TO_CHAR(21) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK
        UNION ALL
        SELECT '[M_' || A.BASIS_YYYYMM || '] AS M_' || A.BASIS_YYYYMM AS COLUMN_NAME
             , '[M_' || A.BASIS_YYYYMM || ']' AS PV_NAME
             , MIN(A.BASIS_START_DATE) || '_' || TO_CHAR(1) AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= p_from_yyyymmdd
           AND A.BASIS_YYYYMMDD <= p_to_yyyymmdd
         GROUP BY A.BASIS_YYYYMM
         ORDER BY SORT_ORDER_NO
    )
    LOOP
                                                                                                 
        v_PV_COL_LIST := v_PV_COL_LIST || CASE WHEN DBMS_LOB.GETLENGTH(v_PV_COL_LIST) > 0 THEN ',' ELSE '' END || rec.COLUMN_NAME;
        v_PV_LIST     := v_PV_LIST     || CASE WHEN DBMS_LOB.GETLENGTH(v_PV_LIST)     > 0 THEN ',' ELSE '' END || rec.PV_NAME;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A026--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                    
    INSERT INTO GT_DMF0021_SCM_MST_SITE
        ( SCM_SITE_ID, DIVISION_ID, DEPT_ID, SOLDTO_CODE, VMI_YN, END_CUSTOMER
        , CITY_NAME, COUNTRY_NAME, SHIPTO_DESCRIPTION, SOLDTO_DESCRIPTION, ATTRIBUTE3 )
    SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN
         , B.END_CUSTOMER, H.CITY_NAME, J.COUNTRY_NAME, L.SHIPTO_DESCRIPTION, L.SOLDTO_DESCRIPTION
         , B.ATTRIBUTE3                                                  
      FROM SCM_MST_SITE B
      LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
                   ON B.DIVISION_ID = K.DIVISION_ID AND B.SCM_SITE_ID = K.SCM_SITE_ID AND K.REP_YN = 'Y'
      LEFT OUTER JOIN SCM_MST_CITY H    ON B.CITY = H.CITY
      LEFT OUTER JOIN SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY
      LEFT OUTER JOIN SCM_MST_CUSTOMER L
                   ON K.DIVISION_ID = L.DIVISION_ID AND K.SHIPTO_CODE = L.SHIPTO_CODE AND K.SOLDTO_CODE = L.SOLDTO_CODE;

           
    v_column_name := '';
    v_column      := '';
    v_orderby     := '';

    SELECT COUNT(*)
      INTO v_i_count
      FROM SCM_MST_TITLESET_USER U
     WHERE 1 = 1
       AND U.PROGRAM_ID = v_p_program_id
       AND U.SHEET_NAME = v_p_sheet_name
       AND U.USER_ID    = p_created_by
       AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A027--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

    IF v_i_count = 0 THEN
        FOR rec IN (
            SELECT '[' || COLUMN_NAME || '],' AS COL_PART
                 , '[' || COLUMN_NAME || '] ' || DATA_SORT_METHOD_CODE || ',' AS ORD_PART
              FROM (                                                                                                                                 
                     SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.COLUMN_NAME ORDER BY t.SORT_ORDER_NO) AS COL_DEDUP_RN
                     FROM (                                       
                    SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                      FROM SCM_MST_SHEET_COLUMNS C
                     WHERE 1 = 1
                       AND C.PROGRAM_ID = v_p_program_id
                       AND C.SHEET_NAME = v_p_sheet_name
                       AND ( C.DEFAULT_FLAG = 'Y' OR ( C.VISIBLE_FLAG = 'N' AND NVL(C.DEFAULT_FLAG,'N') <> 'Y' AND C.VALID_YN = 'Y' ) )                            
                   ) t ) tbColList
             WHERE COL_DEDUP_RN = 1
             ORDER BY SORT_ORDER_NO
        )
        LOOP
            v_ColList   := v_ColList   || rec.COL_PART;
            v_OrderList := v_OrderList || rec.ORD_PART;
        END LOOP;
    ELSE
        FOR rec IN (
            SELECT '[' || COLUMN_NAME || '],' AS COL_PART
                 , '[' || COLUMN_NAME || '] ' || DATA_SORT_METHOD_CODE || ',' AS ORD_PART
              FROM (                                                                                                                                 
                     SELECT t.*, ROW_NUMBER() OVER (PARTITION BY t.COLUMN_NAME ORDER BY t.SORT_ORDER_NO) AS COL_DEDUP_RN
                     FROM (                                       
                    SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                      FROM SCM_MST_TITLESET_USER U
                      INNER JOIN SCM_MST_SHEET_COLUMNS C
                              ON U.PROGRAM_ID  = C.PROGRAM_ID
                             AND U.SHEET_NAME  = C.SHEET_NAME
                             AND U.COLUMN_NAME = C.COLUMN_NAME
                             AND U.PROGRAM_ID  = v_p_program_id
                             AND U.SHEET_NAME  = v_p_sheet_name
                             AND U.USER_ID     = p_created_by
                             AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                    UNION ALL
                                                                                         
                    SELECT * FROM (
                        SELECT CASE WHEN C.COLUMN_NAME = 'GROUP_ID' THEN NVL(U.SORT_ORDER_NO,85) - 0.5
                                                                                                           
                                    WHEN C.COLUMN_NAME = 'SALES_PLAN_ADJUST_YN' THEN NVL(C.SORT_ORDER_NO,400) + 110
                                    ELSE C.SORT_ORDER_NO END AS SORT_ORDER_NO
                             , C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                          FROM SCM_MST_SHEET_COLUMNS C
                          LEFT OUTER JOIN SCM_MST_TITLESET_USER U
                                       ON U.PROGRAM_ID = C.PROGRAM_ID
                                      AND U.SHEET_NAME = C.SHEET_NAME
                                      AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                                      AND U.COLUMN_NAME IN ('ITEM_ID')
                                      AND U.USER_ID = p_created_by
                         WHERE 1 = 1
                           AND C.PROGRAM_ID  = v_p_program_id
                           AND C.SHEET_NAME  = v_p_sheet_name
                           AND C.VISIBLE_FLAG = 'N'
                           AND NVL(C.DEFAULT_FLAG,'N') <> 'Y'                            
                           AND C.VALID_YN     = 'Y'
                    ) WHERE ROWNUM <= 100
                   ) t ) tbColList
             WHERE COL_DEDUP_RN = 1
             ORDER BY SORT_ORDER_NO
        )
        LOOP
            v_ColList   := v_ColList   || rec.COL_PART;
            v_OrderList := v_OrderList || rec.ORD_PART;
        END LOOP;
    END IF;

    v_ColList   := SUBSTR(v_ColList,   1, LENGTH(v_ColList)   - 1);
    v_OrderList := SUBSTR(v_OrderList, 1, LENGTH(v_OrderList) - 1);

                                                 
    v_ColList   := v_ColList || ',[NOTATION]';
                                                                          
                                                                                           
    IF INSTR(v_ColList, '[MEASURE]') = 0 THEN
        v_ColList   := v_ColList   || ',[MEASURE]';
        v_OrderList := v_OrderList || ',[MEASURE]';                                                
    END IF;
    v_ColList   := REPLACE(v_ColList,   '[VERSION_NO]', '[VERSION_SORT],[VERSION_NO]');
    v_OrderList := REPLACE(v_OrderList, '[VERSION_NO]', '[VERSION_SORT] DESC,[VERSION_NO]');
    v_OrderList := REPLACE(v_OrderList, '[MEASURE]',    '[SORT_ORDER_NO],[MEASURE]');
                                                                                                                                       
                     
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A028--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                       
                                                                                                                                       
    IF v_ColList LIKE '%SHIPMENT_SITE%' AND p_division_id = '82' THEN
        SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
          INTO v_SHIP_DIVISION_ID, v_SHIP_PLAN_START_YYYYMMDD, v_SHIP_PLAN_TYPE
             , v_SHIP_PPLAN_SEQ, v_SHIP_PPLAN_ID, v_SHIP_PMODELING_ID
          FROM ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_ID, MODELING_ID
                      , ROW_NUMBER() OVER ( ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) ROW_NUM
                   FROM SCP_PLAN_VERSION_V
                  WHERE 1=1
                    AND DIVISION_ID = '82'
                    AND PLAN_CYCLE  = 'WEEKLY'
                    AND PLAN_TYPE   = 'FN'
                    AND PLAN_START_YYYYMMDD >= TO_CHAR( FN_NEXT_DAY(SYSDATE, 'MON') - 60, 'YYYYMMDD') ) PV
         WHERE PV.ROW_NUM = 1;

                                                    
        INSERT INTO GT_DMF0021_SHIPMENT_SITE_ROW
            ( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, FROM_SITE )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE AS SCM_SITE_ID, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE
          FROM SCP_ANL_SHIPMENT_PLAN_FG A
          INNER JOIN SCM_SYS_CALENDAR_M O ON A.YYYYMMDD = O.BASIS_YYYYMMDD
          LEFT OUTER JOIN ( SELECT DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE
                                 , MAX(REPLACE(SUBSTR(ENG_DEMAND_ID, INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::', INSTR(ENG_DEMAND_ID, '::') + 1) + 1) + 1) + 2, 3), ':', '')) AS FCST_TYPE
                              FROM SCP_ANL_PROBLEM_REPORT_PEGGING
                             WHERE DIVISION_ID         = v_SHIP_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = v_SHIP_PLAN_START_YYYYMMDD
                               AND PLAN_TYPE           = v_SHIP_PLAN_TYPE
                               AND SEQ                 = v_SHIP_PPLAN_SEQ
                               AND PEGGING_OPERATION_CODE IN ( 'CSHIP', 'PSHIP' )
                             GROUP BY DIVISION_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE ) FC
                       ON A.ITEM_ID = FC.ITEM_ID AND A.FROM_SITE = FC.FROM_SITE AND A.TO_SITE = FC.TO_SITE
         WHERE A.DIVISION_ID         = v_SHIP_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = v_SHIP_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = v_SHIP_PLAN_TYPE
           AND A.SEQ                 = v_SHIP_PPLAN_SEQ
           AND A.MEASURE             = 'SHIP_PLAN'
           AND A.QTY                 > 0
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, FC.FCST_TYPE, A.FROM_SITE;

                                                                
        INSERT INTO GT_DMF0021_SHIPMENT_SITE ( DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE, SHIPMENT_SITE )
        SELECT DIVISION_ID, PROJECT_CODE, ITEM_ID, SCM_SITE_ID, INCOTERMS, FCST_TYPE
             , NVL("1", '')
                || CASE WHEN "2" IS NULL THEN '' ELSE ',' || "2" END
                || CASE WHEN "3" IS NULL THEN '' ELSE ',' || "3" END
                || CASE WHEN "4" IS NULL THEN '' ELSE ',' || "4" END
                || CASE WHEN "5" IS NULL THEN '' ELSE ',' || "5" END AS SHIPMENT_SITE
          FROM ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE, A.FROM_SITE
                      , ROW_NUMBER() OVER ( PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID, A.SCM_SITE_ID, A.INCOTERMS, A.FCST_TYPE ORDER BY A.FROM_SITE) AS ROW_NUM
                   FROM GT_DMF0021_SHIPMENT_SITE_ROW A )
         PIVOT ( MAX(FROM_SITE) FOR ROW_NUM IN (1, 2, 3, 4, 5) );
    END IF;
                                                                                                                                       
                        
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A030--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                                                                       
                                                    
                                                                                                                                     
                                                                                                                                       
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'VERSION_NO',     'A.VERSION_NO', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'DIVISION_ID',    'A.DIVISION_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'PROJECT_CODE',   'A.PROJECT_CODE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'SCM_SITE_ID',    'A.SCM_SITE_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'PLANT_SITE_ID',  'A.PLANT_SITE_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'GROUP_ID',       'NVL(I.GROUP_ID,'' '') AS GROUP_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'ITEM_ID',        'A.ITEM_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'TEXT',           'CASE WHEN A.TEXT IS NULL THEN '' '' ELSE A.TEXT END AS TEXT', 1 );                                               
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'TEXT4082',       'CASE WHEN A.TEXT IS NULL THEN '' '' ELSE A.TEXT END AS TEXT4082', 1 );                                  
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'INCOTERMS',      'A.INCOTERMS', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'DOM_EXP',        'A.DOM_EXP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'FCST_TYPE',      'A.FCST_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'MEASURE',        'A.MEASURE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'END_CUSTOMER40', 'A.PROJECT_CODE AS END_CUSTOMER40', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'INTERNAL_YN',    'CASE WHEN LENGTH(A.SCM_SITE_ID) > 2 AND LENGTH(A.SCM_SITE_ID) < 6 THEN ''Y'' ELSE ''N'' END AS INTERNAL_YN', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'YYYYMMDD',       'A.YYYYMMDD', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'QTY',            'A.QTY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'VERSION_SORT',   'CASE WHEN A.VERSION_NO = ''CURRENT'' THEN ''ZZZZZZZZZZZZZZZ'' ELSE A.VERSION_NO END AS VERSION_SORT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'VMI_YN',         'B.VMI_YN', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'END_CUSTOMER',   'NVL(B.END_CUSTOMER,'' '') AS END_CUSTOMER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'CURRENCY',      'CASE WHEN A.CURRENCY IS NOT NULL THEN A.CURRENCY ELSE C.CURRENCY END AS CURRENCY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'CELL_PROD_SITE_ID', 'A.CELL_PROD_SITE_ID', 1 );                 
                                                                          
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'ABC', 'DEPT_ID',      'CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END AS DEPT_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'APPLICATION',    'C.APPLICATION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP',     'C.CUST_GROUP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'OWNER',          'C.OWNER_NAME AS OWNER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'ROUTE',          'C.ROUTE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CUST_GROUP_DTL', 'C.CUST_GROUP_DTL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_CAR',   'C.CELL_PER_CAR', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_PER_MODULE','C.CELL_PER_MODULE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'COMPANY_ID',    'CASE WHEN A.COMPANY_ID IS NULL THEN C.SALES_COMPANY ELSE A.COMPANY_ID END AS COMPANY_ID', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'MODULE_PER_CAR', 'CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DMS_SALES',      'NVL(C.ATTRIBUTE1,'''') AS DMS_SALES', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DMS_CUSTOMER',   'NVL(C.ATTRIBUTE2,'''') AS DMS_CUSTOMER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL',     'C.ATTRIBUTE5 AS CELL_MODEL', 1 );                     
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'PRIORITY',       'C.ATTRIBUTE7 AS PRIORITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'KWH_CELL',       'C.ATTRIBUTE8 AS KWH_CELL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_MODEL_INFO','NVL(C.REPORT_GROUP6,'''') AS CELL_MODEL_INFO', 1 );                     
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'KWH_MODULE',    'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN (C.CELL_PER_MODULE * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_MODULE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'AC', 'KWH_PACK',      'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN (C.CELL_PER_CAR * TO_NUMBER(C.ATTRIBUTE8)) ELSE NULL END AS KWH_PACK', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'BIZ_TYPE_NAME40','D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ENERGE',         'D.ENERGE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ENERGE_WH',      'D.ENERGE_WH', 1 );                                           
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'CELL_QUANTITY',  'D.CELL_QUANTITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_CLASS_NAME','NVL(D.ITEM_CLASS_NAME,'''') AS ITEM_CLASS_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_NAME',      'NVL(D.ITEM_NAME,'''') AS ITEM_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'ITEM_TYPE',      'NVL(D.ITEM_TYPE,'''') AS ITEM_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'NICK_NAME',      'NVL(D.NICK_NAME,'''') AS NICK_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'MIN_CAPACITY',   'D.MIN_CAPACITY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFO_SPEC', 'D.FORECAST_INFO_SPEC', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'D', 'MDM_PROJECT_NAME', 'D.MDM_PROJECT_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'E', 'CELL_TYPE',      'E.SEGMENT2 AS CELL_TYPE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'F', 'CELL_MODEL_NICK_NAME', 'NVL(F.NICK_NAME,'''') AS CELL_MODEL_NICK_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'BIZ_TYPE_NAME',  'G.BIZ_TYPE AS BIZ_TYPE_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_NAME',   'G.PROJECT_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_OWNER',  'G.PROJECT_OWNER', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PROJECT_STATUS', 'G.PROJECT_STATUS', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'G', 'PRODUCT_GROUP_NAME', 'G.PRODUCT_GROUP_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'CITY_NAME',      'B.CITY_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'COUNTRY_NAME',   'B.COUNTRY_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'B', 'SHIPTO_DESCRIPTION', 'B.SHIPTO_DESCRIPTION', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'M', 'SORT_ORDER_NO',  'M.SORT_ORDER_NO', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'CELL_NAME',      'C.ATTRIBUTE9 AS CELL_NAME', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'DISTRIBUTION_CHANNEL', 'B.ATTRIBUTE3 AS DISTRIBUTION_CHANNEL', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'SALES_COMPANY',  'C.SALES_COMPANY', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'C', 'SALES_PLANT',    'C.SALES_PLANT', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'N', 'SHIPMENT_SITE',  'N.SHIPMENT_SITE', 1 );
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'O', 'SEGMENT3',       'NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION', 1 );                     
                                                                     
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'SCP_USE_YN', 'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE IN ( ''VMI_In_Req'', ''VMI_In_Plan'') THEN ''Y'' WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''RTF_PR'',''MKT_FCST_RP'',''MKT_FCST'', ''RTF'',''RTF_SCP'',''RTF_SYS_RP'' ) THEN ''Y'' ELSE ''N'' END AS SCP_USE_YN', 1 );
                                           
    INSERT INTO GT_DMF0021_COLUMN_SETUP VALUES ( 'A', 'FROM_SITE_ID', 'CASE WHEN NVL(A.CELL_PROD_SITE_ID,''-'') = ''-'' THEN ''N/A'' ELSE A.CELL_PROD_SITE_ID END AS FROM_SITE_ID', 1 );

                                                                                             
                                                                       
    INSERT INTO GT_DMF0021_T ( COLUMN_STRING, SEQ )
    SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY B.SORT_KEY ) AS SEQ
      FROM ( SELECT REGEXP_SUBSTR(TO_CHAR(v_ColList), '[^,]+', 1, LEVEL) AS TOKEN
               FROM DUAL
            CONNECT BY LEVEL <= REGEXP_COUNT(TO_CHAR(v_ColList), ',') + 1 ) A
      JOIN GT_DMF0021_COLUMN_SETUP B ON REPLACE(REPLACE(A.TOKEN, '[', ''), ']', '') = B.COLUMN_NAME;

                           
    SELECT 1, COUNT(*), '', ''
      INTO v_I, v_CNT, v_SQL_SELECT, v_SQL_GROUPBY
      FROM GT_DMF0021_T;

    WHILE ( v_I <= v_CNT )
    LOOP
        FOR rec IN ( SELECT COLUMN_STRING FROM GT_DMF0021_T WHERE SEQ = v_I )
        LOOP
            v_SQL_SELECT  := v_SQL_SELECT  || CASE WHEN v_I = 1 THEN '' ELSE ',' END || rec.COLUMN_STRING;
            v_SQL_GROUPBY := v_SQL_GROUPBY || CASE WHEN v_I = 1 THEN '' ELSE ',' END
                                || CASE WHEN INSTR(UPPER(rec.COLUMN_STRING), ' AS ') > 0
                                        THEN SUBSTR(rec.COLUMN_STRING, 1, INSTR(UPPER(rec.COLUMN_STRING), ' AS ') - 1)
                                        ELSE rec.COLUMN_STRING END;
        END LOOP;
        v_I := v_I + 1;
    END LOOP;

                                                                      
    IF p_division_id = '82' THEN
        v_qty_div := 'ROUND(A.QTY,10)';                                                                
        v_sum_qty := 'SUM(QTY)';
        v_avg_qty := 'AVG(QTY)';
    ELSE
        v_qty_div := 'A.QTY';
        v_sum_qty := 'SUM(QTY)';
        v_avg_qty := 'AVG(QTY)';
    END IF;

                                                                                                                                       
                                                                                         
                                                
                                              
                                    
                                                                   
                                                                              
                                                                                        
                                                                                                                                       
    DECLARE
        v_col_plain      CLOB;                                   
        v_orderby_plain  CLOB;                                   
        v_pv_in          CLOB;                                 
        v_pv_proj        CLOB;                         
    BEGIN
        v_col_plain     := REPLACE(REPLACE(v_ColList,   '[', ''), ']', '');
        v_orderby_plain := REPLACE(REPLACE(v_OrderList, '[', ''), ']', '');
        v_pv_in         := REGEXP_REPLACE(v_PV_LIST, '\[([^]]+)\]', '''\1'' AS "\1"');
        v_pv_proj       := REGEXP_REPLACE(v_PV_LIST, '\[([^]]+)\]', '"\1"');

        v_sql_text :=
'WITH WF AS (
    SELECT
        ' || v_qty_div || ' AS QTY
        , CASE WHEN ''' || p_bucket || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '''' END AS YYYYMMDD
        , M.SORT_ORDER_NO
        , CASE WHEN D.ITEM_ID IS NULL THEN ''N_''
               WHEN A.DIVISION_ID = ''40'' AND A.MEASURE = ''Catch_Up'' THEN ''N_''
               WHEN ( A.DIVISION_ID = ''40'' OR A.DIVISION_ID LIKE ''81%'' ) AND A.MEASURE = ''RTF_SYS_RP'' THEN ''N_''
               WHEN NVL(C.SALES_PLAN_ADJUST_YN,'''') = ''N'' THEN ''N_''
               ELSE ''Y_''
               END
        || CASE WHEN ''' || v_dept_list || ''' LIKE ''%''|| CASE WHEN A.FCST_TYPE = ''ETC'' THEN CASE WHEN A.DIVISION_ID = ''40'' THEN A.ATTRIBUTE1 ELSE B.DEPT_ID END ELSE C.DEPT_ID END ||''%'' THEN ''Y''
                WHEN ''' || v_group_id || ''' = ''ADMIN'' THEN ''Y''
            ELSE ''N''
            END AS SALES_PLAN_ADJUST_YN
        , CAL.BASIS_YYYYMM, CAL.ISO_WEEK
        , NVL(O.SEGMENT3, ''DEFAULT'') AS NOTATION   --[E20231128-000738] 원본 #WF 명시 NOTATION 컬럼 복원 (ColList [NOTATION] 이 참조)
        , ' || v_SQL_SELECT || '
    FROM GT_DMF0021_RAW_DATA A
    LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE B          ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
    LEFT OUTER JOIN GT_DMF0021_SCM_MST_SITE_ITEM C     ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
    LEFT OUTER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V D  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E     ON D.CELL_TYPE = E.SEGMENT1 AND E.LOOKUP_TYPE = ''CELL_TYPE''
    LEFT OUTER JOIN GT_DMF0021_DM_MST_ITEM_SINGLE_V F  ON D.DIVISION_ID = F.DIVISION_ID AND NVL(D.FORECAST_INFO_CELL_MODEL,'''') = F.ITEM_ID
    LEFT OUTER JOIN SCM_MST_PROJECT G                  ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
    LEFT OUTER JOIN SCP_MST_ITEM_GROUP_DETAIL I        ON A.DIVISION_ID = I.DIVISION_ID AND A.PROJECT_CODE = I.PROJECT_CODE AND A.ITEM_ID = I.ITEM_ID
    JOIN GT_DMF0021_SELECT_MEASURE M                   ON A.MEASURE = M.MEASURE
    LEFT OUTER JOIN GT_DMF0021_SHIPMENT_SITE N         ON A.DIVISION_ID = N.DIVISION_ID AND A.PROJECT_CODE = N.PROJECT_CODE AND A.SCM_SITE_ID = N.SCM_SITE_ID
                                                      AND A.ITEM_ID = N.ITEM_ID AND A.FCST_TYPE = N.FCST_TYPE AND A.INCOTERMS = N.INCOTERMS
    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL O     ON O.LOOKUP_TYPE = ''DM_MEASURE_POSITIONAL_NOTATION'' AND A.MEASURE = O.SEGMENT2 AND A.DIVISION_ID = O.SEGMENT1
    JOIN SCM_SYS_CALENDAR_M CAL                        ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD AND CAL.BASIS_DATE BETWEEN TO_DATE(''' || p_from_yyyymmdd || ''', ''YYYYMMDD'') AND TO_DATE(''' || p_to_yyyymmdd || ''', ''YYYYMMDD'') + 1
)
SELECT ' || v_col_plain || '
     , SORT_ORDER_NO
     , ' || v_pv_proj || '
FROM (';

                                                           
        IF p_bucket = 'DAILY' THEN
            v_sql_text := v_sql_text || '
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        UNION ALL';
        END IF;

                                                    
        v_sql_text := v_sql_text || '
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || ' ELSE ' || v_sum_qty || ' END AS QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        GROUP BY ' || v_col_plain || ', F.SORT_ORDER_NO, F.BASIS_YYYYMM, F.ISO_WEEK
        UNION ALL
        SELECT ' || v_col_plain || ', F.SORT_ORDER_NO, ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD, CASE WHEN MEASURE IN ( ''KRW'', ''USD'', ''LOC'') THEN ' || v_avg_qty || ' ELSE ' || v_sum_qty || ' END AS QTY
        FROM WF F
        WHERE 1=1
          AND ( ( F.MEASURE <> ''RTF_SYS_RP'' AND F.QTY <> 0 ) OR ( F.MEASURE = ''RTF_SYS_RP'' ) )
        GROUP BY ' || v_col_plain || ', F.SORT_ORDER_NO, F.BASIS_YYYYMM
    )
    PIVOT (
        SUM(QTY) FOR YYYYMMDD IN ( ' || v_pv_in || ' )
    )
    ORDER BY ' || v_orderby_plain;

        DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A033--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

                                                                                  
        OPEN p_cur_result FOR v_sql_text;
    END;

                                                                                                                                       
                                                                                  
                                                                                                                                       
    OPEN p_cur_calendar FOR
        SELECT 'M_' || A.BASIS_YYYYMM AS THIS_YYYYMM
             , 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS THIS_YYYYMMWW
             , A.BASIS_DATE
             , 'M_' || B.BASIS_YYYYMM AS PRE_YYYYMM
             , 'W_' || B.BASIS_YYYYMM || B.ISO_WEEK AS PRE_YYYYMMWW
             , A.BASIS_YYYYMM, A.ISO_WEEK
          FROM (                                    
                 SELECT MAX(BASIS_YYYYMM) AS BASIS_YYYYMM, MIN(ISO_WEEK) AS ISO_WEEK, MIN(BASIS_DATE) AS BASIS_DATE
                   FROM SCM_SYS_CALENDAR_M
                  WHERE BASIS_YYYYMM = ( SELECT BASIS_YYYYMM FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD') )
                    AND ISO_YYYYWW   = ( SELECT ISO_YYYYWW   FROM SCM_SYS_CALENDAR_M WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD') )
               ) A
          JOIN ( SELECT BASIS_YYYYMM, ISO_WEEK, BASIS_DATE
                   FROM SCM_SYS_CALENDAR_M
                  WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
               ) B ON 1 = 1;

                                                                                                                                       
                                                       
                                                                                                                                       
    OPEN p_cur_edit_auth FOR
        SELECT v_EDIT_AUTH_SalesAmt_LOC AS EDIT_AUTH_SalesAmt_LOC
             , v_EDIT_AUTH_RTF_SYS_RP   AS EDIT_AUTH_RTF_SYS_RP
          FROM DUAL;

                                                                                                                                       
                                             
                                                           
                                                                              
                                                                                                                                       
    DBMS_OUTPUT.PUT_LINE(v_p_program_id || ' : A034--' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3'));

END P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX;


  PROCEDURE P_DMF0021_GET_SPREAD_TITLE 
                                                                                                                                                   
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,                          
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
                                                                                                      
                                                                                                       
                                                                                                 
                                                                                              
                                                                                                      
                                                                                                      
                                                                                                      
                                                                                                      
                                                                                                      
                                                                                                 
                                                                                               
                                                                               
                                                              
                                                                                             
                                                                                                   
                                                                                                      
                                                                                                      
          
              
                                             
                          
                  
                                                 
                    
        
                                                                  
                                                  
                                                                                                       
AS

    v_user_col_cnt   PLS_INTEGER := 0;
    v_program_id     VARCHAR2(4000 CHAR);
    v_sheet_name     VARCHAR2(4000 CHAR);

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    v_program_id   := 'DMF0021';
    v_sheet_name   := 'Sales Plan';
    v_user_col_cnt := 0;

    SELECT COUNT(*)
    INTO   v_user_col_cnt
    FROM   SCM_MST_TITLESET_USER U
    WHERE  1 = 1
    AND    U.PROGRAM_ID = v_program_id
    AND    U.SHEET_NAME = v_sheet_name
    AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'                                  
    AND    U.USER_ID    = P_CREATED_BY;

    IF v_user_col_cnt > 0 THEN

        OPEN O_RC1 FOR
        SELECT U.PROGRAM_ID
             , U.SHEET_NAME
             , U.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , U.SORT_ORDER_NO                                                                 
             , U.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , ''                     AS DAY_CODE
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
        AND    U.USER_ID     = P_CREATED_BY
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    P_DIVISION_ID IN (                                                                     
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
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
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'                                               
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                                                     
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO                   
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , T.CELL_CONTROL_OBJECT_TYPE_CODE                                                
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER                               
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH                                  
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                           
                                                      
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                           
                                                                  
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                     , 'FPNumber'                              AS CELL_CONTROL_OBJECT_TYPE_CODE
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                           
                                                    
             ) T
        ORDER BY SORT_ORDER_NO;

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
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                                                     
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
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
             , ''                     AS DAY_CODE
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
        AND    C.PROGRAM_ID   = v_program_id
        AND    C.SHEET_NAME   = v_sheet_name
        AND    C.VISIBLE_FLAG = 'N'
        AND    NVL(C.DEFAULT_FLAG,'N') <> 'Y'                                               
        AND    C.VALID_YN     = 'Y'
        AND    P_DIVISION_ID IN (                                                                     
                   SELECT TRIM(REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL))
                   FROM   DUAL
                   CONNECT BY REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
               )
        UNION ALL
        SELECT v_program_id            AS PROGRAM_ID
             , v_sheet_name            AS SHEET_NAME
             , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME
             , TO_NUMBER(T.SORT_ORDER_NO) AS SORT_ORDER_NO                   
             , ''                      AS DATA_SORT_METHOD_CODE
             , T.SMALL_CLASS_LABEL_NAME
             , T.LARGE_CLASS_LABEL_NAME
             , T.DAY_CODE
             , ''                      AS FIXED_FLAG
             , 50                      AS COLUMN_WIDTH
             , 'FPNumber'              AS CELL_CONTROL_OBJECT_TYPE_CODE
             , ''                      AS CELL_COMBO_DATA_TYPE
             , 3                       AS DATA_SCALE_NUMBER                               
             , TO_NUMBER(NULL)         AS DATA_MAX_LENGTH                                  
             , 'R'                     AS HORIZONTAL_ALIGN_CODE
             , 'Y'                     AS UPPERCASE_APPLY_FLAG
             , 'Y'                     AS VISIBLE_FLAG
             , ''                      AS DEFAULT_FLAG
             , ''                      AS USER_SELECTABLE_FLAG
             , ''                      AS VALID_YN
             , ''                      AS DIVISION_ID
        FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD                AS COLUMN_NAME
                     , A.CALENDAR_DAY                          AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , A.DAYOFWEEK                             AS DAY_CODE
                     , A.BASIS_YYYYMMDD || TO_CHAR(31, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                           
                                                      
                UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                     , A.WEEK_NAME                             AS COLUMN_LABEL_NAME
                     , A.WEEK_NAME                             AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , A.BASIS_START_DATE || TO_CHAR(21, 'FM00') AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                GROUP BY A.BASIS_YYYYMM
                       , A.ISO_WEEK
                       , A.WEEK_NAME
                       , A.MONTH_NAME
                       , A.BASIS_START_DATE
                           
                                                                  
                UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM                 AS COLUMN_NAME
                     , A.MONTH_NAME                            AS COLUMN_LABEL_NAME
                     , A.MONTH_NAME                            AS SMALL_CLASS_LABEL_NAME
                     , A.MONTH_NAME                            AS LARGE_CLASS_LABEL_NAME
                     , ''                                      AS DAY_CODE
                     , MIN(A.BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD                                           
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD                                                               
                GROUP BY A.BASIS_YYYYMM
                       , A.MONTH_NAME
                           
                                                    
             ) T
        ORDER BY SORT_ORDER_NO;

    END IF;

                                                                                                                                   
                                              
                                                                                                                                   
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  :=
            JSON_OBJECT(
                'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
                'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
                'P_CREATED_BY'     VALUE P_CREATED_BY,
                'P_DIVISION_ID'    VALUE P_DIVISION_ID,
                'P_BUCKET'         VALUE P_BUCKET
            );
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SPREAD_TITLE;


  PROCEDURE P_DMF0021_GET_SALES_PLAN_MEASUREINFO 
(
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
  
                                                    
                 
                  
                                                                                                     
                                          
                                                                                                     
                                                                                    
                                                              
                                            
                                                              
                                        
   
AS

    V_PROC_INPUT     VARCHAR2(4000 CHAR);
    V_BACKTRACE      VARCHAR2(4000 CHAR);
    V_SQL_CODE       VARCHAR2(100 CHAR);
    V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
    V_LOG_TYPE       VARCHAR2(100 CHAR);
    V_LOG_MESSAGE    VARCHAR2(4000 CHAR);
    V_DESCRIPTION    VARCHAR2(4000 CHAR);
    N_LOG_COUNT      PLS_INTEGER := 0;
    D_EVENT_DATE     DATE        := SYSDATE;

BEGIN

    OPEN O_RC1 FOR
    SELECT SEGMENT1    AS CODE
         , SEGMENT2    AS NAME
         , DISPLAY_SEQ
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'DM_SALES_PLAN_MEASURE'
    AND    VALID_YN    = 'Y'
    ORDER BY DISPLAY_SEQ;
                              
      
                                                                                        
                                  
         
                                                        
      

                                                                                                                                   
                                              
                                                                                                                                   
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_DESCRIPTION := '';
        V_PROC_INPUT  := JSON_OBJECT('NO_PARAM' VALUE 'N/A');
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_GET_SALES_PLAN_MEASUREINFO;


  PROCEDURE P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL 
(
    P_ACTIVE_FLAG         IN VARCHAR2,
    P_DIVISION_ID         IN VARCHAR2,
    P_PROJECT_CODE        IN VARCHAR2,
    P_SCM_SITE_ID         IN VARCHAR2,
    P_PLANT_SITE_ID       IN VARCHAR2,
    P_ITEM_ID             IN VARCHAR2,
    P_DOM_EXP             IN VARCHAR2,
    P_FCST_TYPE           IN VARCHAR2,
    P_INCOTERMS           IN VARCHAR2,
    P_MEASURE             IN VARCHAR2,
    P_YYYYMMDD            IN VARCHAR2,
    P_QTY                 IN VARCHAR2,
    P_CURRENCY            IN VARCHAR2,
    P_CREATED_BY          IN VARCHAR2,
    P_LAST_UPDATED_BY     IN VARCHAR2,
    P_TEXT                IN VARCHAR2,
    P_DEPT_ID             IN VARCHAR2,                         
    P_CELL_PROD_SITE_ID   IN VARCHAR2,                                       
    O_RESULT_CURSOR       OUT SYS_REFCURSOR
)
                                                                                                                          
                                                    
                                                                                                 
                  
                                                                                                                          
                                          
                                                                                                                          
                                                                                      
                                       
                                                                                 
                                                                                        
                                                   
                                                                       
                                                                                
                                                              
                                                   
                                                              
                                                                  
                                                        
                                                                        
                                                                                                    
                                                        
                                                                            
                                                                             
                                                                                           
                                                                
                                                                                                           
                                                                                 
                                                                                             
                                                              
                                                                                                                           
AS

                                                                                                                   
               
                                                                                                                   
    v_active_flag         VARCHAR2(4000 CHAR);
    v_division_id_val     VARCHAR2(4000 CHAR);
    v_project_code_val    VARCHAR2(4000 CHAR);
    v_scm_site_id_val     VARCHAR2(4000 CHAR);
    v_plant_site_id_val   VARCHAR2(4000 CHAR);
    v_item_id_val         VARCHAR2(4000 CHAR);
    v_dom_exp_val         VARCHAR2(4000 CHAR);
    v_fcst_type_val       VARCHAR2(4000 CHAR);
    v_incoterms_val       VARCHAR2(4000 CHAR);
    v_measure_val         VARCHAR2(4000 CHAR);
    v_wyyyymmdd           VARCHAR2(4000 CHAR);
    v_yyyymmdd_val        VARCHAR2(8 CHAR);
    v_currency_val        VARCHAR2(4000 CHAR);
    v_qty_val             NUMBER(30,10);
    v_created_by_val      VARCHAR2(4000 CHAR);
    v_last_updated_by_val VARCHAR2(4000 CHAR);
    v_text_val            VARCHAR2(4000 CHAR);
    v_dept_id_val         VARCHAR2(4000 CHAR);
    v_cell_prod_val       VARCHAR2(4000 CHAR);
    v_bucket_val          VARCHAR2(10 CHAR);
    v_weeknumber          VARCHAR2(2 CHAR);
    v_yyyy                VARCHAR2(4 CHAR);
    v_yyyymm              VARCHAR2(6 CHAR);
    v_max_cnt             PLS_INTEGER := 0;

                   
    T_FCST_TYPE           T_STR_TAB := T_STR_TAB();

                                                                                                                   
                  
                                                                                                                   
    v_log_type            VARCHAR2(30 CHAR);
    n_log_count           PLS_INTEGER := 0;
    v_log_message         VARCHAR2(1000 CHAR);
    v_description         VARCHAR2(4000 CHAR);
    d_event_date          DATE;
    n_del_count           PLS_INTEGER := 0;
    n_insert_count        PLS_INTEGER := 0;
    n_event_count         PLS_INTEGER := 0;

                                                                                                                   
                    
                                                                                                                   
    V_S_VALIDATION        VARCHAR2(4000 CHAR) := NULL;
    V_S_CODE              VARCHAR2(50 CHAR)   := NULL;

                                                                                                                   
                 
                                                                                                                   
    v_max_mf_w_version    VARCHAR2(100 CHAR);
    v_max_mf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_max_sf_w_version    VARCHAR2(100 CHAR);
    v_max_sf_w_yyyymmdd   VARCHAR2(8 CHAR);
    v_cutoff_start        VARCHAR2(8 CHAR);
    v_cutoff_end          VARCHAR2(8 CHAR);

                                                                                                                   
                   
                                                                                                                   
    V_PROC_INPUT          VARCHAR2(4000 CHAR);
    V_BACKTRACE           VARCHAR2(4000 CHAR);
    V_SQL_CODE            VARCHAR2(100 CHAR);
    V_SQL_ERRMSG          VARCHAR2(1000 CHAR);

    V_CNT                 NUMBER;
BEGIN
                                                                                                
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';

                                                                                                                   
                   
                                                                                                                   
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_LOC;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_RTF;
    DELETE FROM SCM_MGR.GT_F021_DATA_DUP;
    DELETE FROM SCM_MGR.GT_F021_PRICE_RTF_SYS_RP;
    DELETE FROM SCM_MGR.GT_F021_SALES_PLAN_INSERT;

                         
    v_cutoff_start := TO_CHAR(TRUNC(SYSDATE, 'IW') - 7, 'YYYYMMDD');
    v_cutoff_end   := TO_CHAR(TRUNC(SYSDATE, 'IW'), 'YYYYMMDD');

                                                                                                                   
             
                                                                                                                   
    v_log_type    := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

                                                                                                                   
                                                               
                                                                                
                                     
                                                                                                                   
    v_max_cnt := REGEXP_COUNT(P_DIVISION_ID, '\^') + 1;

    FOR i IN 1..v_max_cnt LOOP

        v_active_flag         := TRIM(REGEXP_SUBSTR(P_ACTIVE_FLAG,       '[^\^]+', 1, i));
        v_division_id_val     := TRIM(REGEXP_SUBSTR(P_DIVISION_ID,       '[^\^]+', 1, i));
        v_project_code_val    := TRIM(REGEXP_SUBSTR(P_PROJECT_CODE,      '[^\^]+', 1, i));
        v_scm_site_id_val     := TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID,      '[^\^]+', 1, i));
        v_plant_site_id_val   := TRIM(REGEXP_SUBSTR(P_PLANT_SITE_ID,    '[^\^]+', 1, i));
                                                              
        IF v_plant_site_id_val IS NULL OR TRIM(REPLACE(v_plant_site_id_val, CHR(0), ' ')) IS NULL
           OR TRIM(v_plant_site_id_val) IN ('-','--') THEN
            v_plant_site_id_val := '-';
        END IF;
        v_item_id_val         := TRIM(REGEXP_SUBSTR(P_ITEM_ID,          '[^\^]+', 1, i));
        v_dom_exp_val         := TRIM(REGEXP_SUBSTR(P_DOM_EXP,          '[^\^]+', 1, i));
        v_fcst_type_val       := TRIM(REGEXP_SUBSTR(P_FCST_TYPE,        '[^\^]+', 1, i));
        v_incoterms_val       := TRIM(REGEXP_SUBSTR(P_INCOTERMS,        '[^\^]+', 1, i));
        v_measure_val         := TRIM(REGEXP_SUBSTR(P_MEASURE,          '[^\^]+', 1, i));
        v_wyyyymmdd           := TRIM(REGEXP_SUBSTR(P_YYYYMMDD,         '[^\^]+', 1, i));
        v_currency_val        := TRIM(REGEXP_SUBSTR(P_CURRENCY,         '[^\^]+', 1, i));
        v_qty_val             := TO_NUMBER(TRIM(REGEXP_SUBSTR(P_QTY,    '[^\^]+', 1, i)));
        v_created_by_val      := TRIM(REGEXP_SUBSTR(P_CREATED_BY,       '[^\^]+', 1, i));
        v_last_updated_by_val := TRIM(REGEXP_SUBSTR(P_LAST_UPDATED_BY,  '[^\^]+', 1, i));
        v_text_val            := TRIM(REGEXP_SUBSTR(P_TEXT,              '[^\^]+', 1, i));
        v_dept_id_val         := TRIM(REGEXP_SUBSTR(P_DEPT_ID,          '[^\^]+', 1, i));
        v_cell_prod_val       := TRIM(REGEXP_SUBSTR(P_CELL_PROD_SITE_ID,'[^\^]+', 1, i));

                         
        v_bucket_val := SUBSTR(v_wyyyymmdd, 1, 1);
        v_weeknumber := SUBSTR(v_wyyyymmdd, -2);
        v_yyyy       := SUBSTR(v_wyyyymmdd, 3, 4);
        v_yyyymm     := SUBSTR(v_wyyyymmdd, 3, 6);

                   
        IF v_bucket_val = 'M' THEN
                                                       
            IF v_division_id_val = '40' AND v_fcst_type_val = 'ETC' THEN
                SELECT v_yyyymm || MAX(CALENDAR_DAY)
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M
                WHERE  BASIS_YYYYMM = v_yyyymm;
            ELSE
                v_yyyymmdd_val := v_yyyymm || '01';
            END IF;
        ELSE
            IF SUBSTR(v_yyyymm, 5, 2) <> '12' THEN
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber;
            ELSE
                SELECT CASE WHEN MIN(A.BASIS_YYYYMM) = MAX(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            WHEN v_yyyymm = MIN(A.BASIS_YYYYMM) THEN MIN(A.BASIS_YYYYMMDD)
                            ELSE MAX(A.BASIS_YYYYMM) || '01'
                       END
                INTO   v_yyyymmdd_val
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.CALENDAR_YYYY = v_yyyy
                AND    A.ISO_WEEK      = v_weeknumber
                AND    A.BASIS_YYYYMM  = v_yyyymm;
            END IF;
        END IF;

        INSERT INTO GT_F021_SALES_PLAN
        (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
         V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
         V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY,
         V_TEXT, V_DEPT_ID, V_BUCKET, V_CELL_PROD_SITE_ID)
        VALUES
        (v_active_flag, v_division_id_val, v_project_code_val, v_scm_site_id_val, v_plant_site_id_val,
         v_item_id_val, v_dom_exp_val, v_fcst_type_val, v_incoterms_val, v_measure_val,
         v_yyyymmdd_val, v_currency_val, v_qty_val, v_created_by_val, v_last_updated_by_val,
         v_text_val, v_dept_id_val, v_bucket_val, v_cell_prod_val);

    END LOOP;

             

                                                                                                                   
                                       
                                                                                                                   
    MERGE INTO GT_F021_SALES_PLAN A
    USING (
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
             , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
             , MAX(ATTRIBUTE2) AS FROM_SITE_ID
        FROM   DM_PLN_SALES_PLAN
        WHERE  DIVISION_ID = v_division_id_val
        AND    MEASURE     = 'RTF_SYS_RP'
        AND    YYYYMMDD   >= v_cutoff_start
        AND    ATTRIBUTE2 IS NOT NULL
        GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
               , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID
    ) B
    ON (    A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID = CASE WHEN B.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(B.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(B.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE B.PLANT_SITE_ID END
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.V_MEASURE          = B.MEASURE
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
    )
    WHEN MATCHED THEN UPDATE SET A.V_FROM_SITE_ID = B.FROM_SITE_ID;

             

                                                                                                                   
                
                                                                                                                   
    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

                                                                                                                   
                          
                                                                                                                   
    INSERT INTO GT_F021_SALES_PLAN_LOC SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'SalesAmt_LOC';

    INSERT INTO GT_F021_SALES_PLAN_RTF SELECT * FROM GT_F021_SALES_PLAN WHERE V_MEASURE = 'RTF_SYS_RP';

                                                       
    INSERT INTO GT_F021_SALES_PLAN_RTF
    SELECT A.V_ACTIVE_FLAG, A.V_DIVISION_ID, A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_PLANT_SITE_ID
         , A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE, A.V_INCOTERMS, B.MEASURE
         , A.V_YYYYMMDD, A.V_CURRENCY, A.V_QTY, A.V_CREATED_BY, A.V_LAST_UPDATED_BY
         , A.V_TEXT, A.V_DEPT_ID, A.V_BUCKET, A.V_CELL_PROD_SITE_ID, A.V_FROM_SITE_ID
    FROM GT_F021_SALES_PLAN_RTF A
    CROSS JOIN (SELECT 'RTF' AS MEASURE FROM DUAL UNION ALL SELECT 'RTF_SCP' FROM DUAL) B
    WHERE A.V_MEASURE = 'RTF_SYS_RP';

             

                                                                                                                   
                         
                                                                                                                   

                                                   
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN R
            WHERE R.V_INCOTERMS IN (
                SELECT OLD_VALUE1 FROM NERP_CONV_MASTER WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1
            )
        );
        v_log_type    := 'INVALID';
        V_S_CODE      := 'MSG00467';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

                                  
    BEGIN
        SELECT V_PROJECT_CODE INTO V_S_VALIDATION
        FROM (
            SELECT A.V_PROJECT_CODE
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_PROJECT B
                ON A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
            WHERE A.V_PROJECT_CODE <> 'N'
            AND   A.V_DIVISION_ID  <> '40'
            AND   B.PROJECT_CODE IS NULL
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00457';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

                                                         
    INSERT INTO GT_F021_DATA_DUP
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP,
     V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_PLANT_SITE_ID, V_YYYYMMDD, V_CELL_PROD_SITE_ID)
    SELECT LOC.V_DIVISION_ID, LOC.V_PROJECT_CODE, LOC.V_SCM_SITE_ID, LOC.V_ITEM_ID, LOC.V_DOM_EXP
         , LOC.V_FCST_TYPE, LOC.V_INCOTERMS, LOC.V_MEASURE, LOC.V_PLANT_SITE_ID, LOC.V_YYYYMMDD
         , LOC.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC LOC
    INNER JOIN DM_PLN_SALES_ETC_PLAN P
        ON  LOC.V_DIVISION_ID   = P.DIVISION_ID
        AND LOC.V_PROJECT_CODE  = P.PROJECT_CODE
        AND LOC.V_SCM_SITE_ID   = P.SCM_SITE_ID
        AND LOC.V_ITEM_ID       = P.ITEM_ID
        AND LOC.V_DOM_EXP       = P.DOM_EXP
        AND LOC.V_FCST_TYPE     = P.FCST_TYPE
        AND LOC.V_INCOTERMS     = P.INCOTERMS
        AND LOC.V_MEASURE       = P.MEASURE
        AND LOC.V_PLANT_SITE_ID = CASE WHEN P.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(P.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(P.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
        AND LOC.V_YYYYMMDD      = P.YYYYMMDD
        AND LOC.V_TEXT           = P.REMARK_TEXT
    WHERE LOC.V_ACTIVE_FLAG = 'I'
    UNION ALL
    SELECT RTF.V_DIVISION_ID, RTF.V_PROJECT_CODE, RTF.V_SCM_SITE_ID, RTF.V_ITEM_ID, RTF.V_DOM_EXP
         , RTF.V_FCST_TYPE, RTF.V_INCOTERMS, RTF.V_MEASURE, RTF.V_PLANT_SITE_ID, RTF.V_YYYYMMDD
         , RTF.V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF RTF
    INNER JOIN DM_PLN_SALES_PLAN P
        ON  RTF.V_DIVISION_ID       = P.DIVISION_ID
        AND RTF.V_PROJECT_CODE      = P.PROJECT_CODE
        AND RTF.V_SCM_SITE_ID       = P.SCM_SITE_ID
        AND RTF.V_ITEM_ID           = P.ITEM_ID
        AND RTF.V_DOM_EXP           = P.DOM_EXP
        AND RTF.V_FCST_TYPE         = P.FCST_TYPE
        AND RTF.V_INCOTERMS         = P.INCOTERMS
        AND RTF.V_MEASURE           = P.MEASURE
        AND RTF.V_PLANT_SITE_ID = CASE WHEN P.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(P.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(P.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE P.PLANT_SITE_ID END
        AND RTF.V_YYYYMMDD          = P.YYYYMMDD
        AND RTF.V_CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
    WHERE RTF.V_ACTIVE_FLAG = 'I';

    BEGIN
        SELECT CHR(10) || '*Div : ' || NVL(V_DIVISION_ID,'')
             || CHR(10) || CASE WHEN V_DIVISION_ID = '40' THEN '*End Customer : ' ELSE '*Project Code : ' END || NVL(V_PROJECT_CODE,'')
             || CHR(10) || '*Sales Site : '          || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || '*Model : '               || NVL(V_ITEM_ID,'')
             || CHR(10) || '*Customer Handbook : '   || NVL(V_DOM_EXP,'')
             || CHR(10) || '*FCST Type : '           || NVL(V_FCST_TYPE,'')
             || CHR(10) || '*INCOTERMS : '           || NVL(V_INCOTERMS,'')
             || CHR(10) || '*Measure : '             || NVL(V_MEASURE,'')
             || CHR(10) || '*Plant Site : '          || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || '*YYYYMMDD : '            || NVL(V_YYYYMMDD,'')
             || CHR(10) || '*Cell Prod Site ID : '   || NVL(V_CELL_PROD_SITE_ID,'')
        INTO V_S_VALIDATION
        FROM (SELECT * FROM GT_F021_DATA_DUP ORDER BY V_YYYYMMDD)
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00428';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

                      
    BEGIN
        SELECT A.V_ITEM_ID INTO V_S_VALIDATION
        FROM (
            SELECT A.V_ITEM_ID
            FROM   GT_F021_SALES_PLAN A
            LEFT OUTER JOIN SCM_MST_SITE_ITEM B
                ON  A.V_DIVISION_ID  = B.DIVISION_ID
                AND A.V_PROJECT_CODE = B.PROJECT_CODE
                AND A.V_SCM_SITE_ID  = B.SCM_SITE_ID
                AND A.V_ITEM_ID      = B.ITEM_ID
            WHERE A.V_DIVISION_ID = '40'
            AND   A.V_MEASURE     = 'Catch_Up'
            AND   B.ITEM_ID IS NULL
        ) A
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00458';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

                         
    SELECT SEGMENT2
    BULK COLLECT INTO T_FCST_TYPE
    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MST
    WHERE  MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
    AND    MST.SEGMENT1    = 'FCST_TYPE'
    AND    VALID_YN        = 'Y';

    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN TMP
            WHERE TMP.V_DIVISION_ID = '40'
            AND   TMP.V_MEASURE     = 'Catch_Up'
            AND   TMP.V_FCST_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(T_FCST_TYPE))
            AND   NOT EXISTS (
                SELECT 1 FROM DM_PLN_CFM_SELLING_PRICE FP
                WHERE FP.DIVISION_ID               = TMP.V_DIVISION_ID
                AND   FP.PROJECT_CODE              = TMP.V_PROJECT_CODE
                AND   FP.SCM_SITE_ID               = TMP.V_SCM_SITE_ID
                AND   CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
                AND   FP.ITEM_ID                   = TMP.V_ITEM_ID
                AND   SUBSTR(FP.YYYYMMDD,1,6)      = SUBSTR(TMP.V_YYYYMMDD,1,6)
                AND   FP.MEASURE                   = 'LOC'
                AND   FP.DOM_EXP                   = TMP.V_DOM_EXP
                AND   FP.FCST_TYPE                 = TMP.V_FCST_TYPE
                AND   FP.INCOTERMS                 = TMP.V_INCOTERMS
                AND   FP.CELL_PROD_SITE_ID         = TMP.V_CELL_PROD_SITE_ID
            )
        );
        v_log_type     := 'INVALID';
        V_S_CODE       := 'MSG00328';
        V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

                                                                                         
                                                                      
                                                                       
                                                                            
                                                                           
                                              
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1
            FROM ( SELECT DISTINCT V_DIVISION_ID, V_CREATED_BY
                     FROM GT_F021_SALES_PLAN
                    WHERE V_MEASURE = 'RTF_SYS_RP' ) TMP
            WHERE NOT EXISTS (
                SELECT 1
                FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B
                WHERE  B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                AND    B.VALID_YN    = 'Y'
                AND    B.SEGMENT2    = 'DMF0021'
                AND    B.SEGMENT3    = TMP.V_DIVISION_ID
                AND    B.SEGMENT4    = 'RTF_SYS_RP'
                AND    (B.SEGMENT1 = TMP.V_CREATED_BY
                        OR B.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                          WHERE G.USER_ID = TMP.V_CREATED_BY AND G.USE_YN = 'Y'))
                AND    (B.ATTRIBUTE1 IS NULL
                        OR (SELECT COUNT(DISTINCT V.YYYYMMDD)
                              FROM DM_MST_VERSION V
                             WHERE V.VERSION_TYPE  = 'SP_W'
                               AND V.DIVISION_ID   = TMP.V_DIVISION_ID
                               AND V.CREATION_DATE >
                                   (CASE WHEN TRUNC(SYSDATE, 'IW')
                                              + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                              + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                                              + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440 > SYSDATE
                                         THEN TRUNC(SYSDATE, 'IW') - 7 ELSE TRUNC(SYSDATE, 'IW') END)
                                   + DECODE(B.ATTRIBUTE1, 'MON', 0, 'TUE', 1, 'WED', 2, 'THU', 3, 'FRI', 4, 'SAT', 5, 'SUN', 6)
                                   + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 1, 2)), 0) / 24
                                   + NVL(TO_NUMBER(SUBSTR(B.ATTRIBUTE2, 3, 2)), 0) / 1440) = 1)
            )
        );
                                                                    
                                                                   
                                                                                  
        v_log_type := 'INVALID'; V_S_CODE := 'MSG01001'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

                 
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE = 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) > 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00459'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

                    
    BEGIN
        SELECT 1 INTO v_max_cnt FROM DUAL
        WHERE EXISTS (
            SELECT 1 FROM GT_F021_SALES_PLAN
            WHERE V_FCST_TYPE <> 'RMA' AND V_MEASURE = 'RTF_SYS_RP' AND NVL(V_QTY, 0) < 0
        );
        v_log_type := 'INVALID'; V_S_CODE := 'MSG00460'; V_S_VALIDATION := ' ';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
    END;

                      
    INSERT INTO GT_F021_PRICE_RTF_SYS_RP
    (V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID, V_CELL_PROD_SITE_ID, WEEK_NAME)
    SELECT A.V_PROJECT_CODE, A.V_SCM_SITE_ID, A.V_ITEM_ID, A.V_DOM_EXP, A.V_FCST_TYPE
         , A.V_INCOTERMS, A.V_PLANT_SITE_ID, A.V_CELL_PROD_SITE_ID, A.WEEK_NAME
    FROM (
        SELECT AA.V_YYYYMMDD, AA.V_DIVISION_ID, AA.V_PROJECT_CODE, AA.V_SCM_SITE_ID, AA.V_PLANT_SITE_ID
             , AA.V_CELL_PROD_SITE_ID, AA.V_ITEM_ID, AA.V_DOM_EXP, AA.V_FCST_TYPE, AA.V_INCOTERMS
             , AA.V_MEASURE, M.BASIS_START_DATE, AA.V_QTY, M.WEEK_NAME
        FROM   GT_F021_SALES_PLAN_RTF AA
        JOIN   SCM_SYS_CALENDAR_M M ON AA.V_YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  AA.V_MEASURE = 'RTF_SYS_RP'
    ) A
    LEFT JOIN (
        SELECT BB.YYYYMMDD, BB.DIVISION_ID, BB.PROJECT_CODE, BB.SCM_SITE_ID, BB.PLANT_SITE_ID
             , BB.CELL_PROD_SITE_ID, BB.ITEM_ID, BB.DOM_EXP, BB.FCST_TYPE, BB.INCOTERMS
             , BB.MEASURE, M.BASIS_START_DATE, BB.END_CUSTOMER
        FROM   DM_PLN_CFM_SELLING_PRICE BB
        JOIN   SCM_SYS_CALENDAR_M M ON BB.YYYYMMDD = M.BASIS_YYYYMMDD
        WHERE  BB.MEASURE = 'LOC'
    ) B
        ON  A.V_DIVISION_ID      = B.DIVISION_ID
        AND A.V_PROJECT_CODE     = B.PROJECT_CODE
        AND A.V_PROJECT_CODE     = B.END_CUSTOMER
        AND A.V_SCM_SITE_ID      = B.SCM_SITE_ID
        AND A.V_PLANT_SITE_ID = CASE WHEN B.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(B.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(B.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE B.PLANT_SITE_ID END
        AND A.V_CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
        AND A.V_ITEM_ID          = B.ITEM_ID
        AND A.V_DOM_EXP          = B.DOM_EXP
        AND A.V_FCST_TYPE        = B.FCST_TYPE
        AND A.V_INCOTERMS        = B.INCOTERMS
        AND A.BASIS_START_DATE   = B.BASIS_START_DATE
    WHERE B.BASIS_START_DATE IS NULL
    AND   A.V_FCST_TYPE <> 'ETC'
    AND   NVL(A.V_QTY, 0) <> 0;

    BEGIN
        SELECT CHR(10) || 'Project Code________ : '      || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Sales site_____________ : '  || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model________________ : '    || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Customs Handbook__ : '       || NVL(V_DOM_EXP,'')
             || CHR(10) || 'Fcst Type_____________ : '   || NVL((SELECT SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WHERE MST.LOOKUP_TYPE = 'SALES_TYPE_CODE' AND MST.SEGMENT1 = V_FCST_TYPE AND ROWNUM = 1), '')
             || CHR(10) || 'Incoterms____________ : '    || NVL(V_INCOTERMS,'')
             || CHR(10) || 'Plant Site___________ : '    || NVL(V_PLANT_SITE_ID,'')
             || CHR(10) || 'Cell Prod Site___________ : ' || NVL(V_CELL_PROD_SITE_ID,'')
             || CHR(10) || 'Week_________ : '            || NVL(WEEK_NAME,'')
        INTO V_S_VALIDATION
        FROM GT_F021_PRICE_RTF_SYS_RP WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00462';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

                                             
    BEGIN
        SELECT CHR(10) || 'Div: '            || NVL(V_DIVISION_ID,'')
             || CHR(10) || 'Project Code: '  || NVL(V_PROJECT_CODE,'')
             || CHR(10) || 'Scm Site Id: '   || NVL(V_SCM_SITE_ID,'')
             || CHR(10) || 'Model: '         || NVL(V_ITEM_ID,'')
             || CHR(10) || 'Currency : '     || NVL(V_CURRENCY,'')
        INTO V_S_VALIDATION
        FROM (
            SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                 , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            FROM   GT_F021_SALES_PLAN_LOC
            GROUP BY V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_TEXT, V_YYYYMMDD
                   , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_CURRENCY, V_PLANT_SITE_ID
            HAVING COUNT(*) > 1
        )
        WHERE ROWNUM = 1;

        v_log_type := 'INVALID';
        V_S_CODE   := 'MSG00461';
        GOTO VALIDATION_FAIL;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_S_VALIDATION := NULL;
    END;

                                                                                                                   
                       
                                                                                                                   

                                                                                                                   
                     
                                                                                                                   

                                             
    SELECT COUNT(1) INTO V_CNT FROM GT_F021_SALES_PLAN WHERE V_BUCKET = 'M';
    IF V_CNT > 0 THEN

                                                        
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

                                                  
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    ELSE
                                                       
        DELETE FROM DM_PLN_SALES_ETC_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE       = 'SalesAmt_LOC'
            AND    A.DIVISION_ID       = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE      = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID       = TMP.V_SCM_SITE_ID
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID           = TMP.V_ITEM_ID
            AND    A.DOM_EXP           = TMP.V_DOM_EXP
            AND    A.FCST_TYPE         = TMP.V_FCST_TYPE
            AND    A.INCOTERMS         = TMP.V_INCOTERMS
            AND    A.REMARK_TEXT       = TMP.V_TEXT
            AND    C2.BASIS_YYYYMM     = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW       = C1.ISO_YYYYWW
        )
        AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

        n_del_count := n_del_count + SQL%ROWCOUNT;

                                                 
        DELETE FROM DM_PLN_SALES_PLAN A
        WHERE EXISTS (
            SELECT 1
            FROM   GT_F021_SALES_PLAN TMP
            JOIN   SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
            JOIN   SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
            WHERE  TMP.V_MEASURE           = 'RTF_SYS_RP'
            AND    A.DIVISION_ID           = TMP.V_DIVISION_ID
            AND    A.PROJECT_CODE          = TMP.V_PROJECT_CODE
            AND    A.SCM_SITE_ID           = TMP.V_SCM_SITE_ID
            AND    CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
            AND    A.ITEM_ID               = TMP.V_ITEM_ID
            AND    A.DOM_EXP               = TMP.V_DOM_EXP
            AND    A.FCST_TYPE             = TMP.V_FCST_TYPE
            AND    A.INCOTERMS             = TMP.V_INCOTERMS
            AND    C2.BASIS_YYYYMM         = C1.BASIS_YYYYMM
            AND    C2.ISO_YYYYWW           = C1.ISO_YYYYWW
            AND    A.CELL_PROD_SITE_ID     = TMP.V_CELL_PROD_SITE_ID
        )
        AND A.DIVISION_ID = '40'
        AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

        n_del_count := n_del_count + SQL%ROWCOUNT;

    END IF;

                                              
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'SalesAmt_LOC'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE NOT IN ('MKT_FCST','RTF','CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

                      
    DELETE FROM DM_PLN_SALES_ETC_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE    = 'CATCH_UP'
        AND   A.DIVISION_ID   = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE  = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID   = TMP.V_SCM_SITE_ID
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID       = TMP.V_ITEM_ID
        AND   A.DOM_EXP       = TMP.V_DOM_EXP
        AND   A.FCST_TYPE     = TMP.V_FCST_TYPE
        AND   A.INCOTERMS     = TMP.V_INCOTERMS
        AND   A.REMARK_TEXT   = TMP.V_TEXT
        AND   C2.BASIS_YYYYMM = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW   = C1.ISO_YYYYWW
    )
    AND A.MEASURE IN ('CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up','RTF_SYS_RP');

    n_del_count := n_del_count + SQL%ROWCOUNT;

                                               
    DELETE FROM DM_PLN_SALES_PLAN A
    WHERE EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN TMP
        JOIN SCM_SYS_CALENDAR_M C1 ON TMP.V_YYYYMMDD = C1.BASIS_YYYYMMDD
        JOIN SCM_SYS_CALENDAR_M C2 ON A.YYYYMMDD     = C2.BASIS_YYYYMMDD
        WHERE TMP.V_MEASURE           = 'RTF_SYS_RP'
        AND   A.DIVISION_ID          = TMP.V_DIVISION_ID
        AND   A.PROJECT_CODE         = TMP.V_PROJECT_CODE
        AND   A.SCM_SITE_ID          = TMP.V_SCM_SITE_ID
        AND   CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = TMP.V_PLANT_SITE_ID
        AND   A.ITEM_ID              = TMP.V_ITEM_ID
        AND   A.DOM_EXP              = TMP.V_DOM_EXP
        AND   A.FCST_TYPE            = TMP.V_FCST_TYPE
        AND   A.INCOTERMS            = TMP.V_INCOTERMS
        AND   C2.BASIS_YYYYMM        = C1.BASIS_YYYYMM
        AND   C2.ISO_YYYYWW          = C1.ISO_YYYYWW
        AND   A.CELL_PROD_SITE_ID    = TMP.V_CELL_PROD_SITE_ID
    )
    AND A.DIVISION_ID = '40'
    AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_del_count := n_del_count + SQL%ROWCOUNT;

                                                                                                                   
                                                  
                                                                                                                   
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN tmp.V_QTY
                WHEN tmp.V_CURRENCY = 'USD' THEN NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

                                                                                                                   
                                                  
                                                                                                                   
    INSERT INTO GT_F021_SALES_PLAN_LOC
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE,
     V_YYYYMMDD, V_CURRENCY, V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID,
     V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD'
         , V_YYYYMMDD, V_CURRENCY
         , CASE WHEN tmp.V_CURRENCY = 'KRW' THEN NVL(tmp.V_QTY / (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
                WHEN tmp.V_CURRENCY = 'USD' THEN tmp.V_QTY
                ELSE NVL(tmp.V_QTY * (
                    SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                    WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                    AND UNIT_CURRENCY = tmp.V_CURRENCY AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE)
                    / (SELECT EXCHANGE_PRICE FROM DM_MST_EXCHANGE_RATE
                       WHERE DIVISION_ID = tmp.V_DIVISION_ID AND YYYYMMDD = SUBSTR(tmp.V_YYYYMMDD,1,6) || '01'
                       AND UNIT_CURRENCY = 'USD' AND CURRENCY = 'KRW' GROUP BY EXCHANGE_PRICE), 0)
           END
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_LOC tmp
    WHERE  tmp.V_MEASURE     = 'SalesAmt_LOC'
    AND    V_ACTIVE_FLAG    <> 'D';

                                                                                                                   
                                                                                              
                                                                                                                   
                               
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

                               
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

                               
    INSERT INTO GT_F021_SALES_PLAN
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD_Catch_Up', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (SELECT FP.PRICE FROM DM_PLN_CFM_SELLING_PRICE FP
                             JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                             WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                             AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                             AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                             AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                             AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD
                             AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID AND ROWNUM = 1), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'Catch_Up' AND V_ACTIVE_FLAG <> 'D';

                                                                                                                   
                                   
                                                                                                                   
                                                                                                                  

    INSERT INTO DM_PLN_SALES_ETC_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   GT_F021_SALES_PLAN_LOC
    WHERE  V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;



                     
    INSERT INTO DM_PLN_SALES_ETC_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, REMARK_TEXT,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1,
     ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT V_DIVISION_ID,
    SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL,
    V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_TEXT,
           V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY,
           V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE, V_DEPT_ID,
           NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
    FROM   GT_F021_SALES_PLAN_LOC;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;
                                                                        

                                                                                                                   
                                                                               
                                                                          
                                                                                                                   
                                   
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_KRW', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'KRW' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

                                                          
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_LOC', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'LOC' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

                                                          
    INSERT INTO GT_F021_SALES_PLAN_RTF
    (V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID,
     V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY,
     V_QTY, V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID)
    SELECT V_ACTIVE_FLAG, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID
         , V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'SalesAmt_USD', V_YYYYMMDD, V_CURRENCY
         , NVL(tmp.V_QTY * (
              SELECT PRICE FROM (
                  SELECT 'SCM_MST_FUTURE_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM SCM_MST_FUTURE_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
                  UNION ALL
                  SELECT 'DM_PLN_CFM_SELLING_PRICE' AS TBL, FP.PRICE, FP.DIVISION_ID
                  FROM DM_PLN_CFM_SELLING_PRICE FP JOIN SCM_SYS_CALENDAR_M CAL ON CAL.BASIS_YYYYMMDD = FP.YYYYMMDD
                  WHERE FP.DIVISION_ID = tmp.V_DIVISION_ID AND FP.PROJECT_CODE = tmp.V_PROJECT_CODE
                  AND FP.SCM_SITE_ID = tmp.V_SCM_SITE_ID AND CASE WHEN FP.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(FP.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(FP.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE FP.PLANT_SITE_ID END = tmp.V_PLANT_SITE_ID
                  AND FP.ITEM_ID = tmp.V_ITEM_ID AND FP.DOM_EXP = tmp.V_DOM_EXP
                  AND FP.FCST_TYPE = tmp.V_FCST_TYPE AND FP.INCOTERMS = tmp.V_INCOTERMS
                  AND FP.MEASURE = 'USD' AND FP.CELL_PROD_SITE_ID = tmp.V_CELL_PROD_SITE_ID
                  AND CAL.BASIS_START_DATE = tmp.V_YYYYMMDD AND ROWNUM = 1
              ) AA WHERE AA.TBL = CASE WHEN AA.DIVISION_ID = '40' THEN 'DM_PLN_CFM_SELLING_PRICE' ELSE 'SCM_MST_FUTURE_PRICE' END
           ), 0)
         , V_CREATED_BY, V_LAST_UPDATED_BY, V_TEXT, V_DEPT_ID, V_CELL_PROD_SITE_ID, V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN tmp
    WHERE  tmp.V_MEASURE = 'RTF_SYS_RP' AND V_ACTIVE_FLAG <> 'D';

                                                                                                                   
                                               
                                                                                                                   
    INSERT INTO DM_PLN_SALES_PLAN
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT NVL(V_DIVISION_ID, '-'), NVL(V_PROJECT_CODE, '-'), NVL(V_SCM_SITE_ID, '-'), NVL(V_PLANT_SITE_ID, '-'), NVL(V_ITEM_ID, '-')
         , NVL(V_DOM_EXP, '-'), NVL(V_FCST_TYPE, '-'), NVL(V_INCOTERMS, '-'), NVL(V_MEASURE, '-'), NVL(V_YYYYMMDD, '-'), V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
         , NVL(V_CELL_PROD_SITE_ID, '-')
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD')
    AND    V_ACTIVE_FLAG <> 'D';

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

                     
    INSERT INTO DM_PLN_SALES_PLAN_H
    (DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID,
     DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, CURRENCY, QTY,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10,
     CELL_PROD_SITE_ID)
    SELECT V_DIVISION_ID, SEQ1_DM_PLN_SALES_PLAN_H.NEXTVAL, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_YYYYMMDD, V_CURRENCY, V_QTY
         , V_CREATED_BY, SYSDATE, V_LAST_UPDATED_BY, SYSDATE
         , V_DEPT_ID, V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ACTIVE_FLAG
         , V_CELL_PROD_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF
    WHERE  V_MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_KRW','SalesAmt_LOC','SalesAmt_USD');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

                                                                                                                   
                                                        
                                                                                                                   
    INSERT INTO GT_F021_SALES_PLAN_INSERT
    (V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID,
     V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY,
     V_CELL_PROD_SITE_ID, V_YYYYMM, V_FROM_SITE_ID)
    SELECT DISTINCT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
         , V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, V_LAST_UPDATED_BY
         , V_CELL_PROD_SITE_ID, SUBSTR(V_YYYYMMDD,1,6), V_FROM_SITE_ID
    FROM   GT_F021_SALES_PLAN_RTF;

             

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_F021_SALES_PLAN_INSERT',
        ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE, METHOD_OPT => 'FOR ALL COLUMNS SIZE 1', NO_INVALIDATE => FALSE);

                                 
    DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID
        AND   Z.V_PROJECT_CODE     = DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID      = DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID
        AND   Z.V_ITEM_ID          = DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID
        AND   Z.V_DOM_EXP          = DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP
        AND   Z.V_FCST_TYPE        = DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE
        AND   Z.V_INCOTERMS        = DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS
        AND   Z.V_MEASURE          = DM_PLN_CFM_MKT_DEMAND_PLAN.MEASURE
        AND   Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID END
        AND   Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID
        AND   Z.V_YYYYMM           = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;

                                 
    INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
    (DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE,
     LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5,
     ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
         , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

                                    
    DELETE FROM DM_PLN_MKT_FCST
    WHERE DIVISION_ID = v_division_id_val
    AND   MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    AND   EXISTS (
        SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z
        WHERE Z.V_DIVISION_ID   = DM_PLN_MKT_FCST.DIVISION_ID
        AND   Z.V_PROJECT_CODE  = DM_PLN_MKT_FCST.PROJECT_CODE
        AND   Z.V_SCM_SITE_ID   = DM_PLN_MKT_FCST.SCM_SITE_ID
        AND   Z.V_ITEM_ID       = DM_PLN_MKT_FCST.ITEM_ID
        AND   Z.V_DOM_EXP       = DM_PLN_MKT_FCST.DOM_EXP
        AND   Z.V_FCST_TYPE     = DM_PLN_MKT_FCST.FCST_TYPE
        AND   Z.V_INCOTERMS     = DM_PLN_MKT_FCST.INCOTERMS
        AND   Z.V_MEASURE       = DM_PLN_MKT_FCST.MEASURE
        AND   Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST.PLANT_SITE_ID END
        AND   Z.V_YYYYMM        = SUBSTR(DM_PLN_MKT_FCST.YYYYMMDD, 1, 6)
    );

    n_del_count := n_del_count + SQL%ROWCOUNT;


    INSERT INTO DM_PLN_MKT_FCST
    (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS,
     MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
         , A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
         , MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
    FROM   DM_PLN_SALES_PLAN A
    JOIN   GT_F021_SALES_PLAN_INSERT Z
        ON  A.DIVISION_ID          = Z.V_DIVISION_ID
        AND A.PROJECT_CODE         = Z.V_PROJECT_CODE
        AND A.SCM_SITE_ID          = Z.V_SCM_SITE_ID
        AND A.ITEM_ID              = Z.V_ITEM_ID
        AND A.DOM_EXP              = Z.V_DOM_EXP
        AND A.FCST_TYPE            = Z.V_FCST_TYPE
        AND A.INCOTERMS            = Z.V_INCOTERMS
        AND A.MEASURE              = Z.V_MEASURE
        AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID
        AND A.CELL_PROD_SITE_ID    = Z.V_CELL_PROD_SITE_ID
        AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
    WHERE  A.DIVISION_ID = v_division_id_val
    AND    A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
           , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

    n_insert_count := n_insert_count + SQL%ROWCOUNT;

                                                                                                                   
                                         
                                                                                                                   
                   
    SELECT MAX(VERSION_NO) INTO v_max_mf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'MF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;


    IF v_max_mf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_mf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val
        AND    VERSION_NO   = v_max_mf_w_version
        AND    VERSION_TYPE = 'MF_W';

                                                            
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C
        WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W'
        AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW')
        AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

                                                 
        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_mf_w_version AND CUTOFF_TYPE = 'MF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST_C.PLANT_SITE_ID END AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_mf_w_version, 'MF_W', v_max_mf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;

                           
    SELECT MAX(VERSION_NO) INTO v_max_sf_w_version
    FROM   DM_MST_VERSION
    WHERE  DIVISION_ID  = v_division_id_val
    AND    VERSION_TYPE = 'SF_W'
    AND    YYYYMMDD    >= v_cutoff_start
    AND    YYYYMMDD     < v_cutoff_end;


    IF v_max_sf_w_version IS NOT NULL THEN
        SELECT YYYYMMDD INTO v_max_sf_w_yyyymmdd
        FROM   DM_MST_VERSION
        WHERE  DIVISION_ID  = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND VERSION_TYPE = 'SF_W';

        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_CFM_MKT_DEMAND_PLAN_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_CFM_MKT_DEMAND_PLAN_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_CFM_MKT_DEMAND_PLAN_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_CFM_MKT_DEMAND_PLAN_C.PLANT_SITE_ID END AND Z.V_CELL_PROD_SITE_ID = DM_PLN_CFM_MKT_DEMAND_PLAN_C.CELL_PROD_SITE_ID AND Z.V_YYYYMM = SUBSTR(DM_PLN_CFM_MKT_DEMAND_PLAN_C.YYYYMMDD,1,6));

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD, A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, NULL, Z.V_FROM_SITE_ID, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP','SalesAmt_LOC','SalesAmt_USD','SalesAmt_KRW');

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

        DELETE FROM DM_PLN_MKT_FCST_C WHERE DIVISION_ID = v_division_id_val AND VERSION_NO = v_max_sf_w_version AND CUTOFF_TYPE = 'SF_W' AND MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP') AND EXISTS (SELECT 1 FROM GT_F021_SALES_PLAN_INSERT Z WHERE Z.V_DIVISION_ID = DM_PLN_MKT_FCST_C.DIVISION_ID AND Z.V_PROJECT_CODE = DM_PLN_MKT_FCST_C.PROJECT_CODE AND Z.V_SCM_SITE_ID = DM_PLN_MKT_FCST_C.SCM_SITE_ID AND Z.V_ITEM_ID = DM_PLN_MKT_FCST_C.ITEM_ID AND Z.V_DOM_EXP = DM_PLN_MKT_FCST_C.DOM_EXP AND Z.V_FCST_TYPE = DM_PLN_MKT_FCST_C.FCST_TYPE AND Z.V_INCOTERMS = DM_PLN_MKT_FCST_C.INCOTERMS AND Z.V_MEASURE = DM_PLN_MKT_FCST_C.MEASURE AND Z.V_PLANT_SITE_ID = CASE WHEN DM_PLN_MKT_FCST_C.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(DM_PLN_MKT_FCST_C.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(DM_PLN_MKT_FCST_C.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE DM_PLN_MKT_FCST_C.PLANT_SITE_ID END AND Z.V_YYYYMM = SUBSTR(DM_PLN_MKT_FCST_C.YYYYMMDD,1,6));

        n_del_count := n_del_count + SQL%ROWCOUNT;

        INSERT INTO DM_PLN_MKT_FCST_C
        (DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT A.DIVISION_ID, v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD, SUM(A.QTY), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE), MAX(A.LAST_UPDATED_BY), MAX(A.LAST_UPDATE_DATE)
        FROM DM_PLN_SALES_PLAN A JOIN GT_F021_SALES_PLAN_INSERT Z ON A.DIVISION_ID = Z.V_DIVISION_ID AND A.PROJECT_CODE = Z.V_PROJECT_CODE AND A.SCM_SITE_ID = Z.V_SCM_SITE_ID AND A.ITEM_ID = Z.V_ITEM_ID AND A.DOM_EXP = Z.V_DOM_EXP AND A.FCST_TYPE = Z.V_FCST_TYPE AND A.INCOTERMS = Z.V_INCOTERMS AND A.MEASURE = Z.V_MEASURE AND CASE WHEN A.PLANT_SITE_ID IS NULL OR TRIM(REPLACE(A.PLANT_SITE_ID,CHR(0),' ')) IS NULL OR TRIM(A.PLANT_SITE_ID) IN ('-','--') THEN '-' ELSE A.PLANT_SITE_ID END = Z.V_PLANT_SITE_ID AND A.CELL_PROD_SITE_ID = Z.V_CELL_PROD_SITE_ID AND SUBSTR(A.YYYYMMDD,1,6) = Z.V_YYYYMM
        WHERE A.DIVISION_ID = v_division_id_val AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
        GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP,
        A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD,
        v_max_sf_w_version, 'SF_W', v_max_sf_w_yyyymmdd;

        n_insert_count := n_insert_count + SQL%ROWCOUNT;

    END IF;

    COMMIT;

             
    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := 'delete_count= ' || TO_CHAR(n_del_count) || ' / insert_count= ' || TO_CHAR(n_insert_count);
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    IF P_ACTIVE_FLAG = 'I' THEN
        n_event_count := n_insert_count;
    ELSIF P_ACTIVE_FLAG = 'D' THEN
        n_event_count := n_del_count;
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(n_event_count) AS EVENT FROM DUAL;


    RETURN;

                                                                                                                   
                         
                                                                                                                   
    <<VALIDATION_FAIL>>
    ROLLBACK;
    v_log_message := V_S_CODE;
    v_description := V_S_CODE || '^' || V_S_VALIDATION;
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;

    v_log_type    := 'END';
    v_log_message := '########## END of procedure ##########';
    d_event_date  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date); END;


    OPEN O_RESULT_CURSOR FOR
    SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_S_CODE || '^' || V_S_VALIDATION AS EVENT FROM DUAL;
    RETURN;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_PROC_INPUT := JSON_OBJECT(
            'P_DIVISION_ID' VALUE SUBSTR(P_DIVISION_ID,1,500),
            'P_CREATED_BY'  VALUE P_CREATED_BY
        );
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, 'ERROR', n_log_count, 'EXCEPTION',
                '', SYSDATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        RAISE_APPLICATION_ERROR(-20001,
          '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
          ' / SQLERRM=' || V_SQL_ERRMSG ||
          ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
          ' / PARAMS=' || V_PROC_INPUT
        );
        RAISE;

END P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL;

END PKG_DMF0021;