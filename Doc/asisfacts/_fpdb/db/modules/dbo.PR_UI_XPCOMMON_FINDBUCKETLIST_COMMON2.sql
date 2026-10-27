CREATE PROCEDURE [dbo].[PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON2]
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
/** 프로그램 ID   : PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON                                                            **/
/** 프로그램 명   : Procedure PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON                                                                          **/
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
  EXEC PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_XPCOMMON_FINDBUCKETLIST_COMMON'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_bucket nvarchar(max) = ''
  DECLARE @p_bucket_from nvarchar(max) = ''
  DECLARE @p_bucket_to nvarchar(max) = ''
  DECLARE @p_param nvarchar(max) = ''
  DECLARE @p_queryset1 nvarchar(max) = ''
  DECLARE @p_queryset2 nvarchar(max) = ''
  DECLARE @p_queryset3 nvarchar(max) = ''


  DECLARE @v_bucket nvarchar(max)
  DECLARE @v_bucket_from nvarchar(max)
  DECLARE @v_bucket_to nvarchar(max)
  DECLARE @v_param nvarchar(max)
  DECLARE @v_queryset1 nvarchar(max)
  DECLARE @v_queryset2 nvarchar(max)
  DECLARE @v_queryset3 nvarchar(max)

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
    END ELSE IF @tmp_column = 'BUCKET' BEGIN
      SET @p_bucket =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_FROM' BEGIN
      SET @p_bucket_from =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'BUCKET_TO' BEGIN
      SET @p_bucket_to =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PARAM' BEGIN
      SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
      SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET2' BEGIN
      SET @p_queryset2 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'QUERYSET3' BEGIN
      SET @p_queryset3 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @tmp_column =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  --SET @p_user_id = dbo.FN_deCRYPT_AES128(@p_user_id)
  
  SET @v_bucket ='''' + @p_bucket + ''''
  SET @v_bucket_from ='''' + @p_bucket_from + ''''
  SET @v_bucket_to ='''' + @p_bucket_to + ''''
  SET @v_param ='''' + @p_param + ''''
  SET @v_queryset1 ='''' + @p_queryset1 + ''''
  SET @v_queryset2 ='''' + @p_queryset2 + ''''
  SET @v_queryset3 ='''' + @p_queryset3 + ''''



  -- xpcommon findBucketList_common  
  SET @v_dSql= ''

  -- xpcommon findBucketList_common  
  SET @v_dSql+= ''
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----

  IF @p_bucket = 'D' AND @p_bucket = 'W' AND  @p_bucket = 'P' AND @p_bucket = 'M'
  BEGIN

  SET @v_dSql+= 'SELECT DISTINCT A.COL_NM, A.YEAR, A.HALF, A.QUARTER, A.MONTH, A.WEEK, A.TYPE, A.VALUE, A.LABLE, A.DAY' + char(10)
  SET @v_dSql+= 'FROM ' + char(10)
  SET @v_dSql+= '   (' + char(10)
  SET @v_dSql+= '      SELECT ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(CAL.YYYYMM, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(CAL.ISO_YYYYPW, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(CAL.ISO_YYYYWW,'''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(CAL.YYYYMMDD, '''')' + char(10)
  SET @v_dSql+= '         END AS COL_NM, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN CAL.YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.ISO_YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN CAL.ISO_YEAR' + char(10)
  SET @v_dSql+= '            ELSE CAL.ISO_YEAR' + char(10)
  SET @v_dSql+= '         END AS YEAR, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN CAL.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE CAL.HALF' + char(10)
  SET @v_dSql+= '         END AS HALF, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN CAL.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE CAL.QUARTER' + char(10)
  SET @v_dSql+= '         END AS QUARTER, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN CAL.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE CAL.YYYYMM' + char(10)
  SET @v_dSql+= '         END AS MONTH, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN NULL' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN CAL.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE CAL.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '         END AS WEEK, ' + char(10)
  SET @v_dSql+= '         ''' + @p_bucket + ''' AS TYPE, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN CAL.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN CAL.ISO_YYYYPW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN CAL.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE CAL.YYYYMMDD' + char(10)
  SET @v_dSql+= '         END AS VALUE, ' + char(10)
  SET @v_dSql+= '         CASE ''' + @p_bucket + '''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(CAL.MONTH, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(CAL.ISO_PARTIAL_WEEK, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(CAL.ISO_WEEK, '''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(CAL.DAY, '''')' + char(10)
  SET @v_dSql+= '         END AS LABLE,' + char(10)
  SET @v_dSql+= '         CASE when ''' + @p_bucket + ''' = ''D'' then' + char(10)
  SET @v_dSql+= '            DAY_SEQ' + char(10)
  SET @v_dSql+= '         else ''-'' end as day' + char(10)
  SET @v_dSql+= '      FROM TH_UIS_CAL AS CAL(NOLOCK)' + char(10)
  SET @v_dSql+= '      WHERE CAL.DT >= CONVERT(datetime, ''' + @p_bucket_from + ''', 112) AND CAL.DT <= CONVERT(datetime, ''' + @p_bucket_to + ''', 112)' + char(10)
  SET @v_dSql+= '   )  AS A' + char(10)
  SET @v_dSql+= ' UNION ALL' + char(10)
  SET @v_dSql+= 'SELECT ' + char(10)
  SET @v_dSql+= '   ''TOTAL'' AS COL_NM, NULL AS YEAR, NULL AS HALF, NULL AS QUARTER, NULL AS MONTH, NULL AS WEEK, ''T'' AS TYPE, ''TOTAL'' AS VALUE, ''TOTAL'' AS LABLE, ''-''  AS DAY' + char(10)
  SET @v_dSql+= 'ORDER BY A.VALUE' + char(10)
  END
  ELSE BEGIN
   SET @v_dSql+= 'SELECT ' + char(10)
  SET @v_dSql+= '   max(AA.YYYYMMDD) AS YYYYMMDD, AA.COL_NM, AA.YEAR, AA.HALF, AA.QUARTER, AA.MONTH, AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE, ' + char(10)
  SET @v_dSql+= '   CASE AA.TYPE WHEN ''D'' THEN ''1'' WHEN ''W'' THEN ''2'' WHEN ''P'' THEN ''3'' ELSE ''4'' END AS SEQ' + char(10)
  SET @v_dSql+= 'FROM ' + char(10)
  SET @v_dSql+= '   (' + char(10)
  SET @v_dSql+= '      SELECT ' + char(10)
  SET @v_dSql+= '         A.YYYYMMDD, ' + char(10)
  SET @v_dSql+= '         ''D'' + ISNULL(A.YYYYMMDD, '''') AS COL_NM, ' + char(10)
  SET @v_dSql+= '         A.ISO_YEAR AS YEAR, ' + char(10)
  SET @v_dSql+= '         A.HALF AS HALF, ' + char(10)
  SET @v_dSql+= '         A.QUARTER AS QUARTER, ' + char(10)
  SET @v_dSql+= '         A.YYYYMM AS MONTH, ' + char(10)
  SET @v_dSql+= '         A.ISO_YYYYWW AS WEEK, ' + char(10)
  SET @v_dSql+= '         ''D'' AS TYPE, ' + char(10)
  SET @v_dSql+= '         A.YYYYMMDD AS VALUE, ' + char(10)
  SET @v_dSql+= '         ''D'' + ISNULL(A.DAY, '''') AS LABLE' + char(10)
  SET @v_dSql+= '      FROM TH_UIS_CAL AS A(NOLOCK)' + char(10)
  SET @v_dSql+= '      WHERE A.DT >= CONVERT(datetime, ''' + @p_bucket_from + ''', 112) AND A.DT <= CONVERT(datetime, ''' + @p_bucket_to + ''', 112)' + char(10)
  SET @v_dSql+= '   )  AS AA' + char(10)
  SET @v_dSql+= 'GROUP BY AA.COL_NM, AA.YEAR, AA.HALF, AA.QUARTER, AA.MONTH, AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE' + char(10)
  SET @v_dSql+= ' UNION ALL' + char(10)
  SET @v_dSql+= 'SELECT ' + char(10)
  SET @v_dSql+= '   max(BB.YYYYMMDD) AS YYYYMMDD, BB.COL_NM, BB.YEAR, BB.HALF, BB.QUARTER, BB.MONTH, BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE, ' + char(10)
  SET @v_dSql+= '   CASE BB.TYPE WHEN ''D'' THEN ''1'' WHEN ''W'' THEN ''2'' WHEN ''P'' THEN ''3'' ELSE ''4'' END AS SEQ' + char(10)
  SET @v_dSql+= 'FROM ' + char(10)
  SET @v_dSql+= '   (' + char(10)
  SET @v_dSql+= '      SELECT ' + char(10)
  SET @v_dSql+= '         A.YYYYMMDD, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(A.YYYYMM, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_YYYYPW, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_YYYYWW, '''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(A.YYYYMMDD, '''')' + char(10)
  SET @v_dSql+= '         END AS COL_NM, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YEAR' + char(10)
  SET @v_dSql+= '            ELSE A.ISO_YEAR' + char(10)
  SET @v_dSql+= '         END AS YEAR, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.HALF' + char(10)
  SET @v_dSql+= '         END AS HALF, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.QUARTER' + char(10)
  SET @v_dSql+= '         END AS QUARTER, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.YYYYMM' + char(10)
  SET @v_dSql+= '         END AS MONTH, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN NULL' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '         END AS WEEK, ' + char(10)
  SET @v_dSql+= '         ''W'' AS TYPE, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YYYYPW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE A.YYYYMMDD' + char(10)
  SET @v_dSql+= '         END AS VALUE, ' + char(10)
  SET @v_dSql+= '         CASE ''W''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(A.MONTH, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_PARTIAL_WEEK, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_WEEK, '''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(A.DAY, '''')' + char(10)
  SET @v_dSql+= '         END AS LABLE' + char(10)
  SET @v_dSql+= '      FROM TH_UIS_CAL AS A(NOLOCK)' + char(10)
  SET @v_dSql+= '      WHERE A.DT >= CONVERT(datetime, ''' + @p_bucket_from + ''', 112) AND A.DT <= CONVERT(datetime, ''' + @p_bucket_to + ''', 112)' + char(10)
  SET @v_dSql+= '   )  AS BB' + char(10)
  SET @v_dSql+= 'GROUP BY BB.COL_NM, BB.YEAR, BB.HALF, BB.QUARTER, BB.MONTH, BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE' + char(10)
  SET @v_dSql+= ' UNION ALL' + char(10)
  SET @v_dSql+= 'SELECT ' + char(10)
  SET @v_dSql+= '   max(CC.YYYYMMDD) AS YYYYMMDD, CC.COL_NM, CC.YEAR, CC.HALF, CC.QUARTER, CC.MONTH, CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE, ' + char(10)
  SET @v_dSql+= '   CASE CC.TYPE WHEN ''D'' THEN ''1'' WHEN ''W'' THEN ''2'' WHEN ''P'' THEN ''3'' ELSE ''4'' END AS SEQ' + char(10)
  SET @v_dSql+= 'FROM ' + char(10)
  SET @v_dSql+= '   (' + char(10)
  SET @v_dSql+= '      SELECT ' + char(10)
  SET @v_dSql+= '         A.YYYYMMDD, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(A.YYYYMM, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_YYYYPW, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_YYYYWW, '''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(A.YYYYMMDD, '''')' + char(10)
  SET @v_dSql+= '         END AS COL_NM, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YEAR' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YEAR' + char(10)
  SET @v_dSql+= '            ELSE A.ISO_YEAR' + char(10)
  SET @v_dSql+= '         END AS YEAR, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.HALF' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.HALF' + char(10)
  SET @v_dSql+= '         END AS HALF, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.QUARTER' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.QUARTER' + char(10)
  SET @v_dSql+= '         END AS QUARTER, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN NULL' + char(10)
  SET @v_dSql+= '            ELSE A.YYYYMM' + char(10)
  SET @v_dSql+= '         END AS MONTH, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN NULL' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '         END AS WEEK, ' + char(10)
  SET @v_dSql+= '         ''M'' AS TYPE, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN A.YYYYMM' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN A.ISO_YYYYPW' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN A.ISO_YYYYWW' + char(10)
  SET @v_dSql+= '            ELSE A.YYYYMMDD' + char(10)
  SET @v_dSql+= '         END AS VALUE, ' + char(10)
  SET @v_dSql+= '         CASE ''M''' + char(10)
  SET @v_dSql+= '            WHEN ''M'' THEN ''M'' + ISNULL(A.MONTH, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''P'' THEN ''P'' + ISNULL(A.ISO_PARTIAL_WEEK, '''')' + char(10)
  SET @v_dSql+= '            WHEN ''W'' THEN ''W'' + ISNULL(A.ISO_WEEK, '''')' + char(10)
  SET @v_dSql+= '            ELSE ''D'' + ISNULL(A.DAY, '''')' + char(10)
  SET @v_dSql+= '         END AS LABLE' + char(10)
  SET @v_dSql+= '      FROM TH_UIS_CAL AS A(NOLOCK)' + char(10)
  SET @v_dSql+= '      WHERE A.DT >= CONVERT(datetime, ''' + @p_bucket_from + ''', 112) AND A.DT <= CONVERT(datetime, ''' + @p_bucket_to + ''', 112)' + char(10)
  SET @v_dSql+= '   )  AS CC' + char(10)
  SET @v_dSql+= 'GROUP BY CC.COL_NM, CC.YEAR, CC.HALF, CC.QUARTER, CC.MONTH, CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE' + char(10)
  SET @v_dSql+= 'ORDER BY YYYYMMDD, SEQ' + char(10)
  END

  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{
  --  var SQL;
  --  var bucket = $data.BUCKET;
  --  var bucketfrom = $data.BUCKET_FROM;
  --  var bucketto = $data.BUCKET_TO;
  --
  --  if(bucket=="D" || bucket=="W" || bucket=="P" || bucket=="M"){
  --    SQL = "SELECT DISTINCT A.COL_NM, A.YEAR, A.HALF, A.QUARTER, A.MONTH, A.WEEK, A.TYPE, A.VALUE, A.LABLE, A.DAY \r\n";
  --    SQL+= "FROM  \r\n";
  --    SQL+= "   ( \r\n";
  --    SQL+= "      SELECT  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(CAL.YYYYMM, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(CAL.ISO_YYYYPW, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(CAL.ISO_YYYYWW, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(CAL.YYYYMMDD, '''''''') \r\n";
  --    SQL+= "         END AS COL_NM,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN CAL.YEAR \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.ISO_YEAR \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN CAL.ISO_YEAR \r\n";
  --    SQL+= "            ELSE CAL.ISO_YEAR \r\n";
  --    SQL+= "         END AS YEAR,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN CAL.HALF \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.HALF \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE CAL.HALF \r\n";
  --    SQL+= "         END AS HALF,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN CAL.QUARTER \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.QUARTER \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE CAL.QUARTER \r\n";
  --    SQL+= "         END AS QUARTER,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN CAL.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE CAL.YYYYMM \r\n";
  --    SQL+= "         END AS MONTH,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN NULL \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.ISO_YYYYWW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN CAL.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE CAL.ISO_YYYYWW \r\n";
  --    SQL+= "         END AS WEEK,  \r\n";
  --    SQL+= "         ''''" + bucket + "'''' AS TYPE,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN CAL.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN CAL.ISO_YYYYPW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN CAL.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE CAL.YYYYMMDD \r\n";
  --    SQL+= "         END AS VALUE,  \r\n";
  --    SQL+= "         CASE ''''" + bucket + "'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(CAL.MONTH, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(CAL.ISO_PARTIAL_WEEK, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(CAL.ISO_WEEK, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(CAL.DAY, '''''''') \r\n";
  --    SQL+= "         END AS LABLE, \r\n";
  --    SQL+= "         CASE when ''''" + bucket + "'''' = ''''D'''' then \r\n";
  --    SQL+= "            DAY_SEQ \r\n";
  --    SQL+= "         else ''''-'''' end as day \r\n";
  --    SQL+= "      FROM TH_UIS_CAL AS CAL(NOLOCK) \r\n";
  --    SQL+= "      WHERE CAL.DT >= CONVERT(datetime, ''''" + bucketfrom + "'''', 112) AND CAL.DT <= CONVERT(datetime, ''''" + bucketto + "'''', 112) \r\n";
  --    SQL+= "   )  AS A \r\n";
  --    SQL+= " UNION ALL \r\n";
  --    SQL+= "SELECT  \r\n";
  --    SQL+= "   ''''TOTAL'''' AS COL_NM, NULL AS YEAR, NULL AS HALF, NULL AS QUARTER, NULL AS MONTH, NULL AS WEEK, ''''T'''' AS TYPE, ''''TOTAL'''' AS VALUE, ''''TOTAL'''' AS LABLE, ''''-''''  AS DAY \r\n";
  --    SQL+= "ORDER BY A.VALUE \r\n";
  --  }else{
  --    SQL = "SELECT  \r\n";
  --    SQL+= "   max(AA.YYYYMMDD) AS YYYYMMDD, AA.COL_NM, AA.YEAR, AA.HALF, AA.QUARTER, AA.MONTH, AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE,  \r\n";
  --    SQL+= "   CASE AA.TYPE WHEN ''''D'''' THEN ''''1'''' WHEN ''''W'''' THEN ''''2'''' WHEN ''''P'''' THEN ''''3'''' ELSE ''''4'''' END AS SEQ \r\n";
  --    SQL+= "FROM  \r\n";
  --    SQL+= "   ( \r\n";
  --    SQL+= "      SELECT  \r\n";
  --    SQL+= "         A.YYYYMMDD,  \r\n";
  --    SQL+= "         ''''D'''' + ISNULL(A.YYYYMMDD, '''''''') AS COL_NM,  \r\n";
  --    SQL+= "         A.ISO_YEAR AS YEAR,  \r\n";
  --    SQL+= "         A.HALF AS HALF,  \r\n";
  --    SQL+= "         A.QUARTER AS QUARTER,  \r\n";
  --    SQL+= "         A.YYYYMM AS MONTH,  \r\n";
  --    SQL+= "         A.ISO_YYYYWW AS WEEK,  \r\n";
  --    SQL+= "         ''''D'''' AS TYPE,  \r\n";
  --    SQL+= "         A.YYYYMMDD AS VALUE,  \r\n";
  --    SQL+= "         ''''D'''' + ISNULL(A.DAY, '''''''') AS LABLE \r\n";
  --    SQL+= "      FROM TH_UIS_CAL AS A(NOLOCK) \r\n";
  --    SQL+= "      WHERE A.DT >= CONVERT(datetime, ''''" + bucketfrom + "'''', 112) AND A.DT <= CONVERT(datetime, ''''" + bucketto + "'''', 112) \r\n";
  --    SQL+= "   )  AS AA \r\n";
  --    SQL+= "GROUP BY AA.COL_NM, AA.YEAR, AA.HALF, AA.QUARTER, AA.MONTH, AA.WEEK, AA.TYPE, AA.VALUE, AA.LABLE \r\n";
  --    SQL+= " UNION ALL \r\n";
  --    SQL+= "SELECT  \r\n";
  --    SQL+= "   max(BB.YYYYMMDD) AS YYYYMMDD, BB.COL_NM, BB.YEAR, BB.HALF, BB.QUARTER, BB.MONTH, BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE,  \r\n";
  --    SQL+= "   CASE BB.TYPE WHEN ''''D'''' THEN ''''1'''' WHEN ''''W'''' THEN ''''2'''' WHEN ''''P'''' THEN ''''3'''' ELSE ''''4'''' END AS SEQ \r\n";
  --    SQL+= "FROM  \r\n";
  --    SQL+= "   ( \r\n";
  --    SQL+= "      SELECT  \r\n";
  --    SQL+= "         A.YYYYMMDD,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(A.YYYYMM, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(A.ISO_YYYYPW, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(A.ISO_YYYYWW, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(A.YYYYMMDD, '''''''') \r\n";
  --    SQL+= "         END AS COL_NM,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YEAR \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YEAR \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YEAR \r\n";
  --    SQL+= "            ELSE A.ISO_YEAR \r\n";
  --    SQL+= "         END AS YEAR,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.HALF \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.HALF \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.HALF \r\n";
  --    SQL+= "         END AS HALF,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.QUARTER \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.QUARTER \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.QUARTER \r\n";
  --    SQL+= "         END AS QUARTER,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.YYYYMM \r\n";
  --    SQL+= "         END AS MONTH,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN NULL \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE A.ISO_YYYYWW \r\n";
  --    SQL+= "         END AS WEEK,  \r\n";
  --    SQL+= "         ''''W'''' AS TYPE,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YYYYPW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE A.YYYYMMDD \r\n";
  --    SQL+= "         END AS VALUE,  \r\n";
  --    SQL+= "         CASE ''''W'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(A.MONTH, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(A.ISO_PARTIAL_WEEK, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(A.ISO_WEEK, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(A.DAY, '''''''') \r\n";
  --    SQL+= "         END AS LABLE \r\n";
  --    SQL+= "      FROM TH_UIS_CAL AS A(NOLOCK) \r\n";
  --    SQL+= "      WHERE A.DT >= CONVERT(datetime, ''''" + bucketfrom + "'''', 112) AND A.DT <= CONVERT(datetime, ''''" + bucketto + "'''', 112) \r\n";
  --    SQL+= "   )  AS BB \r\n";
  --    SQL+= "GROUP BY BB.COL_NM, BB.YEAR, BB.HALF, BB.QUARTER, BB.MONTH, BB.WEEK, BB.TYPE, BB.VALUE, BB.LABLE \r\n";
  --    SQL+= " UNION ALL \r\n";
  --    SQL+= "SELECT  \r\n";
  --    SQL+= "   max(CC.YYYYMMDD) AS YYYYMMDD, CC.COL_NM, CC.YEAR, CC.HALF, CC.QUARTER, CC.MONTH, CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE,  \r\n";
  --    SQL+= "   CASE CC.TYPE WHEN ''''D'''' THEN ''''1'''' WHEN ''''W'''' THEN ''''2'''' WHEN ''''P'''' THEN ''''3'''' ELSE ''''4'''' END AS SEQ \r\n";
  --    SQL+= "FROM  \r\n";
  --    SQL+= "   ( \r\n";
  --    SQL+= "      SELECT  \r\n";
  --    SQL+= "         A.YYYYMMDD,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(A.YYYYMM, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(A.ISO_YYYYPW, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(A.ISO_YYYYWW, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(A.YYYYMMDD, '''''''') \r\n";
  --    SQL+= "         END AS COL_NM,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YEAR \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YEAR \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YEAR \r\n";
  --    SQL+= "            ELSE A.ISO_YEAR \r\n";
  --    SQL+= "         END AS YEAR,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.HALF \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.HALF \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.HALF \r\n";
  --    SQL+= "         END AS HALF,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.QUARTER \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.QUARTER \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.QUARTER \r\n";
  --    SQL+= "         END AS QUARTER,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN NULL \r\n";
  --    SQL+= "            ELSE A.YYYYMM \r\n";
  --    SQL+= "         END AS MONTH,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN NULL \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE A.ISO_YYYYWW \r\n";
  --    SQL+= "         END AS WEEK,  \r\n";
  --    SQL+= "         ''''M'''' AS TYPE,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN A.YYYYMM \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN A.ISO_YYYYPW \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN A.ISO_YYYYWW \r\n";
  --    SQL+= "            ELSE A.YYYYMMDD \r\n";
  --    SQL+= "         END AS VALUE,  \r\n";
  --    SQL+= "         CASE ''''M'''' \r\n";
  --    SQL+= "            WHEN ''''M'''' THEN ''''M'''' + ISNULL(A.MONTH, '''''''') \r\n";
  --    SQL+= "            WHEN ''''P'''' THEN ''''P'''' + ISNULL(A.ISO_PARTIAL_WEEK, '''''''') \r\n";
  --    SQL+= "            WHEN ''''W'''' THEN ''''W'''' + ISNULL(A.ISO_WEEK, '''''''') \r\n";
  --    SQL+= "            ELSE ''''D'''' + ISNULL(A.DAY, '''''''') \r\n";
  --    SQL+= "         END AS LABLE \r\n";
  --    SQL+= "      FROM TH_UIS_CAL AS A(NOLOCK) \r\n";
  --    SQL+= "      WHERE A.DT >= CONVERT(datetime, ''''" + bucketfrom + "'''', 112) AND A.DT <= CONVERT(datetime, ''''" + bucketto + "'''', 112) \r\n";
  --    SQL+= "   )  AS CC \r\n";
  --    SQL+= "GROUP BY CC.COL_NM, CC.YEAR, CC.HALF, CC.QUARTER, CC.MONTH, CC.WEEK, CC.TYPE, CC.VALUE, CC.LABLE \r\n";
  --    SQL+= "ORDER BY YYYYMMDD, SEQ \r\n";
  --  }
  --
  --  SQL;
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --         $data.querySet1  = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("pr_amend/planamend_cn2_Form","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("pr_amend/planamend_cn2_Form","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00595","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00595","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00595_row","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00595_row","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00596","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00596","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00601","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00601","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00602","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00602","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00615","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00615","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00616","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00616","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00621","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00621","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00622","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00622","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00624","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00624","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00625","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00625","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP00629","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP00629","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP01551","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP01551","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --				var param = $data.param;
  --				$data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --				$data.querySet2 = $jdbc.queryList("FP01552","find_WeekCnt",param);
  --				$data.querySet3 = $jdbc.queryList("FP01552","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP01554","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP01554","find_bukInfo",param);
  --
  --}

  --'
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("xpcommon","findBucketList_common",param);
  --        $data.querySet2 = $jdbc.queryList("FP09602","find_WeekCnt",param);
  --        $data.querySet3 = $jdbc.queryList("FP09602","find_bukInfo",param);
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
