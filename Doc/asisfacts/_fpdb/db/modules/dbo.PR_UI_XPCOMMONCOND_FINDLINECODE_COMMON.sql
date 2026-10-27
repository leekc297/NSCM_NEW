CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_instance_id nvarchar(max) = '',
  @p_company_id nvarchar(max) = '',
  @p_division_id nvarchar(max) = '',
  @p_site_id nvarchar(max) = '',
  @p_plant_id nvarchar(max) = '',
  @p_factory_id nvarchar(max) = '',
  @p_line_id nvarchar(max) = '',
  @p_operation_id nvarchar(max) = '',
  @p__save_auth nvarchar(max) = '',
  @p__non_auth nvarchar(max) = '',
  @p_division_lt nvarchar(max) = '',
  @p_site_lt nvarchar(max) = '',
  @p_plant_lt nvarchar(max) = '',
  @p_factory_lt nvarchar(max) = '',
  @p_operation_lt nvarchar(max) = '',
  @p_amend_flag nvarchar(max) = '',
  --@p_param nvarchar(max) = '',
  --@p_queryset1 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON                                                                          **/
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
  EXEC PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON'
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_operation_lt nvarchar(max)
  DECLARE @v_amend_flag nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0instance_id nvarchar(max)
  DECLARE @opt_1company_id nvarchar(max)
  DECLARE @opt_2division_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4plant_id nvarchar(max)
  DECLARE @opt_5factory_id nvarchar(max)
  DECLARE @opt_6line_id nvarchar(max)
  DECLARE @opt_7operation_id nvarchar(max)
  --DECLARE @opt_8instance_id nvarchar(max)
  --DECLARE @opt_9company_id nvarchar(max)
  --DECLARE @opt_10division_id nvarchar(max)
  --DECLARE @opt_11site_id nvarchar(max)
  --DECLARE @opt_12plant_id nvarchar(max)
  --DECLARE @opt_13factory_id nvarchar(max)
  --DECLARE @opt_14line_id nvarchar(max)
  --DECLARE @opt_15operation_id nvarchar(max)

  --Optional Parameter Part END

  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  SET @v_operation_lt ='''' + @p_operation_lt + ''''
  SET @v_amend_flag ='''' + @p_amend_flag + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0instance_id = ''
  END ELSE BEGIN
    SET @opt_0instance_id = 'AND B.INSTANCE_ID = ' + @v_instance_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1company_id = ''
  END ELSE BEGIN
    SET @opt_1company_id = 'and    A.COMPANY_ID=' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2division_id = ''
  END ELSE BEGIN
    SET @opt_2division_id = 'and    A.DIVISION_ID=' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'and    A.SITE_ID=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_plant_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4plant_id = ''
  END ELSE BEGIN
    SET @opt_4plant_id = 'AND    A.PLANT_ID = ' + @v_plant_id+''
  END
  SET @STRLEN = LEN(@p_factory_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5factory_id = ''
  END ELSE BEGIN
    SET @opt_5factory_id = 'and    A.FACTORY_ID=' + @v_factory_id+''
  END
  SET @STRLEN = LEN(@p_line_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6line_id = ''
  END ELSE BEGIN
    SET @opt_6line_id = 'and    A.LINE_ID=' + @v_line_id+''
  END
  SET @STRLEN = LEN(@p_operation_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7operation_id = ''
  END ELSE BEGIN
    SET @opt_7operation_id = 'and    A.OPERATION_ID=' + @v_operation_id+''
  END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_8instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_8instance_id = 'AND B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_9company_id = ''
  --END ELSE BEGIN
  --  SET @opt_9company_id = 'and    A.COMPANY_ID=' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_10division_id = ''
  --END ELSE BEGIN
  --  SET @opt_10division_id = 'and    A.DIVISION_ID=' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_11site_id = ''
  --END ELSE BEGIN
  --  SET @opt_11site_id = 'and    A.SITE_ID=' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_12plant_id = 'AND    A.PLANT_ID = ' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_13factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_13factory_id = 'and    A.FACTORY_ID=' + @v_factory_id+''
  --END
  --SET @STRLEN = LEN(@p_line_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_14line_id = ''
  --END ELSE BEGIN
  --  SET @opt_14line_id = 'and    A.LINE_ID=' + @v_line_id+''
  --END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_15operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_15operation_id = 'and    A.OPERATION_ID=' + @v_operation_id+''
  --END


  -- xpcommoncond findLineCode_common  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.LINE_ID AS CODE'+char(10)
  SET @v_dSql += '           , ''('' + A.LINE_ID + '')'' + CASE WHEN A.LINE_NAME = '''' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END AS NAME'+char(10)
  SET @v_dSql += '      FROM   SCM_LINE_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  EXISTS ('+char(10)
  SET @v_dSql += '        	SELECT 1'+char(10)
  SET @v_dSql += '        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	WHERE  A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND    A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '        	AND    A.PLANT_ID       = B.PLANT_ID'+char(10)
  SET @v_dSql += '        	AND    A.FACTORY_ID     = B.FACTORY_ID'+char(10)
  SET @v_dSql += '        	AND    A.OPERATION_ID   = B.OPERATION_ID'+char(10)
  SET @v_dSql += '        	AND    A.LINE_ID        = B.LINE_ID'+char(10)
  SET @v_dSql += '        	AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '        	AND    B.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  IF @p__save_auth = 'Y' BEGIN
    SET @v_dSql +='			AND    B.SAVE_FLAG = ''Y'' ' + char(10)
  END

  --SET @v_dSql += '
  --{
  --	    		  var sql="";
  --
  --	    		  if($data._SAVE_AUTH == "Y")
  --	    		  {
  --	    		  		sql+="			AND    B.SAVE_FLAG = ''''Y'''' \r\n";
  --	    		  }
  --
  --	    		  sql;
  --			}

  --'
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '  	  AND   A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      AND   EXISTS ('+char(10)
  SET @v_dSql += '            SELECT 1 FROM ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID'+char(10)
  SET @v_dSql += '              FROM  SCM_FACTORY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON    A.FACTORY_ID  = B.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND   B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '              WHERE A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND B.INSTANCE_ID = #INSTANCE_ID#
  SET @v_dSql += '            ) C'+char(10)
  SET @v_dSql += '            WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += ' ' +@opt_1company_id +' '+''+char(10)--and    A.COMPANY_ID=#COMPANY_ID#
  SET @v_dSql += ' ' +@opt_2division_id +' '+''+char(10)--and    A.DIVISION_ID=#DIVISION_ID#
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--and    A.SITE_ID=#SITE_ID#
  SET @v_dSql += ' ' +@opt_4plant_id +' '+''+char(10)--AND    A.PLANT_ID = #PLANT_ID#
  SET @v_dSql += ' ' +@opt_5factory_id +' '+''+char(10)--and    A.FACTORY_ID=#FACTORY_ID#
  SET @v_dSql += ' ' +@opt_6line_id +' '+''+char(10)--and    A.LINE_ID=#LINE_ID#
  SET @v_dSql += ' ' +@opt_7operation_id +' '+''+char(10)--and    A.OPERATION_ID=#OPERATION_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
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
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_lt)) + char(10)
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
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
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
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
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
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_lt)) + char(10)
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
  IF isnull(@p_amend_flag,'') <> '' 
  BEGIN
	  SET @v_dSql += '          AND EXISTS ('+ char(10)
	  SET @v_dSql += '            SELECT 1 FROM SCM_OPERATION_M OP'+ char(10)
	  SET @v_dSql += '            WHERE  A.COMPANY_ID   = OP.COMPANY_ID'+ char(10)
	  SET @v_dSql += '            AND    A.DIVISION_ID  = OP.DIVISION_ID'+ char(10)
	  SET @v_dSql += '            AND    A.SITE_ID      = OP.SITE_I'+ char(10)
	  SET @v_dSql += '            AND    A.OPERATION_ID = OP.OPERATION_ID'+ char(10)
	  SET @v_dSql += '            AND    OP.AMEND_FLAG  = ''Y'''+ char(10)
	  SET @v_dSql += '          )'+ char(10)
  END
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	var sAmend = $data.AMEND_FLAG;
  --
  --      	if(sAmend != null && sAmend != "") {
  --            sql+="          AND EXISTS (\r\n";
  --            sql+="            SELECT 1 FROM SCM_OPERATION_M OP\r\n";
  --            sql+="            WHERE  A.COMPANY_ID   = OP.COMPANY_ID\r\n";
  --            sql+="            AND    A.DIVISION_ID  = OP.DIVISION_ID\r\n";
  --            sql+="            AND    A.SITE_ID      = OP.SITE_ID\r\n";
  --            sql+="            AND    A.OPERATION_ID = OP.OPERATION_ID\r\n";
  --            sql+="            AND    OP.AMEND_FLAG  = ''''Y''''\r\n";
  --          sql+="            )";
  --      	}
  --
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  IF isnull(@p_instance_id,'') <> '' 
  BEGIN
     SET @v_dSql += 'AND EXISTS ( SELECT  1 '+ char(10)
    SET @v_dSql += '             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK)'+ char(10)
    SET @v_dSql += '   				   WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+ char(10)
    SET @v_dSql += '        		 AND     LV1.SEGMENT1         = ''' + @p_instance_id +''''+ char(10)
    SET @v_dSql += '        		 AND     LV1.ACTIVE_FLAG      = ''Y'''+ char(10)
    SET @v_dSql += '        		 AND     LV1.ATTRIBUTE1       = ''BUILDING'''+ char(10)
    SET @v_dSql += '        		 UNION ALL'+ char(10)
    SET @v_dSql += '        		 SELECT  1 '+ char(10)
    SET @v_dSql += '             FROM    SCM_SYS_LOOKUP_VALUE LV1 WITH(NOLOCK),'+ char(10)
    SET @v_dSql += '        		         SCM_SYS_LOOKUP_VALUE LV2 WITH(NOLOCK)'+ char(10)
    SET @v_dSql += '        		 WHERE   LV1.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+ char(10)
    SET @v_dSql += '        		 AND 	   LV2.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+ char(10)
    SET @v_dSql += '        		 AND     LV1.SEGMENT1         = LV2.SEGMENT1'+ char(10)
    SET @v_dSql += '        		 AND     LV1.SEGMENT1         = ''' + @p_instance_id + ''''+ char(10)
    SET @v_dSql += '        		 AND     LV1.ACTIVE_FLAG      = ''Y'''+ char(10)
    SET @v_dSql += '        		 AND     LV1.ATTRIBUTE1       = ''PLAN GROUP'''+ char(10)
    SET @v_dSql += '        		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )'+ char(10)
  END
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
  --          sql+="        		 AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) )\r\n";
  --        }
  --
  --        sql;
  --      }

  --'
  SET @v_dSql += '      GROUP BY a.LINE_ID, a.LINE_NAME'+char(10)
  SET @v_dSql += '      ORDER BY A.LINE_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommoncond","findLineCode_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDLINECODE_COMMON',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
