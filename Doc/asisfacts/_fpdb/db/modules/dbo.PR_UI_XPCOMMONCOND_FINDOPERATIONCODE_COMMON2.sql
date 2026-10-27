CREATE PROCEDURE [dbo].[PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON2]
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
/** 프로그램 ID   : PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON                                                                          **/
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
  EXEC PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON'

  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0

  	DECLARE   @p_instance_id nvarchar(max) = ''
	DECLARE @p_company_id nvarchar(max) = ''
	DECLARE @p_division_id nvarchar(max) = ''
	DECLARE  @p_site_id nvarchar(max) = ''
	DECLARE   @p_operation_group_id nvarchar(max) = ''
	DECLARE   @p_capa_type nvarchar(max) = ''
	DECLARE   @p_plant_id nvarchar(max) = ''
	DECLARE   @p_factory_id nvarchar(max) = ''
	--DECLARE   @p_instance_lt nvarchar(max) = ''
	DECLARE  @p__save_auth nvarchar(max) = ''
	DECLARE  @p__non_auth nvarchar(max) = ''
	--DECLARE  @p_division_lt nvarchar(max) = ''
	--DECLARE   @p_site_lt nvarchar(max) = ''

  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_operation_group_id nvarchar(max)
  DECLARE @v_capa_type nvarchar(max)
  --DECLARE @v_plant_lt nvarchar(max)
  --DECLARE @v_factory_lt nvarchar(max)
  --DECLARE @v_instance_lt nvarchar(max)
  DECLARE @v__save_auth nvarchar(max)
  --DECLARE @v_division_lt nvarchar(max)
  --DECLARE @v_site_lt nvarchar(max)
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0instance_id nvarchar(max)
  DECLARE @opt_1company_id nvarchar(max)
  DECLARE @opt_2division_id nvarchar(max)
  DECLARE @opt_3site_id nvarchar(max)
  DECLARE @opt_4operation_group_id nvarchar(max)
  DECLARE @opt_5capa_type nvarchar(max)

  --Optional Parameter Part END

      SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단  

  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = 'INSTANCE_ID' BEGIN
		SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
		SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
		SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'SITE_ID' BEGIN
		SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'OPERATION_GROUP' BEGIN
		SET @p_operation_group_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'CAPA_TYPE' BEGIN
		SET @p_capa_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
		SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
		SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END

  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_operation_group_id ='''' + @p_operation_group_id + ''''
  SET @v_capa_type ='''' + @p_capa_type + ''''
  --SET @v_plant_lt ='''' + @p_plant_lt + ''''
  --SET @v_factory_lt ='''' + @p_factory_lt + ''''
  --SET @v_instance_lt ='''' + @p_instance_lt + ''''
  SET @v__save_auth ='''' + @p__save_auth + ''''
  --SET @v_division_lt ='''' + @p_division_lt + ''''
  --SET @v_site_lt ='''' + @p_site_lt + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_instance_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0instance_id = ''
  END ELSE BEGIN
    SET @opt_0instance_id = 'AND   B.INSTANCE_ID = ' + @v_instance_id+''
  END
  SET @STRLEN = LEN(@p_company_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1company_id = ''
  END ELSE BEGIN
    SET @opt_1company_id = 'AND  A.COMPANY_ID = ' + @v_company_id+''
  END
  SET @STRLEN = LEN(@p_division_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2division_id = ''
  END ELSE BEGIN
    SET @opt_2division_id = 'AND  A.DIVISION_ID = ' + @v_division_id+''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3site_id = ''
  END ELSE BEGIN
    SET @opt_3site_id = 'AND  A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_operation_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4operation_group_id = ''
  END ELSE BEGIN
    SET @opt_4operation_group_id = 'AND  A.OPERATION_GROUP_ID = ' + @v_operation_group_id+''
  END
  SET @STRLEN = LEN(@p_capa_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_5capa_type = ''
  END ELSE BEGIN
    SET @opt_5capa_type = 'AND  A.CAPA_TYPE = ' + @v_capa_type+''
  END
  
  -- xpcommoncond findOperationCode_common  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT OPERATION_ID AS CODE, ''(''+OPERATION_ID+'')''+ISNULL(OPERATION_NAME, OPERATION_ID) AS NAME'+char(10)
  SET @v_dSql += '      FROM SCM_OPERATION_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      WHERE (('+char(10)
  SET @v_dSql += '      EXISTS (SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')'+char(10)
  SET @v_dSql += '      AND MES_ERP_INTERFACE_FLAG=''Y'''+char(10)
  SET @v_dSql += '      ) OR'+char(10)
  SET @v_dSql += '      ('+char(10)
  SET @v_dSql += '      NOT EXISTS (SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M B WITH(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')'+char(10)
  SET @v_dSql += '      ))'+char(10)
  SET @v_dSql += '      AND EXISTS (SELECT 1 FROM SCM_LINE_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  WHERE C.COMPANY_ID=A.COMPANY_ID'+char(10)
  SET @v_dSql += '                  AND   C.DIVISION_ID=A.DIVISION_ID'+char(10)
  SET @v_dSql += '                  AND   C.SITE_ID=A.SITE_ID'+char(10)
  SET @v_dSql += '                  AND   C.OPERATION_ID=A.OPERATION_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10);
  --SET @v_dSql += '
  --{
  --                  	var sql = "";
  --
  --                  	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --                  		sql+= "AND   C.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --                  	}
  --
  --                  	if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
  --                  		sql+= "AND   C.FACTORY_ID IN (" + $data.FACTORY_LT + ")\r\n";
  --                  	}
  --
  --                  	sql;
  --                  }

  --'
  SET @v_dSql += ')'+char(10)
  SET @v_dSql += '      AND EXISTS (SELECT 1 FROM (SELECT DISTINCT B.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                  							 FROM SCM_FACTORY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  							 INNER JOIN FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                  							 ON  A.FACTORY_ID=B.FACTORY_ID'+char(10)
  SET @v_dSql += '                  							 AND B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '                  							 WHERE 1=1'+char(10)
  SET @v_dSql += '                  							 AND   A.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND   B.INSTANCE_ID = #INSTANCE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
  --SET @v_dSql += '
  --{
  --                  								  var sql = "";
  --                  								  var sInst = $data.INSTANCE_LT
  --
  --                  								  if(sInst!=null && sInst!="") {
  --                  								    sql+="AND    B.INSTANCE_ID IN (" + sInst + ")";
  --                  								  }
  --
  --                  								  sql;
  --                  								}

  --'
  SET @v_dSql += '                  							 ) C'+char(10)
  SET @v_dSql += '      			                     WHERE C.INSTANCE_TYPE=A.INSTANCE_TYPE )'+char(10)
  SET @v_dSql += '      AND  EXISTS ('+char(10)
  SET @v_dSql += '			          SELECT 1'+char(10)
  SET @v_dSql += '			          FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '			          WHERE  A.COMPANY_ID   = B.COMPANY_ID'+char(10)
  SET @v_dSql += '			          AND    A.DIVISION_ID  = B.DIVISION_ID'+char(10)
  SET @v_dSql += '			          AND    A.SITE_ID      = B.SITE_ID'+char(10)
  SET @v_dSql += '			          AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '			          AND    B.USER_ID      ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

      IF @p__save_auth = 'Y' BEGIN
		SET @v_dSql +='			AND    B.SAVE_FLAG = ''Y'' ' + char(10)
      END
  --SET @v_dSql += '
  --{
  --							var sql="";
  --
  --							if($data._SAVE_AUTH == "Y")
  --							{
  --								sql+="			AND    B.SAVE_FLAG = ''''Y'''' \r\n";
  --							}
  --
  --							sql;
  --						}

  --'
  SET @v_dSql += '			      )'+char(10)
  SET @v_dSql += '      AND   ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.COMPANY_ID' , 'EQ', @p_company_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_GROUP_ID' , 'EQ', @p_operation_group_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CAPA_TYPE' , 'EQ', @p_capa_type)) + char(10);
  
  --SET @v_dSql += ' ' +@opt_1company_id +' '+''+char(10)--AND  A.COMPANY_ID = #COMPANY_ID#
  --SET @v_dSql += ' ' +@opt_2division_id +' '+''+char(10)--AND  A.DIVISION_ID = #DIVISION_ID#
  --SET @v_dSql += ' ' +@opt_3site_id +' '+''+char(10)--AND  A.SITE_ID = #SITE_ID#
  --SET @v_dSql += ' ' +@opt_4operation_group_id +' '+''+char(10)--AND  A.OPERATION_GROUP_ID = #OPERATION_GROUP_ID#
  --SET @v_dSql += ' ' +@opt_5capa_type +' '+''+char(10)--AND  A.CAPA_TYPE = #CAPA_TYPE#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10);
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --      		sql+= "AND  A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_lt)) + char(10);
  --SET @v_dSql += '
  --{
  --      	var sql = "";
  --      	if($data.SITE_LT != null && $data.SITE_LT != ""){
  --      		sql+= "AND  A.SITE_ID IN (" + $data.SITE_LT + ")\r\n";
  --      	}
  --      	sql;
  --      }

  --'
  SET @v_dSql += '      GROUP BY A.OPERATION_ID, A.OPERATION_NAME'+char(10)
  SET @v_dSql += '      ORDER BY A.OPERATION_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --         var param = $data.param;
  --		 $data.querySet1 = $jdbc.queryList("xpcommoncond","findOperationCode_common",param);
  --
  --}



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
      exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON2',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_XPCOMMONCOND_FINDOPERATIONCODE_COMMON2',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
