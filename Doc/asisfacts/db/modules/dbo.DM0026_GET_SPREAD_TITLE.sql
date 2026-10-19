
/*
 * Program ID   : DM0026_GET_SPREAD_TITLE     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/05  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE procedure [dbo].[DM0026_GET_SPREAD_TITLE]
    @p_start_yyyymmdd NVARCHAR(8),
    @p_end_yyyymmdd   NVARCHAR(8),
    @p_created_by	  NVARCHAR(30)
AS
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_sql_text       AS NVARCHAR(MAX);
	DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
    DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);

	SET @v_sql_text = '';
	SET @v_iteration = '';
    SET @v_start_yyyymmdd = '';
    SET @v_end_yyyymmdd = '';
    

    SET @v_start_yyyymmdd = @p_start_yyyymmdd;
    SET @v_end_yyyymmdd = @p_end_yyyymmdd;

    IF @v_start_yyyymmdd = ''
	    BEGIN		
			SELECT @v_start_yyyymmdd = MIN(C.BASIS_YYYYMMDD)
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                 , (SELECT C.ISO_YYYYWW
                    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
	               ) T
            WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;        
		END;
        
	IF @v_end_yyyymmdd = ''
	    BEGIN		
            SELECT @v_end_yyyymmdd = MAX(C.BASIS_YYYYMMDD)
            FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                 , (SELECT C.ISO_YYYYWW
                    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
                    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)  
	               ) T
            WHERE  C.ISO_YYYYWW = T.ISO_YYYYWW;         
	    END;
    
	/*
	SELECT @v_user_col_cnt = COUNT(*)
	FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
	WHERE  1 = 1
	AND    U.PROGRAM_ID = 'DM0007'
    AND    U.SHEET_NAME = 'Customer FCST'
    AND    U.USER_ID    = @p_created_by;
			*/

	
	BEGIN
	SET @v_iteration = '
		SELECT ''D_'' + BASIS_YYYYMMDD     AS COLUMN_NAME
			 , C.CALENDAR_DAY              AS COLUMN_LABEL_NAME
			 , C.WEEK_NAME                 AS SMALL_CLASS_LABEL_NAME
			 , C.MONTH_NAME                AS LARGE_CLASS_LABEL_NAME 
			 , C.BASIS_YYYYMMDD + ''03''   AS SORT_ORDER_NO
			 , C.DAYOFWEEK                 AS DAY_CODE
		FROM   [dbo].[SCM_SYS_CALENDAR_M]  C  WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.BASIS_YYYYMMDD >= [@v_start_yyyymmdd]
		AND    C.BASIS_YYYYMMDD <= [@v_end_yyyymmdd]
		UNION ALL
		SELECT ''W_'' + BASIS_YYYYMM + WEEK_NAME  AS COLUMN_NAME
			 , ''SUM''                            AS COLUMN_LABEL_NAME
			 , C.WEEK_NAME                        AS SMALL_CLASS_LABEL_NAME
			 , C.MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME 
			 , C.BASIS_START_DATE + ''02''        AS SORT_ORDER_NO
			 , ''''                               AS DAY_CODE
		FROM   [dbo].[SCM_SYS_CALENDAR_M]         C  WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.BASIS_YYYYMMDD >= [@v_start_yyyymmdd]
		AND    C.BASIS_YYYYMMDD <= [@v_end_yyyymmdd]
		GROUP BY C.BASIS_YYYYMM
			   , C.MONTH_NAME
			   , C.ISO_YYYYWW
			   , C.BASIS_START_DATE
			   , C.WEEK_NAME      
		UNION ALL
		SELECT ''M_'' + BASIS_YYYYMM              AS COLUMN_NAME
			 , ''SUM''                            AS COLUMN_LABEL_NAME
			 , ''SUM''                            AS SMALL_CLASS_LABEL_NAME
			 , C.MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME 
			 , MIN(C.BASIS_START_DATE) + ''01''   AS SORT_ORDER_NO
			 , ''''                               AS DAY_CODE
		FROM   [dbo].[SCM_SYS_CALENDAR_M]         C  WITH(NOLOCK)
		WHERE  1 = 1
		AND    C.BASIS_YYYYMMDD >= [@v_start_yyyymmdd]
		AND    C.BASIS_YYYYMMDD <= [@v_end_yyyymmdd]
		GROUP BY C.BASIS_YYYYMM
			   , C.MONTH_NAME
		';		
	END;
			
	
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
			 , ''''    AS DAY_CODE
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
        AND    C.PROGRAM_ID = ''DM0026''
        AND    C.SHEET_NAME = ''ESS Channel PSI''
        AND    C.VALID_YN   = ''Y''

		UNION ALL

		SELECT ''DM0026''           AS PROGRAM_ID
			 , ''ESS Channel PSI''  AS SHEET_NAME
			 , T.COLUMN_NAME
             , T.COLUMN_LABEL_NAME  AS COLUMN_LABEL_NAME
			 , T.SORT_ORDER_NO      AS SORT_ORDER_NO
			 , ''''                 AS DATA_SORT_METHOD_CODE
	         , T.SMALL_CLASS_LABEL_NAME
			 , T.LARGE_CLASS_LABEL_NAME
			 , T.DAY_CODE
			 , ''''               AS FIXED_FLAG
			 , 50                 AS COLUMN_WIDTH
             , ''''               AS CELL_CONTROL_OBJECT_TYPE_CODE
			 , ''''               AS CELL_COMBO_DATA_TYPE
             , ''''               AS DATA_SCALE_NUMBER
             , ''''               AS DATA_MAX_LENGTH
             , ''R''              AS HORIZONTAL_ALIGN_CODE
             , ''Y''              AS UPPERCASE_APPLY_FLAG
             , ''Y''              AS VISIBLE_FLAG
			 , ''Y''              AS VALID_YN
             , ''''               AS DEFAULT_FLAG
        FROM   (		 
	            [@v_iteration]
               ) T
        WHERE  1 = 1
        ORDER BY SORT_ORDER_NO 
	';
		
	END;
	

    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'     , @v_iteration );
    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_start_yyyymmdd]', @v_start_yyyymmdd);
    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_yyyymmdd]'  , @v_end_yyyymmdd  );
	--SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]', @p_created_by);

	--SELECT @v_sql_text;
    --SET @p_debug = @v_sql_text;
    --RETURN @v_sql_text;
    --SELECT @v_sql_text;

    --EXEC(@v_sql_text);
    EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;

END


