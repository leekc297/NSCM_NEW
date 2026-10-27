
-- ================================================================================================
-- Program ID          : 
-- Program Name        : PR_SCM_RELEASE_PLAN_ATTACH_FILE
-- Param               :
-- Batch Period        : realtime
-- Description         :
--
-- Source 
-- Destina
-- Source 
-- Destina
--
-- Create(Update) Date : 2023.02.14
-- Update Date         : 2023.04.07 Version 1.2  piyong
--					   : 2023.07.24	1.3 piyong

-- Author              : 
-- Version             : 1.0   Initial Creation
--						 
-- 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.
--                         Pack 공정군 로직에 LINK 공정군 추가
-- =============================================================================

CREATE PROCEDURE [dbo].[PR_SCM_RELEASE_PLAN_ATTACH_FILE]
	  @P_INSTANCE_ID    NVARCHAR(100) = 'KR_CELL_A2'
	, @P_INSTANCE_DATE  NVARCHAR(100) = '20220708'
	, @P_FACTORY_ID     NVARCHAR(100) =  'A2'
	, @P_PLAN_GROUP_ID  NVARCHAR(100) =  '-'
	, @P_PLAN_DESCRIPTION  NVARCHAR(MAX) =  '-'
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON
	
	-- LOG 용 변수 설정
	DECLARE @V_PROC_NAME			NVARCHAR(100)	= 'PR_SCM_RELEASE_PLAN_ATTACH_FILE'
	DECLARE @V_DESCR				NVARCHAR(250)
	DECLARE @V_ROWCOUNT				INTEGER			= 0
	DECLARE @V_EVENT_DTTM			DATETIME		= GETDATE()
	-- ERROR_LINE
	DECLARE @V_MESSAGE1				NVARCHAR(1000)	= 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	DECLARE @V_MESSAGE2				NVARCHAR(1000)	= 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	DECLARE @V_ATTACH_PATH			NVARCHAR(100)	= 'C:\saprfc\lts\'	-- csv저장위치 (운영: c:\saprfc\lts\, 개발: d:\SAPRFC_TEST\debug\test\)
	DECLARE @V_ATTACH_FILE			NVARCHAR(100)	= 'RELEASE(' + @P_INSTANCE_ID + ',' +@P_INSTANCE_DATE+ ').CSV'	
	DECLARE @V_BCP_QUERYOUT_COMMAND	NVARCHAR(2000)	= ''
	DECLARE @V_BCP_QUERYOUT_OPTION	NVARCHAR(100)	= ' -w -t"\t" -T -S ' + @@SERVERNAME
	DECLARE @V_BCP_DELETE_COMMAND	NVARCHAR(1000)	

	DECLARE @V_SQL					NVARCHAR(MAX)	= N''
	DECLARE @V_FROM_DATE			NVARCHAR(8)		
	DECLARE @V_TO_DATE				NVARCHAR(8)		
	DECLARE @V_MIN_PLAN_DATE		NVARCHAR(8)		
	DECLARE @V_MAX_PLAN_DATE		NVARCHAR(8)		
	DECLARE @V_TYPE					NVARCHAR(10)
	DECLARE @V_FP_PLAN_ID			NVARCHAR(100)
	DECLARE @V_DATE					NVARCHAR(8)	
	DECLARE @V_DAY_COL_NAME			NVARCHAR(10)

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START', NULL, @V_MESSAGE1, '############### Start of procedure ###############', NULL, @V_EVENT_DTTM
    
	BEGIN TRY

		SET @V_TYPE = (
			SELECT TOP 1 CASE 
						WHEN ATTRIBUTE9 = 'E3'	THEN 'PMIX'
						WHEN ATTRIBUTE9 = 'E'	THEN 'ELEC'	
						WHEN ATTRIBUTE9 = 'E1'	THEN 'ELEC'	
						WHEN ATTRIBUTE9 = 'A'	THEN 'ASSY'
						WHEN ATTRIBUTE9 = 'F'	THEN 'FORM'
						WHEN ATTRIBUTE9 = 'P'	THEN 'PACK'
						WHEN ATTRIBUTE9 = 'L'	THEN 'PACK'  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 공정군 로직에 LINK 공정군 추가
						END 
			FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK)
			WHERE	LOOKUP_TYPE_CODE = 'INSTANCE_ID'
			AND		SEGMENT1 = @P_INSTANCE_ID
			)

		SET @V_FP_PLAN_ID = (
			SELECT TOP 1 RELEASE_PLAN_ID
			FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
			WHERE  1=1
			AND    INSTANCE_ID = @P_INSTANCE_ID
			AND    INSTANCE_DATE = @P_INSTANCE_DATE
			AND    ( FACTORY_ID = @P_FACTORY_ID OR PLAN_GROUP_ID = @P_PLAN_GROUP_ID)
			ORDER BY INSERT_TIME DESC
			)
			
		SELECT @V_MIN_PLAN_DATE = CONVERT( NVARCHAR(10), MIN(PLAN_DATE), 112) 
			,@V_MAX_PLAN_DATE = CONVERT( NVARCHAR(10), MAX(PLAN_DATE), 112) 
		FROM FP_DAILY_PRODUCTION_PLAN_R 
		WHERE FP_PLAN_ID IN (
				SELECT RELEASE_PLAN_ID
		/*
		WHERE SUBSTRING(FP_PLAN_ID, 0, LEN(FP_PLAN_ID) -3) IN (
				SELECT SUBSTRING(RELEASE_PLAN_ID, 0, LEN(RELEASE_PLAN_ID) -3)
		*/			FROM (
						SELECT RELEASE_PLAN_ID
								, ROW_NUMBER() OVER ( PARTITION BY INSTANCE_ID, INSTANCE_DATE, DIVISION_ID
																, FACTORY_ID, PLAN_GROUP_ID ORDER BY INSERT_TIME DESC
														) NUMS
							FROM [DBO].FP_RELEASE_PLAN_INFO_H H
							WHERE INSTANCE_ID = @P_INSTANCE_ID
							AND INSTANCE_DATE = @P_INSTANCE_DATE
							AND FACTORY_ID = ISNULL(@P_FACTORY_ID, FACTORY_ID)
							AND PLAN_GROUP_ID = ISNULL(@P_PLAN_GROUP_ID, PLAN_GROUP_ID)
						) A
					WHERE NUMS = 1
							)
		AND CAST(PLAN_QTY AS NUMERIC) > 0
		AND INSTANCE_ID =  @P_INSTANCE_ID -- 2019-01-02 kimcd 조건 추가

		SELECT	@V_MAX_PLAN_DATE = (CASE WHEN  DATEDIFF(DD, CONVERT(DATE,@V_MIN_PLAN_DATE), CONVERT(DATE,@V_MAX_PLAN_DATE)) > 120 
										 THEN  CONVERT(NVARCHAR, DATEADD(DAY, 120, CONVERT(DATE,@V_MIN_PLAN_DATE) ), 112)
										 ELSE  @V_MAX_PLAN_DATE END)

		SET @V_FROM_DATE = ISNULL(@V_MIN_PLAN_DATE, @P_INSTANCE_DATE)
		SET @V_TO_DATE = ISNULL(@V_MAX_PLAN_DATE, @P_INSTANCE_DATE)


		DECLARE CUR_DATE_LIST CURSOR FOR				--배포기간 날짜 조회
			SELECT	CONVERT(VARCHAR,DATE_ID,112) AS YYYYMMDD
					, SUBSTRING(CONVERT(VARCHAR,DATE_ID,23), 6, 5) + '(' + [DAY] + ')' AS DAY_COL_NAME
			FROM	SCM_SYS_CALENDAR_M WITH(NOLOCK)
			WHERE	DATE_ID BETWEEN @V_FROM_DATE AND @V_TO_DATE
			ORDER BY DATE_ID
		
		IF OBJECT_ID('TEMPDB..##RELEASE_CSV') IS NOT NULL
			DROP TABLE ##RELEASE_CSV

		IF @V_TYPE = 'PMIX'
		BEGIN
			SET @V_SQL += ' SELECT *	' + Char(10)
			SET @V_SQL += ' INTO ##RELEASE_CSV' + Char(10)
			SET @V_SQL += ' FROM ( ' + Char(10) 
			SET @V_SQL += '		SELECT  ''Line Name'' AS LINE_NAME '+char(10)
			SET @V_SQL += '				, ''Material'' AS ITEM_ID '+char(10)
			SET @V_SQL += '				, ''Nick Name'' AS NICK_NAME '+char(10)
			SET @V_SQL += '				, ''Prod. Type'' AS PRODUCTION_TYPE '+char(10)
			SET @V_SQL += '				, ''Market'' AS MARKET '+char(10)
			SET @V_SQL += '				, ''Category'' AS CATEGORY_NAME '+char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ' Kg]'' AS Kg' + @V_DATE + Char(10)	
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ' Batch]'' AS Batch' + @V_DATE + Char(10)	
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ' Seq]'' AS Seq' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			SET @V_SQL += '				, ''0'' AS LINE_ID '+char(10)
			SET @V_SQL += '				, 0 AS CATEGORY_ORDER '+char(10)
			SET @V_SQL += '		 UNION ALL '+char(10)
			SET @V_SQL += '		 SELECT A.LINE_NAME, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE, A.MARKET, B.CATEGORY_NAME ' + char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, CASE ' + char(10)
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_OUT'' THEN FORMAT(CAST(SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @V_DATE + ''' THEN CEILING(A.ADJUST_OUT_QTY_KG) ELSE 0 END) AS NUMERIC(10)), ''#,#'') ' + char(10)
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_MEMO'' THEN ISNULL(MAX(C.MEMO_TEXT), '''') ' + char(10) 
					SET @V_SQL += '			      END AS Kg' + @V_DATE + Char(10)
					SET @V_SQL += '			    , CASE ' + char(10) 
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_OUT'' THEN FORMAT(CAST(SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @V_DATE + ''' THEN ROUND(A.ADJUST_OUT_QTY_BATCH,2) ELSE 0 END) AS NUMERIC(10)), ''#,#'')  ' + char(10) 
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_MEMO'' THEN  NULL ' + char(10) 
					SET @V_SQL += '			      END AS Batch' + @V_DATE + Char(10)
					SET @V_SQL += '			    , CASE ' + char(10) 
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_OUT'' THEN FORMAT(CAST(SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @V_DATE + ''' THEN A.SEQ ELSE 0 END) AS NUMERIC(10)), ''#,#'')  ' + char(10) 
					SET @V_SQL += '						WHEN B.CATEGORY_ID=''P_MEMO'' THEN  NULL ' + char(10) 
					SET @V_SQL += '			      END AS Seq' + @V_DATE + Char(10)
					
					FETCH NEXT FROM CUR_DATE_LIST
						INTO @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			SET @V_SQL += '			    , A.LINE_ID ' + char(10)
			SET @V_SQL += '			    , B.CATEGORY_ORDER ' + char(10)
			SET @V_SQL += '		 FROM (                               ' + char(10)	
			SET @V_SQL += '		 	SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID   ' + char(10)
			SET @V_SQL += '		 	    , A.LOCATION, A.OPERATION_ID                                          ' + char(10)
			SET @V_SQL += '		 	    , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 	    , A.EQUIPMENT_ID    ' + char(10)
			SET @V_SQL += '		 	    , A.PLAN_DATE       ' + char(10)
			SET @V_SQL += '		 	    , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SET @V_SQL += '		 	    , A.PRODUCTION_TYPE ' + char(10)
			SET @V_SQL += '		 	    , A.MARKET          ' + char(10)
			SET @V_SQL += '		 	    , A.SEQ             ' + char(10)
			SET @V_SQL += '		 	    , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_KG           ' + char(10)
			SET @V_SQL += '		 	FROM (                                                                        ' + char(10)
			SET @V_SQL += '		 		  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '		 		      , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SET @V_SQL += '		 		      , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 		      , A.EQUIPMENT_ID                                 ' + char(10)
			SET @V_SQL += '		 		      , A.PLAN_DATE                                    ' + char(10)
			SET @V_SQL += '		 		      , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SET @V_SQL += '		 		      , A.PRODUCTION_TYPE                              ' + char(10)
			SET @V_SQL += '		 		      , A.MARKET                                       ' + char(10)
			SET @V_SQL += '		 		      , A.SEQ                                          ' + char(10)
			SET @V_SQL += '		 		      , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_KG ' + char(10)
			SET @V_SQL += '		 		  FROM FP_AMEND_DAILY_PLAN_H A WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '		 		  WHERE  INSTANCE_ID      = '''+ @P_INSTANCE_ID +''' ' + char(10)
			SET @V_SQL += '		 		  AND    FP_PLAN_ID       = '''+ @V_FP_PLAN_ID +''' ' + char(10)
			SET @V_SQL += '		 		  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @P_INSTANCE_DATE +''' AND '''+ @V_TO_DATE +''' ' + char(10)
			SET @V_SQL += '		 		  AND   A.ADJUST_IN_QTY_BATCH > 0 ' + char(10)
			SET @V_SQL += '		 		  UNION ALL                       ' + char(10)
			SET @V_SQL += '		 		  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '		 		         , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SET @V_SQL += '		 		         , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 		         , A.EQUIPMENT_ID                                 ' + char(10)
			SET @V_SQL += '		 		         , A.PLAN_DATE                                    ' + char(10)
			SET @V_SQL += '		 		         , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SET @V_SQL += '		 		         , A.PRODUCTION_TYPE                              ' + char(10)
			SET @V_SQL += '		 		         , A.MARKET                                       ' + char(10)
			SET @V_SQL += '		 		         , '''' SEQ                                       ' + char(10)
			SET @V_SQL += '		 		        , A.BATCH_OUT_QTY AS ADJUST_OUT_QTY_BATCH, A.PLAN_QTY AS ADJUST_OUT_QTY_KG       ' + char(10)
			SET @V_SQL += '		 		  FROM FP_DAILY_PRODUCTIOIN_PLAN_H A WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '					  INNER JOIN FP_INSTANCE_LINE_V B WITH(NOLOCK) ' + char(10)  
			SET @V_SQL += '					  ON	A.COMPANY_ID	= B.COMPANY_ID ' + char(10)
			SET @V_SQL += '					  AND	A.DIVISION_ID	= B.DIVISION_ID ' + char(10)
			SET @V_SQL += '					  AND	A.SITE_ID		= B.SITE_ID ' + char(10)
			SET @V_SQL += '					  AND	A.PLANT_ID		= B.PLANT_ID ' + char(10)
			SET @V_SQL += '					  AND	A.FACTORY_ID	= B.FACTORY_ID ' + char(10)
			SET @V_SQL += '					  AND	A.OPERATION_ID	= B.OPERATION_ID ' + char(10)
			SET @V_SQL += '					  AND	A.LINE_ID		= B.LINE_ID ' + char(10)
			SET @V_SQL += '					  AND	A.ELECTRODE_TYPE= B.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 		  WHERE  INSTANCE_ID = ''' + @P_INSTANCE_ID + '''  ' + char(10)
			SET @V_SQL += '		 		  AND    A.PLAN_TYPE = ''RELEASE''                ' + char(10)
			SET @V_SQL += '		 		  AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @V_FROM_DATE +''' AND '''+ @P_INSTANCE_DATE +'''  -1 ' + char(10)
			SET @V_SQL += '		 		  UNION ALL ' + char(10)
			SET @V_SQL += '		 		  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '		 		         , A.LOCATION, A.OPERATION_ID                     ' + char(10)
			SET @V_SQL += '		 		         , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 		         , A.EQUIPMENT_ID                                 ' + char(10)
			SET @V_SQL += '		 		         , A.PLAN_DATE                                    ' + char(10)
			SET @V_SQL += '		 		         , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME    ' + char(10)
			SET @V_SQL += '		 		         , A.FP_PRODUCTION_TYPE AS PRODUCTION_TYPE        ' + char(10)
			SET @V_SQL += '		 		         , A.MARKET                                       ' + char(10)
			SET @V_SQL += '		 		         , '''' SEQ                                       ' + char(10)
			SET @V_SQL += '		 		         , 0 AS ADJUST_OUT_QTY_BATCH, 0 AS ADJUST_OUT_QTY_KG ' + char(10)
			SET @V_SQL += '		 		  FROM SCM_DAILY_PRODUCT_RESULT_H A WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '					  INNER JOIN FP_INSTANCE_LINE_V B WITH(NOLOCK) ' + char(10)  
			SET @V_SQL += '					  ON	A.COMPANY_ID	= B.COMPANY_ID ' + char(10)
			SET @V_SQL += '					  AND	A.DIVISION_ID	= B.DIVISION_ID ' + char(10)
			SET @V_SQL += '					  AND	A.SITE_ID		= B.SITE_ID ' + char(10)
			SET @V_SQL += '					  AND	A.PLANT_ID		= B.PLANT_ID ' + char(10)
			SET @V_SQL += '					  AND	A.FACTORY_ID	= B.FACTORY_ID ' + char(10)
			SET @V_SQL += '					  AND	A.OPERATION_ID	= B.OPERATION_ID ' + char(10)
			SET @V_SQL += '					  AND	A.LINE_ID		= B.LINE_ID ' + char(10)
			SET @V_SQL += '					  AND	A.ELECTRODE_TYPE= B.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		 		  WHERE  INSTANCE_ID = ''' + @P_INSTANCE_ID + '''  ' + char(10)
			SET @V_SQL += '		 	      AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN '''+ @V_FROM_DATE +''' AND '''+ @V_TO_DATE +''' ' + char(10)
			SET @V_SQL += '		  		 ) A                                     ' + char(10)
			SET @V_SQL += '		  	INNER JOIN SCM_ITEM_M B WITH(NOLOCK)    ' + char(10)
			SET @V_SQL += '		  	ON     A.COMPANY_ID     = B.COMPANY_ID  ' + char(10)
			SET @V_SQL += '		  	AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SET @V_SQL += '		  	AND    A.SITE_ID        = B.SITE_ID     ' + char(10)
			SET @V_SQL += '		  	AND    A.ITEM_ID        = B.ITEM_ID     ' + char(10)
			SET @V_SQL += '		  	INNER JOIN SCM_LINE_M C WITH(NOLOCK)       ' + char(10)
			SET @V_SQL += '		  	ON     A.COMPANY_ID     = C.COMPANY_ID     ' + char(10)
			SET @V_SQL += '		  	AND    A.DIVISION_ID    = C.DIVISION_ID    ' + char(10)
			SET @V_SQL += '		  	AND    A.SITE_ID        = C.SITE_ID        ' + char(10)
			SET @V_SQL += '		  	AND    A.PLANT_ID       = C.PLANT_ID       ' + char(10)
			SET @V_SQL += '		  	AND    A.FACTORY_ID     = C.FACTORY_ID     ' + char(10)
			SET @V_SQL += '		  	AND    A.OPERATION_ID   = C.OPERATION_ID   ' + char(10)
			SET @V_SQL += '		  	AND    A.LINE_ID        = C.LINE_ID        ' + char(10)
			SET @V_SQL += '		  	AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		  	WHERE 1=1                                  ' + char(10)
			SET @V_SQL += '		  	) A              ' + char(10)
			SET @V_SQL += '		 INNER JOIN (     ' + char(10)
			SET @V_SQL += '		     SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 20 AS CATEGORY_ORDER ' + char(10)
			SET @V_SQL += '		     UNION ALL    ' + char(10)
			SET @V_SQL += '		     SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 400 AS CATEGORY_ORDER   ' + char(10)
			SET @V_SQL += '		 ) B              ' + char(10)
			SET @V_SQL += '		 ON 1=1           ' + char(10)
    		-- MEMO
			SET @V_SQL += '			LEFT OUTER JOIN ' + Char(10)
			SET @V_SQL += '			( ' + Char(10)
			SET @V_SQL += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '			       	, A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '			       	, A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '			       	, A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '			       	, A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '			       	, A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '			       	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '			       	, MAX(B.ATTRIBUTE2 + '':'' + A.MEMO) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '				FROM    FP_AMEND_MEMO_M A WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '				LEFT OUTER JOIN  ' + Char(10)
			SET @V_SQL += '			   		(SELECT *  ' + Char(10)
			SET @V_SQL += '			   		FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '			   		WHERE   LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + Char(10)
			SET @V_SQL += '			   		AND     ACTIVE_FLAG=''Y'' ' + Char(10)
			SET @V_SQL += '			   		AND     ATTRIBUTE3 = ''SCM_WORK_CALENDAR_M'') B ' + Char(10)
			SET @V_SQL += '				ON		A.ATTR2	= B.SEGMENT1 ' + Char(10)
			SET @V_SQL += '				WHERE   A.INSTANCE_ID = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '				AND		CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '				GROUP BY A.COMPANY_ID ' + Char(10)
			SET @V_SQL += '					, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '			        , A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '			        , A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '			        , A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '			        , A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '			        , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '			       	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '			) C ' + Char(10)
			SET @V_SQL += '			ON	A.COMPANY_ID		= C.COMPANY_ID ' + Char(10)
			SET @V_SQL += '			AND	A.DIVISION_ID		= C.DIVISION_ID ' + Char(10)
			SET @V_SQL += '			AND	A.SITE_ID			= C.SITE_ID ' + Char(10)
			SET @V_SQL += '			AND	A.PLANT_ID			= C.PLANT_ID ' + Char(10)
			SET @V_SQL += '			AND	A.OPERATION_ID		= C.OPERATION_ID ' + Char(10)
			SET @V_SQL += '			AND	A.LINE_ID			= C.LINE_ID ' + Char(10)
			SET @V_SQL += '			AND	A.ELECTRODE_TYPE	= C.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '			AND	A.EQUIPMENT_ID		= C.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '			AND	A.ITEM_ID			= C.ITEM_ID ' + Char(10)
			SET @V_SQL += '			AND	A.TOP_ITEM_ID		= C.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '			AND	A.PRODUCTION_TYPE	= C.PRODUCTION_TYPE ' + Char(10)
			SET @V_SQL += '			AND	A.MARKET			= C.MARKET ' + Char(10)
			SET @V_SQL += '			AND	A.PLAN_DATE			= C.PLAN_DATE ' + Char(10)
			
			SET @V_SQL += '		 GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '		     , A.LOCATION, A.OPERATION_ID               ' + char(10)
			SET @V_SQL += '		     , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '		     , A.EQUIPMENT_ID                           ' + char(10)
			SET @V_SQL += '		     , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME    ' + char(10)
			SET @V_SQL += '		     , A.PRODUCTION_TYPE, A.MARKET              ' + char(10)
			SET @V_SQL += '		     , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)
			SET @V_SQL += ' ) A ' + Char(10)

			-- BCP COMMAND
			SET @V_BCP_QUERYOUT_COMMAND += 'bcp "SELECT LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME'

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @V_BCP_QUERYOUT_COMMAND += ', Kg' + @V_DATE	
				SET @V_BCP_QUERYOUT_COMMAND += ', Batch' + @V_DATE
				SET @V_BCP_QUERYOUT_COMMAND += ', Seq' + @V_DATE
				FETCH NEXT FROM CUR_DATE_LIST
					INTO  @V_DATE
						, @V_DAY_COL_NAME
			END;
			CLOSE CUR_DATE_LIST

			SET @V_BCP_QUERYOUT_COMMAND += ' FROM ##RELEASE_CSV'
			SET @V_BCP_QUERYOUT_COMMAND += ' ORDER BY LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_ORDER'
			SET @V_BCP_QUERYOUT_COMMAND += '" queryout '
		END
		ELSE IF @V_TYPE = 'ELEC'
		BEGIN
			SET @V_SQL += ' SELECT *	' + Char(10)
			SET @V_SQL += ' INTO ##RELEASE_CSV' + Char(10)
			SET @V_SQL += ' FROM ( ' + Char(10) 
			SET @V_SQL += '		SELECT  ''Line ID'' AS LINE_ID '+char(10)
			SET @V_SQL += '				, ''Material'' AS ITEM_ID '+char(10)
			SET @V_SQL += '				, ''Nick Name'' AS NICK_NAME '+char(10)
			SET @V_SQL += '				, ''Prod. Type'' AS PRODUCTION_TYPE '+char(10)
			SET @V_SQL += '				, ''Market'' AS MARKET '+char(10)
			SET @V_SQL += '				, ''Category'' AS CATEGORY_NAME '+char(10)
			SET @V_SQL += '				, ''Measure'' AS MEASURE_NAME '+char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ']'' AS D' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			SET @V_SQL += '				, ''0'' AS ODR '+char(10)
			SET @V_SQL += '				, 0 AS CATEGORY_ORDER '+char(10)

			SET @V_SQL += '		 UNION ALL '+char(10)
			SET @V_SQL += '       SELECT A.LINE_ID, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE, A.MARKET, A.CATEGORY_NAME, A.MEASURE_NAME' + Char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, CASE ' + Char(10)	
					SET @V_SQL += '					WHEN A.CATEGORY_ID = ''P_OUT_JR'' THEN FORMAT(CAST( D' + @V_DATE + ' AS  NUMERIC(10)), ''#,#'')' + Char(10)
					SET @V_SQL += '					WHEN A.CATEGORY_ID = ''P_OUT_CELL'' THEN FORMAT(CAST( D' + @V_DATE + ' AS  NUMERIC(10)), ''#,#'')' + Char(10)
					SET @V_SQL += '					WHEN A.CATEGORY_ID = ''P_OUT_BATCH'' THEN CONVERT(NVARCHAR, CONVERT(NUMERIC(10, 1), D' + @V_DATE + '))' + Char(10)
					SET @V_SQL += '					WHEN A.CATEGORY_ID = ''P_MEMO'' THEN ISNULL(A.M' + @V_DATE + ', '''') ' + Char(10)
					SET @V_SQL += '				 END AS D' + @V_DATE + Char(10)								
					
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			
			SET @V_SQL += '				, ''1'' AS ODR '+char(10)
			SET @V_SQL += '				, A.CATEGORY_ORDER '+char(10)
			SET @V_SQL += '       FROM (' + Char(10)
			SET @V_SQL += '           SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
			SET @V_SQL += '                , A.LOCATION, A.OPERATION_ID' + Char(10)
			SET @V_SQL += '                , A.LINE_ID' + Char(10)
			SET @V_SQL += '                , A.EQUIPMENT_ID' + Char(10)
			SET @V_SQL += '                , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME ' + Char(10)
			SET @V_SQL += '                , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '                , MIN(A.PLAN_DATE) AS PLAN_DATE ' + Char(10)
			SET @V_SQL += '                , MIN(A.SEQ) AS SEQ ' + Char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '               , SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @V_DATE + ''' ' + Char(10)
					SET @V_SQL += '                    THEN (CASE WHEN B.CATEGORY_ID=''P_OUT_JR'' THEN CONVERT(NUMERIC(10,1), CEILING(A.ADJUST_OUT_QTY_JR)) '  + Char(10)
					SET @V_SQL += '                               WHEN B.CATEGORY_ID=''P_OUT_CELL'' THEN CEILING(A.ADJUST_OUT_QTY_CELL) ' + Char(10)
					SET @V_SQL += '                               WHEN B.CATEGORY_ID=''P_OUT_BATCH'' THEN ROUND(A.ADJUST_OUT_QTY_BATCH, 1) ' + Char(10)
					SET @V_SQL += '                           END) END) AS D' + @V_DATE + ' ' + Char(10)
					SET @V_SQL += '               , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @V_DATE + ''' THEN MEMO_TEXT END) AS M' + @V_DATE + ' ' + Char(10)

					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
	
			SET @V_SQL += '                , MAX(MEMO_TEXT) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '                , B.CATEGORY_NAME' + Char(10)
			SET @V_SQL += '                , B.CATEGORY_ID' + Char(10)
			SET @V_SQL += '                , B.CATEGORY_ORDER' + Char(10)
			SET @V_SQL += '                , B.MEASURE_NAME' + Char(10)
			SET @V_SQL += '                , ''DATA'' AS DATA_TYPE' + Char(10)
			SET @V_SQL += '           FROM (' + Char(10)
			SET @V_SQL += '                   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
			SET @V_SQL += '                        , A.LOCATION, A.OPERATION_ID' + Char(10)
			SET @V_SQL += '                        , A.LINE_ID, A.ELECTRODE_TYPE' + Char(10)
			SET @V_SQL += '                        , A.EQUIPMENT_ID' + Char(10)
			SET @V_SQL += '                        , A.PLAN_DATE' + Char(10)
			SET @V_SQL += '                        , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME' + Char(10)
			SET @V_SQL += '                        , A.PRODUCTION_TYPE' + Char(10)
			SET @V_SQL += '                        , A.MARKET' + Char(10)
			SET @V_SQL += '                        , A.SEQ' + Char(10)
			SET @V_SQL += '                        , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + Char(10)
			SET @V_SQL += '                    FROM (' + Char(10)
			SET @V_SQL += '                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
			SET @V_SQL += '                    , A.LOCATION, A.OPERATION_ID' + Char(10)
			SET @V_SQL += '                    , A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE' + Char(10)
			SET @V_SQL += '                    , A.EQUIPMENT_ID' + Char(10)
			SET @V_SQL += '                    , A.PLAN_DATE' + Char(10)
			SET @V_SQL += '                    , A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME' + Char(10)
			SET @V_SQL += '                    , A.PRODUCTION_TYPE' + Char(10)
			SET @V_SQL += '                    , A.MARKET' + Char(10)
			SET @V_SQL += '                    , A.SEQ' + Char(10)
			SET @V_SQL += '                    , A.ADJUST_OUT_QTY_BATCH, A.ADJUST_OUT_QTY_CELL, A.ADJUST_OUT_QTY_JR' + Char(10)
			SET @V_SQL += '               FROM   FP_AMEND_DAILY_PLAN_H A WITH(NOLOCK)' + Char(10)
			SET @V_SQL += '               LEFT OUTER JOIN ( ' + Char(10)
			SET @V_SQL += '               		SELECT COMPANY_ID ' + Char(10)
			SET @V_SQL += '               			, DIVISION_ID ' + Char(10)
			SET @V_SQL += '               			, SITE_ID ' + Char(10)
			SET @V_SQL += '               			, PLANT_ID ' + Char(10)
			SET @V_SQL += '               			, FACTORY_ID ' + Char(10)
			SET @V_SQL += '               			, MODEL_ID ' + Char(10)
			SET @V_SQL += '               			, VERSION ' + Char(10)
			SET @V_SQL += '               			, OPERATION AS OPERATION_ID ' + Char(10)
			SET @V_SQL += '               			, ITEM_ID ' + Char(10)
			SET @V_SQL += '               			, MAX(PROD_SEQ) AS PROD_SEQ  ' + Char(10)
			SET @V_SQL += '               		FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)  ' + Char(10)
			SET @V_SQL += '               		WHERE  A.OPERATION = ''E2000''  ' + Char(10)
			SET @V_SQL += '               		AND    A.VALUE > 0  ' + Char(10)
			SET @V_SQL += '               		AND    A.CATEGORY IN ( ''Jumbo Roll (cell/m)'', ''Lane Number'', ''Pancake (m/batch)'', ''cell/batch'', ''Jumbo Roll (m/batch)'', ''Pancake (cell/m)'' )  ' + Char(10)
			SET @V_SQL += '               		GROUP BY COMPANY_ID ' + Char(10)
			SET @V_SQL += '               			, DIVISION_ID ' + Char(10)
			SET @V_SQL += '               			, SITE_ID ' + Char(10)
			SET @V_SQL += '               			, PLANT_ID ' + Char(10)
			SET @V_SQL += '               			, FACTORY_ID ' + Char(10)
			SET @V_SQL += '               			, MODEL_ID ' + Char(10)
			SET @V_SQL += '               			, VERSION ' + Char(10)
			SET @V_SQL += '               			, OPERATION ' + Char(10)
			SET @V_SQL += '               			, ITEM_ID  ' + Char(10)
			SET @V_SQL += '               ) B ' + Char(10)
			SET @V_SQL += '               ON  A.COMPANY_ID		= B.COMPANY_ID ' + Char(10)
			SET @V_SQL += '               AND A.DIVISION_ID	= B.DIVISION_ID ' + Char(10)
			SET @V_SQL += '               AND A.SITE_ID		= B.SITE_ID ' + Char(10)
			SET @V_SQL += '               AND A.PLANT_ID		= B.PLANT_ID ' + Char(10)
			SET @V_SQL += '               AND A.FACTORY_ID		= B.FACTORY_ID ' + Char(10)
			SET @V_SQL += '               AND A.WORK_REQUEST_MODEL_ID = B.MODEL_ID ' + Char(10)
			SET @V_SQL += '               AND A.VERSION		= B.VERSION ' + Char(10)
			SET @V_SQL += '               AND A.OPERATION_ID	= B.OPERATION_ID ' + Char(10)
			SET @V_SQL += '               AND A.ITEM_ID		= B.ITEM_ID ' + Char(10)
			SET @V_SQL += '               WHERE  INSTANCE_ID      = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '               AND    FP_PLAN_ID       = ''' + @V_FP_PLAN_ID + ''' ' + Char(10)
			SET @V_SQL += '               AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''' + @V_FROM_DATE + '''  AND  ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '               AND    ISNULL(A.ADJUST_IN_QTY_BATCH,0) <> 0 ' + Char(10)
			SET @V_SQL += '       ) A' + Char(10)
			SET @V_SQL += '       INNER JOIN SCM_ITEM_M B WITH(NOLOCK)' + Char(10)
			SET @V_SQL += '       ON     A.COMPANY_ID     = B.COMPANY_ID' + Char(10)
			SET @V_SQL += '       AND    A.DIVISION_ID    = B.DIVISION_ID' + Char(10)
			SET @V_SQL += '       AND    A.SITE_ID        = B.SITE_ID' + Char(10)
			SET @V_SQL += '       AND    A.TOP_ITEM_ID    = B.ITEM_ID' + Char(10)
			SET @V_SQL += '       WHERE 1=1' + Char(10)
			SET @V_SQL += '           ) A' + Char(10)
			SET @V_SQL += '           INNER HASH JOIN TH_UIS_CAL C WITH(NOLOCK)' + Char(10)
			SET @V_SQL += '           ON  1=1' + Char(10)
			SET @V_SQL += '           AND CONVERT(VARCHAR, C.DT, 112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '           AND A.PLAN_DATE = C.DT' + Char(10)
			SET @V_SQL += '           INNER JOIN (' + Char(10)
			SET @V_SQL += '              SELECT *' + Char(10)
			SET @V_SQL += '               FROM (' + Char(10)
			/*SET @V_SQL += isnull(@p_dsql, '') */
			SET @V_SQL += '               SELECT ''X'' AS CATEGORY_ID, ''X'' AS MEASURE_NAME, '''' AS CATEGORY_NAME, 0 AS CATEGORY_ORDER ' + Char(10)
			SET @V_SQL += '               UNION ALL ' + Char(10)
			SET @V_SQL += '               SELECT ''P_OUT_JR'' AS CATEGORY_ID, ''J/R'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER ' + Char(10)
			SET @V_SQL += '               UNION ALL ' + Char(10)
			SET @V_SQL += '               SELECT ''P_OUT_CELL'' AS CATEGORY_ID, ''Cell'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER ' + Char(10)
			SET @V_SQL += '               UNION ALL ' + Char(10)
			SET @V_SQL += '               SELECT ''P_OUT_BATCH'' AS CATEGORY_ID, ''Batch'' AS MEASURE_NAME, ''Plan(Out)'' AS CATEGORY_NAME, 50 AS CATEGORY_ORDER ' + Char(10)
			SET @V_SQL += '               UNION ALL ' + Char(10)
			SET @V_SQL += '               SELECT ''P_MEMO'' AS CATEGORY_ID, '''' AS MEASURE_NAME, ''Memo'' AS CATEGORY_NAME, 600 AS CATEGORY_ORDER ' + Char(10)
			SET @V_SQL += '               ) A' + Char(10)
			SET @V_SQL += '               WHERE CATEGORY_ID <> ''X''' + Char(10)
			SET @V_SQL += '           ) B' + Char(10)
			SET @V_SQL += '           ON 1=1' + Char(10)
			-- MEMO
			SET @V_SQL += '			LEFT OUTER JOIN ' + Char(10)
			SET @V_SQL += '			( ' + Char(10)
			SET @V_SQL += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		           	, A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		           	, A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		           	, A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		           	, A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		           	, A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		           	, MAX(B.ATTRIBUTE2 + '':'' + A.MEMO) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '				FROM    FP_AMEND_MEMO_M A WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '				LEFT OUTER JOIN  ' + Char(10)
			SET @V_SQL += '	           		(SELECT *  ' + Char(10)
			SET @V_SQL += '	           		FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '	           		WHERE   LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + Char(10)
			SET @V_SQL += '	           		AND     ACTIVE_FLAG=''Y'' ' + Char(10)
			SET @V_SQL += '	           		AND     ATTRIBUTE3 = ''SCM_WORK_CALENDAR_M'') B ' + Char(10)
			SET @V_SQL += '				ON		A.ATTR2	= B.SEGMENT1 ' + Char(10)
			SET @V_SQL += '				WHERE   A.INSTANCE_ID = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '				AND		CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '				GROUP BY A.COMPANY_ID ' + Char(10)
			SET @V_SQL += '					, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		            , A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		            , A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		            , A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		            , A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		            , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		    ) D ' + Char(10)
			SET @V_SQL += '		    ON	A.COMPANY_ID		= D.COMPANY_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.DIVISION_ID		= D.DIVISION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.SITE_ID			= D.SITE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PLANT_ID			= D.PLANT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.OPERATION_ID		= D.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.LINE_ID			= D.LINE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ELECTRODE_TYPE	= D.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		    AND	A.EQUIPMENT_ID		= D.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ITEM_ID			= D.ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.TOP_ITEM_ID		= D.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PRODUCTION_TYPE	= D.PRODUCTION_TYPE ' + Char(10)
			SET @V_SQL += '		    AND	A.MARKET			= D.MARKET ' + Char(10)
			SET @V_SQL += '		    AND	A.PLAN_DATE			= D.PLAN_DATE ' + Char(10)

			SET @V_SQL += '          GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID' + Char(10)
			SET @V_SQL += '              , A.LOCATION, A.OPERATION_ID' + Char(10)
			SET @V_SQL += '              , A.LINE_ID ' + Char(10)
			SET @V_SQL += '              , A.EQUIPMENT_ID' + Char(10)
			SET @V_SQL += '              , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME' + Char(10)
			SET @V_SQL += '              , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '              , B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER, B.MEASURE_NAME' + Char(10)
			SET @V_SQL += '      ) A' + Char(10)
			SET @V_SQL += ' ) A ' + Char(10)

			-- BCP COMMAND
			SET @V_BCP_QUERYOUT_COMMAND += 'bcp "SELECT LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME, MEASURE_NAME'

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @V_BCP_QUERYOUT_COMMAND += ', D' + @V_DATE
				FETCH NEXT FROM CUR_DATE_LIST
					INTO  @V_DATE
						, @V_DAY_COL_NAME
			END;
			CLOSE CUR_DATE_LIST

			SET @V_BCP_QUERYOUT_COMMAND += ' FROM ##RELEASE_CSV'
			SET @V_BCP_QUERYOUT_COMMAND += ' ORDER BY ODR, LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_ORDER, MEASURE_NAME'
			SET @V_BCP_QUERYOUT_COMMAND += '" queryout '
	END
		ELSE IF @V_TYPE = 'ASSY'
		BEGIN

			SET @V_SQL += ' SELECT *	' + Char(10)
			SET @V_SQL += ' INTO ##RELEASE_CSV' + Char(10)
			SET @V_SQL += ' FROM ( ' + Char(10) 
			SET @V_SQL += '		SELECT  ''Line Name'' AS LINE_NAME '+char(10)
			SET @V_SQL += '				, ''Material'' AS ITEM_ID '+char(10)
			SET @V_SQL += '				, ''Nick Name'' AS NICK_NAME '+char(10)
			SET @V_SQL += '				, ''Prod. Type'' AS PRODUCTION_TYPE '+char(10)
			SET @V_SQL += '				, ''Market'' AS MARKET '+char(10)
			SET @V_SQL += '				, ''Category'' AS CATEGORY_NAME '+char(10)
			SET @V_SQL += '				, ''Measure'' AS MEASURE_NAME '+char(10)
	
			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ']'' AS D' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST

			SET @V_SQL += '				, ''0'' AS LINE_ID '+char(10)
			SET @V_SQL += '				, 0 AS CATEGORY_ORDER '+char(10)
			SET @V_SQL += '				, ''0'' AS MEASURE_ID '+char(10)

			SET @V_SQL += '		 UNION ALL '+char(10)
			SET @V_SQL += '		SELECT A.LINE_NAME '+char(10)
			SET @V_SQL += '		     , A.ITEM_ID, A.NICK_NAME '+char(10)
			SET @V_SQL += '		     , A.PRODUCTION_TYPE, A.MARKET '+char(10)
			SET @V_SQL += '		     , B.CATEGORY_NAME '+char(10)
			SET @V_SQL += '		     , B.MEASURE_NAME '+char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '		     , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ''' + @V_DATE + ''' THEN ' + Char(10)
					SET @V_SQL += '				(CASE WHEN B.CATEGORY_ID = ''P_OUT'' AND B.MEASURE_ID = ''UOM'' THEN FORMAT(CAST(A.OUT_QTY AS  NUMERIC(10)), ''#,#'')' + Char(10)
					SET @V_SQL += '					  WHEN B.CATEGORY_ID = ''P_OUT'' AND B.MEASURE_ID = ''CELL'' THEN FORMAT(CAST(A.CELL_OUT_QTY AS  NUMERIC(10)), ''#,#'')' + Char(10)
					SET @V_SQL += '					  WHEN B.CATEGORY_ID = ''P_MEMO'' THEN ISNULL(D.MEMO_TEXT, '''') ' + Char(10)
					SET @V_SQL += '				END) END) AS D' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST

			SET @V_SQL += '				, A.LINE_ID '+char(10)
			SET @V_SQL += '				, B.CATEGORY_ORDER '+char(10)
			SET @V_SQL += '				, B.MEASURE_ID '+char(10)
			SET @V_SQL += '		FROM ('+char(10)
			SET @V_SQL += '		      SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
			SET @V_SQL += '		           		, A.LOCATION, A.OPERATION_ID'+char(10)
			SET @V_SQL += '		             , A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
			SET @V_SQL += '		             , A.EQUIPMENT_ID'+char(10)
			SET @V_SQL += '		             , A.PLAN_DATE'+char(10)
			SET @V_SQL += '		             , A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME'+char(10)
			SET @V_SQL += '		             , A.PRODUCTION_TYPE'+char(10)
			SET @V_SQL += '		             , A.MARKET'+char(10)
			SET @V_SQL += '		             , B.ITEM_TYPE'+char(10)
			SET @V_SQL += '		             , A.PLAN_TYPE'+char(10)
			SET @V_SQL += '		             , A.SEQ'+char(10)
			SET @V_SQL += '		             , A.OUT_QTY'+char(10)
			SET @V_SQL += '		             , A.CELL_OUT_QTY'+char(10)
			SET @V_SQL += '		       FROM ('+char(10)
			SET @V_SQL += '						SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
			SET @V_SQL += '								, A.LOCATION, A.OPERATION_ID'+char(10)
			SET @V_SQL += '								, A.LINE_ID, '''' AS LINE_NAME, A.ELECTRODE_TYPE'+char(10)
			SET @V_SQL += '								, '''' AS EQUIPMENT_ID'+char(10)
			SET @V_SQL += '								, A.PLAN_DATE'+char(10)
			SET @V_SQL += '								, A.TOP_ITEM_ID, A.ITEM_ID, '''' AS NICK_NAME'+char(10)
			SET @V_SQL += '								, A.PRODUCTION_TYPE'+char(10)
			SET @V_SQL += '								, A.MARKET'+char(10)
			SET @V_SQL += '								, ''DPP'' AS PLAN_TYPE'+char(10)
			SET @V_SQL += '								, DATE_SEQ AS SEQ'+char(10)
			SET @V_SQL += '								, A.OUT_QTY'+char(10)
			SET @V_SQL += '								, A.CELL_OUT_QTY'+char(10)
			SET @V_SQL += '						FROM   FP_AMEND_PLAN_CELL_H A WITH(NOLOCK)'+char(10)
			SET @V_SQL += '						WHERE  A.INSTANCE_ID      = ''' + @P_INSTANCE_ID + ''' '+char(10)
			SET @V_SQL += '						AND    A.FP_PLAN_ID       = ''' + @V_FP_PLAN_ID + ''' '+char(10)
			SET @V_SQL += '						AND    (A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.RESULT_OUT_QTY <> 0)'+char(10)
			SET @V_SQL += '						AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''' + @V_FROM_DATE+''' AND ''' + @V_TO_DATE + '''' + char(10)
			SET @V_SQL += '				) A'+char(10)
			SET @V_SQL += '				INNER JOIN ('+char(10)
			SET @V_SQL += '				                 SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,'+char(10)
			SET @V_SQL += '				                        A.ITEM_ID,'+char(10)
			SET @V_SQL += '				                        (CASE WHEN LEFT(A.FLOW_ID,5) = ''A9000'' AND ISNULL(C.LEVEL_4_NAME, ''-'') = ''-'' THEN C.LEVEL_3_NAME'+char(10)
			SET @V_SQL += '				                        	     WHEN LEFT(A.FLOW_ID,5) = ''A9000'' THEN ISNULL(C.LEVEL_4_NAME, ''-'')'+char(10)
			SET @V_SQL += '				                        	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,'+char(10)
			SET @V_SQL += '				                        ISNULL(A.NICK_NAME,''-'') AS NICK_NAME'+char(10)
			SET @V_SQL += '				                 FROM	 SCM_ITEM_M A WITH(NOLOCK),'+char(10)
			SET @V_SQL += '				                   		 SCM_ITEM_CLASS_M C WITH(NOLOCK)'+char(10)
			SET @V_SQL += '				                 WHERE	 A.ITEM_CLASS  = C.CLASS_ID'+char(10)
			SET @V_SQL += '				     ) B'+char(10)
			SET @V_SQL += '				     ON     A.COMPANY_ID     = B.COMPANY_ID'+char(10)
			SET @V_SQL += '				     AND    A.DIVISION_ID    = B.DIVISION_ID'+char(10)
			SET @V_SQL += '				     AND    A.SITE_ID        = B.SITE_ID'+char(10)
			SET @V_SQL += '				     AND    A.TOP_ITEM_ID    = B.ITEM_ID'+char(10)  -- 2021-11-15 AS-IS 점검
			SET @V_SQL += '				     INNER JOIN SCM_LINE_M C WITH(NOLOCK)'+char(10)
			SET @V_SQL += '				     ON     A.COMPANY_ID     = C.COMPANY_ID'+char(10)
			SET @V_SQL += '				     AND    A.DIVISION_ID    = C.DIVISION_ID'+char(10)
			SET @V_SQL += '				     AND    A.SITE_ID        = C.SITE_ID'+char(10)
			SET @V_SQL += '				     AND    A.PLANT_ID       = C.PLANT_ID'+char(10)
			SET @V_SQL += '				     AND    A.FACTORY_ID     = C.FACTORY_ID'+char(10)
			SET @V_SQL += '				     AND    A.OPERATION_ID   = C.OPERATION_ID'+char(10)
			SET @V_SQL += '				     AND    A.LINE_ID        = C.LINE_ID'+char(10)
			SET @V_SQL += '				     AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE'+char(10)
			SET @V_SQL += '				     WHERE  1=1'+char(10)
			SET @V_SQL += '			) A'+char(10)
			SET @V_SQL += '			INNER JOIN ('+char(10)
			SET @V_SQL += '			SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''CELL'' AS MEASURE_ID, ''CELL'' AS MEASURE_NAME, 120 AS CATEGORY_ORDER  '+char(10)
			SET @V_SQL += '			UNION ALL                                                                                                                         '+char(10)
			SET @V_SQL += '			SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, ''UOM'' AS MEASURE_ID, ''UOM'' AS MEASURE_NAME, 130 AS CATEGORY_ORDER    '+char(10)
			SET @V_SQL += '			UNION ALL '+char(10)
			SET @V_SQL += '			SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, '''' AS MEASURE_ID, '''' AS MEASURE_NAME, 700 AS CATEGORY_ORDER '+char(10)
			SET @V_SQL += '			) B'+char(10)
			SET @V_SQL += '			ON 1=1'+char(10)
			-- MEMO
			SET @V_SQL += '			LEFT OUTER JOIN ' + Char(10)
			SET @V_SQL += '			( ' + Char(10)
			SET @V_SQL += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		           	, A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		           	, A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		           	, A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		           	, A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		           	, A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		           	, MAX(B.ATTRIBUTE2 + '':'' + A.MEMO) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '				FROM    FP_AMEND_MEMO_M A WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '				LEFT OUTER JOIN  ' + Char(10)
			SET @V_SQL += '	           		(SELECT *  ' + Char(10)
			SET @V_SQL += '	           		FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '	           		WHERE   LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + Char(10)
			SET @V_SQL += '	           		AND     ACTIVE_FLAG=''Y'' ' + Char(10)
			SET @V_SQL += '	           		AND     ATTRIBUTE3 = ''SCM_WORK_CALENDAR_M'') B ' + Char(10)
			SET @V_SQL += '				ON		A.ATTR2	= B.SEGMENT1 ' + Char(10)
			SET @V_SQL += '				WHERE   A.INSTANCE_ID = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '				AND		CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '				GROUP BY A.COMPANY_ID ' + Char(10)
			SET @V_SQL += '					, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		            , A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		            , A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		            , A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		            , A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		            , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		    ) D ' + Char(10)
			SET @V_SQL += '		    ON	A.COMPANY_ID		= D.COMPANY_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.DIVISION_ID		= D.DIVISION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.SITE_ID			= D.SITE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PLANT_ID			= D.PLANT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.OPERATION_ID		= D.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.LINE_ID			= D.LINE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ELECTRODE_TYPE	= D.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		    AND	A.EQUIPMENT_ID		= D.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ITEM_ID			= D.ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.TOP_ITEM_ID		= D.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PRODUCTION_TYPE	= D.PRODUCTION_TYPE ' + Char(10)
			SET @V_SQL += '		    AND	A.MARKET			= D.MARKET ' + Char(10)
			SET @V_SQL += '		    AND	A.PLAN_DATE			= D.PLAN_DATE ' + Char(10)
			/* -- 한글 테스트 데이터
			SET @V_SQL += '			LEFT OUTER JOIN (' + Char(10)
			SET @V_SQL += '				SELECT  A.MEMO AS MEMO_TEXT FROM FP_AMEND_MEMO_M A WITH(NOLOCK) WHERE	INSTANCE_ID = ''CN_CELL'' AND FACTORY_ID = ''A3'' AND MARKET= ''E'' AND ITEM_ID = ''AFCFC1212A'' ' + Char(10)
			SET @V_SQL += '		    ) D ' + Char(10)
			SET @V_SQL += '		    ON 1=1 ' + Char(10)
			*/
			SET @V_SQL += '		GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID'+char(10)
			SET @V_SQL += '		   , A.LOCATION, A.OPERATION_ID'+char(10)
			SET @V_SQL += '		   , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE'+char(10)
			SET @V_SQL += '		   , A.EQUIPMENT_ID'+char(10)
			SET @V_SQL += '		   , A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME '+char(10)
			SET @V_SQL += '		   , A.PRODUCTION_TYPE, A.MARKET, A.ITEM_TYPE'+char(10)
			SET @V_SQL += '		   , B.CATEGORY_ID, B.CATEGORY_NAME, B.MEASURE_ID, B.MEASURE_NAME, B.CATEGORY_ORDER'+char(10)
			SET @V_SQL += ' ) A ' + Char(10)

			-- BCP COMMAND
			SET @V_BCP_QUERYOUT_COMMAND += 'bcp "SELECT LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME, MEASURE_NAME'

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @V_BCP_QUERYOUT_COMMAND += ', D' + @V_DATE
				FETCH NEXT FROM CUR_DATE_LIST
					INTO  @V_DATE
						, @V_DAY_COL_NAME
			END;
			CLOSE CUR_DATE_LIST

			SET @V_BCP_QUERYOUT_COMMAND += ' FROM ##RELEASE_CSV'
			SET @V_BCP_QUERYOUT_COMMAND += ' ORDER BY LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_ORDER, MEASURE_ID'
			SET @V_BCP_QUERYOUT_COMMAND += '" queryout '
		END
		ELSE IF @V_TYPE = 'FORM'
		BEGIN
			SET @V_SQL += ' SELECT *	' + Char(10)
			SET @V_SQL += ' INTO ##RELEASE_CSV' + Char(10)
			SET @V_SQL += ' FROM ( ' + Char(10) 
			SET @V_SQL += '		SELECT  ''Line Name'' AS LINE_NAME '+char(10)
			SET @V_SQL += '				, ''Material'' AS ITEM_ID '+char(10)
			SET @V_SQL += '				, ''Nick Name'' AS NICK_NAME '+char(10)
			SET @V_SQL += '				, ''Prod. Type'' AS PRODUCTION_TYPE '+char(10)
			SET @V_SQL += '				, ''Market'' AS MARKET '+char(10)
			SET @V_SQL += '				, ''Category'' AS CATEGORY_NAME '+char(10)
			
			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ']'' AS D' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST

			SET @V_SQL += '				, ''0'' AS LINE_ID '+char(10)
			SET @V_SQL += '				, 0 AS CATEGORY_ORDER '+char(10)

			SET @V_SQL += '		UNION ALL '+char(10)
			SET @V_SQL += ' 		SELECT LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME ' + char(10)
            
			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '           , CASE ' + char(10)     
					SET @V_SQL += '					WHEN CATEGORY_ID = ''P_OUT'' THEN FORMAT(CAST(D' + @V_DATE + ' AS  NUMERIC(10)), ''#,#'') ' + char(10)          
					SET @V_SQL += '					WHEN CATEGORY_ID = ''P_MEMO'' THEN ISNULL(M' + @V_DATE + ', '''') ' + char(10)
					SET @V_SQL += '				END  AS D' + @V_DATE + Char(10)

					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			
			SET @V_SQL += '				, LINE_ID '+char(10)
			SET @V_SQL += '				, CATEGORY_ORDER '+char(10)
			SET @V_SQL += ' 		FROM (              ' + char(10)
			SET @V_SQL += ' 		      SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)	
			SET @V_SQL += ' 		         , A.LOCATION, A.OPERATION_ID                                         ' + char(10)
			SET @V_SQL += ' 		         , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE, ''-'' AS EQUIPMENT_ID    ' + char(10)
			SET @V_SQL += ' 		         , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
			SET @V_SQL += ' 		         , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SET @V_SQL += ' 		         , D.CATE_NAME AS CATEGORY_NAME                  ' + char(10)
			
			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += ' 		         , SUM(CASE ' + CHAR(10)
					SET @V_SQL += ' 							WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @V_DATE + ''' AND D.CATE_ID = ''P_OUT'' THEN A.OUT_QTY ' + Char(10)
					SET @V_SQL += ' 							ELSE 0 ' + Char(10)
					SET @V_SQL += '                         END) AS D' + @V_DATE + ' ' + Char(10)
					SET @V_SQL += '                  , MAX(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112)=''' + @V_DATE + ''' THEN MEMO_TEXT END) AS M' + @V_DATE + ' ' + Char(10)
					
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST    

			SET @V_SQL += ' 		         , D.CATE_ID AS CATEGORY_ID       ' + char(10)
			SET @V_SQL += ' 		         , D.CATE_ORDER AS CATEGORY_ORDER ' + char(10)
			SET @V_SQL += ' 		       FROM ( ' + char(10)
			SET @V_SQL += ' 		            SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SET @V_SQL += ' 		                ,A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.LINE_NAME ' + char(10)
			SET @V_SQL += ' 		                ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
			SET @V_SQL += ' 		                ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
			SET @V_SQL += ' 		                , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE ' + char(10)
			SET @V_SQL += ' 		                ,SUM(A.OUT_QTY) OUT_QTY  ' + char(10)
			SET @V_SQL += ' 		            FROM (                                   ' + char(10) 
			SET @V_SQL += ' 		                  SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID        ' + char(10)
			SET @V_SQL += ' 		                      , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SET @V_SQL += ' 		                      , ISNULL(C.NICK_NAME,''-'') AS NICK_NAME, ISNULL(E.LINE_NAME,''-'') AS LINE_NAME ' + char(10)
			SET @V_SQL += ' 		                      , A.OPERATION_ID              ' + char(10)
			SET @V_SQL += ' 		                      , A.FACTORY_ID, A.LOCATION    ' + char(10)
			SET @V_SQL += ' 		                      , NULL AS BOH_QTY             ' + char(10)
			SET @V_SQL += ' 		                      , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SET @V_SQL += ' 		                      , A.LINE_ID          ' + char(10)
			SET @V_SQL += ' 		                      , A.ELECTRODE_TYPE   ' + char(10)
			SET @V_SQL += ' 		                      , A.PLAN_DATE        ' + char(10)
			SET @V_SQL += ' 		                      , A.OUT_QTY          ' + char(10)
			SET @V_SQL += ' 		                  FROM  FP_AMEND_PLAN_FORM_H A WITH(NOLOCK) ' + char(10)
			SET @V_SQL += ' 		                  INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK) ' + char(10)
			SET @V_SQL += ' 		                  ON     1=1                                ' + char(10)
			SET @V_SQL += ' 		                  AND   A.COMPANY_ID   = C.COMPANY_ID  ' + char(10)
			SET @V_SQL += ' 		                  AND   A.DIVISION_ID  = C.DIVISION_ID ' + char(10)
			SET @V_SQL += ' 		                  AND   A.SITE_ID      = C.SITE_ID     ' + char(10)
			SET @V_SQL += ' 		                  AND   A.TOP_ITEM_ID  = C.ITEM_ID     ' + char(10)
			SET @V_SQL += ' 		                  INNER HASH JOIN SCM_LINE_M E WITH(NOLOCK) ' + char(10)
			SET @V_SQL += ' 		                  ON     1=1                                ' + char(10)
			SET @V_SQL += ' 		                  AND   A.COMPANY_ID     = E.COMPANY_ID     ' + char(10)
			SET @V_SQL += ' 		                  AND   A.DIVISION_ID    = E.DIVISION_ID    ' + char(10)
			SET @V_SQL += ' 		                  AND   A.SITE_ID        = E.SITE_ID        ' + char(10)
			SET @V_SQL += ' 		                  AND   A.PLANT_ID       = E.PLANT_ID       ' + char(10)
			SET @V_SQL += ' 		                  AND   A.FACTORY_ID     = E.FACTORY_ID     ' + char(10)
			SET @V_SQL += ' 		                  AND   A.OPERATION_ID   = E.OPERATION_ID   ' + char(10)
			SET @V_SQL += ' 		                  AND   A.LINE_ID        = E.LINE_ID        ' + char(10)
			SET @V_SQL += ' 		                  AND   A.ELECTRODE_TYPE = E.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += ' 		                  WHERE  A.INSTANCE_ID = '''+ @P_INSTANCE_ID +''' ' + char(10)
			SET @V_SQL += ' 		                  AND    A.FP_PLAN_ID  = '''+ @V_FP_PLAN_ID +'''     ' + char(10)
			SET @V_SQL += ' 		                  AND  CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '''+ @V_FROM_DATE +''' AND '''+ @V_TO_DATE +''' ' + char(10)
			SET @V_SQL += ' 		                  AND  ( A.OUT_QTY <> 0 OR A.MPP_OUT_QTY <> 0 OR A.WPP_OUT_QTY <> 0 OR A.AVAILABILITY IS NOT NULL OR ISNULL(A.AGING_WIP,0) <> 0 ) ' + char(10)
			SET @V_SQL += ' 		            ) A          ' + char(10)
			SET @V_SQL += ' 		            GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID ' + char(10)
			SET @V_SQL += ' 		                    ,A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME, A.LINE_NAME ' + char(10)
			SET @V_SQL += ' 		                    ,A.OPERATION_ID, A.FACTORY_ID, A.LOCATION ' + char(10)
			SET @V_SQL += ' 		                    ,A.BOH_QTY, A.PRODUCTION_TYPE, A.MARKET   ' + char(10)
			SET @V_SQL += ' 		                    , A.LINE_ID, A.ELECTRODE_TYPE, A.PLAN_DATE' + char(10)
			SET @V_SQL += '					) A   ' +  + char(10)            
 			SET @V_SQL += ' 		       INNER JOIN ( ' + char(10)
			SET @V_SQL += ' 		           SELECT 116 AS CATE_ORDER, ''Out'' AS CATE_NAME, ''P_OUT'' AS CATE_ID ' + char(10)
			SET @V_SQL += '		               UNION ALL ' + char(10) 
			SET @V_SQL += ' 		           SELECT 300 AS CATE_ORDER, ''Memo'' AS CATE_NAME, ''P_MEMO'' AS CATE_ID ' + char(10)
			SET @V_SQL += ' 		       ) D                    ' + char(10)
			SET @V_SQL += ' 		       ON   1=1               ' + char(10)
			-- MEMO
			SET @V_SQL += '			LEFT OUTER JOIN ' + Char(10)
			SET @V_SQL += '			( ' + Char(10)
			SET @V_SQL += '				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		           	, A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		           	, A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		           	, A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		           	, A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		           	, A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		           	, MAX(B.ATTRIBUTE2 + '':'' + A.MEMO) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '				FROM    FP_AMEND_MEMO_M A WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '				LEFT OUTER JOIN  ' + Char(10)
			SET @V_SQL += '	           		(SELECT *  ' + Char(10)
			SET @V_SQL += '	           		FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '	           		WHERE   LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + Char(10)
			SET @V_SQL += '	           		AND     ACTIVE_FLAG=''Y'' ' + Char(10)
			SET @V_SQL += '	           		AND     ATTRIBUTE3 = ''SCM_WORK_CALENDAR_M'') B ' + Char(10)
			SET @V_SQL += '				ON		A.ATTR2	= B.SEGMENT1 ' + Char(10)
			SET @V_SQL += '				WHERE   A.INSTANCE_ID = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '				AND		CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '				GROUP BY A.COMPANY_ID ' + Char(10)
			SET @V_SQL += '					, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '		            , A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		            , A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '		            , A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		            , A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		            , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '		           	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '		    ) E ' + Char(10)
			SET @V_SQL += '		    ON	A.COMPANY_ID		= E.COMPANY_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.DIVISION_ID		= E.DIVISION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.SITE_ID			= E.SITE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PLANT_ID			= E.PLANT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.OPERATION_ID		= E.OPERATION_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.LINE_ID			= E.LINE_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ELECTRODE_TYPE	= E.ELECTRODE_TYPE ' + Char(10)
			--SET @V_SQL += '		    AND	A.EQUIPMENT_ID		= E.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.ITEM_ID			= E.ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.TOP_ITEM_ID		= E.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '		    AND	A.PRODUCTION_TYPE	= E.PRODUCTION_TYPE ' + Char(10)
			SET @V_SQL += '		    AND	A.MARKET			= E.MARKET ' + Char(10)
			SET @V_SQL += '		    AND	A.PLAN_DATE			= E.PLAN_DATE ' + Char(10)

			SET @V_SQL += '		 	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '		 	      , A.LOCATION, A.OPERATION_ID                 ' + char(10)
			SET @V_SQL += '		 	      , A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE   ' + char(10)
			SET @V_SQL += '		 	      , A.CELL_GROUP_CODE, A.TOP_ITEM_ID, A.ITEM_ID, A.NICK_NAME ' + char(10)
			SET @V_SQL += '		 	      , A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SET @V_SQL += '		 	      , D.CATE_NAME, D.CATE_ID, D.CATE_ORDER       ' + char(10)
			SET @V_SQL += '		 	) AA   ' + char(10)
			SET @V_SQL += ' ) A ' + Char(10)

			-- BCP COMMAND
			SET @V_BCP_QUERYOUT_COMMAND += 'bcp "SELECT LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME'

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @V_BCP_QUERYOUT_COMMAND += ', D' + @V_DATE
				FETCH NEXT FROM CUR_DATE_LIST
					INTO  @V_DATE
						, @V_DAY_COL_NAME
			END;
			CLOSE CUR_DATE_LIST

			SET @V_BCP_QUERYOUT_COMMAND += ' FROM ##RELEASE_CSV'
			SET @V_BCP_QUERYOUT_COMMAND += ' ORDER BY LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_ORDER'
			SET @V_BCP_QUERYOUT_COMMAND += '" queryout '
		END
		ELSE IF @V_TYPE = 'PACK'
		BEGIN
			SET @V_SQL += ' SELECT *	' + Char(10)
			SET @V_SQL += ' INTO ##RELEASE_CSV' + Char(10)
			SET @V_SQL += ' FROM ( ' + Char(10) 
			SET @V_SQL += '		SELECT  ''Line Name'' AS LINE_NAME '+char(10)
			SET @V_SQL += '				, ''Material'' AS ITEM_ID '+char(10)
			SET @V_SQL += '				, ''Nick Name'' AS NICK_NAME '+char(10)
			SET @V_SQL += '				, ''Prod. Type'' AS PRODUCTION_TYPE '+char(10)
			SET @V_SQL += '				, ''Market'' AS MARKET '+char(10)
			SET @V_SQL += '				, ''Category'' AS CATEGORY_NAME '+char(10)
			
			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '				, ''[' + @V_DAY_COL_NAME + ']'' AS D' + @V_DATE + Char(10)									
					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST

			SET @V_SQL += '				, ''0'' AS LINE_ID '+char(10)
			SET @V_SQL += '				, 0 AS CATEGORY_ORDER '+char(10)

			SET @V_SQL += '		 UNION ALL '+char(10)
			SET @V_SQL += '			SELECT    A.LINE_NAME, A.ITEM_ID, A.NICK_NAME, A.PRODUCTION_TYPE, A.MARKET, B.CATEGORY_NAME ' + char(10)

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
				BEGIN
					SET @V_SQL += '					, CASE ' + char(10)     
					SET @V_SQL += '							WHEN B.CATEGORY_ID=''P_OUT'' THEN FORMAT(CAST(SUM(CASE WHEN CONVERT(VARCHAR,A.PLAN_DATE,112) = ' + @V_DATE + ' THEN A.OUT_QTY ELSE 0 END) AS NUMERIC(10)), ''#,#'') ' + char(10)          
					SET @V_SQL += '							WHEN B.CATEGORY_ID=''P_MEMO'' THEN ISNULL(MAX(C.MEMO_TEXT), '''') ' + char(10)
					SET @V_SQL += '					  END  AS D' + @V_DATE + Char(10)

					FETCH NEXT FROM CUR_DATE_LIST
						INTO  @V_DATE
							, @V_DAY_COL_NAME
				END;
			CLOSE CUR_DATE_LIST
			
			SET @V_SQL += '					, A.LINE_ID, B.CATEGORY_ORDER ' + char(10)
			SET @V_SQL += '			FROM  ( ' + char(10)
			SET @V_SQL += '					SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '							, A.LOCATION, A.OPERATION_ID ' + char(10)
			SET @V_SQL += '							, A.LINE_ID, ISNULL(C.LINE_NAME,''-'') AS LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '							, A.PLAN_DATE ' + char(10)
			SET @V_SQL += '							, A.TOP_ITEM_ID, A.ITEM_ID, ISNULL(B.NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SET @V_SQL += '							, A.PRODUCTION_TYPE ' + char(10)
			SET @V_SQL += '							, A.MARKET ' + char(10)
			SET @V_SQL += '							, A.OUT_QTY ' + char(10)
			SET @V_SQL += '					FROM 	(   ' + char(10)
			SET @V_SQL += '							SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '							           , A.LOCATION, A.OPERATION_ID ' + char(10)
			SET @V_SQL += '							           , A.LINE_ID, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '							           , A.PLAN_DATE ' + char(10)
			SET @V_SQL += '							           , A.TOP_ITEM_ID, A.ITEM_ID ' + char(10)
			SET @V_SQL += '							           , A.PRODUCTION_TYPE ' + char(10)
			SET @V_SQL += '							           , A.MARKET ' + char(10)
			SET @V_SQL += '							           , A.OUT_QTY ' + char(10)
			SET @V_SQL += '							FROM   FP_AMEND_PLAN_PACK_H A WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '							WHERE  INSTANCE_ID      = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '							AND    FP_PLAN_ID       = ''' + @V_FP_PLAN_ID + ''' ' + Char(10)
			SET @V_SQL += '							AND    CONVERT(VARCHAR, A.PLAN_DATE, 112) BETWEEN ''' + @V_FROM_DATE + '''  AND  ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '							AND    (A.OUT_QTY > 0 OR A.MPP_OUT_QTY > 0 OR A.WPP_OUT_QTY > 0 OR A.RESULT_OUT_QTY > 0) ' + char(10)
			SET @V_SQL += '							) A ' + char(10)
			SET @V_SQL += '					INNER JOIN ( ' + char(10)
			SET @V_SQL += '					              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, ITEM_ID, ISNULL(NICK_NAME,''-'') AS NICK_NAME ' + char(10)
			SET @V_SQL += '					              FROM	 SCM_ITEM_M WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '					              WHERE	 ACTIVE_FLAG = ''Y'' ' + char(10)
			SET @V_SQL += '							) B ' + char(10)
			SET @V_SQL += '					ON     A.COMPANY_ID     = B.COMPANY_ID ' + char(10)
			SET @V_SQL += '					AND    A.DIVISION_ID    = B.DIVISION_ID ' + char(10)
			SET @V_SQL += '					AND    A.SITE_ID        = B.SITE_ID ' + char(10)
			SET @V_SQL += '					AND    A.TOP_ITEM_ID    = B.ITEM_ID ' + char(10)
			SET @V_SQL += '					INNER JOIN SCM_LINE_M C WITH(NOLOCK) ' + char(10)
			SET @V_SQL += '					ON     A.COMPANY_ID     = C.COMPANY_ID ' + char(10)
			SET @V_SQL += '					AND    A.DIVISION_ID    = C.DIVISION_ID ' + char(10)
			SET @V_SQL += '					AND    A.SITE_ID        = C.SITE_ID ' + char(10)
			SET @V_SQL += '					AND    A.PLANT_ID       = C.PLANT_ID ' + char(10)
			SET @V_SQL += '					AND    A.FACTORY_ID     = C.FACTORY_ID ' + char(10)
			SET @V_SQL += '					AND    A.OPERATION_ID   = C.OPERATION_ID ' + char(10)
			SET @V_SQL += '					AND    A.LINE_ID        = C.LINE_ID ' + char(10)
			SET @V_SQL += '					AND    A.ELECTRODE_TYPE = C.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '					) A ' + char(10)
			SET @V_SQL += '			INNER JOIN (  ' + char(10)
			SET @V_SQL += '					SELECT ''P_OUT'' AS CATEGORY_ID, ''Plan(Out)'' AS CATEGORY_NAME, 60 AS CATEGORY_ORDER ' + char(10)
			SET @V_SQL += '					UNION ALL '+char(10)
			SET @V_SQL += '					SELECT ''P_MEMO'' AS CATEGORY_ID, ''Memo'' AS CATEGORY_NAME, 80 AS CATEGORY_ORDER  ' + char(10)
			SET @V_SQL += '					) B ' + char(10)
			SET @V_SQL += '			ON 1=1 ' + char(10)
			-- MEMO
			SET @V_SQL += '			LEFT OUTER JOIN ' + Char(10)
			SET @V_SQL += '					( ' + Char(10)
			SET @V_SQL += '					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '				       	, A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '				       	, A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '				       	, A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '				       	, A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '				       	, A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '				       	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '				       	, MAX(B.ATTRIBUTE2 + '':'' + A.MEMO) AS MEMO_TEXT ' + Char(10)
			SET @V_SQL += '					FROM    FP_AMEND_MEMO_M A WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '					LEFT OUTER JOIN  ' + Char(10)
			SET @V_SQL += '			       		(SELECT *  ' + Char(10)
			SET @V_SQL += '			       		FROM	SCM_SYS_LOOKUP_VALUE WITH(NOLOCK) ' + Char(10)
			SET @V_SQL += '			       		WHERE   LOOKUP_TYPE_CODE = ''CAPA_UI_LOSS_TYPE_DEFINIT'' ' + Char(10)
			SET @V_SQL += '			       		AND     ACTIVE_FLAG=''Y'' ' + Char(10)
			SET @V_SQL += '			       		AND     ATTRIBUTE3 = ''SCM_WORK_CALENDAR_M'') B ' + Char(10)
			SET @V_SQL += '					ON		A.ATTR2	= B.SEGMENT1 ' + Char(10)
			SET @V_SQL += '					WHERE   A.INSTANCE_ID = ''' + @P_INSTANCE_ID + ''' ' + Char(10)
			SET @V_SQL += '					AND		CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN ''' + @V_FROM_DATE + ''' AND ''' + @V_TO_DATE + ''' ' + Char(10)
			SET @V_SQL += '					GROUP BY A.COMPANY_ID ' + Char(10)
			SET @V_SQL += '						, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + Char(10)
			SET @V_SQL += '				        , A.OPERATION_ID ' + Char(10)
			SET @V_SQL += '				        , A.LINE_ID, A.ELECTRODE_TYPE ' + Char(10)
			SET @V_SQL += '				        , A.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '				        , A.ITEM_ID, A.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '				        , A.PRODUCTION_TYPE, A.MARKET ' + Char(10)
			SET @V_SQL += '				       	, A.PLAN_DATE ' + Char(10)
			SET @V_SQL += '				) C ' + Char(10)
			SET @V_SQL += '			ON	A.COMPANY_ID		= C.COMPANY_ID ' + Char(10)
			SET @V_SQL += '			AND	A.DIVISION_ID		= C.DIVISION_ID ' + Char(10)
			SET @V_SQL += '			AND	A.SITE_ID			= C.SITE_ID ' + Char(10)
			SET @V_SQL += '			AND	A.PLANT_ID			= C.PLANT_ID ' + Char(10)
			SET @V_SQL += '			AND	A.OPERATION_ID		= C.OPERATION_ID ' + Char(10)
			SET @V_SQL += '			AND	A.LINE_ID			= C.LINE_ID ' + Char(10)
			SET @V_SQL += '			AND	A.ELECTRODE_TYPE	= C.ELECTRODE_TYPE ' + Char(10)
			--SET @V_SQL +=		     AND	A.EQUIPMENT_ID		= C.EQUIPMENT_ID ' + Char(10)
			SET @V_SQL += '			AND	A.ITEM_ID			= C.ITEM_ID ' + Char(10)
			SET @V_SQL += '			AND	A.TOP_ITEM_ID		= C.TOP_ITEM_ID ' + Char(10)
			SET @V_SQL += '			AND	A.PRODUCTION_TYPE	= C.PRODUCTION_TYPE ' + Char(10)
			SET @V_SQL += '			AND	A.MARKET			= C.MARKET ' + Char(10)
			SET @V_SQL += '			AND	A.PLAN_DATE			= C.PLAN_DATE ' + Char(10)
			SET @V_SQL += '	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID ' + char(10)
			SET @V_SQL += '			, A.LOCATION, A.OPERATION_ID ' + char(10)
			SET @V_SQL += '			, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE ' + char(10)
			SET @V_SQL += '			, A.ITEM_ID, A.TOP_ITEM_ID, A.NICK_NAME ' + char(10)
			SET @V_SQL += '			, A.PRODUCTION_TYPE, A.MARKET ' + char(10)
			SET @V_SQL += '			, B.CATEGORY_ID, B.CATEGORY_NAME, B.CATEGORY_ORDER ' + char(10)
			SET @V_SQL += ' ) A ' + Char(10)

			-- BCP COMMAND
			SET @V_BCP_QUERYOUT_COMMAND += 'bcp "SELECT LINE_NAME, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_NAME'

			OPEN CUR_DATE_LIST
			FETCH NEXT FROM CUR_DATE_LIST
				INTO  @V_DATE
					, @V_DAY_COL_NAME

			WHILE (@@FETCH_STATUS = 0)
			BEGIN
				SET @V_BCP_QUERYOUT_COMMAND += ', D' + @V_DATE
				FETCH NEXT FROM CUR_DATE_LIST
					INTO  @V_DATE
						, @V_DAY_COL_NAME
			END;
			CLOSE CUR_DATE_LIST

			SET @V_BCP_QUERYOUT_COMMAND += ' FROM ##RELEASE_CSV'
			SET @V_BCP_QUERYOUT_COMMAND += ' ORDER BY LINE_ID, ITEM_ID, NICK_NAME, PRODUCTION_TYPE, MARKET, CATEGORY_ORDER'
			SET @V_BCP_QUERYOUT_COMMAND += '" queryout '
		END

		DEALLOCATE CUR_DATE_LIST;

		IF LEN(ISNULL(@V_SQL, '')) < 1
		BEGIN
			EXEC PR_SCM_RELEASE_PLAN_SEND
				  @instance_id		= @P_INSTANCE_ID
				, @instance_date	= @P_INSTANCE_DATE
				, @factory_id		= @P_FACTORY_ID
				, @plan_group_id	= @P_PLAN_GROUP_ID
				, @plan_description = @P_PLAN_DESCRIPTION
				, @attach_yn		= 'N'
				, @attach_path		= ''
				, @attach_file		= ''

			IF OBJECT_ID('TEMPDB..##RELEASE_CSV') IS NOT NULL
				DROP TABLE ##RELEASE_CSV

			SET @V_DESCR = 'ATTACHMENT FAIL'
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @V_MESSAGE2, NULL, @V_DESCR, @V_EVENT_DTTM
		END
		ELSE
		BEGIN
			EXEC SP_EXECUTESQL @V_SQL
	
			SET @V_ROWCOUNT = @@ROWCOUNT
		
			SET @V_BCP_QUERYOUT_COMMAND = CONCAT(@V_BCP_QUERYOUT_COMMAND, '"', @V_ATTACH_PATH, @V_ATTACH_FILE, '"', @V_BCP_QUERYOUT_OPTION)
			EXEC XP_CMDSHELL @V_BCP_QUERYOUT_COMMAND;
			
			EXEC PR_SCM_RELEASE_PLAN_SEND
				  @instance_id		= @P_INSTANCE_ID
				, @instance_date	= @P_INSTANCE_DATE
				, @factory_id		= @P_FACTORY_ID
				, @plan_group_id	= @P_PLAN_GROUP_ID
				, @plan_description = @P_PLAN_DESCRIPTION
				, @attach_yn		= 'Y'
				, @attach_path		= @V_ATTACH_PATH
				, @attach_file		= @V_ATTACH_FILE


			--발신후 삭제
			SET @V_BCP_DELETE_COMMAND = CONCAT('del /f "', @V_ATTACH_PATH, @V_ATTACH_FILE, '"')
			EXEC XP_CMDSHELL @V_BCP_DELETE_COMMAND;

			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @V_ROWCOUNT, @V_MESSAGE1, '############### End of procedure ###############', NULL, @V_EVENT_DTTM
		END
	END TRY

	BEGIN CATCH
		-- 에러나도 로그는 인서트
		SET @V_DESCR	= ERROR_MESSAGE()
		SET @V_MESSAGE2 = ERROR_NUMBER()

		IF @V_MESSAGE2 = '511'   --최대 허용 행 크기(8060)보다 큰 행(9669)을 만들 수 없습니다.
		BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END', @V_ROWCOUNT, @V_MESSAGE2, '############### End of procedure ###############', @V_DESCR, @V_EVENT_DTTM
		END
		ELSE 
		BEGIN

			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'ERROR', NULL, @V_MESSAGE2, NULL, @V_DESCR, @V_EVENT_DTTM
		END

	END CATCH
END

