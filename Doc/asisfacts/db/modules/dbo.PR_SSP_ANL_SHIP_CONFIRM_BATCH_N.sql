/*
 * Program ID   : PR_SSP_ANL_SHIP_CONFIRM_BATCH_N  
 * Description  : Daily 출하확정 내용 저장 및 인터페이스 테이블 저장 (Daily 07시 수행) 법인별 수행 
 * OutTable     : 
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.10.07   LJH            [PJ20189106] 전지.GSCM 고도화 이행  
 * 2019.10.29   LJH            BALANCE가 음수일 경우 확정 제외 시 오창(A040-A,A040-P)은 제외함(Requested by 김광희) 
 * 2020.05.06   LJH            BALANCE가 음수일 경우 확정 제외 로직 제거 (Requested by 김광희) 
 * 2020-09-21	KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2022.08.01   SSP Pjt.       CONFIRM_ROUTE 적용
 * 2024.02.23   jilee          폴란드 WA 법인 변경건 전체 내역 송부
 * 2024.05.03   hsbang         확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT])
 * 2024.06.03   hsbang         기존 존재하는 ITEM은 CONFIRM_ID 없이 CONFIRM_FLAG = 'Y' 처리 
 * 2024.10.01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       [E20250821-001308] -- to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 * 2026.07.13	강주용		   [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_BATCH_N]
( 
	  @p_company_id        NVARCHAR(30) ,
	  @p_cutoff_date       NVARCHAR(8)  ,
	  @r_error_msg         NVARCHAR(1000)  OUTPUT 
) 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;

	DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  

    DECLARE @v_plan_start_yyyymmdd    NVARCHAR(8) = '';
	DECLARE @v_seq    INTEGER = 0;
	DECLARE @v_infseqno	nvarchar(14);	
	DECLARE @v_timezone	nvarchar(10); 	
    DECLARE @v_daily_confirm_date	nvarchar(8);	
	DECLARE @v_time_for_system datetime ;
	DECLARE @v_time_for_timezone datetime ;
	DECLARE @v_sms_desc          NVARCHAR(4000);

	DECLARE @v_company_id    NVARCHAR(30) = '';
	SET     @v_company_id   = @p_company_id ;

	DECLARE @v_cutoff_date    NVARCHAR(8) = '';
	SET     @v_cutoff_date   = @p_cutoff_date ;
	DECLARE @v_cutoff_next_date    NVARCHAR(8) = CONVERT(VARCHAR, DATEADD(D, 1, CAST(@v_cutoff_date as datetime)), 112);

	DECLARE @v_app_type    NVARCHAR(8) = 'SSP';

    BEGIN TRY
      BEGIN
			
        ------------------------------------------------------------------------------------------------------------- 
        -- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
        ------------------------------------------------------------------------------------------------------------- 
        IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_CONFIRM') IS NOT NULL
            DROP TABLE #tmp_SSP_ANL_SHIP_CONFIRM

        CREATE TABLE #tmp_SSP_ANL_SHIP_CONFIRM(
					 CONFIRM_ID                   nvarchar(020)                                   
					,SHIPMENT_STATUS              nvarchar(020)   
					,DIVISION_ID                  nvarchar(030)   
					,PLAN_START_YYYYMMDD          nvarchar(008)    
					,PLAN_TYPE                    nvarchar(050)   
					,SEQ                          int         
					,ITEM_ID                      nvarchar(050)   
					,FROM_SITE                    nvarchar(030)   
					,TO_SITE                      nvarchar(030)   
					,YYYYMMDD                     nvarchar(008) 
					,PLANNED_QTY                  numeric(20,10)   
					,QTY                          numeric(20,10)
					,BOD_ID                       nvarchar(150)  
					,ROUTE_ID                     int         
					,BIZ_TYPE                     nvarchar(030)   
					,PROJECT_CODE                 nvarchar(050)   
					,FCST_TYPE                    nvarchar(020)   
					,FCST_ETD_DATE                nvarchar(008)    
					,FCST_ETA_DATE                nvarchar(008)    
					,ETD_DATE                     nvarchar(008)    
					,ETA_DATE                     nvarchar(008)    
					,INCOTERMS                    nvarchar(010)   
					,TRANSPORT_MODE               nvarchar(050)   
					,D_COUNTRY                    nvarchar(003)    
					,D_PORT_CODE                  nvarchar(010)   
					,A_COUNTRY                    nvarchar(003)    
					,A_PORT_CODE                  nvarchar(010)   
					,CUSTOMER_LT                  int            
					,TO_COUNTRY                   nvarchar(003)    
					,TO_CITY                      nvarchar(005)    
					,FROM_SITE_TYPE               nvarchar(001)    
					,FROM_SITE_PLANT_ID           nvarchar(030)   
					,FROM_SITE_VENDOR_ID          nvarchar(030)   
					,FROM_SITE_SOLDTO_CODE        nvarchar(010)   
					,FROM_SITE_SHIPTO_CODE        nvarchar(010)   
					,FROM_SITE_COMPANY_ID         nvarchar(030)   
					,TO_SITE_TYPE                 nvarchar(001)    
					,TO_SITE_PLANT_ID             nvarchar(030)   
					,TO_SITE_VENDOR_ID            nvarchar(030)   
					,TO_SITE_SOLDTO_CODE          nvarchar(010)   
					,TO_SITE_SHIPTO_CODE          nvarchar(010)   
					,TO_SITE_COMPANY_ID           nvarchar(030)   
					,CONFIRM_TYPE                 nvarchar(001)  -- 신규 확정:N (NEW) , 기확정 : O(OLD) 
					,COUNTRY                      nvarchar(002)     
					,COMPANY_ID                   nvarchar(030)
					,VMI_YN                       nvarchar(001)
					,ELECTRODE_YN                 nvarchar(001)
					,ELECTRODE_TYPE				  nvarchar(030)  
					,ORIGIN_FROM_DIVISION_ID	  nvarchar(030)
					,ORIGIN_TO_DIVISION_ID		  nvarchar(030)
					,BEFORE_QTY                   numeric(20,10)
					,REMARKS                      nvarchar(255)
					,CHECK_NEED_YN                nvarchar(001)
					,REQUESTOR                    nvarchar(100)
					
        );

	
 		------------------------------------------------------------------------------------------------------------- 
		-- 0-1. Time zone  , 해당 timezone에 해당하는 현재 시간 
		-------------------------------------------------------------------------------------------------------------
		SELECT @v_timezone =  C.SEGMENT1
		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
		WHERE  1=1
		AND    C.LOOKUP_TYPE = 'TIME_ZONE'
		AND    C.SEGMENT3    = 'KR' --@p_country       
        ; 

		SET    @v_time_for_timezone = DBO.FN_MULTY_TIME(@v_timezone) ;
	    SET    @v_time_for_system   = GETDATE() ;

    
		------------------------------------------------------------------------------------------------------------- 
		-- 1. SHIP_CONFIRM 입력 : 출하확정(신규) #tmp_SSP_ANL_SHIP_CONFIRM <-- SSP_ANL_SHIP_PLAN_C 
		--    신규확정일 경우 CONFIRM_ID 채번
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #tmp_SSP_ANL_SHIP_CONFIRM (
					 CONFIRM_ID
					,SHIPMENT_STATUS
					,DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,ITEM_ID
					,FROM_SITE
					,TO_SITE
					,YYYYMMDD
					,PLANNED_QTY
					,QTY
					,BOD_ID
					,ROUTE_ID
					,BIZ_TYPE
					,PROJECT_CODE
					,FCST_TYPE
					,FCST_ETD_DATE
					,FCST_ETA_DATE
					,ETD_DATE
					,ETA_DATE
					,INCOTERMS
					,TRANSPORT_MODE
					,D_COUNTRY
					,D_PORT_CODE
					,A_COUNTRY
					,A_PORT_CODE
					,CUSTOMER_LT
					,TO_COUNTRY
					,TO_CITY
					,FROM_SITE_TYPE
					,FROM_SITE_PLANT_ID
					,FROM_SITE_VENDOR_ID
					,FROM_SITE_SOLDTO_CODE
					,FROM_SITE_SHIPTO_CODE
					,FROM_SITE_COMPANY_ID
					,TO_SITE_TYPE
					,TO_SITE_PLANT_ID
					,TO_SITE_VENDOR_ID
					,TO_SITE_SOLDTO_CODE
					,TO_SITE_SHIPTO_CODE
					,TO_SITE_COMPANY_ID
					,CONFIRM_TYPE
					,COUNTRY
					,COMPANY_ID
					,VMI_YN
					,ELECTRODE_YN            
					,ELECTRODE_TYPE				   
					,ORIGIN_FROM_DIVISION_ID	
					,ORIGIN_TO_DIVISION_ID
					,BEFORE_QTY                   
					,REMARKS                      
					,CHECK_NEED_YN   
					,REQUESTOR   						
		  )
		SELECT 	 'C'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)      AS CONFIRM_ID			 
				,'C' AS SHIPMENT_STATUS
				,P.DIVISION_ID
				,P.PLAN_START_YYYYMMDD
				,'SP'AS PLAN_TYPE
				,1 AS SEQ
				,P.ITEM_ID
				,P.FROM_SITE
				,P.TO_SITE
				,P.YYYYMMDD
				, CASE WHEN  P.QTY <= ISNULL(L.LOT_SIZE ,P.QTY) THEN  P.QTY 
				  ELSE  
						CASE WHEN  P.QTY /(ISNULL(L.LOT_SIZE ,P.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,P.QTY)  
						ELSE P.QTY % (ISNULL(L.LOT_SIZE ,P.QTY)*(C.SEQ-1))
						END 
				  END															AS PLANNED_QTY
				, CASE WHEN  P.QTY <= ISNULL(L.LOT_SIZE ,P.QTY) THEN  P.QTY 
				  ELSE  
						CASE WHEN  P.QTY /(ISNULL(L.LOT_SIZE ,P.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,P.QTY)  
						ELSE P.QTY % (ISNULL(L.LOT_SIZE ,P.QTY)*(C.SEQ-1))
						END 
				  END															AS QTY
				,P.BOD_ID
				,P.ROUTE_ID
				,P.BIZ_TYPE
				,P.PROJECT_CODE
				,P.FCST_TYPE
				,P.FCST_ETD_DATE
				,P.FCST_ETA_DATE
				,P.ETD_DATE
				,P.ETA_DATE
				--,P.INCOTERMS
				,ISNULL(B.SSP_INCOTERMS, P.INCOTERMS) AS INCOTERMS
				,P.TRANSPORT_MODE
				,B.D_COUNTRY
				,B.D_PORT_CODE
				,B.A_COUNTRY
				,B.A_PORT_CODE
				,B.LT_TOTAL		AS  CUSTOMER_LT
				,B.TO_COUNTRY
				,B.TO_CITY
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'SITE_TYPE')   AS FROM_SITE_TYPE  
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'PLANT_ID')    AS FROM_SITE_PLANT_ID   
				-- 2020-08-24 11:19:51
				-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
				-- 2020-08-24  kimbl1
				,CASE WHEN ISNULL(FS.HQ_VENDOR_CODE, '') <> '' THEN FS.HQ_VENDOR_CODE
				 ELSE [DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'VENDOR_ID') END  AS FROM_SITE_VENDOR_ID  
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'COMPANY_ID')  AS FROM_SITE_COMPANY_ID 
				,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](P.DIVISION_ID, P.FROM_SITE,P.TO_SITE, 'SITE_TYPE')     AS TO_SITE_TYPE  -- [E20250821-001308]  -- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
				-- 2020-08-24 11:19:51
				-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
				-- 2020-08-24  kimbl1
				,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
				 ELSE [DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'VENDOR_ID') END    AS TO_SITE_VENDOR_ID  
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'SHIPTO_CODE')   AS TO_SITE_SHIPTO_CODE
				,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](P.DIVISION_ID,P.FROM_SITE, P.TO_SITE, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID -- [E20250821-001308]-- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용
				,'N' AS CONFIRM_TYPE  -- 신규확정
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'COUNTRY') AS COUNTRY      --FROM SITE의 COUNTRY
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.FROM_SITE, 'COMPANY_ID') AS COMPANY_ID  --FROM SITE의 COMPANY_ID
				,[DBO].[FN_GET_SSP_SITE_INFO](P.DIVISION_ID, P.TO_SITE, 'VMI_YN')    AS  VMI_YN     --TO SITE
				,'N' AS ELECTRODE_YN            
				,NULL AS ELECTRODE_TYPE				   
				,P.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID	
				,P.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
				,NULL AS BEFORE_QTY                   
				,NULL AS REMARKS                      
				,'Y'   AS CHECK_NEED_YN 
				, P.REQUESTOR AS REQUESTOR
		FROM   SSP_ANL_SHIP_PLAN_C P WITH(NOLOCK) 
			   JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
				ON  B.DIVISION_ID  = P.DIVISION_ID 
				AND B.BOD_ID       = P.BOD_ID
			   LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				ON L.DIVISION_ID     = P.DIVISION_ID 
				AND L.FROM_SITE      = P.FROM_SITE
				AND L.TO_SITE        = P.TO_SITE
				AND L.ITEM_ID        = P.ITEM_ID   
				AND L.TRANSPORT_MODE = P.TRANSPORT_MODE
				AND L.VALID_YN       = 'Y'
				AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
			JOIN SSP_MST_PARTIAL_SEQ C WITH(NOLOCK) -- LOT SIZE별 행 생성을 위한 기초테이블 
			ON C.SEQ <= CEILING(P.QTY/ISNULL(L.LOT_SIZE ,P.QTY))

			-- 2020-08-24 11:19:51
			-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
			-- 2020-08-24  kimbl1
			LEFT OUTER JOIN SCM_MST_SITE FS  WITH(NOLOCK)
						ON  FS.DIVISION_ID = P.DIVISION_ID 
						AND FS.SCM_SITE_ID = P.FROM_SITE 
						AND FS.VALID_YN    = 'Y' 
			LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
						ON  TS.DIVISION_ID = P.DIVISION_ID 
						AND TS.SCM_SITE_ID = P.TO_SITE 
						AND TS.VALID_YN    = 'Y' 
		WHERE  1=1 
		AND     P.COMPANY_ID = @v_company_id
		AND    P.PLAN_START_YYYYMMDD = @v_cutoff_date
		AND    P.MEASURE = 'SHIP_REQ' 
		AND    P.QTY > 0 
		--AND    [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) > 0 -- 확정일자 0이상인것만 
		AND    [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, P.PLAN_START_YYYYMMDD) > 0 -- 확정일자 0이상인것만 
		AND    ISNULL(P.CONFIRM_FLAG,'N') = 'N' -- BALANCE가 음수일 경우는 D, Y인건 기확정
		--AND    P.YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
		AND    P.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, @v_cutoff_next_date) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
        AND    NOT EXISTS (SELECT 1  -- 기존에 입력된 출하계획은 제외(hsbang, 20240514)
						   FROM   SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK) 
						   WHERE X.DIVISION_ID          = P.DIVISION_ID
							AND X.COMPANY_ID           = P.COMPANY_ID          
							--AND X.PLAN_START_YYYYMMDD  = P.PLAN_START_YYYYMMDD 
							AND X.ITEM_ID              = P.ITEM_ID             
							AND X.FROM_SITE            = P.FROM_SITE           
							AND X.TO_SITE              = P.TO_SITE             
							AND X.YYYYMMDD             = P.YYYYMMDD            
							AND X.BOD_ID               = P.BOD_ID              
							AND X.INCOTERMS            = P.INCOTERMS           
							AND X.TRANSPORT_MODE       = P.TRANSPORT_MODE      
							AND X.PROJECT_CODE         = P.PROJECT_CODE        
							AND X.FCST_TYPE            = P.FCST_TYPE   
							AND X.MEASURE              = P.MEASURE
							AND ISNULL(X.CONFIRM_FLAG,'N') = 'Y'
						   )		
			-- START [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경 
			-- FP PROD 자동생성 항목 제외
			AND NOT EXISTS ( 
				SELECT 1 
				FROM  SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
				WHERE L.LOOKUP_TYPE = 'FP_AUTO_SHIP_FROM_TO'
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1 = P.DIVISION_ID
				AND L.SEGMENT2 = P.FROM_SITE
				AND L.SEGMENT4 = P.ITEM_ID
			)
			-- END [E20260629-000018] SSP 출하 계획 변경 FP 생산기반 CUTOFF 수행 기능 변경
		;

		------------------------------------------------------------------------------------------------------------- 
		-- 2. SHIP_CONFIRM 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM
		-- 신규 건만 생성
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO SSP_ANL_SHIP_CONFIRM (
				 CONFIRM_ID
                ,CHANGE_TYPE
				,SHIPMENT_STATUS
				,DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,YYYYMMDD
				,PLANNED_QTY
				,QTY
				,BOD_ID
				,ROUTE_ID
				,BIZ_TYPE
				,PROJECT_CODE
				,FCST_TYPE
				,FCST_ETD_DATE
				,FCST_ETA_DATE
				,ETD_DATE
				,ETA_DATE
				,INCOTERMS
				,TRANSPORT_MODE
				,D_COUNTRY
				,D_PORT_CODE
				,A_COUNTRY
				,A_PORT_CODE
				,CUSTOMER_LT
				,TO_COUNTRY
				,TO_CITY
				,FROM_SITE_TYPE
				,FROM_SITE_PLANT_ID
				,FROM_SITE_VENDOR_ID
				,FROM_SITE_SOLDTO_CODE
				,FROM_SITE_SHIPTO_CODE
				,FROM_SITE_COMPANY_ID
				,TO_SITE_TYPE
				,TO_SITE_PLANT_ID
				,TO_SITE_VENDOR_ID
				,TO_SITE_SOLDTO_CODE
				,TO_SITE_SHIPTO_CODE
				,TO_SITE_COMPANY_ID
				,CHANGE_REQ_NO
				,ERP_SO_NO
				,ERP_SO_ITEM_NO
				,ERP_DO_NO
				,ERP_STATUS
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ELECTRODE_YN            
				,ELECTRODE_TYPE				   
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID	
			    ,BEFORE_QTY             
			    ,REMARKS                
			    ,CHECK_NEED_YN
				,REQUESTOR
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,PACKAGE_TYPE_CODE 
				,FACTORY_ID 
				,PACKAGE_QTY
				,DOM_EXP
				,ERP_ATTR1
				,ERP_ATTR2
				,ERP_ATTR3
				,ERP_ATTR4
				,ERP_ATTR5
		  )
		  SELECT A.CONFIRM_ID
		        ,'C' -- 확정:C , 계획 : P
				,A.SHIPMENT_STATUS
				,A.DIVISION_ID
				,A.PLAN_START_YYYYMMDD
				,A.PLAN_TYPE
				,A.SEQ
				,A.ITEM_ID
				,A.FROM_SITE
				,A.TO_SITE
				,A.YYYYMMDD
				,A.PLANNED_QTY
				,A.QTY
				,A.BOD_ID
				,A.ROUTE_ID
				,A.BIZ_TYPE
				,A.PROJECT_CODE
				,A.FCST_TYPE
				,A.FCST_ETD_DATE
				,A.FCST_ETA_DATE
				,A.ETD_DATE
				,A.ETA_DATE
				,A.INCOTERMS
				,A.TRANSPORT_MODE
				,A.D_COUNTRY
				,A.D_PORT_CODE
				,A.A_COUNTRY
				,A.A_PORT_CODE
				,A.CUSTOMER_LT
				,A.TO_COUNTRY
				,A.TO_CITY
				,A.FROM_SITE_TYPE
				,A.FROM_SITE_PLANT_ID
				,A.FROM_SITE_VENDOR_ID
				,A.FROM_SITE_SOLDTO_CODE
				,A.FROM_SITE_SHIPTO_CODE
				,A.FROM_SITE_COMPANY_ID
				,A.TO_SITE_TYPE
				,A.TO_SITE_PLANT_ID
				,A.TO_SITE_VENDOR_ID
				,A.TO_SITE_SOLDTO_CODE
				,A.TO_SITE_SHIPTO_CODE
				,A.TO_SITE_COMPANY_ID
				,NULL -- CHANGE_REQ_NO
				,NULL -- ERP_SO_NO
				,NULL -- ERP_SO_ITEM_NO
				,NULL -- ERP_DO_NO
				,NULL -- ERP_STATUS
				,@v_batch_user    -- CREATED_BY    
				,@v_time_for_system  -- CREATION_DATE   
				,@v_batch_user    -- LAST_UPDATED_BY
				,@v_time_for_system  -- LAST_UPDATE_DATE
				,A.ELECTRODE_YN            
				,A.ELECTRODE_TYPE				   
				,A.ORIGIN_FROM_DIVISION_ID	
				,A.ORIGIN_TO_DIVISION_ID	
			    ,A.BEFORE_QTY             
			    ,A.REMARKS   
			    ,A.CHECK_NEED_YN   
				,A.REQUESTOR
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,E.PACKAGE_TYPE_CODE 
				,E.FACTORY_ID
				,CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 		                        WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 		                        WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 		            ELSE ISNULL(A.QTY,0)  END)		AS PACKAGE_QTY
				,E.DOM_EXP_TYPE AS DOM_EXP
				,NULL       AS ERP_ATTR1
				,NULL       AS ERP_ATTR2
				,NULL       AS ERP_ATTR3
				,NULL       AS ERP_ATTR4
				,NULL       AS ERP_ATTR5
		  FROM  #tmp_SSP_ANL_SHIP_CONFIRM  A WITH (NOLOCK)
				LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
				     ON A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
                    AND A.FROM_SITE        = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
					AND A.ITEM_ID          = E.ITEM_ID
		  WHERE  CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
		;

		------------------------------------------------------------------------------------------------------------- 
		-- 4. SHIP_CONFIRM HISTORY 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM_H
		-- 신규 건만 생성
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO SSP_ANL_SHIP_CONFIRM_H (
				 HISTORY_SEQ
				,CONFIRM_ID
				,CHANGE_TYPE
				,SHIPMENT_STATUS
				,DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,ITEM_ID
				,FROM_SITE
				,TO_SITE
				,YYYYMMDD
				,PLANNED_QTY
				,QTY
				,BOD_ID
				,ROUTE_ID
				,BIZ_TYPE
				,PROJECT_CODE
				,FCST_TYPE
				,FCST_ETD_DATE
				,FCST_ETA_DATE
				,ETD_DATE
				,ETA_DATE
				,INCOTERMS
				,TRANSPORT_MODE
				,D_COUNTRY
				,D_PORT_CODE
				,A_COUNTRY
				,A_PORT_CODE
				,CUSTOMER_LT
				,TO_COUNTRY
				,TO_CITY
				,FROM_SITE_TYPE
				,FROM_SITE_PLANT_ID
				,FROM_SITE_VENDOR_ID
				,FROM_SITE_SOLDTO_CODE
				,FROM_SITE_SHIPTO_CODE
				,FROM_SITE_COMPANY_ID
				,TO_SITE_TYPE
				,TO_SITE_PLANT_ID
				,TO_SITE_VENDOR_ID
				,TO_SITE_SOLDTO_CODE
				,TO_SITE_SHIPTO_CODE
				,TO_SITE_COMPANY_ID
				,CHANGE_REQ_NO
				,ERP_SO_NO
				,ERP_SO_ITEM_NO
				,ERP_DO_NO
				,ERP_STATUS
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,HISTORY_CREATION_DATE
				,ELECTRODE_YN            
				,ELECTRODE_TYPE				   
				,ORIGIN_FROM_DIVISION_ID	
				,ORIGIN_TO_DIVISION_ID	
			    ,BEFORE_QTY             
			    ,REMARKS   
			    ,CHECK_NEED_YN 
				,REQUESTOR 
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,PACKAGE_TYPE_CODE 
				,FACTORY_ID 
				,PACKAGE_QTY
				,DOM_EXP
				,ERP_ATTR1
				,ERP_ATTR2
				,ERP_ATTR3
				,ERP_ATTR4
				,ERP_ATTR5
		  )
		  SELECT NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_CONFIRM_H  -- HISTORY_SEQ
		        ,A.CONFIRM_ID
				,'C'
				,A.SHIPMENT_STATUS
				,A.DIVISION_ID
				,A.PLAN_START_YYYYMMDD
				,A.PLAN_TYPE
				,A.SEQ
				,A.ITEM_ID
				,A.FROM_SITE
				,A.TO_SITE
				,A.YYYYMMDD
				,A.PLANNED_QTY
				,A.QTY
				,A.BOD_ID
				,A.ROUTE_ID
				,A.BIZ_TYPE
				,A.PROJECT_CODE
				,A.FCST_TYPE
				,A.FCST_ETD_DATE
				,A.FCST_ETA_DATE
				,A.ETD_DATE
				,A.ETA_DATE
				,A.INCOTERMS
				,A.TRANSPORT_MODE
				,A.D_COUNTRY
				,A.D_PORT_CODE
				,A.A_COUNTRY
				,A.A_PORT_CODE
				,A.CUSTOMER_LT
				,A.TO_COUNTRY
				,A.TO_CITY
				,A.FROM_SITE_TYPE
				,A.FROM_SITE_PLANT_ID
				,A.FROM_SITE_VENDOR_ID
				,A.FROM_SITE_SOLDTO_CODE
				,A.FROM_SITE_SHIPTO_CODE
				,A.FROM_SITE_COMPANY_ID
				,A.TO_SITE_TYPE
				,A.TO_SITE_PLANT_ID
				,A.TO_SITE_VENDOR_ID
				,A.TO_SITE_SOLDTO_CODE
				,A.TO_SITE_SHIPTO_CODE
				,A.TO_SITE_COMPANY_ID
				,NULL -- CHANGE_REQ_NO
				,NULL -- ERP_SO_NO
				,NULL -- ERP_SO_ITEM_NO
				,NULL -- ERP_DO_NO
				,NULL -- ERP_STATUS
				,@v_batch_user    -- CREATED_BY
				,@v_time_for_system  -- CREATION_DATE
				,@v_batch_user    -- LAST_UPDATED_BY
				,@v_time_for_system  -- LAST_UPDATE_DATE
				,@v_time_for_system  -- HISTORY_CREATION_DATE
				,A.ELECTRODE_YN            
				,A.ELECTRODE_TYPE				   
				,A.ORIGIN_FROM_DIVISION_ID	
				,A.ORIGIN_TO_DIVISION_ID
			    ,A.BEFORE_QTY             
			    ,A.REMARKS   
			    ,A.CHECK_NEED_YN  
				,A.REQUESTOR					
				/*----------------------------------------------------------------------------------------
					2020.06.30 : KBK
					I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				------------------------------------------------------------------------------------------*/
				,E.PACKAGE_TYPE_CODE 
				,E.FACTORY_ID
				,CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 		                        WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 		                        WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 		            ELSE ISNULL(A.QTY,0)  END)		AS PACKAGE_QTY
				,E.DOM_EXP_TYPE AS DOM_EXP
				,NULL       AS ERP_ATTR1
				,NULL       AS ERP_ATTR2
				,NULL       AS ERP_ATTR3
				,NULL       AS ERP_ATTR4
				,NULL       AS ERP_ATTR5
		    FROM #tmp_SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
				 LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
			  ON A.DIVISION_ID		= (CASE WHEN A.BIZ_TYPE = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
             AND A.FROM_SITE        = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
		     AND A.ITEM_ID          = E.ITEM_ID
		   WHERE A.CONFIRM_TYPE		= 'N' -- 신규 확정건인 경우
		;

		------------------------------------------------------------------------------------------------------------- 
		-- 5. ERP 전송을 위한 I/F 데이터 생성
		-- 신규 건만 전송
		-- I/F는 법인별로 처리 분리하여 처리 
		-- 40(소형) FROM_SITE가 PACKER인 경우 PACKER에 해당하는 모델로 변환 
		------------------------------------------------------------------------------------------------------------- 
		--CURSOR 선언 
		DECLARE @company_id VARCHAR(30), @from_site VARCHAR(30) , @yyyymmdd VARCHAR(8)
		DECLARE @idx INT     SET     @idx = 0 


		DECLARE CUR_ERP_S CURSOR FOR  
		SELECT   C.COMPANY_ID
		,        MAX(C.YYYYMMDD) AS YYYYMMDD 
		FROM  #tmp_SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
		WHERE 1=1 
		AND   C.COMPANY_ID          = @v_company_id 
		AND   C.CONFIRM_TYPE = 'N'  -- 신규건만 전송 
		GROUP BY   C.COMPANY_ID
		;

		OPEN CUR_ERP_S; 

		FETCH NEXT FROM CUR_ERP_S INTO @company_id , @yyyymmdd

			WHILE(@@FETCH_STATUS = 0) 

			BEGIN; 
				--Idx 1씩 증가 
				SET @idx = @idx + 1 

				-- IFSEQNO 생성
				--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
				--FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN WITH(NOLOCK)
				--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

				SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

			  
				INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
						   (IFSEQNO
				           ,CONFIRM_ID
				           ,SHIPMENT_STATUS
				           ,LAST_CONFIRM_DATE
				           ,VERSION_TYPE
				           ,SALES_COMPANY_ID
				           ,DIVISION_ID
				           ,ITEM_ID
				           ,FROM_SITE
				           ,TO_SITE
				           ,YYYYMMDD
				           ,QTY
				           ,BOD_ID
				           ,ROUTE_ID
				           ,OPERATION_GROUP
				           ,BIZ_TYPE
				           ,PROJECT_CODE
				           ,FCST_TYPE
				           ,FCST_ETD_DATE
				           ,FCST_ETA_DATE
				           ,ETD_DATE
				           ,ETA_DATE
				           ,INCOTERMS
				           ,INCOTERMS2
				           ,TRANSPORT_MODE
				           ,D_COUNTRY
				           ,D_PORT_CODE
				           ,A_COUNTRY
				           ,A_PORT_CODE
				           ,CUSTOMER_LT
				           ,TO_COUNTRY
				           ,TO_CITY
				           ,FROM_SITE_TYPE
				           ,FROM_SITE_PLANT_ID
				           ,FROM_SITE_VENDOR_ID
				           ,FROM_SITE_SOLDTO_CODE
				           ,FROM_SITE_SHIPTO_CODE
				           ,FROM_SITE_COMPANY_ID
				           ,TO_SITE_TYPE
				           ,TO_SITE_PLANT_ID
				           ,TO_SITE_VENDOR_ID
				           ,TO_SITE_SOLDTO_CODE
				           ,TO_SITE_SHIPTO_CODE
				           ,TO_SITE_COMPANY_ID
				           ,BUILDING
				           ,REMARK
				           ,CUSTOMER_REQ
				           ,CHANGE_CODE
				           ,CHANGE_CODE_NAME
				           ,REQUESTOR
				           ,TRANSFER_FLAG
				           ,TRANSFER_DATE
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
				           /*----------------------------------------------------------------------------------------
				           	2020.06.30 : KBK
				           	I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
				           ------------------------------------------------------------------------------------------*/
				           ,PACKAGE_TYPE
				           ,FACTORY_ID 
				           ,PACKAGE_QTY
				           ,DOM_EXP
				           ,ERP_ATTR1
				           ,ERP_ATTR2
				           ,ERP_ATTR3
				           ,ERP_ATTR4
				           ,ERP_ATTR5
				           )
					SELECT A.IFSEQNO
						,A.CONFIRM_ID
						,A.SHIPMENT_STATUS
						,A.LAST_CONFIRM_DATE
						,A.VERSION_TYPE
						,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID
						,A.DIVISION_ID
						,A.ITEM_ID
						,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
						,ISNULL(X3.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
						,A.YYYYMMDD
						,A.QTY
						,A.BOD_ID
						,A.ROUTE_ID
						,A.OPERATION_GROUP
						,A.BIZ_TYPE
						,A.PROJECT_CODE
						,A.FCST_TYPE
						,A.FCST_ETD_DATE
						,A.FCST_ETA_DATE
						,A.ETD_DATE
						,A.ETA_DATE
						,A.INCOTERMS
						,A.INCOTERMS2
						,A.TRANSPORT_MODE
						,A.D_COUNTRY
						,A.D_PORT_CODE
						,A_COUNTRY
						,A_PORT_CODE
						,A.CUSTOMER_LT
						,A.TO_COUNTRY
						,A.TO_CITY
						,A.FROM_SITE_TYPE
						,ISNULL(X4.NEW_VALUE1, A.FROM_SITE_PLANT_ID)		AS FROM_SITE_PLANT_ID
						,ISNULL(X5.NEW_VALUE1, A.FROM_SITE_VENDOR_ID)		AS FROM_SITE_VENDOR_ID
						,ISNULL(X6.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE)		AS FROM_SITE_SOLDTO_CODE
						,ISNULL(X7.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE)		AS FROM_SITE_SHIPTO_CODE
						,ISNULL(X8.NEW_VALUE1, A.FROM_SITE_COMPANY_ID)		AS FROM_SITE_COMPANY_ID
						,A.TO_SITE_TYPE
						,ISNULL(X9.NEW_VALUE1, A.TO_SITE_PLANT_ID)			AS TO_SITE_PLANT_ID
						,ISNULL(X10.NEW_VALUE1, A.TO_SITE_VENDOR_ID)		AS TO_SITE_VENDOR_ID
						,ISNULL(X11.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
						,ISNULL(X12.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
						,ISNULL(X13.NEW_VALUE1, A.TO_SITE_COMPANY_ID)		AS TO_SITE_COMPANY_ID
						,A.BUILDING
						,A.REMARK
						,A.CUSTOMER_REQ
						,A.CHANGE_CODE
						,A.CHANGE_CODE_NAME
						,A.REQUESTOR
						,A.TRANSFER_FLAG
						,A.TRANSFER_DATE
						,A.CREATED_BY
						,A.CREATION_DATE
						,A.LAST_UPDATED_BY
						,A.LAST_UPDATE_DATE
						,A.ATTRIBUTE1
						,A.ATTRIBUTE2
						,A.ATTRIBUTE3
						,A.ATTRIBUTE4
						,A.ATTRIBUTE5
						,A.ATTRIBUTE6
						,A.ATTRIBUTE7
						,A.ATTRIBUTE8
						,A.ATTRIBUTE9
						,A.ATTRIBUTE10
						/*----------------------------------------------------------------------------------------
						2020.06.30 : KBK
						I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,A.PACKAGE_TYPE_CODE 
						,A.FACTORY_ID
						,A.PACKAGE_QTY
						,A.DOM_EXP
						,NULL       AS ERP_ATTR1
						,NULL       AS ERP_ATTR2
						,NULL       AS ERP_ATTR3
						,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
						,NULL       AS ERP_ATTR5
					FROM
					(
						 SELECT A.IFSEQNO
							   ,A.CONFIRM_ID
							   ,A.SHIPMENT_STATUS
							   ,A.LAST_CONFIRM_DATE
							   ,A.VERSION_TYPE
							   ,A.SALES_COMPANY_ID
							   --,A.DIVISION_ID
							   ,D.ATTRIBUTE3 AS DIVISION_ID
							   ,A.ITEM_ID
							   ,A.FROM_SITE
							   ,A.TO_SITE
							   ,A.YYYYMMDD
							   ,A.QTY
							   ,A.BOD_ID
							   ,A.ROUTE_ID
							   ,A.OPERATION_GROUP
							   ,A.BIZ_TYPE
							   ,A.PROJECT_CODE
							   ,A.FCST_TYPE
							   ,A.FCST_ETD_DATE
							   ,A.FCST_ETA_DATE
							   ,A.ETD_DATE
							   ,A.ETA_DATE
							   ,A.INCOTERMS
							   ,A.INCOTERMS2
							   ,A.TRANSPORT_MODE
							   ,A.D_COUNTRY
							   ,A.D_PORT_CODE
							   ,A_COUNTRY
							   ,A_PORT_CODE
							   ,A.CUSTOMER_LT
							   ,A.TO_COUNTRY
							   ,A.TO_CITY
							   ,A.FROM_SITE_TYPE
							   ,A.FROM_SITE_PLANT_ID
							   ,A.FROM_SITE_VENDOR_ID
							   ,A.FROM_SITE_SOLDTO_CODE
							   ,A.FROM_SITE_SHIPTO_CODE
							   ,A.FROM_SITE_COMPANY_ID
							   ,A.TO_SITE_TYPE
							   ,A.TO_SITE_PLANT_ID
							   ,A.TO_SITE_VENDOR_ID
							   ,A.TO_SITE_SOLDTO_CODE
							   ,A.TO_SITE_SHIPTO_CODE
							   ,A.TO_SITE_COMPANY_ID
							   ,A.BUILDING
							   ,A.REMARK
							   ,A.CUSTOMER_REQ
							   ,A.CHANGE_CODE
							   ,A.CHANGE_CODE_NAME
							   ,A.REQUESTOR
							   ,A.TRANSFER_FLAG
							   ,A.TRANSFER_DATE
							   ,A.CREATED_BY
							   ,A.CREATION_DATE
							   ,A.LAST_UPDATED_BY
							   ,A.LAST_UPDATE_DATE
							   ,A.ATTRIBUTE1
							   ,A.ATTRIBUTE2
							   ,A.ATTRIBUTE3
							   ,A.ATTRIBUTE4
							   ,A.ATTRIBUTE5
							   ,A.ATTRIBUTE6
							   ,A.ATTRIBUTE7
							   ,A.ATTRIBUTE8
							   ,A.ATTRIBUTE9
							   ,A.ATTRIBUTE10
							   /*----------------------------------------------------------------------------------------
						   		2020.06.30 : KBK
						   		I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							   ------------------------------------------------------------------------------------------*/
							   ,E.PACKAGE_TYPE_CODE 
							   ,E.FACTORY_ID
							   ,CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 						   					WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 						   					WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(A.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 						   		ELSE ISNULL(A.QTY,0)  END)		AS PACKAGE_QTY
							   ,E.DOM_EXP_TYPE AS DOM_EXP
						   FROM (
								SELECT @v_infseqno  AS  IFSEQNO -- IFSEQNO
									  ,A.CONFIRM_ID
									  ,'A'  AS  SHIPMENT_STATUS  -- I_PLGB  A: 확정  
									  ,@yyyymmdd   AS LAST_CONFIRM_DATE -- I_DATE  확정구간 마지막 일자 
									  ,'B' AS VERSION_TYPE  -- B:NEW/A:OLD 
									  ,ISNULL(C.ATTRIBUTE2, B.ATTRIBUTE2)  AS SALES_COMPANY_ID
									  ,CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END  AS DIVISION_ID
									  ,A.ITEM_ID AS ITEM_ID
									  ,A.FROM_SITE
									  ,A.TO_SITE
									  ,A.YYYYMMDD
									  ,A.QTY
									  ,A.BOD_ID
									  ,A.ROUTE_ID
									  ,A.BIZ_TYPE AS OPERATION_GROUP
									  ,A.BIZ_TYPE
									  ,CASE WHEN A.PROJECT_CODE IS NULL OR A.PROJECT_CODE ='' OR A.PROJECT_CODE ='-' THEN 'TBD' ELSE A.PROJECT_CODE END   AS PROJECT_CODE
									  ,A.FCST_TYPE
									  ,A.FCST_ETD_DATE
									  ,A.FCST_ETA_DATE
									  ,A.ETD_DATE
									  ,A.ETA_DATE
									  ,CASE WHEN VMI_YN = 'Y' THEN ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS]( CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END 
							      																				, A.FROM_SITE, A.TO_SITE, A.ITEM_ID
							      																				, A.PROJECT_CODE
							      																				, A.FCST_TYPE
							      																				, A.YYYYMMDD), A.INCOTERMS ) 
							      			ELSE A.INCOTERMS END   AS INCOTERMS
									  ,NULL AS INCOTERMS2
									  ,A.TRANSPORT_MODE
									  ,A.D_COUNTRY
									  ,A.D_PORT_CODE
									  ,A.A_COUNTRY
									  ,A.A_PORT_CODE
									  ,A.CUSTOMER_LT
									  ,A.TO_COUNTRY
									  ,A.TO_CITY
									  ,A.FROM_SITE_TYPE
									  ,A.FROM_SITE_PLANT_ID
									  ,A.FROM_SITE_VENDOR_ID
									  ,A.FROM_SITE_SOLDTO_CODE
									  ,A.FROM_SITE_SHIPTO_CODE
									  ,A.FROM_SITE_COMPANY_ID
									  ,A.TO_SITE_TYPE
									  ,A.TO_SITE_PLANT_ID
									  ,A.TO_SITE_VENDOR_ID
									  ,A.TO_SITE_SOLDTO_CODE
									  ,A.TO_SITE_SHIPTO_CODE
									  ,A.TO_SITE_COMPANY_ID
									  ,NULL AS BUILDING
									  ,NULL AS REMARK
									  ,NULL AS CUSTOMER_REQ
									  ,NULL AS CHANGE_CODE
									  ,NULL AS CHANGE_CODE_NAME
									  ,A.REQUESTOR AS REQUESTOR
									  ,'N'                 AS TRANSFER_FLAG
									  ,@v_time_for_system  AS TRANSFER_DATE
									  ,@v_batch_user       AS CREATED_BY
									  ,@v_time_for_system  AS CREATION_DATE
									  ,@v_batch_user       AS LAST_UPDATED_BY
									  ,@v_time_for_system  AS LAST_UPDATE_DATE
									  ,NULL AS ATTRIBUTE1
									  ,NULL AS ATTRIBUTE2
									  ,NULL AS ATTRIBUTE3
									  ,NULL AS ATTRIBUTE4
									  ,NULL AS ATTRIBUTE5
									  ,NULL AS ATTRIBUTE6
									  ,NULL AS ATTRIBUTE7
									  ,NULL AS ATTRIBUTE8
									  ,NULL AS ATTRIBUTE9
									  ,A.ELECTRODE_YN AS ATTRIBUTE10
								  FROM #tmp_SSP_ANL_SHIP_CONFIRM A WITH(NOLOCK)
									   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
									ON B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
								   AND B.VALID_YN   = 'Y'
								   AND B.SEGMENT1 = A.FROM_SITE_COMPANY_ID 
								   AND B.SEGMENT3 = A.FROM_SITE
								   AND B.SEGMENT4 = A.TO_SITE_COMPANY_ID 
								   AND B.SEGMENT5 = A.TO_SITE 
									   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  C WITH(NOLOCK) 
									ON C.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
								   AND C.VALID_YN   = 'Y'
								   AND C.SEGMENT1 = A.FROM_SITE_COMPANY_ID 
								   AND C.SEGMENT3 = A.FROM_SITE
								   AND C.SEGMENT4 = A.TO_SITE_COMPANY_ID 
								   AND C.ATTRIBUTE1 = A.TO_SITE 
								 WHERE 1 = 1 
								   AND CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
								   AND COMPANY_ID      =  @company_id
								   AND ISNULL(QTY,0) <> 0  -- 0은IF 제외 
								) A
					   			JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
							 ON A.DIVISION_ID   = D.DIVISION_ID
								LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							 ON A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.DIVISION_ID ELSE  E.ASSY_DIVISION_ID END)
							AND A.FROM_SITE        = (CASE WHEN A.BIZ_TYPE = 'E' THEN E.SCM_SITE_ID ELSE  E.ASSY_SCM_SITE_ID END)
							AND A.ITEM_ID          = E.ITEM_ID
						  WHERE 1 = 1
					) A
					LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'COMPANY_ID'	AND A.SALES_COMPANY_ID = X1.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'SCP_SITE_ID' AND A.FROM_SITE = X2.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'SCP_SITE_ID' AND A.TO_SITE = X3.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'PLANT_ID'	AND A.FROM_SITE_PLANT_ID = X4.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X5 WITH(NOLOCK) ON X5.CODETYPE = 'VENDOR_ID'	AND A.FROM_SITE_VENDOR_ID = X5.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X6 WITH(NOLOCK) ON X6.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SOLDTO_CODE = X6.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X7 WITH(NOLOCK) ON X7.CODETYPE = 'END_CUSTOMER_ID' AND A.FROM_SITE_SHIPTO_CODE = X7.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X8 WITH(NOLOCK) ON X8.CODETYPE = 'COMPANY_ID' AND A.FROM_SITE_COMPANY_ID = X8.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X9 WITH(NOLOCK) ON X9.CODETYPE = 'PLANT_ID'	AND A.TO_SITE_PLANT_ID = X9.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X10 WITH(NOLOCK) ON X10.CODETYPE = 'VENDOR_ID'	AND A.TO_SITE_VENDOR_ID = X10.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X11 WITH(NOLOCK) ON X11.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X11.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X12 WITH(NOLOCK) ON X12.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SHIPTO_CODE = X12.OLD_VALUE1
					LEFT OUTER JOIN NERP_CONV_MASTER X13 WITH(NOLOCK) ON X13.CODETYPE = 'COMPANY_ID' AND  A.TO_SITE_COMPANY_ID = X13.OLD_VALUE1

				      ;

				FETCH NEXT FROM CUR_ERP_S INTO @company_id , @yyyymmdd ; 
	
			END; 

		CLOSE CUR_ERP_S; 
		DEALLOCATE CUR_ERP_S;

		-- IF data  삭제 (90일 이전 데이터 삭제) 
		DELETE 
		FROM  XIF_ERP_SHIP_PLAN_CONFIRM_S_SN   
		WHERE CREATION_DATE < GETDATE() - 90 
		;

	    ------------------------------------------------------------------------------------------------------------- 
		-- 6. UPDATE SSP_ANL_SHIP_PLAN_C
		-------------------------------------------------------------------------------------------------------------
		UPDATE SSP_ANL_SHIP_PLAN_C
        SET    CONFIRM_FLAG  = 'Y'
		,      CONFIRM_ID    =  C.CONFIRM_ID
		,      LAST_UPDATE_DATE = GETDATE()
		,      LAST_UPDATED_BY  = @v_batch_user
		FROM   SSP_ANL_SHIP_PLAN_C P WITH(NOLOCK)
			JOIN #tmp_SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
			 ON P.DIVISION_ID          = C.DIVISION_ID
			AND P.COMPANY_ID           = C.COMPANY_ID          
			AND P.PLAN_START_YYYYMMDD  = C.PLAN_START_YYYYMMDD 
			AND P.ITEM_ID              = C.ITEM_ID             
			AND P.FROM_SITE            = C.FROM_SITE           
			AND P.TO_SITE              = C.TO_SITE             
			AND P.YYYYMMDD             = C.YYYYMMDD            
			AND P.BOD_ID               = C.BOD_ID              
			AND P.INCOTERMS            = C.INCOTERMS           
			AND P.TRANSPORT_MODE       = C.TRANSPORT_MODE      
			AND P.PROJECT_CODE         = C.PROJECT_CODE        
			AND P.FCST_TYPE            = C.FCST_TYPE   
			AND P.MEASURE              = 'SHIP_REQ'  
		WHERE 1=1 
		AND    P.COMPANY_ID = @v_company_id
		AND    P.PLAN_START_YYYYMMDD = @v_cutoff_date
		AND    P.MEASURE = 'SHIP_REQ' 
		AND    P.QTY > 0 
		--AND    [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) > 0 -- 확정일자 0이상인것만 
		AND    [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, P.PLAN_START_YYYYMMDD) > 0 -- 확정일자 0이상인것만 
		--AND    P.YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
		AND    P.YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, @v_cutoff_next_date) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
        
		/* BALANCE가 음수일 경우 확정 제외 로직 제거 (Requested by 김광희) 20200506
		AND    NOT EXISTS (SELECT 1  -- BALANCE가 음수일 경우 확정 제외 ( DIVISION, FROM_SITE, ITEM기준) 
						   FROM   SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK) 
		                   WHERE  X.DIVISION_ID = P.DIVISION_ID
						   AND    X.COMPANY_ID  = P.COMPANY_ID
						   AND    X.PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD
						   AND    X.FROM_SITE = P.FROM_SITE
						   AND    X.ITEM_ID = P.ITEM_ID
						   AND    X.MEASURE = 'BALANCE'
						   AND    X.YYYYMMDD = P.YYYYMMDD
						   AND    X.QTY < 0 
						   AND    X.FROM_SITE NOT IN ('A040-P','A040-A') -- 오창 Pack Cell은 제외(2019.10.29) 
						   AND    X.DIVISION_ID <> '82' -- ESS 82 사업부  제외(2020.02.26 requested by  김광희) 
						   )        
        */
		;	
		
		-- 기존 존재하는 ITEM은 CONFIRM_ID 없이 CONFIRM_FLAG = 'Y' 처리
		UPDATE SSP_ANL_SHIP_PLAN_C
        SET    CONFIRM_FLAG  = 'Y'
		,      LAST_UPDATE_DATE = GETDATE()
		,      LAST_UPDATED_BY  = @v_batch_user
		FROM   SSP_ANL_SHIP_PLAN_C P WITH(NOLOCK)
		WHERE  1=1 
		AND    P.COMPANY_ID = @v_company_id
		AND    P.PLAN_START_YYYYMMDD = @v_cutoff_date
		AND    P.MEASURE = 'SHIP_REQ' 
		AND    P.QTY > 0 
		--AND    [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) > 0 -- 확정일자 0이상인것만 
		AND    [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, P.PLAN_START_YYYYMMDD) > 0 -- 확정일자 0이상인것만 
		AND    ISNULL(P.CONFIRM_FLAG,'N') = 'N' -- BALANCE가 음수일 경우는 D, Y인건 기확정
		--AND    P.YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
		AND    YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, P.DIVISION_ID,P.FROM_SITE, @v_cutoff_next_date) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
        AND    EXISTS (SELECT 1  -- 기존에 입력된 출하계획은 제외(hsbang, 20240514)
						   FROM   SSP_ANL_SHIP_PLAN_C X WITH(NOLOCK) 
						   WHERE X.DIVISION_ID          = P.DIVISION_ID
							AND X.COMPANY_ID           = P.COMPANY_ID          
							--AND X.PLAN_START_YYYYMMDD  = P.PLAN_START_YYYYMMDD 
							AND X.ITEM_ID              = P.ITEM_ID             
							AND X.FROM_SITE            = P.FROM_SITE           
							AND X.TO_SITE              = P.TO_SITE             
							AND X.YYYYMMDD             = P.YYYYMMDD            
							AND X.BOD_ID               = P.BOD_ID              
							AND X.INCOTERMS            = P.INCOTERMS           
							AND X.TRANSPORT_MODE       = P.TRANSPORT_MODE      
							AND X.PROJECT_CODE         = P.PROJECT_CODE        
							AND X.FCST_TYPE            = P.FCST_TYPE   
							AND X.MEASURE              = P.MEASURE
							AND ISNULL(X.CONFIRM_FLAG,'N') = 'Y'
						   )
		;

		-- CONFIRM되지 않은 내용 표시 CONFIRM_FLAG = 'D' 로 UPDATE 
		UPDATE SSP_ANL_SHIP_PLAN_C 
        SET    CONFIRM_FLAG  = 'D' --  BALANCE가 음수일 경우 CONFIRM되지 않은 데이터 
		,      LAST_UPDATE_DATE = GETDATE()
		,      LAST_UPDATED_BY  = @v_batch_user	
		WHERE 1=1 
		AND    COMPANY_ID = @v_company_id
		AND    PLAN_START_YYYYMMDD = @v_cutoff_date
		AND    MEASURE = 'SHIP_REQ' 
		AND    QTY > 0 
		--AND    [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](DIVISION_ID, FROM_SITE) > 0 -- 확정일자 0이상인것만 
		AND    [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, DIVISION_ID, FROM_SITE, PLAN_START_YYYYMMDD) > 0 -- 확정일자 0이상인것만 
		AND    ISNULL(CONFIRM_FLAG,'N') = 'N' -- BALANCE가 음수일 경우는 D, Y인건 기확정
		--AND    YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](DIVISION_ID,FROM_SITE) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
		AND    YYYYMMDD <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, DIVISION_ID,FROM_SITE, @v_cutoff_next_date) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112)
		;

		------------------------------------------------------------------------------------------------------------- 
		-- 7. SHIP_CONFIRM_ROUTE 입력 : 출하확정계획물류경로기본 SSP_ANL_SHIP_CONFIRM_ROUTE
		-- 
		------------------------------------------------------------------------------------------------------------- 
		DECLARE @V_INX		INT	= 0;
		DECLARE @V_MAX_NUM	INT	= 0;

		declare @lv_confirm_id nvarchar(20);
		declare @lv_route_id   bigint;

		DECLARE @TAB_CONFIRM_ROUTE   TABLE
		(
			TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
			[confirm_id]				[nvarchar](20) NOT NULL,
			route_id                    bigint
		)

		INSERT INTO @TAB_CONFIRM_ROUTE (confirm_id, route_id)
		SELECT confirm_id, route_id
		  FROM #tmp_SSP_ANL_SHIP_CONFIRM
		 WHERE CONFIRM_TYPE = 'N' 


		SELECT @V_INX			= 1
			  ,@V_MAX_NUM		= COUNT(*)
		  FROM @TAB_CONFIRM_ROUTE

		WHILE @V_INX <= @V_MAX_NUM
		BEGIN

			SELECT @lv_confirm_id		= confirm_id	
				  ,@lv_route_id			= route_id		
			  FROM @TAB_CONFIRM_ROUTE 
			 WHERE TID					= @V_INX

			EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_ROUTE] @lv_confirm_id, @lv_route_id;

			SET @V_INX = @V_INX + 1
		END
		------------------------------------------------------------------------------------------------------------- 

		 --240223 jilee 폴란드 WA 법인 변경건 전체 내역 송부
        IF (
		     SELECT SEGMENT1 --company id
		     FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) WHERE 1=1
			 AND L.LOOKUP_TYPE = 'SSP_PLN_FP_SHIP_TARGET_WA' 
			 AND L.VALID_YN = 'Y'
		   ) = @v_company_id		  
		   BEGIN
			 EXEC PR_SSP_PLN_FP_SHIP_TARGET_WA
		   END
    END
    END TRY
	
	BEGIN CATCH

		SET @r_error_msg =  CAST(ERROR_MESSAGE() AS NVARCHAR(1000));

		RETURN -1

	END CATCH;

   
    RETURN 1

END; 
