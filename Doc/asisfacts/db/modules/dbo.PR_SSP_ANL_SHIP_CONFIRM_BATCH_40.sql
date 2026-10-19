
/*
 * Program ID   : PR_SSP_ANL_SHIP_CONFIRM_BATCH_40  
 * Description  : Daily 출하확정 내용 저장 및 인터페이스 테이블 저장 (소형) 월 1회 확정
 * OutTable     : s
 * Execute      : EXEC PR_SSP_SHIP_CONFIRM_BATCH @p_division_id = '40' 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.03.13   LJH            Initial Release [PJ20189106] 전지.GSCM 고도화 이행 
 * 2019.05.10   LJH            출하요청입력기간을 기존 1개월에서 2개월로 변경, 확정은 1개월 요청분만 확정함 
                               SSP_MST_SHIP_REQ 의 CONFIRM_START_DATE , CONFIRM_END_DATE 기준으로 확정 
 * 2019.06.13   LJH            [CSR ID:4016810] [요청] SSP Planning Horizen 연장에 따른 Shipment Request Logic 변경 
                               음수Balance 처리 적용 (음수 BALANCE 가 있는 해당 날짜의 SHIP_REQ만 삭제)
                               - 음수Balance 제외 하고 확정
							   - 음수Balance 삭제 대상 데이터 테이블 저장(SSP_ANL_SHIP_REQ_D)
							   
 * 2020-09-21	KIM BOK KI     INCOTERMS COLUMN 변경(INCOTERMS -> SSP_INCOTERMS)
 * 2020-11-10   KIM BOK KI     40 Daily Rolling 을 위한 로직변경
 * 2021-01-12   KIM BOK KI     SCM_MST_SITE JOIN 을 LEFT OUTER JOIN -> JOIN 으로 변경
 * 2021-03-11   KIM BOK KI     스케쥴 재 수행 시 대 수행하지 않도록 로직 추가
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
 * 2022.08.01   SSP Pjt.       CONFIRM_ROUTE 적용
 * 2024.10.01   KHJ            NERP_SSP
 * 2024.11.26   SSP Pjt.       FN_LIST_LOOKUP_VALUE('PR_SSP_ANL_SHIP_CONFIRM_BATCH_40','Specific_Site') 추가
 * 2025/08/18   chkim.68       to_company_id를 from_site에 따라 to_company_id가 다르게 적용되는 예외를 적용 (scm_site_company_exception)
							FN_GET_SSP_SITE_INFO -> [FN_GET_SSP_SITE_INFO_EXCEPTION]
 */

CREATE PROCEDURE [dbo].[PR_SSP_ANL_SHIP_CONFIRM_BATCH_40]
( 
	  @p_division_id        NVARCHAR(30)
	, @p_company_id         NVARCHAR(30)
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'ssp_batch';  
    SET     @v_batch_user = 'ssp_batch' ; -- @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'PR_SSP_ANL_SHIP_CONFIRM_BATCH_40'; -- ▶ 테이블 필수
    DECLARE @d_event_date   DATETIME;

    -- 임시 실행시간 확인용
    DECLARE @v_start_time				DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10) = ''--'[00:00]';


    DECLARE @v_plan_start_yyyymmdd      NVARCHAR(8) = '';
	DECLARE @v_plan_type				NVARCHAR(8) = 'SP';
	DECLARE @v_seq						INTEGER = 1;

 --   DECLARE @v_req_plan_start_yyyymmdd  NVARCHAR(8) = '';
	--DECLARE @v_req_plan_type			NVARCHAR(8) = '';
	--DECLARE @v_req_seq					INTEGER = 0;
	--DECLARE @v_req_mst_id				NVARCHAR(30);
	--DECLARE @v_req_end_date				NVARCHAR(8);
	--DECLARE @v_req_in_start_date		NVARCHAR(8);
	--DECLARE @v_req_in_end_date			NVARCHAR(8);

	DECLARE @v_confirm_start_date		NVARCHAR(8);
	DECLARE @v_confirm_end_date		    NVARCHAR(8);


	DECLARE @v_infseqno					NVARCHAR(14);	
	DECLARE @v_timezone					NVARCHAR(10); 	
    DECLARE @v_daily_confirm_date		NVARCHAR(8);	
	DECLARE @v_time_for_system			DATETIME ;
	DECLARE @v_time_for_timezone		DATETIME ;
	DECLARE @v_sms_desc					NVARCHAR(4000);
    DECLARE @v_last_start_yyyymmdd      NVARCHAR(8) = '';
	DECLARE @plan_cnt    INTEGER = 0;	

	SET     @v_plan_start_yyyymmdd =  CONVERT(char(8), GETDATE(), 112); 
	SET     @v_last_start_yyyymmdd =  CONVERT(char(8), GETDATE()-1, 112); 

	SELECT @plan_cnt = COUNT(*)
	FROM   SSP_ANL_SHIP_PLAN_40 (NOLOCK)
	WHERE  1 = 1
	AND    DIVISION_ID = @p_division_id
	AND    PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
	AND    MEASURE = 'SHIP_CONFIRM'
	AND    ATTRIBUTE10 = @p_company_id
	;


    IF @plan_cnt > 0
	BEGIN
		RETURN ;
	END;

    -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SHIP_CONFIRM INSERT LOGIC';
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

		---- 출하요청 확정 대상 여부 확인 (출하요청 마감일 다음날 생성)
		--SELECT @v_req_mst_id              = ISNULL(MAX(REQ_MST_ID) ,'X')
		--,      @v_req_end_date            = ISNULL(MAX(REQ_END_DATE) ,'X')
		--,      @v_req_plan_start_yyyymmdd = ISNULL(MAX(PLAN_START_YYYYMMDD),'X')
		--,      @v_req_plan_type           = ISNULL(MAX(PLAN_TYPE),'X')
		--,      @v_req_seq                 = ISNULL(MAX(SEQ),0)
		--,      @v_req_in_start_date       = ISNULL(MAX(REQ_IN_START_DATE),'X') 
		--,      @v_req_in_end_date         = ISNULL(MAX(REQ_IN_END_DATE),'X')
		--,      @v_confirm_start_date      = ISNULL(MAX(CONFIRM_START_DATE),'X')
		--,      @v_confirm_end_date        = ISNULL(MAX(CONFIRM_END_DATE),'X')
		--FROM  SSP_MST_SHIP_REQ WITH(NOLOCK)
		--WHERE DIVISION_ID  = @p_division_id
		--AND   CUTOFF_FLAG  = 'Y'
		--AND   CONFIRM_FLAG = 'N'
        --;


        -- 출하요청 마감 다음날일 경우 출하요청 정보를 확정처리  
		--IF @v_req_end_date =  CONVERT(CHAR(8), DATEADD(DD, -1, GETDATE()), 112) 
		--IF '20210201' <=  CONVERT(CHAR(8), GETDATE()+20, 112) 

		BEGIN -- 확정생성 BEGIN

			UPDATE R
			SET    R.ATTRIBUTE10 = C.CONFIRM_ID 
			FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
					JOIN (
							SELECT C.DIVISION_ID
								, C.FROM_SITE
								, C.TO_SITE
								, C.ITEM_ID
								, C.YYYYMMDD
								, C.BOD_ID
								, C.PROJECT_CODE
								, C.FCST_TYPE
								, MAX(C.CONFIRM_ID)  AS CONFIRM_ID
							FROM   SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
							WHERE  1 = 1
							AND    C.DIVISION_ID = '40'
							AND   C.YYYYMMDD    = (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](C.DIVISION_ID, C.FROM_SITE), 0) = 0 THEN @v_plan_start_yyyymmdd
										        ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](C.DIVISION_ID, C.FROM_SITE)-1, @v_plan_start_yyyymmdd) ,112) END)
							GROUP BY C.DIVISION_ID
								, C.FROM_SITE
								, C.TO_SITE
								, C.ITEM_ID
								, C.YYYYMMDD
								, C.BOD_ID
								, C.PROJECT_CODE
								, C.FCST_TYPE
							) C
					ON C.DIVISION_ID = R.DIVISION_ID 
					AND C.FROM_SITE   = R.PLANT_SITE_ID
					AND C.TO_SITE	 = R.SCM_SITE_ID
					AND C.ITEM_ID	 = R.ITEM_ID 
					AND C.YYYYMMDD	 = R.YYYYMMDD
					AND C.BOD_ID      = R.BOD_ID
					AND C.PROJECT_CODE = R.PROJECT_CODE
					AND C.FCST_TYPE = R.FCST_TYPE

					JOIN SCM_MST_SITE E WITH(NOLOCK)
					ON    E.DIVISION_ID = @p_division_id
					AND   ISNULL(E.COMPANY_ID, '')  = @p_company_id
					AND   E.DIVISION_ID = R.DIVISION_ID
					AND   E.SCM_SITE_ID = R.PLANT_SITE_ID
			WHERE  1 = 1
			AND   R.DIVISION_ID = @p_division_id
			AND   R.YYYYMMDD    = (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0 THEN @v_plan_start_yyyymmdd
									ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID)-1, @v_plan_start_yyyymmdd) ,112) END)
			AND   R.ATTRIBUTE10 IS NULL
			--AND   R.QTY         > 0
			AND   R.QTY         >= 1
			;

			------------------------------------------------------------------------------------------------------------- 
			-- 0. temp 테이블 생성 : 생성후 마지막에 한번에 입력하기 위해서
			------------------------------------------------------------------------------------------------------------- 
			IF OBJECT_ID('tempdb..#tmp_SSP_ANL_SHIP_CONFIRM_40') IS NOT NULL
				DROP TABLE #tmp_SSP_ANL_SHIP_CONFIRM_40

				CREATE TABLE #tmp_SSP_ANL_SHIP_CONFIRM_40(
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
					,ELECTRODE_TYPE				  NVARCHAR(030)  
					,ORIGIN_FROM_DIVISION_ID	  NVARCHAR(030)
					,ORIGIN_TO_DIVISION_ID		  NVARCHAR(030)
					,BEFORE_QTY                   NUMERIC(20,10)
					,REMARKS3                     NVARCHAR(255) -- Customer Requirement
					,REQUESTOR					  NVARCHAR(100)	
					,CHECK_NEED_YN                NVARCHAR(001)
					,ATTRIBUTE10                  NVARCHAR(020)	-- REQ_DET_ID
					,REQUEST_ID                   NVARCHAR(030)
			);

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
			FROM   SCM_ADM_LOOKUP_MASTER_DETAIL C WITH(NOLOCK)
			WHERE  1=1
			AND    C.LOOKUP_TYPE = 'TIME_ZONE'
			AND    C.SEGMENT3    = 'KR' --@p_country       
			; 

			SET    @v_time_for_timezone = DBO.FN_MULTY_TIME(@v_timezone) ;
			SET    @v_time_for_system   = GETDATE() ;

			------------------------------------------------------------------------------------------------------------- 
			-- 1. SHIP_CONFIRM 입력 : 출하확정(신규) #tmp_SSP_ANL_SHIP_CONFIRM_40  
			--    신규확정일 경우 CONFIRM_ID 채번
			-- PACKER REQ CONFIRM DATA 생성 REQUEST_ID IS NOT NULL AND CONFIRM_ID IS NULL
			------------------------------------------------------------------------------------------------------------- 
			INSERT INTO #tmp_SSP_ANL_SHIP_CONFIRM_40 (
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
			   FROM   (
					   SELECT DISTINCT
					         'C'                      AS SHIPMENT_STATUS
							, R.DIVISION_ID            AS DIVISION_ID
							, @v_plan_start_yyyymmdd   AS PLAN_START_YYYYMMDD
							, @v_plan_type             AS PLAN_TYPE
							, @v_seq                   AS SEQ
							, R.ITEM_ID                AS ITEM_ID
							, R.PLANT_SITE_ID          AS FROM_SITE
							, R.SCM_SITE_ID            AS TO_SITE
							, R.YYYYMMDD               AS YYYYMMDD
							-- LOT SIZE별로 분할 생성 
							, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
									ELSE  
										CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
												ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
										END 
								END                      AS PLANNED_QTY
							, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
									ELSE  
										CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
												ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
										END 
								END                    AS QTY
							, R.BOD_ID                 AS BOD_ID
							, B.ROUTE_ID               AS ROUTE_ID
							, SUBSTRING(R.PLANT_SITE_ID, CHARINDEX('-', R.PLANT_SITE_ID)+1, 1) AS BIZ_TYPE
							, R.PROJECT_CODE           AS PROJECT_CODE
							, R.FCST_TYPE              AS FCST_TYPE
							, R.YYYYMMDD               AS FCST_ETD_DATE
							, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
							, R.YYYYMMDD               AS ETD_DATE
							, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS ETA_DATE
							, ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)              AS INCOTERMS
							, R.TRANSPORT_MODE         AS TRANSPORT_MODE
							, B.D_COUNTRY              AS D_COUNTRY
							, B.D_PORT_CODE            AS D_PORT_CODE
							, B.A_COUNTRY              AS A_COUNTRY
							, B.A_PORT_CODE            AS A_PORT_CODE
							, B.LT_TOTAL               AS CUSTOMER_LT
							, B.TO_COUNTRY             AS TO_COUNTRY
							, B.TO_CITY                AS TO_CITY
							-- 2020.07.10 함수 호출로 변경 : KBK
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SITE_TYPE')   AS FROM_SITE_TYPE  
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'PLANT_ID')    AS FROM_SITE_PLANT_ID 
							-- 2020-08-24 11:19:51
							-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
							-- 2020-08-24  kimbl1
							,CASE WHEN ISNULL(FS.HQ_VENDOR_CODE, '') <> '' THEN FS.HQ_VENDOR_CODE
							 ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'VENDOR_ID') END   AS FROM_SITE_VENDOR_ID  
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'COMPANY_ID')  AS FROM_SITE_COMPANY_ID 
							,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.DIVISION_ID,FS.SCM_SITE_ID, TS.SCM_SITE_ID, 'SITE_TYPE')     AS TO_SITE_TYPE  
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
							,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
							 ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'VENDOR_ID') END    AS TO_SITE_VENDOR_ID  
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
							,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SHIPTO_CODE')   AS TO_SITE_SHIPTO_CODE
							,[DBO].[FN_GET_SSP_SITE_INFO_EXCEPTION](R.DIVISION_ID,FS.SCM_SITE_ID, TS.SCM_SITE_ID, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID 
							, 'N'                                                                              AS CONFIRM_TYPE  -- 신규확정
							, FS.COUNTRY                                                                       AS COUNTRY  --FROM SITE의 COUNTRY
							, FS.COMPANY_ID                                                                    AS COMPANY_ID
							, TS.VMI_YN                                                                        AS VMI_YN 
							, 'N'                                                                              AS ELECTRODE_YN            
							, ''																               AS ELECTRODE_TYPE				   
							, R.DIVISION_ID														               AS ORIGIN_FROM_DIVISION_ID	
							, R.DIVISION_ID														               AS ORIGIN_TO_DIVISION_ID
							, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
									ELSE  
										CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
												ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
										END 
								END                                                                            AS BEFORE_QTY
							--, R.REMARKS3                                                                       AS REMARKS3  
							, NULL                                                                             AS REMARKS3  
							, R.CREATED_BY																	   AS REQUESTOR                                        
							, 'N'                                                                              AS CHECK_NEED_YN  
							--, R.REQ_DET_ID                                                                     AS ATTRIBUTE10
							, '-'                                                                              AS ATTRIBUTE10
							, '-'                                                                              AS REQUEST_ID
						FROM DM_PLN_SHIPMENT_REQ R WITH(NOLOCK)       
							JOIN SCP_MST_BOD_N_V   B WITH(NOLOCK) 
								ON  B.DIVISION_ID  = R.DIVISION_ID 
								AND B.BOD_ID       = R.BOD_ID 
							JOIN SCM_MST_SITE FS  WITH(NOLOCK)
								ON  FS.DIVISION_ID = R.DIVISION_ID 
								AND FS.SCM_SITE_ID = R.PLANT_SITE_ID 
								AND FS.VALID_YN    = 'Y' 
								AND ISNULL(FS.COMPANY_ID, '')  = @p_company_id
							LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
								ON  TS.DIVISION_ID = R.DIVISION_ID 
								AND TS.SCM_SITE_ID = R.SCM_SITE_ID 
								AND TS.VALID_YN    = 'Y' 
							LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER FC  WITH(NOLOCK)
								ON  FC.DIVISION_ID = R.DIVISION_ID 
								AND FC.SCM_SITE_ID = R.PLANT_SITE_ID 
								AND FC.VALID_YN    = 'Y'
								AND FC.REP_YN      = 'Y'
							LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER TC  WITH(NOLOCK)
								ON  TC.DIVISION_ID = R.DIVISION_ID 
								AND TC.SCM_SITE_ID = R.SCM_SITE_ID    
								AND TC.VALID_YN    = 'Y' 
								AND TC.REP_YN      = 'Y'
							LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
								ON L.DIVISION_ID     = R.DIVISION_ID 
								AND L.FROM_SITE      = R.PLANT_SITE_ID
								AND L.TO_SITE        = R.SCM_SITE_ID
								AND L.ITEM_ID        = R.ITEM_ID   
								AND L.TRANSPORT_MODE = R.TRANSPORT_MODE
								AND L.VALID_YN       = 'Y'
								AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
							JOIN SSP_MST_PARTIAL_SEQ C WITH(NOLOCK) -- LOT SIZE별 행 생성을 위한 기초테이블 
								ON C.SEQ <= CEILING(R.QTY/ISNULL(L.LOT_SIZE ,R.QTY))
						WHERE 1=1 
						AND   R.DIVISION_ID = @p_division_id 
						AND   R.MEASURE     = 'SHIP_REQ'
						--AND   R.QTY         > 0
						AND   R.QTY         >= 1
						AND   R.ATTRIBUTE10 IS NULL
						AND   R.YYYYMMDD    = (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0 THEN @v_plan_start_yyyymmdd
						                        ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.PLANT_SITE_ID)-1, @v_plan_start_yyyymmdd) ,112) END)
						AND   NOT EXISTS ( -- 음수 BALANCE 가 있는 해당 날짜의 SHIP_REQ만 삭제
											SELECT 1
											FROM   (
													SELECT X.DIVISION_ID
														, X.PLAN_START_YYYYMMDD
														, X.PLAN_TYPE
														, X.SEQ
														, X.FROM_SITE
														, X.ITEM_ID
														, X.YYYYMMDD
														, X.QTY - Z.QTY    AS QTY
													FROM   SSP_ANL_SHIP_PLAN_40 X WITH(NOLOCK)
															LEFT OUTER JOIN (
																			SELECT Z.DIVISION_ID
																				, Z.PLANT_SITE_ID  AS FROM_SITE
																				, Z.ITEM_ID
																				, Z.YYYYMMDD
																				, SUM(Z.QTY)   AS QTY
																			FROM   DM_PLN_SHIPMENT_REQ Z WITH(NOLOCK)
																			WHERE  Z.DIVISION_ID = @p_division_id
																			AND    Z.MEASURE = 'SHIP_REQ'
																			--AND Z.ITEM_ID = 'MCCE121501A3'
																			GROUP BY Z.DIVISION_ID
																				, Z.PLANT_SITE_ID
																				, Z.ITEM_ID
																				, Z.YYYYMMDD
																			) Z
															ON   Z.DIVISION_ID = X.DIVISION_ID
															AND  Z.FROM_SITE = X.FROM_SITE
															AND  Z.ITEM_ID = X.ITEM_ID
															AND  Z.YYYYMMDD = X.YYYYMMDD
													WHERE  X.DIVISION_ID = @p_division_id
													AND    X.PLAN_START_YYYYMMDD = @v_last_start_yyyymmdd
													AND    X.PLAN_TYPE = @v_plan_type
													AND    X.SEQ = @v_seq
													AND    X.MEASURE = 'BALANCE'
													--AND X.ITEM_ID = 'MCCE121501A3'
													) X
											WHERE  X.DIVISION_ID = R.DIVISION_ID
											AND    X.FROM_SITE = R.PLANT_SITE_ID
											AND    X.ITEM_ID = R.ITEM_ID
											AND    X.YYYYMMDD = R.YYYYMMDD
											AND    X.QTY < 0 
											AND    X.FROM_SITE NOT IN (SELECT CODE FROM DBO.FN_LIST_LOOKUP_VALUE('PR_SSP_ANL_SHIP_CONFIRM_BATCH_40','Specific_Site'))
											) 

						--UNION ALL

						---- PACKER REQ CONFIRM DATA 생성 REQUEST_ID IS NOT NULL AND CONFIRM_ID IS NULL
						--SELECT DISTINCT
						--     'C'                      AS SHIPMENT_STATUS
						--	, R.DIVISION_ID            AS DIVISION_ID
						--	, @v_plan_start_yyyymmdd   AS PLAN_START_YYYYMMDD
						--	, @v_plan_type             AS PLAN_TYPE
						--	, @v_seq                   AS SEQ
						--	, R.MODEL_ID               AS ITEM_ID
						--	, R.FROM_SITE              AS FROM_SITE
						--	, R.TO_SITE                AS TO_SITE
						--	, R.YYYYMMDD               AS YYYYMMDD
						--	-- LOT SIZE별로 분할 생성 
						--	, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
						--			ELSE  
						--				CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
						--						ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
						--				END 
						--		END                      AS PLANNED_QTY
						--	, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
						--			ELSE  
						--				CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
						--						ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
						--				END 
						--		END                    AS QTY
						--	, R.BOD_ID                 AS BOD_ID
						--	, B.ROUTE_ID               AS ROUTE_ID
						--	, SUBSTRING(R.FROM_SITE, CHARINDEX('-', R.FROM_SITE)+1, 1) AS BIZ_TYPE
						--	, '-'                      AS PROJECT_CODE
						--	, '-'                      AS FCST_TYPE
						--	, R.YYYYMMDD               AS FCST_ETD_DATE
						--	, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS FCST_ETA_DATE
						--	, R.YYYYMMDD               AS ETD_DATE
						--	, [dbo].[FN_GET_SSP_ETA_DATE](R.DIVISION_ID, B.BOD_ID, R.YYYYMMDD) AS ETA_DATE
						--	, ISNULL(B.SSP_INCOTERMS, R.INCOTERMS)              AS INCOTERMS
						--	, R.TRANSPORT_MODE         AS TRANSPORT_MODE
						--	, B.D_COUNTRY              AS D_COUNTRY
						--	, B.D_PORT_CODE            AS D_PORT_CODE
						--	, B.A_COUNTRY              AS A_COUNTRY
						--	, B.A_PORT_CODE            AS A_PORT_CODE
						--	, B.LT_TOTAL               AS CUSTOMER_LT
						--	, B.TO_COUNTRY             AS TO_COUNTRY
						--	, B.TO_CITY                AS TO_CITY
						--	-- 2020.07.10 함수 호출로 변경 : KBK
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SITE_TYPE')   AS FROM_SITE_TYPE  
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'PLANT_ID')    AS FROM_SITE_PLANT_ID 
						--	-- 2020-08-24 11:19:51
						--	-- [요청] 사급 Cell 출하 관련 Packer Master 생성 및 ERP Data 수정 요청
						--	-- 2020-08-24  kimbl1
						--	,CASE WHEN ISNULL(FS.HQ_VENDOR_CODE, '') <> '' THEN FS.HQ_VENDOR_CODE
						--		ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'VENDOR_ID') END   AS FROM_SITE_VENDOR_ID  
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SOLDTO_CODE') AS FROM_SITE_SOLDTO_CODE
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'SHIPTO_CODE') AS FROM_SITE_SHIPTO_CODE
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, FS.SCM_SITE_ID, 'COMPANY_ID')  AS FROM_SITE_COMPANY_ID 
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SITE_TYPE')     AS TO_SITE_TYPE  
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'PLANT_ID')      AS TO_SITE_PLANT_ID   
						--	,CASE WHEN ISNULL(TS.HQ_VENDOR_CODE, '') <> '' THEN TS.HQ_VENDOR_CODE
						--		ELSE [DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'VENDOR_ID') END    AS TO_SITE_VENDOR_ID  
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'SOLDTO_CODE')   AS TO_SITE_SOLDTO_CODE
						--	,R.SHIPTO_CODE                                                                AS TO_SITE_SHIPTO_CODE
						--	,[DBO].[FN_GET_SSP_SITE_INFO](R.DIVISION_ID, TS.SCM_SITE_ID, 'COMPANY_ID')    AS TO_SITE_COMPANY_ID 
						--	--, 'N'                                                                              AS CONFIRM_TYPE  -- 신규확정
						--	, 'Z'                                                                              AS CONFIRM_TYPE  -- 신규확정
						--	, FS.COUNTRY                                                                       AS COUNTRY  --FROM SITE의 COUNTRY
						--	, FS.COMPANY_ID                                                                    AS COMPANY_ID
						--	, TS.VMI_YN                                                                        AS VMI_YN 
						--	, 'N'                                                                              AS ELECTRODE_YN            
						--	, ''																               AS ELECTRODE_TYPE				   
						--	, R.DIVISION_ID														               AS ORIGIN_FROM_DIVISION_ID	
						--	, R.DIVISION_ID														               AS ORIGIN_TO_DIVISION_ID
						--	, CASE WHEN  R.QTY <= ISNULL(L.LOT_SIZE ,R.QTY) THEN  R.QTY 
						--			ELSE  
						--				CASE WHEN  R.QTY /(ISNULL(L.LOT_SIZE ,R.QTY)*C.SEQ) >= 1 THEN ISNULL(L.LOT_SIZE ,R.QTY)  
						--						ELSE R.QTY % (ISNULL(L.LOT_SIZE ,R.QTY)*(C.SEQ-1))
						--				END 
						--		END                                                                            AS BEFORE_QTY
						--	--, R.REMARKS3                                                                       AS REMARKS3  
						--	, NULL                                                                             AS REMARKS3  
						--	, R.CREATED_BY																	   AS REQUESTOR                                        
						--	, 'N'                                                                              AS CHECK_NEED_YN  
						--	--, R.REQ_DET_ID                                                                     AS ATTRIBUTE10
						--	, '-'                                                                              AS ATTRIBUTE10
						--	, R.REQUEST_ID 
						--FROM SSP_ANL_SHIP_PLAN_PACK_REQ R WITH(NOLOCK)       
						--	JOIN SCP_MST_BOD_N_V   B WITH(NOLOCK) 
						--		ON  B.DIVISION_ID  = R.DIVISION_ID 
						--		AND B.BOD_ID       = R.BOD_ID 
						--	JOIN SCM_MST_SITE FS  WITH(NOLOCK)
						--		ON  FS.DIVISION_ID = R.DIVISION_ID 
						--		AND FS.SCM_SITE_ID = R.FROM_SITE 
						--		--AND FS.COMPANY_ID  = @p_company_id
						--		AND FS.VALID_YN    = 'Y' 
						--      AND ISNULL(FS.COMPANY_ID, '')  = @p_company_id
						--	LEFT OUTER JOIN SCM_MST_SITE TS  WITH(NOLOCK)
						--		ON  TS.DIVISION_ID = R.DIVISION_ID 
						--		AND TS.SCM_SITE_ID = R.TO_SITE 
						--		AND TS.VALID_YN    = 'Y' 
						--	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER FC  WITH(NOLOCK)
						--		ON  FC.DIVISION_ID = R.DIVISION_ID 
						--		AND FC.SCM_SITE_ID = R.FROM_SITE 
						--		AND FC.VALID_YN    = 'Y'
						--		AND FC.REP_YN      = 'Y'
						--	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER TC  WITH(NOLOCK)
						--		ON  TC.DIVISION_ID = R.DIVISION_ID 
						--		AND TC.SCM_SITE_ID = R.TO_SITE    
						--		AND TC.VALID_YN    = 'Y' 
						--		AND TC.REP_YN      = 'Y'
						--	LEFT OUTER JOIN SCP_MST_SHIPMENT_LOT_SIZE L WITH(NOLOCK)
						--		ON L.DIVISION_ID     = R.DIVISION_ID 
						--		AND L.FROM_SITE      = R.FROM_SITE
						--		AND L.TO_SITE        = R.TO_SITE
						--		AND L.ITEM_ID        = R.MODEL_ID   
						--		AND L.TRANSPORT_MODE = R.TRANSPORT_MODE
						--		AND L.VALID_YN       = 'Y'
						--		AND L.SPLIT_YN       = 'Y' -- 분할대상인것만 분할(2018.12.18) 
						--	JOIN SSP_MST_PARTIAL_SEQ C WITH(NOLOCK) -- LOT SIZE별 행 생성을 위한 기초테이블 
						--		ON C.SEQ <= CEILING(R.QTY/ISNULL(L.LOT_SIZE ,R.QTY))
						--WHERE 1=1 
						--AND   R.DIVISION_ID = @p_division_id 
						--AND   R.QTY         > 0
						--AND   R.REQUEST_ID  IS NOT NULL
						--AND   R.CONFIRM_ID  IS NULL
						--AND   R.YYYYMMDD    = (CASE WHEN ISNULL([DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.FROM_SITE), 0) = 0 THEN @v_plan_start_yyyymmdd
						--						ELSE CONVERT(VARCHAR, DATEADD(D, [DBO].[FN_GET_SSP_ANL_SHIP_FROZEN](R.DIVISION_ID, R.FROM_SITE)-1, @v_plan_start_yyyymmdd) ,112) END)
					   ) A
				WHERE  1 = 1
				AND A.QTY >= 1
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
				,REQUESTOR               
			    ,CHECK_NEED_YN
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
				,REQUESTOR  
				,CHECK_NEED_YN
				,CONFIRM_TYPE  -- ATTRIBUTE9
				,ATTRIBUTE10   -- REQ_DET_ID 
			FROM  #tmp_SSP_ANL_SHIP_CONFIRM_40 A WITH (NOLOCK)
			WHERE  1 = 1
			AND    DIVISION_ID = @p_division_id
			AND    CONFIRM_TYPE IN ('N', 'Z') -- 신규 확정건인 경우 : N = Cell / Z = Pack
			AND    BIZ_TYPE <> 'E'
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
		  FROM #tmp_SSP_ANL_SHIP_CONFIRM_40 WITH (NOLOCK)
		  WHERE  1 = 1
		  AND    DIVISION_ID = @p_division_id
		  AND    CONFIRM_TYPE IN ('N', 'Z') -- 신규 확정건인 경우
		  AND    BIZ_TYPE <> 'E'
		  ;

			------------------------------------------------------------------------------------------------------------- 
			-- 5. ERP 전송을 위한 I/F 데이터 생성 XIF_ERP_SHIP_PLAN_CONFIRM_S_SN -- SHIPMENT_STATUS : A: 확정
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
			FROM  #tmp_SSP_ANL_SHIP_CONFIRM_40 C WITH(NOLOCK) 
			WHERE 1=1 
			AND   C.CONFIRM_TYPE = 'N'  -- 신규건만 전송 
			--AND   C.CONFIRM_TYPE = 'X'  -- 신규건만 전송 
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
				--FROM XIF_ERP_SHIP_PLAN_CONFIRM_S_SN  WITH(NOLOCK)
				--WHERE IFSEQNO LIKE CONVERT(CHAR(8),GETDATE(),112) +'%' ;

				SELECT @v_infseqno = CONVERT(CHAR(8),GETDATE(),112) + RIGHT( '000000'+ CONVERT(nvarchar,NEXT VALUE FOR DBO.SEQ1_XIF_ERP_IFSEQNO) ,6);

			  
				INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
					( 
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
				SELECT 	@v_infseqno  AS  IFSEQNO -- IFSEQNO
						,A.CONFIRM_ID
						,'A'     -- I_PLGB  A: 확정  
						,@yyyymmdd   AS LAST_CONFIRM_DATE -- I_DATE  확정구간 마지막 일자 
						,'B'-- VERSION_TYPE  -- B:NEW/A:OLD 
						,ISNULL(X1.NEW_VALUE1, A.SALES_COMPANY_ID)		AS SALES_COMPANY_ID
						,A.DIVISION_ID
						,A.ITEM_ID
						,ISNULL(X2.NEW_VALUE1, A.FROM_SITE)				AS FROM_SITE
						,ISNULL(X3.NEW_VALUE1, A.TO_SITE)				AS TO_SITE
						,A.YYYYMMDD
						,A.QTY
						,A.BOD_ID
						,A.ROUTE_ID
						,A.BIZ_TYPE -- OPERATION_GROUP
						,A.BIZ_TYPE
						,A.PROJECT_CODE
						,A.FCST_TYPE
						,A.FCST_ETD_DATE
						,A.FCST_ETA_DATE
						,A.ETD_DATE
						,A.ETA_DATE
						,A.INCOTERMS  
						,NULL     --INCOTERMS2
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
						,NULL --BUILDING
						,NULL --REMARK
						,A.REMARKS3  --CUSTOMER_REQ
						,NULL --CHANGE_CODE
						,NULL --CHANGE_CODE_NAME
						,A.REQUESTOR
						--,'N'                 -- TRANSFER_FLAG
						,'N'                 -- TRANSFER_FLAG
						,@v_time_for_system  -- TRANSFER_DATE
						,@v_batch_user       -- CREATED_BY
						,@v_time_for_system  -- CREATION_DATE
						,@v_batch_user       -- LAST_UPDATED_BY
						,@v_time_for_system  -- LAST_UPDATE_DATE
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
						,A.TO_SITE_PLANT_ID AS ERP_ATTR4-- ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23)
				FROM
				(
					SELECT 
							A.CONFIRM_ID
						,CASE WHEN B.ATTRIBUTE2 IS NULL THEN NULL 
								WHEN B.ATTRIBUTE2 = '' THEN NULL 
							ELSE B.ATTRIBUTE2 END  AS SALES_COMPANY_ID
						,CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END  AS DIVISION_ID
						,A.ITEM_ID
						,A.FROM_SITE
						,A.TO_SITE
						,A.YYYYMMDD
						,A.QTY
						,A.BOD_ID
						,A.ROUTE_ID
						,A.BIZ_TYPE -- OPERATION_GROUP
						--,A.BIZ_TYPE
						,CASE WHEN A.PROJECT_CODE IS NULL OR A.PROJECT_CODE ='' OR A.PROJECT_CODE ='-' THEN 'TBD' ELSE A.PROJECT_CODE END   AS PROJECT_CODE
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
						,A.REMARKS3  --CUSTOMER_REQ
						,A.REQUESTOR
						,A.ELECTRODE_YN -- ATTRIBUTE10
					FROM #tmp_SSP_ANL_SHIP_CONFIRM_40  A WITH(NOLOCK)
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  B WITH(NOLOCK) 
							ON   B.LOOKUP_TYPE = 'CELL_SHIP_FROM_TO' 
							AND  B.VALID_YN   = 'Y'
							AND  B.SEGMENT1 = A.FROM_SITE_COMPANY_ID 
							AND  B.SEGMENT3 = A.FROM_SITE
							AND  B.SEGMENT4 = A.TO_SITE_COMPANY_ID 
							AND  B.SEGMENT5 = A.TO_SITE 
					WHERE 1=1 
					AND   A.DIVISION_ID = @p_division_id
					AND   CONFIRM_TYPE = 'N' -- 신규 확정건인 경우
					--AND   A.CONFIRM_TYPE = 'X' -- 신규 확정건인 경우
					AND   A.BIZ_TYPE <> 'E'
					AND   A.COMPANY_ID      =  @company_id
					AND   ISNULL(A.QTY,0) <> 0  -- 0은IF 제외  
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

			------------------------------------------------------------------------------------------------------------- 
			-- 5. 완료후 SSP_ANL_SHIP_PLAN_PACK_REQ / DM_PLN_SHIPMENT_REQ  CONFIRM_ID UPDATE 
			------------------------------------------------------------------------------------------------------------- 
			--UPDATE R
			--SET    CONFIRM_ID = C.CONFIRM_ID 
			--FROM   SSP_ANL_SHIP_PLAN_PACK_REQ R WITH(NOLOCK) 
			--  JOIN #tmp_SSP_ANL_SHIP_CONFIRM_40 C WITH(NOLOCK) 
			--	ON C.DIVISION_ID = R.DIVISION_ID 
			--   AND C.FROM_SITE   = R.FROM_SITE
			--   AND C.TO_SITE	 = R.TO_SITE
			--   AND C.ITEM_ID	 = R.MODEL_ID 
			--   AND C.YYYYMMDD	 = R.YYYYMMDD
			--   AND C.BOD_ID      = R.BOD_ID
			--   AND C.REQUEST_ID  = R.REQUEST_ID
			--   --AND C.ATTRIBUTE10 = R.REQ_DET_ID 
			--WHERE  1 = 1
			--AND   R.DIVISION_ID = @p_division_id 
			--AND   R.REQUEST_ID IS NOT NULL
			--and   R.CONFIRM_ID IS NULL
			--AND   R.QTY         > 0
			----AND   R.REQ_MST_ID  = @v_req_mst_id
			----AND   R.MEASURE     = 'SHIP_REQ'
			----AND   R.REQ_DET_ID  <> '-'
			----AND   R.YYYYMMDD    >= @v_req_in_start_date
			----AND   R.YYYYMMDD    <= @v_req_in_end_date
			--;

			UPDATE R
			SET    R.ATTRIBUTE10 = C.CONFIRM_ID 
			FROM   DM_PLN_SHIPMENT_REQ R WITH(NOLOCK) 
			  JOIN #tmp_SSP_ANL_SHIP_CONFIRM_40 C WITH(NOLOCK) 
				ON C.DIVISION_ID = R.DIVISION_ID 
			   AND C.FROM_SITE   = R.PLANT_SITE_ID
			   AND C.TO_SITE	 = R.SCM_SITE_ID
			   AND C.ITEM_ID	 = R.ITEM_ID 
			   AND C.YYYYMMDD	 = R.YYYYMMDD
			   AND C.BOD_ID      = R.BOD_ID
			   AND C.PROJECT_CODE = R.PROJECT_CODE
			   AND C.FCST_TYPE   = R.FCST_TYPE
			   --AND C.ATTRIBUTE10 = R.REQ_DET_ID 
			WHERE  1 = 1
			AND   R.DIVISION_ID = @p_division_id 
			AND   R.ATTRIBUTE10 IS NULL
			AND   R.QTY         > 0
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
				FROM  #tmp_SSP_ANL_SHIP_CONFIRM_40 A WITH (NOLOCK)
				WHERE  1 = 1
				AND    DIVISION_ID = @p_division_id
				AND    CONFIRM_TYPE IN ('N', 'Z') -- 신규 확정건인 경우 : N = Cell / Z = Pack
				AND    BIZ_TYPE <> 'E'
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

			--------------------------------------------------------------------------------------------------------------- 
			---- 6. 완료후 SSP_MST_SHIP_REQ  CONFIRM_FLAG ='Y' UPDATE 
			--------------------------------------------------------------------------------------------------------------- 
			--UPDATE SSP_MST_SHIP_REQ
			--SET    CONFIRM_FLAG  = 'Y'
			--,      CONFIRM_DATE  = @v_time_for_system
			--WHERE  REQ_MST_ID    = @v_req_mst_id
			--;

			--------------------------------------------------------------------------------------------------------------- 
			---- 7. 음수Balance 적용 
			---- 음수Balance 삭제 대상 데이터 테이블 저장(SSP_ANL_SHIP_REQ_D)
			--------------------------------------------------------------------------------------------------------------- 

   --         --음수Balance 삭제 대상 데이터 테이블 저장(SSP_ANL_SHIP_REQ_D)
	  --      DELETE 
			--FROM  SSP_ANL_SHIP_REQ_D
			--WHERE REQ_MST_ID  = @v_req_mst_id
			--AND   DIVISION_ID = @p_division_id 			
			--;

   --         -- 음수 Balance 대상 ITEM
			--WITH MINUS_ITEM AS 
			--(							
			--SELECT DISTINCT R.DIVISION_ID 
			--,      R.PLAN_START_YYYYMMDD
			--,      R.PLAN_TYPE 
			--,      R.SEQ 
			--,      R.FROM_SITE 
			--,      R.ITEM_ID
			----,      R.YYYYMMDD
			--,      R.MEASURE 
			--FROM SSP_ANL_SHIP_REQ R WITH(NOLOCK)    
			--		JOIN SSP_MST_SHIP_REQ M WITH(NOLOCK) 
			--		ON R.DIVISION_ID = M.DIVISION_ID 
			--		AND R.PLAN_START_YYYYMMDD = M.PLAN_START_YYYYMMDD
			--		AND R.REQ_MST_ID = M.REQ_MST_ID 
			--WHERE 1=1 
			--AND   R.REQ_MST_ID  = @v_req_mst_id
			--AND   R.DIVISION_ID = @p_division_id 
			--AND   R.PLAN_START_YYYYMMDD = @v_req_plan_start_yyyymmdd
			--AND   R.PLAN_TYPE = @v_req_plan_type
			--AND   R.SEQ = @v_req_seq
			--AND    EXISTS ( SELECT 1 
			--				FROM SSP_ANL_SHIP_REQ X WITH(NOLOCK)
			--				WHERE X.DIVISION_ID = R.DIVISION_ID
			--				AND   X.PLAN_START_YYYYMMDD = R.PLAN_START_YYYYMMDD
			--				AND   X.PLAN_TYPE = R.PLAN_TYPE
			--				AND   X.SEQ = R.SEQ
			--				AND   X.FROM_SITE = R.FROM_SITE
			--				AND   X.ITEM_ID = R.ITEM_ID
			--				AND   X.REQ_MST_ID = R.REQ_MST_ID
			--				AND   X.MEASURE = 'BALANCE'
			--				AND   X.YYYYMMDD BETWEEN M.CONFIRM_START_DATE AND M.CONFIRM_END_DATE
			--				AND   X.YYYYMMDD = R.YYYYMMDD 
			--				AND   X.QTY < 0 ) 
			--AND  R.MEASURE = 'SHIP_REQ'
			--AND  R.QTY > 0 
			--AND  R.YYYYMMDD BETWEEN M.CONFIRM_START_DATE AND M.CONFIRM_END_DATE
			--) 

			---- 음수 Balance 대상 SHIP_REQ 테이블 저장 
			--INSERT INTO SSP_ANL_SHIP_REQ_D (
			--			 DIVISION_ID
			--			,PLAN_START_YYYYMMDD
			--			,PLAN_TYPE
			--			,SEQ
			--			,ITEM_ID
			--			,FROM_SITE
			--			,TO_SITE
			--			,MEASURE
			--			,YYYYMMDD
			--			,BOD_ID
			--			,QTY
			--			,ROUTE_ID
			--			,INCOTERMS
			--			,TRANSPORT_MODE
			--			,BIZ_TYPE
			--			,PROJECT_CODE
			--			,FCST_TYPE
			--			,FCST_ETD_DATE
			--			,FCST_ETA_DATE
			--			,ETD_DATE
			--			,ETA_DATE
			--			,CONFIRM_ID
			--			,REQ_DET_ID
			--			,REQ_MST_ID
			--			,REQ_GRP_ID
			--			,REMARKS3
			--			,CREATED_BY
			--			,CREATION_DATE
			--			,LAST_UPDATED_BY
			--			,LAST_UPDATE_DATE
			--			,ATTRIBUTE1 -- 생성 날짜 
			--		    --,ATTRIBUTE2 -- 삭제 대상 표시 D:삭제 
			--			)
			--			SELECT 
			--			 R.DIVISION_ID
			--			,R.PLAN_START_YYYYMMDD
			--			,R.PLAN_TYPE
			--			,R.SEQ
			--			,R.ITEM_ID
			--			,R.FROM_SITE
			--			,R.TO_SITE
			--			,R.MEASURE
			--			,R.YYYYMMDD
			--			,R.BOD_ID
			--			,R.QTY
			--			,R.ROUTE_ID
			--			,R.INCOTERMS
			--			,R.TRANSPORT_MODE
			--			,R.BIZ_TYPE
			--			,R.PROJECT_CODE
			--			,R.FCST_TYPE
			--			,R.FCST_ETD_DATE
			--			,R.FCST_ETA_DATE
			--			,R.ETD_DATE
			--			,R.ETA_DATE
			--			,R.CONFIRM_ID
			--			,R.REQ_DET_ID
			--			,R.REQ_MST_ID
			--			,R.REQ_GRP_ID
			--			,R.REMARKS3
			--			,R.CREATED_BY
			--			,R.CREATION_DATE
			--			,R.LAST_UPDATED_BY
			--			,R.LAST_UPDATE_DATE
			--			,CONVERT(VARCHAR, GETDATE(), 120)
			--			--,CASE WHEN ( R.MEASURE = M.MEASURE AND R.QTY > 0 AND R.YYYYMMDD = M.YYYYMMDD ) THEN 'D' ELSE ''END  -- 삭제대상 표시  
			--			FROM SSP_ANL_SHIP_REQ R WITH(NOLOCK) 
			--				 JOIN MINUS_ITEM M WITH(NOLOCK) 
			--				   ON R.DIVISION_ID = M.DIVISION_ID 
			--				  AND R.PLAN_START_YYYYMMDD = M.PLAN_START_YYYYMMDD
			--				  AND R.PLAN_TYPE = M.PLAN_TYPE
			--				  AND R.SEQ = M.SEQ
			--				  AND R.FROM_SITE = M.FROM_SITE
			--				  AND R.ITEM_ID = M.ITEM_ID 
   --                     WHERE   R.REQ_MST_ID = @v_req_mst_id
			--            AND   R.DIVISION_ID = @p_division_id    
			--			AND   R.REQ_MST_ID  = @v_req_mst_id
			--			AND   R.DIVISION_ID = @p_division_id 
			--			AND   R.PLAN_START_YYYYMMDD = @v_req_plan_start_yyyymmdd
			--			AND   R.PLAN_TYPE = @v_req_plan_type
			--			AND   R.SEQ = @v_req_seq						
			--			;
			--			-- CONFIRM되지 않은 SHIP_REQ ATTRIBUTE ='D' UPDATE
			--			UPDATE SSP_ANL_SHIP_REQ_D
			--			SET    ATTRIBUTE2  = 'D'
			--			FROM SSP_ANL_SHIP_REQ_D
			--			WHERE  DIVISION_ID  = @p_division_id    
			--			AND   REQ_MST_ID  = @v_req_mst_id  
			--			AND   PLAN_START_YYYYMMDD = @v_req_plan_start_yyyymmdd  
			--			AND   PLAN_TYPE = @v_req_plan_type
			--			AND   SEQ = @v_req_seq	 
			--			AND   MEASURE IN ( 'SHIP_REQ','RTF_SCP' )
			--			AND   QTY>0
			--			AND   YYYYMMDD    >= @v_confirm_start_date
			--			AND   YYYYMMDD    <= @v_confirm_end_date
			--			AND   EXISTS ( SELECT 1 -- 음수 BALANCE 가 있는 해당 날짜의 SHIP_REQ만 
			--							FROM SSP_ANL_SHIP_REQ_D X WITH(NOLOCK)
			--							WHERE X.DIVISION_ID = DIVISION_ID
			--							AND   X.PLAN_START_YYYYMMDD = PLAN_START_YYYYMMDD
			--							AND   X.PLAN_TYPE = PLAN_TYPE
			--							AND   X.SEQ = SEQ
			--							AND   X.REQ_MST_ID = REQ_MST_ID
			--							AND   X.FROM_SITE = FROM_SITE
			--							AND   X.ITEM_ID = ITEM_ID
			--							AND   X.MEASURE = 'BALANCE'
			--							AND   X.YYYYMMDD = YYYYMMDD
			--							AND   X.QTY < 0 ) 
   --                     ;  


			-----------------------------------------------------------
			-- SMS 전송 : Daily Confirm END (46)
			-----------------------------------------------------------
			SET @v_sms_desc = @p_division_id + '::SSP ';
			EXEC SCM_ADM_SMS_SEND_BATCH 46, @v_sms_desc;
			-----------------------------------------------------------

       END; -- 확정생성 END

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
        SET @v_description = N'Process Complete...division_id:'+@p_division_id + '-' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date =  SYSDATETIME();

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


        END;
      
      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = @v_program_name +'- division_id :'+ @p_division_id+'-' + N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;
		-----------------------------------------------------------
		-- SMS 전송 : Daily Confirm ERROR (45)
		-----------------------------------------------------------
		SET @v_sms_desc = @p_division_id + '::SSP';
		EXEC SCM_ADM_SMS_SEND_BATCH 45, @v_sms_desc;
		-----------------------------------------------------------

      return -1

    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['++'][division_id :' + @p_division_id + '][' + @v_exec_time + ']'   ; 
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
   
    return 1  

  END; 
