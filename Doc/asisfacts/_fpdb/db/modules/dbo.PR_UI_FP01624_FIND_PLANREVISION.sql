CREATE PROCEDURE [dbo].[PR_UI_FP01624_FIND_PLANREVISION]
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
/** 프로그램 ID   : PR_UI_FP01624_FIND_PLANREVISION                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP01624_FIND_PLANREVISION                                                                          **/
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
/** 2021-04-22     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01624_FIND_PLANREVISION
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01624_FIND_PLANREVISION'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_mpp_wpp_plan_type nvarchar(max) = ''
  DECLARE @p_last_revision nvarchar(max) = ''
  DECLARE @p_plan_week nvarchar(max) = ''
  DECLARE @p_factory_id nvarchar(max) = ''
  DECLARE @p_plan_month nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_mpp_wpp_plan_type nvarchar(max)
  DECLARE @v_last_revision nvarchar(max)
  DECLARE @v_plan_week nvarchar(max)
  DECLARE @v_factory_lt nvarchar(max)
  DECLARE @v_plan_month nvarchar(max)
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
    END ELSE IF @tmp_column = 'MPP_WPP_PLAN_TYPE' BEGIN
      SET @p_mpp_wpp_plan_type =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'LAST_REVISION' BEGIN
      SET @p_last_revision =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_WEEK' BEGIN
      SET @p_plan_week =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'FACTORY_ID' BEGIN
      SET @p_factory_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_MONTH' BEGIN
      SET @p_plan_month =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_mpp_wpp_plan_type ='''' + @p_mpp_wpp_plan_type + ''''
  SET @v_last_revision ='''' + @p_last_revision + ''''
  SET @v_plan_week ='''' + @p_plan_week + ''''
  SET @v_factory_lt ='''' + @p_factory_id + ''''
  SET @v_plan_month ='''' + @p_plan_month + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''



  -- FP01624 find_PlanRevision  
  SET @v_dSql = ''
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --        var sql="";
  --        var sType = $data.MPP_WPP_PLAN_TYPE;
  --        var sLast = $data.LAST_REVISION;
  --
  --        if(sType == "WPP" || sType == "MRP" || sType == "WO") {
  --          if(sLast == "Y") {
  IF @p_MPP_WPP_PLAN_TYPE = 'WPP' OR @p_MPP_WPP_PLAN_TYPE = 'MRP' OR @p_MPP_WPP_PLAN_TYPE = 'WO' BEGIN
	  IF @p_LAST_REVISION='Y' BEGIN
		  SET @v_dSql += 'SELECT DISTINCT A.* ' + char(10)
		  SET @v_dSql += 'FROM ( ' + char(10)
		  SET @v_dSql += '  SELECT *,1 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '  FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT ROW_NUMBER() OVER ( PARTITION BY PLAN_WEEK, FACTORY_ID, INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                               ORDER BY     PLAN_WEEK, FACTORY_ID, INSTANCE_ID, INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '          ,PLAN_REVISION AS CODE, PLAN_REVISION AS NAME ' + char(10)
		  SET @v_dSql += '    FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '    WHERE  PLAN_WEEK = ''' + @p_PLAN_WEEK + ''' ' + char(10)
		  SET @v_dSql += '    AND    ' + @p_MPP_WPP_PLAN_TYPE + ' = ''Y'' ' + char(10)
		  SET @v_dSql += '    AND    H.PLAN_GROUP_ID = ''-'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('H.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  --            if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
		  --                sql+= "AND   H.FACTORY_ID IN (" + $data.FACTORY_LT + ")' + char(10)
		  --            }
		  SET @v_dSql += '  ) A  ' + char(10)
		  SET @v_dSql += '  WHERE A.NUMES = 1 ' + char(10)
		  SET @v_dSql += '  UNION ALL ' + char(10)
		  SET @v_dSql += '  SELECT A.*, 2 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '  FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT DISTINCT ROW_NUMBER() OVER ( PARTITION BY A.PLAN_WEEK, A.PLAN_GROUP_ID, A.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                        ORDER BY     A.PLAN_WEEK, A.PLAN_GROUP_ID, A.INSTANCE_ID, A.INSERT_TIME DESC ) AS NUMES, ' + char(10)
		  SET @v_dSql += '          A.PLAN_REVISION AS CODE, A.PLAN_REVISION AS NAME ' + char(10)
		  SET @v_dSql += '    FROM   FP_MPP_WPP_BASE_PLAN_H A WITH(NOLOCK), ( ' + char(10)
		  SET @v_dSql += '        SELECT A.* ' + char(10)
		  SET @v_dSql += '        FROM ( ' + char(10)
		  SET @v_dSql += '            SELECT distinct A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
		  SET @v_dSql += '                 , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID ' + char(10)
		  SET @v_dSql += '                 , E.MODEL_TYPE AS PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_FACTORY_M C WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_LINE_M E WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '            WHERE  A.SEGMENT1         = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '            AND    B.FACTORY_ID       = C.FACTORY_ID ' + char(10)
		  SET @v_dSql += '            AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE ' + char(10)
		  SET @v_dSql += '            AND    C.COMPANY_ID       = D.COMPANY_ID ' + char(10)
		  SET @v_dSql += '            AND    C.DIVISION_ID      = D.DIVISION_ID ' + char(10)
		  SET @v_dSql += '            AND    C.SITE_ID          = D.SITE_ID ' + char(10)
		  SET @v_dSql += '            AND    C.COMPANY_ID       = E.COMPANY_ID ' + char(10)
		  SET @v_dSql += '            AND    C.DIVISION_ID      = E.DIVISION_ID ' + char(10)
		  SET @v_dSql += '            AND    C.SITE_ID          = E.SITE_ID ' + char(10)
		  SET @v_dSql += '            AND    C.PLANT_ID         = E.PLANT_ID ' + char(10)
		  SET @v_dSql += '            AND    C.FACTORY_ID       = E.FACTORY_ID ' + char(10)
		  SET @v_dSql += '            AND    D.OPERATION_ID     = E.OPERATION_ID ' + char(10)
		  SET @v_dSql += '            AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		  SET @v_dSql += '            AND    A.ATTRIBUTE1       = ''PLAN GROUP'' ' + char(10)
		  SET @v_dSql += '            AND    A.SEGMENT1        != ''KR_CELL_M_P'' ' + char(10)
		  SET @v_dSql += '            AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    C.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    D.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    E.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  --            if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
		  --                sql+= "            AND   C.FACTORY_ID IN (" + $data.FACTORY_LT + ")' + char(10)
		  --            }
		  SET @v_dSql += '        ) A ' + char(10)
		  SET @v_dSql += '        , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '        WHERE A.INSTANCE_ID      = B.SEGMENT1 ' + char(10)
		  SET @v_dSql += '        AND   A.PLAN_GROUP_ID    = B.SEGMENT2 ' + char(10)
		  SET @v_dSql += '        AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
		  SET @v_dSql += '        AND   B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '    ) B ' + char(10)
		  SET @v_dSql += '    WHERE  A.INSTANCE_ID    = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '    AND    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
		  SET @v_dSql += '    AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		  SET @v_dSql += '    AND    A.SITE_ID        = B.SITE_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLANT_ID       = B.PLANT_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_GROUP_ID  = B.PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_WEEK      = ''' + @p_PLAN_WEEK + ''' ' + char(10)
		  SET @v_dSql += '    AND    A.' + @p_MPP_WPP_PLAN_TYPE + ' = ''Y'' ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_GROUP_ID <> ''-'' ' + char(10)
		  SET @v_dSql += '  ) A ' + char(10)
		  SET @v_dSql += '  WHERE NUMES = 1 ' + char(10)
		  SET @v_dSql += ') A ' + char(10)
		  SET @v_dSql += 'ORDER BY PLAN_TYPE, CODE' + char(10)
	  END -- end of IF @p_LAST_REVISION='Y' BEGIN
	  ELSE BEGIN
		  --          }
		  --          else {
		  SET @v_dSql += 'SELECT DISTINCT A.* ' + char(10)
		  SET @v_dSql += 'FROM ( ' + char(10)
		  SET @v_dSql += '  SELECT *,1 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '  FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT ROW_NUMBER() OVER ( PARTITION BY PLAN_WEEK, FACTORY_ID, INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                               ORDER BY     PLAN_WEEK, FACTORY_ID, INSTANCE_ID, INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '          ,PLAN_REVISION AS CODE, PLAN_REVISION AS NAME ' + char(10)
		  SET @v_dSql += '    FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '    WHERE  PLAN_WEEK = ''' + @p_PLAN_WEEK + ''' ' + char(10)
		  SET @v_dSql += '    AND    ' + @p_MPP_WPP_PLAN_TYPE + ' = ''Y'' ' + char(10)
		  SET @v_dSql += '    AND    H.PLAN_GROUP_ID = ''-'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('H.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  --            if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
		  --                sql+= "AND   H.FACTORY_ID IN (" + $data.FACTORY_LT + ")' + char(10)
		  --            }
		  SET @v_dSql += '  ) A  ' + char(10)
		  SET @v_dSql += '  UNION ALL ' + char(10)
		  SET @v_dSql += '  SELECT A.*,2 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '  FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT DISTINCT ROW_NUMBER() OVER ( PARTITION BY A.PLAN_WEEK, A.PLAN_GROUP_ID, A.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                        ORDER BY     A.PLAN_WEEK, A.PLAN_GROUP_ID, A.INSTANCE_ID, A.INSERT_TIME DESC ) AS NUMES, ' + char(10)
		  SET @v_dSql += '          A.PLAN_REVISION AS CODE, A.PLAN_REVISION AS NAME ' + char(10)
		  SET @v_dSql += '    FROM   FP_MPP_WPP_BASE_PLAN_H A WITH(NOLOCK), ( ' + char(10)
		  SET @v_dSql += '        SELECT A.* ' + char(10)
		  SET @v_dSql += '        FROM ( ' + char(10)
		  SET @v_dSql += '            SELECT distinct A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
		  SET @v_dSql += '                 , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID ' + char(10)
		  SET @v_dSql += '                 , E.MODEL_TYPE AS PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '            FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_FACTORY_M C WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                 , SCM_LINE_M E WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '            WHERE  A.SEGMENT1         = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '            AND    B.FACTORY_ID       = C.FACTORY_ID ' + char(10)
		  SET @v_dSql += '            AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE ' + char(10)
		  SET @v_dSql += '            AND    C.COMPANY_ID       = D.COMPANY_ID ' + char(10)
		  SET @v_dSql += '            AND    C.DIVISION_ID      = D.DIVISION_ID ' + char(10)
		  SET @v_dSql += '            AND    C.SITE_ID          = D.SITE_ID ' + char(10)
		  SET @v_dSql += '            AND    C.COMPANY_ID       = E.COMPANY_ID ' + char(10)
		  SET @v_dSql += '            AND    C.DIVISION_ID      = E.DIVISION_ID ' + char(10)
		  SET @v_dSql += '            AND    C.SITE_ID          = E.SITE_ID ' + char(10)
		  SET @v_dSql += '            AND    C.PLANT_ID         = E.PLANT_ID ' + char(10)
		  SET @v_dSql += '            AND    C.FACTORY_ID       = E.FACTORY_ID ' + char(10)
		  SET @v_dSql += '            AND    D.OPERATION_ID     = E.OPERATION_ID ' + char(10)
		  SET @v_dSql += '            AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		  SET @v_dSql += '            AND    A.ATTRIBUTE1       = ''PLAN GROUP'' ' + char(10)
		  SET @v_dSql += '            AND    A.SEGMENT1        != ''KR_CELL_M_P'' ' + char(10)
		  SET @v_dSql += '            AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    C.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    D.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '            AND    E.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  --            if($data.FACTORY_LT != null && $data.FACTORY_LT != ""){
		  --                sql+= "            AND   C.FACTORY_ID IN (" + $data.FACTORY_LT + ")' + char(10)
		  --            }
		  SET @v_dSql += '        ) A ' + char(10)
		  SET @v_dSql += '        , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '        WHERE A.INSTANCE_ID      = B.SEGMENT1 ' + char(10)
		  SET @v_dSql += '        AND   A.PLAN_GROUP_ID    = B.SEGMENT2 ' + char(10)
		  SET @v_dSql += '        AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
		  SET @v_dSql += '        AND   B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '    ) B ' + char(10)
		  SET @v_dSql += '    WHERE  A.INSTANCE_ID    = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '    AND    A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
		  SET @v_dSql += '    AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		  SET @v_dSql += '    AND    A.SITE_ID        = B.SITE_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLANT_ID       = B.PLANT_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_GROUP_ID  = B.PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_WEEK      = ''' + @p_PLAN_WEEK + ''' ' + char(10)
		  SET @v_dSql += '    AND    A.' + @p_MPP_WPP_PLAN_TYPE + ' = ''Y'' ' + char(10)
		  SET @v_dSql += '    AND    A.PLAN_GROUP_ID <> ''-'' ' + char(10)
		  SET @v_dSql += '  ) A ' + char(10)
		  SET @v_dSql += ') A ' + char(10)
		  SET @v_dSql += 'ORDER BY PLAN_TYPE, CODE'+char(10)
	  END -- end of IF @p_LAST_REVISION='Y' BEGIN END ELSE
  END --end of IF @p_MPP_WPP_PLAN_TYPE = 'WPP' OR @p_MPP_WPP_PLAN_TYPE = 'MRP' OR @p_MPP_WPP_PLAN_TYPE = 'WO' BEGIN
  ELSE BEGIN
	  --          }
	  --        }
	  --        else {  // MPP
	  --          if(sLast == "Y") {
	  IF @p_LAST_REVISION='Y' BEGIN
		  SET @v_dSql += 'SELECT A.* ' + char(10)
		  SET @v_dSql += 'FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT *, 1 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '    FROM   ( ' + char(10)
		  SET @v_dSql += '       SELECT ROW_NUMBER() OVER ( PARTITION BY FACTORY_ID, PLAN_GROUP_ID, INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                  ORDER BY     FACTORY_ID, PLAN_GROUP_ID, INSTANCE_ID, INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '';'' + H.PLAN_WEEK AS CODE ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '' ('' + H.PLAN_WEEK + '')'' AS NAME ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_WEEK, H.PLAN_REVISION ' + char(10)
		  SET @v_dSql += '             ,B.DATED1 AS START_DATE ' + char(10)
		  SET @v_dSql += '       FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '       INNER JOIN TH_UIS_CALENDAR B ' + char(10)
		  SET @v_dSql += '       ON     H.PLAN_WEEK = B.D0 ' + char(10)
		  SET @v_dSql += '       WHERE  H.MPP = ''Y'' ' + char(10)
		  SET @v_dSql += '       AND    H.PLAN_MONTH = ''' + @p_PLAN_MONTH + ''' ' + char(10)
		  SET @v_dSql += '       AND    H.PLAN_GROUP_ID = ''-'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('H.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  SET @v_dSql += '    ) PH ' + char(10)
		  SET @v_dSql += '    WHERE PH.NUMES = 1 ' + char(10)
		  SET @v_dSql += '    UNION ALL ' + char(10)
		  SET @v_dSql += '    SELECT *, 2 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '    FROM   ( ' + char(10)
		  SET @v_dSql += '        SELECT ROW_NUMBER() OVER ( PARTITION BY H.FACTORY_ID, H.PLAN_GROUP_ID, H.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                   ORDER BY     H.FACTORY_ID, H.PLAN_GROUP_ID, H.INSTANCE_ID, H.INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '';'' + H.PLAN_WEEK AS CODE ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '' ('' + H.PLAN_WEEK + '')'' AS NAME ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_WEEK, H.PLAN_REVISION ' + char(10)
		  SET @v_dSql += '             ,C.DATED1 AS START_DATE ' + char(10)
		  SET @v_dSql += '        FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '        , ( ' + char(10)
		  SET @v_dSql += '            SELECT A.* ' + char(10)
		  SET @v_dSql += '            FROM ( ' + char(10)
		  SET @v_dSql += '                SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
		  SET @v_dSql += '                     , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID ' + char(10)
		  SET @v_dSql += '                     , E.MODEL_TYPE AS PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_FACTORY_M C WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_LINE_M E WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                WHERE  A.SEGMENT1         = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                AND    B.FACTORY_ID       = C.FACTORY_ID ' + char(10)
		  SET @v_dSql += '                AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE ' + char(10)
		  SET @v_dSql += '                AND    C.COMPANY_ID       = D.COMPANY_ID ' + char(10)
		  SET @v_dSql += '                AND    C.DIVISION_ID      = D.DIVISION_ID ' + char(10)
		  SET @v_dSql += '                AND    C.SITE_ID          = D.SITE_ID ' + char(10)
		  SET @v_dSql += '                AND    C.COMPANY_ID       = E.COMPANY_ID ' + char(10)
		  SET @v_dSql += '                AND    C.DIVISION_ID      = E.DIVISION_ID ' + char(10)
		  SET @v_dSql += '                AND    C.SITE_ID          = E.SITE_ID ' + char(10)
		  SET @v_dSql += '                AND    C.PLANT_ID         = E.PLANT_ID ' + char(10)
		  SET @v_dSql += '                AND    C.FACTORY_ID       = E.FACTORY_ID ' + char(10)
		  SET @v_dSql += '                AND    D.OPERATION_ID     = E.OPERATION_ID ' + char(10)
		  SET @v_dSql += '                AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		  SET @v_dSql += '                AND    A.ATTRIBUTE1       = ''PLAN GROUP'' ' + char(10)
		  SET @v_dSql += '                AND    A.SEGMENT1        != ''KR_CELL_M_P'' ' + char(10)
		  SET @v_dSql += '                AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    C.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    D.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    E.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  SET @v_dSql += '            ) A ' + char(10)
		  SET @v_dSql += '            , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '            WHERE A.INSTANCE_ID      = B.SEGMENT1 ' + char(10)
		  SET @v_dSql += '            AND   A.PLAN_GROUP_ID    = B.SEGMENT2 ' + char(10)
		  SET @v_dSql += '            AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
		  SET @v_dSql += '            AND   B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '        ) B ' + char(10)
		  SET @v_dSql += '        , TH_UIS_CALENDAR C ' + char(10)
		  SET @v_dSql += '        WHERE  H.INSTANCE_ID    = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '        AND    H.COMPANY_ID     = B.COMPANY_ID ' + char(10)
		  SET @v_dSql += '        AND    H.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		  SET @v_dSql += '        AND    H.SITE_ID        = B.SITE_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLANT_ID       = B.PLANT_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_GROUP_ID  = B.PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_WEEK      = C.D0 ' + char(10)
		  SET @v_dSql += '        AND    H.MPP = ''Y'' ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_MONTH = ''' + @p_PLAN_MONTH + '''  ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_GROUP_ID <> ''-'' ' + char(10)
		  SET @v_dSql += '    ) A ' + char(10)
		  SET @v_dSql += '    WHERE A.NUMES = 1 ' + char(10)
		  SET @v_dSql += ') A ' + char(10)
		  SET @v_dSql += 'ORDER BY A.PLAN_TYPE, A.CODE, A.PLAN_WEEK' + char(10)
	  END ELSE BEGIN -- end of IF @p_LAST_REVISION='Y' BEGIN
		  --          }
		  --          else {
		  SET @v_dSql += 'SELECT A.* ' + char(10)
		  SET @v_dSql += 'FROM ( ' + char(10)
		  SET @v_dSql += '    SELECT *, 1 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '    FROM   ( ' + char(10)
		  SET @v_dSql += '       SELECT ROW_NUMBER() OVER ( PARTITION BY FACTORY_ID, INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                  ORDER BY     FACTORY_ID, INSTANCE_ID, INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '';'' + H.PLAN_WEEK AS CODE ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '' ('' + H.PLAN_WEEK + '')'' AS NAME ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_WEEK, H.PLAN_REVISION ' + char(10)
		  SET @v_dSql += '             ,B.DATED1 AS START_DATE ' + char(10)
		  SET @v_dSql += '       FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '       INNER JOIN TH_UIS_CALENDAR B ' + char(10)
		  SET @v_dSql += '       ON     H.PLAN_WEEK = B.D0 ' + char(10)
		  SET @v_dSql += '       WHERE  H.MPP = ''Y'' ' + char(10)
		  SET @v_dSql += '       AND    H.PLAN_MONTH = ''' + @p_PLAN_MONTH + ''' ' + char(10)
		  SET @v_dSql += '       AND    H.PLAN_GROUP_ID = ''-'' ' + char(10)
  		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('H.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  SET @v_dSql += '    ) PH ' + char(10)
		  SET @v_dSql += '    UNION ALL ' + char(10)
		  SET @v_dSql += '    SELECT *, 2 AS PLAN_TYPE ' + char(10)
		  SET @v_dSql += '    FROM   ( ' + char(10)
		  SET @v_dSql += '        SELECT ROW_NUMBER() OVER ( PARTITION BY H.FACTORY_ID, H.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                                   ORDER BY     H.FACTORY_ID, H.INSTANCE_ID, H.INSERT_TIME DESC ) AS NUMES ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '';'' + H.PLAN_WEEK AS CODE ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_REVISION + '' ('' + H.PLAN_WEEK + '')'' AS NAME ' + char(10)
		  SET @v_dSql += '             ,H.PLAN_WEEK, H.PLAN_REVISION ' + char(10)
		  SET @v_dSql += '             ,C.DATED1 AS START_DATE ' + char(10)
		  SET @v_dSql += '        FROM   FP_MPP_WPP_BASE_PLAN_H H WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '        , ( ' + char(10)
		  SET @v_dSql += '            SELECT A.* ' + char(10)
		  SET @v_dSql += '            FROM ( ' + char(10)
		  SET @v_dSql += '                SELECT DISTINCT A.SEGMENT1 AS INSTANCE_ID, A.ATTRIBUTE1 AS CONFIRM_AREA ' + char(10)
		  SET @v_dSql += '                     , C.COMPANY_ID, C.DIVISION_ID, C.SITE_ID, C.PLANT_ID ' + char(10)
		  SET @v_dSql += '                     , E.MODEL_TYPE AS PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '                FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , FP_INSTANCE_FACTORY_M B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_FACTORY_M C WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_OPERATION_M D WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                     , SCM_LINE_M E WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '                WHERE  A.SEGMENT1         = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '                AND    B.FACTORY_ID       = C.FACTORY_ID ' + char(10)
		  SET @v_dSql += '                AND    B.INSTANCE_TYPE    = D.INSTANCE_TYPE ' + char(10)
		  SET @v_dSql += '                AND    C.COMPANY_ID       = D.COMPANY_ID ' + char(10)
		  SET @v_dSql += '                AND    C.DIVISION_ID      = D.DIVISION_ID ' + char(10)
		  SET @v_dSql += '                AND    C.SITE_ID          = D.SITE_ID ' + char(10)
		  SET @v_dSql += '                AND    C.COMPANY_ID       = E.COMPANY_ID ' + char(10)
		  SET @v_dSql += '                AND    C.DIVISION_ID      = E.DIVISION_ID ' + char(10)
		  SET @v_dSql += '                AND    C.SITE_ID          = E.SITE_ID ' + char(10)
		  SET @v_dSql += '                AND    C.PLANT_ID         = E.PLANT_ID ' + char(10)
		  SET @v_dSql += '                AND    C.FACTORY_ID       = E.FACTORY_ID ' + char(10)
		  SET @v_dSql += '                AND    D.OPERATION_ID     = E.OPERATION_ID ' + char(10)
		  SET @v_dSql += '                AND    A.LOOKUP_TYPE_CODE = ''INSTANCE_ID'' ' + char(10)
		  SET @v_dSql += '                AND    A.ATTRIBUTE1       = ''PLAN GROUP'' ' + char(10)
		  SET @v_dSql += '                AND    A.SEGMENT1        != ''KR_CELL_M_P'' ' + char(10)
		  SET @v_dSql += '                AND    A.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    C.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    D.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '                AND    E.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.FACTORY_ID' , 'EQ', @p_factory_id)) + char(10)
		  SET @v_dSql += '            ) A ' + char(10)
		  SET @v_dSql += '            , SCM_SYS_LOOKUP_VALUE B WITH(NOLOCK) ' + char(10)
		  SET @v_dSql += '            WHERE A.INSTANCE_ID      = B.SEGMENT1 ' + char(10)
		  SET @v_dSql += '            AND   A.PLAN_GROUP_ID    = B.SEGMENT2 ' + char(10)
		  SET @v_dSql += '            AND   B.LOOKUP_TYPE_CODE = ''INSTANCE_PLANNING_GROUP'' ' + char(10)
		  SET @v_dSql += '            AND   B.ACTIVE_FLAG      = ''Y'' ' + char(10)
		  SET @v_dSql += '        ) B ' + char(10)
		  SET @v_dSql += '        , TH_UIS_CALENDAR C ' + char(10)
		  SET @v_dSql += '        WHERE  H.INSTANCE_ID    = B.INSTANCE_ID ' + char(10)
		  SET @v_dSql += '        AND    H.COMPANY_ID     = B.COMPANY_ID ' + char(10)
		  SET @v_dSql += '        AND    H.DIVISION_ID    = B.DIVISION_ID ' + char(10)
		  SET @v_dSql += '        AND    H.SITE_ID        = B.SITE_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLANT_ID       = B.PLANT_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_GROUP_ID  = B.PLAN_GROUP_ID ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_WEEK      = C.D0 ' + char(10)
		  SET @v_dSql += '        AND    H.MPP = ''Y'' ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_MONTH = ''' + @p_PLAN_MONTH + '''  ' + char(10)
		  SET @v_dSql += '        AND    H.PLAN_GROUP_ID <> ''-'' ' + char(10)
		  SET @v_dSql += '    ) A ' + char(10)
		  SET @v_dSql += ') A ' + char(10)
		  SET @v_dSql += 'ORDER BY A.PLAN_TYPE, A.CODE, A.PLAN_WEEK' + char(10)
	  END  -- end of IF @p_LAST_REVISION='Y' BEGIN END ELSE
  END -- end of IF @p_MPP_WPP_PLAN_TYPE = 'WPP' OR @p_MPP_WPP_PLAN_TYPE = 'MRP' OR @p_MPP_WPP_PLAN_TYPE = 'WO' BEGIN END ELSE
  --          }
  --        }
  --
  --        sql;
  --      }

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --      var param = $data.param;
  --      $data.querySet1 = $jdbc.queryList("FP01624","find_PlanRevision",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_PLANREVISION',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP01624_FIND_PLANREVISION',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
