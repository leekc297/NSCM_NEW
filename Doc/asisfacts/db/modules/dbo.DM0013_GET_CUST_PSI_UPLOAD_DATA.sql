/*
 * Program ID  : DM0013_GET_CUST_PSI_UPLOAD_DATA                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/22   SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/05/30  JYE			복수 팀 권한 관련  수정  
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
*/
CREATE PROCEDURE [dbo].[DM0013_GET_CUST_PSI_UPLOAD_DATA]  
  @p_division_id     NVARCHAR(MAX),
  @p_dept_id         NVARCHAR(MAX),
  @p_end_customer    NVARCHAR(MAX),
  @p_scm_site_id     NVARCHAR(MAX),
  @p_plant_site_id   NVARCHAR(MAX),
  @p_project_code    NVARCHAR(MAX),
  @p_item_id         NVARCHAR(MAX),
  @p_start_yyyymmdd  NVARCHAR(8),
  @p_end_yyyymmdd    NVARCHAR(8),
  @p_bucket_type     NVARCHAR(10),
  @p_dom_exp         NVARCHAR(10),
  @p_created_by		 NVARCHAR(50),   --, @p_debug NVARCHAR(MAX) OUTPUT
  @p_userinfo		NVARCHAR(MAX)
AS  
  
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_sql_text       AS NVARCHAR(MAX);
    DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_column_text    AS NVARCHAR(200);
    DECLARE @v_column_name    AS NVARCHAR(50);  
    DECLARE @v_yyyymmdd       AS NVARCHAR(8);  
	DECLARE @v_start_yyyymmdd AS NVARCHAR(8);  

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT @v_start_yyyymmdd = A.BASIS_START_DATE
    FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD = @p_start_yyyymmdd;

	SELECT @v_iteration = '';

	IF @p_bucket_type = 'DAILY'		   
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
	    SELECT 'D_' + BASIS_YYYYMMDD  AS COLUMN_NAME
              , BASIS_YYYYMMDD        AS YYYYMMDD
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)        
        ORDER BY COLUMN_NAME ;
		
		OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN CP.YYYYMMDD = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;

		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
    END;
	ELSE IF @p_bucket_type = 'WEEKLY'
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
		SELECT 'D_' + MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
             , A.ISO_YYYYWW --MIN(RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, A.BASIS_START_DATE), 23), 2))  AS YYYYMMDD    
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.ISO_YYYYWW, A.WEEK_NAME
        ORDER BY COLUMN_NAME ;

	    OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN SUBSTRING(CP.YYYYMMDD, 1, 4) + RIGHT(''00'' + CONVERT(VARCHAR, DATEPART(WEEK, CP.YYYYMMDD), 23), 2) = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;

		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
	END;
	ELSE IF @p_bucket_type = 'MONTHLY'
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
		SELECT 'D_' + MIN(A.BASIS_YYYYMM) + '01' AS COLUMN_NAME
             , MIN(A.BASIS_YYYYMM)               AS YYYYMMDD  
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.MONTH_NAME 
	    ORDER BY COLUMN_NAME;

		OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN SUBSTRING(CP.YYYYMMDD, 1, 6) = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;
		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
	END;
		  
    --SELECT @v_iteration AS xxxx;
  
    SET @v_sql_text = '
	SELECT MA.*
		, CASE WHEN (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'') 
			THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	FROM (
        SELECT CP.DIVISION_ID
			 , S.DEPT_ID
		     , CP.SCM_SITE_ID
			 , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS             
             , CP.FCST_TYPE
			 , CP.DOM_EXP
			 , CP.MEASURE_GROUP
             , CP.MEASURE
			 , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
             [@v_iteration]
        FROM   [dbo].[DM_PLN_CUSTOMER_PSI] CP WITH(NOLOCK)
		     , [dbo].[SCM_MST_SITE]        S  WITH(NOLOCK)
        WHERE  1 = 1
		AND    CP.DIVISION_ID   = S.DIVISION_ID
		AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        AND    CP.MEASURE_GROUP = ''PSI'' 
        [@p_division_id]  
		[@p_dept_id]     
        [@p_scm_site_id]
		[@p_plant_site_id]
		[@p_project_code]
        [@p_item_id]
	    [@p_dom_exp]	
		[@p_end_customer]	
		AND    CP.YYYYMMDD BETWEEN ''[@p_start_yyyymmdd]'' AND ''[@p_end_yyyymmdd]''
		AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
		                      FROM   [dbo].[DM_MST_CUSTOMER_FCST] X WITH(NOLOCK)
							  WHERE  1 = 1
							  AND    X.DIVISION_ID = CP.DIVISION_ID                                     
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID -- 해당 SITE에 연결된 Measure만 구함.
                              AND    X.UPLOAD_BUCKET_TYPE = ''[@p_bucket_type]''	
							  AND    X.VALID_YN    = ''Y''
							)		
		GROUP BY CP.DIVISION_ID
			   , S.DEPT_ID
		       , CP.SCM_SITE_ID
			   , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS             
               , CP.FCST_TYPE
			   , CP.DOM_EXP
			   , CP.MEASURE_GROUP
               , CP.MEASURE
			   , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID
        
	) MA 
	ORDER BY DIVISION_ID
				, SCM_SITE_ID
				, PLANT_SITE_ID
				, CUSTOMER_PROJECT_CODE
				, CUSTOMER_MODEL
  '; 
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'     , @v_iteration     );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.DIVISION_ID'   , 'IN', @p_division_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dept_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DEPT_ID'        , 'IN', @p_dept_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_customer]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.END_CUSTOMER'   , 'IN', @p_end_customer));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_scm_site_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.SCM_SITE_ID'   , 'IN', @p_scm_site_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_plant_site_id]' , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.PLANT_SITE_ID' , 'IN', @p_plant_site_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_project_code]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.PROJECT_CODE'  , 'IN', @p_project_code));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_item_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.ITEM_ID'       , 'IN', @p_item_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dom_exp]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.DOM_EXP'       , 'IN', @p_dom_exp));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_start_yyyymmdd]', @v_start_yyyymmdd);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_yyyymmdd]'  , @p_end_yyyymmdd  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_bucket_type]'   , @p_bucket_type   );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'    , @p_created_by    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'    , @v_group_id    );

  --SET @p_debug = @v_sql_text;
  --RETURN @p_debug;
  --SELECT @v_sql_text;

  --EXEC(@v_sql_text);
  EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;
								  
END

