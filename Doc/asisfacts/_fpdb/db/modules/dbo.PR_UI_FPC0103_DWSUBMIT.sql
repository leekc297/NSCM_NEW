CREATE PROCEDURE [dbo].[PR_UI_FPC0103_DWSUBMIT]
	@p_sys_type			NVARCHAR(MAX),  
	@p_sys_flag			NVARCHAR(MAX),
	@p_sys_gubun		NVARCHAR(MAX),  
	@p_user_id			NVARCHAR(MAX),
	@in_columns			NVARCHAR(MAX),
	@in_row				NVARCHAR(MAX),
	@opt_none			NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FPC0103_DWSUBMIT                                                         **/
/** 프로그램 명   : Procedure PR_UI_FPC0103_DWSUBMIT                                               **/
/** 설 명         :                                                                           **/
/** Version       :				                                                              **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021/08/08   CYS				Initial Release UI통합                                    **/
/***********************************************************************************************/

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;
  
	--DECLARE BASE PARAMETER START
	DECLARE @v_proc_name	NVARCHAR(100) = 'PR_UI_FPC0103_DWSUBMIT';
	DECLARE @runstart		DATETIME;
	DECLARE @runend			DATETIME;
	DECLARE @v_dSql			NVARCHAR(MAX) ='';
	DECLARE @STRLEN			NVARCHAR(MAX);
	DECLARE @v_Err			NVARCHAR(MAX);
	DECLARE @v_Log			NVARCHAR(MAX); 

	DECLARE @v_delimiter    NVARCHAR(1);
	DECLARE @max_loop_cnt	INTEGER = 0;
	DECLARE @mst_loop_cnt	INTEGER = 0;

	DECLARE @p__save_auth	NVARCHAR(MAX);
	DECLARE @p__non_auth	NVARCHAR(MAX);

	-- filter

	DECLARE @p_company_id	NVARCHAR(MAX);
	DECLARE @p_instance_id	NVARCHAR(MAX);
	DECLARE @p_master_id	NVARCHAR(MAX);
	DECLARE @p_plan_date	NVARCHAR(MAX);
	DECLARE @p_plan_id		NVARCHAR(MAX);
	DECLARE @p_bucket_from	NVARCHAR(MAX);
	DECLARE @p_bucket_to	NVARCHAR(MAX);

	DECLARE @p_division_id	NVARCHAR(MAX);
	DECLARE @p_site_id		NVARCHAR(MAX);
	DECLARE @p_plant_id		NVARCHAR(MAX);
	DECLARE @p_factory_id	NVARCHAR(MAX);
	DECLARE @p_operation_id NVARCHAR(MAX);
	DECLARE @p_line_id		NVARCHAR(MAX);
	
	DECLARE @p_mpp_wpp		NVARCHAR(MAX);
	DECLARE @p_table_name	NVARCHAR(MAX);
	DECLARE @p_plan_type	NVARCHAR(MAX);
	DECLARE @p_confirm_type	NVARCHAR(MAX);
	
	-- week
	DECLARE @p_bucket		NVARCHAR(MAX);
	DECLARE @p_week_info	NVARCHAR(MAX);
	DECLARE @p_month_info	NVARCHAR(MAX);

	DECLARE @tmp_column		NVARCHAR(MAX);
	DECLARE @tmp_value		NVARCHAR(MAX);
	DECLARE @dbg_txt		NVARCHAR(MAX);

	SET @v_delimiter            = '^'  -- 데이터 구분자
	SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
	
	WHILE @mst_loop_cnt < @max_loop_cnt
	BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
		
		SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

		SET @tmp_column	= [dbo].[SCM_ARR_SPL_VAL]( @in_columns , @v_delimiter , @mst_loop_cnt);
		SET @tmp_value	= [dbo].[SCM_ARR_SPL_VAL]( @in_row , @v_delimiter , @mst_loop_cnt);

		IF @tmp_column = '_SAVE_AUTH' BEGIN
			SET @p__save_auth =			@tmp_value ;
		END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
			SET @p__non_auth =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
			SET @p_company_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
			SET @p_instance_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
			SET @p_master_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
			SET @p_plan_date =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
			SET @p_plan_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
			SET @p_bucket_from =		@tmp_value ;
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_bucket_from
		END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
			SET @p_bucket_to =			@tmp_value ;

		END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
			SET @p_division_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'SITE_ID' BEGIN
			SET @p_site_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
			SET @p_plant_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
			SET @p_factory_id =			@tmp_value ;
		END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
			SET @p_operation_id =		@tmp_value ;
		END ELSE IF @tmp_column = 'LINE_ID' BEGIN
			SET @p_line_id =			@tmp_value ;
		
		END ELSE IF @tmp_column = 'MPP_WPP' BEGIN
			SET @p_mpp_wpp =			@tmp_value ;
		END ELSE IF @tmp_column = 'TABLE_NAME' BEGIN
			SET @p_table_name =			@tmp_value ;
		END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
			SET @p_plan_type =			@tmp_value ;
		END ELSE IF @tmp_column = 'CONFIRM_TYPE' BEGIN
			SET @p_confirm_type =		@tmp_value ;
			
		END ELSE IF @tmp_column = 'BUCKET' BEGIN
			SET @p_bucket =				@tmp_value ;
		END ELSE IF @tmp_column = 'WEEK_INFO' BEGIN
			SET @p_week_info =			@tmp_value ;
		END ELSE IF @tmp_column = 'MONTH_INFO' BEGIN
			SET @p_month_info =			@tmp_value ;
			SET @dbg_txt += @tmp_column
			SET @dbg_txt += @p_month_info
		END

	END
	/*	Parameter Setting End */

	SET	@v_dSql = '';
	
	IF @p_sys_flag = 'DWSUBMIT_LIST'	-- find_DWSubmit_List
	BEGIN
		
		SELECT @v_dSql += N'	SELECT ''INSTANCE_ID'' AS CONDITION_TYPE, '''+ @p_master_id +''' AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE				' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''FP_PLAN_ID'' AS CONDITION_TYPE, '''+ @p_plan_id +''' AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE                  ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''TYPE'' AS CONDITION_TYPE, SUBSTRING('''+ @p_mpp_wpp +''',1,3) AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE         ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''TABLE_NAME'' AS CONDITION_TYPE, '''+ @p_table_name +''' AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE               ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT ''LINE_ID'' AS CONDITION_TYPE, L.LINE_ID AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE            ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_LINE_M L WITH(NOLOCK), (                                                                                     ' + char(10)
		SELECT @v_dSql += N'		SELECT B.INSTANCE_ID                                                                                                ' + char(10)
		SELECT @v_dSql += N'			, (CASE WHEN B.FACTORY_ID <> ''-'' THEN B.FACTORY_ID ELSE ''-'' END) AS FACTORY_ID                              ' + char(10)
		SELECT @v_dSql += N'			, (CASE WHEN B.PLAN_GROUP_ID <> ''-'' THEN B.PLAN_GROUP_ID ELSE ''-'' END) AS PLAN_GROUP_ID                     ' + char(10)
		SELECT @v_dSql += N'		FROM   FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK)                                                                        ' + char(10)
		SELECT @v_dSql += N'		WHERE  B.INSTANCE_ID     = '''+ @p_master_id +'''                                                                              ' + char(10)
		SELECT @v_dSql += N'		AND    B.RELEASE_PLAN_ID = '''+ @p_plan_id +'''                                                                                ' + char(10)
		SELECT @v_dSql += N'	) B                                                                                                                     ' + char(10)
		SELECT @v_dSql += N'	WHERE  CASE WHEN B.FACTORY_ID = ''-'' THEN B.FACTORY_ID ELSE L.FACTORY_ID END = B.FACTORY_ID                            ' + char(10)
		SELECT @v_dSql += N'	AND    CASE WHEN B.PLAN_GROUP_ID = ''-'' THEN B.PLAN_GROUP_ID ELSE L.MODEL_TYPE END = B.PLAN_GROUP_ID                   ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('L.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	AND    L.ACTIVE_FLAG = ''Y''                                                                                            ' + char(10)
		SELECT @v_dSql += N'	AND    NOT EXISTS ( SELECT 1                                                                                            ' + char(10)
		SELECT @v_dSql += N'					FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)                                                            ' + char(10)
		SELECT @v_dSql += N'					WHERE  SLV.LOOKUP_TYPE_CODE  = ''INSTANCE_SPLIT_LINE_DEFINITION''                                       ' + char(10)
		SELECT @v_dSql += N'					AND    SLV.ACTIVE_FLAG       = ''Y''                                                                    ' + char(10)
		SELECT @v_dSql += N'					AND    SLV.SEGMENT2          = B.INSTANCE_ID                                                            ' + char(10)
		SELECT @v_dSql += N'					AND    SLV.SEGMENT3          = L.LINE_ID )                                                              ' + char(10)
		SELECT @v_dSql += N'	AND    NOT EXISTS ( SELECT 1                                                                                            ' + char(10)
		SELECT @v_dSql += N'					FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)                                                            ' + char(10)
		SELECT @v_dSql += N'					WHERE  SLV.LOOKUP_TYPE_CODE  = ''INSTANCE_SPLIT_LINE_DEFINITION''                                       ' + char(10)
		SELECT @v_dSql += N'					AND    SLV.ACTIVE_FLAG       = ''Y''                                                                    ' + char(10)
		SELECT @v_dSql += N'					AND    SLV.SEGMENT1          = B.INSTANCE_ID)                                                           ' + char(10)
		SELECT @v_dSql += N'	AND   B.INSTANCE_ID != ''KR_CELL_M_P''                                                                                  ' + char(10)
		SELECT @v_dSql += N'	AND   L.FACTORY_ID IN ( SELECT A.FACTORY_ID                                                                             ' + char(10)
		SELECT @v_dSql += N'						FROM   DBO.[FP_INSTANCE_FACTORY_M] A WITH(NOLOCK)                                                   ' + char(10)
		SELECT @v_dSql += N'						WHERE  A.ACTIVE_FLAG = ''Y''                                                                        ' + char(10)
		SELECT @v_dSql += N'						AND    A.INSTANCE_ID != ''KR_CELL_M_P''                                                             ' + char(10)
		SELECT @v_dSql += N'						AND    A.INSTANCE_ID = B.INSTANCE_ID )                                                              ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT DISTINCT ''LINE_ID'' AS CONDITION_TYPE, SLV.SEGMENT3 AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE         ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_SYS_LOOKUP_VALUE SLV WITH(NOLOCK)                                                                            ' + char(10)
		SELECT @v_dSql += N'	WHERE  SLV.LOOKUP_TYPE_CODE  = ''INSTANCE_SPLIT_LINE_DEFINITION''                                                       ' + char(10)
		SELECT @v_dSql += N'	AND    SLV.ACTIVE_FLAG       = ''Y''                                                                                    ' + char(10)
		SELECT @v_dSql += N'	AND    SLV.SEGMENT1          = '''+ @p_master_id +'''                                                                              ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''OPERATION_ID'' AS CONDITION_TYPE, A.OPERATION_ID AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE           ' + char(10)
		SELECT @v_dSql += N'	FROM   '+ @p_table_name +' A WITH(NOLOCK)                                                                                      ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.INSTANCE_ID    = '''+ @p_master_id +'''                                                                                   ' + char(10)
		SELECT @v_dSql += N'	AND    A.FP_PLAN_ID     = '''+ @p_plan_id +'''                                                                                     ' + char(10)
		SELECT @v_dSql += N'	AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                                         ' + char(10)
		SELECT @v_dSql += N'	AND    A.FACTORY_ID <> ''-''                                                                                            ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += N'	GROUP BY A.OPERATION_ID                                                                                                 ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''FROM_DATE'' AS CONDITION_TYPE, '''+ @p_bucket_from +''' AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE               ' + char(10)
		SELECT @v_dSql += N'	UNION ALL                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	SELECT ''TO_DATE'' AS CONDITION_TYPE, '''+ @p_bucket_to +''' AS CONDITION_VALUE, NULL AS CONDITION_NUMERIC_VALUE                   ' + char(10)

	END

	IF @p_sys_flag = 'LINECODE_AMEND'	-- findLineCode_Amend
	BEGIN
		
		SELECT @v_dSql += N'	SELECT A.LINE_ID AS CODE																																	' + char(10)
		SELECT @v_dSql += N'	   , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS NAME                     ' + char(10)
		SELECT @v_dSql += N'	FROM   SCM_LINE_M A WITH(NOLOCK)                                                                                                                            ' + char(10)
		SELECT @v_dSql += N'	WHERE  A.ACTIVE_FLAG = ''Y''                                                                                                                                ' + char(10)
		SELECT @v_dSql += N'	AND    EXISTS (                                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'		        	SELECT 1                                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                   ' + char(10)
		SELECT @v_dSql += N'		        	WHERE  A.COMPANY_ID     = B.COMPANY_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.DIVISION_ID    = B.DIVISION_ID                                                                                                     ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.SITE_ID        = B.SITE_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.PLANT_ID    	= B.PLANT_ID                                                                                                        ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.FACTORY_ID  	= B.FACTORY_ID                                                                                                      ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.OPERATION_ID   = B.OPERATION_ID                                                                                                    ' + char(10)
		SELECT @v_dSql += N'		        	AND    A.LINE_ID   		= B.LINE_ID                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		        	AND    B.USER_ID        = '''+ @p_user_id +'''                                                                                                         ' + char(10)
		SELECT @v_dSql += N'		        	AND	   B.SAVE_FLAG	  	= ''Y''                                                                                                             ' + char(10)
		SELECT @v_dSql += N'			    )                                                                                                                                               ' + char(10)
		SELECT @v_dSql += N'	AND   EXISTS (                                                                                                                                              ' + char(10)
		SELECT @v_dSql += N'	  SELECT 1 FROM (                                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID                                                                          ' + char(10)
		SELECT @v_dSql += N'	      FROM  SCM_FACTORY_M A WITH(NOLOCK)                                                                                                                    ' + char(10)
		SELECT @v_dSql += N'	      INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      ON    A.FACTORY_ID=B.FACTORY_ID                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	      AND   B.ACTIVE_FLAG = ''Y''                                                                                                                           ' + char(10)
		SELECT @v_dSql += N'	      WHERE B.INSTANCE_ID = '''+ @p_instance_id +'''                                                                                                                   ' + char(10)
		SELECT @v_dSql += N'	  ) C                                                                                                                                                       ' + char(10)
		SELECT @v_dSql += N'	  WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID           ' + char(10)
		SELECT @v_dSql += N'	)                                                                                                                                                           ' + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
		SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
		
		IF ( @p_instance_id != '' AND @p_instance_id IS NOT NULL ) BEGIN 
			SELECT @v_dSql += N'	  AND EXISTS ( SELECT  1                                                                                                                        ' + char(10)
			SELECT @v_dSql += N'	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)                                                                                    ' + char(10)
			SELECT @v_dSql += N'	     				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                             ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''                                                                             ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                         ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ATTRIBUTE1       = ''BUILDING''                                                                                  ' + char(10)
			SELECT @v_dSql += N'	          		 UNION ALL                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'	          		 SELECT  1                                                                                                                    ' + char(10)
			SELECT @v_dSql += N'	               FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),                                                                                   ' + char(10)
			SELECT @v_dSql += N'	          		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)                                                                                ' + char(10)
			SELECT @v_dSql += N'	          		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                                                                               ' + char(10)
			SELECT @v_dSql += N'	          		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP''                                                                 ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = LV2.SEGMENT1                                                                                  ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.SEGMENT1         = '''+ @p_instance_id +'''                                                                             ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ACTIVE_FLAG      = ''Y''                                                                                         ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP''                                                                                ' + char(10)
			SELECT @v_dSql += N'	          		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )                                                           ' + char(10)
		END

		IF ( @p_plan_type = 'RELEASE' AND @p_confirm_type = 'PLAN GROUP' ) BEGIN 
			SELECT @v_dSql += N'	  AND A.MODEL_TYPE IN (                                                                                                                   ' + char(10)
			SELECT @v_dSql += N'	      SELECT KK.PLAN_GROUP_ID                                                                                                             ' + char(10)
			SELECT @v_dSql += N'	      FROM   FP_RELEASE_PLAN_INFO_H KK WITH(NOLOCK)                                                                                       ' + char(10)
			SELECT @v_dSql += N'	      WHERE  KK.INSTANCE_ID = '''+ @p_master_id +'''                                                                                 ' + char(10)
			SELECT @v_dSql += N'	      AND    KK.RELEASE_PLAN_ID = '''+ @p_plan_id +'''                                                                               ' + char(10)
			SELECT @v_dSql += N'	  )                                                                                                                                       ' + char(10)
		END

		SELECT @v_dSql += N'	GROUP BY A.LINE_ID, A.LINE_NAME                                                                                                                             ' + char(10)
		SELECT @v_dSql += N'	ORDER BY A.LINE_ID                                                                                                                                          ' + char(10)

	END

	IF @p_sys_type = 'SQL'
    BEGIN
			
			DECLARE @log_id INTEGER = 0
			EXEC	@log_id = PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'sql',@runstart, @runend

			SELECT	QUERY_VALUE 
			FROM	TH_UIS_SQL_LOG WITH(NOLOCK)  
			WHERE	PROG_ID = @v_proc_name AND JOB_TYPE = @p_sys_type AND INST_SEQ = @log_id
			ORDER BY QUERY_SEQ ASC

    END ELSE BEGIN

		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend

    END
	
  
END
