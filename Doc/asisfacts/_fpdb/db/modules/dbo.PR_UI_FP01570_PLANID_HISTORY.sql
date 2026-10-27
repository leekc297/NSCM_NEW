

/*
 * Program ID   : PR_UI_FP01570_PLANID_HISTORY
 * Description  : Plan ID History
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/19   CYS				Initial Release UI통합
 * 2022/07/06   KSI				컬럼 추가 및 Description 분리에 따른 조회 로직 수정
 */

CREATE PROCEDURE [dbo].[PR_UI_FP01570_PLANID_HISTORY]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_plan_id			NVARCHAR(MAX),
  @p_plan_type			NVARCHAR(MAX),
  @p_plan_week			NVARCHAR(MAX),
  @p_due_from_date		NVARCHAR(MAX),
  @p_due_to_date		NVARCHAR(MAX),
  @p_last_release_flag	NVARCHAR(MAX)	

AS 
BEGIN
	
	
--DECLARE @PARAMS NVARCHAR(MAX)

--SET @PARAMS = ''
--SET @PARAMS += ' @P_SYS_TYPE			= ''' +ISNULL(@P_SYS_TYPE			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_FLAG			= ''' +ISNULL(@P_SYS_FLAG			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_SYS_GUBUN			= ''' +ISNULL(@P_SYS_GUBUN			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_USER_ID				= ''' +ISNULL(@P_USER_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_INSTANCE_ID			= ''' +ISNULL(@P_INSTANCE_ID		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_PLAN_ID				= ''' +ISNULL(@P_PLAN_ID			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_PLAN_TYPE			= ''' +ISNULL(@P_PLAN_TYPE			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_PLAN_WEEK			= ''' +ISNULL(@P_PLAN_WEEK			,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_DUE_FROM_DATE		= ''' +ISNULL(@P_DUE_FROM_DATE		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_DUE_TO_DATE			= ''' +ISNULL(@P_DUE_TO_DATE		,'')	+ '''' + CHAR(10)
--SET @PARAMS += ',@P_LAST_RELEASE_FLAG	= ''' +ISNULL(@P_LAST_RELEASE_FLAG	,'')	+ '''' + CHAR(10)


--IF @P_SYS_TYPE = 'SQL' BEGIN
--	SELECT @PARAMS AS SQL
--	RETURN
--END

    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP01570_PLANID_HISTORY';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	WITH RELEASE_PLAN AS (																																											' + char(10) ;
		SET @v_dSql += '	          SELECT DISTINCT                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	                 A.INSTANCE_ID                                                                                                                                                                  ' + char(10) ;
		SET @v_dSql += '	                ,A.RELEASE_PLAN_ID AS PLAN_ID                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	                ,STUFF(( SELECT '','' + AMEND_PLAN_ID                                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                         FROM   FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK)                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                         WHERE  A.INSTANCE_ID     = B.INSTANCE_ID                                                                                                                               ' + char(10) ;
		SET @v_dSql += '	                         AND    A.INSTANCE_DATE   = B.INSTANCE_DATE                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	                         AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                         FOR XML PATH('''') ),1,1,'''') AS AMEND_PLAN_LT                                                                                                                        ' + char(10) ;
		SET @v_dSql += '	                ,STUFF(( SELECT '','' + FACTORY_ID                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	                         FROM   FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK)                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                         WHERE  A.INSTANCE_ID     = B.INSTANCE_ID                                                                                                                               ' + char(10) ;
		SET @v_dSql += '	                         AND    A.INSTANCE_DATE   = B.INSTANCE_DATE                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	                         AND    A.RELEASE_PLAN_ID = B.RELEASE_PLAN_ID                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                         FOR XML PATH('''') ),1,1,'''') AS FACTORY_LT                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	                ,A.PLAN_GROUP_ID                                                                                                                                                                ' + char(10) ;
		SET @v_dSql += '	                ,A.INSTANCE_DATE AS PLAN_DATE                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	          FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                                                                                                                                          ' + char(10) ;
		SET @v_dSql += '	          WHERE  A.INSTANCE_DATE BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                                                                      ' + char(10) ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.RELEASE_PLAN_ID' , 'EQ', @p_plan_id)) + char(10);
		SET @v_dSql += '	      )                                                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += '	      SELECT A.INSTANCE_ID, A.PLAN_ID, A.PLAN_TYPE,                                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	             CONVERT(VARCHAR, A.PLAN_START_TIME, 120) AS PLAN_START_TIME,                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      	     CONVERT(VARCHAR, DATEADD(DAY, A.PLAN_HORIZON, A.PLAN_START_TIME), 120) AS PLAN_END_TIME,                                                                                           ' + char(10) ;
		SET @v_dSql += '	             A.PLAN_HORIZON, A.PLAN_HORIZON_UOM,                                                                                                                                                ' + char(10) ;
		SET @v_dSql += '	             A.DEMAND_HORIZON, A.DEMAND_HORIZON_UOM,                                                                                                                                            ' + char(10) ;
		SET @v_dSql += '	             A.CONFIG_SET_ID, A.BASIS_PLAN_ID, A.DEMAND_PLAN_ID, A.SCP_PLAN_ID, A.PLAN_WEEK,                                                                                                    ' + char(10) ;
		SET @v_dSql += '	             (CASE WHEN B.PLAN_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS CONFIRM_FLAG ,                                                                                                          ' + char(10) ;
		SET @v_dSql += '	             ISNULL(C.AMEND_PLAN_LT,''-'') AS AMEND_PLAN_LT,                                                                                                                                    ' + char(10) ;
		SET @v_dSql += '	             ISNULL(C.FACTORY_LT,''-'') AS FACTORY_LT,                                                                                                                                          ' + char(10) ;
		SET @v_dSql += '	             ISNULL(C.PLAN_GROUP_ID,''-'') AS PLAN_GROUP_ID,                                                                                                                                    ' + char(10) ;
		SET @v_dSql += '	             A.DESCRIPTION, A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME, A.REL_DESC                                                                                                    ' + char(10) ;
		SET @v_dSql += N'	             -- fix option 2 추가... 20200313                                                                                                                                                   ' + char(10) ;
		--SET @v_dSql += '	             ,CONVERT(VARCHAR,A.PRE_FIX_DATE,112) AS PRE_FIX_DATE                                                                                                                               ' + char(10) ;
		--SET @v_dSql += '	             ,A.PRE_FIX_TYPE                                                                                                                                                                    ' + char(10) ;
		SET @v_dSql += '	             ,CONVERT(VARCHAR,A.PRE_FIX_DATE1,112) AS PRE_FIX_DATE ' +char(10) -- fix date 1 값으로 출력 변경... 20231107
		SET @v_dSql += '	             ,A.PRE_FIX_TYPE1 AS PRE_FIX_TYPE ' +char(10)
		SET @v_dSql += '	             ,CONVERT(VARCHAR,A.PRE_FIX_DATE1,112) AS PRE_FIX_DATE1                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	             ,A.PRE_FIX_TYPE1                                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	             ,CONVERT(VARCHAR,A.PRE_FIX_DATE2,112) AS PRE_FIX_DATE2                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	             ,A.PRE_FIX_TYPE2                                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	             , A.MRP_FLAG,                                                                                                                                                                      ' + char(10) ;
		--SET @v_dSql += '	             A.DW_SUBMIT_FLAG, CONVERT(VARCHAR,A.DW_SUBMIT_TIME,20) AS DW_SUBMIT_TIME, (CASE WHEN D.FP_PLAN_ID IS NOT NULl THEN ''Y'' ELSE NULL END) AS LATEST_DW_SUBMIT_FLAG,                  ' + char(10) ;
		SET @v_dSql += '			_WPP.DW_FLAG AS WPP_DW_FLAG, _WPP.DW_USER AS WPP_DW_USER, _WPP.DW_TIME AS WPP_DW_TIME, (CASE WHEN _WPP.FP_PLAN_ID IS NOT NULL THEN ''Y'' ELSE NULL END) AS WPP_LATEST_DW_SUBMIT_FLAG,' + char(10);
		
		SET @v_dSql += '			_MPP.DW_FLAG AS MPP_DW_FLAG, _MPP.DW_USER AS MPP_DW_USER, _MPP.DW_TIME AS MPP_DW_TIME, (CASE WHEN _MPP.FP_PLAN_ID IS NOT NULL THEN ''Y'' ELSE NULL END) AS MPP_LATEST_DW_SUBMIT_FLAG,' + char(10);

		SET @v_dSql += '	             (CASE WHEN E.RELEASE_PLAN_ID IS NOT NULL THEN ''Y'' ELSE NULL END) AS LATEST_RELEASE_FLAG                                                                                          ' + char(10) ;
		SET @v_dSql += '	             -- 배포 plan 에 대해서 plan detail flag 정보 값 추가... 20210203                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	             , (CASE WHEN F.CONFIRM_FLAG = ''Y'' THEN ''Completed'' ELSE F.CONFIRM_FLAG END) AS _CONFIRM_FLAG                                                                                   ' + char(10) ;
		SET @v_dSql += '	             , (CASE WHEN F.RELEASE_FLAG = ''Y'' THEN ''Completed'' ELSE F.RELEASE_FLAG END) AS _RELEASE_FLAG                                                                                   ' + char(10) ;
		SET @v_dSql += '	             , (CASE WHEN F.MES_TRANSFER_FLAG = ''Y'' THEN ''Completed'' ELSE F.MES_TRANSFER_FLAG END) AS _MES_TRANSFER_FLAG                                                                    ' + char(10) ;
		SET @v_dSql += '	             , (CASE WHEN F.JOB_TYPE = ''R'' THEN ''Ready''                                                                                                                                     ' + char(10) ;
		SET @v_dSql += '	                     WHEN F.JOB_TYPE = ''P'' THEN ''Processing''                                                                                                                                ' + char(10) ;
		SET @v_dSql += '	                     WHEN F.JOB_TYPE = ''C'' THEN ''Completed''                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	                     WHEN F.JOB_TYPE = ''E'' THEN ''Error''                                                                                                                                     ' + char(10) ;
		SET @v_dSql += '	                     ELSE F.JOB_TYPE END ) AS _QUEUE_FLAG                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      FROM SCM_FP_PLAN_H A WITH(NOLOCK)                                                                                                                                                         ' + char(10) ;
		
		SET @v_dSql += '	      LEFT OUTER JOIN (                                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += '	          SELECT DISTINCT B.PLAN_DATE, B.INSTANCE_ID, B.PLAN_ID                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	          FROM   SCM_FP_PLAN_DETAIL_H B WITH(NOLOCK)                                                                                                                                            ' + char(10) ;
		SET @v_dSql += '	          WHERE  B.PLAN_DATE BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                                                    ' + char(10) ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += '	          AND    B.CONFIRM_FLAG = ''Y''                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += '	      ) B                                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      ON    A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      AND   A.PLAN_ID = B.PLAN_ID                                                                                                                                                               ' + char(10) ;
		SET @v_dSql += '	      AND   CONVERT(VARCHAR, A.PLAN_START_TIME, 112) = B.PLAN_DATE                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	      LEFT OUTER JOIN RELEASE_PLAN C                                                                                                                                                            ' + char(10) ;
		SET @v_dSql += '	      ON    A.INSTANCE_ID = C.INSTANCE_ID                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      AND   A.PLAN_ID     = C.PLAN_ID                                                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	      AND   CONVERT(VARCHAR, A.PLAN_START_TIME, 112) = C.PLAN_DATE                                                                                                                              ' + char(10) ;
		--SET @v_dSql += '	      LEFT OUTER JOIN (                                                                                                                                                                         ' + char(10) ;
		--SET @v_dSql += '	        	SELECT A.*                                                                                                                                                                          ' + char(10) ;
		--SET @v_dSql += '	        	FROM (                                                                                                                                                                              ' + char(10) ;
		--SET @v_dSql += '	          		SELECT A.*, (CASE WHEN B.FACTORY_ID=''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END) AS RELEASE_VALUE                                                                          ' + char(10) ;
		--SET @v_dSql += '	          			 , ROW_NUMBER() OVER (PARTITION BY A.INSTANCE_ID, (CASE WHEN B.FACTORY_ID=''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END)                                                 ' + char(10) ;
		--SET @v_dSql += '	          								            ORDER BY     CONVERT(NUMERIC,A.CALL_SEQUENCE) DESC) AS ROW_NUM                                                                              ' + char(10) ;
		--SET @v_dSql += '	          		FROM (                                                                                                                                                                          ' + char(10) ;
		--SET @v_dSql += '	            			SELECT CALL_SEQUENCE                                                                                                                                                    ' + char(10) ;
		--SET @v_dSql += '	            				 , MAX(CASE WHEN A.CONDITION_TYPE = ''INSTANCE_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS INSTANCE_ID                                                            ' + char(10) ;
		--SET @v_dSql += '	            				 , MAX(CASE WHEN A.CONDITION_TYPE = ''FP_PLAN_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS FP_PLAN_ID                                                              ' + char(10) ;
		--SET @v_dSql += '	            			FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK)                                                                                                                               ' + char(10) ;
		--SET @v_dSql += '	            			GROUP BY CALL_SEQUENCE                                                                                                                                                  ' + char(10) ;
		--SET @v_dSql += '	          		) A                                                                                                                                                                             ' + char(10) ;
		--SET @v_dSql += '	          		INNER JOIN FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK)                                                                                                                                ' + char(10) ;
		--SET @v_dSql += '	          		ON  A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                                               ' + char(10) ;
		--SET @v_dSql += '	          		AND A.FP_PLAN_ID  = B.RELEASE_PLAN_ID                                                                                                                                           ' + char(10) ;
		--SET @v_dSql += '	        	) A                                                                                                                                                                                 ' + char(10) ;
		--SET @v_dSql += '	        	WHERE A.ROW_NUM = 1                                                                                                                                                                 ' + char(10) ;
		--SET @v_dSql += '	      ) D                                                                                                                                                                                       ' + char(10) ;
		--SET @v_dSql += '	      ON    A.INSTANCE_ID = D.INSTANCE_ID                                                                                                                                                       ' + char(10) ;
		--SET @v_dSql += '	      AND   A.PLAN_ID     = D.FP_PLAN_ID                                                                                                                                                        ' + char(10) ;
		
		
		IF	@p_last_release_flag = 'Y'
			BEGIN
				SET @v_dSql +=	'	INNER JOIN (                                                                                                                    ' + char(10) ;
			END
		ELSE
			BEGIN
				SET @v_dSql +=	'	LEFT OUTER JOIN (                                                                                                                    ' + char(10) ;
			END
		SET @v_dSql += '	        	SELECT A.*                                                                                                                                                                          ' + char(10) ;
		SET @v_dSql += '	        	FROM (                                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                                                                ' + char(10) ;
		SET @v_dSql += '	        			 , RELEASE_PLAN_ID, INSERT_TIME                                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	        			 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID=''-'' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)                                                  ' + char(10) ;
		SET @v_dSql += '	        		                       ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM                                                                                                             ' + char(10) ;
		SET @v_dSql += '	        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)                                                                                                                                    ' + char(10) ;
		SET @v_dSql += '	        	) A                                                                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	        	WHERE A.ROW_NUM = 1                                                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	      ) E                                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      ON    A.INSTANCE_ID = E.INSTANCE_ID                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      AND   A.PLAN_ID     = E.RELEASE_PLAN_ID                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	      LEFT OUTER JOIN (                                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += '	        	SELECT A.*, B.JOB_TYPE                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	        	FROM (                                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	          		SELECT PLAN_DATE, INSTANCE_ID, PLAN_ID, RELEASE_PLAN_ID, A.FACTORY_ID, CONFIRM_FLAG, RELEASE_FLAG, MES_TRANSFER_FLAG                                                            ' + char(10) ;
		SET @v_dSql += '	          		FROM   HIS_FP_PLAN_DETAIL_H A WITH(NOLOCK)                                                                                                                                      ' + char(10) ;
		SET @v_dSql += '	          		WHERE  1=1                                                                                                                                                                      ' + char(10) ;
		SET @v_dSql += '					AND    A.PLAN_DATE BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                                              ' + char(10) ;
		SET @v_dSql += '	          		UNION ALL                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	          		SELECT PLAN_DATE, INSTANCE_ID, PLAN_ID, RELEASE_PLAN_ID, A.PLAN_GROUP_ID, CONFIRM_FLAG, RELEASE_FLAG, MES_TRANSFER_FLAG                                                         ' + char(10) ;
		SET @v_dSql += '	          		FROM   HIS_FP_PLAN_GROUP_DETAIL_H A WITH(NOLOCK)                                                                                                                                ' + char(10) ;
		SET @v_dSql += '	          		WHERE  1=1                                                                                                                                                                      ' + char(10) ;
		SET @v_dSql += '					AND    A.PLAN_DATE BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                                              ' + char(10) ;
		SET @v_dSql += '	        	) A                                                                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	        	LEFT OUTER JOIN (                                                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	          		-- 혹시 동일 실행될 경우, 나중에 실행된 queue의 상태를 보여줌                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	          		SELECT A.*                                                                                                                                                                      ' + char(10) ;
		SET @v_dSql += '	          		FROM (                                                                                                                                                                          ' + char(10) ;
		SET @v_dSql += '	            			SELECT INSTANCE_DATE, INSTANCE_ID, FP_PLAN_ID, JOB_TYPE, PARAMETER5 AS INSTANCE_TYPE, JOB_SEQ                                                                           ' + char(10) ;
		SET @v_dSql += '	            				   , ROW_NUMBER() OVER(PARTITION BY INSTANCE_DATE, INSTANCE_ID, FP_PLAN_ID, PARAMETER5 ORDER BY JOB_SEQ DESC) AS ROWNUM                                             ' + char(10) ;
		SET @v_dSql += '	            			FROM   FP_NETJOB_QUEUE A WITH(NOLOCK)                                                                                                                                   ' + char(10) ;
		SET @v_dSql += '	            			WHERE  1=1                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	            			AND    PROC_NAME = ''PR_SCM_OF_RELEASE_AUTO_PROCESSING''                                                                                                                ' + char(10) ;
		SET @v_dSql += '							AND    A.INSTANCE_DATE BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                                  ' + char(10) ;
		SET @v_dSql += '	            			AND    ACTIVE_FLAG = ''Y''                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	          		) A                                                                                                                                                                             ' + char(10) ;
		SET @v_dSql += '	          		WHERE 1=1                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	          		AND   A.ROWNUM = 1                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	        	) B                                                                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	        	ON 1=1                                                                                                                                                                              ' + char(10) ;
		SET @v_dSql += '	        	AND   A.PLAN_DATE   = B.INSTANCE_DATE                                                                                                                                               ' + char(10) ;
		SET @v_dSql += '	        	AND   A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                                                 ' + char(10) ;
		SET @v_dSql += '	        	AND   A.PLAN_ID     = B.FP_PLAN_ID                                                                                                                                                  ' + char(10) ;
		SET @v_dSql += '	        	AND   A.FACTORY_ID  = B.INSTANCE_TYPE                                                                                                                                               ' + char(10) ;
		SET @v_dSql += '	      ) F                                                                                                                                                                                       ' + char(10) ;
		SET @v_dSql += '	      ON  A.INSTANCE_ID = F.INSTANCE_ID                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += '	      AND A.PLAN_ID     = F.RELEASE_PLAN_ID                                                                                                                                                     ' + char(10) ;
		
		SET @v_dSql += 'LEFT OUTER JOIN ( '+ char(10);
		SET @v_dSql += '	SELECT A.* '+ char(10);
		SET @v_dSql += '	FROM  ( '+ char(10);
		SET @v_dSql += '		SELECT A.* '+ char(10);
		SET @v_dSql += '			 , ''Y'' AS DW_FLAG  '+ char(10);
		SET @v_dSql += '			 , ROW_NUMBER() OVER (PARTITION BY A.INSTANCE_ID, (CASE WHEN B.FACTORY_ID=''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END) '+ char(10);
		SET @v_dSql += '	       	 					  ORDER BY     CONVERT(NUMERIC,A.CALL_SEQUENCE) DESC) AS ROW_NUM '+ char(10);
		SET @v_dSql += '		FROM ( '+ char(10);
		SET @v_dSql += '			SELECT A.* '+ char(10);
		SET @v_dSql += '			FROM ( '+ char(10);
		SET @v_dSql += '				SELECT CALL_SEQUENCE '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''INSTANCE_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS INSTANCE_ID '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''FP_PLAN_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS FP_PLAN_ID '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''TYPE'' THEN A.CONDITION_VALUE ELSE NULL END) AS TYPE '+ char(10);
		SET @v_dSql += '					 , MAX(A.INSERT_ID) AS DW_USER '+ char(10);
		SET @v_dSql += '					 , MAX(CONVERT(VARCHAR,A.INSERT_TIME,20)) AS DW_TIME '+ char(10);
		SET @v_dSql += '				FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK) '+ char(10);
		SET @v_dSql += '				GROUP BY CALL_SEQUENCE '+ char(10);
		SET @v_dSql += '			) A '+ char(10);
		SET @v_dSql += '			WHERE 1=1 '+ char(10);
		SET @v_dSql += '			AND   A.TYPE = ''WPP'' '+ char(10);
		SET @v_dSql += '		) A '+ char(10);
		SET @v_dSql += '		INNER JOIN FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK) '+ char(10);
		SET @v_dSql += '		ON  A.INSTANCE_ID = B.INSTANCE_ID '+ char(10);
		SET @v_dSql += '		AND A.FP_PLAN_ID  = B.RELEASE_PLAN_ID '+ char(10);
		SET @v_dSql += '	) A '+ char(10);
		SET @v_dSql += '	WHERE A.ROW_NUM = 1 '+ char(10);
		SET @v_dSql += ') _WPP '+ char(10);
		SET @v_dSql += 'ON    A.INSTANCE_ID = _WPP.INSTANCE_ID '+ char(10);
		SET @v_dSql += 'AND   A.PLAN_ID     = _WPP.FP_PLAN_ID '+ char(10);
		SET @v_dSql += 'LEFT OUTER JOIN ( '+ char(10);
		SET @v_dSql += '	SELECT A.* '+ char(10);
		SET @v_dSql += '	FROM  ( '+ char(10);
		SET @v_dSql += '		SELECT A.* '+ char(10);
		SET @v_dSql += '			 , ''Y'' AS DW_FLAG '+ char(10);
		SET @v_dSql += '			 , ROW_NUMBER() OVER (PARTITION BY A.INSTANCE_ID, (CASE WHEN B.FACTORY_ID=''-'' THEN B.PLAN_GROUP_ID ELSE B.FACTORY_ID END) '+ char(10);
		SET @v_dSql += '	       	 					  ORDER BY     CONVERT(NUMERIC,A.CALL_SEQUENCE) DESC) AS ROW_NUM '+ char(10);
		SET @v_dSql += '		FROM ( '+ char(10);
		SET @v_dSql += '			SELECT A.* '+ char(10);
		SET @v_dSql += '			FROM ( '+ char(10);
		SET @v_dSql += '				SELECT CALL_SEQUENCE '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''INSTANCE_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS INSTANCE_ID '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''FP_PLAN_ID'' THEN A.CONDITION_VALUE ELSE NULL END) AS FP_PLAN_ID '+ char(10);
		SET @v_dSql += '					 , MAX(CASE WHEN A.CONDITION_TYPE = ''TYPE'' THEN A.CONDITION_VALUE ELSE NULL END) AS TYPE '+ char(10);
		SET @v_dSql += '					 , MAX(A.INSERT_ID) AS DW_USER '+ char(10);
		SET @v_dSql += '					 , MAX(CONVERT(VARCHAR,A.INSERT_TIME,20)) AS DW_TIME '+ char(10);
		SET @v_dSql += '				FROM   FP_PROC_PARAMETER_H A WITH(NOLOCK) '+ char(10);
		SET @v_dSql += '				GROUP BY CALL_SEQUENCE '+ char(10);
		SET @v_dSql += '			) A '+ char(10);
		SET @v_dSql += '			WHERE 1=1 '+ char(10);
		SET @v_dSql += '			AND   A.TYPE = ''MPP'' '+ char(10);
		SET @v_dSql += '		) A '+ char(10);
		SET @v_dSql += '		INNER JOIN FP_RELEASE_PLAN_INFO_H B WITH(NOLOCK) '+ char(10);
		SET @v_dSql += '		ON  A.INSTANCE_ID = B.INSTANCE_ID '+ char(10);
		SET @v_dSql += '		AND A.FP_PLAN_ID  = B.RELEASE_PLAN_ID '+ char(10);
		SET @v_dSql += '	) A '+ char(10);
		SET @v_dSql += '	WHERE A.ROW_NUM = 1 '+ char(10);
		SET @v_dSql += ' ) _MPP '+ char(10);
		SET @v_dSql += ' ON    A.INSTANCE_ID = _MPP.INSTANCE_ID '+ char(10);
		SET @v_dSql += ' AND   A.PLAN_ID     = _MPP.FP_PLAN_ID '+ char(10);

		
		
		SET @v_dSql += '		  WHERE   CONVERT(VARCHAR, A.PLAN_START_TIME, 112) BETWEEN '''+ @p_due_from_date +''' AND '''+ @p_due_to_date +'''                                                                          ' + char(10) ;
		SET @v_dSql += '	      AND    EXISTS (                                                                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	            SELECT 1                                                                                                                                                                            ' + char(10) ;
		SET @v_dSql += '	            FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)                                                                                                                                           ' + char(10) ;
		SET @v_dSql += '	            WHERE  A.INSTANCE_ID = B.INSTANCE_ID                                                                                                                                                ' + char(10) ;
		SET @v_dSql += '	            AND    B.USER_ID     = '''+ @p_user_id +'''                                                                                                                                                    ' + char(10) ;
		SET @v_dSql += '	      )                                                                                                                                                                                         ' + char(10) ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_ID' , 'EQ', @p_plan_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_TYPE' , 'EQ', @p_plan_type)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLAN_WEEK' , 'EQ', @p_plan_week)) + char(10);
		SET @v_dSql += '	      ORDER BY INSTANCE_ID, PLAN_ID DESC, PLAN_TYPE, PLAN_WEEK, PLAN_START_TIME                                                                                                                 ' + char(10) ;

		



	END
	
	IF @p_sys_type = 'SQL'
    BEGIN
		select @v_dSql as [QUERY_VALUE]
    END ELSE BEGIN
		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END
	
  
END

