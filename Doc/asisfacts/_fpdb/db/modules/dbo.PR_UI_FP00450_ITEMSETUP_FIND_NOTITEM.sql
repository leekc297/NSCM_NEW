CREATE PROCEDURE [dbo].[PR_UI_FP00450_ITEMSETUP_FIND_NOTITEM]
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
/** 프로그램 ID   : PR_UI_FP00450_ITEMSETUP_FIND_NOTITEM                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00450_ITEMSETUP_FIND_NOTITEM                                                                          **/
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
/** 2021-07-21     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00450_ITEMSETUP_FIND_NOTITEM
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00450_ITEMSETUP_FIND_NOTITEM'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_company_id nvarchar(max) = ''
  DECLARE @p_division_id nvarchar(max) = ''
  DECLARE @p_site_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_operation_id nvarchar(max) = ''
  DECLARE @p_line_setup_group_id nvarchar(max) = ''
  DECLARE @p_setup_category_id nvarchar(max) = ''
  DECLARE @p_item_setup_group_id nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_company_id nvarchar(max)
  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_site_id nvarchar(max)
  DECLARE @v_plant_id nvarchar(max)
  DECLARE @v_operation_id nvarchar(max)
  DECLARE @v_line_setup_group_id nvarchar(max)
  DECLARE @v_setup_category_id nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_item_setup_group_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  DECLARE @opt_0item_setup_group_id nvarchar(max)
  DECLARE @opt_1item_setup_group_id nvarchar(max)

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
    END ELSE IF @tmp_column = 'COMPANY_ID' BEGIN
      SET @p_company_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @p_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SITE_ID' BEGIN
      SET @p_site_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'OPERATION_ID' BEGIN
      SET @p_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_SETUP_GROUP_ID' BEGIN
      SET @p_line_setup_group_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SETUP_CATEGORY_ID' BEGIN
      SET @p_setup_category_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_SETUP_GROUP_ID' BEGIN
      SET @p_item_setup_group_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_company_id ='''' + @p_company_id + ''''
  SET @v_division_id ='''' + @p_division_id + ''''
  SET @v_site_id ='''' + @p_site_id + ''''
  SET @v_plant_id ='''' + @p_plant_id + ''''
  SET @v_operation_id ='''' + @p_operation_id + ''''
  SET @v_line_setup_group_id ='''' + @p_line_setup_group_id + ''''
  SET @v_setup_category_id ='''' + @p_setup_category_id + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_item_setup_group_id ='''' + @p_item_setup_group_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''


  SET @STRLEN = LEN(@p_item_setup_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0item_setup_group_id = ''
  END ELSE BEGIN
    SET @opt_0item_setup_group_id = 'AND    UPPER(A.ITEM_SETUP_GROUP_ID) LIKE ''%'' + UPPER(' + @v_item_setup_group_id+') + ''%'''
  END
  SET @STRLEN = LEN(@p_item_setup_group_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1item_setup_group_id = ''
  END ELSE BEGIN
    SET @opt_1item_setup_group_id = 'AND    UPPER(A.ITEM_SETUP_GROUP_ID) LIKE ''%'' + UPPER(' + @v_item_setup_group_id+') + ''%'''
  END


  -- FP00450_ItemSetup find_NotItem  
  SET @v_dSql = ''
  SET @v_dSql += '      SELECT'+char(10)
  SET @v_dSql += '' + @v_company_id+''+char(10)
  SET @v_dSql += ' AS COMPANY_ID,'+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += ' AS DIVISION_ID,'+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += ' AS SITE_ID,'+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += ' AS PLANT_ID,'+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += ' AS OPERATION_ID'+char(10)
  SET @v_dSql += '           ,'+char(10)
  SET @v_dSql += '' + @v_line_setup_group_id+''+char(10)
  SET @v_dSql += ' AS LINE_SETUP_GROUP_ID,'+char(10)
  SET @v_dSql += '' + @v_setup_category_id+''+char(10)
  SET @v_dSql += ' AS SETUP_CATEGORY_ID, ''-'' AS SETUP_KEY_ID, ''ALL'' AS ITEM_SETUP_GROUP_ID'+char(10)
  SET @v_dSql += '           , 1 AS ORDERBY'+char(10)
  SET @v_dSql += '      UNION ALL'+char(10)
  SET @v_dSql += '      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.OPERATION_ID'+char(10)
  SET @v_dSql += '           , B.LINE_SETUP_GROUP_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.ITEM_SETUP_GROUP_ID'+char(10)
  SET @v_dSql += '           , 2 AS ORDERBY'+char(10)
  SET @v_dSql += '      FROM   SCM_ITEM_SETUP_GROUP_M A WITH(NOLOCK) INNER JOIN SCM_LINE_SETUP_GROUP_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      ON     A.COMPANY_ID          = B.COMPANY_ID'+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID         = B.DIVISION_ID'+char(10)
  SET @v_dSql += '      AND    A.SITE_ID             = B.SITE_ID'+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID        = B.OPERATION_ID'+char(10)
  SET @v_dSql += '      AND    A.COMPANY_ID          ='+char(10)
  SET @v_dSql += '' + @v_company_id+''+char(10)
  SET @v_dSql += '      AND    A.DIVISION_ID         ='+char(10)
  SET @v_dSql += '' + @v_division_id+''+char(10)
  SET @v_dSql += '      AND    A.SITE_ID             ='+char(10)
  SET @v_dSql += '' + @v_site_id+''+char(10)
  SET @v_dSql += '      AND    B.PLANT_ID            ='+char(10)
  SET @v_dSql += '' + @v_plant_id+''+char(10)
  SET @v_dSql += '      AND    A.OPERATION_ID        ='+char(10)
  SET @v_dSql += '' + @v_operation_id+''+char(10)
  SET @v_dSql += '      AND    B.LINE_SETUP_GROUP_ID ='+char(10)
  SET @v_dSql += '' + @v_line_setup_group_id+''+char(10)
  SET @v_dSql += '      AND    A.SETUP_CATEGORY_ID   ='+char(10)
  SET @v_dSql += '' + @v_setup_category_id+''+char(10)
  SET @v_dSql += '      AND    EXISTS ('+char(10)
  SET @v_dSql += '            SELECT 1'+char(10)
  
  
  SET @v_dSql += '            FROM   FP_USER_ROLE_INFO_V BB WITH(NOLOCK)'+char(10)
  SET @v_dSql += '            WHERE  A.COMPANY_ID   = BB.COMPANY_ID'+char(10)
  SET @v_dSql += '            AND    A.DIVISION_ID  = BB.DIVISION_ID'+char(10)
  SET @v_dSql += '            AND    A.SITE_ID      = BB.SITE_ID'+char(10)
  SET @v_dSql += '            AND    B.PLANT_ID     = BB.PLANT_ID'+char(10)
  SET @v_dSql += '            AND    A.OPERATION_ID = BB.OPERATION_ID'+char(10)
  SET @v_dSql += '            AND    BB.USER_ID     ='+char(10)
  SET @v_dSql += '' + @v_user_id+''+char(10)
  SET @v_dSql += '            AND    BB.SAVE_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += ' ' +@opt_0item_setup_group_id +' '+''+char(10)--AND    UPPER(A.ITEM_SETUP_GROUP_ID) LIKE '%' + UPPER(#ITEM_SETUP_GROUP_ID#) + '%'
  SET @v_dSql += '      GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.OPERATION_ID'+char(10)
  SET @v_dSql += '             , B.LINE_SETUP_GROUP_ID, A.SETUP_CATEGORY_ID, A.SETUP_KEY_ID, A.ITEM_SETUP_GROUP_ID'+char(10)
  SET @v_dSql += '      ORDER BY ORDERBY, ITEM_SETUP_GROUP_ID'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00450_ItemSetup","find_NotItem",param);
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
