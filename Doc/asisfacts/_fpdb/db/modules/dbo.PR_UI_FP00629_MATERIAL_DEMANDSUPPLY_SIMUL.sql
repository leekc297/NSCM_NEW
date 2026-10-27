CREATE PROCEDURE [dbo].[PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @in_columns           NVARCHAR(MAX),
  @in_row               NVARCHAR(MAX),
  @opt_none             NVARCHAR(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   :PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL                                  **/
/** 프로그램 명   : Procedure PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL                       **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
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
/** 2021-08-10     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  DECLARE @p_plan_date       NVARCHAR(100) = ''
  DECLARE @p_instance_id     NVARCHAR(100) = ''
  DECLARE @p_plan_id         NVARCHAR(100) = ''
  DECLARE @p_division_id     NVARCHAR(1000) = ''
  DECLARE @p_site_id         NVARCHAR(1000) = ''
  DECLARE @p_plant_id        NVARCHAR(2000) = ''
  DECLARE @p_factory_id      NVARCHAR(2000) = ''
  DECLARE @p_operation_id    NVARCHAR(2000) = ''
  DECLARE @p_cell_group      NVARCHAR(max) = ''
  DECLARE @p_model_nick_name NVARCHAR(100) = ''
  DECLARE @p_top_item_id     NVARCHAR(100) = ''
  DECLARE @p_item_id         NVARCHAR(100) = ''
  DECLARE @p_nick_name       NVARCHAR(100) = ''
  DECLARE @p_plan_type       NVARCHAR(max) = ''
  DECLARE @p_is_result       NVARCHAR(max) = ''
  DECLARE @p_result_val      NVARCHAR(max) = ''
  DECLARE @p_result_val2     NVARCHAR(max) = ''
  DECLARE @p_release_flag    NVARCHAR(100) = ''
  DECLARE @p_amend_table     NVARCHAR(100) = ''
  DECLARE @p_alt_material    NVARCHAR(max)  = ''

  DECLARE @p_bucket_from     NVARCHAR(100) = ''
  DECLARE @p_bucket_to       NVARCHAR(100) = ''
  DECLARE @p_bucket          NVARCHAR(max) = ''
  DECLARE @p_day_info        NVARCHAR(max) = ''
  DECLARE @p_week_info       NVARCHAR(max) = ''
  DECLARE @p_month_info      NVARCHAR(max) = ''
  DECLARE @p_cate_info       NVARCHAR(max) = ''

  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00629_MATERIAL_DEMANDSUPPLY_SIMUL'


  DECLARE @v_plan_date       NVARCHAR(100)  = ''
  DECLARE @v_instance_id     NVARCHAR(100)  = ''
  DECLARE @v_plan_id         NVARCHAR(100)  = ''
  DECLARE @v_division_id     NVARCHAR(1000) = ''
  DECLARE @v_site_id         NVARCHAR(1000) = ''
  DECLARE @v_plant_id        NVARCHAR(2000) = ''
  DECLARE @v_factory_id      NVARCHAR(2000) = ''
  DECLARE @v_operation_id    NVARCHAR(2000) = ''
  DECLARE @v_cell_group      NVARCHAR(max)  = ''
  DECLARE @v_model_nick_name NVARCHAR(100)  = ''
  DECLARE @v_top_item_id     NVARCHAR(100)  = ''
  DECLARE @v_item_id         NVARCHAR(100)  = ''
  DECLARE @v_nick_name       NVARCHAR(100)  = ''
  DECLARE @v_plan_type       NVARCHAR(max)  = ''
  DECLARE @v_is_result       NVARCHAR(max)  = ''
  DECLARE @v_result_val      NVARCHAR(max)  = ''
  DECLARE @v_result_val2     NVARCHAR(max)  = ''
  DECLARE @v_release_flag    NVARCHAR(100)  = ''
  DECLARE @v_amend_table     NVARCHAR(100)  = ''
  DECLARE @v_bucket_from     NVARCHAR(100)  = ''
  DECLARE @v_bucket_to       NVARCHAR(100)  = ''
  DECLARE @v_bucket          NVARCHAR(max)  = ''
  DECLARE @v_day_info        NVARCHAR(max)  = ''
  DECLARE @v_week_info       NVARCHAR(max)  = ''
  DECLARE @v_month_info      NVARCHAR(max)  = ''
  DECLARE @v_cate_info       NVARCHAR(max)  = ''
  DECLARE @v_user_id         NVARCHAR(max)  = ''
  DECLARE @rtnCount   	        INTEGER = 0

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @v_dSql                 NVARCHAR(MAX)=''
  DECLARE @v_dSql1                NVARCHAR(MAX)=''
  DECLARE @v_dSql2                NVARCHAR(MAX)=''
  DECLARE @v_dSql3                NVARCHAR(MAX)=''
  DECLARE @v_dSql4                NVARCHAR(MAX)=''
  DECLARE @v_dSql5                NVARCHAR(MAX)=''
  
  DECLARE @v_SqlsubTotal          NVARCHAR(MAX)=''
  DECLARE @v_SqlTotal             NVARCHAR(MAX)=''

  DECLARE @v_Tmp1                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp2                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp3                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp4                 NVARCHAR(MAX)=''
  DECLARE @v_Tmp5                 NVARCHAR(MAX)=''


  DECLARE @tmp_column             NVARCHAR(MAX) = ''
  DECLARE @dbg_txt                NVARCHAR(MAX) = ''

  DECLARE @v_delimiter            NVARCHAR(1)
  DECLARE @max_loop_cnt	          INTEGER = 0
  DECLARE @mst_loop_cnt	          INTEGER = 0

  DECLARE @sub_mst_loop_cnt       INTEGER = 0
  DECLARE @sub_max_loop_cnt       INTEGER = 0
  DECLARE @sub_v_delimiter        NVARCHAR(2) = '#'
  DECLARE @sub_tmp_column         NVARCHAR(MAX) = ''
								  
  DECLARE @sub_param_0            NVARCHAR(200) = '' 
  DECLARE @sub_param_1            NVARCHAR(200) = '' 
  DECLARE @sub_param_2            NVARCHAR(200) = '' 
  DECLARE @sub_param_3            NVARCHAR(200) = '' 
  DECLARE @sub_param_4            NVARCHAR(200) = '' 

  DECLARE @p_storage_type_cnt 	  INTEGER = 0

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  
  WHILE @mst_loop_cnt < @max_loop_cnt
      BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
          SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
          SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @in_columns, @v_delimiter, @mst_loop_cnt);
          
          IF @tmp_column = '_SAVE_AUTH' 
              BEGIN
          	     SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'INSTANCE_ID' 
              BEGIN
                  SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PLAN_DATE' 
              BEGIN
                  SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PLAN_ID' 
              BEGIN
                  SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'DIVISION_ID' 
              BEGIN
                  SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'SITE_ID' 
              BEGIN
                  SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PLANT_ID' 
              BEGIN
                  SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'FACTORY_ID' 
              BEGIN
                  SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'OPERATION_ID' 
              BEGIN
                  SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'CELL_GROUP' 
              BEGIN
                 SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 

          ELSE IF @tmp_column = 'TOP_ITEM_ID' 
              BEGIN
                  SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'MODEL_NICK_NAME' 
              BEGIN
                  SET @p_model_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'ITEM_ID' 
              BEGIN
                  SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'NICK_NAME' 
              BEGIN
                  SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'PLAN_TYPE' 
              BEGIN
                  SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'IS_RESULT'
              BEGIN
                  SET @p_is_result =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'RESULT_VAL'
              BEGIN
                  SET @p_result_val =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'RESULT_VAL2'
              BEGIN
                  SET @p_result_val2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'RELEASE_FLAG'
              BEGIN
                  SET @p_release_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'AMEND_TABLE'
              BEGIN
                  SET @p_amend_table =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'BUCKET_FROM' 
              BEGIN
                 SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END  
          ELSE IF @tmp_column = 'BUCKET_TO' 
              BEGIN
                  SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'BUCKET' 
              BEGIN
                SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'DAY_INFO' 
              BEGIN
                  SET @p_day_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'WEEK_INFO' 
              BEGIN
                  SET @p_week_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);;
              END 
          ELSE IF @tmp_column = 'MONTH_INFO' 
              BEGIN
                  SET @p_month_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CATE_INFO' 
              BEGIN
                  SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = '_NON_AUTH' 
              BEGIN
          	     SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
			
			ELSE IF @tmp_column = 'ALT_MATERIAL'	BEGIN
				SET @p_alt_material =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
			END
			  
      END

	SELECT @p_storage_type_cnt = COUNT(*) 
	FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) 								
	WHERE  1=1                                 								
	AND    SEGMENT1 =''+ @p_instance_id +''     							
	AND    LOOKUP_TYPE_CODE = 'MATERIAL_SIMUL_STORAGE_TYPE'
	AND	   ACTIVE_FLAG = 'Y'	

    --BEGIN 
    --    SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date        = '''' + @p_plan_date + ''''
    --           , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id      = '''' + @p_division_id + ''''
    --           , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id         = '''' + @p_plant_id + ''''
    --           , @v_cell_group   = '''' + @p_cell_group + ''''   , @v_is_result        = '''' + @p_is_result + ''''
			   
    --           , @v_top_item_id  = '''' + @p_top_item_id + ''''  , @v_model_nick_name  = '''' + @p_model_nick_name + ''''
    --           , @v_item_id      = '''' + @p_item_id + ''''      , @v_nick_name        = '''' + @p_nick_name + ''''
    --           , @v_plan_type    = '''' + @p_plan_type + ''''    , @v_release_flag     = '''' + @p_release_flag + ''''
			 --  , @v_bucket_from  = '''' + @p_bucket_from + ''''
    --           , @v_bucket_to    = '''' + @p_bucket_to + ''''    , @v_bucket           = '''' + @p_bucket + ''''
    --           , @v_day_info     = '''' + @p_day_info + ''''     , @v_week_info        = '''' + @p_week_info + ''''
			 --  , @v_month_info   = '''' + @p_month_info + ''''   , @v_cate_info        = '''' + @p_cate_info + ''''    
			 --  , @v_user_id      = '''' + @p_user_id + ''''
			 --  , @v_amend_table  = @p_amend_table
			 --  , @v_result_val   = @p_result_val                 , @v_result_val2      = @p_result_val2
    --END
	--#MATERIAL_PLAN
	IF OBJECT_ID('tempdb..#MATERIAL_PLAN') IS NOT NULL
			DROP TABLE #MATERIAL_PLAN

	CREATE TABLE 
		      #MATERIAL_PLAN
		      (
		        	COMPANY_ID nvarchar(30) NOT NULL,
		        	DIVISION_ID nvarchar(30) NOT NULL,
		        	SITE_ID nvarchar(30) NOT NULL,
		        	PLANT_ID nvarchar(30) NOT NULL,
		        	MODEL_ID nvarchar(150) NULL,
		        	PRODUCT_ID nvarchar(150) NULL,
					OPERATION_ID nvarchar(30) NOT NULL,
					PLAN_DATE datetime NOT NULL,
					PLAN_IN_QTY numeric(25, 10) NULL DEFAULT ((0)),
					MATERIAL_ID nvarchar(150) NULL,
					BOM_RATE numeric(25, 10) NULL DEFAULT ((0)),
					MATERIAL_QTY numeric(25, 10) NULL DEFAULT ((0)),
					MATERIAL_NAME nvarchar(150) NULL,
					CLASS_NAME nvarchar(150) NULL
		      )
	
	--DROP TABLE BUF_MATERIAL_PLAN
	----TRUNCATE TABLE BUF_MATERIAL_PLAN
	--CREATE TABLE 
	--	      BUF_MATERIAL_PLAN
	--	      (
	--	        	COMPANY_ID nvarchar(30) NOT NULL,
	--	        	DIVISION_ID nvarchar(30) NOT NULL,
	--	        	SITE_ID nvarchar(30) NOT NULL,
	--	        	PLANT_ID nvarchar(30) NOT NULL,
	--				--FACTORY_ID nvarchar(30) NOT NULL,
	--	        	MODEL_ID nvarchar(150) NULL,
	--	        	PRODUCT_ID nvarchar(150) NULL,
	--				OPERATION_ID nvarchar(30) NOT NULL,
	--				PLAN_DATE datetime NOT NULL,
	--				PLAN_IN_QTY numeric(25, 10) NULL DEFAULT ((0)),
	--				MATERIAL_ID nvarchar(150) NULL,
	--				BOM_RATE numeric(25, 10) NULL DEFAULT ((0)),
	--				MATERIAL_QTY numeric(25, 10) NULL DEFAULT ((0)),
	--				MATERIAL_NAME nvarchar(150) NULL,
	--				CLASS_NAME nvarchar(150) NULL
	--	      )

	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
		BEGIN --MAIN IF

			-- Temp 생성

			SELECT @v_dSql1  = ''
            SELECT @v_dSql1 += '    WITH FP_PLAN AS (                                           ' + char(10)
            SELECT @v_dSql1 += '           SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
            SELECT @v_dSql1 += '               , TOP_ITEM_ID AS MODEL_ID, ITEM_ID AS PRODUCT_ID ' + char(10)
            SELECT @v_dSql1 += '               , OPERATION_ID, LINE_ID, PLAN_DATE               ' + char(10)
			IF(@p_release_flag = 'Y') BEGIN
                    SELECT @v_dSql1 += '               , CEILING(SUM(PLAN_IN_QTY)) AS PLAN_IN_QTY ' + char(10)
            END ELSE BEGIN
                    SELECT @v_dSql1 += '               , CEILING(SUM(IN_QTY)) AS PLAN_IN_QTY      ' + char(10)
            END
            SELECT @v_dSql1 += '           FROM 	' + TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '           WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '           AND 		A.PLAN_DATE BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''    ' + char(10)
			--SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_top_item_id)) + char(10)
			 SELECT @v_dSql1 += '           AND  EXISTS (SELECT 1                                       ' + char(10)
            SELECT @v_dSql1 += '                           FROM  FP_INSTANCE_LINE_V X WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql1 += '                           WHERE 1=1                                   ' + char(10)
            SELECT @v_dSql1 += '                           AND   X.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.COMPANY_ID   = X.COMPANY_ID         ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.SITE_ID      = X.SITE_ID            ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.DIVISION_ID  = X.DIVISION_ID        ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.FACTORY_ID   = X.FACTORY_ID         ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.OPERATION_ID = X.OPERATION_ID       ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.LINE_ID      = X.LINE_ID            ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.ELECTRODE_TYPE = X.ELECTRODE_TYPE   ' + char(10)
            SELECT @v_dSql1 += '           )                                                   ' + char(10)
            IF(@p_release_flag = 'Y') BEGIN
                    SELECT @v_dSql1 += '           AND 	A.PLAN_TYPE = ''RELEASE'' ' + char(10)
                    SELECT @v_dSql1 += '           AND 	A.PLAN_IN_QTY > 0         ' + char(10)
            END ELSE BEGIN
                    SELECT @v_dSql1 += '           AND 	A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
					SELECT @v_dSql1 += '           AND 	A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
                    SELECT @v_dSql1 += '           AND 	A.IN_QTY      > 0 ' + char(10)
            END
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))  + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))   + char(10)
                END
            SELECT @v_dSql1 += '           GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '               , TOP_ITEM_ID, ITEM_ID                 ' + char(10)
            SELECT @v_dSql1 += '               , OPERATION_ID, PLAN_DATE, LINE_ID     ' + char(10)
            SELECT @v_dSql1 += '      )                                               ' + char(10)
            SELECT @v_dSql1 += '    , MATERIAL_CLASS AS (                             ' + char(10)
            SELECT @v_dSql1 += '           SELECT SEGMENT2 AS CLASS_ID                ' + char(10)
            SELECT @v_dSql1 += '           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '           WHERE  1=1                                 ' + char(10)
            SELECT @v_dSql1 += '           AND    SEGMENT1 = '''+ @p_instance_id +'''     ' + char(10)
            SELECT @v_dSql1 += '           AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_ITEM_DEFINIT'' ' + char(10)
            SELECT @v_dSql1 += '    )                           ' + char(10)
            --SELECT @v_dSql1 += '    , SHARE_MATERIAL_PLANT AS ( ' + char(10)
            --SELECT @v_dSql1 += '           SELECT	DISTINCT A.ITEM_ID, C.DIVISION_ID, B.PLANT_ID, D.DIVISION_ID AS OTHER_DIVISION_ID, B.OTHER_PLANT_ID ' + char(10)
            --SELECT @v_dSql1 += '           FROM	FP_MRP_SUM_PROCURE_ITEM_M A WITH(NOLOCK) ' + char(10)
            --SELECT @v_dSql1 += '               , (                                       ' + char(10)
            --SELECT @v_dSql1 += '                  SELECT INSTANCE_ID, MIN(PLANT_ID) AS PLANT_ID, MAX(PLANT_ID) AS OTHER_PLANT_ID ' + char(10)
            --SELECT @v_dSql1 += '                  FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) ' + char(10)
            --SELECT @v_dSql1 += '                  WHERE  1=1                               ' + char(10)
            --SELECT @v_dSql1 += '                  GROUP BY INSTANCE_ID                     ' + char(10)
            --SELECT @v_dSql1 += '                  HAVING   MAX(PLANT_ID) != MIN(PLANT_ID)  ' + char(10)
            --SELECT @v_dSql1 += '                ) B                                        ' + char(10)
            --SELECT @v_dSql1 += '               , SCM_PLANT_M C WITH(NOLOCK)                ' + char(10)
            --SELECT @v_dSql1 += '               , SCM_PLANT_M D WITH(NOLOCK)                ' + char(10)
            --SELECT @v_dSql1 += '           WHERE	1=1                                    ' + char(10)
            --SELECT @v_dSql1 += '           AND 	B.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
            --SELECT @v_dSql1 += '           AND 	((A.PLANT_ID = B.PLANT_ID AND A.OTHER_PLANT_ID = B.OTHER_PLANT_ID) OR (A.PLANT_ID = B.OTHER_PLANT_ID AND A.OTHER_PLANT_ID = B.PLANT_ID)) ' + char(10)
            --SELECT @v_dSql1 += '           AND 	B.PLANT_ID = C.PLANT_ID        ' + char(10)
            --SELECT @v_dSql1 += '           AND 	B.OTHER_PLANT_ID = D.PLANT_ID  ' + char(10)
            --SELECT @v_dSql1 += '           AND 	A.ACTIVE_FLAG = ''Y''          ' + char(10)
            --SELECT @v_dSql1 += '    )                                          ' + char(10)
            SELECT @v_dSql1 += '    , MATERIAL_PLAN_1 AS (                     ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.*                           ' + char(10)
            SELECT @v_dSql1 += '              , ISNULL(E.NEW_ALT_ID, B.CHILD_ITEM_ID) AS MATERIAL_ID ' + char(10)
            SELECT @v_dSql1 += '              , C.ITEM_NAME AS MATERIAL_NAME   ' + char(10)
            SELECT @v_dSql1 += '              , D.CLASS_NAME                   ' + char(10)
            SELECT @v_dSql1 += '              , ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) AS BOM_RATE ' + char(10)
            SELECT @v_dSql1 += '          FROM 	FP_PLAN A WITH(NOLOCK)            ' + char(10)
            SELECT @v_dSql1 += '             , SCM_BOM_M B WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql1 += '				LEFT OUTER JOIN FP_PACK_NEW_ALT_ID E								' + char(10)
			SELECT @v_dSql1 += '				ON	1=1                                                             ' + char(10)
			SELECT @v_dSql1 += '				AND 	B.COMPANY_ID 		= E.COMPANY_ID                              ' + char(10)
			SELECT @v_dSql1 += '				AND 	B.DIVISION_ID 		= E.DIVISION_ID                         ' + char(10)
			SELECT @v_dSql1 += '				AND 	B.SITE_ID 			= E.SITE_ID                             ' + char(10)
			SELECT @v_dSql1 += '				AND 	B.PLANT_ID 			= E.PLANT_ID                            ' + char(10)
			SELECT @v_dSql1 += '				AND 	''ALT_'' + B.PARENT_ITEM_ID + ''_'' + B.ALT_ID = E.ALT_ID   ' + char(10)
            SELECT @v_dSql1 += '             , SCM_ITEM_M C WITH(NOLOCK)          ' + char(10)
            SELECT @v_dSql1 += '             , SCM_ITEM_CLASS_M D WITH(NOLOCK)    ' + char(10)
            --SELECT @v_dSql1 += '             , MATERIAL_CLASS E WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql1 += '          WHERE 1=1                               ' + char(10)
            SELECT @v_dSql1 += '          AND 	B.ACTIVE_FLAG = ''Y''             ' + char(10)
            SELECT @v_dSql1 += '          AND 	C.ACTIVE_FLAG = ''Y''             ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.COMPANY_ID   = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.DIVISION_ID  = B.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.SITE_ID      = B.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.PLANT_ID     = B.PLANT_ID       ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.PRODUCT_ID   = B.PARENT_ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.PLAN_DATE   >= B.EFF_START_DATE ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.PLAN_DATE   <  B.EFF_END_DATE   ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.COMPANY_ID    = C.COMPANY_ID    ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.DIVISION_ID   = C.DIVISION_ID   ' + char(10)
            SELECT @v_dSql1 += '          AND 	A.SITE_ID       = C.SITE_ID       ' + char(10)
            SELECT @v_dSql1 += '          AND 	B.CHILD_ITEM_ID = C.ITEM_ID       ' + char(10)
            SELECT @v_dSql1 += '          AND 	C.ITEM_CLASS = D.CLASS_ID         ' + char(10)
            --SELECT @v_dSql1 += '          AND 	D.CLASS_ID LIKE E.CLASS_ID + ''%''             ' + char(10)
            SELECT @v_dSql1 += '          AND 	(B.ALT_PRIORITY IS NULL OR B.ALT_PRIORITY = 1) ' + char(10)
            SELECT @v_dSql1 += '    )                      ' + char(10)
            SELECT @v_dSql1 += '    , MATERIAL_PLAN_2 AS ( ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
            SELECT @v_dSql1 += '              , A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID    ' + char(10)
            SELECT @v_dSql1 += '              , A.OPERATION_ID, A.LINE_ID, A.PLAN_DATE  ' + char(10)
            SELECT @v_dSql1 += '              , A.PLAN_IN_QTY, ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID) AS MATERIAL_ID ' + char(10)
            SELECT @v_dSql1 += '              , CASE WHEN B.REPLACE_ITEM_ID IS NULL THEN A.BOM_RATE            ' + char(10)
            SELECT @v_dSql1 += '                     ELSE ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) END AS BOM_RATE ' + char(10)
			SELECT @v_dSql1 += '              , A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
            SELECT @v_dSql1 += '          FROM   MATERIAL_PLAN_1 A WITH(NOLOCK)                 ' + char(10)
            SELECT @v_dSql1 += '          LEFT OUTER JOIN FP_LINE_BOM_PRIORITY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '          ON 	1=1                            ' + char(10)
            SELECT @v_dSql1 += '          AND A.PRODUCT_ID  = B.PARENT_ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '          AND A.MATERIAL_ID = B.CHILD_ITEM_ID  ' + char(10)
            SELECT @v_dSql1 += '          AND A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += '          AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += '          AND A.SITE_ID     = B.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += '          AND A.LINE_ID     = B.LINE_ID        ' + char(10)
            SELECT @v_dSql1 += '          AND A.PLAN_DATE  >= B.EFF_START_DATE ' + char(10)
            SELECT @v_dSql1 += '          AND A.PLAN_DATE  <  B.EFF_END_DATE   ' + char(10)
            SELECT @v_dSql1 += '          WHERE 1=1                            ' + char(10)
            SELECT @v_dSql1 += '    )                                          ' + char(10)
            SELECT @v_dSql1 += '          INSERT INTO #MATERIAL_PLAN                     ' + char(10)
			--SELECT @v_dSql1 += '          INSERT INTO BUF_MATERIAL_PLAN                     ' + char(10)
            SELECT @v_dSql1 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID                           ' + char(10)
			SELECT @v_dSql1 += '				, A.OPERATION_ID, A.PLAN_DATE, A.PLAN_IN_QTY, A.MATERIAL_ID, A.BOM_RATE, A.MATERIAL_QTY                           ' + char(10)
			SELECT @v_dSql1 += '				, A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
            SELECT @v_dSql1 += '				--, C.ITEM_NAME AS MATERIAL_NAME, D.CLASS_NAME ' + char(10)
            SELECT @v_dSql1 += '          FROM (                     ' + char(10)
            SELECT @v_dSql1 += '          		SELECT A.COMPANY_ID  ' + char(10)
            SELECT @v_dSql1 += '                    , A.DIVISION_ID  ' + char(10)
            SELECT @v_dSql1 += '                    , A.SITE_ID      ' + char(10)
            SELECT @v_dSql1 += '                    , A.PLANT_ID     ' + char(10)
            SELECT @v_dSql1 += '                    , A.MODEL_ID     ' + char(10)
            SELECT @v_dSql1 += '                    , A.PRODUCT_ID   ' + char(10)
            SELECT @v_dSql1 += '                    , A.OPERATION_ID ' + char(10)
            SELECT @v_dSql1 += '                    , A.PLAN_DATE    ' + char(10)
            SELECT @v_dSql1 += '                    , SUM(A.PLAN_IN_QTY) AS PLAN_IN_QTY                         ' + char(10)
            SELECT @v_dSql1 += '                    , ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID) AS MATERIAL_ID   ' + char(10)
            SELECT @v_dSql1 += '                    , CASE WHEN B.REPLACE_ITEM_ID IS NULL THEN A.BOM_RATE       ' + char(10)
            SELECT @v_dSql1 += '                      ELSE ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) END AS BOM_RATE ' + char(10)
            SELECT @v_dSql1 += '                    , SUM(A.PLAN_IN_QTY) * CASE WHEN B.REPLACE_ITEM_ID IS NULL THEN A.BOM_RATE ' + char(10)
            SELECT @v_dSql1 += '                         ELSE ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) END AS MATERIAL_QTY         ' + char(10)
			SELECT @v_dSql1 += '					, A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
            SELECT @v_dSql1 += '          		FROM 	MATERIAL_PLAN_2 A WITH(NOLOCK)                    ' + char(10)
            SELECT @v_dSql1 += '          		LEFT OUTER HASH JOIN FP_MRP_BOM_PRIORITY_M B WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '          		ON 	1=1                              ' + char(10)
            SELECT @v_dSql1 += '          		AND A.PRODUCT_ID  = B.PARENT_ITEM_ID ' + char(10)
            SELECT @v_dSql1 += '          		AND A.MATERIAL_ID = B.CHILD_ITEM_ID  ' + char(10)
            SELECT @v_dSql1 += '          		AND A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
            SELECT @v_dSql1 += '          		AND A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
            SELECT @v_dSql1 += '          		AND A.SITE_ID     = B.SITE_ID        ' + char(10)
            SELECT @v_dSql1 += '          		AND A.PLAN_DATE  >= B.EFF_START_DATE ' + char(10)
            SELECT @v_dSql1 += '          		AND A.PLAN_DATE  <  B.EFF_END_DATE   ' + char(10)
            SELECT @v_dSql1 += '          		WHERE 1=1                            ' + char(10)
            SELECT @v_dSql1 += '          		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID           ' + char(10)
            SELECT @v_dSql1 += '                    , A.PLANT_ID, A.MODEL_ID, A.PRODUCT_ID                ' + char(10)
            SELECT @v_dSql1 += '                    , A.OPERATION_ID, A.PLAN_DATE                         ' + char(10)
			SELECT @v_dSql1 += '					, A.MATERIAL_NAME, A.CLASS_NAME ' + char(10)
            SELECT @v_dSql1 += '                    , ISNULL(B.REPLACE_ITEM_ID, A.MATERIAL_ID)            ' + char(10)
            SELECT @v_dSql1 += '                    , CASE WHEN B.REPLACE_ITEM_ID IS NULL THEN A.BOM_RATE ' + char(10) 
            SELECT @v_dSql1 += '                      ELSE ROUND(B.CHILD_QTY / B.PARENT_QTY, 4) END       ' + char(10)
            SELECT @v_dSql1 += '          ) A                                 ' + char(10)
            --SELECT @v_dSql1 += '          , SCM_ITEM_M C WITH(NOLOCK)         ' + char(10)
            --SELECT @v_dSql1 += '          , SCM_ITEM_CLASS_M D WITH(NOLOCK)   ' + char(10)
            --SELECT @v_dSql1 += '          WHERE 1=1                           ' + char(10)
            --SELECT @v_dSql1 += '          AND 	A.COMPANY_ID  = C.COMPANY_ID  ' + char(10)
            --SELECT @v_dSql1 += '          AND 	A.DIVISION_ID = C.DIVISION_ID ' + char(10)
            --SELECT @v_dSql1 += '          AND 	A.SITE_ID     = C.SITE_ID     ' + char(10)
            --SELECT @v_dSql1 += '          AND 	A.MATERIAL_ID = C.ITEM_ID     ' + char(10)
            --SELECT @v_dSql1 += '          AND 	C.ITEM_CLASS  = D.CLASS_ID    ' + char(10)
           
		    EXEC sp_executesql @v_dSql1 -- temp table create

			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql1,'TEMP',@runstart, @runend

			SELECT @v_dSql1  = ''
            SELECT @v_dSql1 += '    WITH FP_PLAN AS (                                           ' + char(10)
            SELECT @v_dSql1 += '           SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID    ' + char(10)
            SELECT @v_dSql1 += '               , TOP_ITEM_ID AS MODEL_ID, ITEM_ID AS PRODUCT_ID ' + char(10)
            SELECT @v_dSql1 += '               , OPERATION_ID, LINE_ID, PLAN_DATE               ' + char(10)
			IF(@p_release_flag = 'Y') BEGIN
                    SELECT @v_dSql1 += '               , CEILING(SUM(PLAN_IN_QTY)) AS PLAN_IN_QTY ' + char(10)
            END ELSE BEGIN
                    SELECT @v_dSql1 += '               , CEILING(SUM(IN_QTY)) AS PLAN_IN_QTY      ' + char(10)
            END
            SELECT @v_dSql1 += '           FROM 	' + TRY_CONVERT(NVARCHAR, @p_amend_table) +' A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '           WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '           AND 		A.PLAN_DATE BETWEEN '''+ @p_plan_date +''' AND '''+ @p_bucket_to +'''    ' + char(10)
			--SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'EQ', @p_top_item_id)) + char(10)
			 SELECT @v_dSql1 += '           AND  EXISTS (SELECT 1                                       ' + char(10)
            SELECT @v_dSql1 += '                           FROM  FP_INSTANCE_LINE_V X WITH(NOLOCK)     ' + char(10)
            SELECT @v_dSql1 += '                           WHERE 1=1                                   ' + char(10)
            SELECT @v_dSql1 += '                           AND   X.INSTANCE_ID  = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.COMPANY_ID   = X.COMPANY_ID         ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.SITE_ID      = X.SITE_ID            ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.DIVISION_ID  = X.DIVISION_ID        ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.FACTORY_ID   = X.FACTORY_ID         ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.OPERATION_ID = X.OPERATION_ID       ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.LINE_ID      = X.LINE_ID            ' + char(10)
            SELECT @v_dSql1 += '                           AND   A.ELECTRODE_TYPE = X.ELECTRODE_TYPE   ' + char(10)
            SELECT @v_dSql1 += '           )                                                   ' + char(10)
            IF(@p_release_flag = 'Y') BEGIN
                    SELECT @v_dSql1 += '           AND 	A.PLAN_TYPE = ''RELEASE'' ' + char(10)
                    SELECT @v_dSql1 += '           AND 	A.PLAN_IN_QTY > 0         ' + char(10)
            END ELSE BEGIN
                    SELECT @v_dSql1 += '           AND 	A.INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
					SELECT @v_dSql1 += '           AND 	A.FP_PLAN_ID  = '''+ @p_plan_id +'''     ' + char(10)
                    SELECT @v_dSql1 += '           AND 	A.IN_QTY      > 0 ' + char(10)
            END
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))  + char(10)
            SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))     + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
            IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))   + char(10)
                END
            SELECT @v_dSql1 += '           GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '               , TOP_ITEM_ID, ITEM_ID                 ' + char(10)
            SELECT @v_dSql1 += '               , OPERATION_ID, PLAN_DATE, LINE_ID     ' + char(10)
            SELECT @v_dSql1 += '      )                                               ' + char(10)
            SELECT @v_dSql1 += '    , MATERIAL_CLASS AS (                             ' + char(10)
            SELECT @v_dSql1 += '           SELECT SEGMENT2 AS CLASS_ID                ' + char(10)
            SELECT @v_dSql1 += '           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '           WHERE  1=1                                 ' + char(10)
            SELECT @v_dSql1 += '           AND    SEGMENT1 = '''+ @p_instance_id +'''     ' + char(10)
            SELECT @v_dSql1 += '           AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_ITEM_DEFINIT'' ' + char(10)
            SELECT @v_dSql1 += '    )                           ' + char(10)
            SELECT @v_dSql1 += '    , SHARE_MATERIAL_PLANT AS ( ' + char(10)
            SELECT @v_dSql1 += '           SELECT	DISTINCT A.ITEM_ID, C.DIVISION_ID, B.PLANT_ID, D.DIVISION_ID AS OTHER_DIVISION_ID, B.OTHER_PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '           FROM	FP_MRP_SUM_PROCURE_ITEM_M A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '               , (                                       ' + char(10)
            SELECT @v_dSql1 += '                  SELECT INSTANCE_ID, MIN(PLANT_ID) AS PLANT_ID, MAX(PLANT_ID) AS OTHER_PLANT_ID ' + char(10)
            SELECT @v_dSql1 += '                  FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql1 += '                  WHERE  1=1                               ' + char(10)
            SELECT @v_dSql1 += '                  GROUP BY INSTANCE_ID                     ' + char(10)
            SELECT @v_dSql1 += '                  HAVING   MAX(PLANT_ID) != MIN(PLANT_ID)  ' + char(10)
            SELECT @v_dSql1 += '                ) B                                        ' + char(10)
            SELECT @v_dSql1 += '               , SCM_PLANT_M C WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql1 += '               , SCM_PLANT_M D WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql1 += '           WHERE	1=1                                    ' + char(10)
            SELECT @v_dSql1 += '           AND 	B.INSTANCE_ID = '''+ @p_instance_id +'''       ' + char(10)
            SELECT @v_dSql1 += '           AND 	((A.PLANT_ID = B.PLANT_ID AND A.OTHER_PLANT_ID = B.OTHER_PLANT_ID) OR (A.PLANT_ID = B.OTHER_PLANT_ID AND A.OTHER_PLANT_ID = B.PLANT_ID)) ' + char(10)
            SELECT @v_dSql1 += '           AND 	B.PLANT_ID = C.PLANT_ID        ' + char(10)
            SELECT @v_dSql1 += '           AND 	B.OTHER_PLANT_ID = D.PLANT_ID  ' + char(10)
            SELECT @v_dSql1 += '           AND 	A.ACTIVE_FLAG = ''Y''          ' + char(10)
            SELECT @v_dSql1 += '    )                                          ' + char(10)
            SELECT @v_dSql1 += '    , MATERIAL_BOH_1 AS (                     ' + char(10)
            
			IF @p_storage_type_cnt > 0 BEGIN
				SELECT @v_dSql1 += '          SELECT A.COMPANY_ID                 ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(F.DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID ' + char(10)
				SELECT @v_dSql1 += '          	 , A.SITE_ID                                  ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(F.PLANT_ID, A.PLANT_ID) AS PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '          	 , A.ITEM_ID AS MATERIAL_ID                   ' + char(10)
				SELECT @v_dSql1 += '          	 , CEILING(ISNULL(SUM(CASE WHEN G.BOH_TYPE = ''MATERIAL'' THEN A.QTY END),0)) AS LWH_BOH -- 물류 창고 ' + char(10)
				SELECT @v_dSql1 += '          	 , CEILING(ISNULL(SUM(CASE WHEN G.BOH_TYPE = ''PRODUCTION'' THEN A.QTY END),0)) AS PWH_BOH -- 생산 창고 ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(SUM(A.QTY),0) AS M_BOH ' + char(10)
				SELECT @v_dSql1 += '          FROM   FP_MRP_CUTOFF_SUPPLY_H A WITH(NOLOCK) -- 공급 정보를 MRP 재고 기준으로 변경... 20210819  ' + char(10)
				SELECT @v_dSql1 += '          LEFT OUTER JOIN SHARE_MATERIAL_PLANT F WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql1 += '          ON 	1=1                         ' + char(10)
				SELECT @v_dSql1 += '          AND A.ITEM_ID  = F.ITEM_ID        ' + char(10)
				SELECT @v_dSql1 += '          AND A.PLANT_ID = F.OTHER_PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '          INNER JOIN (																			' + char(10)
				SELECT @v_dSql1 += '				SELECT SEGMENT2 AS BOH_TYPE, SEGMENT3 AS SUPPLY_TYPE, SEGMENT4 AS STORAGE_ID        	' + char(10)
				SELECT @v_dSql1 += '				FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) 											' + char(10)
				SELECT @v_dSql1 += '				WHERE  1=1                                 											' + char(10)
				SELECT @v_dSql1 += '				AND    SEGMENT1 = '''+ @p_instance_id +'''     										' + char(10)
				SELECT @v_dSql1 += '				AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_STORAGE_TYPE'' 							' + char(10)
				SELECT @v_dSql1 += '				AND ACTIVE_FLAG = ''Y''																' + char(10)
				SELECT @v_dSql1 += '          ) G																					' + char(10)
				SELECT @v_dSql1 += '          ON 1=1																				' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SUPPLY_TYPE = G.SUPPLY_TYPE													' + char(10)
				SELECT @v_dSql1 += '          AND 	A.STORAGE_ID = G.STORAGE_ID				' + char(10)
				SELECT @v_dSql1 += '          , SCM_ITEM_M B WITH(NOLOCK)       ' + char(10)
				SELECT @v_dSql1 += '          , SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
				--SELECT @v_dSql1 += '          , MATERIAL_CLASS D WITH(NOLOCK)   ' + char(10)
				SELECT @v_dSql1 += '          , (                               ' + char(10)
				SELECT @v_dSql1 += '              SELECT DISTINCT INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '              FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)  ' + char(10)
				SELECT @v_dSql1 += '              WHERE  1=1                                ' + char(10)
				SELECT @v_dSql1 += '              AND    INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
				SELECT @v_dSql1 += '          ) E                                           ' + char(10)
				SELECT @v_dSql1 += '          WHERE 1=1                                     ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.DIVISION_ID = E.DIVISION_ID      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SITE_ID     = E.SITE_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.PLANT_ID    = E.PLANT_ID         ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.COMPANY_ID  = B.COMPANY_ID       ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.DIVISION_ID = B.DIVISION_ID      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SITE_ID     = B.SITE_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.ITEM_ID     = B.ITEM_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	B.ITEM_CLASS  = C.CLASS_ID         ' + char(10)
				--SELECT @v_dSql1 += '          AND 	C.CLASS_ID LIKE D.CLASS_ID + ''%'' ' + char(10)
				SELECT @v_dSql1 += '          GROUP BY A.COMPANY_ID, ISNULL(F.DIVISION_ID, A.DIVISION_ID) ' + char(10)
				SELECT @v_dSql1 += '              , A.SITE_ID, ISNULL(F.PLANT_ID,A.PLANT_ID), A.ITEM_ID   ' + char(10)
			END ELSE BEGIN
				SELECT @v_dSql1 += '          SELECT A.COMPANY_ID                 ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(F.DIVISION_ID, A.DIVISION_ID) AS DIVISION_ID ' + char(10)
				SELECT @v_dSql1 += '          	 , A.SITE_ID                                  ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(F.PLANT_ID, A.PLANT_ID) AS PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '          	 , A.ITEM_ID AS MATERIAL_ID                   ' + char(10)
				SELECT @v_dSql1 += '          	 , CEILING(ISNULL(SUM(CASE WHEN LEFT(A.STORAGE_ID,1) = ''1'' THEN A.QTY END),0)) AS LWH_BOH -- 물류 창고 ' + char(10)
				SELECT @v_dSql1 += '          	 , CEILING(ISNULL(SUM(CASE WHEN LEFT(A.STORAGE_ID,1) = ''2'' THEN A.QTY END),0)) AS PWH_BOH -- 생산 창고 ' + char(10)
				SELECT @v_dSql1 += '          	 , ISNULL(SUM(A.QTY),0) AS M_BOH ' + char(10)
				SELECT @v_dSql1 += '          FROM   FP_MRP_CUTOFF_SUPPLY_H A WITH(NOLOCK) -- 공급 정보를 MRP 재고 기준으로 변경... 20210819  ' + char(10)
				SELECT @v_dSql1 += '          LEFT OUTER JOIN SHARE_MATERIAL_PLANT F WITH(NOLOCK) ' + char(10)
				SELECT @v_dSql1 += '          ON 	1=1                         ' + char(10)
				SELECT @v_dSql1 += '          AND A.ITEM_ID  = F.ITEM_ID        ' + char(10)
				SELECT @v_dSql1 += '          AND A.PLANT_ID = F.OTHER_PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '          , SCM_ITEM_M B WITH(NOLOCK)       ' + char(10)
				SELECT @v_dSql1 += '          , SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
				--SELECT @v_dSql1 += '          , MATERIAL_CLASS D WITH(NOLOCK)   ' + char(10)
				SELECT @v_dSql1 += '          , (                               ' + char(10)
				SELECT @v_dSql1 += '              SELECT DISTINCT INSTANCE_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
				SELECT @v_dSql1 += '              FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)  ' + char(10)
				SELECT @v_dSql1 += '              WHERE  1=1                                ' + char(10)
				SELECT @v_dSql1 += '              AND    INSTANCE_ID = '''+ @p_instance_id +''' ' + char(10)
				SELECT @v_dSql1 += '          ) E                                           ' + char(10)
				SELECT @v_dSql1 += '          WHERE 1=1                                     ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''')      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SUPPLY_TYPE = ''STOCK''           ' + char(10)
				SELECT @v_dSql1 += '          AND 	(LEFT(A.STORAGE_ID,1) = ''1'' OR LEFT(A.STORAGE_ID,1) = ''2'') ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.DIVISION_ID = E.DIVISION_ID      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SITE_ID     = E.SITE_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.PLANT_ID    = E.PLANT_ID         ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.COMPANY_ID  = B.COMPANY_ID       ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.DIVISION_ID = B.DIVISION_ID      ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.SITE_ID     = B.SITE_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	A.ITEM_ID     = B.ITEM_ID          ' + char(10)
				SELECT @v_dSql1 += '          AND 	B.ITEM_CLASS  = C.CLASS_ID         ' + char(10)
				--SELECT @v_dSql1 += '          AND 	C.CLASS_ID LIKE D.CLASS_ID + ''%'' ' + char(10)
				SELECT @v_dSql1 += '          GROUP BY A.COMPANY_ID, ISNULL(F.DIVISION_ID, A.DIVISION_ID) ' + char(10)
				SELECT @v_dSql1 += '              , A.SITE_ID, ISNULL(F.PLANT_ID,A.PLANT_ID), A.ITEM_ID   ' + char(10)
			END

            
			
			SELECT @v_dSql1 += '    ) ' + char(10)
			
			SELECT @v_dSql2  = ''
			SELECT @v_dSql2 += '	, MATERIAL_BOH_2 AS (  																																							' + char(10)
			SELECT @v_dSql2 += '			SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID AS MATERIAL_ID, SUM(B.LWH_BOH) AS LWH_BOH, SUM(B.PWH_BOH) AS PWH_BOH, SUM(B.M_BOH) AS M_BOH    ' + char(10)
			SELECT @v_dSql2 += '			FROM 	FP_PACK_ALT_MATERIAL_DEFINIT A WITH(NOLOCK)                                                                                                                                  ' + char(10)
			SELECT @v_dSql2 += '						LEFT OUTER JOIN MATERIAL_BOH_1 B                                                                                                                            ' + char(10)
			SELECT @v_dSql2 += '						ON 	1=1                                                                                                                                                     ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.COMPANY_ID = B.COMPANY_ID                                                                                                                         ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.DIVISION_ID = B.DIVISION_ID                                                                                                                       ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.SITE_ID = B.SITE_ID                                                                                                                               ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.PLANT_ID = B.PLANT_ID                                                                                                                             ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.MATERIAL_ID = B.MATERIAL_ID			                                                                                                            ' + char(10)
			SELECT @v_dSql2 += '			WHERE 	1=1                                                                                                                                                             ' + char(10)
			SELECT @v_dSql2 += '			AND 		B.M_BOH IS NOT NULL                                                                                                                                         ' + char(10)
			SELECT @v_dSql2 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID                                                                                               ' + char(10)
			SELECT @v_dSql2 += '		)                                                                                                                                                                           ' + char(10)
            SELECT @v_dSql2 += '    , MATERIAL_BOH AS (        ' + char(10)
            SELECT @v_dSql2 += '          SELECT *             ' + char(10)
            SELECT @v_dSql2 += '          FROM 	MATERIAL_BOH_1 ' + char(10)
            SELECT @v_dSql2 += '          UNION ALL            ' + char(10)
			SELECT @v_dSql2 += '          SELECT *             ' + char(10)
            SELECT @v_dSql2 += '          FROM 	MATERIAL_BOH_2 ' + char(10)
            SELECT @v_dSql2 += '          UNION ALL            ' + char(10)
            SELECT @v_dSql2 += '          SELECT A.COMPANY_ID, B.OTHER_DIVISION_ID, A.SITE_ID, B.OTHER_PLANT_ID, A.MATERIAL_ID, A.LWH_BOH, A.PWH_BOH, A.M_BOH ' + char(10)
            SELECT @v_dSql2 += '          FROM 	 MATERIAL_BOH_1 A, SHARE_MATERIAL_PLANT B ' + char(10)
            SELECT @v_dSql2 += '          WHERE  1=1                                ' + char(10)
            SELECT @v_dSql2 += '          AND 	 A.MATERIAL_ID = B.ITEM_ID          ' + char(10)
            SELECT @v_dSql2 += '    )                                               ' + char(10)
            SELECT @v_dSql2 += '    , MATERIAL_SUM_QTY_1 AS (                       ' + char(10)
            SELECT @v_dSql2 += '            SELECT ISNULL(B.PLANT_ID,A.PLANT_ID) AS PLANT_ID, A.MATERIAL_ID, A.PLAN_DATE, SUM(A.MATERIAL_QTY) AS MATERIAL_QTY ' + char(10)
            SELECT @v_dSql2 += '            FROM   #MATERIAL_PLAN A                  ' + char(10)
			--SELECT @v_dSql2 += '            FROM   BUF_MATERIAL_PLAN A                  ' + char(10)
            SELECT @v_dSql2 += '            LEFT OUTER JOIN SHARE_MATERIAL_PLANT B  ' + char(10)
            SELECT @v_dSql2 += '            ON 	1=1                                 ' + char(10)
            SELECT @v_dSql2 += '            AND A.MATERIAL_ID = B.ITEM_ID           ' + char(10)
            SELECT @v_dSql2 += '            AND A.PLANT_ID    = B.OTHER_PLANT_ID    ' + char(10)
            SELECT @v_dSql2 += '            WHERE 1=1                               ' + char(10)
            SELECT @v_dSql2 += '            GROUP BY ISNULL(B.PLANT_ID, A.PLANT_ID), A.MATERIAL_ID, A.PLAN_DATE ' + char(10)
            SELECT @v_dSql2 += '    )                                               ' + char(10)
            SELECT @v_dSql2 += '    , MATERIAL_SUM_QTY AS (                         ' + char(10)
            SELECT @v_dSql2 += '            SELECT *                                ' + char(10)
            SELECT @v_dSql2 += '            FROM 	 MATERIAL_SUM_QTY_1             ' + char(10)
            SELECT @v_dSql2 += '            UNION ALL                               ' + char(10)
            SELECT @v_dSql2 += '            SELECT B.OTHER_PLANT_ID AS PLANT_ID, A.MATERIAL_ID, A.PLAN_DATE, A.MATERIAL_QTY ' + char(10)
            SELECT @v_dSql2 += '            FROM 	 MATERIAL_SUM_QTY_1 A, SHARE_MATERIAL_PLANT B ' + char(10)
            SELECT @v_dSql2 += '            WHERE  1=1                      ' + char(10)
            SELECT @v_dSql2 += '            AND   A.MATERIAL_ID = B.ITEM_ID ' + char(10)
            SELECT @v_dSql2 += '      )                                     ' + char(10)
            SELECT @v_dSql2 += '    , MATERIAL_IN_QTY_1 AS (                  ' + char(10)
            SELECT @v_dSql2 += '            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.AVAILABLE_DATE, SUM(A.QTY) AS IN_QTY ' + char(10)
            SELECT @v_dSql2 += '            FROM   FP_MRP_CUTOFF_SUPPLY_H A WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '            WHERE  1=1 ' + char(10)
            SELECT @v_dSql2 += '            AND    A.CUTOFF_DATE = CONVERT(DATETIME,'''+ @p_plan_date +''') ' + char(10)
            SELECT @v_dSql2 += '            AND    (A.SUPPLY_TYPE = ''SUPPLY_PLAN'' OR (A.SUPPLY_TYPE= ''STOCK'' AND A.STORAGE_ID IS NULL)) -- 공급 정보에 이동 중 재고 수량 포함... 20210819                      ' + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))        + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))           + char(10)
            
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
                END

            SELECT @v_dSql2 += '            AND    A.AVAILABLE_DATE >= CONVERT(DATETIME,'''+ @p_plan_date +''')                          ' + char(10)
            SELECT @v_dSql2 += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.AVAILABLE_DATE ' + char(10)
            SELECT @v_dSql2 += '    )          ' + char(10)
			SELECT @v_dSql2 += '	, MATERIAL_IN_QTY_2 AS (    																												' + char(10)	
			SELECT @v_dSql2 += '		    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID AS ITEM_ID, B.AVAILABLE_DATE, SUM(B.IN_QTY) AS IN_QTY      ' + char(10)
			SELECT @v_dSql2 += '		    FROM 	FP_PACK_ALT_MATERIAL_DEFINIT A WITH(NOLOCK)                                                                                 ' + char(10)
			--SELECT @v_dSql2 += '		    			LEFT OUTER JOIN MATERIAL_IN_QTY_1 B                                                                                     ' + char(10)
			SELECT @v_dSql2 += '		    			INNER JOIN MATERIAL_IN_QTY_1 B                                                                                     ' + char(10)
			SELECT @v_dSql2 += '						ON 	1=1                                                                                                                 ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.COMPANY_ID = B.COMPANY_ID                                                                                     ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.DIVISION_ID = B.DIVISION_ID                                                                                   ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.SITE_ID = B.SITE_ID                                                                                           ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.PLANT_ID = B.PLANT_ID                                                                                         ' + char(10)
			SELECT @v_dSql2 += '						AND 	A.MATERIAL_ID = B.ITEM_ID	                                                                                    ' + char(10)
			SELECT @v_dSql2 += '			WHERE 	1=1                                                                                                                         ' + char(10)
			SELECT @v_dSql2 += '			AND 		IN_QTY IS NOT NULL                                                                                                      ' + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' ,  'EQ', @p_division_id))        + char(10)
            SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' ,     'EQ', @p_plant_id))           + char(10)
            
			IF(LEN(@p_site_id) > 0)
			    BEGIN
			        SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))         + char(10)
                END

            SELECT @v_dSql2 += '		    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.NEW_ALT_ID, B.AVAILABLE_DATE			                                ' + char(10)
			SELECT @v_dSql2 += '	)                                                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '	, MATERIAL_IN_QTY AS (                                                                                                                      ' + char(10)
			SELECT @v_dSql2 += '			SELECT 	*                                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '			FROM 	MATERIAL_IN_QTY_1                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '			UNION ALL                                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '			SELECT 	*                                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '			FROM 	MATERIAL_IN_QTY_2                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '	)                                                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '    SELECT A.* ' + char(10)
			SELECT @v_dSql2 += '    FROM   ( ' + char(10)
            SELECT @v_dSql2 += '    SELECT A.* ' + char(10)
            SELECT @v_dSql2 += '        , (CASE WHEN A.ALT_TYPE = ''SUB'' THEN '''' WHEN A.IS_RESULT = ''1'' THEN ''Shortage!'' WHEN A.IS_RESULT = ''2'' THEN ''OK(Mat.+Prod. storage)'' ELSE ''OK(Only Mat. storage)'' END) AS IS_RESULT_NAME ' + char(10)
            SELECT @v_dSql2 += '        , (CASE WHEN A.ALT_TYPE = ''SUB'' THEN '''' WHEN A.IS_RESULT = ''1'' THEN ''red'' WHEN A.IS_RESULT = ''2'' THEN ''orange'' ELSE ''green'' END) AS IS_RESULT_COLOR ' + char(10)
            SELECT @v_dSql2 += '        , '''' AS SHORTAGE_DATE -- shortage 발생 최초 일자 : UI 에서 검색 ' + char(10)
			SELECT @v_dSql2 += '        , '''' AS PROD_SHORTAGE_DATE -- prod shortage 발생 최초 일자 : UI 에서 검색 ' + char(10)
            SELECT @v_dSql2 += '        , DENSE_RANK() OVER (ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MATERIAL_ID) AS MATERIAL_RANK ' + char(10)
			SELECT @v_dSql2 += '        , MAX(IS_RESULT) OVER ( PARTITION BY A.PLANT_ID, A.CELL_GROUP, A.PRODUCT_ID, A.MATERIAL_NAME) AS IS_RESULT2 ' + char(10)
            SELECT @v_dSql2 += '    FROM (                          ' + char(10)
            SELECT @v_dSql2 += '          SELECT A.*                ' + char(10)
            SELECT @v_dSql2 += '               -- 계획일자부터 체크 ' + char(10)
			SELECT @v_dSql2 += '               , (CASE WHEN A.ALT_TYPE = ''SUB'' THEN ''0''   ' + char(10)
            SELECT @v_dSql2 += '					   WHEN '+ TRY_CONVERT(NVARCHAR(MAX), @p_result_val) +' THEN ''1''   ' + char(10)
            SELECT @v_dSql2 += '                       WHEN '+ TRY_CONVERT(NVARCHAR(MAX), @p_result_val2) +' THEN ''2''  ' + char(10)
            SELECT @v_dSql2 += '                       ELSE ''3'' END) AS IS_RESULT                                 ' + char(10)
            SELECT @v_dSql2 += '          FROM (                                                                    ' + char(10)
            SELECT @v_dSql2 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID           ' + char(10)
            SELECT @v_dSql2 += '                    , ISNULL(J.CELL_GROUP, ISNULL(F.PACK_PRODUCT_GROUP_CODE, ''-'')) AS CELL_GROUP -- cell group 정보가 null 이면, model의 PACK_PRODUCT_GROUP_CODE, 그것도 null 이면 "-" ' + char(10)
            SELECT @v_dSql2 += '                    , A.MODEL_ID, F.NICK_NAME AS MODEL_NICK_NAME                    ' + char(10)
            SELECT @v_dSql2 += '                    , A.OPERATION_ID, E.OPERATION_NAME, A.PRODUCT_ID ' + char(10)
			SELECT @v_dSql2 += '                    , CASE WHEN A.ALT_TYPE = ''SUB'' THEN ''....'' + A.MATERIAL_ID ELSE A.MATERIAL_ID END AS MATERIAL_ID , A.ALT_ID, A.ALT_TYPE ' + char(10)
            SELECT @v_dSql2 += '                    , A.MATERIAL_NAME, A.CLASS_NAME, TRY_CONVERT(Float, A.BOM_RATE) AS BOM_RATE ' + char(10)
            SELECT @v_dSql2 += '                    , A.LWH_BOH, A.PWH_BOH                                          ' + char(10)
            SELECT @v_dSql2 += '                    -- Plan(In), 자재 소요량, 자재 입고, Logstic Inventory          ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
				IF @max_loop_cnt > 0 BEGIN
        			  -- bucket
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp3       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @mst_loop_cnt     =  @mst_loop_cnt +1
                              SET @tmp_column       = ''
                              SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
                              SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                              
                              SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => AS IS_PLAN
                              SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => 'D0~D31'  AS D_VALUE
                              SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 =>  YYYYMMDD AS _DATE
                              --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => ISO_YYYYWW AS _WEEK
                              --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => MONTH AS _MONTH 
							  SET @v_Tmp3 += '                    , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_2 + ''' THEN A.PLAN_IN_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +'_QTY ' + char(10)
                              SET @v_Tmp3 += '                    , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_2 + ''' THEN A.MATERIAL_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +'_MATQTY ' + char(10)
                              SET @v_Tmp3 += '                    , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @sub_param_2 + ''' THEN A.IN_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +'_MATINQTY ' + char(10)
                              SET @v_Tmp3 += '                    , SUM(CASE WHEN (CONVERT(VARCHAR,A.PLAN_DATE,112)>=''' + @p_plan_date + ''' AND CONVERT(VARCHAR,A.PLAN_DATE,112)<=''' + @sub_param_2 + ''') THEN A.EOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +'_EOHQTY ' + char(10)
                              SET @v_Tmp3 += '                    , SUM(CASE WHEN (CONVERT(VARCHAR,A.PLAN_DATE,112)>=''' + @p_plan_date + ''' AND CONVERT(VARCHAR,A.PLAN_DATE,112)<=''' + @sub_param_2 + ''') THEN A.EOH2_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +'_EOH2QTY ' + char(10)

        				  END
				END 
			END

			SELECT @v_dSql2  +=  @v_Tmp3

            SELECT @v_dSql2 += '                    , D.CLASS_ID, D.SORT_ORDER, D.KEY_YN ' + char(10)
            SELECT @v_dSql2 += '                FROM (                         ' + char(10)
            SELECT @v_dSql2 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID ' + char(10)
            SELECT @v_dSql2 += '                          , A.OPERATION_ID, A.PRODUCT_ID, A.MATERIAL_ID, A.PLAN_DATE        ' + char(10)
            SELECT @v_dSql2 += '                          , A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE                       ' + char(10)
			SELECT @v_dSql2 += '                          , A.ALT_ID                       ' + char(10)
			SELECT @v_dSql2 += '                          , ''MAIN'' AS ALT_TYPE                       ' + char(10)
			SELECT @v_dSql2 += '                          , ISNULL(B.LWH_BOH,0) AS LWH_BOH, ISNULL(B.PWH_BOH,0) AS PWH_BOH  ' + char(10)
            SELECT @v_dSql2 += '                          , A.PLAN_IN_QTY  ' + char(10)
            SELECT @v_dSql2 += '                          , A.MATERIAL_QTY ' + char(10)
            SELECT @v_dSql2 += '                          , D.IN_QTY       ' + char(10)
            SELECT @v_dSql2 += '                          , (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @p_plan_date +''' THEN ISNULL(B.LWH_BOH,0) ELSE 0 END) + ISNULL(D.IN_QTY,0) - ISNULL(C.MATERIAL_QTY,0) AS EOH_QTY ' + char(10)
            SELECT @v_dSql2 += '                          , (CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @p_plan_date +''' THEN ISNULL(B.LWH_BOH,0) + ISNULL(B.PWH_BOH,0) ELSE 0 END) + ISNULL(D.IN_QTY,0) - ISNULL(C.MATERIAL_QTY,0) AS EOH2_QTY ' + char(10)
            SELECT @v_dSql2 += '                      FROM (               ' + char(10)
            SELECT @v_dSql2 += '								SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.OPERATION_ID, A.PRODUCT_ID, A.MATERIAL_ID ' + char(10)
            SELECT @v_dSql2 += '								    , E.DT AS PLAN_DATE, A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE, CASE WHEN A.MATERIAL_ID LIKE ''ALT%'' THEN A.MATERIAL_ID ELSE ''-'' END AS ALT_ID                     ' + char(10)
            SELECT @v_dSql2 += '								    , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.PLAN_IN_QTY ELSE 0 END) AS PLAN_IN_QTY   ' + char(10)
            SELECT @v_dSql2 += '								    , SUM(CASE WHEN A.PLAN_DATE = E.DT THEN A.MATERIAL_QTY ELSE 0 END) AS MATERIAL_QTY ' + char(10)
            SELECT @v_dSql2 += '								FROM   #MATERIAL_PLAN A WITH(NOLOCK)    ' + char(10)
			--SELECT @v_dSql2 += '								FROM   BUF_MATERIAL_PLAN A WITH(NOLOCK)    ' + char(10)
            SELECT @v_dSql2 += '									LEFT OUTER JOIN (                      ' + char(10)
            SELECT @v_dSql2 += '									      SELECT *                         ' + char(10)
            SELECT @v_dSql2 += '									      FROM   TH_UIS_CAL E WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '									      WHERE  E.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''     ' + char(10)
            SELECT @v_dSql2 += '									) E     ' + char(10)
            SELECT @v_dSql2 += '									ON  1=1 ' + char(10)
            SELECT @v_dSql2 += '								GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.OPERATION_ID ' + char(10)
            SELECT @v_dSql2 += '								   	, A.PRODUCT_ID, A.MATERIAL_ID, E.DT, A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE      ' + char(10)
            SELECT @v_dSql2 += '							) A                                     ' + char(10)
            SELECT @v_dSql2 += '							LEFT OUTER HASH JOIN MATERIAL_BOH B     ' + char(10)
            SELECT @v_dSql2 += '							ON 	1=1                               ' + char(10)
            SELECT @v_dSql2 += '							AND A.PLANT_ID    = B.PLANT_ID          ' + char(10)
            SELECT @v_dSql2 += '							AND A.MATERIAL_ID = B.MATERIAL_ID       ' + char(10)
            SELECT @v_dSql2 += '							LEFT OUTER HASH JOIN MATERIAL_SUM_QTY C ' + char(10)
            SELECT @v_dSql2 += '							ON  1=1                                 ' + char(10)
            SELECT @v_dSql2 += '							AND A.PLANT_ID    = C.PLANT_ID          ' + char(10)
            SELECT @v_dSql2 += '							AND A.MATERIAL_ID = C.MATERIAL_ID       ' + char(10)
            SELECT @v_dSql2 += '							AND A.PLAN_DATE   = C.PLAN_DATE         ' + char(10)
			SELECT @v_dSql2 += '							LEFT OUTER HASH JOIN MATERIAL_IN_QTY D  																				' + char(10)
			SELECT @v_dSql2 += '							ON  1=1                                                                                                                 ' + char(10)
			SELECT @v_dSql2 += '							AND A.PLANT_ID    = D.PLANT_ID                                                                                          ' + char(10)
			SELECT @v_dSql2 += '							AND A.MATERIAL_ID = D.ITEM_ID                                                                                           ' + char(10)
			SELECT @v_dSql2 += '							AND A.PLAN_DATE   = D.AVAILABLE_DATE                                                                                    ' + char(10)
			SELECT @v_dSql2 += '					UNION ALL                                                                                                                       ' + char(10)
			SELECT @v_dSql2 += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID                                                           ' + char(10)
			SELECT @v_dSql2 += '						  , A.OPERATION_ID, A.PRODUCT_ID, A.MATERIAL_ID, A.PLAN_DATE                                                                ' + char(10)
			SELECT @v_dSql2 += '						  , A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE                                                                               ' + char(10)
			SELECT @v_dSql2 += '						  , A.ALT_ID                                                                                                                ' + char(10)
			SELECT @v_dSql2 += '						  , ''SUB'' AS ALT_TYPE                                                                                                     ' + char(10)
			SELECT @v_dSql2 += '						  , ISNULL(B.LWH_BOH,0) AS LWH_BOH, ISNULL(B.PWH_BOH,0) AS PWH_BOH                                                          ' + char(10)
			SELECT @v_dSql2 += '						  , A.PLAN_IN_QTY                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '						  , A.MATERIAL_QTY                                                                                                          ' + char(10)
			SELECT @v_dSql2 += '						  , D.IN_QTY                                                                                                                ' + char(10)
			SELECT @v_dSql2 += '						  , 0 AS EOH_QTY                                                                                                            ' + char(10)
			SELECT @v_dSql2 += '						  , 0 AS EOH2_QTY                                                                                                           ' + char(10)
			SELECT @v_dSql2 += '					FROM (                                                                                                                          ' + char(10)
			SELECT @v_dSql2 += '						    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.OPERATION_ID, A.PRODUCT_ID, B.MATERIAL_ID      ' + char(10)
			SELECT @v_dSql2 += '							        , E.DT AS PLAN_DATE, A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE, A.MATERIAL_ID AS ALT_ID                         ' + char(10)
			SELECT @v_dSql2 += '							        , 0 AS PLAN_IN_QTY                                                                                              ' + char(10)
			SELECT @v_dSql2 += '							        , 0 AS MATERIAL_QTY                                                                                             ' + char(10)
			SELECT @v_dSql2 += '						    FROM   	#MATERIAL_PLAN A WITH(NOLOCK)                                                                           ' + char(10)
			--SELECT @v_dSql2 += '						    FROM   	BUF_MATERIAL_PLAN A WITH(NOLOCK)                                                                           ' + char(10)
			SELECT @v_dSql2 += '								    LEFT OUTER JOIN (                                                                                               ' + char(10)
			SELECT @v_dSql2 += '								          SELECT *                                                                                                  ' + char(10)
			SELECT @v_dSql2 += '								          FROM   TH_UIS_CAL E WITH(NOLOCK)                                                                          ' + char(10)
			SELECT @v_dSql2 += '								          WHERE  E.YYYYMMDD BETWEEN '''+ @p_bucket_from +''' AND '''+ @p_bucket_to +'''                             ' + char(10)
			SELECT @v_dSql2 += '								    ) E                                                                        ' + char(10)
			SELECT @v_dSql2 += '								    ON  1=1                                                                    ' + char(10)
			SELECT @v_dSql2 += '								    , FP_PACK_ALT_MATERIAL_DEFINIT B                                                                                  ' + char(10)
			SELECT @v_dSql2 += '						    WHERE 	1=1                                                                                                             ' + char(10)
			IF @p_alt_material = 'N' BEGIN
				SELECT @v_dSql2 += '						    AND 	1=0                                                                                                             ' + char(10)
			END
			SELECT @v_dSql2 += '							AND		 A.COMPANY_ID   = B.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '							AND		 A.DIVISION_ID  = B.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '							AND		 A.SITE_ID      = B.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '							AND		 A.PLANT_ID		= B.PLANT_ID                 ' + char(10)
			SELECT @v_dSql2 += '						    AND 	 A.MATERIAL_ID LIKE ''ALT_%''                                                                                   ' + char(10)
			SELECT @v_dSql2 += '						    AND 	 A.MATERIAL_ID = B.NEW_ALT_ID                                                                                   ' + char(10)
			SELECT @v_dSql2 += '						    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.OPERATION_ID                                 ' + char(10)
			SELECT @v_dSql2 += '						       		, A.PRODUCT_ID, A.MATERIAL_ID, B.MATERIAL_ID, E.DT, A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE                   ' + char(10)
			SELECT @v_dSql2 += '						) A                                                                                                                         ' + char(10)
			SELECT @v_dSql2 += '						LEFT OUTER HASH JOIN MATERIAL_BOH B                                                                                         ' + char(10)
			SELECT @v_dSql2 += '						ON 	1=1                                                                                                                     ' + char(10)
			SELECT @v_dSql2 += '						AND A.PLANT_ID    = B.PLANT_ID                                                                                              ' + char(10)
			SELECT @v_dSql2 += '						AND A.MATERIAL_ID = B.MATERIAL_ID                                                                                           ' + char(10)
            SELECT @v_dSql2 += '						LEFT OUTER HASH JOIN MATERIAL_IN_QTY D  ' + char(10)
            SELECT @v_dSql2 += '						ON  1=1                                 ' + char(10)
            SELECT @v_dSql2 += '						AND A.PLANT_ID    = D.PLANT_ID          ' + char(10)
            SELECT @v_dSql2 += '						AND A.MATERIAL_ID = D.ITEM_ID           ' + char(10)
            SELECT @v_dSql2 += '						AND A.PLAN_DATE   = D.AVAILABLE_DATE    ' + char(10)
            SELECT @v_dSql2 += '                ) A                                           ' + char(10)
            SELECT @v_dSql2 += '                LEFT OUTER HASH JOIN SCM_OPERATION_M E WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '                ON  A.COMPANY_ID   = E.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '                AND A.DIVISION_ID  = E.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '                AND A.SITE_ID      = E.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '                AND A.OPERATION_ID = E.OPERATION_ID                 ' + char(10)
            SELECT @v_dSql2 += '                LEFT OUTER HASH JOIN SCM_ITEM_M F WITH(NOLOCK)      ' + char(10)
            SELECT @v_dSql2 += '                ON  A.COMPANY_ID   = F.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '                AND A.DIVISION_ID  = F.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '                AND A.SITE_ID      = F.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '                AND A.MODEL_ID     = F.ITEM_ID                      ' + char(10)
            SELECT @v_dSql2 += '                LEFT OUTER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK) ' + char(10)
            SELECT @v_dSql2 += '                ON  A.COMPANY_ID   = J.COMPANY_ID                   ' + char(10)
            SELECT @v_dSql2 += '                AND A.DIVISION_ID  = J.DIVISION_ID                  ' + char(10)
            SELECT @v_dSql2 += '                AND A.SITE_ID      = J.SITE_ID                      ' + char(10)
            SELECT @v_dSql2 += '                AND A.MODEL_ID     = J.ITEM_ID                      ' + char(10)
			IF(Len(@p_cell_group) > 0)
			    BEGIN
			        SELECT @v_dSql2 += '    AND   J.CELL_GROUP LIKE  ''' + @p_cell_group  +'''  + ''%'' ' + char(10)
				END
            SELECT @v_dSql2 += '                , SCM_ITEM_M B WITH(NOLOCK)                         ' + char(10)
            SELECT @v_dSql2 += '                , SCM_ITEM_CLASS_M C WITH(NOLOCK)                   ' + char(10)
            SELECT @v_dSql2 += '                , (                                                 ' + char(10)
            SELECT @v_dSql2 += '                    SELECT SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS CLASS_ID, SORT_ORDER, ISNULL(ATTRIBUTE1, ''N'') AS KEY_YN ' + char(10)
            SELECT @v_dSql2 += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                ' + char(10)
            SELECT @v_dSql2 += '                    WHERE  1=1                                                ' + char(10)
            SELECT @v_dSql2 += '                    AND    LOOKUP_TYPE_CODE = ''MATERIAL_SIMUL_ITEM_DEFINIT'' ' + char(10)
            SELECT @v_dSql2 += '                    AND    SEGMENT1 = '''+ @p_instance_id +''' ' + char(10)
            SELECT @v_dSql2 += '                ) D                                        ' + char(10)
            SELECT @v_dSql2 += '                WHERE 1=1                                  ' + char(10)
            SELECT @v_dSql2 += '                AND 	A.COMPANY_ID  = B.COMPANY_ID       ' + char(10)
            SELECT @v_dSql2 += '                AND 	A.DIVISION_ID = B.DIVISION_ID      ' + char(10)
            SELECT @v_dSql2 += '                AND 	A.SITE_ID     = B.SITE_ID          ' + char(10)
            SELECT @v_dSql2 += '                AND 	CASE WHEN A.MATERIAL_ID LIKE ''ALT%'' THEN SUBSTRING(A.MATERIAL_ID,5,20) ELSE A.MATERIAL_ID END = B.ITEM_ID           ' + char(10)
            SELECT @v_dSql2 += '                AND 	B.ITEM_CLASS  = C.CLASS_ID         ' + char(10)
            SELECT @v_dSql2 += '                AND 	C.CLASS_ID LIKE D.CLASS_ID + ''%'' ' + char(10)
			IF(Len(@p_top_item_id) > 0)
			    BEGIN
			        SELECT @v_dSql2 += '             AND   A.MODEL_ID LIKE  RTRIM(LTRIM(''' + @p_top_item_id + ''')) + ''%'' ' + char(10)
				END
			IF(Len(@p_nick_name) > 0)
			    BEGIN
			        SELECT @v_dSql2 += '             AND   F.NICK_NAME LIKE  RTRIM(LTRIM(''' + @p_nick_name + ''')) + ''%'' ' + char(10)
				END
			IF(Len(@p_item_id) > 0)
			    BEGIN
			        SELECT @v_dSql2 += '             AND   A.MATERIAL_ID LIKE  RTRIM(LTRIM(''' + @p_item_id + ''')) + ''%'' ' + char(10)
				END

            SELECT @v_dSql2 += '                GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
            SELECT @v_dSql2 += '                     , ISNULL(J.CELL_GROUP, ISNULL(F.PACK_PRODUCT_GROUP_CODE, ''-'')) -- cell group 정보가 null 이면, model의 PACK_PRODUCT_GROUP_CODE, 그것도 null 이면 "-" ' + char(10)
            SELECT @v_dSql2 += '                     , A.MODEL_ID, F.NICK_NAME, A.OPERATION_ID, E.OPERATION_NAME, A.PRODUCT_ID ' + char(10)
			SELECT @v_dSql2 += '                     , CASE WHEN A.ALT_TYPE = ''SUB'' THEN ''....'' + A.MATERIAL_ID ELSE A.MATERIAL_ID END, A.ALT_ID, A.ALT_TYPE ' + char(10)
            SELECT @v_dSql2 += '                     , A.MATERIAL_NAME, A.CLASS_NAME, A.BOM_RATE, A.LWH_BOH, A.PWH_BOH ' + char(10)
            SELECT @v_dSql2 += '                     , D.CLASS_ID, D.SORT_ORDER, D.KEY_YN                                        ' + char(10)
            SELECT @v_dSql2 += '          ) A ' + char(10)
            SELECT @v_dSql2 += '    ) A       ' + char(10)
			SELECT @v_dSql2 += '    ) A       ' + char(10)
            SELECT @v_dSql2 += '    WHERE 1=1 ' + char(10)
			IF(Len(@p_is_result) > 0)
			    BEGIN
			        --SELECT @v_dSql2 += '    AND   A.IS_RESULT = ''' + @p_is_result  +''' ' + char(10)
					SELECT @v_dSql2 += '    AND   A.IS_RESULT2 = ''' + @p_is_result  +''' ' + char(10)
				END
			IF(Len(@p_cell_group) > 0)
			    BEGIN
			        SELECT @v_dSql2 += '    AND   A.CELL_GROUP LIKE   ''' + @p_cell_group  +'''  + ''%'' ' + char(10)
				END
            SELECT @v_dSql2 += '    ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID ' + char(10)
            --SELECT @v_dSql2 += '         , A.OPERATION_ID DESC, A.PRODUCT_ID, A.SORT_ORDER, A.ALT_ID, ALT_TYPE   ' + char(10)
			SELECT @v_dSql2 += '         , A.OPERATION_ID DESC, A.PRODUCT_ID, A.ALT_ID, ALT_TYPE    ' + char(10)

			SELECT @v_dSql =  @v_dSql1 + @v_dSql2
			--SELECT @p_result_val

		END --MAIN IF

	ELSE IF @p_sys_flag = 'SELECT_MEMO'
		BEGIN
			SELECT @v_dSql = ''
            SELECT @v_dSql += ' SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID       ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
            IF isnull(@p_day_info,'') <> '' 
            	BEGIN
            		SET @mst_loop_cnt    = 0
            		SET @v_delimiter     = '!'  -- 데이터 구분자
            		SET @sub_v_delimiter = '#'
            		SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            
            		IF @max_loop_cnt > 0 
            			 BEGIN
            			 -- bucket
            			 SET @mst_loop_cnt = 0	
            			 SET @max_loop_cnt = 0
            			 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            			 SET @v_Tmp1       = ''
            			 WHILE @mst_loop_cnt < @max_loop_cnt
            				 BEGIN
            					 SET @mst_loop_cnt     =  @mst_loop_cnt +1
            					 SET @tmp_column       = ''
            					 SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
            					 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
            
            					 --SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
            					 --SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
            					 SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
            					 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
            					 --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
            					 --SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))
            
            					 --SET @v_Tmp1 += '     , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)= ''' + @sub_param_2 + ''' THEN A.MEMO ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
            					 SET @v_Tmp1 += '     , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)= ''' + @sub_param_2 + ''' THEN  A.MEMO ELSE NULL END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'_MEMO ' + char(10)
            				 END 
            			END
            	END

            SELECT @v_dSql = @v_dSql + @v_Tmp1

            SELECT @v_dSql += ' FROM FP_AMEND_MEMO_M A WITH(NOLOCK)                                                         ' + char(10)
            SELECT @v_dSql += ' WHERE 1=1                                                                                   ' + char(10)
            SELECT @v_dSql += ' AND  A.INSTANCE_ID  = ' + @v_instance_id+'                                                  ' + char(10)
            SELECT @v_dSql += ' AND	 CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from +' AND ' + @v_bucket_to +' ' + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))                  + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                        + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))                    + char(10) 
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name))                      + char(10)          

            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                   ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                           ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)

		END

	/************************************************************************************************/
	/* FP00629 화면 EXECUTE_MRP_TRANSIT경우 :(EXECUTE_MRP_TRANSIT )                              */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_MRP_TRANSIT')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = '      UPDATE SCM_FP_PLAN_H SET  MRP_FLAG = ''N''    ' + char(10)
			SELECT @v_dSql = '      WHERE  INSTANCE_ID = '''+ @v_instance_id +''' ' + char(10)
			SELECT @v_dSql = '      AND    PLAN_ID     = '''+ @v_plan_id +'''     ' + char(10)
		END
	/************************************************************************************************/
	/* FP00629 화면 EXECUTE_MRP_RECEIVE경우 :(EXECUTE_MRP_RECEIVE )                              */
	/************************************************************************************************/
    ELSE IF(@p_sys_flag ='EXECUTE_MRP_RECEIVE')
	    BEGIN --ELSE IF(START)
		    --LOG
		    SELECT @v_dSql = ''
			SELECT @v_dSql = 'EXEC [dbo].[PR_XIF_MRP_CUTOFF_SUPPLY_R] '
			EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'PR_XIF_MRP_CUTOFF_SUPPLY_R','',@v_dSql,'select', @runstart, @runend

			--실제수행
			EXEC  @rtnCount = [dbo].[PR_XIF_MRP_CUTOFF_SUPPLY_R]
			
			SET @rtnCount = 1
            SELECT	'Result' = @rtnCount

		END

--------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF @p_sys_type = 'SQL'
		BEGIN
			--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,',',@v_dSql,'select',@runstart, @runend
			SELECT @v_dSql as [QUERY_VALUE]

		END  
	ELSE IF ( @p_sys_type = 'SELECT' AND @p_sys_flag != 'EXECUTE_MRP_RECEIVE')
		BEGIN
			SET @runstart = GetDate()
			--쿼리실행
			EXEC sp_executesql @v_dSql

			SET @runend = GetDate()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		END
END
