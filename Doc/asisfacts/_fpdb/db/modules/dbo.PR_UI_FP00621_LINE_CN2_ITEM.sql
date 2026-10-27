CREATE PROCEDURE [dbo].[PR_UI_FP00621_LINE_CN2_ITEM]
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
/** 프로그램 ID   :PR_UI_FP00621_LINE_CN2_ITEM                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00621_LINE_CN2_ITEM                                     **/
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
  EXEC PR_UI_FP00621_LINE_CN2_ITEM
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00621_LINE_CN2_ITEM'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_date nvarchar(max) = ''
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_form_operation_id nvarchar(max) = ''
  DECLARE @p_cell_group_code nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_date nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
  DECLARE @v_form_operation_id nvarchar(max) = ''
  DECLARE @v_cell_group_code nvarchar(max) = ''
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
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'DATE' BEGIN
      SET @p_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'MODEL_ID' BEGIN
      SET @p_model_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FORM_OPERATION_ID' BEGIN
      SET @p_form_operation_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CELL_GROUP_CODE' BEGIN
      SET @p_cell_group_code =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_date ='''' + @p_date + ''''
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_model_id ='''' + @p_model_id + ''''
  SET @v_item_id ='''' + @p_item_id + ''''
  SET @v_nick_name ='''' + @p_nick_name + ''''
  SET @v_cell_group_code ='''' + @p_cell_group_code + ''''
  SET @v_form_operation_id ='''' + @p_form_operation_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''


  -- planAmend_LineRes_CN2_Form_item_P   find_ItemList
  SET @v_dSql = ''
  SET @v_dSql += ' SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.ITEM_ID AS MODEL_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-'') AS NICK_NAME, '+char(10)
  SET @v_dSql += '     (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME '+char(10)
  SET @v_dSql += '           WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'') '+char(10)
  SET @v_dSql += '           ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE '+char(10)
  SET @v_dSql += '     , ISNULL(E.GROUP_ITEM_ID, A.ITEM_ID) AS CELL_GROUP_CODE '+char(10)
  SET @v_dSql += ' FROM	 SCM_ITEM_M A WITH(NOLOCK) '+char(10)
  SET @v_dSql += ' 		 LEFT OUTER JOIN ( '+char(10)
  SET @v_dSql += '           SELECT A.SEGMENT1 AS SITE_ID, A.SEGMENT2 AS DIVISION_ID, A.SEGMENT3 AS GROUP_ITEM_ID, A.SEGMENT4 AS ITEM_ID, A.SORT_ORDER '+char(10)
  SET @v_dSql += '           FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) '+char(10)
  SET @v_dSql += '           WHERE  A.LOOKUP_TYPE_CODE = ''MODULE_CELL_GROUP'' '+char(10)
  SET @v_dSql += '           AND    A.ACTIVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '         ) E '+char(10)
  SET @v_dSql += '         ON  A.DIVISION_ID = E.DIVISION_ID '+char(10)
  SET @v_dSql += '         AND A.SITE_ID = E.SITE_ID '+char(10)
  SET @v_dSql += '         AND A.ITEM_ID = E.ITEM_ID '+char(10)
  SET @v_dSql += ' 		 , '+char(10)
  SET @v_dSql += ' 	 SCM_MODEL_COMP_TEMP B WITH(NOLOCK), '+char(10)
  SET @v_dSql += ' 	 SCM_ITEM_CLASS_M C WITH(NOLOCK), '+char(10)
  SET @v_dSql += ' 	 ( '+char(10)
  SET @v_dSql += '           SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID '+char(10)
  SET @v_dSql += '           FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '           WHERE  A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '           AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '           AND    A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '           AND    A.OPERATION_ID = B.OPERATION_ID '+char(10)
  SET @v_dSql += '           AND    A.INSTANCE_ID  = ' + @v_instance_id+' '+char(10)
  SET @v_dSql += '           AND    A.AMEND_FLAG   = ''Y'' '+char(10)
  SET @v_dSql += '           AND    B.ACTIVE_FLAG  = ''Y'' '+char(10)
  SET @v_dSql += '        ) D '+char(10)
  SET @v_dSql += ' WHERE	 A.COMPANY_ID  = B.COMPANY_ID '+char(10)
  SET @v_dSql += ' AND	 A.DIVISION_ID = B.DIVISION_ID '+char(10)
  SET @v_dSql += ' AND	 A.SITE_ID     = B.SITE_ID '+char(10)
  SET @v_dSql += ' AND	 A.ITEM_ID     = B.CHILD_ITEM_ID '+char(10)
  SET @v_dSql += ' AND	 A.ITEM_CLASS  = C.CLASS_ID '+char(10)
  SET @v_dSql += ' AND   A.COMPANY_ID  = D.COMPANY_ID '+char(10)
  SET @v_dSql += ' AND   A.DIVISION_ID = D.DIVISION_ID '+char(10)
  SET @v_dSql += ' AND   A.SITE_ID     = D.SITE_ID '+char(10)
  IF (LEN(@p_form_operation_id) > 0)
      BEGIN
          SET @v_dSql += ' AND   A.FORMATION_FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%'' '+char(10)
          SET @v_dSql += ' AND   A.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%''  '+char(10)
      END
  IF (LEN(@p_cell_group_code) > 0)
      BEGIN
          SET @v_dSql += ' AND	 ISNULL(E.GROUP_ITEM_ID, A.ITEM_ID) LIKE ''%'' + ' + @v_cell_group_code +' + ''%''  '+char(10)
	  END
  IF (LEN(@p_item_id) > 0)
      BEGIN
          SET @v_dSql += ' AND	 A.ITEM_ID     LIKE ''%'' + ' + @v_item_id +' + ''%'' '+char(10)
	  END
  IF (LEN(@p_nick_name) > 0)
      BEGIN
          SET @v_dSql += ' AND	 A.NICK_NAME   LIKE ''%'' + ' + @v_nick_name +' + ''%'' '+char(10)
	  END

  SET @v_dSql += ' AND    EXISTS (	SELECT 	1 '+char(10)
  SET @v_dSql += '                 FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK) '+char(10)
  SET @v_dSql += '                       ,SCM_FACTORY_M         F  WITH(NOLOCK) '+char(10)
  SET @v_dSql += '                 WHERE  FF.FACTORY_ID 	= F.FACTORY_ID '+char(10)
  SET @v_dSql += '                 AND    FF.INSTANCE_ID = ' + @v_instance_id+' '+char(10)
  SET @v_dSql += '                 AND    F.COMPANY_ID   = A.COMPANY_ID '+char(10)
  SET @v_dSql += '                 AND    F.DIVISION_ID  = A.DIVISION_ID '+char(10)
  SET @v_dSql += '                 AND    F.SITE_ID      = A.SITE_ID	) '+char(10)
  SET @v_dSql += ' AND   EXISTS ( '+char(10)
  SET @v_dSql += '               SELECT 1 '+char(10)
  SET @v_dSql += '               FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK) '+char(10)
  SET @v_dSql += '               WHERE  A.COMPANY_ID   = B.COMPANY_ID '+char(10)
  SET @v_dSql += '               AND    A.DIVISION_ID  = B.DIVISION_ID '+char(10)
  SET @v_dSql += '               AND    A.SITE_ID      = B.SITE_ID '+char(10)
  SET @v_dSql += '               AND    B.USER_ID      = ' + @v_user_id+' '+char(10)
  SET @v_dSql += '               AND    B.SAVE_FLAG	   = ''Y'' '+char(10)
  SET @v_dSql += '         ) '+char(10)
  SET @v_dSql += ' ORDER BY A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, A.ITEM_ID, ISNULL(A.NICK_NAME,''-''), ITEM_TYPE '+char(10)


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00621_LINE_CN2_ITEM',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00621_LINE_CN2_ITEM',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
