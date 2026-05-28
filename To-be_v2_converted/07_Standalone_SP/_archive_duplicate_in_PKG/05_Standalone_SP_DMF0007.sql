-- ============================================================================
-- ARCHIVED: 다음 SP들은 PKG_DMF0007 에 이미 등록되어 있어 standalone에서 제거됨
--          PKG 호출 권장: SCM_MGR.PKG_DMF0007.P_{SP_NAME}
-- ============================================================================


-- DMF0007_GET_CUST_FCST_DATA → PKG_DMF0007.P_DMF0007_GET_CUST_FCST_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0007_GET_CUST_FCST_DATA(
    p_plan_week       IN VARCHAR2,
    p_division_id     IN VARCHAR2,
    p_dept_id         IN VARCHAR2,
    p_end_customer    IN VARCHAR2,
    p_scm_site_id     IN VARCHAR2,
    p_bucket_type     IN VARCHAR2,
    p_valid_yn        IN VARCHAR2,
    p_created_by      IN VARCHAR2,
    p_user_group      IN VARCHAR2
)
AS
    v_err_msg           VARCHAR2(4000 CHAR);
    v_backtrace         VARCHAR2(4000 CHAR);
    v_sql_text          VARCHAR2(4000 CHAR);
    v_iteration         VARCHAR2(4000 CHAR);
    v_column_text       VARCHAR2(200 CHAR);
    v_column_name       VARCHAR2(20 CHAR);
    v_weekstart_date    VARCHAR2(8 CHAR);
    v_param_list        VARCHAR2(4000 CHAR);
    v_plan_week         VARCHAR2(6 CHAR);
    v_start_week        VARCHAR2(8 CHAR);
    v_end_week          VARCHAR2(8 CHAR);
    v_start_yyyymmdd    VARCHAR2(8 CHAR);
    v_end_yyyymmdd      VARCHAR2(8 CHAR);
    v_bucket_type       VARCHAR2(10 CHAR);
    v_group_id          VARCHAR2(50 CHAR) := '';
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_ITEMLIST'; -- TABLE VARIABLE @ItemList → GTT GT_DMPL_ITEMLIST

    ---------------------------------------------------------------------------------  
    -- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)  
    ---------------------------------------------------------------------------------  
    IF NVL(( SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
             WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
             AND VALID_YN = 'Y'
             AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
             AND SEGMENT1 = p_user_group), 0) > 0  
    THEN  
        v_group_id := 'ADMIN';  
    END IF;  

    ---------------------------------------------------------------------------------  
    -- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)  
    ---------------------------------------------------------------------------------  
    v_start_week := '';  
    v_end_week := '';  

    v_start_week := p_plan_week;  
    v_bucket_type := p_bucket_type;  

    SELECT C.ISO_YYYYWW  
    INTO v_plan_week  
    FROM SCM_SYS_CALENDAR_M C   
    WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD');  

    IF v_start_week = ''
    THEN  
        IF v_bucket_type = 'DAILY'              
        THEN
            SELECT MIN(C.BASIS_YYYYMMDD)   
                 , MIN(C.BASIS_YYYYMMDD)   
            INTO v_start_week, v_start_yyyymmdd   
            FROM SCM_SYS_CALENDAR_M C    
            WHERE C.ISO_YYYYWW = ( SELECT C.ISO_YYYYWW  
                                   FROM SCM_SYS_CALENDAR_M C    
                                   WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')  
                                 );

        ELSIF v_bucket_type = 'WEEKLY'  
        THEN
            SELECT MIN(C.ISO_YYYYWW)  
                 , MIN(C.BASIS_YYYYMMDD)  
            INTO v_start_week, v_start_yyyymmdd  
            FROM SCM_SYS_CALENDAR_M C    
            WHERE C.ISO_YYYYWW = ( SELECT C.ISO_YYYYWW  
                                   FROM SCM_SYS_CALENDAR_M C   
                                   WHERE C.BASIS_YYYYMMDD = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')  
                                 );

        ELSIF v_bucket_type = 'MONTHLY'  
        THEN
            SELECT T.BASIS_YYYYMM  
                 , T.BASIS_YYYYMMDD  
            INTO v_start_week, v_start_yyyymmdd  
            FROM ( SELECT MIN(C.BASIS_YYYYMM)	AS BASIS_YYYYMM  
                       , MIN(C.BASIS_YYYYMMDD)	AS BASIS_YYYYMMDD  
                   FROM SCM_SYS_CALENDAR_M C   
                   WHERE C.BASIS_YYYYMM = TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMM')  
                 ) T;
        END IF;
    ELSE  
        v_start_week := p_plan_week;    
    END IF;         
         
    IF v_bucket_type = 'DAILY'  
    THEN  
        FOR rec IN ( SELECT 'D_' || A.BASIS_YYYYMMDD		AS COLUMN_NAME  
                           , A.BASIS_YYYYMMDD		AS BASIS_YYYYMMDD  
                     FROM SCM_SYS_CALENDAR_M A   
                     WHERE 1 = 1  
                     AND A.BASIS_YYYYMMDD >=  v_start_week  
                     AND A.BASIS_YYYYMMDD <= v_end_week
                   ) LOOP
            v_column_text := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''' || rec.BASIS_YYYYMMDD || ''' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS ' || rec.COLUMN_NAME;     
            v_iteration := v_iteration || v_column_text;   
        END LOOP;
    ELSIF v_bucket_type = 'WEEKLY'  
    THEN  
        FOR rec IN ( SELECT 'D_' || MIN(A.BASIS_START_DATE)	AS COLUMN_NAME  
                           , MIN(A.BASIS_YYYYMMDD)		AS BASIS_YYYYMMDD  
                     FROM  SCM_SYS_CALENDAR_M A   
                     WHERE 1 = 1  
                     AND A.ISO_YYYYWW >=  v_start_week  
                     AND A.ISO_YYYYWW <= v_end_week       
                     GROUP BY A.ISO_YYYYWW
                   ) LOOP
            v_column_text := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''' || rec.BASIS_YYYYMMDD || ''' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS ' || rec.COLUMN_NAME;     
            v_iteration := v_iteration || v_column_text;   
        END LOOP;
    ELSIF v_bucket_type = 'MONTHLY'  
    THEN  
        FOR rec IN ( SELECT 'D_' || MIN(A.BASIS_YYYYMMDD)		AS COLUMN_NAME  
                           , MIN(A.BASIS_YYYYMMDD)		AS BASIS_YYYYMMDD  
                     FROM SCM_SYS_CALENDAR_M A   
                     WHERE 1 = 1  
                     AND A.BASIS_YYYYMM >= v_start_week  
                     AND A.BASIS_YYYYMM <= v_end_week   
                     GROUP BY A.MONTH_NAME
                   ) LOOP
            v_column_text := ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''' || rec.BASIS_YYYYMMDD || ''' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS ' || rec.COLUMN_NAME;     
            v_iteration := v_iteration || v_column_text;   
        END LOOP;
    END IF;

    --소형사업부 추가(END CUSTOMER 체크 안함)
    IF p_division_id = '40' --E20230227-000456소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
    THEN
        v_sql_text := '  
            WITH MASTER AS   
                    (	SELECT CF.PLAN_WEEK, CF.DIVISION_ID, S.DEPT_ID, CF.CUSTOMER_CODE, CF.SCM_SITE_ID        
                                , CF.SUMMARY_BUCKET_TYPE, CF.MEASURE_GROUP, CF.MEASURE, CF.EDI_FCST_YN, CF.CUSTOMER_PSI  
                                , CF.UPLOAD_UOM, CF.UPLOAD_BUCKET_TYPE  
                                /*--, CF.VALID_YN*/  
                                , CF.MASTER_VALID_YN, C.BASIS_YYYYMMDD AS SUMMARY_BUCKET_VALUE   
                        FROM (	SELECT T1.PLAN_WEEK, T1.DIVISION_ID, T1.CUSTOMER_CODE, T1.SCM_SITE_ID, T1.SUMMARY_BUCKET_TYPE  
                                        , T1.MEASURE_GROUP, T1.MEASURE, T1.EDI_FCST_YN, T1.CUSTOMER_PSI, T1.UPLOAD_UOM  
                                        , T1.UPLOAD_BUCKET_TYPE, T1.MASTER_VALID_YN, T2.VALID_YN, T2.SUMMARY_BUCKET_VALUE  
                               	FROM ( SELECT PLAN_WEEK, DIVISION_ID , CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                           	, MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                           	, UPLOAD_BUCKET_TYPE, MAX(VALID_YN) AS MASTER_VALID_YN              
                                       FROM DM_MST_CUSTOMER_FCST CF     
                                       WHERE 1 = 1  
                                       AND  MEASURE_GROUP = ''CUST_FCST''  
                                       AND  PLAN_WEEK     = ''' || p_plan_week || '''   
                                       AND  SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''  
                                       ' || FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID', 'IN', p_division_id) || '    
                                       /*--' || FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE', 'IN', p_end_customer) || '*/   
                                       ' || FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID', 'IN', p_scm_site_id) || '  
                                       /*--' || FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', p_bucket_type) || ' --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/                     
                                       GROUP BY PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                              , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                              , UPLOAD_BUCKET_TYPE  
                                     ) T1  
                                LEFT JOIN DM_MST_CUSTOMER_FCST T2       
                                       ON  T1.PLAN_WEEK				= T2.PLAN_WEEK  
                                      AND T1.DIVISION_ID			= T2.DIVISION_ID   
                                      AND T1.CUSTOMER_CODE			= T2.CUSTOMER_CODE     
                                      AND T1.SCM_SITE_ID			= T2.SCM_SITE_ID        
                                      AND T1.SUMMARY_BUCKET_TYPE	= T2.SUMMARY_BUCKET_TYPE  
                                      AND T1.MEASURE_GROUP			= T2.MEASURE_GROUP  
                                      AND T1.MEASURE				= T2.MEASURE  
                                      AND T1.EDI_FCST_YN			= T2.EDI_FCST_YN  
                                      AND T1.CUSTOMER_PSI			= T2.CUSTOMER_PSI  
                                      AND T1.UPLOAD_UOM				= T2.UPLOAD_UOM  
                                      AND T1.UPLOAD_BUCKET_TYPE		= T2.UPLOAD_BUCKET_TYPE  
                                      AND T2.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''         
                                WHERE  1 = 1  
                                ) CF    
                        LEFT JOIN SCM_SYS_CALENDAR_M C     
                               ON (C.BASIS_YYYYMMDD = CF.SUMMARY_BUCKET_VALUE    
                              AND C.BASIS_YYYYMMDD BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || ''')       
                        , SCM_MST_SITE S   
                        WHERE  1 = 1  
                        AND CF.DIVISION_ID			= S.DIVISION_ID  
                        /*--AND CF.CUSTOMER_CODE	= S.END_CUSTOMER*/  
                        AND CF.SCM_SITE_ID			= S.SCM_SITE_ID  
                        /*--' || FN_SCM_GET_WHERE_SQL('S.DEPT_ID', 'IN', p_dept_id) || '*/     
                        AND CF.UPLOAD_BUCKET_TYPE	= ''' || v_bucket_type || ''' /*E20250326-000842_Customer FCST Master 조회 로직 수정*/         
                    )  
  
            SELECT M.PLAN_WEEK, M.DIVISION_ID, M.DEPT_ID, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                 , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                             WHEN ''WEEKLY'' THEN 2  
                                             WHEN ''MONTHLY'' THEN 3 END AS UPLOAD_ORDER  
                 , M.SUMMARY_BUCKET_TYPE, M.MEASURE_GROUP, M.MEASURE, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                 , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE 
                 /*-- , M.VALID_YN */ 
                 , M.MASTER_VALID_YN AS VALID_YN  
                 , CASE WHEN ((FN_GET_DEPT_LIST(''' || p_created_by || ''', M.DEPT_ID) = ''Y'') OR ''' || v_group_id || ''' =''ADMIN'')   
                        THEN ''Y'' ELSE '''' END AS EDIT_FLAG  
                 ' || v_iteration || '      
            FROM MASTER M   
            LEFT OUTER JOIN DM_MST_CUSTOMER_FCST CF   
                         ON (M.PLAN_WEEK			= CF.PLAN_WEEK  
                        AND M.DIVISION_ID			= CF.DIVISION_ID  
                        AND M.CUSTOMER_CODE			= CF.CUSTOMER_CODE  
                        AND M.SCM_SITE_ID			= CF.SCM_SITE_ID  
                        AND M.SUMMARY_BUCKET_TYPE	= CF.SUMMARY_BUCKET_TYPE  
                        AND M.MEASURE_GROUP			= CF.MEASURE_GROUP  
                        AND M.MEASURE				= CF.MEASURE  
                        AND M.SUMMARY_BUCKET_VALUE	= CF.SUMMARY_BUCKET_VALUE  
                        AND M.EDI_FCST_YN			= CF.EDI_FCST_YN  
                        AND M.CUSTOMER_PSI			= CF.CUSTOMER_PSI  
                        AND M.UPLOAD_UOM			= CF.UPLOAD_UOM  
                        AND M.UPLOAD_BUCKET_TYPE	= CF.UPLOAD_BUCKET_TYPE  
                        ' || FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID', 'IN', p_division_id) || '          
                        /*--	' || FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE', 'IN', p_end_customer) || '*/   
                        ' || FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID', 'IN', p_scm_site_id) || '  
                        /*--' || FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', p_bucket_type) || ' --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/        
                        /*-- AND CF.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''*/  
                        )  
            WHERE  1 = 1  
            ' || FN_SCM_GET_WHERE_SQL('M.MASTER_VALID_YN', 'EQ', p_valid_yn) || '  
            /*--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''*/  
            GROUP BY M.PLAN_WEEK, M.DIVISION_ID, M.DEPT_ID, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                   , M.SUMMARY_BUCKET_TYPE, M.MEASURE, M.MEASURE_GROUP, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                   , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                   /*-- , M.VALID_YN*/   
                   , M.MASTER_VALID_YN  
                   , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                               WHEN ''WEEKLY'' THEN 2  
                                               WHEN ''MONTHLY'' THEN 3 END  
            ORDER BY DIVISION_ID, DEPT_ID, CUSTOMER_CODE, SCM_SITE_ID, UPLOAD_ORDER, MEASURE_GROUP, MEASURE  
            ';
    ELSE
        v_sql_text := '  
            WITH MASTER AS   
                    (	SELECT CF.PLAN_WEEK, CF.DIVISION_ID, S.DEPT_ID, CF.CUSTOMER_CODE, CF.SCM_SITE_ID        
                                , CF.SUMMARY_BUCKET_TYPE, CF.MEASURE_GROUP, CF.MEASURE, CF.EDI_FCST_YN, CF.CUSTOMER_PSI  
                                , CF.UPLOAD_UOM, CF.UPLOAD_BUCKET_TYPE  
                                /* --, CF.VALID_YN*/  
                                , CF.MASTER_VALID_YN, C.BASIS_YYYYMMDD AS SUMMARY_BUCKET_VALUE   
                        FROM (	SELECT T1.PLAN_WEEK, T1.DIVISION_ID, T1.CUSTOMER_CODE, T1.SCM_SITE_ID, T1.SUMMARY_BUCKET_TYPE  
                                        , T1.MEASURE_GROUP, T1.MEASURE, T1.EDI_FCST_YN, T1.CUSTOMER_PSI, T1.UPLOAD_UOM  
                                        , T1.UPLOAD_BUCKET_TYPE, T1.MASTER_VALID_YN, T2.VALID_YN, T2.SUMMARY_BUCKET_VALUE  
                               	FROM ( SELECT PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                           	, MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI, UPLOAD_UOM  
                                           	, UPLOAD_BUCKET_TYPE , MAX(VALID_YN) AS MASTER_VALID_YN              
                                       FROM DM_MST_CUSTOMER_FCST CF     
                                       WHERE 1 = 1  
                                       AND MEASURE_GROUP = ''CUST_FCST''  
                                       AND PLAN_WEEK     = ''' || p_plan_week || '''   
                                       AND SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''  
                                       ' || FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID', 'IN', p_division_id) || '    
                                       ' || FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE', 'IN', p_end_customer) || '   
                                       ' || FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID', 'IN', p_scm_site_id) || '  
                                       /*--' || FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', p_bucket_type) || ' --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/                    
                                       GROUP BY PLAN_WEEK, DIVISION_ID, CUSTOMER_CODE, SCM_SITE_ID, SUMMARY_BUCKET_TYPE  
                                              , MEASURE_GROUP, MEASURE, EDI_FCST_YN, CUSTOMER_PSI , UPLOAD_UOM  
                                              , UPLOAD_BUCKET_TYPE  
                                    ) T1  
                                LEFT JOIN DM_MST_CUSTOMER_FCST T2       
                                       ON T1.PLAN_WEEK				= T2.PLAN_WEEK  
                                      AND T1.DIVISION_ID			= T2.DIVISION_ID   
                                      AND T1.CUSTOMER_CODE			= T2.CUSTOMER_CODE     
                                      AND T1.SCM_SITE_ID			= T2.SCM_SITE_ID        
                                      AND T1.SUMMARY_BUCKET_TYPE	= T2.SUMMARY_BUCKET_TYPE  
                                      AND T1.MEASURE_GROUP			= T2.MEASURE_GROUP  
                                      AND T1.MEASURE				= T2.MEASURE  
                                      AND T1.EDI_FCST_YN			= T2.EDI_FCST_YN  
                                      AND T1.CUSTOMER_PSI			= T2.CUSTOMER_PSI  
                                      AND T1.UPLOAD_UOM				= T2.UPLOAD_UOM  
                                      AND T1.UPLOAD_BUCKET_TYPE		= T2.UPLOAD_BUCKET_TYPE  
                                      AND T2.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || '''         
                                WHERE  1 = 1  
                                ) CF    
                        LEFT JOIN SCM_SYS_CALENDAR_M C     
                               ON (C.BASIS_YYYYMMDD = CF.SUMMARY_BUCKET_VALUE    
                              AND C.BASIS_YYYYMMDD BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || ''')       
                        , SCM_MST_SITE S   
                        WHERE  1 = 1  
                        AND CF.DIVISION_ID   = S.DIVISION_ID  
                        AND CF.CUSTOMER_CODE = S.END_CUSTOMER  
                        AND CF.SCM_SITE_ID   = S.SCM_SITE_ID  
                        ' || FN_SCM_GET_WHERE_SQL('S.DEPT_ID', 'IN', p_dept_id) || '                        
                        AND CF.UPLOAD_BUCKET_TYPE  = ''' || v_bucket_type || '''/*E20250326-000842_Customer FCST Master 조회 로직 수정*/                    
                    )  
  
            SELECT M.PLAN_WEEK, M.DIVISION_ID, M.DEPT_ID, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                 , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                             WHEN ''WEEKLY'' THEN 2  
                                             WHEN ''MONTHLY'' THEN 3 END AS UPLOAD_ORDER  
                 , M.SUMMARY_BUCKET_TYPE, M.MEASURE_GROUP, M.MEASURE, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                 , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                 /*-- , M.VALID_YN */ 
                 , M.MASTER_VALID_YN AS VALID_YN  
                 , CASE WHEN ((FN_GET_DEPT_LIST(''' || p_created_by || ''', M.DEPT_ID) = ''Y'') OR ''' || v_group_id || ''' =''ADMIN'')   
                        THEN ''Y'' ELSE '''' END AS EDIT_FLAG  
                 ' || v_iteration || '      
            FROM  MASTER M   
            LEFT OUTER JOIN DM_MST_CUSTOMER_FCST CF   
                         ON (M.PLAN_WEEK			= CF.PLAN_WEEK  
                        AND M.DIVISION_ID			= CF.DIVISION_ID  
                        AND M.CUSTOMER_CODE			= CF.CUSTOMER_CODE  
                        AND M.SCM_SITE_ID			= CF.SCM_SITE_ID  
                        AND M.SUMMARY_BUCKET_TYPE	= CF.SUMMARY_BUCKET_TYPE  
                        AND M.MEASURE_GROUP			= CF.MEASURE_GROUP  
                        AND M.MEASURE				= CF.MEASURE  
                        AND M.SUMMARY_BUCKET_VALUE	= CF.SUMMARY_BUCKET_VALUE  
                        AND M.EDI_FCST_YN			= CF.EDI_FCST_YN  
                        AND M.CUSTOMER_PSI			= CF.CUSTOMER_PSI  
                        AND M.UPLOAD_UOM			= CF.UPLOAD_UOM  
                        AND M.UPLOAD_BUCKET_TYPE	= CF.UPLOAD_BUCKET_TYPE  
                        ' || FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID', 'IN', p_division_id) || '          
                        ' || FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE', 'IN', p_end_customer) || '   
                        ' || FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID', 'IN', p_scm_site_id) || '  
                        /*--' || FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', p_bucket_type) || ' --E20250326-000842_조건은 UPLOAD BUCKET 기준으로 변경*/    
                        /*-- AND CF.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || ''' */ 
                            )  
            WHERE  1 = 1  
            ' || FN_SCM_GET_WHERE_SQL('M.MASTER_VALID_YN', 'EQ', p_valid_yn) || '  
            /*--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''' || v_end_yyyymmdd || ''' */ 
            GROUP BY M.PLAN_WEEK, M.DIVISION_ID, M.DEPT_ID, M.CUSTOMER_CODE, M.SCM_SITE_ID        
                   , M.SUMMARY_BUCKET_TYPE, M.MEASURE, M.MEASURE_GROUP, M.EDI_FCST_YN, M.CUSTOMER_PSI  
                   , M.UPLOAD_UOM, M.UPLOAD_BUCKET_TYPE  
                   /*-- , M.VALID_YN  */
                   , M.MASTER_VALID_YN  
                   , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1  
                                               WHEN ''WEEKLY'' THEN 2  
                                               WHEN ''MONTHLY'' THEN 3 END  
            ORDER BY DIVISION_ID, DEPT_ID, CUSTOMER_CODE, SCM_SITE_ID, UPLOAD_ORDER, MEASURE_GROUP, MEASURE     
            ';
    END IF;		 
  
    EXECUTE IMMEDIATE v_sql_text;

    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        v_err_msg   := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0007_GET_CUST_FCST_DATA failed: ' || v_err_msg);
END DMF0007_GET_CUST_FCST_DATA;
/

-- DMF0007_GET_CUST_PSI_DATA → PKG_DMF0007.P_DMF0007_GET_CUST_PSI_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0007_GET_CUST_PSI_DATA(
    p_plan_week     IN VARCHAR2,
    p_division_id   IN VARCHAR2,
    p_dept_id       IN VARCHAR2,
    p_end_customer  IN VARCHAR2,
    p_scm_site_id   IN VARCHAR2,
    p_bucket_type   IN VARCHAR2,
    p_valid_yn      IN VARCHAR2,
    p_created_by    IN VARCHAR2,
    p_user_group    IN VARCHAR2
)
AS
    v_err_msg       VARCHAR2(4000 CHAR);
    v_backtrace     VARCHAR2(4000 CHAR);
    v_sql_text      VARCHAR2(4000 CHAR);
    v_iteration     VARCHAR2(4000 CHAR);
    v_column_text   VARCHAR2(200 CHAR);
    v_column_name   VARCHAR2(20 CHAR);
    v_weekstart_date VARCHAR2(8 CHAR);
    p_param_list    VARCHAR2(4000 CHAR);
    v_plan_week     VARCHAR2(6 CHAR);
    v_start_week    VARCHAR2(8 CHAR);
    v_end_week      VARCHAR2(8 CHAR);
    v_start_yyyymmdd VARCHAR2(8 CHAR);
    v_end_yyyymmdd   VARCHAR2(8 CHAR);
    v_bucket_type    VARCHAR2(10 CHAR);
    v_group_id       VARCHAR2(50 CHAR) := '';
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_ITEMLIST'; -- TABLE VARIABLE @ItemList → GTT GT_DMPL_ITEMLIST

    --IF v_group_id = 'ADMIN' OR v_group_id = 'DM ADMIN'
    --    v_group_id := 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    IF NVL((
                SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL  
                WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
                  AND VALID_YN = 'Y'
                  AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
                  AND SEGMENT1 = p_user_group
            ),0) > 0
    THEN
        v_group_id := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------
  
    v_start_week := '';
    v_end_week := '';
    v_sql_text := '';

    v_start_week := p_plan_week;
    v_bucket_type := p_bucket_type;

    SELECT C.ISO_YYYYWW
    INTO v_plan_week
    FROM SCM_SYS_CALENDAR_M C  
    WHERE C.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    v_sql_text := '
    SELECT CF.PLAN_WEEK
         , CF.DIVISION_ID	
		 , S.DEPT_ID	 
         , CF.CUSTOMER_CODE   
		 , CF.SCM_SITE_ID      
		 , CF.SUMMARY_BUCKET_TYPE
		 , CF.MEASURE_GROUP
         , CF.MEASURE
         , CF.EDI_FCST_YN
		 , CF.CUSTOMER_PSI
         , CF.UPLOAD_UOM
		 , CF.UPLOAD_BUCKET_TYPE
         , CF.VALID_YN   AS VALID_YN  
		 , CF.LAST_UPDATED_BY
		 , CF.LAST_UPDATE_DATE
		 , CASE WHEN ((FN_GET_DEPT_LIST(''' || p_created_by || ''', S.DEPT_ID) = ''Y'') OR ''' || v_group_id || ''' =''ADMIN'') 
			THEN ''Y'' ELSE '''' END AS EDIT_FLAG
    FROM   DM_MST_CUSTOMER_FCST CF  
	     , SCM_MST_SITE         S   
    WHERE  1 = 1
	AND    CF.DIVISION_ID   = S.DIVISION_ID
	AND    CF.CUSTOMER_CODE = S.END_CUSTOMER
	AND    CF.SCM_SITE_ID   = S.SCM_SITE_ID
	AND    CF.MEASURE_GROUP = ''PSI''
	AND    CF.PLAN_WEEK     = ''' || v_plan_week || ''' 
	--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''' || v_start_yyyymmdd || ''' AND ''' || v_end_yyyymmdd || '''
	' || FN_SCM_GET_WHERE_SQL('CF.DIVISION_ID'        , 'IN', p_division_id ) || '
	' || FN_SCM_GET_WHERE_SQL('S.DEPT_ID'             , 'IN', p_dept_id     ) || '
    ' || FN_SCM_GET_WHERE_SQL('CF.CUSTOMER_CODE'      , 'IN', p_end_customer) || '
	' || FN_SCM_GET_WHERE_SQL('CF.SCM_SITE_ID'        , 'IN', p_scm_site_id ) || '
	' || FN_SCM_GET_WHERE_SQL('CF.SUMMARY_BUCKET_TYPE', 'EQ', p_bucket_type ) || '
	' || FN_SCM_GET_WHERE_SQL('CF.VALID_YN'           , 'EQ', p_valid_yn    ) || '
    ORDER BY CF.DIVISION_ID
	       , S.DEPT_ID
           , CF.CUSTOMER_CODE
           , CF.SCM_SITE_ID
		   , CF.MEASURE_GROUP
		   , CF.MEASURE
  '; 
  
  --EXECUTE IMMEDIATE v_sql_text;

  COMMIT;
  EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        v_err_msg   := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0007_GET_CUST_PSI_DATA failed: ' || v_err_msg);
END DMF0007_GET_CUST_PSI_DATA;
/

-- DMF0007_GET_SPREAD_TITLE → PKG_DMF0007.P_DMF0007_GET_SPREAD_TITLE에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0007_GET_SPREAD_TITLE(
    p_plan_week    IN VARCHAR2,
    p_bucket_type  IN VARCHAR2,
    p_created_by   IN VARCHAR2
)
AS
    v_sql_text       VARCHAR2(4000 CHAR);
    v_iteration      VARCHAR2(4000 CHAR);
    v_start_week     VARCHAR2(8 CHAR);
    v_end_week       VARCHAR2(8 CHAR);
    v_bucket_type    VARCHAR2(10 CHAR);
    v_user_col_cnt   NUMBER(10);
    v_user_time_zone VARCHAR2(10 CHAR);
    v_user_time      VARCHAR2(8 CHAR);
    v_err_msg        VARCHAR2(4000 CHAR);
    v_backtrace      VARCHAR2(4000 CHAR);
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_ITEMLIST'; -- TABLE VARIABLE @ItemList → GTT GT_DMPL_ITEMLIST

    v_start_week := p_plan_week;
    v_bucket_type := p_bucket_type;
    v_user_time_zone := '';

    BEGIN
        SELECT U.TIMEZONE
        INTO v_user_time_zone
        FROM TB_FX_User U
        WHERE U.UserID = p_created_by;
    END;

    IF v_start_week = '' THEN
        IF v_bucket_type = 'DAILY' THEN
            SELECT MIN(C.BASIS_YYYYMMDD)
            INTO v_start_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMMDD');
        ELSIF v_bucket_type = 'WEEKLY' THEN
            SELECT C.ISO_YYYYWW
            INTO v_start_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMMDD');
        ELSIF v_bucket_type = 'MONTHLY' THEN
            SELECT C.BASIS_YYYYMM
            INTO v_start_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMM = TO_CHAR(FN_MULTY_TIME(v_user_time_zone), 'YYYYMM');
        END IF;
    ELSE
        v_start_week := p_plan_week;
    END IF;

    BEGIN
        IF v_bucket_type = 'DAILY' THEN
            SELECT C.BASIS_YYYYMMDD
            INTO v_end_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(v_user_time_zone), 12), 'YYYYMMDD');
        ELSIF v_bucket_type = 'WEEKLY' THEN
            SELECT ISO_YYYYWW
            INTO v_end_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMMDD = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(v_user_time_zone), 30), 'YYYYMMDD');
        ELSIF v_bucket_type = 'MONTHLY' THEN
            SELECT BASIS_YYYYMM
            INTO v_end_week
            FROM SCM_SYS_CALENDAR_M C
            WHERE C.BASIS_YYYYMM = TO_CHAR(ADD_MONTHS(FN_MULTY_TIME(v_user_time_zone), 30), 'YYYYMM');
        END IF;
    END;

    -- Commented out original usage of @v_program_name
    -- @v_program_name := $$PLSQL_UNIT;

    IF v_bucket_type = 'DAILY' THEN
        v_iteration := '
            SELECT ''D_'' || A.BASIS_YYYYMMDD  AS COLUMN_NAME
                 , A.DAYOFWEEK                       AS SMALL_CLASS_LABEL_NAME  
                 , A.BASIS_YYYYMMDD             AS BASIS_YYYYMMDD
            FROM   SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.BASIS_YYYYMMDD >=  :v_start_week
            AND    A.BASIS_YYYYMMDD <= :v_end_week     
            ';
    ELSIF v_bucket_type = 'WEEKLY' THEN
        v_iteration := '
            SELECT ''D_'' || MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
                 , A.ISO_YYYYWW                       AS SMALL_CLASS_LABEL_NAME  
                 , MIN(A.BASIS_YYYYMMDD)             AS BASIS_YYYYMMDD
            FROM   SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.ISO_YYYYWW >=  :v_start_week 
            AND    A.ISO_YYYYWW <= :v_end_week 
            GROUP BY A.ISO_YYYYWW
            ';
    ELSIF v_bucket_type = 'MONTHLY' THEN
        v_iteration := '
            SELECT ''D_'' || MIN(A.BASIS_YYYYMMDD)  AS COLUMN_NAME
                 , A.MONTH_NAME                    AS SMALL_CLASS_LABEL_NAME  
                 , MIN(A.BASIS_YYYYMMDD)           AS BASIS_YYYYMMDD
            FROM   SCM_SYS_CALENDAR_M A 
            WHERE  1 = 1
            AND    A.BASIS_YYYYMM >= :v_start_week 
            AND    A.BASIS_YYYYMM <= :v_end_week 
            GROUP BY A.MONTH_NAME
            ';
    END IF;

    IF v_user_col_cnt > 0 THEN
        -- User Title 이 존재
        v_sql_text := '
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE				 
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.VALID_YN
                 , C.DEFAULT_FLAG
            FROM   SCM_MST_SHEET_COLUMNS C 
            WHERE  1 = 1            
            AND    C.PROGRAM_ID = ''DMF0007''
            AND    C.SHEET_NAME = ''Customer FCST''
            AND    C.VALID_YN   = ''Y''

            UNION ALL

            SELECT ''DMF0007''         AS PROGRAM_ID
                 , ''Customer FCST''  AS SHEET_NAME
                 , T.COLUMN_NAME
                 , C.DATE_SHORT1_NAME AS COLUMN_LABEL_NAME
                 , T.BASIS_YYYYMMDD   AS SORT_ORDER_NO
                 , ''''               AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , ''''               AS LARGE_CLASS_LABEL_NAME
                 , ''''               AS FIXED_FLAG
                 , 50                 AS COLUMN_WIDTH
                 , ''FPComboBox''     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''YesOrNo''        AS CELL_COMBO_DATA_TYPE
                 , ''''               AS DATA_SCALE_NUMBER
                 , ''''               AS DATA_MAX_LENGTH
                 , ''C''              AS HORIZONTAL_ALIGN_CODE
                 , ''Y''              AS UPPERCASE_APPLY_FLAG
                 , ''Y''              AS VISIBLE_FLAG
                 , ''Y''              AS VALID_YN
                 , ''''               AS DEFAULT_FLAG
            FROM   (		 
                    ' || v_iteration || '
                   ) T
                 , SCM_SYS_CALENDAR_M C 
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
        ';
    ELSE
        -- User Title 이 존재
        v_sql_text := '
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE				 
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , C.DATA_SCALE_NUMBER
                 , C.DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.VALID_YN
                 , C.DEFAULT_FLAG
            FROM   SCM_MST_SHEET_COLUMNS C 
            WHERE  1 = 1
            AND    C.PROGRAM_ID = ''DMF0007''
            AND    C.SHEET_NAME = ''Customer FCST''
            AND    C.VALID_YN   = ''Y''
            		
            UNION ALL

            SELECT ''DMF0007''         AS PROGRAM_ID
                 , ''Customer FCST''  AS SHEET_NAME
                 , T.COLUMN_NAME
                 , C.DATE_SHORT1_NAME AS COLUMN_LABEL_NAME
                 , T.BASIS_YYYYMMDD   AS SORT_ORDER_NO
                 , ''''               AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , ''''               AS LARGE_CLASS_LABEL_NAME
                 , ''''               AS FIXED_FLAG
                 , 50                 AS COLUMN_WIDTH
                 , ''FPComboBox''     AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''YesOrNo''        AS CELL_COMBO_DATA_TYPE
                 , ''''               AS DATA_SCALE_NUMBER
                 , ''''               AS DATA_MAX_LENGTH
                 , ''C''              AS HORIZONTAL_ALIGN_CODE
                 , ''Y''              AS UPPERCASE_APPLY_FLAG
                 , ''Y''              AS VISIBLE_FLAG
                 , ''Y''              AS VALID_YN
                 , ''''               AS DEFAULT_FLAG
            FROM   (		 
                    ' || v_iteration || '
                   ) T
                 , SCM_SYS_CALENDAR_M C  
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
        ';
    END IF;

    v_sql_text := REPLACE(v_sql_text, ':v_start_week', v_start_week);
    v_sql_text := REPLACE(v_sql_text, ':v_end_week', v_end_week);
    v_sql_text := REPLACE(v_sql_text, ':p_created_by', p_created_by);

    EXECUTE IMMEDIATE v_sql_text;

    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
EXCEPTION
    WHEN OTHERS THEN
        v_err_msg := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0007_GET_SPREAD_TITLE failed: ' || v_err_msg);
END DMF0007_GET_SPREAD_TITLE;
/

-- DMF0007_SAVE_CUST_FCST_DATA → PKG_DMF0007.P_DMF0007_SAVE_CUST_FCST_DATA에 등록됨
CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0007_SAVE_CUST_FCST_DATA(
    p_active_flag            IN VARCHAR2,
    p_division_id            IN VARCHAR2,
    p_plan_week              IN VARCHAR2,
    p_customer_code          IN VARCHAR2,
    p_scm_site_id            IN VARCHAR2,
    p_measure_group          IN VARCHAR2,
    p_measure                IN VARCHAR2,
    p_valid_yn               IN VARCHAR2,
    p_customer_psi           IN VARCHAR2,
    p_upload_uom             IN VARCHAR2,
    p_upload_bucket_type     IN VARCHAR2,
    p_summary_bucket_type    IN VARCHAR2,
    p_summary_bucket_value   IN VARCHAR2,
    p_summary_bucket_yn      IN NUMBER,
    p_edi_fcst_yn            IN VARCHAR2,
    p_created_by             IN VARCHAR2
)
AS
    v_recv_active_flag       VARCHAR2(4000 CHAR) := NULL;
    v_active_flag            VARCHAR2(4000 CHAR) := NULL;
    v_division_id            VARCHAR2(4000 CHAR) := NULL;
    v_plan_week              VARCHAR2(4000 CHAR) := NULL;
    v_customer_code          VARCHAR2(4000 CHAR) := NULL;
    v_scm_site_id            VARCHAR2(4000 CHAR) := NULL;
    v_measure_group          VARCHAR2(4000 CHAR) := NULL;
    v_measure                VARCHAR2(4000 CHAR) := NULL;
    v_valid_yn               VARCHAR2(4000 CHAR) := NULL;
    v_customer_psi           VARCHAR2(4000 CHAR) := NULL;
    v_upload_uom             VARCHAR2(4000 CHAR) := NULL;
    v_upload_bucket_type     VARCHAR2(4000 CHAR) := NULL;
    v_summary_bucket_type    VARCHAR2(4000 CHAR) := NULL;
    v_summary_bucket_value   VARCHAR2(4000 CHAR) := NULL;
    v_summary_bucket_yn      NUMBER := 0;
    v_edi_fcst_yn            VARCHAR2(4000 CHAR) := NULL;
    v_created_by             VARCHAR2(4000 CHAR) := NULL;
    v_dup_flag               NUMBER := 0;
    n_existence_flag         NUMBER := 0;
    n_existence_value        VARCHAR2(4000 CHAR) := NULL;
    v_delimiter              VARCHAR2(1 CHAR) := '^';
    max_loop_cnt             NUMBER := 0;
    mst_loop_cnt             NUMBER := 0;
    v_log_type               VARCHAR2(30 CHAR);
    n_log_count              NUMBER := 0;
    v_log_message            VARCHAR2(1000 CHAR);
    v_description            VARCHAR2(500 CHAR);
    d_event_date             TIMESTAMP;
    SUMMARY_FLAG             NUMBER := 0;
    v_err_msg                VARCHAR2(4000 CHAR);
    v_backtrace              VARCHAR2(4000 CHAR);
BEGIN
    EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_RESULTS'; -- TABLE VARIABLE @RESULTS → GTT GT_DMPL_RESULTS
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMPL_FCST_MEASURE'; -- TABLE VARIABLE @FCST_MEASURE → GTT GT_DMPL_FCST_MEASURE

    -- 시작 LOG
    v_log_type := 'START';
    v_log_message := '########## Start of procedure ##########';
    v_description := '';
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

    -- 프로시저 LOOP 길이를 판단
    max_loop_cnt := SCM_ARR_SPL_CNT(p_active_flag, v_delimiter);

    -- WHILE loop START
    WHILE LENGTH(v_recv_active_flag) > 0 AND mst_loop_cnt < max_loop_cnt
    -- WHILE loop START
    LOOP
        -- @mst_loop_cnt 1증가
        mst_loop_cnt := mst_loop_cnt + 1;

        -- 각 컬럼들에 대한 split (start)
        v_active_flag := SCM_ARR_SPL_VAL(p_active_flag, v_delimiter, mst_loop_cnt);
        v_division_id := SCM_ARR_SPL_VAL(p_division_id, v_delimiter, mst_loop_cnt);
        v_plan_week := SCM_ARR_SPL_VAL(p_plan_week, v_delimiter, mst_loop_cnt);
        IF v_active_flag = 'I' THEN
            v_plan_week := (SELECT a.ISO_YYYYWW
                            FROM SCM_SYS_CALENDAR_M a
                            WHERE a.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD'));
        END IF;
        v_customer_code := SCM_ARR_SPL_VAL(p_customer_code, v_delimiter, mst_loop_cnt);
        v_scm_site_id := SCM_ARR_SPL_VAL(p_scm_site_id, v_delimiter, mst_loop_cnt);
        v_measure_group := SCM_ARR_SPL_VAL(p_measure_group, v_delimiter, mst_loop_cnt);
        v_measure := SCM_ARR_SPL_VAL(p_measure, v_delimiter, mst_loop_cnt);

        -- 20191210 KHSONG EDI예약어 MEASURE 등록시 '*' 추가
        v_measure := CASE
                        WHEN v_measure = 'Immidiate' THEN 'Immidiate*'
                        WHEN v_measure = 'Planning_Forecast' THEN 'Planning_Forecast*'
                        WHEN v_measure = 'Commercial_Agreement' THEN 'Commercial_Agreement*'
                        ELSE v_measure
                     END;
        v_valid_yn := SCM_ARR_SPL_VAL(p_valid_yn, v_delimiter, mst_loop_cnt);
        v_customer_psi := SCM_ARR_SPL_VAL(p_customer_psi, v_delimiter, mst_loop_cnt);
        v_upload_uom := SCM_ARR_SPL_VAL(p_upload_uom, v_delimiter, mst_loop_cnt);
        v_upload_bucket_type := SCM_ARR_SPL_VAL(p_upload_bucket_type, v_delimiter, mst_loop_cnt);
        v_summary_bucket_type := SCM_ARR_SPL_VAL(p_summary_bucket_type, v_delimiter, mst_loop_cnt);
        v_summary_bucket_value := SCM_ARR_SPL_VAL(p_summary_bucket_value, v_delimiter, mst_loop_cnt);
        v_edi_fcst_yn := SCM_ARR_SPL_VAL(p_edi_fcst_yn, v_delimiter, mst_loop_cnt);
        v_summary_bucket_yn := SCM_ARR_SPL_VAL(p_summary_bucket_yn, v_delimiter, mst_loop_cnt);
        v_created_by := SCM_ARR_SPL_VAL(p_created_by, v_delimiter, mst_loop_cnt);
        -- 각 컬럼들에 대한 split (end)

        -- input data를 temp table 에 저장하여 비교값으로 사용 songkh modify (start)
        INSERT /*+ APPEND PARALLEL(GT_DMPL_RESULTS, 4) */ INTO GT_DMPL_RESULTS (n_division_id, n_plan_week, n_customer_code, n_scm_site_id, n_summary_bucket_value, n_measure_group, n_measure, n_customer_psi, n_valid_yn)
        VALUES (v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_summary_bucket_value, v_measure_group, v_measure, v_customer_psi, v_summary_bucket_yn);

        v_dup_flag := 0;

        IF v_summary_bucket_yn = 0 THEN --@v_valid_yn = '' / @v_summary_bucket_yn
            v_dup_flag := (SELECT COUNT(*)
                           FROM DM_MST_CUSTOMER_FCST
                           WHERE DIVISION_ID = v_division_id
                             AND PLAN_WEEK = v_plan_week
                             AND SCM_SITE_ID = v_scm_site_id
                             AND SUMMARY_BUCKET_VALUE = v_summary_bucket_value
                             AND MEASURE_GROUP = v_measure_group
                             AND valid_yn = 'Y'
                             AND customer_psi = v_customer_psi
                             AND measure <> v_measure);

            v_dup_flag := v_dup_flag + (SELECT COUNT(*)
                                        FROM GT_DMPL_RESULTS
                                        WHERE n_DIVISION_ID = v_division_id
                                          AND n_PLAN_WEEK = v_plan_week
                                          AND n_SCM_SITE_ID = v_scm_site_id
                                          AND n_SUMMARY_BUCKET_VALUE = v_summary_bucket_value
                                          AND n_valid_yn = 'Y'
                                          AND n_MEASURE_GROUP = v_measure_group
                                          AND n_customer_psi = v_customer_psi
                                          AND n_measure <> v_measure);
        END IF;

        -- 하나의 SCM_SITE_ID 당 하나의 SUMMARY BUCKET TYPE 존재 여부 체크
        SUMMARY_FLAG := 0;

        SELECT COUNT(*)
        INTO SUMMARY_FLAG
        FROM (
            SELECT DIVISION_ID, SCM_SITE_ID, COUNT(SUMMARY_BUCKET_TYPE) AS COUNT_BUCKET
            FROM (
                SELECT DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
                FROM (
                    SELECT division_id, plan_week, customer_code, scm_site_id, measure_group, measure, valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type, summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date
                    FROM DM_MST_CUSTOMER_FCST
                    UNION ALL
                    SELECT v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_measure_group, v_measure, v_summary_bucket_yn, v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, v_summary_bucket_value, v_edi_fcst_yn, v_created_by, v_created_by, SYSTIMESTAMP, v_created_by, SYSTIMESTAMP
                ) T1
                WHERE VALID_YN = 'Y'
                  AND SCM_SITE_ID = v_scm_site_id
                  AND DIVISION_ID = v_division_id
                  AND MEASURE_GROUP = v_measure_group
                GROUP BY DIVISION_ID, SCM_SITE_ID, SUMMARY_BUCKET_TYPE
            ) T1
            GROUP BY DIVISION_ID, SCM_SITE_ID
            HAVING COUNT(SUMMARY_BUCKET_TYPE) > 1
        ) T1;

        IF SUMMARY_FLAG > 0 THEN
            v_log_type := 'INVALID';
            GOTO ERR_RTN;
        END IF;

        -- input data를 temp table 에 저장하여 비교값으로 사용 songkh modify (end)

        -- 데이터 기준값 DAY:20000101 , WEEK : 20000102, MONTH: 20000103 설정하여 MASTER 값으로 사용함
        n_existence_flag := 0;
        n_existence_value := NULL;

        n_existence_value := CASE
                                WHEN v_summary_bucket_type = 'DAILY' THEN '20000101'
                                WHEN v_summary_bucket_type = 'WEEKLY' THEN '20000102'
                                WHEN v_summary_bucket_type = 'MONTHLY' THEN '20000103'
                             END;

        -- summary_bucket_type 기준으로 이미 존재하는 데이터를 확인함
        SELECT NVL(COUNT(1), 0)
        INTO n_existence_flag
        FROM DM_MST_CUSTOMER_FCST
        WHERE division_id = v_division_id
          AND plan_week = v_plan_week
          AND customer_code = v_customer_code
          AND scm_site_id = v_scm_site_id
          AND summary_bucket_value = n_existence_value
          AND measure_group = v_measure_group
          AND customer_psi = v_customer_psi
          AND summary_bucket_type = v_summary_bucket_type
          AND MEASURE = v_measure;

        -- MASTER 값 INSERT
        IF n_existence_flag = 0 THEN
            INSERT /*+ APPEND PARALLEL(DM_MST_CUSTOMER_FCST, 4) */ INTO DM_MST_CUSTOMER_FCST (division_id, plan_week, customer_code, scm_site_id, measure_group, measure, valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type, summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date)
            VALUES (v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_measure_group, v_measure, '', v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, n_existence_value, v_edi_fcst_yn, v_created_by, v_created_by, SYSTIMESTAMP, v_created_by, SYSTIMESTAMP);
        END IF;

        IF v_dup_flag = 0 THEN
            -- INPUT 데이터 INSERT전 DELETE처리
            DELETE FROM DM_MST_CUSTOMER_FCST
            WHERE division_id = v_division_id
              AND plan_week = v_plan_week
              AND customer_code = v_customer_code
              AND scm_site_id = v_scm_site_id
              AND summary_bucket_value = v_summary_bucket_value
              AND measure_group = v_measure_group
              AND customer_psi = v_customer_psi;

            -- INPUT 데이터 INSERT
            INSERT /*+ APPEND PARALLEL(DM_MST_CUSTOMER_FCST, 4) */ INTO DM_MST_CUSTOMER_FCST (division_id, plan_week, customer_code, scm_site_id, measure_group, measure, valid_yn, customer_psi, upload_uom, upload_bucket_type, summary_bucket_type, summary_bucket_value, edi_fcst_yn, upload_user_id, created_by, creation_date, last_updated_by, last_update_date)
            VALUES (v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_measure_group, v_measure, v_summary_bucket_yn, v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, v_summary_bucket_value, v_edi_fcst_yn, v_created_by, v_created_by, SYSTIMESTAMP, v_created_by, SYSTIMESTAMP);

            -- history insert
            PR_DM_MST_CUSTOMER_FCST_HIST(v_division_id, v_plan_week, v_customer_code, v_scm_site_id, v_summary_bucket_value, v_measure_group, v_measure, v_summary_bucket_yn, v_customer_psi, v_upload_uom, v_upload_bucket_type, v_summary_bucket_type, v_edi_fcst_yn, v_created_by, v_created_by, v_created_by);
        END IF;
    END LOOP;

    -- WHILE loop END

    -- @results
    INSERT INTO GT_DMPL_TMP_SITE_CUSTOMER_MAP (DIVISION_ID, SCM_SITE_ID, MEASURE, start_day, end_day)
    SELECT a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE,
           a.SUMMARY_BUCKET_VALUE AS start_day,
           CASE WHEN summary_bucket_type = 'WEEKLY' THEN TO_CHAR(NEXT_DAY(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 'SUN'), 'YYYYMMDD')
                ELSE a.SUMMARY_BUCKET_VALUE
           END AS end_day
    FROM DM_MST_CUSTOMER_FCST a
    INNER JOIN (SELECT DISTINCT n_division_id, n_scm_site_id FROM GT_DMPL_RESULTS) rslt
    ON a.DIVISION_ID = rslt.n_division_id
       AND a.SCM_SITE_ID = rslt.n_scm_site_id
    WHERE VALID_YN = 'Y'
      AND a.MEASURE_GROUP = 'CUST_FCST'
      AND a.PLAN_WEEK = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST)
      AND a.SUMMARY_BUCKET_VALUE >= TO_CHAR(NEXT_DAY(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
      AND summary_bucket_type IN ('DAILY', 'WEEKLY')

    UNION

    SELECT a.DIVISION_ID, a.SCM_SITE_ID, a.MEASURE,
           CASE WHEN SUMMARY_BUCKET_VALUE = TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD') - DATEPART('DD', SYSDATE) + 1, 'YYYYMMDD') THEN TO_CHAR(NEXT_DAY(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD')
                ELSE SUMMARY_BUCKET_VALUE
           END AS start_day,
           TO_CHAR(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD') - DATEPART('DD', TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD')) + 1 + LAST_DAY(TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD')) - TO_DATE(SUMMARY_BUCKET_VALUE, 'YYYYMMDD'), 'YYYYMMDD') AS end_day
    FROM DM_MST_CUSTOMER_FCST a
    INNER JOIN (SELECT DISTINCT n_division_id, n_scm_site_id FROM GT_DMPL_RESULTS) rslt
    ON a.DIVISION_ID = rslt.n_division_id
       AND a.SCM_SITE_ID = rslt.n_scm_site_id
    WHERE VALID_YN = 'Y'
      AND a.MEASURE_GROUP = 'CUST_FCST'
      AND a.PLAN_WEEK = (SELECT MAX(PLAN_WEEK) FROM DM_MST_CUSTOMER_FCST)
      AND a.SUMMARY_BUCKET_VALUE >= TO_CHAR(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD') - DATEPART('DD', SYSDATE) + 1, 'YYYYMMDD')
      AND summary_bucket_type IN ('MONTHLY');

    -- 현재 고치는 CUSTOMER FCST MASTER의 MEASURE로 입력 MARKETING FCST 값이 있는지 VALIDATION
    INSERT INTO GT_DMPL_DELETE_TARGET (DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID)
    SELECT T1.DIVISION_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID, T1.DOM_EXP, T1.FCST_TYPE, T1.INCOTERMS, T1.PLANT_SITE_ID
    FROM (
        SELECT T1.DIVISION_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID, T1.DOM_EXP, T1.FCST_TYPE, T1.INCOTERMS, T1.MEASURE, T1.PLANT_SITE_ID
        FROM DM_PLN_MKT_FCST T1
        INNER JOIN DM_MST_CUSTOMER_FCST T2
        ON T1.DIVISION_ID = T2.DIVISION_ID
           AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
           AND (T1.MEASURE = T2.MEASURE OR T1.MEASURE = 'CUST_FCST')
        GROUP BY T1.DIVISION_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID, T1.DOM_EXP, T1.FCST_TYPE, T1.INCOTERMS, T1.MEASURE, T1.PLANT_SITE_ID
    ) T1
    INNER JOIN (SELECT DISTINCT N_DIVISION_ID, N_SCM_SITE_ID FROM GT_DMPL_RESULTS) T2
    ON T1.DIVISION_ID = T2.N_DIVISION_ID
       AND T1.SCM_SITE_ID = T2.N_SCM_SITE_ID
    GROUP BY T1.DIVISION_ID, T1.SCM_SITE_ID, T1.PROJECT_CODE, T1.ITEM_ID, T1.DOM_EXP, T1.FCST_TYPE, T1.INCOTERMS, T1.PLANT_SITE_ID
    HAVING COUNT(MEASURE) > 1;

    DELETE T1
    FROM DM_PLN_MKT_FCST T1
    INNER JOIN GT_DMPL_DELETE_TARGET T2
    ON T1.DIVISION_ID = T2.DIVISION_ID
       AND T1.SCM_SITE_ID = T2.SCM_SITE_ID
       AND T1.PROJECT_CODE = T2.PROJECT_CODE
       AND T1.ITEM_ID = T2.ITEM_ID
       AND T1.DOM_EXP = T2.DOM_EXP
       AND T1.FCST_TYPE = T2.FCST_TYPE
       AND T1.INCOTERMS = T2.INCOTERMS
       AND T1.PLANT_SITE_ID = T2.PLANT_SITE_ID
    WHERE T1.MEASURE = 'CUST_FCST';

    INSERT INTO DM_PLN_MKT_FCST (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10)
    SELECT a.DIVISION_ID, a.PROJECT_CODE, a.SCM_SITE_ID, a.ITEM_ID, a.DOM_EXP, a.FCST_TYPE, a.INCOTERMS, 'CUST_FCST', a.PLANT_SITE_ID, a.YYYYMMDD, a.QTY, a.CREATED_BY, a.CREATION_DATE, a.LAST_UPDATED_BY, a.LAST_UPDATE_DATE, a.ATTRIBUTE1, a.ATTRIBUTE2, a.ATTRIBUTE3, a.ATTRIBUTE4, a.ATTRIBUTE5, a.ATTRIBUTE6, a.ATTRIBUTE7, a.ATTRIBUTE8, a.ATTRIBUTE9, a.ATTRIBUTE10
    FROM DM_PLN_MKT_FCST a
    INNER JOIN (SELECT DISTINCT n_division_id, n_scm_site_id FROM GT_DMPL_RESULTS) rslt
    ON a.DIVISION_ID = rslt.n_division_id
       AND a.SCM_SITE_ID = rslt.n_scm_site_id
    INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, MEASURE, start_day, end_day FROM GT_DMPL_TMP_SITE_CUSTOMER_MAP GROUP BY DIVISION_ID, SCM_SITE_ID, MEASURE, start_day, end_day) map
    ON a.DIVISION_ID = map.DIVISION_ID
       AND a.SCM_SITE_ID = map.SCM_SITE_ID
       AND a.MEASURE = map.MEASURE
    WHERE a.YYYYMMDD BETWEEN map.start_day AND map.end_day
      AND a.YYYYMMDD >= TO_CHAR(NEXT_DAY(TO_DATE(TO_CHAR(SYSDATE, 'YYYYMMDD'), 'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD');

    COMMIT;
    EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

EXCEPTION
    WHEN OTHERS THEN
        v_err_msg := SQLERRM;
        v_backtrace := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, 'DMF0007_SAVE_CUST_FCST_DATA failed: ' || v_err_msg);
END DMF0007_SAVE_CUST_FCST_DATA;

ERR_RTN:
    ROLLBACK;
    v_log_message := '########## END of procedure ##########';
    v_description := '';
    d_event_date := SYSTIMESTAMP;
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
    PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', n_log_count, v_log_message, v_description, d_event_date);
/
