CREATE PROCEDURE [dbo].[PR_UI_FP00414_FIND_FP00414]
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
/** 프로그램 ID   : PR_UI_FP00414_FIND_FP00414                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00414_FIND_FP00414                                                                          **/
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
/** 2021-08-24     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00414_FIND_FP00414
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00414_FIND_FP00414'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_active_flag nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_fcs_model_id nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_active_flag nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_fcs_model_id nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1active_flag nvarchar(max)
  DECLARE @opt_2item_id nvarchar(max)
  DECLARE @opt_3nick_name nvarchar(max)
  DECLARE @opt_4fcs_model_id nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6active_flag nvarchar(max)
  DECLARE @opt_7item_id nvarchar(max)
  DECLARE @opt_8nick_name nvarchar(max)
  DECLARE @opt_9fcs_model_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ACTIVE_FLAG' BEGIN
      SET @p_active_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FCS_MODEL_ID' BEGIN
      SET @p_fcs_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_lt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_active_flag ='''' + @p_active_flag + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_fcs_model_id ='''' + @p_fcs_model_id + ''''
  SET @v_division_lt ='''' + @p_division_lt + ''''
  SET @v_plant_lt ='''' + @p_plant_lt + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0site_id = ''
  END ELSE BEGIN
    SET @opt_0site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_1active_flag = ''
  END ELSE BEGIN
    SET @opt_1active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_2item_id = ''
  END ELSE BEGIN
    SET @opt_2item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_3nick_name = ''
  END ELSE BEGIN
    SET @opt_3nick_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_fcs_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4fcs_model_id = ''
  END ELSE BEGIN
    SET @opt_4fcs_model_id = 'AND    A.FCS_MODEL_ID LIKE ''%'' + ' + @v_fcs_model_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_6active_flag = ''
  END ELSE BEGIN
    SET @opt_6active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_7item_id = ''
  END ELSE BEGIN
    SET @opt_7item_id = 'AND    A.ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_8nick_name = ''
  END ELSE BEGIN
    SET @opt_8nick_name = 'AND    C.NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_fcs_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_9fcs_model_id = ''
  END ELSE BEGIN
    SET @opt_9fcs_model_id = 'AND    A.FCS_MODEL_ID LIKE ''%'' + ' + @v_fcs_model_id+' + ''%'''
  END


  -- FP00414 find_FP00414  
  SET @v_dSql = ''
  SET @v_dSql += '    		  SELECT	A.*'+char(10)
  SET @v_dSql += '    		  FROM		('+char(10)
  SET @v_dSql += '						      SELECT	 A.COMPANY_ID'+char(10)
  SET @v_dSql += '										,A.DIVISION_ID'+char(10)
  SET @v_dSql += '										,A.SITE_ID'+char(10)
  SET @v_dSql += '										,A.PLANT_ID'+char(10)
  SET @v_dSql += '										,A.PSEUDO_FACTORY_ID'+char(10)
  SET @v_dSql += '										,A.FACTORY_ID'+char(10)
  SET @v_dSql += '										,A.LINE_ID'+char(10)
  SET @v_dSql += '										,ISNULL(B.TRAY_TYPE_GROUP, A.TRAY_TYPE_CODE) AS GROUP_TRAY_ID'+char(10)
  SET @v_dSql += '										,A.TRAY_TYPE_CODE AS TRAY_ID'+char(10)
  SET @v_dSql += '										,B.TRAY_TYPE_NAME AS TRAY_NAME'+char(10)
  SET @v_dSql += '										,B.TRAY_TYPE'+char(10)
  SET @v_dSql += '										,('+char(10)
  SET @v_dSql += '											SELECT TOP 1  B.MODEL_LOT_ID'+char(10)
  SET @v_dSql += '											FROM   FP_MODEL_LOT_M  B (NOLOCK)'+char(10)
  SET @v_dSql += '											WHERE  B.COMPANY_ID  = A.COMPANY_ID'+char(10)
  SET @v_dSql += '											AND    B.DIVISION_ID = A.DIVISION_ID'+char(10)
  SET @v_dSql += '											AND    B.SITE_ID = A.SITE_ID'+char(10)
  SET @v_dSql += '											AND    B.PLANT_ID = A.PLANT_ID'+char(10)
  SET @v_dSql += '											AND    B.MODEL_ID = A.ITEM_ID'+char(10)
  SET @v_dSql += '										 ) AS FCS_MODEL_ID'+char(10)
  SET @v_dSql += '										,A.ITEM_ID'+char(10)
  SET @v_dSql += '										,C.NICK_NAME'+char(10)
  SET @v_dSql += '										,A.USE_YN AS ACTIVE_FLAG'+char(10)
  SET @v_dSql += '										,A.INSERT_ID'+char(10)
  SET @v_dSql += '										,A.INSERT_DATE'+char(10)
  SET @v_dSql += '										,A.UPDATE_ID'+char(10)
  SET @v_dSql += '										,A.UPDATE_DATE'+char(10)
  SET @v_dSql += '										, (CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '								FROM	SCM_FCS_TRAY_MODEL_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '															SELECT A.*, ISNULL(B.ATTRIBUTE1, A.DEGAS_BEFORE_TYPE) AS TRAY_TYPE'+char(10)
  SET @v_dSql += '															FROM	 SCM_FCS_TRAY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																	LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '																	ON 1=1'+char(10)
  SET @v_dSql += '																	AND B.LOOKUP_TYPE_CODE = ''FORMATION_TRAY_TYPE'''+char(10)
  SET @v_dSql += '																	AND B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '																	AND A.PLANT_ID = B.SEGMENT1'+char(10)
  SET @v_dSql += '																	AND A.DEGAS_BEFORE_TYPE = B.SEGMENT2'+char(10)
  SET @v_dSql += '															WHERE  1=1'+char(10)
  SET @v_dSql += '															AND	 A.USE_YN = ''Y'''+char(10)
  SET @v_dSql += '										) B'+char(10)
  SET @v_dSql += '										ON  1=1'+char(10)
  SET @v_dSql += '										AND	A.COMPANY_ID = B.COMPANY_ID'+char(10)
  SET @v_dSql += '										AND	A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '										AND	A.SITE_ID = B.SITE_ID'+char(10)
  SET @v_dSql += '										AND	A.PLANT_ID = B.PLANT_ID'+char(10)
  --SET @v_dSql += '										AND	A.FACTORY_ID = B.FACTORY_ID'+char(10)
  SET @v_dSql += '										AND	A.PSEUDO_FACTORY_ID = B.FACTORY_ID'+char(10)
  SET @v_dSql += '										AND	A.TRAY_TYPE_CODE = B.TRAY_TYPE_CODE'+char(10)
  SET @v_dSql += '									    LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										ON  1=1'+char(10)
  SET @v_dSql += '										AND	A.COMPANY_ID = C.COMPANY_ID'+char(10)
  SET @v_dSql += '										AND	A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '										AND	A.SITE_ID = C.SITE_ID'+char(10)
  SET @v_dSql += '										AND	A.ITEM_ID = C.ITEM_ID'+char(10)
  SET @v_dSql += '										AND	C.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '										LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '												           	SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID'+char(10)
  SET @v_dSql += '															FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)'+char(10)
  SET @v_dSql += '															WHERE  R.USER_ID   ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '															AND    R.SAVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '										) R'+char(10)
  SET @v_dSql += '										ON   A.COMPANY_ID  = R.COMPANY_ID'+char(10)
  SET @v_dSql += '										AND  A.DIVISION_ID = R.DIVISION_ID'+char(10)
  SET @v_dSql += '										AND  A.SITE_ID     = R.SITE_ID'+char(10)
  SET @v_dSql += '										AND  A.PLANT_ID    = R.PLANT_ID'+char(10)
  SET @v_dSql += '								WHERE 1=1'+char(10)
      SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
	SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --							      	var sql = "";
  --							      	if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --							      		sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --							      	}
  --							      	sql;
  --							      }

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --							      	var sql = "";
  --							      	if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --							      		sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --							      	}
  --							      	sql;
  --							      }

  --'
  SET @v_dSql += ' ' +@opt_1active_flag +' '+''+char(10)--AND    A.USE_YN = #ACTIVE_FLAG#
  SET @v_dSql += ' ' +@opt_2item_id +' '+''+char(10)--AND    A.ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_3nick_name +' '+''+char(10)--AND    C.NICK_NAME LIKE '%' + #NICK_NAME# + '%'
  SET @v_dSql += '						) A'+char(10)
  SET @v_dSql += '				WHERE	1=1'+char(10)
  SET @v_dSql += ' ' +@opt_4fcs_model_id +' '+''+char(10)--AND    A.FCS_MODEL_ID LIKE '%' + #FCS_MODEL_ID# + '%'
  SET @v_dSql += '				ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.GROUP_TRAY_ID, A.TRAY_ID, A.FCS_MODEL_ID, A.ITEM_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00414","find_FP00414",param);
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
      exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
