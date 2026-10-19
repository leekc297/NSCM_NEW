




CREATE VIEW [dbo].[SSP_DNM_SHIP_RESULT_ERP_V] AS
/********************************************************************************************************************************
* VIEW NAME     : [SSP_DNM_SHIP_RESULT_ERP_V]
* DESCRIPTION   : ERP 출하실적
               
* PROGRAM HISTORY
*-------------------------------------------------------------------------------------------------------------------------------
*  DATE			IN CHARGE           DESCRIPTION
*-------------------------------------------------------------------------------------------------------------------------------
* 2020.02.11	KIMYONGHO				[C20200210-000481] DW 출하계획/실적 레포트 구현 지원
* 2020.05.06	KIMYONGHO				[C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건 
* 2024.10.01    KHJ                     NERP_SSP
            
********************************************************************************************************************************/
SELECT X.*
FROM (
		SELECT  E.DIVISION_ID             AS DIVISION_ID
		,       E.COMPANY_ID              AS COMPANY_ID
		,       E.PLANT_ID                AS PLANT_ID 
		,       E.ORDER_NO                AS ORDER_NO
		,       E.DELIVERY_NO             AS DELIVERY_NO
		,       E.DELIVERY_ITEM_SEQ       AS DELIVERY_ITEM_SEQ
        ,       C.ITEM_ID                 AS ITEM_ID 
		,       CASE WHEN E.DIVISION_ID = '40' THEN '-'  
		             ELSE ISNULL(E.PROJECT_CODE,'-') END     AS PROJET_CODE 
        ,       C.FROM_SITE               AS FROM_SITE      
        ,       C.TO_SITE                 AS TO_SITE      
		,       E.EXFACTORY_DATE          AS YYYYMMDD
		,       E.EXFACTORY_QTY           AS RESULT_QTY 
		,       E.SHIPTO_CODE             AS SHIPTO_CODE 
		,       C.TRANSPORT_MODE          AS TRANSPORT_MODE
		,       C.INCOTERMS               AS INCOTERMS
		,       E.CONFIRM_ID              AS CONFIRM_ID 
		,       C.FCST_TYPE               AS FCST_TYPE
		,       E.CURRENCY_CODE
		,       E.NET_PRICE
		,       E.SALES_AMOUNT
		,       E.KRW_XRATE
		,       E.SALES_KRW_AMOUNT
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
		    JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
			  ON C.CONFIRM_ID = E.CONFIRM_ID 
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			  ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			AND L.VALID_YN = 'Y'
			AND L.SEGMENT1    = E.SSP_TYPE 
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   E.CONFIRM_ID LIKE 'C%'

		UNION ALL 

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
		FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			JOIN  SCP_MST_FINAL_ITEM  F WITH(NOLOCK) -- SCP 대상 ITEM만 
			 ON F.ITEM_ID = E.ITEM_ID 
			AND F.DIVISION_ID = E.DIVISION_ID 
			JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
			   AND FS.DIVISION_ID = E.DIVISION_ID 
			   AND ISNULL(FS.OSP_YN,'N') < > 'Y' -- FROM_SITE가 PACKER제외

			-- 2020.09.18. 김광희 책임 요청으로 막음
			--JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			--	ON L.LOOKUP_TYPE = 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
			--AND L.VALID_YN = 'Y'
			--AND L.SEGMENT1    = E.ORDER_TYPE_CODE 		

			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
					ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
				AND L3.SEGMENT1    = E.DIVISION_ID 
				AND L3.SEGMENT2    = E.SOLDTO_CODE
				AND L3.SEGMENT3    = E.SHIPTO_CODE				    
		WHERE 1=1
		AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
	    AND   E.FROM_SCM_SITE_ID IS NOT NULL 
		AND   E.TO_SCM_SITE_ID IS NOT NULL 
--		AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외 
		AND   E.STORAGE_ID NOT IN (select CODE FROM dbo.FN_LIST_LOOKUP_VALUE('SSP_DNM_SHIP_RESULT_ERP_V','PRODUCT_STORAGE')) --상품창고제외
		--[C20200403-000062]
		AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
								WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
									AND VALID_YN = 'Y'
								)	-- 사외 창고 제외 LOOKUP 관리
) X



