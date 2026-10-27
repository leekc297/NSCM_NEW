CREATE PROCEDURE [dbo].[PR_UI_FP01624_FIND_FP01624_NEWREVISION]
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
/** 프로그램 ID   : PR_UI_FP01624_FIND_FP01624_NEWREVISION                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_FIND_FP01624_NEWREVISION                                                                          **/
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
/** 2021-05-11     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_FIND_FP01624_NEWREVISION
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_FIND_FP01624_NEWREVISION'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_plan_revision nvarchar(max) = ''
  DECLARE @p_plan_week nvarchar(max) = ''
  DECLARE @p_sub_info nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_plan_revision nvarchar(max)
  DECLARE @v_plan_week nvarchar(max)
  DECLARE @v_sub_info nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START

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
    END ELSE IF @tmp_column = 'PLAN_REVISION' BEGIN
      SET @p_plan_revision =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_WEEK' BEGIN
      SET @p_plan_week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SUB_INFO' BEGIN
      SET @p_sub_info =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_plan_revision ='''' + @p_plan_revision + ''''
  SET @v_plan_week ='''' + @p_plan_week + ''''
  SET @v_sub_info ='''' + @p_sub_info + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- FP01624 find_FP01624_newRevision  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH _PLAN_GROUP AS ('+char(10)
  SET @v_dSql += '          SELECT A.*'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '              SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA'+char(10)
  SET @v_dSql += '                   , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID'+char(10)
  SET @v_dSql += '                   , B.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                   , D.OPERATION_ID'+char(10)
  SET @v_dSql += '                   , E.LINE_ID'+char(10)
  SET @v_dSql += '                   , MAX(E.MODEL_TYPE) AS PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                   , FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                   , SCM_FACTORY_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                   , SCM_OPERATION_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                   , SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE  A.SEGMENT1         = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '              AND    B.FACTORY_ID       = C.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '              AND    C.COMPANY_ID       = D.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND    C.DIVISION_ID      = D.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND    C.SITE_ID          = D.SITE_ID'+char(10)
  SET @v_dSql += '              AND    C.COMPANY_ID       = E.COMPANY_ID'+char(10)
  SET @v_dSql += '              AND    C.DIVISION_ID      = E.DIVISION_ID'+char(10)
  SET @v_dSql += '              AND    C.SITE_ID          = E.SITE_ID'+char(10)
  SET @v_dSql += '              AND    C.PLANT_ID         = E.PLANT_ID'+char(10)
  SET @v_dSql += '              AND    C.FACTORY_ID       = E.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND    D.OPERATION_ID     = E.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+char(10)
  SET @v_dSql += '              AND    A.ATTRIBUTE1       = ''PLAN GROUP'''+char(10)
  SET @v_dSql += '              AND    A.SEGMENT1        != ''KR_CELL_M_P'''+char(10)
  SET @v_dSql += '              AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '              AND    B.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '              AND    C.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '              AND    D.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '              AND    E.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '              GROUP BY A.SEGMENT1, A.ATTRIBUTE1'+char(10)
  SET @v_dSql += '                     , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID'+char(10)
  SET @v_dSql += '                     , B.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                     , D.OPERATION_ID'+char(10)
  SET @v_dSql += '                     , E.LINE_ID'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '          WHERE A.INSTANCE_ID      = B.SEGMENT1'+char(10)
  SET @v_dSql += '          AND   A.PLAN_GROUP_ID    = B.SEGMENT2'+char(10)
  SET @v_dSql += '          AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'''+char(10)
  SET @v_dSql += '          AND   B.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      ,MAIN AS ('+char(10)
  SET @v_dSql += '          SELECT A.*'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '              SELECT A.*'+char(10)
  SET @v_dSql += '                  , ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID'+char(10)
  SET @v_dSql += '                                      ORDER BY     A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.INSTANCE_TYPE DESC, A.INSTANCE_ID ) AS ROW_NUM'+char(10)
  SET @v_dSql += '              FROM ('+char(10)
  SET @v_dSql += '                  SELECT * FROM _PLAN_GROUP'+char(10)
  SET @v_dSql += '                  UNION ALL'+char(10)
  SET @v_dSql += '                  SELECT A.*'+char(10)
  SET @v_dSql += '                  FROM ('+char(10)
  SET @v_dSql += '                      SELECT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA'+char(10)
  SET @v_dSql += '                           , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID'+char(10)
  SET @v_dSql += '                           , B.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                           , D.OPERATION_ID'+char(10)
  SET @v_dSql += '                           , E.LINE_ID'+char(10)
  SET @v_dSql += '                           , ''-'' AS PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '                      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                           , FP_INSTANCE_FACTORY_M B WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                           , SCM_FACTORY_M C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                           , SCM_OPERATION_M D WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                           , SCM_LINE_M E WITH(NOLOCK)'+char(10)
  SET @v_dSql += '                      WHERE  A.SEGMENT1         = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '                      AND    B.FACTORY_ID       = C.FACTORY_ID'+char(10)
  SET @v_dSql += '                      AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                      AND    C.COMPANY_ID       = D.COMPANY_ID'+char(10)
  SET @v_dSql += '                      AND    C.DIVISION_ID      = D.DIVISION_ID'+char(10)
  SET @v_dSql += '                      AND    C.SITE_ID          = D.SITE_ID'+char(10)
  SET @v_dSql += '                      AND    C.COMPANY_ID       = E.COMPANY_ID'+char(10)
  SET @v_dSql += '                      AND    C.DIVISION_ID      = E.DIVISION_ID'+char(10)
  SET @v_dSql += '                      AND    C.SITE_ID          = E.SITE_ID'+char(10)
  SET @v_dSql += '                      AND    C.PLANT_ID         = E.PLANT_ID'+char(10)
  SET @v_dSql += '                      AND    C.FACTORY_ID       = E.FACTORY_ID'+char(10)
  SET @v_dSql += '                      AND    D.OPERATION_ID     = E.OPERATION_ID'+char(10)
  SET @v_dSql += '                      AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'''+char(10)
  SET @v_dSql += '                      AND    A.ATTRIBUTE1       = ''BUILDING'''+char(10)
  SET @v_dSql += '                      AND    A.SEGMENT1        != ''KR_CELL_M_P'''+char(10)
  SET @v_dSql += '                      AND    A.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '                      AND    B.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '                      AND    C.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '                      AND    D.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '                      AND    E.ACTIVE_FLAG      = ''Y'''+char(10)
  SET @v_dSql += '                      GROUP BY A.SEGMENT1, A.ATTRIBUTE1'+char(10)
  SET @v_dSql += '                             , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID, B.FACTORY_ID'+char(10)
  SET @v_dSql += '                             , B.INSTANCE_TYPE'+char(10)
  SET @v_dSql += '                             , D.OPERATION_ID'+char(10)
  SET @v_dSql += '                             , E.LINE_ID'+char(10)
  SET @v_dSql += '                  ) A'+char(10)
  SET @v_dSql += '                  WHERE NOT EXISTS ('+char(10)
  SET @v_dSql += '                      SELECT 1'+char(10)
  SET @v_dSql += '                      FROM   _PLAN_GROUP BB'+char(10)
  SET @v_dSql += '                      WHERE  A.COMPANY_ID   = BB.COMPANY_ID'+char(10)
  SET @v_dSql += '                      AND    A.DIVISION_ID  = BB.DIVISION_ID'+char(10)
  SET @v_dSql += '                      AND    A.SITE_ID      = BB.SITE_ID'+char(10)
  SET @v_dSql += '                      AND    A.PLANT_ID     = BB.PLANT_ID'+char(10)
  SET @v_dSql += '                      AND    A.FACTORY_ID   = BB.FACTORY_ID'+char(10)
  SET @v_dSql += '                      AND    A.OPERATION_ID = BB.OPERATION_ID'+char(10)
  SET @v_dSql += '                      AND    A.LINE_ID      = BB.LINE_ID'+char(10)
  SET @v_dSql += '                  )'+char(10)
  SET @v_dSql += '              ) A'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          WHERE A.ROW_NUM = 1'+char(10)
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      , SUB AS ('+char(10)
  
  
  SET @v_dSql += @p_SUB_INFO+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --          var sql="";
  --          sql= $data.SUB_INFO;
  --          sql;
  --        }

  --'
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.*'+char(10)
  SET @v_dSql += '            , (CASE WHEN A.CONFIRM_AREA = ''BUILDING'' THEN A.FACTORY_ID ELSE A.PLAN_GROUP_ID END)'+char(10)
  SET @v_dSql += '            + ''_'' +'+char(10)
  SET @v_dSql += '' + @v_plan_revision+''+char(10)
  SET @v_dSql += '            + ''_'' + A.INSTANCE_ID'+char(10)
  SET @v_dSql += '            + ''_'' + (REPLICATE(''0'',3 - LEN(A.MAX_SEQ)) + CAST(A.MAX_SEQ AS VARCHAR))'+char(10)
  SET @v_dSql += '           AS NEW_PLAN_REVISION'+char(10)
  SET @v_dSql += '      FROM ('+char(10)
  SET @v_dSql += '          SELECT A.*'+char(10)
  SET @v_dSql += '               , CONVERT(NUMERIC, ISNULL(B.SEQ,''000''))+1 AS MAX_SEQ'+char(10)
  SET @v_dSql += '          FROM ('+char(10)
  SET @v_dSql += '              SELECT A.*, B.REV_TYPE'+char(10)
  SET @v_dSql += '              FROM   MAIN A, SUB B'+char(10)
  SET @v_dSql += '              WHERE  A.FACTORY_ID   = B.FACTORY_ID'+char(10)
  SET @v_dSql += '              AND    A.OPERATION_ID = B.OPERATION_ID'+char(10)
  SET @v_dSql += '              AND    A.LINE_ID      = B.LINE_ID'+char(10)
  SET @v_dSql += '          ) A'+char(10)
  SET @v_dSql += '          LEFT OUTER JOIN ('+char(10)
  SET @v_dSql += '              SELECT A.FACTORY_ID, A.PLAN_GROUP_ID, A.INSTANCE_ID, RIGHT(MAX(A.PLAN_REVISION),3) AS SEQ'+char(10)
  SET @v_dSql += '              FROM   FP_MPP_WPP_BASE_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '              WHERE  A.PLAN_WEEK  ='+char(10)
  SET @v_dSql += '' + @v_plan_week+''+char(10)
  SET @v_dSql += '              AND    A.PLAN_REVISION LIKE ''%'' +'+char(10)
  SET @v_dSql += '' + @v_plan_revision+''+char(10)
  SET @v_dSql += ' + ''%'''+char(10)
  SET @v_dSql += '              GROUP BY A.FACTORY_ID, A.PLAN_GROUP_ID, A.INSTANCE_ID'+char(10)
  SET @v_dSql += '          ) B'+char(10)
  SET @v_dSql += '          ON  A.FACTORY_ID    = (CASE WHEN B.FACTORY_ID = ''-'' THEN A.FACTORY_ID ELSE B.FACTORY_ID END)'+char(10)
  SET @v_dSql += '          AND A.INSTANCE_ID   = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '          AND A.PLAN_GROUP_ID = B.PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '      ) A'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --    		var param = $data.param;
  --    		$data.querySet1 = $jdbc.queryList("FP01624","find_FP01624_newRevision",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_FP01624_NEWREVISION',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_FP01624_NEWREVISION',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
