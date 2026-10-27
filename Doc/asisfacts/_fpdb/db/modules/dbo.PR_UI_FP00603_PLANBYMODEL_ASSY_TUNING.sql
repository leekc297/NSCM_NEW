CREATE PROCEDURE [dbo].[PR_UI_FP00603_PLANBYMODEL_ASSY_TUNING]
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
/** 프로그램 ID   :PR_UI_FP00603_PLANBYMODEL_ASSY                                             **/
/** 프로그램 명   : Procedure PR_UI_FP00603_PLANBYMODEL_ASSY                                  **/
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
/** 2021-05-17     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00603_PLANBYMODEL_ASSY
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  DECLARE @p_plan_date    NVARCHAR(100) = ''
  DECLARE @p_instance_id  NVARCHAR(100) = ''
  DECLARE @p_plan_id      NVARCHAR(100) = ''
  DECLARE @p_division_id  NVARCHAR(1000) = ''
  DECLARE @p_site_id      NVARCHAR(1000) = ''
  DECLARE @p_plant_id     NVARCHAR(2000) = ''
  DECLARE @p_factory_id   NVARCHAR(2000) = ''
  DECLARE @p_line_id      NVARCHAR(max) = ''
  DECLARE @p_operation_id NVARCHAR(max) = ''
  DECLARE @p_top_item_id  NVARCHAR(100) = ''
  DECLARE @p_item_id      NVARCHAR(100) = ''
  DECLARE @p_nick_name    NVARCHAR(100) = ''
  DECLARE @p_prod_type    NVARCHAR(max) = ''
  DECLARE @p_prodtype_id  NVARCHAR(max) = ''
  DECLARE @p_cell_group   NVARCHAR(100) = ''
  DECLARE @p_confirm_area NVARCHAR(100) = ''
  DECLARE @p_curr_date    NVARCHAR(100) = ''

  DECLARE @p_bucket_from  NVARCHAR(100) = ''
  DECLARE @p_bucket_to    NVARCHAR(100) = ''
  DECLARE @p_bucket       NVARCHAR(max) = ''
  DECLARE @p_day_info     NVARCHAR(max) = ''
  DECLARE @p_week_info    NVARCHAR(max) = ''
  DECLARE @p_month_info   NVARCHAR(max) = ''
  DECLARE @p_cate_info    NVARCHAR(max) = ''
  DECLARE @p_day2week     NVARCHAR(max) = ''
  DECLARE @p_day2month    NVARCHAR(max) = ''

  --DECLARE BASE PARAMETER START
  DECLARE @runstart          datetime
  DECLARE @runend            datetime
  DECLARE @v_Err             NVARCHAR(max)
  DECLARE @v_Log             NVARCHAR(max) 
  DECLARE @v_proc_name       NVARCHAR(100) = OBJECT_NAME(@@PROCID)


  DECLARE @v_plan_date       NVARCHAR(100)
  DECLARE @v_instance_id     NVARCHAR(100)
  DECLARE @v_plan_id         NVARCHAR(100)
  DECLARE @v_division_id     NVARCHAR(1000)
  DECLARE @v_site_id         NVARCHAR(1000)
  DECLARE @v_plant_id        NVARCHAR(2000)
  DECLARE @v_factory_id      NVARCHAR(2000)
  DECLARE @v_line_id         NVARCHAR(max)
  DECLARE @v_operation_id    NVARCHAR(max)
  DECLARE @v_top_item_id     NVARCHAR(100)
  DECLARE @v_item_id         NVARCHAR(100)
  DECLARE @v_nick_name       NVARCHAR(100)
  DECLARE @v_prod_type       NVARCHAR(max)
  DECLARE @v_prodtype_id     NVARCHAR(max)
  DECLARE @v_cell_group      NVARCHAR(100)  --Pjr Group
  DECLARE @v_confirm_area    NVARCHAR(100)
  DECLARE @v_curr_date       NVARCHAR(100)
  DECLARE @v_bucket_from     NVARCHAR(100)
  DECLARE @v_bucket_to       NVARCHAR(100)
  DECLARE @v_bucket          NVARCHAR(max)
  DECLARE @v_day_info        NVARCHAR(max)
  DECLARE @v_week_info       NVARCHAR(max)
  DECLARE @v_month_info      NVARCHAR(max)
  DECLARE @v_cate_info       NVARCHAR(max)
  DECLARE @v_day2week        NVARCHAR(max)
  DECLARE @v_day2month       NVARCHAR(max)
  DECLARE @v_user_id         NVARCHAR(max)

  DECLARE @p_curr_date_gap	NVARCHAR(MAX); -- 인스턴스별 현재일자를 구한다.
  DECLARE @p_temp			NVARCHAR(MAX);
  DECLARE @tmp_GAP_lastCol	NVARCHAR(MAX); -- Gap(WPP) week, month 막날 용
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

  --Optional Parameter Part END

--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += '@P_SYS_TYPE=' +ISNULL(@P_SYS_TYPE,'') +char(10)
--SET @PARAMS += '@P_SYS_FLAG=' +ISNULL(@P_SYS_FLAG,'') +char(10)
--SET @PARAMS += '@P_SYS_GUBUN=' +ISNULL(@P_SYS_GUBUN,'') +char(10)
--SET @PARAMS += '@P_USER_ID=' +ISNULL(@P_USER_ID,'') +char(10)
--SET @PARAMS += '@in_columns=' +ISNULL(@in_columns,'') +char(10)
--SET @PARAMS += '@in_row=' +ISNULL(@in_row,'') +char(10)

--SELECT @PARAMS AS SQL
--RETURN

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
          ELSE IF @tmp_column = 'LINE_ID' 
              BEGIN
                  SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'TOP_ITEM_ID' 
              BEGIN
                  SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'ITEM_ID' 
              BEGIN
                  SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'NICK_NAME' 
              BEGIN
                  SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'PROD_TYPE' 
              BEGIN
                  SET @p_prod_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CELL_GROUP'
              BEGIN
                  SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CONFIRM_AREA'
              BEGIN
                  SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CURR_DATE'
              BEGIN
                  SET @p_curr_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
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
          ELSE IF @tmp_column = 'DAY2WEEK' 
              BEGIN
                  SET @p_day2week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'DAY2MONTH' 
              BEGIN
                  SET @p_day2month =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CATE_INFO' 
              BEGIN
                  SET @p_cate_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = '_NON_AUTH' 
              BEGIN
          	     SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
      END


    BEGIN 
        SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date    = '''' + @p_plan_date + ''''
               , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id  = '''' + @p_division_id + ''''
               , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id     = '''' + @p_plant_id + ''''
               , @v_factory_id   = '''' + @p_factory_id + ''''   , @v_line_id      = '''' + @p_line_id + ''''
               , @v_operation_id = '''' + @p_operation_id + '''' , @v_top_item_id  = '''' + @p_top_item_id + ''''
               , @v_item_id      = '''' + @p_item_id + ''''      , @v_nick_name    = '''' + @p_nick_name + ''''
               , @v_prodtype_id  = '''' + @p_prodtype_id + ''''  , @v_prod_type    = '''' + @p_prod_type + ''''
               , @v_cell_group   = '''' + @p_cell_group + ''''   , @v_curr_date    = '''' + @p_curr_date + ''''
               , @v_bucket_from  = '''' + @p_bucket_from + ''''  , @v_bucket_to    = '''' + @p_bucket_to + ''''
               , @v_bucket       = '''' + @p_bucket + ''''       , @v_day_info     = '''' + @p_day_info + ''''
			   , @v_week_info    = '''' + @p_week_info + ''''    , @v_month_info   = '''' + @p_month_info + ''''   
			   , @v_cate_info    = '''' + @p_cate_info + ''''    , @v_day2week     = '''' + @p_day2week + ''''
			   , @v_day2month    = '''' + @p_day2month + ''''    , @v_confirm_area = '''' + @p_confirm_area + ''''
			   , @v_user_id      = '''' + @p_user_id + ''''
    END

	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
		BEGIN --MAIN IF
			IF LEN(@p_cate_info) > 0 
				BEGIN
					  SET @mst_loop_cnt    = 0
					  SET @v_delimiter     = '!'  -- 데이터 구분자
					  SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @sub_v_delimiter = '#'
					  SET @v_SqlsubTotal   = ''

					  WHILE @mst_loop_cnt < @max_loop_cnt
						  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
							  SET @mst_loop_cnt     = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
							  SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info,   @v_delimiter,     @mst_loop_cnt);
							  SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column,     @sub_v_delimiter)
							  SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 1)  -- @sub_param_0 => chk
							  SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 2)  -- @sub_param_1 => cell
							  SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 3)  -- @sub_param_2 => true

							  IF (@sub_param_0 = 'chk_subTotal' AND @sub_param_2 ='FALSE')
								  BEGIN
									  SELECT @v_SqlsubTotal += '        WHERE 1=0' +char(10)
								  END 
						  END
				END 
			IF LEN(@p_cate_info) > 0
				BEGIN
					  SET @mst_loop_cnt    = 0
					  SET @v_delimiter     = '!'  -- 데이터 구분자
					  SET @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_cate_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @sub_v_delimiter = '#'
					  SET @v_SqlTotal      = ''

					  WHILE @mst_loop_cnt < @max_loop_cnt
						  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
							  SET @mst_loop_cnt     = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가
							  SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_cate_info,   @v_delimiter,     @mst_loop_cnt);
							  SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column,     @sub_v_delimiter)
							  SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 1)  -- @sub_param_0 => chk
							  SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 2)  -- @sub_param_1 => cell
							  SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 3)  -- @sub_param_2 => true
		          
			      			 IF (@sub_param_0   = 'chk_total'  AND @sub_param_2 ='FALSE')
								  BEGIN
									  SELECT @v_SqlTotal += '        WHERE 1=0' +char(10)
								  END 
						  END
				END 

			-- FP00603   
			SELECT @v_dSql1  = ''

			SET @p_curr_date_gap = (
				 SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,DBO.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME
							  THEN CONVERT(VARCHAR, DATEADD(DD,-1,DBO.FN_SITE_TIME(B.SITE_ID)), 112) 
							  ELSE CONVERT(VARCHAR, DBO.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE 
				  FROM   FP_INSTANCE_START_TIME_V A,
				  (
						  SELECT MAX(B.SITE_ID) AS SITE_ID 
						  FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)
						  WHERE  A.FACTORY_ID = B.FACTORY_ID 
						  AND    A.ACTIVE_FLAG = 'Y'
						  AND    B.ACTIVE_FLAG = 'Y'
						  AND    A.INSTANCE_ID = @p_instance_id
				  ) B
				  WHERE  A.INSTANCE_ID = @p_instance_id
			  )

			-- GAP(WPP) 추가
			SELECT @v_dSql1 += N'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
			SELECT @v_dSql1 += N'	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql1 += N'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
			SELECT @v_dSql1 += N'	drop table #MAIN_GAP_WPP ' + char(10)
			SELECT @v_dSql1 += N'if object_id(''tempdb..#MAIN_P'') is not null drop table #MAIN_P ' + char(10)
			
			SELECT @v_dSql1 += N'' + char(10)
			-- 조회되는 아이템-날짜 세트 : 1일 부터의 구간을 가생성
			SELECT @v_dSql1 += N'SELECT A.* ' + char(10)
			SELECT @v_dSql1 += N'     , B.YYYYMMDD AS PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql1 += N'     , ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += N'     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			SELECT @v_dSql1 += N'     , ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME, BB.ITEM_TYPE ' + char(10)
			SELECT @v_dSql1 += N'	 , J.CELL_GROUP ' + char(10)
			SELECT @v_dSql1 += N'INTO #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql1 += N'FROM ( ' + char(10)
			SELECT @v_dSql1 += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , A.MARKET, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'	FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += N'	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 조회 날짜 구간
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql1 += N'	AND    (A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
			SELECT @v_dSql1 += N'	UNION ' + char(10)
			SELECT @v_dSql1 += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , A.MARKET, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'	FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += N'	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_bucket_from + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 조회 날짜 구간
			SELECT @v_dSql1 += N'	AND    A.PLAN_TYPE IN (''WPP'', ''RELEASE'') ' + char(10) -- WPP 는 WPP(Out) 품번, RELEASE 는 미래실적 품번 때문에 가져옴(미래실적의 경우, 엄밀히 말하면 당일이후 날짜의 품번만 가져와야하나 별도로 가져오기 애매하므로 일단 같이 가져온다... 문제되면 분리해서 하단에 union all 로 붙여야할듯)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += N'	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql1 += N'	AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
			SELECT @v_dSql1 += N') A ' + char(10)
			SELECT @v_dSql1 += N'INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += N'		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			SELECT @v_dSql1 += N'				A.ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += N'				(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql1 += N'	                  WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql1 += N'	                  ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
			SELECT @v_dSql1 += N'				ISNULL(A.NICK_NAME,''-'') AS NICK_NAME  ' + char(10)
			SELECT @v_dSql1 += N'		FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql1 += N'	           SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'		WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
			SELECT @v_dSql1 += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			IF(LEN(@p_nick_name) > 0)
			BEGIN
				SELECT @v_dSql1 += '		AND   A.NICK_NAME LIKE ''%' + @p_nick_name + '%''   ' + char(10)
    		END
			SELECT @v_dSql1 += N') BB ' + char(10)
			SELECT @v_dSql1 += N'ON     A.COMPANY_ID     = BB.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.DIVISION_ID    = BB.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.SITE_ID        = BB.SITE_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.TOP_ITEM_ID    = BB.ITEM_ID ' + char(10) -- line result 는 model 기준인데
			--SELECT @v_dSql1 += N'AND    A.ITEM_ID        = BB.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N'INNER JOIN SCM_LINE_M C WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql1 += N'ON     A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.LINE_ID        = C.LINE_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'INNER JOIN SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'ON     A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.SITE_ID        = D.SITE_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql1 += N'ON     A.COMPANY_ID     = J.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.DIVISION_ID    = J.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.SITE_ID        = J.SITE_ID ' + char(10)
			SELECT @v_dSql1 += N'AND    A.TOP_ITEM_ID    = J.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N', TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += N'AND   B.YYYYMMDD BETWEEN (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'') AND ''' + @p_bucket_to + ''' ' + char(10) -- 시작일의 월의 1일부터 구간이 잡힘
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LIKE', @p_cell_group)) + char(10)
			SELECT @v_dSql1 += N'OPTION (FORCE ORDER) ; ' + char(10)+char(10)

			SELECT @v_dSql1 += N'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += N'	 , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'	 , A.OPERATION_ID, A.OPERATION_NAME , A.FACTORY_ID, A.LOCATION ' + char(10)
			SELECT @v_dSql1 += N'	 , A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI ' + char(10)
			SELECT @v_dSql1 += N'	 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'     , A.CATE, A.MEASURE_ID ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
			BEGIN
    			
				SET @mst_loop_cnt     = 0
    			SET @v_delimiter      = '!'  -- 데이터 구분자
    			SET @sub_v_delimiter  = '#'
    			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

				IF @max_loop_cnt > 0
				BEGIN
					
					-- 1. monthinfo : 월별 막날 값이 필요
    				SET @mst_loop_cnt = 0
    				SET @max_loop_cnt = 0
    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

					declare @d_seq integer = 0;

    				WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SET @mst_loop_cnt     =  @mst_loop_cnt + 1
						SET @tmp_column       = ''
						SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_month_info,@v_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

						SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_0 => MONTH (202304, 202305)
						--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_0 => MONTH_NAME
						SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3) -- @sub_param_2 => MONTH_COUNT (14, 2)
						SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4) -- @sub_param_3 => M_VALUE
						--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   -- @sub_param_0 => IS_DAY_VIEW
						
						--SELECT @v_dSql1 += ' , ' + @sub_param_0 + ' :: ' + @sub_param_2
						SELECT @v_dSql1 += ', D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 월 별 일갯수만큼 누적됨
						 
						SET @d_seq += @sub_param_2
					
					END

    				-- 2. weekinfo : 주 별 막날 값이 필요
    				SET @mst_loop_cnt = 0	
    				SET @max_loop_cnt = 0
    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

					set @d_seq = 0

    				WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SET @mst_loop_cnt     =  @mst_loop_cnt + 1
						SET @tmp_column       = ''
						SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

						SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)     -- @sub_param_0 => WEEK
						--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_0 => WEEK_NAME
						SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_0 => WEEK_COUNT
						SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   -- @sub_param_0 => W_VALUE
						--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   -- @sub_param_0 => IS_DAY_VIEW

						--SELECT @v_dSql1 += ' , ' + @sub_param_0 + ' :: ' + @sub_param_2
						SELECT @v_dSql1 += ', D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 주 별 일갯수만큼 누적됨
						 
						SET @d_seq += @sub_param_2

					END

					-- 3. dayinfo
					SET @mst_loop_cnt = 0
    				SET @max_loop_cnt = 0
    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						
						SELECT @v_dSql1 += '     , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + char(10)
			
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END -- end of @mst_loop_cnt < @max_loop_cnt


				END

			END

			SELECT @v_dSql1 += N'     , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, NULL AS S_ROW ' + char(10)
			SELECT @v_dSql1 += N'INTO #MAIN_GAP_WPP ' + char(10)
			SELECT @v_dSql1 += N'FROM ( ' + char(10)
			SELECT @v_dSql1 += N'	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += N'		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , '''' AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'		 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'		 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'		 , A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		 , B.CATEGORY_NAME AS CATE ' + char(10)
			SELECT @v_dSql1 += N'		 , B.MEASURE_NAME AS MEASURE_NAME ' + char(10)


			
			IF ISNULL(@p_day_info,'') <> ''
			BEGIN
    			
				SET @mst_loop_cnt     = 0
    			SET @v_delimiter      = '!'  -- 데이터 구분자
    			SET @sub_v_delimiter  = '#'
				
				-- @p_day_info :: IS_PLAN:N#D_VALUE:D0#_DATE:20230401#_WEEK:202313#_MONTH:04#_DATE_TXT:2023-04-01 (Sat.)#DAY_SEQ:7#
				SET @mst_loop_cnt = 0
    			SET @max_loop_cnt = 0
    			SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt =  @mst_loop_cnt + 1

					SET @tmp_column   = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info, @v_delimiter, @mst_loop_cnt)
					
					--SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN :: Y/N
					--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 2)   -- @sub_param_1 => D_VALUE :: D0 
					SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 3)   -- @sub_param_2 => DAY_VALUE :: 20230401
					--SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 4)   -- @sub_param_3 => WEEK_VALUE :: 202313
					--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column, @sub_v_delimiter, 5)   -- @sub_param_4 => MONTH_VALUE :: 04

					SELECT @v_dSql1 += N'		 , SUM(CASE WHEN A.PLAN_DATE >= (SUBSTRING(''' + @sub_param_2 + ''',1,6)+''01'') AND A.PLAN_DATE <= ''' + @sub_param_2 + ''' THEN ( CASE WHEN B.CATEGORY_ID=''GAP_WPP'' AND B.MEASURE_ID=''UOM''  THEN A.GAP_QTY ' + char(10)
					SELECT @v_dSql1 += N'	  																											   WHEN B.CATEGORY_ID=''GAP_WPP'' AND B.MEASURE_ID=''CELL'' THEN A.GAP_CELL_QTY ' + char(10)
					SELECT @v_dSql1 += N'	  																											   ELSE 0 END )ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) + ' ' + char(10)
					
				END -- end of @mst_loop_cnt < @max_loop_cnt

			END
			
			SELECT @v_dSql1 += N' 		 , B.CATEGORY_ID, B.MEASURE_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += N' 		 , ''DATA'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql1 += N'	FROM ( ' + char(10)
			SELECT @v_dSql1 += N'		SELECT A.* ' + char(10) 
			SELECT @v_dSql1 += N'			 , ISNULL(B.GAP_QTY,0) AS GAP_QTY ' + char(10)
			SELECT @v_dSql1 += N'			 , ISNULL(B.GAP_CELL_QTY,0) AS GAP_CELL_QTY ' + char(10)
			SELECT @v_dSql1 += N'		FROM #MAIN_ITEM_WPP_GAP A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += N'			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'				 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'				 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'				 , A.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'				 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += N'				 , A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'				 , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'				 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'				 , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
			SELECT @v_dSql1 += N'				 , ROUND(SUM(ISNULL(A.RESULT_QTY_CELL,0)),0) - ROUND(SUM(ISNULL(A.CELL_OUT_QTY,0)),0) AS GAP_CELL_QTY ' + char(10)
			SELECT @v_dSql1 += N'			FROM ( ' + char(10)
												-- WPP
			SELECT @v_dSql1 += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'					 , ISNULL(A.PLAN_QTY,0) AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , ISNULL(A.CELL_OUT_QTY,0) AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS RESULT_QTY_CELL ' + char(10)
			SELECT @v_dSql1 += N'				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 시작일자 월의 1일부터 뽑는다.
			SELECT @v_dSql1 += N'				AND    A.PLAN_TYPE = ''WPP'' ' + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql1 += N'				AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
			SELECT @v_dSql1 += N'				UNION ALL ' + char(10)
												-- Result 과거 : 과거시작일자 월의 1일부터 당일이전 일자(과거)까지
			SELECT @v_dSql1 += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS CELL_IN_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , A.ACTUAL_GOOD_QTY AS RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , A.CELL_OUT_QTY AS RESULT_QTY_CELL ' + char(10)
			SELECT @v_dSql1 += N'				FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(''' + @p_bucket_from + ''',1,6) + ''01'')) AND CONVERT(DATETIME, ''' + @p_curr_date_gap + ''')-1 ' + char(10) -- 과거 : 시작일자 월의 1일부터 당일(인스턴스 기준)이전 일자(과거)까지
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql1 += N'				AND    (A.CELL_OUT_QTY + A.ACTUAL_GOOD_QTY) > 0 ' + char(10)
			SELECT @v_dSql1 += N'				UNION ALL ' + char(10)
												-- Result 미래 : 당일부터 end date 까지
			SELECT @v_dSql1 += N'				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , '''' AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS CELL_IN_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , 0 AS CELL_OUT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , ISNULL(A.PLAN_QTY,0) AS RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += N'					 , ISNULL(A.CELL_OUT_QTY,0) AS RESULT_QTY_CELL ' + char(10)
			SELECT @v_dSql1 += N'				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += N'				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += N'				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ''' + @p_bucket_to + ''') ' + char(10) -- 미래 : 당일(인스턴스 기준)부터 end date 까지
			SELECT @v_dSql1 += N'				AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_top_item_id)) + char(10)
			SELECT @v_dSql1 += N'				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10)
			SELECT @v_dSql1 += N'				AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
			SELECT @v_dSql1 += N'			) A ' + char(10)
			SELECT @v_dSql1 += N'			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'				   , A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += N'				   , A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'				   , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += N'		) B ' + char(10)
			SELECT @v_dSql1 += N'		ON  1=1 ' + char(10)
			SELECT @v_dSql1 += N'		AND A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.SITE_ID         = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.PLANT_ID        = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.LOCATION        = B.LOCATION ' + char(10)
			SELECT @v_dSql1 += N'		AND A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.LINE_ID         = B.LINE_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.ITEM_ID         = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += N'		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		AND A.MARKET          = B.MARKET ' + char(10)
			SELECT @v_dSql1 += N'		AND A.PLAN_DATE       = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += N'		AND A.PLM_EC_NO       = B.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'	) A ' + char(10)
			SELECT @v_dSql1 += N'	INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += N'			SELECT * ' + char(10)
			SELECT @v_dSql1 += N'			FROM ( ' + char(10)
			SELECT @v_dSql1 += N'				SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 0 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += N'				UNION ALL ' + char(10)
			SELECT @v_dSql1 += N'				SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 145 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += N'				UNION ALL ' + char(10)
			SELECT @v_dSql1 += N'				SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 146 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += N'			) BB ' + char(10)
			SELECT @v_dSql1 += N'			WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql1 += N'	) B ' + char(10)
			SELECT @v_dSql1 += N'	ON 1=1 ' + char(10)
			SELECT @v_dSql1 += N'	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
			SELECT @v_dSql1 += N'		  , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += N'		  , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		  , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += N'		  , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql1 += N'		  , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += N') A ' + char(10)
			SELECT @v_dSql1 += N'OPTION (FORCE ORDER) ; ' + char(10)+ char(10)
			
			--SELECT @v_dSql1 += '  WITH MAIN_P AS (                                                                        ' + char(10) -- Tuning_01
			SELECT @v_dSql1 += '      -- P : builing, location, production type, market, line                             ' + char(10)
			SELECT @v_dSql1 += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID            ' + char(10)
			SELECT @v_dSql1 += '           , A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql1 += '           , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'') AS OPERATION_NAME             ' + char(10)
			SELECT @v_dSql1 += '           , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI          ' + char(10)
			SELECT @v_dSql1 += '           , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME                            ' + char(10)
			SELECT @v_dSql1 += '           , A.ELECTRODE_TYPE, D.CATE_NAME AS CATE, D.MEASURE_ID        ' + char(10)

			   IF ISNULL(@p_day_info,'') <> '' BEGIN
    				SET @mst_loop_cnt     = 0
    				SET @v_delimiter      = '!'  -- 데이터 구분자
    				SET @sub_v_delimiter  = '#'
    				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
    				IF @max_loop_cnt > 0 BEGIN
    					-- monthinfo
    					SET @mst_loop_cnt = 0
    					SET @max_loop_cnt = 0
    					SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp1       = ''
    					WHILE @mst_loop_cnt < @max_loop_cnt
							 BEGIN
								 SET @mst_loop_cnt     =  @mst_loop_cnt + 1
								 SET @tmp_column       = ''
								 SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_month_info,@v_delimiter, @mst_loop_cnt)
								 SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

								 SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_0 => MONTH
								 --SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2) -- @sub_param_1 => MONTH_NAME
								 --SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3) -- @sub_param_2 => MONTH_COUNT
								 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4) -- @sub_param_3 => M_VALUE
    
								 SELECT @v_Tmp1 += '           , SUM(CASE WHEN G.YYYYMM=''' + @sub_param_0+ ''' THEN   ' + char(10)
								 SELECT @v_Tmp1 += '                      ( CASE WHEN D.CATE_ID = ''P_IN_UOM''   AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY       ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_IN_CELL''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_OUT_UOM''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY      ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_OUT_CELL'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''M_IN_UOM''   AND A.PLAN_TYPE = ''MPP''     THEN A.IN_QTY       ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''M_IN_CELL''  AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''M_OUT_UOM''  AND A.PLAN_TYPE = ''MPP''     THEN A.OUT_QTY      ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''M_OUT_CELL'' AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''W_IN_UOM''   AND A.PLAN_TYPE = ''WPP''     THEN A.IN_QTY       ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''W_IN_CELL''  AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''W_OUT_UOM''  AND A.PLAN_TYPE = ''WPP''     THEN A.OUT_QTY      ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''W_OUT_CELL'' AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_RESULT_UOM''  THEN A.RESULT_QTY       ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_QTY_CELL  ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_RESULT_EXP_UOM''  THEN A.RESULT_QTY2 ' + char(10) -- Result(Exp.)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_RESULT_EXP_CELL'' THEN A.RESULT_QTY2_CELL ' + char(10) -- Result(Exp.)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_CUT''         THEN CEILING(A.CUT_QTY) ' + char(10)
								 SELECT @v_Tmp1 += '                             WHEN D.CATE_ID = ''P_OFFTIME''     THEN A.OFF_TIME         ' + char(10)
								 SELECT @v_Tmp1 += '                            WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ' + char(10)
								 SELECT @v_Tmp1 += '                       ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
							 END
    
    					-- weekinfo
    					SET @mst_loop_cnt = 0	
    					SET @max_loop_cnt = 0
    					SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp2       = ''
    					WHILE @mst_loop_cnt < @max_loop_cnt
							BEGIN
								SET @mst_loop_cnt     =  @mst_loop_cnt + 1
								SET @tmp_column       = ''
								SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
								SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)

								SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)     -- @sub_param_0 => WEEK
								--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_0 => WEEK_NAME
								--SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_0 => WEEK_COUNT
								--SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 4)   -- @sub_param_0 => W_VALUE
								--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 5)   -- @sub_param_0 => IS_DAY_VIEW
    
								SELECT @v_Tmp2 += '           , SUM(CASE WHEN G.ISO_YYYYWW=''' + @sub_param_0 + ''' THEN ' + char(10)
								SELECT @v_Tmp2 += '                     ( CASE WHEN D.CATE_ID = ''P_IN_UOM''   AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_IN_CELL''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_OUT_UOM''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY      ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_OUT_CELL'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''M_IN_UOM''   AND A.PLAN_TYPE = ''MPP''     THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''M_IN_CELL''  AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''M_OUT_UOM''  AND A.PLAN_TYPE = ''MPP''     THEN A.OUT_QTY      ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''M_OUT_CELL'' AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''W_IN_UOM''   AND A.PLAN_TYPE = ''WPP''     THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''W_IN_CELL''  AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''W_OUT_UOM''  AND A.PLAN_TYPE = ''WPP''     THEN A.OUT_QTY      ' + char(10);
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''W_OUT_CELL'' AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_RESULT_UOM''  THEN A.RESULT_QTY       ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_QTY_CELL  ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_RESULT_EXP_UOM''  THEN A.RESULT_QTY2 ' + char(10) -- Result(Exp.)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_RESULT_EXP_CELL'' THEN A.RESULT_QTY2_CELL ' + char(10) -- Result(Exp.)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_CUT''         THEN CEILING(A.CUT_QTY) ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_OFFTIME''     THEN A.OFF_TIME         ' + char(10)
								SELECT @v_Tmp2 += '                            WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ' + char(10)
								SELECT @v_Tmp2 += '                       ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)
							END
    
    					-- day
    					SET @mst_loop_cnt = 0	
    					SET @max_loop_cnt = 0
    					SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp3       = ''

						WHILE @mst_loop_cnt < @max_loop_cnt
							BEGIN
								SET @mst_loop_cnt     =  @mst_loop_cnt + 1
								SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
								SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                        
								--SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
								--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
								SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
								--SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
								--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
								--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))

								SELECT @v_Tmp3 += '           , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)='''+ @sub_param_2 +''' THEN                        ' + char(10)
								SELECT @v_Tmp3 += '                      ( CASE WHEN D.CATE_ID = ''P_IN_UOM''   AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_IN_CELL''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_OUT_UOM''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY      ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_OUT_CELL'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''M_IN_UOM''   AND A.PLAN_TYPE = ''MPP''     THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''M_IN_CELL''  AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''M_OUT_UOM''  AND A.PLAN_TYPE = ''MPP''     THEN A.OUT_QTY      ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''M_OUT_CELL'' AND A.PLAN_TYPE = ''MPP''     THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''W_IN_UOM''   AND A.PLAN_TYPE = ''WPP''     THEN A.IN_QTY       ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''W_IN_CELL''  AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''W_OUT_UOM''  AND A.PLAN_TYPE = ''WPP''     THEN A.OUT_QTY      ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''W_OUT_CELL'' AND A.PLAN_TYPE = ''WPP''     THEN A.CELL_OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_RESULT_UOM''  THEN A.RESULT_QTY       ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_RESULT_CELL'' THEN A.RESULT_QTY_CELL  ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_RESULT_EXP_UOM''  THEN A.RESULT_QTY2 ' + char(10) -- Result(Exp.)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_RESULT_EXP_CELL'' THEN A.RESULT_QTY2_CELL ' + char(10) -- Result(Exp.)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_CUT''         THEN CEILING(A.CUT_QTY) ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_OFFTIME''     THEN A.OFF_TIME         ' + char(10)
								SELECT @v_Tmp3 += '                             WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END           ' + char(10)
								SELECT @v_Tmp3 += '                       ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)

							END 
    				END
				END 
    
			  SELECT @v_dSql1 = @v_dSql1 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3 + @v_Tmp4

			SELECT @v_dSql1 += '          , D.CATE_ID AS CATEGORY_ID, D.CATE_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '          , ''DATA'' AS DATA_TYPE, NULL AS S_ROW                     ' + char(10)
			SELECT @v_dSql1 += '          into #MAIN_P'+ char(10) -- Tuning_02
    
			SELECT @v_dSql2  = ''
			SELECT @v_dSql2 += '      FROM (                                                                                ' + char(10)
			SELECT @v_dSql2 += '             SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.TOP_ITEM_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql2 += '                 , A.ITEM_ID, B.ITEM_TYPE, J.CELL_GROUP,A.OPERATION_ID, A.FACTORY_ID        ' + char(10)
			SELECT @v_dSql2 += '                 , A.LOCATION, A.BOH_QTY,            A.PRODUCTION_TYPE, A.MARKET,A.PSI      ' + char(10)
			SELECT @v_dSql2 += '                 , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE, A.PLAN_TYPE                    ' + char(10)
			SELECT @v_dSql2 += '                 ,SUM(A.IN_QTY) IN_QTY,              SUM(A.OUT_QTY) OUT_QTY                 ' + char(10)
			SELECT @v_dSql2 += '                 ,SUM(A.CELL_IN_QTY) AS CELL_IN_QTY, SUM(A.CELL_OUT_QTY) AS CELL_OUT_QTY    ' + char(10)
			SELECT @v_dSql2 += '                 ,SUM(A.RESULT_QTY) RESULT_QTY,      SUM(A.RESULT_QTY_CELL) RESULT_QTY_CELL ' + char(10)
			SELECT @v_dSql2 += '                 ,AVG(A.OFF_TIME) OFF_TIME,          SUM(A.CUT_QTY) AS CUT_QTY              ' + char(10)
			SELECT @v_dSql2 += '                 ,SUM(A.RESULT_QTY2) AS RESULT_QTY2, SUM(A.RESULT_QTY2_CELL) RESULT_QTY2_CELL ' + char(10) -- Result(Exp.)
			SELECT @v_dSql2 += '             FROM (                                                                         ' + char(10)
			SELECT @v_dSql2 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID               ' + char(10)
			SELECT @v_dSql2 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql2 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION                 ' + char(10)
			SELECT @v_dSql2 += '                       , NULL AS BOH_QTY, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE           ' + char(10)
			SELECT @v_dSql2 += '                       , A.MARKET, ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE                ' + char(10)
			SELECT @v_dSql2 += '                       , A.PLAN_DATE, A.PLAN_IN_QTY AS IN_QTY, A.PLAN_QTY AS OUT_QTY        ' + char(10)
			SELECT @v_dSql2 += '                       , A.CELL_IN_QTY, A.CELL_OUT_QTY, 0 AS RESULT_QTY                     ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS RESULT_QTY_CELL, 0 AS OFF_TIME, 0 AS CUT_QTY, A.PLAN_TYPE     ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
			SELECT @v_dSql2 += '                    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                       ' + char(10)
			SELECT @v_dSql2 += '                    WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                    AND 	A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' )       ' + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			SELECT @v_dSql2 += '                    AND 	(A.PLAN_IN_QTY + A.PLAN_QTY) > 0                       ' + char(10)
			SELECT @v_dSql2 += '                    UNION ALL                                                      ' + char(10)
			SELECT @v_dSql2 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID      ' + char(10)
			SELECT @v_dSql2 += '                        , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql2 += '                        , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			SELECT @v_dSql2 += '                        , NULL AS BOH_QTY, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql2 += '                        , A.MARKET, ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE      ' + char(10)
			SELECT @v_dSql2 += '                        , A.PLAN_DATE, 0 AS IN_QTY, 0 AS OUT_QTY, 0 AS CELL_IN_QTY ' + char(10)
			SELECT @v_dSql2 += '                        , 0 AS CELL_OUT_QTY, 0 AS RESULT_QTY, 0 AS RESULT_QTY_CELL ' + char(10)
			SELECT @v_dSql2 += '                        , 0 AS OFF_TIME                                            ' + char(10)
			SELECT @v_dSql2 += '                        -- 대치관련 처리... 20200409                               ' + char(10)
			SELECT @v_dSql2 += '                        , ISNULL                                                   ' + char(10)
			SELECT @v_dSql2 += '                            ( ( SELECT TOP 1 (A.PLAN_IN_QTY * B.CHILD_QTY/B.PARENT_QTY)/(PC_ROLL_LENGTH*LANE_QTY) ' + char(10)
			SELECT @v_dSql2 += '                                 FROM   SCM_ITEM_M	I WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql2 += '                                      , SCM_BOM_M B WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql2 += '                                      , SCM_ITEM_LANE_M IL WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql2 += '                                 WHERE I.COMPANY_ID  = B.COMPANY_ID      ' + char(10)
			SELECT @v_dSql2 += '                                 AND   I.DIVISION_ID = B.DIVISION_ID     ' + char(10)
			SELECT @v_dSql2 += '                                 AND   I.SITE_ID     = B.SITE_ID         ' + char(10)
			SELECT @v_dSql2 += '                                 AND   I.ITEM_ID     = B.CHILD_ITEM_ID   ' + char(10)
			SELECT @v_dSql2 += '                                 AND   B.CHILD_ITEM_ID LIKE ''APC%''     ' + char(10)
			SELECT @v_dSql2 += '                                 AND   A.COMPANY_ID  = B.COMPANY_ID      ' + char(10)
			SELECT @v_dSql2 += '                                 AND   A.DIVISION_ID = B.DIVISION_ID     ' + char(10)
			SELECT @v_dSql2 += '                                 AND   A.SITE_ID     = B.SITE_ID         ' + char(10)
			SELECT @v_dSql2 += '                                 AND   A.PLANT_ID    = B.PLANT_ID        ' + char(10)
			SELECT @v_dSql2 += '                                 AND   A.ITEM_ID     = B.PARENT_ITEM_ID  ' + char(10)
			SELECT @v_dSql2 += '                                 AND   B.EFF_START_DATE <= GETDATE()     ' + char(10)
			SELECT @v_dSql2 += '                                 AND   B.EFF_END_DATE   > GETDATE()      ' + char(10)
			SELECT @v_dSql2 += '                                 AND   I.ITEM_UOM    = ''M''             ' + char(10)
			SELECT @v_dSql2 += '                                 AND   IL.ITEM_ID    = B.CHILD_ITEM_ID   ' + char(10)
			SELECT @v_dSql2 += '                                 AND   IL.PC_ROLL_LENGTH IS NOT NULL     ' + char(10)
			SELECT @v_dSql2 += '                                 AND   IL.PC_ROLL_LENGTH > 0             ' + char(10)
			SELECT @v_dSql2 += '                                 AND   IL.LANE_QTY       > 0             ' + char(10)
			SELECT @v_dSql2 += '                                 AND   IL.ACTIVE_FLAG    = ''Y''         ' + char(10)
			SELECT @v_dSql2 += '                                 ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END) ' + char(10)
			SELECT @v_dSql2 += '                                         ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)   ' + char(10)
			SELECT @v_dSql2 += '                                         ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)         ' + char(10)
			SELECT @v_dSql2 += '                                         ,PC_ROLL_LENGTH, LANE_QTY                                     ' + char(10)
			SELECT @v_dSql2 += '                               )                                                ' + char(10)
			SELECT @v_dSql2 += '                         ,( SELECT TOP 1 A.CELL_IN_QTY/                         ' + char(10)
			SELECT @v_dSql2 += '                                 ( SELECT  TOP 1 VALUE AS CELL_M                ' + char(10)
			SELECT @v_dSql2 += '                                   FROM SCM_ITEM_CONV_CALC_M C WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql2 += '                                   WHERE  C.MAX_VER_FLAG = ''Y''                ' + char(10)
			SELECT @v_dSql2 += '                                   AND    ISNULL(C.VALUE, 0) > 0                ' + char(10)
			SELECT @v_dSql2 += '                                   AND    C.CATEGORY     = ''Pancake (cell/m)'' ' + char(10)
			SELECT @v_dSql2 += '                                   AND    C.OPERATION    = ''E2000''            ' + char(10)
			SELECT @v_dSql2 += '                                   AND    C.ITEM_ID      = B.CHILD_ITEM_ID      ' + char(10)
			SELECT @v_dSql2 += '                                   ORDER BY (CASE WHEN C.DIVISION_ID  = B.DIVISION_ID THEN 1 ELSE 2 END ' + char(10)
			SELECT @v_dSql2 += '                                  )                                                            ' + char(10)
			SELECT @v_dSql2 += '                              ,(CASE WHEN C.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)       ' + char(10)
			SELECT @v_dSql2 += '                              ,(CASE WHEN C.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)             ' + char(10)
			SELECT @v_dSql2 += '                              ,(CASE WHEN A.FP_PRODUCTION_TYPE LIKE ''%TEST'' THEN             ' + char(10)
			SELECT @v_dSql2 += '                                    (CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 1 ELSE 2 END)    ' + char(10)
			SELECT @v_dSql2 += '                                     ELSE                                                      ' + char(10)
			SELECT @v_dSql2 += '                                       (CASE WHEN C.VERSION_TYPE = ''TEST'' THEN 2 ELSE 1 END) ' + char(10)
			SELECT @v_dSql2 += '                                  END )                                                        ' + char(10)
			SELECT @v_dSql2 += '                              	,(CASE WHEN C.MODEL_ID	  = A.TOP_ITEM_ID THEN 1 ELSE 2 END)   ' + char(10)
			SELECT @v_dSql2 += '                              	,C.MODEL_ID                                                    ' + char(10)
			SELECT @v_dSql2 += '                              	,( CASE WHEN C.VERSION  LIKE ''Z%'' THEN REPLACE(C.VERSION, ''Z'', ''/'')  ' + char(10)
			SELECT @v_dSql2 += '                              	   ELSE C.VERSION END ) DESC ) / ( PC_ROLL_LENGTH*LANE_QTY)                ' + char(10)
			SELECT @v_dSql2 += '                            FROM   SCM_ITEM_M	I WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql2 += '                               , SCM_BOM_M		B WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql2 += '                               , SCM_ITEM_LANE_M IL WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql2 += '                            WHERE I.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
			SELECT @v_dSql2 += '                            AND   I.DIVISION_ID = B.DIVISION_ID    ' + char(10)
			SELECT @v_dSql2 += '                            AND   I.SITE_ID     = B.SITE_ID        ' + char(10)
			SELECT @v_dSql2 += '                            AND   I.ITEM_ID     = B.CHILD_ITEM_ID  ' + char(10)
			SELECT @v_dSql2 += '                            AND   B.CHILD_ITEM_ID LIKE ''APC%''    ' + char(10)
			SELECT @v_dSql2 += '                            AND   A.COMPANY_ID  = B.COMPANY_ID     ' + char(10)
			SELECT @v_dSql2 += '                            AND   A.DIVISION_ID = B.DIVISION_ID    ' + char(10)
			SELECT @v_dSql2 += '                            AND   A.SITE_ID     = B.SITE_ID        ' + char(10)
			SELECT @v_dSql2 += '                            AND   A.PLANT_ID    = B.PLANT_ID       ' + char(10)
			SELECT @v_dSql2 += '                            AND   A.ITEM_ID     = B.PARENT_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '                            AND   B.EFF_START_DATE <= GETDATE()    ' + char(10)
			SELECT @v_dSql2 += '                            AND   B.EFF_END_DATE  > GETDATE()      ' + char(10)
			SELECT @v_dSql2 += '                            AND   I.ITEM_UOM != ''M''              ' + char(10)
			SELECT @v_dSql2 += '                            AND   IL.ITEM_ID = B.CHILD_ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '                            AND   IL.PC_ROLL_LENGTH IS NOT NULL    ' + char(10)
			SELECT @v_dSql2 += '                            AND   IL.PC_ROLL_LENGTH > 0            ' + char(10)
			SELECT @v_dSql2 += '                            AND   IL.LANE_QTY > 0                  ' + char(10)
			SELECT @v_dSql2 += '                            AND   IL.ACTIVE_FLAG = ''Y''           ' + char(10)
			SELECT @v_dSql2 += '                            ORDER BY (CASE WHEN IL.DIVISION_ID = B.DIVISION_ID THEN 1 ELSE 2 END) ' + char(10)
			SELECT @v_dSql2 += '                             ,(CASE WHEN IL.COMPANY_ID = B.COMPANY_ID THEN 1 ELSE 2 END)          ' + char(10)
			SELECT @v_dSql2 += '                             ,(CASE WHEN IL.SITE_ID = B.SITE_ID THEN 1 ELSE 2 END)                ' + char(10)
			SELECT @v_dSql2 += '                             ,PC_ROLL_LENGTH                          ' + char(10)
			SELECT @v_dSql2 += '                             ,LANE_QTY                                ' + char(10)
			SELECT @v_dSql2 += '                        )	)  AS CUT_QTY                             ' + char(10)
			SELECT @v_dSql2 += '                        , A.PLAN_TYPE                                 ' + char(10)
			SELECT @v_dSql2 += '                        , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
			SELECT @v_dSql2 += '	                FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                    WHERE  1=1                                        ' + char(10)
			SELECT @v_dSql2 += '                    AND    A.PLAN_TYPE = ''RELEASE''                  ' + char(10)
			SELECT @v_dSql2 += '                    AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)

			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
			SELECT @v_dSql3 += '                    AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0                        ' + char(10)
			SELECT @v_dSql3 += '                    UNION ALL                                                     ' + char(10)
			SELECT @v_dSql3 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
			SELECT @v_dSql3 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			SELECT @v_dSql3 += '                       , NULL AS BOH_QTY, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += '                       , A.MARKET, ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE      ' + char(10)
			SELECT @v_dSql3 += '                       , A.PLAN_DATE, 0 IN_QTY, 0 OUT_QTY, 0 AS CELL_IN_QTY       ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS CELL_OUT_QTY, A.ACTUAL_GOOD_QTY AS RESULT_QTY       ' + char(10) -- Result
			SELECT @v_dSql3 += '                       , A.CELL_OUT_QTY AS RESULT_QTY_CELL, 0 AS OFF_TIME         ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS CUT_QTY, ''P_RESULT'' AS PLAN_TYPE                  ' + char(10)
			SELECT @v_dSql3 += '                       , A.CELL_OUT_QTY AS RESULT_QTY2_CELL, A.ACTUAL_GOOD_QTY AS RESULT_QTY2 ' + char(10) -- Result(+Exp.)
			SELECT @v_dSql3 += '                    FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)              ' + char(10)
			SELECT @v_dSql3 += '                    WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
			SELECT @v_dSql3 += '                    AND   (A.ACTUAL_GOOD_QTY ) > 0                              ' + char(10)
													-- 미래 실적 추가 : 계획수량
			SELECT @v_dSql3 += '                    UNION ALL ' + char(10)
			SELECT @v_dSql3 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql3 += '                         , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                         , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION ' + char(10)
			SELECT @v_dSql3 += '                         , NULL AS BOH_QTY, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql3 += '                         , A.MARKET, ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql3 += '                         , A.PLAN_DATE, 0 IN_QTY, 0 OUT_QTY, 0 AS CELL_IN_QTY ' + char(10)
			SELECT @v_dSql3 += '                         , 0 AS CELL_OUT_QTY, 0 AS RESULT_QTY ' + char(10)
			SELECT @v_dSql3 += '                         , 0 AS RESULT_QTY_CELL, 0 AS OFF_TIME ' + char(10)
			SELECT @v_dSql3 += '                         , 0 AS CUT_QTY, ''P_RESULT_EXP'' AS PLAN_TYPE ' + char(10)
			SELECT @v_dSql3 += '                         , A.CELL_OUT_QTY AS RESULT_QTY2_CELL ' + char(10) -- Result(Exp.)
			SELECT @v_dSql3 += '                         , A.PLAN_QTY AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
			SELECT @v_dSql3 += '                    FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                    WHERE  1=1 ' + char(10)
			SELECT @v_dSql3 += '                    AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10) -- 당일 부터 end date 까지
			SELECT @v_dSql3 += '                    AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))     + char(10)
			SELECT @v_dSql3 += '                    ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
			SELECT @v_dSql3 += '                    AND    (ISNULL(A.PLAN_IN_QTY,0) + ISNULL(A.PLAN_QTY,0) + ISNULL(A.CELL_IN_QTY,0) + ISNULL(A.CELL_OUT_QTY,0)) > 0 ' + char(10)
			SELECT @v_dSql3 += '                    UNION ALL                                                   ' + char(10)
			SELECT @v_dSql3 += '                    SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
			SELECT @v_dSql3 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			SELECT @v_dSql3 += '                       , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
			SELECT @v_dSql3 += '                       , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE                ' + char(10)
			SELECT @v_dSql3 += '                       , B.OFF_DATE AS PLAN_DATE, 0 AS IN_QTY, 0 AS OUT_QTY       ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS CELL_IN_QTY, 0 AS CELL_OUT_QTY, 0 AS RESULT_QTY     ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS RESULT_QTY_CELL, B.OFF_TIME AS OFF_TIME             ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS CUT_QTY, ''P_OFFTIME'' AS PLAN_TYPE                 ' + char(10)
			SELECT @v_dSql3 += '                       , 0 AS RESULT_QTY2_CELL, 0 AS RESULT_QTY2 ' + char(10) -- Result(Exp.)
			SELECT @v_dSql3 += '                    FROM (                                                        ' + char(10)
			SELECT @v_dSql3 += '                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                                , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID          ' + char(10)
			SELECT @v_dSql3 += '                                , A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                              ' + char(10)
			SELECT @v_dSql3 += '                            FROM (                                                                                    ' + char(10)
			SELECT @v_dSql3 += '                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                                     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, '''' AS EQUIPMENT_ID              ' + char(10)
			SELECT @v_dSql3 += '                                     , A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET    ' + char(10)
			SELECT @v_dSql3 += '                                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                                   ' + char(10)
			SELECT @v_dSql3 += '                                  WHERE  1=1                                                                          ' + char(10)
			SELECT @v_dSql3 += '                                  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.PLAN_TYPE IN ( ''RELEASE'', ''WPP'', ''MPP'' ) ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))               + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                       + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))                 + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                       + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))               + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                       + char(10)
			SELECT @v_dSql3 += '                                  AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0                  ' + char(10)
			SELECT @v_dSql3 += '                                  UNION ALL                                               ' + char(10)
			SELECT @v_dSql3 += '                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                                       , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, '''' AS EQUIPMENT_ID            ' + char(10)
			SELECT @v_dSql3 += '                                       , A.TOP_ITEM_ID, A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET  ' + char(10)
			SELECT @v_dSql3 += '                                  FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)                                    ' + char(10)
			SELECT @v_dSql3 += '                                  WHERE  1=1                                                                          ' + char(10)
			SELECT @v_dSql3 += '                                  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
    
			SELECT @v_dSql3 += '		    			          AND 	(A.ACTUAL_GOOD_QTY) > 0                 ' + char(10)
			SELECT @v_dSql3 += '    			        	  ) A                                               ' + char(10)
			SELECT @v_dSql3 += '	    				      WHERE 1=1                                         ' + char(10)
			SELECT @v_dSql3 += '	    				      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LOCATION, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '	    				         , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID       ' + char(10)
			SELECT @v_dSql3 += '	    				         , A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                           ' + char(10)
			SELECT @v_dSql3 += '                        ) A                                                                                         ' + char(10)
			SELECT @v_dSql3 += '		                LEFT OUTER JOIN                                                                             ' + char(10)
			SELECT @v_dSql3 += '                                (                                                                                   ' + char(10)
			SELECT @v_dSql3 += '                                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID  ' + char(10)
			SELECT @v_dSql3 += '                                     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE                                  ' + char(10)
			SELECT @v_dSql3 += '                                     , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME   ' + char(10)
			SELECT @v_dSql3 += '                                  FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                                  INNER JOIN SCM_LINE_M B WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql3 += '                                  ON     A.COMPANY_ID     = B.COMPANY_ID        ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.DIVISION_ID    = B.DIVISION_ID       ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.SITE_ID        = B.SITE_ID           ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.PLANT_ID       = B.PLANT_ID          ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.FACTORY_ID     = B.FACTORY_ID        ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.OPERATION_ID   = B.OPERATION_ID      ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.LINE_ID        = B.LINE_ID           ' + char(10)
			SELECT @v_dSql3 += '                                  AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE    ' + char(10)
			SELECT @v_dSql3 += '                                  WHERE  B.ACTIVE_FLAG    = ''Y'' ' + char(10)
			SELECT @v_dSql3 += '                                  AND    CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += '                      ) B                                         ' + char(10)
			SELECT @v_dSql3 += '                      ON    A.COMPANY_ID     = B.COMPANY_ID       ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.DIVISION_ID    = B.DIVISION_ID      ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.SITE_ID        = B.SITE_ID          ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.PLANT_ID       = B.PLANT_ID         ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.FACTORY_ID     = B.FACTORY_ID       ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.OPERATION_ID   = B.OPERATION_ID     ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.LINE_ID        = B.LINE_ID          ' + char(10)
			SELECT @v_dSql3 += '                      AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE   ' + char(10)
			SELECT @v_dSql3 += '         ) A                                                      ' + char(10)
			SELECT @v_dSql3 += '         INNER JOIN (                                             ' + char(10)
			SELECT @v_dSql3 += '                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                ' + char(10)
			SELECT @v_dSql3 += '                     ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000''                                    ' + char(10)
			SELECT @v_dSql3 += '                                  AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME   ' + char(10)
			SELECT @v_dSql3 += '                            WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql3 += '                         ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                    ' + char(10)
			SELECT @v_dSql3 += '                     ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                      ' + char(10)
			SELECT @v_dSql3 += '                 FROM   SCM_ITEM_M A WITH(NOLOCK)                                                 ' + char(10)
			SELECT @v_dSql3 += '                       ,SCM_ITEM_CLASS_M C WITH(NOLOCK)                                           ' + char(10)
			SELECT @v_dSql3 += '                 WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                               ' + char(10)
    
			IF(LEN(@p_nick_name) > 0)
				BEGIN
					SELECT @v_dSql3 += '                 AND   A.NICK_NAME LIKE ''%' + @p_nick_name + '%''   ' + char(10)
    			END
    
			SELECT @v_dSql3 += '         ) B                                            ' + char(10)
			SELECT @v_dSql3 += '         ON     A.COMPANY_ID  = B.COMPANY_ID            ' + char(10)
			SELECT @v_dSql3 += '         AND    A.DIVISION_ID = B.DIVISION_ID           ' + char(10)
			SELECT @v_dSql3 += '         AND    A.SITE_ID     = B.SITE_ID               ' + char(10)
			SELECT @v_dSql3 += '         AND    A.TOP_ITEM_ID     = B.ITEM_ID               ' + char(10)
			SELECT @v_dSql3 += '         INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '         ON  A.COMPANY_ID  = J.COMPANY_ID               ' + char(10)
			SELECT @v_dSql3 += '         AND A.DIVISION_ID = J.DIVISION_ID              ' + char(10)
			SELECT @v_dSql3 += '         AND A.SITE_ID     = J.SITE_ID                  ' + char(10)
			SELECT @v_dSql3 += '         AND A.TOP_ITEM_ID = J.ITEM_ID                  ' + char(10)
			SELECT @v_dSql3 += '         WHERE 1=1                                      ' + char(10)
			IF(LEN(@p_cell_group) > 0)
				BEGIN
					SELECT @v_dSql3 += '         AND   J.CELL_GROUP LIKE ''%'' + '+@v_cell_group +' + ''%''     ' + char(10)
    			END
			SELECT @v_dSql3 += '         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
			SELECT @v_dSql3 += '                    ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, J.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '                    ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION              ' + char(10)
			SELECT @v_dSql3 += '                    ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET                ' + char(10)
			SELECT @v_dSql3 += '                    ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE       ' + char(10)
			SELECT @v_dSql3 += '                    ,A.PLAN_TYPE                                           ' + char(10)
			SELECT @v_dSql3 += '      ) A                                                                  ' + char(10)
			SELECT @v_dSql3 += '      INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                            ' + char(10)
			SELECT @v_dSql3 += '      ON     A.COMPANY_ID  = C.COMPANY_ID                                  ' + char(10)
			SELECT @v_dSql3 += '      AND    A.DIVISION_ID = C.DIVISION_ID                                 ' + char(10)
			SELECT @v_dSql3 += '      AND    A.SITE_ID     = C.SITE_ID                                     ' + char(10)
			SELECT @v_dSql3 += '      AND    A.TOP_ITEM_ID = C.ITEM_ID                                     ' + char(10)
			SELECT @v_dSql3 += '      INNER JOIN (                                                         ' + char(10)
			SELECT @v_dSql3 += '            SELECT 10 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME,  ''CELL'' AS MEASURE_ID, ''M_IN_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 20 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME,  ''UOM'' AS MEASURE_ID, ''M_IN_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 30 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''M_OUT_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 40 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''M_OUT_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 50 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME,  ''CELL'' AS MEASURE_ID, ''W_IN_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 60 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME,  ''UOM'' AS MEASURE_ID, ''W_IN_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 70 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''W_OUT_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 80 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''W_OUT_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 90 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''P_IN_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 100 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''P_IN_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 110 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''P_OUT_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 120 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''P_OUT_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 130 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''P_RESULT_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 140 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''P_RESULT_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 141 AS CATE_ORDER, ''Result(+Exp.)'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''P_RESULT_EXP_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 142 AS CATE_ORDER, ''Result(+Exp.)'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''P_RESULT_EXP_UOM'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 148 AS CATE_ORDER, ''Cut'' AS CATE_NAME, '''' AS MEASURE_ID, ''P_CUT'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 150 AS CATE_ORDER, ''Off Cal.'' AS CATE_NAME, '''' AS MEASURE_ID, ''P_OFFTIME'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '            UNION ALL ' + char(10)
			SELECT @v_dSql3 += '            SELECT 160 AS CATE_ORDER, ''Memo'' AS CATE_NAME, '''' AS MEASURE_ID, ''P_MEMO'' AS CATE_ID ' + char(10)
			SELECT @v_dSql3 += '      ) D                                            ' + char(10)
			SELECT @v_dSql3 += '      ON     1=1                                     ' + char(10)
			SELECT @v_dSql3 += '      INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql3 += '      ON    A.COMPANY_ID     = E.COMPANY_ID          ' + char(10)
			SELECT @v_dSql3 += '      AND   A.DIVISION_ID    = E.DIVISION_ID         ' + char(10)
			SELECT @v_dSql3 += '      AND   A.SITE_ID        = E.SITE_ID             ' + char(10)
			SELECT @v_dSql3 += '      AND   A.PLANT_ID       = E.PLANT_ID            ' + char(10)
			SELECT @v_dSql3 += '      AND   A.FACTORY_ID     = E.FACTORY_ID          ' + char(10)
			SELECT @v_dSql3 += '      AND   A.OPERATION_ID   = E.OPERATION_ID        ' + char(10)
			SELECT @v_dSql3 += '      AND   A.LINE_ID        = E.LINE_ID             ' + char(10)
			SELECT @v_dSql3 += '      AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE      ' + char(10)
			SELECT @v_dSql3 += '      INNER HASH JOIN SCM_OPERATION_M F WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '       ON   A.COMPANY_ID     = F.COMPANY_ID          ' + char(10)
			SELECT @v_dSql3 += '      AND   A.DIVISION_ID    = F.DIVISION_ID         ' + char(10)
			SELECT @v_dSql3 += '      AND   A.SITE_ID        = F.SITE_ID             ' + char(10)
			SELECT @v_dSql3 += '      AND   A.OPERATION_ID   = F.OPERATION_ID        ' + char(10)
			SELECT @v_dSql3 += '      INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql3 += '      ON  A.PLAN_DATE        = G.DT                  ' + char(10)
			SELECT @v_dSql3 += '      WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_nick_name))         + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
    
			SELECT @v_dSql3 += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql3 += '          , A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-''), A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql3 += '          , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'')                       ' + char(10)
			SELECT @v_dSql3 += '          , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET                ' + char(10)
			SELECT @v_dSql3 += '          , A.LINE_ID, ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE               ' + char(10)
			--Begin Tuning_03
			SELECT @v_dSql3 += '          , D.CATE_NAME, D.MEASURE_ID, D.CATE_ORDER, D.CATE_NAME, D.CATE_ID;    ' + char(10)
			--SELECT @v_dSql3 += '  )                                                                              ' + char(10)
			SELECT @v_dSql4  = ''
			SELECT @v_dSql4 += '  -- [C20200213-000397]FP 생산계획 대비 실적 차이수량 집계를 통한 Off-line 계획수립 업무 Zero화 ' + char(10)
			SELECT @v_dSql4 += '  WITH MAIN_GAP AS (                                              ' + char(10)
			-- End Tuning_03
			/*-- OLD block_03
			SELECT @v_dSql3 += '          , D.CATE_NAME, D.MEASURE_ID, D.CATE_ORDER, D.CATE_NAME, D.CATE_ID    ' + char(10)
			SELECT @v_dSql3 += '  )                                                                              ' + char(10)
			SELECT @v_dSql4  = ''
			SELECT @v_dSql4 += '  -- [C20200213-000397]FP 생산계획 대비 실적 차이수량 집계를 통한 Off-line 계획수립 업무 Zero화 ' + char(10)
			SELECT @v_dSql4 += '  , MAIN_GAP AS (                                              ' + char(10)
			-- End OLD block_03*/

			SELECT @v_dSql4 += '    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql4 += '       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME    ' + char(10)
			SELECT @v_dSql4 += '       , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME        ' + char(10)
			SELECT @v_dSql4 += '       , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '       , A.PSI, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql4 += '       , A.CATE, A.MEASURE_ID                                  ' + char(10)

			--sql+= data.DAY2MONTH + data.DAY2WEEK
			SELECT @v_dSql4 = @v_dSql4 + @p_day2month + @p_day2week

			IF ISNULL(@p_day_info,'') <> '' 
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '!'  -- 데이터 구분자
					SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp1           = ''
					IF @max_loop_cnt > 0 
						BEGIN
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp1 += '            , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
						END 
				END

			SELECT @v_dSql4 = @v_dSql4 + @v_Tmp1

			SELECT @v_dSql4 += '       , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, A.S_ROW       ' + char(10)
			SELECT @v_dSql4 += '    FROM (                                                           ' + char(10)
			SELECT @v_dSql4 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql4 += '             , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME    ' + char(10)
			SELECT @v_dSql4 += '             , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME        ' + char(10)
			SELECT @v_dSql4 += '             , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '             , A.PSI, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql4 += '             , A.CATE , A.MEASURE_ID                                 ' + char(10)
    
			IF(@v_curr_date = '-999')
				BEGIN
					IF ISNULL(@p_day_info,'') <> '' 
						BEGIN
							SET @mst_loop_cnt     = 0
							SET @v_delimiter      = '!'  -- 데이터 구분자
							SET @sub_v_delimiter  = '#'
							SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
							SET @v_Tmp1           = ''

							IF @max_loop_cnt > 0 
								BEGIN
                    				-- bucket
                    				SET @mst_loop_cnt = 0	
                    				SET @max_loop_cnt = 0
                    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	    
				    				WHILE @mst_loop_cnt < @max_loop_cnt
                    					BEGIN
                    	        			  SELECT @v_Tmp1 += '             , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
                    	        			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
                    					END
								END 
	        			END
				END
			ELSE
				BEGIN
					IF ISNULL(@p_day_info,'') <> '' 
						BEGIN
							SET @mst_loop_cnt     = 0
							SET @v_delimiter      = '!'  -- 데이터 구분자
							SET @sub_v_delimiter  = '#'
							SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
							SET @v_Tmp1           = ''

							IF @max_loop_cnt > 0 
								BEGIN
				    
				    				 DECLARE @vFlag   NVARCHAR(1) = 'N'
                    				 -- bucket
                    				 SET @mst_loop_cnt = 0	
                    				 SET @max_loop_cnt = 0
                    				 SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                    	     
				    				 WHILE @mst_loop_cnt < @max_loop_cnt
				    					 BEGIN
				    						 IF(@v_curr_date = 'D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt))
                    							 BEGIN
                    	                 			  SELECT @v_Tmp1 += '             , 0  AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    								  SELECT @vFlag = 'Y'
                    							 END
				    						 ELSE
				    							 BEGIN
				    								 IF(@vFlag = 'Y')
				    									 BEGIN
				    										 SELECT @v_Tmp1 += '             , 0 AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    									 END
				    								 ELSE
				    									 BEGIN
				    										 SELECT @v_Tmp1 += '             , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ ' ' + char(10)
				    									 END
				    							 END
				    						 SET @mst_loop_cnt =  @mst_loop_cnt + 1
				    					 END
								END 
	        			END
				END
 
			SELECT @v_dSql4 =  @v_dSql4 + @v_Tmp1

			SELECT @v_dSql4 += '             , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, A.S_ROW                             ' + char(10)
			SELECT @v_dSql4 += '          FROM (                                                                                 ' + char(10)
			SELECT @v_dSql4 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID,        ' + char(10)
			SELECT @v_dSql4 += '                    A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                   , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'') AS OPERATION_NAME            ' + char(10)
			SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI         ' + char(10)
			SELECT @v_dSql4 += '                   , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME                           ' + char(10)
			SELECT @v_dSql4 += '                   , A.ELECTRODE_TYPE, D.CATE_NAME AS CATE, D.MEASURE_ID                         ' + char(10)
    
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

    							 SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => IS_PLAN (Y/N)
								 SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => D_Value (D0...DN)
								 SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 => _DATE(20210221)
								 --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
								 --SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
								 --SET @sub_param_5 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))

    							 SET @v_Tmp1 += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @sub_param_2 + ''' AND A.PLAN_DATE >= B.INSTANCE_DATE  THEN  ' + char(10)
    							 SET @v_Tmp1 += '                     ( CASE  WHEN D.CATE_ID = ''GAP_UOM'' THEN A.GAP_QTY WHEN D.CATE_ID = ''GAP_CELL'' THEN A.GAP_CELL_QTY ELSE 0 END )   ' + char(10)
    							 SET @v_Tmp1 += '                            ELSE 0 END  ) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +'                                                 ' + char(10)
    						 END 
    					END
				END
    
			SELECT @v_dSql4 =  @v_dSql4 + @v_Tmp1

			SELECT @v_dSql4 += '                   , D.CATE_ID AS CATEGORY_ID, D.CATE_ORDER AS CATEGORY_ORDER    ' + char(10)
			SELECT @v_dSql4 += '                   , ''DATA'' AS DATA_TYPE, NULL AS S_ROW                        ' + char(10)
			SELECT @v_dSql4 += '                FROM (                                                           ' + char(10)
			SELECT @v_dSql4 += '                      SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                         ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, J.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                         ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION               ' + char(10)
			SELECT @v_dSql4 += '                         ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET                 ' + char(10)
			SELECT @v_dSql4 += '                         ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE        ' + char(10)
			SELECT @v_dSql4 += '                         ,A.PLAN_TYPE, SUM(A.GAP_QTY) AS GAP_QTY                 ' + char(10)
			SELECT @v_dSql4 += '                         ,SUM(A.GAP_CELL_QTY) AS GAP_CELL_QTY                    ' + char(10)
			SELECT @v_dSql4 += '                      FROM (                                                     ' + char(10)
			SELECT @v_dSql4 += '                            -- 생산실적 차질분 표시 ' + char(10)
			SELECT @v_dSql4 += '                            SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID              ' + char(10)
			SELECT @v_dSql4 += '                               , A.TOP_ITEM_ID, A.ITEM_ID, NULL AS ITEM_TYPE, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                               , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION                          ' + char(10)
			SELECT @v_dSql4 += '                               , NULL AS BOH_QTY, A.PRODUCTION_TYPE, A.MARKET                      ' + char(10)
			SELECT @v_dSql4 += '                               , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE            ' + char(10)
			SELECT @v_dSql4 += '                               , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
			SELECT @v_dSql4 += '                               , ROUND(SUM(ISNULL(A.RESULT_QTY_CELL,0)),0) - ROUND(SUM(ISNULL(A.CELL_OUT_QTY,0)),0) AS GAP_CELL_QTY ' + char(10)
			SELECT @v_dSql4 += '                               , ''GAP'' AS PLAN_TYPE                                       ' + char(10)
			SELECT @v_dSql4 += '                            FROM (                                                          ' + char(10)
			SELECT @v_dSql4 += '                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                                  	 , A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                                  	 , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION   ' + char(10)
			SELECT @v_dSql4 += '                                  	 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET    ' + char(10)
			SELECT @v_dSql4 += '                                  	 , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE             ' + char(10)
			SELECT @v_dSql4 += '                                  	 , A.PLAN_QTY AS OUT_QTY, A.CELL_OUT_QTY                ' + char(10)
			SELECT @v_dSql4 += '                                  	 , 0 AS RESULT_QTY, 0 AS RESULT_QTY_CELL                ' + char(10)
			SELECT @v_dSql4 += '                                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql4 += '                                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '                                  AND 	A.PLAN_TYPE = ''RELEASE''                 ' + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10) 
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))           + char(10)
			SELECT @v_dSql4 += '                                  AND 	(A.PLAN_IN_QTY + A.PLAN_QTY) > 0                    ' + char(10)
			SELECT @v_dSql4 += '                                  UNION ALL                                                 ' + char(10)
			SELECT @v_dSql4 += '                                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                                     , A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                                     , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION   ' + char(10)
			SELECT @v_dSql4 += '                                     , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET    ' + char(10)
			SELECT @v_dSql4 += '                                     , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE             ' + char(10)
			SELECT @v_dSql4 += '                                     , 0 OUT_QTY, 0 AS CELL_OUT_QTY                         ' + char(10)
			SELECT @v_dSql4 += '                                     , A.ACTUAL_GOOD_QTY AS RESULT_QTY                      ' + char(10)
			SELECT @v_dSql4 += '                                     , A.CELL_OUT_QTY AS RESULT_QTY_CELL                    ' + char(10)
			SELECT @v_dSql4 += '                                  FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql4 += '                                  WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10) 
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))           + char(10)
			SELECT @v_dSql4 += '        		                  AND   (A.ACTUAL_GOOD_QTY ) > 0              ' + char(10)
			SELECT @v_dSql4 += '                        ) A                                                   ' + char(10)
			SELECT @v_dSql4 += '  	                    -- 확정시점 가져오기 ' + char(10)
                       
			IF(@p_confirm_area = 'BUILDING') 
				BEGIN
					SELECT @v_dSql4 += '                        INNER JOIN (                                                                                                ' + char(10)
					SELECT @v_dSql4 += '                                    SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE                         ' + char(10)
					SELECT @v_dSql4 += '                                    FROM (                                                                                          ' + char(10)
					SELECT @v_dSql4 += '                                         SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME      ' + char(10)
					SELECT @v_dSql4 += '                                         	 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                                         FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)              ' + char(10)
					SELECT @v_dSql4 += '                                         WHERE  A.INSTANCE_ID = ' + @v_instance_id + '             ' + char(10)
					SELECT @v_dSql4 += '                                         AND    A.FACTORY_ID IN (                                  ' + char(10)
					SELECT @v_dSql4 += '                                                      SELECT DISTINCT B.FACTORY_ID                 ' + char(10)
					SELECT @v_dSql4 += '                                                      FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)  ' + char(10)
					SELECT @v_dSql4 += '                                                      INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
					SELECT @v_dSql4 += '                                                      ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
					SELECT @v_dSql4 += '                                                      AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                                                      AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10);
					SELECT @v_dSql4 += '                                                      AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
					SELECT @v_dSql4 += '                                                 )                          ' + char(10)
					SELECT @v_dSql4 += '                                          ) A                               ' + char(10);
					SELECT @v_dSql4 += '                                    WHERE A.ROW_NUM = 1                     ' + char(10)
					SELECT @v_dSql4 += '            				        ) B                                     ' + char(10)
					SELECT @v_dSql4 += '                        ON    A.FACTORY_ID = B.FACTORY_ID                   ' + char(10)
					SELECT @v_dSql4 += '                        WHERE A.PLAN_DATE >= B.INSTANCE_DATE                ' + char(10)
				END
			ELSE --plan groupd 단위
				BEGIN
					SELECT @v_dSql4 += '                        INNER JOIN SCM_LINE_M C WITH(NOLOCK)                ' + char(10)
					SELECT @v_dSql4 += '                         ON  A.COMPANY_ID     = C.COMPANY_ID                ' + char(10)
					SELECT @v_dSql4 += '                         AND A.DIVISION_ID    = C.DIVISION_ID               ' + char(10)
					SELECT @v_dSql4 += '                         AND A.SITE_ID        = C.SITE_ID                   ' + char(10)
					SELECT @v_dSql4 += '                         AND A.PLANT_ID       = C.PLANT_ID                  ' + char(10)
					SELECT @v_dSql4 += '                         AND A.FACTORY_ID     = C.FACTORY_ID                ' + char(10)
					SELECT @v_dSql4 += '                         AND A.OPERATION_ID   = C.OPERATION_ID              ' + char(10)
					SELECT @v_dSql4 += '                         AND A.LINE_ID        = C.LINE_ID                   ' + char(10)
					SELECT @v_dSql4 += '                         AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE            ' + char(10)
					SELECT @v_dSql4 += '                         INNER JOIN (                                       ' + char(10)
					SELECT @v_dSql4 += '                                    SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE ' + char(10)
					SELECT @v_dSql4 += '                                    FROM (                                  ' + char(10)
					SELECT @v_dSql4 += '                                          SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
					SELECT @v_dSql4 += '                                          	 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                                          FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                         ' + char(10)
					SELECT @v_dSql4 += '                                          WHERE  A.INSTANCE_ID = ' + @v_instance_id + '                        ' + char(10)
					SELECT @v_dSql4 += '                                          AND    A.PLAN_GROUP_ID IN (                                          ' + char(10)
					SELECT @v_dSql4 += '                                                       SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID             ' + char(10)
					SELECT @v_dSql4 += '                                                       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
					SELECT @v_dSql4 += '                                                       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
					SELECT @v_dSql4 += '                                                       AND    A.ACTIVE_FLAG = ''Y''                            ' + char(10)
					SELECT @v_dSql4 += '                                                       AND    A.SEGMENT1 = ' + @v_instance_id + '              ' + char(10)
					SELECT @v_dSql4 += '                                          )                                           ' + char(10)
					SELECT @v_dSql4 += '                                    ) A                                               ' + char(10)
					SELECT @v_dSql4 += '                                    WHERE A.ROW_NUM = 1                               ' + char(10)
					SELECT @v_dSql4 += '                         ) B                                                          ' + char(10)
					SELECT @v_dSql4 += '                         ON    C.MODEL_TYPE = B.PLAN_GROUP_ID                         ' + char(10)
					SELECT @v_dSql4 += '                         WHERE A.PLAN_DATE >= B.INSTANCE_DATE                         ' + char(10)
				END
    
			SELECT @v_dSql4 += '                   GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                   	  , A.TOP_ITEM_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION    ' + char(10)
			SELECT @v_dSql4 += '                   	  , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql4 += '               ) A                                                                            ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN (                                                                   ' + char(10)
			SELECT @v_dSql4 += '                          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                                          ' + char(10)
			SELECT @v_dSql4 += '                             ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql4 += '                              	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')                           ' + char(10)
			SELECT @v_dSql4 += '                              	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE  ' + char(10)
			SELECT @v_dSql4 += '                             ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME        ' + char(10)
			SELECT @v_dSql4 += '                          FROM  SCM_ITEM_M A WITH(NOLOCK)                   ' + char(10)
			SELECT @v_dSql4 += '                               ,SCM_ITEM_CLASS_M C WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql4 += '                          WHERE	 A.ITEM_CLASS  = C.CLASS_ID                 ' + char(10)
			IF(LEN(@p_nick_name) > 0)
				BEGIN
					SELECT @v_dSql4 += '                  AND    A.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_nick_name + ')) + ''%'' ' + char(10)
				END
			SELECT @v_dSql4 += '               ) B                                             ' + char(10)
			SELECT @v_dSql4 += '               ON   A.COMPANY_ID  = B.COMPANY_ID               ' + char(10)
			SELECT @v_dSql4 += '               AND  A.DIVISION_ID = B.DIVISION_ID              ' + char(10)
			SELECT @v_dSql4 += '               AND  A.SITE_ID     = B.SITE_ID                  ' + char(10)
			SELECT @v_dSql4 += '               AND  A.ITEM_ID     = B.ITEM_ID                  ' + char(10)
			SELECT @v_dSql4 += '               INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '               ON  A.COMPANY_ID  = J.COMPANY_ID                ' + char(10)
			SELECT @v_dSql4 += '               AND A.DIVISION_ID = J.DIVISION_ID               ' + char(10)
			SELECT @v_dSql4 += '               AND A.SITE_ID     = J.SITE_ID                   ' + char(10)
			SELECT @v_dSql4 += '               AND A.TOP_ITEM_ID = J.ITEM_ID                   ' + char(10)
			SELECT @v_dSql4 += '               WHERE 1=1                                       ' + char(10)
    
			IF(LEN(@p_cell_group) > 0)
				BEGIN
					SELECT @v_dSql4 += '               AND   J.CELL_GROUP LIKE ''%'' + '+ @v_cell_group +' + ''%''   ' + char(10)
    			END
			SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
			SELECT @v_dSql4 += '                          ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, J.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                          ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION            ' + char(10)
			SELECT @v_dSql4 += '                          ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET              ' + char(10)
			SELECT @v_dSql4 += '                          ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE     ' + char(10)
			SELECT @v_dSql4 += '                          ,A.PLAN_TYPE                                         ' + char(10)
			SELECT @v_dSql4 += '            ) A                                                                ' + char(10)
			SELECT @v_dSql4 += '            INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                          ' + char(10)
			SELECT @v_dSql4 += '            ON     A.COMPANY_ID  = C.COMPANY_ID                                ' + char(10)
			SELECT @v_dSql4 += '            AND    A.DIVISION_ID = C.DIVISION_ID                               ' + char(10)
			SELECT @v_dSql4 += '            AND    A.SITE_ID     = C.SITE_ID                                   ' + char(10)
			SELECT @v_dSql4 += '            AND    A.TOP_ITEM_ID = C.ITEM_ID                                   ' + char(10)
			SELECT @v_dSql4 += '            INNER JOIN (                                                       ' + char(10)
			SELECT @v_dSql4 += '               SELECT 143 AS CATE_ORDER, ''Accu. GAP'' AS CATE_NAME, ''CELL'' AS MEASURE_ID, ''GAP_CELL'' AS CATE_ID ' + char(10)
			SELECT @v_dSql4 += '               UNION ALL                                                                                               ' + char(10)
			SELECT @v_dSql4 += '               SELECT 144 AS CATE_ORDER, ''Accu. GAP'' AS CATE_NAME, ''UOM'' AS MEASURE_ID, ''GAP_UOM'' AS CATE_ID   ' + char(10)
			SELECT @v_dSql4 += '            ) D                                                 ' + char(10)
			SELECT @v_dSql4 += '            ON     1=1                                          ' + char(10)
			SELECT @v_dSql4 += '            INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql4 += '            ON   A.COMPANY_ID     = E.COMPANY_ID                ' + char(10)
			SELECT @v_dSql4 += '            AND  A.DIVISION_ID    = E.DIVISION_ID               ' + char(10)
			SELECT @v_dSql4 += '            AND  A.SITE_ID        = E.SITE_ID                   ' + char(10)
			SELECT @v_dSql4 += '            AND  A.PLANT_ID       = E.PLANT_ID                  ' + char(10)
			SELECT @v_dSql4 += '            AND  A.FACTORY_ID     = E.FACTORY_ID                ' + char(10)
			SELECT @v_dSql4 += '            AND  A.OPERATION_ID   = E.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += '            AND  A.LINE_ID        = E.LINE_ID                   ' + char(10)
			SELECT @v_dSql4 += '            AND  A.ELECTRODE_TYPE = E.ELECTRODE_TYPE            ' + char(10)
			SELECT @v_dSql4 += '            INNER HASH JOIN SCM_OPERATION_M F WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql4 += '      	    ON   A.COMPANY_ID     = F.COMPANY_ID                ' + char(10)
			SELECT @v_dSql4 += '            AND  A.DIVISION_ID    = F.DIVISION_ID               ' + char(10)
			SELECT @v_dSql4 += '            AND  A.SITE_ID        = F.SITE_ID                   ' + char(10)
			SELECT @v_dSql4 += '            AND  A.OPERATION_ID   = F.OPERATION_ID              ' + char(10)
			SELECT @v_dSql4 += '            INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql4 += '            ON  A.PLAN_DATE       = G.DT                        ' + char(10)
			SELECT @v_dSql4 += '            -- 확정시점 가져오기                                ' + char(10)
    
			IF(@p_confirm_area = 'BUILDING') 
				BEGIN
					SELECT @v_dSql4 += '            INNER JOIN (                                ' + char(10)
					SELECT @v_dSql4 += '                   SELECT A.FACTORY_ID, A.INSTANCE_DATE ' + char(10)
					SELECT @v_dSql4 += '                   FROM (                               ' + char(10)
					SELECT @v_dSql4 += '                       SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME  ' + char(10)
					SELECT @v_dSql4 += '                       , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                       FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)     ' + char(10)
					SELECT @v_dSql4 += '                       WHERE  A.INSTANCE_ID = ' + @v_instance_id + '    ' + char(10)
					SELECT @v_dSql4 += '                       AND    A.FACTORY_ID IN (                         ' + char(10)
					SELECT @v_dSql4 += '                           SELECT DISTINCT B.FACTORY_ID                 ' + char(10)
					SELECT @v_dSql4 += '                           FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)  ' + char(10)
					SELECT @v_dSql4 += '                           INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
					SELECT @v_dSql4 += '                           ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
					SELECT @v_dSql4 += '                           AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                           AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                           AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
					SELECT @v_dSql4 += '                       )                                                ' + char(10)
					SELECT @v_dSql4 += '                   ) A                                                  ' + char(10)
					SELECT @v_dSql4 += '                   WHERE A.ROW_NUM = 1                                  ' + char(10)
					SELECT @v_dSql4 += '               ) B                                                      ' + char(10)
					SELECT @v_dSql4 += '                ON  A.FACTORY_ID = B.FACTORY_ID                         ' + char(10)
    			END
			ELSE -- plan groupd 단위
				BEGIN
					SELECT @v_dSql4 += '               INNER JOIN (                                             ' + char(10)
					SELECT @v_dSql4 += '               	     SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE            ' + char(10)
					SELECT @v_dSql4 += '               	     FROM (                                             ' + char(10)
					SELECT @v_dSql4 += '               	          SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
					SELECT @v_dSql4 += '               	          	 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '               	          FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                  ' + char(10)
					SELECT @v_dSql4 += '               	          WHERE  A.INSTANCE_ID = ' + @v_instance_id + '                 ' + char(10)
					SELECT @v_dSql4 += '               	          AND    A.PLAN_GROUP_ID IN (                                   ' + char(10)
					SELECT @v_dSql4 += '               	          		SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID             ' + char(10)
					SELECT @v_dSql4 += '               	          		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
					SELECT @v_dSql4 += '               	          		WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
					SELECT @v_dSql4 += '               	          		AND    A.ACTIVE_FLAG = ''Y''                            ' + char(10)
					SELECT @v_dSql4 += '               	          		AND    A.SEGMENT1 = ' + @v_instance_id + '              ' + char(10)
					SELECT @v_dSql4 += '               	           )                                                            ' + char(10)
					SELECT @v_dSql4 += '               	     ) A                                                                ' + char(10)
					SELECT @v_dSql4 += '               	     WHERE A.ROW_NUM = 1                                                ' + char(10)
					SELECT @v_dSql4 += '               ) B                                                                      ' + char(10)
					SELECT @v_dSql4 += '               ON    E.MODEL_TYPE = B.PLAN_GROUP_ID                                     ' + char(10)
    			END
    
			SELECT @v_dSql4 += '            WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))          + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                  + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))            + char(10) 
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))        + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                  + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                  + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_nick_name))              + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))        + char(10)
    
			SELECT @v_dSql4 += '            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '                , A.ITEM_ID, A.ITEM_TYPE, ISNULL(C.NICK_NAME,''-''), A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql4 += '                , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-''), A.FACTORY_ID         ' + char(10)
			SELECT @v_dSql4 += '                , A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID                   ' + char(10)
			SELECT @v_dSql4 += '                , ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE, D.CATE_NAME             ' + char(10)
			SELECT @v_dSql4 += '                , D.MEASURE_ID, D.CATE_ORDER, D.CATE_NAME, D.CATE_ID                   ' + char(10)
			SELECT @v_dSql4 += '          ) A  ' + char(10)
			SELECT @v_dSql4 += '      ) A      ' + char(10)
			SELECT @v_dSql4 += '  )            ' + char(10)
			SELECT @v_dSql4 += '  , MAIN_P_SUBT AS (                                                     ' + char(10)
			SELECT @v_dSql4 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
			SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME         ' + char(10)
			SELECT @v_dSql4 += '            , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql4 += '            , ''Total'' AS FACTORY_ID, NULL AS LOCATION                  ' + char(10)
			SELECT @v_dSql4 += '            , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI             ' + char(10)
			SELECT @v_dSql4 += '            , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '            , A.CATE, A.MEASURE_ID                                       ' + char(10)
	
			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
				IF @max_loop_cnt > 0 BEGIN
        			  -- monthinfo
        			  SET @mst_loop_cnt = 0
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp1       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp1 += '            , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        				  END
        	  
        			  -- weekinfo
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp2       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp2 += '            , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
        				  END
        	  
        			  -- bucket
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp3       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp3 += '            , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        				  END
				END 
			END

			SELECT @v_dSql4  = @v_dSql4 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql4 += '            , A.CATEGORY_ID                                                     ' + char(10)
			SELECT @v_dSql4 += '            , (CASE WHEN A.CATEGORY_ID=''M_IN_CELL'' THEN 100                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''M_IN_UOM'' THEN 200                    ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''M_OUT_CELL'' THEN 300                  ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''M_OUT_UOM'' THEN 400                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''W_IN_CELL'' THEN 500                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''W_IN_UOM'' THEN 600                    ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''W_OUT_CELL'' THEN 700                  ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''W_OUT_UOM'' THEN 800                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''P_IN_CELL'' THEN 900                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''P_IN_UOM'' THEN 1000                   ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''P_OUT_CELL'' THEN 1100                 ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''P_OUT_UOM'' THEN 1200                  ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID=''P_RESULT_CELL'' THEN 1300              ' + char(10)
			SELECT @v_dSql4 += '                    ELSE 1400 END) AS CATEGORY_ORDER                            ' + char(10)
			SELECT @v_dSql4 += '            , ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW                             ' + char(10)
			SELECT @v_dSql4 += '        FROM (                                                                  ' + char(10)
			SELECT @v_dSql4 += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' + char(10)
			SELECT @v_dSql4 += '                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME         ' + char(10)
			SELECT @v_dSql4 += '                   , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql4 += '                   , ''Total'' AS FACTORY_ID, NULL AS LOCATION                  ' + char(10)
			SELECT @v_dSql4 += '                   , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI             ' + char(10)
			SELECT @v_dSql4 += '                   , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '                   , A.CATE, A.MEASURE_ID                                       ' + char(10)
	
			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    

				IF @max_loop_cnt > 0 BEGIN
        			  -- monthinfo
        			  SET @mst_loop_cnt = 0
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp1       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp1 += '                   , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        				  END
        	  
        			  -- weekinfo
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp2       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp2 += '                   , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
        				  END
        	  
        			  -- bucket
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp3       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @v_Tmp3 += '                   , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        
        	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        				  END
				END 
			END

			SELECT @v_dSql4  = @v_dSql4 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql4 += '                   , A.CATEGORY_ID, ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW                                                  ' + char(10)
			SELECT @v_dSql4 += '                   , ROW_NUMBER( ) OVER( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                   ' + char(10)
			SELECT @v_dSql4 += '                        , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ' + char(10)
			SELECT @v_dSql4 += '                      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE   ' + char(10)
			SELECT @v_dSql4 += '                          , A.NICK_NAME, A.OPERATION_ID, A.CATEGORY_ID, A.PSI, A.CATE ) AS BOH_ROWNUM                      ' + char(10)
			SELECT @v_dSql4 += '              FROM #MAIN_P A                                               ' + char(10)--Tuning_04
			SELECT @v_dSql4 += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME      ' + char(10)
			SELECT @v_dSql4 += '                , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql4 += '                , A.CATEGORY_ID, A.PSI, A.CATE, A.MEASURE_ID              ' + char(10)
			SELECT @v_dSql4 += '        ) A                                                               ' + char(10)
			SELECT @v_dSql4 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
			SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME          ' + char(10)
			SELECT @v_dSql4 += '            , A.CELL_GROUP, A.PLM_EC_NO, A.OPERATION_ID, A.OPERATION_NAME              ' + char(10)
			SELECT @v_dSql4 += '            , A.CATEGORY_ID, A.PSI, A.CATE, A.MEASURE_ID                  ' + char(10)
			SELECT @v_dSql4 += '  )                                                                       ' + char(10)
      
			SELECT @v_dSql5 = ''
			SELECT @v_dSql5 += '  , T_RELEASE AS (      ' + char(10)
			SELECT @v_dSql5 += '    SELECT A.FACTORY_ID ' + char(10)

			IF isnull(@p_day_info,'') <> '' 
				BEGIN
    				SET @mst_loop_cnt = 0
    				SET @v_delimiter            = '!'  -- 데이터 구분자
    				SET @sub_v_delimiter = '#'
    				SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    	    
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

    							 SELECT @v_Tmp1 += '       , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112) = ''' + @sub_param_2 + ''' THEN ''Y'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  +'_BG ' + char(10)
    						 END
    					END
				END
    
			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1

			SELECT @v_dSql5 += '    FROM (                                                                        ' + char(10)
			SELECT @v_dSql5 += '          SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE ' + char(10)
			SELECT @v_dSql5 += '          FROM (                                                                  ' + char(10)
			SELECT @v_dSql5 += '                SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA           ' + char(10)
			SELECT @v_dSql5 += '                     , A.FACTORY_ID, A.INSERT_TIME                                                         ' + char(10)
			SELECT @v_dSql5 += '                     , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
			SELECT @v_dSql5 += '                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql5 += '                    , (                                                    ' + char(10)
			SELECT @v_dSql5 += '                       SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID         ' + char(10)
			SELECT @v_dSql5 += '                       FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql5 += '                       WHERE  A.ACTIVE_FLAG = ''Y''                        ' + char(10)
			SELECT @v_dSql5 += '                       AND    A.INSTANCE_ID = ' + @v_instance_id + '       ' + char(10)
			SELECT @v_dSql5 += '                    ) B                                                    ' + char(10)
			SELECT @v_dSql5 += '                WHERE  A.INSTANCE_ID  = B.INSTANCE_ID                      ' + char(10)
			SELECT @v_dSql5 += '                AND    A.FACTORY_ID   = B.FACTORY_ID                       ' + char(10)
			SELECT @v_dSql5 += '                AND    A.INSTANCE_ID  = ' + @v_instance_id + '             ' + char(10)
			SELECT @v_dSql5 += '          ) A                                                              ' + char(10)
			SELECT @v_dSql5 += '          , SCM_FP_PLAN_H B WITH(NOLOCK)                                   ' + char(10)
			SELECT @v_dSql5 += '          WHERE A.INSTANCE_ID  = B.INSTANCE_ID                             ' + char(10)
			SELECT @v_dSql5 += '          AND   A.PLAN_ID      = B.PLAN_ID                                 ' + char(10)
			SELECT @v_dSql5 += '          AND   A.SORT_ORDER   = 1                                         ' + char(10)
			SELECT @v_dSql5 += '          AND   A.CONFIRM_AREA IN (                                        ' + char(10)
			SELECT @v_dSql5 += '                        SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA           ' + char(10)
			SELECT @v_dSql5 += '                        FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql5 += '                        WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''        ' + char(10)
			SELECT @v_dSql5 += '                        AND    A.SEGMENT1         = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql5 += '                        AND    A.ACTIVE_FLAG      = ''Y''                  ' + char(10)
			SELECT @v_dSql5 += '          )         ' + char(10)
			SELECT @v_dSql5 += '          UNION ALL ' + char(10)
			SELECT @v_dSql5 += '          SELECT A.PLAN_GROUP_ID AS FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE ' + char(10)
			SELECT @v_dSql5 += '          FROM (                                                                                   ' + char(10)
			SELECT @v_dSql5 += '                SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''PLAN GROUP'' AS CONFIRM_AREA ' + char(10)
			SELECT @v_dSql5 += '                	   , A.PLAN_GROUP_ID, A.INSERT_TIME                                            ' + char(10)
			SELECT @v_dSql5 += '                     , DENSE_RANK() OVER(PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
			SELECT @v_dSql5 += '                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '                    , (                                      ' + char(10)
			SELECT @v_dSql5 += '                       SELECT A.SEGMENT1 AS INSTANCE_ID, SEGMENT2 AS PLAN_GROUP_ID ' + char(10)
			SELECT @v_dSql5 += '                       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
			SELECT @v_dSql5 += '                       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
			SELECT @v_dSql5 += '                       AND    A.SEGMENT1         = ' + @v_instance_id + '      ' + char(10)
			SELECT @v_dSql5 += '                       AND    A.ACTIVE_FLAG	     = ''Y''                       ' + char(10)
			SELECT @v_dSql5 += '                ) B                                                            ' + char(10)
			SELECT @v_dSql5 += '                WHERE  A.INSTANCE_ID   = B.INSTANCE_ID                         ' + char(10)
			SELECT @v_dSql5 += '                AND    A.PLAN_GROUP_ID = B.PLAN_GROUP_ID                       ' + char(10)
			SELECT @v_dSql5 += '                AND    A.INSTANCE_ID   = ' + @v_instance_id + '                ' + char(10)
			SELECT @v_dSql5 += '          ) A                                                                  ' + char(10)
			SELECT @v_dSql5 += '          , SCM_FP_PLAN_H B WITH(NOLOCK)                                       ' + char(10)
			SELECT @v_dSql5 += '          WHERE A.INSTANCE_ID  = B.INSTANCE_ID                                 ' + char(10)
			SELECT @v_dSql5 += '          AND   A.PLAN_ID      = B.PLAN_ID                                     ' + char(10)
			SELECT @v_dSql5 += '          AND   A.SORT_ORDER   = 1                                             ' + char(10)
			SELECT @v_dSql5 += '          AND   A.CONFIRM_AREA IN (                                            ' + char(10)
			SELECT @v_dSql5 += '                    SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA                   ' + char(10)
			SELECT @v_dSql5 += '                    FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                 ' + char(10)
			SELECT @v_dSql5 += '                    WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                ' + char(10)
			SELECT @v_dSql5 += '                    AND    A.SEGMENT1         = ' + @v_instance_id+'           ' + char(10)
			SELECT @v_dSql5 += '                    AND    A.ACTIVE_FLAG      = ''Y''                          ' + char(10)
			SELECT @v_dSql5 += '          )               ' + char(10)
			SELECT @v_dSql5 += '    ) A                   ' + char(10)
			SELECT @v_dSql5 += '    GROUP BY A.FACTORY_ID ' + char(10)
			SELECT @v_dSql5 += '  )                       ' + char(10)
			SELECT @v_dSql5 += '  SELECT A.*              ' + char(10)

			IF isnull(@p_day_info,'') <> ''
				BEGIN
    				SELECT @mst_loop_cnt    = 0
    				SELECT @v_delimiter     = '!'  -- 데이터 구분자
    				SELECT @sub_v_delimiter = '#'
    				SELECT @max_loop_cnt    = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    	    
					IF @max_loop_cnt > 0 
						BEGIN
    	        			-- bucket
    	        			SELECT @mst_loop_cnt = 0	
    	        			SELECT @max_loop_cnt = 0
    	        			SELECT @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
							SET @v_Tmp1       = ''
    	        			WHILE @mst_loop_cnt < @max_loop_cnt
    	        				BEGIN
    	        					SELECT @v_Tmp1 += ' ,	CASE WHEN A.DATA_TYPE = ''TOTAL_2'' THEN ''#FFBA85'' ' +char(10)
    	        					SELECT @v_Tmp1 += '         WHEN A.DATA_TYPE = ''TOTAL''   THEN ''#FFE5C2'' ' +char(10)
    	        					SELECT @v_Tmp1 += '         WHEN A.DATA_TYPE = ''DATA''    THEN ( CASE WHEN F.D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END ) ' + char(10)
    	        					SELECT @v_Tmp1 += '     ELSE '''' END AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_BG ' + char(10)
    	        					SELECT @mst_loop_cnt =  @mst_loop_cnt + 1
    	        				END
						END
				END
    
			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1

			SELECT @v_dSql5 += '  FROM (                            ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM #MAIN_P        ' + char(10)--Tuning_05
			SELECT @v_dSql5 += '        UNION ALL                   ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM MAIN_GAP      ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL                   ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM MAIN_P_SUBT   ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM #MAIN_GAP_WPP ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL                                                              ' + char(10)
			SELECT @v_dSql5 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID              ' + char(10)
			SELECT @v_dSql5 += '           , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql5 += '           , A.OPERATION_ID, A.OPERATION_NAME, ''Total'' AS FACTORY_ID         ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET         ' + char(10)
			SELECT @v_dSql5 += '           , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           , A.CATE, A.MEASURE_ID                                              ' + char(10)
    
			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
				IF @max_loop_cnt > 0
					BEGIN
            			  -- monthinfo
            			  SET @mst_loop_cnt = 0
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp1       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp1 += '           , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
            	  
            			  -- weekinfo
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp2       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp2 += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            				  END
            	  
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp3       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp3 += '           , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
					END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                   ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID=''GAP_CELL'' THEN 1500 ' + char(10)
			SELECT @v_dSql5 += '              ELSE 1600 END) AS CATEGORY_ORDER               ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL'' AS DATA_TYPE, '''' AS S_ROW           ' + char(10)
			SELECT @v_dSql5 += '      FROM   MAIN_GAP A                                      ' + char(10)
			SELECT @v_dSql5 =  @v_dSql5 + @v_SqlsubTotal --subtotal
			SELECT @v_dSql5 += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                            ' + char(10)
			SELECT @v_dSql5 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql5 += '          , A.PSI, A.OPERATION_ID, A.OPERATION_NAME                                          ' + char(10)
			SELECT @v_dSql5 += '          , A.CATE, A.MEASURE_ID, A.CATEGORY_ID                                              ' + char(10)


						SELECT @v_dSql5 += '        UNION ALL                                                              ' + char(10)
			SELECT @v_dSql5 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID              ' + char(10)
			SELECT @v_dSql5 += '           , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql5 += '           , A.OPERATION_ID, A.OPERATION_NAME, ''Total'' AS FACTORY_ID         ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET         ' + char(10)
			SELECT @v_dSql5 += '           , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '           , A.CATE, A.MEASURE_ID                                              ' + char(10)
    
			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
				IF @max_loop_cnt > 0
					BEGIN
            			  -- monthinfo
            			  SET @mst_loop_cnt = 0
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_MONTH_INFO, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp1       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp1 += '           , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
            	  
            			  -- weekinfo
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp2       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp2 += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            				  END
            	  
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp3       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp3 += '           , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
					END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                   ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID=''GAP_WPP'' AND A.MEASURE_ID =''CELL'' THEN 170000 ELSE 180000 END) AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL'' AS DATA_TYPE, '''' AS S_ROW           ' + char(10)
			SELECT @v_dSql5 += '      FROM   #MAIN_GAP_WPP A                                      ' + char(10)
			SELECT @v_dSql5 =  @v_dSql5 + @v_SqlsubTotal --subtotal
			SELECT @v_dSql5 += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                            ' + char(10)
			SELECT @v_dSql5 += '          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.CELL_GROUP, A.PLM_EC_NO ' + char(10)
			SELECT @v_dSql5 += '          , A.PSI, A.OPERATION_ID, A.OPERATION_NAME                                          ' + char(10)
			SELECT @v_dSql5 += '          , A.CATE, A.MEASURE_ID, A.CATEGORY_ID                                              ' + char(10)

			SELECT @v_dSql5 += '      UNION ALL                                                                              ' + char(10)
			SELECT @v_dSql5 += '      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID      ' + char(10)
			SELECT @v_dSql5 += '           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS CELL_GROUP, NULL AS PLM_EC_NO, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET   ' + char(10)
			SELECT @v_dSql5 += '           , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE               ' + char(10)
			SELECT @v_dSql5 += '           , A.CATE, A.MEASURE_ID                                                            ' + char(10)
	
			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
            
				IF @max_loop_cnt > 0 
					BEGIN
        				-- monthinfo
        				SET @mst_loop_cnt = 0
        				SET @max_loop_cnt = 0
        				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp1       = ''
        				WHILE @mst_loop_cnt < @max_loop_cnt
        					BEGIN
        	        			  SET @v_Tmp1 += '           , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	        			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        					END
        	    
        				-- weekinfo
        				SET @mst_loop_cnt = 0	
        				SET @max_loop_cnt = 0
        				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp2       = ''
        				WHILE @mst_loop_cnt < @max_loop_cnt
        					BEGIN
        	        			  SET @v_Tmp2 += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	        			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
        					END
        	    
        				-- bucket
        				SET @mst_loop_cnt = 0	
        				SET @max_loop_cnt = 0
        				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						SET @v_Tmp3       = ''
        				WHILE @mst_loop_cnt < @max_loop_cnt
        					BEGIN
        	        			  SET @v_Tmp3 += '           , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
        	        			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
        					END
					END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                          ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID=''M_IN_CELL'' THEN 10000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''M_IN_UOM'' THEN 20000       ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''M_OUT_CELL'' THEN 30000     ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''M_OUT_UOM'' THEN 40000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''W_IN_CELL'' THEN 50000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''W_IN_UOM'' THEN 60000       ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''W_OUT_CELL'' THEN 70000     ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''W_OUT_UOM'' THEN 80000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''P_IN_CELL'' THEN 90000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''P_IN_UOM'' THEN 100000      ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''P_OUT_CELL'' THEN 110000    ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''P_OUT_UOM'' THEN 120000     ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID=''P_RESULT_CELL'' THEN 130000 ' + char(10)
			SELECT @v_dSql5 += '               ELSE 140000 END) AS CATEGORY_ORDER                   ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW                ' + char(10)
			SELECT @v_dSql5 += '      FROM MAIN_P_SUBT A                                            ' + char(10)
			SELECT @v_dSql5 =  @v_dSql5 + @v_SqlTotal  --TOTAL_2
			SELECT @v_dSql5 += '      GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID       ' + char(10)
			SELECT @v_dSql5 += '      UNION ALL                                                                                   ' + char(10)
			SELECT @v_dSql5 += '      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID           ' + char(10)
			SELECT @v_dSql5 += '           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME      ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS CELL_GROUP, NULL AS PLM_EC_NO, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE, A.MEASURE_ID     ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '!'  -- 데이터 구분자
					SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
            
					IF @max_loop_cnt > 0 BEGIN
            			  -- monthinfo
            			  SET @mst_loop_cnt = 0
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp1       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp1 += '           , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
            	  
            			  -- weekinfo
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp2       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp2 += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            				  END
            	  
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp3       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp3 += '           , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
				END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                     ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID=''GAP_CELL'' THEN 150000 ' + char(10)
			SELECT @v_dSql5 += '               ELSE 160000 END) AS CATEGORY_ORDER              ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW           ' + char(10)
			SELECT @v_dSql5 += '      FROM MAIN_GAP A                                          ' + char(10)
			SELECT @v_dSql5 += '      ' + @v_SqlTotal --TOTAL_2
			SELECT @v_dSql5 += '      GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID ' + char(10)

			SELECT @v_dSql5 += '      UNION ALL                                                                                   ' + char(10)
			SELECT @v_dSql5 += '      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID           ' + char(10)
			SELECT @v_dSql5 += '           , ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID, NULL AS ITEM_TYPE, NULL AS NICK_NAME      ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS CELL_GROUP, NULL AS PLM_EC_NO, A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME                 ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS FACTORY_ID, NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI ' + char(10)
			SELECT @v_dSql5 += '           , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE, A.MEASURE_ID     ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
					SET @mst_loop_cnt     = 0
					SET @v_delimiter      = '!'  -- 데이터 구분자
					SET @sub_v_delimiter  = '#'
					SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
            
					IF @max_loop_cnt > 0 BEGIN
            			  -- monthinfo
            			  SET @mst_loop_cnt = 0
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp1       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp1 += '           , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
            	  
            			  -- weekinfo
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp2       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp2 += '           , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            				  END
            	  
            			  -- bucket
            			  SET @mst_loop_cnt = 0	
            			  SET @max_loop_cnt = 0
            			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
						  SET @v_Tmp3       = ''
            			  WHILE @mst_loop_cnt < @max_loop_cnt
            				  BEGIN
            	      			  SET @v_Tmp3 += '           , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + ') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
				END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                     ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID=''GAP_WPP'' AND A.MEASURE_ID =''CELL'' THEN 170000 ELSE 180000 END) AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW           ' + char(10)
			SELECT @v_dSql5 += '      FROM #MAIN_GAP_WPP A' + char(10)
			SELECT @v_dSql5 += '      ' + @v_SqlTotal --TOTAL_2
			SELECT @v_dSql5 += '      GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID, A.MEASURE_ID ' + char(10)

			SELECT @v_dSql5 += '  ) A                                       ' + char(10)
			SELECT @v_dSql5 += '  LEFT OUTER JOIN SCM_LINE_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '  ON  A.COMPANY_ID      = B.COMPANY_ID      ' + char(10)
			SELECT @v_dSql5 += '  AND A.DIVISION_ID     = B.DIVISION_ID     ' + char(10)
			SELECT @v_dSql5 += '  AND A.SITE_ID         = B.SITE_ID         ' + char(10)
			SELECT @v_dSql5 += '  AND A.PLANT_ID        = B.PLANT_ID        ' + char(10)
			SELECT @v_dSql5 += '  AND A.FACTORY_ID      = B.FACTORY_ID      ' + char(10)
			SELECT @v_dSql5 += '  AND A.OPERATION_ID    = B.OPERATION_ID    ' + char(10)
			SELECT @v_dSql5 += '  AND A.LINE_ID         = B.LINE_ID         ' + char(10)
			SELECT @v_dSql5 += '  AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE  ' + char(10)
			SELECT @v_dSql5 += '  LEFT OUTER JOIN T_RELEASE F WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql5 += '  ON  (CASE WHEN '+ @v_confirm_area +' = ''BUILDING'' THEN A.FACTORY_ID ELSE B.MODEL_TYPE END) = F.FACTORY_ID ' + char(10)
			SELECT @v_dSql5 += '  ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.OPERATION_ID DESC                    ' + char(10)
			SELECT @v_dSql5 += '      ,A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE, A.PLM_EC_NO,(CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)          ' + char(10)
			SELECT @v_dSql5 += '      ,A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET                                           ' + char(10)
			SELECT @v_dSql5 += '      ,A.LINE_ID, A.ELECTRODE_TYPE, CATEGORY_ORDER                                                     ' + char(10)
            SELECT @v_dSql5 += '; ' + char(10)+char(10)
            
            SELECT @v_dSql5 += 'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
            SELECT @v_dSql5 += '	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
            SELECT @v_dSql5 += 'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
            SELECT @v_dSql5 += '	drop table #MAIN_GAP_WPP ' + char(10)
            SELECT @v_dSql5 += '; ' + char(10)
			SELECT @v_dSql5 += 'if object_id(''tempdb..#MAIN_P'') is not null drop table #MAIN_P ' + char(10)


			SELECT @v_dSql =  @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5

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
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))                + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))                + char(10)

            SELECT @v_dSql += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                   ' + char(10)
            SELECT @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID                           ' + char(10)
            SELECT @v_dSql += '     , A.ITEM_ID, A.TOP_ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                                 ' + char(10)

		END
--------------------------------------------------------------------------------------------------------------------------------------------------------------
	IF @p_sys_type = 'SQL'
		BEGIN
			--EXEC PR_UI_SQL_LOG @v_proc_name,  @p_user_id,',',@v_dSql,'select',@runstart, @runend
			SELECT @v_dSql as [QUERY_VALUE]

		END  
	ELSE 
		BEGIN
			SET @runstart = GetDate()
			--쿼리실행
			EXEC sp_executesql @v_dSql

			SET @runend = GetDate()
			EXEC PR_UI_SQL_LOG  @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
		END
END
