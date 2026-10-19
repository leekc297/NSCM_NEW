/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO
 * Description  : SHIP_PLAN cutoff정보 생성(법인별 당일재고 생성후 전일 PLAN정보  cutoff 생성)   
 *					PR_SSP_ANL_SHIP_PLAN_CUTOFF 복사하여 생성
 * OutTable     :
 * Execute      : PR_SSP_PLN_SHIP_PLAN_CUTOFF 에서 호출 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.06.09	강주용			[E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경 
 * 2026.08.13	강주용			[E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
*/

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_CUTOFF_FP_AUTO]
( 
      @p_company_id               NVARCHAR(30)
	 ,@p_plan_start_yyyymmdd      NVARCHAR(8)
	 ,@r_error_msg                NVARCHAR(1000)  OUTPUT 
) 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;


	DECLARE @v_company_id  NVARCHAR(30); --속도개선을 위해 별도 DECLARE , SET설정 
	SET     @v_company_id = @p_company_id ;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  

	DECLARE @v_app_type    NVARCHAR(8) = 'SSP'; -- E20260305-001301 프로즌구간을 주차로 관리할때 계획구간 생성 오류 수정

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	SET     @v_plan_start_yyyymmdd = @p_plan_start_yyyymmdd ;

	DECLARE @v_division_id    NVARCHAR(100) = '';
	--  SET     @v_division_id =  '81,82' ; -- 자동차(81),ESS(82) 만 사용
	    SET @v_division_id = STUFF((SELECT ',' + DIVISION_ID
                                      FROM SCM_MST_DIVISION WITH(NOLOCK)
                                     WHERE VALID_YN = 'Y'
                                       AND ATTRIBUTE3 IN ('81','82')
                                    FOR XML PATH ('')
                                   ), 1, 1, '') 

	-- DATA 생성 FROM ~ TO 
    DECLARE @v_data_start_yyyymmdd  NVARCHAR(8) = '';
	DECLARE @v_data_end_yyyymmdd    NVARCHAR(8) = '';

	SET  @v_data_start_yyyymmdd = @v_plan_start_yyyymmdd ; 
	SET  @v_data_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, 56, CONVERT(DATETIME, @v_data_start_yyyymmdd ,112)) ,112) ; --8주(56일)   
	
	DECLARE @v_cutoff_next_date    NVARCHAR(8) = CONVERT(VARCHAR, DATEADD(D, 1, CAST(@v_plan_start_yyyymmdd as datetime)), 112);

       --RETURN 1
 
    BEGIN TRY
		BEGIN

        ------------------------------------------------------------------------------------------------------------- 
        --2. MEASURE별 Data생성 
        ------------------------------------------------------------------------------------------------------------- 
        --temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서
        IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_C') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_C

			CREATE TABLE #tmp_SSP_ANL_SHIP_PLAN_C(
				 DIVISION_ID  				nvarchar(030)
				,COMPANY_ID                 nvarchar(030)
				,PLAN_START_YYYYMMDD		nvarchar(008)
				,ITEM_ID					nvarchar(050)
				,FROM_SITE					nvarchar(030)
				,TO_SITE					nvarchar(030)
				,MEASURE					nvarchar(050)
				,YYYYMMDD					nvarchar(008)
				,BOD_ID						nvarchar(150)
				,QTY						numeric(20,10)
				,ROUTE_ID					INT	
				,INCOTERMS					nvarchar(010)   
				,TRANSPORT_MODE				nvarchar(050)    
				,PROJECT_CODE				nvarchar(050)
				,FCST_TYPE					nvarchar(020)
				,FCST_ETD_DATE				nvarchar(008)
				,FCST_ETA_DATE				nvarchar(008)
				,ETD_DATE					nvarchar(008)
				,ETA_DATE					nvarchar(008)
				,CONFIRM_FLAG				nvarchar(020)
				,CONFIRM_ID					nvarchar(020)
				,REQUESTOR                  nvarchar(150)
				,ATTRIBUTE1                 nvarchar(150)  -- LOT_SIZE_YN 
				,LOT_SIZE					INT
				,RATE						INT	-- 생산수량 재고로 남기는 비율
            );

		------------------------------------------------------------------------------------------------------------- 
		--2-1.일자별 WH_STOC 계산  : 당일 WH_STOC = EPR재고수량 + MES Available 수량(= Total 수량 - OQC NG수량-  MES/QMS Hold수량)
		--, 익일 WH_STOC = 전일 WH_STOC + 전일 PROD_PLAN - 전일SHIP_PLAN - 전일INTN_MOVEMENT             
		-- [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
		-- BOH : MES + OWMS (20210716, 요청자 김광희)
		------------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID('tempdb..#tmp_BOH') IS NOT NULL
            DROP TABLE #tmp_BOH

		CREATE TABLE #tmp_BOH(
			 DIVISION_ID			nvarchar(030)
			,COMPANY_ID				nvarchar(030)
			,PLAN_START_YYYYMMDD	nvarchar(008)
			,ITEM_ID				nvarchar(050)
			,FROM_SITE				nvarchar(030)
			,QTY					numeric(20,10)
        );


		INSERT INTO #tmp_BOH
		SELECT   X.DIVISION_ID           AS DIVISION_ID
		,        X.COMPANY_ID            AS COMPANY_ID
		,        @v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD 
		,        X.ITEM_ID               AS ITEM_ID
		,        X.FROM_SITE             AS FROM_SITE 
		,        SUM(X.QTY)              AS QTY 
		FROM (
				--SELECT W.DIVISION_ID
				--,      W.COMPANY_ID 
				--,      W.ITEM_ID            
				--,      W.SCM_SITE_ID           AS FROM_SITE
				--,      W.SSP_QTY          AS QTY 

				--FROM SCM_DNM_STOCK_V W WITH(NOLOCK)
				--		JOIN SCM_MST_LOCATION L WITH(NOLOCK) 
				--		ON L.DIVISION_ID = W.DIVISION_ID 
				--		AND L.PLANT_ID = W.PLANT_ID
				--		AND L.SCM_SITE_ID = W.SCM_SITE_ID
				--		AND L.STORAGE_ID = W.STORAGE_ID
				--		AND L.LOCATION_CODE  IN ('PACK_OWMS' ,'CELL_OWMS') -- , 'CMA_BMA')
				--	JOIN SCM_MST_SITE S WITH(NOLOCK) 
				--		ON S.DIVISION_ID = L.DIVISION_ID
				--		AND S.PLANT_ID    = L.PLANT_ID
				--		AND S.SCM_SITE_ID = L.SCM_SITE_ID 
				--		AND S.SITE_TYPE  = 'PLANT'
				--WHERE W.COMPANY_ID = @v_company_id
				--AND   CONVERT(VARCHAR(8), W.CUTOFF_DATE, 112) = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
				--AND   W.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 

				--UNION ALL

				-- MES Available = Total 수량 - OQC NG수량-  MES/QMS Hold수량
				SELECT  M.DIVISION_ID            AS DIVISION_ID 
				,       M.COMPANY_ID             AS COMPANY_ID  
				,       M.ITEM_ID                AS ITEM_ID 
				,       M.FROM_SITE              AS FROM_SITE 
				,       ISNULL(LOT_QTY, 0) 
						- CASE WHEN AVAILABLE_YN = 'N' AND OQC_INSP_RESULT = 'N' THEN ISNULL(LOT_QTY, 0)  ELSE 0  END 
						- CASE WHEN AVAILABLE_YN = 'N' AND (QMS_HOLD_YN = 'Y' OR MES_HOLD_YN = 'Y') THEN ISNULL(LOT_QTY, 0) ELSE 0  END AS QTY 
				FROM SSP_DNM_GMES_STOCK_81_82 M WITH(NOLOCK) 
				WHERE M.COMPANY_ID = @v_company_id
				AND   M.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				AND   M.YYYYMMDD  = @v_plan_start_yyyymmdd

				UNION ALL 
				-- [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
				SELECT W.DIVISION_ID
				,      W.COMPANY_ID 
				,      W.ITEM_ID            
				,      W.SCM_SITE_ID      AS FROM_SITE
				,      W.SSP_QTY          AS QTY 
				FROM  SSP_DNM_ESS_PACKER_STOCK_V W WITH(NOLOCK) -- SSP_DNM_ESS_PACKER_STOCK_V W WITH(NOLOCK) 
				WHERE W.COMPANY_ID = @v_company_id
				AND   CONVERT(VARCHAR(8), W.CUTOFF_DATE, 112) = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
				AND   W.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 

				UNION ALL
				--OWMS
				SELECT W.DIVISION_ID
						, W.COMPANY_ID
						, W.ITEM_ID
						, W.FROM_SITE
						, SUM(W.AVAILABLE_QTY)		AS QTY
				FROM SSP_ANL_OWMS_STOCK_C2 AS W WITH(NOLOCK)
						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
					ON L.LOOKUP_TYPE = 'OWMS_STOCK_STATUS'				--C20220419-000607
					AND L.VALID_YN = 'Y'
					AND L.ATTRIBUTE1 = 'Y'
					AND L.SEGMENT1    = W.STOCK_STATUS		
			
				WHERE 1 = 1
				AND W.COMPANY_ID = @p_company_id
				AND W.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				AND W.CUTOFF_DATE = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
				GROUP BY W.DIVISION_ID, W.COMPANY_ID, W.ITEM_ID, W.FROM_SITE

				) X
		GROUP BY X.DIVISION_ID 
		,        X.COMPANY_ID
		,        X.ITEM_ID
		,        X.FROM_SITE 
		;

		------------------------------------------------------------------------------------------------------------- 
		--2-2. [S]INTN_MOVEMENT(Internal movement) : 법인간 이동(SCM_DNM_CELL_INHOUSE_PLAN_SN) CATEGORY = 'MOVING'
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
			(
				DIVISION_ID  				
			,COMPANY_ID           
			,PLAN_START_YYYYMMDD	
			,ITEM_ID				
			,FROM_SITE			
			,TO_SITE				
			,MEASURE				
			,YYYYMMDD				
			,BOD_ID					
			,QTY						
			,ROUTE_ID				
			,INCOTERMS			
			,TRANSPORT_MODE	
			,PROJECT_CODE		
			,FCST_TYPE			
			,FCST_ETD_DATE	
			,FCST_ETA_DATE	
			,ETD_DATE				
			,ETA_DATE				
			,CONFIRM_FLAG		
			,CONFIRM_ID
			,REQUESTOR				     
			)
		SELECT 
				M.DIVISION_ID  				
			,M.COMPANY_ID           
			,@v_plan_start_yyyymmdd  AS  PLAN_START_YYYYMMDD	
			,M.ITEM_ID				
			,FS.SCM_SITE_ID AS FROM_SITE			
			,'-'  AS TO_SITE				
			,'INTN_MOVEMENT'   AS MEASURE				
			,CONVERT(VARCHAR(8), M.PLAN_DATE , 112) AS YYYYMMDD				
			,'-'  AS BOD_ID					
			,SUM(M.QTY) AS QTY 						
			,NULL AS ROUTE_ID				
			,'-'  AS INCOTERMS			
			,'-'  AS TRANSPORT_MODE	
			,'-'  AS PROJECT_CODE		
			,'-'  AS FCST_TYPE			
			,NULL AS FCST_ETD_DATE	
			,NULL AS FCST_ETA_DATE	
			,NULL AS ETD_DATE				
			,NULL AS ETA_DATE				
			,NULL AS CONFIRM_FLAG		
			,'-'  AS CONFIRM_ID
			,NULL AS REQUESTOR	
		FROM SCM_DNM_CELL_INHOUSE_PLAN_SN M WITH(NOLOCK)
			JOIN SCM_MST_SITE FS WITH(NOLOCK) 
				ON FS.DIVISION_ID = M.DIVISION_ID 
				AND FS.PLANT_ID    = M.PLANT_ID 
				AND FS.SITE_TYPE   = 'PLANT'
				AND FS.OSP_YN      = 'N'
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
				ON T.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND T.VALID_YN	   = 'Y'
				AND T.SEGMENT1    = FS.DIVISION_ID
				AND T.SEGMENT2    = FS.SCM_SITE_ID
				AND T.SEGMENT4    = M.ITEM_ID  
		WHERE M.CATEGORY   =  'MOVING'
		AND   M.COMPANY_ID = @v_company_id 
		AND   CONVERT(VARCHAR(8), M.PLAN_DATE, 112) >= @v_data_start_yyyymmdd  
		AND   CONVERT(VARCHAR(8), M.PLAN_DATE, 112) < @v_data_end_yyyymmdd 
		AND   M.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,','))  
		AND   EXISTS ( SELECT 1 
			            FROM   #tmp_SSP_ANL_SHIP_PLAN_C T WITH(NOLOCK) 
						WHERE  T.DIVISION_ID = M.DIVISION_ID 
						AND    T.COMPANY_ID  = M.COMPANY_ID 
						AND    T.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    T.FROM_SITE = FS.SCM_SITE_ID
						AND    T.ITEM_ID = M.ITEM_ID 
						AND    T.MEASURE IN ( /*'SHIP_REQ',*/'SHIP_PLAN','PROD_PLAN')
						) 
		GROUP BY 
			 M.DIVISION_ID  				
			,M.COMPANY_ID           
			,M.ITEM_ID				
			,FS.SCM_SITE_ID 	
			,CONVERT(VARCHAR(8), M.PLAN_DATE , 112) 
		;

		------------------------------------------------------------------------------------------------------------- 
		--2-3. [P]PROD_PLAN(Production)         : SCM_DNM_PLAN_FROZEN_V 
		------------------------------------------------------------------------------------------------------------- 
		/*	Pack : P5500, P9500
			Cell : F5300, F5500, F5600, F6000 
        - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 
		------------------------------------------------------------------------------------------------------------- */
		-- PROD_PLAN Data 생성  
		INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
			(
			DIVISION_ID  				
			,COMPANY_ID           
			,PLAN_START_YYYYMMDD	
			,ITEM_ID				
			,FROM_SITE			
			,TO_SITE				
			,MEASURE				
			,YYYYMMDD				
			,BOD_ID					
			,QTY						
			,ROUTE_ID				
			,INCOTERMS			
			,TRANSPORT_MODE	
			,PROJECT_CODE		
			,FCST_TYPE			
			,FCST_ETD_DATE	
			,FCST_ETA_DATE	
			,ETD_DATE				
			,ETA_DATE				
			,CONFIRM_FLAG		
			,CONFIRM_ID
			,REQUESTOR				     
			)
		SELECT   X.DIVISION_ID  				
				,X.COMPANY_ID           
				,@v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD	
				,X.ITEM_ID				 AS ITEM_ID 
				,X.FROM_SITE             AS FROM_SITE			
				,'-'					 AS TO_SITE				
				,'PROD_PLAN'             AS MEASURE				
				,X.YYYYMMDD              AS YYYYMMDD				
				,'-'					 AS BOD_ID					
				,SUM(X.QTY)              AS QTY 						
				,NULL                    AS ROUTE_ID				
				,'-'					 AS INCOTERMS			
				,'-'					 AS TRANSPORT_MODE	
				,'-'					 AS PROJECT_CODE		
				,'-'					 AS FCST_TYPE			
				,NULL				     AS FCST_ETD_DATE	
				,NULL                    AS FCST_ETA_DATE	
				,NULL                    AS ETD_DATE				
				,NULL                    AS ETA_DATE				
				,NULL                    AS CONFIRM_FLAG		
				,'-'                     AS CONFIRM_ID
				,NULL                    AS REQUESTOR	
		FROM   (
				--SELECT 
				--	 P.DIVISION_ID   AS DIVISION_ID				
				--	,P.COMPANY_ID    AS COMPANY_ID         
				--	,P.ITEM_ID		 AS ITEM_ID		
				--	,P.SCM_SITE_ID   AS FROM_SITE			
				--	,CONVERT(VARCHAR(8), P.PLAN_DATE , 112) AS YYYYMMDD				
				--	,P.PLAN_QTY      AS QTY 						
				--	,'COMMON'        AS TYPE
				--FROM  SCM_DNM_PLAN_FROZEN_V P WITH(NOLOCK) 
				--WHERE OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
				--AND   CONVERT(VARCHAR(8), P.PLAN_DATE , 112) >= @v_data_start_yyyymmdd  
				--AND   CONVERT(VARCHAR(8), P.PLAN_DATE , 112)  < @v_data_end_yyyymmdd 
				--AND   P.COMPANY_ID = @v_company_id 
				--AND   P.SCM_SITE_ID IS NOT NULL 
				--AND   P.PLAN_QTY > 0 
				--AND   P.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				SELECT 
						P.DIVISION_ID   AS DIVISION_ID				
					,P.COMPANY_ID    AS COMPANY_ID         
					,P.ITEM_ID		 AS ITEM_ID		
					,P.SCM_SITE_ID   AS FROM_SITE			
					,P.PLAN_DATE     AS YYYYMMDD				
					,P.PLAN_QTY      AS QTY 						
					,'COMMON'        AS TYPE
				FROM  SSP_DNM_FP_PLAN_FROZEN AS P WITH(NOLOCK) 
				-- START [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
				-- 원본 WHERE OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000')
				WHERE OPERATION_ID IN ('P5500', 'P9500', 'F5300', 'F5500', 'F5600', 'F6000', 'PL500')
				-- END [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
				AND   PLAN_DATE >= @v_data_start_yyyymmdd  
				AND   PLAN_DATE  < @v_data_end_yyyymmdd 
				AND   P.COMPANY_ID = @v_company_id 
				AND   P.SCM_SITE_ID IS NOT NULL 
				AND   P.PLAN_QTY > 0 
				AND   P.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 

				UNION ALL 
				-- [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure)
				SELECT P.DIVISION_ID  AS DIVISION_ID
				,      S.COMPANY_ID   AS COMPANY_ID
				,      P.ITEM_ID      AS ITEM_ID	
				,      P.SCM_SITE_ID  AS FROM_SITE
				,      P.YYYYMMDD     AS YYYYMMDDD   
				,      P.QTY          AS QTY
				,      'ESS-PACKER'   AS TYPE
				FROM SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK) 
				JOIN (
						SELECT TOP 1 
								A.DIVISION_ID 
						,      A.PLAN_START_YYYYMMDD 
						,      A.PLAN_TYPE 
						,      A.PLAN_SEQ   AS SEQ 
						FROM   SCP_PLAN_VERSION_V A WITH(NOLOCK) 
						WHERE  A.DIVISION_ID  = '82' -- ESS(82)만 적용 
						AND    A.PLAN_CYCLE   = 'WEEKLY'
						AND    A.PLAN_TYPE NOT IN ('TE', 'TM')
						ORDER BY PLAN_START_YYYYMMDD DESC , PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC 
					) V 
					ON V.DIVISION_ID = P.DIVISION_ID 
					AND V.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
					AND V.PLAN_TYPE = P.PLAN_TYPE 
					AND V.SEQ       = P.SEQ 
				JOIN SCM_MST_SITE S WITH(NOLOCK) 
					ON S.DIVISION_ID = P.DIVISION_ID 
					AND S.SCM_SITE_ID = P.SCM_SITE_ID 
					AND S.SITE_TYPE = 'PLANT'
					AND S.OSP_YN = 'Y' AND VALID_YN = 'Y'
				WHERE P.DIVISION_ID = '82' -- ESS(82)만 적용 
				AND   S.COMPANY_ID  = @v_company_id
				AND   P.MEASURE = 'PROD_PLAN_AMEND'
				AND   P.QTY > 0  
				AND   P.YYYYMMDD >= @v_data_start_yyyymmdd
				AND   P.YYYYMMDD <  @v_data_end_yyyymmdd

				UNION ALL
				-- A/S PLANT ETA 기준 
				SELECT C.DIVISION_ID            AS DIVISION_ID
                        ,C.TO_SITE_COMPANY_ID     AS COMPANY_ID
	                    ,C.ITEM_ID                AS ITEM_ID
	                    ,C.TO_SITE                AS FROM_SITE
	                    ,C.ETA_DATE               AS YYYYMMDD
	                    ,C.QTY                    AS QTY
	                    ,'AS'                     AS TYPE
                    FROM SSP_ANL_SHIP_CONFIRM AS C WITH(NOLOCK)
                        JOIN SCM_MST_SITE AS TS WITH(NOLOCK)
                    ON C.DIVISION_ID = TS.DIVISION_ID
                    AND C.TO_SITE = TS.SCM_SITE_ID
                    AND TS.OPERATION_GROUP = 'W'
                    AND TS.SITE_TYPE = 'PLANT'
                    AND TS.VALID_YN = 'Y'
                WHERE C.TO_SITE_COMPANY_ID = @v_company_id   
                    AND C.QTY		> 0
					AND C.ETA_DATE >= @v_data_start_yyyymmdd
					AND C.ETA_DATE <  @v_data_end_yyyymmdd
					AND C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
		) X
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
		ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
		AND T.VALID_YN	  = 'Y'
		AND T.SEGMENT1    = X.DIVISION_ID
		AND T.SEGMENT2    = X.FROM_SITE
		AND T.SEGMENT4    = X.ITEM_ID  
		JOIN SCM_MST_ITEM_SN AS I WITH(NOLOCK)--PACK 인것만
		ON X.DIVISION_ID  = I.DIVISION_ID		
		AND X.COMPANY_ID  = I.COMPANY_ID
		AND X.ITEM_ID	  = I.ITEM_ID			
		AND I.SCP_OPERATION_GROUP = 'P'
		GROUP BY X.DIVISION_ID 
		,      X.COMPANY_ID   
		,      X.ITEM_ID      
		,      X.FROM_SITE    
		,      X.YYYYMMDD    
		;

		------------------------------------------------------------------------------------------------------------- 
		--2-4. [S]SHIP_PLAN(Shipment Plan): 출하확정 + 출하요청 (확정구간 : SCM_MST_SITE.SHIP_FROZEN) 
		-------------------------------------------------------------------------------------------------------------
		--     확정구간 : 출하확정(SSP_ANL_SHIP_CONFIRM)
		--     확정구간 이후 : 출하확정(SSP_ANL_SHIP_CONFIRM) + 생산계획(PROD_PLAN) 
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
			(
			DIVISION_ID  				
			,COMPANY_ID           
			,PLAN_START_YYYYMMDD	
			,ITEM_ID				
			,FROM_SITE			
			,TO_SITE				
			,MEASURE				
			,YYYYMMDD				
			,BOD_ID					
			,QTY						
			,ROUTE_ID				
			,INCOTERMS			
			,TRANSPORT_MODE	
			,PROJECT_CODE		
			,FCST_TYPE			
			,FCST_ETD_DATE	
			,FCST_ETA_DATE	
			,ETD_DATE				
			,ETA_DATE				
			,CONFIRM_FLAG		
			,CONFIRM_ID
			,REQUESTOR			
			,LOT_SIZE
			,RATE
			)
		SELECT 	 X.DIVISION_ID  				
				,@v_company_id			  AS  COMPANY_ID           
				,@v_plan_start_yyyymmdd	  AS PLAN_START_YYYYMMDD	
				,X.ITEM_ID				
				,X.FROM_SITE			
				,X.TO_SITE				
				,'SHIP_PLAN'    AS MEASURE				
				,X.YYYYMMDD				
				,X.BOD_ID					
				,SUM(X.QTY)     AS QTY 						
				,X.ROUTE_ID				
				,X.INCOTERMS			
				,X.TRANSPORT_MODE	
				,X.PROJECT_CODE		
				,X.FCST_TYPE			
				,X.FCST_ETD_DATE	
				,X.FCST_ETA_DATE	
				,X.ETD_DATE				
				,X.ETA_DATE				
				,X.CONFIRM_FLAG		
				,X.CONFIRM_ID		
				,X.REQUESTOR		 
				,L.LOT_SIZE
				,X.RATE
		FROM (  
				SELECT 
				C.DIVISION_ID  				
				,C.ITEM_ID				
				,C.FROM_SITE			
				,C.TO_SITE				
				,C.YYYYMMDD				
				,C.BOD_ID					
				,C.QTY						
				,C.ROUTE_ID				
				--,C.INCOTERMS			
				-- 2020.09.16  INCOTERMS-> SSP_INCOTERMS 로 COLUMN 변경
				,ISNULL(B.SSP_INCOTERMS, C.INCOTERMS)   AS INCOTERMS -- R.INCOTERMS			
				,C.TRANSPORT_MODE	
				,C.PROJECT_CODE		
				,C.FCST_TYPE			
				,C.FCST_ETD_DATE	
				,C.FCST_ETA_DATE	
				,C.ETD_DATE				
				,C.ETA_DATE				
				,'Y'        AS   CONFIRM_FLAG		
				,C.CONFIRM_ID		
				,C.REQUESTOR	
				, IIF(ISNUMERIC(T.ATTRIBUTE1) = 0, NULL, T.ATTRIBUTE1) AS RATE
				FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 

				LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
				ON B.DIVISION_ID = C.DIVISION_ID
				AND B.BOD_ID       = C.BOD_ID

				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
				ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
				AND T.VALID_YN	  = 'Y'
				AND T.SEGMENT1    = C.DIVISION_ID
				AND T.SEGMENT2    = C.FROM_SITE
				AND T.SEGMENT3    = C.TO_SITE
				AND T.SEGMENT4    = C.ITEM_ID  

				LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				ON L.DIVISION_ID     = C.DIVISION_ID 
				AND L.FROM_SITE      = C.FROM_SITE
				AND L.TO_SITE        = C.TO_SITE
				AND L.ITEM_ID        = C.ITEM_ID   
				AND L.TRANSPORT_MODE = C.TRANSPORT_MODE
				AND L.VALID_YN       = 'Y'
				--AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 

				WHERE C.YYYYMMDD BETWEEN  @v_plan_start_yyyymmdd AND @v_data_end_yyyymmdd
				AND   C.CHANGE_TYPE = 'C' -- 확정
				AND   [DBO].[FN_GET_SSP_SITE_INFO](C.DIVISION_ID, C.FROM_SITE, 'COMPANY_ID') = @v_company_id 
				AND   C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				UNION ALL 
				--확정기간 이후 출하요청 
				SELECT 
				R.DIVISION_ID  				
				,R.ITEM_ID				
				,R.FROM_SITE			
				,T.SEGMENT3 AS TO_SITE				
				,R.YYYYMMDD				
				,B.BOD_ID					
				,R.QTY						
				,B.ROUTE_ID				
				,B.SSP_INCOTERMS AS INCOTERMS		
				,B.TRANSPORT_MODE	
				,R.PROJECT_CODE		
				,R.FCST_TYPE			
				--,R.FCST_ETD_DATE	
				--,R.FCST_ETA_DATE	
				--,R.ETD_DATE				
				--,R.ETA_DATE				
				,R.YYYYMMDD	 AS FCST_ETD_DATE
				,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
				,R.YYYYMMDD	 AS ETD_DATE								
				,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS ETA_DATE			
				,'N'        AS   CONFIRM_FLAG		
				,R.CONFIRM_ID	
				,R.REQUESTOR	
				, IIF(ISNUMERIC(T.ATTRIBUTE1) = 0, NULL, T.ATTRIBUTE1) AS RATE
				FROM #tmp_SSP_ANL_SHIP_PLAN_C R WITH(NOLOCK) 
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
				ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
				AND T.VALID_YN	  = 'Y'
				AND T.SEGMENT1    = R.DIVISION_ID
				AND T.SEGMENT2    = R.FROM_SITE
				AND T.SEGMENT4    = R.ITEM_ID  
				JOIN SCP_MST_BOD_N_V B WITH(NOLOCK) 
				ON B.DIVISION_ID = T.SEGMENT1
				AND B.BOD_ID     = T.SEGMENT5

				WHERE 1=1 
					AND   R.MEASURE = 'PROD_PLAN'
					AND   R.YYYYMMDD >= CASE WHEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.DIVISION_ID, R.FROM_SITE, @v_plan_start_yyyymmdd) <= 0 THEN @v_plan_start_yyyymmdd
										     ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.DIVISION_ID, R.FROM_SITE, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
										END
					AND   R.YYYYMMDD < @v_data_end_yyyymmdd 
					AND   R.COMPANY_ID = @v_company_id 
					AND   R.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
					AND   EXISTS (SELECT 1  -- 컴펌 수량이 있는 건은 제외
						   FROM   SSP_ANL_SHIP_CONFIRM X WITH(NOLOCK) 
						   WHERE X.DIVISION_ID         = R.DIVISION_ID
							AND X.FROM_SITE_COMPANY_ID = R.COMPANY_ID          
							AND X.ITEM_ID              = R.ITEM_ID             
							AND X.FROM_SITE            = R.FROM_SITE           
							AND X.TO_SITE              = R.TO_SITE             
							AND X.YYYYMMDD             = R.YYYYMMDD            
						   )
				  ) X
			LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				ON L.DIVISION_ID     = X.DIVISION_ID 
				AND L.FROM_SITE      = X.FROM_SITE
				AND L.TO_SITE        = X.TO_SITE
				AND L.ITEM_ID        = X.ITEM_ID   
				AND L.TRANSPORT_MODE = X.TRANSPORT_MODE
				AND L.VALID_YN       = 'Y'
				--AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
			JOIN SCM_MST_ITEM_SN AS I WITH(NOLOCK)--PACK 인것만
			ON X.DIVISION_ID  = I.DIVISION_ID		
			AND @v_company_id = I.COMPANY_ID
			AND X.ITEM_ID	  = I.ITEM_ID			
			AND I.SCP_OPERATION_GROUP = 'P'
			GROUP BY X.DIVISION_ID  				
					,X.ITEM_ID				
					,X.FROM_SITE			
					,X.TO_SITE				
					,X.YYYYMMDD				
					,X.BOD_ID					
					,X.ROUTE_ID				
					,X.INCOTERMS			
					,X.TRANSPORT_MODE	
					,X.PROJECT_CODE		
					,X.FCST_TYPE			
					,X.FCST_ETD_DATE	
					,X.FCST_ETA_DATE	
					,X.ETD_DATE				
					,X.ETA_DATE				
					,X.CONFIRM_FLAG		
					,X.CONFIRM_ID		
					,X.REQUESTOR	
					,L.LOT_SIZE
					,X.RATE
            ;
						
 			-------------------------------------------------------------------------------------------------------------             
			--2-5. 존재하지 않는 경우, 해당 SHIP_PLAN MEASURE를 0으로 추가  
			-------------------------------------------------------------------------------------------------------------   
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
				(
				 DIVISION_ID  	     
                ,COMPANY_ID 
				,PLAN_START_YYYYMMDD 
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	
				,FCST_TYPE
				,CONFIRM_ID		
				,LOT_SIZE
				,RATE
				)        
			SELECT   
				 SUB.DIVISION_ID
                ,SUB.COMPANY_ID
				,SUB.PLAN_START_YYYYMMDD
				,SUB.ITEM_ID
				,SUB.FROM_SITE
				,SUB.TO_SITE
				,SUB.MEASURE
				,SUB.YYYYMMDD
				,SUB.BOD_ID
				,0              AS QTY                      
				,SUB.INCOTERMS
				,SUB.TRANSPORT_MODE
				,SUB.PROJECT_CODE
				,SUB.FCST_TYPE
				,'-' AS CONFIRM_ID 
				,SUB.LOT_SIZE
				,SUB.RATE
			FROM     
				(    
					SELECT   DIVISION_ID
					        ,COMPANY_ID
							,PLAN_START_YYYYMMDD
							,ITEM_ID
							,FROM_SITE
							,TO_SITE
							,MEASURE
							,YYYYMMDD
							,BOD_ID
							,INCOTERMS
							,TRANSPORT_MODE
							,PROJECT_CODE
							,FCST_TYPE
							,LOT_SIZE
							,RATE
						FROM    
							(   -- 56 DAYS (7*8) 
								SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
								FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
								WHERE 1=1  
								AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
								AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd 
							) A,    
							(    
								SELECT --DISTINCT   
									 DIVISION_ID
									,COMPANY_ID
									,PLAN_START_YYYYMMDD
									,ITEM_ID
									,FROM_SITE
									,MAX(TO_SITE) AS TO_SITE
									,'SHIP_PLAN' AS MEASURE
									,'-' AS BOD_ID
									,'-' AS INCOTERMS
									,'-' AS TRANSPORT_MODE
									,'-' AS PROJECT_CODE
									,'-' AS FCST_TYPE
									,MAX(LOT_SIZE) AS LOT_SIZE
									,MAX(RATE) AS RATE
								FROM  #tmp_SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK)   
								WHERE 1=1  
								AND   X.MEASURE IN ('SHIP_PLAN','PROD_PLAN')
								GROUP BY DIVISION_ID
									   , COMPANY_ID
									   , PLAN_START_YYYYMMDD
									   , ITEM_ID
									   , FROM_SITE
									   --, LOT_SIZE
							) B    
				) SUB    
				WHERE 1=1    
					AND NOT EXISTS (    
									SELECT 'X'    
										FROM #tmp_SSP_ANL_SHIP_PLAN_C Z WITH(NOLOCK)     
									WHERE 1=1    
										AND Z.DIVISION_ID         = SUB.DIVISION_ID    
										AND Z.COMPANY_ID          = SUB.COMPANY_ID          
										AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD        
										AND Z.ITEM_ID             = SUB.ITEM_ID   										            
										AND Z.FROM_SITE           = SUB.FROM_SITE       
										AND Z.TO_SITE             = SUB.TO_SITE    
										AND Z.MEASURE             = SUB.MEASURE      										     										                                                    
										AND Z.YYYYMMDD            = SUB.YYYYMMDD     
										AND Z.MEASURE			  = 'SHIP_PLAN'
									)

				-- TO_SITE / LOT_SIZE 갱신
				UPDATE C
				   SET C.TO_SITE  = T.SEGMENT3
				     , C.LOT_SIZE = L.LOT_SIZE
					 , C.RATE	  = IIF(ISNUMERIC(T.ATTRIBUTE1) = 0, NULL, T.ATTRIBUTE1)
				  FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK)
				  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
					ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
				   AND T.VALID_YN	  = 'Y'
				   AND T.SEGMENT1     = C.DIVISION_ID
				   AND T.SEGMENT2     = C.FROM_SITE
				   AND T.SEGMENT4     = C.ITEM_ID  
				  JOIN SCP_MST_BOD_N_V B WITH(NOLOCK) 
				    ON B.DIVISION_ID  = T.SEGMENT1
				   AND B.BOD_ID       = T.SEGMENT5
				  LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				    ON L.DIVISION_ID    = C.DIVISION_ID 
				   AND L.FROM_SITE      = C.FROM_SITE
				   AND L.TO_SITE        = T.SEGMENT3
				   AND L.ITEM_ID        = C.ITEM_ID   
				   AND L.TRANSPORT_MODE = B.TRANSPORT_MODE
				   AND L.VALID_YN       = 'Y'
				   --AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
				 WHERE C.MEASURE	    = 'SHIP_PLAN'
				   AND (ISNULL(C.TO_SITE, '-') = '-' OR C.LOT_SIZE IS NULL)
				;
				-------------------------------------------------------------------------------------------------------------             
				--2-5. SHIP_PLAN, BALANCE, WH_STOCK 일자별 생성
				-------------------------------------------------------------------------------------------------------------   
				-- SHIP_PLAN : WH_STOCK(전일자) + BALANCE(전일자) / LOT SIZE 정수형 값
				-- BALANCE   : WH_STOCK(전일자) + BALANCE(전일자) / LOT SIZE 나머지 값
				-- WH_STOCK  : PROD_PLAN + BALANCE 
				-------------------------------------------------------------------------------------------------------------   
				IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_PLAN_P')
								BEGIN
								   CLOSE CUR_PLAN_P ;
								   DEALLOCATE CUR_PLAN_P ;
								END

				--CURSOR 선언 
				DECLARE @DIVISION_ID  				nvarchar(030)
						,@COMPANY_ID                nvarchar(030)
						,@PLAN_START_YYYYMMDD		nvarchar(008)
						,@ITEM_ID					nvarchar(050)
						,@FROM_SITE					nvarchar(030)
						,@TO_SITE					nvarchar(030)
						,@MEASURE					nvarchar(050)
						,@YYYYMMDD					nvarchar(008)
						,@BOD_ID					nvarchar(150)
						,@QTY						numeric(20,10)
						,@ROUTE_ID					INT	
						,@INCOTERMS					nvarchar(010)   
						,@TRANSPORT_MODE			nvarchar(050)    
						,@PROJECT_CODE				nvarchar(050)
						,@FCST_TYPE					nvarchar(020)
						,@FCST_ETD_DATE				nvarchar(008)
						,@FCST_ETA_DATE				nvarchar(008)
						,@ETD_DATE					nvarchar(008)
						,@ETA_DATE					nvarchar(008)
						,@CONFIRM_FLAG				nvarchar(020)
						,@CONFIRM_ID				nvarchar(020)
						,@REQUESTOR                 nvarchar(150)
						,@ATTRIBUTE1                nvarchar(150)  -- LOT_SIZE_YN 
						,@LOT_SIZE					INT
						,@RATE						INT
						;

				--DECLARE @tmpFrozenCnt INT;--확정데이터 생성 구간 계산용
				DECLARE @tmpMOVE_QTY INT;
				DECLARE @tmpBALANCE INT;
				DECLARE @tmpWH_STOCK INT;
				DECLARE @tmpCFM_QTY INT;
				DECLARE @tmpSP_QTY INT;
				DECLARE @tmpFP_QTY INT;
				DECLARE @idx INT = 0;
				
				DECLARE CUR_PLAN_P CURSOR FOR  

				SELECT DIVISION_ID, COMPANY_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD, BOD_ID, QTY,ROUTE_ID
				     , INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_FLAG, CONFIRM_ID
					 , REQUESTOR, ATTRIBUTE1, LOT_SIZE, RATE
				  FROM #tmp_SSP_ANL_SHIP_PLAN_C
				 WHERE MEASURE = 'SHIP_PLAN'
				 ORDER BY DIVISION_ID, COMPANY_ID, PLAN_START_YYYYMMDD, ITEM_ID, FROM_SITE, TO_SITE, MEASURE, YYYYMMDD;

				OPEN CUR_PLAN_P; 

				FETCH NEXT FROM CUR_PLAN_P INTO @DIVISION_ID  				
												,@COMPANY_ID                
												,@PLAN_START_YYYYMMDD		
												,@ITEM_ID					
												,@FROM_SITE					
												,@TO_SITE					
												,@MEASURE					
												,@YYYYMMDD					
												,@BOD_ID					
												,@QTY						
												,@ROUTE_ID					
												,@INCOTERMS					
												,@TRANSPORT_MODE			
												,@PROJECT_CODE				
												,@FCST_TYPE					
												,@FCST_ETD_DATE				
												,@FCST_ETA_DATE				
												,@ETD_DATE					
												,@ETA_DATE					
												,@CONFIRM_FLAG				
												,@CONFIRM_ID				
												,@REQUESTOR                 
												,@ATTRIBUTE1
												,@LOT_SIZE
												,@RATE;

				WHILE(@@FETCH_STATUS = 0) 
																																																																																																																																																													BEGIN; 
				--Idx 1씩 증가 
				SET @idx = @idx + 1 
				SET @tmpMOVE_QTY = 0;
				SET @tmpCFM_QTY = 0;
				SET @tmpBALANCE = 0;
				SET @tmpWH_STOCK = 0;
				SET @tmpSP_QTY = 0;
				SET @tmpFP_QTY = 0;
				
				-- 전일자 재고 조회
				IF @PLAN_START_YYYYMMDD = @YYYYMMDD
					BEGIN
						SELECT TOP 1 
								@tmpWH_STOCK = ISNULL(B.QTY, 0)
						FROM #tmp_BOH B WITH(NOLOCK)
						WHERE B.DIVISION_ID			= @DIVISION_ID			
						AND B.COMPANY_ID			= @COMPANY_ID
						AND B.PLAN_START_YYYYMMDD	= @YYYYMMDD
						AND B.ITEM_ID				= @ITEM_ID
						AND B.FROM_SITE				= @FROM_SITE
						;
					END
				ELSE 
					BEGIN
						SELECT @tmpWH_STOCK = ISNULL(SUM(QTY), 0)
						FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK) 
						WHERE C.DIVISION_ID  		= @DIVISION_ID
						AND C.COMPANY_ID			= @COMPANY_ID
						AND C.YYYYMMDD				= CONVERT(VARCHAR(8), CONVERT(DATETIME, @YYYYMMDD)-1, 112)		
						AND C.ITEM_ID				= @ITEM_ID
						AND C.FROM_SITE				= @FROM_SITE
						AND C.MEASURE				= 'WH_STOCK'
						--AND C.MEASURE				IN ('PROD_PLAN','BALANCE')
						--GROUP BY DIVISION_ID, COMPANY_ID, YYYYMMDD, ITEM_ID, FROM_SITE
					END
			;
	
				-- SHIP_PLAN 수량 갱신 (전일자재고수량 + 당일생산출하가능수량) / LOT SIZE 정수형)
				SELECT @tmpSP_QTY = CASE WHEN CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, @DIVISION_ID, @FROM_SITE, @v_plan_start_yyyymmdd)/*-@tmpFrozenCnt*/, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)),112) > @YYYYMMDD
												 THEN IIF(ISNULL(C.CONFIRM_ID, '-') != '-', ISNULL(C.QTY, 0), 0) -- 컴펌:프로즌기간에는 컴펌수량만
										 --전일자재고 + (FP생산수량 * 재고비율) / LOT SIZE
										 WHEN CONVERT(INT,(@tmpWH_STOCK+(ISNULL(PP.QTY,0)*((100-ISNULL(C.RATE, 0))/100.0)))/ISNULL(@LOT_SIZE, 0))*ISNULL(@LOT_SIZE, 0) < ISNULL(@LOT_SIZE, 0) THEN 0 -- LOT SIZE보다 작은경우
										 WHEN ISNULL(@LOT_SIZE, 0) = 0 THEN CONVERT(INT,(@tmpWH_STOCK+(ISNULL(PP.QTY,0)*((100-ISNULL(C.RATE, 0))/100.0)))) -- LOT SIZE가 없는경우 전부 계획으로 잡는다.
										 ELSE CONVERT(INT,(@tmpWH_STOCK+(ISNULL(PP.QTY,0)*((100-ISNULL(C.RATE, 0))/100.0)))/ISNULL(@LOT_SIZE, 0))*ISNULL(@LOT_SIZE, 0)
									END
					 , @tmpFP_QTY  = ISNULL(PP.QTY, 0)
					 --, @tmpBALANCE = CASE WHEN ISNULL(C.CONFIRM_ID, '-') != '-' THEN ISNULL(PP.QTY, 0) - ISNULL(C.QTY, 0) 
						--				  WHEN ISNULL(PP.QTY, 0) < ISNULL(@LOT_SIZE, 0) THEN ISNULL(PP.QTY, 0)
						--				  ELSE ISNULL(PP.QTY, 0) % ISNULL(@LOT_SIZE, 1)
						--			 END
					 , @tmpCFM_QTY = IIF(ISNULL(C.CONFIRM_ID, '-') != '-', C.QTY, 0) --컴펌 수량
					 , @tmpMOVE_QTY = ISNULL(MV.QTY, 0) --이동계획
				  FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK)
				  LEFT OUTER JOIN #tmp_SSP_ANL_SHIP_PLAN_C PP WITH(NOLOCK)
				    ON C.DIVISION_ID  = PP.DIVISION_ID
				   AND C.COMPANY_ID   = PP.COMPANY_ID
				   AND C.ITEM_ID	  = PP.ITEM_ID
				   AND C.FROM_SITE	  = PP.FROM_SITE
				   AND C.YYYYMMDD	  = PP.YYYYMMDD
				   AND PP.MEASURE	  = 'PROD_PLAN'
				  LEFT OUTER JOIN #tmp_SSP_ANL_SHIP_PLAN_C MV WITH(NOLOCK)
				    ON C.DIVISION_ID  = MV.DIVISION_ID
				   AND C.COMPANY_ID   = MV.COMPANY_ID
				   AND C.ITEM_ID	  = MV.ITEM_ID
				   AND C.FROM_SITE	  = MV.FROM_SITE
				   AND C.YYYYMMDD	  = MV.YYYYMMDD
				   AND PP.MEASURE	  = 'INTN_MOVEMENT'
				 WHERE C.DIVISION_ID  		 = @DIVISION_ID  				
				   AND C.COMPANY_ID			 = @COMPANY_ID                
				   AND C.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD		
				   AND C.ITEM_ID			 = @ITEM_ID					
				   AND C.FROM_SITE			 = @FROM_SITE					
				   AND C.TO_SITE			 = @TO_SITE					
				   AND C.YYYYMMDD			 = @YYYYMMDD					
				   AND C.BOD_ID				 = @BOD_ID
				   AND C.INCOTERMS			 = @INCOTERMS					
				   AND C.TRANSPORT_MODE		 = @TRANSPORT_MODE	
				   AND C.PROJECT_CODE		 = @PROJECT_CODE				
				   AND C.FCST_TYPE			 = @FCST_TYPE		
				   AND C.MEASURE			 = 'SHIP_PLAN'
				   AND ISNULL(C.LOT_SIZE, 0)		= ISNULL(@LOT_SIZE, 0)
				   AND ISNULL(C.ROUTE_ID, 0)		= ISNULL(@ROUTE_ID, 0)
				   AND ISNULL(C.CONFIRM_FLAG, '')	= ISNULL(@CONFIRM_FLAG, '')
				   AND ISNULL(C.CONFIRM_ID,'')		= ISNULL(@CONFIRM_ID, '')
				   AND ISNULL(C.REQUESTOR,'')		= ISNULL(@REQUESTOR, '')
				   AND ISNULL(C.ATTRIBUTE1, '')		= ISNULL(@ATTRIBUTE1, '')
				;
				
				UPDATE C
				   SET C.QTY = @tmpSP_QTY
				  FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK)
				 WHERE C.DIVISION_ID  		 = @DIVISION_ID  				
				   AND C.COMPANY_ID			 = @COMPANY_ID                
				   AND C.PLAN_START_YYYYMMDD = @PLAN_START_YYYYMMDD		
				   AND C.ITEM_ID			 = @ITEM_ID					
				   AND C.FROM_SITE			 = @FROM_SITE					
				   AND C.TO_SITE			 = @TO_SITE					
				   AND C.YYYYMMDD			 = @YYYYMMDD					
				   AND C.BOD_ID				 = @BOD_ID
				   AND C.INCOTERMS			 = @INCOTERMS					
				   AND C.TRANSPORT_MODE		 = @TRANSPORT_MODE	
				   AND C.PROJECT_CODE		 = @PROJECT_CODE				
				   AND C.FCST_TYPE			 = @FCST_TYPE		
				   AND C.MEASURE			 = 'SHIP_PLAN'
				   AND ISNULL(C.LOT_SIZE, 0)		= ISNULL(@LOT_SIZE, 0)
				   AND ISNULL(C.ROUTE_ID, 0)		= ISNULL(@ROUTE_ID, 0)
				   AND ISNULL(C.CONFIRM_FLAG, '')	= ISNULL(@CONFIRM_FLAG, '')
				   AND ISNULL(C.CONFIRM_ID,'')		= ISNULL(@CONFIRM_ID, '')
				   AND ISNULL(C.REQUESTOR,'')		= ISNULL(@REQUESTOR, '')
				   AND ISNULL(C.ATTRIBUTE1, '')		= ISNULL(@ATTRIBUTE1, '')


				------------------------------------------------------------------------------------------------------------- 
				--2-7.일자별 WH_STOC 계산  : 당일 WH_STOC = EPR재고수량 + MES Available 수량(= Total 수량 - OQC NG수량-  MES/QMS Hold수량)
				--, 익일 WH_STOC = 전일 WH_STOC + 전일 PROD_PLAN - 전일SHIP_PLAN - 전일INTN_MOVEMENT             
				-- [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
				-- BOH : MES + OWMS (20210716, 요청자 김광희)
				------------------------------------------------------------------------------------------------------------- 

				--WH_STOCK 등록
				MERGE INTO #tmp_SSP_ANL_SHIP_PLAN_C C
				USING (
						SELECT @DIVISION_ID			  AS DIVISION_ID
								,@COMPANY_ID		  AS COMPANY_ID
								,@PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD             
								,@ITEM_ID             AS ITEM_ID
								,@FROM_SITE			  AS FROM_SITE
								,'-'				  AS TO_SITE         
								,'WH_STOCK'			  AS MEASURE
								,@YYYYMMDD			  AS YYYYMMDD
								,'-'				  AS BOD_ID			
								,@tmpWH_STOCK +	@tmpFP_QTY - IIF(@tmpCFM_QTY <> 0, @tmpCFM_QTY, @tmpSP_QTY)
													  AS QTY				   
								,'-'				  AS INCOTERMS         
								,'-'				  AS TRANSPORT_MODE    
								,'-'				  AS PROJECT_CODE	
								,'-'				  AS FCST_TYPE	
								,'-'				  AS CONFIRM_ID	
						) N
					 ON C.DIVISION_ID	= N.DIVISION_ID
					AND C.COMPANY_ID	= N.COMPANY_ID
					AND C.ITEM_ID		= N.ITEM_ID
					AND C.FROM_SITE		= N.FROM_SITE
					AND C.MEASURE		= N.MEASURE
					AND C.YYYYMMDD		= N.YYYYMMDD
					AND C.PLAN_START_YYYYMMDD = N.PLAN_START_YYYYMMDD
				WHEN MATCHED THEN
				UPDATE 
				SET QTY = C.QTY - @tmpCFM_QTY
				WHEN NOT MATCHED THEN
				INSERT 
				(
					DIVISION_ID
					,COMPANY_ID	  	     
					,PLAN_START_YYYYMMDD 
					,ITEM_ID	         
					,FROM_SITE	         
					,TO_SITE	         
					,MEASURE	         
					,YYYYMMDD	         
					,BOD_ID	           
					,QTY	             
					,INCOTERMS         
					,TRANSPORT_MODE    
					,PROJECT_CODE	     
					,FCST_TYPE
					,CONFIRM_ID	      
					)
				VALUES (   
					N.DIVISION_ID
					,N.COMPANY_ID    
					,N.PLAN_START_YYYYMMDD            
					,N.ITEM_ID            
					,N.FROM_SITE    
					,'-'		-- TO_SITE         
					,'WH_STOCK' -- MEASURE
					,N.YYYYMMDD  
					,'-'		-- BOD_ID		
					,N.QTY - @tmpMOVE_QTY -- QTY				   
					,'-'		-- INCOTERMS         
					,'-'		-- TRANSPORT_MODE    
					,'-'		-- PROJECT_CODE	
					,'-'		-- FCST_TYPE	
					,'-'		-- CONFIRM_ID	
				);
				
				
				-- BALANCE 당일 등록
				--MERGE INTO #tmp_SSP_ANL_SHIP_PLAN_C C
				--USING
				--(
				--	SELECT @DIVISION_ID  	AS DIVISION_ID			
				--		, @COMPANY_ID       AS COMPANY_ID         
				--		, @PLAN_START_YYYYMMDD	AS PLAN_START_YYYYMMDD
				--		, @ITEM_ID			AS ITEM_ID
				--		, @FROM_SITE		AS FROM_SITE
				--		, '-'				AS TO_SITE
				--		, @YYYYMMDD			AS YYYYMMDD
				--		, '-'				AS BOD_ID
				--		, '-'				AS INCOTERMS	
				--		, '-'				AS TRANSPORT_MODE
				--		, '-'				AS PROJECT_CODE	
				--		, '-'				AS FCST_TYPE	
				--		, 'BALANCE'			AS MEASURE
				--) N
				-- ON C.DIVISION_ID  			= N.DIVISION_ID  				
				--AND C.COMPANY_ID			= N.COMPANY_ID                
				--AND C.PLAN_START_YYYYMMDD	= N.PLAN_START_YYYYMMDD		
				--AND C.ITEM_ID				= N.ITEM_ID					
				--AND C.FROM_SITE				= N.FROM_SITE					
				--AND C.TO_SITE				= N.TO_SITE					
				--AND C.MEASURE				= N.MEASURE					
				--AND C.YYYYMMDD				= N.YYYYMMDD					
				--AND C.BOD_ID				= N.BOD_ID
				--AND C.INCOTERMS				= N.INCOTERMS					
				--AND C.TRANSPORT_MODE		= N.TRANSPORT_MODE	
				--AND C.PROJECT_CODE			= N.PROJECT_CODE				
				--AND C.FCST_TYPE				= N.FCST_TYPE		
				--AND C.MEASURE				= N.MEASURE

				--WHEN MATCHED THEN
				--	UPDATE SET QTY = QTY - @tmpCFM_QTY
				--WHEN NOT MATCHED THEN
				--	INSERT 
				--	(
				--		  DIVISION_ID  
				--		, COMPANY_ID		     
				--		, PLAN_START_YYYYMMDD 
				--		, ITEM_ID	         
				--		, FROM_SITE	         
				--		, TO_SITE	         
				--		, MEASURE	         
				--		, YYYYMMDD	         
				--		, BOD_ID	           
				--		, QTY	             
				--		, INCOTERMS         
				--		, TRANSPORT_MODE    
				--		, PROJECT_CODE	     
				--		, FCST_TYPE	
				--		, CONFIRM_ID      
				--	) VALUES (
				--		  N.DIVISION_ID 
				--		, N.COMPANY_ID
				--		, N.PLAN_START_YYYYMMDD 
				--		, N.ITEM_ID	         
				--		, N.FROM_SITE	         
				--		, N.TO_SITE	         
				--		, N.MEASURE  -- BALANCE	         
				--		, N.YYYYMMDD	         
				--		, N.BOD_ID	           	   
				--		, @tmpBALANCE -- QTY
				--		, N.INCOTERMS         
				--		, N.TRANSPORT_MODE    
				--		, N.PROJECT_CODE	     
				--		, N.FCST_TYPE	
				--		, '-' -- CONFIRM_ID 
				--	)
				--	;

				FETCH NEXT FROM CUR_PLAN_P INTO @DIVISION_ID  				
												,@COMPANY_ID                
												,@PLAN_START_YYYYMMDD		
												,@ITEM_ID					
												,@FROM_SITE					
												,@TO_SITE					
												,@MEASURE					
												,@YYYYMMDD					
												,@BOD_ID					
												,@QTY						
												,@ROUTE_ID					
												,@INCOTERMS					
												,@TRANSPORT_MODE			
												,@PROJECT_CODE				
												,@FCST_TYPE					
												,@FCST_ETD_DATE				
												,@FCST_ETA_DATE				
												,@ETD_DATE					
												,@ETA_DATE					
												,@CONFIRM_FLAG				
												,@CONFIRM_ID				
												,@REQUESTOR                 
												,@ATTRIBUTE1 
												,@LOT_SIZE
												,@RATE;
	
			END; 

			CLOSE CUR_PLAN_P; 
			DEALLOCATE CUR_PLAN_P;

			-- SHIP_PLAN : BOD_ID / ETD / ETA / INCOTERMS / TRANS MODE 갱신
			UPDATE C
			   SET C.BOD_ID = B.BOD_ID
				 , C.ROUTE_ID = B.ROUTE_ID
			     , C.INCOTERMS = B.SSP_INCOTERMS
				 , C.TRANSPORT_MODE = B.TRANSPORT_MODE	
			     , C.FCST_ETD_DATE = C.YYYYMMDD	
				 , C.FCST_ETA_DATE = [dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, B.BOD_ID, C.YYYYMMDD)
				 , C.ETD_DATE      = C.YYYYMMDD
				 , C.ETA_DATE      = [dbo].[FN_GET_SSP_ETA_DATE](C.DIVISION_ID, B.BOD_ID, C.YYYYMMDD)
				 , C.CONFIRM_FLAG  = 'N'
			  FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK)
			  LEFT OUTER JOIN #tmp_SSP_ANL_SHIP_PLAN_C WST WITH(NOLOCK)
			    ON C.DIVISION_ID  = WST.DIVISION_ID  				
			   AND C.COMPANY_ID   = WST.COMPANY_ID                
			   AND C.ITEM_ID	  = WST.ITEM_ID					
			   AND C.FROM_SITE	  = WST.FROM_SITE										
			   AND C.YYYYMMDD	  = WST.YYYYMMDD
			   AND WST.MEASURE	  = 'WH_STOCK'
			  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T WITH(NOLOCK)  
			    ON T.LOOKUP_TYPE  = 'FP_AUTO_SHIP_FROM_TO'
			   AND T.VALID_YN	  = 'Y'
			   AND T.SEGMENT1     = C.DIVISION_ID
			   AND T.SEGMENT2     = C.FROM_SITE
			   AND T.SEGMENT3     = C.TO_SITE
			   AND T.SEGMENT4     = C.ITEM_ID  
			  JOIN SCP_MST_BOD_N_V B WITH(NOLOCK) 
			    ON B.DIVISION_ID  = T.SEGMENT1
			   AND B.BOD_ID       = T.SEGMENT5
			 WHERE C.MEASURE			 = 'SHIP_PLAN'
			   AND ISNULL(C.BOD_ID, '-') = '-'
			   AND C.QTY				 > 0
			;

 			-------------------------------------------------------------------------------------------------------------             
			--2-7. 존재하지 않는 경우, 해당 MEASURE를 0으로 추가  
			-------------------------------------------------------------------------------------------------------------   
 			DECLARE @X_INT        INT   =1;  
			DECLARE @X_MEASURE    NVARCHAR(100);  
  
			WHILE @X_INT < 5
			BEGIN  
              
				SELECT @X_MEASURE = ( CASE @X_INT   WHEN 1 THEN 'SHIP_REQ'   
													WHEN 2 THEN 'SHIP_PLAN'
													WHEN 3 THEN 'PROD_PLAN'
													WHEN 4 THEN 'INTN_MOVEMENT'

										END);  
       
				INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
					(
					 DIVISION_ID  				
					,COMPANY_ID           
					,PLAN_START_YYYYMMDD	
					,ITEM_ID				
					,FROM_SITE			
					,TO_SITE				
					,MEASURE				
					,YYYYMMDD				
					,BOD_ID					
					,QTY						
					,INCOTERMS			
					,TRANSPORT_MODE	
					,PROJECT_CODE		
					,FCST_TYPE			
					,CONFIRM_ID
						)        
				SELECT   
					 SUB.DIVISION_ID
                    ,SUB.COMPANY_ID
					,SUB.PLAN_START_YYYYMMDD
					,SUB.ITEM_ID
					,SUB.FROM_SITE
					,SUB.TO_SITE
					,SUB.MEASURE
					,SUB.YYYYMMDD
					,SUB.BOD_ID
					,0              AS QTY                      
					,SUB.INCOTERMS
					,SUB.TRANSPORT_MODE
					,SUB.PROJECT_CODE
					,SUB.FCST_TYPE
					,SUB.CONFIRM_ID --'-' AS CONFIRM_ID 

				FROM     
					(    
						SELECT   DIVISION_ID
						        ,COMPANY_ID
								,PLAN_START_YYYYMMDD
								,ITEM_ID
								,FROM_SITE
								,'-'         AS TO_SITE
								,@X_MEASURE  AS MEASURE
								,YYYYMMDD
								,'-' AS BOD_ID
								,'-' AS INCOTERMS
								,'-' AS TRANSPORT_MODE
								,'-' AS PROJECT_CODE
								,'-' AS FCST_TYPE
								,'-' AS CONFIRM_ID
							 
							FROM    
								(  -- 56 DAYS (7*8)
									SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
									FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
									WHERE 1=1  
									AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
									AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd
								) A,    
								(    
									SELECT  DISTINCT   
											DIVISION_ID
                                        ,COMPANY_ID  
										,PLAN_START_YYYYMMDD
										,ITEM_ID
										,FROM_SITE
									FROM  #tmp_SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK)   								 
									WHERE 1=1  
								  
								) B    
					) SUB    
					WHERE 1=1    
						AND NOT EXISTS (    
										SELECT 'X'    
											FROM #tmp_SSP_ANL_SHIP_PLAN_C Z WITH(NOLOCK)     
										WHERE 1=1    
											AND Z.DIVISION_ID              = SUB.DIVISION_ID   
											AND Z.COMPANY_ID               = SUB.COMPANY_ID         
											AND Z.PLAN_START_YYYYMMDD      = SUB.PLAN_START_YYYYMMDD        
											AND Z.ITEM_ID                  = SUB.ITEM_ID   										            
											AND Z.FROM_SITE                = SUB.FROM_SITE       
											AND Z.MEASURE                  = @X_MEASURE      										     										                                                    
											AND Z.YYYYMMDD                 = SUB.YYYYMMDD     

										)
				;    

				SET @X_INT = @X_INT + 1;  
      
			END  

			-------------------------------------------------------------------------------------------------------------             
			--2-8. MEASURE별 BUCKET일자별 0 채우기        
			-------------------------------------------------------------------------------------------------------------                      
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
				(
				 DIVISION_ID  	     
                ,COMPANY_ID 
				,PLAN_START_YYYYMMDD 
				,ITEM_ID	         
				,FROM_SITE	         
				,TO_SITE	         
				,MEASURE	         
				,YYYYMMDD	         
				,BOD_ID	           
				,QTY	             
				,INCOTERMS         
				,TRANSPORT_MODE    
				,PROJECT_CODE	
				,FCST_TYPE
				,CONFIRM_ID						     
				)        
			SELECT   
				 SUB.DIVISION_ID
                ,SUB.COMPANY_ID
				,SUB.PLAN_START_YYYYMMDD
				,SUB.ITEM_ID
				,SUB.FROM_SITE
				,SUB.TO_SITE
				,SUB.MEASURE
				,SUB.YYYYMMDD
				,SUB.BOD_ID
				,0              AS QTY                      
				,SUB.INCOTERMS
				,SUB.TRANSPORT_MODE
				,SUB.PROJECT_CODE
				,SUB.FCST_TYPE
				,'-' AS CONFIRM_ID 
			FROM     
				(    
					SELECT   DIVISION_ID
					        ,COMPANY_ID
							,PLAN_START_YYYYMMDD
							,ITEM_ID
							,FROM_SITE
							,TO_SITE
							,MEASURE
							,YYYYMMDD
							,'-' AS  BOD_ID
							,'-' AS  INCOTERMS
							,'-' AS  TRANSPORT_MODE
							,'-' AS  PROJECT_CODE
							,'-' AS  FCST_TYPE
						FROM    
							(   -- 56 DAYS (7*8) 
								SELECT C.BASIS_YYYYMMDD AS YYYYMMDD      
								FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)     
								WHERE 1=1  
								AND C.BASIS_YYYYMMDD >= @v_data_start_yyyymmdd   
								AND C.BASIS_YYYYMMDD <  @v_data_end_yyyymmdd 
							) A,    
							(    
								SELECT DISTINCT   
									 DIVISION_ID
									,COMPANY_ID
									,PLAN_START_YYYYMMDD
									,ITEM_ID
									,FROM_SITE
									,TO_SITE
									,MEASURE
								FROM  #tmp_SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK)   
								WHERE 1=1  
								  
							) B    
				) SUB    
				WHERE 1=1    
					AND NOT EXISTS (    
									SELECT 'X'    
										FROM #tmp_SSP_ANL_SHIP_PLAN_C Z WITH(NOLOCK)     
									WHERE 1=1    
										AND Z.DIVISION_ID         = SUB.DIVISION_ID    
										AND Z.COMPANY_ID          = SUB.COMPANY_ID          
										AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD        
										AND Z.ITEM_ID             = SUB.ITEM_ID   										            
										AND Z.FROM_SITE           = SUB.FROM_SITE       
										AND Z.TO_SITE             = SUB.TO_SITE    
										AND Z.MEASURE             = SUB.MEASURE      										     										                                                    
										AND Z.YYYYMMDD            = SUB.YYYYMMDD     
									)
			;  
						

			------------------------------------------------------------------------------------------------------------- 
			--2-8. [S]CONTAINER(Container Qty)     : SHIP_PLAN / LOT SIZE QTY ( TRANSMODE : SEA) 
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_PLAN_C
				(
				 DIVISION_ID  				
				,COMPANY_ID           
				,PLAN_START_YYYYMMDD	
				,ITEM_ID				
				,FROM_SITE			
				,TO_SITE				
				,MEASURE				
				,YYYYMMDD				
				,BOD_ID					
				,QTY						
				,ROUTE_ID				
				,INCOTERMS			
				,TRANSPORT_MODE	
				,PROJECT_CODE		
				,FCST_TYPE			
				,FCST_ETD_DATE	
				,FCST_ETA_DATE	
				,ETD_DATE				
				,ETA_DATE				
				,CONFIRM_FLAG		
				,CONFIRM_ID
				,REQUESTOR	
			    ,ATTRIBUTE1		--LOT_SIZE_YN	     
				)
			SELECT 
				 P.DIVISION_ID  				
				,P.COMPANY_ID           
				,P.PLAN_START_YYYYMMDD  AS  PLAN_START_YYYYMMDD	
				,P.ITEM_ID				
				,P.FROM_SITE   AS FROM_SITE			
				,'-'           AS TO_SITE				
				,'CONTAINER'   AS MEASURE				
				,P.YYYYMMDD    AS YYYYMMDD				
				,'-'           AS BOD_ID	
				,CASE WHEN ISNULL(MAX(L.LOT_SIZE), 0) = 0 THEN 0 ELSE CEILING(SUM(ISNULL(P.QTY, 0)) /ISNULL(MAX(L.LOT_SIZE), 0)) END AS QTY				
				,NULL AS ROUTE_ID				
				,'-'  AS INCOTERMS			
				,'-'  AS TRANSPORT_MODE	
				,'-'  AS PROJECT_CODE		
				,'-'  AS FCST_TYPE			
				,NULL AS FCST_ETD_DATE	
				,NULL AS FCST_ETA_DATE	
				,NULL AS ETD_DATE				
				,NULL AS ETA_DATE				
				,NULL AS CONFIRM_FLAG		
				,'-'  AS CONFIRM_ID
				,NULL AS REQUESTOR	
				,CASE WHEN MAX(L.LOT_SIZE) IS NULL THEN 'N' ELSE 'Y' END  AS LOT_SIZE_YN
			FROM  #tmp_SSP_ANL_SHIP_PLAN_C  P  WITH(NOLOCK) 
			LEFT OUTER JOIN (	SELECT   A.DIVISION_ID     AS DIVISION_ID
								,        A.FROM_SITE       AS FROM_SITE
								,        A.ITEM_ID         AS ITEM_ID
								,        MAX(A.LOT_SIZE)   AS LOT_SIZE
								FROM   SCP_MST_SHIPMENT_LOT_SIZE A WITH(NOLOCK)
								WHERE  A.VALID_YN    = 'Y'
								-- CMI법인(G380)은 TRUCK 그외 SEA (2019.11.05)
--								AND A.TRANSPORT_MODE = CASE WHEN A.FROM_SITE IN ('G382-A','G382-P') THEN 'TRK' ELSE 'SEA' END
								AND A.TRANSPORT_MODE = CASE WHEN A.FROM_SITE IN (select CODE from dbo.FN_LIST_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_CUTOFF'  ,'G382_Transport' )) THEN 'TRK' ELSE 'SEA' END
								GROUP BY A.DIVISION_ID 
								,        A.FROM_SITE 
								,        A.ITEM_ID 			
						                                   )  L 
						ON  L.DIVISION_ID = P.DIVISION_ID
						AND L.ITEM_ID     = P.ITEM_ID
						AND L.FROM_SITE   = P.FROM_SITE
            WHERE P.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
			AND   P.COMPANY_ID = @v_company_id 
			AND   P.MEASURE    = 'SHIP_PLAN'
			AND   P.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
			GROUP BY 
				 P.DIVISION_ID  
				,P.PLAN_START_YYYYMMDD 				
				,P.COMPANY_ID           
				,P.ITEM_ID				
				,P.FROM_SITE 	
				,P.YYYYMMDD
            ;

 		------------------------------------------------------------------------------------------------------------- 
		--3. 최종 SSP_ANL_SHIP_PLAN_C 생성 
		-------------------------------------------------------------------------------------------------------------
		-- PR_SSP_ANL_SHIP_PLAN_CUTOFF 에서 삭제 처리하고 있음.
        --DELETE 
		--FROM  SSP_ANL_SHIP_PLAN_C  
        --WHERE COMPANY_ID          = @v_company_id 
        --AND   PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
        --;

        INSERT INTO /* SSP_ANL_SHIP_PLAN_C */ dbo.SSP_ANL_SHIP_PLAN_C
                (
				 DIVISION_ID
				,COMPANY_ID
				,PLAN_START_YYYYMMDD
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,MEASURE
				,YYYYMMDD
				,BOD_ID
				,QTY
				,ROUTE_ID
				,INCOTERMS
				,TRANSPORT_MODE
				,BIZ_TYPE
				,PROJECT_CODE
				,FCST_TYPE
				,FCST_ETD_DATE
				,FCST_ETA_DATE
				,ETD_DATE
				,ETA_DATE
				,CONFIRM_FLAG
				,CONFIRM_ID
				,REQUESTOR
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,ATTRIBUTE2
				,ATTRIBUTE3
				,ATTRIBUTE4
				,ATTRIBUTE5
				,ATTRIBUTE6
				,ATTRIBUTE7
				,ATTRIBUTE8
				,ATTRIBUTE9
				,ATTRIBUTE10
				,ELECTRODE_YN
				,ELECTRODE_TYPE
				,ORIGIN_FROM_DIVISION_ID
				,ORIGIN_TO_DIVISION_ID
                )
				SELECT 	 
				 T.DIVISION_ID
				,T.COMPANY_ID
				,T.PLAN_START_YYYYMMDD
				,T.ITEM_ID
				,T.FROM_SITE
				,T.TO_SITE
				,T.MEASURE
				,T.YYYYMMDD
				,T.BOD_ID
				,T.QTY
				,T.ROUTE_ID
				,T.INCOTERMS
				,T.TRANSPORT_MODE
				,V.OPERATION_GROUP  BIZ_TYPE
				,T.PROJECT_CODE
				,T.FCST_TYPE
				,T.FCST_ETD_DATE
				,T.FCST_ETA_DATE
				,T.ETD_DATE
				,T.ETA_DATE
				,T.CONFIRM_FLAG
				,T.CONFIRM_ID
				,T.REQUESTOR
				,@v_batch_user AS CREATED_BY
				,GETDATE() AS CREATION_DATE
				,@v_batch_user AS LAST_UPDATED_BY
				,GETDATE() AS LAST_UPDATE_DATE
				,T.ATTRIBUTE1 AS ATTRIBUTE1  -- LOT_SIZE_YN
				,NULL AS ATTRIBUTE2
				,NULL AS ATTRIBUTE3
				,NULL AS ATTRIBUTE4
				,NULL AS ATTRIBUTE5
				,NULL AS ATTRIBUTE6
				,NULL AS ATTRIBUTE7
				,NULL AS ATTRIBUTE8
				,NULL AS ATTRIBUTE9
				,NULL AS ATTRIBUTE10
				,NULL AS ELECTRODE_YN
				,NULL AS ELECTRODE_TYPE
				,T.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID
				,T.DIVISION_ID AS ORIGIN_TO_DIVISION_ID 
				FROM #tmp_SSP_ANL_SHIP_PLAN_C T WITH (NOLOCK)
						JOIN SCP_MST_FINAL_ITEM V 
						  ON V.ITEM_ID = T.ITEM_ID
						 AND V.DIVISION_ID = T.DIVISION_ID 
				WHERE 1=1
				AND   T.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				--AND   T.MEASURE NOT IN (  'WH_STOCK', 'SHIP_REQ', 'INTN_MOVEMENT','CONTAINER')--'PROD_PLAN'
        ;

    END
    END TRY

    BEGIN CATCH
		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_PLAN_P')
			BEGIN
				CLOSE CUR_PLAN_P ;
				DEALLOCATE CUR_PLAN_P ;
			END

      SET @r_error_msg =  CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
	  PRINT(@r_error_msg);
	  PRINT(STR(ERROR_LINE()));
	  
      RETURN -1

    END CATCH;

	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_C') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_C

		IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_PLAN_P')
				BEGIN
				   CLOSE CUR_PLAN_P ;
				   DEALLOCATE CUR_PLAN_P ;
				END
			
	RETURN 1

END; 
