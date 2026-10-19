

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_ESS                        
 * Description  : 재료비 TASK                      
 * OutTable     : SCP_ANL_PSI_INTEGRATION_ESS                     
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_ESS
                       @p_division_id         = '82'
                      ,@p_plan_start_yyyymmdd = '20240617'
                  
 * Program History                      
 *===================================================================================================                      
 * Date         In Charge      Description                      
 *===================================================================================================                      
 * 2024.06.20                  Initial 재료비 TASK PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 PSI용 정보 구성
 * 2024.08.05                  조립, 전극 작업으로 분리
 * 2024.08.08                  PLAN_TYPE 파라미터 추가, 해상재고 PUR 재고로 변경.
 *******************************************************************************************************************/                    

-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS '82', '20240812', 'FN'
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS '82', '20240812', 'FN'
-- exec PR_SCP_ANL_PSI_INTEGRATION_ESS '82', '20240812', 'MA'

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_INTEGRATION_ESS]
(                         
      @p_division_id          NVARCHAR(30)            
     ,@p_plan_start_yyyymmdd  NVARCHAR(8) 
	 ,@p_PLAN_TYPE			  NVARCHAR(2) = NULL
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_INTEGRATION_ESS';                        
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
	DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= ISNULL(@P_DIVISION_ID, '81')
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL;
	DECLARE @V_PLAN_START_DATE			DATE			= NULL;
	--DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= 'FN';
	DECLARE @V_PLAN_TYPE				NVARCHAR(100)	= ISNULL(@P_PLAN_TYPE, 'FN');
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
			 FROM SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
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
			from SCM_MST_DIVISION A with(nolock)
			INNER JOIN SCM_MST_DIVISION B WITH(NOLOCK)
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
			 FROM SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
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
          -- 1. 팩/모듈 제품 
		  --    0.MKT FCST 입력
          ------------------------------------------------------------------------------------------------------------- 

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
				'-' as COMPANY_ID, 
				'-' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'P' as operation_group, 
				'-' as FROM_SITE,
                '-' AS CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ) AS TO_SITE,
				a.incoterms, 
				'100' AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					a.incoterms,
					a.YYYYMMDD

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
				'-' as COMPANY_ID, 
				'-' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'P' as operation_group, 
				'-' as FROM_SITE,
                '-' AS CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ) AS TO_SITE,
				a.incoterms, 
				'200' AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					a.incoterms,
					a.YYYYMMDD


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
				'-' as COMPANY_ID, 
				'-' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'A' as operation_group, 
				'-' as FROM_SITE,
                '-' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ) AS TO_SITE,
				a.incoterms, 
				'300' AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.measure = 'MKT_FCST' 
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					a.incoterms,
					a.YYYYMMDD


          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    1.Ship. Plan(RTF) 입력
          ------------------------------------------------------------------------------------------------------------- 

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
	            ,1 AS SEQ 
				,'P' as operation_group 
				,'-' as FROM_SITE
                ,'-' as CELL_ITEM_ID  
	            ,a.FROM_ITEM_ID AS item_id 
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'-' as value_type
				,'-' as TO_PRODUCT
				,'-'  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ) AS TO_SITE
				,a.incoterms
				,'110' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
			FROM SCP_PLN_RTF_ALLOCATION_ALL_V a WITH(NOLOCK)
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = 
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.from_item_id 
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
																		from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.from_item_id 
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
													from th_exp_delivery_sn de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.from_item_id 
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )

			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  --AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.PLAN_TYPE			= (CASE WHEN @V_PLAN_TYPE = 'MA' THEN 'SE'
			                                    ELSE @V_PLAN_TYPE
												END ) 
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
	                 a.FROM_ITEM_ID, 
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					 a.incoterms,
					 a.YYYYMMDD

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
	            ,1 AS SEQ 
				,'P' as operation_group 
				,'-' as FROM_SITE
                ,'-' as CELL_ITEM_ID  
	            ,a.FROM_ITEM_ID AS item_id 
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'-' as value_type
				,'-' as TO_PRODUCT
				,'-'  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ) AS TO_SITE
				,a.incoterms
				,'210' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
			FROM SCP_PLN_RTF_ALLOCATION_ALL_V a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = 
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.from_item_id 
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													and k.incoterms = a.incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
													and k.PLAN_TYPE = @V_PLAN_TYPE  
													and k.seq = @V_PLAN_SEQ 
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.from_item_id 
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		and m.incoterms = a.incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
																		and m.PLAN_TYPE = @V_PLAN_TYPE  
																		and m.seq = @V_PLAN_SEQ 
																		and m.qty <> 0
																		and m.measure = 'WH_IN' ) 
													and k.measure = 'WH_IN')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from th_exp_delivery_sn de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.from_item_id  
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			-- AND a.PLAN_TYPE = @V_PLAN_TYPE   
			  AND a.PLAN_TYPE			= (CASE WHEN @V_PLAN_TYPE = 'MA' THEN 'SE'
			                                    ELSE @V_PLAN_TYPE
												END ) 
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
	                 a.FROM_ITEM_ID, 
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					 a.incoterms,
					 a.YYYYMMDD


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
	            ,1 AS SEQ 
				,'A' as operation_group 
				,'-' as FROM_SITE
                ,'-' as CELL_ITEM_ID  
	            ,a.FROM_ITEM_ID AS item_id 
	            ,'SHIP_PLAN_RTF' as MEASURE
				,'PRD' as value_type
				,'-' as TO_PRODUCT
				,'-'  as LINE_ID   
                ,0 as BOH_QTY
					,(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ) AS TO_SITE
				,a.incoterms
				,'310' AS SEQ_FLAG  
				,a.yyyymmdd as YYYYMMDD
				,isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
			FROM SCP_PLN_RTF_ALLOCATION_ALL_V a WITH(NOLOCK)
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = 
									(case when isnull(a.delivery_order_id,'') < '0' then 
												 (select MAX(k.FROM_SITE)
												  from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
												  where k.item_id = a.from_item_id
													and k.project_code = a.project_code 
													and k.to_site = a.sales_site_id 
													and k.incoterms = a.incoterms 
													and k.DIVISION_ID = @V_DIVISION_ID  
													and k.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
													and k.PLAN_TYPE = @V_PLAN_TYPE  
													and k.seq = @V_PLAN_SEQ 
													and k.qty <> 0
													and k.yyyymmdd = ( select min(m.YYYYMMDD)
																		from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
																		where m.item_id = a.from_item_id
																		and m.project_code = a.project_code 
																		and m.to_site = a.sales_site_id 
																		and m.incoterms = a.incoterms 
																		and m.DIVISION_ID = @V_DIVISION_ID  
																		and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
																		and m.PLAN_TYPE = @V_PLAN_TYPE  
																		and m.seq = @V_PLAN_SEQ 
																		and m.qty <> 0
																		and m.measure = 'WH_IN' ) 
													and k.measure = 'WH_IN')
											else 
												 (select SUBSTRING(de.FROM_SITE_ID,1,(CASE WHEN CHARINDEX('~', de.FROM_SITE_ID) = 0  THEN LEN(de.FROM_SITE_ID) ELSE CHARINDEX('~', de.FROM_SITE_ID)  -1 END))
													from th_exp_delivery_sn de with(nolock)
													where  de.master_id = a.master_id 
													and de.plan_id = a.out_version_id 
													and de.item_id = a.from_item_id  
													and de.out_version_id = a.out_version_id 
													and de.order_id = a.delivery_order_id 
													and de.demand_id = a.eng_demand_id  )
											end )
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
--			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
				AND a.PLAN_TYPE			= (CASE WHEN @V_PLAN_TYPE = 'MA' THEN 'SE'
			                                    ELSE @V_PLAN_TYPE
												END )
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
					 a.PLAN_START_YYYYMMDD,
	                 a.FROM_ITEM_ID, 
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else '-'
						end ),
					 a.incoterms,
					 a.YYYYMMDD

--2번(기존)
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.TO_SITE  --a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
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
			AND A.SEQ_FLAG IN ('110','210','310')

--3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.SCM_SITE_ID)
										from SCP_ANL_PRODUCTION_PLAN k with(nolock) 
										where 1=1
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_PRODUCTION_PLAN m with(nolock)
															where 1=1
															and m.item_id = isnull((select max(item_id_assy) from SCP_MST_CELL_PROD_ASSY_MAP z where z.division_id = a.division_id and z.item_id_prod = a.item_id and cell_type='CA1' and valid_yn='Y'),a.item_id)
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'PROD_PLAN_AMEND' ) 
										and k.measure = 'PROD_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310')






          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    5.PROD_PLAN 입력
          -------------------------------------------------------------------------------------------------------------  

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
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'P' as operation_group, 
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
				'150'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
					on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
					and fi.operation_group = 'P'
					and fi.ITEM_ID = a.item_id
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
		             a.ITEM_ID,
					 a.LINE_ID,
					 a.YYYYMMDD

-- PROD_PLAN(250) 생성 

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
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'P' as operation_group, 
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
				'250'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
		             a.ITEM_ID,
					 a.LINE_ID,
					 a.YYYYMMDD

            -------------------------------------------------------------------------------------------------------------                         
            -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) inv start
		    --    6.BOH 입력
            -------------------------------------------------------------------------------------------------------------  

			insert into #tmp_PSI_INTEGRATION_ESS_INV
			SELECT   SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
--					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,SUM(   (case when A.DESCR like 'FOR%' then ISNULL(A.QTY,0) * isnull(fm.ssp_modify_yield, 1)
								 else ISNULL(A.QTY,0) 
								 end)	)   AS QTY     

					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP
			FROM SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID,1,2)
					and C.division_id = @V_DIVISION_ID  
			-- 활성화 수율 가져오기 
			left join SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = SUBSTRING(A.MASTER_ID,1,2)  --a.DIVISION_ID
				and fm.PLANT_SITE_ID = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
				and fm.item_id =A.ITEM_ID
			inner join scm_mst_site b WITH(NOLOCK)
					on b.scm_sitE_id = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
					and b.division_id = @V_DIVISION_ID 
					and not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES')
				 and ( ISNULL(b.osp_yn, 'N') = 'N' 
				       OR (ISNULL(b.osp_yn, 'N') = 'Y' AND descr LIKE 'INT%')
				     )
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID  
			AND A.PLAN_ID     = @V_ENG_PLAN_ID  
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) <= @V_HORIZON_END_YYYYMMDD
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP

-- 추가 한 부분 sales_OnHand
			insert into #tmp_PSI_INTEGRATION_ESS_INV
			SELECT   A.DIVISION_ID AS DIVISION_ID
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,A.SITE_ID   AS FROM_SITE
					,A.ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,SUM(ISNULL(A.PSI_BOH_QTY,0))   AS QTY    
					,'WH' AS DESCR  
--					, b.site_type
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP
			FROM SCP_PLN_SALES_ONHAND A WITH(NOLOCK)     
			inner join scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID,1,2)
					and C.division_id = @V_DIVISION_ID  
			inner join scm_mst_site b WITH(NOLOCK)
					on b.scm_sitE_id = A.SITE_ID
					and b.division_id = @V_DIVISION_ID 
			where  A.DIVISION_ID = @V_DIVISION_ID
			AND A.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			AND A.PLAN_TYPE = @V_PLAN_TYPE
			AND A.seq = @V_PLAN_SEQ
			AND A.YYYYMMDD = @V_PLAN_START_YYYYMMDD  --> 이부분 맞나요?
			AND A.PSI_BOH_QTY <> 0
			GROUP BY                     
					A.DIVISION_ID                        
					,A.SITE_ID
					,A.ITEM_ID                                 
					--,A.DESCR
--					,b.site_type
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP


			/**********************************************
			 #tmp_PSI_INTEGRATION_ESS_inv  'P5000'을 추가.
			***********************************************/

            SET @V_STATUS_DESC = '6.BOH P5000';

			/**********************************************************************
			 EE 재고('560')를 #tmp_PSI_INTEGRATION_ESS_inv 에 추가로 insert 해야함.
			***********************************************************************/

            SET @V_STATUS_DESC = '6.BOH EE';


			update a set --company_id = b.company_id, 
						 company_id = (case when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N' and A.operation_group = 'E' and b.operation_group = 'A' and b.company_id = 'C100') THEN 'G180'  --'G183'의 company_id = 'G180' 으로 변경.
											else b.company_id
											end ), 
						 plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N' and A.operation_group = 'E' and b.operation_group = 'A' and b.company_id = 'C100') THEN 'G183' --'A041' 에서 'G183' 으로 변경.
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N' and A.operation_group = 'E' and b.operation_group = 'A') THEN 
												 (select top 1 plant_id from scm_mst_site k with(nolock) where k.site_type = 'PLANT' and k.valid_yn = 'Y' and k.company_id = b.company_id and k.operation_group = 'E' )
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a  
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.SCM_SITE_ID = a.from_site	

--1번(추가)
			update a set	company_id = b.company_id,  
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.item_id = a.item_id
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
															and m.PLAN_TYPE =  @V_PLAN_TYPE  
															and m.seq = @V_PLAN_SEQ  
															and m.qty <> 0
															and m.measure = 'WH_IN' ) 
										and k.measure = 'WH_IN')
			where isnull(a.plant_id,'-') < '0'

--2번(기존)
			update a set	company_id = b.company_id,  
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
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
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.SCM_SITE_ID)
										from SCP_ANL_PRODUCTION_PLAN k with(nolock) 
										where 1=1
										and k.item_id = a.item_id
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_PRODUCTION_PLAN m with(nolock)
															where 1=1
															and m.item_id = isnull((select max(item_id_assy) from SCP_MST_CELL_PROD_ASSY_MAP z where z.division_id = a.division_id and z.item_id_prod = a.item_id and cell_type='CA1' and valid_yn='Y'),a.item_id)
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE
															and m.seq = @V_PLAN_SEQ
															and m.qty <> 0
															and m.measure = 'PROD_PLAN_AMEND' ) 
										and k.measure = 'PROD_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'

--4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select top 1 from_site from #tmp_PSI_INTEGRATION_ESS_inv k
											inner join scm_mst_site m WITH(NOLOCK)
											on m.DIVISION_ID = k.DIVISION_ID 
											and m.scm_site_id = k.from_site
											and m.SITE_TYPE = 'PLANT'
											where k.division_id = a.division_id
											and (k.item_id = a.item_id or k.item_id = isnull((select max(item_id_assy) from SCP_MST_CELL_PROD_ASSY_MAP z where z.division_id = a.division_id and z.item_id_prod = a.item_id and cell_type='CA1' and valid_yn='Y'),a.item_id))
											and k.qty <> 0
											group by from_site, item_id
											order by sum(qty) desc)
			where isnull(a.plant_id,'-') < '0'

--5번(기존)
			update a set	company_id = b.company_id,  
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			-- select *
			FROM #tmp_PSI_INTEGRATION_ESS_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.from_site	
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD  
										and k.PLAN_TYPE = @V_PLAN_TYPE 
										and k.seq = @V_PLAN_SEQ  
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.from_site	
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  
															and m.PLAN_TYPE =  @V_PLAN_TYPE  
															and m.seq = @V_PLAN_SEQ  
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'



---- plant do 3, 4 작업 수행. start

--4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select top 1 from_site from #tmp_PSI_INTEGRATION_ESS_inv k
											inner join scm_mst_site m WITH(NOLOCK)
											on m.DIVISION_ID = k.DIVISION_ID 
											and m.scm_site_id = k.from_site
											and m.SITE_TYPE = 'PLANT'
											where k.division_id = a.division_id
											and (k.item_id = a.item_id or k.item_id = isnull((select max(item_id_assy) from SCP_MST_CELL_PROD_ASSY_MAP z where z.division_id = a.division_id and z.item_id_prod = a.item_id and cell_type='CA1' and valid_yn='Y'),a.item_id))
											and k.qty <> 0
											group by from_site, item_id
											order by sum(qty) desc)
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310')

--5번(기존)
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select MAX(k.FROM_SITE)
										from SCP_ANL_SHIPMENT_PLAN_FG k with(nolock)
										where k.to_site = a.TO_SITE --a.from_site	
										and k.DIVISION_ID = a.DIVISION_ID
										and k.PLAN_START_YYYYMMDD =  @V_PLAN_START_YYYYMMDD
										and k.PLAN_TYPE = @V_PLAN_TYPE
										and k.seq = @V_PLAN_SEQ 
										and k.qty <> 0
										and k.yyyymmdd = ( select min(m.YYYYMMDD)
															from SCP_ANL_SHIPMENT_PLAN_FG m with(nolock)
															where m.to_site = a.TO_SITE --a.from_site	
															and m.DIVISION_ID = a.DIVISION_ID
															and m.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
															and m.PLAN_TYPE =  @V_PLAN_TYPE 
															and m.seq = @V_PLAN_SEQ 
															and m.qty <> 0
															and m.measure = 'SHIP_PLAN_AMEND' ) 
										and k.measure = 'SHIP_PLAN_AMEND')
			where isnull(a.plant_id,'-') < '0'
			AND A.SEQ_FLAG IN ('110','210','310')


---- plant do 3, 4 작업 수행. end ----


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
						,1 AS SEQ 
						,'P' as operation_group 
						,'-'  AS FROM_SITE
						,'-' as CELL_ITEM_ID 
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
										FROM  scm_dnm_stock_osp so WITH(NOLOCK) 
										INNER JOIN scp_mst_final_item_v fi with(nolock)  
												on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
												and fi.operation_group = 'P'
												and fi.ITEM_ID = so.item_id
										inner join scm_mst_site b WITH(NOLOCK)
											 on  b.DIVISION_ID = so.DIVISION_ID
											 and b.SCM_SITE_ID = so.SCM_SITE_ID
											 and b.operation_group = 'P'
											 and b.osp_yn = 'Y'
										where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  
										and so.division_id = @V_DIVISION_ID  
										UNION ALL
										SELECT   a.division_id as DIVISION_ID
												,a.company_id
												,a.PLANT_ID
												,A.ITEM_ID 
												,isnull(A.QTY,0) AS BOH_QTY  
										FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
										INNER JOIN scp_mst_final_item_v fi with(nolock)
												on (fi.RACK_YN = 'Y' or fi.DC_YN = 'Y')
												and fi.operation_group = 'P'
												and fi.ITEM_ID = a.item_id 
										inner join scm_mst_site b WITH(NOLOCK)
											 on  b.DIVISION_ID = a.DIVISION_ID
											 and b.SCM_SITE_ID = a.FROM_SITE
											 and (b.operation_group = 'P' or b.site_type = 'SALES')
										WHERE a.operation_group='P' 
						) h
			GROUP BY h.DIVISION_ID
					,h.company_id
					,h.plant_id
					,h.ITEM_ID 


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
					,1 AS SEQ 
					,'P' as operation_group 
					,'-'  AS FROM_SITE
					,'-' as CELL_ITEM_ID 
					,h.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(h.BOH_QTY,0)),0)  AS BOH_QTY  
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
							FROM  scm_dnm_stock_osp so WITH(NOLOCK) 
							INNER JOIN scp_mst_final_item_v fi with(nolock)  
									on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
									and fi.operation_group = 'P'
									and fi.ITEM_ID = so.item_id
							inner join scm_mst_site b WITH(NOLOCK)
									on  b.DIVISION_ID = so.DIVISION_ID
									and b.SCM_SITE_ID = so.SCM_SITE_ID
									and b.operation_group = 'P'
									and b.osp_yn = 'Y'
							where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  
							and so.division_id = @V_DIVISION_ID
						
						UNION ALL

							SELECT   a.division_id as DIVISION_ID
									,a.company_id
									,a.PLANT_ID
									,A.ITEM_ID 
									,isnull(A.QTY,0) AS BOH_QTY  
							FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
							INNER JOIN scp_mst_final_item_v fi with(nolock)
									on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
									and fi.operation_group = 'P'
									and fi.ITEM_ID = a.item_id
							inner join scm_mst_site b WITH(NOLOCK)
									on  b.DIVISION_ID = a.DIVISION_ID
									and b.SCM_SITE_ID = a.FROM_SITE
									and (b.operation_group = 'P' or b.site_type = 'SALES')
							WHERE a.operation_group='P' 
				) h
			GROUP BY h.DIVISION_ID
					,h.company_id
					,h.plant_id
					,h.ITEM_ID 


--=== 370 수정 start

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP
					(	
						DIVISION_ID,
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
					,1 AS SEQ 
					,'A' as operation_group 
					,'-'  AS FROM_SITE
					,'-' as CELL_ITEM_ID 
					,h.ITEM_ID 
					,'INV' as MEASURE
					,'PUR' as value_type  
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(h.BOH_QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'370' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM  (  SELECT  so.division_id as DIVISION_ID
							,b.company_id
							,(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
									else  b.PLANT_ID
									end ) as PLANT_ID
							,so.ITEM_ID 
							,isnull(so.QTY,0)   AS BOH_QTY  							
					from scm_dnm_stock_osp so WITH(NOLOCK) 
					inner join scm_mst_site b WITH(NOLOCK)
							on  b.DIVISION_ID = so.DIVISION_ID
							and b.SCM_SITE_ID = so.SCM_SITE_ID
							and b.operation_group = 'P'
							and b.osp_yn = 'Y'
					inner join scp_mst_final_item c WITH(NOLOCK)
							on c.item_id = so.item_id
							and c.DIVISION_ID = so.DIVISION_ID
							and c.OPERATION_GROUP_ID = 'A'  
					where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  
					and so.division_id = @V_DIVISION_ID
					and so.ATTRIBUTE1 = 'PUR'
					UNION ALL
					SELECT   a.division_id as DIVISION_ID
							,a.company_id
							,a.plant_id
							,A.ITEM_ID 
							,isnull(a.QTY,0) AS BOH_QTY
					FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
					WHERE a.operation_group='A' 
					and a.descr LIKE 'INT%'
				) h
			GROUP BY h.DIVISION_ID
					,h.company_id
					,h.PLANT_ID
					,h.ITEM_ID 


--==== 370 수정 end
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
					,1 AS SEQ 
					,'A' as operation_group 
					,'-'  AS FROM_SITE
					,'-' as CELL_ITEM_ID 
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
					FROM  scm_dnm_stock_osp so WITH(NOLOCK) 
					inner join scm_mst_site b WITH(NOLOCK)
							on  b.DIVISION_ID = so.DIVISION_ID
							and b.SCM_SITE_ID = so.SCM_SITE_ID
							and b.operation_group = 'P'
							and b.osp_yn = 'Y'
					inner join scp_mst_final_item c WITH(NOLOCK)
							on c.item_id = so.item_id
							and c.DIVISION_ID = so.DIVISION_ID
							and c.OPERATION_GROUP_ID = 'A'  
					where so.YYYYMMDD = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)  
					and so.division_id = @V_DIVISION_ID
					and isnull(so.ATTRIBUTE1,'-') <> 'PUR' 
					UNION ALL
					SELECT   a.division_id as DIVISION_ID
							,a.company_id
							,a.plant_id
							,A.ITEM_ID 
							,isnull(a.QTY,0) AS BOH_QTY
					FROM #tmp_PSI_INTEGRATION_ESS_inv A WITH(NOLOCK)
					WHERE a.operation_group='A' 
					and a.descr not LIKE 'INT%'
				) h
			group by h.division_id
					,h.company_id
					,h.plant_id
					,h.ITEM_ID


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
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'A' as operation_group, 
				'-' AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				'350'  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM scp_anl_production_plan a WITH(NOLOCK)
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
		             a.ITEM_ID,
					 a.LINE_ID,
					 a.YYYYMMDD


		  -- CA 부품은 CP로 전환
			update a set item_id = x.item_id_prod  
			from #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP a
			inner join (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
							FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
								INNER JOIN scp_mst_final_item f WITH(NOLOCK)
								ON  c.division_id  = f.division_id
								AND c.item_id_prod = f.item_id
								AND f.ATTRIBUTE8   = 'CP'
							WHERE  c.cell_type = 'CA1' 
							AND    c.valid_yn  = 'Y'   
							GROUP BY c.division_id, c.item_id_assy) x
			on x.DIVISION_ID = a.DIVISION_ID
			and x.item_id_assy = a.ITEM_ID
			where a.seq_flag in ('350','360','370','380')


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
                '-' as CELL_ITEM_ID,
	            A.ITEM_ID,
	            A.MEASURE as MEASURE,
				A.VALUE_TYPE as value_type,
				A.TO_PRODUCT as TO_PRODUCT,
				a.LINE_ID,
                isnull(sum(isnull(A.BOH_QTY,0)),0) as BOH_QTY,
	            A.TO_SITE as TO_SITE,
				A.INCOTERMS AS INCOTERMS,
				A.SEQ_FLAG  AS SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_300_GROUP A
			group by PLAN_START_YYYYMMDD, COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMMDD



		    -------------------------------------------------------------------------------------------------------------                         
            -- 200. ESS PACK
		    --    220. Ship. Plan(Semi)
            -------------------------------------------------------------------------------------------------------------  

			insert into #tmp_PSI_INTEGRATION_ESS_220_240
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else '-'
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ, 
					'P' as operation_group, 
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM scp_anl_shipment_plan_semi a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item_v fi with(nolock)
				   on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				   and fi.operation_group = 'P'
				   and fi.ITEM_ID = a.item_id
			left join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join scp_mst_bod_n_v c with(nolock)
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
	            1 AS SEQ, 
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
				a.arrival_YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_220_240 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 a.arrival_YYYYMMDD


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
	            1 AS SEQ, 
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
				a.arrival_YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_220_240 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 a.arrival_YYYYMMDD


          -------------------------------------------------------------------------------------------------------------                         
          -- 200. ESS PACK   
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
	            1 AS SEQ,
				'P' as operation_group, 
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-' as LINE_ID,   
                0 as BOH_QTY,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'230'  as SEQ_FLAG,  
				a.YYYYMMDD,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1)),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			inner join SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = a.plant_id
					and b.model_id = a.item_id
					and b.model_id <> b.child_item_id
					and b.OPERATION_GROUP_ID = 'P'  
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			left join scp_mst_tact_time_osp y WITH (NOLOCK)
			on  y.division_id = @p_division_id
			AND y.valid_yn    = 'Y'   
			and	y.plant_site_id = a.plant_id  
			and y.item_id = a.item_id    
			and y.LINE_ID = a.line_id
			where a.SEQ_FLAG = '150'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             B.child_item_id,  
					 a.YYYYMMDD

		  -- 셀 In_house_Moving('330') 만들기

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
				a.YYYYMMDD,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1)),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a
			inner join SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = a.plant_id
					and b.model_id = a.item_id
					and b.model_id <> b.child_item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			inner join scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					and c.attribute8 = 'CP'
			left join scp_mst_tact_time_osp y WITH (NOLOCK)
					on  y.division_id = a.DIVISION_ID
					AND y.valid_yn    = 'Y'   
					and	y.plant_site_id = a.plant_id  
					and y.item_id = a.item_id    
					and y.LINE_ID = a.line_id
			where a.SEQ_FLAG = '250'  
			group by a.DIVISION_ID,  
					 a.COMPANY_ID, 
					 a.PLANT_ID,  
					 a.PLAN_START_YYYYMMDD, 
				     a.CELL_ITEM_ID,  
		             B.child_item_id,
					 a.ITEM_ID,
					 a.YYYYMMDD

		  -------------------------------------------------------------------------------------------------------------                         
          -- 300. ESS PACK
		  --    320. Ship. Plan(Semi)
          -------------------------------------------------------------------------------------------------------------  
			insert into #tmp_PSI_INTEGRATION_ESS_320_340
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
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
			FROM scp_anl_shipment_plan_semi a WITH(NOLOCK)
			left join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join scp_mst_bod_n_v c with(nolock)
				  on a.division_id = c.division_id
				  and a.bod_id = c.bod_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'A'   
			  and NOT (a.from_site = 'G634-A' and a.to_site = 'CN003035-P')    -- from 빈강 to 남경 제외
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


		   --  빈강 남경 반영 start

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG	
			 
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT

          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP

		  IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result') IS NOT NULL                        
			  DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result  


          CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG(                        
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
			
          CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN(                        
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
	            QTY			            NUMERIC(20, 10) NULL
            );     

		 CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT(                        
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
	            QTY			            NUMERIC(20, 10) NULL
            );    

          CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP(                        
	            ITEM_ID                 NVARCHAR(40)    NULL,
				YYYYMMDD			    NVARCHAR(8)     NULL,
	            QTY			            NUMERIC(20, 10) NULL
            );     

		   CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result(                        
				ITEM_ID                 NVARCHAR(40)    NULL,
				YYYYMMDD			    NVARCHAR(8)     NULL,
				QTY			            NUMERIC(20, 10) NULL
			);  

-- 가용 재고 : 1-1. boh 에 넣기 + 1-2.PROD
-- 가용 재고 1-1. BOH

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN
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
					,1 AS SEQ 
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'-' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'SHIP_PLAN_SEMI_IN' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'B60' as SEQ_FLAG
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0
			FROM #tmp_PSI_INTEGRATION_ESS_INV A WITH(NOLOCK)
			WHERE a.operation_group IN ('A')    
			AND a.from_site = 'G634-A'
			and a.qty <> 0
			group by a.division_id
					,a.company_id
					,a.plant_id
					,a.OPERATION_GROUP
					,A.ITEM_ID 

		  -- 가용 재고 1-2. PROD  : 특성화 리드타임 추가.

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN
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
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'A' as operation_group, 
				'-' AS FROM_SITE,   
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				'B50'  AS SEQ_FLAG,  
				convert(varchar(8), dateadd(d, ISNULL(fm.TOTAL_LT_FORMATION,0), a.YYYYMMDD),112) as yyyymmdd,
	           -- isnull(sum(isnull(QTY,0)),0) as QTY
			    isnull(sum(isnull(QTY,0) * isnull(fm.ssp_modify_yield, 1)),0) as QTY
			FROM scp_anl_production_plan a WITH(NOLOCK)
			left outer join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			-- 활성화 수율 가져오기 
			left join SCP_MST_FORMATION_V fm WITH (NOLOCK)	
				on fm.division_id = a.DIVISION_ID
				and fm.PLANT_SITE_ID = A.SCM_SITE_ID
				and fm.item_id =A.ITEM_ID				
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND A.SCM_SITE_ID = 'G634-A'
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'A'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  and a.qty <> 0
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
		             a.ITEM_ID,
					 a.LINE_ID,
					 convert(varchar(8), dateadd(d, ISNULL(fm.TOTAL_LT_FORMATION,0), a.YYYYMMDD),112) 

		  -- CA 부품은 CP로 전환
			update a set item_id = x.item_id_prod  
			from #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN a
			inner join (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
							FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
								INNER JOIN scp_mst_final_item f WITH(NOLOCK)
								ON  c.division_id  = f.division_id
								AND c.item_id_prod = f.item_id
								AND f.ATTRIBUTE8   = 'CP'
							WHERE  c.cell_type = 'CA1' 
							AND    c.valid_yn  = 'Y'   
							GROUP BY c.division_id, c.item_id_assy) x
			on x.DIVISION_ID = a.DIVISION_ID
			and x.item_id_assy = a.ITEM_ID

			-- 가용 재고 가져오기 end

-- 출하 수량 : 2-1. SEMI + 2-2. FG
-- 출하 수량 2-1. SEMI

		  insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT
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
	            1 AS SEQ, 
				'A' as operation_group, 
				a.from_site as FROM_SITE,
                '-' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'K20'  as SEQ_FLAG,  
				a.arrival_YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_PSI_INTEGRATION_ESS_320_340 a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
		    and (a.from_site = 'G634-A' and a.to_site <> 'CN003035-P')    -- from사이트는 빈강이면서 to사이트는 남경외
			and qty <> 0
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 a.from_site,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 a.arrival_YYYYMMDD

-- 출하 수량  2-2. FG

		 insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT
		 (                        
                DIVISION_ID,
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
				b.COMPANY_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ, 
				'A' as operation_group, 
				'-'  as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				'-' as TO_SITE, 
				'-' as INCOTERMS,
				'K50'  as SEQ_FLAG,  
				a.YYYYMMDD as YYYYMMDD,
				isnull(sum(isnull(a.QTY,0)),0) as QTY
			FROM scp_anl_shipment_plan_fg a WITH(NOLOCK)
			left join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  and a.FROM_SITE	= 'G634-A' 
			  AND A.QTY <> 0
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.biz_type = 'A'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 b.COMPANY_ID,
					 (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				     a.PLAN_START_YYYYMMDD,
				     a.ITEM_ID,
					 a.YYYYMMDD

			insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP
			select h.ITEM_ID, h.YYYYMMDD, SUM(H.QTY) QTY
			FROM  (	SELECT  a.ITEM_ID,
							a.YYYYMMDD as YYYYMMDD,
							isnull(a.QTY,0) + isnull(a.BOH_QTY,0) as QTY  -- BOH + Prod_Plan 수량
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN a
					union all
					SELECT  a.ITEM_ID,
							a.YYYYMMDD as YYYYMMDD,
							(isnull(a.QTY,0) + isnull(a.BOH_QTY,0)) * -1 as QTY  -- semi + fg 수량
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT a
				  ) h
			group by h.ITEM_ID,
					 h.YYYYMMDD

        -- from 빈강 to 남경 계산 START

		DECLARE @MIN_BINGANG_YYYYMMDD  NVARCHAR(8)
		DECLARE @MAX_BINGANG_YYYYMMDD  NVARCHAR(8)
		DECLARE @PROC_BINGANG_YYYYMMDD NVARCHAR(8)

		DECLARE @C_BINGANG_ITEM_ID              NVARCHAR(40)
		DECLARE @C_BINGANG_QTY_REMAIN	        NUMERIC(20, 10)

		set @MIN_BINGANG_YYYYMMDD = @V_PLAN_START_YYYYMMDD
		set @MAX_BINGANG_YYYYMMDD = @V_HORIZON_END_YYYYMMDD

		DECLARE CUR_BinGang_ALLOC CURSOR FOR

			SELECT ITEM_ID, 0
			FROM  #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP WITH(NOLOCK) 
			group by item_id
			ORDER BY ITEM_ID

		OPEN CUR_BinGang_ALLOC;
		FETCH NEXT FROM CUR_BinGang_ALLOC INTO @C_BINGANG_ITEM_ID, @C_BINGANG_QTY_REMAIN;
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

						SET @PROC_BINGANG_YYYYMMDD = @MAX_BINGANG_YYYYMMDD

						DECLARE @I_BINGANG INT = 0

						WHILE (@PROC_BINGANG_YYYYMMDD >= @MIN_BINGANG_YYYYMMDD)
						BEGIN

							IF (@I_BINGANG > 1000)
							BEGIN
								BREAK
							END	

							select @C_BINGANG_QTY_REMAIN = isnull(qty,0) + @C_BINGANG_QTY_REMAIN
							from #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP
							where item_id = @C_BINGANG_ITEM_ID
							and yyyymmdd = @PROC_BINGANG_YYYYMMDD

							if @C_BINGANG_QTY_REMAIN > 0
							begin				   
							   insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result
							   select @C_BINGANG_ITEM_ID, @PROC_BINGANG_YYYYMMDD, @C_BINGANG_QTY_REMAIN

							   set @C_BINGANG_QTY_REMAIN = 0
							end
							else
							begin
							   insert into #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result
							   select @C_BINGANG_ITEM_ID, @PROC_BINGANG_YYYYMMDD, 0
							end


							SET @I_BINGANG = @I_BINGANG + 1

							SET @PROC_BINGANG_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(D, -1, @PROC_BINGANG_YYYYMMDD),112)
						END  -- WHILE (@PROC_BINGANG_YYYYMMDD >= @MIN_BINGANG_YYYYMMDD) 문 END.
			FETCH NEXT FROM CUR_BinGang_ALLOC INTO @C_BINGANG_ITEM_ID, @C_BINGANG_QTY_REMAIN;
		END -- OPEN CUR_BinGang_ALLOC;
		
		CLOSE CUR_BinGang_ALLOC;
		DEALLOCATE CUR_BinGang_ALLOC;

		-- from 빈강 to 남경 계산 end

			insert into #tmp_PSI_INTEGRATION_ESS_320_340
	        SELECT  '82' as DIVISION_ID,  
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then 'CN003035-P'  
								      when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N') THEN x.PLANT_ID
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else '-'
									  end ),
					( SELECT TOP 1 bod_id
					  FROM  scp_mst_bod_v c with(nolock)
					  WHERE c.division_id = '82'
					  and from_site = 'G634-A' 
					  and to_site = 'CN003035-P'
					  and incoterms = 'DAP' ) as bod_id,  
					@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD, 
					1 AS SEQ, 
					'A' as operation_group, 
					'G634-A'  as From_site, 
					a.ITEM_ID,
					'CN003035-P' as To_Site, 
					'DAP' as incoterms, 
					a.qty,
					NULL as lt_total_ssp,  -- 미사용 필드
					'' as departure_YYYYMMDD,  -- 미사용 필드
					a.YYYYMMDD as arrival_yyyymmdd  
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result a WITH(NOLOCK)
			left join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID  
				 and b.SCM_SITE_ID = 'G634-A'   
			left join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = @V_DIVISION_ID  
				 and x.SCM_SITE_ID = 'CN003035-P' 


			drop table #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG
            drop table  #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN
            drop table  #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_OUT
            drop table  #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_IN_OUT_GRP
            drop table  #tmp_SCP_ANL_PSI_INTEGRATION_ESS_BINGANG_result

		  -- 빈강 남경 반영 end


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
	            1 AS SEQ, 
				'A' as operation_group, 
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'PRD' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
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
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 a.arrival_YYYYMMDD

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
	            1 AS SEQ, 
				'A' as operation_group, 
				'-' as FROM_SITE,  
                '-' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'PUR' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
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
					 ITEM_ID,
					 a.arrival_YYYYMMDD


            -------------------------------------------------------------------------------------------------------------                         
            -- 500. ESS 전극
		    --    530.IN_HOUSE_MOVING
            ------------------------------------------------------------------------------------------------------------- 

			select y.operation_group,  a.version_id, a.division_id, a.company_id, a.site_id, a.plant_id, a.factory_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month, a.yield
			into #tmp_YIELD_VER_H_V_A_ESS
			from SCM_MST_YIELD_VER_H_V a with(nolock)
			inner join (    SELECT DISTINCT segment4 as operation_id, segment5 as operation_group
							from scm_adm_lookup_master_detail b WITH(NOLOCK)
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
           SELECT   a.DIVISION_ID,
					--a.COMPANY_ID,
					COMPANY_ID=(CASE WHEN a.COMPANY_ID = 'C100' THEN 'G180'  --'G183'의 company_id = 'G180' 으로 변경.
									 else a.COMPANY_ID
									 end ),
					(CASE WHEN a.COMPANY_ID = 'C100' THEN 'G183' --'A041' 에서 'G183' 으로 변경.
						  ELSE (select top 1 plant_id 
								  from scm_mst_site k with(nolock) 
								 where k.site_type = 'PLANT' 
								   and k.valid_yn = 'Y' 
								   and k.company_id = a.company_id 
								   and k.operation_group = 'E' )
						  END) as plant_id,  -- 전극 Plant
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
					a.YYYYMMDD,
					isnull(sum(a.QTY * isnull(b.usage,1)  / isnull(y.yield,1)),0) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
			inner join SCP_MST_BOM_ELEC b WITH(NOLOCK)
					on  b.division_id = @V_DIVISION_ID
					and b.parent_item_id = a.item_id
					and b.scp_yn = 'Y'
			-- pack/cell 수율 반영 start 
			left join #tmp_YIELD_VER_H_V_A_ESS y 
				on y.division_id = a.DIVISION_ID
				and y.operation_group =a.OPERATION_GROUP
				and y.company_id = a.COMPANY_ID
				and y.line_id = a.LINE_ID
				and y.month = left(a.YYYYMMDD,6)  
				and y.item_id =a.ITEM_ID  
			where a.SEQ_FLAG = '350'  
			group by a.DIVISION_ID,
					 a.COMPANY_ID,
				     a.PLAN_START_YYYYMMDD,
		             B.child_item_id,
					 a.plant_id,
					 a.YYYYMMDD


            -------------------------------------------------------------------------------------------------------------                                         
            -- 9.1  CELL_ITEM_ID UPDATE
            ------------------------------------------------------------------------------------------------------------- 

            SET @V_STATUS_DESC = 'CELL_ITEM_ID Pack';

			select model_id, child_item_id
			into #tmp_FINAL_ITEM_BOM_V_ESS
			FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
			WHERE Y.CELL_TYPE			 = 'CP'		
			AND Y.OPERATION_GROUP_ID = 'A'
			and Y.DIVISION_ID        = @V_DIVISION_ID  

			create index i_tmp_FINAL_ITEM_BOM_V_ESS_01 on #tmp_FINAL_ITEM_BOM_V_ESS(model_id)


            -- PACK 일경우 
			-- CELL_ITEM_ID 적용
            UPDATE X
                SET CELL_ITEM_ID   = isnull(( SELECT TOP 1 CHILD_ITEM_ID
												FROM #tmp_FINAL_ITEM_BOM_V_ESS AS Y WITH (NOLOCK)
											   WHERE Y.MODEL_ID           = X.ITEM_ID),'-')
            FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X
            WHERE OPERATION_GROUP   = 'P'
			and left(x.SEQ_FLAG,1) <> '5'  -- 전극 제외
			and isnull(x.CELL_ITEM_ID,'') < '0'


			-- 상위 모델 이용하여 CELL_ITEM_ID 적용
            UPDATE X
                SET CELL_ITEM_ID   = isnull(( SELECT TOP 1 CHILD_ITEM_ID
												FROM #tmp_FINAL_ITEM_BOM_V_ESS AS Y WITH (NOLOCK)
											   WHERE Y.MODEL_ID    = ( SELECT top 1 model_id
																	     FROM SCM_MST_MODEL_ONE_LEVEL_BOM_V AS Y WITH (NOLOCK)
																		WHERE Y.DIVISION_ID        = X.DIVISION_ID
																		  AND Y.child_item_id         = X.ITEM_ID
																		  and y.plant_id = x.plant_id)),'-')
            FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X
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
					FROM SCP_MST_CELL_PROD_ASSY_MAP M WITH(NOLOCK)
				WHERE 1=1
					AND M.VALID_YN = 'Y' 
			)
				UPDATE X
				SET X.CELL_ITEM_ID      = isnull(CASE	WHEN F.CELL_TYPE LIKE 'CA%'
														THEN ISNULL(ISNULL(ISNULL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD),C3.ITEM_ID_PROD), X.ITEM_ID)
														ELSE X.ITEM_ID
														END,'-')
				FROM #tmp_SCP_ANL_PSI_INTEGRATION_ESS X 
					INNER JOIN SCP_MST_FINAL_ITEM_V F WITH(NOLOCK)  
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

            SET @V_STATUS_DESC = 'INV';

            -- 재고(Inventory) 생성 START ('BOH'는 기생성되어 있음.)
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
					,'1' AS SEQ 
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
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0 AS QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
			FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			where not exists (  select 'y' 
								from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
								where b.DIVISION_ID = a.DIVISION_ID
								and b.COMPANY_ID = a.COMPANY_ID   
								and b.PLANT_ID = a.PLANT_ID
								and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
								and b.SEQ = a.SEQ
								and b.OPERATION_GROUP = a.OPERATION_GROUP
								and b.ITEM_ID = a.ITEM_ID
								and b.CELL_ITEM_ID = a.CELL_ITEM_ID 
								and b.MEASURE = 'INV'
								and substring(b.SEQ_FLAG,2,1) = '6' )
			and a.OPERATION_GROUP <> 'A'
			and a.OPERATION_GROUP <> 'E'
			and a.measure <> 'MKT_FCST'
			and isnull(a.plant_id,'') > '0'
			-- 2. A : PUR
			UNION ALL
			SELECT   DISTINCT a.DIVISION_ID
					,a.COMPANY_ID
					,a.PLANT_ID
					,a.PLAN_START_YYYYMMDD
					,'1' AS SEQ 
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
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0 AS QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
			FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			where not exists (  select 'y' 
								from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
								where b.DIVISION_ID = a.DIVISION_ID
								and b.COMPANY_ID = a.COMPANY_ID   
								and b.PLANT_ID = a.PLANT_ID
								and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
								and b.SEQ = a.SEQ
								and b.OPERATION_GROUP = a.OPERATION_GROUP
								and b.value_type = 'PUR'
								and b.CELL_ITEM_ID = a.CELL_ITEM_ID 
								and b.ITEM_ID = a.ITEM_ID
								and b.MEASURE = 'INV'
								and b.SEQ_FLAG = '370'
								)
			and a.OPERATION_GROUP = 'A' 
			and a.measure <> 'MKT_FCST'
			and isnull(a.plant_id,'') > '0'
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
					,@V_PLAN_START_YYYYMMDD AS YYYYMMDD
					,0 AS QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
			FROM #TMP_SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 
			where not exists (  select 'y' 
								from #TMP_SCP_ANL_PSI_INTEGRATION_ESS b 
								where b.DIVISION_ID = a.DIVISION_ID
								and b.COMPANY_ID = a.COMPANY_ID   
								and b.PLANT_ID = a.PLANT_ID
								and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
								and b.SEQ = a.SEQ
								and b.OPERATION_GROUP = a.OPERATION_GROUP
								and b.value_type = 'PRD'
								and b.CELL_ITEM_ID = a.CELL_ITEM_ID 
								and b.ITEM_ID = a.ITEM_ID
								and b.MEASURE = 'INV'
								and b.SEQ_FLAG = '380'
								)
			and a.OPERATION_GROUP = 'A' 
			and a.measure <> 'MKT_FCST'
			and isnull(a.plant_id,'') > '0'

            -- 재고 없는 경우 첫날 재고 0으로 생성 완료

			-------------------------------------------------------------------------------------------------------------                         
			-- 전극 중 ESS 용 전극이 아닌 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산
			------------------------------------------------------------------------------------------------------------- 
			DELETE #tmp_SCP_ANL_PSI_INTEGRATION_ESS
			where 1=1
			and operation_group = 'E'
			and item_id NOT IN (select distinct item_id from scp_mst_final_item  WITH(NOLOCK)   
									where FLOW_ID like 'E2000%'
									and cell_item_id like 'EC%'
								   ) 

            SET @V_STATUS_DESC = 'Delete';

			DELETE A 
			FROM SCP_ANL_PSI_INTEGRATION_ESS A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
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
					,MEASURE
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
				
			select   DIVISION_ID
					,ISNULL(COMPANY_ID,'-')
					,ISNULL(PLANT_ID,'-')
					,PLAN_START_YYYYMMDD
					,1 AS SEQ
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
					,ISNULL(INCOTERMS,'-')
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


		------------------------------------------------------------
		-- 선입선출 처리 -> BOH 를 제외한 '-'/'PRD'/'PUR' 일자별 재고 계산 : START
		------------------------------------------------------------
		-- 1. 선입선출 처리
		--로직 추가 

		BEGIN  

			-------------------------------------------------------------------------------------------------------------                         
			-- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
			-------------------------------------------------------------------------------------------------------------                   
			IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE') IS NOT NULL                        
				DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE   

			IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED') IS NOT NULL                        
				DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED   

			IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO') IS NOT NULL                        
				DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO    

			CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE(                        
						DIVISION_ID             NVARCHAR(10)    NULL,
						COMPANY_ID			    NVARCHAR(10)    NULL,
						PLANT_ID			    NVARCHAR(10)	NULL,
						PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
						CELL_ITEM_ID            NVARCHAR(40)    NULL,       
						ITEM_ID                 NVARCHAR(40)    NULL,
						MEASURE                 NVARCHAR(40)    NULL,
						VALUE_TYPE				NVARCHAR(10)    NULL,
						TO_PRODUCT				NVARCHAR(100)   NULL,
						SEQ_FLAG				NVARCHAR(5)     NULL,
						YYYYMMDD			    NVARCHAR(8)     NULL,
						QTY			            NUMERIC(20, 10) NULL,   
						PRIORITY				INT				NULL,
						END_FLAG				NVARCHAR(1)     DEFAULT 'N'   -- 'Y'/'N'
			)       
			  

			CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED(                        
						DIVISION_ID             NVARCHAR(10)    NULL,
						COMPANY_ID			    NVARCHAR(10)    NULL,
						PLANT_ID			    NVARCHAR(10)	NULL,
						PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
						CELL_ITEM_ID            NVARCHAR(40)    NULL,       
						ITEM_ID                 NVARCHAR(40)    NULL,
						MEASURE                 NVARCHAR(40)    NULL,
						VALUE_TYPE				NVARCHAR(10)    NULL,
						TO_PRODUCT				NVARCHAR(100)   NULL,
						SEQ_FLAG				NVARCHAR(5)     NULL,
						YYYYMMDD			    NVARCHAR(8)     NULL,
						QTY			            NUMERIC(20, 10) NULL,   
						PRIORITY				INT				NULL,
						END_FLAG				NVARCHAR(1)     DEFAULT 'N'   -- 'Y'/'N'
			)       


			CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO(                        
						DIVISION_ID             NVARCHAR(10)    NULL,
						COMPANY_ID			    NVARCHAR(10)    NULL,
						PLANT_ID			    NVARCHAR(10)	NULL,
						PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
						CELL_ITEM_ID            NVARCHAR(40)    NULL,       
						ITEM_ID                 NVARCHAR(40)    NULL,
						MEASURE                 NVARCHAR(40)    NULL,
						VALUE_TYPE				NVARCHAR(10)    NULL,
						TO_PRODUCT				NVARCHAR(100)   NULL,
						SEQ_FLAG				NVARCHAR(5)     NULL,
						YYYYMMDD			    NVARCHAR(8)     NULL,
						QTY			            NUMERIC(20, 10) NULL,   
						REMAIN_QTY	            NUMERIC(20, 10) NULL,   
						PRIORITY				INT				NULL,
						END_FLAG				NVARCHAR(1)     DEFAULT 'N'   -- 'Y'/'N'
			)       


--- ep lookup 반영 대상 여기까지 start

			------ 선입선출 기초(SHIP_PLAN) 데이터 생성 START -------------	

			-- 선입선출 'IN_HOUSE_MOVING' 데이터 생성
			insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE
			select  DIVISION_ID, 
					COMPANY_ID,
					PLANT_ID,
					PLAN_START_YYYYMMDD,
					CELL_ITEM_ID,
					ITEM_ID,
					'IN_HOUSE_MOVING' AS MEASURE,
					--(case when TO_PRODUCT = 'EP059290P5F1' then 'PUR'
					--	  when TO_PRODUCT = 'EP059290P5FA' then 'PRD'
					--	  END)	as VALUE_TYPE,
					B.SEGMENT2 as VALUE_TYPE,
					TO_PRODUCT,
					'321' AS SEQ_FLAG,
					YYYYMMDD,
					isnull(sum(isnull(QTY,0)),0) AS QTY,
					--(case when TO_PRODUCT = 'EP059290P5F1' then 1
					--	  when TO_PRODUCT = 'EP059290P5FA' then 2
					--	  END)	as PRIORITY,
					(case when B.SEGMENT2 = 'PUR' then 1
						  else 2
						  END) as PRIORITY,
					'N'
			from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock) 
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					on b.SEGMENT1 = a.TO_PRODUCT
					AND B.VALID_YN = 'Y'
					and b.LOOKUP_TYPE = 'EPPACK_FIFO_ITEM'
			where DIVISION_ID = @V_DIVISION_ID 
			AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
			and seq_flag in ('330')
			and qty <> 0
			--and TO_PRODUCT in ('EP059290P5F1','EP059290P5FA')
			group by	DIVISION_ID, 
						COMPANY_ID,
						PLANT_ID,
						PLAN_START_YYYYMMDD,
						CELL_ITEM_ID,
						ITEM_ID,
						B.SEGMENT2,
						TO_PRODUCT,
						YYYYMMDD


			
			insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE
			select  DIVISION_ID, 
					COMPANY_ID,
					PLANT_ID,
					PLAN_START_YYYYMMDD,
					CELL_ITEM_ID,
					ITEM_ID,
					'SHIP_PLAN' AS MEASURE,
					'PRD' AS VALUE_TYPE,
					TO_PRODUCT,
					'321' AS SEQ_FLAG,
					YYYYMMDD,
					isnull(sum(isnull(QTY,0)),0) AS QTY,
					3,
					'N'
			from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
			where DIVISION_ID = @V_DIVISION_ID 
			AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
			and seq_flag in ('310','320')
			and qty <> 0
			group by	DIVISION_ID, 
						COMPANY_ID,
						PLANT_ID,
						PLAN_START_YYYYMMDD,
						CELL_ITEM_ID,
						ITEM_ID,
						VALUE_TYPE,
						TO_PRODUCT,
						YYYYMMDD


			-- 선입선출 'IN_HOUSE_MOVING' 데이터 생성
			insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED
			select  DIVISION_ID, 
					COMPANY_ID,
					PLANT_ID,
					PLAN_START_YYYYMMDD,
					CELL_ITEM_ID,
					ITEM_ID,
					'IN_HOUSE_MOVING' AS MEASURE,
					VALUE_TYPE,
					TO_PRODUCT,
					'331' AS SEQ_FLAG,
					YYYYMMDD,
					isnull(sum(isnull(QTY,0)),0) AS QTY,
					1,
					'N'
			from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock) 
			where DIVISION_ID = @V_DIVISION_ID 
			AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
			and seq_flag in ('330')
			--and TO_PRODUCT not in ('EP059290P5F1','EP059290P5FA')
			and TO_PRODUCT not in (select SEGMENT1 
									from SCM_ADM_LOOKUP_MASTER_DETAIL b
									where b.LOOKUP_TYPE = 'EPPACK_FIFO_ITEM'
									and B.VALID_YN = 'Y' )
			and qty <> 0
			group by	DIVISION_ID, 
						COMPANY_ID,
						PLANT_ID,
						PLAN_START_YYYYMMDD,
						CELL_ITEM_ID,
						ITEM_ID,
						VALUE_TYPE,
						TO_PRODUCT,
						YYYYMMDD

--PRD, PUR 생성

			insert into SCP_ANL_PSI_INTEGRATION_ESS
					(DIVISION_ID
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
					,LAST_UPDATE_DATE)
			select  a.DIVISION_ID
					,a.COMPANY_ID
					,a.PLANT_ID
					,a.PLAN_START_YYYYMMDD
					,a.SEQ
					,a.OPERATION_GROUP
					,a.FROM_SITE
					,a.CELL_ITEM_ID
					,a.ITEM_ID
					,a.MEASURE
					--,(CASE WHEN a.TO_PRODUCT = 'EP059290P5F1' THEN 'PUR' -- 331
					--	   WHEN a.TO_PRODUCT = 'EP059290P5FA' THEN 'PRD' -- 332
					--	   END) AS	 VALUE_TYPE
					,B.SEGMENT2 as VALUE_TYPE
					,a.TO_PRODUCT
					,a.LINE_ID
					,a.BOH_QTY
					,a.TO_SITE
					,a.INCOTERMS
					--,(CASE WHEN a.TO_PRODUCT = 'EP059290P5F1' THEN '331'  -- PUR
					--	   WHEN a.TO_PRODUCT = 'EP059290P5FA' THEN '332'  -- PRD
					--	   END) AS	 SEQ_FLAG
					,(case when B.SEGMENT2 = 'PUR' then '331'
						   else '332'
						   END) as SEQ_FLAG
					,a.YYYYMMDD
					,ISNULL(SUM(ISNULL(a.QTY,0)),0) AS QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
			from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock) 
			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
					on b.SEGMENT1 = a.TO_PRODUCT
					AND B.VALID_YN = 'Y'
					and b.LOOKUP_TYPE = 'EPPACK_FIFO_ITEM'
			where DIVISION_ID = @V_DIVISION_ID  --'82'
			AND a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD  --'20240624'
			and a.seq_flag in ('330')
			--and a.TO_PRODUCT in ('EP059290P5F1','EP059290P5FA')
			and a.qty <> 0
			group by	a.DIVISION_ID
					,a.COMPANY_ID
					,a.PLANT_ID
					,a.PLAN_START_YYYYMMDD
					,a.SEQ
					,a.OPERATION_GROUP
					,a.FROM_SITE
					,a.CELL_ITEM_ID
					,a.ITEM_ID
					,a.MEASURE
					,B.SEGMENT2
--					,a.VALUE_TYPE
					,a.TO_PRODUCT
					,a.LINE_ID
					,a.BOH_QTY
					,a.TO_SITE
					,a.INCOTERMS
					,b.SEGMENT2
					,a.YYYYMMDD

--- ep lookup 반영 대상 여기까지 end

			-- 이하 선입선출 재고 생성 START
			--'SEMI_WH_IN' 생성

			-- PUR 재고 생성
			insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO
			select  h.DIVISION_ID, 
							h.COMPANY_ID,
							h.PLANT_ID,
							h.PLAN_START_YYYYMMDD,
							h.CELL_ITEM_ID,
							h.ITEM_ID,
							h.MEASURE,
							h.VALUE_TYPE,
							h.TO_PRODUCT,
							h.SEQ_FLAG,
							h.YYYYMMDD,
							sum(QTY) AS QTY,
							sum(QTY) AS REMAIN_QTY,
							h.PRIORITY,
							h.END_FLAG

			from 
					(select  DIVISION_ID, 
							COMPANY_ID,
							PLANT_ID,
							PLAN_START_YYYYMMDD,
							CELL_ITEM_ID,
							ITEM_ID,
							'SEMI_WH_IN' AS MEASURE,
							'PUR' AS VALUE_TYPE,
							'-' as TO_PRODUCT,
							'341' AS SEQ_FLAG,
							YYYYMMDD,
							isnull(QTY,0) AS QTY,
							isnull(QTY,0) AS REMAIN_QTY,
							2 as PRIORITY,
							'N' as END_FLAG
					from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
					where DIVISION_ID = @V_DIVISION_ID 
					AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
					and seq_flag in ('340')
					and qty <> 0
					union all
					select  DIVISION_ID, 
							COMPANY_ID,
							PLANT_ID,
							PLAN_START_YYYYMMDD,
							CELL_ITEM_ID,
							ITEM_ID,
							'SEMI_WH_IN' AS MEASURE,
							'PUR' AS VALUE_TYPE,
							'-' as TO_PRODUCT,
							'341' AS SEQ_FLAG,
							YYYYMMDD,
							isnull(BOH_QTY,0) AS QTY,
							isnull(BOH_QTY,0) AS REMAIN_QTY,
							2  as PRIORITY,
							'N' as END_FLAG
					-- select * 
					from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
					where DIVISION_ID = @V_DIVISION_ID 
					AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
					and seq_flag in ('370')
					AND a.YYYYMMDD = @V_PLAN_START_YYYYMMDD
					and BOH_qty <> 0
					) h
			group by	h.DIVISION_ID, 
							h.COMPANY_ID,
							h.PLANT_ID,
							h.PLAN_START_YYYYMMDD,
							h.CELL_ITEM_ID,
							h.ITEM_ID,
							h.MEASURE,
							h.VALUE_TYPE,
							h.TO_PRODUCT,
							h.SEQ_FLAG,
							h.YYYYMMDD,
							h.PRIORITY,
							h.END_FLAG

			-- PRD 재고 생성
			insert into #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO  
			select  h.DIVISION_ID, 
							h.COMPANY_ID,
							h.PLANT_ID,
							h.PLAN_START_YYYYMMDD,
							h.CELL_ITEM_ID,
							h.ITEM_ID,
							h.MEASURE,
							h.VALUE_TYPE,
							h.TO_PRODUCT,
							h.SEQ_FLAG,
							h.YYYYMMDD,
							sum(QTY) AS QTY,
							sum(QTY) AS REMAIN_QTY,
							h.PRIORITY,
							h.END_FLAG

			from 
					(select  DIVISION_ID, 
							COMPANY_ID,
							PLANT_ID,
							PLAN_START_YYYYMMDD,
							CELL_ITEM_ID,
							ITEM_ID,
							'PROD_PLAN' AS MEASURE,
							'PRD' AS VALUE_TYPE,
							'-' as TO_PRODUCT,
							'351' AS SEQ_FLAG,
							YYYYMMDD,
							isnull(QTY,0) AS QTY,
							isnull(QTY,0) AS REMAIN_QTY,
							1 as PRIORITY,
							'N' as END_FLAG
					from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
					where DIVISION_ID = @V_DIVISION_ID 
					AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
					and seq_flag in ('350')
					and qty <> 0
					union all
					select  DIVISION_ID, 
							COMPANY_ID,
							PLANT_ID,
							PLAN_START_YYYYMMDD,
							CELL_ITEM_ID,
							ITEM_ID,
							'PROD_PLAN' AS MEASURE,
							'PRD' AS VALUE_TYPE,
							'-' as TO_PRODUCT,
							'351' AS SEQ_FLAG,
							YYYYMMDD,
							isnull(BOH_QTY,0) AS QTY,
							isnull(BOH_QTY,0) AS REMAIN_QTY,
							1  as PRIORITY,
							'N' as END_FLAG
					from SCP_ANL_PSI_INTEGRATION_ESS a with(nolock)
					where DIVISION_ID = @V_DIVISION_ID 
					AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
					and seq_flag in ('380')
					AND a.YYYYMMDD = @V_PLAN_START_YYYYMMDD
					and BOH_qty <> 0
					) h
			group by	h.DIVISION_ID, 
							h.COMPANY_ID,
							h.PLANT_ID,
							h.PLAN_START_YYYYMMDD,
							h.CELL_ITEM_ID,
							h.ITEM_ID,
							h.MEASURE,
							h.VALUE_TYPE,
							h.TO_PRODUCT,
							h.SEQ_FLAG,
							h.YYYYMMDD,
							h.PRIORITY,
							h.END_FLAG

			--  jego 생성 END


---============== EP 반영 START

			----------------------------------------------
			-- 할당 대상 정보 Cursor
			----------------------------------------------

			DECLARE @C_EP_DIVISION_ID          NVARCHAR(10)
			DECLARE @C_EP_COMPANY_ID		    NVARCHAR(10)
			DECLARE @C_EP_PLANT_ID			    NVARCHAR(10)
			DECLARE @C_EP_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @C_EP_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @C_EP_ITEM_ID              NVARCHAR(40)
			DECLARE @C_EP_VALUE_TYPE			NVARCHAR(10)
			DECLARE @C_EP_MAX_YYYYMMDD			NVARCHAR(8)

			DECLARE @C_EP_QTY			        NUMERIC(20, 10)
			DECLARE @C_EP_REMAIN_QTY	        NUMERIC(20, 10)

			-- from 빈강 to 남경 계산 START

			DECLARE @MIN_EP_YYYYMMDD  NVARCHAR(8)
			DECLARE @MAX_EP_YYYYMMDD  NVARCHAR(8)
			DECLARE @PROC_EP_YYYYMMDD NVARCHAR(8)
			DECLARE @JEGO_EP_QTY         NUMERIC(20, 10)

			set @MIN_EP_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			-- Need(필요) 수량 Cursor  
			DECLARE CUR_EP_ALLOC CURSOR FOR

					SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, VALUE_TYPE, max(YYYYMMDD) as max_yyyymmdd, 0  --, sum(QTY), sum(QTY)-- sum(QTY) 는 확정(PRD/PUR)
					FROM  #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE WITH(NOLOCK)  
					group by DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, VALUE_TYPE   --, YYYYMMDD

			OPEN CUR_EP_ALLOC;
			FETCH NEXT FROM CUR_EP_ALLOC INTO @C_EP_DIVISION_ID, @C_EP_COMPANY_ID, @C_EP_PLANT_ID, @C_EP_PLAN_START_YYYYMMDD, @C_EP_CELL_ITEM_ID, @C_EP_ITEM_ID, @C_EP_VALUE_TYPE, @C_EP_MAX_YYYYMMDD, @C_EP_REMAIN_QTY   --@C_EP_YYYYMMDD, @C_EP_QTY, @C_EP_REMAIN_QTY

			WHILE (@@FETCH_STATUS = 0)
			BEGIN

						SET @PROC_EP_YYYYMMDD = @C_EP_max_yyyymmdd

						DECLARE @I_EP INT = 1

						WHILE (@PROC_EP_YYYYMMDD >= @MIN_EP_YYYYMMDD)
						BEGIN

							IF (@I_EP > 1000)
							BEGIN
								BREAK
							END	

							select @C_EP_QTY = isnull(a.QTY,0)   -- NEED
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE A WITH(NOLOCK)  
							WHERE DIVISION_ID = @C_EP_DIVISION_ID
							AND COMPANY_ID = @C_EP_COMPANY_ID
							AND PLANT_ID = @C_EP_PLANT_ID
							AND PLAN_START_YYYYMMDD = @C_EP_PLAN_START_YYYYMMDD
							AND CELL_ITEM_ID = @C_EP_CELL_ITEM_ID
							AND ITEM_ID = @C_EP_ITEM_ID
							AND VALUE_TYPE = @C_EP_VALUE_TYPE
							AND YYYYMMDD = @PROC_EP_YYYYMMDD

							select @JEGO_EP_QTY = isnull(a.REMAIN_QTY,0)   -- JEGO
							FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
							WHERE DIVISION_ID = @C_EP_DIVISION_ID
							AND COMPANY_ID = @C_EP_COMPANY_ID
							AND PLANT_ID = @C_EP_PLANT_ID
							AND PLAN_START_YYYYMMDD = @C_EP_PLAN_START_YYYYMMDD
							AND CELL_ITEM_ID = @C_EP_CELL_ITEM_ID
							AND ITEM_ID = @C_EP_ITEM_ID
							AND VALUE_TYPE = @C_EP_VALUE_TYPE
							AND YYYYMMDD = @PROC_EP_YYYYMMDD


							SET @C_EP_REMAIN_QTY = isnull(@JEGO_EP_QTY,0) - isnull(@C_EP_QTY,0) + isnull(@C_EP_REMAIN_QTY,0)


							if @C_EP_REMAIN_QTY > 0
							begin				   
								IF ( @C_EP_REMAIN_QTY <> isnull(@JEGO_EP_QTY,0) )
								BEGIN
									UPDATE A SET REMAIN_QTY = @C_EP_REMAIN_QTY
									FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
									WHERE DIVISION_ID = @C_EP_DIVISION_ID
									AND COMPANY_ID = @C_EP_COMPANY_ID
									AND PLANT_ID = @C_EP_PLANT_ID
									AND PLAN_START_YYYYMMDD = @C_EP_PLAN_START_YYYYMMDD
									AND CELL_ITEM_ID = @C_EP_CELL_ITEM_ID
									AND ITEM_ID = @C_EP_ITEM_ID
									AND VALUE_TYPE = @C_EP_VALUE_TYPE
									AND YYYYMMDD = @PROC_EP_YYYYMMDD
								END

								SET @C_EP_REMAIN_QTY = 0

							end
							else
							begin
									if exists ( select 'Y' 
												FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
												WHERE DIVISION_ID = @C_EP_DIVISION_ID
												AND COMPANY_ID = @C_EP_COMPANY_ID
												AND PLANT_ID = @C_EP_PLANT_ID
												AND PLAN_START_YYYYMMDD = @C_EP_PLAN_START_YYYYMMDD
												AND CELL_ITEM_ID = @C_EP_CELL_ITEM_ID
												AND ITEM_ID = @C_EP_ITEM_ID
												AND VALUE_TYPE = @C_EP_VALUE_TYPE
												AND YYYYMMDD = @PROC_EP_YYYYMMDD )
									begin
										UPDATE A SET REMAIN_QTY = 0, END_FLAG = 'Y'
										FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
										WHERE DIVISION_ID = @C_EP_DIVISION_ID
										AND COMPANY_ID = @C_EP_COMPANY_ID
										AND PLANT_ID = @C_EP_PLANT_ID
										AND PLAN_START_YYYYMMDD = @C_EP_PLAN_START_YYYYMMDD
										AND CELL_ITEM_ID = @C_EP_CELL_ITEM_ID
										AND ITEM_ID = @C_EP_ITEM_ID
										AND VALUE_TYPE = @C_EP_VALUE_TYPE
										AND YYYYMMDD = @PROC_EP_YYYYMMDD
									end
									
								-- 없음 : set @C_EP_REMAIN_QTY = 0
							end

							SET @JEGO_EP_QTY = 0
							SET @C_EP_QTY = 0
							SET @I_EP = @I_EP + 1

							SET @PROC_EP_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(D, -1, @PROC_EP_YYYYMMDD),112)
						END  -- WHILE (@PROC_BINGANG_YYYYMMDD >= @MIN_BINGANG_YYYYMMDD) 문 END.

				FETCH NEXT FROM CUR_EP_ALLOC INTO @C_EP_DIVISION_ID, @C_EP_COMPANY_ID, @C_EP_PLANT_ID, @C_EP_PLAN_START_YYYYMMDD, @C_EP_CELL_ITEM_ID, @C_EP_ITEM_ID, @C_EP_VALUE_TYPE, @C_EP_MAX_YYYYMMDD, @C_EP_REMAIN_QTY  --  --, @C_EP_YYYYMMDD, @C_EP_QTY, @C_EP_REMAIN_QTY
			END -- OPEN CUR_BinGang_ALLOC;

			CLOSE CUR_EP_ALLOC;
			DEALLOCATE CUR_EP_ALLOC;

---=============  EP 반영 END

			----------------------------------------------
			-- 할당 대상 정보 Cursor
			----------------------------------------------

			DECLARE @C_DIVISION_ID          NVARCHAR(10)
			DECLARE @C_COMPANY_ID		    NVARCHAR(10)
			DECLARE @C_PLANT_ID			    NVARCHAR(10)
			DECLARE @C_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @C_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @C_ITEM_ID              NVARCHAR(40)
			DECLARE @C_MEASURE              NVARCHAR(40)
			DECLARE @C_VALUE_TYPE			NVARCHAR(10)
			DECLARE @C_TO_PRODUCT			NVARCHAR(100)
			DECLARE @C_SEQ_FLAG				NVARCHAR(5)
			DECLARE @C_YYYYMMDD			    NVARCHAR(8)
			DECLARE @C_QTY			        NUMERIC(20, 10)
			DECLARE @C_PRIORITY				INT
			DECLARE @C_END_FLAG				NVARCHAR(1)
			DECLARE @C_IN_HOUSE_MOVING_PRD_QTY NUMERIC(20, 10)
			DECLARE @C_IN_HOUSE_MOVING_PUR_QTY NUMERIC(20, 10)


			DECLARE @C2_DIVISION_ID         NVARCHAR(10)
			DECLARE @C2_COMPANY_ID		    NVARCHAR(10)
			DECLARE @C2_PLANT_ID			 NVARCHAR(10)
			DECLARE @C2_PLAN_START_YYYYMMDD  NVARCHAR(8)
			DECLARE @C2_CELL_ITEM_ID         NVARCHAR(40)
			DECLARE @C2_ITEM_ID              NVARCHAR(40)
			DECLARE @C2_MEASURE              NVARCHAR(40)
			DECLARE @C2_VALUE_TYPE			NVARCHAR(10)
			DECLARE @C2_TO_PRODUCT			NVARCHAR(100)
			DECLARE @C2_SEQ_FLAG			NVARCHAR(5)
			DECLARE @C2_YYYYMMDD			NVARCHAR(8)
			DECLARE @C2_QTY			        NUMERIC(20, 10)
			DECLARE @C2_REMAIN_QTY	        NUMERIC(20, 10)
			DECLARE @C2_PRIORITY			INT
			DECLARE @C2_END_FLAG			NVARCHAR(1)

			-- Need(필요) 수량 Cursor
			DECLARE CUR_ALLOC CURSOR FOR

				  SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, SEQ_FLAG, YYYYMMDD, QTY, PRIORITY, END_FLAG, 0, 0
				  FROM  #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED WITH(NOLOCK)  
				  WHERE END_FLAG = 'N'
				  ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID, YYYYMMDD, PRIORITY, TO_PRODUCT

			OPEN CUR_ALLOC;
			FETCH NEXT FROM CUR_ALLOC INTO @C_DIVISION_ID, @C_COMPANY_ID, @C_PLANT_ID, @C_PLAN_START_YYYYMMDD, @C_CELL_ITEM_ID, @C_ITEM_ID, @C_MEASURE, @C_VALUE_TYPE, @C_TO_PRODUCT, @C_SEQ_FLAG, @C_YYYYMMDD, @C_QTY, @C_PRIORITY, @C_END_FLAG, @C_IN_HOUSE_MOVING_PRD_QTY, @C_IN_HOUSE_MOVING_PUR_QTY;

		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN
	  
			----------------------------------------
			-- 할당 처리 : START
			----------------------------------------
			-- JEGO (재고) 수량 Cursor
			DECLARE CUR_ALLOC_ITEM CURSOR FOR

				  SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, SEQ_FLAG, YYYYMMDD, QTY, REMAIN_QTY, PRIORITY, END_FLAG
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO WITH(NOLOCK)  
				  WHERE DIVISION_ID = @C_DIVISION_ID
				  and END_FLAG = 'N'
				  AND PLANT_ID = @C_PLANT_ID
				  AND PLAN_START_YYYYMMDD = @C_PLAN_START_YYYYMMDD
				  AND ITEM_ID = @C_ITEM_ID
				  AND REMAIN_QTY > 0
				  ORDER BY DIVISION_ID, PLANT_ID, ITEM_ID, YYYYMMDD, PRIORITY, TO_PRODUCT
		  
			OPEN CUR_ALLOC_ITEM;
			FETCH NEXT FROM CUR_ALLOC_ITEM INTO @C2_DIVISION_ID, @C2_COMPANY_ID, @C2_PLANT_ID, @C2_PLAN_START_YYYYMMDD, @C2_CELL_ITEM_ID, @C2_ITEM_ID, @C2_MEASURE, @C2_VALUE_TYPE, @C2_TO_PRODUCT, @C2_SEQ_FLAG, @C2_YYYYMMDD, @C2_QTY, @C2_REMAIN_QTY, @C2_PRIORITY, @C2_END_FLAG ;
		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN


				-- IN-HOUSE-MOVING 처리 START 			

				IF @C_MEASURE =  'IN_HOUSE_MOVING'
					BEGIN
						IF @C_QTY > @C2_REMAIN_QTY   
						BEGIN

							  UPDATE A SET REMAIN_QTY = 0, END_FLAG = 'Y'
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  IF @C2_VALUE_TYPE = 'PRD'
							  BEGIN
							     SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C2_REMAIN_QTY
							  END
							  ELSE 
							  BEGIN
 								 SET @C_IN_HOUSE_MOVING_PUR_QTY = @C_IN_HOUSE_MOVING_PUR_QTY + @C2_REMAIN_QTY
							  END
						
							  set @C_QTY = @C_QTY - @C2_REMAIN_QTY

						END
						else if @C_QTY <= @C2_REMAIN_QTY   
						BEGIN
							  IF @C2_VALUE_TYPE = 'PRD'   
							  BEGIN
							     SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C_QTY
 							  END
							  ELSE 
							  BEGIN
 								 SET @C_IN_HOUSE_MOVING_PUR_QTY = @C_IN_HOUSE_MOVING_PUR_QTY + @C_QTY
							  END

							  set @C2_REMAIN_QTY = @C2_REMAIN_QTY - @C_QTY
							  set @C_QTY = 0

							  UPDATE A SET REMAIN_QTY = @C2_REMAIN_QTY , END_FLAG = (case when @C2_REMAIN_QTY > 0 then 'N' else 'Y' end)
							  FROM #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO A WITH(NOLOCK)  
							  WHERE DIVISION_ID = @C2_DIVISION_ID
							  AND COMPANY_ID = @C2_COMPANY_ID
							  AND PLANT_ID = @C2_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C2_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C2_CELL_ITEM_ID
							  AND ITEM_ID = @C2_ITEM_ID
							  AND MEASURE = @C2_MEASURE
							  AND VALUE_TYPE = @C2_VALUE_TYPE
							  AND TO_PRODUCT = @C2_TO_PRODUCT
							  AND SEQ_FLAG = @C2_SEQ_FLAG
							  AND YYYYMMDD = @C2_YYYYMMDD
							  AND PRIORITY = @C2_PRIORITY

							  UPDATE A SET END_FLAG = 'Y'
							  FROM  #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED A WITH(NOLOCK)  
							  WHERE DIVISION_ID = @C_DIVISION_ID
							  AND COMPANY_ID = @C_COMPANY_ID
							  AND PLANT_ID = @C_PLANT_ID
							  AND PLAN_START_YYYYMMDD = @C_PLAN_START_YYYYMMDD
							  AND CELL_ITEM_ID = @C_CELL_ITEM_ID
							  AND ITEM_ID = @C_ITEM_ID
							  AND MEASURE = @C_MEASURE
							  AND VALUE_TYPE = @C_VALUE_TYPE
							  AND TO_PRODUCT = @C_TO_PRODUCT
							  AND SEQ_FLAG = @C_SEQ_FLAG
							  AND YYYYMMDD = @C_YYYYMMDD
							  AND PRIORITY = @C_PRIORITY

							  IF @C_IN_HOUSE_MOVING_PRD_QTY <> 0    
							  BEGIN
									 INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
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
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PRD' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											'-'  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'332'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PRD_QTY as QTY,
											'SCP (ESS..)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS..)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

								IF @C_IN_HOUSE_MOVING_PUR_QTY <> 0    
							    BEGIN

									  INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
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
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PUR' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											'-'  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'331'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PUR_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END
							  break

						END	  -- else if @C_QTY <= @C2_REMAIN_QTY 의 END  ('IN_HOUSE_MOVING')

				END   -- 'IN_HOUSE_MOVING' END

			-- IN-HOUSE-MOVING 처리 END  

	 			FETCH NEXT FROM CUR_ALLOC_ITEM INTO  @C2_DIVISION_ID, @C2_COMPANY_ID, @C2_PLANT_ID, @C2_PLAN_START_YYYYMMDD, @C2_CELL_ITEM_ID, @C2_ITEM_ID, @C2_MEASURE, @C2_VALUE_TYPE, @C2_TO_PRODUCT, @C2_SEQ_FLAG, @C2_YYYYMMDD, @C2_QTY, @C2_REMAIN_QTY, @C2_PRIORITY, @C2_END_FLAG ;
			END -- OPEN CUR_ALLOC_ITEM;
		
			CLOSE CUR_ALLOC_ITEM;
			DEALLOCATE CUR_ALLOC_ITEM;
			----------------------------------------
			-- 할당 처리 : END
			----------------------------------------

			if ( @C_QTY > 0 AND @C_MEASURE = 'IN_HOUSE_MOVING' )
			begin
				SET @C_IN_HOUSE_MOVING_PRD_QTY = @C_IN_HOUSE_MOVING_PRD_QTY + @C_QTY
			
							  IF @C_IN_HOUSE_MOVING_PRD_QTY <> 0    
							  BEGIN
									 INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
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
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PRD' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											'-'  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'332'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PRD_QTY as QTY,
											'SCP (ESS.)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS.)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

								IF @C_IN_HOUSE_MOVING_PUR_QTY <> 0    
							    BEGIN

									  INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
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
											QTY,
											CREATED_BY,
											CREATION_DATE,
											LAST_UPDATED_BY,
											LAST_UPDATE_DATE
										 )
									 SELECT @C_DIVISION_ID AS DIVISION_ID,
											@C_COMPANY_ID AS COMPANY_ID,
											@C_PLANT_ID AS plant_id,
											@C_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD,
											1 AS SEQ, 
											'A' as operation_group, 
											'-' as FROM_SITE,  
											@C_CELL_ITEM_ID as CELL_ITEM_ID,  
											@C_ITEM_ID AS ITEM_ID,
											@C_MEASURE as MEASURE,
											'PUR' as value_type,
											@C_TO_PRODUCT as TO_PRODUCT,
											'-'  as LINE_ID,   
											0 as BOH_QTY,
											'-' as TO_SITE,
											'-' as incoterms,
											'331'  as SEQ_FLAG,  
											@C_YYYYMMDD as YYYYMMDD,
											@C_IN_HOUSE_MOVING_PUR_QTY as QTY,
											'SCP (ESS)BATCH' AS CREATED_BY,
											GETDATE() AS CREATION_DATE,
											'SCP (ESS)BATCH' AS LAST_UPDATED_BY,
											GETDATE() AS LAST_UPDATE_DATE
								END

			end

	 		FETCH NEXT FROM CUR_ALLOC INTO  @C_DIVISION_ID, @C_COMPANY_ID, @C_PLANT_ID, @C_PLAN_START_YYYYMMDD, @C_CELL_ITEM_ID, @C_ITEM_ID, @C_MEASURE, @C_VALUE_TYPE, @C_TO_PRODUCT, @C_SEQ_FLAG, @C_YYYYMMDD, @C_QTY, @C_PRIORITY, @C_END_FLAG,@C_IN_HOUSE_MOVING_PRD_QTY, @C_IN_HOUSE_MOVING_PUR_QTY;
		END -- OPEN CUR_ALLOC;
		
		CLOSE CUR_ALLOC;
		DEALLOCATE CUR_ALLOC;

		drop table #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED_PRE
		drop table #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_NEED
		drop table #tmp_SCP_ANL_PSI_INTEGRATION_FIFO_JEGO

	END 


	--  선입 선출 반영 END 

/*
		UPDATE A SET BOH_QTY = round(isnull(BOH_QTY,0),0),
					 QTY     = round(isnull(QTY,0),0)
		FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
		where a.DIVISION_ID = @V_DIVISION_ID
		and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
*/

	--  재고 반영 start 
	--  1. 첫번째 날짜의 재고(QTY) 반영(360 제외) + PUR(370) + PRD(380)
	--  2. 두번째 날짜부터 마지막 날짜까지 재고 생성.
	--  3. PUR(370) + PRD(380)를 합친 360 재고 생성.

			DECLARE @MIN_YYYYMMDD  NVARCHAR(8)
			DECLARE @MAX_YYYYMMDD  NVARCHAR(8)
			DECLARE @PRE_YYYYMMDD  NVARCHAR(8)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)

			SELECT @MIN_YYYYMMDD = @V_PLAN_START_YYYYMMDD

			select @MAX_YYYYMMDD = @V_HORIZON_END_YYYYMMDD

			SET @PROC_YYYYMMDD = @MIN_YYYYMMDD

			DECLARE @I INT = 0

			WHILE (@PROC_YYYYMMDD <= @MAX_YYYYMMDD)
			BEGIN
				IF (@I > 1000)
				BEGIN
					BREAK
				END	

				IF ( @PROC_YYYYMMDD = @MIN_YYYYMMDD )
				BEGIN
					-- 첫번째 날짜의 재고(QTY) 반영
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' and substring(b.SEQ_FLAG,2,1) = '6' THEN  b.BOH_QTY
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
												and B.SEQ_FLAG not in ('360') 
												and b.YYYYMMDD = a.YYYYMMDD ),0)
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
					where a.measure = 'INV'
					and substring(a.SEQ_FLAG,2,1) = '6'
					and a.SEQ_FLAG not in ('360')  
					and a.YYYYMMDD=@PROC_YYYYMMDD
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'


					-- 첫번째 날짜의 재고(QTY) 반영 :  370('PUR')
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' and b.SEQ_FLAG in ('370') THEN  b.BOH_QTY   -- '370' : PUR
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' and b.SEQ_FLAG in ('331')  THEN  b.QTY * -1    -- '331': PUR
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																END) QTY
												FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
												and B.SEQ_FLAG not in ('330','380') -- '330':IN_HOUSE_MOVING
												and b.YYYYMMDD = a.YYYYMMDD ),0)
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.SEQ_FLAG in ('370')  -- 370('PUR')
					and a.YYYYMMDD=@PROC_YYYYMMDD
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'


					-- 첫번째 날짜의 재고(QTY) 반영 : 380('PRD')
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' and b.SEQ_FLAG in ('380') THEN  b.BOH_QTY  -- '380' : PRD
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' and b.SEQ_FLAG in ('332')  THEN  b.QTY * -1  -- '332': PRD
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
												and B.SEQ_FLAG not in ('330','370') -- '330':IN_HOUSE_MOVING
												and b.YYYYMMDD = a.YYYYMMDD ),0)
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.SEQ_FLAG in ('380')  
					and a.YYYYMMDD=@PROC_YYYYMMDD
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'

				END  
				ELSE 
				BEGIN  -- 두번째 날짜부터 마지막 날짜까지 재고 생성.

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
							,1 AS SEQ 
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
							,@PROC_YYYYMMDD AS YYYYMMDD
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE  WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																		 WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																		 WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																		 END) QTY
															FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
															and b.YYYYMMDD = @PROC_YYYYMMDD
															),0) AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
					where a.measure = 'INV'
					and substring(a.SEQ_FLAG,2,1) = '6'
					and a.SEQ_FLAG not in ('360')  
					and a.YYYYMMDD=@PRE_YYYYMMDD 
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'
					
					UNION ALL
					
					SELECT   distinct a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,1 AS SEQ 
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PUR' as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,a.BOH_QTY AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'370' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'IN_HOUSE_MOVING' and b.SEQ_FLAG in ('331')  THEN  b.QTY * -1    -- '331': PUR
																		WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																		END) QTY
															FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
															and B.SEQ_FLAG not in ('330','380') 
															and b.YYYYMMDD = @PROC_YYYYMMDD
															),0) AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
					where a.measure = 'INV'
					and a.SEQ_FLAG in ('370')  
					and a.YYYYMMDD=@PRE_YYYYMMDD 
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'
					
					UNION ALL
					
					SELECT   distinct a.DIVISION_ID
							,a.COMPANY_ID
							,a.PLANT_ID
							,a.PLAN_START_YYYYMMDD
							,1 AS SEQ 
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'PRD' as value_type
							,'-' as TO_PRODUCT
							,'-' AS LINE_ID
							,a.BOH_QTY AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,'380' as seq_flag
							,@PROC_YYYYMMDD AS YYYYMMDD
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'IN_HOUSE_MOVING' and b.SEQ_FLAG in ('332')  THEN  b.QTY * -1  -- '332': PRD
																		WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																		WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																		WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																		END) QTY
															FROM SCP_ANL_PSI_INTEGRATION_ESS B WITH(NOLOCK)
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
															and B.SEQ_FLAG not in ('330','370') -- '330':IN_HOUSE_MOVING
															and b.YYYYMMDD = @PROC_YYYYMMDD
															),0) AS QTY
							,'SCP (ESS)BATCH' AS CREATED_BY
							,GETDATE() AS CREATION_DATE
							,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
							,GETDATE() AS LAST_UPDATE_DATE
					FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK)
					where a.measure = 'INV'
					and a.SEQ_FLAG in ('380')  
					and a.YYYYMMDD=@PRE_YYYYMMDD 
					and a.DIVISION_ID = @V_DIVISION_ID
					and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
					AND a.OPERATION_GROUP <> 'E'
				END -- 두번째날 ~ 마지막날까지의 재고 수량(QTY) 반영 END 

				SET @I = @I + 1

				SET @PRE_YYYYMMDD = @PROC_YYYYMMDD
				SET @PROC_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(D, 1, @PROC_YYYYMMDD),112)

			END  -- WHILE (@PROC_YYYYMMDD <= @MAX_YYYYMMDD) 문 END.

            ------------------------------------------------------------
			-- Cell BOH SUM : VALUE_TYPE  :  PRD + PUR = '-'
            ------------------------------------------------------------

			--  INV ('370 + '380')로 (360) 만듦

			INSERT INTO SCP_ANL_PSI_INTEGRATION_ESS
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
						QTY,
						CREATED_BY,
						CREATION_DATE,
						LAST_UPDATED_BY,
						LAST_UPDATE_DATE
					)
			SELECT   a.division_id as DIVISION_ID
					,a.company_id
					,a.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,1 AS SEQ 
					,'A' as operation_group 
					,'-'  AS FROM_SITE
					,CELL_ITEM_ID as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as value_type
					,'-' as TO_PRODUCT
					,'-' as LINE_ID
					,isnull(sum(isnull(A.BOH_QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'360' as SEQ_FLAG
					,YYYYMMDD AS YYYYMMDD
					,isnull(sum(isnull(A.QTY,0)),0)   AS QTY
					,'SCP (ESS)BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP (ESS)BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
			FROM SCP_ANL_PSI_INTEGRATION_ESS A WITH(NOLOCK)
			WHERE SEQ_FLAG IN ('370','380')
			and a.DIVISION_ID = @V_DIVISION_ID
			and a.PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD
			group by a.division_id
					,a.company_id
					,a.plant_id
					,CELL_ITEM_ID
					,A.ITEM_ID 
					,YYYYMMDD

			--  재고 반영 end  

			------------------------------------------------------------
			-- 선입선출 처리 -> BOH 를 제외한 '-'/'PRD'/'PUR' 일자별 재고 계산 : END
			------------------------------------------------------------
	
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
			where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  
			AND a.DIVISION_ID = @V_DIVISION_ID  
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
			FROM SCP_ANL_PSI_INTEGRATION_ESS a WITH(NOLOCK) 			
		    INNER JOIN (SELECT basis_yyyymm, max(BASIS_YYYYMMDD) yyyymmdd
                          FROM SCM_SYS_CALENDAR_M    C WITH(NOLOCK)                 
                         WHERE 1=1              
                           AND C.BASIS_YYYYMMDD >= @V_PLAN_START_YYYYMMDD 
						   AND C.BASIS_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD 
						 GROUP BY basis_yyyymm
						) cal
            ON a.YYYYMMDD = cal.YYYYMMDD
			where plan_start_yyyymmdd = @V_PLAN_START_YYYYMMDD  
			AND a.DIVISION_ID = @V_DIVISION_ID  
			AND a.MEASURE = 'INV'
		

			-- 월 통합 PSI에 ESS 사업부 반영.
			delete a
			from SCP_ANL_PSI_INTEGRATION a
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			AND a.DIVISION_ID			= @V_DIVISION_ID  


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
					    --,isnull(BOH_QTY,0) BOH_QTY
					,round(isnull(BOH_QTY,0),0) BOH_QTY
					,TO_SITE
					,INCOTERMS
					,SEQ_FLAG
					,a.YYYYMM AS YYYYMM 
					--,isnull(QTY,0) as QTY
					,round(isnull(QTY,0),0) as QTY
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
		SET @v_description  = @V_STATUS_DESC + N'  ERROR_LINE : ' + STR(ERROR_LINE()) + ':' + @V_DIVISION_ID ;                        
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
--    SET @v_description  = N'['+@V_DIVISION_ID+']['+@V_PLAN_START_YYYYMMDD+'][' + @v_exec_time + ']';       
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



