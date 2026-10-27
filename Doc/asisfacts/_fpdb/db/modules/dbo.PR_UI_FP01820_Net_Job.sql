
CREATE
PROCEDURE [dbo].[PR_UI_FP01820_Net_Job]
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
/** 프로그램 ID   : PR_UI_FP01820_Net_Job													  **/
/** 프로그램 명   : Procedure PR_UI_FP01820_Net_Job											  **/
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
/** 2022-04-19     XPDbToProcedure      Auto Generated With Initial Setting                   **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP01820_Net_Job
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP01820_Net_Job'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''

  DECLARE @v_division_id nvarchar(max)
  DECLARE @v_JobList nvarchar(max)
  DECLARE @v_item_id nvarchar(max)
  DECLARE @v_search_cond nvarchar(max)

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
    END ELSE IF @tmp_column = 'DIVISION_ID' BEGIN
      SET @v_division_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'JOB_LIST' BEGIN
      SET @v_JobList =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'SEARCH_COND' BEGIN
      SET @v_search_cond =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'ITEM_ID' BEGIN
      SET @v_item_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);

	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_dSql = ''
  SET @v_dSql += 'SELECT ROW_NUMBER() OVER ( ORDER BY A.DIVISION_ID, A.GROUP_NAME, A.DESCRIPTION, A.PERIOD ) AS NO, ' + char(10)
  SET @v_dSql += '	   GROUP_ID, GROUP_NAME, DIVISION_ID, DESCRIPTION,  ' + char(10)
  SET @v_dSql += '       (SELECT SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE WHERE SEGMENT1 = A.PERIOD AND LOOKUP_TYPE_CODE = ''NET_JOB_PERIOD'') AS PERIOD_NM, PERIOD, ' + char(10)
  SET @v_dSql += '	   ''every '' + CONVERT(VARCHAR, TIME) + '' ''  + (SELECT SEGMENT2 FROM SCM_SYS_LOOKUP_VALUE WHERE SEGMENT1 = A.PERIOD AND LOOKUP_TYPE_CODE = ''NET_JOB_PERIOD'') AS PERIOD_NM2, ' + char(10)
  SET @v_dSql += '       TIME, STATUS, VALID, IMMEDIATE_FLAG, ERROR_PROCEDURE, NEXT_RUN_SEQ, ' + char(10)
  SET @v_dSql += '       CONVERT(VARCHAR, LATEST_RUN_DATE, 120) AS LATEST_RUN_DATE, ' + char(10)
  SET @v_dSql += '       CONVERT(VARCHAR, NEXT_RUN_DATE, 120) AS NEXT_RUN_DATE, ' + char(10)
  SET @v_dSql += '       CREATE_USER_ID, CONVERT(VARCHAR, CREATE_DATE, 120) CREATE_DATE, ' + char(10)
  SET @v_dSql += '	   MODIFY_USER_ID, CONVERT(VARCHAR, MODIFY_DATE, 120) MODIFY_DATE, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR, START_DATE, 120) START_DATE, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR, END_DATE, 120) END_DATE, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR, START_DATE, 112) START_YMD, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR, END_DATE, 112) END_YMD, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR(2), START_DATE, 108) START_HOUR, ' + char(10)
  SET @v_dSql += '	   CONVERT(VARCHAR(2), END_DATE, 108) END_HOUR, ' + char(10)
  SET @v_dSql += '	   RIGHT(CONVERT(VARCHAR(5), START_DATE, 108), 2) START_MIN, ' + char(10)
  SET @v_dSql += '	   RIGHT(CONVERT(VARCHAR(5), END_DATE, 108), 2) END_MIN ' + char(10)
  SET @v_dSql += 'FROM  JOB_SCHEDULE_MASTER A WITH(NOLOCK) ' + char(10)
  SET @v_dSql += 'WHERE 1 = 1 ' + char(10)
  if(isnull(@v_search_cond,'') <> '')
  BEGIN
	  SET @v_dSql += 'AND A.GROUP_NAME LIKE ''%' + @v_search_cond +'%'' OR A.DESCRIPTION LIKE ''%' + @v_search_cond +'%'''+ char(10)
  END

  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @v_division_id)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.GROUP_ID' , 'EQ', @v_JobList)) + char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CREATE_USER_ID' , 'LK', @v_item_id)) + char(10)
  SET @v_dSql += 'ORDER BY A.DIVISION_ID, A.GROUP_NAME, A.DESCRIPTION, A.PERIOD ' + char(10)

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
