






CREATE VIEW [dbo].[FP_CELL_GROUP_V]
AS
-- ================================================================================================
-- Program ID          : FP_CELL_GROUP_V
--
-- Program Name        : FP_CELL_GROUP_V
-- Param               :
-- Batch Period        : 
-- Description         : Cell Group 정보 표시
--
-- Source System       : FP
-- Destination System  : 
-- Source Table        : 
-- Destination Table   : 
--
-- Create(Update) Date : 
-- Author              : 
-- Version             : 
--                       2023-08-08  CYS  Division(81_UC) 이 다른경우 다른사이트 정보를 정상적으로 가져오지 못하는 경우우 보완
--										  후공정 모델인 경우 조회 안되는 현상 보완
-- ================================================================================================
WITH 	CELL_GROUP
AS 		(
						SELECT 	DISTINCT A.DIVISION_ID
								, A.DOE
								, ISNULL(B.NICK_NAME
														 -- , ISNULL(
															-- (	SELECT  TOP 1 NICK_NAME
															--	FROM SCM_ITEM_M X
															--	WHERE 1=1
															--	AND A.DIVISION_ID = X.DIVISION_ID 
															--	AND A.SITE_ID != X.SITE_ID 
															--	AND A.DOE = X.ITEM_ID
															--) 
															, 
															ISNULL(
																	 (	SELECT  TOP 1 NICK_NAME
																		FROM SCM_ITEM_M X WITH(NOLOCK)
																		WHERE 1=1
																		AND X.ACTIVE_FLAG = 'Y'
																		AND SUBSTRING(A.DIVISION_ID,1,2) = SUBSTRING(X.DIVISION_ID,1,2)	-- Division 이 다른경우 조회
																		AND A.SITE_ID != X.SITE_ID 
																		AND A.DOE = X.ITEM_ID
																	)  
																	, (	SELECT  TOP 1 NICK_NAME
																		FROM SCM_ITEM_M X WITH(NOLOCK)
																		WHERE 1=1
																		AND X.ACTIVE_FLAG = 'Y'
																		AND A.SITE_ID != X.SITE_ID 
																		AND A.DOE = X.ITEM_ID
																	)
										--)
										)) AS CELL_GROUP
						FROM 	SCM_ITEM_M A WITH(NOLOCK)
								LEFT OUTER JOIN SCM_ITEM_M B WITH(NOLOCK)
								ON 	1=1
								AND B.ACTIVE_FLAG = 'Y'
								AND A.DIVISION_ID = B.DIVISION_ID 
								AND A.SITE_ID = B.SITE_ID 
								AND A.DOE = B.ITEM_ID
						WHERE 	1=1
						AND 	A.ACTIVE_FLAG = 'Y'
						AND		EXISTS (
											SELECT 1
											FROM (
												SELECT DISTINCT OPERATION_ID
												FROM SCM_OPERATION_M WITH(NOLOCK)
												WHERE 1=1
												AND INSTANCE_TYPE = 'F0'	-- 후공정 공정코드
												AND ACTIVE_FLAG = 'Y'
												UNION ALL
												SELECT 'A3000' UNION ALL SELECT 'A9000'
											) X
											WHERE 1=1
											AND A.FLOW_ID = X.OPERATION_ID
										)
						AND 	A.DOE IS NOT NULL
		)	
SELECT 	DISTINCT A.COMPANY_ID, 
		A.DIVISION_ID, A.SITE_ID
		, ISNULL(ISNULL(ISNULL(C.CELL_GROUP, A.DOE), A.NICK_NAME), A.ITEM_ID) AS CELL_GROUP    
		, A.ITEM_ID, A.NICK_NAME
FROM 	SCM_ITEM_M A WITH(NOLOCK)   
		LEFT OUTER JOIN CELL_GROUP C
		ON 	1=1
		AND A.DOE = C.DOE 
		AND A.DIVISION_ID = C.DIVISION_ID,
		SCM_ITEM_CLASS_M B WITH(NOLOCK) 
WHERE 	1=1                                                                                                                                                                                                          
AND 	A.ACTIVE_FLAG = 'Y'                  
AND EXISTS (
				SELECT 1
				FROM (
					SELECT DISTINCT OPERATION_ID
					FROM SCM_OPERATION_M WITH(NOLOCK)
					WHERE 1=1
					AND INSTANCE_TYPE = 'F0'	-- 후공정 공정코드
					AND ACTIVE_FLAG = 'Y'
					UNION ALL
					SELECT 'A3000' UNION ALL SELECT 'A9000'
				) X
				WHERE 1=1
				AND A.FLOW_ID = X.OPERATION_ID
			)
--AND 	A.ITEM_TYPE IN ('P','H')                                                                                                                                                                                       
AND 	A.ITEM_CLASS = B.CLASS_ID                                                                                                                                                                                    
AND 	LEVEL_1_NAME IN ( 'Model', 'Assembly' )                                                                                                                                                                                       
AND 	B.LEVEL_3_NAME LIKE '%Cell%'

/*
WITH 	CELL_GROUP
AS 		(
		SELECT 	DISTINCT A.DIVISION_ID
				, A.DOE
				, ISNULL(B.NICK_NAME, ISNULL(C.NICK_NAME, ISNULL(D.NICK_NAME, ISNULL(E.NICK_NAME, ISNULL(F.NICK_NAME, G.NICK_NAME))))) AS CELL_GROUP 
		FROM 	SCM_ITEM_M A
				LEFT OUTER JOIN SCM_ITEM_M B
				ON 	1=1
				AND A.DIVISION_ID = B.DIVISION_ID 
				AND A.SITE_ID = B.SITE_ID 
				AND A.DOE = B.ITEM_ID
				LEFT OUTER JOIN SCM_ITEM_M C
				ON 	1=1
				AND A.DIVISION_ID = C.DIVISION_ID 
				AND A.SITE_ID != C.SITE_ID 
				AND C.SITE_ID = 'A001'
				AND A.DOE = C.ITEM_ID
				LEFT OUTER JOIN SCM_ITEM_M D
				ON 	1=1
				AND A.DIVISION_ID = D.DIVISION_ID 
				AND A.SITE_ID != D.SITE_ID 
				AND D.SITE_ID = 'A002'		
				AND A.DOE = D.ITEM_ID	
				LEFT OUTER JOIN SCM_ITEM_M E
				ON 	1=1
				AND A.DIVISION_ID = E.DIVISION_ID 
				AND A.SITE_ID != E.SITE_ID 
				AND E.SITE_ID = 'A003'		
				AND A.DOE = E.ITEM_ID	
				LEFT OUTER JOIN SCM_ITEM_M F
				ON 	1=1
				AND A.DIVISION_ID = F.DIVISION_ID 
				AND A.SITE_ID != F.SITE_ID 
				AND F.SITE_ID = 'A004'		
				AND A.DOE = F.ITEM_ID
				LEFT OUTER JOIN SCM_ITEM_M G
				ON 	1=1
				AND A.DIVISION_ID = G.DIVISION_ID 
				AND A.SITE_ID != G.SITE_ID 
				AND G.SITE_ID = 'A007'		
				AND A.DOE = G.ITEM_ID
		WHERE 	1=1
		AND 	A.ACTIVE_FLAG = 'Y'
		AND 	A.DIVISION_ID IN ('40','81','82','81_UC','81_HM')
		AND 	A.FLOW_ID IN ('A3000','A9000')
		AND 	A.DOE IS NOT NULL
		)	
SELECT 	DISTINCT A.COMPANY_ID, 
		A.DIVISION_ID, A.SITE_ID
		, ISNULL(ISNULL(ISNULL(C.CELL_GROUP, A.DOE), A.NICK_NAME), A.ITEM_ID) AS CELL_GROUP                                                                                                                      
--		, A.DOE, C.DOE, C.CELL_GROUP
		, A.ITEM_ID, A.NICK_NAME--, A.ITEM_CLASS, A.FLOW_ID                                                                                                                                               
FROM 	SCM_ITEM_M A   
		LEFT OUTER HASH JOIN CELL_GROUP C
		ON 	1=1
		AND A.DOE = C.DOE 
		AND A.DIVISION_ID = C.DIVISION_ID,
		SCM_ITEM_CLASS_M B  
WHERE 	1=1                                                                                                                                                                                                          
AND 	A.ACTIVE_FLAG = 'Y'                  
AND 	A.FLOW_ID IN ('A3000','A9000')
--AND 	A.ITEM_TYPE IN ('P','H')                                                                                                                                                                                       
AND 	A.ITEM_CLASS = B.CLASS_ID                                                                                                                                                                                    
AND 	LEVEL_1_NAME IN ( 'Model', 'Assembly' )                                                                                                                                                                                      
AND 	B.LEVEL_3_NAME LIKE '%Cell%'
*/


