CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON]
  @p_sys_type			nvarchar(MAX),  
  @p_sys_flag			nvarchar(MAX),
  @p_sys_gubun			nvarchar(MAX),  
  @p_user_id			nvarchar(MAX),
  @p_instance_id nvarchar(max) = '',
  @p_company_id nvarchar(max) = '',
  @p_division_id nvarchar(max) = '',
  @p_site_id nvarchar(max) = '',
  @p_plant_id nvarchar(max) = '',
  @p__save_auth nvarchar(max) = '',
  @p__non_auth nvarchar(max) = '',
  @p_instance_lt nvarchar(max) = '',
  @p_division_lt nvarchar(max) = '',
  @p_site_lt nvarchar(max) = '',
  @p_plant_lt nvarchar(max) = '',
  --@p_param nvarchar(max) = '',
  --@p_queryset1 nvarchar(max) = '',

  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON                                                                          **/
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
  EXEC PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON'
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  DECLARE @v__non_auth nvarchar(max)
  DECLARE @v_instance_lt nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_site_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0instance_id nvarchar(max)
  DECLARE @opt_1company_id nvarchar(max)
  DECLARE @opt_2division_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4plant_id nvarchar(max)
  --DECLARE @opt_5instance_id nvarchar(max)
  --DECLARE @opt_6company_id nvarchar(max)
  --DECLARE @opt_7division_id nvarchar(max)
  --DECLARE @opt_8site_id nvarchar(max)
  --DECLARE @opt_9plant_id nvarchar(max)

  --Optional Parameter Part END

  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  SET @v__non_auth ='''' + @p__non_auth + ''''
  SET @v_instance_lt ='''' + @p_instance_lt + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_site_lt ='''' + @p_site_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0instance_id = ''
  END ELSE BEGIN
    SET @opt_0instance_id = 'AND    B.INSTANCE_ID = ' + @v_instance_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1company_id = ''
  END ELSE BEGIN
    SET @opt_1company_id = 'AND  a.COMPANY_ID = ' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2division_id = ''
  END ELSE BEGIN
    SET @opt_2division_id = 'AND  a.DIVISION_ID = ' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND  a.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_plant_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4plant_id = ''
  END ELSE BEGIN
    SET @opt_4plant_id = 'AND  a.PLANT_ID = ' + @v_plant_id+''
  END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_5instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_5instance_id = 'AND    B.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_company_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_6company_id = ''
  --END ELSE BEGIN
  --  SET @opt_6company_id = 'AND  a.COMPANY_ID = ' + @v_company_id+''
  --END
  --SET @STRLEN = LEN(@p_division_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7division_id = ''
  --END ELSE BEGIN
  --  SET @opt_7division_id = 'AND  a.DIVISION_ID = ' + @v_division_id+''
  --END
  --SET @STRLEN = LEN(@p_site_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_8site_id = ''
  --END ELSE BEGIN
  --  SET @opt_8site_id = 'AND  a.SITE_ID = ' + @v_site_id+''
  --END
  --SET @STRLEN = LEN(@p_plant_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_9plant_id = ''
  --END ELSE BEGIN
  --  SET @opt_9plant_id = 'AND  a.PLANT_ID = ' + @v_plant_id+''
  --END


  -- xpcommoncond findFactoryCode_common  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT A.FACTORY_ID AS CODE, ''('' + A.FACTORY_ID + '')'' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME'+char(10)
  SET @v_dSql += '      		  , CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END AS ROWCHK'+char(10)
  SET @v_dSql += '      FROM   SCM_FACTORY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '					SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID'+char(10)
  SET @v_dSql += '					FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '					WHERE	1=1'+char(10)
  SET @v_dSql += '					AND		R.USER_ID	='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

        IF @p__save_auth = 'Y' BEGIN
		SET @v_dSql += char(10)
      END
		SET @v_dSql +='			AND    R.SAVE_FLAG = ''Y''' + char(10)
  --SET @v_dSql += '
  --{
  --							var sql="";
  --
  --							if($data._SAVE_AUTH == "Y")
  --							{
  --								sql+="			AND    R.SAVE_FLAG = ''''Y'''' \r\n";
  --							}
  --
  --							sql;
  --						}

  --'
  SET @v_dSql += '			) R'+char(10)
  SET @v_dSql += '			ON		1=1'+char(10)
  SET @v_dSql += '			AND		A.COMPANY_ID		= R.COMPANY_ID'+char(10)
  SET @v_dSql += '			AND		A.DIVISION_ID		= R.DIVISION_ID'+char(10)
  SET @v_dSql += '			AND		A.SITE_ID			= R.SITE_ID'+char(10)
  SET @v_dSql += '			AND		A.PLANT_ID			= R.PLANT_ID'+char(10)
  SET @v_dSql += '			AND		A.FACTORY_ID		= R.FACTORY_ID'+char(10)
  SET @v_dSql += '      WHERE  1=1'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

        IF @p__non_auth = 'Y' BEGIN
		SET @v_dSql += '' + char(10)
  END ELSE BEGIN
		SET @v_dSql +='AND  EXISTS ( ' + char(10)
		SET @v_dSql +='			SELECT 1 ' + char(10)
		SET @v_dSql +='			FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) ' + char(10)
		SET @v_dSql +='			WHERE  A.COMPANY_ID  = B.COMPANY_ID ' + char(10)
		SET @v_dSql +='			AND    A.DIVISION_ID = B.DIVISION_ID ' + char(10)
		SET @v_dSql +='  	    AND    A.SITE_ID     = B.SITE_ID ' + char(10)
		SET @v_dSql +='  	    AND    A.PLANT_ID    = B.PLANT_ID ' + char(10)
		SET @v_dSql +='  	    AND    A.FACTORY_ID    = B.FACTORY_ID ' + char(10)
		SET @v_dSql +='			AND    B.USER_ID     = '+@v_user_id + char(10)
      IF @p__save_auth = 'Y' BEGIN
		SET @v_dSql +='			AND    B.SAVE_FLAG = ''Y'' ' + char(10)
      END
		SET @v_dSql +='	) ' + char(10)
  END

  --SET @v_dSql += '
  --{
  --        var sql="";
  --
  --  		  if($data._NON_AUTH == "Y") {
  --  		  } else {
  --	          sql+="AND  EXISTS ( 	\r\n";
  --	          sql+="  				SELECT 1 \r\n";
  --	          sql+="  				FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) \r\n";
  --	          sql+="  				WHERE  A.COMPANY_ID     = B.COMPANY_ID \r\n";
  --	          sql+="				AND    A.DIVISION_ID    = B.DIVISION_ID \r\n";
  --	          sql+="				AND    A.SITE_ID        = B.SITE_ID \r\n";
  --	          sql+="				AND    A.PLANT_ID       = B.PLANT_ID \r\n";
  --	          sql+="				AND    A.FACTORY_ID     = B.FACTORY_ID \r\n";
  --	          sql+="  				AND    B.USER_ID     = ''''" + $data.USER_ID + "'''' \r\n";
  --          	if($data._SAVE_AUTH == "Y")
  --			{
  --			    sql+="			AND    B.SAVE_FLAG = ''''Y'''' \r\n";
  --			}
  --          	sql+="			) 	\r\n";
  --  		  }
  --
  --  		  sql;
  --      }

  --'
  SET @v_dSql += '      AND A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '      AND EXISTS ('+char(10)
  SET @v_dSql += '          SELECT 1 FROM ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID'+char(10)
  SET @v_dSql += '              FROM   SCM_FACTORY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              ON    A.FACTORY_ID=B.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND		B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '              WHERE 1=1'+char(10)
  SET @v_dSql += '              AND		 A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND    B.INSTANCE_ID = #INSTANCE_ID#
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_lt)) + char(10);
	
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --							  var sql = "";
  --							  var sInst = $data.INSTANCE_LT;
  --
  --							  if(sInst!=null && sInst!="") {
  --							    sql+="AND    B.INSTANCE_ID IN (" + sInst + ")";
  --							  }
  --
  --							  sql;
  --							}

  --'
  SET @v_dSql += '          ) C'+char(10)
  SET @v_dSql += '          WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += ' ' +@opt_1company_id +' '+''+char(10)--AND  a.COMPANY_ID = #COMPANY_ID#
  SET @v_dSql += ' ' +@opt_2division_id +' '+''+char(10)--AND  a.DIVISION_ID = #DIVISION_ID#
  SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND  a.SITE_ID = #SITE_ID#
  SET @v_dSql += ' ' +@opt_4plant_id +' '+''+char(10)--AND  a.PLANT_ID = #PLANT_ID#

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
  --      	var sql = "";
  --      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --      		sql+= "AND a.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      GROUP BY a.FACTORY_ID, a.FACTORY_NAME, CASE WHEN R.FACTORY_ID IS NOT NULL THEN 1 ELSE 0 END'+char(10)
  SET @v_dSql += '      ORDER BY A.FACTORY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --         var param = $data.param;
  --         $data.querySet1 = $jdbc.queryList("xpcommoncond","findFactoryCode_common",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --         var param = $data.param;
  --         $data.querySet1 = $jdbc.queryList("xpcommoncond","findFactoryCode_common",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDFACTORYCODE_COMMON',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
