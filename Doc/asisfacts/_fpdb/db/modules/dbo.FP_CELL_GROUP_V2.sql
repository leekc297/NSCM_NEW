




CREATE VIEW [dbo].[FP_CELL_GROUP_V2]
AS
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
																		FROM SCM_ITEM_M X
																		WHERE 1=1
																		AND SUBSTRING(A.DIVISION_ID,1,2) = SUBSTRING(X.DIVISION_ID,1,2)
																		AND A.SITE_ID != X.SITE_ID 
																		AND A.DOE = X.ITEM_ID
																	)  
																	, (	SELECT  TOP 1 NICK_NAME
																		FROM SCM_ITEM_M X
																		WHERE 1=1
																		AND A.SITE_ID != X.SITE_ID 
																		AND A.DOE = X.ITEM_ID
																	)
										--)
										)) AS CELL_GROUP
						FROM 	SCM_ITEM_M A
								LEFT OUTER JOIN SCM_ITEM_M B
								ON 	1=1
								AND A.DIVISION_ID = B.DIVISION_ID 
								AND A.SITE_ID = B.SITE_ID 
								AND A.DOE = B.ITEM_ID
						WHERE 	1=1
						AND 	A.ACTIVE_FLAG = 'Y'
						AND		EXISTS (
											SELECT 1
											FROM (
												SELECT DISTINCT OPERATION_ID
												FROM SCM_OPERATION_M
												WHERE 1=1
												AND INSTANCE_TYPE = 'F0'
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
FROM 	SCM_ITEM_M A   
		LEFT OUTER JOIN CELL_GROUP C
		ON 	1=1
		AND A.DOE = C.DOE 
		AND A.DIVISION_ID = C.DIVISION_ID,
		SCM_ITEM_CLASS_M B  
WHERE 	1=1                                                                                                                                                                                                          
AND 	A.ACTIVE_FLAG = 'Y'                  
AND EXISTS (
				SELECT 1
				FROM (
					SELECT DISTINCT OPERATION_ID
					FROM SCM_OPERATION_M
					WHERE 1=1
					AND INSTANCE_TYPE = 'F0'
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

