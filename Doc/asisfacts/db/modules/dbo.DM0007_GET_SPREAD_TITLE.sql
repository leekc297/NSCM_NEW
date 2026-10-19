
/*
 * Program ID   : DM0007_GET_SPREAD_TITLE     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/18  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE procedure [dbo].[DM0007_GET_SPREAD_TITLE]
    @p_plan_week    NVARCHAR(6),
    @p_bucket_type  NVARCHAR(10),
    @p_created_by	NVARCHAR(30)
AS
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_start_week     AS NVARCHAR(8);
    DECLARE @v_end_week       AS NVARCHAR(8);
    DECLARE @v_bucket_type    AS NVARCHAR(10);
	DECLARE @v_user_col_cnt   AS INT;
	DECLARE @v_user_time_zone AS NVARCHAR(10);
	DECLARE @v_user_time      AS NVARCHAR(8);

	SET @v_sql_text = '';
	SET @v_iteration = '';
    SET @v_start_week = '';
    SET @v_end_week = '';
    SET @v_bucket_type = '';
	SET @v_user_col_cnt = 0;

    SET @v_start_week = @p_plan_week;
    SET @v_bucket_type = @p_bucket_type;
	SET @v_user_time_zone = '';

	BEGIN
	    SELECT @v_user_time_zone = U.TIMEZONE
		FROM   [dbo].[TB_FX_User] U
		WHERE  U.UserID = @p_created_by;
	END
	
    IF @v_start_week = ''
	    BEGIN
		IF @v_bucket_type = 'DAILY'
			SELECT @v_start_week = MIN(C.BASIS_YYYYMMDD)
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                 , (SELECT C.ISO_YYYYWW
                    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_MULTY_TIME(@v_user_time_zone), 112)
	               ) T
            WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;
        ELSE IF @v_bucket_type = 'WEEKLY'
		    SELECT @v_start_week = C.ISO_YYYYWW
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
            WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), dbo.FN_MULTY_TIME(@v_user_time_zone), 112);
		ELSE IF @v_bucket_type = 'MONTHLY'
		    SELECT @v_start_week =C.BASIS_YYYYMM
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
            WHERE  C.BASIS_YYYYMM = CONVERT(CHAR(6), dbo.FN_MULTY_TIME(@v_user_time_zone), 112);
		END;
    ELSE
        SET @v_start_week = @p_plan_week;  
    

	BEGIN
		IF @v_bucket_type = 'DAILY'
            SELECT @v_end_week = C.BASIS_YYYYMMDD
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
            WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MM, 12, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
        ELSE IF @v_bucket_type = 'WEEKLY'
		    SELECT @v_end_week = ISO_YYYYWW
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
			-- modified by ytchoi 180802
            -- WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MM, 12, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
			WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(MM, 30, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
		ELSE IF @v_bucket_type = 'MONTHLY'
		    SELECT @v_end_week = BASIS_YYYYMM
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
			-- modified by ytchoi 180802
            -- WHERE  C.BASIS_YYYYMM = CONVERT(CHAR(6), DATEADD(MM, 12, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
			WHERE  C.BASIS_YYYYMM = CONVERT(CHAR(6), DATEADD(MM, 30, dbo.FN_MULTY_TIME(@v_user_time_zone)), 112)
	END;
    
	/*
	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = 'DM0007'
    AND    U.SHEET_NAME = 'Customer FCST'
    AND    U.USER_ID    = @p_created_by;
			*/

	IF @v_bucket_type = 'DAILY'
	    BEGIN
		SET @v_iteration = '
		    SELECT ''D_'' + A.BASIS_YYYYMMDD  AS COLUMN_NAME
		         , A.DAYOFWEEK                       AS SMALL_CLASS_LABEL_NAME  
		         , A.BASIS_YYYYMMDD             AS BASIS_YYYYMMDD
		    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		    WHERE  1 = 1
		    AND    A.BASIS_YYYYMMDD >=  [@v_start_week]
		    AND    A.BASIS_YYYYMMDD <= [@v_end_week]     
			';		
		END;
	ELSE IF @v_bucket_type = 'WEEKLY'
	    BEGIN
		SET @v_iteration = '
		    SELECT ''D_'' + MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
		     --    , A.WEEK_NAME                       AS SMALL_CLASS_LABEL_NAME  
			     , A.ISO_YYYYWW                       AS SMALL_CLASS_LABEL_NAME  
		         , MIN(A.BASIS_YYYYMMDD)             AS BASIS_YYYYMMDD
		    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		    WHERE  1 = 1
		    AND    A.ISO_YYYYWW >=  [@v_start_week] 
		    AND    A.ISO_YYYYWW <= [@v_end_week] 
		  --  GROUP BY A.WEEK_NAME
		    GROUP BY A.ISO_YYYYWW
			';
		END;
	ELSE IF @v_bucket_type = 'MONTHLY'
	    BEGIN
		SET @v_iteration = '
		    SELECT ''D_'' + MIN(A.BASIS_YYYYMMDD)  AS COLUMN_NAME
				 , A.MONTH_NAME                    AS SMALL_CLASS_LABEL_NAME  
				 , MIN(A.BASIS_YYYYMMDD)           AS BASIS_YYYYMMDD
			FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
			WHERE  1 = 1
			AND    A.BASIS_YYYYMM >= [@v_start_week] 
			AND    A.BASIS_YYYYMM <= [@v_end_week] 
			GROUP BY MONTH_NAME
			';
		END;
			
	IF @v_user_col_cnt > 0
	    BEGIN
	    -- User Title 이 존재
		SET @v_sql_text = '
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
            FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
            WHERE  1 = 1            
            AND    C.PROGRAM_ID = ''DM0007''
            AND    C.SHEET_NAME = ''Customer FCST''
            AND    C.VALID_YN   = ''Y''

		    UNION ALL

			SELECT ''DM0007''         AS PROGRAM_ID
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
	                [@v_iteration]
                   ) T
                 , [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
	    ';
		
		END;
	ELSE
	    BEGIN
	    -- User Title 이 존재
		SET @v_sql_text = '
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
            FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
            WHERE  1 = 1
            AND    C.PROGRAM_ID = ''DM0007''
            AND    C.SHEET_NAME = ''Customer FCST''
			AND    C.VALID_YN   = ''Y''
            		
		    UNION ALL

			SELECT ''DM0007''         AS PROGRAM_ID
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
	                [@v_iteration] 
                   ) T
                 , [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK) 
            WHERE  T.BASIS_YYYYMMDD = C.BASIS_YYYYMMDD  
            ORDER BY SORT_ORDER_NO 
	    ';		
		END;

    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]' , @v_iteration );
    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_start_week]', @v_start_week);
    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_week]'  , @v_end_week  );
	SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]', @p_created_by);

	--SELECT @v_sql_text;
    --SET @p_debug = @v_sql_text;
    --RETURN @v_sql_text;
    --SELECT @v_sql_text;

    --EXEC(@v_sql_text);
    EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;

END


