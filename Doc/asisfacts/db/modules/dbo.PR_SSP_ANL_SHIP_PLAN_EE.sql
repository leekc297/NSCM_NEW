
CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_PLAN_EE]

/**=========================================================================================================================================================
 * Program ID   : PR_SSP_ANL_SHIP_PLAN_EE
 * Description  : 전극 PSI 정보 생성 
 * OutTable     :
 * Execute      : XXXX 에서 호출 
 * Program History
 *=========================================================================================================================================================
 *   Date       In Charge      Description
 *   20210422   SSP Pjt.       전극 FG 적용
 * 2024.05.03   hsbang         확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT])
 * 2024.10.01   KHJ            NERP_SSP
 *=========================================================================================================================================================
 <MEASURE>  
 * Request용 Measure생성(MEASURE_TYPE = R)
 [R_SCP_PROD_PLAN] SCP Target (Coater)                            
 [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)                         
 [R_FP_COATER_PLAN] Coater Plan                                   
 [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield                  
 [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)   - 실시간          
 [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)           
 [R_SHIP_REQ_ETA] Shipment Request (ETA)  - 실시간                
 [R_SHIP_PLAN_ETD] Shipment Plan(Out)     - 실시간                
 [R_INV_SHIP_REQ] Inventory(Ship Req)     - 계산                  
 [R_INV_SHIP_PLAN] Inventory(Ship Plan)   - 계산                  
                                                             
  * Plan용 Measure생성(MEASURE_TYPE = P)                                        
 [P_SCP_PROD_PLAN] SCP Target (Coater)                            
 [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)                         
 [P_FP_COATER_PLAN] Coater Plan                                   
 [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield                  
 [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)   - 실시간          
 [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)           
 [P_SHIP_REQ_ETD] Shipment Request (ETD)                 -- 실시간
 [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)                       
 [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         -- 실시간
 [P_INV_SIM] Inventory(Simualtion)                       -- 계산  
 [P_INV_CONFIRM] Inventory(Confirm)                      -- 계산  
                        
 <처리 순서>
 1.기준 데이터 추출 및 생성 
 	1-1. BOH CUTOFF 생성  
 	1-2. FP_PLAN 추출
 	1-3. SCP_PROD_PLAN 추출 
 	1-4. SCP_SHIP_PLAN  
 	1-5. 출하요청 생성 
 	1-6. 생성 대상  ITEM  추출 
 	1-7. Stock Deatail cutoff 생성   
 
 2. MEASURE별 Data생성(당일용) 
 	2-1. Request용 Measure생성(MEASURE_TYPE = R)
 	2-2. Plan용 Measure생성(MEASURE_TYPE = P)      
 	       
 3. MEASURE별 Data생성 (CUTOFF용) 
 	3-0. CUTOFF용 전일 대상 추출 ITEM 
 	3-1. 기생성 정보 추출 (전날 기 생성된 정보) 
 	3-2. Request용 Measure생성(MEASURE_TYPE = R) 실시간,계산용 MEASURE
 	3-3. Plan용 Measure생성(MEASURE_TYPE = P) 실시간,계산용 MEASURE				
 					    
 4. 확정 데이터 생성 및 ERP 전송			   
 	4-1. SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_H 생성 
 	4-2. ERP 전송 데이터 생성
 	4-3. SSP_ANL_SHIP_REQ_EE  CONFIRM_ID,FLAG UPDATE                    
 
 5. FP출하타겟 전송 (PR_SSP_PLN_FP_SHIP_TARGET_EE)
 
 *=========================================================================================================================================================
 * 2020.06.16   juhlee         Initial Release [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 
 * 2020.07.02   juhlee         1-7. Stock Deatail cutoff생성 로직 변경 
 * 2020.07.21   juhlee         1-7. Stock Deatail cutoff생성 로직 변경 (PALLET_ID 추가)  
 *              KIMBK          P_SHIP_PLAN_SIMU_ETD Shipment Plan 값 이 0으로 변경
 *                             전극 SITE 별 미사용 STORAGE 정보관리
 * 2020.07.xx                  [C20200723-000010] I/F Blocking 관련 (SSP - SCP Final Plan 동기화)
 * 2020.07.21                  [ADD_20200721] 출하요청 자동 생성 시 LOOKUP으로 자동 생성 SITE만 생성(LOOKUP : ELECTRODE_SHIP_REQ_AUTO_CREATE VALID_YN ='Y' : 자동생성 ) 
 * 2020.07.22                  1-7. Stock Deatail cutoff생성 로직 위치 변경 : BOH 생성 정보 기준 데이터 변경을 위한 위치 이동
 * 2020.09.21   KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2021.01.20   KIM BOK KI     MES & OWMS 재고 정보 체크로직 추가 (I/F 재고 정보미 존재 시 수행하지 않음)
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.02.08   SSP Pjt.       SSP_DNM_MES_STOCK_EE -> SSP_DNM_GMES_STOCK_EE
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2022.08.01   SSP Pjt.       CONFIRM_ROUTE 적용
 * 2024.03.12   jilee          VER CODE 자릿수 제한(Length 10)
 * 2025-07-22   chkim.68       Adding G880 (2025-07-22)
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> FN_GET_SSP_SITE_INFO_TO_COMPANY_ID
 * 2026.08.13	강주용		   MES 재고 부가정보 Data Type varchar Length 정렬
*=========================================================================================================================================================*/
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    --SET ANSI_WARNINGS OFF;


    -- LOG 용 변수 설정
    DECLARE @v_batch_user		NVARCHAR(150) = N'ssp_batch';  

    DECLARE @v_program_name		NVARCHAR(150) = N'PR_SSP_ANL_SHIP_PLAN_EE';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id			NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN_EE'; -- ▶ 테이블 필수
    DECLARE @d_event_date		DATETIME;


    -- 임시 실행시간 확인용
    DECLARE @v_start_time		DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time		NVARCHAR(10) = ''
	DECLARE @v_sms_desc			NVARCHAR(4000);
	DECLARE @v_sms_req			NVARCHAR(10)= '';
	DECLARE @stock_cnt			INTEGER = 0;	

	DECLARE @v_app_type			NVARCHAR(8) = 'SSP';
	DECLARE @v_company_id		NVARCHAR(100) = '';

	-- NERP 매핑코드
    DECLARE @v_C100 NVARCHAR(10);
	DECLARE @v_G180 NVARCHAR(10);
	DECLARE @v_G480 NVARCHAR(10);
    DECLARE @v_G670 NVARCHAR(10);
	DECLARE @v_G740 NVARCHAR(10);
	DECLARE @v_G820 NVARCHAR(10);
	DECLARE @v_G870 NVARCHAR(10);
	DECLARE @v_G880 NVARCHAR(10);

	DECLARE @v_G481A NVARCHAR(10);
	DECLARE @v_A011E NVARCHAR(10);
	DECLARE @v_A041E NVARCHAR(10);
	DECLARE @v_G182A NVARCHAR(10);

	DECLARE @v_G481A_100X NVARCHAR(10);
	DECLARE @v_A011E_310H NVARCHAR(10);
	DECLARE @v_A011E_320W NVARCHAR(10);
	DECLARE @v_A011E_312W NVARCHAR(10);
	DECLARE @v_A041E_310N NVARCHAR(10);
	DECLARE @v_A041E_320N NVARCHAR(10);
	
	SET @v_C100  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESOC');	--C100
	SET @v_G180  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESNJ');	--G180
	SET @v_G480  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESWA');	--G480
	SET @v_G670  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESUC');	--G670
	SET @v_G740  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESHM');	--G740
	SET @v_G820  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESST');	--G820
	SET @v_G870  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESHD');	--G870
	SET @v_G880  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'ESHG');	--G880 (2025-07-22)


	SET @v_G481A  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'G481A' );	--G481-A
	SET @v_A011E  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A011E' );	--A011-E
	SET @v_A041E  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A041E' );	--A041-E
	SET @v_G182A  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'G182A' );	--G182-A

	SET @v_G481A_100X  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'G481A_100X' );	
	SET @v_A011E_310H  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A011E_310H');	
	SET @v_A011E_320W  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A011E_320W' );	
	SET @v_A011E_312W  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A011E_312W' );	
	SET @v_A041E_310N  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A041E_310N' );	
	SET @v_A041E_320N  = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_SHIP_PLAN_EE'  ,'A041E_320N');	


	DECLARE @TAB_COMPANY		TABLE
    (
	    TID								INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		COMPANY_ID						nvarchar(50)
    );

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;
	DECLARE @c_company_id   nvarchar(30);
	--
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
	
    -- 계획 구간 Start End 일자 (현재일 ~ 8주)--------------------------------------------------------------------------------

    DECLARE @v_plan_start_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_plan_end_yyyymmdd   NVARCHAR(8) = '';

	SET     @v_plan_start_yyyymmdd = CONVERT(char(8), GETDATE(), 112); -- 현재일 

	SET     @v_plan_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, 56, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ; 
    ---------------------------------------------------------------------------------------------------------------------------

    
	-- 실적구간 Start End 일자 (전주 월요일 ~ 계획구간 start일자-1)------------------------------------------------------------ 
    DECLARE @v_result_plan_start_yyyymmdd NVARCHAR(8) = '';
	DECLARE @v_result_plan_end_yyyymmdd   NVARCHAR(8) = '';

    -- 해당주 전주 월요일 
	SELECT @v_result_plan_start_yyyymmdd  = C.BASIS_YYYYMMDD
	FROM   SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
	WHERE  C.ISO_YYYYWW = ( 
							SELECT MIN(ISO_YYYYWW)  AS ISO_YYYYWW
							FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK) 
							WHERE BASIS_YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, -7, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
							AND   BASIS_YYYYMMDD <=  @v_plan_start_yyyymmdd
						  )
	AND  C.DAYOFWEEK = 'MON' 
	; 

	SET     @v_result_plan_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) ; 
    ---------------------------------------------------------------------------------------------------------------------------



    --FP MES 실적 수신 완료 된 법인 만 수행 (실적수신이 되어야 FP 과거 실적정보가 만들어짐) ,시업시간 
	SELECT @v_company_id = STUFF(( SELECT ','+ TT.COMPANY_ID         
								FROM (
									SELECT S.COMPANY_ID AS COMPANY_ID 
									FROM   [LGCE_FPDEV_TR].[DBO].[SCM_SYS_LOOKUP_VALUE] L WITH(NOLOCK) 
									   JOIN SCM_MST_SITE S WITH(NOLOCK) 
										 ON S.SITE_ID = L.SEGMENT1
									   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L2 WITH(NOLOCK)  
									     ON L2.SEGMENT1 = S.PLANT_ID
                                        AND L2.SEGMENT4 = S.COMPANY_ID
										AND REPLACE(L2.SEGMENT2,':','') = L.SEGMENT2 -- 시업시간 
										AND L2.LOOKUP_TYPE = 'BASIS_START_TIME_PLANT'
									   JOIN SSP_MST_SHIP_PLAN_SCHEDULE_EE E WITH(NOLOCK) 
										 ON E.COMPANY_ID = S.COMPANY_ID 
										AND E.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND E.CURRENT_PLAN_DATE_YN = 'N'      -- 미수행 

									WHERE  L.LOOKUP_TYPE_CODE = 'AUTO_PLAN_CALL_FLAG'
									AND    L.ACTIVE_FLAG = 'Y'
									AND    L.ATTRIBUTE1  =  @v_plan_start_yyyymmdd
									GROUP BY S.COMPANY_ID 
								) TT  
								FOR XML PATH('')     
								), 1, 1, ''
								) ;


-- MANUAL로 수행시 법인 SETUP
--SET @v_company_id = 'G180'; 
--SET @v_company_id = 'G180,G450'; 
--SET @v_company_id = 'C100,G180,G450';
--SET @v_company_id = 'C100,G180,G450,G630';
--SET @v_company_id = 'C100,G180,G450,G630,G480'; 
--SET @v_company_id = 'C100,G180,G450,G630,G480,G380'; -- 전체 
--SET @v_company_id = 'G180,G380,G450,G480';

	INSERT INTO @TAB_COMPANY (COMPANY_ID)
	     SELECT X.SEGMENT4 AS COMPANY_ID
	       FROM (
	       	    SELECT SEGMENT4, COUNT(*) AS CNT
	       		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	       		 WHERE 1 = 1
	       		   AND LOOKUP_TYPE = 'IF_STOCK_CHECK'
	       		   AND VALID_YN    = 'Y'
	       		   AND SEGMENT1    = 'PLAN_EE'
	       		   AND SEGMENT3    = 'EE'
	       		   AND SEGMENT4    IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_company_id,',') )
	       		 GROUP BY SEGMENT4
	       	    ) AS X
	       	    JOIN (
	       			 SELECT SEGMENT4, COUNT(*) AS CNT
	       			   FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
	       			  WHERE 1 = 1
	       			    AND LOOKUP_TYPE = 'IF_STOCK_CHECK'
	       			    AND VALID_YN    = 'Y'
	       			    AND SEGMENT1    = 'PLAN_EE'
	       			    AND SEGMENT3    = 'EE'
	       			    AND SEGMENT4    IN ( SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_company_id,',') )
	       			    AND SEGMENT5    = CONVERT(CHAR(8), GETDATE(), 112)
	       			  GROUP BY SEGMENT4
	       		     ) AS Y
	       	 ON X.SEGMENT4		= Y.SEGMENT4
	        AND X.CNT			= Y.CNT
	;


	SELECT @INX			= 1
		  ,@MAX_NUM		= COUNT(*)
	  FROM @TAB_COMPANY

	IF @MAX_NUM = 0
		RETURN;

	SELECT @v_company_id = STUFF((
			SELECT ',' + T.COMPANY_ID 
			  FROM @TAB_COMPANY AS T
			   FOR XML PATH('')
			),1,1,'') 


    -- 시업시간과 일치하는 법인 만 수행    
    ---------------------------------
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_PLAN_EE INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;

    BEGIN TRY
    BEGIN
        BEGIN TRAN TX_SH

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT @c_company_id			= COMPANY_ID			
			  FROM @TAB_COMPANY 
			 WHERE TID						= @INX

			--중복수행 방지 CURRENT_PLAN_DATE_YN  = 'P' --진행중 
			UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE
			   SET CURRENT_PLAN_DATE_YN		= 'P' --진행중 
				  ,CREATION_DATE			= GETDATE()
				  ,LAST_UPDATE_DATE			= GETDATE()
				  ,LAST_UPDATED_BY			= @v_batch_user
			 WHERE COMPANY_ID				= @c_company_id
			   AND PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd
			;

			/**************************************************************************************************************** 
			1.기준 데이터 추출 및 생성 
				1-1 BOH CUTOFF생성       : #TMP_FP_BOH -->  SSP_ANL_BOH_CUTOFF_EE
				1-2 FP_PLAN              : #TMP_FP_PLAN
				1-3 SCP_PROD_PLAN        : #TMP_SCP_PROD_PLAN
				1-4 SCP_SHIP_PLAN        : #TMP_SCP_SHIP_PLAN
				1-5 출하요청 DEFAULT생성 : SSP_ANL_SHIP_REQ_EE
				1-6 생성 대상            : #TMP_PLAN_ITEM 
											SCM_MST_SITE_ITEM 등록기준으로 (BOH + FP + SCP_PROD_PLAN + SCP_SHIP_PLAN) 있는것들 
											SSP_MST_SITE_ITEM_EE_V로 적용 ( <-- SCM_MST_SITE_ITEM기준) 
				1-7 Stock Deatail cutoff생성 : SSP_ANL_STOCK_EE_C 		                                   
			***************************************************************************************************************/ 


			/*------------------------------------------------------------------------------------------------------------- 
			1-7. Stock Deatail cutoff생성 : SSP_ANL_STOCK_EE_C 	
					iWMS, GMES, oWMS 재고
					- iWMS : 조립기준 
					- GMES : 조립/전극 구분  
					- oWMS : 조립기준
				 
			2020.06.30 : 조립/전극 분리하여 각 화면별로 조회하였으나 통합하여 보여줌  
					- iWMS : 조립기준  --> 조립 + 전극 MAPPING 추가 생성 (조립-> 전극)  
					- GMES : 조립/전극 --> 조립/전극 + 전극/조립 MAPPING 추가 생성(조립->전극 , 전극 -> 조립)  
					- oWMS : 조립기준  --> 조립 + 전극 MAPPING 추가 생성 (조립-> 전극)  
				 
					Shipment Request > Stock Detail : TYPE = 'A' (iWMS/GMES/oWMS)
					Shipment Plan    > Stock Detail : TYPE = 'E' (GMES/oWMS/oWMS)

			2020.07.21 : PALLET_ID 컬럼 추가 
			--------------------------------------------------------------------------------------------------------------*/ 
			IF OBJECT_ID('tempdb..#NEW_STOCK_EE') IS NOT NULL
			DROP TABLE #NEW_STOCK_EE

			-- 금일자 재고정보 추출 
			SELECT   X.COMPANY_ID 
			,        X.PLAN_START_YYYYMMDD  
			,        X.DIVISION_ID
			,        X.TYPE
			,        X.FROM_SITE
			,        X.PLANT_ID 
			,        X.ITEM_ID
			,        X.LOT_ID
			,        X.PALLET_ID 
			,        ISNULL(X.VERSION,'')    AS VERSION 
			,        ISNULL(X.STORAGE_ID,'') AS STORAGE_ID
			,        ISNULL(X.OPERATION_ID,'-') AS OPERATION_ID 
			,        NULL                    AS  CHANGE_STATUS 
			,        SUM(X.IWMS_QTY)     AS IWMS_QTY 
			,        SUM(X.GMES_QTY)     AS GMES_QTY 
			,        SUM(X.OWMS_QTY)     AS OWMS_QTY 
			,        SUM(X.TOT_QTY )     AS TOT_QTY
			,        CASE WHEN SUM(X.IWMS_HOLD_CNT + X.GMES_HOLD_CNT + X.QMS_HOLD_CNT + X.OWMS_HOLD_CNT) > 0 THEN 'N' ELSE 'Y' END AS AVAILABLE_YN
			,        CASE WHEN SUM(X.IWMS_HOLD_CNT) > 0 THEN 'Y' ELSE 'N' END AS IWMS_HOLD_YN 
			,        CASE WHEN SUM(X.GMES_HOLD_CNT) > 0 THEN 'Y' ELSE 'N' END AS GMES_HOLD_YN 
			,        CASE WHEN SUM(X.QMS_HOLD_CNT)  > 0 THEN 'Y' ELSE 'N' END AS  QMS_HOLD_YN 
			,        CASE WHEN SUM(X.OWMS_HOLD_CNT) > 0 THEN 'Y' ELSE 'N' END AS OWMS_HOLD_YN 
			,        ISNULL(X.EXPIRATION_DATE,'') AS EXPIRATION_DATE
			,        MAX(ISNULL(X.PACKAGE_TYPE,''))  AS PACKAGE_TYPE
			,        'ssp_batch'              AS CREATED_BY
			,        GETDATE() AS CREATION_DATE
			,        'ssp_batch' AS  LAST_UPDATED_BY
			,        GETDATE() AS  LAST_UPDATE_DATE
			INTO    #NEW_STOCK_EE 
			FROM ( 
				-- MES는 조립/전극 구분
				-- 원 조립/전극  
					SELECT 
						'MES'                          AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,X.DIVISION_ID					AS DIVISION_ID             
					,X.INSTANCE_TYPE				AS TYPE    -- E:전극, A:조립                  
					,X.FROM_SITE					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID              		    AS LOT_ID  
					,'-'                            AS PALLET_ID 
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.STORAGE_ID_ERP				AS STORAGE_ID  
					,X.OPERATION_ID                 AS OPERATION_ID             
					,0								AS IWMS_QTY                
					,SUM(X.STOCK_QTY)				AS GMES_QTY                
					,0								AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,NULL							AS IWMS_HOLD_YN  
					,0   							AS IWMS_HOLD_CNT 
					,ISNULL(X.MES_HOLD,'N')         AS GMES_HOLD_YN    
					,CASE WHEN ISNULL(X.MES_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS GMES_HOLD_CNT     
        
					,ISNULL(X.QMS_HOLD,'N')			AS QMS_HOLD_YN    
					,CASE WHEN ISNULL(X.QMS_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS QMS_HOLD_CNT             

					,NULL							AS OWMS_HOLD_YN 
					,0                              AS OWMS_HOLD_CNT           

					,X.EXPIRATION_DATE				AS EXPIRATION_DATE         
					,NULL							AS PACKAGE_TYPE         
					FROM  SSP_DNM_GMES_STOCK_EE X WITH(NOLOCK) 
					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        X.DIVISION_ID
					,        X.INSTANCE_TYPE
					,        X.FROM_SITE
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.ELECTRODE_VERSION
					,        X.STORAGE_ID_ERP
					,        X.OPERATION_ID 
					,        X.MES_HOLD
					,        X.QMS_HOLD	
					,        X.EXPIRATION_DATE	

					UNION ALL
				-- 조립 --> 전극 
					SELECT 
						'MES'                          AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,L.SEGMENT3						AS DIVISION_ID             
					,'E'				            AS TYPE    -- E:전극, A:조립                  
					,L.ATTRIBUTE2					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID              		    AS LOT_ID  
					,'-'                            AS PALLET_ID 					                
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.STORAGE_ID_ERP				AS STORAGE_ID  
					,X.OPERATION_ID                 AS OPERATION_ID             
					,0								AS IWMS_QTY                
					,SUM(X.STOCK_QTY)				AS GMES_QTY                
					,0								AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,NULL							AS IWMS_HOLD_YN  
					,0   							AS IWMS_HOLD_CNT 
					,ISNULL(X.MES_HOLD,'N')         AS GMES_HOLD_YN    
					,CASE WHEN ISNULL(X.MES_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS GMES_HOLD_CNT     
        
					,ISNULL(X.QMS_HOLD,'N')			AS QMS_HOLD_YN    
					,CASE WHEN ISNULL(X.QMS_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS QMS_HOLD_CNT             

					,NULL							AS OWMS_HOLD_YN 
					,0                              AS OWMS_HOLD_CNT           

					,X.EXPIRATION_DATE				AS EXPIRATION_DATE         
					,NULL							AS PACKAGE_TYPE         
					FROM SSP_DNM_GMES_STOCK_EE X WITH(NOLOCK) 

						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 조립-> 전극 
						AND L.SEGMENT1    = X.DIVISION_ID  -- 조립 DIVISION 
						AND L.ATTRIBUTE1  = X.FROM_SITE    -- 조립 SCM_SITE_ID  

					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					AND   X.INSTANCE_TYPE = 'A' -- 조립 
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        L.SEGMENT3	
					,        L.ATTRIBUTE2
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.ELECTRODE_VERSION
					,        X.STORAGE_ID_ERP
					,        X.OPERATION_ID 
					,        X.MES_HOLD
					,        X.QMS_HOLD	
					,        X.EXPIRATION_DATE	

               
					UNION ALL
				-- 전극 --> 조립 
					SELECT 
						'MES'                          AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,L.SEGMENT1						AS DIVISION_ID             
					,'A'				            AS TYPE    -- E:전극, A:조립                  
					,L.ATTRIBUTE1					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID              		    AS LOT_ID 
					,'-'                            AS PALLET_ID 					                 
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.STORAGE_ID_ERP				AS STORAGE_ID  
					,X.OPERATION_ID                 AS OPERATION_ID             
					,0								AS IWMS_QTY                
					,SUM(X.STOCK_QTY)				AS GMES_QTY                
					,0								AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,NULL							AS IWMS_HOLD_YN  
					,0   							AS IWMS_HOLD_CNT 
					,ISNULL(X.MES_HOLD,'N')         AS GMES_HOLD_YN    
					,CASE WHEN ISNULL(X.MES_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS GMES_HOLD_CNT     
        
					,ISNULL(X.QMS_HOLD,'N')			AS QMS_HOLD_YN    
					,CASE WHEN ISNULL(X.QMS_HOLD,'N') ='Y' THEN 1 ELSE 0 END 		AS QMS_HOLD_CNT             

					,NULL							AS OWMS_HOLD_YN 
					,0                              AS OWMS_HOLD_CNT           

					,X.EXPIRATION_DATE				AS EXPIRATION_DATE         
					,NULL							AS PACKAGE_TYPE         
					FROM SSP_DNM_GMES_STOCK_EE X WITH(NOLOCK) 

						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 전극 -> 조립 
						AND L.VALID_YN    = 'Y'
						AND L.SEGMENT3    = X.DIVISION_ID  -- 전극 DIVISION 
						AND L.ATTRIBUTE2  = X.FROM_SITE    -- 전극 SCM_SITE_ID  

					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					AND   X.INSTANCE_TYPE = 'E' -- 전극 
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        L.SEGMENT1	
					,        L.ATTRIBUTE1
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.ELECTRODE_VERSION
					,        X.STORAGE_ID_ERP
					,        X.OPERATION_ID 
					,        X.MES_HOLD
					,        X.QMS_HOLD	
					,        X.EXPIRATION_DATE	

					UNION ALL 

					-- 조립 IWMS (TYPE : A) 
					SELECT 
						'IWMS'                         AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,X.DIVISION_ID					AS DIVISION_ID             
					,'A'             				AS TYPE    -- E:전극, A:조립                  
					,X.FROM_SITE					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID              		    AS LOT_ID
					,'-'                            AS PALLET_ID 					                   
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.ERP_SLOC_ID				    AS STORAGE_ID  
					,'-'                            AS OPERATION_ID            
					,SUM(X.STOCK_QTY)				AS IWMS_QTY                
					,0								AS GMES_QTY                
					,0								AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,X.HOLD							AS IWMS_HOLD_YN       
					,CASE WHEN X.HOLD ='Y' THEN 1 ELSE 0 END AS IWMS_HOLD_CNT         
					,NULL						    AS GMES_HOLD_YN   
					,0   						    AS GMES_HOLD_CNT              
					,NULL					        AS QMS_HOLD_YN             
					,0   					        AS QMS_HOLD_CNT
					,NULL							AS OWMS_HOLD_YN       
					,0                              AS OWMS_HOLD_CNT    
					,CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)				AS EXPIRATION_DATE         
					,NULL							AS PACKAGE_TYPE         
					FROM SSP_DNM_IWMS_STOCK_EE X WITH(NOLOCK) 
					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        X.DIVISION_ID
					,        X.FROM_SITE
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.ELECTRODE_VERSION
					,        X.ERP_SLOC_ID
					,        CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)
					,        X.HOLD

					UNION ALL 

					-- 전극IWMS (TYPE : E) : 조립 --> 전극 
					SELECT 
						'IWMS'                         AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,L.SEGMENT3					    AS DIVISION_ID             
					,'E'             				AS TYPE    -- E:전극, A:조립                  
					,L.ATTRIBUTE2					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID              		    AS LOT_ID  
					,'-'                            AS PALLET_ID 					                 
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.ERP_SLOC_ID				    AS STORAGE_ID    
					,'-'                            AS OPERATION_ID          
					,SUM(X.STOCK_QTY)				AS IWMS_QTY                
					,0								AS GMES_QTY                
					,0								AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,X.HOLD							AS IWMS_HOLD_YN       
					,CASE WHEN X.HOLD ='Y' THEN 1 ELSE 0 END AS IWMS_HOLD_CNT         
					,NULL						    AS GMES_HOLD_YN   
					,0   						    AS GMES_HOLD_CNT              
					,NULL					        AS QMS_HOLD_YN             
					,0   					        AS QMS_HOLD_CNT
					,NULL							AS OWMS_HOLD_YN       
					,0                              AS OWMS_HOLD_CNT    
					,CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)				AS EXPIRATION_DATE         
					,NULL							AS PACKAGE_TYPE         
					FROM SSP_DNM_IWMS_STOCK_EE X WITH(NOLOCK) 

						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 조립-> 전극 
						AND L.SEGMENT1    = X.DIVISION_ID  -- 조립 DIVISION 
						AND L.ATTRIBUTE1  = X.FROM_SITE  -- 조립 SCM_SITE_ID  

					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        L.SEGMENT3
					,        L.ATTRIBUTE2
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.ELECTRODE_VERSION
					,        X.ERP_SLOC_ID
					,        CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)
					,        X.HOLD

					UNION ALL

					-- 전극 OWMS  (TYPE : A)  전극 --> 조립   
					SELECT 
					'OWMS'                          AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,L.SEGMENT1					    AS DIVISION_ID             
					,'A'             				AS TYPE    -- E:전극, A:조립                  
					,L.ATTRIBUTE1					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID                       AS LOT_ID  
					,X.PALLET_ID                    AS PALLET_ID 					            
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.STORAGE_ID				    AS STORAGE_ID  
					,'-'                            AS OPERATION_ID            
					,0								AS IWMS_QTY                
					,0								AS GMES_QTY                
					,SUM(X.STOCK_QTY)				AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,NULL							AS IWMS_HOLD_YN    
					,0							    AS IWMS_HOLD_CNT   
					,NULL						    AS GMES_HOLD_YN        
					,0						        AS GMES_HOLD_CNT
					,NULL					        AS QMS_HOLD_YN     
					,0 					            AS QMS_HOLD_CNT              
					,CASE WHEN X.STOCK_STATUS ='40' THEN 'Y' ELSE 'N' END  AS OWMS_HOLD_YN          -- STOCK STATUS : 40 (품질HOLD) 
					,SUM(CASE WHEN X.STOCK_STATUS ='40' THEN 1 ELSE 0 END) AS OWMS_HOLD_CNT
					,CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)			AS EXPIRATION_DATE         
					,X.PACKING_STATUS_ELEC							AS PACKAGE_TYPE         
					FROM SSP_DNM_OWMS_STOCK_EE X WITH(NOLOCK) 

						JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 전극 -> 조립 
						AND L.VALID_YN    = 'Y'
						AND L.SEGMENT3    = X.DIVISION_ID  -- 전극 DIVISION 
						AND L.ATTRIBUTE2  = X.FROM_SITE    -- 전극 SCM_SITE_ID  

					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        L.SEGMENT1
					,        L.ATTRIBUTE1
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.PALLET_ID
					,        X.ELECTRODE_VERSION
					,        X.STORAGE_ID
					,        CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)
					,        X.STOCK_STATUS
					,        X.PACKING_STATUS_ELEC

					UNION ALL 

					-- 전극 OWMS  (TYPE : E)  
					SELECT 
					'OWMS'                          AS SOURCE_TYPE 
					,X.COMPANY_ID					AS COMPANY_ID              
					,X.YYYYMMDD						AS PLAN_START_YYYYMMDD     
					,X.DIVISION_ID					AS DIVISION_ID             
					,'E'             				AS TYPE    -- E:전극, A:조립                  
					,X.FROM_SITE					AS FROM_SITE               
					,X.PLANT_ID						AS PLANT_ID                
					,X.ITEM_ID						AS ITEM_ID                 
					,X.LOT_ID                       AS LOT_ID 
					,X.PALLET_ID                    AS PALLET_ID 								             
					,X.ELECTRODE_VERSION			AS VERSION                 
					,X.STORAGE_ID				    AS STORAGE_ID     
					,'-'                            AS OPERATION_ID         
					,0								AS IWMS_QTY                
					,0								AS GMES_QTY                
					,SUM(X.STOCK_QTY)				AS OWMS_QTY                
					,SUM(X.STOCK_QTY)				AS TOT_QTY                 
					,NULL							AS IWMS_HOLD_YN    
					,0							    AS IWMS_HOLD_CNT   
					,NULL						    AS GMES_HOLD_YN        
					,0						        AS GMES_HOLD_CNT
					,NULL					        AS QMS_HOLD_YN     
					,0 					            AS QMS_HOLD_CNT              
					,CASE WHEN X.STOCK_STATUS ='40' THEN 'Y' ELSE 'N' END  AS OWMS_HOLD_YN          -- STOCK STATUS : 40 (품질HOLD) 
					,SUM(CASE WHEN X.STOCK_STATUS ='40' THEN 1 ELSE 0 END) AS OWMS_HOLD_CNT
					,CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)			AS EXPIRATION_DATE         
					,X.PACKING_STATUS_ELEC							AS PACKAGE_TYPE         
					FROM  SSP_DNM_OWMS_STOCK_EE X WITH(NOLOCK) 
					WHERE X.YYYYMMDD		= @v_plan_start_yyyymmdd
					AND   X.COMPANY_ID		= @c_company_id
					GROUP BY X.COMPANY_ID
					,        X.YYYYMMDD
					,        X.DIVISION_ID
					,        X.FROM_SITE
					,        X.PLANT_ID
					,        X.ITEM_ID
					,        X.LOT_ID
					,        X.PALLET_ID
					,        X.ELECTRODE_VERSION
					,        X.STORAGE_ID
					,        CONVERT(CHAR(8), X.EXPIRATION_DATE , 112)
					,        X.STOCK_STATUS
					,        X.PACKING_STATUS_ELEC

			) X 
			GROUP BY X.COMPANY_ID 
			,        X.PLAN_START_YYYYMMDD  
			,        X.DIVISION_ID
			,        X.TYPE
			,        X.FROM_SITE
			,        X.PLANT_ID 
			,        X.ITEM_ID
			,        X.LOT_ID
			,        X.PALLET_ID 
			,        X.VERSION 
			,        X.STORAGE_ID
			,        X.OPERATION_ID
			,        X.EXPIRATION_DATE
			;


			DELETE 
			FROM SSP_ANL_STOCK_EE_C 
			WHERE PLAN_START_YYYYMMDD  = @v_plan_start_yyyymmdd
			AND   COMPANY_ID		= @c_company_id
			; 

			-- 이전 데이터 비교 후 INSERT 
			INSERT INTO SSP_ANL_STOCK_EE_C (
				COMPANY_ID
			,PLAN_START_YYYYMMDD
			,DIVISION_ID
			,TYPE
			,FROM_SITE
			,PLANT_ID
			,ITEM_ID
			,LOT_ID
			,PALLET_ID
			,VERSION
			,STORAGE_ID
			,OPERATION_ID
			,CHANGE_STATUS
			,IWMS_QTY
			,GMES_QTY
			,OWMS_QTY
			,TOT_QTY
			,AVAILABLE_YN
			,IWMS_HOLD_YN
			,GMES_HOLD_YN
			,QMS_HOLD_YN
			,OWMS_HOLD_YN
			,EXPIRATION_DATE
			,PACKAGE_TYPE
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			) 
			SELECT ISNULL(A.COMPANY_ID               , B.COMPANY_ID                   )  AS COMPANY_ID  
			,      @v_plan_start_yyyymmdd                                                AS PLAN_START_YYYYMMDD       
			,      ISNULL(A.DIVISION_ID              , B.DIVISION_ID                  )  AS DIVISION_ID          
			,      ISNULL(A.TYPE                     , B.TYPE                         )  AS TYPE                 
			,      ISNULL(A.FROM_SITE                , B.FROM_SITE                    )  AS FROM_SITE            
			,      ISNULL(A.PLANT_ID                 , B.PLANT_ID                     )  AS PLANT_ID             
			,      ISNULL(A.ITEM_ID                  , B.ITEM_ID                      )  AS ITEM_ID              
			,      ISNULL(A.LOT_ID                   , B.LOT_ID                       )  AS LOT_ID   
			,      ISNULL(A.PALLET_ID                , B.PALLET_ID                    )  AS PALLET_ID             			          
			-- START [E20260804-000830] MES 재고 부가정보 Data Type varchar Length 정렬
			--원본,      ISNULL(LEFT(A.VERSION,10)         , LEFT(B.VERSION,10)             )  AS VERSION            
			,      ISNULL(A.VERSION					 , B.VERSION					  )  AS VERSION            
			-- END [E20260804-000830] MES 재고 부가정보 Data Type varchar Length 정렬
			,      ISNULL(A.STORAGE_ID               , B.STORAGE_ID                   )  AS STORAGE_ID 
			,      ISNULL(A.OPERATION_ID             , B.OPERATION_ID                 )  AS OPERATION_ID     
			,      CASE WHEN B.AVAILABLE_YN IS NULL THEN 'N'  -- 신규 
									ELSE 
											CASE WHEN A.AVAILABLE_YN IS NULL THEN 'D' -- 삭제 
												ELSE 
													CASE WHEN A.AVAILABLE_YN <> B.AVAILABLE_YN THEN 'C' -- 변경
													ELSE 'X'  -- 변경없음  
													END 
												END  
									END	                                                 AS CHANGE_STATUS    
			,      ISNULL(A.IWMS_QTY                 , B.IWMS_QTY                     )  AS IWMS_QTY             
			,      ISNULL(A.GMES_QTY                 , B.GMES_QTY                     )  AS GMES_QTY           
			,      ISNULL(A.OWMS_QTY                 , B.OWMS_QTY                     )  AS OWMS_QTY           
			,      ISNULL(A.TOT_QTY                  , B.TOT_QTY                      )  AS TOT_QTY        
			,      ISNULL(A.AVAILABLE_YN             , B.AVAILABLE_YN                 )  AS AVAILABLE_YN               
			,      ISNULL(A.IWMS_HOLD_YN             , B.IWMS_HOLD_YN                 )  AS IWMS_HOLD_YN       
			,      ISNULL(A.GMES_HOLD_YN             , B.GMES_HOLD_YN                 )  AS GMES_HOLD_YN         
			,      ISNULL(A.QMS_HOLD_YN              , B.QMS_HOLD_YN                  )  AS QMS_HOLD_YN          
			,      ISNULL(A.OWMS_HOLD_YN             , B.OWMS_HOLD_YN                 )  AS OWMS_HOLD_YN         
			,      ISNULL(A.EXPIRATION_DATE          , B.EXPIRATION_DATE              )  AS EXPIRATION_DATE    
			,      ISNULL(A.PACKAGE_TYPE             , B.PACKAGE_TYPE                 )  AS PACKAGE_TYPE       
			,      ISNULL(B.CREATED_BY               , @v_batch_user                  )  AS CREATED_BY                
			,      ISNULL(B.CREATION_DATE            , GETDATE()                      )  AS CREATION_DATE             
			,      ISNULL(B.LAST_UPDATED_BY          , @v_batch_user                  )  AS LAST_UPDATED_BY           
			,      ISNULL(B.LAST_UPDATE_DATE         , GETDATE()                      )  AS LAST_UPDATE_DATE 		 
			FROM #NEW_STOCK_EE A WITH(NOLOCK) 
					FULL OUTER JOIN ( 
									-- 이전 정보 
							SELECT   COMPANY_ID
									,PLAN_START_YYYYMMDD
									,DIVISION_ID
									,TYPE
									,FROM_SITE
									,PLANT_ID
									,ITEM_ID
									,LOT_ID
									,PALLET_ID
									,VERSION
									,STORAGE_ID
									,OPERATION_ID
									,CHANGE_STATUS
									,IWMS_QTY
									,GMES_QTY
									,OWMS_QTY
									,TOT_QTY
									,AVAILABLE_YN
									,IWMS_HOLD_YN
									,GMES_HOLD_YN
									,QMS_HOLD_YN
									,OWMS_HOLD_YN
									,EXPIRATION_DATE
									,PACKAGE_TYPE
									,CREATED_BY
									,CREATION_DATE
									,LAST_UPDATED_BY
									,LAST_UPDATE_DATE 
							FROM SSP_ANL_STOCK_EE_C  WITH(NOLOCK) 
							WHERE PLAN_START_YYYYMMDD  = (SELECT MAX(PLAN_START_YYYYMMDD) 
															FROM SSP_ANL_STOCK_EE_C WITH(NOLOCK)
															WHERE 1=1 
															AND  PLAN_START_YYYYMMDD < @v_plan_start_yyyymmdd
															AND  COMPANY_ID		= @c_company_id
															) 
							AND   COMPANY_ID		= @c_company_id
							AND   CHANGE_STATUS       <> 'D' -- 삭제된건 제외 
							) B
					ON B.COMPANY_ID      = A.COMPANY_ID 
				AND B.DIVISION_ID	  = A.DIVISION_ID 
				AND B.TYPE            = A.TYPE 
				AND B.FROM_SITE       = A.FROM_SITE
				AND B.PLANT_ID        = A.PLANT_ID 
				AND B.ITEM_ID         = A.ITEM_ID 
				AND B.LOT_ID          = A.LOT_ID 
				AND B.PALLET_ID       = A.PALLET_ID
				AND B.VERSION         = A.VERSION
				AND B.STORAGE_ID      = A.STORAGE_ID 
				AND B.EXPIRATION_DATE = A.EXPIRATION_DATE 
				AND B.OPERATION_ID    = A.OPERATION_ID
			;
			 -- DELETE 상태 삭제 , 0 인것 삭제 
			 DELETE 
			 FROM SSP_ANL_STOCK_EE_C 
			 WHERE PLAN_START_YYYYMMDD	= @v_plan_start_yyyymmdd
			 AND   COMPANY_ID			= @c_company_id
			 AND   (CHANGE_STATUS = 'D' OR  TOT_QTY = 0 )
			 ;


				/*------------------------------------------------------------------------------------------------------------- 
				1-1.SSP_ANL_BOH_CUTOFF_EE 
					FP PANCAKE SIMULATION BOH ([LGCE_FP_TR].[DBO].[IF_SSP_FP_PANCAKE_SIMUL_WIP_V] ) 
				--------------------------------------------------------------------------------------------------------------*/ 
				IF OBJECT_ID('tempdb..#TMP_FP_BOH') IS NOT NULL
				DROP TABLE #TMP_FP_BOH

				CREATE TABLE #TMP_FP_BOH (
				 COMPANY_ID           NVARCHAR(030)  
				,DIVISION_ID          NVARCHAR(030)  
				,PLANT_ID             NVARCHAR(030)  
				,SCM_SITE_ID          NVARCHAR(030) 
				,MODEL_ID             NVARCHAR(050)  
				,ITEM_ID              NVARCHAR(050)  
				,TOT_BOH_QTY          NUMERIC(20,10) 
				,JR_BOH_QTY           NUMERIC(20,10) 
				,PC_BOH_QTY           NUMERIC(20,10) 
				,TOT_BOH_QTY_TO_PCM   NUMERIC(20,10) 
				,JR_BOH_QTY_TO_PCM    NUMERIC(20,10) 
				,PC_BOH_QTY_TO_PCM    NUMERIC(20,10) 
				,TOT_BOH_QTY_TO_CELL  NUMERIC(20,10) 
				,JR_BOH_QTY_TO_CELL   NUMERIC(20,10) 
				,PC_BOH_QTY_TO_CELL   NUMERIC(20,10) 
				,OP_LT                NVARCHAR(030) 
				,MEASURE_TYPE         NVARCHAR(001) -- R (Request) :조립기준, P(plan) : 전극기준 
				);

			   -- 전극 SITE 기준 재고 ( PLAN용: 전극기준 ) 
				INSERT INTO #TMP_FP_BOH (
					 COMPANY_ID  
					,DIVISION_ID 
					,PLANT_ID    
					,SCM_SITE_ID
					,MODEL_ID    
					,ITEM_ID 
					,TOT_BOH_QTY 
					,JR_BOH_QTY  
					,PC_BOH_QTY  
					,TOT_BOH_QTY_TO_PCM  
					,JR_BOH_QTY_TO_PCM  
					,PC_BOH_QTY_TO_PCM 
					,TOT_BOH_QTY_TO_CELL
					,JR_BOH_QTY_TO_CELL  
					,PC_BOH_QTY_TO_CELL 
					,OP_LT   
					,MEASURE_TYPE   			
				)
				SELECT T.COMPANY_ID  
				,      T.DIVISION_ID
				,      T.PLANT_ID
				,      T.SCM_SITE_ID
				,      T.MODEL_ID    
				,      T.ITEM_ID     
				,      T.TOT_BOH_QTY 
				,      T.JR_BOH_QTY  
				,      T.PC_BOH_QTY  
				,      T.TOT_BOH_QTY_TO_PCM  
				,      T.JR_BOH_QTY_TO_PCM  
				,      T.PC_BOH_QTY_TO_PCM 
				,      T.TOT_BOH_QTY_TO_CELL 
				,      T.JR_BOH_QTY_TO_CELL  
				,      T.PC_BOH_QTY_TO_CELL 
				,      T.OP_LT 
				,      T.MEASURE_TYPE       
				FROM   (
						SELECT A.COMPANY_ID
							 , A.DIVISION_ID
							 , L.SEGMENT4  AS PLANT_ID--A.PLANT_ID
							 , E.SCM_SITE_ID
							 , E.MODEL_ID
							 , A.ITEM_ID
							 , SUM(CEILING(A.TOT_QTY)) AS TOT_BOH_QTY
							 , 0    AS JR_BOH_QTY  
							 , 0    AS PC_BOH_QTY 
							 , SUM(CEILING(A.TOT_QTY  * ISNULL(E.CONVERT_TO_PCM, 1)))   AS TOT_BOH_QTY_TO_PCM 
							 , 0    AS JR_BOH_QTY_TO_PCM 
							 , 0    AS PC_BOH_QTY_TO_PCM 
							 , SUM(CEILING(A.TOT_QTY  * ISNULL(E.CONVERT_TO_CELL, 1)))  AS TOT_BOH_QTY_TO_CELL 
							 , 0    AS JR_BOH_QTY_TO_CELL 
							 , 0    AS PC_BOH_QTY_TO_CELL 			
							 , ISNULL(E.ELECTRODE_POST_OPER_LT, 1) AS OP_LT
							 , 'P'  AS MEASURE_TYPE
						FROM   SSP_ANL_STOCK_EE_C A WITH(NOLOCK)
							   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							   ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 전극-> 조립 
							   AND L.VALID_YN    = 'Y'
							   AND L.SEGMENT3    = A.DIVISION_ID  -- 전극 DIVISION 
							   --AND L.SEGMENT4    = A.PLANT_ID     -- 전극 PLANT_ID 
							   AND L.ATTRIBUTE2  = A.FROM_SITE  -- 전극 SCM_SITE_ID  
							   JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							   ON  E.DIVISION_ID = A.DIVISION_ID 
							   AND E.PLANT_ID    = L.SEGMENT4  --A.PLANT_ID
							   AND E.ITEM_ID     = A.ITEM_ID
						WHERE  1 = 1
						AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    A.AVAILABLE_YN <> 'N'
						AND    A.TYPE = 'E'
						AND    A.COMPANY_ID		= @c_company_id
						AND    EXISTS (
										SELECT 1
										FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
										WHERE  1 = 1
										AND    B.LOOKUP_TYPE = 'ELECTRODE_SHIP_STORAGE'
										AND    B.VALID_YN    = 'Y'
										AND    B.SEGMENT4    = 'P' -- 'R' 인 경우 REQUEST 에 사용
										AND    B.SEGMENT1    = A.PLANT_ID -- 'R' 인 경우 @TO_PLANT
										AND    B.SEGMENT2    = A.FROM_SITE  -- 'R' 인 경우 @TO_SITE
										AND    B.SEGMENT3    = A.STORAGE_ID  -- 'R' 인 경우 @TO_SITE
									  )
						GROUP BY A.COMPANY_ID
							 , A.DIVISION_ID
							 , L.SEGMENT4  --A.PLANT_ID
							 , E.SCM_SITE_ID
							 , E.MODEL_ID
							 , A.ITEM_ID
							 , E.CONVERT_TO_PCM
							 , E.CONVERT_TO_CELL
							 , ISNULL(E.ELECTRODE_POST_OPER_LT, 1)

						UNION ALL

						SELECT S.COMPANY_ID
							 , S.DIVISION_ID
							 , S.PLANT_ID
							 , S.SCM_SITE_ID
							 , E.MODEL_ID
							 , A.ITEM_ID
							 , SUM(CEILING(A.TOT_QTY)) AS TOT_BOH_QTY
							 , 0    AS JR_BOH_QTY  
							 , 0    AS PC_BOH_QTY 
							 , SUM(CEILING(A.TOT_QTY  * ISNULL(E.CONVERT_TO_PCM, 1)))   AS TOT_BOH_QTY_TO_PCM 
							 , 0    AS JR_BOH_QTY_TO_PCM 
							 , 0    AS PC_BOH_QTY_TO_PCM 
							 , SUM(CEILING(A.TOT_QTY  * ISNULL(E.CONVERT_TO_CELL, 1)))  AS TOT_BOH_QTY_TO_CELL 
							 , 0    AS JR_BOH_QTY_TO_CELL 
							 , 0    AS PC_BOH_QTY_TO_CELL 			
							 , ISNULL(E.ELECTRODE_POST_OPER_LT, 1) AS OP_LT
							 , 'R'  AS MEASURE_TYPE
						FROM   SSP_ANL_STOCK_EE_C A WITH(NOLOCK)
							   JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							   ON  E.DIVISION_ID = A.DIVISION_ID 
							   AND E.PLANT_ID    = A.PLANT_ID 
							   AND E.ITEM_ID     = A.ITEM_ID
							   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
							   ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' -- 전극-> 조립 
							   AND L.VALID_YN    = 'Y'
							   AND L.SEGMENT3    = A.DIVISION_ID  -- 전극 DIVISION 
							   AND L.SEGMENT4    = A.PLANT_ID     -- 전극 PLANT_ID 
							   AND L.ATTRIBUTE2  = A.FROM_SITE  -- 전극 SCM_SITE_ID  

							   JOIN SCM_MST_SITE S WITH(NOLOCK) 
							   ON S.DIVISION_ID = L.SEGMENT1   -- 조립 DIVISION 
							   AND S.PLANT_ID    = L.SEGMENT2   -- 조립 PLANT_ID 
							   AND S.SCM_SITE_ID = L.ATTRIBUTE1 -- 조립 SCM_SITE_ID  
						WHERE  1 = 1
						AND    A.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
						AND    A.AVAILABLE_YN <> 'N'
						AND    A.TYPE = 'A'
						AND    A.COMPANY_ID		= @c_company_id
						AND    EXISTS (
										SELECT 1
										FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
										WHERE  1 = 1
										AND    B.LOOKUP_TYPE = 'ELECTRODE_SHIP_STORAGE'
										AND    B.VALID_YN    = 'Y'
										AND    B.SEGMENT4    = 'R' -- 'R' 인 경우 REQUEST 에 사용
										AND    B.SEGMENT1    = S.PLANT_ID
										AND    B.SEGMENT2    = S.SCM_SITE_ID 
										AND    B.SEGMENT3    = A.STORAGE_ID
									  )
						GROUP BY S.COMPANY_ID
							 , S.DIVISION_ID
							 , S.PLANT_ID
							 , S.SCM_SITE_ID
							 , E.MODEL_ID
							 , A.ITEM_ID
							 , E.CONVERT_TO_PCM
							 , E.CONVERT_TO_CELL
							 , ISNULL(E.ELECTRODE_POST_OPER_LT, 1)
					   )  T
				;

				DELETE 
				FROM SSP_ANL_BOH_CUTOFF_EE
				WHERE CUTOFF_DATE =  @v_plan_start_yyyymmdd
				AND   COMPANY_ID = @c_company_id
				;

				INSERT INTO SSP_ANL_BOH_CUTOFF_EE(
				 CUTOFF_DATE
				,COMPANY_ID
				,DIVISION_ID
				,PLANT_ID
				,SCM_SITE_ID 
				,MODEL_ID
				,ITEM_ID
				,MEASURE_TYPE
				,TOT_BOH_QTY
				,JR_BOH_QTY
				,PC_BOH_QTY
				,TOT_BOH_QTY_TO_PCM
				,JR_BOH_QTY_TO_PCM
				,PC_BOH_QTY_TO_PCM
				,TOT_BOH_QTY_TO_CELL
				,JR_BOH_QTY_TO_CELL
				,PC_BOH_QTY_TO_CELL
				,OP_LT
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
				SELECT @v_plan_start_yyyymmdd       AS CUTOFF_DATE 
				,      T.COMPANY_ID
				,      T.DIVISION_ID
				,      T.PLANT_ID 
				,      T.SCM_SITE_ID
				,      T.MODEL_ID                
				,      T.ITEM_ID 
				,      T.MEASURE_TYPE
				,      T.TOT_BOH_QTY   AS TOT_BOH_QTY
				,      T.JR_BOH_QTY   AS JR_BOH_QTY 
				,      T.PC_BOH_QTY    AS PC_BOH_QTY
			 
				,      T.TOT_BOH_QTY_TO_PCM 
				,      T.JR_BOH_QTY_TO_PCM 
				,      T.PC_BOH_QTY_TO_PCM 

				,      T.TOT_BOH_QTY_TO_CELL 
				,      T.JR_BOH_QTY_TO_CELL 
				,      T.PC_BOH_QTY_TO_CELL 

				,      T.OP_LT
				,      @v_batch_user
				,      GETDATE()
				,      @v_batch_user
				,      GETDATE()
				FROM #TMP_FP_BOH T WITH(NOLOCK) 	
				WHERE T.COMPANY_ID = @c_company_id
				;


				/*------------------------------------------------------------------------------------------------------------- 
				1-2.#TMP_FP_PLAN
					FP PANCAKE SIMULATION PLAN ([LGCE_FP_TR].[DBO].[IF_SSP_FP_PANCAKE_SIMUL_PLAN_V] ) 
				--------------------------------------------------------------------------------------------------------------*/ 
				IF OBJECT_ID('tempdb..#TMP_FP_PLAN_RAW') IS NOT NULL
				DROP TABLE #TMP_FP_PLAN_RAW

				SELECT P.COMPANY_ID						    AS COMPANY_ID
				,      P.DIVISION_ID						AS DIVISION_ID
				,      P.PLANT_ID							AS PLANT_ID
				,      P.ITEM_ID							AS ITEM_ID
				,      P.ASSY_PLANT_ID                      AS ASSY_PLANT_ID
				,      CONVERT(CHAR(8), P.PLAN_DATE, 112)   AS YYYYMMDD 
				,      ROUND(SUM(P.ASSY_PC_REQ_QTY),10)		AS NPC_PLAN_QTY -- ASSY 필요수량
				,      ROUND(SUM(P.PLAN_QTY), 10)			AS COATER_PLAN_QTY
				,      ROUND(SUM(P.POST_PLAN_QTY), 10)		AS P_COATER_PLAN_QTY
				INTO   #TMP_FP_PLAN_RAW
				FROM   SSP_DNM_FP_PANCAKE_SIMUL_PLAN_V_SN P WITH(NOLOCK) 
				WHERE  1=1
				AND    P.PLAN_DATE >= @v_result_plan_start_yyyymmdd 
				AND    P.PLAN_DATE <  @v_plan_end_yyyymmdd   
				GROUP BY P.COMPANY_ID 
				,      P.DIVISION_ID 
				,      P.PLANT_ID 
				,      P.ITEM_ID 
				,      P.ASSY_PLANT_ID
				,      P.PLAN_DATE
				;



				IF OBJECT_ID('tempdb..#TMP_FP_PLAN') IS NOT NULL
				DROP TABLE #TMP_FP_PLAN


				CREATE TABLE #TMP_FP_PLAN (
				 COMPANY_ID           NVARCHAR(030)  
				,DIVISION_ID          NVARCHAR(030)  
				,PLANT_ID             NVARCHAR(030)  
				,SCM_SITE_ID          NVARCHAR(030) 
				,MODEL_ID             NVARCHAR(050)  
				,ITEM_ID              NVARCHAR(050)  
				,YYYYMMDD             NVARCHAR(008)
				,NPC_PLAN_QTY         NUMERIC(20,10) 
				,COATER_PLAN_QTY      NUMERIC(20,10) 
				,P_COATER_PLAN_QTY    NUMERIC(20,10) 
				,MEASURE_TYPE         NVARCHAR(001) -- R (Request) :조립기준, P(plan) : 전극기준 
				);

				-- 조립 SITE 기준 
				INSERT INTO #TMP_FP_PLAN(
					 COMPANY_ID 
					,DIVISION_ID 
					,PLANT_ID  
					,SCM_SITE_ID 
					,MODEL_ID 
					,ITEM_ID   
					,YYYYMMDD   
					,NPC_PLAN_QTY 
					,COATER_PLAN_QTY 
					,P_COATER_PLAN_QTY 
					,MEASURE_TYPE 
				)
				SELECT SA.COMPANY_ID
				,      SA.DIVISION_ID 
				,      SA.PLANT_ID
				,      SA.SCM_SITE_ID 
				,      E.MODEL_ID
				,      X.ITEM_ID
				,      X.YYYYMMDD
				,      ROUND(X.NPC_PLAN_QTY,10)   AS  NPC_PLAN_QTY
				,      ROUND(X.COATER_PLAN_QTY,10) AS COATER_PLAN_QTY
				,      ROUND(X.P_COATER_PLAN_QTY,10) AS P_COATER_PLAN_QTY
				,      'R'
				FROM #TMP_FP_PLAN_RAW X WITH(NOLOCK) 

				   JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
					 ON E.DIVISION_ID = X.DIVISION_ID 
					AND E.PLANT_ID    = X.PLANT_ID
					AND E.ITEM_ID     = X.ITEM_ID
                  
				   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
					 ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
					AND L.VALID_YN    = 'Y'
					AND L.SEGMENT3    = X.DIVISION_ID  -- 전극 DIVISION 
					AND L.SEGMENT4    = X.PLANT_ID     -- 전극 PLANT_ID 
				   
				  JOIN SCM_MST_SITE SA WITH(NOLOCK) 
					ON SA.PLANT_ID = ISNULL(X.ASSY_PLANT_ID, L.SEGMENT2 ) -- ASSY_PLANT_ID가 없을 경우 전극의 조립 PLANT 
					AND SA.OPERATION_GROUP = 'A'
				WHERE SA.COMPANY_ID = @c_company_id
				;	         


				-- 전극 SITE 기준 
				-- 전극 SITE <-> 조립 SITE 가 MAPPING 후 조립 SITE =  FP의 ASSY_PLANT_ID 가 NULL 과 전극<-->조립 Mapping되는 조립 PLANT와 동일한 것 
				INSERT INTO #TMP_FP_PLAN(
					 COMPANY_ID 
					,DIVISION_ID 
					,PLANT_ID  
					,SCM_SITE_ID 
					,MODEL_ID 
					,ITEM_ID   
					,YYYYMMDD   
					,NPC_PLAN_QTY 
					,COATER_PLAN_QTY 
					,P_COATER_PLAN_QTY 
					,MEASURE_TYPE  
					)
				SELECT X.COMPANY_ID
				,      X.DIVISION_ID 
				,      X.PLANT_ID
				,      E.SCM_SITE_ID 
				,      E.MODEL_ID
				,      X.ITEM_ID
				,      X.YYYYMMDD
				,      ROUND(X.NPC_PLAN_QTY,10) AS NPC_PLAN_QTY
				,      ROUND(X.COATER_PLAN_QTY,10) AS COATER_PLAN_QTY
				,      ROUND(X.P_COATER_PLAN_QTY,10) AS P_COATER_PLAN_QTY
				,      'P'
				FROM  #TMP_FP_PLAN_RAW X WITH(NOLOCK) 
				   JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
					 ON E.DIVISION_ID = X.DIVISION_ID 
					AND E.PLANT_ID    = X.PLANT_ID
					AND E.ITEM_ID     = X.ITEM_ID

				   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
					 ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
					AND L.VALID_YN    = 'Y'
					AND L.SEGMENT3    = X.DIVISION_ID  -- 전극 DIVISION 
					AND L.SEGMENT4    = X.PLANT_ID     -- 전극 PLANT_ID 
				WHERE X.COMPANY_ID = @c_company_id
				AND L.SEGMENT2  = ISNULL(X.ASSY_PLANT_ID, L.SEGMENT2 ) 
           
			   ;

			  

				/*------------------------------------------------------------------------------------------------------------- 
				1-3.#TMP_SCP_PROD_PLAN 
					SCP_ANL_PRODUCTION_PLAN ,FN PLAN
				--------------------------------------------------------------------------------------------------------------*/ 
				IF OBJECT_ID('tempdb..#TMP_SCP_PROD_PLAN') IS NOT NULL
				DROP TABLE #TMP_SCP_PROD_PLAN 

				CREATE TABLE #TMP_SCP_PROD_PLAN (
				 COMPANY_ID           NVARCHAR(030)  
				,DIVISION_ID          NVARCHAR(030)  
				,PLANT_ID             NVARCHAR(030)  
				,SCM_SITE_ID          NVARCHAR(030) 
				,MODEL_ID             NVARCHAR(050)  
				,ITEM_ID              NVARCHAR(050)  
				,YYYYMMDD             NVARCHAR(050)  
				,QTY                  NUMERIC(20,10)
				,MEASURE_TYPE         NVARCHAR(001) -- R (Request) :조립기준, P(plan) : 전극기준 
				);

			   -- SCP EE FINAL PLAN INFO
				DECLARE @v_scp_plan_start_yyyymmdd    NVARCHAR(8)  = '';
				DECLARE @v_scp_plan_type              NVARCHAR(30) = 'FN'; 
				DECLARE @v_scp_seq                    INTEGER = 0;    


				SELECT TOP 1 
					   @v_scp_plan_start_yyyymmdd = A.PLAN_START_YYYYMMDD 
				,      @v_scp_plan_type           = A.PLAN_TYPE 
				,      @v_scp_seq                 = A.PLAN_SEQ   
				FROM   SCP_PLAN_VERSION_V A WITH(NOLOCK) 
				WHERE  1=1 
/*
				AND    A.DIVISION_ID = CASE WHEN @c_company_id = 'G670' THEN 'EE_UC' 
				                            WHEN @c_company_id = 'G740' THEN 'EE_HM' 
											WHEN @c_company_id = 'G820' THEN 'EE_ST'
									        ELSE 'EE' END
*/
				AND    A.DIVISION_ID = CASE WHEN @c_company_id = @v_G670 THEN 'EE_UC' 
				                            WHEN @c_company_id = @v_G740 THEN 'EE_HM' 
											WHEN @c_company_id = @v_G820 THEN 'EE_ST'
											WHEN @c_company_id = @v_G870 THEN 'EE_HD'
											WHEN @c_company_id = @v_G880 THEN 'EE_HG'--G880 (2025-07-22)
									        ELSE 'EE' END

				AND    A.PLAN_CYCLE  = 'WEEKLY'
				AND    A.PLAN_TYPE   = 'FN'
				ORDER BY PLAN_START_YYYYMMDD DESC , PLAN_TYPE_ORDER DESC , PLAN_SEQ DESC 
				; 

				-- 전극 SITE 기준
				INSERT INTO #TMP_SCP_PROD_PLAN(
				 COMPANY_ID  
				,DIVISION_ID
				,PLANT_ID  
				,SCM_SITE_ID  
				,MODEL_ID  
				,ITEM_ID  
				,YYYYMMDD  
				,QTY       
				,MEASURE_TYPE -- R (Request) :조립기준, P(plan) : 전극기준 			
				)
				SELECT E.COMPANY_ID						    AS COMPANY_ID
				,      E.DIVISION_ID						AS DIVISION_ID
				,      E.PLANT_ID							AS PLANT_ID 
				,      E.SCM_SITE_ID                        AS SCM_SITE_ID
				,      E.MODEL_ID                           AS MODEL_ID 
				,      P.ITEM_ID							AS ITEM_ID
				,      P.YYYYMMDD                           AS YYYYMMDD 
				,      ROUND(SUM(P.QTY),10)                           AS QTY 
				,      'P'                                  AS MEASURE_TYPE
				FROM SCP_ANL_PRODUCTION_PLAN P WITH(NOLOCK) 

				  JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
					ON E.DIVISION_ID = P.ORIGIN_DIVISION_ID 
				   AND E.SCM_SITE_ID = P.SCM_SITE_ID
				   AND E.ITEM_ID     = P.ITEM_ID

				WHERE 1=1
/*
				AND   P.DIVISION_ID         = CASE WHEN @c_company_id = 'G670' THEN 'EE_UC'
				                                   WHEN @c_company_id = 'G740' THEN 'EE_HM'
												   WHEN @c_company_id = 'G820' THEN 'EE_ST'
												   ELSE 'EE' END
*/
				AND   P.DIVISION_ID         = CASE WHEN @c_company_id = @v_G670 THEN 'EE_UC'
				                                   WHEN @c_company_id = @v_G740 THEN 'EE_HM'
												   WHEN @c_company_id = @v_G820 THEN 'EE_ST'
												   WHEN @c_company_id = @v_G870 THEN 'EE_HD'
												   WHEN @c_company_id = @v_G880 THEN 'EE_HG'--G880 (2025-07-22)
												   ELSE 'EE' END
				AND   P.PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd
				AND   P.PLAN_TYPE           = @v_scp_plan_type   
				AND   P.SEQ                 = @v_scp_seq
				AND   P.OPERATION_GROUP     = 'E'
				AND   P.MEASURE             = 'PROD_PLAN_AMEND'
				AND   P.YYYYMMDD           >= @v_result_plan_start_yyyymmdd 
				AND   P.YYYYMMDD            < @v_plan_end_yyyymmdd
				AND   P.QTY                 > 0 
				AND   E.COMPANY_ID  = @c_company_id
				GROUP BY E.COMPANY_ID		
				,      E.DIVISION_ID	
				,      E.PLANT_ID
				,      E.SCM_SITE_ID
				,      E.MODEL_ID   
				,      P.ITEM_ID
				,      P.YYYYMMDD	
				;

				-- 조립 SITE 기준
				INSERT INTO #TMP_SCP_PROD_PLAN(
				 COMPANY_ID  
				,DIVISION_ID
				,PLANT_ID  
				,SCM_SITE_ID  
				,MODEL_ID  
				,ITEM_ID  
				,YYYYMMDD  
				,QTY       
				,MEASURE_TYPE -- R (Request) :조립기준, P(plan) : 전극기준 			
				)
				SELECT S.COMPANY_ID  
				,      S.DIVISION_ID
				,      S.PLANT_ID
				,      S.SCM_SITE_ID
				,      T.MODEL_ID
				,      T.ITEM_ID
				,      T.YYYYMMDD
				,      T.QTY
				,      'R'  
				FROM #TMP_SCP_PROD_PLAN T WITH(NOLOCK) 
				   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
					 ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
					AND L.VALID_YN    = 'Y'
					AND L.SEGMENT3    = T.DIVISION_ID  -- 전극 DIVISION 
					AND L.SEGMENT4    = T.PLANT_ID     -- 전극 PLANT_ID 
					AND L.ATTRIBUTE2  = T.SCM_SITE_ID  -- 전극 SCM_SITE_ID  

					JOIN SCM_MST_SITE S WITH(NOLOCK) 
					 ON S.DIVISION_ID = L.SEGMENT1   -- 조립 DIVISION 
					AND S.PLANT_ID    = L.SEGMENT2   -- 조립 PLANT_ID 
					AND S.SCM_SITE_ID = L.ATTRIBUTE1 -- 조립 SCM_SITE_ID  
				;



				/*------------------------------------------------------------------------------------------------------------- 
				1-4. #TMP_SCP_SHIP_PLAN
					 SCP_ANL_SHIPMENT_PLAN_SEMI FN Plan
					 출하요청을 Default 생성을 위한 SCP 출하타겟 데이터 추출 (FN 기준) 
				--------------------------------------------------------------------------------------------------------------*/ 
				IF OBJECT_ID('tempdb..#TMP_SCP_SHIP_PLAN') IS NOT NULL
				DROP TABLE #TMP_SCP_SHIP_PLAN

				SELECT FROM_COMPANY_ID 
					 , FROM_DIVISION_ID          
					 , FROM_PLANT_ID          
					 , FROM_SITE         
					 , FROM_SITE_OPERATION_GROUP          
					 , TO_COMPANY_ID          
					 , TO_DIVISION_ID          
					 , TO_PLANT_ID          
					 , TO_SITE          
					 , TO_SITE_OPERATION_GROUP          
					 , MODEL_ID          
					 , ITEM_ID         
					 , QTY        
					 , BOD_ID          
					 , ETD_DATE
					 , ETA_DATE
				INTO  #TMP_SCP_SHIP_PLAN     
				FROM   (
						SELECT FS.COMPANY_ID                        AS FROM_COMPANY_ID 
						,      FS.DIVISION_ID                       AS FROM_DIVISION_ID 
						,      FS.PLANT_ID                          AS FROM_PLANT_ID
						,      FS.SCM_SITE_ID                       AS FROM_SITE
						,      MAX(FS.OPERATION_GROUP)              AS FROM_SITE_OPERATION_GROUP
						,      TS.COMPANY_ID                        AS TO_COMPANY_ID 
						,      TS.DIVISION_ID                       AS TO_DIVISION_ID 
						,      TS.PLANT_ID                          AS TO_PLANT_ID
						,      TS.SCM_SITE_ID                       AS TO_SITE
						,      MAX(TS.OPERATION_GROUP)              AS TO_SITE_OPERATION_GROUP
						,      V.MODEL_ID                           AS MODEL_ID 
						,      P.ITEM_ID							AS ITEM_ID
						,      ROUND(SUM(P.QTY),0)                  AS QTY 
						,      P.BOD_ID								AS BOD_ID
						,      P.YYYYMMDD                           AS ETD_DATE
						,      [DBO].[FN_GET_SSP_ETA_DATE](FS.DIVISION_ID, P.BOD_ID, P.YYYYMMDD ) AS ETA_DATE  
						FROM  SCP_ANL_SHIPMENT_PLAN_SEMI P WITH(NOLOCK)  -- SCP_ANL_SHIPMENT_PLAN_SEMI P WITH(NOLOCK) 
							JOIN SCM_MST_SITE FS WITH(NOLOCK) -- FROM_SITE 기준 
								ON FS.DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID  
								AND FS.SCM_SITE_ID = P.FROM_SITE  
							JOIN SCM_MST_SITE TS WITH(NOLOCK) -- TO_SITE 기준 
								ON TS.DIVISION_ID = P.ORIGIN_TO_DIVISION_ID  
								AND TS.SCM_SITE_ID = P.TO_SITE  
							JOIN SSP_MST_SITE_ITEM_EE_V V WITH(NOLOCK) 
								ON V.DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID
								AND V.SCM_SITE_ID = P.FROM_SITE 
			 					AND V.ITEM_ID     = P.ITEM_ID 	
						WHERE 1=1 
/*
						AND   P.DIVISION_ID         = CASE WHEN @c_company_id = 'G670' THEN 'EE_UC' 
						                                   WHEN @c_company_id = 'G740' THEN 'EE_HM'
														   WHEN @c_company_id = 'G820' THEN 'EE_ST'
														   ELSE 'EE' END
*/
						AND   P.DIVISION_ID         = CASE WHEN @c_company_id = @v_G670 THEN 'EE_UC'
														   WHEN @c_company_id = @v_G740 THEN 'EE_HM'
														   WHEN @c_company_id = @v_G820 THEN 'EE_ST'
														   WHEN @c_company_id = @v_G870 THEN 'EE_HD'
														   WHEN @c_company_id = @v_G880 THEN 'EE_HG'--G880 (2025-07-22)
														   ELSE 'EE' END
						AND   P.PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd
						AND   P.PLAN_TYPE           = @v_scp_plan_type   
						AND   P.SEQ                 = @v_scp_seq
						AND   P.MEASURE             = 'SHIP_PLAN_AMEND'
						AND   P.QTY                 > 0 
						AND   P.YYYYMMDD  >= @v_result_plan_start_yyyymmdd -- @v_scp_plan_start_yyyymmdd
						-- SCP 주단위 생성이여서 생성시점 보다 7일 더 추출 
						AND   P.YYYYMMDD  <  CONVERT(VARCHAR, DATEADD(D, 7, CONVERT(DATETIME, @v_plan_end_yyyymmdd ,112)) ,112)  -- @v_plan_end_yyyymmdd 
						--AND   FS.COMPANY_ID  IN (  SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_company_id,',') )
						GROUP BY  
							   FS.COMPANY_ID
						,      FS.DIVISION_ID
						,      FS.PLANT_ID
						,      FS.SCM_SITE_ID 
						,      TS.COMPANY_ID                      
						,      TS.DIVISION_ID
						,      TS.PLANT_ID
						,      TS.SCM_SITE_ID
						,      V.MODEL_ID                      
						,      P.ITEM_ID							
						,      P.BOD_ID								
						,      P.YYYYMMDD 

						-- SCP FG 반영
						UNION ALL

						SELECT FROM_COMPANY_ID 
							  ,FROM_DIVISION_ID          
							  ,FROM_PLANT_ID          
							  ,FROM_SITE         
							  ,FROM_SITE_OPERATION_GROUP          
							  ,TO_COMPANY_ID          
							  ,TO_DIVISION_ID          
							  ,TO_PLANT_ID          
							  ,TO_SITE          
							  ,TO_SITE_OPERATION_GROUP          
							  ,MODEL_ID          
							  ,ITEM_ID         
							  ,ROUND(SUM(QTY), 0)   AS QTY        
							  ,BOD_ID          
							  ,ETD_DATE
							  ,ETA_DATE        
						  FROM (                        
							  SELECT F.COMPANY_ID                        AS FROM_COMPANY_ID
									,F.DIVISION_ID                       AS FROM_DIVISION_ID                  
									,F.PLANT_ID                          AS FROM_PLANT_ID
									,F.SCM_SITE_ID                       AS FROM_SITE
									,F.OPERATION_GROUP                   AS FROM_SITE_OPERATION_GROUP
									,CASE WHEN ISNULL(T.COMPANY_ID, '-') = '' THEN '-' ELSE ISNULL(T.COMPANY_ID, '-') END          AS TO_COMPANY_ID
									,T.DIVISION_ID                       AS TO_DIVISION_ID                  
									,ISNULL(T.PLANT_ID, '-')             AS TO_PLANT_ID
									,T.SCM_SITE_ID                       AS TO_SITE
									,ISNULL(T.OPERATION_GROUP, '-')      AS TO_SITE_OPERATION_GROUP
									,V.MODEL_ID                          AS MODEL_ID 
									,A.ITEM_ID							 AS ITEM_ID
									,A.ALLOCATION_QTY                    AS QTY
									,B.BOD_ID                            AS BOD_ID
									,B.YYYYMMDD                          AS ETD_DATE
									,[dbo].[FN_GET_SSP_ETA_DATE](F.DIVISION_ID, B.BOD_ID, B.YYYYMMDD ) AS ETA_DATE
								FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A WITH (NOLOCK)                         
									 LEFT OUTER JOIN  SCP_PLN_SHIPMENT_PLAN B WITH (NOLOCK)                   
								  ON 1 = 1                
								 AND A.DIVISION_ID           = B.DIVISION_ID                        
								 AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD                
								 AND A.PLAN_TYPE             = B.PLAN_TYPE                          
								 AND A.SEQ                   = B.SEQ                               
								 AND A.ORDER_ID              = B.ORDER_ID                 
								 AND B.MEASURE               = 'SHIP_PLAN'                
								 AND B.SEMI_YN               = 'N'                      
								 AND B.OPERATION_GROUP       = 'E'
									 LEFT OUTER JOIN [dbo].[SCP_MST_BOD_N_V]  C WITH(NOLOCK)
								  ON C.DIVISION_ID  = B.ORIGIN_FROM_DIVISION_ID                        
								 AND C.BOD_ID       = B.BOD_ID
									 JOIN SCM_MST_SITE F WITH(NOLOCK) -- FROM_SITE 기준 
								  ON F.SCM_SITE_ID = B.FROM_SITE  
								 AND F.DIVISION_ID = B.ORIGIN_FROM_DIVISION_ID
									 JOIN SCM_MST_SITE T  WITH(NOLOCK) -- TO_SITE 기준 
								  ON T.SCM_SITE_ID = B.TO_SITE  
								 AND T.DIVISION_ID = B.ORIGIN_TO_DIVISION_ID
									 JOIN [dbo].[SSP_MST_SITE_ITEM_EE_V] V WITH(NOLOCK) 
								  ON V.DIVISION_ID = F.DIVISION_ID
								 AND V.SCM_SITE_ID = F.SCM_SITE_ID 
			 					 AND V.ITEM_ID     = A.ITEM_ID 	
							   WHERE 1 = 1   
/*
								 AND A.DIVISION_ID			= CASE WHEN @c_company_id = 'G670' THEN 'EE_UC' 
								                                   WHEN @c_company_id = 'G740' THEN 'EE_HM'
																   WHEN @c_company_id = 'G820' THEN 'EE_ST'
																   ELSE 'EE' END
*/
								 AND A.DIVISION_ID         = CASE WHEN @c_company_id = @v_G670 THEN 'EE_UC'
																   WHEN @c_company_id = @v_G740 THEN 'EE_HM'
																   WHEN @c_company_id = @v_G820 THEN 'EE_ST'
																   WHEN @c_company_id = @v_G870 THEN 'EE_HD'
																   WHEN @c_company_id = @v_G880 THEN 'EE_HG'--G880 (2025-07-22)
																   ELSE 'EE' END
								 AND A.PLAN_START_YYYYMMDD	= @v_scp_plan_start_yyyymmdd                          
								 AND A.PLAN_TYPE			= @v_scp_plan_type                        
								 AND A.SEQ					= @v_scp_seq   
								 AND A.ALLOCATION_QTY		> 0                         
								 AND B.DIVISION_ID			IS NOT NULL           
								 AND B.YYYYMMDD  >= @v_result_plan_start_yyyymmdd -- @v_scp_plan_start_yyyymmdd
								 AND B.YYYYMMDD  <  CONVERT(VARCHAR, DATEADD(D, 7, CONVERT(DATETIME, @v_plan_end_yyyymmdd ,112)) ,112)  -- @v_plan_end_yyyymmdd 
								 --AND F.COMPANY_ID  IN (  SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(@v_company_id,',') )
						) X                        
						GROUP BY FROM_COMPANY_ID 
							 , FROM_DIVISION_ID          
							 , FROM_PLANT_ID          
							 , FROM_SITE         
							 , FROM_SITE_OPERATION_GROUP          
							 , TO_COMPANY_ID          
							 , TO_DIVISION_ID          
							 , TO_PLANT_ID          
							 , TO_SITE          
							 , TO_SITE_OPERATION_GROUP          
							 , MODEL_ID          
							 , ITEM_ID         
							 , BOD_ID          
							 , ETD_DATE
							 , ETA_DATE
					   ) A
				WHERE  1 = 1
				;

				/*------------------------------------------------------------------------------------------------------------- 
				1-4-1. 출하대상 (LOOKUP) 확인 및 자동 등록 ELECTRODE_SHIP_FROM_TO 
				-- #TMP_SCP_SHIP_PLAN FROM_SITE , TO_SITE 와 LOOKUP 등록된 FROM_SITE , TO_SITE 비교하여 LOOKUP에 없으면 LOOKUP자동 등록 
				-- 등록대상  전극SITE ->  셀SITE 이면서 FROM_SITE 와 TO_SITE의 COMPANY가 다른것 
				--------------------------------------------------------------------------------------------------------------*/ 

				-- 전극출하대상에 없는 SCP 출하계획이 있는 경우 전극출하대상 LOOKUP에 자동 신규 추가 함 
				-- 단, SALES_COMPANY_ID(3자거래 대상)는 PI담당자가 추가 입력해야 해서 제외 함(시스템판단로직 불가)    
				-- VALID_YN N으로 설정된값은 추가 대상이 아님(VALID_YN 관계없이 비교하여 없으면 신규생성함) 
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(
					LOOKUP_TYPE
					,SEGMENT1     -- FROM_COMPANY_ID   
					,SEGMENT2     -- FROM_DIVISION_ID
					,SEGMENT3     -- FROM_SITE
					,SEGMENT4     -- TO_COMPANY_ID
					,SEGMENT5     -- TO_DIVISION_ID
					,ATTRIBUTE1   -- TO_SITE
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
				SELECT DISTINCT
					  'ELECTRODE_SHIP_FROM_TO'
				,      FROM_COMPANY_ID 
				,      FROM_DIVISION_ID
				,      FROM_SITE
				,      TO_COMPANY_ID 
				,      TO_DIVISION_ID
				,      TO_SITE
				,      10    -- DISPLAY_SEQ
				,      'Y'  -- VALID_YN
				,      'System Auto Create'   -- DESCRIPTION
				,      'ssp_batch'      --CREATED_BY   @v_batch_user
				,      GETDATE()        -- CREATION_DATE
				,      'ssp_batch'      --LAST_UPDATED_BY  @v_batch_user
				,      GETDATE()        -- LAST_UPDATE_DATE
				FROM   #TMP_SCP_SHIP_PLAN  T WITH(NOLOCK) 
				WHERE  FROM_SITE_OPERATION_GROUP = 'E'
				AND    TO_SITE_OPERATION_GROUP   IN ('A', '-')
				AND    FROM_COMPANY_ID <> TO_COMPANY_ID
				--     전극 출하대상 LOOKUP에 등록되지 않은 FROM,TO SITE 
				AND    NOT EXISTS ( SELECT *   -- 전극출하대상
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
									WHERE 1=1 
									AND L.LOOKUP_TYPE =  'ELECTRODE_SHIP_FROM_TO' 
									AND L.SEGMENT1    =  T.FROM_COMPANY_ID   
									AND L.SEGMENT2    =  T.FROM_DIVISION_ID    
									AND L.SEGMENT3    =  T.FROM_SITE    
									AND L.SEGMENT4    =  T.TO_COMPANY_ID   
									AND L.SEGMENT5    =  T.TO_DIVISION_ID   
									--AND L.ATTRIBUTE1  =  T.TO_SITE 
									) 
				;

				-- 전극 출하대상이 아닌 대상은 삭제 
				-- 전극 출하대상 LOOKUP에 등록되지 않은 대상 제외 
				DELETE #TMP_SCP_SHIP_PLAN
				  FROM #TMP_SCP_SHIP_PLAN  T
				 WHERE NOT EXISTS (SELECT 1
									 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
									WHERE  L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
									  AND L.VALID_YN    = 'Y' 
									  AND L.SEGMENT1    =  T.FROM_COMPANY_ID    
									  AND L.SEGMENT2    =  T.FROM_DIVISION_ID
									  AND L.SEGMENT3    =  T.FROM_SITE 
									  AND L.SEGMENT4    =  T.TO_COMPANY_ID 
									  AND L.SEGMENT5    =  T.TO_DIVISION_ID  
									  AND L.ATTRIBUTE1  =  T.TO_SITE    
								  )
				;

				/*------------------------------------------------------------------------------------------------------------- 
				[ADD_20200721] 
				--출하요청 자동 생성 LOOKUP 확인 및 자동 등록 ELECTRODE_SHIP_REQ_AUTO_CREATE 
				-- 1-5에서 SCP 출하게획을 출하요청 자동 생성 여부로 사용 (신규 대상 발생시 LOOKUP 추가 등록(추가등록시 Y로 설정) 
				-- #TMP_SCP_SHIP_PLAN TO_DIVISION , TO_SITE 와 LOOKUP 등록된 , TO_DIVISION TO_SITE 비교하여 LOOKUP에 없으면 LOOKUP자동 등록 
				-- 등록대상  전극SITE ->  셀SITE 이면서 FROM_SITE 와 TO_SITE의 COMPANY가 다른것 
				--------------------------------------------------------------------------------------------------------------*/ 
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
					(
					LOOKUP_TYPE
					,SEGMENT1     -- TO_DIVISION_ID   
					,SEGMENT2     -- TO_SITE
					,SEGMENT3      
					,SEGMENT4      
					,SEGMENT5      
					,ATTRIBUTE1    
					,DISPLAY_SEQ
					,VALID_YN
					,DESCRIPTION
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
				SELECT DISTINCT
					  'ELECTRODE_SHIP_REQ_AUTO_CREATE'
				,      TO_DIVISION_ID 
				,      TO_SITE
				,      '-'
				,      '-' 
				,      '-'
				,      '-'
				,      0    -- DISPLAY_SEQ
				,      'Y'  -- VALID_YN
				,      'System Auto Create'   -- DESCRIPTION
				,      'ssp_batch'      --CREATED_BY   @v_batch_user
				,      GETDATE()        -- CREATION_DATE
				,      'ssp_batch'      --LAST_UPDATED_BY  @v_batch_user
				,      GETDATE()        -- LAST_UPDATE_DATE
				FROM   #TMP_SCP_SHIP_PLAN  T WITH(NOLOCK) 
				WHERE  FROM_SITE_OPERATION_GROUP = 'E'
				AND    TO_SITE_OPERATION_GROUP   IN ('A', '-')
				AND    FROM_COMPANY_ID <> TO_COMPANY_ID
				--     전극 출하대상 LOOKUP에 등록되지 않은 TO SITE 
				AND    NOT EXISTS ( SELECT *   -- 전극출하대상
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
									WHERE 1=1 
									AND L.LOOKUP_TYPE =  'ELECTRODE_SHIP_REQ_AUTO_CREATE' 
									AND L.SEGMENT1    =  T.TO_DIVISION_ID   
									AND L.SEGMENT2    =  T.TO_SITE    
									) 
			   ; 

				/*------------------------------------------------------------------------------------------------------------- 
				1-5. SSP_ANL_SHIP_REQ_EE : SCP FN PLAN 기준 DEFAULT 생성 (주1회)  ETA 기준 
					* 생성 구간 및 삭제 로직 정리 
					- 확정구간 이후 : 변동없음 
					   확정구간 : CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](P.DIVISION_ID,P.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_date ,112)) ,112) 
					- 확정구간 + OVERWRITE 구간 : 사용자가 수정한 내역은 제외하고 삭제 후 신규 생성 
					- OVERWRITE 구간 : 전부 삭제 신규 생성 
					- [C20200723-000010] SCP계획사용안할 경우는 자동 생성 제외
				--------------------------------------------------------------------------------------------------------------*/ 
				DECLARE @v_fn_plan_cnt      INTEGER = 0;

				-- 최근 FN PLAN 정보가 SSP_ANL_SHIP_REQ_EE에 없을때 생성 있으면 생성 안함 
				SELECT @v_fn_plan_cnt = COUNT(*) 
				FROM   SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
				WHERE  R.SCP_PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd
				AND    R.SCP_PLAN_TYPE           = @v_scp_plan_type 
				AND    R.SCP_PLAN_SEQ            = @v_scp_seq
				; 

				--[C20200723-000010]-----------------------------------------------------------------------------------------------
				--SCP계획사용안할 경우는 자동 생성 제외(Admin > System > SCP I/F Blocking 의 FP Target YN = 'N'일 경우) 
				--휴가기간, 연말(Season Holiday)등의 경우 등록됨  

				DECLARE @v_scp_block_count    INTEGER = 0;
	
				SELECT @v_scp_block_count =  COUNT(*)
				FROM   SCP_PLN_INTERFACE_YN WITH(NOLOCK)
				WHERE  1=1
/*
				AND    DIVISION_ID         = CASE WHEN @c_company_id = 'G670' THEN 'EE_UC' 
				                                  WHEN @c_company_id = 'G740' THEN 'EE_HM' 
												  WHEN @c_company_id = 'G820' THEN 'EE_ST'
												  ELSE 'EE' END
*/
				AND    DIVISION_ID         = CASE WHEN @c_company_id = @v_G670 THEN 'EE_UC'
				                                WHEN @c_company_id = @v_G740 THEN 'EE_HM'
												WHEN @c_company_id = @v_G820 THEN 'EE_ST'
												WHEN @c_company_id = @v_G870 THEN 'EE_HD'
												WHEN @c_company_id = @v_G880 THEN 'EE_HG'--G880 (2025-07-22)
												ELSE 'EE' END
				AND    PLAN_START_YYYYMMDD = @v_scp_plan_start_yyyymmdd 
				AND    FP_TARGET_YN        = 'N'
				;

				IF ( @v_fn_plan_cnt = 0 AND @v_scp_block_count = 0 )   -- 신규생성해야 할 경우
				-- REQ 생성 BEGIN				 
					BEGIN  

						/*************************************************************************************
						기존 요청 삭제 
							(예시) 	현재일  : 04-08 
									확정구간: 10 일   
									OVERWRITE PERIOD : 7 일  

						기존 데이터 삭제 
							확정구간 이후 : 04-18 ~ 
							1)OVERWRITE PERIOD 이후 : 04-25 ~   ==> 전체 삭제
							2)OVERWRITE PERIOD : 04-18 ~ 04-24  ==> 사용자 수정, 기확정 제외하고 삭제 

						신규 데이터 생성 
							1)OVERWRITE PERIOD 이후 : 04-25 ~   ==> 전체 생성 	
							2)OVERWRITE PERIOD : 04-18 ~ 04-24  ==> 사용자 수정 및 생성 제외 하고 생성
					
						**************************************************************************************/
						--temp 테이블 생성 : SSP_ANL_SHIP_REQ_EE , SSP_ANL_SHIP_REQ_EE_H insert 용도
						IF OBJECT_ID('tempdb..#TMP_SSP_ANL_SHIP_REQ_EE') IS NOT NULL
							DROP TABLE #TMP_SSP_ANL_SHIP_REQ_EE

							CREATE TABLE #TMP_SSP_ANL_SHIP_REQ_EE (
								 TRANS_TYPE                  nvarchar(001)  -- D:Delete , I:Insert, U:Update
								,FROM_COMPANY_ID             nvarchar(030)  
								,FROM_DIVISION_ID            nvarchar(030)  
								,FROM_PLANT_ID               nvarchar(030)  
								,FROM_SITE                   nvarchar(030)   
								,TO_COMPANY_ID               nvarchar(030)  
								,TO_DIVISION_ID              nvarchar(030)  
								,TO_PLANT_ID                 nvarchar(030)  
								,TO_SITE                     nvarchar(030)   
								,MODEL_ID                    nvarchar(050)   
								,ITEM_ID                     nvarchar(050)   
								,BOD_ID                      nvarchar(150)  
								,ETD_DATE                    nvarchar(008)    
								,ETA_DATE                    nvarchar(8)    
								,QTY                         numeric(20, 10)
								,QTY_TO_PCM                  numeric(20, 10)
								,QTY_TO_CELL                 numeric(20, 10)
								,SCP_PLAN_START_YYYYMMDD     nvarchar(008)    
								,SCP_PLAN_TYPE               nvarchar(050)   
								,SCP_PLAN_SEQ                bigint         
								,REQUEST_ID                  nvarchar(020)   
								,CONFIRM_ID                  nvarchar(020)   
								,CONFIRM_FLAG                nvarchar(001)    
								,CREATED_BY                  nvarchar(300)  
								,CREATION_DATE               datetime       
								,LAST_UPDATED_BY             nvarchar(300)  
								,LAST_UPDATE_DATE            datetime       
							);


						-----------------------------------------------------------------------------------------
						--기존 데이터 삭제 대상 추출
						-----------------------------------------------------------------------------------------
						-- 확정구간 + OVERWIRTE 이후 : 모두 삭제 (CONFIRM된 건 제외) 

						INSERT INTO #TMP_SSP_ANL_SHIP_REQ_EE (
								 TRANS_TYPE                
								,FROM_COMPANY_ID             
								,FROM_DIVISION_ID            
								,FROM_PLANT_ID               
								,FROM_SITE                   
								,TO_COMPANY_ID               
								,TO_DIVISION_ID              
								,TO_PLANT_ID                 
								,TO_SITE                     
								,MODEL_ID                    
								,ITEM_ID                     
								,BOD_ID                      
								,ETD_DATE                    
								,ETA_DATE                    
								,QTY                         
								,QTY_TO_PCM                  
								,QTY_TO_CELL                 
								,SCP_PLAN_START_YYYYMMDD     
								,SCP_PLAN_TYPE               
								,SCP_PLAN_SEQ                
								,REQUEST_ID                  
								,CONFIRM_ID                  
								,CONFIRM_FLAG                
								,CREATED_BY                  
								,CREATION_DATE               
								,LAST_UPDATED_BY             
								,LAST_UPDATE_DATE                  
								)
						SELECT  'D'             AS TRANS_TYPE   -- D:Delete , I:Insert, U:Update
								,R.FROM_COMPANY_ID             
								,R.FROM_DIVISION_ID            
								,R.FROM_PLANT_ID               
								,R.FROM_SITE                   
								,R.TO_COMPANY_ID               
								,R.TO_DIVISION_ID              
								,R.TO_PLANT_ID                 
								,R.TO_SITE                     
								,R.MODEL_ID                    
								,R.ITEM_ID                     
								,R.BOD_ID                      
								,R.ETD_DATE                    
								,R.ETA_DATE                    
								,R.QTY                         
								,R.QTY_TO_PCM                  
								,R.QTY_TO_CELL                 
								,R.SCP_PLAN_START_YYYYMMDD     
								,R.SCP_PLAN_TYPE               
								,R.SCP_PLAN_SEQ                
								,R.REQUEST_ID                  
								,R.CONFIRM_ID                  
								,R.CONFIRM_FLAG                
								,R.CREATED_BY                  
								,R.CREATION_DATE               
								,R.LAST_UPDATED_BY             
								,R.LAST_UPDATE_DATE  			     					
						FROM SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
								ON  L.LOOKUP_TYPE = 'ELECTRODE_SHIP_REQ_OW_PERIOD' 
								AND L.VALID_YN    = 'Y' 
								AND L.SEGMENT1    = R.FROM_COMPANY_ID
								AND L.SEGMENT2    = R.FROM_DIVISION_ID
								AND L.SEGMENT3    = R.FROM_PLANT_ID
								AND L.SEGMENT4    = R.FROM_SITE
						WHERE  1=1 
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						--AND    R.ETD_DATE >=  CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE) + ISNULL(CONVERT(INT, L.SEGMENT5),0)  
						--											   , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
						AND    R.ETD_DATE >=  CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) + ISNULL(CONVERT(INT, L.SEGMENT5),0)
						                                                , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
						AND    R.CONFIRM_FLAG <> 'Y'
						; 

						-- 확정구간 ~ 확정구간 + OVERWIRTE 구간: 사용자 수정 없는 것(R.LAST_UPDATED_BY = 'SCP FN Plan')  삭제, 단 확정된건은 제외(CONFIRM_FLAG <>'Y') 
						INSERT INTO #TMP_SSP_ANL_SHIP_REQ_EE (
								 TRANS_TYPE                
								,FROM_COMPANY_ID             
								,FROM_DIVISION_ID            
								,FROM_PLANT_ID               
								,FROM_SITE                   
								,TO_COMPANY_ID               
								,TO_DIVISION_ID              
								,TO_PLANT_ID                 
								,TO_SITE                     
								,MODEL_ID                    
								,ITEM_ID                     
								,BOD_ID                      
								,ETD_DATE                    
								,ETA_DATE                    
								,QTY                         
								,QTY_TO_PCM                  
								,QTY_TO_CELL                 
								,SCP_PLAN_START_YYYYMMDD     
								,SCP_PLAN_TYPE               
								,SCP_PLAN_SEQ                
								,REQUEST_ID                  
								,CONFIRM_ID                  
								,CONFIRM_FLAG                
								,CREATED_BY                  
								,CREATION_DATE               
								,LAST_UPDATED_BY             
								,LAST_UPDATE_DATE           
								)
						SELECT  'D'             AS TRANS_TYPE   -- D:Delete , I:Insert, U:Update
								,R.FROM_COMPANY_ID             
								,R.FROM_DIVISION_ID            
								,R.FROM_PLANT_ID               
								,R.FROM_SITE                   
								,R.TO_COMPANY_ID               
								,R.TO_DIVISION_ID              
								,R.TO_PLANT_ID                 
								,R.TO_SITE                     
								,R.MODEL_ID                    
								,R.ITEM_ID                     
								,R.BOD_ID                      
								,R.ETD_DATE                    
								,R.ETA_DATE                    
								,R.QTY                         
								,R.QTY_TO_PCM                  
								,R.QTY_TO_CELL                 
								,R.SCP_PLAN_START_YYYYMMDD     
								,R.SCP_PLAN_TYPE               
								,R.SCP_PLAN_SEQ                
								,R.REQUEST_ID                  
								,R.CONFIRM_ID                  
								,R.CONFIRM_FLAG                
								,R.CREATED_BY                  
								,R.CREATION_DATE               
								,R.LAST_UPDATED_BY             
								,R.LAST_UPDATE_DATE  			   					
						FROM SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
								ON  L.LOOKUP_TYPE = 'ELECTRODE_SHIP_REQ_OW_PERIOD' 
								AND L.VALID_YN    = 'Y' 
								AND L.SEGMENT1    = R.FROM_COMPANY_ID
								AND L.SEGMENT2    = R.FROM_DIVISION_ID
								AND L.SEGMENT3    = R.FROM_PLANT_ID
								AND L.SEGMENT4    = R.FROM_SITE 
						WHERE  1=1
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						/*
						AND    R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE)  
																	  , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  
						AND    R.ETD_DATE  < CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE) + ISNULL(CONVERT(INT, L.SEGMENT5),0)
																	  , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  
						*/
						AND    R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) 
						                                               , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
						AND    R.ETD_DATE  < CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) + ISNULL(CONVERT(INT, L.SEGMENT5),0) 
						                                               , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
						AND    R.LAST_UPDATED_BY = 'SCP FN Plan'
						AND    R.CONFIRM_FLAG <> 'Y'
						;

						-----------------------------------------------------------------------------------------
						-- 신규 데이터 대상 추출   
						-----------------------------------------------------------------------------------------
						INSERT INTO #TMP_SSP_ANL_SHIP_REQ_EE (
								 TRANS_TYPE                
								,FROM_COMPANY_ID             
								,FROM_DIVISION_ID            
								,FROM_PLANT_ID               
								,FROM_SITE                   
								,TO_COMPANY_ID               
								,TO_DIVISION_ID              
								,TO_PLANT_ID                 
								,TO_SITE                     
								,MODEL_ID                    
								,ITEM_ID                     
								,BOD_ID                      
								,ETD_DATE                    
								,ETA_DATE                    
								,QTY                         
								,QTY_TO_PCM                  
								,QTY_TO_CELL                 
								,SCP_PLAN_START_YYYYMMDD     
								,SCP_PLAN_TYPE               
								,SCP_PLAN_SEQ                
								,REQUEST_ID                  
								,CONFIRM_ID                  
								,CONFIRM_FLAG                
								,CREATED_BY                  
								,CREATION_DATE               
								,LAST_UPDATED_BY             
								,LAST_UPDATE_DATE         
								)
						SELECT 	'I'             AS TRANS_TYPE   -- D:Delete , I:Insert, U:Update
								,T.FROM_COMPANY_ID             
								,T.FROM_DIVISION_ID            
								,T.FROM_PLANT_ID               
								,T.FROM_SITE                   
								,T.TO_COMPANY_ID               
								,T.TO_DIVISION_ID              
								,T.TO_PLANT_ID                 
								,T.TO_SITE                     
								,T.MODEL_ID                    
								,T.ITEM_ID                     
								,T.BOD_ID                      
								,T.ETD_DATE                    
								,T.ETA_DATE  		
								,ROUND(SUM(T.QTY),10)              AS QTY 
								,NULL                    AS QTY_TO_PCM
								,NULL                    AS QTY_TO_CELL
								,@v_scp_plan_start_yyyymmdd  -- PLAN_START_YYYYMMDD
								,@v_scp_plan_type            -- PLAN_TYPE
								,@v_scp_seq                  -- PLAN_SEQ
								,'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_EE_ID),6) -- REQUEST_ID
								,NULL                        -- CONFIRM_ID 
								,'N'                         -- CONFIRM_FLAG
								,'SCP FN Plan'               -- CREATED_BY
								,GETDATE()					 -- CREATION_DATE
								,'SCP FN Plan'				 -- LAST_UPDATED_BY
								,GETDATE()                   -- LAST_UPDATE_DATE 
						FROM   #TMP_SCP_SHIP_PLAN T WITH(NOLOCK)
						WHERE 1=1 
						/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						/*
						AND   T.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](T.FROM_DIVISION_ID,T.FROM_SITE)  --확정구간 이후 
													, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  
						*/
						AND   T.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, T.FROM_DIVISION_ID,T.FROM_SITE, @v_plan_start_yyyymmdd) 
						                                   , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
						AND   NOT EXISTS ( SELECT 1 -- 확정구간 ~ 확정구간+OW구간 의 사용자가 수정한값 과 동일한것은 제외 
										   FROM SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
											LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
												ON  L.LOOKUP_TYPE = 'ELECTRODE_SHIP_REQ_OW_PERIOD' 
												AND L.VALID_YN    = 'Y' 
												AND L.SEGMENT1    = R.FROM_COMPANY_ID
												AND L.SEGMENT2    = R.FROM_DIVISION_ID
												AND L.SEGMENT3    = R.FROM_PLANT_ID
												AND L.SEGMENT4    = R.FROM_SITE 
										   WHERE 1=1 
										   AND   R.FROM_COMPANY_ID  = T.FROM_COMPANY_ID
										   AND   R.FROM_DIVISION_ID = T.FROM_DIVISION_ID   
										   AND   R.FROM_PLANT_ID    = T.FROM_PLANT_ID
										   AND   R.FROM_SITE        = T.FROM_SITE   
										   AND   R.TO_COMPANY_ID    = T.TO_COMPANY_ID
										   AND   R.TO_DIVISION_ID   = T.TO_DIVISION_ID   
										   AND   R.TO_PLANT_ID      = T.TO_PLANT_ID
										   AND   R.TO_SITE          = T.TO_SITE  
										   AND   R.MODEL_ID          = T.MODEL_ID        
										   AND   R.ITEM_ID           = T.ITEM_ID   
										   AND   R.BOD_ID            = T.BOD_ID          
										   AND   R.ETD_DATE          = T.ETD_DATE        
										   AND   R.ETA_DATE          = T.ETA_DATE   
										   AND   R.LAST_UPDATED_BY   <>  'SCP FN Plan' -- 사용자 수정 
										   AND   R.CONFIRM_FLAG <> 'Y'
										   /*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
										   /*
										   AND   R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE)  
																						  , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  
										   AND   R.ETD_DATE  < CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE) + ISNULL(CONVERT(INT, L.SEGMENT5),0)
																						  , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)  
											*/
										   AND   R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) 
											                                             , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
										   AND   R.ETD_DATE  < CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) + ISNULL(CONVERT(INT, L.SEGMENT5),0)
											                                             , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) 
										  )
						GROUP BY T.FROM_COMPANY_ID
								,T.FROM_DIVISION_ID
								,T.FROM_PLANT_ID
								,T.FROM_SITE
								,T.TO_COMPANY_ID
								,T.TO_DIVISION_ID
								,T.TO_PLANT_ID
								,T.TO_SITE
								,T.MODEL_ID
								,T.ITEM_ID
								,T.BOD_ID
								,T.ETD_DATE
								,T.ETA_DATE
						;

						-----------------------------------------------------------------------------------------
						--[ADD_20200721]
						-- 자동생성 대상이 아닌경우 제외 (LOOKUP : ELECTRODE_SHIP_REQ_AUTO_CREATE ) VALID_YN ='N' 경우 대상 삭제 (20200721) 
						-- 기존 만들어 진후 LOOKUP이 바뀔경우 기존 생성된 내용은 삭제 안하고 신규경우만 생성안됨 ) 
						-- 만약 이전것도 삭제하려면 TRANS_TYPE = 'D' 인것은 제외 해야 함 (WHERE T.TRANS_TYPE <> 'D' 추가) 
						-----------------------------------------------------------------------------------------
						DELETE #TMP_SSP_ANL_SHIP_REQ_EE
						FROM   #TMP_SSP_ANL_SHIP_REQ_EE T WITH(NOLOCK) 
							  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
								ON L.LOOKUP_TYPE =  'ELECTRODE_SHIP_REQ_AUTO_CREATE'
							   AND L.SEGMENT1 =  T.TO_DIVISION_ID  
							   AND L.SEGMENT2 =  T.TO_SITE 
							   AND L.VALID_YN = 'N'
						 ;

						-----------------------------------------------------------------------------------------
						-- 신규 데이터 생성 SSP_ANL_SHIP_REQ_EE   
						-----------------------------------------------------------------------------------------
						INSERT INTO SSP_ANL_SHIP_REQ_EE (
								 FROM_COMPANY_ID
								,FROM_DIVISION_ID
								,FROM_PLANT_ID
								,FROM_SITE
								,TO_COMPANY_ID
								,TO_DIVISION_ID
								,TO_PLANT_ID
								,TO_SITE
								,MODEL_ID
								,ITEM_ID
								,BOD_ID
								,ETD_DATE
								,ETA_DATE
								,QTY
								,QTY_TO_PCM
								,QTY_TO_CELL
								,SCP_PLAN_START_YYYYMMDD
								,SCP_PLAN_TYPE
								,SCP_PLAN_SEQ
								,REQUEST_ID
								,CONFIRM_ID
								,CONFIRM_FLAG
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE 
								) 
						SELECT   T.FROM_COMPANY_ID
								,T.FROM_DIVISION_ID
								,T.FROM_PLANT_ID
								,T.FROM_SITE
								,T.TO_COMPANY_ID
								,T.TO_DIVISION_ID
								,T.TO_PLANT_ID
								,T.TO_SITE
								,T.MODEL_ID
								,T.ITEM_ID
								,T.BOD_ID
								,T.ETD_DATE
								,T.ETA_DATE
								,ROUND(T.QTY, 0)  AS QTY
								,CEILING(ROUND(T.QTY, 0) * ISNULL(E.CONVERT_TO_PCM, 1))   AS QTY_TO_PCM 							
								,CEILING(ROUND(T.QTY, 0) * ISNULL(E.CONVERT_TO_CELL, 1))  AS QTY_TO_CELL 	
								,T.SCP_PLAN_START_YYYYMMDD
								,T.SCP_PLAN_TYPE
								,T.SCP_PLAN_SEQ
								,T.REQUEST_ID             
								,T.CONFIRM_ID             
								,T.CONFIRM_FLAG             
								,T.CREATED_BY             
								,T.CREATION_DATE             
								,T.LAST_UPDATED_BY             
								,T.LAST_UPDATE_DATE      					
						FROM #TMP_SSP_ANL_SHIP_REQ_EE T WITH(NOLOCK) 

						  JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							ON E.DIVISION_ID = T.FROM_DIVISION_ID 
						   AND E.SCM_SITE_ID = T.FROM_SITE  -- 출하요청은 FROM_SITE 기준 
						   AND E.ITEM_ID     = T.ITEM_ID

						WHERE T.TRANS_TYPE  = 'I'
						;

						-----------------------------------------------------------------------------------------
						--기존 데이터 삭제 : T.TRANS_TYPE  = 'D'
						-----------------------------------------------------------------------------------------
						DELETE SSP_ANL_SHIP_REQ_EE
						FROM   SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
							  JOIN #TMP_SSP_ANL_SHIP_REQ_EE T WITH(NOLOCK) 
								ON T.REQUEST_ID = R.REQUEST_ID 
							   AND T.TRANS_TYPE ='D'


						-----------------------------------------------------------------------------------------
						-- HISTORY TALBE INSERT  SSP_ANL_SHIP_REQ_EE_H
						-----------------------------------------------------------------------------------------
						INSERT INTO SSP_ANL_SHIP_REQ_EE_H (
								 HISTORY_SEQ
								,TRANS_TYPE
								,FROM_COMPANY_ID
								,FROM_DIVISION_ID
								,FROM_PLANT_ID
								,FROM_SITE
								,TO_COMPANY_ID
								,TO_DIVISION_ID
								,TO_PLANT_ID
								,TO_SITE
								,MODEL_ID
								,ITEM_ID
								,BOD_ID
								,ETD_DATE
								,ETA_DATE
								,QTY
								,QTY_TO_PCM
								,QTY_TO_CELL
								,SCP_PLAN_START_YYYYMMDD
								,SCP_PLAN_TYPE
								,SCP_PLAN_SEQ
								,REQUEST_ID
								,CONFIRM_ID
								,CONFIRM_FLAG
								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE 
								,HISTORY_CREATION_DATE
								) 
						SELECT   NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_REQ_EE_H
								,T.TRANS_TYPE
								,T.FROM_COMPANY_ID
								,T.FROM_DIVISION_ID
								,T.FROM_PLANT_ID
								,T.FROM_SITE
								,T.TO_COMPANY_ID
								,T.TO_DIVISION_ID
								,T.TO_PLANT_ID
								,T.TO_SITE
								,T.MODEL_ID
								,T.ITEM_ID
								,T.BOD_ID
								,T.ETD_DATE
								,T.ETA_DATE
								,ROUND(T.QTY, 0)  AS QTY
								,CEILING(T.QTY * ISNULL(E.CONVERT_TO_PCM, 1))   AS QTY_TO_PCM 							
								,CEILING(T.QTY * ISNULL(E.CONVERT_TO_CELL, 1))  AS QTY_TO_CELL 	
								,T.SCP_PLAN_START_YYYYMMDD
								,T.SCP_PLAN_TYPE
								,T.SCP_PLAN_SEQ
								,T.REQUEST_ID             
								,T.CONFIRM_ID             
								,T.CONFIRM_FLAG             
								,T.CREATED_BY             
								,T.CREATION_DATE             
								,T.LAST_UPDATED_BY             
								,T.LAST_UPDATE_DATE 
								,GETDATE()     					
						FROM #TMP_SSP_ANL_SHIP_REQ_EE T WITH(NOLOCK) 
						  JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							ON E.DIVISION_ID = T.FROM_DIVISION_ID 
						   AND E.SCM_SITE_ID = T.FROM_SITE  -- 출하요청은 FROM_SITE 기준 
						   AND E.ITEM_ID     = T.ITEM_ID
						;

					-- REQ 생성 END
					END;   

				/*------------------------------------------------------------------------------------------------------------- 
				1-6. #TMP_PLAN_ITEM
					 SCM_MST_SITE_ITEM 등록기준으로 (BOH + FP + SCP_PROD_PLAN + SCP_SHIP_PLAN) 있는것들 
					 SSP_MST_SITE_ITEM_EE_V로 적용 ( <-- SCM_MST_SITE_ITEM기준) 

				MEASURE_TYPE : R -> Request 메져용 ( 전극 --> 조립(cell) 으로 ) 
				MEASURE_TYPE : P -> Plan 메져용 ( 전극 기준 ) 				 
				--------------------------------------------------------------------------------------------------------------*/ 
				IF OBJECT_ID('tempdb..#TMP_PLAN_ITEM') IS NOT NULL
				DROP TABLE #TMP_PLAN_ITEM 

				SELECT X.COMPANY_ID
				,      X.DIVISION_ID
				,      X.PLANT_ID
				,      X.SCM_SITE_ID 
				,      X.MODEL_ID
				,      X.ITEM_ID
				,      X.MEASURE_TYPE
				INTO  #TMP_PLAN_ITEM
				FROM  ( 
					   SELECT DISTINCT 
							  T.COMPANY_ID  
					   ,      T.DIVISION_ID
					   ,      T.PLANT_ID
					   ,      T.SCM_SITE_ID
					   ,      T.MODEL_ID
					   ,      T.ITEM_ID
					   ,      T.MEASURE_TYPE
					   FROM   #TMP_FP_BOH T WITH(NOLOCK)


					   UNION ALL 

					   SELECT DISTINCT 
							  T.COMPANY_ID 
					   ,      T.DIVISION_ID
					   ,      T.PLANT_ID
					   ,      T.SCM_SITE_ID
					   ,      T.MODEL_ID
					   ,      T.ITEM_ID
					   ,      T.MEASURE_TYPE
					   FROM   #TMP_FP_PLAN T WITH(NOLOCK)

					   UNION ALL 

					   SELECT DISTINCT 
							  T.COMPANY_ID 
					   ,      T.DIVISION_ID
					   ,      T.PLANT_ID
					   ,      T.SCM_SITE_ID
					   ,      T.MODEL_ID
					   ,      T.ITEM_ID
					   ,      T.MEASURE_TYPE
					   FROM   #TMP_SCP_PROD_PLAN T WITH(NOLOCK)

					   UNION ALL 

					   SELECT DISTINCT  -- ETA기준
							  TO_COMPANY_ID   COMPANY_ID
					   ,      TO_DIVISION_ID  DIVISION_ID
					   ,      TO_PLANT_ID     PLANT_ID
					   ,      TO_SITE         SCM_SITE_ID
					   ,      MODEL_ID
					   ,      ITEM_ID
					   ,      'R' 
					   FROM   SSP_ANL_SHIP_REQ_EE WITH(NOLOCK)
					   WHERE  1=1  
					   AND    TO_COMPANY_ID  = @c_company_id
					   AND    ETA_DATE >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					   AND    ETA_DATE  < @v_plan_end_yyyymmdd

					   UNION ALL 

					   SELECT DISTINCT  -- ETD기준
							  FROM_COMPANY_ID   COMPANY_ID
					   ,      FROM_DIVISION_ID  DIVISION_ID
					   ,      FROM_PLANT_ID     PLANT_ID
					   ,      FROM_SITE         SCM_SITE_ID
					   ,      MODEL_ID
					   ,      ITEM_ID
					   ,      'P'
					   FROM   SSP_ANL_SHIP_REQ_EE WITH(NOLOCK)
					   WHERE  1=1  
					   AND    FROM_COMPANY_ID  = @c_company_id
					   AND    ETD_DATE >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					   AND    ETD_DATE  < @v_plan_end_yyyymmdd

					   ) X


				WHERE  X.COMPANY_ID = @c_company_id
				GROUP BY X.COMPANY_ID
				,      X.DIVISION_ID
				,      X.PLANT_ID
				,      X.SCM_SITE_ID 
				,      X.MODEL_ID
				,      X.ITEM_ID  	
				,      X.MEASURE_TYPE
				;

			/*------------------------------------------------------------------------------------------------------------- 
			  2. MEASURE별 Data생성(당일용) 
			---------------------------------------------------------------------------------------------------------------
				2-1. Request용 Measure생성(MEASURE_TYPE = R)
					(O) 2-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater)
					(O) 2-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)
					(O) 2-1-3. [R_FP_COATER_PLAN] Coater Plan 
					(O) 2-1-4. [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield
					(X) 2-1-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In) - 실시간
					(O) 2-2-1. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)
					(X) 2-2-2. [R_SHIP_REQ_ETA] Shipment Request (ETA)  - 실시간 
					(X) 2-2-3. [R_SHIP_PLAN_ETD] Shipment Plan(Out)     - 실시간
					(X) 2-2-4. [R_INV_SHIP_REQ] Inventory(Ship Req)     - 계산
					(X) 2-2-5. [R_INV_SHIP_PLAN] Inventory(Ship Plan)   - 계산

				2-2. Plan용 Measure생성(MEASURE_TYPE = P)
					(O) 2-1-1. [P_SCP_PROD_PLAN] SCP Target (Coater)
					(O) 2-1-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)
					(O) 2-1-3. [P_FP_COATER_PLAN] Coater Plan 
					(0) 2-1-4. [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield
					(X) 2-1-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  - 실시간
					(O) 2-3-1. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)
					(X) 2-3-2. [P_SHIP_REQ_ETD] Shipment Request (ETD)                 - 실시간
					(O) 2-3-3. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)
					(X) 2-3-4. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         - 실시간
					(X) 2-3-5. [P_INV_SIM] Inventory(Simualtion)                       - 계산 
					(X) 2-3-6. [P_INV_CONFIRM] Inventory(Confirm)                      - 계산  


			--------------------------------------------------------------------------------------------------------------*/ 
			--temp 테이블 생성 : SSP_ANL_SHIP_PLAN_EE insert 용도 (당일)
			IF OBJECT_ID('tempdb..#TMP_SSP_ANL_SHIP_PLAN_EE') IS NOT NULL
				DROP TABLE #TMP_SSP_ANL_SHIP_PLAN_EE

				CREATE TABLE #TMP_SSP_ANL_SHIP_PLAN_EE (
				 COMPANY_ID           NVARCHAR(030)  
				,DIVISION_ID          NVARCHAR(030)  
				,PLANT_ID             NVARCHAR(030)  
				,SCM_SITE_ID          NVARCHAR(030) 
				,MODEL_ID             NVARCHAR(050)  
				,ITEM_ID              NVARCHAR(050)  
				,MEASURE_TYPE         NVARCHAR(001)  -- C:공통  R :Request 화면용 P:, Plan 화면용
				,MEASURE              NVARCHAR(050)
				,YYYYMMDD             NVARCHAR(008) 
				,QTY                  NUMERIC(20,10)
				,FROM_DIVISION_ID     NVARCHAR(030)  
				,FROM_SITE            NVARCHAR(030)  
				,TO_DIVISION_ID       NVARCHAR(030)  
				,TO_SITE              NVARCHAR(030)  
				,BOD_ID               NVARCHAR(150) 
				,ETD_DATE             NVARCHAR(008)   
				,ETA_DATE             NVARCHAR(008)   
				);


				/*----------------------------------------------------------------------------------------------------------- 
				 2-1. Request  Measure생성(MEASURE_TYPE = R)
				------------------------------------------------------------------------------------------------------------- 
					(O) 2-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater)
					(O) 2-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)
					(O) 2-1-3. [R_FP_COATER_PLAN] Coater Plan 
					(O) 2-1-4. [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield
					(X) 2-1-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  - 실시간 

					(O) 2-1-6. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)
					(X) 2-1-7. [R_SHIP_REQ_ETA] Shipment Request (ETA)  - 실시간 
					(X) 2-1-8. [R_SHIP_PLAN_ETD] Shipment Plan(Out)     - 실시간
					(X) 2-1-9. [R_INV_SHIP_REQ] Inventory(Ship Req)     - 계산
					(X) 2-1-10.[R_INV_SHIP_PLAN] Inventory(Ship Plan)   - 계산
				-------------------------------------------------------------------------------------------------------------*/ 

					------------------------------------------------------------------------------------------------------------- 
					--2-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater) 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE 
						  ,MEASURE 
   						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'R'                                         AS MEASURE_TYPE
					,      'R_SCP_PROD_PLAN'                           AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.QTY, 0)),10)                       AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_SCP_PROD_PLAN T WITH(NOLOCK)  -- 조립 PLANT 
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'R'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'R'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching) 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE 
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'R'                                         AS MEASURE_TYPE
					,      'R_FP_NPC_ASSY_PLAN'                        AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.NPC_PLAN_QTY, 0)),10)              AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'R'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'R'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-1-3. [R_FP_COATER_PLAN] Coater Plan 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE  
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'R'                                         AS MEASURE_TYPE
					,      'R_FP_COATER_PLAN'                          AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.COATER_PLAN_QTY, 0)),10)           AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'R'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'R'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-1-4. [R_FP_COATER_POST_PLAN] Coater Plan 
					-- 실적구간 필요없음 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'R'                                         AS MEASURE_TYPE
					,      'R_FP_COATER_POST_PLAN'                     AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.COATER_PLAN_QTY, 0)),10)           AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'R'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'R'
					AND    T.YYYYMMDD           >= @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD           < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_plan_start_yyyymmdd)
					;


					------------------------------------------------------------------------------------------------------------- 
					--2-1-6. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target) (ETA) : F.SCM_SITE_ID = T.TO_SITE 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT F.COMPANY_ID           
					,      F.DIVISION_ID          
					,      F.PLANT_ID 
					,      F.SCM_SITE_ID 
					,      F.MODEL_ID             
					,      F.ITEM_ID              
					,      'R'                            AS MEASURE_TYPE          
					,      'R_SCP_SHIP_PLAN_ETA'          AS MEASURE     
					,      T.ETA_DATE                     AS YYYYMMDD              
					,      ROUND(SUM(T.QTY),10)                     AS QTY     
					,      T.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
					,      T.FROM_SITE                    AS FROM_SITE            
					,      T.TO_DIVISION_ID               AS TO_DIVISION_ID       
					,      T.TO_SITE                      AS TO_SITE              
					,      T.BOD_ID                       AS BOD_ID               
					,      T.ETD_DATE                     AS ETD_DATE              
					,      T.ETA_DATE                     AS ETA_DATE 
					FROM #TMP_SCP_SHIP_PLAN T WITH(NOLOCK)  
					   JOIN #TMP_PLAN_ITEM F WITH(NOLOCK)   
						 ON  F.MEASURE_TYPE = 'R'
						AND  F.SCM_SITE_ID = T.TO_SITE 
						AND  F.ITEM_ID     = T.ITEM_ID 
					WHERE T.ETA_DATE      >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND   T.ETA_DATE      <  @v_plan_end_yyyymmdd	 
					GROUP BY F.COMPANY_ID           
					,        F.DIVISION_ID          
					,        F.PLANT_ID 
					,        F.SCM_SITE_ID 
					,        F.MODEL_ID             
					,        F.ITEM_ID     
					,        T.FROM_DIVISION_ID                 
					,        T.FROM_SITE                   
					,        T.TO_DIVISION_ID              
					,        T.TO_SITE                      
					,        T.BOD_ID                       
					,        T.ETD_DATE                     
					,        T.ETA_DATE                  
					;

				/*----------------------------------------------------------------------------------------------------------- 
				 2-2. Plan용 Measure생성(MEASURE_TYPE = P)
				------------------------------------------------------------------------------------------------------------- 
					(O) 2-2-1. [P_SCP_PROD_PLAN] SCP Target (Coater)
					(O) 2-2-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)
					(O) 2-2-3. [P_FP_COATER_PLAN] Coater Plan 
					(O) 2-2-4. [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield
					(X) 2-2-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  - 실시간
					(O) 2-2-6. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)
					(X) 2-2-7. [P_SHIP_REQ_ETD] Shipment Request (ETD)                 - 실시간
					(O) 2-2-8. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)
					(X) 2-2-9. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         - 실시간
					(X) 2-2-10.[P_INV_SIM] Inventory(Simualtion)                       - 계산 
					(X) 2-2-11.[P_INV_CONFIRM] Inventory(Confirm)                      - 계산  
				-------------------------------------------------------------------------------------------------------------*/

					------------------------------------------------------------------------------------------------------------- 
					--2-2-1. [P_SCP_PROD_PLAN] SCP Target (Coater) 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE 
						  ,MEASURE 
   						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'P'                                         AS MEASURE_TYPE
					,      'P_SCP_PROD_PLAN'                           AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.QTY, 0)),10)                       AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_SCP_PROD_PLAN T WITH(NOLOCK)  -- 조립 PLANT 
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'P'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'P'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-2-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching) 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE 
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'P'                                         AS MEASURE_TYPE
					,      'P_FP_NPC_ASSY_PLAN'                        AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.NPC_PLAN_QTY, 0)),10)             AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'P'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'P'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-2-3. [P_FP_COATER_PLAN] Coater Plan 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE  
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'P'                                         AS MEASURE_TYPE
					,      'P_FP_COATER_PLAN'                          AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.COATER_PLAN_QTY, 0)),10)           AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'P'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'P'
					AND    T.YYYYMMDD           >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_result_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-2-4. [P_FP_COATER_POST_PLAN] Coater Plan 
					-- 실적구간 필요없음 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT M.COMPANY_ID						           AS COMPANY_ID
					,      M.DIVISION_ID						       AS DIVISION_ID
					,      M.PLANT_ID							       AS PLANT_ID 
					,      M.SCM_SITE_ID                               AS SCM_SITE_ID
					,      M.MODEL_ID    						       AS MODEL_ID
					,      M.ITEM_ID							       AS ITEM_ID
					,      'P'                                         AS MEASURE_TYPE
					,      'P_FP_COATER_POST_PLAN'                     AS MEASURE 
					,      ISNULL(T.YYYYMMDD, @v_plan_start_yyyymmdd)  AS YYYYMMDD 
					,      ROUND(SUM(ISNULL(T.COATER_PLAN_QTY, 0)),10)           AS QTY 
					,      '-'                                         AS FROM_DIVISION_ID       
					,      '-'                                         AS FROM_SITE
					,      '-'                                         AS TO_DIVISION_ID       
					,      '-'                                         AS TO_SITE
					,      '-'                                         AS BOD_ID
					,      '-'                                         AS ETD_DATE
					,      '-'                                         AS ETA_DATE  
					FROM #TMP_PLAN_ITEM M WITH(NOLOCK) 
					 LEFT OUTER JOIN #TMP_FP_PLAN T WITH(NOLOCK)  
						  ON T.COMPANY_ID  = M.COMPANY_ID 
						 AND T.DIVISION_ID = M.DIVISION_ID 
						 AND T.PLANT_ID    = M.PLANT_ID 
						 AND T.SCM_SITE_ID = M.SCM_SITE_ID 
						 AND T.MODEL_ID    = M.MODEL_ID 
						 AND T.ITEM_ID     = M.ITEM_ID 
						 AND T.MEASURE_TYPE= 'P'
					WHERE  1=1 
					AND    M.MEASURE_TYPE  = 'P'
					AND    T.YYYYMMDD           >= @v_plan_start_yyyymmdd
					AND    T.YYYYMMDD            < @v_plan_end_yyyymmdd
					GROUP BY M.COMPANY_ID
					,        M.DIVISION_ID	
					,        M.PLANT_ID	
					,        M.SCM_SITE_ID 
					,        M.MODEL_ID
					,        M.ITEM_ID
					,        ISNULL(T.YYYYMMDD, @v_plan_start_yyyymmdd)
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-2-6. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)   F.SCM_SITE_ID = T.FROM_SITE 
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT F.COMPANY_ID           
					,      F.DIVISION_ID          
					,      F.PLANT_ID 
					,      F.SCM_SITE_ID 
					,      F.MODEL_ID             
					,      F.ITEM_ID              
					,      'P'                            AS MEASURE_TYPE          
					,      'P_SCP_SHIP_PLAN_ETD'          AS MEASURE     
					,      T.ETD_DATE                     AS YYYYMMDD              
					,      ROUND(SUM(T.QTY),10)                    AS QTY     
					,      T.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
					,      T.FROM_SITE                    AS FROM_SITE            
					,      T.TO_DIVISION_ID               AS TO_DIVISION_ID       
					,      T.TO_SITE                      AS TO_SITE              
					,      T.BOD_ID                       AS BOD_ID               
					,      T.ETD_DATE                     AS ETD_DATE              
					,      T.ETA_DATE                     AS ETA_DATE 
					FROM #TMP_SCP_SHIP_PLAN T WITH(NOLOCK)  
					   JOIN #TMP_PLAN_ITEM F WITH(NOLOCK)   
						 ON  F.MEASURE_TYPE = 'P'
						AND  F.SCM_SITE_ID = T.FROM_SITE 
						AND  F.ITEM_ID     = T.ITEM_ID 
					WHERE T.ETD_DATE      >= @v_result_plan_start_yyyymmdd -- @v_plan_start_yyyymmdd
					AND   T.ETD_DATE      <  @v_plan_end_yyyymmdd	 
					GROUP BY F.COMPANY_ID           
					,        F.DIVISION_ID          
					,        F.PLANT_ID 
					,        F.SCM_SITE_ID 
					,        F.MODEL_ID             
					,        F.ITEM_ID     
					,        T.FROM_DIVISION_ID                 
					,        T.FROM_SITE                   
					,        T.TO_DIVISION_ID              
					,        T.TO_SITE                      
					,        T.BOD_ID                       
					,        T.ETD_DATE                     
					,        T.ETA_DATE                  
					;

					------------------------------------------------------------------------------------------------------------- 
					--2-2-8. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD) : 출하 확정 + 출하요청 
					--       최초 출하요청 기준이고 사용자가 SIMULATION 저장, CONFIRM 수정되면 수정된 값으로 변경 
					--       #TMP_PLAN_ITEM.SCM_SITE_ID = 출하확정의 FROM_SITE, 출하요청의 FROM_SITE 
					--       확정구간 : 출하확정 
					--       확정구간 이후 : 출하확정 + 출하요청
					--       다음날 생성 시 최근값 유지 
					--       별도 이력값 관리  (SSP_ANL_SHIP_PLAN_SIMU_EE)
					------------------------------------------------------------------------------------------------------------- 
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					-- 2020.07.17   KIMBK   P_SHIP_PLAN_SIMU_ETD SCM_SYS_CALENDAR_M 일자 기준으로 로직변경
					SELECT   X.COMPANY_ID           
					,        X.DIVISION_ID          
					,        X.PLANT_ID    
					,        X.SCM_SITE_ID
					,        X.MODEL_ID             
					,        X.ITEM_ID  
					,        'P'                       AS MEASURE_TYPE          
					,        'P_SHIP_PLAN_SIMU_ETD'    AS MEASURE   
					,        ISNULL(X.YYYYMMDD, @v_result_plan_start_yyyymmdd)             AS YYYYMMDD
					,        CASE WHEN ROUND(SUM( ISNULL(Y.QTY, 0) ),10) <> 0 THEN SUM( ISNULL(Y.QTY, 0) ) ELSE ROUND(SUM( ISNULL(X.QTY, 0) ),10) END AS QTY 
					--,        CASE WHEN ROUND(SUM( ISNULL(X.QTY, 0) ),10) <> 0 THEN SUM( ISNULL(X.QTY, 0) ) ELSE ROUND(SUM( ISNULL(Y.QTY, 0) ),10) END AS QTY 
					--,        ISNULL(CASE WHEN SUM(Y.QTY) IS NULL or SUM(Y.QTY) = 0 THEN  SUM(X.QTY) ELSE SUM(Y.QTY) END,0)  AS QTY 
					,        '-'                       AS FROM_DIVISION_ID       
					,        '-'                       AS FROM_SITE            
					,        '-'                       AS TO_DIVISION_ID       
					,        '-'                       AS TO_SITE              
					,        '-'                       AS BOD_ID               
					,        '-'                       AS ETD_DATE              
					,        '-'                       AS ETA_DATE 
					FROM  ( SELECT A.COMPANY_ID
								, A.DIVISION_ID
								, A.PLANT_ID
								, A.SCM_SITE_ID
								, A.MODEL_ID
								, A.ITEM_ID
								, A.YYYYMMDD
								, ISNULL(B.QTY, 0) AS QTY
							FROM   (
									SELECT B.COMPANY_ID           
									,      B.DIVISION_ID          
									,      B.PLANT_ID    
									,      B.SCM_SITE_ID
									,      B.MODEL_ID             
									,      B.ITEM_ID  
									,      A.BASIS_YYYYMMDD AS YYYYMMDD
									FROM   SCM_SYS_CALENDAR_M  A WITH(NOLOCK) 
									JOIN   #TMP_PLAN_ITEM B WITH(NOLOCK)
										ON   B.COMPANY_ID = @c_company_id   
										AND  B.MEASURE_TYPE  = 'P'
									WHERE  A.BASIS_YYYYMMDD >= @v_result_plan_start_yyyymmdd
									AND    A.BASIS_YYYYMMDD <= @v_plan_end_yyyymmdd 
									GROUP BY B.COMPANY_ID           
									,      B.DIVISION_ID          
									,      B.PLANT_ID    
									,      B.SCM_SITE_ID
									,      B.MODEL_ID             
									,      B.ITEM_ID  
									,      A.BASIS_YYYYMMDD
								   ) A
									LEFT OUTER JOIN (
													SELECT A.COMPANY_ID
															, A.DIVISION_ID
															, A.PLANT_ID
															, A.SCM_SITE_ID
															, A.MODEL_ID
															, A.ITEM_ID
															, A.YYYYMMDD
															, SUM( ISNULL(A.QTY, 0) )  AS QTY
													FROM   (
															-- 출하 확정 : 전체
															SELECT T.COMPANY_ID           
															,      T.DIVISION_ID          
															,      T.PLANT_ID    
															,      T.SCM_SITE_ID
															,      T.MODEL_ID             
															,      T.ITEM_ID              
															,      C.YYYYMMDD
															,      CASE WHEN C.QTY IS NULL THEN 0 ELSE C.QTY END              AS QTY     
															FROM   #TMP_PLAN_ITEM T WITH(NOLOCK)
																LEFT OUTER JOIN  SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
																	ON C.DIVISION_ID = T.DIVISION_ID 
																AND C.FROM_SITE   = T.SCM_SITE_ID
																AND C.ITEM_ID     = T.ITEM_ID 
																AND C.CHANGE_TYPE = 'C'
																AND C.YYYYMMDD >= @v_result_plan_start_yyyymmdd --@v_plan_start_yyyymmdd -- ETD
																AND C.YYYYMMDD <= @v_plan_end_yyyymmdd    
															WHERE 1=1 
															AND   T.COMPANY_ID = @c_company_id
															AND   T.MEASURE_TYPE  = 'P'

															UNION ALL 

															-- 출하요청 ( 확정구간 이후 ~ ) 
															SELECT T.COMPANY_ID           
															,      T.DIVISION_ID          
															,      T.PLANT_ID 
															,      T.SCM_SITE_ID 
															,      T.MODEL_ID             
															,      T.ITEM_ID              
															,      R.ETD_DATE    AS YYYYMMDD              
															,      CASE WHEN R.QTY IS NULL THEN 0 ELSE R.QTY END                          AS QTY  
															FROM   #TMP_PLAN_ITEM T WITH(NOLOCK)
																LEFT OUTER JOIN  SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK)
																	ON R.FROM_DIVISION_ID = T.DIVISION_ID 
																AND R.FROM_SITE        = T.SCM_SITE_ID
																AND R.ITEM_ID          = T.ITEM_ID   
																-- 당일 확정될 수량 포함하여 생성 시작일자를 하루전으로 
																/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
																/*
																AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID ,R.FROM_SITE) -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112)
																*/
																AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd)
																                                            , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112) - 1) ,112)
																AND R.ETD_DATE  < @v_plan_end_yyyymmdd
																AND R.CONFIRM_FLAG <> 'Y'
															WHERE  1 = 1
															AND    T.COMPANY_ID = @c_company_id 
															AND    T.MEASURE_TYPE  = 'P'
															) A
														WHERE  1 = 1
														GROUP BY A.COMPANY_ID
															, A.DIVISION_ID
															, A.PLANT_ID
															, A.SCM_SITE_ID
															, A.MODEL_ID
															, A.ITEM_ID
															, A.YYYYMMDD
														) B
									ON  B.DIVISION_ID = A.DIVISION_ID 
									AND B.SCM_SITE_ID = A.SCM_SITE_ID
									AND B.ITEM_ID     = A.ITEM_ID 
									AND B.YYYYMMDD    = A.YYYYMMDD
							WHERE  1 = 1

							) X	
							  LEFT OUTER JOIN ( -- 사용자 입력값이 있으면 사용자 입력값으로 
												SELECT H.COMPANY_ID                       
												,      H.DIVISION_ID  
												,      H.PLANT_ID     
												,      H.SCM_SITE_ID  
												,      H.MODEL_ID     
												,      H.ITEM_ID      
												,      H.YYYYMMDD    
												,      H.QTY 
												,      H.QTY_TO_CELL  
												FROM SSP_ANL_SHIP_PLAN_SIMU_EE H WITH(NOLOCK) 
												WHERE H.SEQ = (SELECT MAX(B.SEQ ) 
															   FROM  SSP_ANL_SHIP_PLAN_SIMU_EE B WITH(NOLOCK) 
															   WHERE 1=1
															   AND   B.COMPANY_ID  = H.COMPANY_ID  
															   AND   B.DIVISION_ID = H.DIVISION_ID
															   AND   B.PLANT_ID    = H.PLANT_ID   
															   AND   B.SCM_SITE_ID = H.SCM_SITE_ID
															   AND   B.MODEL_ID    = H.MODEL_ID   
															   AND   B.ITEM_ID     = H.ITEM_ID    
															   AND   B.YYYYMMDD    = H.YYYYMMDD   
															  )  
								  ) Y 
								 ON Y.COMPANY_ID  = X.COMPANY_ID  
								AND Y.DIVISION_ID = X.DIVISION_ID
								AND Y.PLANT_ID    = X.PLANT_ID   
								AND Y.SCM_SITE_ID = X.SCM_SITE_ID
								AND Y.MODEL_ID    = X.MODEL_ID   
								AND Y.ITEM_ID     = X.ITEM_ID    
								AND Y.YYYYMMDD    = X.YYYYMMDD   
					GROUP BY X.COMPANY_ID           
					,        X.DIVISION_ID          
					,        X.PLANT_ID    
					,        X.SCM_SITE_ID
					,        X.MODEL_ID             
					,        X.ITEM_ID              
					,        X.YYYYMMDD                        
					;

				/*----------------------------------------------------------------------------------------------------------- 
				 2-3. SSP_ANL_SHIP_PLAN_EE 생성(당일)
				------------------------------------------------------------------------------------------------------------- 
				-- MEASURE TYPE = R --> 
				-------------------------------------------------------------------------------------------------------------*/
				DELETE FROM SSP_ANL_SHIP_PLAN_EE  
				WHERE  PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd 
				AND    COMPANY_ID = @c_company_id
				;

				INSERT INTO SSP_ANL_SHIP_PLAN_EE
						(PLAN_START_YYYYMMDD
						,COMPANY_ID
						,DIVISION_ID
						,PLANT_ID
						,SCM_SITE_ID
						,MODEL_ID
						,ITEM_ID
						,MEASURE_TYPE
						,MEASURE
						,YYYYMMDD
						,QTY
						,QTY_TO_PCM
						,QTY_TO_CELL
						,FROM_DIVISION_ID
						,FROM_SITE
						,TO_DIVISION_ID
						,TO_SITE
						,BOD_ID
						,ELECTRODE_TYPE
						,ETD_DATE
						,ETA_DATE
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10         								  	
						)
						SELECT 	 
						 @v_plan_start_yyyymmdd  -- PLAN_START_YYYYMMDD
						,T.COMPANY_ID
						,T.DIVISION_ID
						,T.PLANT_ID
						,T.SCM_SITE_ID
						,T.MODEL_ID
						,T.ITEM_ID
						--,T.NPC_ITEM_ID
						,T.MEASURE_TYPE
						,T.MEASURE
						,T.YYYYMMDD
						,ROUND(T.QTY, 0) AS QTY 
						 , ROUND(CEILING(T.QTY * ISNULL(E.CONVERT_TO_PCM, 1)), 0)   AS QTY_TO_PCM 							
						 , ROUND(CEILING(T.QTY * ISNULL(E.CONVERT_TO_CELL, 1)), 0)  AS QTY_TO_CELL 	
						,T.FROM_DIVISION_ID
						,T.FROM_SITE
						,T.TO_DIVISION_ID
						,T.TO_SITE
						,T.BOD_ID
						--,E.ELECTRODE_TYPE
						,(SELECT MAX(F.ELECTRODE_TYPE) 
						  FROM   SCM_MST_FINAL_ITEM_V F WITH(NOLOCK) 
						  WHERE F.ITEM_ID = T.ITEM_ID ) AS ELECTRODE_TYPE
						,T.ETD_DATE
						,T.ETA_DATE
						,@v_batch_user        -- CREATED_BY
						,GETDATE()            -- CREATION_DATE
						,@v_batch_user        -- LAST_UPDATED_BY
						,GETDATE()            -- T.LAST_UPDATE_DATE
						,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL  
						FROM #TMP_SSP_ANL_SHIP_PLAN_EE T WITH (NOLOCK)
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LR WITH(NOLOCK) -- 조립->전극  
							 ON LR.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
							AND LR.SEGMENT1    = T.DIVISION_ID  -- 조립 DIVISION 
							AND LR.SEGMENT2    = T.PLANT_ID     -- 조립 PLANT_ID 
							AND LR.ATTRIBUTE1  = T.SCM_SITE_ID  -- 조립 SCM_SITE_ID  

							LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
							 ON CASE WHEN T.MEASURE_TYPE = 'R' THEN  LR.SEGMENT3   ELSE T.DIVISION_ID END =  E.DIVISION_ID 
							AND CASE WHEN T.MEASURE_TYPE = 'R' THEN  LR.ATTRIBUTE2 ELSE T.SCM_SITE_ID END =  E.SCM_SITE_ID  
							AND E.ITEM_ID     = T.ITEM_ID

						WHERE 1=1
						AND   T.COMPANY_ID = @c_company_id
				;


			  /*------------------------------------------------------------------------------------------------------------- 
			  3. MEASURE별 Data생성 (CUTOFF용) 
			  ---------------------------------------------------------------------------------------------------------------
				<대상 MEASURE >
					(O) 3-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)                <-- 기생성 
					(O) 3-1-3. [R_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-1-4. [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(O) 3-1-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
				
					(X) 3-1-6. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)  
					(X) 3-1-7. [R_SHIP_REQ_ETA] Shipment Request (ETA)   
					(X) 3-1-8. [R_SHIP_PLAN_ETD] Shipment Plan(Out)     
					(X) 3-1-9. [R_INV_SHIP_REQ] Inventory(Ship Req)     
					(X) 3-1-10.[R_INV_SHIP_PLAN] Inventory(Ship Plan)   

					(O) 3-2-1. [P_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-2-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)				   <-- 기생성
					(O) 3-2-3. [P_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-2-4. [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(X) 3-2-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  

					(O) 3-2-6. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)  <-- 기생성
					(X) 3-2-7. [P_SHIP_REQ_ETD] Shipment Request (ETD)                 
					(O) 3-2-8. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)              <-- 기생성
					(X) 3-2-9. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         
					(X) 3-2-10.[P_INV_SIM] Inventory(Simualtion)                       
					(X) 3-2-11.[P_INV_CONFIRM] Inventory(Confirm)   


				3-0. CUTOFF용 전일 대상 추출 ITEM 

				3-1. 기생성 정보 추출 (전날 기 생성된 정보) 

					(O) 3-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)                <-- 기생성 
					(O) 3-1-3. [R_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-1-4. [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(O) 3-1-6. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)  <-- 기생성
				
					(O) 3-2-1. [P_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-2-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)				   <-- 기생성
					(O) 3-2-3. [P_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-2-4. [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(O) 3-2-6. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)  <-- 기생성						
					(O) 3-2-8. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)              <-- 기생성							 


				3-2. Request용 Measure생성(MEASURE_TYPE = R) 실시간,계산용 MEASURE
					(O) 3-2-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
					(O) 3-2-7. [R_SHIP_REQ_ETA] Shipment Request (ETA)   
					(O) 3-2-8. [R_SHIP_PLAN_ETD] Shipment Plan(Out)     
					(O) 3-2-9. [R_INV_SHIP_REQ] Inventory(Ship Req)     
					(O) 3-2-10.[R_INV_SHIP_PLAN] Inventory(Ship Plan)   

				3-3. Plan용 Measure생성(MEASURE_TYPE = P) 실시간,계산용 MEASURE

					(0) 3-3-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
					(O) 3-3-7. [P_SHIP_REQ_ETD] Shipment Request (ETD)                 
					(O) 3-3-9. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         
					(O) 3-3-10.[P_INV_SIM] Inventory(Simualtion)                       
					(O) 3-3-11.[P_INV_CONFIRM] Inventory(Confirm)                        

			  --------------------------------------------------------------------------------------------------------------*/       
			--temp 테이블 생성 : SSP_ANL_SHIP_PLAN_EE insert 용도 (CUTOFF)
			IF OBJECT_ID('tempdb..#TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF') IS NOT NULL
				DROP TABLE #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF

				CREATE TABLE #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
				 COMPANY_ID           NVARCHAR(030)  
				,DIVISION_ID          NVARCHAR(030)  
				,PLANT_ID             NVARCHAR(030)  
				,SCM_SITE_ID          NVARCHAR(030) 
				,MODEL_ID             NVARCHAR(050)  
				,ITEM_ID              NVARCHAR(050)  
				,MEASURE_TYPE         NVARCHAR(001)  --   R :Request 화면용 P:, Plan 화면용
				,MEASURE              NVARCHAR(050)
				,YYYYMMDD             NVARCHAR(008) 
				,QTY                  NUMERIC(20,10)
				,FROM_DIVISION_ID     NVARCHAR(030)  
				,FROM_SITE            NVARCHAR(030)  
				,TO_DIVISION_ID       NVARCHAR(030)  
				,TO_SITE              NVARCHAR(030)  
				,BOD_ID               NVARCHAR(150) 
				,ETD_DATE             NVARCHAR(008)   
				,ETA_DATE             NVARCHAR(008)   
				);


				/*-------------------------------------------------------------------------------------------------------------
				3-0. CUTOFF용 전일 대상 추출  
				   #TMP_PLAN_ITEM_CUTOFF
				--------------------------------------------------------------------------------------------------------------*/ 
				-- Cutoff 용 이전 version  

				---------------------------------------------------------------------------------------------------------------------------
				-- 계획 구간 Start End 일자 (plan_start_yyyymmdd-1 ~ 8주) 			
				DECLARE @v_cutoff_plan_start_yyyymmdd    NVARCHAR(8) = '';
				DECLARE @v_cutoff_plan_end_yyyymmdd   NVARCHAR(8) = '';

				SET    @v_cutoff_plan_start_yyyymmdd  =  CONVERT(char(8), DATEADD(DD, -1, CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)), 112) 
				SET    @v_cutoff_plan_end_yyyymmdd    =  CONVERT(VARCHAR, DATEADD(D,  56, CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112) ; 
				---------------------------------------------------------------------------------------------------------------------------

				---------------------------------------------------------------------------------------------------------------------------
				-- 실적구간 Start End 일자 (plan_start_yyyymmdd-1의 전주월요일  ~ 계획구간 start일자-1) 
				DECLARE @v_result_cutoff_start_yyyymmdd NVARCHAR(8) = '';
				DECLARE @v_result_cutoff_end_yyyymmdd   NVARCHAR(8) = '';

				-- plan_start_yyyymmdd-1의 전주월요일
				SELECT @v_result_cutoff_start_yyyymmdd  = C.BASIS_YYYYMMDD
				FROM   SCM_SYS_CALENDAR_M C WITH(NOLOCK) 
				WHERE  C.ISO_YYYYWW = ( 
										SELECT MIN(ISO_YYYYWW)  AS ISO_YYYYWW
										FROM SCM_SYS_CALENDAR_M  WITH(NOLOCK) 
										WHERE BASIS_YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, -7, CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112) 
										AND   BASIS_YYYYMMDD <=  @v_cutoff_plan_start_yyyymmdd
									  )
				AND  C.DAYOFWEEK = 'MON' 
				; 

				SET     @v_result_cutoff_end_yyyymmdd   = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112) ; 
				---------------------------------------------------------------------------------------------------------------------------



				-- Cutoff 용 이전 FP 기준 정보 추출
				IF OBJECT_ID('tempdb..#TMP_PLAN_ITEM_CUTOFF') IS NOT NULL
				DROP TABLE #TMP_PLAN_ITEM_CUTOFF 

				SELECT DISTINCT  
					   T.COMPANY_ID
				,      T.DIVISION_ID
				,      T.PLANT_ID
				,      T.SCM_SITE_ID 
				,      T.MODEL_ID
				,      T.ITEM_ID
				,      T.MEASURE_TYPE 
				INTO   #TMP_PLAN_ITEM_CUTOFF
				FROM   SSP_ANL_SHIP_PLAN_EE T WITH(NOLOCK) 
				WHERE  PLAN_START_YYYYMMDD = @v_cutoff_plan_start_yyyymmdd
				AND    COMPANY_ID  = @c_company_id
				;

 				/*----------------------------------------------------------------------------------------------------------- 
				 3-1.  기생성 정보 추출 (전날 기 생성된 정보) 
				------------------------------------------------------------------------------------------------------------- 
					(O) 3-1-1. [R_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-1-2. [R_FP_NPC_ASSY_PLAN] Assy Plan(Notching)                <-- 기생성 
					(O) 3-1-3. [R_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-1-4. [R_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(O) 3-1-6. [R_SCP_SHIP_PLAN_ETA] SCP Target (Shipping Target ETA)  <-- 기생성
				
					(O) 3-2-1. [P_SCP_PROD_PLAN] SCP Target (Coater)                   <-- 기생성
					(O) 3-2-2. [P_FP_NPC_ASSY_PLAN] Assy Plan(Notching)				   <-- 기생성
					(O) 3-2-3. [P_FP_COATER_PLAN] Coater Plan                          <-- 기생성 
					(O) 3-2-4. [P_FP_COATER_POST_PLAN] Coater Plan+ Post Yield         <-- 기생성
					(O) 3-2-6. [P_SCP_SHIP_PLAN_ETD] SCP Target (Shipping Target ETD)  <-- 기생성						
					(O) 3-2-8. [P_SHIP_PLAN_SIMU_ETD] Shipment Plan (ETD)              <-- 기생성	
				-------------------------------------------------------------------------------------------------------------*/ 
					-- 기 생성 된 measure 추출 

					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT P.COMPANY_ID           
					,      P.DIVISION_ID          
					,      P.PLANT_ID 
					,      P.SCM_SITE_ID 
					,      P.MODEL_ID             
					,      P.ITEM_ID              
					,      P.MEASURE_TYPE                        
					,      P.MEASURE          
					,      P.YYYYMMDD                              
					,      P.QTY                     
					,      P.FROM_DIVISION_ID                           
					,      P.FROM_SITE                         
					,      P.TO_DIVISION_ID                       
					,      P.TO_SITE                             
					,      P.BOD_ID                           
					,      P.ETD_DATE                          
					,      P.ETA_DATE                     
					FROM   SSP_ANL_SHIP_PLAN_EE P WITH(NOLOCK)      
					WHERE  P.PLAN_START_YYYYMMDD = @v_cutoff_plan_start_yyyymmdd
					AND    P.COMPANY_ID = @c_company_id
					AND    P.MEASURE IN ( 
										 'R_SCP_PROD_PLAN'
										,'P_SCP_PROD_PLAN'
										,'R_FP_NPC_ASSY_PLAN'
										,'P_FP_NPC_ASSY_PLAN'
										,'R_FP_COATER_PLAN'
										,'P_FP_COATER_PLAN'
										,'R_FP_COATER_POST_PLAN'
										,'P_FP_COATER_POST_PLAN'
										,'R_SCP_SHIP_PLAN_ETA'
										,'P_SCP_SHIP_PLAN_ETD'
										,'P_SHIP_PLAN_SIMU_ETD'
										)
					;

 				/*----------------------------------------------------------------------------------------------------------- 
				 3-2. Request용 Measure생성(MEASURE_TYPE = R)
				------------------------------------------------------------------------------------------------------------- 
					(O) 3-2-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
					(O) 3-2-7. [R_SHIP_REQ_ETA] Shipment Request (ETA)   
					(O) 3-2-8. [R_SHIP_PLAN_ETD] Shipment Plan(Out)     
					(O) 3-2-9. [R_INV_SHIP_REQ] Inventory(Ship Req)     
					(O) 3-2-10.[R_INV_SHIP_PLAN] Inventory(Ship Plan)  

				-------------------------------------------------------------------------------------------------------------*/ 
					------------------------------------------------------------------------------------------------------------- 
					--3-2-5. [R_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
					--       Intransit + Ship Confirm + Ship Req  
					--       조립기준 도착 INTRANSIT 
					--       조립기준 TO_SITE : SSP_ANL_SHIP_CONFIRM 
					--       조립기준 TO_SITE : SSP_ANL_SHIP_REQ_EE (확정구간이후) 
					-------------------------------------------------------------------------------------------------------------
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT X.COMPANY_ID           
					,      X.DIVISION_ID          
					,	   X.PLANT_ID   
					,      X.SCM_SITE_ID          
					,      X.MODEL_ID             
					,      X.ITEM_ID              
					,      'R'                       AS MEASURE_TYPE			 
					,      'R_INTRANSIT_ETA'         AS MEASURE              
					,      X.YYYYMMDD  AS YYYYMMDD    
					,      SUM(X.QTY) AS QTY                  
 					,      '-'  AS FROM_DIVISION_ID       
					,      '-'  AS FROM_SITE
					,      '-'  AS TO_DIVISION_ID       
					,      '-'  AS TO_SITE              
					,      '-'  AS BOD_ID               
					,      '-'  AS ETD_DATE              
					,      '-'  AS ETA_DATE
					FROM (   
							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID      
							,      CASE WHEN CONVERT(NVARCHAR(8), V.ETA_DATE, 112)  < @v_cutoff_plan_start_yyyymmdd THEN @v_cutoff_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR(8), V.ETA_DATE, 112) END   AS YYYYMMDD         
							,      ISNULL(V.INTRANSIT_QTY,0)                    AS QTY     
							FROM   #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 
								JOIN SSP_DNM_FP_MRP_INTRANSIT_SN V WITH(NOLOCK) -- SSP_DNM_FP_MRP_INTRANSIT_SN  V WITH(NOLOCK) 
								  ON V.COMPANY_ID  = M.COMPANY_ID
								 AND V.DIVISION_ID = M.DIVISION_ID
								 AND V.PLANT_ID    = M.PLANT_ID
								 AND V.ITEM_ID     = M.ITEM_ID 
								 AND V.INTRANSIT_QTY > 0 
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'R'

							UNION ALL 
							-- Shipment Plan(In)-- CONFIRM 
							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID              
							,      ISNULL(C.ETA_DATE, @v_cutoff_plan_start_yyyymmdd)  AS YYYYMMDD 
							,      ISNULL(C.QTY, 0)                            AS QTY  
							FROM #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 
							  LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
								   ON C.CHANGE_TYPE = 'C'
								  AND C.ETA_DATE >= @v_cutoff_plan_start_yyyymmdd
								  AND C.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd    
								  AND C.TO_SITE  = M.SCM_SITE_ID 
								  AND C.ITEM_ID  = M.ITEM_ID 
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'R'

							UNION ALL 

							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID              
							,      ISNULL(R.ETA_DATE, @v_cutoff_plan_start_yyyymmdd)  AS YYYYMMDD 
							,      ISNULL(R.QTY, 0)                            AS QTY  
							FROM #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 
							  LEFT OUTER JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
								 ON R.TO_DIVISION_ID = M.DIVISION_ID
								AND R.TO_SITE        = M.SCM_SITE_ID
								AND R.ITEM_ID        = M.ITEM_ID
								AND R.CONFIRM_FLAG   <> 'Y' -- CONFIRM된 REQUEST 제외
								AND R.ETA_DATE >= @v_cutoff_plan_start_yyyymmdd
								AND R.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'R'

							--  2020-07-17   kimbk           Receipt(Intransit)+Shipment Plan(In)의 Plan in 값을 Shipment Plan의 Simulation값으로 표시
							--  Division = '40' and From Site = 'A011-E' and To Site = '' 인 정보만 적용
							--  기존 REQ 정보에서 위 정보는 제외 처리 함
							AND  NOT EXISTS (
											SELECT 1
											FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
											WHERE  1 = 1
											AND    B.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
											AND    B.VALID_YN    = 'Y'
											AND    B.SEGMENT2 = '40'
											AND    B.SEGMENT1 = @v_C100		-- 'C100'
											AND    B.SEGMENT3 = @v_A011E	--'A011-E'
											AND    B.SEGMENT5 = '40'
											AND    B.SEGMENT4 = @v_G180		-- 'G180'
											AND    B.ATTRIBUTE1 = @v_G182A	--'G182-A'

											AND R.FROM_DIVISION_ID = B.SEGMENT2
											AND R.FROM_COMPANY_ID = B.SEGMENT1
											AND R.FROM_SITE = B.SEGMENT3
											AND R.TO_DIVISION_ID = B.SEGMENT5
											AND R.TO_COMPANY_ID = B.SEGMENT4
											AND R.TO_SITE = B.ATTRIBUTE1
											)
							UNION ALL

							--  2020-07-17   kimbk           Receipt(Intransit)+Shipment Plan(In)의 Plan in 값을 Shipment Plan의 Simulation값으로 표시
							--  Division = '40' and From Site = 'A011-E' and To Site = '' 인 정보만 적용
							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID              
							,      ISNULL(B.ETA_DATE, @v_cutoff_plan_start_yyyymmdd)  AS YYYYMMDD 
							,      ISNULL(B.QTY, 0)                            AS QTY  
							FROM   #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 
								  LEFT OUTER JOIN 
								   (
									SELECT B.SEGMENT5  AS TO_DIVISION_ID
										 , DBO.[FN_GET_SSP_SITE_INFO](B.SEGMENT5, B.ATTRIBUTE1, 'PLANT_ID')  AS PLANT
										 , B.SEGMENT4  AS TO_COMPANY_ID
										 , B.ATTRIBUTE1  AS SCM_SITE_ID
										 , ISNULL(E.ELECTRODE_TYPE,'-')		AS ELECTRODE_TYPE
										 , E.CELL_TYPE						AS CELL_TYPE
										 , E.MODEL_ID						AS MODEL_ID				
										 , A.ITEM_ID
										 , '-'								AS FROM_SITE
										 , '-'								AS BOD_ID
										 , 'R_INTRANSIT_ETA'					AS MEASURE
										 /*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
										 --, CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](B.SEGMENT2 ,B.SEGMENT3) , CONVERT(DATETIME, A.YYYYMMDD,112)) ,112) AS ETA_DATE
										 , CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, B.SEGMENT2 ,B.SEGMENT3, A.YYYYMMDD) , CONVERT(DATETIME, A.YYYYMMDD,112)) ,112) AS ETA_DATE
										 , A.QTY							AS QTY
										 , A.QTY * ISNULL(E.CONVERT_TO_PCM,  1)		AS QTY_TO_PCM
										 , A.QTY * ISNULL(E.CONVERT_TO_CELL, 1)		AS QTY_TO_CELL
										 , '-'								AS LAST_UPDATED_BY
										 , A.LAST_UPDATE_DATE			 
									FROM   SSP_ANL_SHIP_PLAN_EE A WITH(NOLOCK)  
										  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  

										  ON  B.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
										  AND B.VALID_YN    = 'Y'
										  AND B.SEGMENT2 = '40'
										  AND B.SEGMENT1 = @v_C100		-- 'C100'
										  AND B.SEGMENT3 = @v_A011E		-- 'A011-E'
										  AND B.SEGMENT5 = '40'
										  AND B.SEGMENT4 = @v_G180		-- 'G180'
										  AND B.ATTRIBUTE1 = @v_G182A	-- 'G182-A'
										  AND A.DIVISION_ID = B.SEGMENT2
										  AND A.COMPANY_ID  = B.SEGMENT1
										  AND A.SCM_SITE_ID = B.SEGMENT3

										  LEFT JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
										  ON E.DIVISION_ID	   = A.DIVISION_ID
										  AND E.SCM_SITE_ID	   = A.SCM_SITE_ID
										  AND E.ITEM_ID		   = A.ITEM_ID
									WHERE 1 = 1
									AND   A.PLAN_START_YYYYMMDD = @v_cutoff_plan_start_yyyymmdd
									AND   A.MEASURE = 'P_SHIP_PLAN_SIMU_ETD'
									--AND   A.YYYYMMDD >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](B.SEGMENT2 ,B.SEGMENT3) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) -- @P_PLAN_START_YYYYMMDD
									--AND   A.YYYYMMDD <= @v_cutoff_plan_end_yyyymmdd -- @P_PLAN_END_YYYYMMDD
								   ) B
								 ON B.TO_DIVISION_ID = M.DIVISION_ID
								AND B.SCM_SITE_ID    = M.SCM_SITE_ID
								AND B.ITEM_ID        = M.ITEM_ID
								/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
								--AND B.ETA_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](B.TO_DIVISION_ID ,B.SCM_SITE_ID) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112)) ,112) -- @P_PLAN_START_YYYYMMDD
								AND B.ETA_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, B.TO_DIVISION_ID ,B.SCM_SITE_ID, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd,112)) ,112)
								AND B.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd
							WHERE  M.MEASURE_TYPE  = 'R'
							) X
					WHERE    X.COMPANY_ID = @c_company_id
					GROUP BY X.COMPANY_ID           
					,        X.DIVISION_ID          
					,	     X.PLANT_ID             
					,        X.SCM_SITE_ID             
					,        X.MODEL_ID             
					,        X.ITEM_ID   
					,        X.YYYYMMDD
					;

					------------------------------------------------------------------------------------------------------------- 
					--3-2-7. [R_SHIP_REQ_ETA] Shipment Request (ETA) : 
					--       SSP_ANL_SHIP_REQ_EE 
					-------------------------------------------------------------------------------------------------------------
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT T.COMPANY_ID           
					,      T.DIVISION_ID          
					,      T.PLANT_ID 
					,      T.SCM_SITE_ID 
					,      T.MODEL_ID             
					,      T.ITEM_ID              
					,      'R'                            AS MEASURE_TYPE          
					,      'R_SHIP_REQ_ETA'               AS MEASURE     
					,      R.ETA_DATE                     AS YYYYMMDD              
					,      SUM(R.QTY)                     AS QTY     
					,      R.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
					,      R.FROM_SITE                    AS FROM_SITE            
					,      R.TO_DIVISION_ID               AS TO_DIVISION_ID       
					,      R.TO_SITE                      AS TO_SITE              
					,      R.BOD_ID                       AS BOD_ID               
					,      R.ETD_DATE                     AS ETD_DATE              
					,      R.ETA_DATE                     AS ETA_DATE 
					FROM   #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
					  JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK)
						ON R.TO_DIVISION_ID = T.DIVISION_ID 
					   AND R.TO_SITE        = T.SCM_SITE_ID 
					   AND R.ITEM_ID        = T.ITEM_ID 
					   AND R.ETA_DATE >= @v_result_cutoff_start_yyyymmdd				  
					   AND R.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd
					WHERE  1=1
					AND    T.MEASURE_TYPE = 'R'
					AND    T.COMPANY_ID = @c_company_id
					GROUP BY T.COMPANY_ID           
					,        T.DIVISION_ID          
					,        T.PLANT_ID 
					,        T.SCM_SITE_ID 
					,        T.MODEL_ID             
					,        T.ITEM_ID     
					,        R.FROM_DIVISION_ID                 
					,        R.FROM_SITE                   
					,        R.TO_DIVISION_ID              
					,        R.TO_SITE                      
					,        R.BOD_ID                       
					,        R.ETA_DATE                     
					,        R.ETD_DATE 
					;
					------------------------------------------------------------------------------------------------------------- 
					--3-2-8. [R_SHIP_PLAN_ETD] Shipment Plan(Out) : 출하실적 + 출하 확정 + 출하요청 
					--       기준SITE의 전극 SITE = FROM_SITE 
					--       과거구간 : OWMS 재고 
					--       확정구간 : 출하확정 
					--       확정구간 이후 : 출하확정 + 출하요청
					-------------------------------------------------------------------------------------------------------------  
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT X.COMPANY_ID           
					,      X.DIVISION_ID          
					,      X.PLANT_ID    
					,      X.SCM_SITE_ID
					,      X.MODEL_ID             
					,      X.ITEM_ID              
					,      'R'                                 AS MEASURE_TYPE          
					,      'R_SHIP_PLAN_ETD'                   AS MEASURE     
					,      X.YYYYMMDD                          AS YYYYMMDD              
					,      SUM(X.QTY)                          AS QTY     
					,      X.FROM_DIVISION_ID                  AS FROM_DIVISION_ID       
					,      X.FROM_SITE                         AS FROM_SITE            
					,      X.TO_DIVISION_ID                    AS TO_DIVISION_ID       
					,      X.TO_SITE                           AS TO_SITE              
					,      X.BOD_ID                            AS BOD_ID               
					,      X.ETD_DATE                          AS ETD_DATE              
					,      X.ETA_DATE                          AS ETA_DATE 
					FROM (
          
						-- 출하 실적(OWMS) : 과거 실적구간
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID    
						,      T.SCM_SITE_ID
						,      T.MODEL_ID                         AS MODEL_ID 
						,      V.ITEM_ID                          AS ITEM_ID
						,      V.YYYYMMDD                         AS YYYYMMDD              
						,      V.QTY                              AS QTY     
						,      V.DIVISION_ID                      AS FROM_DIVISION_ID       
						,      V.FROM_SITE                        AS FROM_SITE            
						,      '-'                                AS TO_DIVISION_ID       
						,      '-'                                AS TO_SITE              
						,      '-'                                AS BOD_ID               
						,      '-'                                AS ETD_DATE              
						,      '-'                                AS ETA_DATE 
						FROM #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
						   AND L.VALID_YN    = 'Y'
						   AND L.SEGMENT1    = T.DIVISION_ID   -- 조립 DIVISION 
						   AND L.SEGMENT2    = T.PLANT_ID      -- 조립 PLANT_ID  
						   AND L.ATTRIBUTE1  = T.SCM_SITE_ID   -- 조립 SCM_SITE_ID

						  JOIN  SSP_DNM_SHIP_RESULT_OWMS_V V WITH(NOLOCK) 
							ON V.DIVISION_ID = L.SEGMENT3    -- 전극 DIVISION 
						   AND V.FROM_SITE   = L.ATTRIBUTE2  -- 전극 SCM_SITE_ID 
						   AND V.ITEM_ID     = T.ITEM_ID
						   AND V.YYYYMMDD >= @v_result_cutoff_start_yyyymmdd --@v_cutoff_plan_start_yyyymmdd -- ETD
						   AND V.YYYYMMDD <= @v_result_cutoff_end_yyyymmdd
 
						WHERE 1=1 
						AND   T.MEASURE_TYPE = 'R'
						AND   T.COMPANY_ID = @c_company_id

						UNION ALL 

						-- 출하 확정( @v_cutoff_plan_start_yyyymmdd ~ 전체 )
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID    
						,      T.SCM_SITE_ID
						,      T.MODEL_ID                          AS MODEL_ID 
						,      T.ITEM_ID              
						,      C.YYYYMMDD                          AS YYYYMMDD              
						,      C.QTY                               AS QTY     
						,      C.ORIGIN_FROM_DIVISION_ID           AS FROM_DIVISION_ID       
						,      C.FROM_SITE                         AS FROM_SITE            
						,      C.ORIGIN_TO_DIVISION_ID             AS TO_DIVISION_ID       
						,      C.TO_SITE                           AS TO_SITE              
						,      C.BOD_ID                            AS BOD_ID               
						,      C.ETD_DATE                          AS ETD_DATE              
						,      C.ETA_DATE                          AS ETA_DATE 
						FROM #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
						   AND L.VALID_YN    = 'Y'
						   AND L.SEGMENT1    = T.DIVISION_ID   -- 조립 DIVISION 
						   AND L.SEGMENT2    = T.PLANT_ID      -- 조립 PLANT_ID  
						   AND L.ATTRIBUTE1  = T.SCM_SITE_ID   -- 조립 SCM_SITE_ID 

						  JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
							ON C.DIVISION_ID = L.SEGMENT3    -- 전극 DIVISION 
						   AND C.FROM_SITE   = L.ATTRIBUTE2  -- 전극 SCM_SITE_ID 
						   AND C.ITEM_ID     = T.ITEM_ID
						   AND C.CHANGE_TYPE = 'C'
						   AND C.YYYYMMDD   >= @v_cutoff_plan_start_yyyymmdd  --@v_cutoff_plan_start_yyyymmdd -- ETD
						   AND C.YYYYMMDD   <  @v_cutoff_plan_end_yyyymmdd   

						WHERE 1=1 
						AND   T.MEASURE_TYPE = 'R'
						AND   T.COMPANY_ID = @c_company_id	

						UNION ALL 

						-- 출하요청 ( 확정 구간 이후 ) 
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID 
						,      T.SCM_SITE_ID 
						,      T.MODEL_ID             
						,      T.ITEM_ID              
  						,      R.ETD_DATE                     AS YYYYMMDD              
						,      R.QTY                          AS QTY     
						,      R.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
						,      R.FROM_SITE                    AS FROM_SITE            
						,      R.TO_DIVISION_ID               AS TO_DIVISION_ID       
						,      R.TO_SITE                      AS TO_SITE              
						,      R.BOD_ID                       AS BOD_ID               
						,      R.ETD_DATE                     AS ETD_DATE              
						,      R.ETA_DATE                     AS ETA_DATE 
						FROM #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  
							ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
						   AND L.VALID_YN    = 'Y'
						   AND L.SEGMENT1    = T.DIVISION_ID   -- 조립 DIVISION 
						   AND L.SEGMENT2    = T.PLANT_ID      -- 조립 PLANT_ID  
						   AND L.ATTRIBUTE1  = T.SCM_SITE_ID   -- 조립 SCM_SITE_ID 

						  JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
							ON R.FROM_DIVISION_ID = L.SEGMENT3   -- 전극 DIVISION 
						   AND R.FROM_PLANT_ID    = L.SEGMENT4   -- 전극 PLANT_ID 
						   AND R.FROM_SITE        = L.ATTRIBUTE2 -- 전극 SCM_SITE_ID 
						   AND R.ITEM_ID          = T.ITEM_ID 
						   /*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
						   --AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID ,R.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112)
						   AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID ,R.FROM_SITE, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112) - 1) ,112)
						   AND R.ETD_DATE  < @v_cutoff_plan_end_yyyymmdd
						WHERE 1=1 
						AND   T.MEASURE_TYPE = 'R'
						AND   T.COMPANY_ID = @c_company_id

					) X
					WHERE 1=1 
					GROUP BY X.COMPANY_ID           
					,      X.DIVISION_ID          
					,      X.PLANT_ID    
					,      X.SCM_SITE_ID
					,      X.MODEL_ID             
					,      X.ITEM_ID   
					,      X.YYYYMMDD
					,      X.FROM_DIVISION_ID    
					,      X.FROM_SITE        
					,      X.TO_DIVISION_ID       
					,      X.TO_SITE            
					,      X.BOD_ID             
					,      X.ETD_DATE              
					,      X.ETA_DATE	 
					;

					------------------------------------------------------------------------------------------------------------- 
					--3-2-4. [R_INV_SHIP_REQ] Inventory(Ship Req) 계산 
					-- R_INV_SHIP_REQ(당일) = BOH - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
					-- R_INV_SHIP_REQ(익일) = R_INV_SHIP_REQ(당일) + C_FP_COATER_PLAN(당일) - C_FP_NPC_ASSY_PLAN(익일) - R_SHIP_PLAN_ETD(익일) + R_SHIP_REQ_ETA(익일) 
					-------------------------------------------------------------------------------------------------------------   
					-- Cutoff 용 이전 BOH 정보 추출
					IF OBJECT_ID('tempdb..#TMP_BOH_CUTOFF_EE') IS NOT NULL
					DROP TABLE #TMP_BOH_CUTOFF_EE 

					SELECT  COMPANY_ID 
					,       DIVISION_ID
					,		PLANT_ID
					,		SCM_SITE_ID
					,		MODEL_ID
					,		ITEM_ID
					,       TOT_BOH_QTY 
					,       CUTOFF_DATE
					,       MEASURE_TYPE 
					INTO   #TMP_BOH_CUTOFF_EE 
					FROM   SSP_ANL_BOH_CUTOFF_EE WITH(NOLOCK) 
					WHERE  CUTOFF_DATE = @v_cutoff_plan_start_yyyymmdd
					AND    COMPANY_ID = @c_company_id
					;

					WITH R_INV_SHIP_REQ AS (    -- R_INV_SHIP_REQ(당일) = BOH - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
								SELECT    X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
										, SUM(X.QTY) AS QTY 
								FROM ( 
										-- BOH 
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       TOT_BOH_QTY AS QTY 
										FROM   #TMP_BOH_CUTOFF_EE B WITH(NOLOCK) 
										WHERE  MEASURE_TYPE = 'R'
										AND    CUTOFF_DATE  = @v_cutoff_plan_start_yyyymmdd
										AND    COMPANY_ID = @c_company_id
	
										UNION ALL 
										--  - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일)
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       ISNULL( SUM( CASE WHEN MEASURE = 'R_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'R_SHIP_PLAN_ETD'      THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'R_SHIP_REQ_ETA'       THEN ISNULL(T.QTY,0) 
															  ELSE 0 END  
															) 
														,0) AS QTY 
										FROM   #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
										WHERE  T.MEASURE_TYPE = 'R'
										AND    T.YYYYMMDD  = @v_cutoff_plan_start_yyyymmdd
										AND    T.MEASURE IN ( 'R_FP_NPC_ASSY_PLAN' ,'R_SHIP_PLAN_ETD' , 'R_SHIP_REQ_ETA' ) 
										AND    T.COMPANY_ID = @c_company_id
										GROUP BY T.COMPANY_ID 
												,T.DIVISION_ID
												,T.PLANT_ID
												,T.SCM_SITE_ID
												,T.MODEL_ID
												,T.ITEM_ID
								) X
								GROUP BY X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
								),  
						Z AS (
								SELECT DISTINCT  
								 T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
								FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									LEFT OUTER JOIN (	
														SELECT BASIS_YYYYMMDD AS YYYYMMDD
														FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE  BASIS_YYYYMMDD >= @v_cutoff_plan_start_yyyymmdd	
														AND    BASIS_YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd
													 )  C
												ON C.YYYYMMDD    >= @v_cutoff_plan_start_yyyymmdd	
												AND   C.YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd

								WHERE T.MEASURE_TYPE = 'R'
								AND   T.COMPANY_ID = @c_company_id
								AND   T.YYYYMMDD     >= @v_cutoff_plan_start_yyyymmdd
								GROUP BY T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
							)  

						-- R_INV_SHIP_REQ(익일) = R_INV_SHIP_REQ(전일) - C_FP_COATER_PLAN(전일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) 
						INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
								 COMPANY_ID           
								,DIVISION_ID          
								,PLANT_ID   
								,SCM_SITE_ID 
								,MODEL_ID             
								,ITEM_ID              
								,MEASURE_TYPE
								,MEASURE     
								,YYYYMMDD              
								,QTY                  
								,FROM_DIVISION_ID      
								,FROM_SITE            
								,TO_DIVISION_ID       
								,TO_SITE          
								,BOD_ID               
								,ETD_DATE              
								,ETA_DATE )

						SELECT   
								 Z.COMPANY_ID           
								,Z.DIVISION_ID          
								,Z.PLANT_ID   
								,Z.SCM_SITE_ID 
								,Z.MODEL_ID             
								,Z.ITEM_ID              
								,'R'              AS MEASURE_TYPE
								,'R_INV_SHIP_REQ' AS MEASURE
								,Z.YYYYMMDD  
			----------------------------------------------------
								-- R_INV_SHIP_REQ(전일) 
								,  ISNULL(B.QTY,0) 
								+ 
								-- + C_FP_COATER_PLAN(전일)
								( SELECT ISNULL( SUM(CASE WHEN T.MEASURE = 'R_FP_COATER_PLAN'    THEN  ISNULL(T.QTY,0)  
													 ELSE 0.0 END
													),0)   
									FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE = 'R'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE              IN ('R_FP_COATER_PLAN')
									AND T.YYYYMMDD             >= @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             < Z.YYYYMMDD  

								)  
								+ 
								-- C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) 
								(  SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'R_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
															WHEN T.MEASURE = 'R_SHIP_PLAN_ETD'      THEN ISNULL(T.QTY,0) * -1
															WHEN T.MEASURE = 'R_SHIP_REQ_ETA'       THEN ISNULL(T.QTY,0) 
														ELSE 0.0 END
													 ) ,0)    
									FROM #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE ='R'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE     IN ('R_FP_NPC_ASSY_PLAN', 'R_SHIP_PLAN_ETD' ,'R_SHIP_REQ_ETA' )
									AND T.YYYYMMDD    > @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD    <= Z.YYYYMMDD 
								)  
								,'-'  AS FROM_DIVISION_ID      
								,'-'  AS FROM_SITE            
								,'-'  AS TO_DIVISION_ID       
								,'-'  AS TO_SITE          
								,'-'  AS BOD_ID               
								,'-'  AS ETD_DATE              
								,'-'  AS ETA_DATE 
					--------------------------------------------------------------------------------------------------------------------------------------
					FROM Z WITH(NOLOCK)   
					LEFT OUTER JOIN R_INV_SHIP_REQ B WITH(NOLOCK) 
						 ON Z.COMPANY_ID  = B.COMPANY_ID 
						AND Z.DIVISION_ID = B.DIVISION_ID
						AND Z.PLANT_ID    = B.PLANT_ID
						AND Z.SCM_SITE_ID = B.SCM_SITE_ID
						AND Z.MODEL_ID    = B.MODEL_ID
						AND Z.ITEM_ID     = B.ITEM_ID
					WHERE 1 = 1 
					ORDER BY Z.YYYYMMDD
					;

					------------------------------------------------------------------------------------------------------------- 
					--3-2-5. [R_INV_SHIP_PLAN] Inventory(Ship Plan) 계산 
					-- R_INV_SHIP_PLAN(당일) = BOH + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) 
					-- R_INV_SHIP_PLAN(익일) = R_INV_SHIP_PLAN(전일)  + C_FP_COATER_PLAN(전일) + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) 
					-------------------------------------------------------------------------------------------------------------   
					WITH R_INV_SHIP_PLAN AS (    -- R_INV_SHIP_PLAN(당일) = BOH + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) 
								SELECT  X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
										, SUM(X.QTY) AS QTY 
								FROM ( 
										-- BOH 
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       TOT_BOH_QTY AS QTY 
										FROM   #TMP_BOH_CUTOFF_EE B WITH(NOLOCK) 
										WHERE  MEASURE_TYPE = 'R'  
										AND    CUTOFF_DATE = @v_cutoff_plan_start_yyyymmdd
										AND    COMPANY_ID = @c_company_id
	
										UNION ALL 
										--  + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) + R_SHIP_REQ_ETA(당일) 
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       ISNULL( SUM( CASE WHEN MEASURE = 'R_INTRANSIT_ETA'    THEN ISNULL(T.QTY,0)
																  WHEN MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'R_SHIP_PLAN_ETD'    THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'R_SHIP_REQ_ETA'     THEN ISNULL(T.QTY,0)
															  ELSE 0 END  
															)
														,0) AS QTY 
										FROM   #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
										WHERE  T.MEASURE_TYPE  = 'R'
										AND    T.YYYYMMDD  = @v_cutoff_plan_start_yyyymmdd
										AND    T.MEASURE IN ( 'R_INTRANSIT_ETA' , 'R_FP_NPC_ASSY_PLAN' ,'R_SHIP_PLAN_ETD' , 'R_SHIP_REQ_ETA' ) 
										AND    T.COMPANY_ID = @c_company_id
										GROUP BY T.COMPANY_ID 
												,T.DIVISION_ID
												,T.PLANT_ID
												,T.SCM_SITE_ID
												,T.MODEL_ID
												,T.ITEM_ID
								) X
								GROUP BY X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
								),  
						Z AS (
								SELECT DISTINCT  
								 T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
								FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									LEFT OUTER JOIN (	
														SELECT BASIS_YYYYMMDD AS YYYYMMDD
														FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE  BASIS_YYYYMMDD >= @v_cutoff_plan_start_yyyymmdd	
														AND    BASIS_YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd
													 )  C
												ON C.YYYYMMDD    >= @v_cutoff_plan_start_yyyymmdd	
												AND   C.YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd

								WHERE 1=1 
								AND T.MEASURE_TYPE = 'R'
								AND T.COMPANY_ID = @c_company_id
								AND T.YYYYMMDD     >= @v_cutoff_plan_start_yyyymmdd
								GROUP BY T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
							)  

						-- R_INV_SHIP_PLAN(익일) = R_INV_SHIP_PLAN(전일)  + C_FP_COATER_PLAN(전일) + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) 
						INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
								 COMPANY_ID           
								,DIVISION_ID          
								,PLANT_ID   
								,SCM_SITE_ID 
								,MODEL_ID             
								,ITEM_ID              
								--,NPC_ITEM_ID  
								,MEASURE_TYPE
								,MEASURE     
								,YYYYMMDD              
								,QTY                  
								,FROM_DIVISION_ID      
								,FROM_SITE            
								,TO_DIVISION_ID       
								,TO_SITE          
								,BOD_ID               
								,ETD_DATE              
								,ETA_DATE )

						SELECT   
								 Z.COMPANY_ID           
								,Z.DIVISION_ID          
								,Z.PLANT_ID   
								,Z.SCM_SITE_ID 
								,Z.MODEL_ID             
								,Z.ITEM_ID              
								,'R'              AS MEASURE_TYPE
								,'R_INV_SHIP_PLAN' AS MEASURE
								,Z.YYYYMMDD  
			----------------------------------------------------
								-- R_INV_SHIP_PLAN(전일) 
								,  ISNULL(B.QTY,0) 
								+ 
								-- + C_FP_COATER_PLAN(전일)
								( SELECT ISNULL( SUM(CASE WHEN T.MEASURE = 'R_FP_COATER_PLAN'    THEN  ISNULL(T.QTY,0)  
													 ELSE 0.0 END
													),0)   
									FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE= 'R'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
									--AND ISNULL(T.NPC_ITEM_ID,'') = ISNULL(Z.NPC_ITEM_ID,'')	
 									AND T.MEASURE              IN ('R_FP_COATER_PLAN')
									AND T.YYYYMMDD             >= @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             < Z.YYYYMMDD  

								)  
								+ 
								-- + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - R_SHIP_PLAN_ETD(당일) 
								(  SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'R_INTRANSIT_ETA'    THEN ISNULL(T.QTY,0) 
															WHEN T.MEASURE = 'R_FP_NPC_ASSY_PLAN' THEN ISNULL(T.QTY,0) * -1
															WHEN T.MEASURE = 'R_SHIP_PLAN_ETD'    THEN ISNULL(T.QTY,0) * -1
														ELSE 0.0 END
													 ) ,0)    
									FROM #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE = 'R'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE              IN ('R_INTRANSIT_ETA', 'R_FP_NPC_ASSY_PLAN' ,'R_SHIP_PLAN_ETD' )
									AND T.YYYYMMDD             > @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             <= Z.YYYYMMDD 
								)  
								,'-'  AS FROM_DIVISION_ID      
								,'-'  AS FROM_SITE            
								,'-'  AS TO_DIVISION_ID       
								,'-'  AS TO_SITE          
								,'-'  AS BOD_ID               
								,'-'  AS ETD_DATE              
								,'-'  AS ETA_DATE 
					--------------------------------------------------------------------------------------------------------------------------------------
					FROM Z WITH(NOLOCK)   
					LEFT OUTER JOIN R_INV_SHIP_PLAN  B WITH(NOLOCK) 
						 ON Z.COMPANY_ID  = B.COMPANY_ID 
						AND Z.DIVISION_ID = B.DIVISION_ID
						AND Z.PLANT_ID    = B.PLANT_ID
						AND Z.SCM_SITE_ID = B.SCM_SITE_ID
						AND Z.MODEL_ID    = B.MODEL_ID
						AND Z.ITEM_ID     = B.ITEM_ID
					WHERE 1=1 
					ORDER BY Z.YYYYMMDD
					;

				/*----------------------------------------------------------------------------------------------------------- 
				 3-3. Plan용 Measure생성(MEASURE_TYPE = P)
				------------------------------------------------------------------------------------------------------------- 
					(0) 3-3-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)  
					(O) 3-3-7. [P_SHIP_REQ_ETD] Shipment Request (ETD)                 
					(O) 3-3-9. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD)         
					(O) 3-3-10.[P_INV_SIM] Inventory(Simualtion)                       
					(O) 3-3-11.[P_INV_CONFIRM] Inventory(Confirm)  
				-------------------------------------------------------------------------------------------------------------*/        

					------------------------------------------------------------------------------------------------------------- 
					--3-3-5. [P_INTRANSIT_ETA] Receipt(Intransit)+Shipment Plan(In)
					--       Intransit + Ship Confirm + Ship Req  
					--       전극-> 조립 변경 
					--       조립기준 도착 INTRANSIT 
					--       조립기준 TO_SITE : SSP_ANL_SHIP_CONFIRM 
					--       조립기준 TO_SITE : SSP_ANL_SHIP_REQ_EE (확정구간이후) 
					-------------------------------------------------------------------------------------------------------------
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT X.COMPANY_ID           
					,      X.DIVISION_ID          
					,	   X.PLANT_ID   
					,      X.SCM_SITE_ID          
					,      X.MODEL_ID             
					,      X.ITEM_ID              
					,      'P'                       AS MEASURE_TYPE			 
					,      'P_INTRANSIT_ETA'         AS MEASURE              
					,      X.YYYYMMDD  AS YYYYMMDD    
					,      SUM(X.QTY) AS QTY                  
 					,      '-'  AS FROM_DIVISION_ID       
					,      '-'  AS FROM_SITE
					,      '-'  AS TO_DIVISION_ID       
					,      '-'  AS TO_SITE              
					,      '-'  AS BOD_ID               
					,      '-'  AS ETD_DATE              
					,      '-'  AS ETA_DATE
					FROM ( 

							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID      
							,      CASE WHEN CONVERT(NVARCHAR(8), V.ETA_DATE, 112)  < @v_cutoff_plan_start_yyyymmdd THEN @v_cutoff_plan_start_yyyymmdd ELSE CONVERT(NVARCHAR(8), V.ETA_DATE, 112) END   AS YYYYMMDD         
							,      ISNULL(V.INTRANSIT_QTY,0)                    AS QTY 
   
							FROM   #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 

								JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  -- SEGMENT1:A_DIVISION_ID	,SEGMENT2 : A_PLANT_ID
								  ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
								 AND L.VALID_YN    ='Y'  -- 전극-> 조립 
								 AND L.SEGMENT3    = M.DIVISION_ID  -- 전극 DIVISION
								 AND L.SEGMENT4    = M.PLANT_ID     -- 전극 PLANT_ID
								 AND L.ATTRIBUTE2  = M.SCM_SITE_ID  -- 전극 SCM_SITE_ID	    

								JOIN SSP_DNM_FP_MRP_INTRANSIT_SN  V WITH(NOLOCK) 
								  ON V.DIVISION_ID =  L.SEGMENT1    -- 조립 DIVISION
								 AND V.PLANT_ID    =  L.SEGMENT2    -- 조립 PLANT_ID
								 AND V.ITEM_ID     =  M.ITEM_ID 
								 AND V.INTRANSIT_QTY > 0 
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'P'

							UNION ALL 
						
							-- Shipment Plan(In)
							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID              
							,      ISNULL(C.ETA_DATE, @v_cutoff_plan_start_yyyymmdd)  AS YYYYMMDD 
							,      ISNULL(C.QTY, 0)                            AS QTY  
							FROM #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 

							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  -- SEGMENT1:A_DIVISION_ID	,SEGMENT2 : A_PLANT_ID , ATTRIBUTE1 : A_SCM_SITE_ID 
								  ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
								 AND L.VALID_YN    ='Y'  --전극-> 조립 
								 AND L.SEGMENT3    = M.DIVISION_ID  -- 전극 DIVISION
								 AND L.SEGMENT4    = M.PLANT_ID     -- 전극 PLANT_ID
								 AND L.ATTRIBUTE2  = M.SCM_SITE_ID  -- 전극 SCM_SITE_ID  

							  LEFT OUTER JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
								   ON C.CHANGE_TYPE = 'C'
								  AND C.ETA_DATE >= @v_cutoff_plan_start_yyyymmdd
								  AND C.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd     
								  AND C.ORIGIN_TO_DIVISION_ID = L.SEGMENT1 --S.DIVISION_ID 
								  AND C.TO_SITE               = L.ATTRIBUTE1 -- S.SCM_SITE_ID 
								  AND C.ITEM_ID               = M.ITEM_ID 
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'P'

							UNION ALL 
						
							-- Shipment Request(In)
							SELECT M.COMPANY_ID           
							,      M.DIVISION_ID          
							,      M.PLANT_ID   
							,      M.SCM_SITE_ID 
							,      M.MODEL_ID             
							,      M.ITEM_ID              
							,      ISNULL(R.ETA_DATE, @v_cutoff_plan_start_yyyymmdd)  AS YYYYMMDD 
							,      ISNULL(R.QTY, 0)                            AS QTY  
							FROM #TMP_PLAN_ITEM_CUTOFF M WITH(NOLOCK) 

							JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)  -- SEGMENT1:A_DIVISION_ID	,SEGMENT2 : A_PLANT_ID
								  ON L.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
								 AND L.VALID_YN    ='Y'  --전극-> 조립 
								 AND L.SEGMENT3    = M.DIVISION_ID  -- 전극 DIVISION
								 AND L.SEGMENT4    = M.PLANT_ID     -- 전극 PLANT_ID
								 AND L.ATTRIBUTE2  = M.SCM_SITE_ID  -- 전극 SCM_SITE_ID  

							  LEFT OUTER JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
								   ON R.TO_DIVISION_ID = L.SEGMENT1 --S.DIVISION_ID 
								  AND R.TO_SITE        = L.ATTRIBUTE1 -- S.SCM_SITE_ID 
								  AND R.ITEM_ID        = M.ITEM_ID 
								  AND R.ETA_DATE       >= @v_cutoff_plan_start_yyyymmdd-- CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID ,R.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112)
								  AND R.ETA_DATE       < @v_cutoff_plan_end_yyyymmdd
								  AND R.CONFIRM_FLAG <> 'Y' --  CONFIRM된 REQUEST 제외 
							WHERE  1=1 
							AND    M.MEASURE_TYPE  = 'P'
						  ) X
					WHERE    X.COMPANY_ID = @c_company_id 
					GROUP BY X.COMPANY_ID           
					,        X.DIVISION_ID          
					,	     X.PLANT_ID             
					,        X.SCM_SITE_ID             
					,        X.MODEL_ID             
					,        X.ITEM_ID   
					,        X.YYYYMMDD
					;

					------------------------------------------------------------------------------------------------------------- 
					--3-3-7. [P_SHIP_REQ_ETD] Shipment Request (ETD)
					--        #TMP_PLAN_ITEM_CUTOFF.SCM_SITE_ID = 출하요청의 FROM_SITE
					-------------------------------------------------------------------------------------------------------------   
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )
					SELECT T.COMPANY_ID           
					,      T.DIVISION_ID          
					,      T.PLANT_ID 
					,      T.SCM_SITE_ID 
					,      T.MODEL_ID             
					,      T.ITEM_ID              
					,      'P'                            AS MEASURE_TYPE          
					,      'P_SHIP_REQ_ETD'               AS MEASURE     
					,      R.ETD_DATE                     AS YYYYMMDD              
					,      SUM(R.QTY)                     AS QTY     
					,      R.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
					,      R.FROM_SITE                    AS FROM_SITE            
					,      R.TO_DIVISION_ID               AS TO_DIVISION_ID       
					,      R.TO_SITE                      AS TO_SITE              
					,      R.BOD_ID                       AS BOD_ID               
					,      R.ETD_DATE                     AS ETD_DATE              
					,      R.ETA_DATE                     AS ETA_DATE 
					FROM   #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
					   JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK)
						 ON R.FROM_DIVISION_ID = T.DIVISION_ID 
						AND R.FROM_SITE = T.SCM_SITE_ID
						AND R.ITEM_ID   = T.ITEM_ID 
						AND R.ETA_DATE >= @v_result_cutoff_start_yyyymmdd  -- @v_cutoff_plan_start_yyyymmdd
						AND R.ETA_DATE  < @v_cutoff_plan_end_yyyymmdd
					WHERE T.MEASURE_TYPE  = 'P'
					AND   T.COMPANY_ID = @c_company_id
					GROUP BY T.COMPANY_ID           
					,        T.DIVISION_ID          
					,        T.PLANT_ID 
					,        T.SCM_SITE_ID 
					,        T.MODEL_ID             
					,        T.ITEM_ID     
					,        R.FROM_DIVISION_ID                 
					,        R.FROM_SITE                   
					,        R.TO_DIVISION_ID              
					,        R.TO_SITE                      
					,        R.BOD_ID                       
					,        R.ETA_DATE                     
					,        R.ETD_DATE 
					;

					------------------------------------------------------------------------------------------------------------- 
					--3-3-4. [P_SHIP_CONFIRM_ETD] Shipment Plan Confirm(ETD) : 출하실적 + 출하 확정 + 출하요청 
					--        #TMP_PLAN_ITEM_CUTOFF.SCM_SITE_ID  = 출하확정의 FROM_SITE
					--       과거구간 : OWMS 재고 
					--       확정구간 : 출하확정 
					--       확정구간 이후 : 출하확정 + 출하요청
					-------------------------------------------------------------------------------------------------------------   
					INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
						   COMPANY_ID           
						  ,DIVISION_ID          
						  ,PLANT_ID   
						  ,SCM_SITE_ID 
						  ,MODEL_ID             
						  ,ITEM_ID              
						  ,MEASURE_TYPE
						  ,MEASURE     
						  ,YYYYMMDD              
						  ,QTY                  
						  ,FROM_DIVISION_ID      
						  ,FROM_SITE            
						  ,TO_DIVISION_ID       
						  ,TO_SITE          
						  ,BOD_ID               
						  ,ETD_DATE              
						  ,ETA_DATE )

					SELECT X.COMPANY_ID           
					,      X.DIVISION_ID          
					,      X.PLANT_ID    
					,      X.SCM_SITE_ID
					,      X.MODEL_ID             
					,      X.ITEM_ID              
					,      'P'                                 AS MEASURE_TYPE          
					,      'P_SHIP_CONFIRM_ETD'                   AS MEASURE     
					,      X.YYYYMMDD                          AS YYYYMMDD              
					,      SUM(X.QTY)                          AS QTY     
					,      X.FROM_DIVISION_ID                  AS FROM_DIVISION_ID       
					,      X.FROM_SITE                         AS FROM_SITE            
					,      X.TO_DIVISION_ID                    AS TO_DIVISION_ID       
					,      X.TO_SITE                           AS TO_SITE              
					,      X.BOD_ID                            AS BOD_ID               
					,      X.ETD_DATE                          AS ETD_DATE              
					,      X.ETA_DATE                          AS ETA_DATE 
					FROM (
          
						-- 출하 실적(OWMS) : 실적구간
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID    
						,      T.SCM_SITE_ID
						,      T.MODEL_ID                          AS MODEL_ID 
						,      T.ITEM_ID                           AS ITEM_ID     
						,      V.YYYYMMDD                          AS YYYYMMDD              
						,      V.QTY                               AS QTY     
						,      V.DIVISION_ID                       AS FROM_DIVISION_ID       
						,      V.FROM_SITE                         AS FROM_SITE            
						,      '-'                                 AS TO_DIVISION_ID       
						,      '-'                                 AS TO_SITE              
						,      '-'                                 AS BOD_ID               
						,      '-'                                 AS ETD_DATE              
						,      '-'                                 AS ETA_DATE 
						FROM   #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						   JOIN SSP_DNM_SHIP_RESULT_OWMS_V V WITH(NOLOCK) 	
							 ON V.DIVISION_ID = T.DIVISION_ID 
							AND V.FROM_SITE   = T.SCM_SITE_ID 
							AND V.ITEM_ID     = T.ITEM_ID 					
							AND V.YYYYMMDD    >= @v_result_cutoff_start_yyyymmdd --@v_cutoff_plan_start_yyyymmdd -- ETD
							AND V.YYYYMMDD    <= @v_result_cutoff_end_yyyymmdd					
						WHERE T.MEASURE_TYPE  = 'P'
						AND   T.COMPANY_ID = @c_company_id		

						UNION ALL 

						-- 출하 확정( @v_cutoff_plan_start_yyyymmdd ~ 전체 )
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID    
						,      T.SCM_SITE_ID
						,      T.MODEL_ID                   AS MODEL_ID 
						,      T.ITEM_ID                    AS ITEM_ID     
						,      C.YYYYMMDD                   AS YYYYMMDD              
						,      C.QTY                        AS QTY     
						,      C.DIVISION_ID                AS FROM_DIVISION_ID       
						,      C.FROM_SITE                  AS FROM_SITE            
						,      C.ORIGIN_TO_DIVISION_ID      AS TO_DIVISION_ID       
						,      C.TO_SITE                    AS TO_SITE              
						,      C.BOD_ID                     AS BOD_ID               
						,      C.ETD_DATE                   AS ETD_DATE              
						,      C.ETA_DATE                   AS ETA_DATE 

						FROM   #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						   JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  
							 ON C.DIVISION_ID = T.DIVISION_ID 
							AND C.FROM_SITE   = T.SCM_SITE_ID 
							AND C.ITEM_ID     = T.ITEM_ID 
							AND C.CHANGE_TYPE = 'C'
							AND C.YYYYMMDD  >= @v_cutoff_plan_start_yyyymmdd  --@v_cutoff_plan_start_yyyymmdd -- ETD
							AND C.YYYYMMDD  <  @v_cutoff_plan_end_yyyymmdd  

  						WHERE T.MEASURE_TYPE  = 'P'
						AND   T.COMPANY_ID = @c_company_id		

						UNION ALL 
				   
						-- 출하요청 ( 확정구간 이후 ~ ) 
						SELECT T.COMPANY_ID           
						,      T.DIVISION_ID          
						,      T.PLANT_ID 
						,      T.SCM_SITE_ID 
						,      T.MODEL_ID                     AS MODEL_ID         
						,      T.ITEM_ID                      AS ITEM_ID            
  						,      R.ETD_DATE                     AS YYYYMMDD              
						,      R.QTY                          AS QTY     
						,      R.FROM_DIVISION_ID             AS FROM_DIVISION_ID       
						,      R.FROM_SITE                    AS FROM_SITE            
						,      R.TO_DIVISION_ID               AS TO_DIVISION_ID       
						,      R.TO_SITE                      AS TO_SITE              
						,      R.BOD_ID                       AS BOD_ID               
						,      R.ETD_DATE                     AS ETD_DATE              
						,      R.ETA_DATE                     AS ETA_DATE 
						FROM   #TMP_PLAN_ITEM_CUTOFF T WITH(NOLOCK) 
						   JOIN SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK)
							 ON R.FROM_DIVISION_ID = T.DIVISION_ID 
							AND R.FROM_SITE   = T.SCM_SITE_ID 
							AND R.ITEM_ID     = T.ITEM_ID 
							/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
							--AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID ,R.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112)
							AND R.ETD_DATE >= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd, 112) - 1), 112)
							AND R.ETD_DATE  < @v_cutoff_plan_end_yyyymmdd
						WHERE  T.MEASURE_TYPE  = 'P'
						AND    T.COMPANY_ID = @c_company_id


					) X
					WHERE 1=1 
					GROUP BY X.COMPANY_ID           
					,      X.DIVISION_ID          
					,      X.PLANT_ID    
					,      X.SCM_SITE_ID
					,      X.MODEL_ID             
					,      X.ITEM_ID   
					,      X.YYYYMMDD
					,      X.FROM_DIVISION_ID    
					,      X.FROM_SITE        
					,      X.TO_DIVISION_ID       
					,      X.TO_SITE            
					,      X.BOD_ID             
					,      X.ETD_DATE              
					,      X.ETA_DATE	 
					;


					------------------------------------------------------------------------------------------------------------- 
					--3-3-5. [P_INV_SIM] Inventory(Simualtion) 
					-- P_INV_SIM(당일) = BOH + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
					-- P_INV_SIM(익일) = P_INV_SIM(전일) +  P_FP_COATER_PLAN(전일) +  P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
					-------------------------------------------------------------------------------------------------------------   
					WITH P_INV_SIM AS (    -- BOH + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
								SELECT  X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
										, SUM(X.QTY) AS QTY 
								FROM ( 
										-- BOH 
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       TOT_BOH_QTY AS QTY 
										FROM   #TMP_BOH_CUTOFF_EE B WITH(NOLOCK) 
										WHERE  MEASURE_TYPE = 'P'
										AND    CUTOFF_DATE = @v_cutoff_plan_start_yyyymmdd
										AND    COMPANY_ID = @c_company_id
	
										UNION ALL 
										-- + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       ISNULL( SUM( CASE WHEN MEASURE = 'P_INTRANSIT_ETA'      THEN ISNULL(T.QTY,0)
																  WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN ISNULL(T.QTY,0) * -1
															  ELSE 0 END  
															)
														,0) AS QTY 
										FROM   #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
										WHERE  T.MEASURE_TYPE = 'P'
										AND    T.YYYYMMDD  = @v_cutoff_plan_start_yyyymmdd
										AND    T.MEASURE IN ( 'P_INTRANSIT_ETA' , 'P_FP_NPC_ASSY_PLAN' ,'P_SHIP_PLAN_SIMU_ETD' ) 
										AND    T.COMPANY_ID = @c_company_id 
										GROUP BY T.COMPANY_ID 
												,T.DIVISION_ID
												,T.PLANT_ID
												,T.SCM_SITE_ID
												,T.MODEL_ID
												,T.ITEM_ID
								) X
								GROUP BY X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
								),  
						Z AS (
								SELECT DISTINCT  
								 T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
								FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									LEFT OUTER JOIN (	
														SELECT BASIS_YYYYMMDD AS YYYYMMDD
														FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE  BASIS_YYYYMMDD >= @v_cutoff_plan_start_yyyymmdd	
														AND    BASIS_YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd
													 )  C
												ON C.YYYYMMDD    >= @v_cutoff_plan_start_yyyymmdd	
												AND   C.YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd

								WHERE 1=1 
								AND T.MEASURE_TYPE = 'P'
								AND T.COMPANY_ID = @c_company_id
								AND T.YYYYMMDD     >= @v_cutoff_plan_start_yyyymmdd
								GROUP BY T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
							)  

						-- P_INV_SIM(익일) = P_INV_SIM(전일) +  P_FP_COATER_PLAN(전일) +  P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
						INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
								 COMPANY_ID           
								,DIVISION_ID          
								,PLANT_ID   
								,SCM_SITE_ID 
								,MODEL_ID             
								,ITEM_ID              
								,MEASURE_TYPE
								,MEASURE     
								,YYYYMMDD              
								,QTY                  
								,FROM_DIVISION_ID      
								,FROM_SITE            
								,TO_DIVISION_ID       
								,TO_SITE          
								,BOD_ID               
								,ETD_DATE              
								,ETA_DATE )

						SELECT   
								 Z.COMPANY_ID           
								,Z.DIVISION_ID          
								,Z.PLANT_ID   
								,Z.SCM_SITE_ID 
								,Z.MODEL_ID             
								,Z.ITEM_ID              
								,'P'              AS MEASURE_TYPE
								,'P_INV_SIM'      AS MEASURE
								,Z.YYYYMMDD  
			----------------------------------------------------
								-- P_INV_SIM(전일) 
								,  ISNULL(B.QTY,0) 
								+ 
								-- + C_FP_COATER_PLAN(전일)
								( SELECT ISNULL( SUM(CASE WHEN T.MEASURE = 'P_FP_COATER_PLAN'    THEN  ISNULL(T.QTY,0)  
													 ELSE 0.0 END
													),0)   
									FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1 
									AND T.MEASURE_TYPE ='P' 
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
									--AND ISNULL(T.NPC_ITEM_ID,'') = ISNULL(Z.NPC_ITEM_ID,'')	
 									AND T.MEASURE              IN ('P_FP_COATER_PLAN')
									AND T.YYYYMMDD             >= @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             < Z.YYYYMMDD  

								)  
								+ 
								-- P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_PLAN_SIMU_ETD(당일)
								(  SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'P_INTRANSIT_ETA'      THEN ISNULL(T.QTY,0) 
															WHEN T.MEASURE = 'P_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
															WHEN T.MEASURE = 'P_SHIP_PLAN_SIMU_ETD' THEN ISNULL(T.QTY,0) * -1
														ELSE 0.0 END
													 ) ,0)    
									FROM #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE  = 'P'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE              IN ('P_INTRANSIT_ETA', 'P_FP_NPC_ASSY_PLAN' ,'P_SHIP_PLAN_SIMU_ETD' )
									AND T.YYYYMMDD             > @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             <= Z.YYYYMMDD 
								)  
								,'-'  AS FROM_DIVISION_ID      
								,'-'  AS FROM_SITE            
								,'-'  AS TO_DIVISION_ID       
								,'-'  AS TO_SITE          
								,'-'  AS BOD_ID               
								,'-'  AS ETD_DATE              
								,'-'  AS ETA_DATE 
					--------------------------------------------------------------------------------------------------------------------------------------
					FROM Z WITH(NOLOCK)   
					LEFT OUTER JOIN P_INV_SIM B WITH(NOLOCK) 
						 ON Z.COMPANY_ID  = B.COMPANY_ID 
						AND Z.DIVISION_ID = B.DIVISION_ID
						AND Z.PLANT_ID    = B.PLANT_ID
						AND Z.SCM_SITE_ID = B.SCM_SITE_ID
						AND Z.MODEL_ID    = B.MODEL_ID
						AND Z.ITEM_ID     = B.ITEM_ID
					WHERE 1=1 
					ORDER BY Z.YYYYMMDD
					;




					------------------------------------------------------------------------------------------------------------- 
					--3-3-6. [P_INV_CONFIRM] Inventory(Confirm)
					-- P_INV_CONFIRM(당일) = BOH + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)
					-- P_INV_CONFIRM(익일) = P_INV_CONFIRM(전일) + P_FP_COATER_PLAN(전일) + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)			
					-------------------------------------------------------------------------------------------------------------   
					WITH P_INV_CONFIRM AS (   -- BOH + C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)
								SELECT  X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
										, SUM(X.QTY) AS QTY 
								FROM ( 
										-- BOH 
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       TOT_BOH_QTY AS QTY 
										FROM   #TMP_BOH_CUTOFF_EE B WITH(NOLOCK) 
										WHERE  MEASURE_TYPE  ='P'
										AND    CUTOFF_DATE = @v_cutoff_plan_start_yyyymmdd
										AND    COMPANY_ID = @c_company_id  
	
										UNION ALL 
										-- + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)
										SELECT  COMPANY_ID 
										,       DIVISION_ID
										,		PLANT_ID
										,		SCM_SITE_ID
										,		MODEL_ID
										,		ITEM_ID
										,       ISNULL( SUM( CASE WHEN MEASURE = 'P_INTRANSIT_ETA'      THEN ISNULL(T.QTY,0)
																  WHEN MEASURE = 'P_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
																  WHEN MEASURE = 'P_SHIP_CONFIRM_ETD'   THEN ISNULL(T.QTY,0) * -1
															  ELSE 0 END  
															)
														,0) AS QTY 
										FROM   #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
										WHERE  T.MEASURE_TYPE ='P'
										AND    T.YYYYMMDD  = @v_cutoff_plan_start_yyyymmdd
										AND    T.MEASURE IN ( 'P_INTRANSIT_ETA' , 'P_FP_NPC_ASSY_PLAN' ,'P_SHIP_CONFIRM_ETD' ) 
										AND    T.COMPANY_ID = @c_company_id
										GROUP BY T.COMPANY_ID 
												,T.DIVISION_ID
												,T.PLANT_ID
												,T.SCM_SITE_ID
												,T.MODEL_ID
												,T.ITEM_ID
								) X
								GROUP BY X.COMPANY_ID 
										, X.DIVISION_ID
										, X.PLANT_ID
										, X.SCM_SITE_ID
										, X.MODEL_ID
										, X.ITEM_ID
								),  
						Z AS (
								SELECT DISTINCT  
								 T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
								FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									LEFT OUTER JOIN (	
														SELECT BASIS_YYYYMMDD AS YYYYMMDD
														FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
														WHERE  BASIS_YYYYMMDD >= @v_cutoff_plan_start_yyyymmdd	
														AND    BASIS_YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd
													 )  C
												ON C.YYYYMMDD    >= @v_cutoff_plan_start_yyyymmdd	
												AND   C.YYYYMMDD <  @v_cutoff_plan_end_yyyymmdd

								WHERE 1=1 
								AND T.MEASURE_TYPE ='P'
								AND T.COMPANY_ID = @c_company_id
								AND T.YYYYMMDD     >= @v_cutoff_plan_start_yyyymmdd
								GROUP BY T.COMPANY_ID 
								,T.DIVISION_ID
								,T.PLANT_ID
								,T.SCM_SITE_ID
								,T.MODEL_ID
								,T.ITEM_ID
								,C.YYYYMMDD
							)  

						-- P_INV_CONFIRM(익일) = P_INV_CONFIRM(전일) + P_FP_COATER_PLAN(전일) + P_INTRANSIT_ETA(당일) - P_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)		
						INSERT INTO #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF (
								 COMPANY_ID           
								,DIVISION_ID          
								,PLANT_ID   
								,SCM_SITE_ID 
								,MODEL_ID             
								,ITEM_ID              
								,MEASURE_TYPE
								,MEASURE     
								,YYYYMMDD              
								,QTY                  
								,FROM_DIVISION_ID      
								,FROM_SITE            
								,TO_DIVISION_ID       
								,TO_SITE          
								,BOD_ID               
								,ETD_DATE              
								,ETA_DATE )

						SELECT   
								 Z.COMPANY_ID           
								,Z.DIVISION_ID          
								,Z.PLANT_ID   
								,Z.SCM_SITE_ID 
								,Z.MODEL_ID             
								,Z.ITEM_ID              
								,'P'                 AS MEASURE_TYPE
								,'P_INV_CONFIRM'      AS MEASURE
								,Z.YYYYMMDD  
			----------------------------------------------------
								-- P_INV_CONFIRM(전일) 
								,  ISNULL(B.QTY,0) 
								+ 
								-- + C_FP_COATER_PLAN(전일)
								( SELECT ISNULL( SUM(CASE WHEN T.MEASURE = 'P_FP_COATER_PLAN'    THEN  ISNULL(T.QTY,0)  
													 ELSE 0.0 END
													),0)   
									FROM  #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE ='P'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE              IN ('P_FP_COATER_PLAN')
									AND T.YYYYMMDD             >= @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             < Z.YYYYMMDD  

								)  
								+ 
								-- C_INTRANSIT_ETA(당일) - C_FP_NPC_ASSY_PLAN(당일) - P_SHIP_CONFIRM_ETD(당일)	
								(  SELECT ISNULL( SUM( CASE WHEN T.MEASURE = 'P_INTRANSIT_ETA'      THEN ISNULL(T.QTY,0) 
															WHEN T.MEASURE = 'P_FP_NPC_ASSY_PLAN'   THEN ISNULL(T.QTY,0) * -1
															WHEN T.MEASURE = 'P_SHIP_CONFIRM_ETD'   THEN ISNULL(T.QTY,0) * -1
														ELSE 0.0 END
													 ) ,0)    
									FROM #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH(NOLOCK)
									WHERE 1=1  
									AND T.MEASURE_TYPE ='P'
									AND T.COMPANY_ID  = Z.COMPANY_ID 
									AND T.DIVISION_ID = Z.DIVISION_ID
									AND T.PLANT_ID    = Z.PLANT_ID
									AND T.SCM_SITE_ID = Z.SCM_SITE_ID
									AND T.MODEL_ID    = Z.MODEL_ID
									AND T.ITEM_ID     = Z.ITEM_ID
 									AND T.MEASURE              IN ('P_INTRANSIT_ETA', 'P_FP_NPC_ASSY_PLAN' ,'P_SHIP_CONFIRM_ETD' )
									AND T.YYYYMMDD             > @v_cutoff_plan_start_yyyymmdd	
									AND T.YYYYMMDD             <= Z.YYYYMMDD 
								)  
								,'-'  AS FROM_DIVISION_ID      
								,'-'  AS FROM_SITE            
								,'-'  AS TO_DIVISION_ID       
								,'-'  AS TO_SITE          
								,'-'  AS BOD_ID               
								,'-'  AS ETD_DATE              
								,'-'  AS ETA_DATE 
					--------------------------------------------------------------------------------------------------------------------------------------
					FROM Z WITH(NOLOCK)   
					LEFT OUTER JOIN P_INV_CONFIRM B WITH(NOLOCK) 
						 ON Z.COMPANY_ID  = B.COMPANY_ID 
						AND Z.DIVISION_ID = B.DIVISION_ID
						AND Z.PLANT_ID    = B.PLANT_ID
						AND Z.SCM_SITE_ID = B.SCM_SITE_ID
						AND Z.MODEL_ID    = B.MODEL_ID
						AND Z.ITEM_ID     = B.ITEM_ID
					WHERE 1=1 
					ORDER BY Z.YYYYMMDD
					;

				/*----------------------------------------------------------------------------------------------------------- 
				 3-4. SSP_ANL_SHIP_PLAN_EE 생성(CUTOFF)
				------------------------------------------------------------------------------------------------------------- 

				-------------------------------------------------------------------------------------------------------------*/

				DELETE FROM SSP_ANL_SHIP_PLAN_EE  
				WHERE  PLAN_START_YYYYMMDD = @v_cutoff_plan_start_yyyymmdd 
				AND    COMPANY_ID = @c_company_id
				;

				INSERT INTO SSP_ANL_SHIP_PLAN_EE(
				 PLAN_START_YYYYMMDD
				,COMPANY_ID
				,DIVISION_ID
				,PLANT_ID
				,SCM_SITE_ID
				,MODEL_ID
				,ITEM_ID
				,MEASURE_TYPE
				,MEASURE
				,YYYYMMDD
				,QTY
				,QTY_TO_PCM
				,QTY_TO_CELL
				,FROM_DIVISION_ID
				,FROM_SITE
				,TO_DIVISION_ID
				,TO_SITE
				,BOD_ID
				,ELECTRODE_TYPE
				,ETD_DATE
				,ETA_DATE
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10         								  	
				)
				SELECT 	 
				 @v_cutoff_plan_start_yyyymmdd  -- PLAN_START_YYYYMMDD
				,T.COMPANY_ID
				,T.DIVISION_ID
				,T.PLANT_ID
				,T.SCM_SITE_ID
				,T.MODEL_ID
				,T.ITEM_ID
				,T.MEASURE_TYPE
				,T.MEASURE
				,T.YYYYMMDD
				,ROUND(T.QTY, 0) AS QTY 
				,CEILING(T.QTY * ISNULL(E.CONVERT_TO_PCM, 1))   AS QTY_TO_PCM 							
				,CEILING(T.QTY * ISNULL(E.CONVERT_TO_CELL, 1))  AS QTY_TO_CELL 	
				,T.FROM_DIVISION_ID
				,T.FROM_SITE
				,T.TO_DIVISION_ID
				,T.TO_SITE
				,T.BOD_ID
				,(SELECT MAX(F.ELECTRODE_TYPE) 
					FROM   SCM_MST_FINAL_ITEM_V F WITH(NOLOCK) 
					WHERE F.ITEM_ID = T.ITEM_ID ) AS ELECTRODE_TYPE
				,T.ETD_DATE
				,T.ETA_DATE
				,@v_batch_user        -- CREATED_BY
				,GETDATE()            -- CREATION_DATE
				,@v_batch_user        -- LAST_UPDATED_BY
				,GETDATE()            -- T.LAST_UPDATE_DATE
				,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL  
				FROM #TMP_SSP_ANL_SHIP_PLAN_EE_CUTOFF T WITH (NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LR WITH(NOLOCK) -- R 
						ON LR.LOOKUP_TYPE = 'ELECTRODE_ASSY_PLANT_MAPPING' 
					--AND LR.VALID_YN    = 'Y'
					AND LR.SEGMENT1    = T.DIVISION_ID  -- 조립 DIVISION 
					AND LR.SEGMENT2    = T.PLANT_ID     -- 조립 PLANT_ID 
					AND LR.ATTRIBUTE1  = T.SCM_SITE_ID  -- 조립 SCM_SITE_ID  

					LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
						ON CASE WHEN T.MEASURE_TYPE = 'R' THEN  LR.SEGMENT3   ELSE T.DIVISION_ID END =  E.DIVISION_ID 
					AND CASE WHEN T.MEASURE_TYPE = 'R' THEN  LR.ATTRIBUTE2 ELSE T.SCM_SITE_ID END =  E.SCM_SITE_ID  
					AND E.ITEM_ID     = T.ITEM_ID
				WHERE 1=1
				AND   T.COMPANY_ID = @c_company_id
				;



				--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE(CURRENT_PLAN_DATE_YN)
				UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE
				SET    CURRENT_PLAN_DATE_YN  = 'Y'
				,      LAST_UPDATE_DATE      = GETDATE()
				,      LAST_UPDATED_BY       = @v_batch_user
				WHERE COMPANY_ID  = @c_company_id
				AND   PLAN_START_YYYYMMDD   = @v_plan_start_yyyymmdd
				;


				--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE (PLAN_CUTOFF_CREATE_YN)
				UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE
				SET    PLAN_CUTOFF_CREATE_YN   = 'Y'
				,      PLAN_CUTOFF_CREATE_DATE = GETDATE() 
				,      LAST_UPDATE_DATE        = GETDATE()
				,      LAST_UPDATED_BY         = @v_batch_user
				WHERE COMPANY_ID  = @c_company_id
				AND   PLAN_START_YYYYMMDD   = @v_cutoff_plan_start_yyyymmdd
				;


			/*------------------------------------------------------------------------------------------------------------- 
			4. 확정 데이터 생성 및 ERP 전송
			--------------------------------------------------------------------------------------------------------------    
			4-1. SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_H 생성 
			4-2. ERP 전송 데이터 생성
			4-3. SSP_ANL_SHIP_REQ_EE  CONFIRM_ID,FLAG UPDATE 
			-------------------------------------------------------------------------------------------------------------*/

				/*----------------------------------------------------------------------------------------------------------- 
				  4-1. SSP_ANL_SHIP_CONFIRM, SSP_ANL_SHIP_CONFIRM_H 생성 
				------------------------------------------------------------------------------------------------------------- 

				-------------------------------------------------------------------------------------------------------------*/  
				IF OBJECT_ID('tempdb..#TMP_SSP_ANL_SHIP_CONFIRM_EE') IS NOT NULL
					DROP TABLE #TMP_SSP_ANL_SHIP_CONFIRM_EE

				CREATE TABLE #TMP_SSP_ANL_SHIP_CONFIRM_EE(
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
							,REQUEST_ID                   nvarchar(020)
							,PACKAGE_TYPE_CODE            nvarchar(030)
							,FACTORY_ID                   nvarchar(030)
							,SALES_COMPANY_ID             nvarchar(030) -- 전극 3자거래 구분위함 ERP 송신 I/F 테이블에만 활용 
							/*----------------------------------------------------------------------------------------
								2020.06.30 : KBK
								I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							------------------------------------------------------------------------------------------*/
							,PACKAGE_QTY	              numeric(20,10)
							,DOM_EXP	                  nvarchar(30)
							,ERP_ATTR1	                  nvarchar(150)
							,ERP_ATTR2	                  nvarchar(150)
							,ERP_ATTR3	                  nvarchar(150)
							,ERP_ATTR4	                  nvarchar(150)
							,ERP_ATTR5	                  nvarchar(150)
						   );

				INSERT INTO #TMP_SSP_ANL_SHIP_CONFIRM_EE (
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
							,REQUEST_ID  
							,PACKAGE_TYPE_CODE 
							,FACTORY_ID 
							,SALES_COMPANY_ID						
							/*----------------------------------------------------------------------------------------
								2020.06.30 : KBK
								I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							------------------------------------------------------------------------------------------*/
							,PACKAGE_QTY
							,DOM_EXP
							,ERP_ATTR1
							,ERP_ATTR2
							,ERP_ATTR3
							,ERP_ATTR4
							,ERP_ATTR5
							)
				SELECT 	 'C'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_CONFIRM_ID),6)      AS CONFIRM_ID			 
						,'C'							AS SHIPMENT_STATUS
						,R.FROM_DIVISION_ID				AS DIVISION_ID 
						,@v_cutoff_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
						,'SP'							AS PLAN_TYPE
						,1								AS SEQ
						,R.ITEM_ID
						,R.FROM_SITE
						,R.TO_SITE
						,R.ETD_DATE						AS YYYYMMDD
						,R.QTY							AS PLANNED_QTY
						,R.QTY							AS QTY
						,R.BOD_ID
						,B.ROUTE_ID
						,'E'							AS BIZ_TYPE
						,'-'							AS PROJECT_CODE
						,'-'							AS FCST_TYPE
						,R.ETD_DATE						AS FCST_ETD_DATE
						,R.ETA_DATE						AS FCST_ETA_DATE
						,R.ETD_DATE
						,R.ETA_DATE
						--,B.INCOTERMS
						,B.SSP_INCOTERMS                AS INCOTERMS
						,B.TRANSPORT_MODE
						,B.D_COUNTRY
						,B.D_PORT_CODE
						,B.A_COUNTRY
						,B.A_PORT_CODE
						,B.LT_TOTAL_ORIGIN		AS  CUSTOMER_LT
						,B.TO_COUNTRY
						,B.TO_CITY
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'SITE_TYPE')   AS FROM_SITE_TYPE  
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'PLANT_ID')    AS FROM_SITE_PLANT_ID   
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'VENDOR_ID')   AS FROM_SITE_VENDOR_ID  
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'COMPANY_ID')  AS FROM_SITE_COMPANY_ID 
						,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.TO_DIVISION_ID, R.FROM_SITE,R.TO_SITE, 'SITE_TYPE')     AS TO_SITE_TYPE  -- [E20250821-001308]-- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용
						,[DBO].[FN_GET_SSP_SITE_INFO](R.TO_DIVISION_ID, R.TO_SITE, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
						,[DBO].[FN_GET_SSP_SITE_INFO](R.TO_DIVISION_ID, R.TO_SITE, 'VENDOR_ID')     AS TO_SITE_VENDOR_ID  
						,[DBO].[FN_GET_SSP_SITE_INFO](R.TO_DIVISION_ID, R.TO_SITE, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
						,[DBO].[FN_GET_SSP_SITE_INFO](R.TO_DIVISION_ID, R.TO_SITE, 'SHIPTO_CODE')   AS TO_SITE_SHIPTO_CODE
						,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.TO_DIVISION_ID,R.FROM_SITE, R.TO_SITE, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID -- [E20250821-001308]-- TO_COMPANY_ID를 FROM_SITE에 따라 다르게 적용하는 예외를 적용
						,'N' AS CONFIRM_TYPE  -- 신규확정
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'COUNTRY') AS COUNTRY      --FROM SITE의 COUNTRY
						,[DBO].[FN_GET_SSP_SITE_INFO](R.FROM_DIVISION_ID, R.FROM_SITE, 'COMPANY_ID') AS COMPANY_ID  --FROM SITE의 COMPANY_ID
						,[DBO].[FN_GET_SSP_SITE_INFO](R.TO_DIVISION_ID, R.TO_SITE, 'VMI_YN')    AS  VMI_YN     --TO SITE
						,'Y' AS ELECTRODE_YN            
						,E.ELECTRODE_TYPE AS ELECTRODE_TYPE				   
						,R.FROM_DIVISION_ID AS ORIGIN_FROM_DIVISION_ID	
						,R.TO_DIVISION_ID AS ORIGIN_TO_DIVISION_ID
						,NULL AS BEFORE_QTY                   
						,NULL AS REMARKS                      
						,'Y'   AS CHECK_NEED_YN 
						,CASE WHEN R.LAST_UPDATED_BY = 'SCP FN Plan' THEN @v_batch_user ELSE R.LAST_UPDATED_BY END AS REQUESTOR
						,R.REQUEST_ID
						,E.PACKAGE_TYPE_CODE 
						,E.FACTORY_ID
						,CASE WHEN L.ATTRIBUTE2 ='' THEN NULL ELSE L.ATTRIBUTE2 END  -- SALES_COMPANY_ID
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,CEILING(CASE WHEN E.PACKAGE_TYPE_CODE = 'BX' THEN CEILING(R.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.BOX_PER_CUT ,1)
 									  WHEN E.PACKAGE_TYPE_CODE = 'SC' THEN CEILING(R.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELCRATE_PER_CUT ,1)
 									  WHEN E.PACKAGE_TYPE_CODE = 'SR' THEN CEILING(R.QTY * isnull(E.CONVERT_TO_PC_ROLL_LENGTH ,1) ) * isnull(E.STEELRACK_PER_CUT ,1)
 						 ELSE ISNULL(R.QTY,0)  END)		AS PACKAGE_QTY
						,E.DOM_EXP_TYPE AS DOM_EXP
						,NULL       AS ERP_ATTR1
						,NULL       AS ERP_ATTR2
						,NULL       AS ERP_ATTR3
						,NULL       AS ERP_ATTR4
						,NULL       AS ERP_ATTR5
				FROM   SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 

					JOIN SCM_MST_SITE FS WITH(NOLOCK) 
					  ON FS.DIVISION_ID = R.FROM_DIVISION_ID
					 AND FS.SCM_SITE_ID = R.FROM_SITE 

					JOIN SCP_MST_BOD_N_V  B WITH(NOLOCK) 
						 ON  B.DIVISION_ID  = R.FROM_DIVISION_ID 
						AND  B.BOD_ID       = R.BOD_ID

					LEFT OUTER JOIN SSP_MST_SITE_ITEM_EE_V E WITH(NOLOCK) 
						 ON E.DIVISION_ID = R.FROM_DIVISION_ID 
						AND E.SCM_SITE_ID = R.FROM_SITE 
						AND E.ITEM_ID     = R.ITEM_ID 
                
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK) 
						 ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO' 
						AND L.VALID_YN   = 'Y'
						AND L.SEGMENT2   = R.FROM_DIVISION_ID 
						AND L.SEGMENT3   = R.FROM_SITE
						AND L.SEGMENT5   = R.TO_DIVISION_ID 
						AND L.ATTRIBUTE1 = R.TO_SITE 
					
				WHERE  1=1 
				AND    FS.COMPANY_ID = @c_company_id  -- FROM_SITE의 COMPANY
				/*확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16*/
				--AND    [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE) > 0 -- 확정일자 0이상인것만 
				AND    [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) > 0 -- 확정일자 0이상인것만 
				AND    ISNULL(R.CONFIRM_FLAG,'N') = 'N' 
				AND    R.QTY > 0 
				--AND    R.ETD_DATE <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.FROM_DIVISION_ID,R.FROM_SITE) , CONVERT(DATETIME, @v_cutoff_plan_start_yyyymmdd ,112)) ,112)
				AND    R.ETD_DATE <= CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_ANL_SHIP_FROZEN_DAY_CNT](@v_app_type, R.FROM_DIVISION_ID,R.FROM_SITE, @v_plan_start_yyyymmdd) , CONVERT(DATETIME, @v_plan_start_yyyymmdd ,112) - 1) ,112)
				;


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
						,PACKAGE_TYPE_CODE
						,FACTORY_ID
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,PACKAGE_QTY
						,DOM_EXP
						,ERP_ATTR1
						,ERP_ATTR2
						,ERP_ATTR3
						,ERP_ATTR4
						,ERP_ATTR5
				  )
				  SELECT CONFIRM_ID
						,'C' -- 확정:C , 계획 : P
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
						,GETDATE()  -- CREATION_DATE   
						,@v_batch_user    -- LAST_UPDATED_BY
						,GETDATE()  -- LAST_UPDATE_DATE
						,ELECTRODE_YN            
						,ELECTRODE_TYPE				   
						,ORIGIN_FROM_DIVISION_ID	
						,ORIGIN_TO_DIVISION_ID	
						,BEFORE_QTY             
						,REMARKS   
						,CHECK_NEED_YN   
						,REQUESTOR
						,PACKAGE_TYPE_CODE 
						,FACTORY_ID
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,PACKAGE_QTY
						,DOM_EXP
						,ERP_ATTR1
						,ERP_ATTR2
						,ERP_ATTR3
						,ERP_ATTR4
						,ERP_ATTR5
				  FROM  #TMP_SSP_ANL_SHIP_CONFIRM_EE  WITH (NOLOCK)
				  WHERE  CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
				  ;

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
						,PACKAGE_TYPE_CODE 
						,FACTORY_ID
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,PACKAGE_QTY
						,DOM_EXP
						,ERP_ATTR1
						,ERP_ATTR2
						,ERP_ATTR3
						,ERP_ATTR4
						,ERP_ATTR5
					)
					SELECT NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_CONFIRM_H  -- HISTORY_SEQ
						,CONFIRM_ID
						,'C'
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
						,GETDATE()  -- CREATION_DATE
						,@v_batch_user    -- LAST_UPDATED_BY
						,GETDATE()    -- LAST_UPDATE_DATE
						,GETDATE()    -- HISTORY_CREATION_DATE
						,ELECTRODE_YN            
						,ELECTRODE_TYPE				   
						,ORIGIN_FROM_DIVISION_ID	
						,ORIGIN_TO_DIVISION_ID
						,BEFORE_QTY             
						,REMARKS   
						,CHECK_NEED_YN  
						,REQUESTOR	
						,PACKAGE_TYPE_CODE 
						,FACTORY_ID									
						/*----------------------------------------------------------------------------------------
							2020.06.30 : KBK
							I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
						------------------------------------------------------------------------------------------*/
						,PACKAGE_QTY
						,DOM_EXP
						,ERP_ATTR1
						,ERP_ATTR2
						,ERP_ATTR3
						,ERP_ATTR4
						,ERP_ATTR5
					FROM #TMP_SSP_ANL_SHIP_CONFIRM_EE WITH (NOLOCK)
				   WHERE CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
					;

				/*----------------------------------------------------------------------------------------------------------- 
				 4-2. ERP 전송 데이터 생성 
				------------------------------------------------------------------------------------------------------------- 
				  INSERT XIF_ERP_SHIP_PLAN_CONFIRM_S_SN 
				  UPDATE SSP_ANL_SHIP_REQ_EE : COMFIRM_ID, CONFIRM_FLAG UPDATE 
				  UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE : CONFIRM_CREATE_YN, CONFIRM_CREATE_DATE 
				-------------------------------------------------------------------------------------------------------------*/ 
				--CURSOR 선언 

				DECLARE @v_infseqno					NVARCHAR(14);	

				DECLARE @company_id VARCHAR(30),  @yyyymmdd VARCHAR(8)
				DECLARE @idx_01 INT     SET     @idx_01 = 0 


				DECLARE CUR_ERP_S CURSOR FOR  
				SELECT   C.COMPANY_ID
				,        MAX(C.YYYYMMDD) AS YYYYMMDD 
				FROM  #TMP_SSP_ANL_SHIP_CONFIRM_EE C WITH(NOLOCK) 
				WHERE 1=1 
				AND   C.COMPANY_ID  = @c_company_id
				AND   C.CONFIRM_TYPE = 'N'  -- 신규건만 전송 
				GROUP BY   C.COMPANY_ID
				;

				OPEN CUR_ERP_S; 

				FETCH NEXT FROM CUR_ERP_S INTO @company_id , @yyyymmdd

				WHILE(@@FETCH_STATUS = 0) 

				BEGIN 
					--Idx 1씩 증가 
					SET @idx_01 = @idx_01 + 1 

					-- IFSEQNO 생성
					--SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '00000'+ CONVERT(VARCHAR,ISNULL(MAX(RIGHT(IFSEQNO,6)),0)+1 ) ,6)
					--  FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN  WITH(NOLOCK)
					-- WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

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
						SELECT @v_infseqno  AS  IFSEQNO -- IFSEQNO
							   ,A.CONFIRM_ID
							   ,'A'     -- I_PLGB  A: 확정  
							   ,@yyyymmdd   AS LAST_CONFIRM_DATE -- I_DATE  확정구간 마지막 일자 
							   ,'B'-- VERSION_TYPE  -- B:NEW/A:OLD 
							   ,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID  -- SALES_COMPANY_ID  전극일 경우만 LOOKUP(ELECTRODE_SHIP_FROM_TO) 의 SALES_COMPANY_ID 에 등록된 경우 값 전송 
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
							   ,'TBD'    --PROJECT_CODE --전극경우 PROJECT_CODE가 없음 default TBD로 전송(  
							   ,A.FCST_TYPE
							   ,A.FCST_ETD_DATE
							   ,A.FCST_ETA_DATE
							   ,A.ETD_DATE
							   ,A.ETA_DATE
							   ,A.INCOTERMS
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
							   ,ISNULL(X4.NEW_VALUE1, A.FROM_SITE_PLANT_ID)			AS FROM_SITE_PLANT_ID
							   ,ISNULL(X5.NEW_VALUE1, A.FROM_SITE_VENDOR_ID)		AS FROM_SITE_VENDOR_ID
							   ,ISNULL(X6.NEW_VALUE1, A.FROM_SITE_SOLDTO_CODE)		AS FROM_SITE_SOLDTO_CODE
							   ,ISNULL(X7.NEW_VALUE1, A.FROM_SITE_SHIPTO_CODE)		AS FROM_SITE_SHIPTO_CODE
							   ,ISNULL(X8.NEW_VALUE1, A.FROM_SITE_COMPANY_ID)		AS FROM_SITE_COMPANY_ID
							   ,A.TO_SITE_TYPE
							   ,ISNULL(X9.NEW_VALUE1, A.TO_SITE_PLANT_ID)			AS TO_SITE_PLANT_ID
							   ,ISNULL(X10.NEW_VALUE1, A.TO_SITE_VENDOR_ID)			AS TO_SITE_VENDOR_ID
							   ,ISNULL(X11.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)		AS TO_SITE_SOLDTO_CODE
							   ,ISNULL(X12.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)		AS TO_SITE_SHIPTO_CODE
							   ,ISNULL(X13.NEW_VALUE1, A.TO_SITE_COMPANY_ID)		AS TO_SITE_COMPANY_ID
							   ,NULL AS BUILDING
							   ,NULL AS REMARK
							   ,NULL AS CUSTOMER_REQ
							   ,NULL AS CHANGE_CODE
							   ,NULL AS CHANGE_CODE_NAME
							   ,A.REQUESTOR     -- REQUESTOR
							   ,'N'           -- TRANSFER_FLAG
							   ,GETDATE()     -- TRANSFER_DATE
							   ,@v_batch_user -- CREATED_BY
							   ,GETDATE()     -- CREATION_DATE
							   ,@v_batch_user -- LAST_UPDATED_BY
							   ,GETDATE()     -- LAST_UPDATE_DATE
							   ,NULL -- ATTRIBUTE1
							   ,NULL -- ATTRIBUTE2
							   ,NULL -- ATTRIBUTE3
							   ,NULL -- ATTRIBUTE4
							   ,NULL -- ATTRIBUTE5
							   ,NULL -- ATTRIBUTE6
							   ,NULL -- ATTRIBUTE7
							   ,NULL -- ATTRIBUTE8
							   ,NULL -- ATTRIBUTE9
							   ,A.ELECTRODE_YN -- ATTRIBUTE10
							   /*----------------------------------------------------------------------------------------
				           		2020.06.30 : KBK
				           		I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							   ------------------------------------------------------------------------------------------*/
							   ,A.PACKAGE_TYPE  
							   ,A.FACTORY_ID									
							   ,A.PACKAGE_QTY
							   ,A.DOM_EXP
							   ,A.ERP_ATTR1
							   ,A.ERP_ATTR2
							   ,A.ERP_ATTR3
							   ,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
							   ,A.ERP_ATTR5
						FROM
						(
						 SELECT C.CONFIRM_ID
							   ,C.SALES_COMPANY_ID  -- SALES_COMPANY_ID  전극일 경우만 LOOKUP(ELECTRODE_SHIP_FROM_TO) 의 SALES_COMPANY_ID 에 등록된 경우 값 전송 
							   ,D.ATTRIBUTE3  AS DIVISION_ID
							   ,C.ITEM_ID
							   ,C.FROM_SITE
							   ,C.TO_SITE
							   ,C.YYYYMMDD
							   ,C.QTY
							   ,C.BOD_ID
							   ,C.ROUTE_ID
							   ,C.BIZ_TYPE AS OPERATION_GROUP
							   ,C.BIZ_TYPE
							   ,C.FCST_TYPE
							   ,C.FCST_ETD_DATE
							   ,C.FCST_ETA_DATE
							   ,C.ETD_DATE
							   ,C.ETA_DATE
							   ,CASE WHEN C.VMI_YN = 'Y' THEN ISNULL([dbo].[FN_GET_SSP_MKT_FCST_INCOTERMS]( CASE WHEN C.DIVISION_ID = 'EE' THEN C.ORIGIN_FROM_DIVISION_ID
																											   ELSE C.DIVISION_ID
																											   END 
				           																				, C.FROM_SITE, C.TO_SITE, C.ITEM_ID
				           																				, C.PROJECT_CODE
				           																				, C.FCST_TYPE
				           																				, C.YYYYMMDD), C.INCOTERMS ) 
				           			 ELSE INCOTERMS 
									 END					AS INCOTERMS
							   ,C.TRANSPORT_MODE
							   ,C.D_COUNTRY
							   ,C.D_PORT_CODE
							   ,C.A_COUNTRY
							   ,C.A_PORT_CODE
							   ,C.CUSTOMER_LT
							   ,C.TO_COUNTRY
							   ,C.TO_CITY
							   ,C.FROM_SITE_TYPE
							   ,C.FROM_SITE_PLANT_ID
							   ,C.FROM_SITE_VENDOR_ID
							   ,C.FROM_SITE_SOLDTO_CODE
							   ,C.FROM_SITE_SHIPTO_CODE
							   ,C.FROM_SITE_COMPANY_ID
							   ,C.TO_SITE_TYPE
							   ,C.TO_SITE_PLANT_ID
							   ,C.TO_SITE_VENDOR_ID
							   ,C.TO_SITE_SOLDTO_CODE
							   ,C.TO_SITE_SHIPTO_CODE
							   ,C.TO_SITE_COMPANY_ID
							   ,C.REQUESTOR     -- REQUESTOR
							   ,C.ELECTRODE_YN -- ATTRIBUTE10
							   /*----------------------------------------------------------------------------------------
				           		2020.06.30 : KBK
				           		I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함 
							   ------------------------------------------------------------------------------------------*/
							   ,C.PACKAGE_TYPE_CODE  AS PACKAGE_TYPE
							   ,C.FACTORY_ID									
							   ,C.PACKAGE_QTY
							   ,C.DOM_EXP
							   ,C.ERP_ATTR1
							   ,C.ERP_ATTR2
							   ,C.ERP_ATTR3
							   ,C.ERP_ATTR4
							   ,C.ERP_ATTR5
						   FROM #TMP_SSP_ANL_SHIP_CONFIRM_EE AS C WITH(NOLOCK)
								JOIN SCM_MST_DIVISION AS D WITH(NOLOCK)
							 ON C.ORIGIN_FROM_DIVISION_ID = D.DIVISION_ID
						  WHERE 1 = 1 
							AND C.CONFIRM_TYPE		= 'N' -- 신규 확정건인 경우
							AND C.COMPANY_ID		=  @company_id
							AND ISNULL(C.QTY,0)		<> 0  -- 0은IF 제외  
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

				/*----------------------------------------------------------------------------------------------------------- 
				 4-3. SSP_ANL_SHIP_REQ_EE  CONFIRM_ID,FLAG UPDATE 
				------------------------------------------------------------------------------------------------------------- 
				-------------------------------------------------------------------------------------------------------------*/ 			

				UPDATE SSP_ANL_SHIP_REQ_EE 
				SET    CONFIRM_ID   = C.CONFIRM_ID
				,      CONFIRM_FLAG = 'Y'
				FROM   SSP_ANL_SHIP_REQ_EE R WITH(NOLOCK) 
				   JOIN #TMP_SSP_ANL_SHIP_CONFIRM_EE C WITH(NOLOCK) 
					 ON C.REQUEST_ID  = R.REQUEST_ID 

					JOIN SCM_MST_SITE FS WITH(NOLOCK) 
					  ON FS.DIVISION_ID = R.FROM_DIVISION_ID
					 AND FS.SCM_SITE_ID = R.FROM_SITE 

				WHERE   1=1 
				AND    FS.COMPANY_ID = @c_company_id  -- FROM_SITE의 COMPANY
				AND    ISNULL(R.CONFIRM_FLAG,'N') = 'N' 
				AND    R.QTY > 0 
				;				  


				--UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE (CONFIRM_CREATE_YN)
				UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE
				SET    CONFIRM_CREATE_YN = 'Y'
				,      CONFIRM_CREATE_DATE = GETDATE()
				,      ATTRIBUTE1 = 'CONFIRM_CREATE_YN UPDATE: '+ @c_company_id + ' : '+ @v_cutoff_plan_start_yyyymmdd 
				WHERE COMPANY_ID = @c_company_id
				AND   PLAN_START_YYYYMMDD = @v_cutoff_plan_start_yyyymmdd 
				;

				/**************************************************************************************************************** 
				-- 2020.07.20 전극 SITE 별 미사용 STORAGE 정보관리                   
				***************************************************************************************************************/ 
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					  LOOKUP_TYPE
					 ,SEGMENT1
					 ,SEGMENT2
					 ,SEGMENT3
					 ,SEGMENT4
					 ,SEGMENT5
					 ,DISPLAY_SEQ
					 ,VALID_YN
					 ,DESCRIPTION
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY 
					 ,LAST_UPDATE_DATE
					 ,ATTRIBUTE1 
				)
				SELECT distinct A.LOOKUP_TYPE
					 ,A.SEGMENT1
					 ,A.SEGMENT2
					 ,A.SEGMENT3
					 ,A.SEGMENT4
					 ,A.SEGMENT5
					 ,A.DISPLAY_SEQ
					 ,A.VALID_YN
					 ,A.DESCRIPTION
					 ,A.CREATED_BY
					 ,A.CREATION_DATE
					 ,A.LAST_UPDATED_BY 
					 ,A.LAST_UPDATE_DATE
					 ,A.ATTRIBUTE1 
				FROM   (
						-- SHIPMENT PLAN'
						select  distinct 
								'ELECTRODE_SHIP_STORAGE'   AS LOOKUP_TYPE
						,       X.PLANT_ID     AS SEGMENT1  -- STORAGE_PLANT
						,       X.FROM_SITE    AS SEGMENT2  -- STORAGE_SITE
						,       ISNULL(X.STORAGE_ID, '-')   AS SEGMENT3  -- STORAGE_ID
						,       X.JOB_TYPE     AS SEGMENT4  -- JOB_TYPE
						,       X.SOURCE_SYSTEM AS SEGMENT5  -- SOURCE_SYSTEM

						,       0 AS DISPLAY_SEQ          
/*
						,       CASE WHEN X.JOB_TYPE = 'R' AND X.SOURCE_SYSTEM = 'oWMS' THEN 'N'
									 WHEN X.JOB_TYPE = 'R' AND X.SOURCE_SYSTEM = 'iWMS' AND X.FROM_SITE = 'G481-A' AND X.STORAGE_ID = '100X' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'iWMS' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = 'A011-E' AND X.STORAGE_ID = '310H' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = 'A011-E' AND X.STORAGE_ID = '320W' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = 'A011-E' AND X.STORAGE_ID = '312W' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = 'A041-E' AND X.STORAGE_ID = '310N' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = 'A041-E' AND X.STORAGE_ID = '320N' THEN 'N'
									 ELSE 'Y' END AS VALID_YN     -- 310H,320W,312W
*/
						,       CASE WHEN X.JOB_TYPE = 'R' AND X.SOURCE_SYSTEM = 'oWMS' THEN 'N'
									 WHEN X.JOB_TYPE = 'R' AND X.SOURCE_SYSTEM = 'iWMS' AND X.FROM_SITE = @v_G481A AND X.STORAGE_ID = @v_G481A_100X THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'iWMS' THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = @v_A011E AND X.STORAGE_ID = @v_A011E_310H THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = @v_A011E AND X.STORAGE_ID = @v_A011E_320W THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = @v_A011E AND X.STORAGE_ID = @v_A011E_312W THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = @v_A011E AND X.STORAGE_ID = @v_A041E_310N THEN 'N'
									 WHEN X.JOB_TYPE = 'P' AND X.SOURCE_SYSTEM = 'GMES' AND X.FROM_SITE = @v_A011E AND X.STORAGE_ID = @v_A041E_320N THEN 'N'
									 ELSE 'Y' END AS VALID_YN     -- 310H,320W,312W
						,       NULL AS DESCRIPTION

						,       @v_program_name AS CREATED_BY
						,       GETDATE()   AS CREATION_DATE
						,       @v_program_name AS LAST_UPDATED_BY
						,       GETDATE()   AS LAST_UPDATE_DATE
						,       X.DIVISION_ID  AS ATTRIBUTE1 -- SOURCE_DIVISION
						from (
								select  distinct 
										division_id 
								,       plant_id 
								,       FROM_SITE
								,       storage_id  storage_id 
								,       'oWMS'  as source_system 
								,       CASE WHEN SUBSTRING(FROM_SITE, CHARINDEX('-', FROM_SITE)+1, 1) = 'A' THEN 'R'
										ELSE 'P' END AS JOB_TYPE
								from   ssp_dnm_owms_stock_ee (NOLOCK)
								where  yyyymmdd = @v_plan_start_yyyymmdd
								and COMPANY_ID = @c_company_id
								union all
								select  distinct 
										division_id 
								,       plant_id 
								,       FROM_SITE
								,       erp_sloc_id  storage_id 
								,       'iWMS'  as source_system 
								,       CASE WHEN SUBSTRING(FROM_SITE, CHARINDEX('-', FROM_SITE)+1, 1) = 'A' THEN 'R'
										ELSE 'P' END AS JOB_TYPE
								from   ssp_dnm_iwms_stock_ee (NOLOCK)
								where  yyyymmdd = @v_plan_start_yyyymmdd
								and COMPANY_ID = @c_company_id
								union all
								select  distinct 
										division_id 
								,       plant_id 
								,       FROM_SITE
								,       storage_id_erp  storage_id 
								,       'GMES'  as source_system 
								,       CASE WHEN SUBSTRING(FROM_SITE, CHARINDEX('-', FROM_SITE)+1, 1) = 'A' THEN 'R'
										ELSE 'P' END AS JOB_TYPE
								from   SSP_DNM_GMES_STOCK_EE (NOLOCK)
								where  yyyymmdd = @v_plan_start_yyyymmdd
								and COMPANY_ID  = @c_company_id
							   ) x
						WHERE  1 = 1
					   ) A
				WHERE  1 = 1
					and    NOT EXISTS (
									   SELECT 1
									   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B (nolock)
									   WHERE  B.LOOKUP_TYPE = A.LOOKUP_TYPE
									   AND    B.SEGMENT1 = A.SEGMENT1
									   AND    B.SEGMENT2 = A.SEGMENT2
									   AND    B.SEGMENT3 = A.SEGMENT3
									   AND    B.SEGMENT4 = A.SEGMENT4
									   AND    B.SEGMENT5 = A.SEGMENT5
									  )

				-- oWMS JOB_TYPE = 'P' 인 정보를 JOB_TYPE = 'R' FH EMDFHR
				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					  LOOKUP_TYPE
					 ,SEGMENT1
					 ,SEGMENT2
					 ,SEGMENT3
					 ,SEGMENT4
					 ,SEGMENT5
					 ,DISPLAY_SEQ
					 ,VALID_YN
					 ,DESCRIPTION
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY 
					 ,LAST_UPDATE_DATE
					 ,ATTRIBUTE1 
					 )
					select LOOKUP_TYPE
					 ,SEGMENT1
					 ,SEGMENT2
					 ,SEGMENT3
					 ,'R'      AS SEGMENT4
					 ,SEGMENT5
					 ,DISPLAY_SEQ
					 ,'N'
					 ,DESCRIPTION
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY 
					 ,LAST_UPDATE_DATE
					 ,ATTRIBUTE1 
					from   SCM_ADM_LOOKUP_MASTER_DETAIL A (nolock)
					where  LOOKUP_TYPE = 'ELECTRODE_SHIP_STORAGE'
					and    SEGMENT5 = 'oWMS'
					and    SEGMENT4 = 'P'
					and    NOT EXISTS (
									   SELECT 1
									   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B (nolock)
									   WHERE  B.LOOKUP_TYPE = A.LOOKUP_TYPE
									   AND    B.SEGMENT1 = A.SEGMENT1
									   AND    B.SEGMENT2 = A.SEGMENT2
									   AND    B.SEGMENT3 = A.SEGMENT3
									   AND    B.SEGMENT4 = 'R'
									   AND    B.SEGMENT5 = A.SEGMENT5
									  )

				INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
					  LOOKUP_TYPE
					 ,SEGMENT1
					 ,SEGMENT2
					 ,SEGMENT3
					 ,SEGMENT4
					 ,SEGMENT5
					 ,DISPLAY_SEQ
					 ,VALID_YN
					 ,DESCRIPTION
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY 
					 ,LAST_UPDATE_DATE
					 ,ATTRIBUTE1 
					 )
					select LOOKUP_TYPE
					 ,SEGMENT1
					 ,SEGMENT2
					 ,SEGMENT3
					 ,'P'      AS SEGMENT4
					 ,SEGMENT5
					 ,DISPLAY_SEQ
					 ,'N'
					 ,DESCRIPTION
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY 
					 ,LAST_UPDATE_DATE
					 ,ATTRIBUTE1 
					from   SCM_ADM_LOOKUP_MASTER_DETAIL A (nolock)
					where  LOOKUP_TYPE = 'ELECTRODE_SHIP_STORAGE'
					and    SEGMENT5 = 'iWMS'
					and    SEGMENT4 = 'R'
					and    NOT EXISTS (
									   SELECT 1
									   FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B (nolock)
									   WHERE  B.LOOKUP_TYPE = A.LOOKUP_TYPE
									   AND    B.SEGMENT1 = A.SEGMENT1
									   AND    B.SEGMENT2 = A.SEGMENT2
									   AND    B.SEGMENT3 = A.SEGMENT3
									   AND    B.SEGMENT4 = 'P'
									   AND    B.SEGMENT5 = A.SEGMENT5
									  )

				------------------------------------------------------------------------------------------------------------- 
				-- 7. SHIP_CONFIRM_ROUTE 입력 : 출하확정계획물류경로기본 SSP_ANL_SHIP_CONFIRM_ROUTE
				-- 
				------------------------------------------------------------------------------------------------------------- 

				DELETE FROM @TAB_CONFIRM_ROUTE;

				INSERT INTO @TAB_CONFIRM_ROUTE (confirm_id, route_id)
				SELECT confirm_id, route_id
				  FROM #TMP_SSP_ANL_SHIP_CONFIRM_EE WITH (NOLOCK)
			     WHERE CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
					 ;

				SELECT @V_INX			= min(tid)
					  ,@V_MAX_NUM		= max(tid)
				  FROM @TAB_CONFIRM_ROUTE

				 WHILE @V_INX <= @V_MAX_NUM
				 BEGIN

				     SELECT @lv_confirm_id			= confirm_id	
					       ,@lv_route_id			= route_id		
					   FROM @TAB_CONFIRM_ROUTE 
					  WHERE TID						= @V_INX

					 EXEC [dbo].[PR_SSP_ANL_SHIP_CONFIRM_ROUTE] @lv_confirm_id, @lv_route_id;

					 SET @V_INX		= @V_INX + 1
				 END


			SET @INX = @INX + 1

		END  --end of while loop

		------------------------------------------------------------------------------------------------------------- 
		--4 SMS 전송 : Daily Plan  END (51)
		--50 Daily Plan Start 
		--51 Daily Plan End 
		--52 Daily Plan Error 
		-------------------------------------------------------------------------------------------------------------
 		-- 25-04-14 End 제외
		--SET @v_sms_desc = 'Electrode:'+ @v_company_id;
		--EXEC SCM_ADM_SMS_SEND_BATCH 51, @v_sms_desc;


        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
        BEGIN
			COMMIT TRAN TX_SH;
        END;       

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- ▶ 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;      

    END
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

			--IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WITH(NOLOCK) WHERE CURSOR_NAME = 'CUR_FP_S')
			--	BEGIN
			--	   CLOSE CUR_FP_S ;
			--	   DEALLOCATE CUR_FP_S ;
			--	END
        END;
		      
		-- ERROR LOG
		SET @v_log_type = N'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
		                          ,@p_log_type      =@v_log_type
		                          ,@p_log_count     =@n_log_count 
		                          ,@p_log_message   =@v_log_message 
		                          ,@p_description   =@v_description 
		                          ,@p_event_date    =@d_event_date 
		                          ,@p_user_id       =@v_batch_user
		                          ;

		-- CURRENT_PLAN_DATE_YN  = 'E' -- 진행 완료(에러 미수행) 
		UPDATE SSP_MST_SHIP_PLAN_SCHEDULE_EE
		SET    CURRENT_PLAN_DATE_YN		= 'E' --E 
		,      LAST_UPDATE_DATE			= GETDATE()
		,      LAST_UPDATED_BY			= @v_batch_user
		WHERE COMPANY_ID				= @c_company_id
		AND   PLAN_START_YYYYMMDD		= @v_plan_start_yyyymmdd
		;

		-----------------------------------------------------------
		-- SMS 전송 : Daily Plan  ERROR (52)
		--50 Daily Plan Start 
		--51 Daily Plan End 
		--52 Daily Plan Error 
		-----------------------------------------------------------
 		SET @v_sms_desc = 'Electrode:'+ @c_company_id;
	    EXEC SCM_ADM_SMS_SEND_BATCH 52, @v_sms_desc;
 

		RETURN -1

    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@v_plan_start_yyyymmdd+'][' + @v_exec_time + ']['+ @v_company_id + ']';  
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    RETURN 1  

  END;  
