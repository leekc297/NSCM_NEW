CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON]
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
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON                                                                          **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0(Auto)                                                                     **/
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
/** 2021-02-15     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON'

  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0


  DECLARE @p_amend_instance nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max) = ''
  --DECLARE @p_amend_instance_lt nvarchar(max) = ''
  --DECLARE @p_param nvarchar(max) = ''
  --DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_amend_instance nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  --DECLARE @v_amend_instance_lt nvarchar(max)
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  --DECLARE @opt_0amend_instance nvarchar(max)
  --DECLARE @opt_1amend_instance nvarchar(max)

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = 'USER_ID' BEGIN
		SET @p_user_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'AMEND_INSTANCE' BEGIN
		SET @p_amend_instance =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END

  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_amend_instance ='''' + @p_amend_instance + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  --SET @v_amend_instance_lt ='''' + @p_amend_instance_lt + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  --SET @STRLEN = LEN(@p_amend_instance)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_0amend_instance = ''
  --END ELSE BEGIN
  --  SET @opt_0amend_instance = 'AND AMEND_UI_NAME = ' + @v_amend_instance+''
  --END
  --SET @STRLEN = LEN(@p_amend_instance)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1amend_instance = ''
  --END ELSE BEGIN
  --  SET @opt_1amend_instance = 'AND AMEND_UI_NAME = ' + @v_amend_instance+''
  --END


  -- xpcommoncond findAmendInstanceList_common  
  SET @v_dSql = ''
  SET @v_dSql += '	    SELECT A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER'+char(10)
  SET @v_dSql += '	           , B.ATTRIBUTE3 AS USE_WOW_STATUS'+char(10)
  SET @v_dSql += '	           , B.ATTRIBUTE1 AS CONFIRM_AREA'+char(10)
  SET @v_dSql += '	           , B.ATTRIBUTE2 AS IS_SAME_PLAN_ID'+char(10)
  SET @v_dSql += '	      FROM ('+char(10)
  SET @v_dSql += '            SELECT DISTINCT INSTANCE_ID'+char(10)
  SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  USER_ID ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --IF @p__save_auth='Y' BEGIN
	SET @v_dSql += '			AND    A.SAVE_FLAG = ''Y''' + char(10)
  --END
  --SET @v_dSql += '
  --{
  --	    		  var sql="";
  --
  --	    		  if($data._SAVE_AUTH == "Y")
  --	    		  {
  --	    		  		sql+="			AND    A.SAVE_FLAG = ''''Y'''' \r\n";
  --	    		  }
  --
  --	    		  sql;
  --			}

  --'
  SET @v_dSql += '	      ) A, SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '	      WHERE A.INSTANCE_ID      = B.SEGMENT1'+char(10)
  SET @v_dSql += '	      AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+char(10)
  SET @v_dSql += '	      AND   B.SEGMENT1 IN ('+char(10)
  SET @v_dSql += '	          SELECT INSTANCE_ID'+char(10)
  SET @v_dSql += '	          FROM FP_AMEND_UI_V'+char(10)
  SET @v_dSql += '	          WHERE 1=1'+char(10)
  --SET @v_dSql += ' ' +@opt_0amend_instance +' '+''+char(10)--AND AMEND_UI_NAME = #AMEND_INSTANCE#
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('AMEND_UI_NAME' , 'EQ', @p_amend_instance)) + char(10);
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --	            var sql="";
  --	            var sInst = $data.AMEND_INSTANCE_LT;
  --
  --	            if(sInst!="" && sInst!=null) sql+="AND AMEND_UI_NAME IN (" + sInst + ")";
  --
  --	            sql;
  --	          }

  --'
  SET @v_dSql += '	          AND USE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '	      )'+char(10)
  SET @v_dSql += '	     ORDER BY B.SORT_ORDER'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1  = $jdbc.queryList("xpcommoncond","findAmendInstanceList_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDAMENDINSTANCELIST_COMMON',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
