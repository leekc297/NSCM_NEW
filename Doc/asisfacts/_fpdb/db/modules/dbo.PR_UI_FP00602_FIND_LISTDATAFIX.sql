CREATE PROCEDURE [dbo].[PR_UI_FP00602_FIND_LISTDATAFIX]
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
/** 프로그램 ID   : PR_UI_FP00602_FIND_LISTDATAFIX                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_FIND_LISTDATAFIX                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-04-14     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_FIND_LISTDATAFIX
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_FIND_LISTDATAFIX'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_type nvarchar(max) = ''
  DECLARE @p_master_id nvarchar(max) = ''
  DECLARE @p_AMEND_TABLE nvarchar(max) = ''
  
  DECLARE @p_plan_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_plan_type nvarchar(max)
  DECLARE @v_master_id nvarchar(max)
  DECLARE @v_plan_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0operation_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'PLAN_TYPE' BEGIN
      SET @p_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MASTER_ID' BEGIN
      SET @p_master_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_ID' BEGIN
      SET @p_plan_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'AMEND_TABLE' BEGIN
      SET @p_AMEND_TABLE =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_plan_type ='''' + @p_plan_type + ''''
  SET @v_master_id ='''' + @p_master_id + ''''
  SET @v_plan_id ='''' + @p_plan_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0operation_id = ''
  END ELSE BEGIN
    SET @opt_0operation_id = 'AND  A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND  A.OPERATION_ID = ' + @v_operation_id+''
  END


  -- FP00602 find_ListData  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.INSTANCE_ID, A.FP_PLAN_ID'+char(10)
  SET @v_dSql += '           , A.COMPANY_ID, A.DIVISION_ID, A.CATEGORY_ID, A.SITE_ID, A.PLANT_ID'+char(10)
  SET @v_dSql += '           , A.ITEM_ID, A.OPERATION_ID, A.PRODUCTION_TYPE, A.MARKET, A.FACTORY_ID'+char(10)
  SET @v_dSql += '           , A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.TOP_ITEM_ID, A.ITEM_TYPE'+char(10)
  SET @v_dSql += '           , A.IN_QTY, A.OUT_QTY'+char(10)
  SET @v_dSql += '           , A.CELL_IN_QTY, A.CELL_OUT_QTY'+char(10)
  SET @v_dSql += '           , A.WPP_CELL_OUT_QTY AS WPP_OUT_QTY'+char(10)
  SET @v_dSql += '           , A.MPP_CELL_OUT_QTY AS MPP_OUT_QTY'+char(10)
  SET @v_dSql += '           , A.DATE_SEQ AS SEQ'+char(10)
  SET @v_dSql += '           , NULL AS BOH_QTY'+char(10)
  SET @v_dSql += '           , NULL AS SALES_QTY'+char(10)
  SET @v_dSql += '           , NULL AS EOH_QTY'+char(10)
  SET @v_dSql += '           , NULL AS YIELD'+char(10)
  SET @v_dSql += '      FROM   '+@p_AMEND_TABLE + ' A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE 1=(CASE WHEN'+char(10)
  SET @v_dSql += '' + @v_plan_type+''+char(10)
  SET @v_dSql += ' = ''RELEASE'' THEN 1 ELSE 0 END)'+char(10)
  SET @v_dSql += '      AND 	A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_master_id+''+char(10)
  SET @v_dSql += '      AND   A.FP_PLAN_ID   ='+char(10)
  SET @v_dSql += '' + @v_plan_id+''+char(10)
  SET @v_dSql += '      AND   A.CATEGORY_ID  = ''PLAN'''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
  --SET @v_dSql += ' ' +@opt_0operation_id +' '+''+char(10)--AND  A.OPERATION_ID = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --	      	var sql = "";
  --	      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --	      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")\r\n";
  --	      	}
  --	      	sql;
  --	      }

  --'
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '              ,A.ITEM_ID, A.ITEM_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602","find_ListData",param);
  --
  --}

  --'


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_LISTDATAFIX',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_FIND_LISTDATAFIX',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
