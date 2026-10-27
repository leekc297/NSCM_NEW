CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_company_id nvarchar(max) = '',
  @p_division_id nvarchar(max) = '',
  @p_site_id nvarchar(max) = '',
  @p_plant_id nvarchar(max) = '',
  @p_factory_id nvarchar(max) = '',
  @p_line_id nvarchar(max) = '',
  @p_operation_id nvarchar(max) = '',
  @p_equipment_id nvarchar(max) = '',
  @p__save_auth nvarchar(max) = '',
  @p__non_auth nvarchar(max) = '',
  @p_division_lt nvarchar(max) = '',
  @p_site_lt nvarchar(max) = '',
  @p_plant_lt nvarchar(max) = '',
  @p_factory_lt nvarchar(max) = '',
  --@p_param nvarchar(max) = '',
  --@p_queryset1 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON                                                                          **/
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
  EXEC PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON'
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_equipment_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
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
  DECLARE @opt_7equipment_id nvarchar(max)
  --DECLARE @opt_8company_id nvarchar(max)
  --DECLARE @opt_9division_id nvarchar(max)
  --DECLARE @opt_10site_id nvarchar(max)
  --DECLARE @opt_11plant_id nvarchar(max)
  --DECLARE @opt_12factory_id nvarchar(max)
  --DECLARE @opt_13line_id nvarchar(max)
  --DECLARE @opt_14operation_id nvarchar(max)
  --DECLARE @opt_15equipment_id nvarchar(max)

  --Optional Parameter Part END

  
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_equipment_id ='''' + @p_equipment_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_factory_lt ='''' + @p_factory_lt + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0company_id = ''
  END ELSE BEGIN
    SET @opt_0company_id = 'and    a.company_id=' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1division_id = ''
  END ELSE BEGIN
    SET @opt_1division_id = 'and    a.division_id=' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2site_id = ''
  END ELSE BEGIN
    SET @opt_2site_id = 'and    a.site_id=' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_plant_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3plant_id = ''
  END ELSE BEGIN
    SET @opt_3plant_id = 'AND    a.PLANT_ID = ' + @v_plant_id+''
  END
  SET @STRLEN = LEN(@p_factory_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4factory_id = ''
  END ELSE BEGIN
    SET @opt_4factory_id = 'and    a.factory_id=' + @v_factory_id+''
  END
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
  SET @STRLEN = LEN(@p_equipment_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7equipment_id = ''
  END ELSE BEGIN
    SET @opt_7equipment_id = 'and    a.equipment_id=' + @v_equipment_id+''
  END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_8company_id = ''
  --END ELSE BEGIN
  --  SET @opt_8company_id = 'and    a.company_id=' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_9division_id = ''
  --END ELSE BEGIN
  --  SET @opt_9division_id = 'and    a.division_id=' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_10site_id = ''
  --END ELSE BEGIN
  --  SET @opt_10site_id = 'and    a.site_id=' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_11plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_11plant_id = 'AND    a.PLANT_ID = ' + @v_plant_id+''
  --END
  --SET @STRLEN = LEN(@p_factory_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_12factory_id = ''
  --END ELSE BEGIN
  --  SET @opt_12factory_id = 'and    a.factory_id=' + @v_factory_id+''
  --END
  --SET @STRLEN = LEN(@p_line_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_13line_id = ''
  --END ELSE BEGIN
  --  SET @opt_13line_id = 'and    a.line_id=' + @v_line_id+''
  --END
  --SET @STRLEN = LEN(@p_operation_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_14operation_id = ''
  --END ELSE BEGIN
  --  SET @opt_14operation_id = 'and    a.operation_id=' + @v_operation_id+''
  --END
  --SET @STRLEN = LEN(@p_equipment_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_15equipment_id = ''
  --END ELSE BEGIN
  --  SET @opt_15equipment_id = 'and    a.equipment_id=' + @v_equipment_id+''
  --END


  -- xpcommoncond findResourceCode_common  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT EQUIPMENT_ID AS CODE'+char(10)
  SET @v_dSql += '            ,CASE WHEN EQUIPMENT_NAME = '''' OR EQUIPMENT_NAME IS NULL THEN EQUIPMENT_ID ELSE EQUIPMENT_NAME END AS NAME'+char(10)
  SET @v_dSql += '            ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID'+char(10)
  SET @v_dSql += '            ,LINE_ID, OPERATION_ID, EQUIPMENT_ID, EQUIPMENT_NAME'+char(10)
  SET @v_dSql += '			      ,EQUIPMENT_TYPE, ELECTRODE_TYPE'+char(10)
  SET @v_dSql += '      FROM   SCM_EQUIPMENT_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE  1=1'+char(10)
  SET @v_dSql += ' ' +@opt_0company_id +' '+''+char(10)--and    a.company_id=#COMPANY_ID#
  SET @v_dSql += ' ' +@opt_1division_id +' '+''+char(10)--and    a.division_id=#DIVISION_ID#
  SET @v_dSql += ' ' +@opt_2site_id +' '+''+char(10)--and    a.site_id=#SITE_ID#
  SET @v_dSql += ' ' +@opt_3plant_id +' '+''+char(10)--AND    a.PLANT_ID = #PLANT_ID#
  SET @v_dSql += ' ' +@opt_4factory_id +' '+''+char(10)--and    a.factory_id=#FACTORY_ID#
  SET @v_dSql += ' ' +@opt_5line_id +' '+''+char(10)--and    a.line_id=#LINE_ID#
  SET @v_dSql += ' ' +@opt_6operation_id +' '+''+char(10)--and    a.operation_id=#OPERATION_ID#
  SET @v_dSql += ' ' +@opt_7equipment_id +' '+''+char(10)--and    a.equipment_id=#EQUIPMENT_ID#
  SET @v_dSql += '      AND     EXISTS ('+char(10)
  SET @v_dSql += '        	SELECT 1'+char(10)
  SET @v_dSql += '        	FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '        	AND    A.PLANT_ID     = B.PLANT_ID'+char(10)
  SET @v_dSql += '        	AND    A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '        	AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '        	AND    A.LINE_ID      = B.LINE_ID'+char(10)
  SET @v_dSql += '        	AND    B.USER_ID      ='+char(10)
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
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10);
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND a.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_lt)) + char(10); 
 --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.SITE_LT != null && $data.SITE_LT != ""){
  --      		sql+= "AND a.SITE_ID IN (" + $data.SITE_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10); 
 --SET @v_dSql += '
  --{
  --        	var sql = "";
  --        	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --        		sql+= "AND a.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --        	}
  --        	sql;
  --        }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10); 
 --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --      		sql+= "AND a.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.EQUIPMENT_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommoncond","findResourceCode_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
