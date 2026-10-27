CREATE PROCEDURE [dbo].[PR_UI_FP00461_FINDPLANTOPERATIONLIST]
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
/** 프로그램 ID   : PR_UI_FP00461_FINDPLANTOPERATIONLIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00461_FINDPLANTOPERATIONLIST                                                                          **/
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
/** 2021-05-26     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00461_FINDPLANTOPERATIONLIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00461_FINDPLANTOPERATIONLIST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1operation_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3operation_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_division_lt ='''' + @p_division_id + ''''
  SET @v_plant_lt ='''' + @p_plant_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1operation_id = ''
  END ELSE BEGIN
    SET @opt_1operation_id = 'AND    B.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3operation_id = ''
  END ELSE BEGIN
    SET @opt_3operation_id = 'AND    B.OPERATION_ID = ' + @v_operation_id+''
  END


  -- FP00461 findPlantOperationList  
  SET @v_dSql = ''
  SET @v_dSql += '							SELECT DISTINCT AA.COMPANY_ID, AA.DIVISION_ID, AA.SITE_ID, AA.PLANT_ID'+char(10)
  SET @v_dSql += '							FROM ('+char(10)
  SET @v_dSql += '										SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,  B.OPERATION_NAME FROM SCM_PLANT_M A(NOLOCK)'+char(10)
  SET @v_dSql += '										INNER JOIN SCM_OPERATION_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										ON  A.COMPANY_ID    = B.COMPANY_ID'+char(10)
  SET @v_dSql += '										AND A.DIVISION_ID   = B.DIVISION_ID'+char(10)
  SET @v_dSql += '										AND A.SITE_ID       = B.SITE_ID'+char(10)
  SET @v_dSql += '										AND B.INSTANCE_TYPE = ''P'''+char(10)
  SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  SET @v_dSql += ' ' +@opt_1operation_id +' '+''+char(10)--AND    B.OPERATION_ID = #OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
    SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
	  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10)
  --SET @v_dSql += '
  --{
  --											var sql = "";
  --											if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --												sql+= "AND A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --											}
  --											sql;
  --										}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --											var sql = "";
  --											if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --												sql+= "AND A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --											}
  --											sql;
  --										}

  --'
  SET @v_dSql += '							) AA'+char(10)
  SET @v_dSql += '							WHERE EXISTS (SELECT 1 FROM SCM_ITEM_LINE_ASSIGN_M A2'+char(10)
  SET @v_dSql += '							              WHERE A2.COMPANY_ID=AA.COMPANY_ID'+char(10)
  SET @v_dSql += '							              AND A2.DIVISION_ID=AA.DIVISION_ID'+char(10)
  SET @v_dSql += '							              AND A2.SITE_ID=AA.SITE_ID'+char(10)
  SET @v_dSql += '							              AND A2.PLANT_ID=AA.PLANT_ID'+char(10)
  SET @v_dSql += '							              --AND A2.OPERATION_ID=AA.OPERATION_ID'+char(10)
  SET @v_dSql += '							            )'+char(10)
  SET @v_dSql += '						 	AND NOT EXISTS ('+char(10)
  SET @v_dSql += '                              SELECT 1'+char(10)
  SET @v_dSql += '                              FROM SCM_PACK_WORKER_LIMIT_M C (NOLOCK)'+char(10)
  SET @v_dSql += '                              WHERE 1=1'+char(10)
  SET @v_dSql += '                              AND AA.COMPANY_ID = C.COMPANY_ID'+char(10)
  SET @v_dSql += '                							AND AA.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '                							AND AA.SITE_ID = C.SITE_ID'+char(10)
  SET @v_dSql += '                							AND AA.PLANT_ID = C.PLANT_ID'+char(10)
  SET @v_dSql += '                							AND C.WORK_DATE BETWEEN'+char(10)
  SET @v_dSql += '' + @v_bucket_from+''+char(10)
  SET @v_dSql += ' AND'+char(10)
  SET @v_dSql += '' + @v_bucket_to+''+char(10)
  SET @v_dSql += '                          )'+char(10)
  SET @v_dSql += '              AND    EXISTS ('+char(10)
  SET @v_dSql += '                    SELECT 1'+char(10)
  SET @v_dSql += '                    FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                    WHERE  AA.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '                    AND    AA.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '                    AND    AA.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '                    AND    AA.PLANT_ID    = B.PLANT_ID'+char(10)
  SET @v_dSql += '                    AND    B.SAVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '                    AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '              )'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --         $data.querySet1 = $jdbc.queryList("FP00461","findPlantOperationList",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00461_FINDPLANTOPERATIONLIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00461_FINDPLANTOPERATIONLIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
