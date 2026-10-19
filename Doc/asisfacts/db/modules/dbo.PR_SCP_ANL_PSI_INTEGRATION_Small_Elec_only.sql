

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
 * Description  : 재료비 TASK                      
 * OutTable     : SCP_ANL_PSI_INTEGRATION                     
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
                       @p_division_id         = '40'
                     , @p_plan_start_yyyymmdd = '20240923'
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.10.25     lgjjg        Initial. PJ20248928 LGES 재료비 Task SCP 소형사업부 확산 및 고도화.
 * 2025.02.12     hrkim        cell/전극 plant 매핑 로직 수정
 *								- 1순위 : division, company, plant 정보로 매핑
 *								- 2순위 : division, company, city, country 정보로 매핑 
 *								- 3순위 : division, company 정보로 매핑 
 *								- 4순위 : company 정보로 매핑 
 * 2025.03.13   hrkim          PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *								- 빈월 수량 0 데이터 생성 반영 
 *								- 비대상 measure : MKT_FCST, SHIP_PLAN_RTF
 *								- plan 시작월 부터 lookup 설정한 개월수 만큼만 (lookup type : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD) 
 *								- attribute2 : PLAN_TYPE
 *								- attribute3 : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD lookup 설정 값 
 *
 *******************************************************************************************************************/                    

-- exec PR_SCP_ANL_PSI_INTEGRATION_Small_Elec_only '40', '20250106'

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_INTEGRATION_Small_Elec_only]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_INTEGRATION_Small_Elec_only';                        
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

			print  convert(varchar(30), getdate(), 121) + N' @V_PLAN_START_YYYYMMDD		: ' + CONVERT(nvarchar(100), @V_PLAN_START_YYYYMMDD	)
			print  convert(varchar(30), getdate(), 121) + N' @V_PLAN_TYPE				: ' + CONVERT(nvarchar(100), @V_PLAN_TYPE           )
			print  convert(varchar(30), getdate(), 121) + N' @V_PLAN_SEQ				: ' + CONVERT(nvarchar(100), @V_PLAN_SEQ			)
			print  convert(varchar(30), getdate(), 121) + N' @V_HORIZON_END_YYYYMMDD	: ' + CONVERT(nvarchar(100), @V_HORIZON_END_YYYYMMDD)
			print  convert(varchar(30), getdate(), 121) + N' @V_MASTER_ID				: ' + CONVERT(nvarchar(100), @V_MASTER_ID			)
			print  convert(varchar(30), getdate(), 121) + N' @V_ENG_PLAN_ID				: ' + CONVERT(nvarchar(100), @V_ENG_PLAN_ID			)
			print  convert(varchar(30), getdate(), 121) + N' @V_EE_DIVISION_ID			: ' + CONVERT(nvarchar(100), @V_EE_DIVISION_ID			)
			print  convert(varchar(30), getdate(), 121) + N' @V_EE_ENG_PLAN_ID			: ' + CONVERT(nvarchar(100), @V_EE_ENG_PLAN_ID			)

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N' 전극 plant 사이트 정보 추출 - #elec_plant' 
			-- 2025.02.12 cell/전극 plant 매핑 로직 수정 
			-- 1순위 : division, company, plant 정보로 매핑
			-- 2순위 : division, company, city, country 정보로 매핑 
			-- 3순위 : division, company 정보로 매핑 
			-- 4순위 : company 정보로 매핑 
			------------------------------------------------------------------------------------------------------------------
			if object_id('tempdb..#elec_plant') is not null drop table #elec_plant;

			select es.company_id
				 , es.division_id
				 , isnull(es.city	,'Z')	as city
				 , isnull(es.country,'Z')	as country
				 , es.plant_id
				 , es.site_description
				 , es.scm_site_id
				 , es.site_id
				 , row_number() over (partition by	  es.company_id
													, es.division_id
													, es.plant_id
										  order by	 es.plant_id)	as elec_plant_priority_1st
				 , row_number() over (partition by	  es.company_id
													, es.division_id
													, isnull(es.city	,'Z')
													, isnull(es.country,'Z')
										  order by	 es.plant_id)	as elec_plant_priority_2nd
				 , row_number() over (partition by	  es.company_id
													, es.division_id
										  order by	 es.plant_id)	as elec_plant_priority_3RD
 				 , row_number() over (partition by	  es.company_id
										  order by	 es.plant_id)	as elec_plant_priority_4TH
			 into #elec_plant
			 from scm_mst_site es with(nolock)
			where 1=1
			  and es.valid_yn			= 'Y'
			  and es.operation_group	= 'E'	-- 전극 Plant 
			  and es.site_type			= 'PLANT'

          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------   
          IF OBJECT_ID('tempdb..#tmp_psi_integration_inv') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_inv     
			  
          IF OBJECT_ID('tempdb..#tmp_psi_integration_ccc') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_ccc                         
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY 			  


           CREATE TABLE #tmp_PSI_INTEGRATION_INV(                        
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

           CREATE TABLE #tmp_PSI_INTEGRATION_CCC(                        
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
   
                        
           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY(                        
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
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_01 on #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY(item_id)
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_02 on #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY(YYYYMM, item_id)


			/****************************************************
			EE 재고('560')를 #tmp_psi_integration_inv 에 추가로 insert 해야함.
			****************************************************/

            SET @V_STATUS_DESC = '6.BOH EE';

			INSERT INTO #tmp_psi_integration_inv
			SELECT   @V_DIVISION_ID 
					,'-' AS COMPANY_ID
					,'-' AS PLANT_ID
					,A.SCM_SITE_ID  AS FROM_SITE
					,A.ELEC_ITEM_ID AS ITEM_ID                                 
					,@V_PLAN_START_YYYYMMDD  AS YYYYMMDD
					,ISNULL(SUM(CASE  WHEN A.LVL IS NULL THEN isnull(SCM_QTY,0)
									  WHEN A.LVL = '4'   THEN isnull(SCM_QTY,0)
									  WHEN A.LVL = '3'   THEN isnull(l1_qty,0)
									  WHEN A.LVL = '2'   THEN isnull(l2_qty,0)
									  WHEN A.LVL = '1'   THEN isnull(l3_qty,0)
									  END),0) AS QTY
					,(CASE WHEN A.stock_type = 'INTRANSIT' THEN 'INT'
						   ELSE 'WH'
						   END ) AS DESCR
					,'-' as attribute8, 'E2000' FLOW_ID, 'E' as OPERATION_GROUP		
			from SCP_XLS_PSI_GLOBAL_ELECTRODE_BOM A with (nolock)		
--			from SCP_ANL_PSI_INTEGRATION_ELEC_BOM_ACCUM A with (nolock)		--
			WHERE DIVISION_ID = @V_DIVISION_ID  -- '81'  --
--			AND PLAN_TYPE = @V_EE_PLAN_TYPE  -- 'FN'  --
			AND PLAN_ID = SUBSTRING(@V_EE_ENG_PLAN_ID, 1, CHARINDEX('::', @V_EE_ENG_PLAN_ID)-1)  -- '1348'  -- 
			GROUP BY A.SCM_SITE_ID
					,A.ELEC_ITEM_ID                                 
					,(CASE WHEN A.stock_type = 'INTRANSIT' THEN 'INT'
						   ELSE 'WH'
						   END )


			-- 재고의 COMPANY_ID, PLANT_ID 반영.
			update a set company_id = b.company_id, 
						 plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group IN ('A','P') and										  
-- 1,2,3순위 조건 추가(2024.12.31) start
												exists (select 'y' 
														from scm_mst_site x with(nolock) 
														where x.site_type = 'PLANT' 
														and x.valid_yn = 'Y'  
														and x.company_id = b.company_id  
														and x.division_id = b.division_id
														and x.plant_id = b.plant_id
														and x.operation_group = 'E')   ) THEN 	(select top 1 plant_id 
																								 from scm_mst_site k with(nolock) 
																								 where k.site_type = 'PLANT' 
																								 and k.valid_yn = 'Y' 
																								 and k.company_id = b.company_id 
																								 and k.division_id = b.division_id 
																								 and k.plant_id = b.plant_id
																								 and k.operation_group = 'E' ) 

										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group IN ('A','P') 
												and e2.plant_id is not null)				 THEN e2.plant_id		-- 2025.02.12  cell/전극 plant 매핑 로직 수정 : 2순위 참조 케이스 추가 (division, company, city, country정보로 매핑) 
																						 
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group IN ('A','P') and
												exists (select 'y' 
														from scm_mst_site x with(nolock) 
														where x.site_type = 'PLANT' 
														and x.valid_yn = 'Y'  
														and x.company_id = b.company_id  
														and x.division_id = b.division_id
														and x.operation_group = 'E')   ) THEN 	(select top 1 plant_id 
																								 from scm_mst_site k with(nolock) 
																								 where k.site_type = 'PLANT' 
																								 and k.valid_yn = 'Y' 
																								 and k.company_id = b.company_id 
																								 and k.division_id = b.division_id 
																								 and k.operation_group = 'E' ) 

										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group IN ('A','P') ) 
										                                                 THEN 	(select top 1 plant_id 
																								 from scm_mst_site k with(nolock) 
																								 where k.site_type = 'PLANT' 
																								 and k.valid_yn = 'Y' 
																								 and k.company_id = b.company_id 
																								 and k.operation_group = 'E' ) 
-- 1,2,3순위 조건 추가(2024.12.31) end

										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv a  
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = a.from_site	
			  left join #elec_plant  e2		-- 2025.02.12  cell/전극 plant 매핑 로직 수정 
					 on e2.elec_plant_priority_2nd = 1
					and e2.division_id	= b.division_id
					and e2.company_id	= b.company_id
					and e2.city			= isnull(b.city,'Z')
					and e2.country		= isnull(b.country,'Z')


--1번(추가) : 가장 빠른 WH_IN이 있는 Plant
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv a
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
															and m.measure = 'WH_IN' )  --WH_IN을 봄
										and k.measure = 'WH_IN') --WH_IN
			where isnull(a.plant_id,'-') < '0'


--2번(기존)
			update a set	company_id = b.company_id,
							plant_id = (case when  b.SITE_TYPE = 'SALES' then '-'  --a.TO_SITE
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N') THEN b.PLANT_ID
										  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'Y') THEN b.logistic_plant_id
										  else '-'
										  end )
			FROM #tmp_psi_integration_inv a
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
			FROM #tmp_psi_integration_inv a
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
			FROM #tmp_psi_integration_inv a
			left outer join scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = (select top 1 from_site from #tmp_PSI_INTEGRATION_INV k
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
			FROM #tmp_psi_integration_inv a
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


          SET @V_STATUS_DESC = '6.BOH inv E';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
					,1 AS SEQ 
					,'E' as operation_group 
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
					,'560' as SEQ_FLAG
					--,convert(nvarchar(6),getdate(),112)
					,substring(@V_PLAN_START_YYYYMMDD,1,6) AS YYYYMM
					,0 QTY
			FROM #tmp_psi_integration_inv A WITH(NOLOCK)
			WHERE a.operation_group = 'E'         
			group by a.division_id
					,a.company_id
					,a.plant_id
					,a.ITEM_ID 


            SET @V_STATUS_DESC = '0.  MKT_FCST EE';	 

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    1.Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------
          SET @V_STATUS_DESC = '1.Ship. Plan(RTF) EE';	 	  

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
         SELECT @V_DIVISION_ID, 
				B.COMPANY_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
				a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'E' as operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID,  
	            a.FROM_ITEM_ID AS item_id,
	            'SHIP_PLAN_RTF' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
					  when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
					  else '-'
					  end ) as TO_SITE,
				'-' as INCOTERMS,
				'510'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(a.ALLOCATION_QTY,0)),0) as QTY
			FROM SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			inner join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID  
				 and b.SCM_SITE_ID = a.plant_site_id
			inner join scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = @V_DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE   
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND a.operation_group = 'E'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by 
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
					left(a.YYYYMMDD,6) 

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    2.Ship. Plan(Semi)
          ------------------------------------------------------------------------------------------------------------- 

            SET @V_STATUS_DESC = '2.Ship. Plan(Semi) EE';	 
			
			insert into #tmp_PSI_INTEGRATION_CCC
	        SELECT  a.DIVISION_ID,
					a.ORIGIN_FROM_DIVISION_ID,
					A.ORIGIN_TO_DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ) as PLANT_ID,
					to_plant_id = (case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								        when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N' and
-- 1,2,3순위 조건 추가(2024.12.31) start
												exists (select 'y' 
														from scm_mst_site ss with(nolock) 
														where ss.site_type = 'PLANT' 
														and ss.valid_yn = 'Y'  
														and ss.company_id = x.company_id  
														and ss.division_id = x.division_id
														and ss.plant_id = x.plant_id
														and ss.operation_group = 'E')   ) THEN 	(select top 1 plant_id       -- 이부분을 그냥 x.plant_id 라고 해도 됨.  
																								 from scm_mst_site k with(nolock) 
																								 where k.site_type = 'PLANT' 
																								 and k.valid_yn = 'Y' 
																								 and k.company_id = x.company_id 
																								 and k.division_id = x.division_id 
																								 and k.plant_id = x.plant_id
																								 and k.operation_group = 'E' ) 

										when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N' 
												and e2.plant_id is not null	)			  THEN e2.plant_id		-- 2025.02.12  cell/전극 plant 매핑 로직 수정 : 2순위 참조 케이스 추가 (division, company, city, country정보로 매핑) 

										when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N' and
												exists (select 'y' 
														from scm_mst_site ss with(nolock) 
														where ss.site_type = 'PLANT' 
														and ss.valid_yn = 'Y'  
														and ss.company_id = x.company_id  
														and ss.division_id = x.division_id
														and ss.operation_group = 'E')   ) THEN 	(select top 1 plant_id 
																									from scm_mst_site k with(nolock) 
																									where k.site_type = 'PLANT' 
																									and k.valid_yn = 'Y' 
																									and k.company_id = x.company_id 
																									and k.division_id = x.division_id 
																									and k.operation_group = 'E' ) 

										when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'N' ) 
																						 THEN 	(select top 1 plant_id 
																								from scm_mst_site k with(nolock) 
																								where k.site_type = 'PLANT' 
																								and k.valid_yn = 'Y' 
																								and k.company_id = x.company_id 
																								and k.operation_group = 'E' ) 
-- 1,2,3순위 조건 추가(2024.12.31) end
									  when (x.SITE_TYPE = 'PLANT' and x.osp_yn= 'Y') THEN x.logistic_plant_id
									  else '-'
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					1 AS SEQ,
					'E' as operation_group,
					a.FROM_SITE,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else '-'
									  end ) AS TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM scp_anl_shipment_plan_semi a WITH(NOLOCK)
			left join scm_mst_site b WITH(NOLOCK)
				 on b.SCM_SITE_ID = a.FROM_SITE
			left join scm_mst_site x WITH(NOLOCK)
				 on x.SCM_SITE_ID = a.to_SITE
			left join scp_mst_bod_n_v c with(nolock)
				  on c.division_id = @V_DIVISION_ID
				  and c.bod_id = a.bod_id 
			left join #elec_plant  e2		-- 2025.02.12  cell/전극 plant 매핑 로직 수정 
				   on e2.elec_plant_priority_2nd = 1
				  and e2.division_id	= x.division_id
				  and e2.company_id		= x.company_id
				  and e2.city			= isnull(x.city,'Z')
				  and e2.country		= isnull(x.country,'Z')
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND (a.ORIGIN_FROM_DIVISION_ID = @V_DIVISION_ID or a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID)
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'E'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD

          SET @V_STATUS_DESC = '2.Ship. Plan(Semi) EE 520';	 

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
         SELECT ORIGIN_FROM_DIVISION_ID AS DIVISION_ID,
				COMPANY_ID,
				PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'E' as operation_group,
				'-' as FROM_SITE,
                '-' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id as TO_SITE,  
				INCOTERMS,
				'520'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_ccc a WITH(NOLOCK)
			where a.COMPANY_ID <> a.to_COMPANY_ID
			and a.ORIGIN_FROM_DIVISION_ID = @V_DIVISION_ID --'81'
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by ORIGIN_FROM_DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 to_plant_id,
					 INCOTERMS,
					 left(a.arrival_YYYYMMDD,6)

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    4.Semi WH-IN
          ------------------------------------------------------------------------------------------------------------- 
          SET @V_STATUS_DESC = '4.Semi WH-IN  EE';	

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
         SELECT ORIGIN_TO_DIVISION_ID AS DIVISION_ID,
				to_COMPANY_ID AS COMPANY_ID,
				to_plant_id AS PLANT_ID,
	            PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'E' as operation_group,
				'-' AS FROM_SITE,
                '-' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
	            '-' AS TO_SITE,  
				'-' AS INCOTERMS,
				'540'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_ccc a WITH(NOLOCK)
			where a.COMPANY_ID <> a.to_COMPANY_ID
			and a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID 
			and a.arrival_YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by ORIGIN_TO_DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 ITEM_ID,
					 TO_SITE,
					 left(a.arrival_YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  
            SET @V_STATUS_DESC = '3.IN_HOUSE_MOVING  EE';


			
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
				  (  DIVISION_ID
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
           SELECT    a.DIVISION_ID
					,a.COMPANY_ID
					,a.PLANT_ID 
					,a.PLAN_START_YYYYMMDD
					,a.SEQ
					,a.OPERATION_GROUP 
					,a.FROM_SITE
					,a.CELL_ITEM_ID
					,a.ITEM_ID
					,a.MEASURE
					,a.VALUE_TYPE
					,a.TO_PRODUCT
					,a.LINE_ID
					,a.BOH_QTY
					,a.TO_SITE
					,a.INCOTERMS
					,a.SEQ_FLAG
					,a.YYYYMM
					,a.QTY
					,a.CREATED_BY
					,a.CREATION_DATE
					,a.LAST_UPDATED_BY
					,a.LAST_UPDATE_DATE
			--select TOP 100 *
			FROM SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.SEQ					= '1' 
			  AND a.DIVISION_ID			= @V_DIVISION_ID  
			  and a.SEQ_FLAG = '530'  



          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  
          SET @V_STATUS_DESC = '5.PROD_PLAN  EE';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
         SELECT @V_DIVISION_ID,
				b.COMPANY_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            1 AS SEQ,
				'E' as operation_group,
				'-' AS FROM_SITE,
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-' as value_type,
				'-' as TO_PRODUCT,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as INCOTERMS,
				'550'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM scp_anl_production_plan a WITH(NOLOCK)
			INNER JOIN scp_mst_final_item fi with(nolock)
				 ON fi.operation_group = 'E'
				 and fi.cell_item_id NOT like 'EC%'
				 and fi.division_id = @V_DIVISION_ID
				 AND fi.item_id = a.item_id
			inner join scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID  
				 and b.SCM_SITE_ID = a.SCM_SITE_ID
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND a.measure = 'PROD_PLAN_AMEND' 
			  AND a.operation_group = 'E'
			  AND A.ORIGIN_DIVISION_ID = @V_DIVISION_ID
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by b.COMPANY_ID,
					(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
						  else  b.PLANT_ID
						  end ),
				     a.PLAN_START_YYYYMMDD,
					 a.ITEM_ID,
					 a.LINE_ID,
					 left(a.YYYYMMDD,6)


--소숫점 없애기

update a set BOH_QTY = round(isnull(BOH_QTY,0),0),
			 QTY     = round(isnull(QTY,0),0)
from #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY a



-- 월_INVentory 생성 START 

            SET @V_STATUS_DESC = 'INV';
			DECLARE @MIN_YYYYMM NVARCHAR(6)
			DECLARE @MAX_YYYYMM NVARCHAR(6)
			DECLARE @PRE_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)

			SELECT @MIN_YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)

			SELECT @MAX_YYYYMM = substring(@V_HORIZON_END_YYYYMMDD,1,6)

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
					insert into #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY b 
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


					-- 첫번째 월의 재고(QTY) 반영
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN b.MEASURE = 'INV' THEN  b.BOH_QTY
																WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  b.QTY * -1
																WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  b.QTY * -1
																WHEN b.MEASURE = 'SEMI_WH_IN' THEN  b.QTY
																WHEN b.MEASURE = 'PROD_PLAN' THEN  b.QTY
																END) QTY
												FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY B WITH(NOLOCK)
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
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.YYYYMM=@PROC_YYYYMM

				END  
				ELSE -- 두번째 월부터 마지막 월까지 재고 생성.
				BEGIN

					insert into #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
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
															FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY B WITH(NOLOCK)
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
					FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY a WITH(NOLOCK)
					where a.measure = 'INV'
					and a.YYYYMM=@PRE_YYYYMM 
				END

				SET @I = @I + 1

				SET @PROC_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(M, 1, @PROC_YYYYMMDD),112)
				SET @PRE_YYYYMM = @PROC_YYYYMM
				SET @PROC_YYYYMM = LEFT(@PROC_YYYYMMDD,6)

			END 

			-------------------------------------------------------------------------------------------------------------                         
			-- ESS 용 전극 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산
			------------------------------------------------------------------------------------------------------------- 
			DELETE #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
			where 1=1
			and operation_group = 'E'
			and item_id IN (select distinct item_id from scp_mst_final_item  WITH(NOLOCK)   
									where division_id = @V_DIVISION_ID
									and FLOW_ID like 'E2000%'
									and cell_item_id like 'EC%'
								   ) 

	----------------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 2025.03.013  Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 
	print  convert(varchar(30), getdate(), 121) + N'Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영' 
	----------------------------------------------------------------------------------------------------------------------------------------------------------

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'빈월 0 채우기 대상 기간 정보' 
			------------------------------------------------------------------------------------------------------------------
			DECLARE @V_FILL_0_TARGET_PERIOD				INTEGER		= -1;					
			DECLARE @V_FILL_0_TARGET_PERIOD_END_YYYYMM	NVARCHAR(6)	= SUBSTRING(@V_HORIZON_END_YYYYMMDD, 1, 6) ;   

			SELECT TOP 1 @V_FILL_0_TARGET_PERIOD			= L.SEGMENT1
						,@V_FILL_0_TARGET_PERIOD_END_YYYYMM = CASE  WHEN CONVERT(INTEGER, L.SEGMENT1) > 0 
																	THEN CONVERT(NVARCHAR(6), EOMONTH(DATEADD(MONTH, CONVERT(INTEGER, L.SEGMENT1)-1, @V_PLAN_START_DATE)), 112) 
																	ELSE @V_FILL_0_TARGET_PERIOD_END_YYYYMM
															  END 
			 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			WHERE 1=1
			  AND L.LOOKUP_TYPE = 'INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD' -- ESS 선입선출 선점 차감 기간 (0 채우기 대상 기간 - 개월수)
			  AND L.VALID_YN = 'Y'
			  AND ISNULL(L.SEGMENT1, 0) IS NOT NULL
			  AND ISNUMERIC(L.SEGMENT1) = 1 
			ORDER BY L.LAST_UPDATE_DATE DESC 

			IF @V_FILL_0_TARGET_PERIOD_END_YYYYMM > SUBSTRING(@V_HORIZON_END_YYYYMMDD, 1, 6) 
				BEGIN
					SET @V_FILL_0_TARGET_PERIOD_END_YYYYMM = SUBSTRING(@V_HORIZON_END_YYYYMMDD, 1, 6);
				 END

			print  convert(varchar(30), getdate(), 121) + N'@V_FILL_0_TARGET_PERIOD : ' + converT(nvarchar(10), @V_FILL_0_TARGET_PERIOD, 112) ;
			print  convert(varchar(30), getdate(), 121) + N'@V_FILL_0_TARGET_PERIOD_END_YYYYMM : ' + @V_FILL_0_TARGET_PERIOD_END_YYYYMM	;

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'빈월 0 채우기 대상 기간 월 목록' 
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#MM_LIST') IS NOT NULL DROP TABLE #MM_LIST
			SELECT DISTINCT YYYYMM
			 INTO #MM_LIST
			 FROM SCM_MST_BUCKET B WITH(NOLOCK)
			WHERE 1=1
			  AND B.YYYYMM BETWEEN @V_PLAN_START_YYYYMM 
							   AND @V_FILL_0_TARGET_PERIOD_END_YYYYMM 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'빈월 0 채우기 대상 Measure' 
			-- 대상 measure : PROD_PLAN , SHIP_PLAN_SEMI
			------------------------------------------------------------------------------------------------------------------
			IF OBJECT_ID('TEMPDB..#TARGET_MM_0') IS NOT NULL DROP TABLE #TARGET_MM_0
			SELECT T.DIVISION_ID
				  ,T.COMPANY_ID
				  ,T.PLANT_ID
				  ,T.PLAN_START_YYYYMMDD
				  ,T.SEQ
				  ,T.OPERATION_GROUP
				  ,T.FROM_SITE
				  ,T.CELL_ITEM_ID
				  ,T.ITEM_ID
				  ,T.MEASURE
				  ,T.VALUE_TYPE
				  ,T.TO_PRODUCT
				  ,T.LINE_ID
				  ,T.BOH_QTY
				  ,T.TO_SITE
				  ,T.INCOTERMS
				  ,T.SEQ_FLAG
				  ,M.YYYYMM
				  ,ISNULL(MAX(CASE WHEN T.YYYYMM = M.YYYYMM THEN T.QTY ELSE NULL END),0)	AS QTY	-- 재고를 제외하고 음수가 없기 떄문에 MAX처리 문제 없음 ?!
				  ,MAX(T.ATTRIBUTE1)														AS ATTRIBUTE1
			 INTO #TARGET_MM_0
			 FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY T
				  INNER JOIN #MM_LIST M 
						  ON 1=1
			WHERE 1=1
			  AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV') 
			  AND T.YYYYMM BETWEEN @V_PLAN_START_YYYYMM 
							   AND @V_FILL_0_TARGET_PERIOD_END_YYYYMM
			GROUP BY T.DIVISION_ID
					,T.COMPANY_ID
					,T.PLANT_ID
					,T.PLAN_START_YYYYMMDD
					,T.SEQ
					,T.OPERATION_GROUP
					,T.FROM_SITE
					,T.CELL_ITEM_ID
					,T.ITEM_ID
					,T.MEASURE
					,T.VALUE_TYPE
					,T.TO_PRODUCT
					,T.LINE_ID
					,T.BOH_QTY
					,T.TO_SITE
					,T.INCOTERMS
					,T.SEQ_FLAG
					,M.YYYYMM

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'빈월 0 채우기 대상 Measure - 채우기 전 데이터 삭제 (해당 기간)' 
			------------------------------------------------------------------------------------------------------------------
			DELETE T  
			FROM #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY T
			WHERE 1=1
			  AND T.YYYYMM BETWEEN @V_PLAN_START_YYYYMM 
							   AND @V_FILL_0_TARGET_PERIOD_END_YYYYMM
			  AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV') 

			------------------------------------------------------------------------------------------------------------------
			print  convert(varchar(30), getdate(), 121) + N'빈월 0 채우기 대상 Measure - 0 채운 데이터 Insert - Start ' 
			------------------------------------------------------------------------------------------------------------------
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY (
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
				  ,ATTRIBUTE1) 
			SELECT T.DIVISION_ID
				  ,T.COMPANY_ID
				  ,T.PLANT_ID
				  ,T.PLAN_START_YYYYMMDD
				  ,T.SEQ
				  ,T.OPERATION_GROUP
				  ,T.FROM_SITE
				  ,T.CELL_ITEM_ID
				  ,T.ITEM_ID
				  ,T.MEASURE
				  ,T.VALUE_TYPE
				  ,T.TO_PRODUCT
				  ,T.LINE_ID
				  ,T.BOH_QTY
				  ,T.TO_SITE
				  ,T.INCOTERMS
				  ,T.SEQ_FLAG
				  ,T.YYYYMM
				  ,T.QTY
				  ,T.ATTRIBUTE1
			 FROM #TARGET_MM_0 T

	----------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 2025.03.013  End   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 
	print  convert(varchar(30), getdate(), 121) + N'End	 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영'  
	----------------------------------------------------------------------------------------------------------------------------------------------------------

			-------------------------------------------------------------------------------------------------------------                         
			-- 이전 동일 수행건 삭제 후 수행내역 Insert
			-- 삭제 & insert   
			------------------------------------------------------------------------------------------------------------- 
            SET @V_STATUS_DESC = 'Delete';


			DELETE A 
			FROM SCP_ANL_PSI_INTEGRATION A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.DIVISION_ID			= @V_DIVISION_ID
			and a.seq_flag in ('500','510','520','540','550','560')


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
					--,BOH_QTY
					--,isnull(sum(isnull(BOH_QTY,0)),0) as BOH_QTY
					,ROUND(isnull(sum(isnull(BOH_QTY,0)),0),0) as BOH_QTY
					,TO_SITE
					,ISNULL(INCOTERMS,'-')
					,SEQ_FLAG
					,YYYYMM
					--,QTY
					--,isnull(sum(isnull(QTY,0)),0) as QTY
					,ROUND(isnull(sum(isnull(QTY,0)),0),0) as QTY
					,'SCP BATCH' AS CREATED_BY
					,GETDATE() AS CREATION_DATE
					,'SCP BATCH' AS LAST_UPDATED_BY
					,GETDATE() AS LAST_UPDATE_DATE
					,'' AS ATTRIBUTE1
					,@V_PLAN_TYPE									AS	ATTRIBUTE2	-- 2025.03.13 수정 
					,CONVERT(NVARCHAR(30), @V_FILL_0_TARGET_PERIOD) AS	ATTRIBUTE3	-- 2025.03.13 수정 
					,'' AS ATTRIBUTE4
					,'' AS ATTRIBUTE5
					,'' AS ATTRIBUTE6
					,'' AS ATTRIBUTE7
					,'' AS ATTRIBUTE8
					,'' AS ATTRIBUTE9
					,'' AS ATTRIBUTE10
			from #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY a  WITH(NOLOCK) 
			where a.seq_flag in ('500','510','520','540','550','560')
			group by DIVISION_ID, ISNULL(COMPANY_ID,'-'), ISNULL(PLANT_ID,'-'), PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, a.YYYYMM

		
			drop table #tmp_SCP_ANL_PSI_INTEGRATION_ELEC_ONLY
			drop table #tmp_psi_integration_inv
			drop table #tmp_psi_integration_ccc

			if object_id('tempdb..#elec_plant') is not null drop table #elec_plant;
			if object_id('tempdb..#cell_elec_plant_mapping') is not null drop table #cell_elec_plant_mapping;
			IF OBJECT_ID('TEMPDB..#MM_LIST') IS NOT NULL DROP TABLE #MM_LIST
			IF OBJECT_ID('TEMPDB..#TARGET_MM_0') IS NOT NULL DROP TABLE #TARGET_MM_0

            
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



