CREATE PROCEDURE [dbo].[PR_UI_FP09599_FINDOPERATIONCODE_COMMON]
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
/** 프로그램 ID   : PR_UI_FP09599_FINDOPERATIONCODE_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP09599_FINDOPERATIONCODE_COMMON                                                                          **/
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
  EXEC PR_UI_FP09599_FINDOPERATIONCODE_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP09599_FINDOPERATIONCODE_COMMON'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_amend_main_flag nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max)=''
  DECLARE @p__non_auth nvarchar(max)=''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v__non_auth nvarchar(max)

  DECLARE @v_amend_main_flag nvarchar(max)


  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  --DECLARE @opt_0site_id nvarchar(max)
  --DECLARE @opt_1site_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_LT' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'AMEND_MAIN_FLAG' BEGIN
      SET @p_amend_main_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_amend_main_flag ='''' + @p_amend_main_flag + ''''

  -- FP09599 findOperationCode_common  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT DISTINCT A.OPERATION_ID AS CODE, ''('' + A.OPERATION_ID + '')'' + B.OPERATION_NAME AS NAME'+char(10)
  SET @v_dSql += '           , A.AMEND_MAIN_FLAG'+char(10)
  SET @v_dSql += '      FROM   FP_INSTANCE_OPERATION_V A, ('+char(10)
  SET @v_dSql += '          SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID'+char(10)
  SET @v_dSql += '	        FROM TH_UIS_USER_FACTORY_RELATE A, TH_UIS_ROLE_FACTORY_RELATE B'+char(10)
  SET @v_dSql += '	        WHERE A.USER_ID ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '	        AND   A.ROLE_ID = B.ROLE_ID'+char(10)
  SET @v_dSql += '	        AND   A.USE_AT_FLAG = ''Y'''+char(10)
  SET @v_dSql += '	        AND   B.USE_AT_FLAG = ''Y'''+char(10)
  SET @v_dSql += '	        GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID'+char(10)
  SET @v_dSql += '			) AA'+char(10)
  SET @v_dSql += '			, SCM_OPERATION_M B'+char(10)
  SET @v_dSql += '      WHERE  A.COMPANY_ID   = AA.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID  = AA.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID      = AA.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND  A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND  A.SITE_ID = #SITE_ID#
  SET @v_dSql += '      AND   A.AMEND_FLAG = ''Y'''+char(10)
  IF @p_amend_main_flag = 'N' BEGIN
    SET @v_dSql += '      AND   A.AMEND_MAIN_FLAG = ''Y'''+char(10)
  END
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sFlg = $data.AMEND_MAIN_FLAG;
  --
  --        if(sFlg==''''N'''') {
  --          sql+="AND   A.AMEND_MAIN_FLAG = ''''Y''''\r\n";
  --        }
  --
  --        sql;
  --      }

  --'
  SET @v_dSql += '      ORDER BY A.OPERATION_ID DESC'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP09599","findOperationCode_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP09599_FINDOPERATIONCODE_COMMON',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP09599_FINDOPERATIONCODE_COMMON',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
