



/*
 * Program ID   : SSP0015_GET_SHIPMENT_RESULT
 * Description  : Shipment Shipment Result
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/09/26   AYJ			[CSR ID:4037234] 출하계획 대비 실적 Report 개발
 * 2019/12/04   juhlee      [C20191205-000132]  OWMS 출하실적에 반품 내용 적용 ( SSP_DNM_SHIP_RESULT_OWMS_V)
 * 2020/01/21   juhlee          [C20200121-000352]  ESS Packer출하 적용 
								 - [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)    
 * 2020/02/12   KIMYONGHO   [C20200218-000135]  SHIP_TYPE 컬럼추가 및  FROM_STIE, TO_SITE Display 변경 CDOE - > Discription
 * 2020.05.06	KIMYONGHO   [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건 
 * 2020.09.18	KIMYONGHO   ERP_ORDER_TYPE 주석 처리 Request by 김광희 책임
 * 2021.02.17	KIMYONGHO   실적 조회시 TRNSPORT_MODE, INCOTERMS, ERP_SO_NO, ETA_DATE, ETD_DATE ERP 실적 기준으로 조회 Request by 김광희 책임
 * 2021.04.05   KIMYONGHO   [C20210330-000402] Shipment Plan화면의 실적 조회시 Sales site Mapping 안되는건에 대해서도 전수 표시 요청
 * 2021.05.03   SSP Pjt.    SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE LOOKUP적용
 * 2021.11.15   KIMYONGHO   Confirm Data Plan Date 기준 조회 처리 
 * 2024.10.18   SSP         소형 Team 컬럼 추가
 * 2024.10.29   KHJ         NERP_SSP
*/

CREATE PROCEDURE [dbo].[SSP0015_GET_SHIPMENT_RESULT]
	 @p_division_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_type				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	,@p_company_id			NVARCHAR(MAX)
	,@p_myModelChk			NVARCHAR(MAX)
	,@p_partLeaderChk		NVARCHAR(MAX)
	,@p_teamLeaderChk		NVARCHAR(MAX)
	,@p_delegateeChk		NVARCHAR(MAX)
	,@p_nonChk				NVARCHAR(MAX)
	,@p_real_flag			NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd	NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	WITH RESULT_ERP_C_EXIST AS 
	(
		-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.CONFIRM_ID              AS CONFIRM_ID
		,       E.ORDER_NO				  AS ERP_SO_NO 
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
		,       E.INCOTERMS				  AS INCOTERMS
		,		E.ETA_DATE				  AS ETA_DATE
		,		E.ETD_DATE				  AS ETD_DATE
		,		E.FROM_SCM_SITE_ID		  AS FROM_SITE
		,		E.TO_SCM_SITE_ID		  AS TO_SITE
		,		E.ITEM_ID				  AS ITEM_ID
		,       STUFF((  SELECT ',' + ISNULL(DEPT_NAME_KO,'-') FROM SCM_MST_SSO_DEPT_INFO A1 WITH(NOLOCK) 
		        LEFT OUTER JOIN TB_FX_User B1 WITH(NOLOCK) 
				ON A1.DEPT_ID = B1.DEPT_ID 
				WHERE B1.UserID in ( SELECT OWNER FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
									AND   DIVISION_ID   = E.DIVISION_ID
									AND   SCM_SITE_ID   = E.TO_SCM_SITE_ID
									AND   ITEM_ID       = E.ITEM_ID   
									AND   PROJECT_CODE  = (SELECT C.PROJECT_CODE FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) WHERE C.CONFIRM_ID = E.CONFIRM_ID)
									AND   VALID_YN      = 'Y'
									AND   OWNER IS NOT  NULL ) FOR XML PATH('')),1,1,'') AS TEAM
		,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY 
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.SSP_TYPE 
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   E.CONFIRM_ID LIKE 'C%'
		AND   E.EXFACTORY_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 
				
		GROUP BY E.DIVISION_ID 
		,        E.CONFIRM_ID
		,        E.ORDER_NO
		,        E.EXFACTORY_DATE
		,		 E.TRANSPORT_MODE
		,        E.INCOTERMS
		,		 E.ETA_DATE
		,        E.ETD_DATE
		,		 E.FROM_SCM_SITE_ID	
		,		 E.TO_SCM_SITE_ID	
		,		 E.ITEM_ID			


		)
	, RESULT_ERP_C_NON AS 
	(
		-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       '-'                       AS CONFIRM_ID
		,       E.ORDER_NO				  AS ERP_SO_NO 
		,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
        ,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
		,       E.ITEM_ID                 AS ITEM_ID
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.TRANSPORT_MODE      AS TRANSPORT_MODE
		,       E.INCOTERMS				  AS INCOTERMS
		,		E.ETA_DATE				  AS ETA_DATE
		,		E.ETD_DATE				  AS ETD_DATE
		,       STUFF((  SELECT ',' + ISNULL(DEPT_NAME_KO,'-') FROM SCM_MST_SSO_DEPT_INFO A1 WITH(NOLOCK) 
		        LEFT OUTER JOIN TB_FX_User B1 WITH(NOLOCK) 
				ON A1.DEPT_ID = B1.DEPT_ID 
				WHERE B1.UserID in ( SELECT OWNER FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
									AND   DIVISION_ID   = E.DIVISION_ID
									AND   SCM_SITE_ID   = E.TO_SCM_SITE_ID
									AND   ITEM_ID       = E.ITEM_ID   
									-- AND   PROJECT_CODE  = E.PROJECT_CODE
									AND   VALID_YN      = 'Y'
									AND   OWNER IS NOT  NULL ) FOR XML PATH('')),1,1,'') AS TEAM
		,       SUM(E.EXFACTORY_QTY )     AS QTY  
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
			  ON F.ITEM_ID = E.ITEM_ID 
			 AND F.DIVISION_ID = E.DIVISION_ID
			JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
			   AND FS.DIVISION_ID = E.DIVISION_ID 
			  -- AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
		-- 2020.09.18 김광희 책임 요청으로 주석처리
		-- 2021.04.15 김광희 책임 요청으로 주석해제
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.ORDER_TYPE_CODE 
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = E.DIVISION_ID 
				AND L3.SEGMENT2    = E.SOLDTO_CODE
				AND L3.SEGMENT3    = E.SHIPTO_CODE					    
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
		AND   E.EXFACTORY_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd
		--[C20210330-000402
		--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
		--AND   E.TO_SCM_SITE_ID IS NOT NULL 
--		AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
		AND 	E.STORAGE_ID NOT IN (select CODE FROM dbo.FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_RESULT','PRODUCT_STORAGE')) --상품창고제외
		--[C20200403-000062]
		AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리
		--AND   E.ORDER_TYPE_CODE  IN ('ZEF','ZEFC','ZEML','ZEMM','ZEX','ZFD','ZFR','ZKB','ZMM','ZOR','ZFDC','ZKM') -- 해당 ORDER_TYPE만 대상으로 함 
		GROUP BY E.DIVISION_ID 
		,        E.ORDER_NO
		,        E.FROM_SCM_SITE_ID                                                                           
		,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
		,        E.ITEM_ID   
		,        E.EXFACTORY_DATE
		,		 E.TRANSPORT_MODE
		,        E.INCOTERMS
		,		 E.ETA_DATE
		,        E.ETD_DATE
		,        E.TO_SCM_SITE_ID 
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
		FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			 LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
						  ON SI.DIVISION_ID = C.DIVISION_ID
						 AND SI.ITEM_ID     = C.ITEM_ID 
						 AND SI.SCM_SITE_ID = C.TO_SITE
						 AND SI.PROJECT_CODE = C.PROJECT_CODE 
 			 LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
						  ON TS.DIVISION_ID = C.DIVISION_ID
						 AND TS.SCM_SITE_ID = C.TO_SITE 
		WHERE CHANGE_TYPE = 'C'
		AND   QTY > 0 
		AND   YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd
		AND   CONFIRM_ID LIKE 'C%'
		AND ( ( @p_real_flag  = 'Y'  AND 1=1) )

		UNION ALL

		-- SSP출하계획 ( confirm된 계획) - OLD Version
		SELECT D.DIVISION_ID    AS DIVISION_ID
		,      D.ERP_SO_NO      AS ERP_SO_NO
		,      D.CONFIRM_ID     AS CONFIRM_ID 
		,      D.ITEM_ID        AS ITEM_ID 
		,      D.FROM_SITE      AS FROM_SITE 
		,      D.TO_SITE        AS TO_SITE 
		,      CASE WHEN D.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
					ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
		,      D.SHIPMENT_CONFIRM_QTY            AS QTY 
		,      D.YYYYMMDD       AS YYYYMMDD 
		,      D.TRANSPORT_MODE AS TRANSPORT_MODE
		,      D.INCOTERMS      AS INCOTERMS
		,      D.ETD            AS ETD_DATE
		,      D.ETA            AS ETA_DATE
		,	   NULL				AS SHIP_TYPE
		FROM SSP_ANL_SHIP_PLAN_ALL D WITH(NOLOCK)
		
		INNER JOIN SCM_MST_SITE MS 
			ON D.DIVISION_ID = MS.DIVISION_ID AND D.FROM_SITE = MS.SCM_SITE_ID AND MS.SITE_TYPE = 'PLANT' AND D.DIVISION_ID = '40'  AND MS.OPERATION_GROUP = 'A'

		LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
			ON SI.DIVISION_ID = D.DIVISION_ID
			AND SI.ITEM_ID     = D.ITEM_ID 
			AND SI.SCM_SITE_ID = D.TO_SITE
			AND SI.PROJECT_CODE = D.PROJECT_CODE 

 		LEFT OUTER JOIN SCM_MST_SITE TS WITH(NOLOCK) 
			ON TS.DIVISION_ID = D.DIVISION_ID
			AND TS.SCM_SITE_ID = D.TO_SITE 
		WHERE 1=1
		AND	D.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		AND D.SHIPMENT_STATUS = 'C'
		AND D.SHIPMENT_CONFIRM_QTY > 0 
		AND D.YYYYMMDD BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		AND ( ( @p_real_flag  = 'N'  AND 1=1) )
	) 
	, RESULT_OWMS AS
	(
		-- owms 출하실적
		SELECT A.DIVISION_ID       AS DIVISION_ID 
		,      A.ITEM_ID           AS ITEM_ID 
		,      A.FROM_SITE         AS FROM_SITE
		,      CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE  A.TO_SITE END          AS TO_SITE
		,      SUM(A.LOT_QTY)            AS QTY 
		,      A.PLANT_ISSUE_DATE  AS YYYYMMDD
		,	   A.SHIP_TYPE AS SHIP_TYPE
		,       STUFF((  SELECT ',' + ISNULL(DEPT_NAME_KO,'-') FROM SCM_MST_SSO_DEPT_INFO A1 WITH(NOLOCK) 
		        LEFT OUTER JOIN TB_FX_User B1 WITH(NOLOCK) 
				ON A1.DEPT_ID = B1.DEPT_ID 
				WHERE B1.UserID in ( SELECT OWNER FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE 1=1 
									AND   DIVISION_ID   = A.DIVISION_ID
									AND   SCM_SITE_ID   = A.TO_SITE
									AND   ITEM_ID       = A.ITEM_ID   
									-- AND   PROJECT_CODE  = E.PROJECT_CODE
									AND   VALID_YN      = 'Y'
									AND   OWNER IS NOT  NULL ) FOR XML PATH('')),1,1,'') AS TEAM
		FROM SSP_DNM_SHIP_RESULT_OWMS A WITH(NOLOCK)
		WHERE A.PLANT_ISSUE_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		GROUP BY A.DIVISION_ID        
		,        A.ITEM_ID      
		,        A.FROM_SITE   
		,        CASE WHEN A.TO_SITE ='-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE  END  
		,        A.PLANT_ISSUE_DATE  
		,		 A.SHIP_TYPE
		,        A.TO_SITE
	)

	, RETURN_OWMS AS
	(
		-- owms 출하 반품
		SELECT B.DIVISION_ID      AS DIVISION_ID 
		,      B.ITEM_ID          AS ITEM_ID 
		,      B.FROM_SITE        AS FROM_SITE
		,      '*'                AS TO_SITE 
		,      SUM(B.RECIEPT_QTY) AS QTY 
		,      B.RECIEPT_DATE     AS YYYYMMDD 
		,	   NULL AS SHIP_TYPE
		FROM SSP_DNM_SHIP_RETURN_OWMS B WITH(NOLOCK) 
		WHERE B.RECIEPT_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		GROUP BY B.DIVISION_ID        
		,        B.ITEM_ID      
		,        B.FROM_SITE   
		,        B.RECIEPT_DATE 
		
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
	,      X.TEAM	
	,      X.END_CUSTOMER  
	,      X.QTY 
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD 
	,      X.TRANSPORT_MODE
	,      X.INCOTERMS
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
	,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
	,	   X.SHIP_TYPE
	FROM (
		--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 
		SELECT R.DIVISION_ID     AS DIVISION_ID
		,     'E'				 AS TYPE 
		,      R.ERP_SO_NO       AS ERP_SO_NO
		,      R.CONFIRM_ID      AS CONFIRM_ID 
		,      R.ITEM_ID         AS ITEM_ID 
		,      R.FROM_SITE       AS FROM_SITE 
		,      R.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      R.TEAM            AS TEAM
		,      SUM(R.RESULT_QTY) AS QTY 
		,      R.YYYYMMDD        AS YYYYMMDD
		--,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
		--,      P.INCOTERMS       AS INCOTERMS
		,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      R.INCOTERMS       AS INCOTERMS
		,      R.ETD_DATE        AS ETD_DATE
		,      R.ETA_DATE        AS ETA_DATE 
		,      NULL				 AS SHIP_TYPE
		FROM  RESULT_ERP_C_EXIST R 
				--JOIN RESULT_ERP_C_EXIST R 
				--ON R.DIVISION_ID = P.DIVISION_ID 
				--AND R.CONFIRM_ID = P.CONFIRM_ID 
				--AND R.YYYYMMDD = P.YYYYMMDD 

		GROUP BY R.DIVISION_ID
		,        R.ERP_SO_NO
		,        R.FROM_SITE                                                                           
		,        R.TO_SITE 
		,        R.ITEM_ID
		--,		 P.TRANSPORT_MODE			   
		--,		 P.INCOTERMS
		,		 R.TRANSPORT_MODE			   
		,		 R.INCOTERMS
		--,		 P.ETD_DATE
		--,		 P.ETA_DATE
		,		 R.ETD_DATE
		,		 R.ETA_DATE			  
		,        R.YYYYMMDD 
		,        R.CONFIRM_ID
		,        R.TEAM

	--UNION ALL 

	--	--CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계
	--	SELECT P.DIVISION_ID     AS DIVISION_ID
	--	,     'E'                AS TYPE 
	--	,      R.ERP_SO_NO       AS ERP_SO_NO
	--	,      R.CONFIRM_ID      AS CONFIRM_ID 
	--	,      P.ITEM_ID         AS ITEM_ID 
	--	,      P.FROM_SITE       AS FROM_SITE 
	--	,      P.TO_SITE         AS TO_SITE 
	--	,      NULL              AS END_CUSTOMER
	--	,      SUM(R.RESULT_QTY) AS QTY 
	--	,      R.YYYYMMDD        AS YYYYMMDD 
	--	--,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
	--	--,      P.INCOTERMS       AS INCOTERMS
	--	,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
	--	,      R.INCOTERMS       AS INCOTERMS
	--	--,      P.ETD_DATE        AS ETD_DATE
	--	--,      P.ETA_DATE        AS ETA_DATE
	--	,      R.ETD_DATE        AS ETD_DATE
	--	,      R.ETA_DATE        AS ETA_DATE 
	--	,      NULL				 AS SHIP_TYPE
	--	FROM  PLAN_SSP P 
	--			JOIN RESULT_ERP_C_EXIST R 
	--			ON R.DIVISION_ID = P.DIVISION_ID 
	--			AND R.CONFIRM_ID = P.CONFIRM_ID 
	--			AND R.YYYYMMDD <> P.YYYYMMDD 
	--	GROUP BY P.DIVISION_ID
	--	,		 R.ERP_SO_NO
	--	,        P.FROM_SITE                                                                           
	--	,        P.TO_SITE 
	--	,        P.ITEM_ID 
	--	--,		 P.TRANSPORT_MODE			   
	--	--,		 P.INCOTERMS
	--	,		 R.TRANSPORT_MODE			   
	--	,		 R.INCOTERMS
	--	--,		 P.ETD_DATE
	--	--,		 P.ETA_DATE
	--	,		 R.ETD_DATE
	--	,		 R.ETA_DATE			  
	--	,        R.YYYYMMDD 
	--	,        R.CONFIRM_ID

	UNION ALL 

		--CONFIRM_ID 없는 실적 
		SELECT R.DIVISION_ID     AS DIVISION_ID
		,     'E'                AS TYPE 
		,      R.ERP_SO_NO       AS ERP_SO_NO
		,      NULL              AS CONFIRM_ID 
		,      R.ITEM_ID         AS ITEM_ID 
		,      R.FROM_SITE       AS FROM_SITE 
		,      R.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      R.TEAM            AS TEAM
		,      R.QTY             AS QTY 
		,      R.YYYYMMDD        AS YYYYMMDD 
		--,      NULL              AS TRANSPORT_MODE
		--,      NULL              AS INCOTERMS
		,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      R.INCOTERMS       AS INCOTERMS
		--,      NULL              AS ETD_DATE
		--,      NULL              AS ETA_DATE
		,      R.ETD_DATE        AS ETD_DATE
		,      R.ETA_DATE        AS ETA_DATE 
		,      NULL              AS SHIP_TYPE
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
		,      '-'               AS TEAM
		,      P.QTY             AS QTY 
		,      P.YYYYMMDD        AS YYYYMMDD 
		,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
		,      P.INCOTERMS       AS INCOTERMS
		,      P.ETD_DATE        AS ETD_DATE
		,      P.ETA_DATE        AS ETA_DATE
		,      NULL              AS SHIP_TYPE
		FROM  PLAN_SSP P 


	UNION ALL 
		-- OWMS 실적 
		SELECT R.DIVISION_ID     AS DIVISION_ID
		,     'O'				 AS TYPE 
		,      NULL              AS ERP_SO_NO
		,      NULL              AS CONFIRM_ID 
		,      R.ITEM_ID         AS ITEM_ID 
		,      R.FROM_SITE       AS FROM_SITE 
		,      R.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      R.TEAM            AS TEAM
		,      R.QTY             AS QTY 
		,      R.YYYYMMDD        AS YYYYMMDD 
		,      NULL              AS TRANSPORT_MODE
		,      NULL              AS INCOTERMS
		,      NULL              AS ETD_DATE
		,      NULL              AS ETA_DATE 
		,      R.SHIP_TYPE         AS SHIP_TYPE
		FROM  RESULT_OWMS R
	
	UNION ALL
		-- OWMS 반품실적 
		SELECT R.DIVISION_ID     AS DIVISION_ID
		,      'R'		         AS TYPE 
		,      NULL              AS ERP_SO_NO
		,      NULL              AS CONFIRM_ID 
		,      R.ITEM_ID         AS ITEM_ID 
		,      R.FROM_SITE       AS FROM_SITE 
		,      R.TO_SITE         AS TO_SITE 
		,      NULL              AS END_CUSTOMER
		,      '-'               AS TEAM
		,      R.QTY             AS QTY 
		,      R.YYYYMMDD        AS YYYYMMDD 
		,      NULL              AS TRANSPORT_MODE
		,      NULL              AS INCOTERMS
		,      NULL              AS ETD_DATE
		,      NULL              AS ETA_DATE
		,      R.SHIP_TYPE       AS SHIP_TYPE
		FROM  RETURN_OWMS R
	) X
		JOIN SCM_MST_SITE MS WITH(NOLOCK) 
		  ON MS.DIVISION_ID = X.DIVISION_ID 
		 AND MS.SCM_SITE_ID = X.FROM_SITE  
		 AND MS.OPERATION_GROUP <> 'E'
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   		  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만 
		 AND L.SEGMENT1 = X.TYPE 
		 AND L.VALID_YN = 'Y'
		LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
		          ON  M.DIVISION_ID = X.DIVISION_ID 
					and M.FROM_SITE = X.FROM_SITE 
					and M.ITEM_ID = X.ITEM_ID 
					and M.VALID_YN = 'Y'
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
