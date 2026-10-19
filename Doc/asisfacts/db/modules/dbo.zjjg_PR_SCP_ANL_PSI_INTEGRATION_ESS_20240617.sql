

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617                        
 * Description  : 재료비 TASK                      
 * OutTable     : SCP_ANL_PSI_INTEGRATION_ESS                     
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617
                       @p_division_id         = '81'
                     , @p_plan_start_yyyymmdd = '20240527'
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.05.08                  Initial 재료비 TASK PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 PSI용 정보 구성
 *
 *******************************************************************************************************************/                    

-- 운영 이관시 1. 운영 IP 지우기, 2. ITEM_ID 를 FROM_ITEM_ID로 변경하기, 3. TEMP에서 SCP_ANL_PSI_INTEGRATION 에 넣을때 조건 지우기

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '81', '20240527'  --수행 시간 ==> 11분 04초 걸림. : 36,487건
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '81_UC', '20240527'  --수행 시간 ==> 7분 53초 걸림 : 1,308건
-- 운영 DB Link : select * from [10.34.221.78,7433].lgce_scmprod.dbo.[SCM_MST_SITE_item]  with(nolock)

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527'  --수행 시간 ==> 11분 04초 걸림. : 36,487건
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617]
(                         
      @p_division_id          NVARCHAR(30)            
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name         
)                         
AS                        
  BEGIN 

	if @p_division_id <> '82'
	begin
		return
	end	
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                        
    SET NOCOUNT ON;                        
    SET XACT_ABORT ON;                        
    SET ANSI_WARNINGS ON;                        
                        
    -- LOG 용 변수 설정                        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';                          
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PSI_INTEGRATION_ESS';                         
    DECLARE @d_event_date   DATETIME;                        
	                   
    DECLARE @V_STATUS_DESC  NVARCHAR(1000) = 'START'; 
	
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + @v_table_id + N' INSERT LOGIC';                        
    SET @d_event_date   = SYSDATETIME();                        
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                              ;                        
    -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';         


	-- SCP 계힉 참조를 위한 변수
	DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= ISNULL(@P_DIVISION_ID, '81')
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL;
	DECLARE @V_PLAN_START_DATE			DATE			= NULL;
	DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN';
	DECLARE @V_PLAN_SEQ					BIGINT			= 1
	DECLARE @V_HORIZON_END_YYYYMMDD		NVARCHAR(8)		= NULL
	DECLARE @V_PLAN_START_YYYYMM		NVARCHAR(6)		= NULL	-- 계획 구간 시작월
	DECLARE @V_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_ENG_PLAN_ID				NVARCHAR(100)	= NULL
	

	-- 전극용 구하기
	DECLARE @V_EE_DIVISION_ID		    NVARCHAR(10)	= 'EE'
	DECLARE @V_EE_PLAN_START_YYYYMMDD	NVARCHAR(8)		= NULL;
	DECLARE @V_EE_PLAN_TYPE				NVARCHAR(100)	= 'FN';
	--DECLARE @V_EE_PLAN_TYPE				NVARCHAR(100)	= 'MA';
	DECLARE @V_EE_PLAN_SEQ				BIGINT			= 1
	DECLARE @V_EE_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_EE_ENG_PLAN_ID			NVARCHAR(100)	= NULL

	
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527'

    BEGIN TRY                        
        BEGIN  

			---------------------------------------------------------------------------------------------------
			-- SCP PLAN 버전 정보 (PRODUCTION) 
			---------------------------------------------------------------------------------------------------
            SET @V_STATUS_DESC = 'Plan seq';
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
--SELECT 'JJG001'


			SELECT TOP 1
				  @V_PLAN_SEQ				= D.PLAN_SEQ  -- 1
				 ,@V_PLAN_START_YYYYMMDD	= P.PLAN_NAME -- 20240527
				 ,@V_PLAN_START_DATE		= CONVERT(DATE, P.PLAN_NAME, 112) 
				 ,@V_PLAN_START_YYYYMM		= SUBSTRING(P.PLAN_NAME, 1, 6)   -- 202405
				 ,@V_HORIZON_END_YYYYMMDD	= SUBSTRING(P.HORIZON_END_DATE, 1, 8)   -- 20250525
				 ,@V_MASTER_ID				= P.DIVISION_ID + '::' + P.PLAN_CYCLE   -- 81::WEEKLY
				 ,@V_ENG_PLAN_ID			= P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)  -- 1341::FN::1				 
			 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						  ON D.DIVISION_ID  = P.DIVISION_ID
						 AND D.PLAN_ID      = P.PLAN_ID
						 AND D.PLAN_TYPE    = @V_PLAN_TYPE -- FN
						 AND D.PLAN_STATUS  = '1'  -- 정상 완료
						 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			WHERE 1=1
			  AND P.DIVISION_ID  = @V_DIVISION_ID			
			  AND P.PLAN_NAME    = @P_PLAN_START_YYYYMMDD  -- JJGKSK 수정했음.
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 

--SELECT 'JJG002'
/*
			SELECT TOP 1
				  D.PLAN_SEQ  -- 1
				 ,P.PLAN_NAME -- 20240527
				 ,CONVERT(DATE, P.PLAN_NAME, 112) 
				 ,SUBSTRING(P.PLAN_NAME, 1, 6)   -- 202405
				 ,SUBSTRING(P.HORIZON_END_DATE, 1, 8)   -- 20250525
				 ,P.DIVISION_ID + '::' + P.PLAN_CYCLE   -- 81::WEEKLY
				 ,P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)  -- 1341::FN::1
			 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						  ON D.DIVISION_ID  = P.DIVISION_ID
						 AND D.PLAN_ID      = P.PLAN_ID
						 AND D.PLAN_TYPE    = 'FN'  --@V_PLAN_TYPE -- FN
						 AND D.PLAN_STATUS  = '1'  -- 정상 완료
						 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			WHERE 1=1
			  AND P.DIVISION_ID  ='82' --@V_DIVISION_ID			
			  AND P.PLAN_NAME    = '20240610' --@P_PLAN_START_YYYYMMDD  -- JJGKSK 수정했음.
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 

*/



--SELECT '@V_PLAN_SEQ : ' + @V_PLAN_SEQ  -- 2
--SELECT '@V_PLAN_START_YYYYMMDD : ' + @V_PLAN_START_YYYYMMDD  -- 2024-05-27
--SELECT '@V_PLAN_START_YYYYMM : ' + @V_PLAN_START_YYYYMM  --202405
--SELECT '@V_HORIZON_END_YYYYMMDD : ' + @V_HORIZON_END_YYYYMMDD  -- 20250525
--SELECT '@V_MASTER_ID : ' + @V_MASTER_ID  -- 82::WEEKLY
--SELECT '@V_ENG_PLAN_ID : ' + @V_ENG_PLAN_ID  -- 1341::FN::2

--return
--SELECT 'JJG003'

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 


            SET @V_STATUS_DESC = 'division EE ';
             -- 전극 @V_EE_DIVISION_ID 구하기.
			SELECT TOP 1 @V_EE_DIVISION_ID = b.DIVISION_ID
			from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION A with(nolock)
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION B WITH(NOLOCK)
			on b.attribute4 = a.ATTRIBUTE4
			and b.ATTRIBUTE3 = 'EE'
			where a.DIVISION_ID = @V_DIVISION_ID	-- '81_HM'


            SET @V_STATUS_DESC = ' plan EE';

/*
SELECT '@V_DIVISION_ID : ' + @V_DIVISION_ID  ==>  @V_DIVISION_ID : 82
SELECT '@V_EE_DIVISION_ID : ' + @V_EE_DIVISION_ID  ==> @V_EE_DIVISION_ID : EE

*/
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

			---------------------------------------------------------------------------------------------------
			-- 'EE'추가  SCP PLAN 버전 정보 (PRODUCTION) 
			---------------------------------------------------------------------------------------------------

			SELECT TOP 1
				  @V_EE_PLAN_SEQ			= D.PLAN_SEQ
				 ,@V_EE_PLAN_START_YYYYMMDD	= P.PLAN_NAME
				 ,@V_EE_MASTER_ID			= P.DIVISION_ID + '::' + P.PLAN_CYCLE 
				 ,@V_EE_ENG_PLAN_ID			= P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)
			 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						  ON D.DIVISION_ID  = P.DIVISION_ID
						 AND D.PLAN_ID      = P.PLAN_ID
						 AND D.PLAN_TYPE    = @V_PLAN_TYPE -- FN
						 AND D.PLAN_STATUS  = '1'  -- 정상 완료
						 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			WHERE 1=1
			  AND P.DIVISION_ID  = @V_EE_DIVISION_ID			
			  AND P.PLAN_NAME    = @P_PLAN_START_YYYYMMDD  
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 

/*

			SELECT TOP 1
				  D.PLAN_SEQ
				 ,P.PLAN_NAME
				 ,P.DIVISION_ID + '::' + P.PLAN_CYCLE 
				 ,P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)
			 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						  ON D.DIVISION_ID  = P.DIVISION_ID
						 AND D.PLAN_ID      = P.PLAN_ID
						 AND D.PLAN_TYPE    = @V_PLAN_TYPE -- FN
						 AND D.PLAN_STATUS  = '1'  -- 정상 완료
						 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			WHERE 1=1
			  AND P.DIVISION_ID  = @V_EE_DIVISION_ID			
			  AND P.PLAN_NAME    = @P_PLAN_START_YYYYMMDD  
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 
*/

/*
SELECT '@V_EE_PLAN_SEQ : ' + @V_EE_PLAN_SEQ  -- 1
SELECT '@V_EE_PLAN_START_YYYYMMDD : ' + @V_EE_PLAN_START_YYYYMMDD  -- 20240527
SELECT '@V_EE_MASTER_ID : ' + @V_EE_MASTER_ID  --EE::WEEKLY
SELECT '@V_EE_ENG_PLAN_ID : ' + @V_EE_ENG_PLAN_ID  -- 1341::FN::1
*/




          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------                   
          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_ESS_inv') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_ESS_inv     
			  
          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_ESS_220_240') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_ESS_220_240     
			  
          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_ESS_320_340') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_ESS_320_340     

          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_ESS_520_540') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_ESS_520_540                                        
			  
          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_ESS_350') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_ESS_350     
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP			  


          IF OBJECT_ID('tempdb..#TMP_SCP_ANL_PSI_INTEGRATION_CALC') IS NOT NULL                        
              DROP TABLE #TMP_SCP_ANL_PSI_INTEGRATION_CALC       
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS			  

			 

           CREATE TABLE #tmp_PSI_INTEGRATION_ESS_INV(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
				YYYYMMDD				NVARCHAR(8)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				DESCR					NVARCHAR(4000)  NULL,
                ATTRIBUTE8              NVARCHAR(150)   NULL,     
				FLOW_ID					NVARCHAR(200)   NULL, 
				OPERATION_GROUP			NVARCHAR(1)     NULL
            );   

           CREATE TABLE #tmp_PSI_INTEGRATION_ESS_220_240(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				to_COMPANY_ID			NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				to_PLANT_ID			    NVARCHAR(10)	NULL,
				BOD_ID					NVARCHAR(300)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				lt_total_ssp			int				NULL,
				departure_YYYYMMDD		NVARCHAR(8)     NULL,
				arrival_YYYYMMDD		NVARCHAR(8)     NULL
            );   			  

           CREATE TABLE #tmp_PSI_INTEGRATION_ESS_320_340(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				to_COMPANY_ID			NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				to_PLANT_ID			    NVARCHAR(10)	NULL,
				BOD_ID					NVARCHAR(300)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				lt_total_ssp			int				NULL,
				departure_YYYYMMDD		NVARCHAR(8)     NULL,
				arrival_YYYYMMDD		NVARCHAR(8)     NULL
            );   			  

           CREATE TABLE #tmp_PSI_INTEGRATION_ESS_520_540(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
                ORIGIN_FROM_DIVISION_ID NVARCHAR(10)    NULL,
                ORIGIN_TO_DIVISION_ID   NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				to_COMPANY_ID		    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				to_PLANT_ID			    NVARCHAR(10)	NULL,
				BOD_ID					NVARCHAR(300)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				lt_total_ssp			int				NULL,
				departure_YYYYMMDD		NVARCHAR(8)     NULL,
				arrival_YYYYMMDD		NVARCHAR(8)     NULL
            );   	

           CREATE TABLE #tmp_PSI_INTEGRATION_ESS_350(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
                CELL_ITEM_ID            NVARCHAR(40)    NULL,       
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            MEASURE                 NVARCHAR(20)    NULL,
				VALUE_TYPE				NVARCHAR(10)    NULL,
				TO_PRODUCT				NVARCHAR(100)   NULL,
				LINE_ID					NVARCHAR(10)    NULL,
                BOH_QTY					NUMERIC(20, 10) NULL,     
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
				SEQ_FLAG				NVARCHAR(5)     NULL,
				YYYYMM				    NVARCHAR(6)     NULL,
	            QTY			            NUMERIC(20, 10) NULL
            );    


           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
                CELL_ITEM_ID            NVARCHAR(40)    NULL,       
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            MEASURE                 NVARCHAR(20)    NULL,
				VALUE_TYPE				NVARCHAR(10)    NULL,
				TO_PRODUCT				NVARCHAR(100)   NULL,
				LINE_ID					NVARCHAR(10)    NULL,
                BOH_QTY					NUMERIC(20, 10) NULL,     
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
				SEQ_FLAG				NVARCHAR(5)     NULL,
				YYYYMMDD			    NVARCHAR(8)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				CREATED_BY				nvarchar(150)   NULL,
				CREATION_DATE           datetime        NULL,
				LAST_UPDATED_BY         nvarchar(150)   NULL,
				LAST_UPDATE_DATE        datetime        NULL, 
                ATTRIBUTE1              NVARCHAR(150)   NULL,     
                ATTRIBUTE2              NVARCHAR(150)   NULL,     
                ATTRIBUTE3              NVARCHAR(150)   NULL,     
                ATTRIBUTE4              NVARCHAR(150)   NULL,     
                ATTRIBUTE5              NVARCHAR(150)   NULL,     
                ATTRIBUTE6              NVARCHAR(150)   NULL,     
                ATTRIBUTE7              NVARCHAR(150)   NULL,     
                ATTRIBUTE8              NVARCHAR(150)   NULL,     
                ATTRIBUTE9              NVARCHAR(150)   NULL,     
                ATTRIBUTE10             NVARCHAR(150)   NULL     
            );    


			CREATE TABLE #TMP_SCP_ANL_PSI_INTEGRATION_CALC(
				DIVISION_ID nvarchar(10) NOT NULL,
				COMPANY_ID nvarchar(10) NOT NULL,
				PLANT_ID nvarchar(10) NOT NULL,
				PLAN_START_YYYYMMDD nvarchar(8) NOT NULL,
				SEQ bigint NOT NULL,
				OPERATION_GROUP nvarchar(1) NOT NULL,
				FROM_SITE nvarchar(30) NOT NULL,
				CELL_ITEM_ID nvarchar(40) NOT NULL,
				ITEM_ID nvarchar(40) NOT NULL,
				MEASURE nvarchar(20) NOT NULL,
				VALUE_TYPE nvarchar(10) NOT NULL,
				TO_PRODUCT nvarchar(100) NOT NULL,
				LINE_ID nvarchar(10) NOT NULL,
				BOH_QTY numeric(20, 10) NULL,
				TO_SITE nvarchar(30) NOT NULL,
				INCOTERMS nvarchar(5) NOT NULL,
				SEQ_FLAG nvarchar(5) NULL,
				YYYYMM nvarchar(6) NOT NULL,
				QTY numeric(20, 10) NULL,
				CREATED_BY nvarchar(150) NOT NULL,
				CREATION_DATE datetime NOT NULL,
				LAST_UPDATED_BY nvarchar(150) NOT NULL,
				LAST_UPDATE_DATE datetime NOT NULL,
				ATTRIBUTE1 nvarchar(150) NULL,
				ATTRIBUTE2 nvarchar(150) NULL,
				ATTRIBUTE3 nvarchar(150) NULL,
				ATTRIBUTE4 nvarchar(150) NULL,
				ATTRIBUTE5 nvarchar(150) NULL,
				ATTRIBUTE6 nvarchar(150) NULL,
				ATTRIBUTE7 nvarchar(150) NULL,
				ATTRIBUTE8 nvarchar(150) NULL,
				ATTRIBUTE9 nvarchar(150) NULL,
				ATTRIBUTE10 nvarchar(150) NULL
			)
			create index i_#TMP_SCP_ANL_PSI_INTEGRATION_CALC_01 on #TMP_SCP_ANL_PSI_INTEGRATION_CALC(item_id)
			create index i_#TMP_SCP_ANL_PSI_INTEGRATION_CALC_02 on #TMP_SCP_ANL_PSI_INTEGRATION_CALC(YYYYMM, item_id)
                        
           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
	            SEQ                     BIGINT          NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
                CELL_ITEM_ID            NVARCHAR(40)    NULL,       
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            MEASURE                 NVARCHAR(20)    NULL,
				VALUE_TYPE				NVARCHAR(10)    NULL,
				TO_PRODUCT				NVARCHAR(100)   NULL,
				LINE_ID					NVARCHAR(10)    NULL,
                BOH_QTY					NUMERIC(20, 10) NULL,     
	            TO_SITE                 NVARCHAR(30)    NULL,
				INCOTERMS				NVARCHAR(5)     NULL,
				SEQ_FLAG				NVARCHAR(5)     NULL,
				YYYYMMDD			    NVARCHAR(8)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				CREATED_BY				nvarchar(150)   NULL,
				CREATION_DATE           datetime        NULL,
				LAST_UPDATED_BY         nvarchar(150)   NULL,
				LAST_UPDATE_DATE        datetime        NULL, 
                ATTRIBUTE1              NVARCHAR(150)   NULL,     
                ATTRIBUTE2              NVARCHAR(150)   NULL,     
                ATTRIBUTE3              NVARCHAR(150)   NULL,     
                ATTRIBUTE4              NVARCHAR(150)   NULL,     
                ATTRIBUTE5              NVARCHAR(150)   NULL,     
                ATTRIBUTE6              NVARCHAR(150)   NULL,     
                ATTRIBUTE7              NVARCHAR(150)   NULL,     
                ATTRIBUTE8              NVARCHAR(150)   NULL,     
                ATTRIBUTE9              NVARCHAR(150)   NULL,     
                ATTRIBUTE10             NVARCHAR(150)   NULL     
            );       
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_ESS_01 on #tmp_SCP_ANL_PSI_INTEGRATION_ESS(item_id)
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_ESS_02 on #tmp_SCP_ANL_PSI_INTEGRATION_ESS(YYYYMMDD, item_id)


           
          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    0.MKT FCST 입력
          ------------------------------------------------------------------------------------------------------------- 
--/* jjg 나중에 하자1 start
            SET @V_STATUS_DESC = '0.MKT FCST ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				'' as COMPANY_ID, 
				'' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'P' as operation_group, -- a.operation_group,
				'-' as FROM_SITE,
                '' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   -- shipment 에는 Line_id 없으므로 공백처리gka.
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
				a.incoterms, 
--ess				(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) AS SEQ_FLAG,  
				'100' AS SEQ_FLAG,  -- 정렬   
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					--a.SEQ,
					--a.operation_group,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) ,
					a.YYYYMMDD
--jjg 나중에 하자1 end*/

-- '200'
		  -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    200. MKT FCST
          -------------------------------------------------------------------------------------------------------------  
  		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				'' as COMPANY_ID, 
				'' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'P' as operation_group, --a.operation_group,
				'-' as FROM_SITE,
                '' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   -- shipment 에는 Line_id 없으므로 공백처리gka.
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
				a.incoterms, 
--ess				(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) AS SEQ_FLAG,  
				'200' AS SEQ_FLAG,  -- 정렬   
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					--a.SEQ,
					--a.operation_group,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) ,
					a.YYYYMMDD

--select 'jjgkk9-1 : ' +  convert(varchar(19), getdate(),121)  

-- '300'
--select '111'
 		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				'' as COMPANY_ID, 
				'' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'A' as operation_group, --a.operation_group,
				'-' as FROM_SITE,
                '' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   -- shipment 에는 Line_id 없으므로 공백처리gka.
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
				a.incoterms, 
--ess				(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) AS SEQ_FLAG,  
				'300' AS SEQ_FLAG,  -- 정렬   
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					--a.SEQ,
					--a.operation_group,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '100'
--ess					  WHEN a.operation_group = 'A' THEN '300'
--ess				      END ) ,
					a.YYYYMMDD




          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    1.Ship. Plan(RTF) 입력
          ------------------------------------------------------------------------------------------------------------- 
--select 'jjgkk1 : ' +  convert(varchar(19), getdate(),121)


            SET @V_STATUS_DESC = '1.Ship. Plan(RTF)  ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID
			    ,COMPANY_ID
			    ,PLANT_ID 
	            ,PLAN_START_YYYYMMDD
	            ,SEQ
				,OPERATION_GROUP
	            ,FROM_SITE
                ,CELL_ITEM_ID
	            ,ITEM_ID
	            ,MEASURE
				,VALUE_TYPE
				,TO_PRODUCT
				,LINE_ID
                ,BOH_QTY
	            ,TO_SITE
				,INCOTERMS
				,SEQ_FLAG
				,YYYYMMDD 
				,QTY
			 )
         SELECT a.DIVISION_ID
				,B.COMPANY_ID
				,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID  
	            ,a.PLAN_START_YYYYMMDD
	            ,1 AS SEQ --,a.SEQ
				,'P' as operation_group --a.operation_group
				,'-' as FROM_SITE
                ,'' as CELL_ITEM_ID  
	            ,a.ITEM_ID
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'-' as value_type
				,'-' as TO_PRODUCT
				,''  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ) AS TO_SITE
				,a.incoterms
--ess				,(CASE WHEN a.operation_group = 'P' THEN '110'
--ess					  WHEN a.operation_group = 'A' THEN '310'
--ess				      END ) AS SEQ_FLAG  
				,'110' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
--	            ,isnull(ALLOCATION_QTY,1) as QTY
			-- SELECT *
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 --and b.SCM_SITE_ID = a.plant_site_id
				 and b.SCM_SITE_ID = --a.plant_site_id
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.item_id
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													and k.incoterms = a.incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
													and k.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
													and k.seq = @V_PLAN_SEQ --a.seq
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.item_id
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		and m.incoterms = a.incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
																		and m.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
																		and m.seq = @V_PLAN_SEQ --a.seq
																		and m.qty <> 0
																		and m.measure = 'SHIP_PLAN_AMEND' ) --'SHIP_PLAN_AMEND' )	
													and k.measure = 'SHIP_PLAN_AMEND')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from [10.34.221.78,7433].eng_scp.dbo.th_exp_delivery de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.item_id
													--and de.item_id = a.from_item_id  -- 이관시 from_item_id 로 변경할 것.
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )

			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  --and a.item_id = 'APBMWHAF0-A1-010'
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
					 --a.SEQ,
					 --a.operation_group,
					 a.ITEM_ID,
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					 a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '110'
--ess						  WHEN a.operation_group = 'A' THEN '310'
--ess						  END ),
					a.YYYYMMDD

--select 'jjgkk2 : ' +  convert(varchar(19), getdate(),121)  
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

--- '210'
		  -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    210. Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------  
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID
			    ,COMPANY_ID
			    ,PLANT_ID 
	            ,PLAN_START_YYYYMMDD
	            ,SEQ
				,OPERATION_GROUP
	            ,FROM_SITE
                ,CELL_ITEM_ID
	            ,ITEM_ID
	            ,MEASURE
				,VALUE_TYPE
				,TO_PRODUCT
				,LINE_ID
                ,BOH_QTY
	            ,TO_SITE
				,INCOTERMS
				,SEQ_FLAG
				,YYYYMMDD 
				,QTY
			 )
         SELECT a.DIVISION_ID
				,B.COMPANY_ID
				,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID  
	            ,a.PLAN_START_YYYYMMDD
	            ,1 AS SEQ --,a.SEQ
				,'P' as operation_group --a.operation_group
				,'-' as FROM_SITE
                ,'' as CELL_ITEM_ID  
	            ,a.ITEM_ID
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'-' as value_type
				,'-' as TO_PRODUCT
				,''  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ) AS TO_SITE
				,a.incoterms
--ess				,(CASE WHEN a.operation_group = 'P' THEN '110'
--ess					  WHEN a.operation_group = 'A' THEN '310'
--ess				      END ) AS SEQ_FLAG  
				,'210' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
--	            ,isnull(ALLOCATION_QTY,1) as QTY
			-- SELECT *
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 --and b.SCM_SITE_ID = a.plant_site_id
				 and b.SCM_SITE_ID = --a.plant_site_id
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.item_id
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													and k.incoterms = a.incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
													and k.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
													and k.seq = @V_PLAN_SEQ --a.seq
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.item_id
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		and m.incoterms = a.incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
																		and m.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
																		and m.seq = @V_PLAN_SEQ --a.seq
																		and m.qty <> 0
																		and m.measure = 'SHIP_PLAN_AMEND' ) --'SHIP_PLAN_AMEND' )	
													and k.measure = 'SHIP_PLAN_AMEND')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from [10.34.221.78,7433].eng_scp.dbo.th_exp_delivery de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.item_id
													--and de.item_id = a.from_item_id  -- 이관시 from_item_id 로 변경할 것.
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  --and a.item_id = 'APBMWHAF0-A1-010'
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
					 --a.SEQ,
					 --a.operation_group,
					 a.ITEM_ID,
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					 a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '110'
--ess						  WHEN a.operation_group = 'A' THEN '310'
--ess						  END ),
					a.YYYYMMDD


-- '310' 
--select 'jjgkk9-2 : ' +  convert(varchar(19), getdate(),121)  


		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID
			    ,COMPANY_ID
			    ,PLANT_ID 
	            ,PLAN_START_YYYYMMDD
	            ,SEQ
				,OPERATION_GROUP
	            ,FROM_SITE
                ,CELL_ITEM_ID
	            ,ITEM_ID
	            ,MEASURE
				,VALUE_TYPE
				,TO_PRODUCT
				,LINE_ID
                ,BOH_QTY
	            ,TO_SITE
				,INCOTERMS
				,SEQ_FLAG
				,YYYYMMDD 
				,QTY
			 )
         SELECT a.DIVISION_ID
				,B.COMPANY_ID
				,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID  
	            ,a.PLAN_START_YYYYMMDD
	            ,1 AS SEQ --,a.SEQ
				,'A' as operation_group --a.operation_group
				,'-' as FROM_SITE
                ,'' as CELL_ITEM_ID  
	            ,a.ITEM_ID
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'PRD' as value_type
				,'-' as TO_PRODUCT
				,''  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ) AS TO_SITE
				,a.incoterms
--ess				,(CASE WHEN a.operation_group = 'P' THEN '110'
--ess					  WHEN a.operation_group = 'A' THEN '310'
--ess				      END ) AS SEQ_FLAG  
				,'310' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
--	            ,isnull(ALLOCATION_QTY,1) as QTY
			-- SELECT *
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 --and b.SCM_SITE_ID = a.plant_site_id
				 and b.SCM_SITE_ID = --a.plant_site_id
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.item_id
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													and k.incoterms = a.incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
													and k.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
													and k.seq = @V_PLAN_SEQ --a.seq
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.item_id
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		and m.incoterms = a.incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  --a.DIVISION_ID
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --a.PLAN_START_YYYYMMDD
																		and m.PLAN_TYPE = @V_PLAN_TYPE  --a.PLAN_TYPE
																		and m.seq = @V_PLAN_SEQ --a.seq
																		and m.qty <> 0
																		and m.measure = 'SHIP_PLAN_AMEND' ) --'SHIP_PLAN_AMEND' )	
													and k.measure = 'SHIP_PLAN_AMEND')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from [10.34.221.78,7433].eng_scp.dbo.th_exp_delivery de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.item_id
													--and de.item_id = a.from_item_id  -- 이관시 from_item_id 로 변경할 것.
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
--ess			  AND a.operation_group IN ('A','P')   
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  --and a.item_id = 'APBMWHAF0-A1-010'
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
					 --a.SEQ,
					 --a.operation_group,
					 a.ITEM_ID,
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					 a.incoterms,
--ess					(CASE WHEN a.operation_group = 'P' THEN '110'
--ess						  WHEN a.operation_group = 'A' THEN '310'
--ess						  END ),
					a.YYYYMMDD

--select 'jjgkk9-2 : ' +  convert(varchar(19), getdate(),121)  

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    5.PROD_PLAN 입력
          -------------------------------------------------------------------------------------------------------------  
-- '150'

            SET @V_STATUS_DESC = '5.PROD_PLAN ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				--B.PLANT_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'P' as operation_group, --a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
--ess				(CASE WHEN a.operation_group = 'P' THEN '150'
--ess					  WHEN a.operation_group = 'A' THEN '450'
--ess				      END ) AS SEQ_FLAG,  
				'150'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
--ess			  AND a.operation_group IN ('A','P') 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,  
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
				     --a.SEQ,
					 --a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
--ess					(CASE WHEN a.operation_group = 'P' THEN '150'
--ess						  WHEN a.operation_group = 'A' THEN '450'
--ess						  END ),
					a.YYYYMMDD



-- '250'
            SET @V_STATUS_DESC = '5.PROD_PLAN ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				--B.PLANT_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'P' as operation_group, --a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
--ess				(CASE WHEN a.operation_group = 'P' THEN '150'
--ess					  WHEN a.operation_group = 'A' THEN '450'
--ess				      END ) AS SEQ_FLAG,  
				'250'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
--ess			  AND a.operation_group IN ('A','P') 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,  
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
				     --a.SEQ,
					 --a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
--ess					(CASE WHEN a.operation_group = 'P' THEN '150'
--ess						  WHEN a.operation_group = 'A' THEN '450'
--ess						  END ),
					a.YYYYMMDD

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) inv start
		  --    6.BOH 입력
          -------------------------------------------------------------------------------------------------------------  
--select 'jjgkk3 : ' +  convert(varchar(19), getdate(),121)  

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 

/*
set @V_STATUS_DESC = '6.BOH ';


select 'jjj1'

select @V_MASTER_ID
select @V_ENG_PLAN_ID
select @V_HORIZON_END_YYYYMMDD
select @V_DIVISION_ID


SELECT   SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
--					,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID,1,2)
					and C.division_id = @V_DIVISION_ID  
					--and c.FLOW_ID <> 'P5000' 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on b.scm_sitE_id = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
					and b.division_id = @V_DIVISION_ID 
				 and ( ISNULL(b.osp_yn, 'N') = 'N' 
				    OR (ISNULL(b.osp_yn, 'N') = 'Y' AND descr LIKE 'INT%')
				     )
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID  
			AND A.PLAN_ID     = @V_ENG_PLAN_ID  
--			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					--, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP

select 'jjj2'

return
*/



--


--
			insert into #tmp_PSI_INTEGRATION_ESS_INV
			SELECT   SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
--					,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID,1,2)
					and C.division_id = @V_DIVISION_ID  
					--and c.FLOW_ID <> 'P5000' 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on b.scm_sitE_id = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
					and b.division_id = @V_DIVISION_ID 
				 and ( ISNULL(b.osp_yn, 'N') = 'N' 
				    OR (ISNULL(b.osp_yn, 'N') = 'Y' AND descr LIKE 'INT%')
				     )
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID  
			AND A.PLAN_ID     = @V_ENG_PLAN_ID  
--			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					--, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP


			/*****************************************
				#tmp_PSI_INTEGRATION_ESS_inv  'P5000'을 추가.
			******************************************/
--select 'jjgkk4 : ' +  convert(varchar(19), getdate(),121)  


            SET @V_STATUS_DESC = '6.BOH P5000';


			/****************************************************
			EE 재고('560')를 #tmp_PSI_INTEGRATION_ESS_inv 에 추가로 insert 해야함.
			****************************************************/

--select 'jjgkk5 : ' +  convert(varchar(19), getdate(),121)  
--KSK : 자동차에선 'ec' 가 아닌 것으로 조건 추가
            SET @V_STATUS_DESC = '6.BOH EE';

			INSERT INTO #tmp_PSI_INTEGRATION_ESS_inv
			SELECT   @V_DIVISION_ID 
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					--,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,'' as attribute8, 'E2000' FLOW_ID, 'E' as OPERATION_GROUP			
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)  
			inner join (select distinct item_id from [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item  WITH(NOLOCK)   
			            where division_id = @V_DIVISION_ID --'82' --@V_DIVISION_ID
						and FLOW_ID like 'E2000%'
						and cell_item_id like 'EC%'
			           ) c
					on C.item_id = A.ITEM_ID
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site d WITH(NOLOCK)   
					on d.scm_sitE_id = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
					and d.division_id = @V_DIVISION_ID 
					--and d.operation_group = 'E'
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_EE_MASTER_ID 
			AND A.PLAN_ID     = @V_EE_ENG_PLAN_ID 
			--AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					--, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR

--select 'jjgkk6 : ' +  convert(varchar(19), getdate(),121)  
--select * from #tmp_PSI_INTEGRATION_ESS_inv 
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '81', '20240527'  

			update a set company_id = b.company_id, 
						 plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a  -- 1094
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = a.from_site	

--select 'jjgkk7 : ' +  convert(varchar(19), getdate(),121)  

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'

			update a set	company_id = b.company_id,  --(case when isnull(a.COMPANY_ID,'') < '0'  then b.company_id else a.company_id end),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			-- select *
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  -- '20240527' 
										and k.PLAN_TYPE = @V_PLAN_TYPE --'FN' 
										and k.seq = @V_PLAN_SEQ  --'1' 
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  -- '20240527'  
															and m.PLAN_TYPE =  @V_PLAN_TYPE  -- 'FN' --
															and m.seq = @V_PLAN_SEQ  -- '1' 
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'


			update a set	company_id = b.company_id,  --(case when isnull(a.COMPANY_ID,'') < '0'  then b.company_id else a.company_id end),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			-- select *
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										--and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  -- '20240527' 
										and k.PLAN_TYPE = @V_PLAN_TYPE --'FN' 
										and k.seq = @V_PLAN_SEQ  --'1' 
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															--and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  -- '20240527'  
															and m.PLAN_TYPE =  @V_PLAN_TYPE  -- 'FN' --
															and m.seq = @V_PLAN_SEQ  -- '1' 
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'

--select 'jjgkk8 : ' +  convert(varchar(19), getdate(),121)  
--select 'BEFORE INV : ' +  convert(varchar(19), getdate(),121) 
--select seq_flag, COUNT(*) from #tmp_SCP_ANL_PSI_INTEGRATION_ESS group by seq_flag order by seq_flag --order by seq_flag, YYYYMMDD, ITEM_ID
--select * from #tmp_SCP_ANL_PSI_INTEGRATION_ESS ORDER BY SEQ_FLAG, YYYYMMDD, ITEM_ID
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'  

select 'jjgaa00'

/*
select *
from #tmp_PSI_INTEGRATION_ESS_inv
where  item_ID = 'ERT5422CN301'

return
*/
/*
SELECT PLAN_START_YYYYMMDD, SEQ, seq_flag, operation_group, COUNT(*)
-- SELECT *
FROM SCP_ANL_PSI_INTEGRATION WITH(NOLOCK) 
where division_id = '82'
AND PLAN_START_YYYYMMDD = '20240610'
and item_ID = 'ERT5422CN301'
AND MEASURE = 'INV'
*/

select 'jjgyy00'
            SET @V_STATUS_DESC = '6.BOH inv';

--'160' :  STOCK_OSP 의 외부 업체(OSP= 'Y') 정보 입력. (RACK/DC 임)

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
						)
				SELECT   h.DIVISION_ID as DIVISION_ID
						,h.company_id
						,h.PLANT_ID as PLANT_ID
						,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
						,1 AS SEQ --@V_PLAN_SEQ AS SEQ
						,'P' as operation_group --b.OPERATION_GROUP as OPERATION_GROUP
						,'-'  AS FROM_SITE
						,'' as CELL_ITEM_ID 
						,h.ITEM_ID 
						,'INV' as MEASURE
						,'-' as value_type
						,'-' as TO_PRODUCT
						,'-' as LINE_ID
						,isnull(sum(isnull(h.BOH_QTY,0)),0)   AS BOH_QTY  
						,'-' as TO_SITE
						,'-' as incoterms
						,'160' as SEQ_FLAG
						,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
						,0
				from (
										SELECT   so.DIVISION_ID as DIVISION_ID
												,b.company_id
												,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
													  else  b.PLANT_ID
													  end ) as PLANT_ID
												,so.ITEM_ID 
												,isnull(so.QTY,0)   AS BOH_QTY  
										FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
										INNER JOIN scp_mst_final_item_v fi with(nolock)  -- 9
												on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
												and fi.operation_group = 'P'
												and fi.ITEM_ID = so.item_id
										inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
											 on  b.DIVISION_ID = so.DIVISION_ID
											 and b.SCM_SITE_ID = so.SCM_SITE_ID
											 and b.operation_group = 'P'
											 and b.osp_yn = 'Y'
										where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  --'20240526'  --  dateadd(d, -1, @V_PLAN_START_YYYYMMDD) 
										and so.division_id = @V_DIVISION_ID  --'82' --
										UNION ALL
										SELECT   a.division_id as DIVISION_ID
												,a.company_id
												--,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id  -- 위에서 #tmp_PSI_INTEGRATION_ESS_inv 입력시 반영했음.
												--	  else  b.PLANT_ID
												--	  end ) as PLANT_ID
												,a.PLANT_ID
												,A.ITEM_ID 
												,isnull(A.QTY,0) AS BOH_QTY  
										FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
										INNER JOIN scp_mst_final_item_v fi with(nolock)
												on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
												and fi.operation_group = 'P'
												and fi.ITEM_ID = a.item_id 
										inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
											 on  b.DIVISION_ID = a.DIVISION_ID
											 and b.SCM_SITE_ID = a.FROM_SITE
											 --and b.operation_group = 'P'
											 and (b.operation_group = 'P' or b.site_type = 'SALES')
										WHERE a.operation_group='P' 
						) h
			GROUP BY h.DIVISION_ID
					,h.company_id
					,h.plant_id
					,h.ITEM_ID 


/*
			SELECT TOP 100 *
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site WITH(NOLOCK)
*/
/*
select 'jjgyy00'
SELECT   *
FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
WHERE a.item_id = 'ERT5422CN301'

select 'jjgyy01'
*/
/*
										SELECT   a.division_id as DIVISION_ID
												,a.company_id
												,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
													  else  b.PLANT_ID
													  end ) as PLANT_ID
												,A.ITEM_ID 
												,isnull(A.QTY,0) AS BOH_QTY
												--,from_site
										FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
										INNER JOIN scp_mst_final_item_v fi with(nolock)
												on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
												and fi.operation_group = 'P'
												and fi.ITEM_ID = a.item_id 
										inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
											 on  b.DIVISION_ID = a.DIVISION_ID
											 and b.SCM_SITE_ID = a.FROM_SITE
												and (b.operation_group = 'P' or b.site_type = 'SALES')
										WHERE a.operation_group='P' 
										and a.item_id = 'ERT5422CN301'

select 'jjgyy11'
select *
from #tmp_SCP_ANL_PSI_INTEGRATION_ESS
where division_id = '82'
AND PLAN_START_YYYYMMDD = '20240610'
and item_ID = 'ERT5422CN301'
AND MEASURE = 'INV'
*/
select 'jjgyy12'

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'  

-- '260' STOCK_OSP 의 외부 업체(OSP= 'Y') 정보 입력. (RACK/DC 가 아님)
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   h.division_id as DIVISION_ID
					,h.company_id
					,h.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'P' as operation_group --b.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,h.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(h.BOH_QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'260' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			from ( 	
							SELECT   so.division_id as DIVISION_ID
									,b.company_id
									,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
											else  b.PLANT_ID
											end ) as PLANT_ID
									,so.ITEM_ID 
									,isnull(so.QTY,0)   AS BOH_QTY  
							FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
							INNER JOIN scp_mst_final_item_v fi with(nolock)  -- 60
									on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
									and fi.operation_group = 'P'
									and fi.ITEM_ID = so.item_id
							inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
									on  b.DIVISION_ID = so.DIVISION_ID
									and b.SCM_SITE_ID = so.SCM_SITE_ID
									and b.operation_group = 'P'
									and b.osp_yn = 'Y'
							where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  --'20240526'  --  dateadd(d, -1, @V_PLAN_START_YYYYMMDD) 
							and so.division_id = @V_DIVISION_ID
						
							UNION ALL

							SELECT   a.division_id as DIVISION_ID
									,a.company_id
									--,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
									--		else  b.PLANT_ID
									--		end ) as PLANT_ID
									,a.PLANT_ID
									,A.ITEM_ID 
									,isnull(A.QTY,0) AS BOH_QTY  
							FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
							INNER JOIN scp_mst_final_item_v fi with(nolock)
									on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
									and fi.operation_group = 'P'
									and fi.ITEM_ID = a.item_id
							inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
									on  b.DIVISION_ID = a.DIVISION_ID
									and b.SCM_SITE_ID = a.FROM_SITE
--									and b.operation_group = 'P'
									and (b.operation_group = 'P' or b.site_type = 'SALES')
							WHERE a.operation_group='P' 
				) h
			GROUP BY h.DIVISION_ID
					,h.company_id
					,h.plant_id
					,h.ITEM_ID 


select 'jjgyy02'
--return
---- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
---- ksk jjg 370 start
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)

			SELECT   so.division_id as DIVISION_ID
					,b.company_id
					,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
							else  b.PLANT_ID
							end ) as PLANT_ID
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'A' as operation_group --b.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,so.ITEM_ID 
					,'INV' as MEASURE
					,'PUR' as value_type  --so.ATTRIBUTE1 as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(so.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'370' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = so.DIVISION_ID
					and b.SCM_SITE_ID = so.SCM_SITE_ID
					and b.operation_group = 'P'
					and b.osp_yn = 'Y'
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = so.item_id
					and c.DIVISION_ID = so.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
			where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  --'20240526'  --  dateadd(d, -1, @V_PLAN_START_YYYYMMDD) 
			and so.division_id = '82' --@V_DIVISION_ID
			and so.ATTRIBUTE1 = 'PUR'
			GROUP BY so.DIVISION_ID
					,b.company_id
					,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
							else  b.PLANT_ID
							end )
					,so.ITEM_ID 
					,so.ATTRIBUTE1

select 'jjgyy222'
--return
---- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
---- ksk jjg 370 end
---- ksk jjg 380 start
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   h.division_id as DIVISION_ID
					,h.company_id
					,h.PLANT_ID as PLANT_ID
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'A' as operation_group --b.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,h.ITEM_ID 
					,'INV' as MEASURE
					,'PRD' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(h.BOH_QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'380' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			from (
							SELECT   so.division_id as DIVISION_ID
									,b.company_id
									,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
											else  b.PLANT_ID
											end ) as PLANT_ID
									,so.ITEM_ID 
									,isnull(so.QTY,0) AS BOH_QTY  
							FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
							inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
									on  b.DIVISION_ID = so.DIVISION_ID
									and b.SCM_SITE_ID = so.SCM_SITE_ID
									and b.operation_group = 'P'
									and b.osp_yn = 'Y'
							inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
									on c.item_id = so.item_id
									and c.DIVISION_ID = so.DIVISION_ID
									and c.OPERATION_GROUP_ID = 'A'  
							where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  --'20240526'  --  dateadd(d, -1, @V_PLAN_START_YYYYMMDD) 
							and so.division_id = '82' --@V_DIVISION_ID
							and isnull(so.ATTRIBUTE1,'') < > 'PUR' -- 'PRD'
							UNION ALL
							SELECT   a.division_id as DIVISION_ID
									,a.company_id
									,a.plant_id
									,A.ITEM_ID 
									,isnull(a.QTY,0) AS BOH_QTY
							FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
							WHERE a.operation_group='A' 
							--and a.Flow_id in ('P5500','P9500')
					) h
				group by h.division_id
						,h.company_id
						,h.plant_id
						--,h.OPERATION_GROUP
						,h.ITEM_ID
select 'jjgyy333'
--return
---- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 

---- ksk jjg 380 end




-- ksk jjg

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 

-- '360' 의 PRD는  stock_plan 에서 입력  + STOCK_OSP 의 외주가 아닌(OSP= 'N') 정보 입력.
-- '360' PUR stock_osp
/*
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   so.division_id as DIVISION_ID
					,b.company_id
					--,b.plant_id
					,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						   else  b.PLANT_ID
						   end ) as PLANT_ID
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'A' as operation_group --b.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,so.ITEM_ID 
					,'INV' as MEASURE
					,(CASE WHEN isnull(so.ATTRIBUTE1,'') = '' THEN 'PRD'
					      ELSE so.ATTRIBUTE1
						  END ) as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(so.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'370' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
		    --select DISTINCT so.SCM_SITE_ID  
			-- select top 100 * 
			-- select *
			FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = so.DIVISION_ID
				 and b.SCM_SITE_ID = so.SCM_SITE_ID
				 and b.operation_group = 'P'
				 and b.osp_yn = 'Y'
			--KSK  FINAL ITEM 의 CELL 조건 추가.
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = so.item_id
					and c.DIVISION_ID = so.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					--and c.attribute8 = 'CP'
			where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  --'20240526'  --  dateadd(d, -1, @V_PLAN_START_YYYYMMDD) 
			and so.division_id = '82' --@V_DIVISION_ID
			GROUP BY so.DIVISION_ID
					,b.company_id
					--,b.plant_id
					,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end )
					--,b.OPERATION_GROUP
					,so.ITEM_ID 
					,(CASE WHEN isnull(so.ATTRIBUTE1,'') = '' THEN 'PRD'
					      ELSE so.ATTRIBUTE1
						  END ) 
*/
select 'jjgyy03'
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
-- '360' PRD stock_PLAN

/*
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'A' as operation_group -- a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'PRD' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'380' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
			WHERE a.operation_group='A' 
			--and a.Flow_id in ('P5500','P9500')
			group by a.division_id
					,a.company_id
					,a.plant_id
					--,a.OPERATION_GROUP
					,A.ITEM_ID 
*/


            SET @V_STATUS_DESC = '5.PROD_PLAN ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				--B.PLANT_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'A' as operation_group, --a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
--ess				(CASE WHEN a.operation_group = 'P' THEN '150'
--ess					  WHEN a.operation_group = 'A' THEN '450'
--ess				      END ) AS SEQ_FLAG,  
				'350'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
--ess			  AND a.operation_group IN ('A','P') 
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 --B.PLANT_ID,  
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
				     --a.SEQ,
					 --a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
--ess					(CASE WHEN a.operation_group = 'P' THEN '150'
--ess						  WHEN a.operation_group = 'A' THEN '450'
--ess						  END ),
					a.YYYYMMDD

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
---KSK2 360, 370, 380 도 CA 부품은 CP로 전환 확인하기.

SELECT 'KKKK11'

		  -- CA 부품은 CP로 전환
			update a set item_id = x.item_id_prod  --, MEASURE = 'test'
			from #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP a
			inner join (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
							FROM   [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
								INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item f WITH(NOLOCK)
								ON  c.division_id  = f.division_id
								AND c.item_id_prod = f.item_id
								AND f.ATTRIBUTE8   = 'CP'
							WHERE  c.cell_type = 'CA1' 
							AND    c.valid_yn  = 'Y'   
							GROUP BY c.division_id, c.item_id_assy) x
			on x.DIVISION_ID = a.DIVISION_ID
			and x.item_id_assy = a.ITEM_ID
			--where a.seq_flag = '350'
			where a.seq_flag in ('350','360','370','380')

--select 'jjgkk9-99 : ' +  convert(varchar(19), getdate(),121)  


SELECT 'KKKK12'

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				A.COMPANY_ID,
				A.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group, 
				A.FROM_SITE AS FROM_SITE,   
                '' as CELL_ITEM_ID,
	            A.ITEM_ID,
	            A.MEASURE as MEASURE,
				A.VALUE_TYPE as value_type,
				A.TO_PRODUCT as TO_PRODUCT,
				a.LINE_ID,
                isnull(sum(isnull(A.BOH_QTY,0)),0) as BOH_QTY,
	            A.TO_SITE as TO_SITE,
				A.INCOTERMS AS INCOTERMS,
--ess				(CASE WHEN a.operation_group = 'P' THEN '150'
--ess					  WHEN a.operation_group = 'A' THEN '450'
--ess				      END ) AS SEQ_FLAG,  
				A.SEQ_FLAG  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			--SELECT PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, YYYYMMDD
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP A
			group by PLAN_START_YYYYMMDD, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMMDD

SELECT 'KKKK13' 

SELECT 'KKKK14'

-- '560'  --전극 재고는 stock_plan 에서 입력

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'E' as operation_group --a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'560' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
			WHERE a.operation_group='E' 
			--and a.Flow_id in ('P5500','P9500')
			group by a.division_id
					,a.company_id
					,a.plant_id
					--,a.OPERATION_GROUP
					,A.ITEM_ID 
SELECT 'KKKK15'

/*
select 'AFTER 360 INV : ' +  convert(varchar(19), getdate(),121) 
select seq_flag, COUNT(*) from #tmp_SCP_ANL_PSI_INTEGRATION_ESS group by seq_flag order by seq_flag --order by seq_flag, YYYYMMDD, ITEM_ID
select * from #tmp_SCP_ANL_PSI_INTEGRATION_ESS WHERE SEQ_FLAG IN ('160','260','360','560') ORDER BY SEQ_FLAG, YYYYMMDD, ITEM_ID 
return

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527'  
*/
/*

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,@V_PLAN_SEQ AS SEQ
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,(case when a.operation_group='P' and  a.Flow_id in ('P5500','P9500')      then '160'  
						   when a.operation_group='P' and  a.Flow_id not in ('P5500','P9500')  then '260'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP'  then '360'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA'  then '460'  
						   end ) as SEQ_FLAG
					,substring(@V_PLAN_START_YYYYMMDD,1,6) AS YYYYMM
					,0
			FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
			--left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
			--		on  b.DIVISION_ID = a.DIVISION_ID  
			--		and b.SCM_SITE_ID = a.from_site			
			WHERE a.operation_group IN ('A','P')    
			group by a.division_id
					,a.company_id
					,a.plant_id
					,a.OPERATION_GROUP
					,A.ITEM_ID 
					,(case when a.operation_group='P' and  a.Flow_id in ('P5500','P9500')      then '160'  
						   when a.operation_group='P' and  a.Flow_id not in ('P5500','P9500')  then '260'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP'  then '360'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA'  then '460'  
						   end ) 
*/

--select 'jjgkk9 : ' +  convert(varchar(19), getdate(),121) 


/* ESS 560은 좀 있다가 하자
set @V_STATUS_DESC = '6.BOH inv E';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,@V_PLAN_SEQ AS SEQ
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'560' as SEQ_FLAG
					,convert(nvarchar(6),getdate(),112)
					,0 QTY
			FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
			--left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
			--		on  b.DIVISION_ID = a.DIVISION_ID
			--		and b.SCM_SITE_ID = a.from_site			
			WHERE a.operation_group = 'E'         
			group by a.division_id
					,a.company_id
					,a.plant_id
					,a.OPERATION_GROUP
					,a.ITEM_ID 
ESS 560은 좀 있다가 하자 */
/*
          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  
			-- 230 은 150으로 만들어 지므로  150의 cell_item_id 까지 만들어지 그 뒤에서 insert 함.
		 
          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
		    -- 230에서 250도 함께 생성함.
				
          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    6.BOH 입력
          -------------------------------------------------------------------------------------------------------------  
		  -- 160 생성 시 160~460까지 모두 생성함.  

          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음) : 
		  --    0.MKT FCST 입력
          ------------------------------------------------------------------------------------------------------------- 
		  -- 100에서 300도 함께 생성함.

          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음) : 
		  --    1.Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------
		  -- 110에서 310도 함께 생성함.

          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    2.Ship. Plan(Semi)
          -------------------------------------------------------------------------------------------------------------  
*/





		  -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    220. Ship. Plan(Semi)
          -------------------------------------------------------------------------------------------------------------  

			insert into #tmp_PSI_INTEGRATION_ESS_220_240
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					--b.PLANT_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else ''
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, --a.SEQ,
					'P' as operation_group, --a.operation_group,
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on a.division_id = c.division_id
				  and a.bod_id = c.bod_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'P'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'P' as operation_group, --operation_group,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'220'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_220_240 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 a.arrival_YYYYMMDD

--select 'jjgkk9-3 : ' +  convert(varchar(19), getdate(),121)  

          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK   -- 250 부터 만들고 230 만들어야 함. CELL_ITEM_ID 반영하는 뒤로 옮길것.
		  --    230.IN_HOUSE_MOVING
          ------------------------------------------------------------------------------------------------------------- 
/*
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							( DIVISION_ID,
							COMPANY_ID,
							PLANT_ID, 
							PLAN_START_YYYYMMDD,
							SEQ,
							OPERATION_GROUP, 
							FROM_SITE,
							CELL_ITEM_ID,
							ITEM_ID,
							MEASURE,
							VALUE_TYPE,
							TO_PRODUCT,
							LINE_ID,
							BOH_QTY,
							TO_SITE,
							INCOTERMS,
							SEQ_FLAG,
							YYYYMMDD,
							QTY
							)
			select  i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					i.FROM_SITE,    
					i.cell_item_id,
					i.item_id as item_id,
--					'PROD_PLAN' as measure,
					'IN_HOUSE_MOVING' as measure,
					'-' as value_type,
					'-' as TO_PRODUCT,
--					i.LINE_ID,
					'-' as LINE_ID,
					0 as BOH_QTY,
--					I.TO_SITE,
					i.PLANT_ID as TO_SITE,
					i.INCOTERMS,
					'230' as SEQ_FLAG,   
					i.YYYYMMDD,
					isnull(sum(isnull(i.qty,0)),0) as QTY   
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS i with(nolock)
			where i.SEQ_FLAG in ('250')
			group by i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					i.FROM_SITE,    
					i.cell_item_id,
					i.item_id,
					--i.BOH_QTY,
					i.PLANT_ID,
					i.INCOTERMS,
					i.YYYYMMDD
*/
          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    240.Semi WH In
          ------------------------------------------------------------------------------------------------------------- 
            SET @V_STATUS_DESC = '4.Semi WH-IN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT DIVISION_ID,
				to_COMPANY_ID,
				to_plant_id,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'P' as operation_group, --operation_group,
				'-' as FROM_SITE,  
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as incoterms,
				'240'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_220_240 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 a.arrival_YYYYMMDD

--select 'jjgkk9-4 : ' +  convert(varchar(19), getdate(),121)  

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

		  
          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    250.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
		  ---> '150' 만드는 곳에서 '250' 만듦.

          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK   -- 250 부터 만들고 230 만들어야 함. CELL_ITEM_ID 반영하는 뒤로 옮길것.
		  --    230.IN_HOUSE_MOVING
          ------------------------------------------------------------------------------------------------------------- 
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'P' as operation_group, --b.OPERATION_GROUP_ID,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
--				a.LINE_ID,   
				'-' as LINE_ID,   
                0 as BOH_QTY,
--	            '-' as TO_SITE,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'230'  as SEQ_FLAG,  
				a.YYYYMMDD,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1)),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = a.plant_id
					and b.model_id = a.item_id
					and b.model_id <> b.child_item_id
					and b.OPERATION_GROUP_ID = 'P'  
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
--			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
--					on c.item_id = B.child_item_id
--					and c.DIVISION_ID = a.DIVISION_ID
--					and c.OPERATION_GROUP_ID = 'P'  
----					and c.attribute8 = 'CP'
			left join scp_mst_tact_time_osp y WITH (NOLOCK)
			on  y.division_id = @p_division_id
			AND y.valid_yn    = 'Y'   
			and	y.plant_site_id = a.plant_id  --CN003035-P
			and y.item_id = a.item_id    --EA019170PC01
			and y.LINE_ID = a.line_id
			/*
			-- pack, cell 수율반영 가져 오기
			left join (select y.operation_group,  a.*
						from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_YIELD_VER_H_V a with(nolock)
						inner join (
									SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
									from [10.34.221.78,7433].lgce_scmprod.dbo.scm_adm_lookup_master_detail b WITH(NOLOCK)
									where b.lookup_type = 'LOCATION_GROUP_ROUTE'
									and b.valid_yn = 'Y'
									and b.segment3 = 'Y'
									and b.segment5 = 'P'   --'P':Pack, 'A':Cell
								   ) y
						on a.operation_id = y.operation_id
						where 1=1
						and a.division_id = @V_DIVISION_ID ) y 
				on y.division_id = a.DIVISION_ID
				and y.operation_group =a.OPERATION_GROUP
				and y.company_id = a.COMPANY_ID
				and y.plant_id = a.PLANT_ID
				and y.line_id = a.LINE_ID
				and y.month = a.yyyymm
				and y.item_id =a.ITEM_ID  
				*/
			where a.SEQ_FLAG = '150'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
					 --a.SEQ,  
					 --b.OPERATION_GROUP_ID,  
				     a.CELL_ITEM_ID,  
		             B.child_item_id,  
					 --a.LINE_ID,  
					 a.YYYYMMDD


-- '330'


		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'A' as operation_group, --c.OPERATION_GROUP_ID,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				a.ITEM_ID as TO_PRODUCT,
--				a.LINE_ID,   
				'-' as LINE_ID,   
                0 as BOH_QTY,
--	            '-' as TO_SITE,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'330'  as SEQ_FLAG,  
				a.YYYYMMDD,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1)),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = a.plant_id
					and b.model_id = a.item_id
					and b.model_id <> b.child_item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					and c.attribute8 = 'CP'
			left join scp_mst_tact_time_osp y WITH (NOLOCK)
					on  y.division_id = a.DIVISION_ID
					AND y.valid_yn    = 'Y'   
					and	y.plant_site_id = a.plant_id  --CN003035-P
					and y.item_id = a.item_id    --EA019170PC01
					and y.LINE_ID = a.line_id
			/*
			-- pack, cell 수율반영 가져 오기
			left join (select y.operation_group,  a.*
						from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_YIELD_VER_H_V a with(nolock)
						inner join (
									SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
									from [10.34.221.78,7433].lgce_scmprod.dbo.scm_adm_lookup_master_detail b WITH(NOLOCK)
									where b.lookup_type = 'LOCATION_GROUP_ROUTE'
									and b.valid_yn = 'Y'
									and b.segment3 = 'Y'
									and b.segment5 = 'P'   --'P':Pack, 'A':Cell
								   ) y
						on a.operation_id = y.operation_id
						where 1=1
						and a.division_id = @V_DIVISION_ID ) y 
				on y.division_id = a.DIVISION_ID
				and y.operation_group =a.OPERATION_GROUP
				and y.company_id = a.COMPANY_ID
				and y.plant_id = a.PLANT_ID
				and y.line_id = a.LINE_ID
				and y.month = a.yyyymm
				and y.item_id =a.ITEM_ID   
			*/
			where a.SEQ_FLAG = '250'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
					 --a.SEQ,  
					 --c.OPERATION_GROUP_ID,  
				     a.CELL_ITEM_ID,  
		             B.child_item_id,
					 a.ITEM_ID,
					 --a.LINE_ID,  
					 a.YYYYMMDD
/*
SELECT *
INTO JJG_TEST_20240615
FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS
WHERE SEQ_FLAG IN ('150','250')
*/
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527'
--RETURN

          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK
		  --    260.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  


--300
		  -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    300. MKT FCST
          -------------------------------------------------------------------------------------------------------------

		  -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    310. Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------  

		  -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    320. Ship. Plan(Semi)
          -------------------------------------------------------------------------------------------------------------  
			insert into #tmp_PSI_INTEGRATION_ESS_320_340
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					--b.PLANT_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else ''
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, --a.SEQ,
					'A' as operation_group, --a.operation_group,
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			--INNER JOIN scp_mst_final_item_v fi with(nolock)
			--	   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
			--	   and fi.operation_group = 'P'
			--	   and fi.ITEM_ID = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on a.division_id = c.division_id
				  and a.bod_id = c.bod_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'A'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'A' as operation_group, --operation_group,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'320'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_320_340 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 a.arrival_YYYYMMDD
          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    330.IN_HOUSE_MOVING
          ------------------------------------------------------------------------------------------------------------- 



          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    332.IN_HOUSE_MOVING - PUR
          ------------------------------------------------------------------------------------------------------------- 

          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    334.IN_HOUSE_MOVING - PRD
          ------------------------------------------------------------------------------------------------------------- 

          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    340.Semi WH In
          ------------------------------------------------------------------------------------------------------------- 
            SET @V_STATUS_DESC = '4.Semi WH-IN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT DIVISION_ID,
				to_COMPANY_ID,
				to_plant_id,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'A' as operation_group, --operation_group,
				'-' as FROM_SITE,  
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'PUR' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as incoterms,
				'340'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_320_340 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 a.arrival_YYYYMMDD
          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    350.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  


--select 'jjgkk100-1 ca to cp : ' +  convert(varchar(19), getdate(),121)  
/*
		  select *
		  into jjg_test_20240615_0300
		  from #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		  --where seq_flag = '350'
*/
		  --return

		  -- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

/*
			--select top 100 x.item_id_prod, a.*
			select count(*)  -- 9828
			-- update a set item_id = x.item_id_prod
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			inner join (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
							FROM   [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
								INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item f WITH(NOLOCK)
								ON  c.division_id  = f.division_id
								AND c.item_id_prod = f.item_id
								AND f.ATTRIBUTE8   = 'CP'
							WHERE  c.cell_type = 'CA1' 
							AND    c.valid_yn  = 'Y'   
							GROUP BY c.division_id, c.item_id_assy) x
			on x.DIVISION_ID = a.DIVISION_ID
			and x.item_id_assy = a.ITEM_ID
			where a.seq_flag = '350'


			select a.item_id, x.item_id_assy, x.item_id_prod  -- 9828
			from jjg_test_20240615_0219 a
			inner join (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
							FROM   [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
								INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item f WITH(NOLOCK)
								ON  c.division_id  = f.division_id
								AND c.item_id_prod = f.item_id
								AND f.ATTRIBUTE8   = 'CP'
							WHERE  c.cell_type = 'CA1' 
							AND    c.valid_yn  = 'Y'   
							GROUP BY c.division_id, c.item_id_assy) x
			on x.DIVISION_ID = a.DIVISION_ID
			and x.item_id_assy = a.ITEM_ID
			where a.seq_flag = '350'

'EAE0725N5-02'  --> 'jjg0725N5-02'
			select *
			-- update a set item_id = 'jjg0725N5-02'
			from jjg_test_20240615_0219 a
			where a.seq_flag = '350'
			and yyyymmdd = '20240527'
			and item_id = 'EAE0725N5-02'
			and company_id = 'C100'
*/


		  --select top 10 *
		  -- select distinct seq_flag 
		  --from jjg_test_20240615_0219

/*
		  select *
		  into jjg_test_20240615_0219
		  from #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		  where seq_flag = '350'

		  return

		  -- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 
*/
          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    360.INV
          ------------------------------------------------------------------------------------------------------------- 
		  --> 160 만들때 260, 360, 460도 함께 만듦


          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    370.INV - PUR
          ------------------------------------------------------------------------------------------------------------- 

          -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    380.INV- PRD
          ------------------------------------------------------------------------------------------------------------- 

--500

		  -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    500. MKT FCST
          -------------------------------------------------------------------------------------------------------------

		  -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    510. Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------  

		  -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    520. Ship. Plan(Semi)
          -------------------------------------------------------------------------------------------------------------  

			
			insert into #tmp_PSI_INTEGRATION_ESS_520_540
	        SELECT  a.DIVISION_ID,
					a.ORIGIN_FROM_DIVISION_ID,
					A.ORIGIN_TO_DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					--b.PLANT_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else ''
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, --a.SEQ,
					'E' as operation_group, --a.operation_group,
					a.FROM_SITE,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, isnull(c.lt_total_ssp,0), a.yyyymmdd),112)   -- jjg 여기 lt_total_ssp 꼭 한번 물어 보기
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
--select item_id, cell_item_id, *
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item fi with(nolock)
				 ON fi.operation_group = 'E'
				 and fi.cell_item_id like 'EC%'
				 and fi.division_id = @V_DIVISION_ID  --'82'
				 AND fi.item_id = a.item_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on c.bod_id = a.bod_id 
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND (a.ORIGIN_FROM_DIVISION_ID = @V_DIVISION_ID or a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID)
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'E'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD

--select 'jjgkk19 : ' +  convert(varchar(19), getdate(),121)  


            SET @V_STATUS_DESC = '2.Ship. Plan(Semi) EE 520';	 

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT ORIGIN_FROM_DIVISION_ID AS DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'E' as operation_group, --OPERATION_GROUP,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id as TO_SITE,  
				INCOTERMS,
				'520'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_520_540 a WITH(NOLOCK)
			where a.COMPANY_ID <> a.to_COMPANY_ID
			and a.ORIGIN_FROM_DIVISION_ID = @V_DIVISION_ID --'81'
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by ORIGIN_FROM_DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 to_plant_id,
					 INCOTERMS,
					 a.arrival_YYYYMMDD

          -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    540.Semi WH In
          ------------------------------------------------------------------------------------------------------------- 

--select 'jjgkk20 : ' +  convert(varchar(19), getdate(),121)  

            SET @V_STATUS_DESC = '4.Semi WH-IN  EE';	

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT ORIGIN_TO_DIVISION_ID AS DIVISION_ID,
				to_COMPANY_ID AS COMPANY_ID,
				to_plant_id AS PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ, --SEQ,
				'E' as operation_group, --OPERATION_GROUP,
				'-' AS FROM_SITE,
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            '-' AS TO_SITE,  
				'-' AS INCOTERMS,
				'540'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_520_540 a WITH(NOLOCK)
			where a.COMPANY_ID <> a.to_COMPANY_ID
			and a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID 
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by ORIGIN_TO_DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 --SEQ,
					 --operation_group,
					 ITEM_ID,
					 TO_SITE,
					 a.arrival_YYYYMMDD

          -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    530.IN_HOUSE_MOVING
          ------------------------------------------------------------------------------------------------------------- 

			select y.operation_group,  a.version_id, a.division_id, a.company_id, a.site_id, a.plant_id, a.factory_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month, a.yield
			into #tmp_YIELD_VER_H_V_A_ESS
			from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_YIELD_VER_H_V a with(nolock)
			inner join (    SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
							from [10.34.221.78,7433].lgce_scmprod.dbo.scm_adm_lookup_master_detail b WITH(NOLOCK)
							where b.lookup_type = 'LOCATION_GROUP_ROUTE'
							and b.valid_yn = 'Y'
							and b.segment3 = 'Y'
							and b.segment5 = 'A' ) y
			on a.operation_id = y.operation_id
			where 1=1
			and a.division_id = @V_DIVISION_ID 

			create index i_tmp_YIELD_VER_H_V_A_ESS_01 on #tmp_YIELD_VER_H_V_A_ESS(item_id)

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as plant_id,  -- 전극 Plant
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'E' as operation_group, --b.operation_group_id,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID, 
	            B.child_item_id as ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID, 
                0 as BOH_QTY,
--	            '-' as TO_SITE,
	            substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as TO_SITE,
				'-' as INCOTERMS,
				'530'  as SEQ_FLAG, 
				a.YYYYMMDD,
				isnull(sum(a.QTY * isnull(b.accumulated_child_qty,1)  / isnull(y.yield,1)),0) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = @V_DIVISION_ID
					and b.plant_id = a.plant_id
					and b.operation_group_id = 'E' 
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			-- pack/cell 수율 반영 start 
			left join #tmp_YIELD_VER_H_V_A_ESS y 
				on y.division_id = a.DIVISION_ID
				and y.operation_group =a.OPERATION_GROUP
				and y.company_id = a.COMPANY_ID
				and y.line_id = a.LINE_ID
				and y.month = left(a.YYYYMMDD,6)  -- 수정함.
				and y.item_id =a.ITEM_ID  
			where a.SEQ_FLAG = '350'  
			group by a.DIVISION_ID,
					 a.COMPANY_ID,
					 substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1),
				     a.PLAN_START_YYYYMMDD,
				     --a.SEQ,
					 --b.operation_group_id,
		             B.child_item_id,
					 a.YYYYMMDD
          -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    540.Semi WH In
          ------------------------------------------------------------------------------------------------------------- 

          -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    550.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
            SET @V_STATUS_DESC = '5.PROD_PLAN  EE';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
		      ( DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            PLAN_START_YYYYMMDD,
	            SEQ,
				OPERATION_GROUP, 
	            FROM_SITE,
                CELL_ITEM_ID,
	            ITEM_ID,
	            MEASURE,
				VALUE_TYPE,
				TO_PRODUCT,
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMMDD,
				QTY
			 )
         SELECT @V_DIVISION_ID,
				b.COMPANY_ID,
				--b.PLANT_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, --a.SEQ,
				'E' as operation_group, --a.OPERATION_GROUP,
				'-' AS FROM_SITE,
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as INCOTERMS,
				'550'  as SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item fi with(nolock)
				 ON fi.operation_group = 'E'
				 and fi.cell_item_id like 'EC%' -- KSK : 자동차에선 <>'EC' 조건 추가 하기.
				 and fi.division_id = @V_DIVISION_ID  --'82'
				 AND fi.item_id = a.item_id
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'E'
			  --AND A.ORIGIN_DIVISION_ID = @V_DIVISION_ID -- EE 생산계획에 ESS 는 없음
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by b.COMPANY_ID,
					 --b.PLANT_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ),
				     a.PLAN_START_YYYYMMDD,
				     --a.SEQ,
					 --a.OPERATION_GROUP,
					 a.ITEM_ID,
					 a.LINE_ID,
					 a.YYYYMMDD

          -------------------------------------------------------------------------------------------------------------                         
          -- 500. ESS 전극
		  --    560.INV
          ------------------------------------------------------------------------------------------------------------- 
		  --> 160 만들때 260, 360, 460도 함께 만듦
/*
select 'jjgkk200 : ' +  convert(varchar(19), getdate(),121)  

select seq_flag, COUNT(*) from #tmp_SCP_ANL_PSI_INTEGRATION_ESS group by seq_flag order by seq_flag --order by seq_flag, YYYYMMDD, ITEM_ID
return

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610' 
*/

--============================================ jjg end end end end =================================




          -------------------------------------------------------------------------------------------------------------                                         
          -- 9.1  CELL_ITEM_ID UPDATE
          ------------------------------------------------------------------------------------------------------------- 

--select 'jjgkk23 : ' +  convert(varchar(19), getdate(),121)  

            SET @V_STATUS_DESC = 'CELL_ITEM_ID Pack';

				select model_id, child_item_id
				into #tmp_FINAL_ITEM_BOM_V_ESS
				FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
				WHERE Y.CELL_TYPE			 = 'CP'		
				AND Y.OPERATION_GROUP_ID = 'A'
				and Y.DIVISION_ID        = @V_DIVISION_ID  -- 3742

				create index i_tmp_FINAL_ITEM_BOM_V_ESS_01 on #tmp_FINAL_ITEM_BOM_V_ESS(model_id)


--select 'jjgkk23-1 : ' +  convert(varchar(19), getdate(),121) 

                -- PACK 일경우 
				-- CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V_ESS AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = X.ITEM_ID),'-')
													--and Y.DIVISION_ID        = X.DIVISION_ID
													--AND Y.CELL_TYPE			 = 'CP'		
													--AND Y.OPERATION_GROUP_ID = 'A'),'')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'  -- 전극 제외
				and isnull(x.CELL_ITEM_ID,'') < '0'


--select 'jjgkk23-2 : ' +  convert(varchar(19), getdate(),121) 
/*
select seq_flag, COUNT(*) from #tmp_SCP_ANL_PSI_INTEGRATION_ESS group by seq_flag order by seq_flag --order by seq_flag, YYYYMMDD, ITEM_ID
return
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 
*/


				-- 상위 모델 이용하여 CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V_ESS AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = ( 	SELECT top 1 model_id
																					FROM SCM_MST_MODEL_ONE_LEVEL_BOM_V AS Y WITH (NOLOCK)
																					WHERE Y.DIVISION_ID        = X.DIVISION_ID
																					AND Y.child_item_id         = X.ITEM_ID
																					and y.plant_id = x.plant_id)),'-')
													--and Y.DIVISION_ID        = X.DIVISION_ID
													--AND Y.CELL_TYPE			 = 'CP'		
													--AND Y.OPERATION_GROUP_ID = 'A'),'')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'   
				and isnull(x.CELL_ITEM_ID,'') < '0'

--select 'jjgkk24 : ' +  convert(varchar(19), getdate(),121)  


            SET @V_STATUS_DESC = 'CELL_ITEM_ID Cell';

                 -- CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - 변경후 쿼리 
				;WITH CP_INFO AS (
					SELECT M.DIVISION_ID
						  ,M.PLANT_ID
						  ,M.ITEM_ID_ASSY
						  ,M.ITEM_ID_PROD
						  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
														  ,M.ITEM_ID_ASSY
														  ,M.PLANT_ID
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_1ST
						  ,ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
														  ,M.ITEM_ID_ASSY
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_2ND
						  ,ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
												  ORDER BY M.VALID_YN DESC 
														  ,M.ITEM_ID_PROD) PRIORITY_3RD
					 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
					WHERE 1=1
					  AND M.VALID_YN = 'Y' 
				)
				 UPDATE X
					SET X.CELL_ITEM_ID      = isnull(CASE	WHEN F.CELL_TYPE LIKE 'CA%'
															THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), X.ITEM_ID)
															ELSE X.ITEM_ID
															END,'-')
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X 
					   INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM_V F WITH(NOLOCK)  
							   ON 1=1
							  AND F.ITEM_ID			= X.ITEM_ID
					   LEFT  JOIN CP_INFO C1 WITH(NOLOCK)
							   ON C1.DIVISION_ID	= X.DIVISION_ID
							  AND C1.PLANT_ID		= x.PLANT_ID   
							  AND C1.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C1.PRIORITY_1ST	= 1
					   LEFT  JOIN CP_INFO C2 WITH(NOLOCK)
							   ON C2.DIVISION_ID	= X.DIVISION_ID
							  AND C2.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C2.PRIORITY_2ND	= 1
					   LEFT  JOIN CP_INFO C3 WITH(NOLOCK)
							   ON C3.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C3.PRIORITY_3RD	= 1
				 WHERE 0 = 0
				   AND X.OPERATION_GROUP   = 'A'
				   and left(x.SEQ_FLAG,1) <> '5'  
				   and isnull(x.CELL_ITEM_ID,'') < '0'

--select 'jjgkk25 : ' +  convert(varchar(19), getdate(),121)  



 
            SET @V_STATUS_DESC = 'CELL_ITEM_ID MEB';
/*
			SELECT *
              FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X 
			  WHERE X.ATTRIBUTE9 = 'P5200'
			  and left(x.SEQ_FLAG,1) <> '5'  
			  and x.CELL_ITEM_ID < '0'
*/
 

			----------------------------------------------------
			-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - start
			----------------------------------------------------
/* ESS 제외
			UPDATE X
               SET X.CELL_ITEM_ID = isnull(Z.CELL_ITEM_ID,'')
              FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X 
			INNER JOIN (SELECT distinct z.model_id as item_id, z.child_item_id as cell_item_id, z.accumulated_child_qty as cell_qty_pack, y.module_id, y.module_qty_pack
						  FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V z WITH(NOLOCK),
							   ( SELECT x.DIVISION_ID, x.model_id, x.child_item_id as module_id, x.child_qty as module_qty_pack
								   FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_bom_sn_V x WITH(NOLOCK)	--2021-03-09	SCP 대치 BOM 적용
										INNER JOIN [10.34.221.78,7433].lgce_fp_tr.dbo.SCM_ITEM_M i WITH(NOLOCK)
										ON  x.child_division_id = i.division_id
										AND x.child_item_id     = i.item_id
										AND I.FLOW_ID = 'P5200'
										AND x.child_company_id  = i.company_id -- A002 빈강 추가 따른 조건 추가
										AND x.child_site_id     = i.site_id
										AND i.active_flag       = 'Y'           
								  WHERE 1=1
								) Y
						 WHERE z.DIVISION_ID        = Y.DIVISION_ID
							AND z.MODEL_ID           = Y.model_id
							AND z.CELL_TYPE			 = 'CP' -- 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가)
							AND z.OPERATION_GROUP_ID = 'A'
					   ) Z
				 ON X.ITEM_ID    = Z.MODULE_ID
			  WHERE X.ATTRIBUTE9 = 'P5200'
			  and left(x.SEQ_FLAG,1) <> '5'  
			  and x.CELL_ITEM_ID < '0'
*/

--select 'jjgkk25-2 : ' +  convert(varchar(19), getdate(),121)  


          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  
--select 'jjgkk26 : ' +  convert(varchar(19), getdate(),121)  

            SET @V_STATUS_DESC = '3.IN_HOUSE_MOVING 222';
/*
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							( DIVISION_ID,
							COMPANY_ID,
							PLANT_ID, 
							PLAN_START_YYYYMMDD,
							SEQ,
							OPERATION_GROUP, 
							FROM_SITE,
							CELL_ITEM_ID,
							ITEM_ID,
							MEASURE,
							VALUE_TYPE,
							TO_PRODUCT,
							LINE_ID,
							BOH_QTY,
							TO_SITE,
							INCOTERMS,
							SEQ_FLAG,
							YYYYMM,
							QTY
							)
			select  i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					'-' as FROM_SITE,    
					i.cell_item_id as cell_item_id,
					a.child_item_id as item_id, 
					--'IN_HOUSE_MOVING' as measure,
					i.measure,
					'-' as value_type,
					'-' as TO_PRODUCT,
					i.LINE_ID,
					0 as BOH_QTY,
					I.TO_SITE,
					'-' as INCOTERMS,
					'250' as SEQ_FLAG, 
					i.YYYYMM,
					isnull(sum(isnull(i.qty,0) * isnull(a.ACCUMULATED_CHILD_QTY,1) ),0) as QTY 
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS i with(nolock)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
				on a.model_id = i.ITEM_ID
				and a.parent_item_id = i.ITEM_ID
				and a.division_id = i.division_id
				and a.COMPANY_ID = i.company_id 
				AND i.PLAN_START_YYYYMMDD BETWEEN a.eff_start_date and a.eff_end_date  
		        AND (a.alt_id IS NULL 
				    OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NULL AND ISNULL(a.alt_priority, '1') = 'Y') 
				    OR (a.alt_id IS NOT NULL AND a.scp_plan_yn IS NOT NULL AND a.scp_plan_yn = 'Y'))
			inner join [10.34.221.78,7433].lgce_fp_tr.dbo.SCM_ITEM_M b with(nolock)
				on a.division_id = b.division_id
				and a.company_id = b.company_id
				and a.child_item_id = b.item_id
				and ISNULL(b.scp_flow_id, b.flow_id) = 'P5000'
			where i.SEQ_FLAG in ('150')
			--and i.MEASURE = 'PROD_PLAN'
			group by i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					i.cell_item_id,
					a.child_item_id,
					i.measure,
					i.LINE_ID,
					--i.BOH_QTY,
					I.TO_SITE,
					i.YYYYMM
*/
          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
--select 'jjgkk27 : ' +  convert(varchar(19), getdate(),121)  

            SET @V_STATUS_DESC = '5.PROD_PLAN 222';
/*
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							( DIVISION_ID,
							COMPANY_ID,
							PLANT_ID, 
							PLAN_START_YYYYMMDD,
							SEQ,
							OPERATION_GROUP, 
							FROM_SITE,
							CELL_ITEM_ID,
							ITEM_ID,
							MEASURE,
							VALUE_TYPE,
							TO_PRODUCT,
							LINE_ID,
							BOH_QTY,
							TO_SITE,
							INCOTERMS,
							SEQ_FLAG,
							YYYYMM,
							QTY
							)
			select  i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					i.FROM_SITE,    
					i.cell_item_id,
					i.item_id as item_id,
--					'PROD_PLAN' as measure,
					'IN_HOUSE_MOVING' as measure,
					'-' as value_type,
					'-' as TO_PRODUCT,
--					i.LINE_ID,
					'-' as LINE_ID,
					0 as BOH_QTY,
--					I.TO_SITE,
					i.PLANT_ID as TO_SITE,
					i.INCOTERMS,
					'230' as SEQ_FLAG,   
					i.YYYYMM,
					isnull(sum(isnull(i.qty,0)),0) as QTY   
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS i with(nolock)
			where i.SEQ_FLAG in ('250')
			group by i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.seq, 
					i.operation_group,
					i.FROM_SITE,    
					i.cell_item_id,
					i.item_id,
					--i.BOH_QTY,
					i.PLANT_ID,
					i.INCOTERMS,
					i.YYYYMM
*/

--/* JJG JEGO START : 임시 처리 : 선입선출 완료 후 PRD/PUR 구분하여 재처리 필요

            SET @V_STATUS_DESC = 'INV';
			DECLARE @MIN_YYYYMMDD  NVARCHAR(8)
			DECLARE @MAX_YYYYMMDD  NVARCHAR(8)
			DECLARE @PRE_YYYYMMDD  NVARCHAR(8)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)
			--DECLARE @PROC_YYYYMMDD_OLD NVARCHAR(8)

			SELECT @MIN_YYYYMMDD = @V_PLAN_START_YYYYMMDD

			select @MAX_YYYYMMDD = @V_HORIZON_END_YYYYMMDD

			SET @PROC_YYYYMMDD = @MIN_YYYYMMDD

			SET @PROC_YYYYMMDD = @MIN_YYYYMMDD
			--set @PROC_YYYYMMDD_OLD = @PROC_YYYYMM + '01'

			-- 재고가 없는 경우 첫번째 날짜를 QTY=0 으로 생성함.
					insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							(
							 DIVISION_ID
							,COMPANY_ID
							,PLANT_ID
							,PLAN_START_YYYYMMDD
							,SEQ
							,OPERATION_GROUP
							,FROM_SITE
							,CELL_ITEM_ID
							,ITEM_ID
							,MEASURE
							,VALUE_TYPE
							,TO_PRODUCT
							,LINE_ID
							,BOH_QTY
							,TO_SITE
							,INCOTERMS
							,SEQ_FLAG
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

							)
					-- 1. P / E
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'-' as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,LEFT(SEQ_FLAG,1) + '60' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and substring(b.SEQ_FLAG,2,1) = '6' )
					and a.OPERATION_GROUP <> 'A'
					and a.measure <> 'MKT_FCST'
					-- 2. A : PUR
					UNION ALL
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PUR' AS value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'370' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.value_type = 'PUR'
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and b.SEQ_FLAG = '370'
										)
					and a.OPERATION_GROUP = 'A' --CELL
					and a.measure <> 'MKT_FCST'
					-- 3. A : PRD
					UNION ALL
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PRD' AS value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'380' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.value_type = 'PRD'
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and b.SEQ_FLAG = '380'
										)
					and a.OPERATION_GROUP = 'A' --CELL
					and a.measure <> 'MKT_FCST'
									
			-- Cell BOH SUM : PRD + PUR = '-'
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS
					(	DIVISION_ID,
						COMPANY_ID,
						PLANT_ID, 
						PLAN_START_YYYYMMDD,
						SEQ,
						OPERATION_GROUP, 
						FROM_SITE,
						CELL_ITEM_ID,
						ITEM_ID,
						MEASURE,
						VALUE_TYPE,
						TO_PRODUCT,
						LINE_ID,
						BOH_QTY,
						TO_SITE,
						INCOTERMS,
						SEQ_FLAG,
						YYYYMMDD,
						QTY
					)
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ --@V_PLAN_SEQ AS SEQ
					,'A' as operation_group --a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.BOH_QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'360' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS A WITH(NOLOCK)
			WHERE SEQ_FLAG IN ('370','380')
			group by a.division_id
					,a.company_id
					,a.plant_id
					--,a.OPERATION_GROUP
					,A.ITEM_ID 
									

--JJG JEGO END */



/*
select * 
into jjg_test_20240612_end
from #tmp_SCP_ANL_PSI_INTEGRATION_ESS 
*/
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '81_UC', '20240527' 
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

			-------------------------------------------------------------------------------------------------------------                         
			-- 이전 동일 수행건 삭제 후 수행내역 Insert
			-- 삭제 & insert   
			------------------------------------------------------------------------------------------------------------- 
--select 'jjgkk28 : ' +  convert(varchar(19), getdate(),121)  

--select seq_flag, COUNT(*) from #tmp_SCP_ANL_PSI_INTEGRATION_ESS group by seq_flag order by seq_flag --order by seq_flag, YYYYMMDD, ITEM_ID
--return
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240527' 

-- Violation of PRIMARY KEY constraint 'PK_SCP_ANL_PSI_INTEGRATION_ESS'. Cannot insert duplicate key in object 'dbo.SCP_ANL_PSI_INTEGRATION_ESS'. The duplicate key value is (20240527, 1, P, C100, A050, 82, -, ECE0566F1-01, ETD1525ACB31, INV, -, -, -, -, -, 20240531).
/*
SELECT COUNT(*) -- 178479
FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS
RETURN 
*/
--SELECT * FROM JJG_TEST_ESS_20240615_1
-- jjgkk JEGO START : 2024-06-15 15:08:41
-- jjgkk JEGO END : 2024-06-15 15:13:29
--/*


/*
SELECT *
INTO JJG_TEST_ESS_20240615_5
FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS

RETURN
*/
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'

--*/
			-------------------------------------------------------------------------------------------------------------                         
			-- 전극 중 ESS 용 전극이 아닌 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산
			------------------------------------------------------------------------------------------------------------- 
			DELETE #tmp_SCP_ANL_PSI_INTEGRATION_ESS
			where 1=1
			and operation_group = 'E'
			and item_id NOT IN (select distinct item_id from [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item  WITH(NOLOCK)   
									where FLOW_ID like 'E2000%'
									and cell_item_id like 'EC%'
								   ) 

            SET @V_STATUS_DESC = 'Delete';

			DELETE A 
			FROM SCP_ANL_PSI_INTEGRATION_ESS A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			--AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID

            SET @V_STATUS_DESC = 'insert';
			insert into SCP_ANL_PSI_INTEGRATION_ESS
					(	
			 		 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE   --10
					,value_type
					,TO_PRODUCT
					,LINE_ID
					,BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,YYYYMMDD
					,QTY
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY     --10
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
					)
				
			select   DIVISION_ID
					,ISNULL(COMPANY_ID,'')
					,ISNULL(PLANT_ID,'')
					,PLAN_START_YYYYMMDD
					,1 AS SEQ --SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE 
					,TO_PRODUCT
					,LINE_ID
					,BOH_QTY
					,TO_SITE
					,ISNULL(INCOTERMS,'')
					,SEQ_FLAG
					,YYYYMMDD
					,QTY
					,'SCP BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
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
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS
			--where NOT (		item_id = 'EP059062PEF1'
			--			and plan_start_yyyymmdd = '20240527'
			--			and division_id = '82'
			--			and plant_id = 'A050'
			--			and operation_group = 'P'
			--			and measure = 'INV'
			--			and seq_flag = '260' )

/* 운영 이관시 주석 처리 함.
			select * 
			from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID
			ORDER BY substring(SEQ_FLAG,1,1), ITEM_ID, YYYYMM, substring(SEQ_FLAG,2,1), TO_SITE
*/


	/*  ESS Daily를 월로 취합 START  */

			INSERT INTO #TMP_SCP_ANL_PSI_INTEGRATION_CALC
			select 	 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE
					,TO_PRODUCT
					,LINE_ID
					,isnull(sum(isnull(BOH_QTY,0)),0) BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,left(a.YYYYMMDD,6) AS YYYYMM
					,isnull(sum(isnull(QTY,0)),0) as QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
					,'' AS ATTRIBUTE1
					,'' AS ATTRIBUTE2
					,'' AS ATTRIBUTE3
					,'' AS ATTRIBUTE4
					,'' AS ATTRIBUTE5
					,'' AS ATTRIBUTE6
					,'' AS ATTRIBUTE7
					,'' AS ATTRIBUTE8
					,'' AS ATTRIBUTE9
					,'' AS ATTRIBUTE10
			FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  --'20240610' --
			AND a.DIVISION_ID = @V_DIVISION_ID  --'82'  --
			--AND SUBSTRING(A.SEQ_FLAG,2,1) <> '6'
			AND a.MEASURE <> 'INV'
			group by PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, seq_flag, left(a.YYYYMMDD,6) 

			-- 재고는 매월 마지막일자 정보로 처리
			INSERT INTO #TMP_SCP_ANL_PSI_INTEGRATION_CALC
			select 	 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE
					,TO_PRODUCT
					,LINE_ID
					,isnull(BOH_QTY,0) BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,cal.basis_yyyymm AS YYYYMM
					,0 as QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
					,'' AS ATTRIBUTE1
					,'' AS ATTRIBUTE2
					,'' AS ATTRIBUTE3
					,'' AS ATTRIBUTE4
					,'' AS ATTRIBUTE5
					,'' AS ATTRIBUTE6
					,'' AS ATTRIBUTE7
					,'' AS ATTRIBUTE8
					,'' AS ATTRIBUTE9
					,'' AS ATTRIBUTE10
			FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			
		    INNER JOIN (SELECT basis_yyyymm, max(BASIS_YYYYMMDD) yyyymmdd
                          FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
                         WHERE 1=1              
                           AND C.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD --'20240610'   
						   AND C.BASIS_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD --'20250608'  
						 GROUP BY basis_yyyymm
						) cal
           ON a.YYYYMMDD = cal.YYYYMMDD

			where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  --'20240610' --
			AND a.DIVISION_ID = @V_DIVISION_ID  --'82'  --
			--AND SUBSTRING(A.SEQ_FLAG,2,1) = '6'
			AND a.MEASURE = 'INV'
			--group by PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, seq_flag, left(a.YYYYMMDD,6) 
		
		------------------------------------------------------------
		-- BOH 표시를 위한 임시 처리 : 선입선출 처리 -> 재고 처리 후 삭제할 것 : START
		------------------------------------------------------------
			INSERT INTO #TMP_SCP_ANL_PSI_INTEGRATION_CALC
			select 	 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE
					,TO_PRODUCT
					,LINE_ID
					,isnull(BOH_QTY,0) BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,left(a.YYYYMMDD,6) AS YYYYMM 
					,0 as QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
					,'' AS ATTRIBUTE1
					,'' AS ATTRIBUTE2
					,'' AS ATTRIBUTE3
					,'' AS ATTRIBUTE4
					,'' AS ATTRIBUTE5
					,'' AS ATTRIBUTE6
					,'' AS ATTRIBUTE7
					,'' AS ATTRIBUTE8
					,'' AS ATTRIBUTE9
					,'' AS ATTRIBUTE10
			FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  --'20240610' --
			AND a.DIVISION_ID = @V_DIVISION_ID  --'82'  --
			AND a.MEASURE = 'INV'
			AND a.yyyymmdd = @V_PLAN_START_YYYYMMDD
		------------------------------------------------------------
		-- BOH 표시를 위한 임시 처리 : 선입선출 처리 -> 재고 처리 후 삭제할 것 : END
		------------------------------------------------------------

--select 'jjgkk28-1 : ' +  convert(varchar(19), getdate(),121) 

/*
SELECT *
INTO JJG_TEST_ESS_MONTH_20240616
FROM #TMP_SCP_ANL_PSI_INTEGRATION_CALC

RETURN
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '82', '20240610'

*/



------ 월재고 생성 END ---------------------

			delete a
			from SCP_ANL_PSI_INTEGRATION a
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  --'20240610'
			--AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID  --'82' 

			insert into SCP_ANL_PSI_INTEGRATION
					(
					 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE
					,TO_PRODUCT
					,LINE_ID
					,BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,YYYYMM
					,QTY
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
					)
			select 	 DIVISION_ID
					,COMPANY_ID
					,PLANT_ID
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,VALUE_TYPE
					,TO_PRODUCT
					,LINE_ID
					,isnull(BOH_QTY,0) BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,a.YYYYMM AS YYYYMM --left(a.YYYYMMDD,6) AS YYYYMM
					,isnull(QTY,0) as QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
					,'' AS ATTRIBUTE1
					,'' AS ATTRIBUTE2
					,'' AS ATTRIBUTE3
					,'' AS ATTRIBUTE4
					,'' AS ATTRIBUTE5
					,'' AS ATTRIBUTE6
					,'' AS ATTRIBUTE7
					,'' AS ATTRIBUTE8
					,'' AS ATTRIBUTE9
					,'' AS ATTRIBUTE10
			FROM #TMP_SCP_ANL_PSI_INTEGRATION_CALC a WITH(NOLOCK) 
			--where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  --'20240610' --
			--AND a.DIVISION_ID = @V_DIVISION_ID  --'82'  --
			--group by PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, seq_flag, left(a.YYYYMMDD,6) 

--select 'jjgkk28-3 : ' +  convert(varchar(19), getdate(),121) 

	/*  ESS Daily를 월로 취합 END  */

			drop table #tmp_SCP_ANL_PSI_INTEGRATION_ESS
			drop table #tmp_PSI_INTEGRATION_ESS_inv
			drop table #tmp_PSI_INTEGRATION_ESS_220_240
			drop table #tmp_PSI_INTEGRATION_ESS_320_340
			drop table #tmp_PSI_INTEGRATION_ESS_520_540
			drop table #tmp_PSI_INTEGRATION_ESS_350

			drop table #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP
			drop table #TMP_SCP_ANL_PSI_INTEGRATION_CALC
			drop table #tmp_YIELD_VER_H_V_A_ESS
			drop table #tmp_FINAL_ITEM_BOM_V_ESS


            
			-- TXN LOG                        
			SET @v_log_type     = N'TXN';          
			SET @n_log_count    = @@ROWCOUNT;                        
			SET @v_log_message  = N'INSERT INTO '+@v_table_id;                               
			SET @d_event_date   = SYSDATETIME();                                     
			SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);    
                        
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
									  ,@p_log_type      =@v_log_type                        
									  ,@p_log_count     =@n_log_count                         
									  ,@p_log_message   =@v_log_message                         
									  ,@p_description   =@v_description                         
									  ,@p_event_date    =@d_event_date                         
									  ,@p_user_id       =@v_batch_user     

	  END 
	END TRY
 

	BEGIN CATCH
	
	    DECLARE @jjgv_log_message  NVARCHAR(1000);
		SET @jjgv_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
		select 'ERROR JJG-Catch'
		select @jjgv_log_message

      -- ERROR LOG                        
      SET @v_log_type     = N'ERROR';                        
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                        
      SET @v_description  = @V_STATUS_DESC + N'  ERROR_LINE : ' + STR(ERROR_LINE());                        
      SET @d_event_date   = SYSDATETIME();                        
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
                                ,@p_log_type      =@v_log_type                        
                                ,@p_log_count     =@n_log_count                         
                                ,@p_log_message   =@v_log_message                         
                                ,@p_description   =@v_description                         
                                ,@p_event_date    =@d_event_date                         
                                ,@p_user_id       =@v_batch_user                        
                                ;                        
      return -1  

	END CATCH

	
--select 'jjgkk29 : ' +  convert(varchar(19), getdate(),121)  
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS_20240617 '81', '20240527'

    -- 임시 운영반영시에 주석처리 할것.                
    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
                
                    
    -- 종료 LOG                        
    SET @v_log_type     = N'END';                        
    SET @v_log_message  = N'########## END of procedure ##########';                        
    SET @v_description  = N'['+@V_DIVISION_ID+']['+@V_PLAN_START_YYYYMMDD+'][' + @v_exec_time + ']';       
    SET @v_description  = N'['+@V_STATUS_DESC+']['+@V_PLAN_START_YYYYMMDD+'][' + @v_exec_time + ']';                
    SET @d_event_date   =  SYSDATETIME()  ;                        

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                        
                              ,@p_log_count     =@n_log_count                         
                              ,@p_log_message   =@v_log_message                         
                              ,@p_description   =@v_description                         
                              ,@p_event_date    =@d_event_date                         
                              ,@p_user_id       =@v_batch_user                        
                              ;                        
    return 1  
	
/*-- ksg : 선입선출 배분 처리 후 없는 재고 포함 및 미래구간 재고 계산 로직 처리 필요 : START

            SET @V_STATUS_DESC = 'INV';
			DECLARE @MIN_YYYYMMDD  NVARCHAR(8)
			DECLARE @MAX_YYYYMMDD  NVARCHAR(8)
			DECLARE @PRE_YYYYMMDD  NVARCHAR(8)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)
			--DECLARE @PROC_YYYYMMDD_OLD NVARCHAR(8)

			SELECT @MIN_YYYYMMDD = @V_PLAN_START_YYYYMMDD

			select @MAX_YYYYMMDD = @V_HORIZON_END_YYYYMMDD

			SET @PROC_YYYYMMDD = @MIN_YYYYMMDD

			SET @PROC_YYYYMMDD = @MIN_YYYYMMDD
			--set @PROC_YYYYMMDD_OLD = @PROC_YYYYMM + '01'

			DECLARE @I INT = 0


			WHILE (@PROC_YYYYMMDD <= @MAX_YYYYMMDD)
			BEGIN
				--SELECT 'JJG WHILE - @PROC_YYYYMMDD :' + @PROC_YYYYMMDD
				IF (@I > 370)
				--IF (@I > 3)
				BEGIN
					--SELECT 'BREAK ERR'
					BREAK
				END	

				IF ( @PROC_YYYYMMDD = @MIN_YYYYMMDD )
				BEGIN
					-- 재고가 없는 경우 첫번째 날짜를 QTY=0 으로 생성함.
					insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							(
							 DIVISION_ID
							,COMPANY_ID
							,PLANT_ID
							,PLAN_START_YYYYMMDD
							,SEQ
							,OPERATION_GROUP
							,FROM_SITE
							,CELL_ITEM_ID
							,ITEM_ID
							,MEASURE
							,VALUE_TYPE
							,TO_PRODUCT
							,LINE_ID
							,BOH_QTY
							,TO_SITE
							,INCOTERMS
							,SEQ_FLAG
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

							)
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'-' as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,LEFT(SEQ_FLAG,1) + '60' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and substring(b.SEQ_FLAG,2,1) = '6' )
					and a.OPERATION_GROUP <> 'A'
					and a.measure <> 'MKT_FCST'
					-- Cell 재고 : PUR
					UNION ALL
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PUR' AS value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'370' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.value_type = 'PUR'
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and b.SEQ_FLAG = '370'
										)
					and a.OPERATION_GROUP = 'A' --CELL
					and a.measure <> 'MKT_FCST'
					-- Cell 재고 : PUR
					UNION ALL
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,'1' AS SEQ --,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PRD' AS value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,0 AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'380' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,0 AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.value_type = 'PRD'
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV'
										and b.SEQ_FLAG = '380'
										)
					and a.OPERATION_GROUP = 'A' --CELL
					and a.measure <> 'MKT_FCST'
					
					-- 첫번째 날짜의 재고(QTY) 반영 : P/E
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' and substring(b.SEQ_FLAG,2,1) = '6' THEN  b.BOH_QTY
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
												WHERE  b.DIVISION_ID = a.DIVISION_ID
												and b.COMPANY_ID = a.COMPANY_ID 
												and b.PLANT_ID = a.PLANT_ID
												and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
												and b.seq = a.seq
												and b.OPERATION_GROUP = a.OPERATION_GROUP
												and b.FROM_SITE = a.FROM_SITE
												and b.CELL_ITEM_ID = a.CELL_ITEM_ID
												and b.ITEM_ID = a.ITEM_ID
												and b.value_type = a.value_type
												and LEFT(b.SEQ_FLAG,1) = LEFT(a.SEQ_FLAG,1)
												and b.YYYYMMDD = a.YYYYMMDD ),0)
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.opeartion_group <> 'A'
					and substring(a.SEQ_FLAG,2,1) = '6'
					and a.YYYYMMDD=@PROC_YYYYMMDD

					-- 첫번째 날짜의 재고(QTY) 반영 : PUR
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' and b.SEQ_FLAG in ( '370') THEN  b.BOH_QTY
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
												WHERE  b.DIVISION_ID = a.DIVISION_ID
												and b.COMPANY_ID = a.COMPANY_ID 
												and b.PLANT_ID = a.PLANT_ID
												and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
												and b.seq = a.seq
												and b.OPERATION_GROUP = a.OPERATION_GROUP
												and b.FROM_SITE = a.FROM_SITE
												and b.CELL_ITEM_ID = a.CELL_ITEM_ID
												and b.ITEM_ID = a.ITEM_ID
												and b.value_type = a.value_type
												and LEFT(b.SEQ_FLAG,1) = LEFT(a.SEQ_FLAG,1)
												and b.YYYYMMDD = a.YYYYMMDD ),0)
					FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.opeartion_group = 'A'
					and a.SEQ_FLAG = '370'
					and a.YYYYMMDD=@PROC_YYYYMMDD

				END  
				ELSE -- 두번째 날짜부터 마지막 날짜까지 재고 생성.
				BEGIN

					insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS
							(
							 DIVISION_ID
							,COMPANY_ID
							,PLANT_ID
							,PLAN_START_YYYYMMDD
							,SEQ
							,OPERATION_GROUP
							,FROM_SITE
							,CELL_ITEM_ID
							,ITEM_ID
							,MEASURE
							,VALUE_TYPE
							,TO_PRODUCT
							,LINE_ID
							,BOH_QTY
							,TO_SITE
							,INCOTERMS
							,SEQ_FLAG
							,YYYYMMDD
							,QTY
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

							)
					SELECT   distinct a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,1 AS SEQ --a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,a.value_type as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,a.BOH_QTY AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,a.SEQ_FLAG as seq_flag
							--,LEFT(a.SEQ_FLAG,1) + '60' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE  WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																		 WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																		 END) QTY
															FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
															WHERE  b.DIVISION_ID = a.DIVISION_ID
															and b.COMPANY_ID = a.COMPANY_ID 
															and b.PLANT_ID = a.PLANT_ID
															and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
															and b.seq = a.seq
															and b.OPERATION_GROUP = a.OPERATION_GROUP
															and b.FROM_SITE = a.FROM_SITE
															and b.CELL_ITEM_ID = a.CELL_ITEM_ID
															and b.ITEM_ID = a.ITEM_ID
												            and b.value_type = a.value_type
															and b.SEQ_FLAG = a.SEQ_FLAG
															--and LEFT(b.SEQ_FLAG,1) = LEFT(a.SEQ_FLAG,1)
															and b.YYYYMMDD = @PROC_YYYYMMDD
															),0) AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
					where a.measure = 'INV'
					--and substring(a.SEQ_FLAG,2,1) = '6'
					and a.SEQ_FLAG <> '360'
					and a.YYYYMMDD=@PRE_YYYYMMDD 
				END

				SET @I = @I + 1

				--SET @PROC_YYYYMMDD_OLD = CONVERT(VARCHAR(8),DATEADD(M, 1, @PROC_YYYYMMDD_OLD),112)
				SET @PRE_YYYYMMDD = @PROC_YYYYMMDD
				SET @PROC_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(D, 1, @PROC_YYYYMMDD),112)
				--SET @PROC_YYYYMM = LEFT(@PROC_YYYYMMDD_OLD,6)

			END 


*/ -- ksg : 선입선출 배분 처리 후 없는 재고 포함 및 미래구간 재고 계산 로직 처리 필요 : END

end  



