

--CREATE
CREATE
PROCEDURE [dbo].[PR_UI_FP00599MK2_FIND_TOTALVALUE]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @in_columns nvarchar(MAX),
  @in_row nvarchar(MAX),
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_FP00599MK2_FIND_TOTALVALUE                                          **/
/** 프로그램 명   : Procedure PR_UI_FP00599MK2_FIND_TOTALVALUE                                **/
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
/** 2021-03-23     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/** 2023-05-15     hsbyeon				홀드수량 조회										  **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599MK2_FIND_TOTALVALUE
*/

BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  --DECLARE BASE PARAMETER START
  DECLARE @STRLEN nvarchar(max)
  DECLARE @runstart datetime
  DECLARE @runend datetime
  DECLARE @v_dSql nvarchar(max)
  DECLARE @v_Err nvarchar(max)
  DECLARE @v_Log nvarchar(max) 
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599MK2_FIND_TOTALVALUE'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p_plan_type nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_top_item_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_past_plan_type nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_item_name nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  --DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_cell_group nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  DECLARE @p_AMEND_TABLE nvarchar(100) = 'FP_AMEND_PLAN_CELL_R'
  DECLARE @p_AMEND_CUTOFF_BOH_TABLE nvarchar(100) = 'FP_AMEND_CUTOFF_BOH_R'
  DECLARE @p_AMEND_BOR_TABLE nvarchar(100) = 'FP_AMEND_PLAN_CELL_BOR_R'
  DECLARE @p_AMEND_SALES_TABLE nvarchar(100) = 'FP_AMEND_PLAN_CELL_SALES_R'
  DECLARE @p_AMEND_UTIL_TABLE nvarchar(100) = 'FP_AMEND_PLAN_CELL_UTIL_R'




  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_plan_date nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_top_item_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_past_plan_type nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_item_name nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_line_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2top_item_id nvarchar(max)
  DECLARE @opt_3item_id nvarchar(max)
  DECLARE @opt_4past_plan_type nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6operation_id nvarchar(max)
  DECLARE @opt_7top_item_id nvarchar(max)
  DECLARE @opt_8item_id nvarchar(max)
  DECLARE @opt_9site_id nvarchar(max)
  DECLARE @opt_10operation_id nvarchar(max)
  DECLARE @opt_11top_item_id nvarchar(max)
  DECLARE @opt_12item_id nvarchar(max)
  DECLARE @opt_13item_name nvarchar(max)
  DECLARE @opt_14site_id nvarchar(max)
  DECLARE @opt_15operation_id nvarchar(max)
  DECLARE @opt_16top_item_id nvarchar(max)
  DECLARE @opt_17item_id nvarchar(max)
  DECLARE @opt_18past_plan_type nvarchar(max)
  DECLARE @opt_19site_id nvarchar(max)
  DECLARE @opt_20operation_id nvarchar(max)
  DECLARE @opt_21top_item_id nvarchar(max)
  DECLARE @opt_22item_id nvarchar(max)
  DECLARE @opt_23site_id nvarchar(max)
  DECLARE @opt_24operation_id nvarchar(max)
  DECLARE @opt_25top_item_id nvarchar(max)
  DECLARE @opt_26item_id nvarchar(max)
  DECLARE @opt_27item_name nvarchar(max)

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TOP_ITEM_ID' BEGIN
      SET @p_top_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PAST_PLAN_TYPE' BEGIN
      SET @p_past_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_NAME' BEGIN
      SET @p_item_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      --SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_GROUP' BEGIN
      SET @p_cell_group =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PARAM' BEGIN
    --  SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
    --  SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
		SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END

  IF @p_plan_type = 'RELEASE' BEGIN
    SET @p_AMEND_TABLE = 'FP_AMEND_PLAN_CELL_H'
    SET @p_AMEND_CUTOFF_BOH_TABLE = 'FP_AMEND_CUTOFF_BOH_H'
	SET @p_AMEND_BOR_TABLE = 'FP_AMEND_PLAN_CELL_BOR_H'
    SET @p_AMEND_SALES_TABLE = 'FP_AMEND_PLAN_CELL_SALES_H'
    SET @p_AMEND_UTIL_TABLE = 'FP_AMEND_PLAN_CELL_UTIL_H'
  END
  
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_plan_date ='''' + @p_plan_date + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_top_item_id ='''' + @p_top_item_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_past_plan_type ='''' + @p_past_plan_type + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_item_name ='''' + @p_item_name + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  --SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_line_lt ='''' + @p_line_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2top_item_id = ''
  END ELSE BEGIN
    SET @opt_2top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3item_id = ''
  END ELSE BEGIN
    SET @opt_3item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_past_plan_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_4past_plan_type = ''
  END ELSE BEGIN
    SET @opt_4past_plan_type = 'AND    A.PLAN_TYPE = ' + @v_past_plan_type+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_id = ''
  END ELSE BEGIN
    SET @opt_6operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7top_item_id = ''
  END ELSE BEGIN
    SET @opt_7top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8item_id = ''
  END ELSE BEGIN
    SET @opt_8item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9site_id = ''
  END ELSE BEGIN
    SET @opt_9site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10operation_id = ''
  END ELSE BEGIN
    SET @opt_10operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11top_item_id = ''
  END ELSE BEGIN
    SET @opt_11top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_12item_id = ''
  END ELSE BEGIN
    SET @opt_12item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_13item_name = ''
  END ELSE BEGIN
    SET @opt_13item_name = 'AND    B.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_item_name+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_14site_id = ''
  END ELSE BEGIN
    SET @opt_14site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_15operation_id = ''
  END ELSE BEGIN
    SET @opt_15operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_16top_item_id = ''
  END ELSE BEGIN
    SET @opt_16top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_17item_id = ''
  END ELSE BEGIN
    SET @opt_17item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_past_plan_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_18past_plan_type = ''
  END ELSE BEGIN
    SET @opt_18past_plan_type = 'AND    A.PLAN_TYPE = ' + @v_past_plan_type+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_19site_id = ''
  END ELSE BEGIN
    SET @opt_19site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_20operation_id = ''
  END ELSE BEGIN
    SET @opt_20operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_21top_item_id = ''
  END ELSE BEGIN
    SET @opt_21top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_22item_id = ''
  END ELSE BEGIN
    SET @opt_22item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_23site_id = ''
  END ELSE BEGIN
    SET @opt_23site_id = 'AND    A.SITE_ID   = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_24operation_id = ''
  END ELSE BEGIN
    SET @opt_24operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_top_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_25top_item_id = ''
  END ELSE BEGIN
    SET @opt_25top_item_id = 'AND    A.TOP_ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_top_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_26item_id = ''
  END ELSE BEGIN
    SET @opt_26item_id = 'AND    A.ITEM_ID LIKE ''%'' + RTRIM(LTRIM(' + @v_item_id+')) + ''%'''
  END
  SET @STRLEN = LEN(@p_item_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_27item_name = ''
  END ELSE BEGIN
    SET @opt_27item_name = 'AND    B.NICK_NAME LIKE ''%'' + RTRIM(LTRIM(' + @v_item_name+')) + ''%'''
  END


  -- FP00599 find_TotalValue  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH MAIN AS ('+char(10)
  SET @v_dSql += '          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '               , A.OPERATION_ID, A.LOCATION'+char(10)
  SET @v_dSql += '               , A.ITEM_ID, A.TOP_ITEM_ID, ISNULL(A.MODIFY_QTY, A.QTY) AS QTY'+char(10)
  SET @v_dSql += '               , A.HOLD_QTY'+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '          FROM    ('+char(10)
  -- Add none-plan, only-boh item... 20211224
  SET @v_dSql += '										                      SELECT '+char(10)
  SET @v_dSql += '										                      	   A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, NULL ITEM_TYPE '+char(10)
  SET @v_dSql += '										                      	 , A.OPERATION_ID, A.FACTORY_ID, A.LOCATION, A.MODIFY_QTY, A.QTY '+char(10)
  SET @v_dSql += '										                      	 , A.HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '										                      FROM ( '+char(10)
  SET @v_dSql += '																SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '+char(10)
  SET @v_dSql += '										                      		, A.OPERATION_ID, A.LOCATION, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '										                      		, A.ITEM_ID, A.TOP_ITEM_ID, A.MODIFY_QTY, A.QTY '+char(10)
  SET @v_dSql += '										                      		, ISNULL(A.HOLD_QTY, 0) AS  HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '																FROM   ' + @p_amend_cutoff_boh_table + ' A WITH(NOLOCK), SCM_ITEM_M B WITH(NOLOCK), SCM_ITEM_CLASS_M C WITH(NOLOCK) '+char(10)
  SET @v_dSql += '																WHERE  1=1 '+char(10)
  SET @v_dSql += '																AND    A.COMPANY_ID  = B.COMPANY_ID  '+char(10)
  SET @v_dSql += '																AND    A.DIVISION_ID = B.DIVISION_ID '+char(10)
  SET @v_dSql += '																AND    A.SITE_ID     = B.SITE_ID '+char(10)
  SET @v_dSql += '																AND    A.ITEM_ID     = B.ITEM_ID '+char(10)
  SET @v_dSql += '																AND    B.ITEM_CLASS  = C.CLASS_ID '+char(10)
  SET @v_dSql += '																AND    C.CLASS_ID <> ''ES1101'' -- NONE HARP CELL ITEM '+char(10)
  SET @v_dSql += '																AND    A.INSTANCE_ID = ' + @v_master_id + ' '+char(10)
  SET @v_dSql += '																AND    A.FP_PLAN_ID  = ' + @v_plan_id + ' ' + char(10)
  SET @v_dSql += '										                        UNION ALL -- HARP CELL ITEM '+char(10)


  SET @v_dSql += '										                        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '										                        		 , A.ITEM_ID, A.TOP_ITEM_ID, A.MODIFY_QTY, A.QTY  '+char(10)
  SET @v_dSql += '										                        		 , A.HOLD_QTY  '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '										                        FROM ( '+char(10)
  SET @v_dSql += '										                        	SELECT A.*'+char(10)
  SET @v_dSql += '										                        		 , B.OUT_QTY AS SUM_QTY '+char(10)
  SET @v_dSql += '										                        		 , ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID '+char(10)
  SET @v_dSql += '										                        						     ORDER BY     B.OUT_QTY DESC, B.LINE_ID, B.ELECTRODE_TYPE ) AS ROW_NUM '+char(10)
  SET @v_dSql += '										                        	FROM ( '+char(10)
  SET @v_dSql += '																			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '										                      					, A.ITEM_ID, B.TOP_ITEM_ID, B.MODIFY_QTY, B.QTY'+char(10)
  SET @v_dSql += '										                      					, ISNULL(B.HOLD_QTY, 0) AS HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '																			FROM ( '+char(10)
  SET @v_dSql += '																				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, C.PLANT_ID, C.FACTORY_ID, C.OPERATION_ID, C.LINE_ID, C.ELECTRODE_TYPE, A.ITEM_ID, B.LOCATION '+char(10)
  SET @v_dSql += '																				FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M D WITH(NOLOCK), SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '																				WHERE  1=1 '+char(10)
  SET @v_dSql += '																				AND    A.ITEM_CLASS  = D.CLASS_ID '+char(10)
  SET @v_dSql += '																				AND    A.COMPANY_ID  = C.COMPANY_ID '+char(10)
  SET @v_dSql += '																				AND    A.DIVISION_ID = C.DIVISION_ID '+char(10)
  SET @v_dSql += '																				AND    A.SITE_ID     = C.SITE_ID '+char(10)
  SET @v_dSql += '																				AND    A.ITEM_ID     = C.ITEM_ID '+char(10)
  SET @v_dSql += '																				AND    B.COMPANY_ID     = C.COMPANY_ID '+char(10)
  SET @v_dSql += '																				AND    B.DIVISION_ID    = C.DIVISION_ID '+char(10)
  SET @v_dSql += '																				AND    B.SITE_ID        = C.SITE_ID '+char(10)
  SET @v_dSql += '																				AND    B.PLANT_ID       = C.PLANT_ID '+char(10)
  SET @v_dSql += '																				AND    B.FACTORY_ID     = C.FACTORY_ID '+char(10)
  SET @v_dSql += '																				AND    B.OPERATION_ID   = C.OPERATION_ID '+char(10)
  SET @v_dSql += '																				AND    B.LINE_ID        = C.LINE_ID '+char(10)
  SET @v_dSql += '																				AND    B.ELECTRODE_TYPE = C.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '																				AND    A.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '																				AND    D.USE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '																				AND    D.CLASS_ID = ''ES1101'' '+char(10)
  SET @v_dSql += '																				AND    C.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += '																				AND    C.MONTH = LEFT(''' + @p_plan_date + ''' ,6) ' + char(10)
  SET @v_dSql += '																			) A '+char(10)
  SET @v_dSql += '																			LEFT OUTER JOIN ' + @p_amend_cutoff_boh_table + ' B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '																			ON     A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '																			AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '																			AND    A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '																			AND    A.PLANT_ID     = B.PLANT_ID '+char(10)
  SET @v_dSql += '																			AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
  SET @v_dSql += '																			AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
  SET @v_dSql += '																			AND    A.ITEM_ID      = B.ITEM_ID '+char(10)
  SET @v_dSql += '																			AND    B.INSTANCE_ID = ' + @v_master_id + ' '+char(10)
  SET @v_dSql += '																			AND    B.FP_PLAN_ID  = ' + @v_plan_id + ' '+char(10)
  SET @v_dSql += '																			WHERE  1=1 '+char(10)
  SET @v_dSql += '																			AND    B.TOP_ITEM_ID IS NOT NULL '+char(10)
  SET @v_dSql += '																	) A '+char(10)
  SET @v_dSql += '																	LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '										                        			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.TOP_ITEM_ID, A.ITEM_ID'+char(10)
  SET @v_dSql += '										                        					, SUM(OUT_QTY) AS OUT_QTY'+char(10)
  SET @v_dSql += '										                        			FROM   ' + @p_amend_table + ' A WITH(NOLOCK) '+ char(10)
  SET @v_dSql += '										                        			WHERE  A.INSTANCE_ID  = ' + @v_master_id + ' '+char(10)
  SET @v_dSql += '										                        			AND    A.FP_PLAN_ID   = ' + @v_plan_id + ' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += '										                        			AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' '+char(10)
  SET @v_dSql += '										                        			AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0) '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
  SET @v_dSql += '										                        			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.TOP_ITEM_ID, A.ITEM_ID '+ char(10)
  SET @v_dSql += '																    ) B '+ char(10)
  SET @v_dSql += '																    ON  A.COMPANY_ID     = B.COMPANY_ID '+ char(10)
  SET @v_dSql += '																    AND A.DIVISION_ID    = B.DIVISION_ID '+ char(10)
  SET @v_dSql += '																    AND A.SITE_ID        = B.SITE_ID '+ char(10)
  SET @v_dSql += '																    AND A.PLANT_ID       = B.PLANT_ID '+ char(10)
  SET @v_dSql += '																    AND A.FACTORY_ID     = B.FACTORY_ID '+ char(10)
  SET @v_dSql += '																    AND A.OPERATION_ID   = B.OPERATION_ID '+ char(10)
  SET @v_dSql += '																    AND A.LINE_ID        = B.LINE_ID '+ char(10)
  SET @v_dSql += '																    AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE '+ char(10)
  SET @v_dSql += '																    AND A.TOP_ITEM_ID    = B.TOP_ITEM_ID '+ char(10)
  SET @v_dSql += '																    AND A.ITEM_ID        = B.ITEM_ID '+ char(10)
  SET @v_dSql += '																) A '+ char(10)
  SET @v_dSql += '																WHERE 1=1 '+ char(10)
  SET @v_dSql += '																AND   A.ROW_NUM = 1 '+ char(10)


  /*
  SET @v_dSql += '										                        SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LOCATION, A.LINE_ID, A.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '										                      		, A.ITEM_ID, B.TOP_ITEM_ID, B.MODIFY_QTY, B.QTY'+char(10)
  SET @v_dSql += '																FROM ( '+char(10)
  SET @v_dSql += '																	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, C.PLANT_ID, C.FACTORY_ID, C.OPERATION_ID, C.LINE_ID, C.ELECTRODE_TYPE, A.ITEM_ID, B.LOCATION '+char(10)
  SET @v_dSql += '																	FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M D WITH(NOLOCK), SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK), SCM_LINE_M B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '																	WHERE  1=1 '+char(10)
  SET @v_dSql += '																	AND    A.ITEM_CLASS  = D.CLASS_ID '+char(10)
  SET @v_dSql += '																	AND    A.COMPANY_ID  = C.COMPANY_ID '+char(10)
  SET @v_dSql += '																	AND    A.DIVISION_ID = C.DIVISION_ID '+char(10)
  SET @v_dSql += '																	AND    A.SITE_ID     = C.SITE_ID '+char(10)
  SET @v_dSql += '																	AND    A.ITEM_ID     = C.ITEM_ID '+char(10)
  SET @v_dSql += '																	AND    B.COMPANY_ID     = C.COMPANY_ID '+char(10)
  SET @v_dSql += '																	AND    B.DIVISION_ID    = C.DIVISION_ID '+char(10)
  SET @v_dSql += '																	AND    B.SITE_ID        = C.SITE_ID '+char(10)
  SET @v_dSql += '																	AND    B.PLANT_ID       = C.PLANT_ID '+char(10)
  SET @v_dSql += '																	AND    B.FACTORY_ID     = C.FACTORY_ID '+char(10)
  SET @v_dSql += '																	AND    B.OPERATION_ID   = C.OPERATION_ID '+char(10)
  SET @v_dSql += '																	AND    B.LINE_ID        = C.LINE_ID '+char(10)
  SET @v_dSql += '																	AND    B.ELECTRODE_TYPE = C.ELECTRODE_TYPE '+char(10)
  SET @v_dSql += '																	AND    A.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '																	AND    D.USE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '																	AND    D.CLASS_ID = ''ES1101'' '+char(10)
  SET @v_dSql += '																	AND    C.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += '																	AND    C.MONTH = LEFT(''' + @p_plan_date + ''' ,6) ' + char(10)
  SET @v_dSql += '																) A '+char(10)
  SET @v_dSql += '																LEFT OUTER JOIN ' + @p_amend_cutoff_boh_table + ' B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '																ON     A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '																AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '																AND    A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '																AND    A.PLANT_ID     = B.PLANT_ID '+char(10)
  SET @v_dSql += '																AND    A.FACTORY_ID   = B.FACTORY_ID '+char(10)
  SET @v_dSql += '																AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
  SET @v_dSql += '																AND    A.ITEM_ID      = B.ITEM_ID '+char(10)
  SET @v_dSql += '																AND    B.INSTANCE_ID = ' + @v_master_id + ' '+char(10)
  SET @v_dSql += '																AND    B.FP_PLAN_ID  = ' + @v_plan_id + ' '+char(10)
  SET @v_dSql += '																WHERE  1=1 '+char(10)
  SET @v_dSql += '																AND    B.TOP_ITEM_ID IS NOT NULL '+char(10)
  */


  SET @v_dSql += '										                      ) A'+char(10)
  SET @v_dSql += '															  INNER HASH JOIN ( -- amend  '+char(10)
  SET @v_dSql += '															  	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.TOP_ITEM_ID, A.ITEM_ID '+char(10)
  SET @v_dSql += '															  		 --, A.MARKET, A.PRODUCTION_TYPE '+char(10)
  SET @v_dSql += '															  	FROM   ' + @p_amend_table + ' A WITH(NOLOCK) '+char(10)
  SET @v_dSql += '															  	WHERE  A.INSTANCE_ID  = ' + @v_master_id + ' '+char(10)
  SET @v_dSql += '															  	AND    A.FP_PLAN_ID   = ' + @v_plan_id + ' '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10) 
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id)) + char(10)
  SET @v_dSql += '															  	AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ' + @v_bucket_from + ' AND ' + @v_bucket_to + ' '+char(10)
  SET @v_dSql += '										                        AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0) '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LK', @p_top_item_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LK', @p_item_id)) + char(10) 
  SET @v_dSql += '															  ) B '+char(10)
  SET @v_dSql += '															  ON  A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '															  AND A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '															  AND A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '															  AND A.PLANT_ID     = B.PLANT_ID '+char(10)
  SET @v_dSql += '															  AND A.FACTORY_ID   = B.FACTORY_ID '+char(10)
  SET @v_dSql += '															  AND A.OPERATION_ID = B.OPERATION_ID '+char(10)
  SET @v_dSql += '															  AND A.TOP_ITEM_ID  = B.TOP_ITEM_ID '+char(10)
  SET @v_dSql += '															  AND A.ITEM_ID      = B.ITEM_ID '+char(10)
  SET @v_dSql += '															  INNER HASH JOIN FP_CELL_GROUP_V J WITH(NOLOCK) '+char(10)
  SET @v_dSql += '															  ON  A.COMPANY_ID  = J.COMPANY_ID '+char(10)
  SET @v_dSql += '															  AND A.DIVISION_ID = J.DIVISION_ID '+char(10)
  SET @v_dSql += '															  AND A.SITE_ID     = J.SITE_ID '+char(10)
  SET @v_dSql += '															  AND A.TOP_ITEM_ID = J.ITEM_ID '+char(10)
  SET @v_dSql += '															  WHERE 1=1 '+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('J.CELL_GROUP' , 'LK', @p_cell_group)) + char(10) 
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          INNER JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.ITEM_ID      = B.ITEM_ID'+char(10)
  SET @v_dSql += '          WHERE  1=1'+char(10)
  SET @v_dSql += '          AND    EXISTS ('+char(10)
  SET @v_dSql += '              SELECT 1'+char(10)
  SET @v_dSql += '              FROM ('+char(10)
  SET @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                       , A.OPERATION_ID, A.LOCATION'+char(10)
  SET @v_dSql += '                    	 , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '                       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '                  FROM   '+ @p_AMEND_TABLE +' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE  A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '                  AND    A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) >='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id) + char(10)
  SET @v_dSql += ' ' +@opt_2top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '                  UNION ALL'+char(10)
  SET @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                       , A.OPERATION_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '                    	 , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '                       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '                  FROM   FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE  1=0'+char(10)
  SET @v_dSql += '                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) <'+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ' ' +@opt_4past_plan_type +' '+''+char(10)--AND    A.PLAN_TYPE = #PAST_PLAN_TYPE#
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id) + char(10)
  SET @v_dSql += ' ' +@opt_2top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '                  UNION ALL'+char(10)
  SET @v_dSql += '                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '                    	 , A.OPERATION_ID, ISNULL(A.LOCATION,''-'') AS LOCATION'+char(10)
  SET @v_dSql += '                       , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '                       , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE'+char(10)
  SET @v_dSql += '                  FROM   SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE  1=0'+char(10)
  SET @v_dSql += '                  AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id) + char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id) + char(10)
  SET @v_dSql += ' ' +@opt_2top_item_id +' '+''+char(10)--AND    A.TOP_ITEM_ID LIKE '%' + RTRIM(LTRIM(#TOP_ITEM_ID#)) + '%'
  SET @v_dSql += ' ' +@opt_3item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + RTRIM(LTRIM(#ITEM_ID#)) + '%'
  SET @v_dSql += '              ) AA'+char(10)
  SET @v_dSql += '              WHERE A.COMPANY_ID    = AA.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND   A.DIVISION_ID   = AA.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND   A.SITE_ID       = AA.SITE_ID'+char(10)
  SET @v_dSql += '              AND   A.PLANT_ID      = AA.PLANT_ID'+char(10)
  SET @v_dSql += '              AND   A.FACTORY_ID    = AA.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND   A.OPERATION_ID  = AA.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND   A.LOCATION      = AA.LOCATION'+char(10)
  SET @v_dSql += '          	  AND   A.ITEM_ID       = AA.ITEM_ID'+char(10)
  SET @v_dSql += '              AND   A.TOP_ITEM_ID   = AA.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '              AND   AA.PLAN_DATE BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '          )'+char(10)
  SET @v_dSql += ' ' +@opt_13item_name +' '+''+char(10)--AND    B.NICK_NAME LIKE '%' + RTRIM(LTRIM(#ITEM_NAME#)) + '%'
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      -- SUB TOTAL'+char(10)
  SET @v_dSql += '      , SUB_TOTAL AS ( '+char(10)
  SET @v_dSql += '			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ''-'' AS FACTORY_ID'+char(10)
  SET @v_dSql += '			     , A.OPERATION_ID, ''-'' AS LOCATION'+char(10)
  SET @v_dSql += '			     , A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '			     , SUM(A.QTY) AS QTY'+char(10)
  SET @v_dSql += '			     , ROUND(( SUM(A.QTY) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,' + @v_plan_date + ' )) ) ,0) AS BOH_CELL_QTY '+char(10)
  SET @v_dSql += '			     , SUM(A.HOLD_QTY) AS HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			     , ROUND(( SUM(A.HOLD_QTY) / dbo.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,' + @v_plan_date + ' )) ) ,0) AS BOH_CELL_HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  --SET @v_dSql += '			     , ( SUM(A.QTY) / DBO.FN_GET_REQ_QTY_MODEL(A.PLANT_ID, A.TOP_ITEM_ID, A.ITEM_ID, CONVERT(DATE,' + @v_plan_date + ' )) ) AS BOH_CELL_QTY_RAW '+char(10)
  SET @v_dSql += '			     , ''TOTAL'' AS _TYPE'+char(10)
  SET @v_dSql += '			FROM   MAIN A'+char(10)
  SET @v_dSql += '			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.ITEM_ID, A.TOP_ITEM_ID'+char(10)
  SET @v_dSql += '      ) '+char(10)
  SET @v_dSql += '      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			 , OPERATION_ID, LOCATION '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			 , ITEM_ID, TOP_ITEM_ID '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			 , REPLACE(CONVERT(VARCHAR, CAST(QTY AS MONEY),1),''.00'','''') '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			  + ''('' + REPLACE(CONVERT(VARCHAR, CAST(HOLD_QTY AS MONEY),1),''.00'','''') + '')'' AS  QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			 , REPLACE(CONVERT(VARCHAR, CAST(BOH_CELL_QTY AS MONEY),1),''.00'','''') '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			  + ''('' + REPLACE(CONVERT(VARCHAR, CAST(BOH_CELL_HOLD_QTY AS MONEY),1),''.00'','''') + '')'' AS  BOH_CELL_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '			 , _TYPE '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      FROM SUB_TOTAL '+char(10)
  SET @v_dSql += '      UNION ALL '+char(10)
  SET @v_dSql += '      --- TOTAL'+char(10)
  SET @v_dSql += '      SELECT NULL AS COMPANY_ID, NULL AS DIVISION_ID, NULL AS SITE_ID, NULL AS PLANT_ID, NULL AS FACTORY_ID '+char(10)
  SET @v_dSql += '           , A.OPERATION_ID, NULL AS LOCATION, NULL AS ITEM_ID, NULL AS TOP_ITEM_ID '+char(10)
  --SET @v_dSql += '      	 , B.QTY, B.BOH_CELL_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	 , REPLACE(CONVERT(VARCHAR, CAST(B.QTY AS MONEY),1),''.00'','''') '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	  + ''('' + REPLACE(CONVERT(VARCHAR, CAST(B.HOLD_QTY AS MONEY),1),''.00'','''') + '')'' AS  QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	 , REPLACE(CONVERT(VARCHAR, CAST(B.BOH_CELL_QTY AS MONEY),1),''.00'','''') '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	  + ''('' + REPLACE(CONVERT(VARCHAR, CAST(B.BOH_CELL_HOLD_QTY AS MONEY),1),''.00'','''') + '')'' AS  BOH_CELL_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	 , ''TOTAL_2'' AS _TYPE '+char(10)
  SET @v_dSql += '      FROM ( '+char(10)
  SET @v_dSql += '      	SELECT DISTINCT OPERATION_ID '+char(10)
  SET @v_dSql += '      	FROM   SCM_OPERATION_M A WITH(NOLOCK) '+char(10)
  SET @v_dSql += '      	WHERE  1 = 1 '+char(10)
  SET @v_dSql += [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id) + char(10)
  SET @v_dSql += '      ) A '+char(10)
  SET @v_dSql += '      LEFT OUTER JOIN ( '+char(10)
  SET @v_dSql += '      	SELECT A.OPERATION_ID, SUM(A.QTY) AS QTY, SUM(A.BOH_CELL_QTY) AS BOH_CELL_QTY '+char(10)
  SET @v_dSql += '      	     , SUM(A.HOLD_QTY) AS HOLD_QTY, SUM(A.BOH_CELL_HOLD_QTY) AS BOH_CELL_HOLD_QTY '+char(10) -- 2023.05.15 홀드수량 조회
  SET @v_dSql += '      	FROM   SUB_TOTAL A '+char(10)
  SET @v_dSql += '      	WHERE  1=1 '+char(10)
  SET @v_dSql += '      	GROUP BY A.OPERATION_ID '+char(10)
  SET @v_dSql += '      ) B '+char(10)
  SET @v_dSql += '      ON A.OPERATION_ID = B.OPERATION_ID '+char(10)

  IF @p_sys_type = 'SQL'
  BEGIN
    -- return SQL Query Source
    select @v_dSql as [QUERY_VALUE]
  END ELSE BEGIN
    SET @runstart = GetDate()

    BEGIN TRY
      BEGIN TRAN
        -- run dynamic sql
        exec sp_executesql @v_dSql
      COMMIT TRAN
    END TRY
    BEGIN CATCH
      ROLLBACK
      SET @runend = GetDate()
      exec PR_UI_SQL_LOG 'PR_UI_FP00599MK2_FIND_TOTALVALUE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599MK2_FIND_TOTALVALUE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
