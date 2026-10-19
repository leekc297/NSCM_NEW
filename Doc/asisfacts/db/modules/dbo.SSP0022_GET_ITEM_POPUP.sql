/****************************************************************************************************/
/* Program ID  : SSP0022_GET_ITEM_POPUP													*/
/* Description :																	*/
/* Usage       :																	*/
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2020/04/20  KIMYONGHO    신규추가													*/
/* 2020/09/21  KIMYONGHO    SSP_INCOTERMS 변경 작업										*/
/****************************************************************************************************/


CREATE PROCEDURE [dbo].[SSP0022_GET_ITEM_POPUP]  
  @p_division_id		NVARCHAR(30),
  @p_from_site_id		NVARCHAR(50),
  @p_to_site_id			NVARCHAR(30),
  @p_item_id			NVARCHAR(50),
  @p_bod_id				NVARCHAR(50),
  @p_incoterms			NVARCHAR(50),
  @p_transport_mode		NVARCHAR(50),
  @P_PLAN_START_YYYYMMDD NVARCHAR(8) 
AS
BEGIN
	
  SET NOCOUNT ON;
    
	--SELECT X.DIVISION_ID
	--	, X.BOD_ID 
	--	, F.CELL_ITEM_ID AS MODEL_ID
	--	, X.ITEM_ID 
	--	, X.FROM_YYYYMMDD
	--	, X.TO_YYYYMMDD
	--	, V.INCOTERMS
	--	, V.PRIORITY
	--	, V.TRANSPORT_MODE
	--	, V.ROUTE_ID
	--	, V.LT_TYPE
	--	, V.DAYS_MON
	--	, V.DAYS_TUE
	--	, V.DAYS_WED
	--	, V.DAYS_THU
	--	, V.DAYS_FRI
	--	, V.DAYS_SAT
	--	, V.DAYS_SUN
	--	, V.BOD_VALID_YN
	--	, V.ROUTE_VALID_YN
	--	--, CONVERT(CHAR(10), DATEADD(DD, ISNULL(V.LT_TOTAL_ORIGIN,0) + ISNULL(TC.SEGMENT5,0), CONVERT(VARCHAR,  GETDATE(), 121)), 23) AS CONFIRM_DAY	

	--	 /* 확정구간 과 Oper LT 중 큰 일수 + bod LT   기간 이후 부터 입력 가능하게 적용 
	--		bod LT 는 [FN_GET_SSP_ETA_DATE] 함수 사용 */
	--	, CASE WHEN ISNULL(TC.SEGMENT5,0) >  ISNULL(TD.SHIP_FROZEN,0) 
	--		THEN  
	--			CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, @P_PLAN_START_YYYYMMDD, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TC.SEGMENT5,0) + 0, @P_PLAN_START_YYYYMMDD),112))),0) , @P_PLAN_START_YYYYMMDD), 23) 	
				
	--		ELSE
	--			CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, @P_PLAN_START_YYYYMMDD, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TD.SHIP_FROZEN,0) + 0, @P_PLAN_START_YYYYMMDD),112))),0)  , @P_PLAN_START_YYYYMMDD), 23) 	
	--		END AS CONFIRM_DAY
	--FROM [SCP_MST_BOD_ITEM] X
	--JOIN [SCP_MST_FINAL_ITEM] F WITH(NOLOCK) 
	--	ON F.DIVISION_ID = X.DIVISION_ID
	--	AND F.ITEM_ID     = X.ITEM_ID 
	--JOIN [SCP_MST_BOD_N_V] V
	--	ON V.DIVISION_ID = X.DIVISION_ID
	--	AND V.BOD_ID = X.BOD_ID
	--LEFT OUTER JOIN SSP_MST_SHIP_MASTER_EE TB WITH(NOLOCK)	
	--	ON X.DIVISION_ID = TB.DIVISION_ID
	--	AND TB.SCM_SITE_ID = @p_from_site_id
	--	AND X.ITEM_ID = TB.ITEM_ID
	--LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL TC WITH(NOLOCK)	
	--	ON TB.DIVISION_ID = TC.SEGMENT1
	--	AND TB.ELECTRODE_POST_OPER_CODE = TC.SEGMENT2
	--	AND TC.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE'
	--	AND TC.VALID_YN ='Y'
	--LEFT OUTER JOIN SCM_MST_SITE TD WITH(NOLOCK)	
	--			ON X.DIVISION_ID	= TD.DIVISION_ID	
	--			AND X.BOD_ID		= V.BOD_ID			
	--			AND V.FROM_SITE	= TD.SCM_SITE_ID
	--WHERE X.DIVISION_ID = @p_division_id
	--AND X.VALID_YN ='Y'
	--AND X.BOD_ID IN (SELECT BOD_ID 
	--			  FROM [SCP_MST_BOD_N_V] 
	--			  WHERE 1=1
	--			  AND VALID_YN = 'Y'
	--			  AND TO_SITE   IN(SELECT ATTRIBUTE1
	--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
	--							WHERE L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
	--							AND L.SEGMENT5 = @p_division_id
	--							AND L.SEGMENT3   =@p_from_site_id
	--							AND L.ATTRIBUTE1 =@p_to_site_id
	--							)
	--			  AND BOD_ID  LIKE '%' + @p_bod_id +'%'
	--			)
	--AND (X.ITEM_ID LIKE '%' + @p_item_id + '%' )
	--AND X.FROM_YYYYMMDD <= CONVERT(CHAR(8), GETDATE(), 112)
	--AND X.TO_YYYYMMDD   >= CONVERT(CHAR(8), GETDATE(), 112)
	--order by V.PRIORITY
	--;

		--IF @p_item_id = ''
		--	SET @p_item_id = NULL
		--IF @p_bod_id = ''
		--	SET @p_bod_id = NULL

/*
		SELECT DISTINCT X.DIVISION_ID
		, X.BOD_ID 
		, F.CELL_ITEM_ID AS MODEL_ID
		, X.ITEM_ID 
--		, X.FROM_YYYYMMDD
--		, X.TO_YYYYMMDD
		, V.INCOTERMS
		, V.PRIORITY
		, V.TRANSPORT_MODE
		--, V.ROUTE_ID
		--, V.LT_TYPE
		--, V.DAYS_MON
		--, V.DAYS_TUE
		--, V.DAYS_WED
		--, V.DAYS_THU
		--, V.DAYS_FRI
		--, V.DAYS_SAT
		--, V.DAYS_SUN
		--, V.BOD_VALID_YN
		--, V.ROUTE_VALID_YN
		--, CONVERT(CHAR(10), DATEADD(DD, ISNULL(V.LT_TOTAL_ORIGIN,0) + ISNULL(TC.SEGMENT5,0), CONVERT(VARCHAR,  GETDATE(), 121)), 23) AS CONFIRM_DAY	

		 /* 확정구간 과 Oper LT 중 큰 일수 + bod LT   기간 이후 부터 입력 가능하게 적용 
			bod LT 는 [FN_GET_SSP_ETA_DATE] 함수 사용 */
		, CASE WHEN ISNULL(TC.SEGMENT5,0) >  ISNULL(TD.SHIP_FROZEN,0) 
			THEN  
				CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, @P_PLAN_START_YYYYMMDD, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TC.SEGMENT5,0) + 0, @P_PLAN_START_YYYYMMDD),112))),0) , @P_PLAN_START_YYYYMMDD), 23) 	
				
			ELSE
				CONVERT(CHAR(10), DATEADD(DD, ISNULL(DATEDIFF(DD, @P_PLAN_START_YYYYMMDD, [dbo].[FN_GET_SSP_ETA_DATE](X.DIVISION_ID, X.BOD_ID, CONVERT(CHAR(8),DATEADD(DD,ISNULL(TD.SHIP_FROZEN,0) + 0, @P_PLAN_START_YYYYMMDD),112))),0)  , @P_PLAN_START_YYYYMMDD), 23) 	
			END AS CONFIRM_DAY
	FROM (
	      SELECT  DIVISION_ID
		          ,BOD_ID
				,ITEM_ID      
				,FROM_YYYYMMDD
				,TO_YYYYMMDD
		  FROM   [SCP_MST_BOD_ITEM] A WITH(NOLOCK)
		  WHERE  VALID_YN ='Y'
		  AND (( @p_item_id  IS NULL OR @p_item_id ='')       OR ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))	
		  AND   BOD_ID IN (SELECT BOD_ID					
						FROM [SCP_MST_BOD_N_V] T0
						LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
							ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
								AND L.SEGMENT2 = @p_division_id
								AND L.SEGMENT3 = T0.FROM_SITE
								AND L.ATTRIBUTE1 = T0.TO_SITE
						WHERE 1=1
						--T0.DIVISION_ID = @p_division_id
						AND T0.VALID_YN = 'Y'
						AND T0.FROM_SITE IN( @p_from_site_id)
						AND T0.TO_SITE   IN( @p_to_site_id)
						--AND T0.BOD_ID  LIKE '%' + @p_bod_id +'%'
						AND (( @p_bod_id  IS NULL OR @p_bod_id ='')       OR T0.BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , ',')))	 
					)

		 ) X
		 
	JOIN [SCP_MST_FINAL_ITEM] F WITH(NOLOCK) 
		ON F.DIVISION_ID = X.DIVISION_ID
		AND F.ITEM_ID     = X.ITEM_ID 
	JOIN [SCP_MST_BOD_N_V] V
		ON V.DIVISION_ID = X.DIVISION_ID
		AND V.BOD_ID = X.BOD_ID
		AND (( @p_bod_id  IS NULL OR @p_bod_id ='')       OR V.BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , ',')))	 
	LEFT OUTER JOIN [SSP_MST_SHIP_MASTER_EE] TB WITH(NOLOCK)	
		ON X.DIVISION_ID = TB.DIVISION_ID
		AND TB.SCM_SITE_ID = @p_from_site_id
		AND X.ITEM_ID = TB.ITEM_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL TC WITH(NOLOCK)	
		ON TB.DIVISION_ID = TC.SEGMENT1
		AND TB.ELECTRODE_POST_OPER_CODE = TC.SEGMENT2
		AND TC.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE'
		AND TC.VALID_YN ='Y'
	LEFT OUTER JOIN [SCM_MST_SITE] TD WITH(NOLOCK)	
		ON X.DIVISION_ID	= TD.DIVISION_ID	
		AND X.BOD_ID		= V.BOD_ID			
		AND V.FROM_SITE	= TD.SCM_SITE_ID
	WHERE 1=1
	--X.DIVISION_ID = @p_division_id
	 --AND X.FROM_YYYYMMDD <= CONVERT(CHAR(8), GETDATE(), 112)
	 --AND X.TO_YYYYMMDD   >= CONVERT(CHAR(8), GETDATE(), 112)

	order by V.PRIORITY
	;
*/


				

SELECT  @p_division_id =  DIVISION_ID  
FROM SCM_MST_SITE WITH(NOLOCK) 
WHERE SCM_SITE_ID  = @p_from_site_id 
AND   VALID_YN  = 'Y'
AND   SITE_TYPE  = 'PLANT'
;


SELECT V.DIVISION_ID 
,      V.BOD_ID 
,      M.MODEL_ID AS MODEL_ID
,      A.ITEM_ID 
,      V.INCOTERMS 
,      V.PRIORITY
,      V.TRANSPORT_MODE 

--,	     V.ROUTE_ID
--,      V.LT_TYPE
--,      V.DAYS_MON
--,      V.DAYS_TUE
--,      V.DAYS_WED
--,      V.DAYS_THU
--,      V.DAYS_FRI
--,      V.DAYS_SAT
--,      V.DAYS_SUN
--,      V.BOD_VALID_YN
--,      V.ROUTE_VALID_YN

,  CASE WHEN ISNULL(M.ELECTRODE_POST_OPER_LT,0) >  ISNULL(FS.SHIP_FROZEN,0)  THEN   
             CONVERT(VARCHAR, DATEADD(D, 0+ ISNULL(M.ELECTRODE_POST_OPER_LT,0) , CONVERT(DATETIME, V.ETA_DATE ,112))  ,112) 
        ELSE 
		     CONVERT(VARCHAR, DATEADD(D, 0+ ISNULL(FS.SHIP_FROZEN,0), CONVERT(DATETIME,V.ETA_DATE  ,112)) ,112)     
	    END  AS CONFIRM_DAY


FROM    (
			SELECT  B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.INCOTERMS, B.TRANSPORT_MODE, B.PRIORITY
			,      MIN(CONVERT(VARCHAR,DATEADD(D, B.LT_TOTAL - B.SHIP_LT_TOTAL  ,CONVERT(DATETIME,C.BASIS_YYYYMMDD  ,112)),112))  AS ETA_DATE 
			FROM (
					SELECT top 1 DIVISION_ID 
					,      BOD_ID
					,      FROM_SITE
					,      TO_SITE
					--* 2020/09/21  KIMYONGHO    SSP_INCOTERMS 변경 작업
					--,      INCOTERMS
					,      SSP_INCOTERMS	   AS INCOTERMS 
					,      TRANSPORT_MODE 
					,      LT_TOTAL_ORIGIN       AS LT_TOTAL    
					,      SHIP_LT_TOTAL_ORIGIN  AS SHIP_LT_TOTAL 
					,      PRIORITY 
					,      CASE WHEN DAYOFWEEK = 'days_mon' THEN 'MON'
								WHEN DAYOFWEEK = 'days_tue' THEN 'TUE'
								WHEN DAYOFWEEK = 'days_wed' THEN 'WED'
								WHEN DAYOFWEEK = 'days_thu' THEN 'THU'
								WHEN DAYOFWEEK = 'days_fri' THEN 'FRI'
								WHEN DAYOFWEEK = 'days_sat' THEN 'SAT'
								WHEN DAYOFWEEK = 'days_sun' THEN 'SUN'
						   ELSE ''END AS DAYOFWEEK
					,      EXIST_YN  
					--FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
					FROM SCP_MST_BOD_N_V WITH(NOLOCK)
						 UNPIVOT (EXIST_YN FOR DAYOFWEEK 
											IN (DAYS_MON,DAYS_TUE,DAYS_WED,DAYS_THU,DAYS_FRI,DAYS_SAT,DAYS_SUN)
								 ) AS UNPVT
					WHERE DIVISION_ID = @p_division_id
                    AND   FROM_SITE   = @p_from_site_id
					AND   TO_SITE     = @p_to_site_id
					AND   TRANSPORT_MODE = @p_transport_mode
					AND   INCOTERMS   = @p_incoterms
					AND   FROM_YYYYMMDD <= CONVERT(VARCHAR(8), GETDATE(), 112)
					AND   TO_YYYYMMDD >= CONVERT(VARCHAR(8), GETDATE(), 112)
					--AND (( @p_bod_id  IS NULL OR @p_bod_id ='')       OR BOD_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_bod_id , ',')))	 
					AND   BOD_VALID_YN ='Y'
					ORDER BY priority, to_yyyymmdd
				)  B 
			JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
			  ON B.DAYOFWEEK = C.DAYOFWEEK 
			 AND C.BASIS_YYYYMMDD >= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL  ,   CONVERT(DATETIME,@P_PLAN_START_YYYYMMDD ,112)),112)   -- YYYYMMDD + SHIP_LT_TOTAL 
			 AND C.BASIS_YYYYMMDD <= CONVERT(VARCHAR,DATEADD(D, B.SHIP_LT_TOTAL + 6 ,CONVERT(DATETIME,@P_PLAN_START_YYYYMMDD ,112)),112) -- YYYYMMDD + SHIP_LT_TOTAL + 7 
			 AND B.EXIST_YN ='Y'
			GROUP BY B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.INCOTERMS, B.TRANSPORT_MODE, B.PRIORITY

   
   )  V

    JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
	       FROM   SCP_MST_BOD_ITEM  WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
	       WHERE  DIVISION_ID =   @p_division_id
		   AND     (( @p_item_id  IS NULL OR @p_item_id ='')   OR ITEM_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_item_id , ',')))	
          )   A
	  ON A.DIVISION_ID  = V.DIVISION_ID 
	 AND A.BOD_ID       = V.BOD_ID

	JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
	  ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
	 AND L.SEGMENT2   = V.DIVISION_ID 
	 AND L.SEGMENT3   = V.FROM_SITE
	 AND L.ATTRIBUTE1 = V.TO_SITE

	JOIN SCM_MST_SITE FS WITH(NOLOCK)	
	  ON FS.DIVISION_ID	= V.DIVISION_ID	
	 AND FS.SCM_SITE_ID	= V.FROM_SITE

    LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V M WITH(NOLOCK) 
	  ON M.DIVISION_ID = @p_division_id
	 AND M.SCM_SITE_ID = @p_from_site_id
	 AND M.ITEM_ID     = A.ITEM_ID 


WHERE V.DIVISION_ID = @p_division_id
AND   V.FROM_SITE   = @p_from_site_id
AND   V.TO_SITE     = @p_to_site_id
 

order by V.PRIORITY


			
END
