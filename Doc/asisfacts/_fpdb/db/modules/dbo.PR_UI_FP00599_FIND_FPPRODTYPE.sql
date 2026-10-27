CREATE PROCEDURE [dbo].[PR_UI_FP00599_FIND_FPPRODTYPE]
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
/** 프로그램 ID   : PR_UI_FP00599_FIND_FPPRODTYPE                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00599_FIND_FPPRODTYPE                                                                          **/
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
/** 2021-03-09     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FIND_FPPRODTYPE
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599_FIND_FPPRODTYPE'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  --DECLARE @p_param nvarchar(max) = ''
  --DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max) = ''
  DECLARE @p__non_auth nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_instance_id nvarchar(max) = ''


  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
    --  SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- FP00599 find_FPProdType   
  SET @v_dSql = ''
  SET @v_dSql += '  	SELECT  DISTINCT A.ATTRIBUTE2 AS CODE, A.ATTRIBUTE2 AS NAME' + char(10)
  SET @v_dSql += '		FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)' + char(10)
  SET @v_dSql += '		WHERE   A.LOOKUP_TYPE_CODE =''DIVISION_DEMAND_TYPE''' + char(10)
  SET @v_dSql += '		AND     A.ACTIVE_FLAG = ''Y''' + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SEGMENT1' , 'EQ', @p_division_id)) + char(10)
  IF @p_instance_id = 'KR_CELL' BEGIN
    SET @v_dSql += 'UNION ALL SELECT ''M/C'' AS CODE_ID, ''M/C'' AS CODE_NAME'  + char(10)
  END

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00599","find_FPProdType"  ,param);
  --
  --}

  --'
  --    <![CDATA[
		--SELECT  DISTINCT A.ATTRIBUTE2 AS CODE_ID, A.ATTRIBUTE2 AS CODE_NAME
		--FROM    SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
		--WHERE   A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
		--AND     A.ACTIVE_FLAG = 'Y'
		--{
	 --       var sql="";
	 --       var sDiv = $data.DIVISION_LT;
	 --       sql="AND    A.SEGMENT1 IN (" + sDiv + ")";
	 --       sql;
	 --   }
	 --   {
	 --       var sql = "";
	 --       var sMst = $data.INSTANCE_ID;
	        
	 --       if(sMst == "KR_CELL") {
	 --         sql = "UNION ALL SELECT 'M/C' AS CODE_ID, 'M/C' AS CODE_NAME \r\n";
	 --       }
        
  --      	sql;
  --    }
  --  ]]>


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_FPPRODTYPE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_FIND_FPPRODTYPE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
