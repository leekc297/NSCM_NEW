/*
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_CUTOFF
 * Description  : SHIP_PLAN cutoff정보 생성(법인별 당일재고 생성후 전일 PLAN정보  cutoff 생성)   
 * OutTable     :
 * Execute      : PR_SSP_PLN_SHIP_PLAN_CUTOFF 에서 호출 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.07   juhlee         Initial Release [PJ20189106} 전지.GSCM 고도화 이행 PROJECT
 *                             소형 출하PSI 화면용 DATA생성 
	<MEASURE>  
	[S]SHIP_REQ(Shipment Request)       : MKT 담당자가 출하요청한 수량 + 법인간 (SCP FN PLAN)        
	[S]SHIP_PLAN(Shipment Plan)         : 출하 확정 수량 + SHIP_REQ 
	[S]INTN_MOVEMENT(Internal movement) : 법인간 이동 	  
	[S]CONTAINER(Container Qty)         : SHIP_PLAN/LOT수량 (정수)   
	[P]PROD_PLAN(Production)            : FP 특성계획
	[I]WH_STOC(Warehouse Stock)         : 당일 WH_STOC = EPR재고수량 , 익일 WH_STOC = 전일 WH_STOC + 전일 PROD_PLAN - 전일SHIP_PLAN - 전일INTN_MOVEMENT     
	[I]BALANCE(Balance)                 : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Plan 
 * 2019.10.17   juhlee         Pack 생산 창고 추가 CMA_BMA BOH수량에 추가  (requested by 김광희) 
 * 2019.10.28   juhlee         EPR재고수량에  MES Available 수량 더함 
                               (MES Available수량= Total 수량 - OQC NG수량-  MES/QMS Hold수량) 
 * 2019.10.29   juhlee         항차고려한 ETA 산춫 [PJ20189106] 전지.GSCM 고도화 이행 
 * 2019.11.05	juhlee		   Container Lot Size 로직 수정(CMI일경우 운송모드 TRUCK, 그외 SEA) 
 * 2020.01.21   juhlee         [C20200121-000352]  ESS Packer출하 적용 
                                - [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
                                - [C20200121-000352]-3 : Production Plan Measure에 Paker생산계획 추가(SCP_ANL_PRODUCTION_PLAN 의 PROD_PLAN_AMEND measure) 
 * 2020.03.17   juhlee	       BOH 수량에 CMA_BMA 제외 (requested by 김광희)
 * 2020.09.21   KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.02.08   SSP Pjt.       SSP_DNM_MES_STOCK_81_82 -> SSP_DNM_GMES_STOCK_81_82
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2022.04.23   SSP Pjt.       C20220419-000607 / SSP~oWMS 사외창고 재고 I/F개선 요청
 * 2024.10.01   KHJ            NERP_SSP
 * 2026.03.05	강주용		   E20260305-001301 프로즌구간을 주차로 관리할때 계획구간 생성 오류 수정
 * 2026.07.13	강주용		   [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
 * 2026.08.13	강주용		   [E20260811-000692] ESMI AZ 링크 2호기 생산계획 받아오지 못하는 현상 처리
*/

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_CUTOFF]
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
            );

			------------------------------------------------------------------------------------------------------------- 
			--2-1. [S]SHIP_REQ(Shipment Request)    : 출하요청 수량 (DM_PLN_SHIPMENT_REQ)
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
				 R.DIVISION_ID  				
				,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, R.PLANT_SITE_ID, 'COMPANY_ID')  AS COMPANY_ID           
				,@v_plan_start_yyyymmdd  AS PLAN_START_YYYYMMDD	
				,R.ITEM_ID				
				,R.PLANT_SITE_ID			
				,R.SCM_SITE_ID				
				,R.MEASURE				
				,R.YYYYMMDD				
				,B.BOD_ID					
				,SUM(R.QTY) AS QTY 					
				,B.ROUTE_ID	
				--,R.INCOTERMS
				-- 2020.09.16  INCOTERMS-> SSP_INCOTERMS 로 COLUMN 변경
				,ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)   AS INCOTERMS -- R.INCOTERMS			
				,R.TRANSPORT_MODE	
				,R.PROJECT_CODE		
				,R.FCST_TYPE			
				,R.YYYYMMDD	 AS FCST_ETD_DATE	
				--,CONVERT(VARCHAR, DATEADD(D, MIN(B.LT_TOTAL), CONVERT(DATETIME, R.YYYYMMDD ,112)) ,112)   AS FCST_ETA_DATE	
				,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
				,R.YYYYMMDD	 AS ETD_DATE				
				--,CONVERT(VARCHAR, DATEADD(D, MIN(B.LT_TOTAL), CONVERT(DATETIME, R.YYYYMMDD ,112)) ,112)   AS ETA_DATE	
				,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS ETA_DATE							
				,NULL	AS CONFIRM_FLAG		
				,'-'	AS CONFIRM_ID	
				, MAX(R.LAST_UPDATED_BY) 	AS REQUESTOR
			FROM DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
				 LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
				   ON B.DIVISION_ID = R.DIVISION_ID
				  AND B.FROM_SITE    = R.PLANT_SITE_ID
				  --AND B.TO_SITE      = R.SCM_SITE_ID
				  AND B.BOD_ID       = R.BOD_ID
				  --AND B.INCOTERMS    = R.INCOTERMS
				  --AND B.TRANSPORT_MODE =R.TRANSPORT_MODE
			WHERE R.MEASURE = 'SHIP_REQ'
			AND   R.YYYYMMDD >= @v_plan_start_yyyymmdd 
			AND   R.YYYYMMDD <  @v_data_end_yyyymmdd
			AND   [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, R.PLANT_SITE_ID, 'COMPANY_ID') = @v_company_id
			AND   R.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
			-- START [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경 
			-- FP PROD 자동생성 항목 제외
			AND NOT EXISTS ( 
				SELECT 1 
				FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
				WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = R.DIVISION_ID
				AND L.SEGMENT2 = R.PLANT_SITE_ID
				AND L.SEGMENT4 = R.ITEM_ID
			)
			-- END [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
			GROUP BY 
				 R.DIVISION_ID  				
				,R.ITEM_ID				
				,R.PLANT_SITE_ID			
				,R.SCM_SITE_ID				
				,R.MEASURE				
				,R.YYYYMMDD				
				,B.BOD_ID					
				,B.ROUTE_ID				
				--,R.INCOTERMS
				,ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)
				,R.TRANSPORT_MODE	
				,R.PROJECT_CODE		
				,R.FCST_TYPE	
				,B.BOD_ID		
				,B.ROUTE_ID	
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-2. [S]SHIP_PLAN(Shipment Plan): 출하확정 + 출하요청 (확정구간 : SCM_MST_SITE.SHIP_FROZEN) 
			-------------------------------------------------------------------------------------------------------------
			--     확정구간 : 출하확정(SSP_ANL_SHIP_CONFIRM)
			--     확정구간 이후 : 하확정(SSP_ANL_SHIP_CONFIRM) + 출하요청(DM_PLN_SHIPMENT_REQ) 
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

			FROM (  SELECT 
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
					FROM SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 

						 LEFT OUTER JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
						   ON B.DIVISION_ID = C.DIVISION_ID
						  AND B.BOD_ID       = C.BOD_ID

					WHERE C.YYYYMMDD BETWEEN  @v_plan_start_yyyymmdd AND @v_data_end_yyyymmdd
					AND   C.CHANGE_TYPE = 'C' -- 확정
					AND   [DBO].[FN_GET_SSP_SITE_INFO](C.DIVISION_ID, C.FROM_SITE, 'COMPANY_ID') = @v_company_id 
					AND   C.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
					-- START [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
					-- FP PROD 자동생성 항목 제외
					AND NOT EXISTS ( 
						SELECT 1 
						FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
						WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
						AND L.VALID_YN = 'Y'
						AND L.SEGMENT1 = C.DIVISION_ID
						AND L.SEGMENT2 = C.FROM_SITE
						AND L.SEGMENT4 = C.ITEM_ID
					)
					-- END [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
					UNION ALL 
					--확정기간 이후 출하요청 
					SELECT 
					 R.DIVISION_ID  				
					,R.ITEM_ID				
					,R.FROM_SITE			
					,R.TO_SITE				
					,R.YYYYMMDD				
					,R.BOD_ID					
					,R.QTY						
					,R.ROUTE_ID				
					,R.INCOTERMS			
					,R.TRANSPORT_MODE	
					,R.PROJECT_CODE		
					,R.FCST_TYPE			
					,R.FCST_ETD_DATE	
					,R.FCST_ETA_DATE	
					,R.ETD_DATE				
					,R.ETA_DATE				
					,'N'        AS   CONFIRM_FLAG		
					,R.CONFIRM_ID	
					,R.REQUESTOR	
					FROM   #tmp_SSP_ANL_SHIP_PLAN_C R WITH(NOLOCK) 
					WHERE 1=1 
					AND   R.MEASURE = 'SHIP_REQ'
					-- START E20260305-001301 프로즌구간을 주차로 관리할때 계획구간 생성 오류 수정
					--AND   R.YYYYMMDD >= CASE WHEN [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.FROM_SITE) <= 0 THEN @v_plan_start_yyyymmdd
					--					ELSE  CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID,R.FROM_SITE) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
					--					END  
					AND   R.YYYYMMDD >= CASE WHEN [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.DIVISION_ID, R.FROM_SITE, @v_plan_start_yyyymmdd) <= 0 THEN @v_plan_start_yyyymmdd
										     ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.DIVISION_ID, R.FROM_SITE, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
										END
					-- END E20260305-001301 프로즌구간을 주차로 관리할때 계획구간 생성 오류 수정
					AND   R.YYYYMMDD < @v_data_end_yyyymmdd 
					AND   R.COMPANY_ID = @v_company_id 
					AND   R.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
				  ) X
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
            ;

			------------------------------------------------------------------------------------------------------------- 
			--2-3. [S]INTN_MOVEMENT(Internal movement) : 법인간 이동(SCM_DNM_CELL_INHOUSE_PLAN_SN) CATEGORY = 'MOVING'
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
						   AND    T.MEASURE IN ( 'SHIP_REQ','SHIP_PLAN','PROD_PLAN')
						   ) 
			GROUP BY 
				 M.DIVISION_ID  				
				,M.COMPANY_ID           
				,M.ITEM_ID				
				,FS.SCM_SITE_ID 	
				,CONVERT(VARCHAR(8), M.PLAN_DATE , 112) 
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-4. [P]PROD_PLAN(Production)         : SCM_DNM_PLAN_FROZEN_V 
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
			-- START [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
			-- FP PROD 자동생성 항목 제외
			WHERE NOT EXISTS ( 
				SELECT 1 
				FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
				WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = X.DIVISION_ID
				AND L.SEGMENT2 = X.FROM_SITE
				AND L.SEGMENT4 = X.ITEM_ID
			)
			-- END [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
			GROUP BY X.DIVISION_ID 
			,      X.COMPANY_ID   
			,      X.ITEM_ID      
			,      X.FROM_SITE    
			,      X.YYYYMMDD    
			;
 
 			-------------------------------------------------------------------------------------------------------------             
			--2-5. 존재하지 않는 경우, 해당 MEASURE를 0으로 추가  
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
			--2-6. MEASURE별 BUCKET일자별 0 채우기        
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
			--2-7.일자별 WH_STOC 계산  : 당일 WH_STOC = EPR재고수량 + MES Available 수량(= Total 수량 - OQC NG수량-  MES/QMS Hold수량)
			--, 익일 WH_STOC = 전일 WH_STOC + 전일 PROD_PLAN - 전일SHIP_PLAN - 전일INTN_MOVEMENT             
			-- [C20200121-000352]-1 : ESS Packer 재고 적용(SSP_DNM_ESS_PACKER_STOCK_V) 
			-- BOH : MES + OWMS (20210716, 요청자 김광희)
			------------------------------------------------------------------------------------------------------------- 
			WITH BOH AS (    
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
						),  
				Z AS (
					SELECT DISTINCT  
						   DIVISION_ID  	
					,      COMPANY_ID		     
					,      PLAN_START_YYYYMMDD 
					,      ITEM_ID	         
					,      FROM_SITE  
					,      YYYYMMDD     

					FROM  #tmp_SSP_ANL_SHIP_PLAN_C  WITH(NOLOCK ) 
					WHERE 1=1 
					AND COMPANY_ID          = @v_company_id
					AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- '20180429' 
					AND MEASURE IN ('SHIP_PLAN', 'PROD_PLAN','INTN_MOVEMENT')
					AND YYYYMMDD            >= @v_data_start_yyyymmdd
					AND DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,',')) 
					GROUP BY DIVISION_ID   
					,        COMPANY_ID
					,        PLAN_START_YYYYMMDD 
					,        ITEM_ID	         
					,        FROM_SITE  
					,        YYYYMMDD 
					)  

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
					 Z.DIVISION_ID
					,Z.COMPANY_ID    
					,Z.PLAN_START_YYYYMMDD            
					,Z.ITEM_ID            
					,Z.FROM_SITE    
					,'-'   AS TO_SITE         
					,'WH_STOCK' AS MEASURE
					,Z.YYYYMMDD  
					,'-'   AS BOD_ID
					,-- 전일 PROD_PLAN , 전일 SHIP_PLAN
						( SELECT  
							ISNULL( SUM(CASE X.MEASURE WHEN 'SHIP_PLAN'     THEN -1 * ISNULL(X.QTY,0) 
							                           WHEN 'INTN_MOVEMENT' THEN -1 * ISNULL(X.QTY,0)  
													   WHEN 'PROD_PLAN'     THEN      ISNULL(X.QTY,0)  
											ELSE 0.0  
								END),0)   
						FROM #tmp_SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK)   
						WHERE 1=1  
						AND X.DIVISION_ID          = Z.DIVISION_ID
						AND X.COMPANY_ID           = Z.COMPANY_ID  
     					AND X.PLAN_START_YYYYMMDD  = Z.PLAN_START_YYYYMMDD           
						AND X.ITEM_ID              = Z.ITEM_ID  
						AND X.FROM_SITE            = Z.FROM_SITE  
						AND X.MEASURE              IN ('SHIP_PLAN', 'PROD_PLAN', 'INTN_MOVEMENT')  
						AND X.YYYYMMDD             >= @v_data_start_yyyymmdd
						AND X.YYYYMMDD             < Z.YYYYMMDD  )  

						-- 당일  재고 
							+  ISNULL(BOH.QTY,0)      AS QTY
	      --------------------------------------------------------------------------------------------------------------------------------------
					,'-'   AS INCOTERMS         
					,'-'   AS TRANSPORT_MODE    
					,'-'   AS PROJECT_CODE	
					,'-'   AS FCST_TYPE	
					,'-'   AS CONFIRM_ID	
			FROM Z WITH(NOLOCK)   
			LEFT OUTER JOIN BOH WITH(NOLOCK) 
							ON Z.DIVISION_ID      = BOH.DIVISION_ID
                        AND Z.COMPANY_ID          = BOH.COMPANY_ID  
						AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD  
						AND Z.ITEM_ID             = BOH.ITEM_ID  
						AND Z.FROM_SITE           = BOH.FROM_SITE  
			WHERE 1=1 
			;

			------------------------------------------------------------------------------------------------------------- 
			--2-7. [I]BALANCE(Balance)              : 당일 Balance :  당일Warehouse Stock - 당일 Shipment Plan 
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
			SELECT B.DIVISION_ID 
			,      B.COMPANY_ID
			,      B.PLAN_START_YYYYMMDD 
			,      B.ITEM_ID	         
			,      B.FROM_SITE	         
			,      B.TO_SITE	         
			,      'BALANCE'  AS MEASURE	         
			,      B.YYYYMMDD	         
			,      B.BOD_ID	           
			,      B.QTY - (SELECT SUM(C.QTY) 
							FROM #tmp_SSP_ANL_SHIP_PLAN_C C WITH(NOLOCK) 
							WHERE 1=1 
							AND B.DIVISION_ID          = C.DIVISION_ID   
							AND B.COMPANY_ID           = C.COMPANY_ID     
							AND B.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD
							AND B.ITEM_ID              = C.ITEM_ID             
							AND B.FROM_SITE            = C.FROM_SITE           
							AND B.YYYYMMDD             = C.YYYYMMDD 
							AND C.MEASURE              IN ('SHIP_PLAN')
							GROUP BY C.DIVISION_ID  
							        ,C.COMPANY_ID      							
									,C.PLAN_START_YYYYMMDD
									,C.ITEM_ID            
									,C.FROM_SITE          
									,C.YYYYMMDD ) AS QTY 		             
			,      B.INCOTERMS         
			,      B.TRANSPORT_MODE    
			,      B.PROJECT_CODE	     
			,      B.FCST_TYPE	
			,      '-' AS CONFIRM_ID 
			FROM #tmp_SSP_ANL_SHIP_PLAN_C B WITH(NOLOCK) 
			WHERE 1=1 
			AND B.COMPANY_ID          = @v_company_id  
			AND B.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd  -- '20180429'  
			AND B.MEASURE = 'WH_STOCK'  
			AND B.DIVISION_ID IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_division_id,','))      
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
        DELETE 
		FROM  SSP_ANL_SHIP_PLAN_C  
        WHERE COMPANY_ID          = @v_company_id 
        AND   PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
        ;

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
        ;

 		------------------------------------------------------------------------------------------------------------- 
		--4. Hold 재고 cutoff 생성( SSP_ANL_HOLD_STOCK ) 
		-------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_HOLD_STOCK') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_HOLD_STOCK

			CREATE TABLE #tmp_SSP_ANL_HOLD_STOCK(
			 HOLD_ID                        nvarchar(050)   
			,PLAN_START_YYYYMMDD            nvarchar(008)    
			,PLAN_TYPE                      nvarchar(050)   
			,SEQ                            INT         
			,DIVISION_ID                    nvarchar(030)   
			,FROM_SITE                      nvarchar(030)   
			,ITEM_ID                        nvarchar(050)   
			,HOLD_YYYYMMDD                  nvarchar(008)    
			,RELEASE_YYYYMMDD               nvarchar(008)    
			,HOLD_QTY                       numeric(20, 10)
			,REMARKS                        nvarchar(255)  
			,ORIGIN_FROM_DIVISION_ID        nvarchar(030)   
			,CREATED_BY                     nvarchar(150)  
			,CREATION_DATE                  datetime       
			,LAST_UPDATED_BY                nvarchar(150)  
			,LAST_UPDATE_DATE               datetime       
			);

			INSERT INTO #tmp_SSP_ANL_HOLD_STOCK (
					 HOLD_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,DIVISION_ID
					,FROM_SITE
					,ITEM_ID
					,HOLD_YYYYMMDD
					,RELEASE_YYYYMMDD
					,HOLD_QTY
					,REMARKS
					,ORIGIN_FROM_DIVISION_ID
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
     			)
					SELECT 
					 H.HOLD_ID
					,CONVERT(VARCHAR, DATEADD(D, 1, CONVERT(DATETIME, @p_plan_start_yyyymmdd ,112)) ,112) 
					,'SP' --PLAN_TYPE
					,1    --SEQ
					,H.DIVISION_ID
					,H.FROM_SITE
					,H.ITEM_ID
					,H.HOLD_YYYYMMDD
					,H.RELEASE_YYYYMMDD
					,H.HOLD_QTY
					,H.REMARKS
					,H.ORIGIN_FROM_DIVISION_ID
					,H.CREATED_BY
					,H.CREATION_DATE
					,H.LAST_UPDATED_BY
					,H.LAST_UPDATE_DATE
					FROM SSP_ANL_HOLD_STOCK H WITH(NOLOCK) 
							JOIN SCM_MST_SITE FS WITH(NOLOCK) 
							ON FS.DIVISION_ID  = H.DIVISION_ID 
							AND FS.SCM_SITE_ID = H.FROM_SITE
							AND FS.SITE_TYPE   = 'PLANT'
					WHERE FS.COMPANY_ID         = @v_company_id 
					AND   H.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
					AND   H.PLAN_TYPE           = 'SP' 
					AND   H.SEQ                 = 1
					AND   H.DIVISION_ID         <> '40' -- 소형 제외(소형 HOLD재고는 PR_SSP_ANL_SHIP_PLAN_40 에서 생성됨) 
				;

			-- SSP_ANL_HOLD_STOCK 생성 
			DELETE 
			FROM SSP_ANL_HOLD_STOCK
			FROM SSP_ANL_HOLD_STOCK H
			     JOIN SCM_MST_SITE FS WITH(NOLOCK) 
			   	   ON FS.DIVISION_ID = H.DIVISION_ID 
				  AND FS.SCM_SITE_ID = H.FROM_SITE
				  AND FS.SITE_TYPE   = 'PLANT'
			WHERE FS.COMPANY_ID         = @v_company_id 
			AND   H.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND   H.PLAN_TYPE           = 'SP' 
			AND   H.SEQ                 = 1
			AND   H.DIVISION_ID        <> '40' -- 소형 제외(소형 HOLD재고는 PR_SSP_ANL_SHIP_PLAN_40 에서 생성됨) 
			;

			INSERT INTO SSP_ANL_HOLD_STOCK (
				 HOLD_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,DIVISION_ID
				,FROM_SITE
				,ITEM_ID
				,HOLD_YYYYMMDD
				,RELEASE_YYYYMMDD
				,HOLD_QTY
				,REMARKS
				,ORIGIN_FROM_DIVISION_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
     			)
				SELECT 
				 HOLD_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,DIVISION_ID
				,FROM_SITE
				,ITEM_ID
				,HOLD_YYYYMMDD
				,RELEASE_YYYYMMDD
				,HOLD_QTY
				,REMARKS
				,ORIGIN_FROM_DIVISION_ID
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				FROM #tmp_SSP_ANL_HOLD_STOCK WITH(NOLOCK) 
			;

    END
    END TRY

    BEGIN CATCH

      SET @r_error_msg =  CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      RETURN -1

    END CATCH;

	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_PLAN_C') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_SHIP_PLAN_C

	IF OBJECT_ID('tempdb..#tmp_SSP_ANL_HOLD_STOCK') IS NOT NULL
		DROP TABLE #tmp_SSP_ANL_HOLD_STOCK
			
	RETURN 1

END; 
