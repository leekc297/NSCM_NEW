CREATE PROCEDURE [dbo].[PR_UI_FP00413_FIND_FP00413]
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
/** 프로그램 ID   : PR_UI_FP00413_FIND_FP00413                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00413_FIND_FP00413                                                                          **/
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
  EXEC PR_UI_FP00413_FIND_FP00413
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00413_FIND_FP00413'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_tray_id nvarchar(max) = ''
  DECLARE @p_active_flag nvarchar(max) = ''
  DECLARE @p_tray_type nvarchar(max) = ''
  DECLARE @p_group_tray_cnt nvarchar(max) = ''
  DECLARE @p_division_lt nvarchar(max) = ''
  DECLARE @p_plant_lt nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_tray_id nvarchar(max)
  DECLARE @v_active_flag nvarchar(max)
  DECLARE @v_tray_type nvarchar(max)
  DECLARE @v_group_tray_cnt nvarchar(max)
  DECLARE @v_division_lt nvarchar(max)
  DECLARE @v_plant_lt nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0site_id nvarchar(max)
  DECLARE @opt_1tray_id nvarchar(max)
  DECLARE @opt_2active_flag nvarchar(max)
  DECLARE @opt_3tray_type nvarchar(max)
  DECLARE @opt_4group_tray_cnt nvarchar(max)
  DECLARE @opt_5site_id nvarchar(max)
  DECLARE @opt_6tray_id nvarchar(max)
  DECLARE @opt_7active_flag nvarchar(max)
  DECLARE @opt_8tray_type nvarchar(max)
  DECLARE @opt_9group_tray_cnt nvarchar(max)

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
    END ELSE IF @tmp_column = 'TRAY_ID' BEGIN
      SET @p_tray_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ACTIVE_FLAG' BEGIN
      SET @p_active_flag =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'TRAY_TYPE' BEGIN
      SET @p_tray_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'GROUP_TRAY_CNT' BEGIN
      SET @p_group_tray_cnt =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  SET @v_tray_id ='''' + @p_tray_id + ''''
  SET @v_active_flag ='''' + @p_active_flag + ''''
  SET @v_tray_type ='''' + @p_tray_type + ''''
  SET @v_group_tray_cnt ='''' + @p_group_tray_cnt + ''''
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
  SET @STRLEN = LEN(@p_tray_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1tray_id = ''
  END ELSE BEGIN
    SET @opt_1tray_id = 'AND    A.TRAY_TYPE_CODE LIKE ''%'' + ' + @v_tray_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_2active_flag = ''
  END ELSE BEGIN
    SET @opt_2active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_tray_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_3tray_type = ''
  END ELSE BEGIN
    SET @opt_3tray_type = 'AND    A.DEGAS_BEFORE_TYPE = ' + @v_tray_type+''
  END
  SET @STRLEN = LEN(@p_group_tray_cnt)
  IF @STRLEN< 1  BEGIN
    SET @opt_4group_tray_cnt = ''
  END ELSE BEGIN
    SET @opt_4group_tray_cnt = 'AND    A.GROUP_TRAY_CNT > ' + @v_group_tray_cnt+' '
  END
  SET @STRLEN = LEN(@p_site_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_5site_id = ''
  END ELSE BEGIN
    SET @opt_5site_id = 'AND    A.SITE_ID = ' + @v_site_id+''
  END
  SET @STRLEN = LEN(@p_tray_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_6tray_id = ''
  END ELSE BEGIN
    SET @opt_6tray_id = 'AND    A.TRAY_TYPE_CODE LIKE ''%'' + ' + @v_tray_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_active_flag)
  IF @STRLEN< 1  BEGIN
    SET @opt_7active_flag = ''
  END ELSE BEGIN
    SET @opt_7active_flag = 'AND    A.USE_YN = ' + @v_active_flag+''
  END
  SET @STRLEN = LEN(@p_tray_type)
  IF @STRLEN< 1  BEGIN
    SET @opt_8tray_type = ''
  END ELSE BEGIN
    SET @opt_8tray_type = 'AND    A.DEGAS_BEFORE_TYPE = ' + @v_tray_type+''
  END
  SET @STRLEN = LEN(@p_group_tray_cnt)
  IF @STRLEN< 1  BEGIN
    SET @opt_9group_tray_cnt = ''
  END ELSE BEGIN
    SET @opt_9group_tray_cnt = 'AND    A.GROUP_TRAY_CNT > ' + @v_group_tray_cnt+' '
  END


  -- FP00413 find_FP00413  
  SET @v_dSql = ''
  SET @v_dSql += '    		  SELECT	A.*'+char(10)
  SET @v_dSql += '    		  FROM		('+char(10)
  SET @v_dSql += '						      	SELECT   A.COMPANY_ID'+char(10)
  SET @v_dSql += '										,A.DIVISION_ID'+char(10)
  SET @v_dSql += '										,A.SITE_ID'+char(10)
  SET @v_dSql += '										,A.PLANT_ID'+char(10)
  SET @v_dSql += '										,A.FACTORY_ID'+char(10)
  SET @v_dSql += '										,A.TRAY_TYPE_CODE AS TRAY_ID'+char(10)
  SET @v_dSql += '										,ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE) AS GROUP_TRAY_ID'+char(10)
  SET @v_dSql += '										,A.TRAY_TYPE_NAME AS TRAY_NAME'+char(10)
  SET @v_dSql += '										,A.DEGAS_BEFORE_TYPE'+char(10)
  SET @v_dSql += '										,ISNULL(B.ATTRIBUTE1, A.DEGAS_BEFORE_TYPE) AS TRAY_TYPE'+char(10)
  SET @v_dSql += '										,A.CELL_CNT'+char(10)
  SET @v_dSql += '										,A.LOAD_YIELD'+char(10)
  SET @v_dSql += '										,A.BUFFER_DAY'+char(10)
  SET @v_dSql += '										,A.TRAY_CNT AS INVENTORY_CNT'+char(10)
  SET @v_dSql += '										,A.INTRANSIT_CNT'+char(10)
  SET @v_dSql += '										,A.DESCRIPTION'+char(10)
  SET @v_dSql += '										,A.USE_YN AS ACTIVE_FLAG'+char(10)
  SET @v_dSql += '										,A.INSERT_ID'+char(10)
  SET @v_dSql += '										,A.INSERT_DATE'+char(10)
  SET @v_dSql += '										,A.UPDATE_ID'+char(10)
  SET @v_dSql += '										,A.UPDATE_DATE'+char(10)
  SET @v_dSql += '										,(CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN'+char(10)
  SET @v_dSql += '										,COUNT(ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE) ) OVER (PARTITION BY A.PLANT_ID, ISNULL(A.TRAY_TYPE_GROUP,A.TRAY_TYPE_CODE) ) AS GROUP_TRAY_CNT'+char(10)
  SET @v_dSql += '								FROM	SCM_FCS_TRAY_M A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '										ON 1=1'+char(10)
  SET @v_dSql += '										AND B.LOOKUP_TYPE_CODE = ''FORMATION_TRAY_TYPE'''+char(10)
  SET @v_dSql += '										AND B.ACTIVE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '										AND A.PLANT_ID = B.SEGMENT1'+char(10)
  SET @v_dSql += '										AND A.DEGAS_BEFORE_TYPE = B.SEGMENT2'+char(10)
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
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --									var sql = "";
  --									if($data.DIVISION_LT != null && $data.DIVISION_LT != ""){
  --										sql+= "AND    A.DIVISION_ID IN (" + $data.DIVISION_LT + ")\r\n";
  --									}
  --									sql;
  --								}

  --'
  --SET @v_dSql += ' ' +@opt_0site_id +' '+''+char(10)--AND    A.SITE_ID = #SITE_ID#
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --									var sql = "";
  --									if($data.PLANT_LT != null && $data.PLANT_LT != ""){
  --										sql+= "AND    A.PLANT_ID IN (" + $data.PLANT_LT + ")\r\n";
  --									}
  --									sql;
  --								}

  --'
  SET @v_dSql += ' ' +@opt_1tray_id +' '+''+char(10)--AND    A.TRAY_TYPE_CODE LIKE '%' + #TRAY_ID# + '%'
  SET @v_dSql += ' ' +@opt_2active_flag +' '+''+char(10)--AND    A.USE_YN = #ACTIVE_FLAG#
  --SET @v_dSql += ' ' +@opt_3tray_type +' '+''+char(10)--AND    A.DEGAS_BEFORE_TYPE = #TRAY_TYPE#
  SET @v_dSql += '						) A'+char(10)
  SET @v_dSql += '				WHERE	1=1'+char(10)
  SET @v_dSql += ' ' +@opt_4group_tray_cnt +' '+''+char(10)--AND    A.GROUP_TRAY_CNT > #GROUP_TRAY_CNT# 
  -- 내부조건 밖으로 빼냄... ljs 20211119
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DEGAS_BEFORE_TYPE' , 'LK', @p_tray_type)) + char(10)

  SET @v_dSql += '				ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.TRAY_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00413","find_FP00413",param);
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
