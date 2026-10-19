

/********************************************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_Small                        
 * Description  : 재료비 TASK(소형).  PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화        
 * OutTable     : SCP_ANL_PSI_INTEGRATION                     
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_Small_for_Proc
                       @p_division_id         = '40'
                     , @p_plan_start_yyyymmdd = '20240923'
                  
 * Program History                      
 *===========================================================================================================================================                      
 *   Date       In Charge      Description                      
 *===========================================================================================================================================                      
 * 2024.10.25     lgjjg        Initial. PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화.
 ********************************************************************************************************************************************/                    

-- exec PR_SCP_ANL_PSI_INTEGRATION_Small_for_Proc '40', '20241125'

create PROCEDURE [dbo].[zjjg_PR_SCP_ANL_PSI_INTEGRATION_Small_for_Proc_20250113_bkup_good]
(                         
      @p_division_id          NVARCHAR(30)            
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name         
)                         
AS                        
  BEGIN 
  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                        
    SET NOCOUNT ON;                        
    SET XACT_ABORT ON;                        
    SET ANSI_WARNINGS ON;                        
                        
    -- LOG 용 변수 설정                        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';                          
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_INTEGRATION_Small_for_Proc';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PSI_INTEGRATION';                         
    DECLARE @d_event_date   DATETIME;                        
	                   
    DECLARE @V_STATUS_DESC  NVARCHAR(1000) = 'START'; 
	
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @p_division_id + ':' + @v_program_name + ':' + @v_table_id + N' INSERT LOGIC';                        
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
	DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= ISNULL(@P_DIVISION_ID, '40')
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
	DECLARE @V_EE_PLAN_SEQ				BIGINT			= 1
	DECLARE @V_EE_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_EE_ENG_PLAN_ID			NVARCHAR(100)	= NULL

	
    BEGIN TRY                        
        BEGIN  

			---------------------------------------------------------------------------------------------------
			-- SCP PLAN 버전 정보 (PRODUCTION) 
			---------------------------------------------------------------------------------------------------
            SET @V_STATUS_DESC = 'Plan seq';

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
			  AND P.PLAN_NAME    = @P_PLAN_START_YYYYMMDD  
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 


            SET @V_STATUS_DESC = 'division EE ';
             -- 전극 @V_EE_DIVISION_ID 구하기.
			SELECT TOP 1 @V_EE_DIVISION_ID = b.DIVISION_ID
			from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION A with(nolock)
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION B WITH(NOLOCK)
			on b.attribute4 = a.ATTRIBUTE4
			and b.ATTRIBUTE3 = 'EE'
			where a.DIVISION_ID = @V_DIVISION_ID	-- '81_HM'


            SET @V_STATUS_DESC = ' plan EE';
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





          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------   
          IF OBJECT_ID('tempdb..#tmp_psi_integration_inv_small') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_inv_small     
			  
          IF OBJECT_ID('tempdb..#tmp_psi_integration_220_240_small') IS NOT NULL   -- pack 반제품 추가.
              DROP TABLE #tmp_psi_integration_220_240_small   
			  
          IF OBJECT_ID('tempdb..#tmp_psi_integration_320_340_small') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_320_340_small   
/*
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_small_330_yield') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_330_yield  
*/			  
		  IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_230_ITEM_small') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_230_ITEM_small

		  IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_350_small') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_350_small

		  IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_350_750_430_ultra_small') IS NOT NULL  
			  DROP TABLE #tmp_PSI_INTEGRATION_350_750_430_ultra_small

		  IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_750_small') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_750_small

          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_450_small') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_450_small 

          IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_430_small') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_430_small 



          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_small') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small 	
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy	

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd	


          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_small_650_330') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330	





           CREATE TABLE #tmp_psi_integration_inv_small(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
				YYYYMMDD				NVARCHAR(8)     NULL,
				RECEIVING_DTTM_YYYYMM	NVARCHAR(6)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
	            QTY_include_yield       NUMERIC(20, 10) NULL,
				DESCR					NVARCHAR(4000)  NULL,
                ATTRIBUTE8              NVARCHAR(150)   NULL,     
				FLOW_ID					NVARCHAR(200)   NULL, 
				OPERATION_GROUP			NVARCHAR(1)     NULL,
				TCO_CELL_YN				NVARCHAR(1)     NULL
            );
			
--			create index i_tmp_psi_integration_inv_small_01 on #tmp_psi_integration_inv_small(item_id)
--			create index i_tmp_psi_integration_inv_small_02 on #tmp_psi_integration_inv_small(RECEIVING_DTTM_YYYYMM, item_id)

           CREATE TABLE #tmp_psi_integration_220_240_small(                        
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

           CREATE TABLE #tmp_psi_integration_320_340_small(                        
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

/*
           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_330_yield(
                DIVISION_ID             NVARCHAR(10)    NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
				COMPANY_ID			    NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
                CELL_ITEM_ID            NVARCHAR(40)    NULL,       
	            ITEM_ID                 NVARCHAR(40)    NULL,
	            child_ITEM_ID           NVARCHAR(40)    NULL,
				LINE_ID					NVARCHAR(10)    NULL,
				YYYYMM				    NVARCHAR(6)     NULL,
				YIELD					numeric(18, 6)	NULL )  		
*/

           CREATE TABLE #tmp_PSI_INTEGRATION_230_ITEM_small(                        
	            ITEM_ID                 NVARCHAR(40)    NULL
            );   


           CREATE TABLE #tmp_PSI_INTEGRATION_350_small(                        
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


           CREATE TABLE #tmp_PSI_INTEGRATION_350_750_430_ultra_small(                        
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
			
           CREATE TABLE #tmp_PSI_INTEGRATION_750_small(                        
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

           CREATE TABLE #tmp_PSI_INTEGRATION_450_small(                        
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
				YYYYMMDD				NVARCHAR(8)     NULL,
				YYYYMMDD_LT			    NVARCHAR(8)     NULL,
	            YIELD		            NUMERIC(20, 10) NULL,
	            QTY			            NUMERIC(20, 10) NULL
            );    

           CREATE TABLE #tmp_PSI_INTEGRATION_430_small(                        
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

                        
           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small(                        
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
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_01 on #tmp_SCP_ANL_PSI_INTEGRATION_small(item_id)
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_02 on #tmp_SCP_ANL_PSI_INTEGRATION_small(YYYYMM, item_id)

           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330(                        
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

           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy(                        
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
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_01 on #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy(item_id)
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_02 on #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy(YYYYMM, item_id)

           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd(                        
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
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd_01 on #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd(item_id)
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd_02 on #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd(YYYYMM, item_id)

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    0.MKT FCST 입력
          ------------------------------------------------------------------------------------------------------------- 

           SET @V_STATUS_DESC = '0.MKT FCST ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
		SELECT	a.DIVISION_ID,
			'-' as COMPANY_ID, 
			'-' as PLANT_ID,
	        a.PLAN_START_YYYYMMDD,
	        1 AS SEQ, 
			a.operation_group,
			'-' as FROM_SITE,
            '-' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	        a.ITEM_ID,
	        'MKT_FCST' as MEASURE,
			'-' as value_type,
			'-' as TO_PRODUCT,
			'-'  as LINE_ID,   -- shipment 에는 Line_id 없으므로 공백처리함.
            0 as BOH_QTY,
			(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								    when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									else '-'
									end ) AS TO_SITE,
			a.incoterms, 
			(CASE WHEN a.operation_group = 'P' THEN '100'
					WHEN a.operation_group = 'A' and b.tco_cell_yn = 'Y' THEN '600'
					WHEN a.operation_group = 'A' THEN '300'
				    END ) AS SEQ_FLAG,  
			left(a.YYYYMMDD,6) as YYYYMM,
	        isnull(sum(isnull(QTY,0)),0) as QTY
		FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PSI_GLOBAL_SMALL a WITH(NOLOCK)
		left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on  x.DIVISION_ID = a.DIVISION_ID
				and x.SCM_SITE_ID = a.to_SITE
		left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM b WITH (NOLOCK)
			on b.division_id =  a.DIVISION_ID
			and b.operation_group = 'A'
			and b.item_id = a.item_id   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
		inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
			on C.item_id = A.ITEM_ID
			and C.division_id = a.DIVISION_ID
			and c.FLOW_ID <> 'P5000' 
		WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.PLAN_TYPE			= @V_PLAN_TYPE
			AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID
			and a.measure = 'MKT_FCST' 
			AND a.operation_group IN ('A','P')   
			AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
		group by a.DIVISION_ID,
				a.PLAN_START_YYYYMMDD,
				a.operation_group,
				a.ITEM_ID,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
					when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
					else '-'
					end ),
				a.incoterms,
				(CASE WHEN a.operation_group = 'P' THEN '100'
					WHEN a.operation_group = 'A' and b.tco_cell_yn = 'Y' THEN '600'
					WHEN a.operation_group = 'A' THEN '300'
				    END ) ,
				left(a.YYYYMMDD,6)



          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    1.Ship. Plan(RTF) 입력
          ------------------------------------------------------------------------------------------------------------- 

          SET @V_STATUS_DESC = '1.Ship. Plan(RTF)  ';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID,    
				ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							  else  b.PLANT_ID
							  end ),'-') as PLANT_ID,  
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				a.operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID,  
	            a.FROM_ITEM_ID AS item_id, -- Group 에 의해 실제 제공된 Item 표시
	            'SHIP_PLAN_RTF' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
					(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ) AS TO_SITE,
				a.incoterms,
				(CASE WHEN (a.operation_group = 'P' and c.FLOW_ID =  'P5000' )THEN '210'
					  WHEN (a.operation_group = 'P' and c.FLOW_ID <> 'P5000' )THEN '110'
					  WHEN a.operation_group = 'A' and fi.tco_cell_yn = 'Y' THEN '610'  --> TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V 
					  WHEN a.operation_group = 'A' THEN '310'  --> TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V 
				      END ) AS SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = (case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.from_item_id -- Group 에 의해 실제 제공된 Item 표시
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													--and k.incoterms = a.incoterms 
													and k.incoterms = a.scp_incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
													and k.PLAN_TYPE = @V_PLAN_TYPE  
													and k.seq = @V_PLAN_SEQ 
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.from_item_id -- Group 에 의해 실제 제공된 Item 표시
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		--and m.incoterms = a.incoterms 
																		and m.incoterms = a.scp_incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
																		and m.PLAN_TYPE = @V_PLAN_TYPE  
																		and m.seq = @V_PLAN_SEQ 
																		and m.qty <> 0
																		and m.measure = 'WH_IN' ) 
													and k.measure = 'WH_IN')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from [10.34.221.78,7433].eng_scp.dbo.th_exp_delivery de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.from_item_id -- Group 에 의해 실제 제공된 Item 표시
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
				 on fi.division_id =  a.DIVISION_ID
				 and fi.operation_group = 'A'
				 and fi.item_id = a.item_id   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = a.DIVISION_ID
					--and c.FLOW_ID <> 'P5000' 
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.operation_group IN ('A','P')   
--			  AND a.YYYYMMDD <= '20241231'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.PLANT_ID = 'KR004004' THEN 'G182'
						   else  b.PLANT_ID
						   end ),
					 a.PLAN_START_YYYYMMDD,
					 a.operation_group,
					 a.FROM_ITEM_ID, -- Group 에 의해 실제 제공된 Item 표시
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					 a.incoterms,
					(CASE WHEN (a.operation_group = 'P' and c.FLOW_ID =  'P5000' )THEN '210'
						  WHEN (a.operation_group = 'P' and c.FLOW_ID <> 'P5000' )THEN '110'
						  WHEN a.operation_group = 'A' and fi.tco_cell_yn = 'Y' THEN '610'  --> TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V 
						  WHEN a.operation_group = 'A' THEN '310'  --> TCO_CELL_YN : Y : 후공정 CELL : SCP_MST_FINAL_ITEM_V 
						  END ) ,
					left(a.YYYYMMDD,6)


--2번(기존)
			update a set	company_id = isnull(b.company_id,'-'),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.PLANT_ID = 'KR004004') THEN 'G182'
										  when b.SITE_TYPE = 'PLANT'  THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.TO_SITE  --a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.TO_SITE --a.from_site	
															and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310','610')

--3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant
			update a set	company_id = isnull(b.company_id,'-'), --b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.PLANT_ID = 'KR004004') THEN 'G182'
										  when b.SITE_TYPE = 'PLANT'  THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.SCM_SITE_ID)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PRODUCTION_PLAN k with(nolock) 
										where 1=1
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PRODUCTION_PLAN m with(nolock)
															where 1=1
															and m.item_id = isnull((select max(item_id_assy) 
																					from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP z 
																					where z.division_id = a.division_id 
																					and z.item_id_prod = a.item_id 
																					and cell_type='CA1' 
																					and valid_yn='Y'),a.item_id)
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'PROD_PLAN_AMEND' ) 
										and k.measure = 'PROD_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310','610')


          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    5.PROD_PLAN 입력
          -------------------------------------------------------------------------------------------------------------  

            SET @V_STATUS_DESC = '5.PROD_PLAN ';




		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							 else  b.PLANT_ID
							 end ),'-') as PLANT_ID,  
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				--(CASE WHEN a.operation_group = 'P' THEN '150'
				--	  WHEN a.operation_group = 'A' THEN '450'
				--      END ) AS SEQ_FLAG,  
				'150' AS SEQ_FLAG, 
				left(a.YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)   -- 여기에서 pack 제품만 포함되도록 해야 함. pack반제품이 포함되어 있음.
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = a.DIVISION_ID
					and c.FLOW_ID <> 'P5000' 
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'P'   --('A','P') 
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							else  b.PLANT_ID
							end ),  
				     a.PLAN_START_YYYYMMDD,
					 a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
					left(a.YYYYMMDD,6)



------- 250 : 반제품 Prod_Plan 생성

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							 else  b.PLANT_ID
							 end ),'-') as PLANT_ID,  
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				--(CASE WHEN a.operation_group = 'P' THEN '150'
				--	  WHEN a.operation_group = 'A' THEN '450'
				--      END ) AS SEQ_FLAG,  
				'250' AS SEQ_FLAG, 
				left(a.YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)   -- 여기에서 pack 제품만 포함되도록 해야 함. pack반제품이 포함되어 있음.
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = a.DIVISION_ID
					and c.FLOW_ID = 'P5000' 
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'P'   --('A','P') 
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							else  b.PLANT_ID
							end ),  
				     a.PLAN_START_YYYYMMDD,
					 a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
					left(a.YYYYMMDD,6)


----- 후공정 제품 (650) : Prod Plan - 셀 후공정 제품의 Shipment Plan FG start -------- '350' 활용

	
		 --  이하 shipment_plan_fg 입력
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				b.COMPANY_ID,
				ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							 else  b.PLANT_ID
							 end ),'-') as PLANT_ID, 
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-'  as FROM_SITE,
                '-' as CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				'-' as TO_SITE, 
				'-' as INCOTERMS,
				'650'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(a.QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_fg a WITH(NOLOCK)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			--final_item 조인하기.
			INNER join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
				 on fi.division_id =  a.DIVISION_ID
				 and fi.operation_group = 'A'
				 and fi.item_id = a.item_id   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
				 and fi.tco_cell_yn = 'Y'
				 and fi.attribute8 = 'CP'
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.biz_type = 'A'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 b.COMPANY_ID,
					 (case when  b.PLANT_ID = 'KR004004' THEN 'G182'
						   else  b.PLANT_ID
						   end ),
				     a.PLAN_START_YYYYMMDD,
				     a.ITEM_ID,
					 left(a.YYYYMMDD,6)

----- 후공정 제품 (650) : Prod Plan - 셀 후공정 제품의 Shipment Plan FG end --------


----- 후공정 반제품 (730, 750) START
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
		SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				ca.item_id_ASSY AS ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'730'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0)),0) as QTY  -- pack, cell 수율반영	
			--select *
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP ca WITH(NOLOCK)
				ON  ca.DIVISION_ID = a.division_id  --'40'
				and ca.plant_id = a.plant_id
				AND ca.ITEM_ID_PROD = a.item_id
				and ca.cell_type = 'CA2'
				and ca.valid_yn = 'Y'
			where a.SEQ_FLAG = '650'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             ca.item_id_ASSY,  
					 a.YYYYMM


----- 후공정 반제품 (730, 750) END

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) inv start
		  --    6.BOH 입력
          -------------------------------------------------------------------------------------------------------------  

            SET @V_STATUS_DESC = '6.BOH ';

			insert into #tmp_psi_integration_inv_small
			SELECT   SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1) AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,CONVERT(NVARCHAR(6), A.RECEIVING_DTTM,112) AS RECEIVING_DTTM_YYYYMM
					,isnull(SUM(ISNULL(A.QTY,0)),0) AS QTY
					,isnull(SUM(ISNULL(A.QTY,0) * isnull(fm.FORMATION_TOTAL_YIELD, 1)),0)   AS QTY_include_yield     
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)  
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID
				 and b.SCM_SITE_ID = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  
				 and not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES')
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1)
					and C.division_id = @V_DIVISION_ID  
					and c.FLOW_ID <> 'P5000' 
			-- 활성화 수율 가져오기 
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = SUBSTRING(A.MASTER_ID,1,2)  --a.DIVISION_ID
				and fm.PLANT_SITE_ID = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
				and fm.item_id =A.ITEM_ID

			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID  
			AND A.PLAN_ID     = @V_ENG_PLAN_ID  
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					 SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1)                    
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID  
					,CONVERT(NVARCHAR(6), A.RECEIVING_DTTM,112)
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN

-- SALES_ONHAND 추가

			insert into #tmp_psi_integration_inv_small
			SELECT   A.DIVISION_ID AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,A.SITE_ID  AS FROM_SITE
					,A.ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,left(@V_PLAN_START_YYYYMMDD,6) AS RECEIVING_DTTM_YYYYMM					--,CONVERT(NVARCHAR(8), A.YYYYMMDD,112) AS RECEIVING_DTTM_YYYYMMDD
					,isnull(SUM(ISNULL(A.PSI_BOH_QTY,0)),0)   AS QTY     
					,isnull(SUM(ISNULL(A.PSI_BOH_QTY,0)),0)   AS QTY_include_yield     
					,'WH' AS DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_SALES_ONHAND A WITH(NOLOCK)  
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID
				 and b.SCM_SITE_ID = A.SITE_ID
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = A.DIVISION_ID
					and C.division_id = @V_DIVISION_ID  
					and c.FLOW_ID <> 'P5000' 
			where  A.DIVISION_ID = @V_DIVISION_ID
			AND A.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			AND A.PLAN_TYPE = @V_PLAN_TYPE
			AND A.seq = @V_PLAN_SEQ
			AND A.YYYYMMDD = @V_PLAN_START_YYYYMMDD --> 이부분 맞나요?
			AND A.PSI_BOH_QTY <> 0
			GROUP BY  A.DIVISION_ID                   
					 ,A.SITE_ID  
					,A.ITEM_ID  
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP, C.TCO_CELL_YN


			/*****************************************
				#tmp_psi_integration_inv_small  'P5000'을 추가.
			******************************************/

            SET @V_STATUS_DESC = '6.BOH P5000';

-- = 'P5000' : not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES')

			INSERT INTO #tmp_psi_integration_inv_small
			SELECT   SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1) AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,CONVERT(NVARCHAR(6), A.RECEIVING_DTTM,112) AS RECEIVING_DTTM_YYYYMMDD
					,isnull(SUM(ISNULL(A.QTY,0)),0)   AS QTY     
					,isnull(SUM(ISNULL(A.QTY,0) * isnull(fm.FORMATION_TOTAL_YIELD, 1)),0)   AS QTY_include_yield     
					,A.DESCR
					,'-' as attribute8, C.FLOW_ID, 'P' as OPERATION_GROUP, '-' as TCO_CELL_YN
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID
				 and b.SCM_SITE_ID = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  
				 and not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES')			
			inner join (select distinct division_id, item_id, isnull(scp_flow_id, flow_id) flow_id
			            from [10.34.221.78,7433].lgce_fp_tr.dbo.SCM_ITEM_M WITH(NOLOCK)   
						where division_id = @V_DIVISION_ID 
						and isnull(scp_flow_id, flow_id) = 'P5000'
				        ) c
					on  c.division_id = SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1)
					and c.item_id = A.ITEM_ID
			-- 활성화 수율 가져오기 
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = SUBSTRING(A.MASTER_ID,1,2)  --a.DIVISION_ID
				and fm.PLANT_SITE_ID = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
				and fm.item_id =A.ITEM_ID
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID 
			AND A.PLAN_ID     = @V_ENG_PLAN_ID 
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					 SUBSTRING(A.MASTER_ID, 1, CHARINDEX('::', A.MASTER_ID)-1)
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID   
					,CONVERT(NVARCHAR(6), A.RECEIVING_DTTM,112)
					,A.DESCR
					,C.FLOW_ID


			/****************************************************
			EE 재고('560')를 #tmp_psi_integration_inv_small 에 추가로 insert 해야함.
			****************************************************/

            SET @V_STATUS_DESC = '6.BOH EE';


			-- 재고의 COMPANY_ID, PLANT_ID 반영.
			update a set company_id = isnull(b.company_id,'-'), 
						 plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group = 'A') THEN 	-- 셀사이트에 있는 전극 재고는 전극 PLANT로 처리
												  substring(b.plant_id,1, len(b.plant_id)-1) + convert(nvarchar(1),convert(int, right(b.plant_id,1)) + 1) 
										  when (b.SITE_TYPE = 'PLANT' AND  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a  
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = a.from_site	



--1번(추가) : 가장 빠른 WH_IN이 있는 Plant
			update a set	company_id = isnull(b.company_id,'-'),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' AND  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'WH_IN' )  --WH_IN을 봄
										and k.measure = 'WH_IN') --WH_IN
			where isnull(a.plant_id,'-') < '0'


--2번(기존)
			update a set	company_id = isnull(b.company_id,'-'),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'


--3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant
			update a set	company_id = isnull(b.company_id,'-'),
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.SCM_SITE_ID)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PRODUCTION_PLAN k with(nolock) 
										where 1=1
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PRODUCTION_PLAN m with(nolock)
															where 1=1
															and m.item_id = isnull((select max(item_id_assy) 
																					from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP z 
																					where z.division_id = a.division_id 
																					and z.item_id_prod = a.item_id 
																					and cell_type='CA1' 
																					and valid_yn='Y'),a.item_id)
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'PROD_PLAN_AMEND' ) 
										and k.measure = 'PROD_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'


--4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정
			update a set	company_id = isnull(b.company_id,'-'), --b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select top 1 from_site from #tmp_psi_integration_inv_small k
											inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site m WITH(NOLOCK)
											on m.DIVISION_ID = k.DIVISION_ID 
											and m.scm_site_id = k.from_site
											and m.SITE_TYPE = 'PLANT'
											where k.division_id = a.division_id
											and (k.item_id = a.item_id or k.item_id = isnull((select max(item_id_assy) 
																							  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP z 
																							  where z.division_id = a.division_id 
																							  and z.item_id_prod = a.item_id 
																							  and cell_type='CA1' 
																							  and valid_yn='Y'),a.item_id))
											and k.qty <> 0
											group by from_site, item_id
											order by sum(qty) desc)
			where isnull(a.plant_id,'-') < '0'


--5번(기존)
			update a set	company_id = isnull(b.company_id,'-'),  --b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'
										  when (b.SITE_TYPE = 'PLANT' and  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD
										and k.PLAN_TYPE = @V_PLAN_TYPE
										and k.seq = @V_PLAN_SEQ 
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE 
															and m.seq = @V_PLAN_SEQ 
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'


			update a set COMPANY_ID = ( SELECT min(COMPANY_ID) 
										FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
										WHERE  b.DIVISION_ID = a.DIVISION_ID
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.plant_id = a.plant_id)
			FROM #tmp_psi_integration_inv_small a
			WHERE a.PLANT_ID = 'G182'
			and isnull(a.COMPANY_ID,'-') <>  (  SELECT min(COMPANY_ID) 
												FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
												WHERE  b.DIVISION_ID = a.DIVISION_ID
												and b.OPERATION_GROUP = a.OPERATION_GROUP
												and b.plant_id =  a.plant_id)



---------- 450, 430 만든는 부분 여기에 넣을것.START --------

		  INSERT INTO #tmp_PSI_INTEGRATION_450_small
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
				YYYYMMDD_LT,
				YIELD,
				QTY
			 )
         SELECT a.DIVISION_ID,
				B.COMPANY_ID,
				ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							 else  b.PLANT_ID
							 end ),'-') as PLANT_ID, 
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				a.OPERATION_GROUP,
				a.SCM_SITE_ID AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				'450' AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
				convert(varchar(8), dateadd(d, ISNULL(fm.TOTAL_LT_FORMATION,0), a.YYYYMMDD),112) as yyyymmdd_LT,
				isnull(fm.FORMATION_TOTAL_YIELD, 1) AS YIELD,
	            isnull(QTY,0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			INNER join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
				 on fi.division_id =  a.DIVISION_ID
				 and fi.operation_group = 'A'
				 and fi.item_id = a.item_id   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
				 AND LEFT(fi.ATTRIBUTE8,2) = 'CA'  -- CP:제품, CA:반제품
				 and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님.
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			-- 활성화 수율 가져오기 
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = a.DIVISION_ID
				and fm.PLANT_SITE_ID = A.SCM_SITE_ID
				and fm.item_id =A.ITEM_ID	
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


-- 450 insert
		INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
				COMPANY_ID,
				PLANT_ID as PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				'450' AS SEQ_FLAG,  
				left(YYYYMMDD,6),  
	            isnull(sum(isnull(QTY,0)),0) as QTY   
		from #tmp_PSI_INTEGRATION_450_small  
		group by  DIVISION_ID,
					COMPANY_ID,
					PLANT_ID, 
					PLAN_START_YYYYMMDD,
					OPERATION_GROUP, 
					ITEM_ID,
					LINE_ID,
					left(YYYYMMDD,6)


-- 430 만들기
--   1. 활성화 lt 포함
-- 430 : A.ITEM_ID <> 'MASS20253-A2'

		INSERT INTO #tmp_PSI_INTEGRATION_430_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID as PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            a.ITEM_ID,
	            'IN_HOUSE_MOVING' AS MEASURE,
				'-' AS value_type,
--				FC.item_id_PROD as TO_PRODUCT,
-- 반영1/4 start
				to_product = (select min(fc.item_id_PROD)
								from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
								INNER join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  -- 2,237,978,407.1687378580
									on fi.division_id =  fc.DIVISION_ID
									and fi.operation_group = 'A'
									and fi.item_id = fc.item_id_prod   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
									AND LEFT(fi.ATTRIBUTE8,2) = 'CP'  -- CP:제품, CA:반제품
							--		and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님.
								where FC.DIVISION_ID = A.DIVISION_ID
									AND FC.ITEM_ID_ASSY = A.ITEM_ID
									and fc.CELL_TYPE = 'CA1'
									AND FC.PLANT_ID = A.PLANT_ID
									and fc.VALID_YN = 'Y'
							),
-- 반영1/4 end
				'-' as LINE_ID,
				0 as BOH_QTY,
	            A.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,  
				'430' as SEQ_FLAG, 
				left(a.YYYYMMDD_LT, 6) as YYYYMM,
	            isnull(sum(isnull(a.QTY,0)),0) as QTY
		from #tmp_PSI_INTEGRATION_450_small A  
-- 반영2/4 start
		WHERE  EXISTS (SELECT 'Y' 
						FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
						WHERE exists (select 'y'
									  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  -- 2,237,978,407.1687378580
									  where fi.division_id =  fc.DIVISION_ID
									  and fi.operation_group = 'A'
									  and fi.item_id = fc.item_id_prod   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
									  AND LEFT(fi.ATTRIBUTE8,2) = 'CP'  -- CP:제품, CA:반제품
									  --and isnull(fi.TCO_CELL_YN,'N') <> 'Y' 
									  )
						and FC.DIVISION_ID = A.DIVISION_ID
						AND FC.ITEM_ID_ASSY = A.ITEM_ID
						and fc.CELL_TYPE = 'CA1'
						AND FC.PLANT_ID = A.PLANT_ID
						and fc.VALID_YN = 'Y' )
-- 반영2/4 end
		and a.YYYYMMDD_LT <= @V_HORIZON_END_YYYYMMDD
--AND A.ITEM_ID <> 'MASS20253-A2'
		AND A.ITEM_ID NOT IN (select DISTINCT SEGMENT1
							  from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
							  where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
							  AND VALID_YN = 'Y')
		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					a.ITEM_ID,
					--to_product,  --FC.item_id_PROD,
					left(YYYYMMDD_LT, 6)


-- 2. aging
-- AGING : A.ITEM_ID <> 'MASS20253-A2'

		INSERT INTO #tmp_PSI_INTEGRATION_430_small
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
		select  a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
				a.ITEM_ID,
				'IN_HOUSE_MOVING' AS MEASURE,
				'-' as value_type,
--				FC.item_id_PROD as TO_PRODUCT,
-- 반영3/4 start
				to_product = (select min(fc.item_id_PROD)
								from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
								INNER join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  -- 2,237,978,407.1687378580
									on fi.division_id =  fc.DIVISION_ID
									and fi.operation_group = 'A'
									and fi.item_id = fc.item_id_prod   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
									AND LEFT(fi.ATTRIBUTE8,2) = 'CP'  -- CP:제품, CA:반제품
							--		and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님.
								where FC.DIVISION_ID = A.DIVISION_ID
									AND FC.ITEM_ID_ASSY = A.ITEM_ID
									and fc.CELL_TYPE = 'CA1'
									AND FC.PLANT_ID = A.PLANT_ID
									and fc.VALID_YN = 'Y'
							),
-- 반영3/4 end
				'-' as LINE_ID,
				0 as BOH_QTY,
				A.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,  
				'430' as SEQ_FLAG, 
				a.RECEIVING_DTTM_YYYYMM AS YYYYMM,
				isnull(sum(isnull(a.QTY,0)),0) as QTY
		from #tmp_psi_integration_inv_small a   
-- 반영4/4 start
		WHERE  EXISTS (SELECT 'Y' 
						FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
						WHERE exists (select 'y'
									  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  -- 2,237,978,407.1687378580
									  where fi.division_id =  fc.DIVISION_ID
									  and fi.operation_group = 'A'
									  and fi.item_id = fc.item_id_prod   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
									  AND LEFT(fi.ATTRIBUTE8,2) = 'CP'  -- CP:제품, CA:반제품
									  --and isnull(fi.TCO_CELL_YN,'N') <> 'Y' 
									  )
						and FC.DIVISION_ID = A.DIVISION_ID
						AND FC.ITEM_ID_ASSY = A.ITEM_ID
						and fc.CELL_TYPE = 'CA1'
						AND FC.PLANT_ID = A.PLANT_ID
						and fc.VALID_YN = 'Y' )
-- 반영4/4 end
		and a.operation_group='A' 
		and  a.attribute8 = 'CA1'  
		and ISNULL(a.TCO_CELL_YN,'N') <> 'Y'
		AND (a.DESCR like 'FOR%' OR a.DESCR = 'WH')
--AND A.ITEM_ID <> 'MASS20253-A2'
		AND A.ITEM_ID NOT IN (select DISTINCT SEGMENT1
							  from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
							  where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
							  AND VALID_YN = 'Y')
		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					a.ITEM_ID,
					--to_product,  -- FC.item_id_PROD,
					a.RECEIVING_DTTM_YYYYMM




-- 430 취합해서 넣기

		INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            @V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            ITEM_ID,
	            'IN_HOUSE_MOVING' AS MEASURE,
				'-' as value_type,
				TO_PRODUCT,
				'-' as LINE_ID,
				0 as BOH_QTY,
	            TO_SITE,
				'-' as INCOTERMS,  
				'430' as SEQ_FLAG, 
				YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
		FROM #tmp_PSI_INTEGRATION_430_small  -- 12,984,  ==> 129,584
		group by  DIVISION_ID,
					COMPANY_ID,
					PLANT_ID, 
					ITEM_ID,
					TO_PRODUCT,
					TO_SITE,
					YYYYMM

-- 430 to start

		update a set to_product =  ISNULL((select min(FC4.ITEM_ID_ASSY)
									from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC3 WITH(NOLOCK)
									inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi3 WITH (NOLOCK)
											on  fi3.division_id = a.DIVISION_ID
											and fi3.operation_group = 'A'
											and fi3.item_id = fc3.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
											AND left(fi3.ATTRIBUTE8,2) = 'CP'
											and isnull(fi3.TCO_CELL_YN,'N') = 'Y'
									inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC4 WITH (NOLOCK)
											on FC4.DIVISION_ID = A.DIVISION_ID  -- '40' 
											AND FC4.ITEM_ID_prod = fi3.item_id
											and FC4.CELL_TYPE = 'CA2'
											AND FC4.PLANT_ID = A.PLANT_ID
											and FC4.VALID_YN = 'Y'
									where fc3.DIVISION_ID = A.DIVISION_ID  -- '40'  -- 
									AND FC3.ITEM_ID_ASSY = A.ITEM_ID
									and fc3.CELL_TYPE = 'CA1'
									AND FC3.PLANT_ID = A.PLANT_ID
									and fc3.VALID_YN = 'Y'), A.to_product)
		FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a WITH(NOLOCK) 
		WHERE a.DIVISION_ID = @V_DIVISION_ID --'40'   
		AND a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --'20240923'
		AND a.seq_flag = '430'
		and  exists ( select 'Y' 
						from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC2 WITH(NOLOCK)
						inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi2 WITH (NOLOCK)
								on  fi2.division_id = a.DIVISION_ID
								and fi2.operation_group = 'A'
								and fi2.item_id = fc2.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
								AND left(fi2.ATTRIBUTE8,2) = 'CP'
								and isnull(fi2.TCO_CELL_YN,'N') = 'Y'
						where fc2.DIVISION_ID = A.DIVISION_ID
						AND FC2.ITEM_ID_ASSY = A.ITEM_ID
						and fc2.CELL_TYPE = 'CA1'
						AND FC2.PLANT_ID = A.PLANT_ID
						and fc2.VALID_YN = 'Y')


-- 430 to end


--======================================  350 만들기 start =======================

-- 430 복사해서 350 만듦
-- 430 만들기
-- 1. 활성화 lt 포함


		INSERT INTO #tmp_PSI_INTEGRATION_350_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID as PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            fc.ITEM_ID_prod AS ITEM_ID,
	            'PROD_PLAN' AS MEASURE,
				'-' AS value_type,
				'-' as TO_PRODUCT,
				a.line_id as LINE_ID,
				0 as BOH_QTY,
	            '-' as TO_SITE,  
				'-' as INCOTERMS,  
				'350' as SEQ_FLAG, 
				left(a.YYYYMMDD_LT, 6) as YYYYMM,
	            isnull(sum(isnull(a.QTY,0) * isnull(a.YIELD, 1)),0) as QTY
		from #tmp_PSI_INTEGRATION_450_small a  
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
			ON FC.DIVISION_ID = @V_DIVISION_ID --'40'
			AND FC.ITEM_ID_ASSY = A.ITEM_ID
			and fc.CELL_TYPE = 'CA1'
			AND FC.PLANT_ID = A.PLANT_ID
			and fc.VALID_YN = 'Y'
		inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
			on fi.division_id = a.DIVISION_ID
			and fi.operation_group = 'A'
			and fi.item_id = fc.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
			AND left(fi.ATTRIBUTE8,2) = 'CP'
			and isnull(fi.TCO_CELL_YN,'N') <> 'Y'
		where YYYYMMDD_LT <= @V_HORIZON_END_YYYYMMDD
						and not exists (select 'Y' 
								from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC2 WITH(NOLOCK)
								inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi2 WITH (NOLOCK)
										on  fi2.division_id = a.DIVISION_ID
										and fi2.operation_group = 'A'
										and fi2.item_id = fc2.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
										and fi2.item_id not in (SELECT SEGMENT1
																from SCM_ADM_LOOKUP_MASTER_DETAIL A with(nolock)
																where LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
																AND VALID_YN = 'Y')
										AND left(fi2.ATTRIBUTE8,2) = 'CP'
										and isnull(fi2.TCO_CELL_YN,'N') = 'Y'
								where fc2.DIVISION_ID = @V_DIVISION_ID --'40'
								AND FC2.ITEM_ID_ASSY = A.ITEM_ID
								and fc2.CELL_TYPE = 'CA1'
								AND FC2.PLANT_ID = A.PLANT_ID
								and fc2.VALID_YN = 'Y')

		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					fc.ITEM_ID_prod,
					a.line_id,
					left(a.YYYYMMDD_LT, 6)


--   2. aging

		INSERT INTO #tmp_PSI_INTEGRATION_350_small
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
		select  a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
				FC.ITEM_ID_PROD as item_id,
				'PROD_PLAN' AS MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,  
				'-' as LINE_ID,
				0 as BOH_QTY,
				'-' as TO_SITE,
				'-' as INCOTERMS,  
				'350' as SEQ_FLAG, 
				a.RECEIVING_DTTM_YYYYMM AS YYYYMM,
				isnull(sum(isnull(QTY_include_yield,0)),0) as QTY
		from #tmp_psi_integration_inv_small a   
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
			ON FC.DIVISION_ID = @V_DIVISION_ID --'40'
			AND FC.ITEM_ID_ASSY = A.ITEM_ID
			and fc.CELL_TYPE = 'CA1'
			AND FC.PLANT_ID = A.PLANT_ID
			and fc.VALID_YN = 'Y'
		inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
			on fi.division_id = a.DIVISION_ID
			and fi.operation_group = 'A'
			and fi.item_id = FC.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
			AND fi.ATTRIBUTE8 = 'CP'
			and isnull(fi.TCO_CELL_YN,'N') <> 'Y'
						and not exists (select 'Y' 
								from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC2 WITH(NOLOCK)
								inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi2 WITH (NOLOCK)
										on  fi2.division_id = a.DIVISION_ID
										and fi2.operation_group = 'A'
										and fi2.item_id = fc2.ITEM_ID_PROD   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
										and fi2.item_id not in (SELECT SEGMENT1
																from SCM_ADM_LOOKUP_MASTER_DETAIL A with(nolock)
																where LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
																AND VALID_YN = 'Y')
										AND left(fi2.ATTRIBUTE8,2) = 'CP'
										and isnull(fi2.TCO_CELL_YN,'N') = 'Y'
								where fc2.DIVISION_ID = @V_DIVISION_ID --'40'
								AND FC2.ITEM_ID_ASSY = A.ITEM_ID
								and fc2.CELL_TYPE = 'CA1'
								AND FC2.PLANT_ID = A.PLANT_ID
								and fc2.VALID_YN = 'Y')
		where a.operation_group='A' 
		and  a.attribute8 = 'CA1'  
		and ISNULL(a.TCO_CELL_YN,'N') <> 'Y'
		AND (a.DESCR like 'FOR%' OR a.DESCR = 'WH')  --a.DESCR like 'FOR%'
		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					FC.ITEM_ID_PROD,
					A.PLANT_ID,
					a.RECEIVING_DTTM_YYYYMM


-- 350 취합해서 넣기

		INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            @V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            ITEM_ID,
	            'PROD_PLAN' AS MEASURE,
				'-' as value_type,
				TO_PRODUCT,
				'-' as LINE_ID,
				0 as BOH_QTY,
	            TO_SITE,
				'-' as INCOTERMS,  
				'350' as SEQ_FLAG, 
				YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
		FROM #tmp_PSI_INTEGRATION_350_small  
		group by  DIVISION_ID,
					COMPANY_ID,
					PLANT_ID, 
					ITEM_ID,
					TO_PRODUCT,
					TO_SITE,
					YYYYMM


---- 430 만든는 부분 여기에 넣을것.END 

-- 350 만들기 end 

-- 750 만들기 start

		INSERT INTO #tmp_PSI_INTEGRATION_750_small
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

         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID as PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            fc2.ITEM_ID_ASSY AS ITEM_ID,
	            'PROD_PLAN' AS MEASURE,
				'-' AS value_type,
				'-' as TO_PRODUCT,
				a.line_id as LINE_ID,
				0 as BOH_QTY,
	            '-' as TO_SITE,  -- a.plant_id??
				'-' as INCOTERMS,  --- 250에서 '-' 를 넣었으므로 모두 '-' 임.
				'750' as SEQ_FLAG, 
				left(a.YYYYMMDD_LT, 6) as YYYYMM,
	            isnull(sum(isnull(a.QTY,0) * isnull(a.YIELD, 1)),0) as QTY
		from #tmp_PSI_INTEGRATION_450_small a  -- 12,984,  ==> 129,584   ==> 여기에 MAP 추가하기.
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
			ON FC.DIVISION_ID = @V_DIVISION_ID --'40'  -- A.DIVISION_ID   
			AND FC.ITEM_ID_ASSY = A.ITEM_ID
			and fc.CELL_TYPE = 'CA1'
			AND FC.PLANT_ID = A.PLANT_ID
			and fc.VALID_YN = 'Y'
			AND FC.ITEM_ID_ASSY NOT IN (select DISTINCT SEGMENT1
										from SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
										where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
										AND VALID_YN = 'Y')
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC2
			ON FC2.DIVISION_ID = @V_DIVISION_ID --'40'
			AND FC2.ITEM_ID_PROD =FC.ITEM_ID_PROD
			AND FC2.CELL_TYPE= 'CA2'
			AND FC2.PLANT_ID = FC.PLANT_ID
			and fc2.VALID_YN = 'Y'
		-- 아래부분 다시 추가함.
		inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  
			on fi.division_id = fc2.DIVISION_ID
			and fi.operation_group = 'A'
			and fi.item_id = FC2.ITEM_ID_ASSY   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
			AND fi.ATTRIBUTE8 = 'CA2'
			and isnull(fi.TCO_CELL_YN,'N') = 'Y'
		where YYYYMMDD_LT <= @V_HORIZON_END_YYYYMMDD
		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					fc2.ITEM_ID_ASSY,
					a.line_id,
					left(a.YYYYMMDD_LT, 6)


--   2. aging

		INSERT INTO #tmp_PSI_INTEGRATION_750_small
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
		select  A.DIVISION_ID,
				A.COMPANY_ID,
				A.PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
				fc2.ITEM_ID_ASSY as ITEM_ID,
				'PROD_PLAN' AS MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,   --A.item_id as TO_PRODUCT,
				'-' as LINE_ID,
				0 as BOH_QTY,
				'-' as TO_SITE,  --A.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,  
				'750' as SEQ_FLAG, 
				A.RECEIVING_DTTM_YYYYMM AS YYYYMM,
				isnull(sum(isnull(QTY_include_yield,0)),0) as QTY
		from #tmp_psi_integration_inv_small a   
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC WITH(NOLOCK)
			ON FC.DIVISION_ID = @V_DIVISION_ID --'40'  -- A.DIVISION_ID   
			AND FC.ITEM_ID_ASSY = A.ITEM_ID
			and fc.CELL_TYPE = 'CA1'
			AND FC.PLANT_ID = A.PLANT_ID
			and fc.VALID_YN = 'Y'
			AND FC.ITEM_ID_ASSY NOT IN (select DISTINCT SEGMENT1
										from SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
										where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
										AND VALID_YN = 'Y')
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP FC2
			ON FC2.DIVISION_ID = @V_DIVISION_ID --'40'
			AND FC2.ITEM_ID_PROD =FC.ITEM_ID_PROD
			AND FC2.CELL_TYPE= 'CA2'
			AND FC2.PLANT_ID = FC.PLANT_ID
			and fc2.VALID_YN = 'Y'
		-- 아래부분 다시 추가함.
		inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)  
			on fi.division_id = fc2.DIVISION_ID
			and fi.operation_group = 'A'
			and fi.item_id = FC2.ITEM_ID_ASSY   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
			AND fi.ATTRIBUTE8 = 'CA2'
			and isnull(fi.TCO_CELL_YN,'N') = 'Y'
		where a.operation_group='A' 
		and  a.attribute8 = 'CA1'  
		and ISNULL(A.TCO_CELL_YN,'N') <> 'Y'
		AND (a.DESCR like 'FOR%' OR a.DESCR = 'WH')  --DESCR like 'FOR%'
		group by  A.DIVISION_ID,
					A.COMPANY_ID,
					A.PLANT_ID, 
					fc2.ITEM_ID_ASSY,
					A.PLANT_ID,
					A.RECEIVING_DTTM_YYYYMM


-- 750 취합해서 넣기

		INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
			    COMPANY_ID,
			    PLANT_ID, 
	            @V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            ITEM_ID,
	            'PROD_PLAN' AS MEASURE,
				'-' as value_type,
				TO_PRODUCT,
				'-' as LINE_ID,
				0 as BOH_QTY,
	            TO_SITE,
				'-' as INCOTERMS,  
				'750' as SEQ_FLAG, 
				YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
		FROM #tmp_PSI_INTEGRATION_750_small  -- 12,984,  ==> 129,584
		group by  DIVISION_ID,
					COMPANY_ID,
					PLANT_ID, 
					ITEM_ID,
					TO_PRODUCT,
					TO_SITE,
					YYYYMM

---- 430 만든는 부분 여기에 넣을것.END 

-- 350 만들기 end
-- 750 만들기 END


--4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정
			update a set	company_id = isnull(b.company_id,'-'),  
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' AND  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select top 1 from_site from #tmp_psi_integration_inv_small k
											inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site m WITH(NOLOCK)
											on m.DIVISION_ID = k.DIVISION_ID 
											and m.scm_site_id = k.from_site
											and m.SITE_TYPE = 'PLANT'
											where k.division_id = a.division_id
											and (k.item_id = a.item_id or k.item_id = isnull((select max(item_id_assy) 
																							  from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP z 
																							  where z.division_id = a.division_id 
																							  and z.item_id_prod = a.item_id 
																							  and cell_type='CA1' 
																							  and valid_yn='Y'),a.item_id))
											and k.qty <> 0
											group by from_site, item_id
											order by sum(qty) desc)
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310','610')

--5번(기존)
			update a set	company_id = isnull(b.company_id,'-'),  
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'
										  when (b.SITE_TYPE = 'PLANT' AND  b.PLANT_ID = 'KR004004') THEN 'G182'
										  when  b.SITE_TYPE = 'PLANT' THEN b.PLANT_ID
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.TO_SITE 	
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD
										and k.PLAN_TYPE = @V_PLAN_TYPE
										and k.seq = @V_PLAN_SEQ 
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.TO_SITE --a.from_site	
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE 
															and m.seq = @V_PLAN_SEQ 
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310','610')


			update a set COMPANY_ID = ( SELECT min(COMPANY_ID) 
										FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
										WHERE  b.DIVISION_ID = a.DIVISION_ID
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.plant_id = a.plant_id)
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			WHERE a.PLANT_ID = 'G182'
			and isnull(a.COMPANY_ID,'-') <>  (  SELECT min(COMPANY_ID) 
												FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
												WHERE  b.DIVISION_ID = a.DIVISION_ID
												and b.OPERATION_GROUP = a.OPERATION_GROUP
												and b.plant_id =  a.plant_id)



---- plant do 3, 4 작업 수행. end ----

          SET @V_STATUS_DESC = '6.BOH inv';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
					,ISNULL(a.company_id,'-')  
					,ISNULL(a.plant_id,'-')  
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ 
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'-' as CELL_ITEM_ID 
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
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP' and a.tco_cell_yn = 'Y' THEN '660'
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP' then '360'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA' and a.tco_cell_yn = 'Y' then '760'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA'  then '460'  
						   end ) as SEQ_FLAG
					,substring(@V_PLAN_START_YYYYMMDD,1,6) AS YYYYMM
					,0
			FROM #tmp_psi_integration_inv_small A WITH(NOLOCK)
			WHERE a.operation_group IN ('A','P')    
			group by a.division_id
					,a.company_id
					,a.plant_id
					,a.OPERATION_GROUP
					,A.ITEM_ID 
					,(case when a.operation_group='P' and  a.Flow_id in ('P5500','P9500')      then '160'  
						   when a.operation_group='P' and  a.Flow_id not in ('P5500','P9500')  then '260'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP' and a.tco_cell_yn = 'Y' THEN '660'
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP'  then '360'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA' and a.tco_cell_yn = 'Y' then '760'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA'  then '460'  
						   end ) 


          SET @V_STATUS_DESC = '6.BOH inv E';

-------- 220, 240 (pack 반제품)  start 

          SET @V_STATUS_DESC = '220, 240  1';

			insert into #tmp_psi_integration_220_240_small
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							     else  b.PLANT_ID
							     end ),'-') as PLANT_ID,  
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and  x.PLANT_ID = 'KR004004') THEN 'G182'
									  when  x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, 
					'A' as operation_group, 
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)  -- '40' 에는 P 로 모두 제품 반제품만 있는 것 같음.
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on a.division_id = c.division_id
				  and a.bod_id = c.bod_id
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item fi WITH(NOLOCK)   
				on fi.item_id = A.ITEM_ID
				and fi.division_id = a.DIVISION_ID
				and fi.FLOW_ID = 'P5000'
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'P'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


			 -- 220 운송중 재고 포함하기.
			INSERT INTO #tmp_psi_integration_220_240_small
	        SELECT  a.DIVISION_ID,
					a.COMPANY_ID,
					a.COMPANY_ID as to_COMPANY_ID,
					a.PLANT_ID as PLANT_ID,
					a.PLANT_ID as to_plant_id,
					'-' BOD_ID,
					@V_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD,
					1 AS SEQ,  
					a.operation_group as operation_group, 
					a.FROM_SITE,
					a.ITEM_ID,
					a.FROM_SITE as TO_SITE,
					'-' as INCOTERMS,
					a.qty,
					0 as lt_total_ssp,  -- STOCK PLAN 값을 수작업으로 가져와서 LT_TOTAL_SSP는 불필요해서 0으로 셋팅함.
					RECEIVING_DTTM_YYYYMM + '01' as departure_YYYYMMDD,
					RECEIVING_DTTM_YYYYMM + '01' as arrival_YYYYMMDD   
			FROM #tmp_psi_integration_inv_small A WITH(NOLOCK)
			where a.descr LIKE 'INT%'
			and a.operation_group='P' 
			and  a.Flow_id = 'P5000'


          SET @V_STATUS_DESC = '220. 2.SHIP_PLAN_SEMI';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,   -- 최종 넣을때는 꼭 1로 넣어야 함.
				'P' as operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'220'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_220_240_small a WITH(NOLOCK)
			where a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 left(a.arrival_YYYYMMDD,6)


		  -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    4.Semi WH-IN
          -------------------------------------------------------------------------------------------------------------  

          SET @V_STATUS_DESC = '240.  4.Semi WH-IN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
				to_COMPANY_ID,
				to_plant_id,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,   -- 최종 넣을때는 꼭 1로 넣어야 함.
				'P' as operation_group,
				'-' as FROM_SITE,  
                '-' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as incoterms,
				'240'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_220_240_small a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id   
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD 
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 left(a.arrival_YYYYMMDD,6)

---220, 240 (pack 반제품)  end 

          SET @V_STATUS_DESC = 'bbb  1';

			insert into #tmp_psi_integration_320_340_small
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							     else  b.PLANT_ID
							     end ),'-') as PLANT_ID, 
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and  x.PLANT_ID = 'KR004004') THEN 'G182'
									  when  x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, 
					'A' as operation_group, 
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			INNER join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM fi WITH (NOLOCK)
				 on fi.division_id =  a.DIVISION_ID
				 and fi.operation_group = 'A'
				 and fi.item_id = a.item_id   --in ('MIF469958A11-I07', 'MCCH114030D3-M04')
				 AND LEFT(fi.ATTRIBUTE8,2) = 'CP'  -- CP:제품, CA:반제품
				 and isnull(fi.TCO_CELL_YN,'N') <> 'Y'  -- 'Y':후공정, <>'Y':후공정아님.
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



			INSERT INTO #tmp_psi_integration_320_340_small
	        SELECT  a.DIVISION_ID,
					a.COMPANY_ID,
					a.COMPANY_ID as to_COMPANY_ID,
					a.PLANT_ID as PLANT_ID,
					a.PLANT_ID as to_plant_id,
					'-' BOD_ID,
					@V_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD,
					1 AS SEQ,  
					a.operation_group as operation_group, 
					a.FROM_SITE,
					a.ITEM_ID,
					a.FROM_SITE as TO_SITE,
					'-' as INCOTERMS,
					a.qty,
					0 as lt_total_ssp,
					RECEIVING_DTTM_YYYYMM + '01'  as departure_YYYYMMDD,
					RECEIVING_DTTM_YYYYMM + '01'  as arrival_YYYYMMDD   
			FROM #tmp_psi_integration_inv_small A WITH(NOLOCK)
			where a.descr LIKE 'INT%'
			and a.operation_group='A' 
			and substring(a.attribute8,1,2) = 'CP'
			and ISNULL(a.TCO_CELL_YN,'N') <> 'Y'




          SET @V_STATUS_DESC = 'bbb  320';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'320'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_320_340_small a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 left(a.arrival_YYYYMMDD,6)
		  

		  -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    4.Semi WH-IN
          -------------------------------------------------------------------------------------------------------------  

          SET @V_STATUS_DESC = '4.Semi WH-IN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT DIVISION_ID,
				to_COMPANY_ID,
				to_plant_id,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,  
                '-' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as incoterms,
				'340'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_320_340_small a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 left(a.arrival_YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  

          SET @V_STATUS_DESC = '3.IN_HOUSE_MOVING';  

			insert into #tmp_PSI_INTEGRATION_230_ITEM_small
			select distinct a.ITEM_ID
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on  x.DIVISION_ID = a.DIVISION_ID
				and x.plant_id = a.PLANT_ID
			    and x.OPERATION_GROUP = 'P'
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
											else a.plant_id
											end )
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.FLOW_ID = 'P5000'			
			where a.SEQ_FLAG in ('150' ,'250')



		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				a.ITEM_ID as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'330'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) ),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on  x.DIVISION_ID = a.DIVISION_ID
				and x.plant_id = a.PLANT_ID
			    and x.OPERATION_GROUP = 'P'
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
										   else a.plant_id
										   end )
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					and c.attribute8 = 'CP'
					and isnull(c.TCO_CELL_YN,'N') <> 'Y'			
			where a.SEQ_FLAG = '150'  
			and a.ITEM_ID not in ( select xi.item_id from #tmp_PSI_INTEGRATION_230_ITEM_small xi )
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             B.child_item_id,
					 a.ITEM_ID,
					 a.YYYYMM


		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				a.ITEM_ID as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'330'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(yh.yield,1) ),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on  x.DIVISION_ID = a.DIVISION_ID
				and x.plant_id = a.PLANT_ID
			    and x.OPERATION_GROUP = 'P'
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
											else a.plant_id
											end )
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date 
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					and c.attribute8 = 'CP'
					and isnull(c.TCO_CELL_YN,'N') <> 'Y'			
			inner join  [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_YIELD_VER_H_V yh WITH(NOLOCK)
					on yh.division_id = a.DIVISION_ID  --'40'
					and yh.company_id = a.company_id  --'G180'
					and yh.PLANT_id = a.PLANT_id  --'G182'
					and yh.ITEM_ID = a.ITEM_ID  --'AMDMO0001A'
					and yh.line_id = a.line_id  --'PDQ01'
					and yh.month = a.YYYYMM  --'202409'
			where a.SEQ_FLAG = '250'  
			and a.ITEM_ID in ( select xi.item_id from #tmp_PSI_INTEGRATION_230_ITEM_small xi )
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             B.child_item_id, 
					 a.ITEM_ID,
					 a.YYYYMM



		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'P' as operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				a.ITEM_ID as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'230'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) ),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on  x.DIVISION_ID = a.DIVISION_ID
				and x.plant_id = a.PLANT_ID
			    and x.OPERATION_GROUP = 'P'
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = (case when x.osp_yn = 'Y' then x.logistic_plant_id
										   else a.plant_id
										   end )
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP = 'P' 
					and c.flow_id = 'P5000'
			where a.SEQ_FLAG = '150'  
			and a.ITEM_ID in ( select xi.item_id from #tmp_PSI_INTEGRATION_230_ITEM_small xi )
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             B.child_item_id,
					 a.ITEM_ID,
					 a.YYYYMM



          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  
            SET @V_STATUS_DESC = '3.IN_HOUSE_MOVING  EE';

			select y.operation_group,  a.version_id, a.division_id, a.company_id, a.site_id, a.plant_id, a.factory_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month, a.yield
			into #tmp_YIELD_VER_H_V_A_small
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

			create index i_tmp_YIELD_VER_H_V_A_small_01 on #tmp_YIELD_VER_H_V_A_small(item_id)
			
			
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as plant_id,  -- 전극 Plant
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'E' as operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID, 
	            B.child_item_id as ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID, 
                0 as BOH_QTY,
	            a.plant_id as TO_SITE,
				'-' as INCOTERMS,
				'530'  as SEQ_FLAG, 
				a.YYYYMM,
				floor(isnull(sum(a.QTY * isnull(b.usage,1)  / isnull(y.yield,1)),0)) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_BOM_ELEC b WITH(NOLOCK)
					on  b.division_id = @V_DIVISION_ID
					and b.parent_item_id = a.item_id
					and b.scp_yn = 'Y'
			-- pack/cell 수율 반영 start 
			left join #tmp_YIELD_VER_H_V_A_small y 
				on y.division_id = a.DIVISION_ID
				and y.operation_group =a.OPERATION_GROUP
				and y.company_id = a.COMPANY_ID
				and y.line_id = a.LINE_ID
				and y.month = a.yyyymm
				and y.item_id =a.ITEM_ID  
			where a.SEQ_FLAG = '450'  
			group by a.DIVISION_ID,
					 a.COMPANY_ID,
					 substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1),
				     a.PLAN_START_YYYYMMDD,
		             B.child_item_id,
					 a.plant_id,
					 a.YYYYMM


          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
          SET @V_STATUS_DESC = '5.PROD_PLAN  EE';

          -------------------------------------------------------------------------------------------------------------                                         
          -- 9.1  CELL_ITEM_ID UPDATE
          ------------------------------------------------------------------------------------------------------------- 
            SET @V_STATUS_DESC = 'CELL_ITEM_ID Pack';

				select model_id, child_item_id
				into #tmp_FINAL_ITEM_BOM_V_small
				FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
				WHERE Y.CELL_TYPE			 = 'CP'		
				AND Y.OPERATION_GROUP_ID = 'A'
				and Y.DIVISION_ID        = @V_DIVISION_ID  -- 3742

				create index i_tmp_FINAL_ITEM_BOM_V_small_01 on #tmp_FINAL_ITEM_BOM_V_small(model_id)

                -- PACK 일경우 
				-- CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V_small AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = X.ITEM_ID),'-')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION_small X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'  -- 전극 제외
				and isnull(x.CELL_ITEM_ID,'') < '0'

				-- 상위 모델 이용하여 CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V_small AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = ( 	SELECT top 1 model_id
																					FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_ONE_LEVEL_BOM_V AS Y WITH (NOLOCK)
																					WHERE Y.DIVISION_ID        = X.DIVISION_ID
																					AND Y.child_item_id         = X.ITEM_ID
																					and y.plant_id = x.plant_id)),'-')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION_small X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'   
				and isnull(x.CELL_ITEM_ID,'') < '0'

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
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_small X 
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

            SET @V_STATUS_DESC = 'CELL_ITEM_ID MEB';

			----------------------------------------------------
			-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - start
			----------------------------------------------------
			UPDATE X
               SET X.CELL_ITEM_ID = isnull(Z.CELL_ITEM_ID,'-')
              FROM #tmp_SCP_ANL_PSI_INTEGRATION_small X 
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
			  and isnull(x.CELL_ITEM_ID,'') < '0'


          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
            SET @V_STATUS_DESC = '5.PROD_PLAN 222';

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small
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
					1 AS SEQ,
					'P' as operation_group,
					'-' as FROM_SITE,    
					i.cell_item_id as cell_item_id,
					a.child_item_id as item_id, 
					'IN_HOUSE_MOVING' as measure,
					'-' as value_type,
					i.item_id as TO_PRODUCT,
					'-' as LINE_ID,
					0 as BOH_QTY,
					i.PLANT_ID as TO_SITE,
					'-' as INCOTERMS,  
					'230' as SEQ_FLAG,   
					i.YYYYMM,
					isnull(sum(isnull(i.qty,0) * isnull(a.ACCUMULATED_CHILD_QTY,1) ),0) as QTY 
			from #tmp_SCP_ANL_PSI_INTEGRATION_small i with(nolock)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
				on a.model_id = i.ITEM_ID
				and a.parent_item_id = i.ITEM_ID
				and a.division_id = i.division_id
				and a.COMPANY_ID = i.company_id 
				and a.PLANT_ID = i.plant_id 
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
			group by i.division_id, 
					i.company_id,
					i.PLANT_ID,
					i.PLAN_START_YYYYMMDD, 
					i.cell_item_id,
					a.child_item_id,
					i.item_id,
					i.YYYYMM



			insert into #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy
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
					)
			SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, sum(BOH_QTY), TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, sum(QTY)
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small WITH(NOLOCK)
			GROUP BY DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM


-- 셀후공정제품 BOH(660)로 PROD_PLAN(650) 차감하기 START
--------------------------------------------
-- 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감. 
--------------------------------------------

BEGIN

			DECLARE @CUR1st_SEQ_FLAG			 NVARCHAR(5)
			DECLARE @CUR1st_DIVISION_ID          NVARCHAR(10)
			DECLARE @CUR1st_OPERATION_GROOUP     NVARCHAR(1)
			DECLARE @CUR1st_COMPANY_ID		     NVARCHAR(10)
			DECLARE @CUR1st_PLANT_ID			 NVARCHAR(10)
			DECLARE @CUR1st_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @CUR1st_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @CUR1st_ITEM_ID              NVARCHAR(40)
			DECLARE @CUR1st_BOH_QTY			     NUMERIC(20, 10)
			DECLARE @CUR1st_REMAIN_QTY		     NUMERIC(20, 10)

			DECLARE @CUR2nd_DIVISION_ID          NVARCHAR(10)
			DECLARE @CUR2nd_OPERATION_GROOUP     NVARCHAR(1)
			DECLARE @CUR2nd_COMPANY_ID		     NVARCHAR(10)
			DECLARE @CUR2nd_PLANT_ID			 NVARCHAR(10)
			DECLARE @CUR2nd_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @CUR2nd_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @CUR2nd_ITEM_ID              NVARCHAR(40)
			DECLARE @CUR2nd_YYYYMM			     NVARCHAR(6)
			DECLARE @CUR2nd_QTY			         NUMERIC(20, 10)
			DECLARE @CUR2nd_MEASURE              NVARCHAR(40)
			DECLARE @CUR2nd_SEQ_FLAG			 NVARCHAR(5)

			DECLARE @CUR2nd_VALUE_TYPE			 NVARCHAR(10)
			DECLARE @CUR2nd_TO_PRODUCT			 NVARCHAR(100)
			DECLARE @CUR2nd_LINE_ID				 NVARCHAR(10)
	        DECLARE @CUR2nd_TO_SITE              NVARCHAR(30)
			DECLARE @CUR2nd_INCOTERMS			 NVARCHAR(5)

			DECLARE @CUR2nd_MIN_MONTH			 NVARCHAR(6)

			-- BOH Cursor
			DECLARE CUR_660_BOH_ALLOC CURSOR FOR

					SELECT a.seq_flag,	a.DIVISION_ID, a.OPERATION_GROUP, a.COMPANY_ID, a.PLANT_ID, a.PLAN_START_YYYYMMDD, a.CELL_ITEM_ID, a.ITEM_ID, a.BOH_QTY, a.BOH_QTY
					FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
					WHERE a.BOH_QTY > 0
					and a.measure = 'INV'
					and a.seq_flag = '660'
					AND a.YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)  
					ORDER BY a.seq_flag, a.ITEM_ID

			OPEN CUR_660_BOH_ALLOC;
			FETCH NEXT FROM CUR_660_BOH_ALLOC INTO @CUR1st_SEQ_FLAG, @CUR1st_DIVISION_ID, @CUR1st_OPERATION_GROOUP, @CUR1st_COMPANY_ID, @CUR1st_PLANT_ID, @CUR1st_PLAN_START_YYYYMMDD, @CUR1st_CELL_ITEM_ID, @CUR1st_ITEM_ID, @CUR1st_BOH_QTY, @CUR1st_REMAIN_QTY   
		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN				


--- 최소월 찾기 START ---

							SELECT @CUR2nd_MIN_MONTH = MIN(YYYYMM)  
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy WITH(NOLOCK)  
							WHERE DIVISION_ID = @CUR1st_DIVISION_ID
							and OPERATION_GROUP = @CUR1st_OPERATION_GROOUP
							and COMPANY_ID = @CUR1st_COMPANY_ID
							AND PLANT_ID = @CUR1st_PLANT_ID
							AND PLAN_START_YYYYMMDD = @CUR1st_PLAN_START_YYYYMMDD
							AND CELL_ITEM_ID = @CUR1st_CELL_ITEM_ID
							AND ITEM_ID = @CUR1st_ITEM_ID
							AND MEASURE = 'PROD_PLAN'
							AND SEQ_FLAG = '650'
							AND QTY > 0							

--- 최소월 찾기 END ---

--- boh 체크 기능 추가 start 1/2

					declare @CUR1st_prod_plan_total_qty NUMERIC(20, 10)
					declare @CUR1st_ship_plan_total_qty NUMERIC(20, 10)

					select @CUR1st_prod_plan_total_qty = isnull(sum(isnull(qty,0)),0)
					FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
					WHERE a.OPERATION_GROUP = @CUR1st_OPERATION_GROOUP 
					and a.COMPANY_ID = @CUR1st_COMPANY_ID  
					and a.PLANT_ID = @CUR1st_PLANT_ID 
					and a.PLAN_START_YYYYMMDD = @CUR1st_PLAN_START_YYYYMMDD 
					and a.CELL_ITEM_ID = @CUR1st_CELL_ITEM_ID  
					and a.ITEM_ID = @CUR1st_ITEM_ID  
					and a.measure='PROD_PLAN'
					and a.seq_flag = '650'


					select @CUR1st_ship_plan_total_qty = isnull(sum(isnull(qty,0)),0)
					FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
					WHERE a.OPERATION_GROUP =  @CUR1st_OPERATION_GROOUP 
					and a.COMPANY_ID = @CUR1st_COMPANY_ID 
					and a.PLANT_ID = @CUR1st_PLANT_ID 
					and a.PLAN_START_YYYYMMDD = @CUR1st_PLAN_START_YYYYMMDD 
					and a.CELL_ITEM_ID = @CUR1st_CELL_ITEM_ID  
					and a.ITEM_ID = @CUR1st_ITEM_ID  
					and a.measure in ('SHIP_PLAN_RTF','SHIP_PLAN_SEMI')
					and a.seq_flag in ('610','620')


					if ((@CUR1st_REMAIN_QTY + @CUR1st_prod_plan_total_qty) - @CUR1st_ship_plan_total_qty > 0)
					begin

						if (@CUR1st_REMAIN_QTY > ((@CUR1st_REMAIN_QTY + @CUR1st_prod_plan_total_qty) - @CUR1st_ship_plan_total_qty))
						begin
							set @CUR1st_REMAIN_QTY = ((@CUR1st_REMAIN_QTY + @CUR1st_prod_plan_total_qty) - @CUR1st_ship_plan_total_qty) 
						end

--- boh 체크 기능 추가 end 1/2
			
						-- PROD_PLAN Cursor
						DECLARE CUR_660_BOH_ALLOC_ITEM CURSOR FOR

							SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG, 
								   VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy WITH(NOLOCK)  
							WHERE DIVISION_ID = @CUR1st_DIVISION_ID
							and OPERATION_GROUP = @CUR1st_OPERATION_GROOUP
							and COMPANY_ID = @CUR1st_COMPANY_ID
							AND PLANT_ID = @CUR1st_PLANT_ID
							AND PLAN_START_YYYYMMDD = @CUR1st_PLAN_START_YYYYMMDD
							AND CELL_ITEM_ID = @CUR1st_CELL_ITEM_ID
							AND ITEM_ID = @CUR1st_ITEM_ID
							AND MEASURE = 'PROD_PLAN'
							AND SEQ_FLAG = '650'
							AND QTY > 0
							ORDER BY YYYYMM
		  
						OPEN CUR_660_BOH_ALLOC_ITEM;
						FETCH NEXT FROM CUR_660_BOH_ALLOC_ITEM INTO @CUR2nd_DIVISION_ID, @CUR2nd_OPERATION_GROOUP, @CUR2nd_COMPANY_ID, @CUR2nd_PLANT_ID, @CUR2nd_PLAN_START_YYYYMMDD, @CUR2nd_CELL_ITEM_ID, @CUR2nd_ITEM_ID, @CUR2nd_YYYYMM, @CUR2nd_QTY, @CUR2nd_MEASURE, @CUR2nd_SEQ_FLAG,  
																	@CUR2nd_VALUE_TYPE, @CUR2nd_TO_PRODUCT,	@CUR2nd_LINE_ID, @CUR2nd_TO_SITE, @CUR2nd_INCOTERMS ;
		 
						WHILE (@@FETCH_STATUS = 0)
						BEGIN

								IF @CUR1st_REMAIN_QTY > @CUR2nd_QTY 
								BEGIN
										UPDATE A SET QTY = 0
										FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy A WITH(NOLOCK)  
										WHERE DIVISION_ID = @CUR2nd_DIVISION_ID
										and OPERATION_GROUP = @CUR2nd_OPERATION_GROOUP
										and COMPANY_ID = @CUR2nd_COMPANY_ID
										AND PLANT_ID = @CUR2nd_PLANT_ID
										AND PLAN_START_YYYYMMDD = @CUR2nd_PLAN_START_YYYYMMDD
										AND CELL_ITEM_ID = @CUR2nd_CELL_ITEM_ID
										AND ITEM_ID = @CUR2nd_ITEM_ID
										AND YYYYMM = @CUR2nd_YYYYMM
										AND MEASURE = @CUR2nd_MEASURE
										AND SEQ_FLAG = @CUR2nd_SEQ_FLAG
										and VALUE_TYPE = @CUR2nd_VALUE_TYPE 
										and TO_PRODUCT = @CUR2nd_TO_PRODUCT	
										and LINE_ID = @CUR2nd_LINE_ID 
										and TO_SITE = @CUR2nd_TO_SITE 
										and INCOTERMS = @CUR2nd_INCOTERMS

										set @CUR1st_REMAIN_QTY = @CUR1st_REMAIN_QTY - @CUR2nd_QTY

								END
								else if @CUR1st_REMAIN_QTY <= @CUR2nd_QTY
								BEGIN

										UPDATE A SET QTY = QTY - @CUR1st_REMAIN_QTY
										FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy A WITH(NOLOCK)  
										WHERE DIVISION_ID = @CUR2nd_DIVISION_ID
										and OPERATION_GROUP = @CUR2nd_OPERATION_GROOUP
										and COMPANY_ID = @CUR2nd_COMPANY_ID
										AND PLANT_ID = @CUR2nd_PLANT_ID
										AND PLAN_START_YYYYMMDD = @CUR2nd_PLAN_START_YYYYMMDD
										AND CELL_ITEM_ID = @CUR2nd_CELL_ITEM_ID
										AND ITEM_ID = @CUR2nd_ITEM_ID
										AND YYYYMM = @CUR2nd_YYYYMM
										AND MEASURE = @CUR2nd_MEASURE
										AND SEQ_FLAG = @CUR2nd_SEQ_FLAG
										and VALUE_TYPE = @CUR2nd_VALUE_TYPE 
										and TO_PRODUCT = @CUR2nd_TO_PRODUCT	
										and LINE_ID = @CUR2nd_LINE_ID 
										and TO_SITE = @CUR2nd_TO_SITE 
										and INCOTERMS = @CUR2nd_INCOTERMS


										set @CUR1st_REMAIN_QTY = 0
													  
										break  -- set @CUR1st_REMAIN_QTY = 0 이 됨.	

								END	

	 					FETCH NEXT FROM CUR_660_BOH_ALLOC_ITEM INTO @CUR2nd_DIVISION_ID, @CUR2nd_OPERATION_GROOUP, @CUR2nd_COMPANY_ID, @CUR2nd_PLANT_ID, @CUR2nd_PLAN_START_YYYYMMDD, @CUR2nd_CELL_ITEM_ID, @CUR2nd_ITEM_ID, @CUR2nd_YYYYMM, @CUR2nd_QTY, @CUR2nd_MEASURE, @CUR2nd_SEQ_FLAG,  
																	@CUR2nd_VALUE_TYPE, @CUR2nd_TO_PRODUCT,	@CUR2nd_LINE_ID, @CUR2nd_TO_SITE, @CUR2nd_INCOTERMS ;
						END 
		
						CLOSE CUR_660_BOH_ALLOC_ITEM;
						DEALLOCATE CUR_660_BOH_ALLOC_ITEM;
						----------------------------------------
						-- PROD_PLAN Cursor : END
						----------------------------------------
		end  ----- boh 체크 기능 추가 start end 2/2

-- 후공정 반제품(730) in_house_moving 차감 start

--=========== in-house-moving 대상 찾기 start

	IF ( @CUR1st_BOH_QTY <> @CUR1st_REMAIN_QTY )
	BEGIN
						declare @CUR730_Boh_QTY			NUMERIC(20, 10)
						declare @CUR730_Boh_REMAIN_QTY	NUMERIC(20, 10)

						set @CUR730_Boh_QTY = @CUR1st_BOH_QTY  -- * @260boh_CHILD_QTY / @260boh_YIELD
						set @CUR730_Boh_REMAIN_QTY = @CUR730_Boh_QTY

--=========== in-house-moving 대상 찾기 end
-- 730 cursor start

			DECLARE @CUR730_DIVISION_ID          NVARCHAR(10)
			DECLARE @CUR730_OPERATION_GROOUP     NVARCHAR(1)
			DECLARE @CUR730_COMPANY_ID		     NVARCHAR(10)
			DECLARE @CUR730_PLANT_ID			 NVARCHAR(10)
			DECLARE @CUR730_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @CUR730_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @CUR730_ITEM_ID              NVARCHAR(40)
			DECLARE @CUR730_YYYYMM			     NVARCHAR(6)
			DECLARE @CUR730_QTY			         NUMERIC(20, 10)
			DECLARE @CUR730_MEASURE              NVARCHAR(40)
			DECLARE @CUR730_SEQ_FLAG			 NVARCHAR(5)

			DECLARE @CUR730_VALUE_TYPE			 NVARCHAR(10)
			DECLARE @CUR730_TO_PRODUCT			 NVARCHAR(100)
			DECLARE @CUR730_LINE_ID				 NVARCHAR(10)
	        DECLARE @CUR730_TO_SITE              NVARCHAR(30)
			DECLARE @CUR730_INCOTERMS			 NVARCHAR(5)

						-- PROD_PLAN Cursor
						DECLARE CUR_650_730_BOH_ALLOC_ITEM CURSOR FOR

							SELECT a.DIVISION_ID, a.OPERATION_GROUP, a.COMPANY_ID, a.PLANT_ID, a.PLAN_START_YYYYMMDD, a.CELL_ITEM_ID, a.ITEM_ID, a.YYYYMM, a.QTY, a.MEASURE, a.SEQ_FLAG, 
								   a.VALUE_TYPE, a.TO_PRODUCT, a.LINE_ID, a.TO_SITE, a.INCOTERMS
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
							INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_CELL_PROD_ASSY_MAP mp WITH(NOLOCK)
								ON  mp.DIVISION_ID = @CUR1st_DIVISION_ID  
								and mp.plant_id = @CUR1st_PLANT_ID
								AND mp.ITEM_ID_PROD = @CUR1st_ITEM_ID
								and mp.cell_type = 'CA2'
								and mp.valid_yn = 'Y'
							WHERE a.DIVISION_ID = @CUR1st_DIVISION_ID
							and a.OPERATION_GROUP = 'A'  
							and a.COMPANY_ID = @CUR1st_COMPANY_ID
							AND a.PLANT_ID = @CUR1st_PLANT_ID
							AND a.PLAN_START_YYYYMMDD = @CUR1st_PLAN_START_YYYYMMDD
							AND a.CELL_ITEM_ID = @CUR1st_CELL_ITEM_ID
							AND a.ITEM_ID = mp.ITEM_ID_assy 
							and a.to_site = @CUR1st_PLANT_ID
							AND a.MEASURE = 'IN_HOUSE_MOVING'
							AND a.SEQ_FLAG = '730'
							AND a.QTY > 0
							AND a.YYYYMM >= @CUR2nd_MIN_MONTH -- 최소 반영월 이상만 반영함.
							ORDER BY a.YYYYMM
		  
						OPEN CUR_650_730_BOH_ALLOC_ITEM;
						FETCH NEXT FROM CUR_650_730_BOH_ALLOC_ITEM INTO @CUR730_DIVISION_ID, @CUR730_OPERATION_GROOUP, @CUR730_COMPANY_ID, @CUR730_PLANT_ID, @CUR730_PLAN_START_YYYYMMDD, @CUR730_CELL_ITEM_ID, @CUR730_ITEM_ID, @CUR730_YYYYMM, @CUR730_QTY, @CUR730_MEASURE, @CUR730_SEQ_FLAG,  
																	@CUR730_VALUE_TYPE, @CUR730_TO_PRODUCT,	@CUR730_LINE_ID, @CUR730_TO_SITE, @CUR730_INCOTERMS ;
	 
						WHILE (@@FETCH_STATUS = 0)
						BEGIN
								IF @CUR730_Boh_REMAIN_QTY > @CUR730_QTY 
								BEGIN
										UPDATE A SET QTY = 0
										FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy A WITH(NOLOCK)  
										WHERE DIVISION_ID = @CUR730_DIVISION_ID
										and OPERATION_GROUP = @CUR730_OPERATION_GROOUP
										and COMPANY_ID = @CUR730_COMPANY_ID
										AND PLANT_ID = @CUR730_PLANT_ID
										AND PLAN_START_YYYYMMDD = @CUR730_PLAN_START_YYYYMMDD
										AND CELL_ITEM_ID = @CUR730_CELL_ITEM_ID
										AND ITEM_ID = @CUR730_ITEM_ID
										AND YYYYMM = @CUR730_YYYYMM
										AND MEASURE = @CUR730_MEASURE
										AND SEQ_FLAG = @CUR730_SEQ_FLAG
										and VALUE_TYPE = @CUR730_VALUE_TYPE 
										and TO_PRODUCT = @CUR730_TO_PRODUCT	
										and LINE_ID = @CUR730_LINE_ID 
										and TO_SITE = @CUR730_TO_SITE 
										and INCOTERMS = @CUR730_INCOTERMS

										set @CUR730_Boh_REMAIN_QTY = @CUR730_Boh_REMAIN_QTY - @CUR730_QTY

								END
								else if @CUR730_Boh_REMAIN_QTY <= @CUR730_QTY
								BEGIN

										UPDATE A SET QTY = QTY - @CUR730_Boh_REMAIN_QTY
										FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy A WITH(NOLOCK)  
										WHERE DIVISION_ID = @CUR730_DIVISION_ID
										and OPERATION_GROUP = @CUR730_OPERATION_GROOUP
										and COMPANY_ID = @CUR730_COMPANY_ID
										AND PLANT_ID = @CUR730_PLANT_ID
										AND PLAN_START_YYYYMMDD = @CUR730_PLAN_START_YYYYMMDD
										AND CELL_ITEM_ID = @CUR730_CELL_ITEM_ID
										AND ITEM_ID = @CUR730_ITEM_ID
										AND YYYYMM = @CUR730_YYYYMM
										AND MEASURE = @CUR730_MEASURE
										AND SEQ_FLAG = @CUR730_SEQ_FLAG
										and VALUE_TYPE = @CUR730_VALUE_TYPE 
										and TO_PRODUCT = @CUR730_TO_PRODUCT	
										and LINE_ID = @CUR730_LINE_ID 
										and TO_SITE = @CUR730_TO_SITE 
										and INCOTERMS = @CUR730_INCOTERMS

										set @CUR730_Boh_REMAIN_QTY = 0
													  
										break  -- set @CUR730_Boh_REMAIN_QTY = 0 이 됨.	

								END	

	 					FETCH NEXT FROM CUR_650_730_BOH_ALLOC_ITEM INTO @CUR730_DIVISION_ID, @CUR730_OPERATION_GROOUP, @CUR730_COMPANY_ID, @CUR730_PLANT_ID, @CUR730_PLAN_START_YYYYMMDD, @CUR730_CELL_ITEM_ID, @CUR730_ITEM_ID, @CUR730_YYYYMM, @CUR730_QTY, @CUR730_MEASURE, @CUR730_SEQ_FLAG,  
																	@CUR730_VALUE_TYPE, @CUR730_TO_PRODUCT,	@CUR730_LINE_ID, @CUR730_TO_SITE, @CUR730_INCOTERMS ;
						END 
		
						CLOSE CUR_650_730_BOH_ALLOC_ITEM;
						DEALLOCATE CUR_650_730_BOH_ALLOC_ITEM;

	END
-- 730 cursor end

-- 후공정 반제품(730) in_house_moving 차감 end

	 		FETCH NEXT FROM CUR_660_BOH_ALLOC INTO @CUR1st_SEQ_FLAG, @CUR1st_DIVISION_ID, @CUR1st_OPERATION_GROOUP, @CUR1st_COMPANY_ID, @CUR1st_PLANT_ID, @CUR1st_PLAN_START_YYYYMMDD, @CUR1st_CELL_ITEM_ID, @CUR1st_ITEM_ID, @CUR1st_BOH_QTY, @CUR1st_REMAIN_QTY ;  
			END -- OPEN CUR_660_BOH_ALLOC;
		
			CLOSE CUR_660_BOH_ALLOC;
			DEALLOCATE CUR_660_BOH_ALLOC;

END   -- BOH로 PROD 차감 END
-- === 660 boh 차감 end


--============ (예외1. 1/2) CA2 없는 후공정 아이템 TCO_ITEM_PROD start ===========

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330
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
		SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'A' as operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				LMD.SEGMENT2 AS ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				a.item_id as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'330'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0)),0) as QTY  -- pack, cell 수율반영	
			--select *
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LMD with(nolock)
					ON LMD.LOOKUP_TYPE = 'TCO_NO_CA2_ITEM_PROD'
					AND LMD.VALID_YN = 'Y'
					AND LMD.SEGMENT1 = A.ITEM_ID
			where a.SEQ_FLAG = '650'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             LMD.SEGMENT2,
					 a.item_id,
					 a.YYYYMM

---- 예외2 CASE2 START ============================
------------예외2, CASE2 중 1. '450 -> 350 START

			create table #tmp_ultra_small_lookup_cell
			(cell_ca	nvarchar(200),
			 cell_cp	nvarchar(200))

			insert into #tmp_ultra_small_lookup_cell
			select distinct segment1, segment2
			from SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
			where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
			and LM.valid_yn = 'Y'

			--		INSERT INTO #tmp_PSI_INTEGRATION_350_750_430_ultra_small
					INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330  --> CELL_ITEM_ID를 setting 하기 위해. 
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
				SELECT a.DIVISION_ID,
							b.COMPANY_ID,
			ISNULL((case when  b.PLANT_ID = 'KR004004' THEN 'G182'
							else  b.PLANT_ID
							end ),'-') as PLANT_ID,  
							a.PLAN_START_YYYYMMDD,
							1 AS SEQ,
							'A' as operation_group,
							'-'  as FROM_SITE,
							'-' as CELL_ITEM_ID, 				
							a.ITEM_ID,
							'PROD_PLAN' as MEASURE,
							'-' as value_type,
							'-' as TO_PRODUCT,
							'-'  as LINE_ID,   
							0 as BOH_QTY,
							'-' as TO_SITE, 
							'-' as INCOTERMS,
							'350'  as SEQ_FLAG,  
							left(a.YYYYMMDD,6) as YYYYMM,
							isnull(sum(isnull(a.QTY,0)),0) as QTY
						FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_fg a WITH(NOLOCK)
						inner join #tmp_ultra_small_lookup_cell cp WITH(NOLOCK)
								on cp.cell_cp = a.item_id
						left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
								on  b.DIVISION_ID = a.DIVISION_ID
								and b.SCM_SITE_ID = a.FROM_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  --'20240923'
			AND a.PLAN_TYPE			= @V_PLAN_TYPE  --'FN'
			AND a.SEQ					= @V_PLAN_SEQ  --1
			AND a.DIVISION_ID			= @V_DIVISION_ID  --'40'
			AND a.measure = 'SHIP_PLAN_AMEND' 
			and a.biz_type = 'A'   
			AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD  --'20250921
						group by a.DIVISION_ID,
									b.COMPANY_ID,
									(case when  b.PLANT_ID = 'KR004004' THEN 'G182'
										else  b.PLANT_ID
										end ),
									a.PLAN_START_YYYYMMDD,
									a.ITEM_ID,
									left(a.YYYYMMDD,6)

------------예외2, CASE2 중 1. '450 -> 350 END

------------예외2, CASE2 중 2. '650 -> 750 START

			create table #tmp_ultra_small_lookup_tco_cell
			(cell_ca	    nvarchar(200),
			 tco_cell_ca	nvarchar(200),
			 tco_cell_cp	nvarchar(200))

			insert into #tmp_ultra_small_lookup_tco_cell
			select distinct segment1, segment3, segment4
			from SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
			where LM.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
			and LM.valid_yn = 'Y'

			--		INSERT INTO #tmp_PSI_INTEGRATION_350_750_430_ultra_small
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330  --> CELL_ITEM_ID를 setting 하기 위해. 
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

         SELECT a.DIVISION_ID,
				a.COMPANY_ID,
				a.PLANT_ID as PLANT_ID,
				@V_PLAN_START_YYYYMMDD,
				1 AS SEQ,
				'A' AS OPERATION_GROUP,
				'-' AS FROM_SITE,
				'-' AS CELL_ITEM_ID,
	            tc.tco_cell_ca AS ITEM_ID,
	            'PROD_PLAN' AS MEASURE,
				'-' AS value_type,
				'-' as TO_PRODUCT,
				a.line_id as LINE_ID,
				0 as BOH_QTY,
	            '-' as TO_SITE,  
				'-' as INCOTERMS, 
				'750' as SEQ_FLAG, 
				a.YYYYMM as YYYYMM,
	            isnull(sum(isnull(a.QTY,0)) ,0) as QTY
		from #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a with(nolock) -- 12,984,  ==> 129,584   ==> 여기에 MAP 추가하기.
		inner join #tmp_ultra_small_lookup_tco_cell tc
				on tc.tco_cell_cp = a.item_id
		where a.SEQ_FLAG = '650'  
		and a.DIVISION_ID = @V_DIVISION_ID --'40'
and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --'20240923'
		group by  a.DIVISION_ID,
					a.COMPANY_ID,
					a.PLANT_ID, 
					tc.tco_cell_ca,
					a.line_id,
					a.YYYYMM

------------예외2, CASE2 중 1. '650 -> 750 START

---- 예외2 CASE2 END ============================


                 -- CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - 변경후 쿼리 
				;WITH CP_INFO2 AS (
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
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 X 
					   INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM_V F WITH(NOLOCK)  
							   ON 1=1
							  AND F.ITEM_ID			= X.ITEM_ID
					   LEFT  JOIN CP_INFO2 C1 WITH(NOLOCK)
							   ON C1.DIVISION_ID	= X.DIVISION_ID
							  AND C1.PLANT_ID		= x.PLANT_ID   
							  AND C1.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C1.PRIORITY_1ST	= 1
					   LEFT  JOIN CP_INFO2 C2 WITH(NOLOCK)
							   ON C2.DIVISION_ID	= X.DIVISION_ID
							  AND C2.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C2.PRIORITY_2ND	= 1
					   LEFT  JOIN CP_INFO2 C3 WITH(NOLOCK)
							   ON C3.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C3.PRIORITY_3RD	= 1
				 WHERE 0 = 0
				   AND X.OPERATION_GROUP   = 'A'
				   --and left(x.SEQ_FLAG,1) <> '5'  
				   --and isnull(x.CELL_ITEM_ID,'') < '0'

------------예외2, CASE2 중 1. '350 + 750  --> 430  START

-- 여기에 350 boh 차감. start

--------------------------------------------
-- 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감. 
--------------------------------------------

		BEGIN

					DECLARE @350_CUR_SEQ_FLAG				NVARCHAR(5)
					DECLARE @350_CUR_DIVISION_ID			NVARCHAR(10)
					DECLARE @350_CUR_OPERATION_GROOUP		NVARCHAR(1)
					DECLARE @350_CUR_COMPANY_ID				NVARCHAR(10)
					DECLARE @350_CUR_PLANT_ID			    NVARCHAR(10)
					DECLARE @350_CUR_PLAN_START_YYYYMMDD	NVARCHAR(8)
					DECLARE @350_CUR_CELL_ITEM_ID			NVARCHAR(40)
					DECLARE @350_CUR_ITEM_ID				NVARCHAR(40)
					DECLARE @350_CUR_QTY			        NUMERIC(20, 10)
					DECLARE @350_CUR_REMAIN_QTY		        NUMERIC(20, 10)

					DECLARE @350_CUR2_DIVISION_ID			NVARCHAR(10)
					DECLARE @350_CUR2_OPERATION_GROOUP		NVARCHAR(1)
					DECLARE @350_CUR2_COMPANY_ID		    NVARCHAR(10)
					DECLARE @350_CUR2_PLANT_ID				NVARCHAR(10)
					DECLARE @350_CUR2_PLAN_START_YYYYMMDD	NVARCHAR(8)
					DECLARE @350_CUR2_CELL_ITEM_ID			NVARCHAR(40)
					DECLARE @350_CUR2_ITEM_ID				NVARCHAR(40)
					DECLARE @350_CUR2_YYYYMM				NVARCHAR(6)
					DECLARE @350_CUR2_QTY			        NUMERIC(20, 10)
					DECLARE @350_CUR2_MEASURE				NVARCHAR(40)
					DECLARE @350_CUR2_SEQ_FLAG				NVARCHAR(5)

					DECLARE @350_CUR2_VALUE_TYPE		NVARCHAR(10)
					DECLARE @350_CUR2_TO_PRODUCT		NVARCHAR(100)
					DECLARE @350_CUR2_LINE_ID			NVARCHAR(10)
					DECLARE @350_CUR2_TO_SITE           NVARCHAR(30)
					DECLARE @350_CUR2_INCOTERMS			NVARCHAR(5)


					-- BOH Cursor
					DECLARE CUR_350_BOH_ALLOC CURSOR FOR

							SELECT a.seq_flag,	a.DIVISION_ID, a.OPERATION_GROUP, a.COMPANY_ID, a.PLANT_ID, a.PLAN_START_YYYYMMDD, a.CELL_ITEM_ID, a.ITEM_ID, a.BOH_QTY
							FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
							WHERE a.BOH_QTY > 0
							and a.measure = 'INV'
							and a.seq_flag = '360'
							AND a.YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)  
							and exists (select 'Y'
										from #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 b with(nolock)
										where b.DIVISION_ID = a.DIVISION_ID
										and b.OPERATION_GROUP = a.OPERATION_GROUP 
										and b.COMPANY_ID = a.COMPANY_ID 
										and b.PLANT_ID = a.PLANT_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.CELL_ITEM_ID = a.CELL_ITEM_ID
										and b.ITEM_ID = a.ITEM_ID
										and b.seq_flag = '350'
										and b.qty > 0 )
							ORDER BY a.ITEM_ID

					OPEN CUR_350_BOH_ALLOC;
					FETCH NEXT FROM CUR_350_BOH_ALLOC INTO @350_CUR_SEQ_FLAG, @350_CUR_DIVISION_ID, @350_CUR_OPERATION_GROOUP, @350_CUR_COMPANY_ID, @350_CUR_PLANT_ID, @350_CUR_PLAN_START_YYYYMMDD, @350_CUR_CELL_ITEM_ID, @350_CUR_ITEM_ID, @350_CUR_REMAIN_QTY   
		 
					WHILE (@@FETCH_STATUS = 0)
					BEGIN	  


   --- 대상 찾기 start 			

						declare @350_CUR_prod_plan_total_qty NUMERIC(20, 10)
						declare @350_CUR_ship_plan_total_qty NUMERIC(20, 10)

						select @350_CUR_prod_plan_total_qty = isnull(sum(isnull(qty,0)),0)
						FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 a WITH(NOLOCK)  
						WHERE a.OPERATION_GROUP = @350_CUR_OPERATION_GROOUP 
						and a.COMPANY_ID = @350_CUR_COMPANY_ID  
						and a.PLANT_ID = @350_CUR_PLANT_ID 
						and a.PLAN_START_YYYYMMDD = @350_CUR_PLAN_START_YYYYMMDD 
						and a.CELL_ITEM_ID = @350_CUR_CELL_ITEM_ID  
						and a.ITEM_ID = @350_CUR_ITEM_ID  
						and a.measure='PROD_PLAN'
						and a.seq_flag = '350'


						select @350_CUR_ship_plan_total_qty = isnull(sum(isnull(qty,0)),0)
						FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
						WHERE a.OPERATION_GROUP =  @350_CUR_OPERATION_GROOUP 
						and a.COMPANY_ID = @350_CUR_COMPANY_ID 
						and a.PLANT_ID = @350_CUR_PLANT_ID 
						and a.PLAN_START_YYYYMMDD = @350_CUR_PLAN_START_YYYYMMDD 
						and a.CELL_ITEM_ID = @350_CUR_CELL_ITEM_ID  
						and a.ITEM_ID = @350_CUR_ITEM_ID  
						and a.measure in ('SHIP_PLAN_RTF','SHIP_PLAN_SEMI')
						and a.seq_flag in ('310','320')


						if ((@350_CUR_REMAIN_QTY + @350_CUR_prod_plan_total_qty) - @350_CUR_ship_plan_total_qty > 0)
						begin

							if (@350_CUR_REMAIN_QTY > ((@350_CUR_REMAIN_QTY + @350_CUR_prod_plan_total_qty) - @350_CUR_ship_plan_total_qty))
							begin
								set @350_CUR_REMAIN_QTY = ((@350_CUR_REMAIN_QTY + @350_CUR_prod_plan_total_qty) - @350_CUR_ship_plan_total_qty) 
							end
	--- 대상 찾기 end
									DECLARE CUR_350_BOH_ALLOC_ITEM CURSOR FOR


									SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG, 
										   VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
									FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 WITH(NOLOCK)  
									WHERE DIVISION_ID = @350_CUR_DIVISION_ID
									and OPERATION_GROUP = @350_CUR_OPERATION_GROOUP
									and COMPANY_ID = @350_CUR_COMPANY_ID
									AND PLANT_ID = @350_CUR_PLANT_ID
									AND PLAN_START_YYYYMMDD = @350_CUR_PLAN_START_YYYYMMDD
									AND CELL_ITEM_ID = @350_CUR_CELL_ITEM_ID
									AND ITEM_ID = @350_CUR_ITEM_ID
									AND MEASURE = 'PROD_PLAN'
									AND SEQ_FLAG = '350'
									AND QTY > 0
									ORDER BY YYYYMM
		  
									OPEN CUR_350_BOH_ALLOC_ITEM;
									FETCH NEXT FROM CUR_350_BOH_ALLOC_ITEM INTO @350_CUR2_DIVISION_ID, @350_CUR2_OPERATION_GROOUP, @350_CUR2_COMPANY_ID, @350_CUR2_PLANT_ID, @350_CUR2_PLAN_START_YYYYMMDD, @350_CUR2_CELL_ITEM_ID, @350_CUR2_ITEM_ID, @350_CUR2_YYYYMM, @350_CUR2_QTY, @350_CUR2_MEASURE, @350_CUR2_SEQ_FLAG,  
																			@350_CUR2_VALUE_TYPE, @350_CUR2_TO_PRODUCT,	@350_CUR2_LINE_ID, @350_CUR2_TO_SITE, @350_CUR2_INCOTERMS  ;
		 
									WHILE (@@FETCH_STATUS = 0)
									BEGIN

											IF @350_CUR_REMAIN_QTY > @350_CUR2_QTY 
											BEGIN
													UPDATE A SET QTY = 0
													FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 A WITH(NOLOCK)  
													WHERE DIVISION_ID = @350_CUR2_DIVISION_ID
													and OPERATION_GROUP = @350_CUR2_OPERATION_GROOUP
													and COMPANY_ID = @350_CUR2_COMPANY_ID
													AND PLANT_ID = @350_CUR2_PLANT_ID
													AND PLAN_START_YYYYMMDD = @350_CUR2_PLAN_START_YYYYMMDD
													AND CELL_ITEM_ID = @350_CUR2_CELL_ITEM_ID
													AND ITEM_ID = @350_CUR2_ITEM_ID
													AND YYYYMM = @350_CUR2_YYYYMM
													AND MEASURE = @350_CUR2_MEASURE
													AND SEQ_FLAG = @350_CUR2_SEQ_FLAG
													and VALUE_TYPE = @350_CUR2_VALUE_TYPE 
													and TO_PRODUCT = @350_CUR2_TO_PRODUCT	
													and LINE_ID = @350_CUR2_LINE_ID 
													and TO_SITE = @350_CUR2_TO_SITE 
													and INCOTERMS = @350_CUR2_INCOTERMS

													set @350_CUR_REMAIN_QTY = @350_CUR_REMAIN_QTY - @350_CUR2_QTY

											END
											else if @350_CUR_REMAIN_QTY <= @350_CUR2_QTY
											BEGIN

													UPDATE A SET QTY = QTY - @350_CUR_REMAIN_QTY
													FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 A WITH(NOLOCK)  
													WHERE DIVISION_ID = @350_CUR2_DIVISION_ID
													and OPERATION_GROUP = @350_CUR2_OPERATION_GROOUP
													and COMPANY_ID = @350_CUR2_COMPANY_ID
													AND PLANT_ID = @350_CUR2_PLANT_ID
													AND PLAN_START_YYYYMMDD = @350_CUR2_PLAN_START_YYYYMMDD
													AND CELL_ITEM_ID = @350_CUR2_CELL_ITEM_ID
													AND ITEM_ID = @350_CUR2_ITEM_ID
													AND YYYYMM = @350_CUR2_YYYYMM
													AND MEASURE = @350_CUR2_MEASURE
													AND SEQ_FLAG = @350_CUR2_SEQ_FLAG
													and VALUE_TYPE = @350_CUR2_VALUE_TYPE 
													and TO_PRODUCT = @350_CUR2_TO_PRODUCT	
													and LINE_ID = @350_CUR2_LINE_ID 
													and TO_SITE = @350_CUR2_TO_SITE 
													and INCOTERMS = @350_CUR2_INCOTERMS

										
													break  -- set @350_CUR_REMAIN_QTY = 0 이 됨.	

											END	

	 								FETCH NEXT FROM CUR_350_BOH_ALLOC_ITEM INTO @350_CUR2_DIVISION_ID, @350_CUR2_OPERATION_GROOUP, @350_CUR2_COMPANY_ID, @350_CUR2_PLANT_ID, @350_CUR2_PLAN_START_YYYYMMDD, @350_CUR2_CELL_ITEM_ID, @350_CUR2_ITEM_ID, @350_CUR2_YYYYMM, @350_CUR2_QTY, @350_CUR2_MEASURE, @350_CUR2_SEQ_FLAG,  
																			@350_CUR2_VALUE_TYPE, @350_CUR2_TO_PRODUCT,	@350_CUR2_LINE_ID, @350_CUR2_TO_SITE, @350_CUR2_INCOTERMS  ;
									END 
		
								CLOSE CUR_350_BOH_ALLOC_ITEM;
								DEALLOCATE CUR_350_BOH_ALLOC_ITEM;
								----------------------------------------
								-- PROD_PLAN Cursor : END
								----------------------------------------
						end  -- 350 boh로 prod 차감 추가 2 (check2/2)

	 				FETCH NEXT FROM CUR_350_BOH_ALLOC INTO @350_CUR_SEQ_FLAG, @350_CUR_DIVISION_ID, @350_CUR_OPERATION_GROOUP, @350_CUR_COMPANY_ID, @350_CUR_PLANT_ID, @350_CUR_PLAN_START_YYYYMMDD, @350_CUR_CELL_ITEM_ID, @350_CUR_ITEM_ID, @350_CUR_REMAIN_QTY ;  
					END -- OPEN CUR_350_BOH_ALLOC;
		
					CLOSE CUR_350_BOH_ALLOC;
					DEALLOCATE CUR_350_BOH_ALLOC;

		END   -- BOH로 PROD 차감 END


--여기에 360으로 350 boh 차감. end

--여기에 760으로 750 boh 차감. start
	--------------------------------------------
	-- 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감. 
	--------------------------------------------

	BEGIN

				DECLARE @750_CUR_SEQ_FLAG				NVARCHAR(5)
				DECLARE @750_CUR_DIVISION_ID			NVARCHAR(10)
				DECLARE @750_CUR_OPERATION_GROOUP		NVARCHAR(1)
				DECLARE @750_CUR_COMPANY_ID				NVARCHAR(10)
				DECLARE @750_CUR_PLANT_ID			    NVARCHAR(10)
				DECLARE @750_CUR_PLAN_START_YYYYMMDD	NVARCHAR(8)
				DECLARE @750_CUR_CELL_ITEM_ID			NVARCHAR(40)
				DECLARE @750_CUR_ITEM_ID				NVARCHAR(40)
				DECLARE @750_CUR_QTY			        NUMERIC(20, 10)
				DECLARE @750_CUR_REMAIN_QTY		        NUMERIC(20, 10)

				DECLARE @750_CUR2_DIVISION_ID			NVARCHAR(10)
				DECLARE @750_CUR2_OPERATION_GROOUP		NVARCHAR(1)
				DECLARE @750_CUR2_COMPANY_ID		    NVARCHAR(10)
				DECLARE @750_CUR2_PLANT_ID				NVARCHAR(10)
				DECLARE @750_CUR2_PLAN_START_YYYYMMDD	NVARCHAR(8)
				DECLARE @750_CUR2_CELL_ITEM_ID			NVARCHAR(40)
				DECLARE @750_CUR2_ITEM_ID				NVARCHAR(40)
				DECLARE @750_CUR2_YYYYMM				NVARCHAR(6)
				DECLARE @750_CUR2_QTY			        NUMERIC(20, 10)
				DECLARE @750_CUR2_MEASURE				NVARCHAR(40)
				DECLARE @750_CUR2_SEQ_FLAG				NVARCHAR(5)

				DECLARE @750_CUR2_VALUE_TYPE		NVARCHAR(10)
				DECLARE @750_CUR2_TO_PRODUCT		NVARCHAR(100)
				DECLARE @750_CUR2_LINE_ID			NVARCHAR(10)
				DECLARE @750_CUR2_TO_SITE           NVARCHAR(30)
				DECLARE @750_CUR2_INCOTERMS			NVARCHAR(5)


				-- BOH Cursor
				DECLARE CUR_750_BOH_ALLOC CURSOR FOR

						SELECT a.seq_flag,	a.DIVISION_ID, a.OPERATION_GROUP, a.COMPANY_ID, a.PLANT_ID, a.PLAN_START_YYYYMMDD, a.CELL_ITEM_ID, a.ITEM_ID, a.BOH_QTY
						FROM  #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy a WITH(NOLOCK)  
						WHERE a.BOH_QTY > 0
						and a.measure = 'INV'
						and a.seq_flag = '760'
						AND a.YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)  
						and exists (select 'Y'
									from #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 b with(nolock)
									where b.DIVISION_ID = a.DIVISION_ID
									and b.OPERATION_GROUP = a.OPERATION_GROUP 
									and b.COMPANY_ID = a.COMPANY_ID 
									and b.PLANT_ID = a.PLANT_ID
									and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
									and b.CELL_ITEM_ID = a.CELL_ITEM_ID
									and b.ITEM_ID = a.ITEM_ID
									and b.seq_flag = '750'
									and b.qty > 0 )
						ORDER BY a.ITEM_ID

				OPEN CUR_750_BOH_ALLOC;
				FETCH NEXT FROM CUR_750_BOH_ALLOC INTO @750_CUR_SEQ_FLAG, @750_CUR_DIVISION_ID, @750_CUR_OPERATION_GROOUP, @750_CUR_COMPANY_ID, @750_CUR_PLANT_ID, @750_CUR_PLAN_START_YYYYMMDD, @750_CUR_CELL_ITEM_ID, @750_CUR_ITEM_ID, @750_CUR_REMAIN_QTY   
		 
				WHILE (@@FETCH_STATUS = 0)
				BEGIN	
							DECLARE CUR_750_BOH_ALLOC_ITEM CURSOR FOR


							SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG, 
								   VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 WITH(NOLOCK)  
							WHERE DIVISION_ID = @750_CUR_DIVISION_ID
							and OPERATION_GROUP = @750_CUR_OPERATION_GROOUP
							and COMPANY_ID = @750_CUR_COMPANY_ID
							AND PLANT_ID = @750_CUR_PLANT_ID
							AND PLAN_START_YYYYMMDD = @750_CUR_PLAN_START_YYYYMMDD
							AND CELL_ITEM_ID = @750_CUR_CELL_ITEM_ID
							AND ITEM_ID = @750_CUR_ITEM_ID
							AND MEASURE = 'PROD_PLAN'
							AND SEQ_FLAG = '750'
							AND QTY > 0
							ORDER BY YYYYMM
		  
							OPEN CUR_750_BOH_ALLOC_ITEM;
							FETCH NEXT FROM CUR_750_BOH_ALLOC_ITEM INTO @750_CUR2_DIVISION_ID, @750_CUR2_OPERATION_GROOUP, @750_CUR2_COMPANY_ID, @750_CUR2_PLANT_ID, @750_CUR2_PLAN_START_YYYYMMDD, @750_CUR2_CELL_ITEM_ID, @750_CUR2_ITEM_ID, @750_CUR2_YYYYMM, @750_CUR2_QTY, @750_CUR2_MEASURE, @750_CUR2_SEQ_FLAG,  
																	@750_CUR2_VALUE_TYPE, @750_CUR2_TO_PRODUCT,	@750_CUR2_LINE_ID, @750_CUR2_TO_SITE, @750_CUR2_INCOTERMS  ;
		 
							WHILE (@@FETCH_STATUS = 0)
							BEGIN

									IF @750_CUR_REMAIN_QTY > @750_CUR2_QTY 
									BEGIN
											UPDATE A SET QTY = 0
											FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 A WITH(NOLOCK)  
											WHERE DIVISION_ID = @750_CUR2_DIVISION_ID
											and OPERATION_GROUP = @750_CUR2_OPERATION_GROOUP
											and COMPANY_ID = @750_CUR2_COMPANY_ID
											AND PLANT_ID = @750_CUR2_PLANT_ID
											AND PLAN_START_YYYYMMDD = @750_CUR2_PLAN_START_YYYYMMDD
											AND CELL_ITEM_ID = @750_CUR2_CELL_ITEM_ID
											AND ITEM_ID = @750_CUR2_ITEM_ID
											AND YYYYMM = @750_CUR2_YYYYMM
											AND MEASURE = @750_CUR2_MEASURE
											AND SEQ_FLAG = @750_CUR2_SEQ_FLAG
											and VALUE_TYPE = @750_CUR2_VALUE_TYPE 
											and TO_PRODUCT = @750_CUR2_TO_PRODUCT	
											and LINE_ID = @750_CUR2_LINE_ID 
											and TO_SITE = @750_CUR2_TO_SITE 
											and INCOTERMS = @750_CUR2_INCOTERMS

											set @750_CUR_REMAIN_QTY = @750_CUR_REMAIN_QTY - @750_CUR2_QTY

									END
									else if @750_CUR_REMAIN_QTY <= @750_CUR2_QTY
									BEGIN

											UPDATE A SET QTY = QTY - @750_CUR_REMAIN_QTY
											FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 A WITH(NOLOCK)  
											WHERE DIVISION_ID = @750_CUR2_DIVISION_ID
											and OPERATION_GROUP = @750_CUR2_OPERATION_GROOUP
											and COMPANY_ID = @750_CUR2_COMPANY_ID
											AND PLANT_ID = @750_CUR2_PLANT_ID
											AND PLAN_START_YYYYMMDD = @750_CUR2_PLAN_START_YYYYMMDD
											AND CELL_ITEM_ID = @750_CUR2_CELL_ITEM_ID
											AND ITEM_ID = @750_CUR2_ITEM_ID
											AND YYYYMM = @750_CUR2_YYYYMM
											AND MEASURE = @750_CUR2_MEASURE
											AND SEQ_FLAG = @750_CUR2_SEQ_FLAG
											and VALUE_TYPE = @750_CUR2_VALUE_TYPE 
											and TO_PRODUCT = @750_CUR2_TO_PRODUCT	
											and LINE_ID = @750_CUR2_LINE_ID 
											and TO_SITE = @750_CUR2_TO_SITE 
											and INCOTERMS = @750_CUR2_INCOTERMS

										
											break  -- set @750_CUR_REMAIN_QTY = 0 이 됨.	

									END	

	 						FETCH NEXT FROM CUR_750_BOH_ALLOC_ITEM INTO @750_CUR2_DIVISION_ID, @750_CUR2_OPERATION_GROOUP, @750_CUR2_COMPANY_ID, @750_CUR2_PLANT_ID, @750_CUR2_PLAN_START_YYYYMMDD, @750_CUR2_CELL_ITEM_ID, @750_CUR2_ITEM_ID, @750_CUR2_YYYYMM, @750_CUR2_QTY, @750_CUR2_MEASURE, @750_CUR2_SEQ_FLAG,  
																	@750_CUR2_VALUE_TYPE, @750_CUR2_TO_PRODUCT,	@750_CUR2_LINE_ID, @750_CUR2_TO_SITE, @750_CUR2_INCOTERMS  ;
							END 
		
							CLOSE CUR_750_BOH_ALLOC_ITEM;
							DEALLOCATE CUR_750_BOH_ALLOC_ITEM;
							----------------------------------------
							-- PROD_PLAN Cursor : END
							----------------------------------------

	 			FETCH NEXT FROM CUR_750_BOH_ALLOC INTO @750_CUR_SEQ_FLAG, @750_CUR_DIVISION_ID, @750_CUR_OPERATION_GROOUP, @750_CUR_COMPANY_ID, @750_CUR_PLANT_ID, @750_CUR_PLAN_START_YYYYMMDD, @750_CUR_CELL_ITEM_ID, @750_CUR_ITEM_ID, @750_CUR_REMAIN_QTY ;  
				END -- OPEN CUR_750_BOH_ALLOC;
		
				CLOSE CUR_750_BOH_ALLOC;
				DEALLOCATE CUR_750_BOH_ALLOC;

	END   -- BOH로 PROD 차감 END


--여기에 750 boh 차감. end

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330
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
		select  c.DIVISION_ID, 
				c.COMPANY_ID, 
				c.PLANT_ID, 
				@V_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD, 
				1 as SEQ, 
				'A' as OPERATION_GROUP, 
				'-'  as FROM_SITE, 
				'-'  as CELL_ITEM_ID, 
				c.ITEM_ID as ITEM_ID, 
				'IN_HOUSE_MOVING' as MEASURE, 
				'-'  as VALUE_TYPE, 
				c.TO_PRODUCT as TO_PRODUCT, 
				'-' as LINE_ID, 
				0 as BOH_QTY, 
				c.TO_SITE as TO_SITE, 
				'-' as INCOTERMS, 
				'430' as SEQ_FLAG, 
				c.YYYYMM, 
				isnull(sum(isnull(QTY,0)/isnull(fm.FORMATION_TOTAL_YIELD, 1)),0) as QTY
		from (	
				-- 350 -> 430
				select  DIVISION_ID, 
						COMPANY_ID, 
						PLANT_ID, 
						lc.cell_ca as ITEM_ID, 
						a.ITEM_ID as TO_PRODUCT, 
						a.PLANT_ID as TO_SITE, 
						YYYYMM, 
						QTY
				from #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 a
				inner join #tmp_ultra_small_lookup_cell LC WITH(NOLOCK)
						on Lc.cell_cp = a.ITEM_ID
				where a.seq_flag = '350'
				union all
				-- 750 -> 430
				select  DIVISION_ID, 
						COMPANY_ID, 
						PLANT_ID, 
						lc.cell_ca as ITEM_ID, 
						b.ITEM_ID as TO_PRODUCT, 
						b.PLANT_ID as TO_SITE, 
						YYYYMM, 
						QTY
				from #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 b
				inner join #tmp_ultra_small_lookup_tco_cell LC WITH(NOLOCK)
						on Lc.tco_cell_ca = b.ITEM_ID 
				where b.seq_flag = '750'
				) c
		left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				on x.DIVISION_ID =  @V_DIVISION_ID --'40'
				and x.plant_id = c.PLANT_ID --'G182'
				and x.operation_group = 'A' 
		left join [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = @V_DIVISION_ID --'40'
				and fm.PLANT_SITE_ID = x.SCM_SITE_ID
				and fm.item_id =c.ITEM_ID	
		group by c.DIVISION_ID, 
				c.COMPANY_ID, 
				c.PLANT_ID, 
				c.ITEM_ID, 
				c.TO_PRODUCT, 
				c.TO_SITE, 
				c.YYYYMM


                 -- CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - 변경후 쿼리 
				;WITH CP_INFO3 AS (
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
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330 X 
					   INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_FINAL_ITEM_V F WITH(NOLOCK)  
							   ON 1=1
							  AND F.ITEM_ID			= X.ITEM_ID
					   LEFT  JOIN CP_INFO3 C1 WITH(NOLOCK)
							   ON C1.DIVISION_ID	= X.DIVISION_ID
							  AND C1.PLANT_ID		= x.PLANT_ID   
							  AND C1.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C1.PRIORITY_1ST	= 1
					   LEFT  JOIN CP_INFO3 C2 WITH(NOLOCK)
							   ON C2.DIVISION_ID	= X.DIVISION_ID
							  AND C2.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C2.PRIORITY_2ND	= 1
					   LEFT  JOIN CP_INFO3 C3 WITH(NOLOCK)
							   ON C3.ITEM_ID_ASSY	= X.ITEM_ID
							  AND C3.PRIORITY_3RD	= 1
				 WHERE 0 = 0
				   AND X.OPERATION_GROUP   = 'A'
				   and x.SEQ_FLAG = '430'  
				   --and isnull(x.CELL_ITEM_ID,'') < '0'

------------예외2, CASE2 중 1. '350 + 750  --> 430  end

INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy
SELECT *
FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_650_330


-- 셀후공정제품 BOH(660)로 PROD_PLAN(650) 차감하기 END


					insert into #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd
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
							)
					SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, sum(BOH_QTY), TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, sum(QTY)
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy WITH(NOLOCK)
					GROUP BY DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM



--소숫점 없애기

update a set BOH_QTY = round(isnull(BOH_QTY,0),0),
			 QTY     = round(isnull(QTY,0),0)
from #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd a


-- 월_INVentory 생성 START 

            SET @V_STATUS_DESC = 'INV';
			DECLARE @MIN_YYYYMM NVARCHAR(6)
			DECLARE @MAX_YYYYMM NVARCHAR(6)
			DECLARE @PRE_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)

			SELECT @MIN_YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)

			select @MAX_YYYYMM=MAX(YYYYMM)  
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd a WITH(NOLOCK)
			WHERE DIVISION_ID =  @V_DIVISION_ID 
			AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 

			SET @PROC_YYYYMM = @MIN_YYYYMM

			set @PROC_YYYYMMDD = @PROC_YYYYMM + '01'

			DECLARE @I INT = 0

			WHILE (@PROC_YYYYMM <= @MAX_YYYYMM)
			BEGIN

				IF (@I > 50)
				BEGIN
					BREAK
				END	

				IF ( @PROC_YYYYMM = @MIN_YYYYMM )
				BEGIN
					-- 재고가 없는 경우 첫번째 월을 QTY=0 으로 생성함.
					insert into #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd
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

							)
					SELECT   DISTINCT a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,1 AS SEQ --a.SEQ
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
							,@PROC_YYYYMM AS YYYYMM
							,0 AS QTY
							,'SCP BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.COMPANY_ID = a.COMPANY_ID   
										and b.PLANT_ID = a.PLANT_ID  
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ  
										and b.OPERATION_GROUP = a.OPERATION_GROUP 
										--and b.FROM_SITE = a.FROM_SITE
										and b.CELL_ITEM_ID = a.CELL_ITEM_ID 
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV')
					and a.measure <> 'MKT_FCST'
					and a.operation_group <> 'E'  -- 전극 제외

					-- 첫번째 월의 재고(QTY) 반영
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' THEN  b.BOH_QTY
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd B WITH(NOLOCK)
												WHERE  b.DIVISION_ID = a.DIVISION_ID
												and b.COMPANY_ID = a.COMPANY_ID 
												and b.PLANT_ID = a.PLANT_ID
												and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
												and b.seq = a.seq
												and b.OPERATION_GROUP = a.OPERATION_GROUP
												and b.FROM_SITE = a.FROM_SITE
												and b.CELL_ITEM_ID = a.CELL_ITEM_ID
												and b.ITEM_ID = a.ITEM_ID
												and LEFT(b.SEQ_FLAG,1) = LEFT(a.SEQ_FLAG,1)
												and b.YYYYMM = a.YYYYMM ),0)
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.YYYYMM=@PROC_YYYYMM
					and a.operation_group <> 'E'  -- 전극은 사실상 없음.

				END  
				ELSE -- 두번째 월부터 마지막 월까지 재고 생성.
				BEGIN

					insert into #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd
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
							,'-' as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,a.BOH_QTY AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,LEFT(a.SEQ_FLAG,1) + '60' as seq_flag
							,@PROC_YYYYMM AS YYYYMM
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE  WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																		 WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																		 END) QTY
															FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd B WITH(NOLOCK)
															WHERE  b.DIVISION_ID = a.DIVISION_ID
															and b.COMPANY_ID = a.COMPANY_ID 
															and b.PLANT_ID = a.PLANT_ID
															and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
															and b.seq = a.seq
															and b.OPERATION_GROUP = a.OPERATION_GROUP
															and b.FROM_SITE = a.FROM_SITE
															and b.CELL_ITEM_ID = a.CELL_ITEM_ID
															and b.ITEM_ID = a.ITEM_ID
															and LEFT(b.SEQ_FLAG,1) = LEFT(a.SEQ_FLAG,1)
															and b.YYYYMM = @PROC_YYYYMM
															),0) AS QTY
							,'SCP BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd a WITH(NOLOCK)
					where a.measure = 'INV'
					and a.YYYYMM=@PRE_YYYYMM 
					and a.operation_group <> 'E'  -- 전극은 사실상 없음.
				END

				SET @I = @I + 1

				SET @PROC_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(M, 1, @PROC_YYYYMMDD),112)
				SET @PRE_YYYYMM = @PROC_YYYYMM
				SET @PROC_YYYYMM = LEFT(@PROC_YYYYMMDD,6)

			END 


			-------------------------------------------------------------------------------------------------------------                         
			-- ESS 용 전극 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산
			------------------------------------------------------------------------------------------------------------- 
			DELETE #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd
			where 1=1
			and operation_group = 'E'
			and item_id IN (select distinct item_id from [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item  WITH(NOLOCK)   
									where division_id = @V_DIVISION_ID
									and FLOW_ID like 'E2000%'
									and cell_item_id like 'EC%'
								   ) 

			-------------------------------------------------------------------------------------------------------------                         
			-- 이전 동일 수행건 삭제 후 수행내역 Insert
			-- 삭제 & insert   
			------------------------------------------------------------------------------------------------------------- 
            SET @V_STATUS_DESC = 'Delete';


			DELETE A FROM SCP_ANL_PSI_INTEGRATION A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.DIVISION_ID			= @V_DIVISION_ID


            SET @V_STATUS_DESC = 'insert';
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
					,MEASURE   --10
					,value_type
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
					,ISNULL(COMPANY_ID,'-')
					,ISNULL(PLANT_ID,'-')
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
					,round(isnull(BOH_QTY,0),0)
					,TO_SITE
					,ISNULL(INCOTERMS,'-')
					,SEQ_FLAG
					,YYYYMM
					,round(isnull(QTY,0),0)
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
			from #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd

		
			drop table #tmp_SCP_ANL_PSI_INTEGRATION_small
			drop table #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy
			drop table #tmp_SCP_ANL_PSI_INTEGRATION_small_GroupBy_2nd
			drop table #tmp_psi_integration_inv_small
			drop table #tmp_psi_integration_220_240_small
			drop table #tmp_psi_integration_320_340_small
			drop table #tmp_PSI_INTEGRATION_230_ITEM_small
			drop table #tmp_PSI_INTEGRATION_350_small
			drop table #tmp_PSI_INTEGRATION_450_small
			drop table #tmp_PSI_INTEGRATION_430_small
			drop table #tmp_PSI_INTEGRATION_350_750_430_ultra_small
			drop table #tmp_PSI_INTEGRATION_750_small
			drop table #tmp_YIELD_VER_H_V_A_small
			drop table #tmp_FINAL_ITEM_BOM_V_small

            
			-- TXN LOG                        
			SET @v_log_type     = N'TXN';          
			SET @n_log_count    = @@ROWCOUNT;                        
			SET @v_log_message  = N'INSERT INTO '+@v_table_id;                               
			SET @d_event_date   = SYSDATETIME();                                     
			SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ':' + @V_DIVISION_ID ;    
                        
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
	
end  



