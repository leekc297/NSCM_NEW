CREATE PROCEDURE [dbo].[PR_UI_FP00626_PANCAKESIMULATION_ASSY]
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
/** 프로그램 ID   :PR_UI_FP00626_PANCAKESIMULATION_ASSY                                       **/
/** 프로그램 명   : Procedure PR_UI_FP00626_PANCAKESIMULATION_ASSY                            **/
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
--                       2024-03-15 chkim.68 하드코딩 전환 (ref scm_code_lookup_value )
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00626_PANCAKESIMULATION_ASSY
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
  DECLARE @p_cell_type       NVARCHAR(max) = ''
  DECLARE @p_pancake_type    NVARCHAR(max) = ''
  DECLARE @p_model_nick_name NVARCHAR(100) = ''
  DECLARE @p_top_item_id     NVARCHAR(100) = ''
  DECLARE @p_item_id         NVARCHAR(100) = ''
  DECLARE @p_nick_name       NVARCHAR(100) = ''
  DECLARE @p_plan_type       NVARCHAR(max) = ''
  DECLARE @p_unit            NVARCHAR(max) = ''
  DECLARE @p_uom_type        NVARCHAR(100) = ''
  DECLARE @p_total_include   NVARCHAR(100) = ''
  DECLARE @p_release_flag    NVARCHAR(100) = ''
  DECLARE @p_chk_planid      NVARCHAR(100) = ''
  DECLARE @p_curr_date       NVARCHAR(100) = ''

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
  DECLARE @v_proc_name       NVARCHAR(100) = 'PR_UI_FP00626_PANCAKESIMULATION_ASSY'


  DECLARE @v_plan_date       NVARCHAR(100)  = ''
  DECLARE @v_instance_id     NVARCHAR(100)  = ''
  DECLARE @v_plan_id         NVARCHAR(100)  = ''
  DECLARE @v_division_id     NVARCHAR(1000) = ''
  DECLARE @v_site_id         NVARCHAR(1000) = ''
  DECLARE @v_plant_id        NVARCHAR(2000) = ''
  DECLARE @v_factory_id      NVARCHAR(2000) = ''
  DECLARE @v_cell_type       NVARCHAR(max)  = ''
  DECLARE @v_pancake_type    NVARCHAR(max)  = ''
  DECLARE @v_model_nick_name NVARCHAR(100)  = ''
  DECLARE @v_top_item_id     NVARCHAR(100)  = ''
  DECLARE @v_item_id         NVARCHAR(100)  = ''
  DECLARE @v_nick_name       NVARCHAR(100)  = ''
  DECLARE @v_plan_type       NVARCHAR(max)  = ''
  DECLARE @v_unit            NVARCHAR(max)  = ''
  DECLARE @v_uom_type        NVARCHAR(100)  = ''  
  DECLARE @v_total_include   NVARCHAR(100)  = ''
  DECLARE @v_release_flag    NVARCHAR(100)  = ''
  DECLARE @v_chk_planid      NVARCHAR(100)  = ''
  DECLARE @v_curr_date       NVARCHAR(100)  = ''
  DECLARE @v_bucket_from     NVARCHAR(100)  = ''
  DECLARE @v_bucket_to       NVARCHAR(100)  = ''
  DECLARE @v_bucket          NVARCHAR(max)  = ''
  DECLARE @v_day_info        NVARCHAR(max)  = ''
  DECLARE @v_week_info       NVARCHAR(max)  = ''
  DECLARE @v_month_info      NVARCHAR(max)  = ''
  DECLARE @v_cate_info       NVARCHAR(max)  = ''
  DECLARE @v_user_id         NVARCHAR(max)  = ''
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

--  DECLARE @params nvarchar(max)

--SET @params = ''
--SET @params += 'p_sys_type:' +ISNULL(@p_sys_type,'') +char(10)
--SET @params += 'p_sys_flag:' +ISNULL(@p_sys_flag,'') +char(10)
--SET @params += 'p_sys_gubun:' +ISNULL(@p_sys_gubun,'') +char(10)
--SET @params += 'p_user_id:' +ISNULL(@p_user_id,'') +char(10)
--SET @params += 'in_columns:' +ISNULL(@in_columns,'') +char(10)
--SET @params += 'in_row:' +ISNULL(@in_row,'') +char(10)
--SET @params += 'opt_none:' +ISNULL(@opt_none,'') +char(10)

--IF @p_sys_type = 'SQL' BEGIN
--  SELECT @params as SQL
--return
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
          ELSE IF @tmp_column = 'CELL_TYPE' 
              BEGIN
                 SET @p_cell_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END 
          ELSE IF @tmp_column = 'PANCAKE_TYPE' 
              BEGIN
                  SET @p_pancake_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
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
          ELSE IF @tmp_column = 'UNIT' 
              BEGIN
                  SET @p_unit =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'UOM_TYPE'
              BEGIN
                  SET @p_uom_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'TOTAL_INCLUDE'
              BEGIN
                  SET @p_total_include =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'RELEASE_FLAG'
              BEGIN
                  SET @p_release_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
              END
          ELSE IF @tmp_column = 'CHK_PLANID'
              BEGIN
                  SET @p_chk_planid =  [dbo].[SCM_ARR_SPL_VAL]( @in_row        ,@v_delimiter, @mst_loop_cnt);
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
        SELECT @v_instance_id    = '''' + @p_instance_id + ''''  , @v_plan_date        = '''' + @p_plan_date + ''''
               , @v_plan_id      = '''' + @p_plan_id + ''''      , @v_division_id      = '''' + @p_division_id + ''''
               , @v_site_id      = '''' + @p_site_id + ''''      , @v_plant_id         = '''' + @p_plant_id + ''''
               , @v_cell_type    = '''' + @p_cell_type + ''''    , @v_pancake_type     = '''' + @p_pancake_type + ''''
               , @v_top_item_id  = '''' + @p_top_item_id + ''''  , @v_model_nick_name  = '''' + @p_model_nick_name + ''''
               , @v_item_id      = '''' + @p_item_id + ''''      , @v_nick_name        = '''' + @p_nick_name + ''''
               , @v_unit         = '''' + @p_unit + ''''         , @v_plan_type        = '''' + @p_plan_type + ''''
               , @v_uom_type     = '''' + @p_uom_type + ''''     , @v_release_flag     = '''' + @p_release_flag + ''''
			   , @v_chk_planid   = '''' + @p_chk_planid + ''''   , @v_curr_date        = '''' + @p_curr_date + ''''
               , @v_bucket_from  = '''' + @p_bucket_from + ''''  , @v_bucket_to        = '''' + @p_bucket_to + ''''
               , @v_bucket       = '''' + @p_bucket + ''''       , @v_day_info         = '''' + @p_day_info + ''''
			   , @v_week_info    = '''' + @p_week_info + ''''    , @v_month_info       = '''' + @p_month_info + ''''   
			   , @v_cate_info    = '''' + @p_cate_info + ''''    , @v_total_include    = '''' + @p_total_include + ''''
			   , @v_user_id      = '''' + @p_user_id + ''''
    END

	--MAIN IF
	IF @p_sys_flag = 'SELECT_MAIN'
		BEGIN --MAIN IF
			SELECT @v_dSql1  = ''

if object_id('tempdb..#INSTANCE_T') is not null
	drop table #INSTANCE_T

			--SELECT @v_dSql1 += '	WITH INSTANCE_T AS ( ' +char(10)
			SELECT @v_dSql1 += '      SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID, B.INSTANCE_ID    ' +char(10)
			SELECT @v_dSql1 += '      into #INSTANCE_T    ' +char(10)
			SELECT @v_dSql1 += '      FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' +char(10)
			SELECT @v_dSql1 += '      ON  	A.FACTORY_ID=B.FACTORY_ID ' +char(10)
			SELECT @v_dSql1 += '      AND 	B.ACTIVE_FLAG = ''Y''     ' +char(10)
			SELECT @v_dSql1 += '      WHERE 1=1                       ' +char(10)
			SELECT @v_dSql1 += '      AND   A.ACTIVE_FLAG = ''Y''     ' +char(10)
			SELECT @v_dSql1 += '      AND 	B.INSTANCE_ID = (         ' +char(10)
			SELECT @v_dSql1 += '                              SELECT DISTINCT TO_INSTANCE_ID               ' +char(10)
			SELECT @v_dSql1 += '                              FROM   FP_INSTANCE_PANCAKE_V V WITH(NOLOCK)  ' +char(10)
			SELECT @v_dSql1 += '                              WHERE 1=1                                    ' +char(10)
			SELECT @v_dSql1 += '                              AND   V.INSTANCE_ID = ' + @v_instance_id + ' ' +char(10)
			SELECT @v_dSql1 += '                              AND   V.GUBUN       = ''PANCAKE'' ' +char(10)
			SELECT @v_dSql1 += '                              AND   V.ACTIVE_FLAG = ''Y''       ' +char(10)
			SELECT @v_dSql1 += '                              ) ' +char(10)
			--SELECT @v_dSql1 += '    )                           ' +char(10)

if object_id('tempdb..#PANCAKE_INSTANCE') is not null
	drop table #PANCAKE_INSTANCE

			--SELECT @v_dSql1 += '    , PANCAKE_INSTANCE AS	(              ' +char(10)
			SELECT @v_dSql1 += '           SELECT DISTINCT TO_INSTANCE_ID  ' +char(10)
			SELECT @v_dSql1 += '           into #PANCAKE_INSTANCE ' +char(10)
			SELECT @v_dSql1 += '           FROM   FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) ' +char(10)
			SELECT @v_dSql1 += '           WHERE 1=1                                   ' +char(10)
			SELECT @v_dSql1 += '           AND  V.INSTANCE_ID = ' + @v_instance_id + ' ' +char(10)
			SELECT @v_dSql1 += '           AND  V.GUBUN       = ''PANCAKE'' ' +char(10)
			SELECT @v_dSql1 += '           AND  V.ACTIVE_FLAG = ''Y''       ' +char(10)
			--SELECT @v_dSql1 += '    )                                       ' +char(10)

if object_id('tempdb..#SHIPMENT_INFO') is not null
	drop table #SHIPMENT_INFO


			--SELECT @v_dSql1 += '	, SHIPMENT_INFO AS (                    ' +char(10)
			SELECT @v_dSql1 += '	           SELECT AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID, AA.SHOP_GROUP_ID, MAX(AA.SCP_PLAN_ID) AS SCP_PLAN_ID  ' +char(10)
			SELECT @v_dSql1 += '	           into #SHIPMENT_INFO                       ' +char(10)
			SELECT @v_dSql1 += '	           FROM	 FP_WEEKLY_DEMAND_SHIPMENT_H AA WITH(NOLOCK)                       ' +char(10)
			SELECT @v_dSql1 += '	           INNER JOIN ( SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' +char(10)
			SELECT @v_dSql1 += '	                        FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)                   ' +char(10)              
			SELECT @v_dSql1 += '	                        WHERE  A.INSTANCE_ID = (  SELECT TOP 1 TO_INSTANCE_ID      ' +char(10)
			SELECT @v_dSql1 += '	                        FROM   FP_INSTANCE_PANCAKE_V V WITH(NOLOCK)  ' +char(10)
			SELECT @v_dSql1 += '	                        WHERE 1=1                                    ' +char(10)                        
			SELECT @v_dSql1 += '	                        AND  V.INSTANCE_ID = ' + @v_instance_id + '  ' +char(10)
			SELECT @v_dSql1 += '	                        AND  V.GUBUN       = ''PANCAKE''             ' +char(10)
			SELECT @v_dSql1 += '	                        AND  V.ACTIVE_FLAG = ''Y'' )                 ' +char(10)
			SELECT @v_dSql1 += '	           ) BB                                 ' +char(10)
			SELECT @v_dSql1 += '	           ON  AA.COMPANY_ID  = BB.COMPANY_ID   ' +char(10)
			SELECT @v_dSql1 += '	           AND AA.DIVISION_ID = BB.DIVISION_ID  ' +char(10)
			SELECT @v_dSql1 += '	           AND AA.SITE_ID     = BB.SITE_ID      ' +char(10) 
			SELECT @v_dSql1 += '	           AND AA.PLANT_ID    = BB.PLANT_ID     ' +char(10)
			SELECT @v_dSql1 += '	           WHERE  1=1                           ' +char(10)                           
			SELECT @v_dSql1 += '	           AND  AA.SHOP_GROUP_ID = ''E''        ' +char(10)
			SELECT @v_dSql1 += '	           GROUP BY AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID , AA.SHOP_GROUP_ID ' +char(10)
			--SELECT @v_dSql1 += '	 )               ' +char(10)

if object_id('tempdb..#ASSY_PLAN') is not null
	drop table #ASSY_PLAN 


			SELECT @v_dSql1 += '    -- Assy Plan     ' +char(10)
			--SELECT @v_dSql1 += '    , ASSY_PLAN AS ( ' +char(10)
			SELECT @v_dSql1 += '          SELECT A.* ' +char(10)
			SELECT @v_dSql1 += '          into  #ASSY_PLAN    ' +char(10)
			SELECT @v_dSql1 += '          FROM (     ' +char(10)
			SELECT @v_dSql1 += '          	    SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' +char(10)
			SELECT @v_dSql1 += '                    , RELEASE_PLAN_ID, INSERT_TIME ' +char(10)
			SELECT @v_dSql1 += '                    , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' +char(10)
			SELECT @v_dSql1 += '                        ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' +char(10)
			SELECT @v_dSql1 += '          	    FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' +char(10)
			SELECT @v_dSql1 += '          	    WHERE  A.INSTANCE_DATE <= ' + @v_plan_date + ' ' +char(10)
			SELECT @v_dSql1 += '          ) A ' +char(10)
			SELECT @v_dSql1 += '          WHERE A.ROW_NUM = 1 ' +char(10)
			SELECT @v_dSql1 += '          AND   A.INSTANCE_ID = ' + @v_instance_id + ' ' +char(10)

            IF(@p_release_flag = 'Y')
                BEGIN
                    SELECT @v_dSql1 += '                	AND   1=1 ' + char(10)
                END
            ELSE
                BEGIN
                    SELECT @v_dSql1 += '                	AND   1=0 ' + char(10)
                END
            
			SELECT @v_dSql1 += '          UNION ALL ' + char(10)
			SELECT @v_dSql1 += '          SELECT ' + @v_instance_id + ' AS INSTANCE_ID, ''-'' AS RELEASE_VALUE, ' + @v_plan_id + ' AS RELEASE_PLAN_ID, A.INSERT_TIME AS INSERT_TIME, 1 AS ROW_NM ' + char(10)
			SELECT @v_dSql1 += '          FROM SCM_FP_PLAN_H A WITH(NOLOCK) ' + char(10)
            
			IF(@p_release_flag = 'Y')
                BEGIN
                    SELECT @v_dSql1 += '                	WHERE   1=0 ' + char(10)
                END
            ELSE
                BEGIN
                    SELECT @v_dSql1 += '                	WHERE   1=1 ' + char(10)
                END

			SELECT @v_dSql1 += '          AND A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql1 += '          AND A.PLAN_ID     = ' + @v_plan_id + '     ' + char(10)
			--SELECT @v_dSql1 += '    )                  ' + char(10)

if object_id('tempdb..#COATER_PLAN') is not null
	drop table #COATER_PLAN


			SELECT @v_dSql1 += '    -- Coater Plan     ' + char(10)
			--SELECT @v_dSql1 += '    , COATER_PLAN AS ( ' + char(10)
			SELECT @v_dSql1 += '          SELECT A.*   ' + char(10)
			SELECT @v_dSql1 += '          into #COATER_PLAN       ' + char(10)
			SELECT @v_dSql1 += '          FROM (       ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE ' + char(10)
			SELECT @v_dSql1 += '                	 , RELEASE_PLAN_ID, INSERT_TIME ' + char(10)
			SELECT @v_dSql1 += '                	 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) ' + char(10)
			SELECT @v_dSql1 += '                           ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM ' + char(10)
			SELECT @v_dSql1 += '                FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                WHERE	1=1                                  ' + char(10)
			SELECT @v_dSql1 += '                AND   A.INSTANCE_ID IN (                     ' + char(10)
			SELECT @v_dSql1 += '                      SELECT A.SEGMENT1 AS ASSY_ID           ' + char(10)
			SELECT @v_dSql1 += '                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)             ' + char(10)
			SELECT @v_dSql1 += '                      WHERE  A.LOOKUP_TYPE_CODE = ''ELEC_ASSY_INSTANCE_MAP'' ' + char(10)
			SELECT @v_dSql1 += '                      AND    A.SEGMENT2 = ' + @v_instance_id + '             ' + char(10)
			SELECT @v_dSql1 += '                      ) ' + char(10)

            IF(@p_release_flag = 'Y' OR @p_chk_planid = 'Y' )
                BEGIN
                    SELECT @v_dSql1 += '                AND  A.INSTANCE_DATE <= ' + @v_plan_date + ' ' + char(10)
                END
            ELSE
                BEGIN
                    SELECT @v_dSql1 += '                AND  A.INSERT_TIME <= ( SELECT INSERT_TIME FROM ASSY_PLAN )' + char(10)
                END

			SELECT @v_dSql1 += '          ) A                 ' + char(10)
			SELECT @v_dSql1 += '          WHERE A.ROW_NUM = 1 ' + char(10)
			--SELECT @v_dSql1 += '    )                         ' + char(10)

if object_id('tempdb..#SHIP_PLAN') is not null
	drop table #SHIP_PLAN


			--SELECT @v_dSql1 += '	, SHIP_PLAN AS (          ' + char(10)
			SELECT @v_dSql1 += '          SELECT DISTINCT A.INSTANCE_ID, A.INSTANCE_DATE, A.VERSION_ID ' + char(10)
			SELECT @v_dSql1 += '          into #SHIP_PLAN ' + char(10)
			SELECT @v_dSql1 += '          FROM ( ' + char(10)
			SELECT @v_dSql1 += '                SELECT A.INSTANCE_ID, A.INSTANCE_DATE, A.VERSION_ID, ROW_NUMBER() OVER(ORDER BY INSTANCE_DATE DESC, VERSION_ID DESC) AS ROW_NUM ' + char(10)
			SELECT @v_dSql1 += '                FROM   FP_PANCAKE_SHIPMENT_PLAN_R A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '                WHERE  A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql1 += '          ) A                 ' + char(10)
			SELECT @v_dSql1 += '          WHERE A.ROW_NUM = 1 ' + char(10)
			--SELECT @v_dSql1 += '	)                         ' + char(10)
			
if object_id('tempdb..#OPERATION_YIELD') is not null
	drop table #OPERATION_YIELD			
			
			
			--SELECT @v_dSql1 += '	, OPERATION_YIELD AS (    ' + char(10)
			SELECT @v_dSql1 += '          SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, ITEM_ID, MONTH ' + char(10)
			SELECT @v_dSql1 += '              , (CASE WHEN A.Y3 IS NULL OR A.Y3 = 0 THEN 1 ELSE A.Y3 END) AS Y3 ' + char(10)
			SELECT @v_dSql1 += '              , (CASE WHEN A.Y4 IS NULL OR A.Y4 = 0 THEN 1 ELSE A.Y4 END) AS Y4 ' + char(10)
			SELECT @v_dSql1 += '          into #OPERATION_YIELD	 ' + char(10)
			SELECT @v_dSql1 += '          FROM ( ' + char(10)
			SELECT @v_dSql1 += '                SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID  , ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql1 += '                    , MIN(CASE WHEN OPERATION_ID = ''E3000'' THEN YIELD ELSE 1 END) AS Y3 ' + char(10)
			SELECT @v_dSql1 += '                    , MIN(CASE WHEN OPERATION_ID = ''E4000'' THEN YIELD ELSE 1 END) AS Y4 ' + char(10)
			SELECT @v_dSql1 += '                FROM  ( ' + char(10)
			SELECT @v_dSql1 += '                       SELECT 	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID,  MIN(A.YIELD) AS YIELD ' + char(10)
			SELECT @v_dSql1 += '                       FROM  SCM_YIELD_M A WITH(NOLOCK)     ' + char(10)
			SELECT @v_dSql1 += '                           , #INSTANCE_T B WITH(NOLOCK)      ' + char(10)
			SELECT @v_dSql1 += '                       WHERE  1=1                           ' + char(10)
			SELECT @v_dSql1 += '                       AND  A.COMPANY_ID 	= B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql1 += '                       AND  A.DIVISION_ID 	= B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '                       AND  A.SITE_ID 		= B.SITE_ID     ' + char(10)
			SELECT @v_dSql1 += '                       AND  A.PLANT_ID 		= B.PLANT_ID    ' + char(10)
			SELECT @v_dSql1 += '                       AND 	A.OPERATION_ID IN (''E3000'', ''E4000'')  -- ROLL PRESSING / SLITTING ' + char(10)
			SELECT @v_dSql1 += '                       AND 	A.MONTH BETWEEN CONVERT(VARCHAR(6),' + @v_bucket_from + ') AND CONVERT(VARCHAR(6),' + @v_bucket_to + ') ' + char(10)
			SELECT @v_dSql1 += '                       GROUP BY A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.FACTORY_ID, A.ITEM_ID , A.MONTH , A.OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '                      ) A ' + char(10)
			SELECT @v_dSql1 += '                WHERE 1=1 ' + char(10)
			SELECT @v_dSql1 += '                GROUP BY COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , FACTORY_ID  , ITEM_ID , MONTH ' + char(10)
			SELECT @v_dSql1 += '          	) A    ' + char(10)
			--SELECT @v_dSql1 += '    )              ' + char(10)
			
if object_id('tempdb..#STOCK_T') is not null
	drop table #STOCK_T			
			
			
			
			--SELECT @v_dSql1 += '    , STOCK_T AS ( ' + char(10)
			SELECT @v_dSql1 += '          SELECT B.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SELECT @v_dSql1 += '              , (CASE WHEN C.JR_BEFORE = ''Y'' THEN 2000 WHEN C.JR_AFTER = ''Y'' THEN 3000 ELSE 9999 END) AS OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '              , A.WIPHOLD_YN, A.ITEM_ID, A.CUTOFF_DATE ' + char(10)
			SELECT @v_dSql1 += '              , (CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) THEN ISNULL(A.SSP_QTY,0) ELSE 0 END) AS BOH_QTY ' + char(10)
			SELECT @v_dSql1 += '              , (CASE WHEN WIPHOLD_YN = ''Y'' THEN ISNULL(A.SSP_QTY,0) ELSE 0 END) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql1 += '              , A.STOCK_TYPE                      ' + char(10)
			SELECT @v_dSql1 += '          into #STOCK_T ' + char(10)
			SELECT @v_dSql1 += '          FROM   IF_FP_SCM_STOCK_V A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql1 += '             , ( SELECT *                         ' + char(10)
			SELECT @v_dSql1 += '                 FROM   FP_INSTANCE_PANCAKE_V WITH(NOLOCK)                         ' + char(10)
			SELECT @v_dSql1 += '                 WHERE INSTANCE_ID = (SELECT TO_INSTANCE_ID FROM #PANCAKE_INSTANCE) ' + char(10)
			SELECT @v_dSql1 += '                 AND   GUBUN       = ''BOM'' ' + char(10)
			SELECT @v_dSql1 += '                 AND   ACTIVE_FLAG = ''Y''   ' + char(10)
			SELECT @v_dSql1 += '           ) B ' + char(10)
			SELECT @v_dSql1 += '          ,(   ' + char(10)
			SELECT @v_dSql1 += '              SELECT A.SEGMENT3 AS DIVISION_ID, A.SEGMENT2 AS SITE_ID, A.SEGMENT4 AS PLANT_ID, A.SEGMENT5 AS STOCK_POINT ' + char(10)
			SELECT @v_dSql1 += '              	   , A.ATTRIBUTE1 AS STOCK_TYPE, A.ATTRIBUTE8 AS JR_BEFORE, A.ATTRIBUTE9 AS JR_AFTER, A.ATTRIBUTE10 AS PANCAKE ' + char(10)
			SELECT @v_dSql1 += '              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql1 += '              WHERE A.LOOKUP_TYPE_CODE = ''SIMULATION_BOH''       ' + char(10)
			SELECT @v_dSql1 += '              AND   A.SEGMENT1         = ''PANCAKE_SIMUL_BY_BLD'' ' + char(10)
			SELECT @v_dSql1 += '              AND   A.ACTIVE_FLAG      = ''Y''                    ' + char(10)
			SELECT @v_dSql1 += '          ) C                                 ' + char(10)
			SELECT @v_dSql1 += '          WHERE A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql1 += '          AND   A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '          AND   A.SITE_ID     = B.SITE_ID     ' + char(10)
			SELECT @v_dSql1 += '          AND   A.PLANT_ID    = B.PLANT_ID    ' + char(10)
			SELECT @v_dSql1 += '          AND   A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql1 += '          AND   A.SITE_ID     = C.SITE_ID     ' + char(10)
			SELECT @v_dSql1 += '          AND   A.PLANT_ID    = C.PLANT_ID    ' + char(10)
			SELECT @v_dSql1 += '          AND   A.STOCK_TYPE  = C.STOCK_TYPE  ' + char(10)
			SELECT @v_dSql1 += '          -- erp 재고 : STORAGE_ID, mes 재고 : FP_APPLY_OPERATION_ID ' + char(10)
			SELECT @v_dSql1 += '          AND   (CASE WHEN A.STOCK_TYPE = ''INVENTORY'' THEN A.STORAGE_ID WHEN A.STOCK_TYPE = ''WIP'' THEN A.FP_APPLY_OPERATION_ID ELSE NULL END) = C.STOCK_POINT ' + char(10)
			SELECT @v_dSql1 += '          AND   A.CUTOFF_DATE BETWEEN CONVERT(DATE,' + @v_bucket_from + ')  AND CONVERT(DATE,' + @v_plan_date + ' ) ' + char(10)
			SELECT @v_dSql1 += '          AND   A.ITEM_ID LIKE ''APC%'' ' + char(10)
			SELECT @v_dSql1 += '          AND   A.SSP_QTY > 0           ' + char(10)
			--SELECT @v_dSql1 += '          )                             ' + char(10)

if object_id('tempdb..#SCM_BOM') is not null
	drop table #SCM_BOM


			
			SELECT @v_dSql2  = ''
			--SELECT @v_dSql2 += '    , SCM_BOM AS ( ' + char(10)
			SELECT @v_dSql2 += '          SELECT * ' + char(10)
			SELECT @v_dSql2 += '          into #SCM_BOM  ' + char(10)
			SELECT @v_dSql2 += '          FROM (   ' + char(10)
			SELECT @v_dSql2 += '                SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY, A.PARENT_UOM, A.CHILD_ITEM_ID, A.CHILD_QTY, A.CHILD_UOM ' + char(10)
			SELECT @v_dSql2 += '                   , A.ALT_ID, A.ALT_PRIORITY, A.EFF_START_DATE, A.EFF_END_DATE, B.FACTORY_ID, B.ASSY_FACTORY_ID, B.MONTH, B.PRIORITY      ' + char(10)
			SELECT @v_dSql2 += '                   , RANK() OVER ( PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.PARENT_QTY         ' + char(10)
			SELECT @v_dSql2 += '                             , A.EFF_START_DATE, A.EFF_END_DATE, B.FACTORY_ID, B.ASSY_FACTORY_ID, B.MONTH                                  ' + char(10)
			SELECT @v_dSql2 += '                        ORDER BY CASE WHEN B.PRIORITY IS NULL THEN 9 ELSE 1 END, ISNULL(A.ALT_PRIORITY, 1), ISNULL(B.PRIORITY, 9) ) AS RNK ' + char(10)
			SELECT @v_dSql2 += '                FROM   SCM_BOM_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                LEFT OUTER JOIN (               ' + char(10)
			SELECT @v_dSql2 += '                      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID, A.ITEM_ID,  A.MONTH, A.PRIORITY, B.ASSY_FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '                      FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                      INNER HASH JOIN (                            ' + char(10)
			SELECT @v_dSql2 += '                      		SELECT SEGMENT1 AS ASSY_FACTORY_ID, SEGMENT2 AS ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '                      		FROM   SCM_SYS_LOOKUP_VALUE L WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql2 += '                      		WHERE 1=1                                         ' + char(10)
			SELECT @v_dSql2 += '                      		AND  LOOKUP_TYPE_CODE = ''ELEC_ASSY_FACTORY_MAP'' ' + char(10)
			SELECT @v_dSql2 += '                      		AND  ACTIVE_FLAG = ''Y''                          ' + char(10)
			SELECT @v_dSql2 += '                      ) B       ' + char(10)
			SELECT @v_dSql2 += '                      ON    1=1 ' + char(10)
			SELECT @v_dSql2 += '                      AND   A.FACTORY_ID = B.ELEC_FACTORY_ID ' + char(10)
			SELECT @v_dSql2 += '                      WHERE 1=1                              ' + char(10)
			SELECT @v_dSql2 += '                      AND   A.ACTIVE_FLAG = ''Y''            ' + char(10)
			SELECT @v_dSql2 += '                      AND   A.MONTH BETWEEN SUBSTRING(' + @v_bucket_from + ',1,6) AND SUBSTRING(' + @v_bucket_to + ',1,6) ' + char(10)
			SELECT @v_dSql2 += '                      AND   A.PRIORITY NOT IN (0,9)     ' + char(10)
			SELECT @v_dSql2 += '                 ) B                                    ' + char(10)
			SELECT @v_dSql2 += '                 ON    1=1                              ' + char(10)
			SELECT @v_dSql2 += '                 AND   A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql2 += '                 AND   A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '                 AND   A.SITE_ID        = B.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND   A.CHILD_ITEM_ID  = B.ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND   B.MONTH <  = CONVERT(VARCHAR(6),A.EFF_END_DATE,112) ' + char(10)
			SELECT @v_dSql2 += '                 , TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '                 , ( SELECT  * FROM FP_INSTANCE_PANCAKE_V WITH(NOLOCK) WHERE INSTANCE_ID = ' + @v_instance_id + ' AND GUBUN= ''ASSY_PLANT'' AND ACTIVE_FLAG = ''Y'' ) E ' + char(10)
			SELECT @v_dSql2 += '                 , SCM_ITEM_M CC WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql2 += '                 , SCM_ITEM_CLASS_M DD WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql2 += '                 , SCM_ITEM_M EE WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql2 += '                 , SCM_ITEM_CLASS_M FF WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql2 += '                 WHERE 1=1                             ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.COMPANY_ID     = E.COMPANY_ID  ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.DIVISION_ID    = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.SITE_ID        = E.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.PLANT_ID       = E.PLANT_ID    ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.ACTIVE_FLAG    = ''Y''         ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.EFF_START_DATE = C.DT          ' + char(10)
			SELECT @v_dSql2 += '                 AND  C.YEAR + C.MONTH < = ISNULL(B.MONTH, C.YEAR + C.MONTH) ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.COMPANY_ID     = CC.COMPANY_ID  ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.DIVISION_ID    = CC.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.SITE_ID        = CC.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.PARENT_ITEM_ID = CC.ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND  CC.ITEM_CLASS    = DD.CLASS_ID    ' + char(10)
			SELECT @v_dSql2 += '                 AND  DD.LEVEL_2_NAME IN (''Notched Pancake'', ''Jelly Roll'') ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.COMPANY_ID     = EE.COMPANY_ID  ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.DIVISION_ID    = EE.DIVISION_ID ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.SITE_ID        = EE.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.CHILD_ITEM_ID  = EE.ITEM_ID     ' + char(10)
			SELECT @v_dSql2 += '                 AND  EE.ITEM_CLASS    = FF.CLASS_ID    ' + char(10)
			SELECT @v_dSql2 += '                 AND  FF.LEVEL_2_NAME  = ''Pancake''    ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.EFF_START_DATE<= ' + @v_plan_date + ' ' + char(10)
			SELECT @v_dSql2 += '                 AND  A.EFF_END_DATE   > ' + @v_plan_date + ' ' + char(10)
			SELECT @v_dSql2 += '          ) A             ' + char(10)
			SELECT @v_dSql2 += '          WHERE 1=1       ' + char(10)
			SELECT @v_dSql2 += '          AND   A.RNK = 1 ' + char(10)
			--SELECT @v_dSql2 += '    )                     ' + char(10)
			
 if object_id('tempdb..#INS_PLANT') is not null
	drop table #INS_PLANT			
			
			
			--SELECT @v_dSql2 += '    , INS_PLANT AS (      ' + char(10)
			SELECT @v_dSql2 += '          --= P/C ITEM을 입고받는 조립 PLANT ID 리스트 =--                     ' + char(10)
			SELECT @v_dSql2 += '          SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID   ' + char(10)
			SELECT @v_dSql2 += '              , V.DIVISION_ID AS ASSY_DIVISION_ID, V.PLANT_ID AS ASSY_PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '          into #INS_PLANT ' + char(10)
			SELECT @v_dSql2 += '          FROM  FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '              , (                                    ' + char(10)
			SELECT @v_dSql2 += '                 SELECT DISTINCT B.INSTANCE_ID, B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID ' + char(10)
			SELECT @v_dSql2 += '                 FROM   FP_INSTANCE_INFO_V B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql2 += '               )  B ' + char(10)
			SELECT @v_dSql2 += '          WHERE 1=1 ' + char(10)
			SELECT @v_dSql2 += '          AND  V.TO_INSTANCE_ID = B.INSTANCE_ID          ' + char(10)
			SELECT @v_dSql2 += '          AND  V.INSTANCE_ID    = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql2 += '          AND  V.GUBUN          = ''PANCAKE''            ' + char(10)
			SELECT @v_dSql2 += '          AND  V.ACTIVE_FLAG    = ''Y''                  ' + char(10)
			--SELECT @v_dSql2 += '    )           ' + char(10)
			

if object_id('tempdb..#INSTANCE_INFO') is not null
	drop table #INSTANCE_INFO

			SELECT @v_dSql2 += '   SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID               ' + char(10)     
			SELECT @v_dSql2 += '   into #INSTANCE_INFO														    ' + char(10)
			SELECT @v_dSql2 += '   FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)                   			    ' + char(10)
			SELECT @v_dSql2 += '   WHERE  A.INSTANCE_ID = (SELECT TO_INSTANCE_ID FROM #PANCAKE_INSTANCE)    ' + char(10)
																									    
if object_id('tempdb..#MAIN') is not null
	drop table #MAIN			
			

			--SELECT @v_dSql2 += '    , MAIN AS ( ' + char(10)
			SELECT @v_dSql2 += '        	SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql2 += '                , A.ITEM_ID, ISNULL(E.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SELECT @v_dSql2 += '                , ISNULL(E.APPLIED_MODEL, A.ITEM_ID) AS MODEL_T     ' + char(10)
			SELECT @v_dSql2 += '                , E.ITEM_TYPE, E.ITEM_CLASS                         ' + char(10)
			SELECT @v_dSql2 += '                , MAX(A.PLANT_ID) AS PLANT_ID                       ' + char(10)
			SELECT @v_dSql2 += '                , MAX(A.TOP_ITEM_ID) AS TOP_ITEM_ID                 ' + char(10)
			SELECT @v_dSql2 += '                , MAX(A.NPC_ITEM_ID) AS NPC_ITEM_ID                 ' + char(10)
			SELECT @v_dSql2 += '                , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER  ' + char(10)

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
						      SET @mst_loop_cnt     =  @mst_loop_cnt +1
                              SET @tmp_column       = ''
                              SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_month_info,@v_delimiter, @mst_loop_cnt)
                              SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                              
                              SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => YYYYMM AS MONTH
                              SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => 'Jan' AS MONTH_NAME
                              SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 =>  COUNT(*) AS MONTH_COUNT
                              --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => 'M0~M12' AS M-VALUE

							  SET @v_Tmp1 += '                , SUM(CASE WHEN C.YYYYMM = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID = ''COATER'' THEN 0  ' + char(10)
                              SET @v_Tmp1 += '                           WHEN B.CATEGORY_ID = ''POST'' THEN 0     ' + char(10)
                              SET @v_Tmp1 += '                           WHEN B.CATEGORY_ID = ''ASSY'' THEN 0     ' + char(10)
                              SET @v_Tmp1 += '                           WHEN B.CATEGORY_ID = ''SHIP'' THEN 0     ' + char(10)
                              SET @v_Tmp1 += '                           WHEN B.CATEGORY_ID = ''SHIP_IN'' THEN 0  ' + char(10)
                              SET @v_Tmp1 += '                           WHEN B.CATEGORY_ID = ''INV'' THEN 0      ' + char(10)
                              SET @v_Tmp1 += '                      ELSE 0 END ) ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
        				  END
        	  
        			  -- weekinfo
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp2       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @mst_loop_cnt     =  @mst_loop_cnt +1
                              SET @tmp_column       = ''
                              SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
                              SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                              
                              SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => ISO_YYYYWW AS WEEK
                              SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => 'W'  AS WEEK_NAME
                              SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 =>  COUNT(*) AS WEEK_COUNT
                              --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => 'W0~W1' AS W_VALUE

							  SET @v_Tmp2 += '                , SUM(CASE WHEN C.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN ( CASE WHEN B.CATEGORY_ID = ''COATER'' THEN 0 ' + char(10)
							  SET @v_Tmp2 += '                           WHEN B.CATEGORY_ID = ''POST'' THEN 0  ' + char(10)
							  SET @v_Tmp2 += '                           WHEN B.CATEGORY_ID = ''ASSY'' THEN 0  ' + char(10)
							  SET @v_Tmp2 += '                           WHEN B.CATEGORY_ID = ''SHIP'' THEN 0  ' + char(10)
							  SET @v_Tmp2 += '                           WHEN B.CATEGORY_ID = ''SHIP_IN'' THEN 0  ' + char(10)
							  SET @v_Tmp2 += '                           WHEN B.CATEGORY_ID = ''INV'' THEN 0  ' + char(10)
							  SET @v_Tmp2 += '                      ELSE 0 END ) ELSE 0 END ) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)					
        				  END
        	  
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

							  SET @v_Tmp3 += '                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_2 + ''' THEN ( CASE WHEN B.CATEGORY_ID = ''COATER'' THEN ROUND(A.COATER_QTY,0)  ' + char(10)
							  SET @v_Tmp3 += '                           WHEN B.CATEGORY_ID = ''POST'' THEN ROUND(A.POST_QTY,0)  ' + char(10)
							  SET @v_Tmp3 += '                           WHEN B.CATEGORY_ID = ''ASSY'' THEN ROUND(A.ASSY_QTY,0)  ' + char(10)
							  SET @v_Tmp3 += '                           WHEN B.CATEGORY_ID = ''SHIP'' THEN ROUND(A.SHIP_QTY,0)  ' + char(10)
							  SET @v_Tmp3 += '                           WHEN B.CATEGORY_ID = ''SHIP_IN'' THEN ROUND(A.SHIP_IN_QTY,0)  ' + char(10)
							  SET @v_Tmp3 += '                           WHEN B.CATEGORY_ID = ''INV'' THEN A.BOH_QTY  ' + char(10)
							  SET @v_Tmp3 += '                      ELSE 0 END ) ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
        				  END
				END 
			END

			SELECT @v_dSql2  +=  @v_Tmp1 + @v_Tmp2 + @v_Tmp3



			SELECT @v_dSql2 += '                , ''DATA'' AS DATA_TYPE ' + char(10)
			SELECT @v_dSql2 += '        	into #MAIN                     ' + char(10)
			SELECT @v_dSql2 += '        	FROM (                      ' + char(10)
			SELECT @v_dSql2 += '	              -- Assy               ' + char(10)
			SELECT @v_dSql2 += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CHILD_ITEM_ID AS ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, 0 AS COATER_QTY, 0 AS POST_QTY ' + char(10)
			SELECT @v_dSql2 += '                      , SUM(ROUND(ISNULL(A.PC_QTY,0),0)) AS ASSY_QTY, 0 AS SHIP_QTY, 0 AS SHIP_IN_QTY, 0 AS BOH_QTY ' + char(10)
			SELECT @v_dSql2 += '                      , A.PLANT_ID AS PLANT_ID, A.ITEM_ID AS NPC_ITEM_ID, A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '                  FROM (                                   ' + char(10)
			SELECT @v_dSql2 += '                  		SELECT A.INSTANCE_ID, A.COMPANY_ID ' + char(10)
			SELECT @v_dSql2 += '                            , A.DIVISION_ID, A.SITE_ID     ' + char(10)
			SELECT @v_dSql2 += '                            , A.PLANT_ID, A.TOP_ITEM_ID    ' + char(10)
			SELECT @v_dSql2 += '                            , A.ITEM_ID                    ' + char(10)
			SELECT @v_dSql2 += '                            , ISNULL(B.CHILD_ITEM_ID, ISNULL(C.CHILD_ITEM_ID, D.CHILD_ITEM_ID)) AS CHILD_ITEM_ID ' + char(10)
			SELECT @v_dSql2 += '                            , A.PLAN_DATE                  ' + char(10)
			SELECT @v_dSql2 += '                            , A.IN_QTY*ISNULL(B.CHILD_QTY, ISNULL(C.CHILD_QTY, D.CHILD_QTY))/ISNULL(B.PARENT_QTY, ISNULL(C.PARENT_QTY, D.PARENT_QTY)) AS PC_QTY ' + char(10)
            
			IF(@p_release_flag = 'Y' OR @p_plan_type = 'RELEASE' )
                BEGIN
                    SELECT @v_dSql2 += '                  		FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK) ' + char(10)
                END
            ELSE
                BEGIN
                    SELECT @v_dSql2 += '                  		FROM   FP_AMEND_PLAN_CELL_R A WITH(NOLOCK) ' + char(10)
                END

			SELECT @v_dSql2 += '                        LEFT OUTER JOIN #SCM_BOM B WITH(NOLOCK)        ' + char(10)
			SELECT @v_dSql2 += '                        ON   1=1                                      ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.COMPANY_ID     = B.COMPANY_ID          ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.DIVISION_ID    = B.DIVISION_ID         ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.SITE_ID        = B.SITE_ID             ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.ITEM_ID        = B.PARENT_ITEM_ID      ' + char(10)
			SELECT @v_dSql2 += '                        AND  B.EFF_START_DATE <= ' + @v_plan_date + ' ' + char(10)
			SELECT @v_dSql2 += '                        AND  B.EFF_END_DATE    > ' + @v_plan_date + ' ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.FACTORY_ID = B.ASSY_FACTORY_ID         ' + char(10)
			SELECT @v_dSql2 += '                        AND  CONVERT(VARCHAR(6),A.PLAN_DATE,112) = B.MONTH ' + char(10)
			SELECT @v_dSql2 += '                        LEFT OUTER JOIN #SCM_BOM C WITH(NOLOCK)         ' + char(10)
			SELECT @v_dSql2 += '                        ON   1=1                                       ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.COMPANY_ID     = C.COMPANY_ID           ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.DIVISION_ID    = C.DIVISION_ID          ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.SITE_ID        = C.SITE_ID              ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.ITEM_ID        = C.PARENT_ITEM_ID       ' + char(10)
			SELECT @v_dSql2 += '                        AND  C.EFF_START_DATE <= ' + @v_plan_date + '  ' + char(10)
			SELECT @v_dSql2 += '                        AND  C.EFF_END_DATE    > ' + @v_plan_date + '  ' + char(10)
			SELECT @v_dSql2 += '                        AND  C.ASSY_FACTORY_ID IS NULL                 ' + char(10)
			SELECT @v_dSql2 += '                        AND  C.MONTH IS NULL                           ' + char(10)
			SELECT @v_dSql2 += '                        LEFT OUTER JOIN SCM_BOM_M D WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql2 += '                        ON  1=1                                        ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.COMPANY_ID     = D.COMPANY_ID                ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.DIVISION_ID    = D.DIVISION_ID               ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.SITE_ID        = D.SITE_ID                   ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.ITEM_ID        = D.PARENT_ITEM_ID            ' + char(10)
			SELECT @v_dSql2 += '                        AND  D.EFF_START_DATE <= ' + @v_plan_date + '       ' + char(10)
			SELECT @v_dSql2 += '                        AND  D.EFF_END_DATE    > ' + @v_plan_date + '       ' + char(10)
			SELECT @v_dSql2 += '                        AND  (D.ALT_PRIORITY IS NULL OR D.ALT_PRIORITY = 1) ' + char(10)
			SELECT @v_dSql2 += '                        WHERE  1=1                                          ' + char(10)
			SELECT @v_dSql2 += '                        AND  EXISTS (                                       ' + char(10)
			SELECT @v_dSql2 += '                        		SELECT 1                                    ' + char(10)
			SELECT @v_dSql2 += '                        		FROM   #ASSY_PLAN CC                         ' + char(10)
			SELECT @v_dSql2 += '                        		WHERE  A.INSTANCE_ID = CC.INSTANCE_ID       ' + char(10)
			SELECT @v_dSql2 += '                        		AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID   ' + char(10)
			SELECT @v_dSql2 += '                               )                                            ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.OPERATION_ID IN (''A2000'',''A5000'')        ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.PLAN_DATE BETWEEN CONVERT(DATETIME, ' + @v_bucket_from + ') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
			SELECT @v_dSql2 += '                        AND  A.IN_QTY > 0 ' + char(10)
			SELECT @v_dSql2 += '                    ) A                   ' + char(10)
			SELECT @v_dSql2 += '                    WHERE 1=1             ' + char(10)
			SELECT @v_dSql2 += '                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CHILD_ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112), A.PLANT_ID, A.ITEM_ID, A.TOP_ITEM_ID ' + char(10)
            
			SELECT @v_dSql3  = ''
			SELECT @v_dSql3 += '                    UNION ALL ' + char(10)
			SELECT @v_dSql3 += '                    -- Coater ' + char(10)
			SELECT @v_dSql3 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE ' + char(10)
			SELECT @v_dSql3 += '                        , SUM(ROUND(ISNULL(A.ADJUST_OUT_QTY,0),0)) AS COATER_QTY      ' + char(10)
			SELECT @v_dSql3 += '                        , SUM( ROUND(ISNULL(A.ADJUST_OUT_QTY,0),0) * ISNULL(B.Y3,1) * ISNULL(B.Y4,1) ) AS POST_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , 0 AS ASSY_QTY, 0 AS SHIP_QTY, 0 AS SHIP_IN_QTY, 0 AS BOH_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID   ' + char(10)
			SELECT @v_dSql3 += '                    FROM  FP_AMEND_DAILY_PLAN_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                    LEFT OUTER JOIN #OPERATION_YIELD B ' + char(10)
			SELECT @v_dSql3 += '                    ON 	1=1                           ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.SITE_ID     = B.SITE_ID     ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.PLANT_ID    = B.PLANT_ID    ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.FACTORY_ID  = B.FACTORY_ID  ' + char(10)
			SELECT @v_dSql3 += '                    AND	A.ITEM_ID     = B.ITEM_ID     ' + char(10)
			SELECT @v_dSql3 += '                    AND	CONVERT(VARCHAR(6),A.PLAN_DATE,112)  = B.MONTH ' + char(10)
			SELECT @v_dSql3 += '                    WHERE  1=1     ' + char(10)
			SELECT @v_dSql3 += '                    AND  EXISTS (  ' + char(10)
			SELECT @v_dSql3 += '                          SELECT 1 ' + char(10)
			SELECT @v_dSql3 += '                          FROM   #COATER_PLAN CC                     ' + char(10)
			SELECT @v_dSql3 += '                          WHERE  A.INSTANCE_ID = CC.INSTANCE_ID     ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.FP_PLAN_ID  = CC.RELEASE_PLAN_ID ' + char(10)
			SELECT @v_dSql3 += '                    )                               ' + char(10)
			SELECT @v_dSql3 += '                    AND  A.OPERATION_ID = ''E2000'' ' + char(10)
			SELECT @v_dSql3 += '                    AND  A.PLAN_DATE BETWEEN CONVERT(DATETIME, ' + @v_bucket_from + ') AND CONVERT(DATETIME, ' + @v_bucket_to + ') ' + char(10)
			SELECT @v_dSql3 += '                    AND  A.ADJUST_OUT_QTY > 0                                                                    ' + char(10)
			SELECT @v_dSql3 += '                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.PLAN_DATE,112) ' + char(10)
			SELECT @v_dSql3 += '                    -- Shipment - 계획구간 ' + char(10)
			SELECT @v_dSql3 += '                    UNION ALL              ' + char(10)
			SELECT @v_dSql3 += '                    -- SSP Shipping Plan 으로 변경... 20200722 ' + char(10)
			SELECT @v_dSql3 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.SHIP_DATE,112) AS PLAN_DATE      ' + char(10)
			SELECT @v_dSql3 += '                        , 0 AS COATER_QTY, 0 AS POST_QTY, 0 AS ASSY_QTY, ISNULL(SUM(A.SHIP_QTY),0) AS SHIP_QTY, 0 AS SHIP_IN_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , 0 AS BOH_QTY, NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID                               ' + char(10)

			SELECT @v_dSql3 += '                    FROM   #INSTANCE_INFO AS B                ' + char(10)
			SELECT @v_dSql3 += '                    INNER JOIN FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			--SELECT @v_dSql3 += '                    FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)                ' + char(10)
			--SELECT @v_dSql3 += '                    INNER JOIN (                                                     ' + char(10)
			--SELECT @v_dSql3 += '                          SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID ' + char(10)
			--SELECT @v_dSql3 += '                          FROM   FP_INSTANCE_INFO_V A WITH(NOLOCK)                   ' + char(10)
			--SELECT @v_dSql3 += '                          WHERE  A.INSTANCE_ID = (SELECT TO_INSTANCE_ID FROM PANCAKE_INSTANCE) ' + char(10)
			--SELECT @v_dSql3 += '                    ) B                               ' + char(10)
			
			SELECT @v_dSql3 += '                    ON  A.COMPANY_ID  = B.COMPANY_ID  ' + char(10)
			SELECT @v_dSql3 += '                    AND A.DIVISION_ID = B.DIVISION_ID ' + char(10)
			SELECT @v_dSql3 += '                    AND A.SITE_ID     = B.SITE_ID     ' + char(10)
			SELECT @v_dSql3 += '                    AND A.PLANT_ID    = B.PLANT_ID    ' + char(10)
			SELECT @v_dSql3 += '                    INNER JOIN #SHIPMENT_INFO  C            ' + char(10)
			SELECT @v_dSql3 += '                    ON  A.DIVISION_ID    = C.DIVISION_ID   ' + char(10)
			SELECT @v_dSql3 += '                    AND A.SITE_ID	     = C.SITE_ID       ' + char(10)
			SELECT @v_dSql3 += '                    AND A.PLANT_ID	     = C.PLANT_ID      ' + char(10)
			SELECT @v_dSql3 += '                    AND A.SHOP_GROUP_ID	 = C.SHOP_GROUP_ID ' + char(10)
			SELECT @v_dSql3 += '                    AND A.SCP_PLAN_ID    = C.SCP_PLAN_ID   ' + char(10)
 			SELECT @v_dSql3 += '                    WHERE CONVERT(VARCHAR,A.SHIP_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql3 += '                    GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.SHIP_DATE,112)   ' + char(10)
			SELECT @v_dSql3 += '                    -- Shipment - 과거구간 ' + char(10)
			SELECT @v_dSql3 += '                    UNION ALL              ' + char(10)
			SELECT @v_dSql3 += '                    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.SHIP_DATE AS PLAN_DATE, 0 AS COATER_QTY, 0 AS POST_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , 0 AS ASSY_QTY, ISNULL(A.QTY,0) AS SHIP_QTY, 0 AS SHIP_IN_QTY, 0 AS BOH_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql3 += '                    FROM (                                    ' + char(10)
			SELECT @v_dSql3 += '                          SELECT V.INSTANCE_ID AS INSTANCE_ID ' + char(10)
			SELECT @v_dSql3 += '                             ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_DATE, SUM(QTY) AS QTY ' + char(10)
			SELECT @v_dSql3 += '                          FROM  SCM_SHIPPING_RESULT_H A WITH(NOLOCK)           ' + char(10)
			SELECT @v_dSql3 += '                          INNER HASH JOIN FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                          ON   1=1                                             ' + char(10)
			SELECT @v_dSql3 += '                          AND  V.INSTANCE_ID  = (SELECT TO_INSTANCE_ID FROM #PANCAKE_INSTANCE) ' + char(10)
			SELECT @v_dSql3 += '                          AND  V.GUBUN        = ''ASSY''      ' + char(10)
			SELECT @v_dSql3 += '                          AND  V.ACTIVE_FLAG  = ''Y''         ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.COMPANY_ID   = V.COMPANY_ID  ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.DIVISION_ID  = V.DIVISION_ID ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.SITE_ID        = V.SITE_ID   ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.PLANT_ID       = V.PLANT_ID  ' + char(10)
			SELECT @v_dSql3 += '                         , SCM_ITEM_M B WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql3 += '                         , SCM_ITEM_CLASS_M C WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql3 += '                          WHERE 1=1                           ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.COMPANY_ID = B.COMPANY_ID    ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.SITE_ID = B.SITE_ID          ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.DIVISION_ID = B.DIVISION_ID  ' + char(10)
			--SELECT @v_dSql3 += '                          AND  A.PLANT_ID NOT IN (''3050'')   ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.PLANT_ID NOT in (SELECT SEGMENT2 FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE=''PR_UI_FP00626_PANCAKESIMULATION_ASSY'' AND SEGMENT1  = ''0'' AND ACTIVE_FLAG = ''Y'')   ' + char(10)

			SELECT @v_dSql3 += '                          AND  A.ITEM_ID      = B.ITEM_ID     ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.SHIP_DATE    <= ' + @v_plan_date + '   ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.SHIP_DATE    >= ' + @v_bucket_from + ' ' + char(10)
			SELECT @v_dSql3 += '                          AND  B.ACTIVE_FLAG  = ''Y''          ' + char(10)
			SELECT @v_dSql3 += '                          AND  B.ITEM_CLASS   = C.CLASS_ID     ' + char(10)
			SELECT @v_dSql3 += '                          AND  C.LEVEL_2_NAME = ''Pancake''    ' + char(10)
			SELECT @v_dSql3 += '                          GROUP BY V.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.SHIP_DATE ' + char(10)
			SELECT @v_dSql3 += '                    ) A                                          ' + char(10)
			SELECT @v_dSql3 += '                    WHERE  A.INSTANCE_ID =' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql3 += '                    -- Receipt Plan -- ' + char(10)
			SELECT @v_dSql3 += '                    UNION ALL          ' + char(10)
			SELECT @v_dSql3 += '                    SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ETA_DATE AS PLAN_DATE, 0 AS COATER_QTY, 0 AS POST_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , 0 AS ASSY_QTY, 0 AS SHIP_QTY, ISNULL(A.QTY,0) AS SHIP_IN_QTY, 0 AS BOH_QTY ' + char(10)
			SELECT @v_dSql3 += '                        , NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID                 ' + char(10)
			SELECT @v_dSql3 += '                    FROM (        ' + char(10)
			SELECT @v_dSql3 += '                          SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) AS ETA_DATE, SUM(A.QTY) AS QTY ' + char(10)
			SELECT @v_dSql3 += '                          FROM  ( ' + char(10)
			SELECT @v_dSql3 += '                          SELECT ' + @v_instance_id + ' AS INSTANCE_ID ' + char(10)
			SELECT @v_dSql3 += '                              ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql3 += '                              ,CASE WHEN ISNULL(A.ETA_DATE,'''') < ' + @v_plan_date + ' THEN ' + @v_plan_date + ' ELSE ISNULL(A.ETA_DATE,'''') END AS ETA_DATE ' + char(10)
			SELECT @v_dSql3 += '                              ,A.INTRANSIT_QTY AS QTY              ' + char(10)
			SELECT @v_dSql3 += '                          FROM 	FP_MRP_INTRANSIT_H A WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql3 += '                          INNER HASH JOIN FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                          ON 1=1 ' + char(10)
			SELECT @v_dSql3 += '                          AND	V.INSTANCE_ID  = (SELECT TO_INSTANCE_ID FROM #PANCAKE_INSTANCE) ' + char(10)
			SELECT @v_dSql3 += '                          AND	V.GUBUN        = ''RECEIPT''   ' + char(10)
			SELECT @v_dSql3 += '                          AND	V.ACTIVE_FLAG  = ''Y''         ' + char(10)
			SELECT @v_dSql3 += '                          AND	A.COMPANY_ID   = V.COMPANY_ID  ' + char(10)
			SELECT @v_dSql3 += '                          AND	A.DIVISION_ID  = V.DIVISION_ID ' + char(10)
			SELECT @v_dSql3 += '                          AND   A.SITE_ID	   = V.SITE_ID     ' + char(10)
			SELECT @v_dSql3 += '                          WHERE 1=1                            ' + char(10)
			SELECT @v_dSql3 += '                          AND   A.ITEM_ID LIKE ''APC%''        ' + char(10)
			SELECT @v_dSql3 += '                          UNION ALL                            ' + char(10)
			SELECT @v_dSql3 += '                          --= Shipment_In List: 미래의 선적계획' + char(10)
			SELECT @v_dSql3 += '                          SELECT ' + @v_instance_id + ' AS INSTANCE_ID, V.COMPANY_ID, V.DIVISION_ID, A.TO_SITE_ID AS SITE_ID, V.PLANT_ID ' + char(10)
			SELECT @v_dSql3 += '                               , A.ITEM_ID, A.RECEIVE_YYYYMMDD AS ETA_DATE, A.SHIP_QTY AS QTY ' + char(10)
			SELECT @v_dSql3 += '                          FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                          INNER JOIN #INS_PLANT V                   ' + char(10)
			SELECT @v_dSql3 += '                          ON  1=1                                  ' + char(10)
			SELECT @v_dSql3 += '                          AND A.TO_SITE_ID  = V.SITE_ID            ' + char(10)
			SELECT @v_dSql3 += '                          AND A.TO_PLANT_ID = V.ASSY_PLANT_ID      ' + char(10)
			SELECT @v_dSql3 += '                          INNER JOIN #SHIPMENT_INFO  C              ' + char(10)
			SELECT @v_dSql3 += '                          ON  1=1                                  ' + char(10)                 
			SELECT @v_dSql3 += '                          AND  A.DIVISION_ID   = C.DIVISION_ID     ' + char(10)      
			SELECT @v_dSql3 += '                          AND  A.SITE_ID        = C.SITE_ID        ' + char(10) 
			SELECT @v_dSql3 += '                          AND  A.PLANT_ID       = C.PLANT_ID       ' + char(10) 
			SELECT @v_dSql3 += '                          AND  A.SHOP_GROUP_ID  = C.SHOP_GROUP_ID  ' + char(10)  
			SELECT @v_dSql3 += '                          AND  A.SCP_PLAN_ID    = C.SCP_PLAN_ID    ' + char(10)
			SELECT @v_dSql3 += '                          WHERE	1=1                                ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.PLANT_ID <> A.TO_PLANT_ID	-- 같은건 to 가 외주로 가기 때문에 제외한다. ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.SHIP_QTY > 0        ' + char(10)
			SELECT @v_dSql3 += '                          AND  A.RECEIVE_YYYYMMDD >= ' + @v_plan_date + '   ---+ 미래의 선적계획만 가져온다. ' + char(10)
			SELECT @v_dSql3 += '                          UNION ALL                              ' + char(10)
			SELECT @v_dSql3 += '                          -- SCP INTRANSIT 정보 추가... 20200722 ' + char(10)
			SELECT @v_dSql3 += '                          SELECT ' + @v_instance_id + ' AS INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, V.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql3 += '                              , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, ' + @v_plan_date + ',112) THEN CONVERT(VARCHAR, ' + @v_plan_date + ',112) ELSE A.ETA_DATE END ETA_DATE --+ 만약 도착일자가 과거면 오늘날짜로 강제보정 ' + char(10)
			SELECT @v_dSql3 += '                              , DELIVERY_QTY AS QTY                 ' + char(10)
			SELECT @v_dSql3 += '                          FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql3 += '                               , SCM_ITEM_M B WITH(NOLOCK)          ' + char(10)
			SELECT @v_dSql3 += '                               , SCM_ITEM_CLASS_M C WITH(NOLOCK)    ' + char(10)
			SELECT @v_dSql3 += '                               , #INS_PLANT V                        ' + char(10)
			SELECT @v_dSql3 += '                          WHERE  A.DELIVERY_QTY > 0                 ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, ' + @v_plan_date + ') ),112)  --> D-1일로 조회해야 함. ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.COMPANY_ID   = B.COMPANY_ID    ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.DIVISION_ID  = B.DIVISION_ID   ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.SITE_ID      = B.SITE_ID       ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.ITEM_ID      = B.ITEM_ID       ' + char(10)
			SELECT @v_dSql3 += '                          AND    B.ACTIVE_FLAG  = ''Y''           ' + char(10)
			SELECT @v_dSql3 += '                          AND    B.ITEM_CLASS   = C.CLASS_ID      ' + char(10)
			SELECT @v_dSql3 += '                          AND    C.LEVEL_2_NAME = ''Pancake''     ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.COMPANY_ID   = V.COMPANY_ID    ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.SITE_ID      = V.SITE_ID       ' + char(10)
			SELECT @v_dSql3 += '                          AND    A.PLANT_ID     = V.ASSY_PLANT_ID ' + char(10)
			SELECT @v_dSql3 += '                       ) A                                        ' + char(10)
			SELECT @v_dSql3 += '                    WHERE 1=1                                     ' + char(10)
			SELECT @v_dSql3 += '                    GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) ' + char(10)
			SELECT @v_dSql3 += '                ) A                                           ' + char(10)
			SELECT @v_dSql3 += '                WHERE  A.INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql3 += '             ) A                                              ' + char(10)
            
			SELECT @v_dSql4  = ''
			SELECT @v_dSql4 += '             INNER JOIN (   ' + char(10)
			SELECT @v_dSql4 += '                   SELECT * ' + char(10)
			SELECT @v_dSql4 += '                   FROM (   ' + char(10)
			SELECT @v_dSql4 += '                         SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER                              ' + char(10)
			SELECT @v_dSql4 += '                         UNION ALL  ' + char(10)																              
			SELECT @v_dSql4 += '                         SELECT ''ASSY'' AS CATEGORY_ID, ''Assy Plan(Notching)'' AS CATEGORY_NAME, 10 AS CATEGORY_ORDER       ' + char(10)
			SELECT @v_dSql4 += '                         UNION ALL  ' + char(10)																		      
			SELECT @v_dSql4 += '                         SELECT ''POST'' AS CATEGORY_ID, ''Coater Plan + Post Yield'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER  ' + char(10)
			SELECT @v_dSql4 += '                         UNION ALL  ' + char(10)
			SELECT @v_dSql4 += '                         SELECT ''COATER'' AS CATEGORY_ID, ''Coater Plan'' AS CATEGORY_NAME, 30 AS CATEGORY_ORDER             ' + char(10)
			SELECT @v_dSql4 += '                         UNION ALL  ' + char(10)																			  
			SELECT @v_dSql4 += '                         SELECT ''SHIP'' AS CATEGORY_ID, ''Shipment Plan(Out)'' AS CATEGORY_NAME, 40 AS CATEGORY_ORDER        ' + char(10)
			SELECT @v_dSql4 += '                         UNION ALL  ' + char(10)
			SELECT @v_dSql4 += '                         SELECT ''SHIP_IN'' AS CATEGORY_ID, ''Receipt(Plan+Intransit)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER' + char(10)
			SELECT @v_dSql4 += '                   ) BB                       ' + char(10)
			SELECT @v_dSql4 += '                   WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql4 += '             ) B                              ' + char(10)
			SELECT @v_dSql4 += '             ON 1=1                           ' + char(10)
			SELECT @v_dSql4 += '             INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '             ON  A.PLAN_DATE = C.YYYYMMDD              ' + char(10)
			SELECT @v_dSql4 += '             INNER HASH JOIN SCM_ITEM_M E WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '             ON  A.DIVISION_ID = E.DIVISION_ID         ' + char(10)
			SELECT @v_dSql4 += '             AND A.SITE_ID	  = E.SITE_ID              ' + char(10)
			SELECT @v_dSql4 += '             AND A.ITEM_ID	  = E.ITEM_ID              ' + char(10)
			SELECT @v_dSql4 += '             AND E.COMPANY_ID = (SELECT DISTINCT COMPANY_ID FROM FP_INSTANCE_OPERATION_V WHERE INSTANCE_ID = ' + @v_instance_id + ') ' + char(10)
			SELECT @v_dSql4 += '             AND E.ACTIVE_FLAG = ''Y'' ' + char(10)
			SELECT @v_dSql4 += '             WHERE 1=1                 ' + char(10)
			
			IF(Len(@p_item_id) > 0)
			    BEGIN
			        SELECT @v_dSql4 += '             AND   A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id + ')) + ''%'' ' + char(10)
				END
			IF(Len(@p_nick_name) > 0)
			    BEGIN
			        SELECT @v_dSql4 += '             AND   E.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_nick_name + ')) + ''%'' ' + char(10)
				END

			SELECT @v_dSql4 += '             GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, ISNULL(E.NICK_NAME,''-''), ISNULL(E.APPLIED_MODEL, A.ITEM_ID), E.ITEM_TYPE, E.ITEM_CLASS ' + char(10)
			SELECT @v_dSql4 += '               , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)
			--SELECT @v_dSql4 += '        )                                 ' + char(10)
			SELECT @v_dSql4 += '        option (force order)                ' + char(10)
			
if object_id('tempdb..#MAIN_SUB') is not null
	drop table #MAIN_SUB			
			
			--SELECT @v_dSql4 += '    , MAIN_SUB AS (                       ' + char(10)
			SELECT @v_dSql4 += '          SELECT A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql4 += '              , A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql4 += '              , A.PLANT_ID    ' + char(10)
			SELECT @v_dSql4 += '              , A.TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '              , A.NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '              , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)

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
						      SET @mst_loop_cnt     =  @mst_loop_cnt +1
                              SET @tmp_column       = ''
                              SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_month_info,@v_delimiter, @mst_loop_cnt)
                              SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                              
                              SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => YYYYMM AS MONTH
                              SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => 'Jan' AS MONTH_NAME
                              SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 =>  COUNT(*) AS MONTH_COUNT
                              --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => 'M0~M12' AS M-VALUE

							  SET @v_Tmp1 += '                , SUM(CASE WHEN A.YYYYMM = ''' + @sub_param_0 + ''' THEN 0 ELSE 0 END) AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
        				  END
        	  
        			  -- weekinfo
        			  SET @mst_loop_cnt = 0	
        			  SET @max_loop_cnt = 0
        			  SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
					  SET @v_Tmp2       = ''
        			  WHILE @mst_loop_cnt < @max_loop_cnt
        				  BEGIN
        	      			  SET @mst_loop_cnt     =  @mst_loop_cnt +1
                              SET @tmp_column       = ''
                              SET @tmp_column       = [dbo].[SCM_ARR_SPL_VAL]( @p_week_info,@v_delimiter, @mst_loop_cnt)
                              SET @sub_max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@tmp_column, @sub_v_delimiter)
                              
                              SET @sub_param_0 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1)   -- @sub_param_0 => ISO_YYYYWW AS WEEK
                              SET @sub_param_1 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 2)   -- @sub_param_1 => 'W'  AS WEEK_NAME
                              SET @sub_param_2 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 3)   -- @sub_param_2 =>  COUNT(*) AS WEEK_COUNT
                              --SET @sub_param_3 =  [dbo].[SCM_ARR_SPL_VAL_ENTITY]( @tmp_column,@sub_v_delimiter, 1) -- @sub_param_3 => 'W0~W1' AS W_VALUE

							  SET @v_Tmp2 += '                , SUM(CASE WHEN A.ISO_YYYYWW = ''' + @sub_param_0 + ''' THEN 0 ELSE 0 END) AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)				
        				  END
        	  
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

							  SET @v_Tmp3 += '                , SUM(CASE WHEN A.PLAN_DATE = ''' + @sub_param_2 + ''' THEN A.BOH_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
        				  END
				END 
			END

			SELECT @v_dSql4 +=  @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql4 += '              , ''DATA'' AS DATA_TYPE ' + char(10)

			SELECT @v_dSql4 += '          into #MAIN_SUB ' + char(10)	
			SELECT @v_dSql4 += '          FROM ( ' + char(10)	
			SELECT @v_dSql4 += '                SELECT A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql4 += '                		, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, C.YYYYMM, C.ISO_YYYYWW, CONVERT(VARCHAR, DATEADD(DD, -1, C.YYYYMMDD) ,112) AS PLAN_DATE, MAX(B.BOH_QTY) AS BOH_QTY ' + char(10)
			SELECT @v_dSql4 += '                FROM  (            ' + char(10)
			SELECT @v_dSql4 += '                       SELECT A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '                       FROM	#MAIN A ' + char(10)
			SELECT @v_dSql4 += '                       GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS, A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '                ) A                                  ' + char(10)
			SELECT @v_dSql4 += '                INNER JOIN TH_UIS_CAL C WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql4 += '                ON  C.YYYYMMDD BETWEEN ' + @v_bucket_from + ' AND ' + @v_plan_date + ' ' + char(10)
			SELECT @v_dSql4 += '                LEFT OUTER HASH JOIN (  ' + char(10)
			SELECT @v_dSql4 += '                      -- 과거 Inventory ' + char(10)
			SELECT @v_dSql4 += '                      SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.CUTOFF_DATE AS PLAN_DATE, SUM(A.BOH_QTY) AS BOH_QTY ' + char(10)
			SELECT @v_dSql4 += '                      FROM	#STOCK_T A ' + char(10)
			SELECT @v_dSql4 += '                      WHERE 	1=1   ' + char(10)
			SELECT @v_dSql4 += '                      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.CUTOFF_DATE ' + char(10)
			SELECT @v_dSql4 += '                ) B    ' + char(10)
			SELECT @v_dSql4 += '                ON 1=1 ' + char(10)
			SELECT @v_dSql4 += '                AND	A.DIVISION_ID	= B.DIVISION_ID ' + char(10)
			SELECT @v_dSql4 += '                AND	A.SITE_ID		= B.SITE_ID     ' + char(10)
			SELECT @v_dSql4 += '                AND	A.ITEM_ID		= B.ITEM_ID     ' + char(10)
			SELECT @v_dSql4 += '                AND	C.YYYYMMDD		= B.PLAN_DATE   ' + char(10)
			SELECT @v_dSql4 += '                GROUP BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql4 += '                    , A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID, C.YYYYMM, C.ISO_YYYYWW, CONVERT(VARCHAR, DATEADD(DD, -1, C.YYYYMMDD) ,112) ' + char(10)
			SELECT @v_dSql4 += '          ) A                  ' + char(10)
			SELECT @v_dSql4 += '          INNER JOIN (         ' + char(10)
			SELECT @v_dSql4 += '                      SELECT * ' + char(10)
			SELECT @v_dSql4 += '                      FROM (   ' + char(10)
			SELECT @v_dSql4 += '                            SELECT ''X'' AS CATEGORY_ID, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += '                            UNION ALL  ' + char(10)
			SELECT @v_dSql4 += '                            SELECT ''INV'' AS CATEGORY_ID, ''Inventory'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql4 += '                      ) BB                       ' + char(10)
			SELECT @v_dSql4 += '                      WHERE CATEGORY_ID <> ''X'' ' + char(10)
			SELECT @v_dSql4 += '          ) B                                    ' + char(10)
			SELECT @v_dSql4 += '          ON 1=1                                 ' + char(10)
			SELECT @v_dSql4 += '          GROUP BY 	A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME, A.MODEL_T, A.ITEM_TYPE, A.ITEM_CLASS ' + char(10)
			SELECT @v_dSql4 += '              , A.PLANT_ID, A.TOP_ITEM_ID, A.NPC_ITEM_ID         ' + char(10)
			SELECT @v_dSql4 += '              , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)
			--SELECT @v_dSql4 += '    )                                         ' + char(10)
			
if object_id('tempdb..#ACCU_T') is not null
	drop table #ACCU_T			
			
			
			--SELECT @v_dSql4 += '    , ACCU_T AS (                             ' + char(10)
			SELECT @v_dSql4 += '          SELECT  A.MODEL_ID, A.CHILD_ITEM_ID ' + char(10)

			IF ISNULL(@p_day_info,'') <> ''
				BEGIN
				SET @mst_loop_cnt     = 0
				SET @v_delimiter      = '!'  -- 데이터 구분자
				SET @sub_v_delimiter  = '#'
				SET @max_loop_cnt     = [dbo].[SCM_ARR_SPL_CNT](@p_day_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단    
        
				IF @max_loop_cnt > 0 
				    BEGIN
			            SELECT @v_dSql4 += '              , MAX(CASE WHEN A.YYYYMMDD = ' + @v_plan_date + ' THEN A.ACCU_QTY ELSE 0 END) AS DD ' + char(10)
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
                                
                                SET @v_Tmp3 += '              , MAX(CASE WHEN A.YYYYMMDD = ''' + @sub_param_2 +''' THEN A.ACCU_QTY ELSE 0 END) AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
                            END
				    END 
			END

			SELECT @v_dSql4 += @v_Tmp3

			SELECT @v_dSql4 += '          into #ACCU_T ' + char(10)
			SELECT @v_dSql4 += '          FROM ( ' + char(10)
			SELECT @v_dSql4 += '                 SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.CHILD_ITEM_ID, A.YYYYMMDD, SUM(ACCU_QTY) AS ACCU_QTY ' + char(10)
			SELECT @v_dSql4 += '                 FROM (                       ' + char(10)
			SELECT @v_dSql4 += '                       SELECT A.*, C.YYYYMMDD ' + char(10)
			SELECT @v_dSql4 += '                           , CASE WHEN  YYYYMMDD <= START_DATE AND  YYYYMMDD > END_DATE THEN 0 ELSE ACCUMULATED_CHILD_QTY END AS ACCU_QTY ' + char(10)
			SELECT @v_dSql4 += '                       FROM  ( ' + char(10)
			SELECT @v_dSql4 += '                              SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.CHILD_ITEM_ID ' + char(10)
			SELECT @v_dSql4 += '                              		 , CONVERT(VARCHAR,A.EFF_START_DATE,112) AS START_DATE, CONVERT(VARCHAR,A.EFF_END_DATE,112) AS END_DATE ' + char(10)
			SELECT @v_dSql4 += '                              		 , A.ACCUMULATED_CHILD_QTY                    ' + char(10)
			SELECT @v_dSql4 += '                              FROM  SCM_MODEL_COMP_EFFECTIVE_DATE A WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '                              WHERE 1=1                                           ' + char(10)
			SELECT @v_dSql4 += '                              AND 	A.DIVISION_ID IN (SELECT DIVISION_ID FROM #INSTANCE_T)     ' + char(10)
			SELECT @v_dSql4 += '                              AND   A.CHILD_ITEM_ID   LIKE ''APC%''                           ' + char(10)
			SELECT @v_dSql4 += '                              AND   A.EFF_START_DATE <= CONVERT(DATE, ' + @v_bucket_from + ') ' + char(10)
			SELECT @v_dSql4 += '                              AND   A.EFF_END_DATE    > CONVERT(DATE, ' + @v_bucket_from + ') ' + char(10)
			SELECT @v_dSql4 += '                       ) A                                   ' + char(10)
			SELECT @v_dSql4 += '                       INNER JOIN TH_UIS_CAL C WITH(NOLOCK)  ' + char(10)
			SELECT @v_dSql4 += '                       ON  C.YYYYMMDD BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' ' + char(10)
			SELECT @v_dSql4 += '                 ) A       ' + char(10)
			SELECT @v_dSql4 += '                 WHERE 1=1 ' + char(10)
			SELECT @v_dSql4 += '                 GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.MODEL_ID, A.CHILD_ITEM_ID, A.YYYYMMDD ' + char(10)
			SELECT @v_dSql4 += '             ) A                                  ' + char(10)
			SELECT @v_dSql4 += '             where 1=0 -- 사용안함                ' + char(10)
			SELECT @v_dSql4 += '             GROUP BY A.MODEL_ID, A.CHILD_ITEM_ID ' + char(10)
			--SELECT @v_dSql4 += '	     )                                        ' + char(10)

if object_id('tempdb..#MAIN_T') is not null
	drop table #MAIN_T



			--SELECT @v_dSql4 += '    , MAIN_T AS (                                 ' + char(10)
			SELECT @v_dSql4 += '        SELECT 	 A.DIVISION_ID, A.SITE_ID         ' + char(10)
			SELECT @v_dSql4 += '            , A.ITEM_ID, A.NICK_NAME, A.ITEM_TYPE ' + char(10)
			SELECT @v_dSql4 += '            , A.MODEL, A.TOP_ITEM_ID              ' + char(10)
			SELECT @v_dSql4 += '            , A.NPC_ITEM_ID, A.ITEM_CLASS         ' + char(10)
			SELECT @v_dSql4 += '            , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)

            IF(@p_uom_type = 'PANCAKE') 
			    BEGIN
			        SELECT @v_dSql4 += '            , 0 AS PREV_BOH_QTY                                   ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.POST_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS POST_BOH_QTY ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS BOH_QTY           ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.PC_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS PC_BOH_QTY     ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.JR_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS JR_BOH_QTY     ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS HOLD_QTY         ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.PC_HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS PC_HOLD_QTY   ' + char(10)
			        SELECT @v_dSql4 += '            , FLOOR( A.JR_HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS JR_HOLD_QTY   ' + char(10)
			        
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
                       		                SET @mst_loop_cnt     =  @mst_loop_cnt +1
                       		                SET @v_Tmp1 += '            , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                       		            END
                         	         
                       		        -- weekinfo
                       		        SET @mst_loop_cnt = 0	
                       		        SET @max_loop_cnt = 0
                       		        SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                       		        SET @v_Tmp2       = ''
                       		        WHILE @mst_loop_cnt < @max_loop_cnt
                       		            BEGIN
                                            SET @mst_loop_cnt     =  @mst_loop_cnt +1
                       		                SET @v_Tmp2 += '            , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)				
                       		            END
                         	        
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
                       		                
                       		                SET @v_Tmp3 += '            , CASE WHEN ''' + @sub_param_2 + ''' < '+ @v_plan_date +' AND CATEGORY_ID <> ''INV'' THEN 0 ELSE FLOOR( A.D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ) END / CONVERT(int, '+ @v_unit +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
                       		            END
			                    END 
                        END
			    END --IF END
            ELSE
			    BEGIN
			        SELECT @v_dSql4 += '            , 0 AS PREV_BOH_QTY ' + char(10)
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.POST_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.POST_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS POST_BOH_QTY ' + char(10)
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS BOH_QTY ' + char(10)        				
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.PC_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.PC_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS PC_BOH_QTY  ' + char(10)
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.JR_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.JR_BOH_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS JR_BOH_QTY  ' + char(10)
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS HOLD_QTY  ' + char(10)       				
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.PC_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.PC_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS PC_HOLD_QTY  ' + char(10)
			        SELECT @v_dSql4 += '            , ISNULL( FLOOR( A.JR_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ), FLOOR( A.JR_HOLD_QTY / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, ' + @v_plan_date + ' ) ) ) / CONVERT(int, '+ @v_unit +') AS JR_HOLD_QTY  ' + char(10)

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
                                            SET @mst_loop_cnt     =  @mst_loop_cnt +1
                                            SET @v_Tmp1 += '            , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
                                        END
                            
                                    -- weekinfo
                                    SET @mst_loop_cnt = 0	
                                    SET @max_loop_cnt = 0
                                    SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
                                    SET @v_Tmp2       = ''
                                    WHILE @mst_loop_cnt < @max_loop_cnt
                                        BEGIN
                                            SET @mst_loop_cnt     =  @mst_loop_cnt +1
                                            SET @v_Tmp2 += '            , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)				
                                        END
                            
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
                                            
                                            SET @v_Tmp3 += '            , CASE WHEN ''' + @sub_param_2 + ''' < '+ @v_plan_date +' AND CATEGORY_ID <> ''INV'' THEN 0  ' + char(10)
                                            SET @v_Tmp3 += '                   WHEN ''' + @sub_param_2 + ''' < '+ @v_plan_date +' THEN ISNULL( FLOOR( D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL_T,  A.ITEM_ID, '''+ @sub_param_2 +''' ) ), FLOOR( D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL_T,  A.ITEM_ID, '''+ @sub_param_2 +''' ) ) ) ' + char(10)
                                            SET @v_Tmp3 += '              ELSE ISNULL( FLOOR( D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' / dbo.FN_GET_REQ_QTY_MODEL( F.PLANT_ID, A.MODEL,  A.ITEM_ID, '''+ @sub_param_2 +''' ) ), FLOOR( D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' / dbo.FN_GET_REQ_QTY_MODEL( '''', A.MODEL,  A.ITEM_ID, '''+ @sub_param_2 +''' ) ) ) END / CONVERT(int, '+ @v_unit +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
                                        END
                                END 
                        END
			    END--ELSE END

			SELECT @v_dSql4 += @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5  = ''
			SELECT @v_dSql5 += '        , A.DATA_TYPE                          ' + char(10)
			SELECT @v_dSql5 += '        , B.LEVEL_3_NAME AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql5 += '        , (CASE WHEN D.LEVEL_4_NAME = ''-'' THEN D.LEVEL_2_NAME ELSE D.LEVEL_4_NAME END) AS MODEL_CLASS_NAME ' + char(10)
			SELECT @v_dSql5 += '        , ISNULL(C.NICK_NAME,''-'') AS MODEL_NICK_NAME ' + char(10)
			SELECT @v_dSql5 += '        , C.ITEM_CLASS AS MODEL_CLASS                  ' + char(10)
			SELECT @v_dSql5 += '        , CASE WHEN ISNULL(A.LT,1) = 0 THEN 1 ELSE ISNULL(A.LT,1) END AS LT ' + char(10)
			SELECT @v_dSql5 += '    into #MAIN_T                                            ' + char(10)
			SELECT @v_dSql5 += '    FROM (                                                  ' + char(10)
			SELECT @v_dSql5 += '            SELECT  A.*                                     ' + char(10)
			SELECT @v_dSql5 += '                , ISNULL(A.TOP_ITEM_ID, A.MODEL_T) AS MODEL ' + char(10)
			SELECT @v_dSql5 += '                , ISNULL(D.BOH_QTY,0) AS BOH_QTY, ISNULL(D.PREV_BOH_QTY,0) AS PREV_BOH_QTY, ISNULL(D.PC_BOH_QTY,0) AS PC_BOH_QTY, ISNULL(D.JR_BOH_QTY,0) AS JR_BOH_QTY       ' + char(10)
			SELECT @v_dSql5 += '                , ISNULL(D.HOLD_QTY,0) AS HOLD_QTY, ISNULL(D.PC_HOLD_QTY,0) AS PC_HOLD_QTY, ISNULL(D.JR_HOLD_QTY,0) AS JR_HOLD_QTY, ISNULL(D.POST_BOH_QTY,0) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                , CASE WHEN FLOOR( ( ISNULL(F.LT,0) + ISNULL( ISNULL(G.LT, E.LT) , 0 ) ) / 1440 ) < 1 THEN 0 ELSE FLOOR( ( ISNULL(F.LT,0) + ISNULL( ISNULL(G.LT, E.LT) , 0 ) ) / 1440 ) END AS LT ' + char(10)
			SELECT @v_dSql5 += '            FROM (                         ' + char(10)
			SELECT @v_dSql5 += '                  SELECT * FROM #MAIN A     ' + char(10)
			SELECT @v_dSql5 += '                  UNION                    ' + char(10)
			SELECT @v_dSql5 += '                  SELECT * FROM #MAIN_SUB A ' + char(10)
			SELECT @v_dSql5 += '            ) A                            ' + char(10)
			SELECT @v_dSql5 += '            LEFT OUTER HASH JOIN (         ' + char(10)
			SELECT @v_dSql5 += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '                      , 0 AS PREV_BOH_QTY                                  ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN BOH_QTY ELSE 0 END) AS BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN POST_BOH_QTY ELSE 0 END) AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN PC_BOH_QTY ELSE 0 END) AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN JR_BOH_QTY ELSE 0 END) AS JR_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN HOLD_QTY ELSE 0 END) AS HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN JR_HOLD_QTY ELSE 0 END) AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                      , SUM( CASE WHEN A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') THEN PC_HOLD_QTY ELSE 0 END) AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                  FROM ( ' + char(10)
			SELECT @v_dSql5 += '                         SELECT  A.INSTANCE_ID,	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '                             , CONVERT(VARCHAR,A.CUTOFF_DATE,112) AS CUTOFF_DATE ,	A.OPERATION_ID ' + char(10)
			SELECT @v_dSql5 += '                             , ISNULL(SUM(A.BOH_QTY),0) AS BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.OPERATION_ID = 2000 THEN  ISNULL(SUM(A.BOH_QTY),0) * ISNULL(C.Y3,1) * ISNULL(C.Y4,1) ' + char(10)
			SELECT @v_dSql5 += '                                    WHEN A.OPERATION_ID = 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) * ISNULL(C.Y4,1) ' + char(10)
			SELECT @v_dSql5 += '                                    ELSE ISNULL(SUM(A.BOH_QTY),0) END POST_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.OPERATION_ID <= 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) ELSE 0 END AS JR_BOH_QTY  ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.OPERATION_ID > 3000 THEN  ISNULL(SUM(A.BOH_QTY),0) ELSE 0 END AS PC_BOH_QTY ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.WIPHOLD_YN = ''Y'' THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.WIPHOLD_YN = ''Y'' AND A.OPERATION_ID <= 3000 THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS JR_HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                             , CASE WHEN A.WIPHOLD_YN = ''Y'' AND A.OPERATION_ID > 3000 THEN  ISNULL(SUM(A.HOLD_QTY),0) ELSE 0 END AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql5 += '                         FROM 	#STOCK_T A       ' + char(10)
			SELECT @v_dSql5 += '                         LEFT OUTER HASH JOIN ( ' + char(10)
			SELECT @v_dSql5 += '                               SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MONTH, MIN(Y3) AS Y3, MIN(Y4) AS Y4 ' + char(10)
			SELECT @v_dSql5 += '                               FROM   #OPERATION_YIELD ' + char(10)
			SELECT @v_dSql5 += '                               GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, MONTH ' + char(10)
			SELECT @v_dSql5 += '                               ) C ' + char(10)
			SELECT @v_dSql5 += '                         ON 1=1    ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.COMPANY_ID  = C.COMPANY_ID  ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.DIVISION_ID = C.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.SITE_ID     = C.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.PLANT_ID    = C.PLANT_ID    ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.ITEM_ID     = C.ITEM_ID     ' + char(10)
			SELECT @v_dSql5 += '                         AND  CONVERT(VARCHAR(6), A.CUTOFF_DATE, 112) = C.MONTH  ' + char(10)
			SELECT @v_dSql5 += '                         WHERE 1=1                                               ' + char(10)
			SELECT @v_dSql5 += '                         AND  A.CUTOFF_DATE = CONVERT(DATE,' + @v_plan_date + ') ' + char(10)
			SELECT @v_dSql5 += '                         GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, CONVERT(VARCHAR,A.CUTOFF_DATE,112),	A.OPERATION_ID, A.WIPHOLD_YN, C.Y3, C.Y4 ' + char(10)
			SELECT @v_dSql5 += '                  ) A       ' + char(10)
			SELECT @v_dSql5 += '                  WHERE 1=1 ' + char(10)
			SELECT @v_dSql5 += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '            ) D       ' + char(10)
			SELECT @v_dSql5 += '            ON   1=1  ' + char(10)
			SELECT @v_dSql5 += '            AND  A.DIVISION_ID = D.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '            AND  A.SITE_ID     = D.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '            AND  A.ITEM_ID     = D.ITEM_ID     ' + char(10)
			SELECT @v_dSql5 += '            LEFT OUTER JOIN (                  ' + char(10)
			SELECT @v_dSql5 += '                  SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, MAX(A.TRANSPORT_TIME) AS LT ' + char(10)
			SELECT @v_dSql5 += '                  FROM	SCM_BOD_M A(NOLOCK)            ' + char(10)
			SELECT @v_dSql5 += '                  WHERE	1=1                            ' + char(10)
			SELECT @v_dSql5 += '                  AND  A.FROM_OPERATION_ID = ''E4000'' ' + char(10) 
			SELECT @v_dSql5 += '                  AND  A.TO_OPERATION_ID   = ''A5000'' ' + char(10)
			SELECT @v_dSql5 += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql5 += '            ) F     ' + char(10)
			SELECT @v_dSql5 += '            ON	1=1 ' + char(10)
			SELECT @v_dSql5 += '            AND   A.DIVISION_ID = F.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '            AND   A.SITE_ID     = F.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '            LEFT OUTER JOIN (                   ' + char(10)
			SELECT @v_dSql5 += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID ' + char(10)
			SELECT @v_dSql5 += '                      , MAX( CASE WHEN A.OPERATION_LEAD_TIME_UOM = ''DAY'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 24 * 60 ' + char(10)
			SELECT @v_dSql5 += '                                  WHEN A.OPERATION_LEAD_TIME_UOM = ''HOUR'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 60 ' + char(10)
			SELECT @v_dSql5 += '                                  ELSE    ISNULL(OPERATION_LEAD_TIME,0) END ) AS LT ' + char(10)
			SELECT @v_dSql5 += '                  FROM SCM_OPERATION_MOVE_M A WITH(NOLOCK)       ' + char(10)
			SELECT @v_dSql5 += '                  WHERE 1=1                                      ' + char(10)
			SELECT @v_dSql5 += '                  AND	A.OPERATION_ID IN (''E2000'', ''E3000'') ' + char(10)
			SELECT @v_dSql5 += '                  AND	A.OPERATION_LEAD_TIME IS NOT NULL        ' + char(10)
			SELECT @v_dSql5 += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID' + char(10)
			SELECT @v_dSql5 += '            ) E     ' + char(10)
			SELECT @v_dSql5 += '            ON	1=1 ' + char(10)
			SELECT @v_dSql5 += '            AND   A.DIVISION_ID = E.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '            AND   A.SITE_ID     = E.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '            LEFT OUTER JOIN (                   ' + char(10)
			SELECT @v_dSql5 += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '                      , MAX( CASE WHEN A.OPERATION_LEAD_TIME_UOM = ''DAY'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 24 * 60 ' + char(10)
			SELECT @v_dSql5 += '                                  WHEN A.OPERATION_LEAD_TIME_UOM = ''HOUR'' THEN ISNULL(OPERATION_LEAD_TIME,0) * 60     ' + char(10)
			SELECT @v_dSql5 += '                                  ELSE    ISNULL(OPERATION_LEAD_TIME,0) END ) AS LT                                     ' + char(10)
			SELECT @v_dSql5 += '                  FROM   SCM_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '                  WHERE  1=1                                   ' + char(10)
			SELECT @v_dSql5 += '                  AND A.OPERATION_LEAD_TIME IS NOT NULL        ' + char(10)
			SELECT @v_dSql5 += '                  AND A.OPERATION_ID IN (''E2000'', ''E3000'') ' + char(10)
			SELECT @v_dSql5 += '                  GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID  ' + char(10)
			SELECT @v_dSql5 += '            ) G                                 ' + char(10)
			SELECT @v_dSql5 += '            ON	1=1                             ' + char(10)
			SELECT @v_dSql5 += '            AND   A.DIVISION_ID = G.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '            AND   A.SITE_ID     = G.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '            AND   A.ITEM_ID     = G.ITEM_ID     ' + char(10)
			SELECT @v_dSql5 += '            WHERE 1=1      ' + char(10)
			SELECT @v_dSql5 += '        ) A                ' + char(10)
			SELECT @v_dSql5 += '        LEFT OUTER JOIN  ( ' + char(10)
			SELECT @v_dSql5 += '              SELECT *     ' + char(10)
			SELECT @v_dSql5 += '              FROM   FP_INSTANCE_PANCAKE_V WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql5 += '              WHERE  INSTANCE_ID = ' + @v_instance_id + ' ' + char(10)
			SELECT @v_dSql5 += '              AND  GUBUN= ''ASSY''      ' + char(10)
			SELECT @v_dSql5 += '              AND  ACTIVE_FLAG = ''Y''  ' + char(10)
			SELECT @v_dSql5 += '        ) F     ' + char(10)
			SELECT @v_dSql5 += '       	ON  1=1 ' + char(10)
			SELECT @v_dSql5 += '       	AND A.DIVISION_ID = F.DIVISION_ID ' + char(10)
			SELECT @v_dSql5 += '       	AND A.SITE_ID 	  = F.SITE_ID     ' + char(10)
			SELECT @v_dSql5 += '        , SCM_ITEM_CLASS_M B WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '        ,( 	                              ' + char(10)
			SELECT @v_dSql5 += '        	SELECT DISTINCT A.SITE_ID, A.ITEM_ID, A.ITEM_CLASS, A.NICK_NAME  ' + char(10)
			SELECT @v_dSql5 += '        	FROM SCM_ITEM_M A WITH(NOLOCK) ' + char(10)
			SELECT @v_dSql5 += '        		, #INSTANCE_T B             ' + char(10)
			SELECT @v_dSql5 += '        	WHERE A.SITE_ID = B.SITE_ID    ' + char(10)
			SELECT @v_dSql5 += '        ) C                                ' + char(10)
			SELECT @v_dSql5 += '       , SCM_ITEM_CLASS_M D WITH(NOLOCK)   ' + char(10)
			SELECT @v_dSql5 += '        WHERE  A.ITEM_CLASS  = B.CLASS_ID  ' + char(10)
			SELECT @v_dSql5 += '        AND    A.MODEL       = C.ITEM_ID   ' + char(10)
			SELECT @v_dSql5 += '        AND    A.SITE_ID     = C.SITE_ID   ' + char(10)
			SELECT @v_dSql5 += '        AND    C.ITEM_CLASS  = D.CLASS_ID  ' + char(10)
			
			IF(LEN(@p_top_item_id) > 0)
			    BEGIN
				    SELECT @v_dSql5 += '        AND    A.MODEL LIKE ''%'' + RTRIM(LTRIM( ' + @v_top_item_id + ' )) + ''%'' ' + char(10)
				END
			IF(LEN(@p_model_nick_name) > 0)
			    BEGIN
				    SELECT @v_dSql5 += '        AND    ISNULL(C.NICK_NAME,''-'') LIKE ''%'' + RTRIM(LTRIM( ' + @v_model_nick_name + ' )) + ''%'' ' + char(10)
				END
			IF(LEN(@p_cell_type) > 0)
			    BEGIN
				    SELECT @v_dSql5 += '        AND    (CASE WHEN D.LEVEL_4_NAME = ''-'' THEN D.LEVEL_2_NAME ELSE D.LEVEL_4_NAME END) = ' + @v_cell_type + ' ' + char(10)
				END
			IF(LEN(@p_pancake_type) > 0)
			    BEGIN
				    SELECT @v_dSql5 += '        AND    B.LEVEL_3_NAME = ' + @v_pancake_type + ' ' + char(10)
				END

			--SELECT @v_dSql5 += '    )        ' + char(10)





			SELECT @v_dSql5 += '    SELECT * ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.BOH_QTY,0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.HOLD_QTY,0) AS MONEY),1),''.00'','''') +  '')'' AS BOH        ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.PC_BOH_QTY,0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.PC_HOLD_QTY,0) AS MONEY),1),''.00'','''') + '')'' AS PC_BOH ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.JR_BOH_QTY,0) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST(ISNULL(A.JR_HOLD_QTY,0) AS MONEY),1),''.00'','''') + '')'' AS JR_BOH ' + char(10)
			SELECT @v_dSql5 += '    FROM 	#MAIN_T A ' + char(10)
			SELECT @v_dSql5 += '    UNION ALL        ' + char(10)
			SELECT @v_dSql5 += '    SELECT 	NULL AS DIVISION_ID, NULL AS SITE_ID                ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS ITEM_ID, NULL AS NICK_NAME, NULL AS ITEM_TYPE ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS MODEL       ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS TOP_ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS NPC_ITEM_ID ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS ITEM_CLASS  ' + char(10)
			SELECT @v_dSql5 += '        , A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER ' + char(10)
			SELECT @v_dSql5 += '        , 0 AS PREV_BOH_QTY                                ' + char(10)
			SELECT @v_dSql5 += '        , SUM( A.POST_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS POST_BOH_QTY ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS BOH_QTY         ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.PC_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS PC_BOH_QTY   ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.JR_BOH_QTY ) / CONVERT(int, '+ @v_unit +') AS JR_BOH_QTY   ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS HOLD_QTY       ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.PC_HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS PC_HOLD_QTY ' + char(10)
			SELECT @v_dSql5+= '        , SUM( A.JR_HOLD_QTY ) / CONVERT(int, '+ @v_unit +') AS JR_HOLD_QTY ' + char(10)

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
               		                SET @mst_loop_cnt     =  @mst_loop_cnt +1
               		                SET @v_Tmp1 += '        , NULL AS M' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt-1) +' ' + char(10)
               		            END
                 	         
               		        -- weekinfo
               		        SET @mst_loop_cnt = 0	
               		        SET @max_loop_cnt = 0
               		        SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_week_info, @v_delimiter) -- 프로시저 LOOP 길이를 판단
               		        SET @v_Tmp2       = ''
               		        WHILE @mst_loop_cnt < @max_loop_cnt
               		            BEGIN
                                    SET @mst_loop_cnt     =  @mst_loop_cnt +1
               		                SET @v_Tmp2 += '        , NULL AS W' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)				
               		            END
                 	        
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
               		                
               		                SET @v_Tmp3 += '        , SUM(D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +') / CONVERT(int, '+ @v_unit +') AS D' + TRY_CONVERT(NVARCHAR, @mst_loop_cnt -1) +' ' + char(10)
               		            END
			            END 
			    END --IF END

            SELECT @v_dSql5+= @v_Tmp1 + @v_Tmp2 + @v_Tmp3

			SELECT @v_dSql5 += '        , ''TOTAL_2'' AS DATA_TYPE                   ' + char(10)
			SELECT @v_dSql5 += '        , A.MODEL_LEVEL_3_NAME AS MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS MODEL_CLASS_NAME                   ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS MODEL_NICK_NAME                    ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS MODEL_CLASS                        ' + char(10)
			SELECT @v_dSql5 += '        , NULL AS LT                                 ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.BOH_QTY,0)) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.HOLD_QTY,0)) AS MONEY),1),''.00'','''') + '')'' AS BOH          ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.PC_BOH_QTY,0)) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.PC_HOLD_QTY,0)) AS MONEY),1),''.00'','''') + '')'' AS PC_BOH ' + char(10)
			SELECT @v_dSql5 += '        , REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.JR_BOH_QTY,0)) AS MONEY),1),''.00'','''') + ''('' + REPLACE(CONVERT(VARCHAR, CAST( SUM(ISNULL(A.JR_HOLD_QTY,0)) AS MONEY),1),''.00'','''') + '')'' AS JR_BOH ' + char(10)
			SELECT @v_dSql5 += '    FROM #MAIN_T A ' + char(10)
			SELECT @v_dSql5 += '    WHERE 1=1     ' + char(10)
			IF(@p_total_include <> 'Y')
			    BEGIN
				    SELECT @v_dSql5 += '    AND  1=0 ' + char(10)
				END

			SELECT @v_dSql5 += '    GROUP BY A.CATEGORY_ID, A.CATEGORY_NAME, A.CATEGORY_ORDER, A.MODEL_LEVEL_3_NAME ' + char(10)
			SELECT @v_dSql5 += '    ORDER BY A.DIVISION_ID, A.SITE_ID,  A.MODEL, A.MODEL_LEVEL_3_NAME, A.ITEM_CLASS, A.ITEM_ID, A.CATEGORY_ORDER ' + char(10)

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
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id))                          + char(10)
            SELECT @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.NICK_NAME' , 'LK', @p_nick_name))                      + char(10)          

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
