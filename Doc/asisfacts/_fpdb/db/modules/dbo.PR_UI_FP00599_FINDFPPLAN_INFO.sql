CREATE PROCEDURE [dbo].[PR_UI_FP00599_FINDFPPLAN_INFO]
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
/** 프로그램 ID   : PR_UI_FP00599_FINDFPPLAN_INFO                                                            **/
/** 프로그램 명   : Procedure PR_UI_FP00599_FINDFPPLAN_INFO                                                                          **/
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
/** 2021-03-09     XPDbToProcedure      Auto Generated With Initial Setting                                                      **/
/***********************************************************************************************/
/*
  EXEC PR_UI_FP00599_FINDFPPLAN_INFO
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
  DECLARE @v_proc_name nvarchar(100) = 'PR_UI_FP00599_FINDFPPLAN_INFO'
  DECLARE @v_delimiter          NVARCHAR(1)
  DECLARE @max_loop_cnt	        INTEGER = 0
  DECLARE @mst_loop_cnt	        INTEGER = 0
  DECLARE @p_instance_id nvarchar(max) = ''
  DECLARE @p_plan_date nvarchar(max) = ''
  DECLARE @p__save_auth nvarchar(max) = ''
  DECLARE @p__non_auth nvarchar(max) = ''
  --DECLARE @p_param nvarchar(max) = ''
  --DECLARE @p_queryset1 nvarchar(max) = ''


  DECLARE @v_instance_id nvarchar(max)
  DECLARE @v_plan_date nvarchar(max)
  --DECLARE @v_param nvarchar(max)
  --DECLARE @v_queryset1 nvarchar(max)

  --DECLARE BASE PARAMETER START END

  --Optional Parameter Part START
  --DECLARE @opt_0instance_id nvarchar(max)
  --DECLARE @opt_1plan_date nvarchar(max)
  --DECLARE @opt_2instance_id nvarchar(max)
  DECLARE @opt_3plan_date nvarchar(max)
  --DECLARE @opt_4instance_id nvarchar(max)
  --DECLARE @opt_5plan_date nvarchar(max)
  --DECLARE @opt_6instance_id nvarchar(max)
  --DECLARE @opt_7plan_date nvarchar(max)

  --Optional Parameter Part END

  SET @v_delimiter            = '^'  -- 데이터 구분자
  SET @max_loop_cnt           = [dbo].[SCM_ARR_SPL_CNT](@in_columns, @v_delimiter) -- 프로시저 LOOP 길이를 판단
  DECLARE @tmp_column nvarchar(MAX) = ''
  WHILE @mst_loop_cnt < @max_loop_cnt
  BEGIN -- 각 컬럼들에 대한 스플릿처리로직 스타트	
	SET @mst_loop_cnt = @mst_loop_cnt + 1;	-- @mst_loop_cnt 1증가

	SET @tmp_column			    = [dbo].[SCM_ARR_SPL_VAL]( @in_columns			    ,@v_delimiter, @mst_loop_cnt);
	IF @tmp_column = '_SAVE_AUTH' BEGIN
		SET @p__save_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'INSTANCE_ID' BEGIN
      SET @p_instance_id =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    END ELSE IF @tmp_column = 'PLAN_DATE' BEGIN
      SET @p_plan_date =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'PARAM' BEGIN
    --  SET @p_param =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
    --END ELSE IF @tmp_column = 'QUERYSET1' BEGIN
    --  SET @p_queryset1 =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END ELSE IF @tmp_column = '_NON_AUTH' BEGIN
		SET @p__non_auth =  [dbo].[SCM_ARR_SPL_VAL]( @in_row			    ,@v_delimiter, @mst_loop_cnt);
	END
  END
  
  SET @v_instance_id ='''' + @p_instance_id + ''''
  SET @v_plan_date ='''' + @p_plan_date + ''''
  --SET @v_param ='''' + @p_param + ''''
  --SET @v_queryset1 ='''' + @p_queryset1 + ''''

  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_0instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_0instance_id = 'AND    A.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_plan_date)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_1plan_date = ''
  --END ELSE BEGIN
  --  SET @opt_1plan_date = 'AND    A.INSTANCE_DATE  = ' + @v_plan_date+''
  --END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_2instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_2instance_id = 'AND    A.INSTANCE_ID = ' + @v_instance_id+''
  --END
  SET @STRLEN = LEN(@p_plan_date)
  IF @STRLEN< 1  BEGIN
    SET @opt_3plan_date = ''
  END ELSE BEGIN
    SET @opt_3plan_date = 'AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = ' + @v_plan_date+''
  END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_4instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_4instance_id = 'AND    A.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_plan_date)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_5plan_date = ''
  --END ELSE BEGIN
  --  SET @opt_5plan_date = 'AND    A.INSTANCE_DATE  = ' + @v_plan_date+''
  --END
  --SET @STRLEN = LEN(@p_instance_id)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_6instance_id = ''
  --END ELSE BEGIN
  --  SET @opt_6instance_id = 'AND    A.INSTANCE_ID = ' + @v_instance_id+''
  --END
  --SET @STRLEN = LEN(@p_plan_date)
  --IF @STRLEN< 1  BEGIN
  --  SET @opt_7plan_date = ''
  --END ELSE BEGIN
  --  SET @opt_7plan_date = 'AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = ' + @v_plan_date+''
  --END


  -- FP00599 findFpPlan_info  
  SET @v_dSql = ''
  SET @v_dSql += '      WITH RELEASE_PLAN AS ('+char(10)
  SET @v_dSql += '          SELECT DISTINCT'+char(10)
  SET @v_dSql += '                 A.INSTANCE_ID'+char(10)
  SET @v_dSql += '                ,A.RELEASE_PLAN_ID AS PLAN_ID'+char(10)
  SET @v_dSql += '                ,STUFF(( SELECT '','' + FACTORY_ID'+char(10)
  SET @v_dSql += '                         FROM   FP_RELEASE_PLAN_INFO_H B'+char(10)
  SET @v_dSql += '                         WHERE  A.INSTANCE_ID     = B.INSTANCE_ID'+char(10)
  SET @v_dSql += '                         AND    A.INSTANCE_DATE   = B.INSTANCE_DATE'+char(10)
  SET @v_dSql += '                         AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID'+char(10)
  SET @v_dSql += '                         FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT'+char(10)
  SET @v_dSql += '                ,A.PLAN_GROUP_ID'+char(10)
  SET @v_dSql += '                ,A.INSTANCE_DATE AS PLAN_DATE'+char(10)
  SET @v_dSql += '          FROM   FP_RELEASE_PLAN_INFO_H A'+char(10)
  SET @v_dSql += '          WHERE  1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_DATE' , 'EQ', @p_plan_date)) + char(10);
  --SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND    A.INSTANCE_ID = #INSTANCE_ID#
  --SET @v_dSql += ' ' +@opt_1plan_date +' '+''+char(10)--AND    A.INSTANCE_DATE  = #PLAN_DATE#
  SET @v_dSql += '      )'+char(10)
  SET @v_dSql += '      SELECT A.PLAN_ID AS CODE, SUBSTRING(A.PLAN_ID,CHARINDEX(''-'',A.PLAN_ID)+1,11) AS NAME'+char(10)
  SET @v_dSql += '            ,A.PLAN_ID'+char(10)
  SET @v_dSql += '            ,A.PLAN_TYPE'+char(10)
  SET @v_dSql += '            ,A.PLAN_START_TIME'+char(10)
  SET @v_dSql += '            ,A.PLAN_HORIZON'+char(10)
  SET @v_dSql += '            ,A.PLAN_HORIZON_UOM'+char(10)
  SET @v_dSql += '            ,A.DEMAND_HORIZON'+char(10)
  SET @v_dSql += '            ,A.DEMAND_HORIZON_UOM'+char(10)
  SET @v_dSql += '            ,A.CONFIG_SET_ID'+char(10)
  SET @v_dSql += '            ,A.BASIS_PLAN_ID'+char(10)
  SET @v_dSql += '            ,A.DEMAND_PLAN_ID'+char(10)
  SET @v_dSql += '            ,A.SCP_PLAN_ID'+char(10)
  SET @v_dSql += '            ,A.PLAN_WEEK'+char(10)
  SET @v_dSql += '            --,CONVERT(VARCHAR(8), DATEADD(DAY,-28, A.PLAN_START_TIME), 112) AS PLAN_START_DATE'+char(10)
  SET @v_dSql += '            --,CONVERT(VARCHAR(8), DATEADD(DAY, 55, A.PLAN_START_TIME), 112) AS PLAN_END_DATE'+char(10)
  SET @v_dSql += '            ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD ='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) AS PLAN_START_DATE'+char(10)
  SET @v_dSql += '            ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD ='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')))), 112) AS PLAN_END_DATE'+char(10)
  SET @v_dSql += '            ,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE  YYYYMMDD ='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')) AS DEFAULT_START_DATE'+char(10)
  SET @v_dSql += '            ,CONVERT(VARCHAR, DATEADD(DD, 27, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD ='+char(10)
  SET @v_dSql += '' + @v_plan_date+''+char(10)
  SET @v_dSql += ')))), 112) AS DEFAULT_END_DATE'+char(10)
  --SET @v_dSql += '		    ,CONVERT(VARCHAR, DATEADD(DD, D.ATTRIBUTE15 * 7, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = '+ @v_plan_date +')))), 112) AS UI_END_DATE  ' + char(10)
  SET @v_dSql += '            ,CONVERT(VARCHAR, DATEADD(DD, (CASE WHEN CONVERT(NUMERIC,D.ATTRIBUTE15) > 18 THEN ''18'' ELSE D.ATTRIBUTE15 END) * 7, CONVERT(DATE,(SELECT DATED1 FROM TH_UIS_CALENDAR WHERE D0 = (SELECT ISO_YYYYWW FROM TH_UIS_CAL A WITH(NOLOCK) WHERE YYYYMMDD = ' + @v_plan_date + ')))), 112) AS UI_END_DATE ' + char(10) -- PDS 2차 고도화... 기준주차가 52주 이상일 경우 오류발생하여 18주로 보정처리
  SET @v_dSql += '            ,A.INSTANCE_ID'+char(10)
  SET @v_dSql += '            ,A.SITE_ID'+char(10)
  SET @v_dSql += '            ,A.DESCRIPTION'+char(10)
  SET @v_dSql += '            ,A.PLAN_TYPE'+char(10)
  SET @v_dSql += '            ,CASE WHEN A.RELEASE_FLAG = ''Y'' THEN A.RELEASE_ID ELSE A.INSERT_ID END AS INSERT_ID'+char(10)
  SET @v_dSql += '            ,CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME'+char(10)
  SET @v_dSql += '            ,CASE WHEN A.RELEASE_FLAG = ''Y'''+char(10)
  SET @v_dSql += '            	  THEN (SELECT DISTINCT SA.DESCRIPTION FROM SCM_FP_PLAN_H SA WHERE A.INSTANCE_ID = SA.INSTANCE_ID AND A.BASIS_PLAN_ID = SA.PLAN_ID )'+char(10)
  SET @v_dSql += '            	  ELSE A.DESCRIPTION END AS DESCS'+char(10)
  SET @v_dSql += '           	,SUBSTRING(BASIS_PLAN_ID,CHARINDEX(''-'',BASIS_PLAN_ID)+1,11) AS BASIC_VERSION'+char(10)
  SET @v_dSql += '           	,C.FACTORY_LT'+char(10)
  SET @v_dSql += '  			,(CASE WHEN PLAN_TYPE = ''RELEASE'' THEN ''Y'''+char(10)
  SET @v_dSql += '        	       WHEN RIGHT(A.PLAN_ID,2) = ''00'' THEN ''Y'' ELSE ''N'' END) AS READ_ONLY'+char(10)
  SET @v_dSql += '      FROM   SCM_FP_PLAN_H A WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      		LEFT OUTER JOIN RELEASE_PLAN C WITH(NOLOCK)'+char(10)
  SET @v_dSql += '      		ON  A.INSTANCE_ID = C.INSTANCE_ID'+char(10)
  SET @v_dSql += '      		AND A.PLAN_ID = C.PLAN_ID'+char(10)
  SET @v_dSql += '				LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE D WITH(NOLOCK)              ' + char(10)
  SET @v_dSql += '				ON	A.INSTANCE_ID = D.SEGMENT1                                   ' + char(10)
  SET @v_dSql += '				AND D.LOOKUP_TYPE_CODE = ''INSTANCE_ID''                         ' + char(10)
  SET @v_dSql += '				AND D.ACTIVE_FLAG = ''Y''                                        ' + char(10)
  SET @v_dSql += '      WHERE  1=1'+char(10)
  SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
  --SET @v_dSql += ' ' +@opt_0instance_id +' '+''+char(10)--AND    A.INSTANCE_ID = #INSTANCE_ID#
  SET @v_dSql += ' ' +@opt_3plan_date +' '+''+char(10)--AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = #PLAN_DATE#
  SET @v_dSql += '      ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC'+char(10)
  ---- REMAINED SCRIPT (PLEASE CONVERT THIS MANUALLY----
  --SET @v_dSql += '
  --{--SCRIPT RAW
  --
  --        var param = $data.param;
  --        $data.querySet1 = $jdbc.queryList("FP00599","findFpPlan_info",param);
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
      exec PR_UI_SQL_LOG 'PR_UI_FP00599_FINDFPPLAN_INFO',  @p_user_id,'','',@v_dSql,'rollback error',@runstart, @runend
    END CATCH

    SET @runend = GetDate()
    -- Record sql query
    exec PR_UI_SQL_LOG 'PR_UI_FP00599_FINDFPPLAN_INFO',  @p_user_id,'','',@v_dSql,'select',@runstart, @runend
  END


END
