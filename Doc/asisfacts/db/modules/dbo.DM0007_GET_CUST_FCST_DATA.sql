
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID  : DM0007_GET_CUST_FCST_DATA                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/10/25  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/05/30  JYE			복수 팀 권한 관련  수정  
 ** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
*/
CREATE PROCEDURE [dbo].[DM0007_GET_CUST_FCST_DATA]
    @p_plan_week     NVARCHAR(6),
    @p_division_id   NVARCHAR(50),
    @p_dept_id       NVARCHAR(100),
    @p_end_customer  NVARCHAR(100),
    @p_scm_site_id   NVARCHAR(100),
    @p_bucket_type   NVARCHAR(100),
    @p_valid_yn      NVARCHAR(3),
    @p_created_by	   NVARCHAR(50), --, @p_debug         NVARCHAR(MAX) OUTPUT
	@p_user_group		NVARCHAR(100)
AS  
  
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_sql_text       AS NVARCHAR(MAX);
    DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_column_text    AS NVARCHAR(200);
    --DECLARE @v_iteration      AS NVARCHAR(4000);
    DECLARE @v_column_name    AS NVARCHAR(20);
    DECLARE @v_weekstart_date AS NVARCHAR(8);
    DECLARE @p_param_list     AS NVARCHAR(4000);
	DECLARE @v_plan_week      AS NVARCHAR(6);  
    DECLARE @v_start_week     AS NVARCHAR(8);  
    DECLARE @v_end_week       AS NVARCHAR(8);
    DECLARE @v_start_yyyymmdd AS NVARCHAR(8);  
    DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);
    DECLARE @v_bucket_type    AS NVARCHAR(10);

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------
  
    SET @v_start_week = '';
    SET @v_end_week = '';

    SET @v_start_week = @p_plan_week;
    SET @v_bucket_type = @p_bucket_type;

	SELECT @v_plan_week = C.ISO_YYYYWW
    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);
  
   IF @v_start_week = ''
	    BEGIN
		IF @v_bucket_type = 'DAILY'            
			SELECT @v_start_week      = MIN(C.BASIS_YYYYMMDD) 
			     , @v_start_yyyymmdd  = MIN(C.BASIS_YYYYMMDD) 
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                 , (SELECT C.ISO_YYYYWW
                    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
	               ) T
            WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
        ELSE IF @v_bucket_type = 'WEEKLY'
		    SELECT @v_start_week     = MIN(C.ISO_YYYYWW)
			     , @v_start_yyyymmdd = MIN(C.BASIS_YYYYMMDD)
			FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                 , (SELECT C.ISO_YYYYWW      AS ISO_YYYYWW
					FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
					WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
				   ) T
            WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
		ELSE IF @v_bucket_type = 'MONTHLY'
		    SELECT @v_start_week     = T.BASIS_YYYYMM
			     , @v_start_yyyymmdd = T.BASIS_YYYYMMDD
			FROM   (	
					SELECT MIN(C.BASIS_YYYYMM)    AS BASIS_YYYYMM
						 , MIN(C.BASIS_YYYYMMDD)  AS BASIS_YYYYMMDD
					FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
					WHERE  C.BASIS_YYYYMM = CONVERT(CHAR(6), CURRENT_TIMESTAMP, 112)
				   ) T
			;
		END;
    ELSE
        SET @v_start_week = @p_plan_week;  
    
	
	BEGIN
		IF @v_bucket_type = 'DAILY'
            SELECT @v_end_week     = C.BASIS_YYYYMMDD
			     , @v_end_yyyymmdd = C.BASIS_YYYYMMDD
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
            WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MM, 12, CURRENT_TIMESTAMP), 112)
        ELSE IF @v_bucket_type = 'WEEKLY'
		    SELECT @v_end_week   = T.ISO_YYYYWW
			     , @v_end_yyyymmdd = T.BASIS_YYYYMMDD
			FROM   (
					SELECT MAX(ISO_YYYYWW)       AS ISO_YYYYWW
						 , MAX(C.BASIS_YYYYMMDD) AS BASIS_YYYYMMDD
					FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
					WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MM, 30, CURRENT_TIMESTAMP), 112)
				  ) T
		ELSE IF @v_bucket_type = 'MONTHLY'
		    SELECT @v_end_week     = T.BASIS_YYYYMM
			     , @v_end_yyyymmdd = T.BASIS_YYYYMMDD
			FROM  (SELECT MAX(BASIS_YYYYMM)      AS BASIS_YYYYMM
			            , MAX(C.BASIS_YYYYMMDD)  AS BASIS_YYYYMMDD
                   FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
                   WHERE  C.BASIS_YYYYMM = CONVERT(CHAR(6), DATEADD(MM, 30, CURRENT_TIMESTAMP), 112)
				  ) T
	END;

	--SELECT @v_bucket_type, @v_start_week, @v_end_week;

	SET @v_iteration = '';

	IF @v_bucket_type = 'DAILY'
	    BEGIN
	    DECLARE c_bucket CURSOR FAST_FORWARD FOR
            SELECT 'D_' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
		         , A.BASIS_YYYYMMDD         AS BASIS_YYYYMMDD
		    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		    WHERE  1 = 1
		    AND    A.BASIS_YYYYMMDD >=  @v_start_week
		    AND    A.BASIS_YYYYMMDD <= @v_end_week     
	        ;
	
	    --SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''20000101'' THEN CF.VALID_YN ELSE '''' END) AS aaaa ';

        OPEN c_bucket;
        FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
		WHILE @@FETCH_STATUS = 0   
			BEGIN

			SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[@v_weekstart_date]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [@v_column_name] ';
	
			SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
			SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

			SET @v_iteration = @v_iteration + @v_column_text;	
    
			FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
            END;

	    CLOSE c_bucket;  
        DEALLOCATE c_bucket;
	    END;
	ELSE IF @v_bucket_type = 'WEEKLY'
	    BEGIN
		DECLARE c_bucket CURSOR FAST_FORWARD FOR
		    SELECT 'D_' + MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
		         , MIN(A.BASIS_YYYYMMDD)           AS BASIS_YYYYMMDD
		    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		    WHERE  1 = 1
		    AND    A.ISO_YYYYWW >=  @v_start_week
		    AND    A.ISO_YYYYWW <= @v_end_week 
		  --  GROUP BY A.WEEK_NAME
		    GROUP BY A.ISO_YYYYWW
			;
        
		--SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''20000102'' THEN CF.VALID_YN ELSE '''' END) AS aaaa ';

        OPEN c_bucket;
        FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
		WHILE @@FETCH_STATUS = 0   
			BEGIN

			SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[@v_weekstart_date]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [@v_column_name] ';
	
			SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
			SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

			SET @v_iteration = @v_iteration + @v_column_text;	
    
			FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
            END;

	    CLOSE c_bucket;  
        DEALLOCATE c_bucket;
		END;
	ELSE IF @v_bucket_type = 'MONTHLY'
	    BEGIN
		DECLARE c_bucket CURSOR FAST_FORWARD FOR
		    SELECT 'D_' + MIN(A.BASIS_YYYYMMDD)  AS COLUMN_NAME
				 , MIN(A.BASIS_YYYYMMDD)         AS BASIS_YYYYMMDD
			FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.BASIS_YYYYMM >= @v_start_week
			AND    A.BASIS_YYYYMM <= @v_end_week 
			GROUP BY MONTH_NAME
			;
        
		--SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''20000103'' THEN CF.VALID_YN ELSE '''' END) AS aaaa ';

		
		OPEN c_bucket;
        FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
		WHILE @@FETCH_STATUS = 0   
			BEGIN

			SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[@v_weekstart_date]'' THEN CASE CF.VALID_YN WHEN ''Y'' THEN CF.VALID_YN ELSE '''' END ELSE '''' END) AS [@v_column_name] ';
	
			SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
			SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

			SET @v_iteration = @v_iteration + @v_column_text;	
    
			FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
            END;

	    CLOSE c_bucket;  
        DEALLOCATE c_bucket;
		END;
	
    --SELECT @v_start_yyyymmdd, @v_end_yyyymmdd;	
/*
    DECLARE c_bucket CURSOR FAST_FORWARD FOR
    SELECT 'D_' + a.basis_start_date AS column_name       
         , basis_start_date AS weekstart_date
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
    WHERE  a.iso_yyyyww > @v_start_week --   CONVERT(CHAR(4), YEAR(CURRENT_TIMESTAMP)) + CONVERT(CHAR(2), DATEPART(WEEK, CURRENT_TIMESTAMP))
    AND    a.iso_yyyyww <= @v_end_week --CONVERT(CHAR(4), YEAR(DATEADD(YYYY, 1, CURRENT_TIMESTAMP))) + CONVERT(CHAR(2), DATEPART(WEEK, CURRENT_TIMESTAMP))
    GROUP BY a.basis_start_date
           , a.basis_end_date
	;
	
  SELECT @v_iteration = '';

  OPEN c_bucket;
  FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
  WHILE @@FETCH_STATUS = 0   
  BEGIN

	SET @v_column_text = ', MAX(CASE WHEN CF.SUMMARY_BUCKET_VALUE = ''[@v_weekstart_date]'' THEN CF.VALID_YN ELSE '''' END) AS [@v_column_name] ';
	
	SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
	SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

	SELECT @v_iteration = @v_iteration + @v_column_text;	
    
    FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
  END;
  
  --SELECT @v_iteration AS xxxx;

  CLOSE c_bucket;  
  DEALLOCATE c_bucket;
  */


  SET @v_sql_text = '
      WITH MASTER AS 
	  (
	   
		  SELECT CF.PLAN_WEEK
				, CF.DIVISION_ID	
	    		,  S.DEPT_ID	 
				, CF.CUSTOMER_CODE   
				, CF.SCM_SITE_ID      
				, CF.SUMMARY_BUCKET_TYPE
				, CF.MEASURE_GROUP
				, CF.MEASURE
				, CF.EDI_FCST_YN
				, CF.CUSTOMER_PSI
				, CF.UPLOAD_UOM
				, CF.UPLOAD_BUCKET_TYPE
				--, CF.VALID_YN
				, CF.MASTER_VALID_YN
                , C.BASIS_YYYYMMDD AS SUMMARY_BUCKET_VALUE 
		 FROM   (	SELECT		 T1.PLAN_WEEK
								,T1.DIVISION_ID	
								,T1.CUSTOMER_CODE   
								,T1.SCM_SITE_ID      
								,T1.SUMMARY_BUCKET_TYPE
								,T1.MEASURE_GROUP
								,T1.MEASURE
								,T1.EDI_FCST_YN
								,T1.CUSTOMER_PSI
								,T1.UPLOAD_UOM
								,T1.UPLOAD_BUCKET_TYPE
								,T1.MASTER_VALID_YN
								,T2.VALID_YN
								,T2.SUMMARY_BUCKET_VALUE
					FROM		(
									SELECT  PLAN_WEEK
											,DIVISION_ID	
											,CUSTOMER_CODE   
											,SCM_SITE_ID      
											,SUMMARY_BUCKET_TYPE
											,MEASURE_GROUP
											,MEASURE
											,EDI_FCST_YN
											,CUSTOMER_PSI
											,UPLOAD_UOM
											,UPLOAD_BUCKET_TYPE
											,MAX(VALID_YN) AS MASTER_VALID_YN
										
									FROM	[dbo].[DM_MST_CUSTOMER_FCST] AS CF WITH(NOLOCK)  
									WHERE	1=1
									AND		MEASURE_GROUP = ''CUST_FCST''
									AND		PLAN_WEEK     = ''[@p_plan_week]'' 
									AND		SUMMARY_BUCKET_VALUE BETWEEN ''20000101'' AND ''[@v_end_yyyymmdd]''
									[@p_division_id]  
									[@p_end_customer]	
									[@p_scm_site_id]
									[@p_bucket_type]	
												
									GROUP BY PLAN_WEEK
											 ,DIVISION_ID	
											 ,CUSTOMER_CODE   
											 ,SCM_SITE_ID      
											 ,SUMMARY_BUCKET_TYPE
											 ,MEASURE_GROUP
											 ,MEASURE
											 ,EDI_FCST_YN
											 ,CUSTOMER_PSI
											 ,UPLOAD_UOM
											 ,UPLOAD_BUCKET_TYPE

																		   ) T1
					LEFT JOIN   [dbo].[DM_MST_CUSTOMER_FCST]				 T2  WITH(NOLOCK)    
					ON			T1.PLAN_WEEK			 = T2.PLAN_WEEK
					AND			T1.DIVISION_ID			 = T2.DIVISION_ID	
					AND			T1.CUSTOMER_CODE   		 = T2.CUSTOMER_CODE   
					AND			T1.SCM_SITE_ID      	 = T2.SCM_SITE_ID      
					AND			T1.SUMMARY_BUCKET_TYPE	 = T2.SUMMARY_BUCKET_TYPE
					AND			T1.MEASURE_GROUP		 = T2.MEASURE_GROUP
					AND			T1.MEASURE				 = T2.MEASURE
					AND			T1.EDI_FCST_YN			 = T2.EDI_FCST_YN
					AND			T1.CUSTOMER_PSI			 = T2.CUSTOMER_PSI
					AND			T1.UPLOAD_UOM			 = T2.UPLOAD_UOM
					AND			T1.UPLOAD_BUCKET_TYPE	 = T2.UPLOAD_BUCKET_TYPE
					AND			T2.SUMMARY_BUCKET_VALUE BETWEEN ''[@v_start_yyyymmdd]'' AND ''[@v_end_yyyymmdd]''
					
					WHERE		1 = 1
					
					
							
					
					) CF  
					LEFT JOIN [dbo].[SCM_SYS_CALENDAR_M]    C	 WITH(NOLOCK)		
					ON			(    C.BASIS_YYYYMMDD = CF.SUMMARY_BUCKET_VALUE  
									AND C.BASIS_YYYYMMDD BETWEEN ''20000101'' AND ''[@v_end_yyyymmdd]'')					
			   , [dbo].[SCM_MST_SITE]         S   WITH(NOLOCK)
		 WHERE  1 = 1
		 AND    CF.DIVISION_ID   = S.DIVISION_ID
		 AND    CF.CUSTOMER_CODE = S.END_CUSTOMER
		 AND    CF.SCM_SITE_ID   = S.SCM_SITE_ID
		 [@p_dept_id]     							
			  		
	         
		   

  )

    SELECT M.PLAN_WEEK
         , M.DIVISION_ID	
		 , M.DEPT_ID	 
         , M.CUSTOMER_CODE   
		 , M.SCM_SITE_ID      
		 , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1
							 WHEN ''WEEKLY'' THEN 2
							 WHEN ''MONTHLY'' THEN 3 END AS UPLOAD_ORDER
		 , M.SUMMARY_BUCKET_TYPE
		 , M.MEASURE_GROUP
         , M.MEASURE
         , M.EDI_FCST_YN
		 , M.CUSTOMER_PSI
         , M.UPLOAD_UOM

		 , M.UPLOAD_BUCKET_TYPE
        -- , M.VALID_YN
		 , M.MASTER_VALID_YN AS VALID_YN
		 , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', M.DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'') 
			THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
         [@v_iteration]    
    FROM   MASTER           M   WITH(NOLOCK)
		   LEFT OUTER JOIN [dbo].[DM_MST_CUSTOMER_FCST] CF  WITH(NOLOCK)
		   ON (    M.PLAN_WEEK            = CF.PLAN_WEEK
			   AND M.DIVISION_ID          = CF.DIVISION_ID
			   AND M.CUSTOMER_CODE        = CF.CUSTOMER_CODE
			   AND M.SCM_SITE_ID          = CF.SCM_SITE_ID
			   AND M.SUMMARY_BUCKET_TYPE  = CF.SUMMARY_BUCKET_TYPE
			   AND M.MEASURE_GROUP        = CF.MEASURE_GROUP
			   AND M.MEASURE              = CF.MEASURE
			   AND M.SUMMARY_BUCKET_VALUE = CF.SUMMARY_BUCKET_VALUE
			   AND M.EDI_FCST_YN          = CF.EDI_FCST_YN
			   AND M.CUSTOMER_PSI         = CF.CUSTOMER_PSI
			   AND M.UPLOAD_UOM 		  = CF.UPLOAD_UOM
			   AND M.UPLOAD_BUCKET_TYPE	  = CF.UPLOAD_BUCKET_TYPE
			   [@p_division_id]  			   
			   [@p_end_customer]	
			   [@p_scm_site_id]
			   [@p_bucket_type]			
			  -- AND CF.SUMMARY_BUCKET_VALUE BETWEEN ''[@v_start_yyyymmdd]'' AND ''[@v_end_yyyymmdd]''
			  )
    WHERE  1 = 1
	[@p_valid_yn]
	--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''[@v_start_yyyymmdd]'' AND ''[@v_end_yyyymmdd]''
	
	GROUP BY M.PLAN_WEEK
           , M.DIVISION_ID		
		   , M.DEPT_ID 
           , M.CUSTOMER_CODE   
		   , M.SCM_SITE_ID      
		   , M.SUMMARY_BUCKET_TYPE
           , M.MEASURE
		   , M.MEASURE_GROUP
           , M.EDI_FCST_YN
		   , M.CUSTOMER_PSI
           , M.UPLOAD_UOM
		   , M.UPLOAD_BUCKET_TYPE
		  -- , M.VALID_YN
		   , M.MASTER_VALID_YN
		   , CASE M.UPLOAD_BUCKET_TYPE WHEN ''DAILY'' THEN 1
							 WHEN ''WEEKLY'' THEN 2
							 WHEN ''MONTHLY'' THEN 3 END
    ORDER BY DIVISION_ID
	       , DEPT_ID
           , CUSTOMER_CODE
		   , SCM_SITE_ID
		   , UPLOAD_ORDER
		   , MEASURE_GROUP
		   , MEASURE
		   

  '; 
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'     , @v_iteration     );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_plan_week]'     , @v_plan_week     );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_start_yyyymmdd]', @v_start_yyyymmdd);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_yyyymmdd]'  , @v_end_yyyymmdd  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.DIVISION_ID'        , 'IN', @p_division_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dept_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DEPT_ID'             , 'IN', @p_dept_id     ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_customer]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.CUSTOMER_CODE'      , 'IN', @p_end_customer));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_scm_site_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.SCM_SITE_ID'        , 'IN', @p_scm_site_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_bucket_type]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.SUMMARY_BUCKET_TYPE', 'EQ', @p_bucket_type ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_valid_yn]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('M.MASTER_VALID_YN'     , 'EQ', @p_valid_yn    ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'    , @p_created_by    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'    , @v_group_id    );

  --SET @p_debug = @v_sql_text;
  --RETURN @v_sql_text;
  --SELECT @v_sql_text;

  --EXEC(@v_sql_text);
  EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;


-- xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')  
 
								  
END


