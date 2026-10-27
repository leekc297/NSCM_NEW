CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE]
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
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE                                                                          **/
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
/** 2021-04-13     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_queryset2 nvarchar(max) = ''


  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)
  DECLARE @v_queryset2 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0division_id nvarchar(max)
  DECLARE @opt_1division_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET2' BEGIN
      SET @p_queryset2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''
  SET @v_queryset2 ='''' + @p_queryset2 + ''''

  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0division_id = ''
  END ELSE BEGIN
    SET @opt_0division_id = 'AND	 A.SEGMENT1 = ' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1division_id = ''
  END ELSE BEGIN
    SET @opt_1division_id = 'AND	 A.SEGMENT1 = ' + @v_division_id+''
  END


  -- xpcommoncond findLookUpCode_ProdType  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT DISTINCT A.ATTRIBUTE2 AS CODE_ID, A.SEGMENT2 AS CODE_NAME, A.SORT_ORDER'+char(10)
  SET @v_dSql += '      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  A.LOOKUP_TYPE_CODE = ''DIVISION_DEMAND_TYPE'''+char(10)
  SET @v_dSql += '      AND    A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0division_id +' '+''+char(10)--AND	 A.SEGMENT1 = #DIVISION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p_instance_id = 'KR_CELL' BEGIN
  SET @v_dSql += 'UNION ALL SELECT ''M/C'' AS CODE_ID, ''M/C'' AS CODE_NAME, ''999'' AS SORT_ORDER '+char(10)
  END
  --SET @v_dSql += '
  --{
  --	        var sql = "";
  --	        var sMst = $data.INSTANCE_ID;
  --
  --	        if(sMst == "KR_CELL") {
  --	          sql = "UNION ALL SELECT ''''M/C'''' AS CODE_ID, ''''M/C'''' AS CODE_NAME, ''''999'''' AS SORT_ORDER \r\n";
  --	        }
  --
  --        	sql;
  --      }

  --'
  SET @v_dSql += '      ORDER BY A.SORT_ORDER'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommoncond","findLookUpCode_ProdType", param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDLOOKUPCODE_PRODTYPE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
