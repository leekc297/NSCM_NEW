
CREATE   PROCEDURE [dbo].[PR_UI_FP00740_FIND_FP00740]
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
/** 프로그램 ID   : PR_UI_FP00740_FIND_FP00740                                                **/
/** 프로그램 명   : Procedure PR_UI_FP00740_FIND_FP00740                                      **/
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
/** 2025-05-14     LJS      [E20251216-000584] - 이론재고 관리                  **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00740_FIND_FP00740
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00740_FIND_FP00740'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0

  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plant_id nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_line_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_chk_line_assign nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

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
    END ELSE IF @tmp_column = 'PLANT_ID' BEGIN
      SET @p_plant_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LINE_ID' BEGIN
      SET @p_line_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'CHK_LINE_ASSIGN' BEGIN
      SET @p_chk_line_assign =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_user_id ='''' + @p_user_id + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''


  SET @v_dSql = ''
  SET @v_dSql += 'SELECT A.* ' + char(10)
  SET @v_dSql += '     , CONVERT(NUMERIC(20,3), ROUND(B.THEORY_STOCK_QTY,3)) AS THEORY_STOCK_QTY, B.ACTIVE_FLAG ' + char(10)
  SET @v_dSql += '     , D.EDIT_YN, ''' + @p_user_id + ''' AS USER_ID ' + char(10)
  SET @v_dSql += 'FROM ( ' + char(10)
  SET @v_dSql += '	SELECT A.* ' + char(10)
  SET @v_dSql += '		 , B.ITEM_ID, B.NICK_NAME, C.LINE_NAME ' + char(10)
  SET @v_dSql += '	FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	ON  1=1 ' + char(10)
  SET @v_dSql += '	AND A.COMPANY_ID   = B.COMPANY_ID ' + char(10)
  SET @v_dSql += '	AND A.DIVISION_ID  = B.DIVISION_ID ' + char(10)
  SET @v_dSql += '	AND A.SITE_ID      = B.SITE_ID ' + char(10)
  SET @v_dSql += '	AND A.OPERATION_ID = RIGHT(B.FLOW_ID, 5) ' + char(10)
  SET @v_dSql += '	INNER JOIN SCM_ITEM_CLASS_M BB WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	ON  1=1 ' + char(10)
  SET @v_dSql += '	AND B.ITEM_CLASS = BB.CLASS_ID ' + char(10)
  SET @v_dSql += '	INNER JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	ON  1=1 ' + char(10)
  SET @v_dSql += '	AND A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
  SET @v_dSql += '	AND A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
  SET @v_dSql += '	AND A.SITE_ID        = C.SITE_ID ' + char(10)
  SET @v_dSql += '	AND A.PLANT_ID       = C.PLANT_ID ' + char(10)
  SET @v_dSql += '	AND A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
  SET @v_dSql += '	AND A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
  SET @v_dSql += '	AND A.LINE_ID        = C.LINE_ID ' + char(10)
  SET @v_dSql += '	AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += '	AND (CASE WHEN SUBSTRING(BB.LEVEL_3_CODE,4,1) = ''A'' THEN ''Anode'' ELSE ''Cathode'' END) = C.ELECTRODE_TYPE ' + char(10) -- Anode, Cathode 아이템코드 - line 의 elec type 매핑 조건 추가
  SET @v_dSql += '	WHERE 1=1 ' + char(10)
  SET @v_dSql += '	AND   C.ACTIVE_FLAG = ''Y'' ' + char(10)
  SET @v_dSql += '	AND   B.ACTIVE_FLAG = ''Y'' ' + char(10)
  SET @v_dSql += '	AND   BB.USE_FLAG = ''Y'' ' + char(10)
  SET @v_dSql += '	AND   A.OPERATION_ID IN ( ''E1000'', ''E0430'' ) ' + char(10)
  SET @v_dSql += '	AND   RIGHT(B.FLOW_ID, 5) IN ( ''E1000'', ''E0430'' ) ' + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.LINE_ID' , 'EQ', @p_line_id))
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.ITEM_ID' , 'EQ', @p_item_id)) + char(10)
  SET @v_dSql += ') A ' + char(10)
  SET @v_dSql += 'LEFT OUTER JOIN FP_THEORY_STOCK_M B WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'ON  1=1 ' + char(10)
  SET @v_dSql += 'AND A.FACTORY_ID     = B.FACTORY_ID ' + char(10)
  SET @v_dSql += 'AND A.OPERATION_ID   = B.OPERATION_ID ' + char(10)
  SET @v_dSql += 'AND A.LINE_ID        = B.LINE_ID ' + char(10)
  SET @v_dSql += 'AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += 'AND A.ITEM_ID        = B.ITEM_ID ' + char(10)
  -- line assign 조건 추가 자리
  if @p_chk_line_assign = 'Y' begin
	  SET @v_dSql += 'INNER JOIN SCM_ITEM_LINE_ASSIGN_M C WITH(NOLOCK) ' + char(10)
	  SET @v_dSql += 'ON  1=1 ' + char(10)
	  SET @v_dSql += 'AND A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
	  SET @v_dSql += 'AND A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
	  SET @v_dSql += 'AND A.SITE_ID        = C.SITE_ID ' + char(10)
	  SET @v_dSql += 'AND A.PLANT_ID       = C.PLANT_ID ' + char(10)
	  SET @v_dSql += 'AND A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
	  SET @v_dSql += 'AND A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
	  SET @v_dSql += 'AND A.LINE_ID        = C.LINE_ID ' + char(10)
	  SET @v_dSql += 'AND A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
	  SET @v_dSql += 'AND A.ITEM_ID        = C.ITEM_ID ' + char(10)
	  SET @v_dSql += 'AND C.MONTH          = CONVERT(VARCHAR(6) ,GETDATE(), 112) ' + char(10)
	  SET @v_dSql += 'AND C.ACTIVE_FLAG    = ''Y'' ' + char(10)
	  SET @v_dSql += 'AND C.PRIORITY IN (1,2,3,4,5,6,7,8) ' + char(10)
  end

  SET @v_dSql += 'LEFT OUTER JOIN ( ' + char(10)
  SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, (CASE WHEN MAX(SAVE_FLAG) = ''Y'' THEN ''Y'' ELSE ''N'' END) AS EDIT_YN ' + char(10)
  SET @v_dSql += '	FROM   FP_USER_ROLE_INFO_V D WITH(NOLOCK) ' + char(10)
  SET @v_dSql += '	WHERE  D.USER_ID = ''' + @p_user_id + ''' ' + char(10)
  SET @v_dSql += '	GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += ') D ' + char(10)
  SET @v_dSql += 'ON  A.COMPANY_ID     = D.COMPANY_ID ' + char(10)
  SET @v_dSql += 'AND A.DIVISION_ID    = D.DIVISION_ID ' + char(10)
  SET @v_dSql += 'AND A.SITE_ID        = D.SITE_ID ' + char(10)
  SET @v_dSql += 'AND A.PLANT_ID       = D.PLANT_ID ' + char(10)
  SET @v_dSql += 'AND A.FACTORY_ID     = D.FACTORY_ID ' + char(10)
  SET @v_dSql += 'AND A.OPERATION_ID   = D.OPERATION_ID ' + char(10)
  SET @v_dSql += 'AND A.LINE_ID        = D.LINE_ID ' + char(10)
  SET @v_dSql += 'AND A.ELECTRODE_TYPE = D.ELECTRODE_TYPE ' + char(10)
  SET @v_dSql += 'ORDER BY INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, ITEM_ID ' + char(10)


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
      exec PR_UI_SQL_LOG 'PR_UI_FP00740_FIND_FP00740',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00740_FIND_FP00740',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
