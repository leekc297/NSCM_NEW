






CREATE VIEW [dbo].[SSP_DNM_SHIP_RESULT_ERP_COMMON_SCM_V] AS
/*
 * Program ID   : SSP_DNM_SHIP_RESULT_ERP_COMMON_SCM_V
 * Description  : ERP 출하실적을 전사 SCM 에 제공한다
                  소속 DIVISION_ID 정보를 조회 하기 위해서
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2025.05.14 _ERP_DW_V에서 복사하여 전사SCM용으로 신규 생성 (심재만 책임 요청)
 * 2025.06.19 ssp 출하실적 view 기준으로 수정
 * 2026.02.12	강주용		E20260211-001000 SSP ERP 출하실적 차이 수정
*/

SELECT 
	   D.ATTRIBUTE3		AS DIVISION_ID
	  ,X.COMPANY_ID
	  ,X.PLANT_ID 
	  ,X.ORDER_NO
	  ,X.DELIVERY_NO
	  ,X.DELIVERY_ITEM_SEQ
	  ,X.ITEM_ID
	  ,X.PROJET_CODE
	  ,X.FROM_SITE     
	  ,X.TO_SITE      
	  ,X.YYYYMMDD
	  ,X.RESULT_QTY 
	  ,X.SHIPTO_CODE 
	  ,X.TRANSPORT_MODE
	  ,X.INCOTERMS
	  ,X.CONFIRM_ID 
	  ,X.FCST_TYPE
	  ,X.CURRENCY_CODE
	  ,X.NET_PRICE
	  ,X.SALES_AMOUNT
	  ,X.KRW_XRATE
	  ,X.SALES_KRW_AMOUNT
	  ,X.DIVISION_ID	AS SCM_DIVISION_ID
	  ,X.ORDER_TYPE_CODE
  FROM (
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.COMPANY_ID              AS COMPANY_ID
		,       E.PLANT_ID                AS PLANT_ID 
		,       E.ORDER_NO                AS ORDER_NO
		,       E.DELIVERY_NO             AS DELIVERY_NO
		,       E.DELIVERY_ITEM_SEQ       AS DELIVERY_ITEM_SEQ
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
        --,       C.ITEM_ID                 AS ITEM_ID 
		,       E.ITEM_ID                 AS ITEM_ID 
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       CASE WHEN E.DIVISION_ID = '40' THEN '-'  
		             ELSE ISNULL(E.PROJECT_CODE,'-') END     AS PROJET_CODE 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
        --,       C.FROM_SITE               AS FROM_SITE      
        --,       C.TO_SITE                 AS TO_SITE    
		,       E.FROM_SCM_SITE_ID        AS FROM_SITE
		,       E.TO_SCM_SITE_ID          AS TO_SITE
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.EXFACTORY_QTY           AS RESULT_QTY 
		,       E.SHIPTO_CODE             AS SHIPTO_CODE 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--,       C.TRANSPORT_MODE          AS TRANSPORT_MODE
		--,       C.INCOTERMS               AS INCOTERMS
		,       E.TRANSPORT_MODE          AS TRANSPORT_MODE
		,       E.INCOTERMS               AS INCOTERMS
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.CONFIRM_ID              AS CONFIRM_ID 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--,       C.FCST_TYPE               AS FCST_TYPE
		,       '-'							AS FCST_TYPE
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.CURRENCY_CODE
		,       E.NET_PRICE
		,       E.SALES_AMOUNT
		,       E.KRW_XRATE
		,       E.SALES_KRW_AMOUNT
		, E.ORDER_TYPE_CODE AS ORDER_TYPE_CODE
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
		--START E20260211-001000 SSP ERP 출하실적 차이 수정
		--    JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
		--	  ON C.CONFIRM_ID = E.CONFIRM_ID 
		--END E20260211-001000 SSP ERP 출하실적 차이 수정
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.SSP_TYPE
		JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
			ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
		   AND E.DIVISION_ID	= S.DIVISION_ID				 
		   AND S.SITE_TYPE		= 'PLANT'					 				 
		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
			ON E.ITEM_ID		= T.ITEM_ID					 
		   AND E.DIVISION_ID	= T.DIVISION_ID				 
		   AND S.COMPANY_ID		= T.COMPANY_ID				 
		   AND T.ITEM_TYPE		NOT IN ('Q','R')
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   E.CONFIRM_ID LIKE 'C%'
		AND   E.DIVISION_ID <> '40'--E20260211-001000 SSP ERP 출하실적 차이 수정. 소형제외
		--AND   E.EXFACTORY_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 

		--START E20260211-001000 SSP ERP 출하실적 차이 수정 : 페커 제외
        -- 2025-07-02 PACKER 추가 시작
	--	UNION ALL
	--	SELECT S.DIVISION_ID     AS DIVISION_ID
	--	,NULL AS COMPANY_ID
	--	,NULL AS PLANT_ID
	--	,      S.ERP_SO_NO       AS ORDER_NO
	--	, NULL AS DELIVERY_NO
	--	, 0       AS DELIVERY_ITEM_SEQ
	--	,      S.ITEM_ID         AS ITEM_ID 
	--	, NULL          AS PROJECT_CODE
	--	,      S.FROM_SITE       AS FROM_SITE 
	--	,      S.TO_SITE         AS TO_SITE 
	--	,      S.YYYYMMDD        AS YYYYMMDD 
	--	,      SUM(S.RESULT_QTY) AS RESULT_QTY 
	--	,      S.SHIP_TO         AS SHIPTO_CODE 
	--	,      S.TRANSPORT_MODE  AS TRANSPORT_MODE
	--	,      S.INCOTERMS       AS INCOTERMS
	--, CONFIRM_ID AS CONFIRM_ID	
	--, '' AS FCST_TYPE
	--, '0' AS CURRENCY_CODE
	--,NULL AS NET_PRICE
	--,NULL AS SALES_AMOUNT
	--,NULL AS KRW_XRATE
	--,NULL AS SALES_KRW_AMOUNT
	--,'' AS ORDER_TYPE_CODE
	--	--,      NULL              AS END_CUSTOMER
	--	--,      SUM(S.RESULT_QTY) AS QTY 
	--	--,      S.YYYYMMDD        AS YYYYMMDD 
	--	--,      S.TRANSPORT_MODE  AS TRANSPORT_MODE
	--	--,      S.INCOTERMS       AS INCOTERMS
	--	--,      S.ETD_DATE        AS ETD_DATE
	--	--,      S.ETA_DATE        AS ETA_DATE 
	--	--,      NULL				 AS SHIP_TYPE
	--	-- 20211126  SMS  추가 Ship to
	--	--,      S.SHIP_TO         AS SHIP_TO
	--	--============================================= 
	--	FROM  (
		
	--	-- SCS 출하실적에서 CONFIRM_ID 존재
	--	SELECT  E.DIVISION_ID             AS DIVISION_ID
	--	,       E.ATTRIBUTE5              AS CONFIRM_ID
	--	,       C.ERP_SO_NO				  AS ERP_SO_NO 
	--	,       E.SHIP_DATE		          AS YYYYMMDD
	--	,       C.TRANSPORT_MODE		  AS TRANSPORT_MODE
	--	,       C.INCOTERMS				  AS INCOTERMS
	--	,		C.ETA_DATE				  AS ETA_DATE
	--	,		C.ETD_DATE				  AS ETD_DATE
	--	,       E.SCM_SITE_ID			  AS FROM_SITE
	--	,		E.TO_SITE				  AS TO_SITE
	--	,		E.ITEM_ID				  AS ITEM_ID
	--	-- 20211126  SMS  추가  Ship to
	--	,		E.ATTRIBUTE4			  AS SHIP_TO
	--	--======================================================
	--	,       SUM(E.SHIP_QTY )		  AS RESULT_QTY 
	--	FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
	--	LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
	--		ON E.DIVISION_ID = C.DIVISION_ID
	--		AND E.ATTRIBUTE5 = C.CONFIRM_ID
	--	WHERE 1=1
	--	AND E.DIVISION_ID = '40'
	--	--AND   E.ATTRIBUTE5 LIKE 'R%' -- not to ESS DATA Duplicattion 
	--	--AND   E.SHIP_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 
				
	--	GROUP BY E.DIVISION_ID 
	--	,        E.ATTRIBUTE5
	--	,        C.ERP_SO_NO
	--	,        E.SHIP_DATE
	--	,		 C.TRANSPORT_MODE
	--	,        C.INCOTERMS
	--	,		 C.ETA_DATE
	--	,        C.ETD_DATE
	--	,        E.SCM_SITE_ID	
	--	,		 E.TO_SITE		
	--	,		 E.ITEM_ID		
	--	-- 20211126  SMS  추가
	--	,		 E.ATTRIBUTE4		
	--	--================================
		
	--	) S
	--	--LEFT OUTER JOIN PLAN_SSP P 
	--	-- ON S.CONFIRM_ID = P.CONFIRM_ID
	--	GROUP BY S.DIVISION_ID
	--	,		 S.ERP_SO_NO
	--	,        S.FROM_SITE                                                                           
	--	,        S.TO_SITE 
	--	,        S.ITEM_ID 
	--	,		 S.TRANSPORT_MODE			   
	--	,		 S.INCOTERMS
	--	,		 S.ETD_DATE
	--	,		 S.ETA_DATE			  
	--	,        S.YYYYMMDD 
	--	,        S.CONFIRM_ID
	--	-- 20211126  SMS  추가 Ship to
	--	,        S.SHIP_TO

		-- 2025-07-02 PACKER 추가 종료
		
		UNION ALL 
		-- 소형제외, 컴펌아이디 없는 건
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.COMPANY_ID              AS COMPANY_ID
		,       E.PLANT_ID                AS PLANT_ID 
		,       E.ORDER_NO                AS ORDER_NO
		,       E.DELIVERY_NO             AS DELIVERY_NO
		,       E.DELIVERY_ITEM_SEQ       AS DELIVERY_ITEM_SEQ
        ,       E.ITEM_ID                 AS ITEM_ID 
		,       CASE WHEN E.DIVISION_ID = '40' THEN '-'  
		             ELSE ISNULL(E.PROJECT_CODE,'-') END     AS PROJET_CODE
		,       E.FROM_SCM_SITE_ID        AS FROM_SITE
		,       E.TO_SCM_SITE_ID          AS TO_SITE 
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.EXFACTORY_QTY           AS RESULT_QTY 
		,       E.SHIPTO_CODE             AS SHIPTO_CODE 
		,       E.TRANSPORT_MODE          AS TRANSPORT_MODE
		,       E.INCOTERMS               AS INCOTERMS
		,       E.CONFIRM_ID              AS CONFIRM_ID 
		,       '-'                       AS FCST_TYPE
		,       E.CURRENCY_CODE
		,       E.NET_PRICE
		,       E.SALES_AMOUNT
		,       E.KRW_XRATE
		,       E.SALES_KRW_AMOUNT
		,       E.ORDER_TYPE_CODE AS ORDER_TYPE_CODE
		FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
		JOIN SCM_MST_SITE AS S WITH(NOLOCK)					 
			ON E.FROM_SCM_SITE_ID	= S.SCM_SITE_ID				 
		   AND E.DIVISION_ID	= S.DIVISION_ID				 
		   AND S.SITE_TYPE		= 'PLANT'					 				 
		
		JOIN SCM_MST_ITEM_SN AS T WITH(NOLOCK)				 
			ON E.ITEM_ID		= T.ITEM_ID					 
		   AND E.DIVISION_ID	= T.DIVISION_ID				 
		   AND S.COMPANY_ID		= T.COMPANY_ID				 
		   AND T.ITEM_TYPE		NOT IN ('Q','R')
		JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
			ON F.ITEM_ID = E.ITEM_ID 
			AND F.DIVISION_ID = E.DIVISION_ID
		LEFT JOIN   SCM_MST_SITE FS WITH(NOLOCK)
			ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
			AND FS.DIVISION_ID = E.DIVISION_ID 
			-- 2025-07-02 PACKER 제외 적용
			--AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
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
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--AND ISNULL(FS.OSP_YN,'N') ='Y' 
		AND ISNULL(FS.DIVISION_ID,'') <> '40' -- 소형제외
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
		--AND   E.EXFACTORY_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		--[C20210330-000402]
		--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
		--AND   E.TO_SCM_SITE_ID IS NOT NULL 
		AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
		--[C20200403-000062]
		AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리

		UNION ALL
		-- 소형 컴펌아이디 있는 부분
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.COMPANY_ID              AS COMPANY_ID
		,       E.PLANT_ID                AS PLANT_ID 
		,       E.ORDER_NO                AS ORDER_NO
		,       E.DELIVERY_NO             AS DELIVERY_NO
		,       E.DELIVERY_ITEM_SEQ       AS DELIVERY_ITEM_SEQ
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
        --,       C.ITEM_ID                 AS ITEM_ID 
		,       E.ITEM_ID                 AS ITEM_ID 
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       CASE WHEN E.DIVISION_ID = '40' THEN '-'  
		             ELSE ISNULL(E.PROJECT_CODE,'-') END     AS PROJET_CODE 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
        --,       C.FROM_SITE               AS FROM_SITE      
        --,       C.TO_SITE                 AS TO_SITE    
		,       E.FROM_SCM_SITE_ID        AS FROM_SITE
		,       E.TO_SCM_SITE_ID          AS TO_SITE
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.EXFACTORY_QTY           AS RESULT_QTY 
		,       E.SHIPTO_CODE             AS SHIPTO_CODE 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--,       C.TRANSPORT_MODE          AS TRANSPORT_MODE
		--,       C.INCOTERMS               AS INCOTERMS
		,       E.TRANSPORT_MODE          AS TRANSPORT_MODE
		,       E.INCOTERMS               AS INCOTERMS
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.CONFIRM_ID              AS CONFIRM_ID 
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--,       C.FCST_TYPE               AS FCST_TYPE
		,       '-'							AS FCST_TYPE
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		,       E.CURRENCY_CODE
		,       E.NET_PRICE
		,       E.SALES_AMOUNT
		,       E.KRW_XRATE
		,       E.SALES_KRW_AMOUNT
		, E.ORDER_TYPE_CODE AS ORDER_TYPE_CODE
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
		--START E20260211-001000 SSP ERP 출하실적 차이 수정
		--    JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
		--	  ON C.CONFIRM_ID = E.CONFIRM_ID 
		--END E20260211-001000 SSP ERP 출하실적 차이 수정
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.SSP_TYPE
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   E.CONFIRM_ID LIKE 'C%'
		AND   E.DIVISION_ID = '40'
		--AND   E.EXFACTORY_DATE BETWEEN @p_from_yyyymmdd  AND @p_to_yyyymmdd 

		UNION ALL
		-- 소형 컴펌아이디 없는 부분
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.COMPANY_ID              AS COMPANY_ID
		,       E.PLANT_ID                AS PLANT_ID 
		,       E.ORDER_NO                AS ORDER_NO
		,       E.DELIVERY_NO             AS DELIVERY_NO
		,       E.DELIVERY_ITEM_SEQ       AS DELIVERY_ITEM_SEQ
        ,       E.ITEM_ID                 AS ITEM_ID 
		,       CASE WHEN E.DIVISION_ID = '40' THEN '-'  
		             ELSE ISNULL(E.PROJECT_CODE,'-') END     AS PROJET_CODE
		,       E.FROM_SCM_SITE_ID        AS FROM_SITE
		,       E.TO_SCM_SITE_ID          AS TO_SITE 
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.EXFACTORY_QTY           AS RESULT_QTY 
		,       E.SHIPTO_CODE             AS SHIPTO_CODE 
		,       E.TRANSPORT_MODE          AS TRANSPORT_MODE
		,       E.INCOTERMS               AS INCOTERMS
		,       E.CONFIRM_ID              AS CONFIRM_ID 
		,       '-'                       AS FCST_TYPE
		,       E.CURRENCY_CODE
		,       E.NET_PRICE
		,       E.SALES_AMOUNT
		,       E.KRW_XRATE
		,       E.SALES_KRW_AMOUNT
		,       E.ORDER_TYPE_CODE AS ORDER_TYPE_CODE
		FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
		JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
			ON F.ITEM_ID = E.ITEM_ID 
			AND F.DIVISION_ID = E.DIVISION_ID
		LEFT JOIN   SCM_MST_SITE FS WITH(NOLOCK)
			ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
			AND FS.DIVISION_ID = E.DIVISION_ID 
			-- 2025-07-02 PACKER 제외 적용
			--AND ISNULL(FS.OSP_YN,'N') <> 'Y' --- [C20200121-000352]-2 : FROM_SITE PACKER포함(OSP_YN <> 'Y' 조건제외)
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
		-- START E20260211-001000 SSP ERP 출하실적 차이 수정
		--AND ISNULL(FS.OSP_YN,'N') ='Y' 
		AND ISNULL(FS.DIVISION_ID,'') = '40'
		-- END E20260211-001000 SSP ERP 출하실적 차이 수정
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
		--AND   E.EXFACTORY_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd 
		--[C20210330-000402]
		--AND   E.FROM_SCM_SITE_ID IS NOT NULL 
		--AND   E.TO_SCM_SITE_ID IS NOT NULL 
		--AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
		--[C20200403-000062]
		AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리
		--END E20260211-001000 SSP ERP 출하실적 차이 수정

       ) X
       JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
    ON X.DIVISION_ID = D.DIVISION_ID
