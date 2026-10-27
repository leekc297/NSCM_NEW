 
CREATE PROCEDURE [dbo].[PR_UI_FP00604_PLANBYMODEL_PACK]
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
/** 프로그램 ID   :PR_UI_FP00604_PLANBYMODEL_PACK                                                 **/
/** 프로그램 명   : Procedure PR_UI_FP00604_PLANBYMODEL_PACK                             **/
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
/** 2021-05-28     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/** 2026-03-03     SYngsn               E20251119-001047  Result(+Exp.) 값 Plan+Result 보여주고 있는 원인 확인 및 조치 **/
/** 2026-05-13     SYngsn               E20260421-000487 acc gap - weeksum error - plan by line ( fomation)**/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00604_PLANBYMODEL_PACK
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
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00604_PLANBYMODEL_PACK'


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

  DECLARE @v_row_delimiter		NVARCHAR(2);	
  DECLARE @max_week_loop_cnt	integer = 0;
  DECLARE @max_month_loop_cnt	integer = 0;

  --Optional Parameter Part END


--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE	= ''' +ISNULL(@P_SYS_TYPE,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG	= ''' +ISNULL(@P_SYS_FLAG,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN	= ''' +ISNULL(@P_SYS_GUBUN,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID		= ''' +ISNULL(@P_USER_ID,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_columns	= ''' +ISNULL(@in_columns,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@in_row		= ''' +ISNULL(@in_row,'')		+ '''' + CHAR(10)
--SET @PARAMS += ',@opt_none		= ''' +ISNULL(@opt_none,'')		+ '''' + CHAR(10)

--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END



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
			
			SET @v_row_delimiter	= '!';  -- row column 데이터 구분자
			SET @sub_v_delimiter	= '#';  -- column  데이타 구분자 (추후 변경)

			SET @max_loop_cnt		= [dbo].[SCM_ARR_SPL_CNT](@p_day_info   , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
			SET @max_week_loop_cnt	= [dbo].[SCM_ARR_SPL_CNT](@p_week_info	, @v_row_delimiter) -- 프로시저 LOOP 길이를 판단
			SET @max_month_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_month_info , @v_row_delimiter) -- 프로시저 LOOP 길이를 판단


			-- 테이블 생성부터 동적으로 변경한다.
			SELECT @v_dSql1  = ''

			--2026-03-03 E20251119-001047 yyyyMMddHHmmss BugFix
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

            SELECT @v_dSql1 += ' IF OBJECT_ID(''tempdb..#TblFP00604_TEMP'') IS NOT NULL DROP TABLE #TblFP00604_TEMP;	' + char(10)
			SELECT @v_dSql1 += ' CREATE TABLE #TblFP00604_TEMP (                                                    ' + char(10)
			SELECT @v_dSql1 += ' 				[CATE_ORDER] [int] NOT NULL   ,                                     ' + char(10)
			SELECT @v_dSql1 += ' 				[CATE_NAME] [nvarchar](30) NOT NULL   ,                             ' + char(10)
			SELECT @v_dSql1 += ' 				[CATE_ID] [nvarchar](30) NOT NULL  );                               ' + char(10)
			SELECT @v_dSql1 += ' 		                                                                            ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME, CATE_ID)                      ' + char(10)
			SELECT @v_dSql1 += '         values(10,''MPP(In)'' ,''M_IN'' );                                             ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME, CATE_ID)                      ' + char(10)
			SELECT @v_dSql1 += '         values (20,''MPP(Out)''  ,''M_OUT''  );                                        ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (30,''WPP(In)''    ,''W_IN'')  ;                                        ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (40,''WPP(Out)''  ,''W_OUT''  );                                        ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (50,''Plan(In)''    ,''P_IN'' )	;                                       ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (60,''Plan(Out)''  ,''P_OUT''  )	;			                        ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (70,''Result''    ,''P_RESULT''  );                                     ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (71,''Result(+Exp.)''  ,''RESULT_EXP''  );                              ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (80,''Off Cal.''   ,''P_OFFTIME''  );                                   ' + char(10)
			SELECT @v_dSql1 += ' insert into #TblFP00604_TEMP (CATE_ORDER, CATE_NAME,  CATE_ID)                     ' + char(10)
			SELECT @v_dSql1 += '         values (90,''Memo''  ,''P_MEMO''  );                                           ' + char(10)

			SELECT @v_dSql1 += 'IF OBJECT_ID(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H_TEMP'') IS NOT NULL  ' + char(10)
			SELECT @v_dSql1 += ' DROP TABLE #SCM_DAILY_PRODUCT_RESULT_H_TEMP;  ' + char(10)
			SELECT @v_dSql1 += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID      ' + char(10)
			SELECT @v_dSql1 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			SELECT @v_dSql1 += '                       , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET        ' + char(10)
			SELECT @v_dSql1 += '                       , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE   ' + char(10)
			SELECT @v_dSql1 += '                       , 0 IN_QTY, 0 OUT_QTY, A.ACTUAL_GOOD_QTY AS RESULT_QTY     ' + char(10) 
			SELECT @v_dSql1 += '                       , 0 AS OFF_TIME, ''P_RESULT'' AS PLAN_TYPE                 ' + char(10)
			SELECT @v_dSql1 += '                       , A.ACTUAL_GOOD_QTY AS RESULT_QTY2 '                       + char(10) 
			SELECT @v_dSql1 += '                       INTO #SCM_DAILY_PRODUCT_RESULT_H_TEMP ' + char(10)
			SELECT @v_dSql1 += '                   FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql1 += '                   WHERE  1 = 1 ' + char(10)
			--SELECT @v_dSql1 += '                   AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ' + @v_bucket_from + ' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ' + @v_bucket_to + ' + '' 23:59:59.997'', 121) ' + char(10)
			SELECT @v_dSql1 += '                   AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(' + @v_bucket_from + ',1,6) + ''01 00:00:00.000'', 121) AND CONVERT(DATETIME, ' + @v_bucket_to + ' + '' 23:59:59.997'', 121) ' + char(10) -- 시작일자의 월의 1일부터
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			SELECT @v_dSql1 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			SELECT @v_dSql1 += '                   AND A.ACTUAL_GOOD_QTY > 0                                       ' + char(10)

			SELECT @v_dSql1 += 'IF OBJECT_ID(''tempdb..#MAIN_P'') IS NOT NULL ' + char(10)
		    SELECT @v_dSql1 += '	DROP TABLE #MAIN_P ' + char(10)
			SELECT @v_dSql1 += 'IF OBJECT_ID(''tempdb..#MAIN_GAP'') IS NOT NULL ' + char(10)
		    SELECT @v_dSql1 += '	DROP TABLE #MAIN_GAP ' + char(10)+ char(10)

			SELECT @v_dSql1 += 'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
			SELECT @v_dSql1 += '	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql1 += 'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
			SELECT @v_dSql1 += '	drop table #MAIN_GAP_WPP ' + char(10)+char(10)

			SELECT @v_dSql1 += 'SELECT A.* ' + char(10)
			SELECT @v_dSql1 += '     , B.YYYYMMDD AS PLAN_DATE, B.ISO_YYYYWW AS PLAN_WEEK, B.YYYYMM AS PLAN_MONTH ' + char(10)
			SELECT @v_dSql1 += '     , ISNULL(D.OPERATION_NAME,''-'') AS OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += '     , ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, '''' AS EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += '     , ISNULL(BB.NICK_NAME,''-'') AS NICK_NAME, BB.ITEM_TYPE, ISNULL(BB.PJT_GROUP_NAME,''-'') AS PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql1 += 'INTO #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
									-- 실적 품번
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '	FROM   #SCM_DAILY_PRODUCT_RESULT_H_TEMP A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ' + @v_bucket_from + ' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ' + @v_bucket_to + ' + '' 23:59:59.997'', 121) ' + char(10)
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) 
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) 
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) 
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) 
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) 
			--SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			--SELECT @v_dSql1 += '	AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
			SELECT @v_dSql1 += '	UNION ' + char(10)
									-- WPP 품번
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '	FROM    FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '	WHERE   1=1 ' + char(10)
			SELECT @v_dSql1 += '	AND     A.PLAN_DATE BETWEEN CONVERT(DATETIME, ' + @v_bucket_from + ' + '' 00:00:00.000'', 121) AND CONVERT(DATETIME, ' + @v_bucket_to + ' + '' 23:59:59.997'', 121) ' + char(10)
			SELECT @v_dSql1 += '	AND 	A.PLAN_TYPE IN (''WPP'', ''RELEASE'') ' + char(10)
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) 
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) 
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) 
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) 
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) 
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql1 += '	' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			SELECT @v_dSql1 += '	AND 	( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += 'INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ' + char(10)
			SELECT @v_dSql1 += '			   A.ITEM_ID, ' + char(10)
			SELECT @v_dSql1 += '			  (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql1 += '	                WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql1 += '	                ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE, ' + char(10)
			SELECT @v_dSql1 += '			   ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, ISNULL(A.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql1 += '		FROM   SCM_ITEM_M A WITH(NOLOCK), ' + char(10)
			SELECT @v_dSql1 += '	           SCM_ITEM_CLASS_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		WHERE  A.ITEM_CLASS  = C.CLASS_ID ' + char(10)
			SELECT @v_dSql1 += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql1 += '		' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) 
			IF(LEN(@p_nick_name) > 0)
			BEGIN
				SELECT @v_dSql1 += '		AND   A.NICK_NAME LIKE ''%'' + ''' + @p_nick_name + ''' + ''%''   ' + char(10)
    		END
			SELECT @v_dSql1 += ') BB ' + char(10)
			SELECT @v_dSql1 += 'ON     A.COMPANY_ID     = BB.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.DIVISION_ID    = BB.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.SITE_ID        = BB.SITE_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.TOP_ITEM_ID     = BB.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += 'INNER JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += 'ON     A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.SITE_ID        = C.SITE_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.LINE_ID        = C.LINE_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += 'INNER JOIN SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += 'ON     A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.SITE_ID        = D.SITE_ID ' + char(10)
			SELECT @v_dSql1 += 'AND    A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += ', TH_UIS_CAL B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += 'WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += 'AND   B.YYYYMMDD BETWEEN (SUBSTRING(' + @v_bucket_from + ',1,6) + ''01'') AND ' + @v_bucket_to + ' ' + char(10) -- 시작일의 월 1일부터
			SELECT @v_dSql1 += 'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)+char(10)

			SELECT @v_dSql1 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql1 += '	 , A.OPERATION_ID, A.OPERATION_NAME, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '     , A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '	 , ''P'' AS PSI ' + char(10)
			SELECT @v_dSql1 += '     , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '     , A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '	 , A.DATA_TYPE, NULL AS S_ROW ' + char(10)

			IF ISNULL(@p_day_info,'') <> '' BEGIN
    			SET @mst_loop_cnt     = 0
    			SET @v_delimiter      = '!'  -- 데이터 구분자
    			SET @sub_v_delimiter  = '#'
    			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
    			IF @max_loop_cnt > 0 BEGIN
    				-- 1. monthinfo : 월별 막날
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
						SELECT @v_dSql1 += '	 , D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 월 별 일갯수만큼 누적됨
						 
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
						SELECT @v_dSql1 += '	 , D' +  CONVERT(VARCHAR, (@d_seq + CONVERT(integer, @sub_param_2) - 1)) + ' AS ' + @sub_param_3 + char(10) -- 주 별 일갯수만큼 누적됨
						 
						SET @d_seq += @sub_param_2

					END

    				-- 3. day
    				SET @mst_loop_cnt = 0	
    				SET @max_loop_cnt = 0
    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp3       = ''

					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SET @mst_loop_cnt     =  @mst_loop_cnt + 1
						SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_day_info,@v_delimiter, @mst_loop_cnt)
						SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                        
						--SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_0 => IS_PLAN (Y/N)
						--SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2) -- @sub_param_1 => D_Value (D0...DN)
						--SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3) -- @sub_param_2 => _DATE(20210221)
						--SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => _WEEK(202109)
						--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_4 => _MONTH(02)
						--SET @sub_param_4 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_5 => _DATE_TXT(2021-02-21(Mon.))

						SELECT @v_dSql1 += '	 , A.D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1)  + ' ' + char(10)

					END 
    			END
			END 

			SELECT @v_dSql1 += 'INTO #MAIN_GAP_WPP ' + char(10)
			SELECT @v_dSql1 += 'FROM ( ' + char(10)
			SELECT @v_dSql1 += '	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += '		 , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , A.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += '		 , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql1 += '		 , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '		 , A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql1 += '		 , B.CATEGORY_NAME AS CATE ' + char(10)
			SELECT @v_dSql1 += '		 , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '		 , ''DATA'' AS DATA_TYPE ' + char(10)

			IF ISNULL(@p_day_info,'') <> '' BEGIN
    			SET @mst_loop_cnt     = 0
    			SET @v_delimiter      = '!'  -- 데이터 구분자
    			SET @sub_v_delimiter  = '#'
    			SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
    
    			IF @max_loop_cnt > 0 BEGIN
    				-- day
    				SET @mst_loop_cnt = 0	
    				SET @max_loop_cnt = 0
    				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단

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

						SELECT @v_dSql1 += '		 , SUM(CASE WHEN A.PLAN_DATE >= (SUBSTRING(''' + @sub_param_2 + ''',1,6)+''01'') AND A.PLAN_DATE <= ''' + @sub_param_2 + ''' THEN A.GAP_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) + '' + char(10)

					END 

    			END
			END 

			SELECT @v_dSql1 += '	FROM ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT A.* ' + char(10)
			SELECT @v_dSql1 += '			 , ISNULL(B.GAP_QTY,0) AS GAP_QTY ' + char(10)
			SELECT @v_dSql1 += '		FROM #MAIN_ITEM_WPP_GAP A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '		LEFT OUTER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '				 , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '				 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '				 , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '				 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '				 , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
			SELECT @v_dSql1 += '			FROM ( ' + char(10)
			                                    -- WPP(OUT) : 시작일의 월 1일 부터
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '					 , ISNULL(A.PLAN_QTY,0) AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, (SUBSTRING(' + @v_bucket_from + ',1,6) + ''01'')) AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_TYPE = ''WPP'' ' + char(10)
			SELECT @v_dSql1 += '				AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			                                    -- 과거 실적 : 시작일의 월 1일 부터 end date까지(실적이라 당일 이전까지만 데이터 존재)
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , A.RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   #SCM_DAILY_PRODUCT_RESULT_H_TEMP A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, SUBSTRING(' + @v_bucket_from + ',1,6) + ''01 00:00:00.000'', 121) AND CONVERT(DATETIME, ' + @v_bucket_to + ' + '' 23:59:59.997'', 121) ' + char(10)
			--SELECT @v_dSql1 += '				AND    A.ACTUAL_GOOD_QTY > 0 ' + char(10)
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
			--SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			                                    -- 미래 실적 : 당일 부터 end date 까지
			SELECT @v_dSql1 += '				UNION ALL ' + char(10)
			SELECT @v_dSql1 += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LOCATION, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '					 , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '					 , A.MARKET ' + char(10)
			SELECT @v_dSql1 += '					 , 0 AS OUT_QTY ' + char(10)
			SELECT @v_dSql1 += '					 , ISNULL(A.PLAN_QTY,0) AS RESULT_QTY ' + char(10)
			SELECT @v_dSql1 += '				FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '				WHERE  1=1 ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME, ''' + @p_curr_date_gap + ''') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
			SELECT @v_dSql1 += '				AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
			SELECT @v_dSql1 += '				AND    ( A.PLAN_QTY + A.PLAN_IN_QTY ) > 0 ' + char(10)
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql1 += '				' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			SELECT @v_dSql1 += '			) A ' + char(10)
			SELECT @v_dSql1 += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '					, A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '					, A.PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '					, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '		) B ' + char(10)
			SELECT @v_dSql1 += '		ON  1=1 ' + char(10)
			SELECT @v_dSql1 += '		AND A.COMPANY_ID      = B.COMPANY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.DIVISION_ID     = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.SITE_ID         = B.SITE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLANT_ID        = B.PLANT_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.FACTORY_ID      = B.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.LOCATION        = B.LOCATION ' + char(10)
			SELECT @v_dSql1 += '		AND A.OPERATION_ID    = B.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.LINE_ID         = B.LINE_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.ITEM_ID         = B.ITEM_ID ' + char(10)
			SELECT @v_dSql1 += '		AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE ' + char(10)
			SELECT @v_dSql1 += '		AND A.MARKET          = B.MARKET ' + char(10)
			SELECT @v_dSql1 += '		AND A.PLAN_DATE       = B.PLAN_DATE ' + char(10)
			SELECT @v_dSql1 += '	) A ' + char(10)
			SELECT @v_dSql1 += '	INNER JOIN ( ' + char(10)
			SELECT @v_dSql1 += '		SELECT * ' + char(10)
			SELECT @v_dSql1 += '		FROM ( ' + char(10)
			SELECT @v_dSql1 += '			SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '			UNION ALL ' + char(10)
			SELECT @v_dSql1 += '			SELECT ''GAP_WPP'' AS CATEGORY_ID, ''Accu. GAP(WPP)'' AS CATEGORY_NAME, 76 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '		) BB ' + char(10)
			SELECT @v_dSql1 += '		WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql1 += '	) B ' + char(10)
			SELECT @v_dSql1 += '	ON 1=1 ' + char(10)
			SELECT @v_dSql1 += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.LOCATION, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql1 += '		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql1 += '		   , A.EQUIPMENT_ID ' + char(10)
			SELECT @v_dSql1 += '		   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME, A.PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql1 += '		   , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql1 += '		   , A.ITEM_TYPE, B.CATEGORY_NAME ' + char(10)
			SELECT @v_dSql1 += '		   , B.CATEGORY_ID, B.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += ') A ' + char(10)
			SELECT @v_dSql1 += 'OPTION (FORCE ORDER) ' + char(10)
			SELECT @v_dSql1 += '; ' + char(10)+char(10)

		    SELECT @v_dSql1 += 'CREATE TABLE #MAIN_P ' + char(10)
		    SELECT @v_dSql1 += '( ' + char(10)
		    SELECT @v_dSql1 += '  	[COMPANY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [SITE_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [TOP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [ITEM_TYPE] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [NICK_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [PJT_GROUP_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [OPERATION_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [OPERATION_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [FACTORY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    [LOCATION] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[PRODUCTION_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[MARKET] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[PSI] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[LINE_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[LINE_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[ELECTRODE_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '	[CATE] [nvarchar](30) NULL,	' + char(10)
		    SELECT @v_dSql1 += '    [CATEGORY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '   	[CATEGORY_ORDER] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += ' 	[DATA_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += ' 	[S_ROW] [nvarchar](30) NULL ' + char(10)

			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 	, [M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 	, [W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  					END
					
					-- bucket
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 	, [D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) ' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						
					END 
				END 
			END 

		    SELECT @v_dSql1 += ') ' + char(10)+ char(10)

		    SELECT @v_dSql1 += 'CREATE TABLE #MAIN_GAP ' + char(10)
		    SELECT @v_dSql1 += '( ' + char(10)
		    SELECT @v_dSql1 += '  		[COMPANY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[DIVISION_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[SITE_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[PLANT_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[TOP_ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[ITEM_ID] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[ITEM_TYPE] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[NICK_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[PJT_GROUP_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[OPERATION_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[OPERATION_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[FACTORY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '    	[LOCATION] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[PRODUCTION_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[MARKET] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[PSI] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[LINE_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[LINE_NAME] [nvarchar](150) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[ELECTRODE_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '		[CATE] [nvarchar](30) NULL,	' + char(10)
		    SELECT @v_dSql1 += '    	[CATEGORY_ID] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += '   		[CATEGORY_ORDER] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += ' 		[DATA_TYPE] [nvarchar](30) NULL, ' + char(10)
		    SELECT @v_dSql1 += ' 		[S_ROW] [nvarchar](30) NULL ' + char(10)
		    
			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 		, [M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0))' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 		, [W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0))' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
  					END

					-- bucket
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SELECT @v_dSql1 += ' 		, [D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0))' + char(10)
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
					END
				END
			END

		    SELECT @v_dSql1 += ') ' + char(10)+char(10)

			/*
			IF OBJECT_ID('tempdb..#MAIN_P') IS NOT NULL
		      DROP TABLE #MAIN_P
			IF OBJECT_ID('tempdb..#MAIN_GAP') IS NOT NULL
		      DROP TABLE #MAIN_GAP

			CREATE TABLE #MAIN_P							
		      (																	
		      		[COMPANY_ID] [nvarchar](30) NULL,							
		        	[DIVISION_ID] [nvarchar](30) NULL,							
		        	[SITE_ID] [nvarchar](30) NULL,								
		        	[PLANT_ID] [nvarchar](30) NULL,								
		        	[TOP_ITEM_ID] [nvarchar](150) NULL,						
		        	[ITEM_ID] [nvarchar](150) NULL,							
		        	[ITEM_TYPE] [nvarchar](150) NULL,							
		        	[NICK_NAME] [nvarchar](150) NULL,						
		        	[PJT_GROUP_NAME] [nvarchar](150) NULL,								
		        	[OPERATION_ID] [nvarchar](30) NULL,							
		        	[OPERATION_NAME] [nvarchar](150) NULL,								
		        	[FACTORY_ID] [nvarchar](30) NULL,									
		        	[LOCATION] [nvarchar](30) NULL,								
					[PRODUCTION_TYPE] [nvarchar](30) NULL,
					[MARKET] [nvarchar](30) NULL,
					[PSI] [nvarchar](30) NULL,
					[LINE_ID] [nvarchar](30) NULL,
					[LINE_NAME] [nvarchar](150) NULL,
					[ELECTRODE_TYPE] [nvarchar](30) NULL,
					[CATE] [nvarchar](30) NULL,	
		        	[CATEGORY_ID] [nvarchar](30) NULL,		
		       		[CATEGORY_ORDER] [nvarchar](30) NULL,	
		     		[DATA_TYPE] [nvarchar](30) NULL,		
		     		[S_ROW] [nvarchar](30) NULL
			 )		
			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
						EXEC SP_EXECUTESQL @v_dSql;
  					END -- end of @mst_loop_cnt < @max_loop_cnt
					
					-- bucket
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_P ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1

						EXEC SP_EXECUTESQL @v_dSql;
					END -- end of @mst_loop_cnt < @max_loop_cnt
				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''

			CREATE TABLE #MAIN_GAP							
		      (																	
		      		[COMPANY_ID] [nvarchar](30) NULL,							
		        	[DIVISION_ID] [nvarchar](30) NULL,							
		        	[SITE_ID] [nvarchar](30) NULL,								
		        	[PLANT_ID] [nvarchar](30) NULL,								
		        	[TOP_ITEM_ID] [nvarchar](150) NULL,						
		        	[ITEM_ID] [nvarchar](150) NULL,							
		        	[ITEM_TYPE] [nvarchar](150) NULL,							
		        	[NICK_NAME] [nvarchar](150) NULL,						
		        	[PJT_GROUP_NAME] [nvarchar](150) NULL,								
		        	[OPERATION_ID] [nvarchar](30) NULL,							
		        	[OPERATION_NAME] [nvarchar](150) NULL,								
		        	[FACTORY_ID] [nvarchar](30) NULL,									
		        	[LOCATION] [nvarchar](30) NULL,								
					[PRODUCTION_TYPE] [nvarchar](30) NULL,
					[MARKET] [nvarchar](30) NULL,
					[PSI] [nvarchar](30) NULL,
					[LINE_ID] [nvarchar](30) NULL,
					[LINE_NAME] [nvarchar](150) NULL,
					[ELECTRODE_TYPE] [nvarchar](30) NULL,
					[CATE] [nvarchar](30) NULL,	
		        	[CATEGORY_ID] [nvarchar](30) NULL,		
		       		[CATEGORY_ORDER] [nvarchar](30) NULL,	
		     		[DATA_TYPE] [nvarchar](30) NULL,		
		     		[S_ROW] [nvarchar](30) NULL
			 )		
			IF ISNULL(@p_bucket,'') <> '' BEGIN
				
				IF @max_loop_cnt > 0 BEGIN
					-- monthinfo
					SET @mst_loop_cnt = 0
					WHILE @mst_loop_cnt < @max_month_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_GAP ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END-- end of @mst_loop_cnt < @max_loop_cnt

					-- weekinfo
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_week_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_GAP ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1						
						EXEC SP_EXECUTESQL @v_dSql;
  					END -- end of @mst_loop_cnt < @max_loop_cnt

					-- bucket
					SET @mst_loop_cnt = 0	
					WHILE @mst_loop_cnt < @max_loop_cnt
					BEGIN
						SELECT @v_dSql = 'ALTER TABLE #MAIN_GAP ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
						SET @mst_loop_cnt =  @mst_loop_cnt + 1
						EXEC SP_EXECUTESQL @v_dSql;
					END -- end of @mst_loop_cnt < @max_loop_cnt
				END --end of @max_loop_cnt
			END -- end of isnull(@p_bucket,'') <> ''
			*/

			--DROP TABLE BUF_MAIN_P
			--CREATE TABLE BUF_MAIN_P							
		 --     (																	
		 --     		[COMPANY_ID] [nvarchar](30) NULL,							
		 --       	[DIVISION_ID] [nvarchar](30) NULL,							
		 --       	[SITE_ID] [nvarchar](30) NULL,								
		 --       	[PLANT_ID] [nvarchar](30) NULL,								
		 --       	[TOP_ITEM_ID] [nvarchar](150) NULL,						
		 --       	[ITEM_ID] [nvarchar](150) NULL,							
		 --       	[ITEM_TYPE] [nvarchar](150) NULL,							
		 --       	[NICK_NAME] [nvarchar](150) NULL,						
		 --       	[PJT_GROUP_NAME] [nvarchar](150) NULL,								
		 --       	[OPERATION_ID] [nvarchar](30) NULL,							
		 --       	[OPERATION_NAME] [nvarchar](150) NULL,								
		 --       	[FACTORY_ID] [nvarchar](30) NULL,									
		 --       	[LOCATION] [nvarchar](30) NULL,								
			--		[PRODUCTION_TYPE] [nvarchar](30) NULL,
			--		[MARKET] [nvarchar](30) NULL,
			--		[PSI] [nvarchar](30) NULL,
			--		[LINE_ID] [nvarchar](30) NULL,
			--		[LINE_NAME] [nvarchar](150) NULL,
			--		[ELECTRODE_TYPE] [nvarchar](30) NULL,
			--		[CATE] [nvarchar](30) NULL,	
		 --       	[CATEGORY_ID] [nvarchar](30) NULL,		
		 --      		[CATEGORY_ORDER] [nvarchar](30) NULL,	
		 --    		[DATA_TYPE] [nvarchar](30) NULL,		
		 --    		[S_ROW] [nvarchar](30) NULL
			-- )		
			--IF ISNULL(@p_bucket,'') <> '' BEGIN
				
			--	IF @max_loop_cnt > 0 BEGIN
			--		-- monthinfo
			--		SET @mst_loop_cnt = 0
			--		WHILE @mst_loop_cnt < @max_month_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_P ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			--			EXEC SP_EXECUTESQL @v_dSql;
			--		END-- end of @mst_loop_cnt < @max_loop_cnt

			--		-- weekinfo
			--		SET @mst_loop_cnt = 0	
			--		WHILE @mst_loop_cnt < @max_week_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_P ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1						
			--			EXEC SP_EXECUTESQL @v_dSql;
  	--				END -- end of @mst_loop_cnt < @max_loop_cnt

			--		-- bucket
			--		SET @mst_loop_cnt = 0	
			--		WHILE @mst_loop_cnt < @max_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_P ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			--			EXEC SP_EXECUTESQL @v_dSql;
			--		END -- end of @mst_loop_cnt < @max_loop_cnt
			--	END --end of @max_loop_cnt
			--END -- end of isnull(@p_bucket,'') <> ''

			--DROP TABLE BUF_MAIN_GAP
			--CREATE TABLE BUF_MAIN_GAP							
		 --     (																	
		 --     		[COMPANY_ID] [nvarchar](30) NULL,							
		 --       	[DIVISION_ID] [nvarchar](30) NULL,							
		 --       	[SITE_ID] [nvarchar](30) NULL,								
		 --       	[PLANT_ID] [nvarchar](30) NULL,								
		 --       	[TOP_ITEM_ID] [nvarchar](150) NULL,						
		 --       	[ITEM_ID] [nvarchar](150) NULL,							
		 --       	[ITEM_TYPE] [nvarchar](150) NULL,							
		 --       	[NICK_NAME] [nvarchar](150) NULL,						
		 --       	[PJT_GROUP_NAME] [nvarchar](150) NULL,								
		 --       	[OPERATION_ID] [nvarchar](30) NULL,							
		 --       	[OPERATION_NAME] [nvarchar](150) NULL,								
		 --       	[FACTORY_ID] [nvarchar](30) NULL,									
		 --       	[LOCATION] [nvarchar](30) NULL,								
			--		[PRODUCTION_TYPE] [nvarchar](30) NULL,
			--		[MARKET] [nvarchar](30) NULL,
			--		[PSI] [nvarchar](30) NULL,
			--		[LINE_ID] [nvarchar](30) NULL,
			--		[LINE_NAME] [nvarchar](150) NULL,
			--		[ELECTRODE_TYPE] [nvarchar](30) NULL,
			--		[CATE] [nvarchar](30) NULL,	
		 --       	[CATEGORY_ID] [nvarchar](30) NULL,		
		 --      		[CATEGORY_ORDER] [nvarchar](30) NULL,	
		 --    		[DATA_TYPE] [nvarchar](30) NULL,		
		 --    		[S_ROW] [nvarchar](30) NULL
			-- )		
			--IF ISNULL(@p_bucket,'') <> '' BEGIN
				
			--	IF @max_loop_cnt > 0 BEGIN
			--		-- monthinfo
			--		SET @mst_loop_cnt = 0
			--		WHILE @mst_loop_cnt < @max_month_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_GAP ADD [M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			--			EXEC SP_EXECUTESQL @v_dSql;
			--		END-- end of @mst_loop_cnt < @max_loop_cnt

			--		-- weekinfo
			--		SET @mst_loop_cnt = 0	
			--		WHILE @mst_loop_cnt < @max_week_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_GAP ADD  [W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1						
			--			EXEC SP_EXECUTESQL @v_dSql;
  	--				END -- end of @mst_loop_cnt < @max_loop_cnt

			--		-- bucket
			--		SET @mst_loop_cnt = 0	
			--		WHILE @mst_loop_cnt < @max_loop_cnt
			--		BEGIN
			--			SELECT @v_dSql = 'ALTER TABLE BUF_MAIN_GAP ADD  [D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '] [numeric](25, 10) NULL DEFAULT ((0)) '
			--			SET @mst_loop_cnt =  @mst_loop_cnt + 1
			--			EXEC SP_EXECUTESQL @v_dSql;
			--		END -- end of @mst_loop_cnt < @max_loop_cnt
			--	END --end of @max_loop_cnt
			--END -- end of isnull(@p_bucket,'') <> ''
			
			
			-- FP00603   
			--SELECT @v_dSql1  = ''
			SELECT @v_dSql1 += 'INSERT INTO #MAIN_P                                                                ' + char(10)
            --SELECT @v_dSql1 += ' WITH MAIN_P AS (                                                                      ' + char(10)
            --SELECT @v_dSql1 += '-- P : builing, location, production type, market, line                            ' + char(10)
            SELECT @v_dSql1 += 'SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                          ' + char(10)
            SELECT @v_dSql1 += '       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
            SELECT @v_dSql1 += '       , ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME                     ' + char(10)
            SELECT @v_dSql1 += '       , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'') AS OPERATION_NAME              ' + char(10)
            SELECT @v_dSql1 += '       , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET                         ' + char(10)
            SELECT @v_dSql1 += '       , ''P'' AS PSI , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME              ' + char(10)
            SELECT @v_dSql1 += '       , A.ELECTRODE_TYPE, D.CATE_NAME AS CATE                                         ' + char(10)
			SELECT @v_dSql1 += '          , D.CATE_ID AS CATEGORY_ID, D.CATE_ORDER AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql1 += '          , ''DATA'' AS DATA_TYPE, NULL AS S_ROW                     ' + char(10)

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
								 SELECT @v_Tmp1 += '       , SUM(CASE WHEN G.YYYYMM= '''+ @sub_param_0 +''' THEN                                   ' + char(10)
								 SELECT @v_Tmp1 += '                ( CASE WHEN D.CATE_ID = ''P_IN''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''M_IN''  AND A.PLAN_TYPE = ''MPP''     THEN A.IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP''     THEN A.OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''W_IN''  AND A.PLAN_TYPE = ''WPP''     THEN A.IN_QTY  ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP''     THEN A.OUT_QTY ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''P_RESULT''  THEN A.RESULT_QTY                        ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- result(+exp.)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME                          ' + char(10)
								 SELECT @v_Tmp1 += '                       WHEN D.CATE_ID = ''P_MEMO''    THEN NULL ELSE 0 END                     ' + char(10)
								 SELECT @v_Tmp1 += '                  ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS M' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)

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
								SELECT @v_Tmp2 += '       , SUM(CASE WHEN G.ISO_YYYYWW = '''+ @sub_param_0 +''' THEN                             ' + char(10)
								SELECT @v_Tmp2 += '               ( CASE WHEN D.CATE_ID = ''P_IN''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''M_IN''  AND A.PLAN_TYPE = ''MPP'' THEN A.IN_QTY     ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP'' THEN A.OUT_QTY    ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''W_IN''  AND A.PLAN_TYPE = ''WPP'' THEN A.IN_QTY     ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP'' THEN A.OUT_QTY    ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''P_RESULT''  THEN A.RESULT_QTY                       ' + char(10)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- result(+exp.)
								SELECT @v_Tmp2 += '                      WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME                         ' + char(10)
                                SELECT @v_Tmp2 += '                       WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END                      ' + char(10)
								SELECT @v_Tmp2 += '                  ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS W' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)   

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

								--SELECT @v_Tmp3 += '       , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = '''+ @sub_param_2 +''' THEN          ' + char(10)
								SELECT @v_Tmp3 += '       , SUM(CASE WHEN A.PLAN_DATE = '''+ @sub_param_2 +''' THEN          ' + char(10)
								SELECT @v_Tmp3 += '                ( CASE WHEN D.CATE_ID = ''P_IN''  AND A.PLAN_TYPE = ''RELEASE'' THEN A.IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''P_OUT'' AND A.PLAN_TYPE = ''RELEASE'' THEN A.OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''M_IN''  AND A.PLAN_TYPE = ''MPP''     THEN A.IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''M_OUT'' AND A.PLAN_TYPE = ''MPP''     THEN A.OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''W_IN''  AND A.PLAN_TYPE = ''WPP''     THEN A.IN_QTY  ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''W_OUT'' AND A.PLAN_TYPE = ''WPP''     THEN A.OUT_QTY ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''P_RESULT'' THEN A.RESULT_QTY                         ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''RESULT_EXP'' THEN A.RESULT_QTY2 ' + char(10) -- result(+exp.)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''P_OFFTIME'' THEN A.OFF_TIME                          ' + char(10)
								SELECT @v_Tmp3 += '                       WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END                        ' + char(10)
								SELECT @v_Tmp3 += '                  ) ELSE ( CASE WHEN D.CATE_ID = ''P_MEMO'' THEN NULL ELSE 0 END ) END) AS D' + TRY_CONVERT(NVARCHAR,@mst_loop_cnt-1) +' ' + char(10)

							END 
    				END
				END 
    
			  SELECT @v_dSql1 = @v_dSql1 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3 + @v_Tmp4

			

	        SELECT @v_dSql2  = ''
         	SELECT @v_dSql2 += '      FROM (                                                                ' + char(10)
         	SELECT @v_dSql2 += '             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
         	SELECT @v_dSql2 += '                  , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, A.OPERATION_ID      ' + char(10)
         	SELECT @v_dSql2 += '                  , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET     ' + char(10)
         	SELECT @v_dSql2 += '                  , A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE            ' + char(10)
         	SELECT @v_dSql2 += '                  , A.PLAN_TYPE, SUM(A.IN_QTY) IN_QTY,SUM(A.OUT_QTY) OUT_QTY   ' + char(10)
         	SELECT @v_dSql2 += '                  , SUM(A.RESULT_QTY) RESULT_QTY, AVG(A.OFF_TIME) AS OFF_TIME ' + char(10)
			SELECT @v_dSql2 += '                  , SUM(A.RESULT_QTY2) AS RESULT_QTY2 ' + char(10) -- result(+exp.)
            SELECT @v_dSql2 += '             FROM ( ' + char(10)
			SELECT @v_dSql2 += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID      ' + char(10)
			SELECT @v_dSql2 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			SELECT @v_dSql2 += '                       , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET        ' + char(10)
			SELECT @v_dSql2 += '                       , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE   ' + char(10)
			SELECT @v_dSql2 += '                       , A.PLAN_IN_QTY AS IN_QTY, A.PLAN_QTY AS OUT_QTY           ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS RESULT_QTY, 0 AS OFF_TIME, A.PLAN_TYPE              ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS RESULT_QTY2 ' + char(10) -- result(+exp.)
			SELECT @v_dSql2 += '                   FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)              ' + char(10)
			--SELECT @v_dSql2 += '                   WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                   WHERE  A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                   AND  A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' )         ' + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))              + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))            + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))        + char(10) 
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))    + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))              + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))              + char(10)
			SELECT @v_dSql2 += '                    AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0                       ' + char(10)

			SELECT @v_dSql2 += '                   UNION ALL                                                      ' + char(10)
			--SELECT @v_dSql2 += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID      ' + char(10)
			--SELECT @v_dSql2 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID ' + char(10)
			--SELECT @v_dSql2 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION       ' + char(10)
			--SELECT @v_dSql2 += '                       , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET        ' + char(10)
			--SELECT @v_dSql2 += '                       , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE   ' + char(10)
			--SELECT @v_dSql2 += '                       , 0 IN_QTY, 0 OUT_QTY, A.ACTUAL_GOOD_QTY AS RESULT_QTY     ' + char(10) -- result
			--SELECT @v_dSql2 += '                       , 0 AS OFF_TIME, ''P_RESULT'' AS PLAN_TYPE                 ' + char(10)
			--SELECT @v_dSql2 += '                       , A.RESULT_QTY2 ' + char(10) -- result(+exp.)
			SELECT @v_dSql2 += '                   SELECT *      ' + char(10)
			SELECT @v_dSql2 += '                   FROM   #SCM_DAILY_PRODUCT_RESULT_H_TEMP A WITH(NOLOCK)               ' + char(10)
			-- @v_dSql2 += '                   WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                   WHERE  A.PLAN_DATE BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			--SELECT @v_dSql2 += '                   AND A.ACTUAL_GOOD_QTY > 0                                       ' + char(10)
												   -- 미래 실적 구간 : 계획수량으로 출력
			SELECT @v_dSql2 += '				   UNION ALL ' + char(10)
			SELECT @v_dSql2 += '				   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '                        , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql2 += '                        , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION ' + char(10)
			SELECT @v_dSql2 += '                        , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += '                        , ''P'' AS PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
			SELECT @v_dSql2 += '                        , 0 AS IN_QTY, 0 AS OUT_QTY ' + char(10)
			SELECT @v_dSql2 += '                        , 0 AS RESULT_QTY, 0 AS OFF_TIME, ''RESULT_EXP'' AS PLAN_TYPE ' + char(10) -- result(+exp.)
			SELECT @v_dSql2 += '                        , A.PLAN_QTY AS RESULT_QTY2 ' + char(10) -- result(+exp.)
			SELECT @v_dSql2 += '                   FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                   WHERE  A.PLAN_DATE BETWEEN ''' + @p_curr_date_gap + ''' AND ' + @v_bucket_to + ' ' + char(10) -- 현재일자부터
			SELECT @v_dSql2 += '                   AND    A.PLAN_TYPE = ''RELEASE'' ' + char(10)
			SELECT @v_dSql2 += '                   AND    (A.PLAN_IN_QTY + A.PLAN_QTY) > 0 ' + char(10)
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))
			SELECT @v_dSql2 += '                   ' + (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))
			SELECT @v_dSql2 += '                   UNION ALL                                                           ' + char(10)
			SELECT @v_dSql2 += '                   SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
			SELECT @v_dSql2 += '                       , A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE, A.OPERATION_ID      ' + char(10)
			SELECT @v_dSql2 += '                       , A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION            ' + char(10)
			SELECT @v_dSql2 += '                       , A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI                     ' + char(10)
			SELECT @v_dSql2 += '                       , A.LINE_ID, A.ELECTRODE_TYPE, B.OFF_DATE AS PLAN_DATE          ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS IN_QTY, 0 AS OUT_QTY, 0 AS RESULT_QTY                    ' + char(10)
			SELECT @v_dSql2 += '                       , B.OFF_TIME AS OFF_TIME, ''P_OFFTIME'' AS PLAN_TYPE            ' + char(10)
			SELECT @v_dSql2 += '                       , 0 AS RESULT_QTY2 ' + char(10) -- result(+exp.)
			SELECT @v_dSql2 += '                   FROM (                                                              ' + char(10)
			SELECT @v_dSql2 += '                         SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID     ' + char(10)
			SELECT @v_dSql2 += '                             , A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID     ' + char(10)
			SELECT @v_dSql2 += '                             , A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID         ' + char(10)
			SELECT @v_dSql2 += '                             , A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET                  ' + char(10)
			SELECT @v_dSql2 += '                         FROM (                                                        ' + char(10)
			SELECT @v_dSql2 += '                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID          ' + char(10)
			SELECT @v_dSql2 += '                                    , A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID          ' + char(10)
			SELECT @v_dSql2 += '                                    , A.ELECTRODE_TYPE, '''' AS EQUIPMENT_ID, A.TOP_ITEM_ID        ' + char(10)
			SELECT @v_dSql2 += '                                    , A.ITEM_ID, A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql2 += '                                FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                    ' + char(10)
			SELECT @v_dSql2 += '                                WHERE  1=1                                                         ' + char(10)
			--SELECT @v_dSql2 += '                                AND   CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                                AND   A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                                AND   A.PLAN_TYPE IN ( ''RELEASE'', ''MPP'', ''WPP'' ) ' + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FP_PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			SELECT @v_dSql2 += '                                AND   (A.PLAN_IN_QTY + A.PLAN_QTY) > 0             ' + char(10)
												               
			SELECT @v_dSql2 += '                                UNION ALL                                                   ' + char(10)
			SELECT @v_dSql2 += '                                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' + char(10)
			SELECT @v_dSql2 += '                                    , A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID   ' + char(10)
			SELECT @v_dSql2 += '                                	, A.ELECTRODE_TYPE, '''' AS EQUIPMENT_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '                                	, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET             ' + char(10)
			SELECT @v_dSql2 += '                                FROM #SCM_DAILY_PRODUCT_RESULT_H_TEMP A WITH(NOLOCK)              ' + char(10)
			SELECT @v_dSql2 += '                                WHERE  1=1                                                  ' + char(10)
			--SELECT @v_dSql2 += '                                AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql2 += '                                AND  A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))        + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))              + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))          + char(10) 
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))      + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))        + char(10)
			--SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                + char(10)
			SELECT @v_dSql2 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			--SELECT @v_dSql2 += '                                AND A.ACTUAL_GOOD_QTY > 0                          ' + char(10)
			SELECT @v_dSql2 += '                         ) A                                                            ' + char(10)
			SELECT @v_dSql2 += '                         WHERE 1=1                                                      ' + char(10)
			SELECT @v_dSql2 += '                         GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
			SELECT @v_dSql2 += '                           , A.FACTORY_ID, A.LOCATION, A.OPERATION_ID, A.LINE_ID        ' + char(10)
			SELECT @v_dSql2 += '                           , A.ELECTRODE_TYPE, A.EQUIPMENT_ID, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '                           , A.PRODUCTION_TYPE, A.MARKET                                ' + char(10)
         	SELECT @v_dSql2 += '                   ) A        ' + char(10)

			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += '		    LEFT OUTER JOIN                                                       ' + char(10)
			SELECT @v_dSql3 += '            (                                                                     ' + char(10)
			SELECT @v_dSql3 += '              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql3 += '                  , A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE     ' + char(10)
			SELECT @v_dSql3 += '                  , CONVERT(VARCHAR, A.OFF_DATE, 112) AS OFF_DATE, A.OFF_TIME_TERM AS OFF_TIME ' + char(10)
			SELECT @v_dSql3 += '              FROM   SCM_OFF_CALENDAR_LINE_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '              INNER JOIN SCM_LINE_M B WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql3 += '              ON    A.COMPANY_ID     = B.COMPANY_ID         ' + char(10)
			SELECT @v_dSql3 += '              AND   A.DIVISION_ID    = B.DIVISION_ID        ' + char(10)
			SELECT @v_dSql3 += '              AND   A.SITE_ID        = B.SITE_ID            ' + char(10)
			SELECT @v_dSql3 += '              AND   A.PLANT_ID       = B.PLANT_ID           ' + char(10)
			SELECT @v_dSql3 += '              AND   A.FACTORY_ID     = B.FACTORY_ID         ' + char(10)
			SELECT @v_dSql3 += '              AND   A.OPERATION_ID   = B.OPERATION_ID       ' + char(10)
			SELECT @v_dSql3 += '              AND   A.LINE_ID        = B.LINE_ID            ' + char(10)
			SELECT @v_dSql3 += '              AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE     ' + char(10)
			SELECT @v_dSql3 += '              WHERE  B.ACTIVE_FLAG    = ''Y''               ' + char(10)
			--SELECT @v_dSql3 += '              AND   CONVERT(VARCHAR, A.OFF_DATE, 112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += '              AND   A.OFF_DATE BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)

			SELECT @v_dSql3 += '            ) B                                         ' + char(10)
			SELECT @v_dSql3 += '            ON    A.COMPANY_ID     = B.COMPANY_ID       ' + char(10)
			SELECT @v_dSql3 += '            AND   A.DIVISION_ID    = B.DIVISION_ID      ' + char(10)
			SELECT @v_dSql3 += '            AND   A.SITE_ID        = B.SITE_ID          ' + char(10)
			SELECT @v_dSql3 += '            AND   A.PLANT_ID       = B.PLANT_ID         ' + char(10)
			SELECT @v_dSql3 += '            AND   A.FACTORY_ID     = B.FACTORY_ID       ' + char(10)
			SELECT @v_dSql3 += '            AND   A.OPERATION_ID   = B.OPERATION_ID     ' + char(10)
			SELECT @v_dSql3 += '            AND   A.LINE_ID        = B.LINE_ID          ' + char(10)
			SELECT @v_dSql3 += '            AND   A.ELECTRODE_TYPE = B.ELECTRODE_TYPE   ' + char(10)

			SELECT @v_dSql3 += '     ) A                                                      ' + char(10)
			SELECT @v_dSql3 += '     INNER JOIN (                                             ' + char(10)
			SELECT @v_dSql3 += '             SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID                ' + char(10)
			SELECT @v_dSql3 += '                 ,(CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000''                                    ' + char(10)
			SELECT @v_dSql3 += '                              AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME   ' + char(10)
			SELECT @v_dSql3 += '                        WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') ' + char(10)
			SELECT @v_dSql3 += '                     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE                                    ' + char(10)
			SELECT @v_dSql3 += '                 ,ISNULL(A.NICK_NAME,''-'') AS NICK_NAME                                      ' + char(10)
			SELECT @v_dSql3 += '             FROM   SCM_ITEM_M A WITH(NOLOCK)                                                 ' + char(10)
			SELECT @v_dSql3 += '                   ,SCM_ITEM_CLASS_M C WITH(NOLOCK)                                           ' + char(10)
			SELECT @v_dSql3 += '             WHERE	 A.ITEM_CLASS  = C.CLASS_ID                                               ' + char(10)
			IF(LEN(@p_nick_name) > 0)
				BEGIN
					SELECT @v_dSql3 += '             AND   A.NICK_NAME LIKE ''%'' + ''' + @p_nick_name + ''' + ''%''   ' + char(10)
    			END
    
			SELECT @v_dSql3 += '     ) B                                            ' + char(10)
			SELECT @v_dSql3 += '     ON     A.COMPANY_ID  = B.COMPANY_ID            ' + char(10)
			SELECT @v_dSql3 += '     AND    A.DIVISION_ID = B.DIVISION_ID           ' + char(10)
			SELECT @v_dSql3 += '     AND    A.SITE_ID     = B.SITE_ID               ' + char(10)
			SELECT @v_dSql3 += '     AND    A.TOP_ITEM_ID = B.ITEM_ID               ' + char(10)
			SELECT @v_dSql3 += '     GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID    ' + char(10)
			SELECT @v_dSql3 += '       ,A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, B.NICK_NAME, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql3 += '       ,A.FACTORY_ID, A.LOCATION,A.PRODUCTION_TYPE, A.MARKET        ' + char(10)
			SELECT @v_dSql3 += '       ,A.PSI, A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE,A.PLAN_TYPE ' + char(10)
			SELECT @v_dSql3 += ' ) A                                                                ' + char(10)
			SELECT @v_dSql3 += ' INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)                          ' + char(10)
			SELECT @v_dSql3 += ' ON     A.COMPANY_ID  = C.COMPANY_ID                                ' + char(10)
			SELECT @v_dSql3 += ' AND    A.DIVISION_ID = C.DIVISION_ID                               ' + char(10)
			SELECT @v_dSql3 += ' AND    A.SITE_ID     = C.SITE_ID                                   ' + char(10)
			SELECT @v_dSql3 += ' AND    A.TOP_ITEM_ID = C.ITEM_ID                                   ' + char(10)
			SELECT @v_dSql3 += ' INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql3 += ' ON    A.COMPANY_ID     = E.COMPANY_ID          ' + char(10)
			SELECT @v_dSql3 += ' AND   A.DIVISION_ID    = E.DIVISION_ID         ' + char(10)
			SELECT @v_dSql3 += ' AND   A.SITE_ID        = E.SITE_ID             ' + char(10)
			SELECT @v_dSql3 += ' AND   A.PLANT_ID       = E.PLANT_ID            ' + char(10)
			SELECT @v_dSql3 += ' AND   A.FACTORY_ID     = E.FACTORY_ID          ' + char(10)
			SELECT @v_dSql3 += ' AND   A.OPERATION_ID   = E.OPERATION_ID        ' + char(10)
			SELECT @v_dSql3 += ' AND   A.LINE_ID        = E.LINE_ID             ' + char(10)
			SELECT @v_dSql3 += ' AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE      ' + char(10)
			SELECT @v_dSql3 += ' INNER HASH JOIN SCM_OPERATION_M F WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '  ON   A.COMPANY_ID     = F.COMPANY_ID          ' + char(10)
			SELECT @v_dSql3 += ' AND   A.DIVISION_ID    = F.DIVISION_ID         ' + char(10)
			SELECT @v_dSql3 += ' AND   A.SITE_ID        = F.SITE_ID             ' + char(10)
			SELECT @v_dSql3 += ' AND   A.OPERATION_ID   = F.OPERATION_ID        ' + char(10)
			SELECT @v_dSql3 += ' INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql3 += ' ON  A.PLAN_DATE        = G.DT                  ' + char(10)
			SELECT @v_dSql3 += ' INNER JOIN #TblFP00604_TEMP D                                                       ' + char(10)
			--SELECT @v_dSql3 += ' INNER JOIN (                                                       ' + char(10)
			--SELECT @v_dSql3 += '        SELECT 10 AS CATE_ORDER, ''MPP(In)'' AS CATE_NAME, ''M_IN'' AS CATE_ID       ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)													     
			--SELECT @v_dSql3 += '        SELECT 20 AS CATE_ORDER, ''MPP(Out)'' AS CATE_NAME, ''M_OUT'' AS CATE_ID     ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)													     
			--SELECT @v_dSql3 += '        SELECT 30 AS CATE_ORDER, ''WPP(In)'' AS CATE_NAME, ''W_IN'' AS CATE_ID       ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)													     
			--SELECT @v_dSql3 += '        SELECT 40 AS CATE_ORDER, ''WPP(Out)'' AS CATE_NAME, ''W_OUT'' AS CATE_ID     ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)													     
			--SELECT @v_dSql3 += '        SELECT 50 AS CATE_ORDER, ''Plan(In)'' AS CATE_NAME, ''P_IN'' AS CATE_ID      ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)
			--SELECT @v_dSql3 += '        SELECT 60 AS CATE_ORDER, ''Plan(Out)'' AS CATE_NAME, ''P_OUT'' AS CATE_ID    ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)													     
			--SELECT @v_dSql3 += '        SELECT 70 AS CATE_ORDER, ''Result'' AS CATE_NAME, ''P_RESULT'' AS CATE_ID    ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10) -- result(+exp.)
			--SELECT @v_dSql3 += '        SELECT 71 AS CATE_ORDER, ''Result(+Exp.)'' AS CATE_NAME, ''RESULT_EXP'' AS CATE_ID ' + char(10) -- result(+exp.)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)
			--SELECT @v_dSql3 += '        SELECT 80 AS CATE_ORDER, ''Off Cal.'' AS CATE_NAME, ''P_OFFTIME'' AS CATE_ID ' + char(10)
			--SELECT @v_dSql3 += '        UNION ALL ' + char(10)
			--SELECT @v_dSql3 += '        SELECT 90 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID        ' + char(10)
			--SELECT @v_dSql3 += ' ) D                                        ' + char(10)
			SELECT @v_dSql3 += ' ON     1=1                                 ' + char(10)
			SELECT @v_dSql3 += ' WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN  ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))     + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))           + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))       + char(10) 
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))   + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))             + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_nick_name))         + char(10)
			SELECT @v_dSql3 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))   + char(10)
			IF(LEN(@p_cell_group) > 0)
				BEGIN
					SELECT @v_dSql3 += ' AND  C.PACK_PRODUCT_GROUP_CODE LIKE ''%'' + '+@v_cell_group +' + ''%'' ' + char(10)
    			END    

			SELECT @v_dSql3 += ' GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
			SELECT @v_dSql3 += '     , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, ISNULL(A.NICK_NAME,''-'') ' + char(10)
			SELECT @v_dSql3 += '     , ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'')                          ' + char(10)
			SELECT @v_dSql3 += '     , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'')                   ' + char(10)
			SELECT @v_dSql3 += '     , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET            ' + char(10)
			SELECT @v_dSql3 += '     , A.LINE_ID, ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE           ' + char(10)
			SELECT @v_dSql3 += '     , D.CATE_ORDER, D.CATE_NAME, D.CATE_ID                             ' + char(10)
			SELECT @v_dSql3 += '; ' + char(10)+ char(10)
			
			--SELECT @v_dSql3 += ' )                                                                      ' + char(10)
			/*
			SELECT @v_dSql3 = @v_dSql1 + @v_dSql2 + @v_dSql3

			EXEC SP_EXECUTESQL @v_dSql3;

			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql3,'tempDB',@runstart, @runend
			*/

			SELECT @v_dSql4  = ''
			SELECT @v_dSql4 += '    INSERT INTO #MAIN_GAP                 ' + char(10)
			--SELECT @v_dSql4 += '  , MAIN_GAP AS (                                              ' + char(10)
			--SELECT @v_dSql4 += '  WITH MAIN_GAP AS (                                              ' + char(10)
			SELECT @v_dSql4 += '    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql4 += '       , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME    ' + char(10)
			SELECT @v_dSql4 += '       , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME    ' + char(10)
			SELECT @v_dSql4 += '       , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '       , A.PSI, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql4 += '       , A.CATE                                                ' + char(10)
			SELECT @v_dSql4 += '       , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, A.S_ROW       ' + char(10)
			--sql+= data.DAY2MONTH + data.DAY2WEEK
			--SELECT @v_dSql4 = @v_dSql4 + @p_day2month + @p_day2week
			--2026-05-13 E20260421-000487 acc gap - weeksum error - plan by line ( fomation)
			SELECT @v_dSql4 += dbo.FN_GET_LAST_D_ALIAS(@p_day2month) 
			SELECT @v_dSql4 += dbo.FN_GET_LAST_D_ALIAS(@p_day2week) 

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
            	      			  SET @v_Tmp1 += '       , A.D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+' AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      			  SET @mst_loop_cnt =  @mst_loop_cnt + 1
            				  END
						END 
				END

			SELECT @v_dSql4 = @v_dSql4 + @v_Tmp1

			
			SELECT @v_dSql4 += '    FROM (                                                           ' + char(10)
			SELECT @v_dSql4 += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID  ' + char(10)
			SELECT @v_dSql4 += '             , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME    ' + char(10)
			SELECT @v_dSql4 += '             , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME    ' + char(10)
			SELECT @v_dSql4 += '             , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '             , A.PSI, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE       ' + char(10)
			SELECT @v_dSql4 += '             , A.CATE                                                ' + char(10)
    
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

			SELECT @v_dSql4 += '             , A.CATEGORY_ID, A.CATEGORY_ORDER, A.DATA_TYPE, A.S_ROW                       ' + char(10)
			SELECT @v_dSql4 += '          FROM (                                                                           ' + char(10)
			SELECT @v_dSql4 += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID   ' + char(10)
			SELECT @v_dSql4 += '                   , A.ITEM_ID, B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') AS NICK_NAME        ' + char(10)
			SELECT @v_dSql4 += '                   , ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'') AS PJT_GROUP_NAME             ' + char(10)
			SELECT @v_dSql4 += '                   , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'') AS OPERATION_NAME      ' + char(10)
			SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, ''P'' AS PSI   ' + char(10)
			SELECT @v_dSql4 += '                   , A.LINE_ID, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME                     ' + char(10)
			SELECT @v_dSql4 += '                   , A.ELECTRODE_TYPE, D.CATE_NAME AS CATE                                 ' + char(10)
    
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
    							 SET @v_Tmp1 += '                   , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) <= ''' + @sub_param_2 + ''' AND A.PLAN_DATE >= H.INSTANCE_DATE THEN A.GAP_QTY ELSE 0 END) AS D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
    						 
							 END 
    					END
				END
    
			SELECT @v_dSql4 =  @v_dSql4 + @v_Tmp1

			SELECT @v_dSql4 += '                   , D.CATE_ID AS CATEGORY_ID, D.CATE_ORDER AS CATEGORY_ORDER     ' + char(10)
			SELECT @v_dSql4 += '                   , ''DATA'' AS DATA_TYPE, NULL AS S_ROW                         ' + char(10)
			SELECT @v_dSql4 += '                FROM (                                                            ' + char(10)
			--SELECT @v_dSql4 += '                      -- 생산실적 차질분 계산                                     ' + char(10)
			SELECT @v_dSql4 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID   ' + char(10)
			SELECT @v_dSql4 += '                          , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.OPERATION_ID ' + char(10)
			SELECT @v_dSql4 += '                          , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SELECT @v_dSql4 += '                          , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE              ' + char(10)
			SELECT @v_dSql4 += '                          , SUM(ISNULL(A.RESULT_QTY,0)) - SUM(ISNULL(A.OUT_QTY,0)) AS GAP_QTY ' + char(10)
			SELECT @v_dSql4 += '                      FROM (                                            ' + char(10)
			SELECT @v_dSql4 += '                             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                   ' + char(10)
			SELECT @v_dSql4 += '                                 , A.TOP_ITEM_ID, A.ITEM_ID, NULL AS ITEM_TYPE                           ' + char(10)
			SELECT @v_dSql4 += '                                 , A.OPERATION_ID, A.FACTORY_ID, ISNULL(A.LOCATION,''-'') AS LOCATION    ' + char(10)
			SELECT @v_dSql4 += '                                 , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE, A.MARKET, A.LINE_ID          ' + char(10)
			SELECT @v_dSql4 += '                                 , A.ELECTRODE_TYPE, A.PLAN_DATE, A.PLAN_QTY AS OUT_QTY, 0 AS RESULT_QTY ' + char(10)
			SELECT @v_dSql4 += '                             FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)                           ' + char(10)
			--SELECT @v_dSql4 += '                             WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '                             WHERE  A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '                             AND 	A.PLAN_TYPE = ''RELEASE''                 ' + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10) 
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))   + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))           + char(10)
			SELECT @v_dSql4 += '                             AND 	A.PLAN_QTY > 0                            ' + char(10)
			
			SELECT @v_dSql4 += '                             UNION ALL                                                 ' + char(10)
			SELECT @v_dSql4 += '                             SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID           ' + char(10)
			SELECT @v_dSql4 += '                                  , A.TOP_ITEM_ID, A.ITEM_ID, NULL AS ITEM_TYPE, A.OPERATION_ID  ' + char(10)
			SELECT @v_dSql4 += '                                  , A.FACTORY_ID, A.LOCATION           ' + char(10)
			SELECT @v_dSql4 += '                                  , A.PRODUCTION_TYPE, A.MARKET, A.LINE_ID ' + char(10)
			SELECT @v_dSql4 += '                                  , A.ELECTRODE_TYPE, A.PLAN_DATE, 0 AS OUT_QTY                  ' + char(10)
			SELECT @v_dSql4 += '                                  , A.RESULT_QTY                              ' + char(10)
			SELECT @v_dSql4 += '                             FROM   #SCM_DAILY_PRODUCT_RESULT_H_TEMP A WITH(NOLOCK)                    ' + char(10)
			--SELECT @v_dSql4 += '                             WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '                             WHERE  A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))   + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))           + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))         + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))     + char(10) 
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))           + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id))   + char(10)
			--SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))           + char(10)
			--SELECT @v_dSql4 += '        		             AND   (A.ACTUAL_GOOD_QTY ) > 0                   ' + char(10)
			SELECT @v_dSql4 += '                         ) A                                                  ' + char(10)
			--SELECT @v_dSql4 += '                         -- 확정시점 가져오기 ' + char(10)
                       
			IF(@p_confirm_area = 'BUILDING') 
				BEGIN
					SELECT @v_dSql4 += '                 INNER JOIN (                                                                         ' + char(10)
					SELECT @v_dSql4 += '                              SELECT A.FACTORY_ID, CONVERT(DATETIME,A.INSTANCE_DATE) AS INSTANCE_DATE ' + char(10)
					SELECT @v_dSql4 += '                              FROM (                                                                  ' + char(10)
					SELECT @v_dSql4 += '                                    SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
					SELECT @v_dSql4 += '                                    	 , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                                    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                 ' + char(10)
					SELECT @v_dSql4 += '                                    WHERE  A.INSTANCE_ID = ' + @v_instance_id + '                ' + char(10)
					SELECT @v_dSql4 += '                                    AND    A.FACTORY_ID IN (                                     ' + char(10)
					SELECT @v_dSql4 += '                                                    SELECT DISTINCT B.FACTORY_ID                 ' + char(10)
					SELECT @v_dSql4 += '                                                    FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)  ' + char(10)
					SELECT @v_dSql4 += '                                                    INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
					SELECT @v_dSql4 += '                                                    ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
					SELECT @v_dSql4 += '                                                    AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                                                    AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                                                    AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
					SELECT @v_dSql4 += '                                    )                     ' + char(10)
					SELECT @v_dSql4 += '                              ) A                         ' + char(10)
					SELECT @v_dSql4 += '                          WHERE A.ROW_NUM = 1             ' + char(10)
					SELECT @v_dSql4 += '                          ) B                             ' + char(10)
					SELECT @v_dSql4 += '                      ON    A.FACTORY_ID = B.FACTORY_ID   ' + char(10)
					SELECT @v_dSql4 += '                      WHERE A.PLAN_DATE >= B.INSTANCE_DATE' + char(10)
				END
			ELSE --plan groupd 단위
				BEGIN
					SELECT @v_dSql4 += '                  INNER JOIN SCM_LINE_M C WITH(NOLOCK)                ' + char(10)
					SELECT @v_dSql4 += '                   ON  A.COMPANY_ID     = C.COMPANY_ID                ' + char(10)
					SELECT @v_dSql4 += '                   AND A.DIVISION_ID    = C.DIVISION_ID               ' + char(10)
					SELECT @v_dSql4 += '                   AND A.SITE_ID        = C.SITE_ID                   ' + char(10)
					SELECT @v_dSql4 += '                   AND A.PLANT_ID       = C.PLANT_ID                  ' + char(10)
					SELECT @v_dSql4 += '                   AND A.FACTORY_ID     = C.FACTORY_ID                ' + char(10)
					SELECT @v_dSql4 += '                   AND A.OPERATION_ID   = C.OPERATION_ID              ' + char(10)
					SELECT @v_dSql4 += '                   AND A.LINE_ID        = C.LINE_ID                   ' + char(10)
					SELECT @v_dSql4 += '                   AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE            ' + char(10)
					SELECT @v_dSql4 += '                   INNER JOIN (                                       ' + char(10)
					SELECT @v_dSql4 += '                              SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE ' + char(10)
					SELECT @v_dSql4 += '                              FROM (                                  ' + char(10)
					SELECT @v_dSql4 += '                                    SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.PLAN_GROUP_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME     ' + char(10)
					SELECT @v_dSql4 += '                                    	 , ROW_NUMBER() OVER (PARTITION BY A.PLAN_GROUP_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                                    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                         ' + char(10)
					SELECT @v_dSql4 += '                                    WHERE  A.INSTANCE_ID = ' + @v_instance_id + '                        ' + char(10)
					SELECT @v_dSql4 += '                                    AND    A.PLAN_GROUP_ID IN (                                          ' + char(10)
					SELECT @v_dSql4 += '                                                 SELECT DISTINCT A.SEGMENT2 AS PLAN_GROUP_ID             ' + char(10)
					SELECT @v_dSql4 += '                                                 FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              ' + char(10)
					SELECT @v_dSql4 += '                                                 WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
					SELECT @v_dSql4 += '                                                 AND    A.ACTIVE_FLAG = ''Y''                            ' + char(10)
					SELECT @v_dSql4 += '                                                 AND    A.SEGMENT1 = ' + @v_instance_id + '              ' + char(10)
					SELECT @v_dSql4 += '                                    )                                           ' + char(10)
					SELECT @v_dSql4 += '                              ) A                                               ' + char(10)
					SELECT @v_dSql4 += '                              WHERE A.ROW_NUM = 1                               ' + char(10)
					SELECT @v_dSql4 += '                   ) B                                                          ' + char(10)
					SELECT @v_dSql4 += '                   ON    C.MODEL_TYPE = B.PLAN_GROUP_ID                         ' + char(10)
					SELECT @v_dSql4 += '                   WHERE A.PLAN_DATE >= B.INSTANCE_DATE                         ' + char(10)
				END
    
			SELECT @v_dSql4 += '                   GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '                   	  , A.ITEM_ID, A.ITEM_TYPE, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION      ' + char(10)
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
			SELECT @v_dSql4 += '               ) B                                   ' + char(10)
			SELECT @v_dSql4 += '               ON     A.COMPANY_ID  = B.COMPANY_ID   ' + char(10)
			SELECT @v_dSql4 += '               AND    A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
			SELECT @v_dSql4 += '               AND    A.SITE_ID     = B.SITE_ID      ' + char(10)
			SELECT @v_dSql4 += '               AND    A.TOP_ITEM_ID = B.ITEM_ID      ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN SCM_ITEM_M C WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '               ON     A.COMPANY_ID   = C.COMPANY_ID  ' + char(10)
			SELECT @v_dSql4 += '               AND    A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql4 += '               AND    A.SITE_ID      = C.SITE_ID     ' + char(10)
			SELECT @v_dSql4 += '               AND    A.TOP_ITEM_ID  = C.ITEM_ID     ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN (                          ' + char(10)
			SELECT @v_dSql4 += '                     SELECT 75 AS CATE_ORDER, ''Accu. Gap'' AS CATE_NAME, ''GAP'' AS CATE_ID ' + char(10)
			SELECT @v_dSql4 += '               ) D                                        ' + char(10)
			SELECT @v_dSql4 += '               ON     1=1                                 ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN SCM_LINE_M E WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql4 += '               ON     A.COMPANY_ID     = E.COMPANY_ID     ' + char(10)
			SELECT @v_dSql4 += '               AND    A.DIVISION_ID    = E.DIVISION_ID    ' + char(10)
			SELECT @v_dSql4 += '               AND    A.SITE_ID        = E.SITE_ID        ' + char(10)
			SELECT @v_dSql4 += '               AND    A.PLANT_ID       = E.PLANT_ID       ' + char(10)
			SELECT @v_dSql4 += '               AND    A.FACTORY_ID     = E.FACTORY_ID     ' + char(10)
			SELECT @v_dSql4 += '               AND    A.OPERATION_ID   = E.OPERATION_ID   ' + char(10)
			SELECT @v_dSql4 += '               AND    A.LINE_ID        = E.LINE_ID        ' + char(10)
			SELECT @v_dSql4 += '               AND    A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN SCM_OPERATION_M F WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '               ON     A.COMPANY_ID     = F.COMPANY_ID     ' + char(10)
			SELECT @v_dSql4 += '               AND    A.DIVISION_ID    = F.DIVISION_ID    ' + char(10)
			SELECT @v_dSql4 += '               AND    A.SITE_ID        = F.SITE_ID        ' + char(10)
			SELECT @v_dSql4 += '               AND    A.OPERATION_ID   = F.OPERATION_ID   ' + char(10)
			--SELECT @v_dSql4 += '               INNER HASH JOIN TH_UIS_CAL G WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '               INNER JOIN TH_UIS_CAL G WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '               ON  A.PLAN_DATE        = G.DT              ' + char(10)

			--SELECT @v_dSql4 += '               -- 확정시점 가져오기                                ' + char(10)
    
			IF(@p_confirm_area = 'BUILDING') 
				BEGIN
					SELECT @v_dSql4 += '               INNER JOIN (                                ' + char(10)
					SELECT @v_dSql4 += '                      SELECT A.FACTORY_ID, A.INSTANCE_DATE ' + char(10)
					SELECT @v_dSql4 += '                      FROM (                               ' + char(10)
					SELECT @v_dSql4 += '                          SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.FACTORY_ID, A.RELEASE_PLAN_ID, A.INSERT_TIME  ' + char(10)
					SELECT @v_dSql4 += '                          , ROW_NUMBER() OVER (PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) AS ROW_NUM ' + char(10)
					SELECT @v_dSql4 += '                          FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)     ' + char(10)
					SELECT @v_dSql4 += '                          WHERE  A.INSTANCE_ID = ' + @v_instance_id + '    ' + char(10)
					SELECT @v_dSql4 += '                          AND    A.FACTORY_ID IN (                         ' + char(10)
					SELECT @v_dSql4 += '                              SELECT DISTINCT B.FACTORY_ID                 ' + char(10)
					SELECT @v_dSql4 += '                              FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)  ' + char(10)
					SELECT @v_dSql4 += '                              INNER JOIN SCM_FACTORY_M B WITH(NOLOCK)      ' + char(10)
					SELECT @v_dSql4 += '                              ON    A.FACTORY_ID  = B.FACTORY_ID           ' + char(10)
					SELECT @v_dSql4 += '                              AND   A.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                              AND   B.ACTIVE_FLAG = ''Y''                  ' + char(10)
					SELECT @v_dSql4 += '                              AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
					SELECT @v_dSql4 += '                          )                                                ' + char(10)
					SELECT @v_dSql4 += '                      ) A                                                  ' + char(10)
					SELECT @v_dSql4 += '                      WHERE A.ROW_NUM = 1                                  ' + char(10)
					SELECT @v_dSql4 += '               ) H                                                         ' + char(10)
					SELECT @v_dSql4 += '                ON  A.FACTORY_ID = H.FACTORY_ID                            ' + char(10)
    			END																								   
			ELSE -- plan groupd 단위																			     
				BEGIN																							   
					SELECT @v_dSql4 += '               INNER JOIN (                                                ' + char(10)
					SELECT @v_dSql4 += '               	     SELECT A.PLAN_GROUP_ID, A.INSTANCE_DATE               ' + char(10)
					SELECT @v_dSql4 += '               	     FROM (                                                ' + char(10)
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
					SELECT @v_dSql4 += '               ) H                                                                      ' + char(10)
					SELECT @v_dSql4 += '               ON    E.MODEL_TYPE = H.PLAN_GROUP_ID                                     ' + char(10)
    			END
    
			--SELECT @v_dSql4 += '               WHERE  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '               WHERE  A.PLAN_DATE BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id))            + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id))                    + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))                  + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))              + char(10) 
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id))          + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))                    + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                    + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.NICK_NAME' , 'LK', @p_nick_name))                + char(10)
			SELECT @v_dSql4 += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_prod_type))          + char(10)
            IF(LEN(@p_cell_group) > 0)
				BEGIN
					SELECT @v_dSql4 += '               AND  C.PACK_PRODUCT_GROUP_CODE LIKE ''%'' + RTRIM(LTRIM(' + @v_cell_group + ')) + ''%'' ' + char(10)
				END  
			SELECT @v_dSql4 += '               GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID            ' + char(10)
			SELECT @v_dSql4 += '                   , A.TOP_ITEM_ID, A.ITEM_ID, B.ITEM_TYPE, ISNULL(C.NICK_NAME,''-'') ' + char(10)
			SELECT @v_dSql4 += '               	, ISNULL(C.PACK_PRODUCT_GROUP_CODE,''-'')                             ' + char(10)
			SELECT @v_dSql4 += '                   , A.OPERATION_ID, ISNULL(F.OPERATION_NAME,''-'')                   ' + char(10)
			SELECT @v_dSql4 += '                   , A.FACTORY_ID, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET            ' + char(10)
			SELECT @v_dSql4 += '                   , A.LINE_ID, ISNULL(E.LINE_NAME,''-''), A.ELECTRODE_TYPE           ' + char(10)
			SELECT @v_dSql4 += '                   , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER	                          ' + char(10)			
			SELECT @v_dSql4 += '          ) A  ' + char(10)
			SELECT @v_dSql4 += '      ) A      ' + char(10)
			SELECT @v_dSql4 += '; ' + char(10)+ char(10)
			--SELECT @v_dSql4 += '  )            ' + char(10)

			/*
			EXEC SP_EXECUTESQL @v_dSql4;
			
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql4,'tempDB2',@runstart, @runend

			SET @v_dSql4 = ''
			*/

			--SELECT @v_dSql4 += '  , MAIN_P_SUBT AS (                                                     ' + char(10)
			SELECT @v_dSql4 += '  WITH MAIN_P_SUBT AS (                                                     ' + char(10)
			SELECT @v_dSql4 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
			SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME         ' + char(10)
			SELECT @v_dSql4 += '            , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME         ' + char(10)
			SELECT @v_dSql4 += '            , ''Total'' AS FACTORY_ID, NULL AS LOCATION                  ' + char(10)
			SELECT @v_dSql4 += '            , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI             ' + char(10)
			SELECT @v_dSql4 += '            , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '            , A.CATE                                                     ' + char(10)
			SELECT @v_dSql4 += '            , A.CATEGORY_ID                                                     ' + char(10)
			SELECT @v_dSql4 += '            , (CASE WHEN A.CATEGORY_ID = ''M_IN'' THEN 100                      ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''M_OUT'' THEN 200                     ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''W_IN'' THEN 300                      ' + char(10) 
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''W_OUT'' THEN 400                     ' + char(10)
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''P_IN'' THEN 500                      ' + char(10) 
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''P_OUT'' THEN 600                     ' + char(10) 
			SELECT @v_dSql4 += '                    WHEN A.CATEGORY_ID = ''P_RESULT'' THEN 700 ' + char(10) -- result
			SELECT @v_dSql4 += '                    ELSE 800 END) AS CATEGORY_ORDER                             ' + char(10) -- result(+exp.)
			SELECT @v_dSql4 += '            , ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW                             ' + char(10)
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
			
			SELECT @v_dSql4 += '        FROM (                                                                  ' + char(10)
			SELECT @v_dSql4 += '              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID         ' + char(10)
			SELECT @v_dSql4 += '                   , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME         ' + char(10)
			SELECT @v_dSql4 += '                   , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME         ' + char(10)
			SELECT @v_dSql4 += '                   , ''Total'' AS FACTORY_ID, NULL AS LOCATION                  ' + char(10)
			SELECT @v_dSql4 += '                   , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI             ' + char(10)
			SELECT @v_dSql4 += '                   , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql4 += '                   , A.CATE                                                     ' + char(10)
	
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
			SELECT @v_dSql4 += '              FROM #MAIN_P A                                               ' + char(10)
			SELECT @v_dSql4 += '              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql4 += '                , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME      ' + char(10)
			SELECT @v_dSql4 += '                , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME      ' + char(10)
			SELECT @v_dSql4 += '                , A.CATEGORY_ID, A.PSI, A.CATE                            ' + char(10)
			SELECT @v_dSql4 += '        ) A                                                               ' + char(10)
			SELECT @v_dSql4 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID       ' + char(10)
			SELECT @v_dSql4 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME          ' + char(10)
			SELECT @v_dSql4 += '            , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME          ' + char(10)
			SELECT @v_dSql4 += '            , A.CATEGORY_ID, A.PSI, A.CATE                                ' + char(10)
			SELECT @v_dSql4 += '  )                                                                       ' + char(10)
			
			

			SELECT @v_dSql5 = ''
			SELECT @v_dSql5 += '  , T_RELEASE AS (      ' + char(10)
			SELECT @v_dSql5 += '        SELECT A.FACTORY_ID ' + char(10)

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

    							 SELECT @v_Tmp1 += '        , MAX(CASE WHEN CONVERT(VARCHAR,A.RELEASE_DATE,112) = ''' + @sub_param_2 + ''' THEN ''Y'' ELSE NULL END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1)  +'_BG ' + char(10)
    						 END
    					END
				END
    
			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1

			SELECT @v_dSql5 += '        FROM (                                                                        ' + char(10)
			SELECT @v_dSql5 += '              SELECT A.FACTORY_ID, CONVERT(VARCHAR,B.INSERT_TIME,112) AS RELEASE_DATE ' + char(10)
			SELECT @v_dSql5 += '              FROM (                                                                  ' + char(10)
			SELECT @v_dSql5 += '                    SELECT A.INSTANCE_ID, A.RELEASE_PLAN_ID AS PLAN_ID, ''BUILDING'' AS CONFIRM_AREA           ' + char(10)
			SELECT @v_dSql5 += '                         , A.FACTORY_ID, A.INSERT_TIME                                                         ' + char(10)
			SELECT @v_dSql5 += '                         , DENSE_RANK() OVER(PARTITION BY A.FACTORY_ID ORDER BY A.INSERT_TIME DESC) SORT_ORDER ' + char(10)
			SELECT @v_dSql5 += '                    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)               ' + char(10)
			SELECT @v_dSql5 += '                        , (                                                    ' + char(10)
			SELECT @v_dSql5 += '                           SELECT DISTINCT A.INSTANCE_ID, A.FACTORY_ID         ' + char(10)
			SELECT @v_dSql5 += '                           FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql5 += '                           WHERE  A.ACTIVE_FLAG = ''Y''                        ' + char(10)
			SELECT @v_dSql5 += '                           AND    A.INSTANCE_ID = ' + @v_instance_id + '       ' + char(10)
			SELECT @v_dSql5 += '                        ) B                                                    ' + char(10)
			SELECT @v_dSql5 += '                    WHERE  A.INSTANCE_ID  = B.INSTANCE_ID                      ' + char(10)
			SELECT @v_dSql5 += '                    AND    A.FACTORY_ID   = B.FACTORY_ID                       ' + char(10)
			SELECT @v_dSql5 += '                    AND    A.INSTANCE_ID  = ' + @v_instance_id + '             ' + char(10)
			SELECT @v_dSql5 += '              ) A                                                              ' + char(10)
			SELECT @v_dSql5 += '              , SCM_FP_PLAN_H B WITH(NOLOCK)                                   ' + char(10)
			SELECT @v_dSql5 += '              WHERE A.INSTANCE_ID  = B.INSTANCE_ID                             ' + char(10)
			SELECT @v_dSql5 += '              AND   A.PLAN_ID      = B.PLAN_ID                                 ' + char(10)
			SELECT @v_dSql5 += '              AND   A.SORT_ORDER   = 1                                         ' + char(10)
			SELECT @v_dSql5 += '              AND   A.CONFIRM_AREA IN (                                        ' + char(10)
			SELECT @v_dSql5 += '                                       SELECT MAX(A.ATTRIBUTE1) AS CONFIRM_AREA           ' + char(10)
			SELECT @v_dSql5 += '                                       FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql5 += '                                       WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''        ' + char(10)
			SELECT @v_dSql5 += '                                       AND    A.SEGMENT1         = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql5 += '                                       AND    A.ACTIVE_FLAG      = ''Y''                  ' + char(10)
			SELECT @v_dSql5 += '                                      )         ' + char(10)
			SELECT @v_dSql5 += '        ) A                   ' + char(10)
			SELECT @v_dSql5 += '        GROUP BY A.FACTORY_ID ' + char(10)
			SELECT @v_dSql5 += '   )                          ' + char(10)
			
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
    	        					SELECT @v_Tmp1 += '          WHEN A.DATA_TYPE = ''TOTAL''   THEN ''#FFE5C2'' ' +char(10)
    	        					SELECT @v_Tmp1 += '          WHEN A.DATA_TYPE = ''DATA''    THEN ( CASE WHEN F.D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+ '_BG = ''Y'' THEN ''#FFFFE6'' ELSE '''' END ) ' + char(10)
    	        					SELECT @v_Tmp1 += '     ELSE '''' END AS D'+ TRY_CONVERT(NVARCHAR, @mst_loop_cnt) + '_BG ' + char(10)
    	        					SELECT @mst_loop_cnt =  @mst_loop_cnt + 1
    	        				END
						END
				END
    
			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1

			SELECT @v_dSql5 += '  FROM (                            ' + char(10)
										-- DATA
			SELECT @v_dSql5 += '        SELECT * FROM #MAIN_P        ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL                   ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM #MAIN_GAP      ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM #MAIN_GAP_WPP ' + char(10)
										-- SUB TOTAL
			SELECT @v_dSql5 += '        UNION ALL                   ' + char(10)
			SELECT @v_dSql5 += '        SELECT * FROM MAIN_P_SUBT   ' + char(10)
			SELECT @v_dSql5 += @v_SqlsubTotal
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '            , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '            , ''Total'' AS FACTORY_ID, NULL AS LOCATION ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '            , A.CATE, A.CATEGORY_ID, 820 AS CATEGORY_ORDER ' + char(10) -- result 다음 순
			SELECT @v_dSql5 += '            , ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW ' + char(10)

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

			SELECT @v_dSql5 += '        FROM    #MAIN_GAP A ' + char(10)
			SELECT @v_dSql5 += @v_SqlsubTotal
			SELECT @v_dSql5 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '               , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '               , A.PSI, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '            , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '            , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '            , ''Total'' AS FACTORY_ID, NULL AS LOCATION ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS PRODUCTION_TYPE, NULL AS MARKET, A.PSI ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE ' + char(10)
			SELECT @v_dSql5 += '            , A.CATE, A.CATEGORY_ID, 850 AS CATEGORY_ORDER ' + char(10) -- result 다음 순
			SELECT @v_dSql5 += '            , ''TOTAL'' AS DATA_TYPE, NULL AS S_ROW ' + char(10)

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

			SELECT @v_dSql5 += '        FROM    #MAIN_GAP_WPP A ' + char(10)
			SELECT @v_dSql5 += @v_SqlsubTotal
			SELECT @v_dSql5 += '        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SELECT @v_dSql5 += '               , A.TOP_ITEM_ID, A.ITEM_ID, A.ITEM_TYPE, A.NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '               , A.PJT_GROUP_NAME, A.OPERATION_ID, A.OPERATION_NAME ' + char(10)
			SELECT @v_dSql5 += '               , A.PSI, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
										-- total
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID                 ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS PLANT_ID, ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID               ' + char(10)
			SELECT @v_dSql5 += '        	, NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME              ' + char(10)
			SELECT @v_dSql5 += '            , A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME, NULL AS FACTORY_ID      ' + char(10)
			SELECT @v_dSql5 += '            , NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET                 ' + char(10)
			SELECT @v_dSql5 += '            , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE ' + char(10)
			SELECT @v_dSql5 += '           , A.CATEGORY_ID                                   ' + char(10)
			SELECT @v_dSql5 += '           , (CASE WHEN A.CATEGORY_ID = ''M_IN'' THEN 1000   ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''M_OUT'' THEN 2000  ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''W_IN'' THEN 3000   ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''W_OUT'' THEN 4000  ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''P_IN'' THEN 5000   ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''P_OUT'' THEN 6000  ' + char(10)
			SELECT @v_dSql5 += '                   WHEN A.CATEGORY_ID = ''P_RESULT'' THEN 6500 ' + char(10) -- result
			SELECT @v_dSql5 += '                   ELSE 7000 END) AS CATEGORY_ORDER          ' + char(10)
			SELECT @v_dSql5 += '           , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW         ' + char(10)

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
			
			SELECT @v_dSql5 += '        FROM MAIN_P_SUBT A ' + char(10)
			SELECT @v_dSql5 += @v_SqlTotal --total
			SELECT @v_dSql5 += '        GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID ' + char(10)
			SELECT @v_dSql5 += '             , NULL AS PLANT_ID, ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '        	 , NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql5 += '             , A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME, NULL AS FACTORY_ID ' + char(10)
			SELECT @v_dSql5 += '             , NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql5 += '             , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE ' + char(10)
			SELECT @v_dSql5 += '             , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '             , 7500 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '             , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW ' + char(10)

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
            	      	SET @v_Tmp1 += '             , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1
            		END
            	  
            		-- weekinfo
            		SET @mst_loop_cnt = 0	
            		SET @max_loop_cnt = 0
            		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp2       = ''
            		WHILE @mst_loop_cnt < @max_loop_cnt
            		BEGIN
            	      	SET @v_Tmp2 += '             , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            		END
            	  
            		-- bucket
            		SET @mst_loop_cnt = 0	
            		SET @max_loop_cnt = 0
            		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp3       = ''
            		WHILE @mst_loop_cnt < @max_loop_cnt
            		BEGIN
            	      	SET @v_Tmp3 += '             , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1
            		END
				END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '        FROM #MAIN_GAP A ' + char(10)
			SELECT @v_dSql5 += @v_SqlTotal --total
			SELECT @v_dSql5 += '        GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '        UNION ALL ' + char(10)
			SELECT @v_dSql5 += '        SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID ' + char(10)
			SELECT @v_dSql5 += '             , NULL AS PLANT_ID, ''Total'' AS TOP_ITEM_ID, NULL AS ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '        	 , NULL AS ITEM_TYPE, NULL AS NICK_NAME, NULL AS PJT_GROUP_NAME ' + char(10)
			SELECT @v_dSql5 += '             , A.OPERATION_ID AS OPERATION_ID, A.OPERATION_NAME, NULL AS FACTORY_ID ' + char(10)
			SELECT @v_dSql5 += '             , NULL AS LOCATION, NULL AS PRODUCTION_TYPE, NULL AS MARKET ' + char(10)
			SELECT @v_dSql5 += '             , A.PSI, NULL AS LINE_ID, NULL AS LINE_NAME, NULL AS ELECTRODE_TYPE, A.CATE ' + char(10)
			SELECT @v_dSql5 += '             , A.CATEGORY_ID ' + char(10)
			SELECT @v_dSql5 += '             , 8000 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '             , ''TOTAL_2'' AS DATA_TYPE, '''' AS S_ROW ' + char(10)

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
            	      	SET @v_Tmp1 += '             , SUM(M'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +') AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1
            		END
            	  
            		-- weekinfo
            		SET @mst_loop_cnt = 0	
            		SET @max_loop_cnt = 0
            		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp2       = ''
            		WHILE @mst_loop_cnt < @max_loop_cnt
            		BEGIN
            	      	SET @v_Tmp2 += '             , SUM(W'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1						
            		END
            	  
            		-- bucket
            		SET @mst_loop_cnt = 0	
            		SET @max_loop_cnt = 0
            		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					SET @v_Tmp3       = ''
            		WHILE @mst_loop_cnt < @max_loop_cnt
            		BEGIN
            	      	SET @v_Tmp3 += '             , SUM(D'+TRY_CONVERT(NVARCHAR, @mst_loop_cnt)+') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt) +' ' + char(10)
            	      	SET @mst_loop_cnt =  @mst_loop_cnt + 1
            		END
				END 
			END

			SELECT @v_dSql5 = @v_dSql5 + @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '        FROM #MAIN_GAP_WPP A ' + char(10)
			SELECT @v_dSql5 += @v_SqlTotal --total
			SELECT @v_dSql5 += '        GROUP BY A.OPERATION_ID, A.OPERATION_NAME, A.PSI, A.CATE, A.CATEGORY_ID, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '  ) A                                                          ' + char(10)
			SELECT @v_dSql5 += '  LEFT OUTER JOIN T_RELEASE F WITH(NOLOCK)                     ' + char(10)
			SELECT @v_dSql5 += '  ON 1=1                                                       ' + char(10)
			SELECT @v_dSql5 += '  AND A.FACTORY_ID = F.FACTORY_ID                              ' + char(10)
			SELECT @v_dSql5 += '  ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.TOP_ITEM_ID  ' + char(10)
			SELECT @v_dSql5 += '      ,A.OPERATION_ID DESC,A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql5 += '      ,(CASE WHEN DATA_TYPE=''DATA'' THEN 1 ELSE 999 END)      ' + char(10)
			SELECT @v_dSql5 += '      ,A.FACTORY_ID, A.LOCATION,A.PRODUCTION_TYPE, A.MARKET    ' + char(10)
			SELECT @v_dSql5 += '      ,A.LINE_ID, A.ELECTRODE_TYPE, CATEGORY_ORDER             ' + char(10)
			SELECT @v_dSql5 += '  OPTION (LOOP JOIN) ;' + char(10)+ char(10) -- 튜닝 추가

			SELECT @v_dSql5 += 'IF OBJECT_ID(''tempdb..#MAIN_P'') IS NOT NULL ' + char(10)
			SELECT @v_dSql5 += '	DROP TABLE #MAIN_P ' + char(10)
			SELECT @v_dSql5 += 'IF OBJECT_ID(''tempdb..#MAIN_GAP'') IS NOT NULL ' + char(10)
			SELECT @v_dSql5 += '	DROP TABLE #MAIN_GAP ' + char(10)+ char(10)

			SELECT @v_dSql5 += 'if object_id(''tempdb..#MAIN_ITEM_WPP_GAP'') is not null ' + char(10)
			SELECT @v_dSql5 += '	drop table #MAIN_ITEM_WPP_GAP ' + char(10)
			SELECT @v_dSql5 += 'if object_id(''tempdb..#MAIN_GAP_WPP'') is not null ' + char(10)
			SELECT @v_dSql5 += '	drop table #MAIN_GAP_WPP ' + char(10)+char(10)
			
			SELECT @v_dSql5 += 'IF OBJECT_ID(''tempdb..#TblFP00604_TEMP'') IS NOT NULL DROP TABLE #TblFP00604_TEMP;	' + char(10)
			SELECT @v_dSql5 += 'IF OBJECT_ID(''tempdb..#SCM_DAILY_PRODUCT_RESULT_H_TEMP'') IS NOT NULL  DROP TABLE #SCM_DAILY_PRODUCT_RESULT_H_TEMP; ' + char(10)


			SELECT @v_dSql =  @v_dSql1 + @v_dSql2 + @v_dSql3 + @v_dSql4 + @v_dSql5
			--SELECT @v_dSql =  @v_dSql4 + @v_dSql5
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'Main',@runstart, @runend
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
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name))                      + char(10)          
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
