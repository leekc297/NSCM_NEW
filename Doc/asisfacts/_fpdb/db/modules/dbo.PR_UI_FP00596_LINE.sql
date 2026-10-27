CREATE PROCEDURE [dbo].[PR_UI_FP00596_LINE]
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
/** 프로그램 ID   :PR_UI_FP00596_LINE                                                         **/
/** 프로그램 명   : Procedure PR_UI_FP00596_LINE                                              **/
/** 설 명         :                                                                           **/
/** Version       : 1.5.0(Auto)                                                               **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2021-05-17     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00596_LINE
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00596_LINE'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_confirm_area nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_factory_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_confirm_area nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0model_id nvarchar(max)
  DECLARE @opt_1item_id nvarchar(max)
  DECLARE @opt_2nick_name nvarchar(max)
  DECLARE @opt_3model_id nvarchar(max)
  DECLARE @opt_4item_id nvarchar(max)
  DECLARE @opt_5nick_name nvarchar(max)

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
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column =' CONFIRM_AREA' BEGIN
      SET @p_confirm_area =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			        ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_factory_id ='''' + @p_factory_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_line_id ='''' + @p_line_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_confirm_area ='''' + @p_confirm_area + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''


  -- FP00596_Addline   find_LineList
  SET @v_dSql = ''
  SET @v_dSql += ' SELECT DISTINCT  ' + char(10)
  SET @v_dSql += '       A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
  SET @v_dSql += '     , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '     , ISNULL(B.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
  SET @v_dSql += '     , B.LOCATION ' + char(10)
  SET @v_dSql += ' FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += ' INNER JOIN SCM_LINE_M B WITH(NOLOCK) ' + char(10)
  SET @v_dSql += ' ON     A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
  SET @v_dSql += ' AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
  SET @v_dSql += ' AND    A.SITE_ID        = B.SITE_ID ' + char(10)
  SET @v_dSql += ' AND    A.PLANT_ID       = B.PLANT_ID ' + char(10)
  SET @v_dSql += ' AND    A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
  SET @v_dSql += ' AND    A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
  SET @v_dSql += ' AND    A.LINE_ID        = B.LINE_ID ' + char(10)
  SET @v_dSql += ' AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)

  IF (@p_confirm_area = 'PLAN GROUP')
      BEGIN 
          SET @v_dSql += ' INNER JOIN ' + char(10)
      END
  ELSE
      BEGIN 
          SET @v_dSql += ' LEFT OUTER JOIN ' + char(10)
      END
  SET @v_dSql += ' ( ' + char(10)
  SET @v_dSql += '     SELECT A.SEGMENT2 AS PLAN_GROUP_ID ' + char(10)
  SET @v_dSql += '     FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '     WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
  SET @v_dSql += '     AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
  SET @v_dSql += '     and    A.SEGMENT1         = ' + @v_instance_id +' ' + char(10)
  SET @v_dSql += ' ) C ' + char(10)
  SET @v_dSql += ' ON   B.MODEL_TYPE   = C.PLAN_GROUP_ID ' + char(10)
  SET @v_dSql += ' INNER JOIN ( ' + char(10)
  SET @v_dSql += '        SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID ' + char(10)
  SET @v_dSql += '        FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '        WHERE  A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
  SET @v_dSql += '        AND    A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
  SET @v_dSql += '        AND    A.SITE_ID      = B.SITE_ID ' + char(10)
  SET @v_dSql += '        AND    A.OPERATION_ID = B.OPERATION_ID ' + char(10)
  SET @v_dSql += '        AND    A.INSTANCE_ID  = ' + @v_instance_id +' ' + char(10)
  IF (LEN(@p_division_id) > 0)
      BEGIN
          SET @v_dSql += '        AND   A.DIVISION_ID   = ' + @v_division_id +' ' + char(10)
      END
  IF (LEN(@p_site_id) > 0)
      BEGIN
          SET @v_dSql += '        AND   A.SITE_ID   = ' + @v_site_id +' ' + char(10)
      END

  SET @v_dSql += '        AND    A.AMEND_FLAG   = ''Y'' ' + char(10)
  SET @v_dSql += '        AND    B.ACTIVE_FLAG  = ''Y'' ' + char(10)
  SET @v_dSql += '  ) D '+char(10)
  SET @v_dSql += ' ON     A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
  SET @v_dSql += ' AND    A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
  SET @v_dSql += ' AND    A.SITE_ID        = D.SITE_ID ' + char(10)
  SET @v_dSql += ' AND    A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
  SET @v_dSql += ' WHERE  1=1 '+char(10)

  IF (LEN(@p_division_id) > 0)
      BEGIN
          SET @v_dSql += ' AND   A.DIVISION_ID   = ' + @v_division_id +' ' + char(10)
      END
  IF (LEN(@p_site_id) > 0)
      BEGIN
          SET @v_dSql += ' AND   A.SITE_ID   = ' + @v_site_id +' ' + char(10)
      END
  IF (LEN(@p_line_id) > 0)
      BEGIN
          SET @v_dSql += ' AND   A.LINE_ID LIKE ''%'' + ' + @v_line_id +' + ''%'' ' + char(10)
      END

  SET @v_dSql += ' AND    A.ITEM_ID     = ' + @v_item_id +' '+char(10)
  SET @v_dSql += ' AND   A.ACTIVE_FLAG  = ''Y'' ' + char(10)
  SET @v_dSql += ' AND   B.ACTIVE_FLAG  = ''Y'' ' + char(10)
  SET @v_dSql += ' AND   A.MONTH        = SUBSTRING(CONVERT(VARCHAR,dbo.SYSDATE1(),112),1,6) ' + char(10)
  SET @v_dSql += ' AND   A.PRIORITY NOT IN (''0'',''9'') ' + char(10)
  SET @v_dSql += ' AND   EXISTS ( ' + char(10)
  SET @v_dSql += '               SELECT 1 ' + char(10)
  SET @v_dSql += '               FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '               WHERE A.COMPANY_ID     = BB.COMPANY_ID  ' + char(10)
  SET @v_dSql += '               AND   A.DIVISION_ID    = BB.DIVISION_ID  ' + char(10)
  SET @v_dSql += '               AND   A.SITE_ID        = BB.SITE_ID  ' + char(10)
  SET @v_dSql += '               AND   A.PLANT_ID       = BB.PLANT_ID  ' + char(10)
  SET @v_dSql += '               AND   A.FACTORY_ID     = BB.FACTORY_ID  ' + char(10)
  SET @v_dSql += '               AND   A.OPERATION_ID   = BB.OPERATION_ID  ' + char(10)
  SET @v_dSql += '               AND   A.LINE_ID        = BB.LINE_ID  ' + char(10)
  SET @v_dSql += '               AND   BB.USER_ID       = ' + @v_user_id +'  ' + char(10)
  SET @v_dSql += '               AND   BB.SAVE_FLAG	  = ''Y''  ' + char(10)
  SET @v_dSql += '              ) '+char(10)
  SET @v_dSql += 'ORDER BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, LINE_NAME, LOCATION  ' + char(10)


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00596_LINE',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00596_LINE',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
