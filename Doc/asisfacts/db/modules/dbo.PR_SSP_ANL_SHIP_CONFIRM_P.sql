
/*
 * Program ID   : PR_SSP_ANL_SHIP_CONFIRM_P  
 * Description  :  
 * OutTable     : SSP_ANL_ESS_SHIP_CONFIRM
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.10.01   SSP Pjt.       Create.
 * 2023.04.11   jilee          프로젝트 Name명 추가 전송
 * 2024.10.01   KHJ            NERP_SSP
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_P]
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  
    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_SHIP_CONFIRM_P';
    DECLARE @v_log_type					NVARCHAR(30);	-- START/END/ERROR/...
    DECLARE @n_log_count				INTEGER			= 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_SHIP_CONFIRM'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= ''--'[00:00]';


    DECLARE @v_plan_start_yyyymmdd      NVARCHAR(8)		= '';
	DECLARE @v_plan_type				NVARCHAR(8)		= 'SP';
	DECLARE @v_seq						INTEGER = 1;

	DECLARE @v_confirm_start_date		NVARCHAR(8);
	DECLARE @v_confirm_end_date		    NVARCHAR(8);
	DECLARE @v_division_id				NVARCHAR(30);


	DECLARE @v_infseqno					NVARCHAR(14);	
	DECLARE @v_timezone					NVARCHAR(10); 	
    DECLARE @v_daily_confirm_date		NVARCHAR(8);	
	DECLARE @v_time_for_system			DATETIME ;
	DECLARE @v_time_for_timezone		DATETIME ;
	DECLARE @v_sms_desc					NVARCHAR(4000);
    DECLARE @v_last_start_yyyymmdd      NVARCHAR(8)		= '';
	DECLARE @check_cnt					INTEGER			= 0;	

	SET @v_plan_start_yyyymmdd	= CONVERT(char(8), getdate(), 112)
	SET @v_division_id			= '40'


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
		IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_CONFIRM') IS NOT NULL
			DROP TABLE #tmp_SSP_ANL_SHIP_CONFIRM

		CREATE TABLE #tmp_SSP_ANL_SHIP_CONFIRM (
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
			  ,INCOTERMS                    NVARCHAR(010)   --SSP_INCOTERMS
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
		);

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
		-- 1. #tmp_SSP_ANL_SHIP_CONFIRM  
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
			  ,REMARKS3  
			  ,REQUESTOR                    
			  ,CHECK_NEED_YN  
			  )
	    SELECT REQUEST_ID AS CONFIRM_ID
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
			  ,PLANNED_QTY
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
		  FROM (
			   SELECT R.REQUEST_ID                      AS REQUEST_ID
			         ,'C'								AS SHIPMENT_STATUS
					 ,R.DIVISION_ID						AS DIVISION_ID
					 ,@v_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
					 ,@v_plan_type						AS PLAN_TYPE
					 ,@v_seq							AS SEQ
					 ,R.ITEM_ID						    AS ITEM_ID
					 ,B.FROM_SITE						AS FROM_SITE
					 ,B.TO_SITE							AS TO_SITE
					 ,R.YYYYMMDD						AS YYYYMMDD
					 ,R.QTY								AS PLANNED_QTY
					 ,R.BOD_ID							AS BOD_ID
					 ,B.ROUTE_ID						AS ROUTE_ID
					 ,FS.OPERATION_GROUP                AS BIZ_TYPE
					 ,R.PROJECT_CODE					AS PROJECT_CODE
					 ,R.FCST_TYPE						AS FCST_TYPE
					 ,R.YYYYMMDD						AS FCST_ETD_DATE
					 ,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD)				AS FCST_ETA_DATE
					 ,R.YYYYMMDD						AS ETD_DATE
					 ,[dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD)				AS ETA_DATE
					 ,ISNULL(B.SSP_INCOTERMS, B.INCOTERMS)											AS INCOTERMS
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
					 --,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SOLDTO_CODE')	AS TO_SITE_SOLDTO_CODE
					 ,(SELECT TOP 1 SOLDTO_CODE
						 FROM SCM_MST_SITE_CUSTOMER WITH(NOLOCK)
						WHERE DIVISION_ID = R.DIVISION_ID
						  AND SCM_SITE_ID = B.TO_SITE
						  AND SHIPTO_CODE = R.SHIPTO_CODE
						ORDER BY VALID_YN DESC, REP_YN DESC)										AS TO_SITE_SOLDTO_CODE
					 --,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SHIPTO_CODE')	AS TO_SITE_SHIPTO_CODE
					 ,R.SHIPTO_CODE																	AS TO_SITE_SHIPTO_CODE
					 ,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.DIVISION_ID,FS.SCM_SITE_ID, TS.SCM_SITE_ID, 'COMPANY_ID')		AS TO_SITE_COMPANY_ID 
					 ,'N'                                                                           AS CONFIRM_TYPE  -- 신규확정
					 ,FS.COUNTRY                                                                    AS COUNTRY  --FROM SITE의 COUNTRY
					 ,FS.COMPANY_ID                                                                 AS COMPANY_ID
					 ,TS.VMI_YN                                                                     AS VMI_YN 
					 ,'N'                                                                           AS ELECTRODE_YN            
					 ,''																            AS ELECTRODE_TYPE				   
					 ,R.DIVISION_ID														            AS ORIGIN_FROM_DIVISION_ID	
					 ,R.DIVISION_ID														            AS ORIGIN_TO_DIVISION_ID
					 ,R.QTY                                                                         AS BEFORE_QTY
					 ,NULL                                                                          AS REMARKS3  
					 ,R.CREATED_BY																	AS REQUESTOR                                        
					 ,'N'                                                                           AS CHECK_NEED_YN 
				 FROM dbo.SSP_ANL_SHIP_REQ_P AS R  WITH(NOLOCK)     
				      INNER JOIN SCP_MST_BOD_N_V   B WITH(NOLOCK) 
                   ON B.DIVISION_ID         = R.DIVISION_ID
				  AND B.BOD_ID				= R.BOD_ID 
					  INNER JOIN SCM_MST_SITE AS FS  WITH(NOLOCK)
			   	   ON FS.DIVISION_ID		= R.DIVISION_ID 
			      AND FS.SCM_SITE_ID		= B.FROM_SITE 
				  AND FS.SITE_TYPE			= 'PLANT'
			      AND FS.VALID_YN			= 'Y' 
				  AND FS.OSP_YN				= 'Y'
				  AND FS.OPERATION_GROUP	= 'P'
					  INNER JOIN SCM_MST_SITE AS TS  WITH(NOLOCK)
				   ON TS.DIVISION_ID		= R.DIVISION_ID 
				  AND TS.SCM_SITE_ID		= B.TO_SITE 
				  AND TS.SITE_TYPE			= 'SALES'
				  AND TS.VALID_YN			= 'Y' 
				WHERE 1=1 
				  AND R.DIVISION_ID			= @v_division_id 
				  AND R.QTY					> 0
  				  AND R.YYYYMMDD			= (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, B.FROM_SITE), 0) = 0 THEN @v_plan_start_yyyymmdd
						                            ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, B.FROM_SITE)-1, @v_plan_start_yyyymmdd) ,112) 
													END)
				  AND R.CONFIRM_ID			IS NULL
				  AND R.REQUEST_ID          LIKE 'R%'
				) A
		  WHERE 1 = 1
			;

		------------------------------------------------------------------------------------------------------------- 
		-- 2. SSP_ANL_SHIP_CONFIRM
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
		  FROM #tmp_SSP_ANL_SHIP_CONFIRM A WITH (NOLOCK)
		 WHERE 1 = 1
		   ;

		------------------------------------------------------------------------------------------------------------- 
		-- 4. SSP_ANL_SHIP_CONFIRM_H
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
		  FROM #tmp_SSP_ANL_SHIP_CONFIRM WITH (NOLOCK)
		 WHERE 1 = 1
		   ;

		------------------------------------------------------------------------------------------------------------- 
		-- 5. ERP 전송
		------------------------------------------------------------------------------------------------------------- 

		DECLARE @ifseqno nvarchar(20)
		--SET @ifseqno = CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)
		SET @ifseqno = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss')

		INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN (
			   IF_SEQ
			  ,IF_TYPE
			  ,IF_ID
			  ,IF_INS_DATE
			  ,IF_FLAG
			  ,IF_SND_DATE
			  ,IFSEQNO
			  ,SSP_CNFM
			  ,PACKER_CODE
			  ,DIVISION_ID
			  ,PACK_MODEL_CODE
			  ,NICK_NAME
			  ,SALES_SITE
			  ,SOLD_TO
			  ,SHIP_TO
			  ,TRANSPORT_MODE
			  ,INCOTERMS
			  ,SHIP_PLAN_DATE
			  ,SHIP_PLAN_QTY
			  ,COMMENT
			  ,ORDER_TYPE_DETAIL
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
              )
		SELECT
			 'OERP' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
			,'I'
			,'OSCM_OERP_PACK_SHIP_PLAN'
			,getdate()
			,'N'
			,NULL
			,@ifseqno
			,A.CONFIRM_ID
			,ISNULL(X1.NEW_VALUE1, A.FROM_SITE)				AS PACKER_CODE
			,A.DIVISION_ID
			,A.ITEM_ID
			,A.NICK_NAME
			,ISNULL(X2.NEW_VALUE1, A.TO_SITE)					AS TO_SITE
			,ISNULL(X3.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
			,ISNULL(X4.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
			,A.TRANSPORT_MODE
			,A.INCOTERMS
			,A.YYYYMMDD
			,A.QTY
			,NULL
			,A.ORDER_TYPE_DETAIL
			,NULL   --ATTRIBUTE1
			,NULL	  --ATTRIBUTE2
			, A.ATTR_03    --Model PIC   
			, A.ATTR_04    --MTK_OWNER       
			,NULL	  --ATTRIBUTE5
			,NULL	  --ATTRIBUTE6
			,NULL	  --ATTRIBUTE7
			,NULL	  --ATTRIBUTE8
			,NULL	  --ATTRIBUTE9
			,NULL	  --ATTRIBUTE10
		FROM
		(
			SELECT 
				   P.CONFIRM_ID
				  ,P.FROM_SITE
				  ,P.DIVISION_ID
				  ,P.ITEM_ID
				  ,[dbo].[FN_GET_ITEM_NICKNAME]( P.DIVISION_ID, P.ITEM_ID)  AS NICK_NAME
				  ,P.TO_SITE
				  ,P.TO_SITE_SOLDTO_CODE
				  ,P.TO_SITE_SHIPTO_CODE
				  ,P.TRANSPORT_MODE
				  ,P.INCOTERMS
				  ,P.YYYYMMDD
				  ,P.QTY
				  ,ISNULL(LK.SEGMENT2, P.FCST_TYPE) AS ORDER_TYPE_DETAIL
				 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03    --Model PIC   
				 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04    --MTK_OWNER       
			  FROM #tmp_SSP_ANL_SHIP_CONFIRM AS P 
				   LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
				ON P.DIVISION_ID					= SI.DIVISION_ID
			   AND P.TO_SITE						= SI.SCM_SITE_ID
			   AND P.ITEM_ID						= SI.ITEM_ID
			   AND P.PROJECT_CODE					= SI.PROJECT_CODE
				   LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
				ON P.DIVISION_ID = MU.DIVISION_ID
			   AND P.FROM_SITE = MU.FROM_SITE
			   AND P.ITEM_ID = MU.ITEM_ID
			   AND MU.VALID_YN = 'Y'
				   LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
				ON mu.user_id = u2.UserID 
			   AND U2.UseYN = 'Y'
				   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
				ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
			   AND LK.VALID_YN	= 'Y'
			   AND P.FCST_TYPE	= LK.SEGMENT1
			 WHERE 1 = 1 
		) A
		LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.FROM_SITE = X1.OLD_VALUE1
		LEFT OUTER JOIN NERP_CONV_MASTER X2 WITH(NOLOCK) ON X2.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE = X2.OLD_VALUE1
		LEFT OUTER JOIN NERP_CONV_MASTER X3 WITH(NOLOCK) ON X3.CODETYPE = 'END_CUSTOMER_ID' AND A.TO_SITE_SOLDTO_CODE = X3.OLD_VALUE1
		LEFT OUTER JOIN NERP_CONV_MASTER X4 WITH(NOLOCK) ON X4.CODETYPE = 'END_CUSTOMER_ID'	AND A.TO_SITE_SHIPTO_CODE = X4.OLD_VALUE1

			;

		INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
		       IF_SEQ           
			 , IF_TYPE          
			 , IF_ID            
			 , IF_INS_DATE      
			 , IF_FLAG          
			 , PACKER_CODE      
			 , DIVISION_ID      
			 , PLAN_VERSION   
			 , PACK_MODEL_CODE  
			 , NICK_NAME 
			 , TARGET_ORDER
			 , SSP_CNFM
			 , SALES_SITE
			 , SHIP_TO
			 , SHIP_TO_NAME
			 , TRANSPORT_MODE
			 , INCOTERMS
			 , SHIP_PLAN_DATE 
			 , SHIP_PLAN_QTY 
			 , COMMENT
			 , ATTR_01           
			 , ATTR_02           
			 , ATTR_03           
			 , ATTR_04           
			 , ATTR_05           
			 , ATTR_06           
			 , ATTR_07           
			 , ATTR_08           
			 , ATTR_09           
			 , ATTR_10   
			 , ORDER_TYPE_DETAIL
             )
		SELECT 
			 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
			,'I'
			,'OSCM_OSCS_SCS_PACK_SHIP_PLAN'
			,getdate()
			,'N'
			, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE) AS PACKER_CODE
			, A.DIVISION_ID     -- DIVISION 
			, A.PLAN_VERSION    -- 원본테이블의  PLAN_START_YYYYMMDD날자를 VERSION(기준일)으로 갖고간다  
			, A.PACK_MODEL_CODE -- PACK ID 
			, A.NICK_NAME
			, 'O'
			, A.SSP_CNFM
			, A.SALES_SITE
			, A.SHIP_TO_CODE                                 
			, A.SHIP_TO_NAME
			, A.TRANSPORT_MODE  -- 운송수단
			, A.INCOTERMS       -- 거래조건
			, A.SHIP_PLAN_DATE  -- 출하계획일 
			, A.SHIP_PLAN_QTY   -- 출하계획수량
			, NULL								AS REMARKS         -- Comment
			, A.ATTR_01      
			, A.ATTR_02           
			, A.ATTR_03      --Model PIC   
			, A.ATTR_04		--MTK_OWNER       
			-- 230411 jilee 프로젝트 Name명 추가
			, A.ATTR05           
			, NULL								AS ATTR06           
			, NULL								AS ATTR07           
			, NULL								AS ATTR08           
			, NULL								AS ATTR09           
			, NULL								AS ATTR10 
			, A.FCST_TYPE       --ORDER_TYPE_DETAIL
		FROM
		(
			SELECT 
				   P.FROM_SITE						AS PACKER_CODE
				 , P.DIVISION_ID					AS DIVISION_ID     -- DIVISION 
				 , P.PLAN_START_YYYYMMDD			AS PLAN_VERSION    -- 원본테이블의  PLAN_START_YYYYMMDD날자를 VERSION(기준일)으로 갖고간다  
				 , P.ITEM_ID						AS PACK_MODEL_CODE -- PACK ID 
				 , [dbo].[FN_GET_ITEM_NICKNAME]( P.DIVISION_ID, P.ITEM_ID)  AS NICK_NAME
				 , P.CONFIRM_ID						AS SSP_CNFM
				 , P.TO_SITE						AS SALES_SITE
				 , P.TO_SITE_SHIPTO_CODE			AS SHIP_TO_CODE                                             
				 , TC.SHIPTO_DESCRIPTION 	        AS SHIP_TO_NAME
				 , P.TRANSPORT_MODE					AS TRANSPORT_MODE  -- 운송수단
				 , P.INCOTERMS						AS INCOTERMS       -- 거래조건
				 , P.YYYYMMDD						AS SHIP_PLAN_DATE  -- 출하계획일 
				 , P.QTY							AS SHIP_PLAN_QTY   -- 출하계획수량
				 , P.DIVISION_ID + '_' + CONVERT(CHAR(8), DATEADD(dd, -1, GETDATE()),112) + '_' + @ifseqno	AS ATTR_01      
				 , P.PROJECT_CODE					AS ATTR_02           
				 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   
				 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
				 -- 230411 jilee 프로젝트 Name명 추가
				 , ISNULL((SELECT TOP 1 M.PROJECT_NAME FROM SCM_MST_PROJECT M with(nolock) 
						   WHERE M.DIVISION_ID = P.DIVISION_ID AND M.PROJECT_CODE = P.PROJECT_CODE),NULL) 
													AS ATTR05           
				 , ISNULL(LK.SEGMENT2, P.FCST_TYPE) AS FCST_TYPE       --ORDER_TYPE_DETAIL
			  FROM #tmp_SSP_ANL_SHIP_CONFIRM AS P 
				   LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
				ON P.DIVISION_ID					= SI.DIVISION_ID
			   AND P.TO_SITE						= SI.SCM_SITE_ID
			   AND P.ITEM_ID						= SI.ITEM_ID
			   AND P.PROJECT_CODE					= SI.PROJECT_CODE
				   LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
				ON P.DIVISION_ID = MU.DIVISION_ID
			   AND P.FROM_SITE = MU.FROM_SITE
			   AND P.ITEM_ID = MU.ITEM_ID
			   AND MU.VALID_YN = 'Y'
				   LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
				ON mu.user_id = u2.UserID 
			   AND U2.UseYN = 'Y'
				   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
				ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
			   AND LK.VALID_YN	= 'Y'
			   AND P.FCST_TYPE	= LK.SEGMENT1
				   LEFT OUTER JOIN SCM_MST_CUSTOMER TC  WITH(NOLOCK)	
				ON P.DIVISION_ID = TC.DIVISION_ID				
			   AND P.TO_SITE_SOLDTO_CODE = TC.SOLDTO_CODE			
			   AND P.TO_SITE_SHIPTO_CODE = TC.SHIPTO_CODE		
 			   AND TC.VALID_YN = 'Y'		
			 WHERE 1 = 1 
		 ) A
		LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
		
			;
			
		UPDATE R
		   SET R.CONFIRM_ID			= C.CONFIRM_ID 
		  FROM dbo.SSP_ANL_SHIP_REQ_P			AS R WITH(NOLOCK) 
			   JOIN #tmp_SSP_ANL_SHIP_CONFIRM	AS C WITH(NOLOCK) 
		    ON R.REQUEST_ID    = C.CONFIRM_ID	
           AND R.DIVISION_ID   = C.DIVISION_ID
		   AND R.ITEM_ID       = C.ITEM_ID
		   AND R.BOD_ID        = C.BOD_ID
		   AND R.SHIPTO_CODE   = C.TO_SITE_SHIPTO_CODE
		   AND R.YYYYMMDD      = C.YYYYMMDD 

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRAN TX_SH;

        END;  
		

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
		SET @v_sms_desc = @v_division_id + ':Packer:SSP';
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
