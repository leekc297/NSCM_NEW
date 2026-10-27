CREATE PROCEDURE [dbo].[PR_UI_COMMON_ITEM_STATUS]
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
/** 프로그램 ID   : PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG                                                                          **/
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
/** 2021-04-12     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_date nvarchar(max) = ''
  DECLARE @p_model_id nvarchar(max) = ''
  DECLARE @p_item_id nvarchar(max) = ''
  DECLARE @p_nick_name nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_date nvarchar(max)
  DECLARE @v_user_id nvarchar(max)
  DECLARE @v_model_id nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_nick_name nvarchar(max)
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

  DECLARE @JULY_EXCEPT nvarchar(2) = 'Y' 

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
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @p_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'NICK_NAME' BEGIN
      SET @p_nick_name =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
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
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''

  SET @STRLEN = LEN(@p_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_0model_id = ''
  END ELSE BEGIN
    SET @opt_0model_id = 'AND    A.ROOT LIKE ''%'' +  ' + @v_model_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_1item_id = ''
  END ELSE BEGIN
    SET @opt_1item_id = 'AND    A.PARENT_ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_2nick_name = ''
  END ELSE BEGIN
    SET @opt_2nick_name = 'AND    A.PARENT_NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END
  SET @STRLEN = LEN(@p_model_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_3model_id = ''
  END ELSE BEGIN
    SET @opt_3model_id = 'AND    A.ROOT LIKE ''%'' +  ' + @v_model_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_item_id)
  IF @STRLEN< 1  BEGIN
    SET @opt_4item_id = ''
  END ELSE BEGIN
    SET @opt_4item_id = 'AND    A.PARENT_ITEM_ID LIKE ''%'' + ' + @v_item_id+' + ''%'''
  END
  SET @STRLEN = LEN(@p_nick_name)
  IF @STRLEN< 1  BEGIN
    SET @opt_5nick_name = ''
  END ELSE BEGIN
    SET @opt_5nick_name = 'AND    A.PARENT_NICK_NAME LIKE ''%'' + ' + @v_nick_name+' + ''%'''
  END


  -- FP00602_addLine find_ItemList  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH INST_OP AS ('+char(10)
  SET @v_dSql += '        	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID'+char(10)
  SET @v_dSql += '        	FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	WHERE    A.INSTANCE_ID  ='+char(10)
  SET @v_dSql += '' + @v_instance_id+''+char(10)
  SET @v_dSql += '        	AND    A.AMEND_FLAG   = ''Y'''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , CTE_NODE(COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,PARENT_ITEM_ID,CHILD_ITEM_ID,KEY_DATE,EFF_START_DATE,EFF_END_DATE,PARENT_QTY,PARENT_UOM,CHILD_QTY,CHILD_UOM'+char(10)
  SET @v_dSql += '      	,PARENT_ITEM_TYPE,PARENT_ITEM_CLASS,PARENT_NICK_NAME,PARENT_LEVEL_2_CODE,PARENT_LEVEL_3_NAME,PARENT_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '      	,CHILD_ITEM_TYPE,CHILD_ITEM_CLASS,CHILD_NICK_NAME,CHILD_LEVEL_2_CODE,CHILD_LEVEL_3_NAME,CHILD_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '      	,NLEVEL,NPATH,ROOT, FLOW_ID)'+char(10)
  SET @v_dSql += '      AS ('+char(10)
  SET @v_dSql += '        	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE,A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM'+char(10)
  SET @v_dSql += '        		 , PD1.ITEM_TYPE AS PARENT_ITEM_TYPE'+char(10)
  SET @v_dSql += '        		 , PD1.ITEM_CLASS AS PARENT_ITEM_CLASS'+char(10)
  SET @v_dSql += '        		 , PD1.NICK_NAME AS PARENT_NICK_NAME'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_4_NAME AS PARENT_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '        		 , PD2.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '        		 , PD2.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '        		 , PD2.NICK_NAME AS CHILD_NICK_NAME'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_4_NAME AS CHILD_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '        		 , 1 AS NLEVEL,CONVERT(VARCHAR(100),PARENT_ITEM_ID+''/''+CHILD_ITEM_ID) AS NPATH,PARENT_ITEM_ID AS ROOT'+char(10)
  SET @v_dSql += '        		 , PD1.FLOW_ID'+char(10)

  IF @JULY_EXCEPT = 'Y' -- 20230613 Assy Changes
	SET @v_dSql += '        	FROM SCM_BOM_M_V A WITH(NOLOCK)'+char(10)
  ELSE -- ORG
	SET @v_dSql += '        	FROM SCM_BOM_M A WITH(NOLOCK)'+char(10)

  SET @v_dSql += '        	INNER JOIN SCM_ITEM_M PD1 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  A.COMPANY_ID     = PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND A.DIVISION_ID    = PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND A.SITE_ID        = PD1.SITE_ID'+char(10)
  SET @v_dSql += '        	AND A.PARENT_ITEM_ID = PD1.ITEM_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M PDC1 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON PD1.ITEM_CLASS = PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_M PD2 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  A.COMPANY_ID    = PD2.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND A.DIVISION_ID   = PD2.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND A.SITE_ID       = PD2.SITE_ID'+char(10)
  SET @v_dSql += '        	AND A.CHILD_ITEM_ID = PD2.ITEM_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M PDC2 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON PD2.ITEM_CLASS=PDC2.CLASS_ID'+char(10)
  SET @v_dSql += '          , INST_OP D'+char(10)
  SET @v_dSql += '        	WHERE 1=1'+char(10)
  SET @v_dSql += '        	AND   A.COMPANY_ID  = D.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND   A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND   A.SITE_ID     = D.SITE_ID'+char(10)
  SET @v_dSql += '        	AND   PD1.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%'''+char(10)
  SET @v_dSql += '        	AND   A.EFF_START_DATE <='+char(10)
  SET @v_dSql += '' + @v_date+''+char(10)
  SET @v_dSql += '        	AND   A.EFF_END_DATE   >'+char(10)
  SET @v_dSql += '' + @v_date+''+char(10)
  SET @v_dSql += '        	AND   A.ACTIVE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PD1.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PDC1.USE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PD2.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PDC2.USE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '        	UNION ALL'+char(10)
  SET @v_dSql += '        	SELECT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.PARENT_ITEM_ID,A.CHILD_ITEM_ID,A.KEY_DATE,A.EFF_START_DATE,A.EFF_END_DATE,A.PARENT_QTY,A.PARENT_UOM,A.CHILD_QTY,A.CHILD_UOM'+char(10)
  SET @v_dSql += '        		 , PD1.ITEM_TYPE AS PARENT_ITEM_TYPE'+char(10)
  SET @v_dSql += '        		 , PD1.ITEM_CLASS AS PARENT_ITEM_CLASS'+char(10)
  SET @v_dSql += '        		 , PD1.NICK_NAME AS PARENT_NICK_NAME'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        		 , PDC1.LEVEL_4_NAME AS PARENT_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '        		 , PD2.ITEM_TYPE AS CHILD_ITEM_TYPE'+char(10)
  SET @v_dSql += '        		 , PD2.ITEM_CLASS AS CHILD_ITEM_CLASS'+char(10)
  SET @v_dSql += '        		 , PD2.NICK_NAME AS CHILD_NICK_NAME'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME'+char(10)
  SET @v_dSql += '        		 , PDC2.LEVEL_4_NAME AS CHILD_LEVEL_4_NAME'+char(10)
  SET @v_dSql += '        		 , NLEVEL+1 AS NLEVEL ,CONVERT(VARCHAR(100),NPATH+''/''+A.CHILD_ITEM_ID) AS NPATH,ROOT'+char(10)
  SET @v_dSql += '        		 , PD1.FLOW_ID'+char(10)
  
    IF @JULY_EXCEPT = 'Y' -- 20230613 Assy Changes
	SET @v_dSql += '        	FROM SCM_BOM_M_V A WITH(NOLOCK)'+char(10)
  ELSE -- ORG
	SET @v_dSql += '        	FROM SCM_BOM_M A WITH(NOLOCK)'+char(10)

  SET @v_dSql += '        	INNER JOIN CTE_NODE B'+char(10)
  SET @v_dSql += '        	ON  A.PARENT_ITEM_ID = B.CHILD_ITEM_ID'+char(10)
  SET @v_dSql += '        	AND A.COMPANY_ID     = B.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND A.DIVISION_ID    = B.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND A.SITE_ID        = B.SITE_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_M PD1 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  A.COMPANY_ID     = PD1.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND A.DIVISION_ID    = PD1.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND A.SITE_ID        = PD1.SITE_ID'+char(10)
  SET @v_dSql += '        	AND A.PARENT_ITEM_ID = PD1.ITEM_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M PDC1 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  PD1.ITEM_CLASS = PDC1.CLASS_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_M PD2 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  A.COMPANY_ID    = PD2.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND A.DIVISION_ID   = PD2.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND A.SITE_ID       = PD2.SITE_ID'+char(10)
  SET @v_dSql += '        	AND A.CHILD_ITEM_ID = PD2.ITEM_ID'+char(10)
  SET @v_dSql += '        	INNER JOIN SCM_ITEM_CLASS_M PDC2 WITH(NOLOCK)'+char(10)
  SET @v_dSql += '        	ON  PD2.ITEM_CLASS=PDC2.CLASS_ID'+char(10)
  SET @v_dSql += '          , INST_OP D'+char(10)
  SET @v_dSql += '        	WHERE 1=1'+char(10)
  SET @v_dSql += '        	AND   A.COMPANY_ID  = D.COMPANY_ID'+char(10)
  SET @v_dSql += '        	AND   A.DIVISION_ID = D.DIVISION_ID'+char(10)
  SET @v_dSql += '        	AND   A.SITE_ID     = D.SITE_ID'+char(10)
  SET @v_dSql += '        	AND   PD1.FLOW_ID LIKE ''%'' + D.OPERATION_ID + ''%'''+char(10)
  SET @v_dSql += '        	AND   A.EFF_START_DATE <='+char(10)
  SET @v_dSql += '' + @v_date+''+char(10)
  SET @v_dSql += ' -- 입력일자 기준으로 ECO 일자 지정'+char(10)
  SET @v_dSql += '        	AND   A.EFF_END_DATE   >'+char(10)
  SET @v_dSql += '' + @v_date+''+char(10)
  SET @v_dSql += '        	AND   PD1.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PDC1.USE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PD2.ACTIVE_FLAG  = ''Y'''+char(10)
  SET @v_dSql += '        	AND   PDC2.USE_FLAG    = ''Y'''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT DISTINCT A.*'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ROOT AS MODEL_ID, A.PARENT_ITEM_ID AS ITEM_ID'+char(10)
  SET @v_dSql += '          	 , A.PARENT_NICK_NAME AS NICK_NAME'+char(10)
  SET @v_dSql += '          	 , (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND  ISNULL(A.PARENT_LEVEL_4_NAME, ''-'') = ''-'' THEN A.PARENT_LEVEL_3_NAME'+char(10)
  SET @v_dSql += '          			 WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(A.PARENT_LEVEL_4_NAME, ''-'')'+char(10)
  SET @v_dSql += '          			 ELSE A.PARENT_LEVEL_3_NAME END) AS ITEM_TYPE'+char(10)
  SET @v_dSql += '          FROM   CTE_NODE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID  = B.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID = B.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID     = B.SITE_ID'+char(10)
  SET @v_dSql += '          AND    A.ROOT        = B.ITEM_ID'+char(10)
  SET @v_dSql += '          INNER HASH JOIN ('+char(10)
  SET @v_dSql += '              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID'+char(10)
  SET @v_dSql += '              FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE  B.USER_ID   = ' + @v_user_id + ' '+char(10)
  SET @v_dSql += '              AND    B.SAVE_FLAG = ''Y'' '+char(10)
  SET @v_dSql += '          ) C'+char(10)
  SET @v_dSql += '          ON     A.COMPANY_ID  = C.COMPANY_ID'+char(10)
  SET @v_dSql += '          AND    A.DIVISION_ID = C.DIVISION_ID'+char(10)
  SET @v_dSql += '          AND    A.SITE_ID     = C.SITE_ID'+char(10)
  SET @v_dSql += '          WHERE  1=1'+char(10)
  SET @v_dSql += '          --AND    B.ITEM_TYPE   = ''P'''+char(10)
  SET @v_dSql += '          AND    RIGHT(B.FLOW_ID,5) IN (''A3000'',''A9000'')'+char(10)

  IF @JULY_EXCEPT = 'Y' -- 20230613 Assy Changes
	SET @v_dSql += '       AND NOT ( a.PARENT_ITEM_ID = a.ROOT AND a.site_id = ''A001'' ) '+char(10)
  


  SET @v_dSql += ' ' +@opt_0model_id +' '+''+char(10)--AND    A.ROOT LIKE '%' +  #MODEL_ID# + '%'
  SET @v_dSql += ' ' +@opt_1item_id +' '+''+char(10)--AND    A.PARENT_ITEM_ID LIKE '%' + #ITEM_ID# + '%'
  SET @v_dSql += ' ' +@opt_2nick_name +' '+''+char(10)--AND    A.PARENT_NICK_NAME LIKE '%' + #NICK_NAME# + '%'
  SET @v_dSql += '      ) A'+char(10)
  SET @v_dSql += '      ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, ITEM_ID, NICK_NAME, ITEM_TYPE'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00602_addLine","find_ItemList",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00602_ADDLINE_FIND_ITEMLISTORG',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
