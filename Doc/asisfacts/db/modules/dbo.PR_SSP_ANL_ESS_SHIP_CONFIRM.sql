

/*
 * Program ID   : PR_SSP_ANL_ESS_SHIP_CONFIRM  
 * Description  :  
 * OutTable     : SSP_ANL_ESS_SHIP_CONFIRM
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.03.23   SSP Pjt.       Create.
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.08.01   SSP Pjt.       CONFIRM_ROUTE 적용
 * 2024.10.01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_ESS_SHIP_CONFIRM]
( 
      @p_division_id              NVARCHAR(10)
) 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  
    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_ESS_SHIP_CONFIRM';
    DECLARE @v_log_type					NVARCHAR(30);	-- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER			= 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_SHIP_CONFIRM'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= ''--'[00:00]';

	-- NERP 매핑코드
    DECLARE @v_KR012031				NVARCHAR(20);
	SET @v_KR012031 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_SHIP_CONFIRM'  ,'KR012031P' )


    DECLARE @v_plan_start_yyyymmdd      NVARCHAR(8)		= '';
	DECLARE @v_plan_type				NVARCHAR(8)		= 'SP';
	DECLARE @v_seq						INTEGER = 1;

	DECLARE @v_confirm_start_date		NVARCHAR(8);
	DECLARE @v_confirm_end_date		    NVARCHAR(8);
	DECLARE @v_division_id				NVARCHAR(30)	= '';


	DECLARE @v_infseqno					NVARCHAR(14);	
	DECLARE @v_timezone					NVARCHAR(10); 	
    DECLARE @v_daily_confirm_date		NVARCHAR(8);	
	DECLARE @v_time_for_system			DATETIME ;
	DECLARE @v_time_for_timezone		DATETIME ;
	DECLARE @v_sms_desc					NVARCHAR(4000);
    DECLARE @v_last_start_yyyymmdd      NVARCHAR(8)		= '';
	DECLARE @check_cnt					INTEGER			= 0;	

	DECLARE @TAB   TABLE
	(
	    TID						INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[DIVISION_ID]			[nvarchar](30) NOT NULL,
		[PROJECT_CODE]			[nvarchar](50) NOT NULL,
		[SCM_SITE_ID]			[nvarchar](30) NOT NULL,
		[ITEM_ID]				[nvarchar](50) NOT NULL,
		[DOM_EXP]				[nvarchar](3) NOT NULL,
		[FCST_TYPE]				[nvarchar](20) NOT NULL,
		[INCOTERMS]				[nvarchar](10) NOT NULL,
		[MEASURE]				[nvarchar](50) NOT NULL,
		[PLANT_SITE_ID]			[nvarchar](30) NOT NULL,
		[YYYYMMDD]				[nvarchar](8) NOT NULL,
		[PLAN_QTY]				[numeric](30, 10) NULL,
		[BOD_ID]                [nvarchar](30) ,
		[CREATED_BY]            [nvarchar](30) NOT NULL,
		[ORG_PLANT_SITE_ID]		[nvarchar](30) NOT NULL
	)

	IF @p_division_id IS NULL
		SET @v_division_id = '82';
    ELSE
   	    SET @v_division_id =  @p_division_id ; 




	 SELECT @v_plan_start_yyyymmdd	= X.ATTRIBUTE1
       FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS X WITH(NOLOCK)
      WHERE X.LOOKUP_TYPE	= 'SSP_ANL_ESS_PLAN'
	    AND X.SEGMENT1		= @v_division_id
		AND X.VALID_YN		= 'Y'

    -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY

        BEGIN TRAN TX_SH
		------------------------------------------------------------------------------------------------------------- 
		-- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
		------------------------------------------------------------------------------------------------------------- 
		IF OBJECT_ID('tempdb..#tmp_SSP_ANL_ESS_CONFIRM') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_ESS_CONFIRM

		CREATE TABLE #tmp_SSP_ANL_ESS_CONFIRM (
			   CONFIRM_ID                   NVARCHAR(020)                                   
			  ,SHIPMENT_STATUS              NVARCHAR(020)   
			  ,DIVISION_ID                  NVARCHAR(030)   
			  ,PLAN_START_YYYYMMDD          NVARCHAR(008)    
			  ,PLAN_TYPE                    NVARCHAR(050)   
			  ,SEQ                          INT         
			  ,ITEM_ID                      NVARCHAR(050)   
			  ,FROM_SITE                    NVARCHAR(030)   
			  ,TO_SITE                      NVARCHAR(030)   
			  ,YYYYMMDD                     NVARCHAR(008) 
			  ,PLANNED_QTY                  NUMERIC(20,10)   
			  ,QTY                          NUMERIC(20,10)
			  ,BOD_ID                       NVARCHAR(150)  
			  ,ROUTE_ID                     INT         
			  ,BIZ_TYPE                     NVARCHAR(030)   
			  ,PROJECT_CODE                 NVARCHAR(050)   
			  ,FCST_TYPE                    NVARCHAR(020)   
			  ,FCST_ETD_DATE                NVARCHAR(008)    
			  ,FCST_ETA_DATE                NVARCHAR(008)    
			  ,ETD_DATE                     NVARCHAR(008)    
			  ,ETA_DATE                     NVARCHAR(008)    
			  ,INCOTERMS                    NVARCHAR(010)   
			  ,TRANSPORT_MODE               NVARCHAR(050)   
			  ,D_COUNTRY                    NVARCHAR(003)    
			  ,D_PORT_CODE                  NVARCHAR(010)   
			  ,A_COUNTRY                    NVARCHAR(003)    
			  ,A_PORT_CODE                  NVARCHAR(010)   
			  ,CUSTOMER_LT                  INT            
			  ,TO_COUNTRY                   NVARCHAR(003)    
			  ,TO_CITY                      NVARCHAR(005)    
			  ,FROM_SITE_TYPE               NVARCHAR(001)    
			  ,FROM_SITE_PLANT_ID           NVARCHAR(030)   
			  ,FROM_SITE_VENDOR_ID          NVARCHAR(030)   
			  ,FROM_SITE_SOLDTO_CODE        NVARCHAR(010)   
			  ,FROM_SITE_SHIPTO_CODE        NVARCHAR(010)   
			  ,FROM_SITE_COMPANY_ID         NVARCHAR(030)   
			  ,TO_SITE_TYPE                 NVARCHAR(001)    
			  ,TO_SITE_PLANT_ID             NVARCHAR(030)   
			  ,TO_SITE_VENDOR_ID            NVARCHAR(030)   
			  ,TO_SITE_SOLDTO_CODE          NVARCHAR(010)   
			  ,TO_SITE_SHIPTO_CODE          NVARCHAR(010)   
			  ,TO_SITE_COMPANY_ID           NVARCHAR(030)   
			  ,CONFIRM_TYPE                 NVARCHAR(001)  -- 신규 확정:N (NEW) , 기확정 : O(OLD) 
			  ,COUNTRY                      NVARCHAR(002)     
			  ,COMPANY_ID                   NVARCHAR(030)
			  ,VMI_YN                       NVARCHAR(001)
			  ,ELECTRODE_YN                 NVARCHAR(001)
			  ,ELECTRODE_TYPE				NVARCHAR(030)  
			  ,ORIGIN_FROM_DIVISION_ID	    NVARCHAR(030)
			  ,ORIGIN_TO_DIVISION_ID		NVARCHAR(030)
			  ,BEFORE_QTY                   NUMERIC(20,10)
			  ,REMARKS3                     NVARCHAR(255) -- Customer Requirement
			  ,REQUESTOR					NVARCHAR(100)	
			  ,CHECK_NEED_YN                NVARCHAR(001)
			  ,ATTRIBUTE10                  NVARCHAR(020)	-- REQ_DET_ID
			  ,REQUEST_ID                   NVARCHAR(030)
			  ,[ORG_PLANT_SITE_ID]          NVARCHAR(030)
			  ,[DOM_EXP]                    nvarchar(030)
			  ,[DM_INCOTERMS]               NVARCHAR(050)
		);

		INSERT INTO @TAB (
			   [DIVISION_ID]	
			  ,[PROJECT_CODE]	
			  ,[SCM_SITE_ID]	
			  ,[ITEM_ID]		
			  ,[DOM_EXP]		
			  ,[FCST_TYPE]		
			  ,[INCOTERMS]		
			  ,[MEASURE]		
			  ,[PLANT_SITE_ID]	
			  ,[YYYYMMDD]		
			  ,[PLAN_QTY]
			  ,[BOD_ID]
			  ,[CREATED_BY]
			  ,[ORG_PLANT_SITE_ID]
			  )
		SELECT
			   [DIVISION_ID]	
			  ,[PROJECT_CODE]	
			  ,[SCM_SITE_ID]	
			  ,[ITEM_ID]		
			  ,[DOM_EXP]		
			  ,[FCST_TYPE]		
			  ,[INCOTERMS]		
			  ,[MEASURE]		
			  ,CASE WHEN R.[PLANT_SITE_ID] IS NULL OR R.[PLANT_SITE_ID] = '' THEN @v_KR012031--'KR012031-P' 
				    ELSE R.[PLANT_SITE_ID] 
			   END AS [PLANT_SITE_ID]
			  ,[YYYYMMDD]		
			  ,[QTY] AS PLAN_QTY
			  ,(SELECT TOP 1 BOD_ID 
				  FROM SCP_MST_BOD_V WITH(NOLOCK)
				 WHERE DIVISION_ID	= R.DIVISION_ID  
				   AND FROM_SITE	= CASE WHEN R.PLANT_SITE_ID IS NULL OR R.PLANT_SITE_ID = '' THEN @v_KR012031--'KR012031-P' 
										   ELSE R.PLANT_SITE_ID 
									  END
				   AND TO_SITE		= R.SCM_SITE_ID 
				   AND INCOTERMS    = R.INCOTERMS
				   AND BOD_VALID_YN = 'Y'
				 ORDER BY 
					   PRIORITY ASC
			  )  AS BOD_ID  
			  ,[CREATED_BY]
			  ,[PLANT_SITE_ID] AS ORG_PLANT_SITE_ID
		  FROM [dbo].DM_PLN_MKT_FCST R WITH(NOLOCK)
		 WHERE R.DIVISION_ID		= @v_division_id 
		   AND R.QTY				>= 1
		   AND R.ATTRIBUTE9	IS NULL 
		   AND R.YYYYMMDD			>= CONVERT(VARCHAR, getdate(), 112)
		   AND R.MEASURE			= 'BNPIn'


		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm  START (44)
		-----------------------------------------------------------
		-- 수행시간이 짧아 시작 문자는 제외 
		--SET @v_sms_desc = @p_division_id + '::SSP';
		--EXEC SCM_ADM_SMS_SEND_BATCH 44, @v_sms_desc;

 		------------------------------------------------------------------------------------------------------------- 
		-- 0-1. Time zone  , 해당 timezone에 해당하는 현재 시간 
		-------------------------------------------------------------------------------------------------------------
		SELECT @v_timezone =  C.SEGMENT1
		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
		 WHERE 1 = 1
		   AND C.LOOKUP_TYPE = 'TIME_ZONE'
		   AND C.SEGMENT3    = 'KR' --@p_country       
		; 

		SET    @v_time_for_timezone = DBO.FN_MULTY_TIME(@v_timezone) ;
		SET    @v_time_for_system   = GETDATE() ;

		------------------------------------------------------------------------------------------------------------- 
		-- 1. SHIP_CONFIRM 입력 : 출하확정(신규) #tmp_SSP_ANL_ESS_CONFIRM  
		--    신규확정일 경우 CONFIRM_ID 채번
		------------------------------------------------------------------------------------------------------------- 
		INSERT INTO #tmp_SSP_ANL_ESS_CONFIRM (
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
			  ,REMARKS3  
			  ,REQUESTOR                    
			  ,CHECK_NEED_YN    
			  ,ATTRIBUTE10  						
			  ,REQUEST_ID
			  ,[ORG_PLANT_SITE_ID]
			  ,[DOM_EXP]
			  ,[DM_INCOTERMS]
			  )
	    SELECT 'C'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6) AS CONFIRM_ID
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
			  ,REMARKS3  
			  ,REQUESTOR                    
			  ,CHECK_NEED_YN    
			  ,ATTRIBUTE10  						
			  ,REQUEST_ID
			  ,[ORG_PLANT_SITE_ID]
			  ,[DOM_EXP]
			  ,[DM_INCOTERMS]
		  FROM (
			   SELECT 'C'								AS SHIPMENT_STATUS
					 ,R.DIVISION_ID						AS DIVISION_ID
					 ,@v_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
					 ,@v_plan_type						AS PLAN_TYPE
					 ,@v_seq							AS SEQ
					 ,R.ITEM_ID							AS ITEM_ID
					 ,R.PLANT_SITE_ID					AS FROM_SITE
					 ,R.SCM_SITE_ID						AS TO_SITE
					 ,R.YYYYMMDD						AS YYYYMMDD
					 -- LOT SIZE별로 분할 생성 
					 ,CASE WHEN R.PLAN_QTY <= ISNULL(L.LOT_SIZE ,R.PLAN_QTY) THEN  R.PLAN_QTY 
					       ELSE  
							   CASE WHEN R.PLAN_QTY / (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.PLAN_QTY)  
								    ELSE R.PLAN_QTY % (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*(C.SEQ-1))
								    END 
						   END							AS PLANNED_QTY
					 ,CASE WHEN R.PLAN_QTY <= ISNULL(L.LOT_SIZE ,R.PLAN_QTY) THEN  R.PLAN_QTY 
					       ELSE  
					  		   CASE WHEN R.PLAN_QTY / (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.PLAN_QTY)  
					  		        ELSE R.PLAN_QTY % (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*(C.SEQ-1))
					  			    END 
					  	   END							AS QTY
					 ,R.BOD_ID							AS BOD_ID
					 ,B.ROUTE_ID						AS ROUTE_ID
					 ,SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID) +1, 1)				AS BIZ_TYPE
					 ,R.PROJECT_CODE					AS PROJECT_CODE
					 ,R.FCST_TYPE						AS FCST_TYPE
					 ,R.YYYYMMDD						AS FCST_ETD_DATE
					 ,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD)				AS FCST_ETA_DATE
					 ,R.YYYYMMDD						AS ETD_DATE
					 ,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD)				AS ETA_DATE
					 ,ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)											AS INCOTERMS
					 ,B.TRANSPORT_MODE					AS TRANSPORT_MODE
					 ,B.D_COUNTRY						AS D_COUNTRY
					 ,B.D_PORT_CODE						AS D_PORT_CODE
					 ,B.A_COUNTRY						AS A_COUNTRY
					 ,B.A_PORT_CODE						AS A_PORT_CODE
					 ,B.LT_TOTAL						AS CUSTOMER_LT
					 ,B.TO_COUNTRY						AS TO_COUNTRY
					 ,B.TO_CITY							AS TO_CITY
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SITE_TYPE')		AS FROM_SITE_TYPE  
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'PLANT_ID')		AS FROM_SITE_PLANT_ID 
					 ,CASE WHEN ISNULL(FS.HQ_VENDOR_CODE, '') <> '' THEN FS.HQ_VENDOR_CODE
					       ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'VENDOR_ID') 
					 	    END							AS FROM_SITE_VENDOR_ID  
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SOLDTO_CODE')	AS FROM_SITE_SOLDTO_CODE
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SHIPTO_CODE')	AS FROM_SITE_SHIPTO_CODE
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'COMPANY_ID')		AS FROM_SITE_COMPANY_ID 
					 ,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.DIVISION_ID,FS.SCM_SITE_ID, TS.SCM_SITE_ID, 'SITE_TYPE')		AS TO_SITE_TYPE  
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'PLANT_ID')		AS TO_SITE_PLANT_ID   
					 ,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
					       ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'VENDOR_ID') 
					 	    END							AS TO_SITE_VENDOR_ID  
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SOLDTO_CODE')	AS TO_SITE_SOLDTO_CODE
					 ,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SHIPTO_CODE')	AS TO_SITE_SHIPTO_CODE
					 ,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.DIVISION_ID,FS.SCM_SITE_ID, TS.SCM_SITE_ID, 'COMPANY_ID')		AS TO_SITE_COMPANY_ID 
					 ,'N'                                                                           AS CONFIRM_TYPE  -- 신규확정
					 ,FS.COUNTRY                                                                    AS COUNTRY  --FROM SITE의 COUNTRY
					 ,FS.COMPANY_ID                                                                 AS COMPANY_ID
					 ,TS.VMI_YN                                                                     AS VMI_YN 
					 ,'N'                                                                           AS ELECTRODE_YN            
					 ,''																            AS ELECTRODE_TYPE				   
					 ,R.DIVISION_ID														            AS ORIGIN_FROM_DIVISION_ID	
					 ,R.DIVISION_ID														            AS ORIGIN_TO_DIVISION_ID
					 ,CASE WHEN  R.PLAN_QTY <= ISNULL(L.LOT_SIZE ,R.PLAN_QTY) THEN  R.PLAN_QTY 
					 	    ELSE  
					 		    CASE WHEN R.PLAN_QTY / (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.PLAN_QTY)  
					 			     ELSE R.PLAN_QTY % (ISNULL(L.LOT_SIZE ,R.PLAN_QTY)*(C.SEQ-1))
					 			END 
					 	    END							AS BEFORE_QTY
					 ,NULL                                                                          AS REMARKS3  
					 ,R.CREATED_BY																	AS REQUESTOR                                        
					 ,'N'                                                                           AS CHECK_NEED_YN  
					 ,'-'                                                                           AS ATTRIBUTE10
					 ,'-'                                                                           AS REQUEST_ID
					 ,R.[ORG_PLANT_SITE_ID]
					 ,R.[DOM_EXP]
					 ,R.INCOTERMS																	AS DM_INCOTERMS
				 FROM @TAB AS R        
				      JOIN SCP_MST_BOD_N_V   B WITH(NOLOCK) 
				   ON B.DIVISION_ID		= R.DIVISION_ID 
				  AND B.BOD_ID			= R.BOD_ID 
					  JOIN SCM_MST_SITE FS  WITH(NOLOCK)
			   	   ON FS.DIVISION_ID	= R.DIVISION_ID 
			      AND FS.SCM_SITE_ID	= R.PLANT_SITE_ID 
			      AND FS.VALID_YN		= 'Y' 
					  LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
				   ON TS.DIVISION_ID	= R.DIVISION_ID 
				  AND TS.SCM_SITE_ID	= R.SCM_SITE_ID 
				  AND TS.VALID_YN		= 'Y' 
				      LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
				   ON L.DIVISION_ID    = R.DIVISION_ID 
				  AND L.FROM_SITE      = R.PLANT_SITE_ID
				  AND L.TO_SITE        = R.SCM_SITE_ID
				  AND L.ITEM_ID        = R.ITEM_ID   
				  AND L.TRANSPORT_MODE = B.TRANSPORT_MODE
				  AND L.VALID_YN       = 'Y'
				  AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
				      JOIN SSP_MST_PARTIAL_SEQ C WITH(NOLOCK) -- LOT SIZE별 행 생성을 위한 기초테이블 
				   ON C.SEQ <= CEILING(R.PLAN_QTY/ISNULL(L.LOT_SIZE ,R.PLAN_QTY))
				WHERE 1=1 
				  AND R.DIVISION_ID		= @v_division_id 
				  AND R.PLAN_QTY        >= 1
				  AND [dbo].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID) > 0
				  AND R.YYYYMMDD		>= CONVERT(VARCHAR, getdate(), 112)
				  AND R.YYYYMMDD		< CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID) , getdate()) ,112) 
				  AND R.BOD_ID IS NOT NULL						
				) A
		  WHERE 1 = 1
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
			  ,REMARKS3   -- Customer Requirement 
			  ,CHECK_NEED_YN
			  ,REQUESTOR               
			  ,ATTRIBUTE9  -- CONFIRM_TYPE (N : CELL, Z : PACK)
			  ,ATTRIBUTE10 -- REQ_DET_ID 
			  )
		SELECT CONFIRM_ID
			  ,'C' -- 확정:C , 계획 : P   -- CHANGE_TYPE  
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
			  ,NULL -- CHANGE_REQ_NO
			  ,NULL -- ERP_SO_NO
			  ,NULL -- ERP_SO_ITEM_NO
			  ,NULL -- ERP_DO_NO
			  ,NULL -- ERP_STATUS
			  ,@v_batch_user    -- CREATED_BY    
			  ,@v_time_for_system  -- CREATION_DATE   
			  ,@v_batch_user    -- LAST_UPDATED_BY
			  ,@v_time_for_system  -- LAST_UPDATE_DATE
			  ,ELECTRODE_YN            
			  ,ELECTRODE_TYPE				   
			  ,ORIGIN_FROM_DIVISION_ID	
			  ,ORIGIN_TO_DIVISION_ID	
			  ,BEFORE_QTY             
			  ,REMARKS3 -- Customer Requirement
			  ,CHECK_NEED_YN
			  ,REQUESTOR  
			  ,CONFIRM_TYPE  -- ATTRIBUTE9
			  ,ATTRIBUTE10   -- REQ_DET_ID 
		  FROM #tmp_SSP_ANL_ESS_CONFIRM A WITH (NOLOCK)
		 WHERE 1 = 1
		   AND DIVISION_ID		= @v_division_id
		   AND CONFIRM_TYPE		= 'N'
		   AND BIZ_TYPE			<> 'E'
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
			  ,REMARKS3   -- Customer Requirement
			  ,REQUESTOR 
			  ,CHECK_NEED_YN 
			  ,ATTRIBUTE9  -- CONFIRM_TYPE (N : CELL, Z : PACK)
			  ,ATTRIBUTE10 -- REQ_DET_ID 
		      )
		SELECT NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_CONFIRM_H  -- HISTORY_SEQ
		      ,CONFIRM_ID
			  ,'C'                 -- CHANGE_TYPE     
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
			  ,ELECTRODE_YN            
			  ,ELECTRODE_TYPE				   
			  ,ORIGIN_FROM_DIVISION_ID	
			  ,ORIGIN_TO_DIVISION_ID
			  ,BEFORE_QTY             
			  ,REMARKS3 
			  ,REQUESTOR  
			  ,CHECK_NEED_YN  
			  ,CONFIRM_TYPE   -- ATTRIBUTE9
			  ,ATTRIBUTE10    -- REQ_DET_ID 					
		  FROM #tmp_SSP_ANL_ESS_CONFIRM WITH (NOLOCK)
		 WHERE 1 = 1
		   AND DIVISION_ID	= @v_division_id
		   AND CONFIRM_TYPE = 'N'
		   AND BIZ_TYPE		<> 'E'
		   ;

		------------------------------------------------------------------------------------------------------------- 
		-- 5. ERP 전송을 위한 I/F 데이터 생성 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN -- SHIPMENT_STATUS : A: 확정
		-- 신규 건만 전송
		-- I/F는 법인별로 처리 분리하여 처리 
		------------------------------------------------------------------------------------------------------------- 

		--CURSOR 선언 
		DECLARE @company_id				VARCHAR(30)
	    DECLARE @yyyymmdd				VARCHAR(8)

		DECLARE CUR_ERP_S CURSOR FOR  
		 SELECT C.COMPANY_ID
			   ,MAX(C.YYYYMMDD)		AS YYYYMMDD 
		   FROM #tmp_SSP_ANL_ESS_CONFIRM C WITH(NOLOCK) 
		  WHERE 1 = 1 
		    AND C.CONFIRM_TYPE		= 'N'  -- 신규건만 전송 
		  GROUP BY 
			    C.COMPANY_ID
		  ;

		OPEN CUR_ERP_S; 

		FETCH NEXT FROM CUR_ERP_S INTO @company_id, @yyyymmdd

		WHILE(@@FETCH_STATUS = 0) 
		BEGIN 

			-- IFSEQNO 생성
			--SELECT @v_infseqno	= CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
			--  FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
			-- WHERE IFSEQNO		LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

			 SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

			INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN (
				   IFSEQNO
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
				  ,ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
				  
				  )
			SELECT 
				 @v_infseqno					AS  IFSEQNO -- IFSEQNO
				,A.CONFIRM_ID
				,'A'		-- I_PLGB  A: 확정  
				,@yyyymmdd					AS LAST_CONFIRM_DATE -- I_DATE  확정구간 마지막 일자 
				,'B'		-- VERSION_TYPE  -- B:NEW/A:OLD 
				,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID
				,A.DIVISION_ID
				,A.ITEM_ID
				,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
				,ISNULL(X3.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
				,A.YYYYMMDD
				,A.QTY
				,A.BOD_ID
				,A.ROUTE_ID
				,A.BIZ_TYPE	-- OPERATION_GROUP
				,A.BIZ_TYPE
				,A.PROJECT_CODE
				,A.FCST_TYPE
				,A.FCST_ETD_DATE
				,A.FCST_ETA_DATE
				,A.ETD_DATE
				,A.ETA_DATE
				,A.INCOTERMS  
				,NULL			AS INCOTERMS2
				,A.TRANSPORT_MODE
				,A.D_COUNTRY
				,A.D_PORT_CODE
				,A.A_COUNTRY
				,A.A_PORT_CODE
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
				,NULL			--BUILDING
				,NULL			--REMARK
				,A.CUSTOMER_REQ	--CUSTOMER_REQ
				,NULL			--CHANGE_CODE
				,NULL			--CHANGE_CODE_NAME
				,A.REQUESTOR
				,'N'          -- TRANSFER_FLAG
				,@v_time_for_system  -- TRANSFER_DATE
				,@v_batch_user       -- CREATED_BY
				,@v_time_for_system  -- CREATION_DATE
				,@v_batch_user       -- LAST_UPDATED_BY
				,@v_time_for_system  -- LAST_UPDATE_DATE
				,NULL			-- ATTRIBUTE1
				,NULL			-- ATTRIBUTE2
				,NULL			-- ATTRIBUTE3
				,NULL			-- ATTRIBUTE4
				,NULL			-- ATTRIBUTE5
				,NULL			-- ATTRIBUTE6
				,NULL			-- ATTRIBUTE7
				,NULL			-- ATTRIBUTE8
				,NULL			-- ATTRIBUTE9
				,A.ELECTRODE_YN -- ATTRIBUTE10
				,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
			FROM 
			(
				SELECT 
					   A.CONFIRM_ID
					  ,CASE WHEN B.ATTRIBUTE2 IS NULL OR B.ATTRIBUTE2 = '' THEN NULL 
				    		ELSE B.ATTRIBUTE2 
				  			END						AS SALES_COMPANY_ID
					  ,CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID 
				  			ELSE A.DIVISION_ID 
				  			END						AS DIVISION_ID
					  ,A.ITEM_ID
					  ,A.FROM_SITE
					  ,A.TO_SITE
					  ,A.YYYYMMDD
					  ,A.QTY
					  ,A.BOD_ID
					  ,A.ROUTE_ID
					  --,A.BIZ_TYPE	-- OPERATION_GROUP
					  ,A.BIZ_TYPE
					  ,CASE WHEN A.PROJECT_CODE IS NULL OR A.PROJECT_CODE ='' OR A.PROJECT_CODE ='-' THEN 'TBD' 
							ELSE A.PROJECT_CODE 
							END						AS PROJECT_CODE
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
					  ,A.REMARKS3	AS CUSTOMER_REQ
					  ,A.REQUESTOR
					  ,A.ELECTRODE_YN -- ATTRIBUTE10
				  FROM #tmp_SSP_ANL_ESS_CONFIRM  A WITH(NOLOCK)
					   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
					ON B.LOOKUP_TYPE	= 'CELL_SHIP_FROM_TO' 
				   AND B.VALID_YN		= 'Y'
				   AND B.SEGMENT1		= A.FROM_SITE_COMPANY_ID 
				   AND B.SEGMENT3		= A.FROM_SITE
				   AND B.SEGMENT4		= A.TO_SITE_COMPANY_ID 
				   AND B.SEGMENT5		= A.TO_SITE 
				 WHERE 1 = 1 
				   AND A.DIVISION_ID	= @v_division_id
				   AND CONFIRM_TYPE		= 'N' -- 신규 확정건인 경우
				   AND A.BIZ_TYPE		<> 'E'
				   AND A.COMPANY_ID     =  @company_id
				   AND A.QTY			>= 1  -- 0은IF 제외  
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

			FETCH NEXT FROM CUR_ERP_S INTO @company_id, @yyyymmdd ; 
		END

		CLOSE CUR_ERP_S; 
		DEALLOCATE CUR_ERP_S;
			 
		UPDATE R
		   SET R.ATTRIBUTE9			= C.CONFIRM_ID 
		  FROM [dbo].DM_PLN_MKT_FCST R WITH(NOLOCK) 
			   JOIN #tmp_SSP_ANL_ESS_CONFIRM C WITH(NOLOCK) 
		    ON R.[DIVISION_ID]	    = C.[DIVISION_ID]	
		   AND R.[PROJECT_CODE]		= C.[PROJECT_CODE]	
		   AND R.[SCM_SITE_ID]		= C.[TO_SITE]	
		   AND R.[ITEM_ID]			= C.[ITEM_ID]		
		   AND R.[DOM_EXP]			= C.[DOM_EXP]		
		   AND R.[FCST_TYPE]		= C.[FCST_TYPE]	
		   AND R.[INCOTERMS]		= C.[DM_INCOTERMS]	
		   AND R.[MEASURE]			= 'BNPIn'		
		   AND R.[PLANT_SITE_ID]	= C.[ORG_PLANT_SITE_ID]
		   AND R.[YYYYMMDD]			= C.[YYYYMMDD]		

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
		  FROM #tmp_SSP_ANL_ESS_CONFIRM A WITH (NOLOCK)
		 WHERE 1 = 1
		   AND DIVISION_ID		= @v_division_id
		   AND CONFIRM_TYPE		= 'N'
		   AND BIZ_TYPE			<> 'E'
				;

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


        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRAN TX_SH;

			-------------------------------------------------------------
			---- SMS 전송 : Daily Confirm END (46)
			-------------------------------------------------------------
			--SET @v_sms_desc = @v_division_id + ':Merchandise:SSP';
			--EXEC SCM_ADM_SMS_SEND_BATCH 46, @v_sms_desc;

        END;  
		
		-------------------------------------------------------------
		---- 메일 전송 : Daily Confirm END (46)
		-------------------------------------------------------------
		SELECT @check_cnt = COUNT(*)
		  FROM @TAB
		 WHERE BOD_ID IS NULL
		 ;
		IF @check_cnt > 0 AND (CONVERT(CHAR(2),GETDATE(),108) = '09')
		BEGIN
			EXEC [dbo].[PR_SSP_MAIL_SEND_BOD_REGISTRATION] 75
		END

        -- TXN LOG
        SET @v_log_type		= N'TXN';    -- ▶ 로그타입
        SET @n_log_count	= @@ROWCOUNT;
        SET @v_log_message	= N'INSERT INTO '+@v_table_id;
        SET @v_description	= N'Process Complete...division_id:'+@v_division_id + '-' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date	= SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END TRY

    BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
			ROLLBACK TRAN TX_SH
		    
			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_ERP_S')
			BEGIN
			    CLOSE CUR_ERP_S ;
			    DEALLOCATE CUR_ERP_S ;
			END
        END;
      
		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name +'- division_id :'+ @v_division_id+'-' + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;
		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm ERROR (45)
		-----------------------------------------------------------
		SET @v_sms_desc = @v_division_id + ':Merchandise:SSP';
		EXEC SCM_ADM_SMS_SEND_BATCH 45, @v_sms_desc;
		-----------------------------------------------------------

      return -1

    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'['++'][division_id :' + @v_division_id + '][' + @v_exec_time + ']'   ; 
    SET @d_event_date	= SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
   
    return 1  

END; 
