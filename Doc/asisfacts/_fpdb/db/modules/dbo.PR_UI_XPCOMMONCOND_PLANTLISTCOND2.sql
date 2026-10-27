CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_PLANTLISTCOND2]
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
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_PLANTLISTCOND                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_PLANTLISTCOND                                                                          **/
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
  EXEC PR_UI_XPCOMMONCOND_PLANTLISTCOND
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_PLANTLISTCOND'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_company_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p__non_auth nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max) = ''
  --DECLARE @p_instance_lt nvarchar(max) = ''
  --DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  --DECLARE @p_param nvarchar(max) = ''
  --DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v__non_auth nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  --DECLARE @v_instance_lt nvarchar(max)
  --DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  --DECLARE @opt_0instance_id nvarchar(max)
  --DECLARE @opt_1company_id nvarchar(max)
  --DECLARE @opt_2division_id nvarchar(max)
  --DECLARE @opt_3site_id nvarchar(max)
  --DECLARE @opt_4instance_id nvarchar(max)
  --DECLARE @opt_5company_id nvarchar(max)
  --DECLARE @opt_6division_id nvarchar(max)
  --DECLARE @opt_7site_id nvarchar(max)
  --DECLARE @opt_8instance_id nvarchar(max)
  --DECLARE @opt_9company_id nvarchar(max)
  --DECLARE @opt_10division_id nvarchar(max)
  --DECLARE @opt_11site_id nvarchar(max)
  --DECLARE @opt_12instance_id nvarchar(max)
  --DECLARE @opt_13company_id nvarchar(max)
  --DECLARE @opt_14division_id nvarchar(max)
  --DECLARE @opt_15site_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
    --  SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = '_SAVE_AUTH' BEGIN
      --SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'INSTANCE_LT' BEGIN
    --  SET @p_instance_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'DIVISION_LT' BEGIN
    --  SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PARAM' BEGIN
    --  SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
    --  SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v__non_auth ='''' + @p__non_auth + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  --SET @v_instance_lt ='''' + @p_instance_lt + ''''
  --SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_0instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_0instance_id = 'AND   B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1company_id = ''
  --END ELSE BEGIN
  --  SET @opt_1company_id = 'AND A.COMPANY_ID = ' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_2division_id = ''
  --END ELSE BEGIN
  --  SET @opt_2division_id = 'AND A.DIVISION_ID = ' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_3site_id = ''
  --END ELSE BEGIN
  --  SET @opt_3site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_4instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_4instance_id = 'AND   B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_5company_id = ''
  --END ELSE BEGIN
  --  SET @opt_5company_id = 'AND A.COMPANY_ID = ' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_6division_id = ''
  --END ELSE BEGIN
  --  SET @opt_6division_id = 'AND A.DIVISION_ID = ' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7site_id = ''
  --END ELSE BEGIN
  --  SET @opt_7site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_8instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_8instance_id = 'AND   B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_9company_id = ''
  --END ELSE BEGIN
  --  SET @opt_9company_id = 'AND A.COMPANY_ID = ' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_10division_id = ''
  --END ELSE BEGIN
  --  SET @opt_10division_id = 'AND A.DIVISION_ID = ' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_11site_id = ''
  --END ELSE BEGIN
  --  SET @opt_11site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_12instance_id = 'AND   B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_13company_id = ''
  --END ELSE BEGIN
  --  SET @opt_13company_id = 'AND A.COMPANY_ID = ' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_14division_id = ''
  --END ELSE BEGIN
  --  SET @opt_14division_id = 'AND A.DIVISION_ID = ' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_15site_id = ''
  --END ELSE BEGIN
  --  SET @opt_15site_id = 'AND A.SITE_ID = ' + @v_site_id+''
  --END


  -- xpcommoncond findPlantList_common  
  SET @v_dSql = ''
  SET @v_dSql += '  		SELECT PLANT_ID as code_id,'+char(10)
  SET @v_dSql += '               ''('' + PLANT_ID + '')'' + case when PLANT_NAME = '''' or PLANT_NAME is null then PLANT_ID else PLANT_NAME end as code_name'+char(10)
  SET @v_dSql += '  		FROM  SCM_PLANT_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '  		WHERE 1 = 1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF @p__non_auth = 'Y' BEGIN
    SET @v_dSql = @v_dSql
  END ELSE	
  BEGIN
	SET @v_dSql ='AND  EXISTS ( '+char(10)
	SET @v_dSql ='  	SELECT 1 '+char(10)
	SET @v_dSql ='  	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) '+char(10)
	SET @v_dSql ='  	WHERE  A.COMPANY_ID  = B.COMPANY_ID '+char(10)
	SET @v_dSql ='  	AND    A.DIVISION_ID = B.DIVISION_ID '+char(10)
	SET @v_dSql ='  	AND    A.SITE_ID     = B.SITE_ID '+char(10)
	SET @v_dSql ='  	AND    A.PLANT_ID    = B.PLANT_ID '+char(10)
	SET @v_dSql ='  	AND    B.USER_ID     = ''' + @p_user_id + ''' '+char(10)
	IF @p__save_auth = 'Y' BEGIN
	  SET @v_dSql =' 			AND    B.SAVE_FLAG = ''Y'''+char(10)
	END
	SET @v_dSql =') '+char(10)
  END
  --SET @v_dSql += '
  --{
  --  		  var sql="";
  --
  --  		  if($data._NON_AUTH == "Y") {
  --  		  } else {
  --  		    sql+="AND  EXISTS ( \r\n";
  --  		    sql+="  	SELECT 1 \r\n";
  --  		    sql+="  	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) \r\n";
  --  		    sql+="  	WHERE  A.COMPANY_ID  = B.COMPANY_ID \r\n";
  --  		    sql+="  	AND    A.DIVISION_ID = B.DIVISION_ID \r\n";
  --  		    sql+="  	AND    A.SITE_ID     = B.SITE_ID \r\n";
  --  		    sql+="  	AND    A.PLANT_ID    = B.PLANT_ID \r\n";
  --  		    sql+="  	AND    B.USER_ID     = ''''" + $data.USER_ID + "'''' \r\n";
  --  		    if($data._SAVE_AUTH == "Y")
  --		    {
  --		  	    sql+="			AND    B.SAVE_FLAG = ''''Y'''' \r\n";
  --		    }
  --  		    sql+=") \r\n";
  --  		  }
  --
  --  		  sql;
  --  		}

  --'
  SET @v_dSql += '  		AND   EXISTS ('+char(10)
  SET @v_dSql += '  		        SELECT 1 FROM ('+char(10)
  SET @v_dSql += '  		          SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID'+char(10)
  SET @v_dSql += '    						FROM SCM_FACTORY_M A WITH(NOLOCK) INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '    						ON  A.FACTORY_ID=B.FACTORY_ID'+char(10)
  SET @v_dSql += '    						AND B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '    						WHERE 1=1'+char(10)
  SET @v_dSql += '    						AND   A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
  --SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND   B.INSTANCE_ID = #INSTANCE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --								  var sql = "";
  --								  var sInst = $data.INSTANCE_LT;
  --
  --								  if(sInst!=null && sInst!="") {
  --								    sql+="AND    B.INSTANCE_ID IN (" + sInst + ")";
  --								  }
  --
  --								  sql;
  --								}

  --'
  SET @v_dSql += '  						) C'+char(10)
  SET @v_dSql += '  						WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID'+char(10)
  SET @v_dSql += '  					)'+char(10)
  --SET @v_dSql += ' ' +@opt_1company_id +' '+''+char(10)--AND A.COMPANY_ID = #COMPANY_ID#
  --SET @v_dSql += ' ' +@opt_2division_id +' '+''+char(10)--AND A.DIVISION_ID = #DIVISION_ID#
  --SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND A.SITE_ID = #SITE_ID#
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_company_id)) + char(10);
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
    ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql = "";
  --        if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --          sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --        }
  --        sql;
  --      }

  --'
  SET @v_dSql += '  		GROUP BY PLANT_ID, PLANT_NAME'+char(10)
  SET @v_dSql += '  		ORDER BY PLANT_ID ASC'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --          var param = $data.param;
  --          $data.querySet1 = $jdbc.queryList("xpcommoncond","findPlantList_common",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --         $data.querySet1 = $jdbc.queryList("xpcommoncond","findPlantList_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_PLANTLISTCOND',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_PLANTLISTCOND',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
