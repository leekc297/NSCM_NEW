CREATE PROCEDURE [dbo].[PR_UI_FP00130_FIND_FP00130_SUB_ALL]
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
/** 프로그램 ID   : PR_UI_FP00130_FIND_FP00130_SUB_ALL                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00130_FIND_FP00130_SUB_ALL                                                                          **/
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
/** 2021-06-30     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00130_FIND_FP00130_SUB_ALL
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00130_FIND_FP00130_SUB_ALL'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_company_id nvarchar(max) = ''
  --DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  --DECLARE @p_plant_id nvarchar(max) = ''
  --DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_resource_id nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_company_id nvarchar(max)
  --DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  --DECLARE @v_plant_id nvarchar(max)
  --DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_resource_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0company_id nvarchar(max)
  --DECLARE @opt_1division_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  --DECLARE @opt_3plant_id nvarchar(max)
  --DECLARE @opt_4factory_id nvarchar(max)
  DECLARE @opt_5line_id nvarchar(max)
  DECLARE @opt_6operation_id nvarchar(max)
  DECLARE @opt_7resource_id nvarchar(max)
  DECLARE @opt_8company_id nvarchar(max)
  --DECLARE @opt_9division_id nvarchar(max)
  DECLARE @opt_10site_id nvarchar(max)
  --DECLARE @opt_11plant_id nvarchar(max)
  --DECLARE @opt_12factory_id nvarchar(max)
  DECLARE @opt_13line_id nvarchar(max)
  DECLARE @opt_14operation_id nvarchar(max)
  DECLARE @opt_15resource_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
    --  SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
    --  SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
    --  SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'RESOURCE_ID' BEGIN
      SET @p_resource_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_company_id ='''' + @p_company_id + ''''
  --SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  --SET @v_plant_id ='''' + @p_plant_id + ''''
  --SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_resource_id ='''' + @p_resource_id + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0company_id = ''
  END ELSE BEGIN
    SET @opt_0company_id = 'and    a.company_id=' + @v_company_id+''
  END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1division_id = ''
  --END ELSE BEGIN
  --  SET @opt_1division_id = 'and    a.division_id=' + @v_division_id+''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'and    a.site_id=' + @v_site_id+''
  END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_3plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_3plant_id = 'and    a.plant_id=' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_4factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_4factory_id = 'and    a.factory_id=' + @v_factory_id+''
  --END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5line_id = ''
  END ELSE BEGIN
    SET @opt_5line_id = 'and    a.line_id=' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_id = ''
  END ELSE BEGIN
    SET @opt_6operation_id = 'and    a.operation_id=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_resource_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7resource_id = ''
  END ELSE BEGIN
    SET @opt_7resource_id = 'and    a.equipment_id = ' + @v_resource_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8company_id = ''
  END ELSE BEGIN
    SET @opt_8company_id = 'and    a.company_id=' + @v_company_id+''
  END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_9division_id = ''
  --END ELSE BEGIN
  --  SET @opt_9division_id = 'and    a.division_id=' + @v_division_id+''
  --END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10site_id = ''
  END ELSE BEGIN
    SET @opt_10site_id = 'and    a.site_id=' + @v_site_id+''
  END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_11plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_11plant_id = 'and    a.plant_id=' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_12factory_id = 'and    a.factory_id=' + @v_factory_id+''
  --END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_13line_id = ''
  END ELSE BEGIN
    SET @opt_13line_id = 'and    b.line_id=' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_14operation_id = ''
  END ELSE BEGIN
    SET @opt_14operation_id = 'and    b.operation_id=' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_resource_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_15resource_id = ''
  END ELSE BEGIN
    SET @opt_15resource_id = 'and    a.equipment_id = ' + @v_resource_id+''
  END


  -- FP00130 find_FP00130_Sub_All  
  SET @v_dSql = ''
  SET @v_dSql += '      select a.company_id,a.division_id,a.site_id,a.plant_id,a.factory_id'+char(10)
  SET @v_dSql += '            ,a.equipment_id, b.equipment_name'+char(10)
  SET @v_dSql += '            ,convert(varchar(8), a.start_time, 112) as start_time'+char(10)
  SET @v_dSql += '            ,convert(varchar(8), a.end_time, 112) as end_time'+char(10)
  SET @v_dSql += '            ,a.active_flag'+char(10)
  SET @v_dSql += '      from   scm_equipment_except_m a(NOLOCK), scm_equipment_m b(NOLOCK)'+char(10)
  SET @v_dSql += '      where  a.company_id   = b.company_id'+char(10)
  SET @v_dSql += '      and    a.division_id  = b.division_id'+char(10)
  SET @v_dSql += '      and    a.site_id      = b.site_id'+char(10)
  SET @v_dSql += '      and    a.plant_id     = b.plant_id'+char(10)
  SET @v_dSql += '      and    a.factory_id   = b.factory_id'+char(10)
  SET @v_dSql += '      and    a.equipment_id = b.equipment_id'+char(10)
  SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--and    a.company_id=#COMPANY_ID#
  --SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--and    a.division_id=#DIVISION_ID#
  SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--and    a.site_id=#SITE_ID#
  --SET @v_dSql += ' ' +@opt_3plant_id +' '+''+char(10)--and    a.plant_id=#PLANT_ID#
  --SET @v_dSql += ' ' +@opt_4factory_id +' '+''+char(10)--and    a.factory_id=#FACTORY_ID#
  SET @v_dSql += ' ' +@opt_5line_id +' '+''+char(10)--and    a.line_id=#LINE_ID#
  SET @v_dSql += ' ' +@opt_6operation_id +' '+''+char(10)--and    a.operation_id=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_7resource_id +' '+''+char(10)--and    a.equipment_id = #RESOURCE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --      		sql+= "AND    A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      order by a.equipment_id, a.start_time'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00130","find_FP00130_Sub_All",param);
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
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
