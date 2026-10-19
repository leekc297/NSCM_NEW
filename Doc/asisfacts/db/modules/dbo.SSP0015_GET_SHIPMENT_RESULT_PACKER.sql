
/*
 * Program ID   : SSP0015_GET_SHIPMENT_RESULT_PACKER
 * Description  : Shipment Shipment Result
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021/10/05   KIMYONGHO		신규추가
 * 2021/11/26   SMS		        Ship to 추가
*/

CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_RESULT_PACKER]
	 @p_division_id				NVARCHAR(MAX)
	,@p_from_site				NVARCHAR(MAX)
	,@p_item_id					NVARCHAR(MAX)
	,@p_from_yyyymmdd			NVARCHAR(MAX)
	,@p_to_yyyymmdd				NVARCHAR(MAX)
	,@p_type					NVARCHAR(MAX)
	,@p_user_id					NVARCHAR(MAX)
	,@p_company_id				NVARCHAR(MAX)
	,@p_myModelChk				NVARCHAR(MAX)
	,@p_partLeaderChk			NVARCHAR(MAX)
	,@p_teamLeaderChk			NVARCHAR(MAX)
	,@p_delegateeChk			NVARCHAR(MAX)
	,@p_nonChk					NVARCHAR(MAX)
	,@p_real_flag				NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd		NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH RESULT_SCS_EXIST AS 
	(
		-- SCS 출하실적에서 CONFIRM_ID 존재
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.ATTRIBUTE5              AS CONFIRM_ID
		,       C.ERP_SO_NO				  AS ERP_SO_NO 
		,       E.SHIP_DATE		          AS YYYYMMDD
		,       C.TRANSPORT_MODE		  AS TRANSPORT_MODE
		,       C.INCOTERMS				  AS INCOTERMS
		,		C.ETA_DATE				  AS ETA_DATE
		,		C.ETD_DATE				  AS ETD_DATE
		,       E.SCM_SITE_ID			  AS FROM_SITE
		,		E.TO_SITE				  AS TO_SITE
		,		E.ITEM_ID				  AS ITEM_ID
		-- 20211126  SMS  추가  Ship to
		,		E.ATTRIBUTE4			  AS SHIP_TO
		--======================================================
		,       SUM(E.SHIP_QTY )		  AS RESULT_QTY 
		FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
		LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
			ON E.DIVISION_ID = C.DIVISION_ID
			AND E.ATTRIBUTE5 = C.CONFIRM_ID
		WHERE 1=1
		--AND   E.ATTRIBUTE5 LIKE 'R%'
		AND   E.SHIP_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 
				
		GROUP BY E.DIVISION_ID 
		,        E.ATTRIBUTE5
		,        C.ERP_SO_NO
		,        E.SHIP_DATE
		,		 C.TRANSPORT_MODE
		,        C.INCOTERMS
		,		 C.ETA_DATE
		,        C.ETD_DATE
		,        E.SCM_SITE_ID	
		,		 E.TO_SITE		
		,		 E.ITEM_ID		
		-- 20211126  SMS  추가
		,		 E.ATTRIBUTE4		
		--================================
		)
	, RESULT_ERP_C_NON AS 
	(
		-- SCS 출하실적에서 CONFIRM_ID 없는 실적 
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.ATTRIBUTE5              AS CONFIRM_ID
		,       '-'						  AS ERP_SO_NO 
		,       E.SHIP_DATE		          AS YYYYMMDD
		,       '-'						  AS TRANSPORT_MODE
		,       '-'						  AS INCOTERMS
		,		'-'						  AS ETA_DATE
		,		'-'						  AS ETD_DATE
		,       E.SCM_SITE_ID			  AS FROM_SITE
		,       E.TO_SITE				  AS TO_SITE
		,		E.ITEM_ID				  AS ITEM_ID
		-- 20211126  SMS  추가  Ship to
		,		E.ATTRIBUTE4			  AS SHIP_TO
		--======================================================
		,       SUM(E.SHIP_QTY )		  AS RESULT_QTY 

		FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
		
		WHERE 1=1
		
		AND   E.SHIP_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 
	    AND   ISNULL(E.ATTRIBUTE5,'-') = '-'
		GROUP BY E.DIVISION_ID 
		,        E.ATTRIBUTE5
		,        E.SHIP_DATE
		,		 E.ITEM_ID
		,        E.SCM_SITE_ID	
		,        E.TO_SITE		
		-- 20211126  SMS  추가
		,		 E.ATTRIBUTE4		
		--================================
	)
	, PLAN_SSP AS
	(   -- SSP출하계획 ( confirm된 계획) - Current Version
		SELECT C.DIVISION_ID    AS DIVISION_ID
		,      C.ERP_SO_NO      AS ERP_SO_NO
		,      C.CONFIRM_ID     AS CONFIRM_ID 
		,      C.ITEM_ID        AS ITEM_ID 
		,      C.FROM_SITE      AS FROM_SITE 
		,      C.TO_SITE        AS TO_SITE 
		,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
					ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
		,      C.QTY            AS QTY 
		,      C.YYYYMMDD       AS YYYYMMDD 
		,      C.TRANSPORT_MODE AS TRANSPORT_MODE
		,      C.INCOTERMS      AS INCOTERMS
		,      C.ETD_DATE       AS ETD_DATE
		,      C.ETA_DATE       AS ETA_DATE
		,	   NULL				AS SHIP_TYPE
		-- 20211126  SMS  추가  Ship to
		,	   C.TO_SITE_SHIPTO_CODE  AS SHIP_TO
		--======================================================
		FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
		INNER JOIN SCM_MST_SITE MS 
			ON C.DIVISION_ID = MS.DIVISION_ID AND C.FROM_SITE = MS.SCM_SITE_ID AND MS.SITE_TYPE = 'PLANT' AND C.DIVISION_ID = '40'  AND MS.OPERATION_GROUP = 'P'
		LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
			ON SI.DIVISION_ID = C.DIVISION_ID
			AND SI.ITEM_ID     = C.ITEM_ID 
			AND SI.SCM_SITE_ID = C.TO_SITE
			AND SI.PROJECT_CODE = C.PROJECT_CODE 
 		LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
			ON TS.DIVISION_ID = C.DIVISION_ID
			AND TS.SCM_SITE_ID = C.TO_SITE 
			AND TS.VALID_YN = 'Y'			--NERP 추가
		WHERE CHANGE_TYPE = 'C'
		AND   QTY > 0 
		AND   YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		AND ( ( @p_real_flag  = 'Y'  AND 1=1) )

		UNION ALL

		-- SSP출하계획 ( confirm된 계획) - OLD Version
		SELECT D.DIVISION_ID    AS DIVISION_ID
		,      NULL      AS ERP_SO_NO
		,      D.CONFIRM_ID     AS CONFIRM_ID 
		,      D.ITEM_ID        AS ITEM_ID 
		,      D.FROM_SITE      AS FROM_SITE 
		,      V.TO_SITE        AS TO_SITE 
		,      CASE WHEN D.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
					ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
		,      D.QTY            AS QTY 
		,      D.YYYYMMDD       AS YYYYMMDD 
		,      V.TRANSPORT_MODE AS TRANSPORT_MODE
		,      V.INCOTERMS      AS INCOTERMS
		,      D.ETD_DATE       AS ETD_DATE
		,      D.ETA_DATE       AS ETA_DATE
		,	   NULL				AS SHIP_TYPE
		-- 20211126  SMS  추가  Ship to
		,	   D.SHIPTO_CODE    AS SHIP_TO
		--======================================================
		FROM SSP_ANL_SHIP_PLAN_P D WITH(NOLOCK)

		INNER JOIN SCP_MST_BOD_N_V V
		 ON D.BOD_ID = V.BOD_ID

		LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
			ON SI.DIVISION_ID = D.DIVISION_ID
			AND SI.ITEM_ID     = D.ITEM_ID 
			AND SI.SCM_SITE_ID = V.TO_SITE
			AND SI.PROJECT_CODE = D.PROJECT_CODE 

 		LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
			ON TS.DIVISION_ID = D.DIVISION_ID
			AND TS.SCM_SITE_ID = V.TO_SITE 
			AND TS.VALID_YN = 'Y'			--NERP 추가
		WHERE 1=1
		AND	D.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND D.MEASURE = 'SHIP_CONFIRM'
		AND D.CONFIRM_FLAG = 'Y'
		AND D.QTY > 0 
		AND D.YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		AND ( ( @p_real_flag  = 'N'  AND 1=1) )
	) 

	SELECT X.DIVISION_ID
	,      MS.COMPANY_ID AS COMPANY_ID
	,      L.SEGMENT2  AS TYPE 
	,	   X.ERP_SO_NO
	,      X.CONFIRM_ID 
	,      X.ITEM_ID 
	,      DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
	--,      X.FROM_SITE 
	--,      X.TO_SITE 
	,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE)   AS FROM_SITE 
	,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)       AS TO_SITE 
		
	,      X.END_CUSTOMER  
	,      X.QTY 
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD 
	,      X.TRANSPORT_MODE
	,      X.INCOTERMS
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
	,	   X.SHIP_TYPE

	-- 20211126  SMS  추가 Ship to, Shipto description
	,	   X.SHIP_TO
	,	   SH.SHIPTO_DESCRIPTION
	-- ==============================================================
	FROM (
		--CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계
		SELECT S.DIVISION_ID     AS DIVISION_ID
		,     'S'                AS TYPE 
		,      S.ERP_SO_NO       AS ERP_SO_NO
		,      S.CONFIRM_ID      AS CONFIRM_ID 
		,      S.ITEM_ID         AS ITEM_ID 
		,      S.FROM_SITE       AS FROM_SITE 
		,      S.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      SUM(S.RESULT_QTY) AS QTY 
		,      S.YYYYMMDD        AS YYYYMMDD 
		,      S.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      S.INCOTERMS       AS INCOTERMS
		,      S.ETD_DATE        AS ETD_DATE
		,      S.ETA_DATE        AS ETA_DATE 
		,      NULL				 AS SHIP_TYPE
		-- 20211126  SMS  추가 Ship to
		,      S.SHIP_TO         AS SHIP_TO
		--============================================= 
		FROM  RESULT_SCS_EXIST S
		--LEFT OUTER JOIN PLAN_SSP P 
		-- ON S.CONFIRM_ID = P.CONFIRM_ID
		GROUP BY S.DIVISION_ID
		,		 S.ERP_SO_NO
		,        S.FROM_SITE                                                                           
		,        S.TO_SITE 
		,        S.ITEM_ID 
		,		 S.TRANSPORT_MODE			   
		,		 S.INCOTERMS
		,		 S.ETD_DATE
		,		 S.ETA_DATE			  
		,        S.YYYYMMDD 
		,        S.CONFIRM_ID
		-- 20211126  SMS  추가 Ship to
		,        S.SHIP_TO
		--========================================

	UNION ALL 

		--CONFIRM_ID 없는 실적 
		SELECT R.DIVISION_ID     AS DIVISION_ID
		,     'S'                AS TYPE 
		,      R.ERP_SO_NO       AS ERP_SO_NO
		,      NULL              AS CONFIRM_ID 
		,      R.ITEM_ID         AS ITEM_ID 
		,      R.FROM_SITE       AS FROM_SITE 
		,      R.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      R.RESULT_QTY      AS QTY 
		,      R.YYYYMMDD        AS YYYYMMDD 
		,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      R.INCOTERMS       AS INCOTERMS
		,      NULL        AS ETD_DATE
		,      NULL        AS ETA_DATE 
		,      NULL              AS SHIP_TYPE
		-- 20211126  SMS  추가 Ship to
		,      R.SHIP_TO         AS SHIP_TO
		--============================================= 
		FROM  RESULT_ERP_C_NON R 
	UNION ALL
  
		SELECT P.DIVISION_ID     AS DIVISION_ID
		,     'P'                AS TYPE 
		,      P.ERP_SO_NO       AS ERP_SO_NO
		,      P.CONFIRM_ID      AS CONFIRM_ID 
		,      P.ITEM_ID         AS ITEM_ID 
		,      P.FROM_SITE       AS FROM_SITE 
		,      P.TO_SITE         AS TO_SITE 
		,      P.END_CUSTOMER    AS END_CUSTOMER
		,      P.QTY             AS QTY 
		,      P.YYYYMMDD        AS YYYYMMDD 
		,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      P.INCOTERMS       AS INCOTERMS
		,      P.ETD_DATE        AS ETD_DATE
		,      P.ETA_DATE        AS ETA_DATE
		,      NULL              AS SHIP_TYPE
		-- 20211126  SMS  추가 Ship to
		,      P.SHIP_TO         AS SHIP_TO
		--============================================= 
		FROM  PLAN_SSP P 

	) X
		JOIN SCM_MST_SITE MS WITH(NOLOCK) 
		  ON MS.DIVISION_ID = X.DIVISION_ID 
		 AND MS.SCM_SITE_ID = X.FROM_SITE  
		 AND MS.OPERATION_GROUP <> 'E'
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   		  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE_PACKER' -- LOOKUP에 등록된 공정만 
		 AND L.SEGMENT1 = X.TYPE 
		 AND L.VALID_YN = 'Y'
		LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		          ON  M.DIVISION_ID = X.DIVISION_ID 
					and M.FROM_SITE = X.FROM_SITE 
					and M.ITEM_ID = X.ITEM_ID 
					and M.VALID_YN = 'Y'

		--20211126  SMS  추가  Shipto Description																	
		LEFT OUTER JOIN (SELECT DIVISION_ID, SHIPTO_CODE, MAX(SHIPTO_DESCRIPTION) AS SHIPTO_DESCRIPTION FROM SCM_MST_CUSTOMER WITH(NOLOCK)
		                  WHERE DIVISION_ID = '40' GROUP BY DIVISION_ID, SHIPTO_CODE) SH 		 
						     ON X.DIVISION_ID = SH.DIVISION_ID
						    AND X.SHIP_TO = SH.SHIPTO_CODE
		--=================================================

	WHERE 1=1
	AND   X.DIVISION_ID = @p_division_id
	AND ( ( @p_company_id   IS NULL OR @p_company_id ='')  OR MS.COMPANY_ID  = @p_company_id )
	AND ( ( @p_from_site   IS NULL OR @p_from_site ='')  OR X.FROM_SITE IN (SELECT token FROM dbo.String_Split(@p_from_site,',')) )
	AND ( ( @p_item_id   IS NULL OR @p_item_id ='')  OR X.ITEM_ID IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	AND ( ( @p_type   IS NULL OR @p_type ='')  OR X.TYPE IN (SELECT token FROM dbo.String_Split(@p_type,',')) )

	--체크박스 체크 여부 조회 시작(@p_nonChk = 'Y' : 체크박스 선택 안한 상태)
	AND ((@p_nonChk = 'Y' AND 1 = 1 OR M.USER_ID IN (SELECT CASE WHEN @p_myModelChk = 'Y' THEN @p_user_id ELSE 'X' END 
													UNION 
													SELECT CASE WHEN @p_delegateeChk = 'Y' THEN USER_ID ELSE 'X' END 
													FROM SSP_MST_DELEGATE WHERE VALID_YN = 'Y' AND DELEGATEE_ID = @p_user_id GROUP BY USER_ID)
									OR M.PART_LEADER = CASE WHEN @p_partLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END	
									OR M.TEAM_LEADER = CASE WHEN @p_teamLeaderChk = 'Y' THEN @p_user_id  ELSE 'X' END))
	--체크박스 체크 여부 조회 끝
	ORDER BY X.DIVISION_ID, X.FROM_SITE, X.YYYYMMDD, X.ITEM_ID, X.TO_SITE, L.DISPLAY_SEQ, X.CONFIRM_ID 

END
