CREATE PROCEDURE [dbo].[PR_UI_FP00605_FINDLINECODE_LIST]
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
/** 프로그램 ID   : PR_UI_FP00605_FINDLINECODE_LIST                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00605_FINDLINECODE_LIST                                                                          **/
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
/** 2021-04-05     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00605_FINDLINECODE_LIST
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00605_FINDLINECODE_LIST'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_company_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_in_active nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_site_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_factory_lt nvarchar(max) = ''
  DECLARE @p_operation_lt nvarchar(max) = ''
  DECLARE @p_all_line nvarchar(max) = ''
  DECLARE @p_user_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_in_active nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_all_line nvarchar(max)
  DECLARE @v_user_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0company_id nvarchar(max)
  DECLARE @opt_1division_id nvarchar(max)
  DECLARE @opt_2site_id nvarchar(max)
  DECLARE @opt_3plant_id nvarchar(max)
  DECLARE @opt_4factory_id nvarchar(max)
  DECLARE @opt_5line_id nvarchar(max)
  DECLARE @opt_6operation_id nvarchar(max)
  DECLARE @opt_7company_id nvarchar(max)
  DECLARE @opt_8division_id nvarchar(max)
  DECLARE @opt_9site_id nvarchar(max)
  DECLARE @opt_10plant_id nvarchar(max)
  DECLARE @opt_11factory_id nvarchar(max)
  DECLARE @opt_12line_id nvarchar(max)
  DECLARE @opt_13operation_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'IN_ACTIVE' BEGIN
      SET @p_in_active =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_LT' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_LT' BEGIN
      SET @p_site_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_LT' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_LT' BEGIN
      SET @p_factory_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_LT' BEGIN
      SET @p_operation_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ALL_LINE' BEGIN
      SET @p_all_line =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'USER_LT' BEGIN
      SET @p_user_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_in_active ='''' + @p_in_active + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_all_line ='''' + @p_all_line + ''''
  SET @v_user_lt ='''' + @p_user_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0company_id = ''
  END ELSE BEGIN
    SET @opt_0company_id = 'AND    A.COMPANY_ID   = ' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1division_id = ''
  END ELSE BEGIN
    SET @opt_1division_id = 'AND    A.DIVISION_ID  = ' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'AND    A.SITE_ID      = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_plant_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3plant_id = ''
  END ELSE BEGIN
    SET @opt_3plant_id = 'AND    A.PLANT_ID     = ' + @v_plant_id+''
  END
  SET @STRLEN = LEN(@p_factory_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4factory_id = ''
  END ELSE BEGIN
    SET @opt_4factory_id = 'AND    A.FACTORY_ID   = ' + @v_factory_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5line_id = ''
  END ELSE BEGIN
    SET @opt_5line_id = 'AND    A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6operation_id = ''
  END ELSE BEGIN
    SET @opt_6operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7company_id = ''
  END ELSE BEGIN
    SET @opt_7company_id = 'AND    A.COMPANY_ID   = ' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_8division_id = ''
  END ELSE BEGIN
    SET @opt_8division_id = 'AND    A.DIVISION_ID  = ' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9site_id = ''
  END ELSE BEGIN
    SET @opt_9site_id = 'AND    A.SITE_ID      = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_plant_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_10plant_id = ''
  END ELSE BEGIN
    SET @opt_10plant_id = 'AND    A.PLANT_ID     = ' + @v_plant_id+''
  END
  SET @STRLEN = LEN(@p_factory_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_11factory_id = ''
  END ELSE BEGIN
    SET @opt_11factory_id = 'AND    A.FACTORY_ID   = ' + @v_factory_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_12line_id = ''
  END ELSE BEGIN
    SET @opt_12line_id = 'AND    A.LINE_ID      = ' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_13operation_id = ''
  END ELSE BEGIN
    SET @opt_13operation_id = 'AND    A.OPERATION_ID = ' + @v_operation_id+''
  END


  -- FP00605 findLineCode_List  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.LINE_ID AS CODE_ID'+char(10)
  SET @v_dSql += '           , ''('' + A.LINE_ID + '')'' + (CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END) AS CODE_NAME'+char(10)
  SET @v_dSql += '      FROM   SCM_LINE_M A(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE 1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      		var sql="";
  --
  --		  	if($data.IN_ACTIVE != "Y") {
  --		    	sql+="AND	A.ACTIVE_FLAG = ''''Y''''  \r\n";
  --		  	}
  --      	}

  --'
  SET @v_dSql += '      AND    EXISTS ('+char(10)
  SET @v_dSql += '			        	SELECT 1'+char(10)
  SET @v_dSql += '			        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			        	WHERE  A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '			        	AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '			        	AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '			        	AND    A.PLANT_ID	 = B.PLANT_ID'+char(10)
  SET @v_dSql += '			        	AND    A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  SET @v_dSql += '			        	AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --				      		var sql="";
  --
  --						  	if($data.IN_ACTIVE != "Y") {
  --						    	sql+="AND    A.LINE_ID 	 = B.LINE_ID  \r\n";
  --						  	}
  --				      	}

  --'
  SET @v_dSql += '			        	AND    B.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '			      	)'+char(10)
  SET @v_dSql += '      AND   EXISTS ('+char(10)
  SET @v_dSql += '          SELECT 1 FROM ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID'+char(10)
  SET @v_dSql += '              FROM  SCM_FACTORY_M A(NOLOCK)'+char(10)
  SET @v_dSql += '              INNER JOIN FP_INSTANCE_FACTORY_M B(NOLOCK)'+char(10)
  SET @v_dSql += '              ON    A.FACTORY_ID=B.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND   B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '              WHERE 1=1'+char(10)
  SET @v_dSql += '              AND   B.INSTANCE_ID ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '          ) C'+char(10)
  SET @v_dSql += '          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--AND    A.COMPANY_ID   = #COMPANY_ID#
  SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--AND    A.DIVISION_ID  = #DIVISION_ID#
  SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--AND    A.SITE_ID      = #SITE_ID#
  SET @v_dSql += ' ' +@opt_3plant_id +' '+''+char(10)--AND    A.PLANT_ID     = #PLANT_ID#
  SET @v_dSql += ' ' +@opt_4factory_id +' '+''+char(10)--AND    A.FACTORY_ID   = #FACTORY_ID#
  SET @v_dSql += ' ' +@opt_5line_id +' '+''+char(10)--AND    A.LINE_ID      = #LINE_ID#
  SET @v_dSql += ' ' +@opt_6operation_id +' '+''+char(10)--AND    A.OPERATION_ID = #OPERATION_ID#
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
  --      	var sql = "";
  --      	if($data.SITE_LT != null && $data.SITE_LT != ""){
  --      		sql+= "AND A.SITE_ID IN (" + $data.SITE_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --      		sql+= "AND A.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.OPERATION_LT != null && $data.OPERATION_LT != ""){
  --      		sql+= "AND A.OPERATION_ID IN (" + $data.OPERATION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql = "";
  --        var sInst = $data.INSTANCE_ID;
  --
  --        if(sInst != "" && sInst != null) {
  --          sql+="AND EXISTS ( SELECT  1 \r\n";
  --          sql+="             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)\r\n";
  --          sql+="   				   WHERE   LV1.LOOKUP_TYPE_CODE = ''''INSTANCE_ID''''\r\n";
  --          sql+="        		 AND     LV1.SEGMENT1         = ''''" + sInst + "''''\r\n";
  --          sql+="        		 AND     LV1.ACTIVE_FLAG      = ''''Y''''\r\n";
  --          sql+="        		 AND     LV1.ATTRIBUTE1       = ''''BUILDING''''\r\n";
  --          sql+="        		 UNION ALL\r\n";
  --          sql+="        		 SELECT  1 \r\n";
  --          sql+="             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),\r\n";
  --          sql+="        		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)\r\n";
  --          sql+="        		 WHERE   LV1.LOOKUP_TYPE_CODE = ''''INSTANCE_ID''''\r\n";
  --          sql+="        		 AND 	   LV2.LOOKUP_TYPE_CODE = ''''INSTANCE_PLANNING_GROUP''''\r\n";
  --          sql+="        		 AND     LV1.SEGMENT1         = LV2.SEGMENT1\r\n";
  --          sql+="        		 AND     LV1.SEGMENT1         = ''''" + sInst + "''''\r\n";
  --          sql+="        		 AND     LV1.ACTIVE_FLAG      = ''''Y''''\r\n";
  --          sql+="        		 AND     LV1.ATTRIBUTE1       = ''''PLAN GROUP''''\r\n";
  --          sql+="        		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) ) \r\n";
  --        }
  --
  --        sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sAllLine = $data.ALL_LINE;
  --        var sUserLt = $data.USER_LT;
  --
  --        if(sUserLt == "") {
  --          sUserLt = "''''''''";
  --        }
  --
  --        if(sAllLine != "Y") {
  --          sql+="AND A.LINE_ID IN (\r\n";
  --          sql+="    SELECT DISTINCT LINE_ID\r\n";
  --          sql+="    FROM   FP_USER_LINE_GROUP_M AA WITH(NOLOCK)\r\n";
  --          sql+="    WHERE  AA.INSTANCE_ID = ''''" + $data.INSTANCE_ID + "''''\r\n";
  --          sql+="    AND    AA.USER_ID IN (" + sUserLt + ")\r\n";
  --          sql+=")\r\n";
  --        }
  --
  --        sql;
  --      }

  --'
  SET @v_dSql += '      GROUP BY A.LINE_ID, A.LINE_NAME'+char(10)
  SET @v_dSql += '      ORDER BY A.LINE_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00605","findLineCode_List",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00605_FINDLINECODE_LIST',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00605_FINDLINECODE_LIST',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
