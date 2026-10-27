






CREATE VIEW [dbo].[IF_SCM_FORMATION_YIELD_V] AS
-- ================================================================================================
-- Program ID          : IF_SCM_FORMATION_YIELD_V
--
-- Program Name        : IF_SCM_FORMATION_YIELD_V(Yield Table 기준으로 활성화 수율 정보 제공용 View 형성) 
-- Param               :
-- Batch Period        : 
-- Description         : 기존 SCM_FORMATION_YIELD_M 사용 중단하고 SCM_YIELD_M 기준으로 SCP에 활성화 수율 제공
--                       
--
-- Source System       : FP SDB
-- Destination System  : SCP SDB
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 2021.10.19
-- Author              : kim choon dong
-- Version             : 2020-11-21 kimcd 최초 형성. FP Formation Yield UI 기반으로 구성
--                       2021-03-03 kimcd 특성 공정을 F6000 Hard Coding에서 각 품목의 Formation 공정으로 수정
--                       2021-10-19 kimcd FORMATION_TOTAL_YIELD 컬럼 추가
-- ================================================================================================
	SELECT A.COMPANY_ID
		, A.DIVISION_ID
		, A.SITE_ID
		, A.PLANT_ID
		, A.FACTORY_ID
		, A.ITEM_ID
		, A.NICK_NAME
		, A.LINE_ID
		, A.LINE_NAME
		, A.FORMATION_FLOW_ID
		, A.FORMATION1_YIELD
		, A.USER_FORMATION1_YIELD
		, A.DEGAS_YIELD
		, A.USER_DEGAS_YIELD
		, A.FORMATION2_YIELD
		, A.USER_FORMATION2_YIELD
		, A.GRADE_YIELD
		, A.USER_GRADE_YIELD
		, A.CHARACTERIZATION_YIELD
		, A.USER_CHARACTERIZATION_YIELD
		, A.FORMATION_TOTAL_YIELD -- 2021-10-19 kimcd 컴럼 추가   
		, A.TOTAL_YIELD
		, A.USER_FORMATION_TOTAL_YIELD
		, A.USER_TOTAL_YIELD
	FROM	( 
				    SELECT A.COMPANY_ID
				        , A.DIVISION_ID
				        , A.SITE_ID
				        , A.PLANT_ID
				        , A.FACTORY_ID
				        , A.ITEM_ID
				        , B.NICK_NAME
				        , A.LINE_ID
				        , C.LINE_NAME
				      	, B.FORMATION_FLOW_ID
				      	-- F1000
				        , MAX(A.FORMATION1_YIELD) AS FORMATION1_YIELD
				        , MAX(A.USER_FORMATION1_YIELD) AS USER_FORMATION1_YIELD
				      	-- F4000
				        , MAX(A.DEGAS_YIELD) AS DEGAS_YIELD
				        , MAX(A.USER_DEGAS_YIELD) AS USER_DEGAS_YIELD
				      	-- F4500
				        , MAX(A.FORMATION2_YIELD) AS FORMATION2_YIELD
				        , MAX(A.USER_FORMATION2_YIELD) AS USER_FORMATION2_YIELD
				      	-- F4700
				        , MAX(A.GRADE_YIELD) AS GRADE_YIELD
				        , MAX(A.USER_GRADE_YIELD) AS USER_GRADE_YIELD
				      	-- F6000
				        , MAX(A.CHARACTERIZATION_YIELD) AS CHARACTERIZATION_YIELD
				        , MAX(A.USER_CHARACTERIZATION_YIELD) AS USER_CHARACTERIZATION_YIELD
				      	-- Total Yield
						, ROUND(ISNULL(MAX(A.FORMATION1_YIELD),1)*ISNULL(MAX(A.DEGAS_YIELD),1)*ISNULL(MAX(A.FORMATION2_YIELD),1)*ISNULL(MAX(A.GRADE_YIELD),1), 6) AS FORMATION_TOTAL_YIELD -- 2021-10-19 kimcd 컴럼 추가
				        , ROUND(ISNULL(MAX(A.FORMATION1_YIELD),1)*ISNULL(MAX(A.DEGAS_YIELD),1)*ISNULL(MAX(A.FORMATION2_YIELD),1)*ISNULL(MAX(A.GRADE_YIELD),1)*ISNULL(MAX(A.CHARACTERIZATION_YIELD),1), 6) AS TOTAL_YIELD -- 2021-10-19 kimcd ISNULL 추가
						, (CASE WHEN (MAX(A.USER_FORMATION1_YIELD) IS NULL AND MAX(A.USER_DEGAS_YIELD) IS NULL AND MAX(A.USER_FORMATION2_YIELD) IS NULL AND MAX(A.USER_GRADE_YIELD) IS NULL) THEN NULL 
				                ELSE ROUND(ISNULL(MAX(A.USER_FORMATION1_YIELD),1)*ISNULL(MAX(A.USER_DEGAS_YIELD),1)*ISNULL(MAX(A.USER_FORMATION2_YIELD),1)*ISNULL(MAX(A.USER_GRADE_YIELD),1), 6) END) AS USER_FORMATION_TOTAL_YIELD
				        , (CASE WHEN (MAX(A.USER_FORMATION1_YIELD) IS NULL AND MAX(A.USER_DEGAS_YIELD) IS NULL AND MAX(A.USER_FORMATION2_YIELD) IS NULL AND MAX(A.USER_GRADE_YIELD) IS NULL AND MAX(A.USER_CHARACTERIZATION_YIELD) IS NULL) THEN NULL 
				                ELSE ROUND(ISNULL(MAX(A.USER_FORMATION1_YIELD),1)*ISNULL(MAX(A.USER_DEGAS_YIELD),1)*ISNULL(MAX(A.USER_FORMATION2_YIELD),1)*ISNULL(MAX(A.USER_GRADE_YIELD),1)*ISNULL(MAX(A.USER_CHARACTERIZATION_YIELD),1), 6) END) AS USER_TOTAL_YIELD
				    FROM (
				      	-- F1000
				      	SELECT COMPANY_ID
				      		, DIVISION_ID
				      			, SITE_ID
				      			, PLANT_ID
				      			, FACTORY_ID
				      			, ITEM_ID
				      			, LINE_ID
				      			, RESULT_YIELD AS FORMATION1_YIELD
				      			, YIELD AS USER_FORMATION1_YIELD
				      			, NULL AS DEGAS_YIELD
				      			, NULL AS USER_DEGAS_YIELD
				      			, NULL AS FORMATION2_YIELD
				      			, NULL AS USER_FORMATION2_YIELD
				      			, NULL AS GRADE_YIELD
				      			, NULL AS USER_GRADE_YIELD
				      			, NULL AS CHARACTERIZATION_YIELD
				      			, NULL AS USER_CHARACTERIZATION_YIELD
				      	FROM 	SCM_YIELD_M A WITH(NOLOCK)
				      	WHERE 	1=1
				      	AND 	MONTH = ( SELECT 	YEAR + MONTH
				      						FROM 	SCM_SYS_CALENDAR_M KK WITH(NOLOCK)
				      						WHERE 	DATE_ID = CONVERT(NVARCHAR(8),GETDATE(),112))
				      	AND 	OPERATION_ID = 'F1000'
				      	-- F4000
				      	UNION ALL
				      	SELECT COMPANY_ID
				      		, DIVISION_ID
				      			, SITE_ID
				      			, PLANT_ID
				      			, FACTORY_ID
				      			, ITEM_ID
				      			, LINE_ID
				      			, NULL AS FORMATION1_YIELD
				      			, NULL AS USER_FORMATION1_YIELD
				      			, RESULT_YIELD AS DEGAS_YIELD
				      			, YIELD AS USER_DEGAS_YIELD
				      			, NULL AS FORMATION2_YIELD
				      			, NULL AS USER_FORMATION2_YIELD
				      			, NULL AS GRADE_YIELD
				      			, NULL AS USER_GRADE_YIELD
				      			, NULL AS CHARACTERIZATION_YIELD
				      			, NULL AS USER_CHARACTERIZATION_YIELD
				      	FROM 	SCM_YIELD_M A WITH(NOLOCK)
				      	WHERE 	1=1
				      	AND 	MONTH = ( SELECT 	YEAR + MONTH
				      						FROM 	SCM_SYS_CALENDAR_M KK WITH(NOLOCK)
				      						WHERE 	DATE_ID = CONVERT(NVARCHAR(8),GETDATE(),112))
				      	AND 	OPERATION_ID = 'F4000'
				      	-- F4500
				      	UNION ALL
				      	SELECT COMPANY_ID
				      			, DIVISION_ID
				      			, SITE_ID
				      			, PLANT_ID
				      			, FACTORY_ID
				      			, ITEM_ID
				      			, LINE_ID
				      			, NULL AS FORMATION1_YIELD
				      			, NULL AS USER_FORMATION1_YIELD
				      			, NULL AS DEGAS_YIELD
				      			, NULL AS USER_DEGAS_YIELD
				      			, RESULT_YIELD AS FORMATION2_YIELD
				      			, YIELD AS USER_FORMATION2_YIELD
				      			, NULL AS GRADE_YIELD
				      			, NULL AS USER_GRADE_YIELD
				      			, NULL AS CHARACTERIZATION_YIELD
				      			, NULL AS USER_CHARACTERIZATION_YIELD
				      	FROM 	SCM_YIELD_M A WITH(NOLOCK)
				      	WHERE 	1=1
				      	AND 	MONTH = ( SELECT 	YEAR + MONTH
				      						FROM 	SCM_SYS_CALENDAR_M KK WITH(NOLOCK)
				      						WHERE 	DATE_ID = CONVERT(NVARCHAR(8),GETDATE(),112))
				      	AND 	OPERATION_ID = 'F4500'
				      	-- F4700
				      	UNION ALL
				      	SELECT COMPANY_ID
				      			, DIVISION_ID
				      			, SITE_ID
				      			, PLANT_ID
				      			, FACTORY_ID
				      			, ITEM_ID
				      			, LINE_ID
				      			, NULL AS FORMATION1_YIELD
				      			, NULL AS USER_FORMATION1_YIELD
				      			, NULL AS DEGAS_YIELD
				      			, NULL AS USER_DEGAS_YIELD
				      			, NULL AS FORMATION2_YIELD
				      			, NULL AS USER_FORMATION2_YIELD
				      			, RESULT_YIELD AS GRADE_YIELD
				      			, YIELD AS USER_GRADE_YIELD
				      			, NULL AS CHARACTERIZATION_YIELD
				      			, NULL AS USER_CHARACTERIZATION_YIELD
				      	FROM 	SCM_YIELD_M A WITH(NOLOCK)
				      	WHERE 	1=1
				      	AND 	MONTH = ( SELECT 	YEAR + MONTH
				      						FROM 	SCM_SYS_CALENDAR_M KK WITH(NOLOCK)
				      						WHERE 	DATE_ID = CONVERT(NVARCHAR(8),GETDATE(),112))
				      	AND 	OPERATION_ID = 'F4700'
				      	-- F6000
				      	UNION ALL
				      	SELECT A.COMPANY_ID
				      			, A.DIVISION_ID
				      			, A.SITE_ID
				      			, A.PLANT_ID
				      			, A.FACTORY_ID
				      			, A.ITEM_ID
				      			, LINE_ID
				      			, NULL AS FORMATION1_YIELD
				      			, NULL AS USER_FORMATION1_YIELD
				      			, NULL AS DEGAS_YIELD
				      			, NULL AS USER_DEGAS_YIELD
				      			, NULL AS FORMATION2_YIELD
				      			, NULL AS USER_FORMATION2_YIELD
				      			, NULL AS GRADE_YIELD
				      			, NULL AS USER_GRADE_YIELD
				      			, RESULT_YIELD AS CHARACTERIZATION_YIELD
				      			, YIELD AS USER_CHARACTERIZATION_YIELD
				      	FROM 	SCM_YIELD_M A WITH(NOLOCK)
							   ,SCM_ITEM_M  I WITH(NOLOCK) -- 2021-03-03 kimcd 활성화 특성 공정의 수율을 추츨하도록 추가
				      	WHERE   A.COMPANY_ID  = I.COMPANY_ID
						AND     A.DIVISION_ID = I.DIVISION_ID
						AND     A.SITE_ID     = I.SITE_ID
						AND     A.ITEM_ID     = I.ITEM_ID
						AND     1=1
				      	AND 	MONTH = ( SELECT 	YEAR + MONTH
				      						FROM 	SCM_SYS_CALENDAR_M KK WITH(NOLOCK)
				      						WHERE 	DATE_ID = CONVERT(NVARCHAR(8),GETDATE(),112))
				      	AND 	OPERATION_ID = ISNULL(RIGHT(I.FORMATION_FLOW_ID, 5),'F6000')  -- 2021-03-03 kimcd 활성화 특성 공정의 수율을 추츨하도록 추가
				    ) A
				    LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)
				    ON 	1=1
				    AND A.COMPANY_ID  = B.COMPANY_ID
				    AND A.DIVISION_ID = B.DIVISION_ID
				    AND A.SITE_ID     = B.SITE_ID
				    AND A.ITEM_ID     = B.ITEM_ID
				    LEFT OUTER JOIN (
				        SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, MAX(A.LINE_NAME) AS LINE_NAME
				        FROM (
				        	SELECT A.*
				        			, ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID ORDER BY OPERATION_ID DESC, ELECTRODE_TYPE) AS ROW_NUM
				        	FROM   SCM_LINE_M A WITH(NOLOCK)
				        	WHERE  A.ACTIVE_FLAG = 'Y'
				        ) A
				        WHERE A.ROW_NUM = 1
				        GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID
				    ) C
				    ON 	1=1
				    AND A.COMPANY_ID   = C.COMPANY_ID
				    AND A.DIVISION_ID  = C.DIVISION_ID
				    AND A.SITE_ID      = C.SITE_ID
				    AND A.PLANT_ID     = C.PLANT_ID
				    AND A.FACTORY_ID   = C.FACTORY_ID
				    AND A.LINE_ID      = C.LINE_ID
				    GROUP BY A.COMPANY_ID
				       	, A.DIVISION_ID
				      	, A.SITE_ID
				      	, A.PLANT_ID
				      	, A.FACTORY_ID
				      	, A.ITEM_ID
				      	, B.NICK_NAME
				      	, A.LINE_ID
				      	, C.LINE_NAME
				        , B.FORMATION_FLOW_ID
      	) A

