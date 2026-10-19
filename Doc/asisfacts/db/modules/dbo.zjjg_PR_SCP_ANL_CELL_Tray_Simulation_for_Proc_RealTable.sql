

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_CELL_Tray_Simulation                        
 * Description  : 회수 포장재                      
 * OutTable     : SCP_ANL_CELL_Tray_Simulation_Weekly                     
 * Execute      : 
                  EXEC PR_SCP_ANL_CELL_Tray_Simulation
                       @p_division_id         = '82'
                     , @p_plan_start_yyyymmdd = '20240624'
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.09.11                  Initial 회수 포장재
 *******************************************************************************************************************/                    

-- 운영 DB Link : select * from [10.34.221.78,7433].lgce_scmprod.dbo.[SCM_MST_SITE_item]  with(nolock)

-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82',	  '20240902', 'FN'

CREATE PROCEDURE [dbo].[zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable]
(                         
      @p_division_id          NVARCHAR(30)            
     ,@p_plan_start_yyyymmdd  NVARCHAR(8) 
	 ,@p_PLAN_TYPE			  NVARCHAR(2) = NULL   
)                         
AS                        
  BEGIN 


  
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;                        
    SET NOCOUNT ON;                        
    SET XACT_ABORT ON;                        
    SET ANSI_WARNINGS ON;                        
                        
    -- LOG 용 변수 설정                        
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';                          
    DECLARE @v_program_name NVARCHAR(150) = N'zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_CELL_Tray_Simulation_Weekly';                         
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
	DECLARE @V_DIVISION_ID		        NVARCHAR(10)	= ISNULL(@P_DIVISION_ID, '82')
	DECLARE @V_PLAN_START_YYYYMMDD		NVARCHAR(8)		= NULL;
	DECLARE @V_PLAN_START_DATE			DATE			= NULL;
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

select 'jjg001'

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

/*
select 'jjg1'
select @V_DIVISION_ID
select @V_PLAN_START_YYYYMMDD
select @V_PLAN_START_DATE
select @V_PLAN_TYPE
select @V_PLAN_SEQ
select @V_HORIZON_END_YYYYMMDD
select @V_PLAN_START_YYYYMM
select @V_MASTER_ID
select @V_ENG_PLAN_ID
select 'jjg1_ee'
select @V_EE_DIVISION_ID
select @V_EE_PLAN_START_YYYYMMDD
select @V_EE_PLAN_TYPE
select @V_EE_PLAN_SEQ
select @V_EE_MASTER_ID
select @V_EE_ENG_PLAN_ID
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82',	  '20240819', 'FN'
*/

          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------   
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_CELL_Tray_Simulation_Usage') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_CELL_Tray_Simulation_Usage     
		  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_CELL_Tray_Simulation_Daily') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_CELL_Tray_Simulation_Daily   

          IF OBJECT_ID('tempdb..#tmp_CELL_TRAY_EXFACTORY_RESULT') IS NOT NULL                        
              DROP TABLE #tmp_CELL_TRAY_EXFACTORY_RESULT   

/*	
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION_330_yield') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION_330_yield  
			  
		  IF OBJECT_ID('tempdb..#tmp_PSI_INTEGRATION_350') IS NOT NULL                        
              DROP TABLE #tmp_PSI_INTEGRATION_350
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION 			  
*/

			CREATE TABLE #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
			(
				DIVISION_ID             NVARCHAR(10)    NULL,
				PLANT_ID			    NVARCHAR(10)	NULL,
				FROM_SITE               NVARCHAR(30)    NULL,
				TO_SITE                 NVARCHAR(30)    NULL,
				PLAN_START_YYYYMMDD     NVARCHAR(8)     NULL,
				OPERATION_GROUP			NVARCHAR(1)     NULL,
				CELL_ITEM_ID            NVARCHAR(40)    NULL,   
				accumulated_child_qty   NUMERIC(20, 10) NULL,
				ITEM_ID                 NVARCHAR(40)    NULL,
				MEASURE                 NVARCHAR(20)    NULL,
				YYYYMMDD			    NVARCHAR(8)     NULL,
				PACK_QTY			    NUMERIC(20, 10) NULL,  
				CELL_QTY			    NUMERIC(20, 10) NULL     
			);   

			CREATE TABLE #tmp_SCP_ANL_CELL_Tray_Simulation_Daily
			(
				[DIVISION_ID] [nvarchar](10) NOT NULL,
				[PLAN_START_YYYYMMDD] [nvarchar](8) NOT NULL,
				[PLAN_TYPE] [nvarchar](2) NOT NULL,
				[FROM_SITE] [nvarchar](30) NOT NULL,
				[TO_SITE] [nvarchar](30) NOT NULL,
				[MEASURE] [nvarchar](20) NOT NULL,
				[SEQ_FLAG] [nvarchar](5) NOT NULL,
				[YYYYMMDD] [nvarchar](8) NOT NULL,
				[BOH_QTY] [numeric](20, 10) NULL,
				[QTY] [numeric](20, 10) NULL
			)
           

			CREATE TABLE #tmp_CELL_TRAY_EXFACTORY_RESULT
			(
				DIVISION_ID NVARCHAR(10) NULL,
				from_SCM_Site_id nvarchar(30) NOT NULL,
				to_scm_site_id nvarchar(30) NOT NULL,
				arrival_YYYYMMDD nvarchar(8) NOT NULL,
				QTY numeric(20, 10) NULL
			)

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. semi wh in 만들기
          ------------------------------------------------------------------------------------------------------------- 
--1. semi_wh_in 계획 만들기

select 'jjg002'

		declare @TRAY1_from_site   nvarchar(200)
		declare @TRAY1_to_site     nvarchar(200)

		DECLARE CUR_TRAY1_ALLOC CURSOR FOR

			SELECT distinct SEGMENT1, SEGMENT2
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
			WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
			and LM.valid_yn = 'Y'

		OPEN CUR_TRAY1_ALLOC;
		FETCH NEXT FROM CUR_TRAY1_ALLOC INTO @TRAY1_from_site, @TRAY1_to_site;
		 
		WHILE (@@FETCH_STATUS = 0)
		BEGIN

--select '@TRAY1_from_site : ' + @TRAY1_from_site
--select '@TRAY1_to_site : ' + @TRAY1_to_site

			insert into #tmp_SCP_ANL_CELL_Tray_Simulation_Daily
				(	DIVISION_ID,
					PLAN_START_YYYYMMDD,
					PLAN_TYPE,
					FROM_SITE,
					TO_SITE,
					MEASURE,
					SEQ_FLAG,
					YYYYMMDD,
					BOH_QTY,
					QTY
				)
			SELECT  a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					@V_PLAN_TYPE as PLAN_TYPE, -- 'FN'
					a.FROM_SITE,
					a.TO_SITE,
					'SEMI_WH_IN' as MEASURE,
					'110' as SEQ_FLAG,
					convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112) as YYYYMMDD,  --==>  jjg--임책임에게 문의
					0 as BOH_QTY,
					 isnull(SUM(ISNULL(a.qty,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on a.division_id = c.division_id
				  and a.bod_id = c.bod_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  -- '20240819'
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE  -- 'FN'
			  AND a.SEQ					= @V_PLAN_SEQ  -- '1'
			  AND a.DIVISION_ID			= @V_DIVISION_ID  -- '82'
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'A'   
			  AND A.FROM_SITE = @TRAY1_from_site  -- in ('G184-A','G634-A')
			  AND A.TO_SITE = @TRAY1_to_site  --'KR32625300_82-P'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD  -- '20250817'  
			GROUP BY a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.FROM_SITE,
					a.TO_SITE,
					convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			--ORDER BY FROM_SITE, TO_SITE, YYYYMMDD

			
			FETCH NEXT FROM CUR_TRAY1_ALLOC INTO 	@TRAY1_from_site, @TRAY1_to_site;
		END -- OPEN CUR_TRAY1_ALLOC;
		
		CLOSE CUR_TRAY1_ALLOC;
		DEALLOCATE CUR_TRAY1_ALLOC;

/*
select 'jjg1'
select * from #tmp_SCP_ANL_CELL_Tray_Simulation_Daily ORDER BY FROM_SITE, TO_SITE, YYYYMMDD
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82',	  '20240819', 'FN'
*/

--1. semi_wh_in 실적 만들기
			-- 실적 최종 START
			--declare @V_PLAN_START_YYYYMMDD nvarchar(8)

/*
			declare @max_lt_total_ssp int

			DECLARE @lt_total_ssp  INT
			declare @TRAY2_from_site   nvarchar(200)
			declare @TRAY2_to_site     nvarchar(200)

			DECLARE CUR_TRAY2_ALLOC CURSOR FOR

				SELECT distinct SEGMENT1, SEGMENT2
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
				WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
				and LM.valid_yn = 'Y'

			OPEN CUR_TRAY2_ALLOC;
			FETCH NEXT FROM CUR_TRAY2_ALLOC INTO @TRAY2_from_site, @TRAY2_to_site;
		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

	--select '@TRAY2_from_site : ' + @TRAY2_from_site
	--select '@TRAY2_to_site : ' + @TRAY2_to_site

				SELECT @lt_total_ssp =  MAX(B.LT_TOTAL_SSP)  -- 가장 최대 값을 잡음.
				-- select *
				from SCP_MST_BOD_N_V B with(nolock)
				WHERE b.division_id = '82' --@V_DIVISION_ID  --'82' 
				and b.from_site  = @TRAY2_from_site  -- in ('G184-A','G634-A')
				AND b.TO_site = @TRAY2_to_site  --'KR32625300_82-P'
				--AND b.TRANSPORT_MODE = 'SEA'  --가장 늦은 교통 수단으로 함. --R.TRANSPORT_MODE
				--and b.incoterms = R.incoterms --'dap'   -- 이걸 막아야 조회됨. 
				and @V_PLAN_START_YYYYMMDD between b.from_yyyymmdd and b.to_yyyymmdd  -- @V_PLAN_START_YYYYMMDD  --'20240826'


				IF @lt_total_ssp > @max_lt_total_ssp
				BEGIN
					SET @max_lt_total_ssp = @lt_total_ssp
				END
			
				FETCH NEXT FROM CUR_TRAY2_ALLOC INTO 	@TRAY2_from_site, @TRAY2_to_site;
			END -- OPEN CUR_TRAY2_ALLOC;
		
			CLOSE CUR_TRAY2_ALLOC;
			DEALLOCATE CUR_TRAY2_ALLOC;
*/

select 'jjg003'

			declare @TRAY3_from_site   nvarchar(200)
			declare @TRAY3_to_site     nvarchar(200)

			DECLARE CUR_TRAY3_ALLOC CURSOR FOR

				SELECT distinct SEGMENT1, SEGMENT2
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
				WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
				and LM.valid_yn = 'Y'

			OPEN CUR_TRAY3_ALLOC;
			FETCH NEXT FROM CUR_TRAY3_ALLOC INTO @TRAY3_from_site, @TRAY3_to_site;
		 
			WHILE (@@FETCH_STATUS = 0)
			BEGIN

	--select '@TRAY3_from_site : ' + @TRAY3_from_site
	--select '@TRAY3_to_site : ' + @TRAY3_to_site
			
					-- DROP TABLE #tmp_CELL_TRAY_EXFACTORY_RESULT
					insert into #tmp_CELL_TRAY_EXFACTORY_RESULT
					select  R.DIVISION_ID,
							R.from_SCM_Site_id,
							R.to_scm_site_id,
							arrival_YYYYMMDD = CONVERT(NVARCHAR(8), DATEADD(D, ISNULL((SELECT max(B.LT_TOTAL_SSP)
																						FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_MST_BOD_N_V B with(nolock)
																						WHERE b.division_id = R.DIVISION_ID  --'82' 
																						and b.from_site = R.from_SCM_Site_id -- 'G184-A'
																						AND b.TO_site = R.TO_SCM_SITE_ID -- 'KR32625300_82-P'
																						AND b.TRANSPORT_MODE = R.TRANSPORT_MODE
																						and B.incoterms = 'DAP' --'dap'   -- 이걸 막아야 조회됨.  jjg ksg. TO_SITE가 PLANT 인 경우는 SCP는 DAP로 처리한다.
																						--and b.incoterms = R.incoterms --'dap'   -- 이걸 막아야 조회됨. 
																						and R.EXFACTORY_DATE between b.from_yyyymmdd and b.to_yyyymmdd ),0),R.EXFACTORY_DATE),112),
							ISNULL(R.EXFACTORY_QTY,0) as QTY
					from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_DNM_EXFACTORY_RESULT R WITH(NOLOCK)
					inner JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)    -- JJG 운영 아직 안걸었음.
							ON  L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만
							AND L.VALID_YN = 'Y'
							AND L.SEGMENT1    = R.SSP_TYPE
					where R.DIVISION_ID = @V_DIVISION_ID  --'82'
					AND R.EXFACTORY_STATUS NOT IN ('D10','D90')
					and R.from_SCM_Site_id = @TRAY3_from_site  -- IN ('G184-A','G634-A')
					and R.to_scm_site_id = @TRAY3_to_site  --'KR32625300_82-P'
					and R.EXFACTORY_DATE >= convert(nvarchar(6),dateadd(m,-1,@V_PLAN_START_YYYYMMDD),112) + '01'  --  '20240701'
					and R.EXFACTORY_DATE <= DATEADD(D, -1, @V_PLAN_START_YYYYMMDD)  --   '20240818'
					--ORDER BY from_SCM_Site_id, to_scm_site_id, arrival_YYYYMMDD

				FETCH NEXT FROM CUR_TRAY3_ALLOC INTO 	@TRAY3_from_site, @TRAY3_to_site;
			END -- OPEN CUR_TRAY3_ALLOC;
		
			CLOSE CUR_TRAY3_ALLOC;
			DEALLOCATE CUR_TRAY3_ALLOC;

select 'jjg004'

		 --delete a from #tmp_SCP_ANL_CELL_Tray_Simulation_Daily a
			insert into #tmp_SCP_ANL_CELL_Tray_Simulation_Daily
				(	DIVISION_ID,
					PLAN_START_YYYYMMDD,
					PLAN_TYPE,
					FROM_SITE,
					TO_SITE,
					MEASURE,
					SEQ_FLAG,
					YYYYMMDD,
					BOH_QTY,
					QTY
				)			
			select  A.DIVISION_ID,
					@V_PLAN_START_YYYYMMDD,
					@V_PLAN_TYPE,  -- 'FN'
					A.from_SCM_Site_id,
					A.to_scm_site_id,
					'SEMI_WH_IN' as MEASURE,
					'110' as SEQ_FLAG,
					arrival_YYYYMMDD AS YYYYMMDD,
					0 as BOH_QTY,
					isnull(SUM(ISNULL(A.QTY,0)),0) as QTY
			from #tmp_CELL_TRAY_EXFACTORY_RESULT A WITH(NOLOCK)
			where A.ARRIVAL_YYYYMMDD >= LEFT(@V_PLAN_START_YYYYMMDD,6) + '01'
			GROUP BY  A.DIVISION_ID,
					  A.from_SCM_Site_id,
					  A.to_scm_site_id,
					  arrival_YYYYMMDD
			--ORDER BY from_SCM_Site_id, to_scm_site_id, arrival_YYYYMMDD

/*
select *
from #tmp_SCP_ANL_CELL_Tray_Simulation_Daily
ORDER BY FROM_SITE, TO_SITE, YYYYMMDD

select 'jjg111'
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82',	  '20240819', 'FN'
*/
/*
SELECT *
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
WHERE MEASURE = 'SEMI_WH_IN'
AND CREATION_DATE >= '20240911'
*/
			-- 실적 최종 END

			--SELECT convert(nvarchar(6),dateadd(m,-1,'20240810'),112) + '01'
			--SELECT DATEADD(D,-11,'20240810') 

			--#tmp_CELL_TRAY_EXFACTORY_RESULT

		  -------------------------------------------------------------------------------------------------------------                         
          -- 2. usage 만들기
          ------------------------------------------------------------------------------------------------------------- 
select 'jjg005'
-- 2. usage 계획 만들기

		 INSERT INTO #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
		 (
			DIVISION_ID,
			PLANT_ID,
			FROM_SITE,
			TO_SITE,
			PLAN_START_YYYYMMDD,
			OPERATION_GROUP,
			CELL_ITEM_ID,
			ITEM_ID,
			MEASURE,
			YYYYMMDD,
			PACK_QTY		
		 )
		 SELECT a.DIVISION_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
				'-' AS FROM_SITE,   
	            a.SCM_SITE_ID as TO_SITE,
	            a.PLAN_START_YYYYMMDD,
				'P' as operation_group, 
                '-' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'USAGE' as MEASURE,
				a.YYYYMMDD as YYYYMMDD,
	            isnull(sum(isnull(a.QTY,0)),0) as QTY
			-- select B.SITE_DESCRIPTION, *
		FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item_v fi with(nolock)
				on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				and fi.operation_group = 'P'
				and fi.ITEM_ID = a.item_id
		left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				on  b.DIVISION_ID = a.DIVISION_ID
				and b.SCM_SITE_ID = a.SCM_SITE_ID
		WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  -- '20240819'
			AND a.PLAN_TYPE	= @V_PLAN_TYPE  -- 'FN'  
			AND a.SEQ = @V_PLAN_SEQ  -- '1'  
			AND a.DIVISION_ID = @V_DIVISION_ID  -- '82'  
			AND a.measure = 'PROD_PLAN_AMEND' 
			AND a.operation_group = 'P'
			AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD  -- '20250817'
			and a.SCM_SITE_ID in (  SELECT distinct SEGMENT2
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
									WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
									and LM.valid_yn = 'Y'  )  -- 'KR32625300_82-P'
			and a.QTY > 0
			AND A.ITEM_ID NOT IN (SELECT EP.SEGMENT1 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL EP WITH(NOLOCK)
								WHERE EP.LOOKUP_TYPE = 'EPPACK_FIFO_ITEM'
								AND EP.VALID_YN = 'Y'
								AND EP.SEGMENT2 = 'PRD' )
		group by    a.DIVISION_ID,
				    (case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  	  else  b.PLANT_ID
					  	  end ),
 					a.SCM_SITE_ID,
					a.PLAN_START_YYYYMMDD,
					a.ITEM_ID,
					a.YYYYMMDD
		--order by item_id, yyyymmdd


-- 여기까지 검증 완료.
/*
select *
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
ORDER BY item_id, yyyymmdd

select 'jjg111'
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82', '20240819', 'FN'

-- Violation of PRIMARY KEY constraint 'PK_SCP_ANL_CELL_Tray_Simulation_Weekly'. Cannot insert duplicate key in object 'dbo.SCP_ANL_CELL_Tray_Simulation_Weekly'. The duplicate key value is (20240826, 82, FN, A050-A, KR32625300_82-P, USAGE, 120, 202504, 20250418).
*/
/*
select top 10 *
from SCP_ANL_CELL_Tray_Simulation_Weekly with(nolock)
where creation_date >= '20240912'
*/
select 'jjg006'

------------ usage 실적 start -------------

--delete a
--from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a

		INSERT INTO #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
				 (
					DIVISION_ID,
					PLANT_ID,
					FROM_SITE,
					TO_SITE,
					PLAN_START_YYYYMMDD,
					OPERATION_GROUP,
					CELL_ITEM_ID,
					ITEM_ID,
					MEASURE,
					YYYYMMDD,
					PACK_QTY		
				 )
		 SELECT a.DIVISION_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ) as PLANT_ID,
				'-' AS FROM_SITE,   
				a.SCM_SITE_ID as TO_SITE,
				@v_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD,  --'20240819'
				'P' as operation_group, 
				'-' as CELL_ITEM_ID,
				a.ITEM_ID,
				'USAGE' as MEASURE,
				convert(nvarchar(8),a.PLAN_DATE,112) as YYYYMMDD,
				isnull(sum(isnull(a.ACTUAL_QTY,0)),0) as Pack_QTY
		--select top 10 a.*
		FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_DNM_PRODUCT_RESULT_V a WITH(NOLOCK)
		INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item_v fi with(nolock)
				on fi.RACK_YN <> 'Y' and fi.DC_YN <> 'Y'
				and fi.operation_group = 'P'
				and fi.ITEM_ID = a.item_id
		left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				on  b.DIVISION_ID = a.DIVISION_ID
				and b.SCM_SITE_ID = a.SCM_SITE_ID
		WHERE a.PLAN_DATE >= left(@v_PLAN_START_YYYYMMDD,6) + '01' 
		AND a.PLAN_DATE < @v_PLAN_START_YYYYMMDD
		AND a.DIVISION_ID = @V_DIVISION_ID  --'82'
		AND a.scm_site_id in (  SELECT distinct SEGMENT2
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
									WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
									and LM.valid_yn = 'Y'  )  -- 'KR32625300_82-P'
		AND a.ITEM_ID NOT IN (SELECT EP.SEGMENT1 
							FROM SCM_ADM_LOOKUP_MASTER_DETAIL EP WITH(NOLOCK)
							WHERE EP.LOOKUP_TYPE = 'EPPACK_FIFO_ITEM'
							AND EP.VALID_YN = 'Y'
							AND EP.SEGMENT2 = 'PRD' )
		--and a.item_id = 'EM048290P5B7'
		group by a.DIVISION_ID,
				(case when  b.osp_yn= 'Y' THEN b.logistic_plant_id
					  else  b.PLANT_ID
					  end ),
				 a.SCM_SITE_ID,
				 a.ITEM_ID,
				 a.PLAN_DATE
--		order by a.item_id, a.plan_date


/*
select *
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
ORDER BY item_id, yyyymmdd

select 'jjg111'
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82', '20240819', 'FN'
*/

select 'jjg007'
--select left('20240819',6) + '01'

------------ usage 실적 end -------------

---
-- drop table #tmp_FINAL_ITEM_BOM_V_CELL_TRAY
            -------------------------------------------------------------------------------------------------------------                                         
            -- 2-3. usage의 cell_item_id 반영
            ------------------------------------------------------------------------------------------------------------- 

            SET @V_STATUS_DESC = 'CELL_ITEM_ID Pack';

			select model_id, child_item_id, accumulated_child_qty
			into #tmp_FINAL_ITEM_BOM_V_CELL_TRAY
			-- select *
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
			WHERE Y.CELL_TYPE			 = 'CP'		
			AND Y.OPERATION_GROUP_ID = 'A'
			and Y.DIVISION_ID        = @V_DIVISION_ID  -- '82'  

			create index i_tmp_FINAL_ITEM_BOM_V_CELL_TRAY_01 on #tmp_FINAL_ITEM_BOM_V_CELL_TRAY(model_id)

/*
SELECT *
FROM #tmp_FINAL_ITEM_BOM_V_CELL_TRAY

SELECT *
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage  -- 17,836
WHERE ISNULL(CELL_ITEM_ID,'-') <'0'
*/
            -- PACK 일경우 
			-- CELL_ITEM_ID 적용
            UPDATE X
                SET CELL_ITEM_ID   = isnull(( SELECT TOP 1 CHILD_ITEM_ID
												FROM #tmp_FINAL_ITEM_BOM_V_CELL_TRAY AS Y WITH (NOLOCK)
											   WHERE Y.MODEL_ID           = X.ITEM_ID),'-')
            FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage X
            WHERE OPERATION_GROUP   = 'P'
			and isnull(x.CELL_ITEM_ID,'') < '0'

/*
SELECT *
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage  -- 728
WHERE ISNULL(CELL_ITEM_ID,'-') <'0'
*/

			-- 상위 모델 이용하여 CELL_ITEM_ID 적용
            UPDATE X
                SET CELL_ITEM_ID   = isnull(( SELECT TOP 1 CHILD_ITEM_ID
												FROM #tmp_FINAL_ITEM_BOM_V_CELL_TRAY AS Y WITH (NOLOCK)
											   WHERE Y.MODEL_ID    = ( SELECT top 1 model_id
																	     FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_ONE_LEVEL_BOM_V AS Y WITH (NOLOCK)
																		WHERE Y.DIVISION_ID        = X.DIVISION_ID
																		  AND Y.child_item_id         = X.ITEM_ID
																		  and y.plant_id = x.plant_id)),'-')
            FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage X
            WHERE OPERATION_GROUP   = 'P'
			and isnull(x.CELL_ITEM_ID,'') < '0'

/*
SELECT *
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage  -- 728
WHERE ISNULL(CELL_ITEM_ID,'-') <'0'
*/


			-- CELL_ITEM_ID 없는 것 삭제.
			delete a
			FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a -- 728
			WHERE ISNULL(CELL_ITEM_ID,'-') <'0'

--2-4. CHILD_ITEM의 accumulated_qty 반영

/*
select * 
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
*/
			-- CELL의 accumulated_child_qty 찾기

			--select *, ( SELECT TOP 1 accumulated_child_qty
			--												FROM #tmp_FINAL_ITEM_BOM_V_CELL_TRAY AS Y WITH (NOLOCK)
			--											   WHERE Y.MODEL_ID           = X.ITEM_ID
			--											   and y.CHILD_ITEM_ID = x.CELL_ITEM_ID)
            UPDATE X SET accumulated_child_qty = ( SELECT TOP 1 accumulated_child_qty
															FROM #tmp_FINAL_ITEM_BOM_V_CELL_TRAY AS Y WITH (NOLOCK)
														   WHERE Y.MODEL_ID           = X.ITEM_ID
														   and y.CHILD_ITEM_ID = x.CELL_ITEM_ID)
            FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Usage X
            WHERE OPERATION_GROUP   = 'P'
			and isnull(x.accumulated_child_qty,'0') = 0


			-- CELL 수량 반영.
			UPDATE A SET CELL_QTY = ACCUMULATED_CHILD_QTY * PACK_QTY
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage A 
			where isnull(a.CELL_QTY,'0') = 0


/*
select * 
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage  --1553
WHERE CELL_QTY IS NULL
*/

-- 2-5.  From_site 반영


			--[참고] From_site 찾기. start 
/*
			select PLANT_SITE_ID  --G184-A
			from [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority a with(nolock)
			where a.item_id = 'ECE0630N1-02'
			AND a.DIVISION_ID = '82'
			AND a.PRIORITY = (  SELECT MIN(b.PRIORITY) 
								FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority b with(nolock)
								where b.ITEM_ID = a.ITEM_ID
								and b.DIVISION_ID = a.DIVISION_ID )
*/
			--[참고] From_site 찾기. end 

			-- 참고 site 명 확인 start
/*
			select TOP 10 *
			from [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
			where  x.SCM_SITE_ID LIKE '%G634%'  -- G634-A
			OR   x.SCM_SITE_ID LIKE '%G184%'  -- G184-A
			-- 참고 site 명 확인 end

*/





-- JJG KSK : SITE NJ, BK WHERE조건에 빠져있음.
/*
			update a set from_site = pr.PLANT_SITE_ID
			--select a.*, pr.PLANT_SITE_ID
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority pr with(nolock)
				on pr.item_id = a.cell_item_id --'ECE0630N1-02'
				AND pr.DIVISION_ID = A.DIVISION_ID
				and a.yyyymmdd between pr.FROM_YYYYMMDD and pr.TO_YYYYMMDD
				AND pr.PRIORITY = (  SELECT MIN(b.PRIORITY)   -- JJG KSK기간 정보체크 필요.
									FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority b with(nolock)
									where b.ITEM_ID = pr.ITEM_ID
									and b.DIVISION_ID = pr.DIVISION_ID 
									and a.yyyymmdd between b.FROM_YYYYMMDD and b.TO_YYYYMMDD
									and b.plant_site_id in ( 	SELECT distinct SEGMENT1
																FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
																WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
																and LM.valid_yn = 'Y' 
															)
									)
				and pr.plant_site_id in ( 	SELECT distinct SEGMENT1
											FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
											WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
											and LM.valid_yn = 'Y' 
										)
			where isnull(a.from_site,'-') < '0'
*/
/*
select a.*, pr.PLANT_SITE_ID
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority pr with(nolock)
				on pr.item_id = a.cell_item_id --'ECE0630N1-02'
				AND pr.DIVISION_ID = A.DIVISION_ID
				--and a.yyyymmdd between pr.FROM_YYYYMMDD and pr.TO_YYYYMMDD
				AND pr.PRIORITY = (  SELECT MIN(b.PRIORITY)   -- JJG KSK기간 정보체크 필요.
									FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority b with(nolock)
									where b.ITEM_ID = pr.ITEM_ID
									and b.DIVISION_ID = pr.DIVISION_ID 
									and a.yyyymmdd between b.FROM_YYYYMMDD and b.TO_YYYYMMDD
									
									)
				
			where isnull(a.from_site,'-') < '0'
*/

/* 임책임님 요청건. PRIORITY 수정
			update a set from_site = ( select min(pr.PLANT_SITE_ID)
										from [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority pr with(nolock)
										where pr.item_id = a.cell_item_id --'ECE0630N1-02'
											AND pr.DIVISION_ID = A.DIVISION_ID
											and a.yyyymmdd between pr.FROM_YYYYMMDD and pr.TO_YYYYMMDD
											AND pr.PRIORITY = (  SELECT MIN(b.PRIORITY)   -- JJG KSK기간 정보체크 필요.
																FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority b with(nolock)
																where b.ITEM_ID = pr.ITEM_ID
																and b.DIVISION_ID = pr.DIVISION_ID 
																and a.yyyymmdd between b.FROM_YYYYMMDD and b.TO_YYYYMMDD
																and b.plant_site_id in ( 	SELECT distinct SEGMENT1
																							FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
																							WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
																							and LM.valid_yn = 'Y' 
																						)
																)
											and pr.plant_site_id in ( 	SELECT distinct SEGMENT1
																		FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
																		WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
																		and LM.valid_yn = 'Y' 
																	)
										)
			--select a.*, pr.PLANT_SITE_ID
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a
			where isnull(a.from_site,'-') < '0'
*/

			update a set from_site = ( select min(pr.PLANT_SITE_ID)
										from [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority pr with(nolock)
										where pr.item_id = a.cell_item_id --'ECE0630N1-02'
											AND pr.DIVISION_ID = A.DIVISION_ID
											and a.yyyymmdd between pr.FROM_YYYYMMDD and pr.TO_YYYYMMDD
											AND pr.PRIORITY = (  SELECT MIN(b.PRIORITY)   -- JJG KSK기간 정보체크 필요.
																FROM [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site_item_priority b with(nolock)
																where b.ITEM_ID = pr.ITEM_ID
																and b.DIVISION_ID = pr.DIVISION_ID 
																and a.yyyymmdd between b.FROM_YYYYMMDD and b.TO_YYYYMMDD)
																--and b.plant_site_id in ( 	SELECT distinct SEGMENT1
																--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
																--							WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
																--							and LM.valid_yn = 'Y' 
																--						)
																--)
											--and pr.plant_site_id in ( 	SELECT distinct SEGMENT1
											--							FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
											--							WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
											--							and LM.valid_yn = 'Y' 
											--						)
										)
			--select a.*, pr.PLANT_SITE_ID
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage a
			where isnull(a.from_site,'-') < '0'


select 'jjg008'

/*
select *
into jjg_test_usage_20270923_05
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
*/

--select 'jjg before'
--return
--select 'jjg after'

-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82', '20240902', 'FN'  -- 수행 시간 5초.

/*


and a.SCM_SITE_ID in (  SELECT distinct SEGMENT1
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM WITH(NOLOCK)
						WHERE LM.LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
						and LM.valid_yn = 'Y'  ) 


select *
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
where isnull(from_site,'-') < '0'
*/

/*
select *
into jjg_test_20240912
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
ORDER BY item_id, yyyymmdd

select 'jjg111'
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82', '20240819', 'FN'
*/



			insert into #tmp_SCP_ANL_CELL_Tray_Simulation_Daily
				(	DIVISION_ID,
					PLAN_START_YYYYMMDD,
					PLAN_TYPE,
					FROM_SITE,
					TO_SITE,
					MEASURE,
					SEQ_FLAG,
					YYYYMMDD,
					BOH_QTY,
					QTY
				)
			SELECT  a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					@V_PLAN_TYPE AS PLAN_TYPE,
					a.FROM_SITE,
					a.TO_SITE,
					'USAGE' as MEASURE,
					'120' as SEQ_FLAG,
					a.yyyymmdd as YYYYMMDD,
					0 as BOH_QTY,
					ISNULL(SUM(ISNULL(a.CELL_qty,0)),0) as QTY
			from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage A
			where  exists ( select 'Y'
							from SCM_ADM_LOOKUP_MASTER_DETAIL b
							where b.LOOKUP_TYPE like 'CELL_TRAY_SIMULATION_SITE'
							and b.valid_yn = 'Y'
							AND B.SEGMENT1 = A.FROM_SITE
							AND B.SEGMENT2 = A.TO_SITE)
			GROUP BY a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.FROM_SITE,
					a.TO_SITE,
					a.yyyymmdd



/*
SELECT A.*
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
order by measure, from_site, to_site, yyyymmdd
*/

/*
select substring(convert(nvarchar(8),getdate(),112),1,4)

SELECT FROM_SITE, TO_SITE, SEQ_FLAG, MEASURE, 'W' + CONVERT(CHAR, DATEPART(WEEK, YYYYMMDD)) AS WEEK,  substring(convert(nvarchar(8),getdate(),112),1,4)+format(DATEPART(WEEK, YYYYMMDD),'00') AS WEEK_NO, SUM(QTY) AS QTY -- , A.*
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
GROUP BY FROM_SITE, TO_SITE, SEQ_FLAG, MEASURE, CONVERT(CHAR, DATEPART(WEEK, YYYYMMDD)) , DATEPART(WEEK, YYYYMMDD)
ORDER BY FROM_SITE, TO_SITE, SEQ_FLAG, DATEPART(WEEK, YYYYMMDD)  , MEASURE
*/

/*
SELECT '82', '20240826', 'FN', FROM_SITE, TO_SITE, MEASURE, SEQ_FLAG, YYYYMMDD, left(YYYYMMDD,4)+format(DATEPART(WEEK, YYYYMMDD),'00') AS WEEK, SUM(QTY) AS QTY -- , A.*
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
GROUP BY FROM_SITE, TO_SITE, SEQ_FLAG, MEASURE, YYYYMMDD, left(YYYYMMDD,4)+format(DATEPART(WEEK, YYYYMMDD),'00') 
ORDER BY FROM_SITE, TO_SITE, SEQ_FLAG, left(YYYYMMDD,4)+format(DATEPART(WEEK, YYYYMMDD),'00')  , MEASURE
*/

/*
SELECT  '82' as DIVISION_ID, 
		'20240826' as PLAN_START_YYYYMMDD, 
		'FN' as plan_type, 
		FROM_SITE, 
		TO_SITE, 
		MEASURE, 
		SEQ_FLAG, 
		left(YYYYMMDD,4)+format(DATEPART(WEEK, YYYYMMDD),'00') AS WEEK, 
		SUM(QTY) AS QTY
FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
GROUP BY FROM_SITE, TO_SITE, SEQ_FLAG, MEASURE, left(YYYYMMDD,4)+format(DATEPART(WEEK, YYYYMMDD),'00') 
*/
/*
SELECT *
FROM SCP_ANL_CELL_Tray_Simulation_Weekly
*/
----------- table creation end
--SELECT format(DATEPART(WEEK, '20240901'),'00')

/*
select *
from SCP_ANL_CELL_Tray_Simulation_Weekly
where plan_start_yyyymmdd <> '20240826'
*/

select 'jjg1'

/*
DROP TABLE jjg_test_CELL_Tray_Usage_20240902
DROP TABLE jjg_test_CELL_TRAY_BOM_20240902

SELECT * FROM jjg_test_CELL_Tray_Usage_20240902
SELECT * FROM jjg_test_CELL_TRAY_BOM_20240902
SELECT * FROM jjg_test_CELL_Tray_Daily_20240902
SELECT * FROM jjg_test_CELL_Tray_EXFACTORY_RESULT_20240902
*/

select *
into jjg_test_CELL_Tray_Usage_20240902_2   -- 'USAGE'용 데이터 취합.
from #tmp_SCP_ANL_CELL_Tray_Simulation_Usage

select *
into jjg_test_CELL_TRAY_BOM_20240902_2   --usage용 model_id, child_item_id, accumulated_child_qty 추출함
from #tmp_FINAL_ITEM_BOM_V_CELL_TRAY

select *
into jjg_test_CELL_Tray_Daily_20240902_2  -- MEASURE:'SEMI_WH_IN' 와  'USAGE'가 최종 Daily 취합.
from #tmp_SCP_ANL_CELL_Tray_Simulation_Daily    

select *
into jjg_test_CELL_Tray_EXFACTORY_RESULT_20240902_2  -- semi_wh_in 실적 취합
from #tmp_CELL_TRAY_EXFACTORY_RESULT 

select 'jjg2'
return
select 'jjg3'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82',	  '20240902', 'FN'


			DELETE A FROM SCP_ANL_CELL_Tray_Simulation_Weekly A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.DIVISION_ID			= @V_DIVISION_ID
			and a.plan_type				= @V_PLAN_TYPE

set datefirst  1; 

			insert into SCP_ANL_CELL_Tray_Simulation_Weekly
			SELECT  @V_DIVISION_ID as DIVISION_ID,  -- '82' 
					@V_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD,  --'20240826'
					@V_PLAN_TYPE as plan_type,  -- 'FN'
					A.FROM_SITE, 
					A.TO_SITE, 
					A.MEASURE, 
					A.SEQ_FLAG, 
					left(A.YYYYMMDD,6) AS YYYYMM, 
					left(A.YYYYMMDD,6)+format(DATEPART(WEEK, A.YYYYMMDD),'00') AS WEEK, 
					0 AS BOH_QTY,
					--SUM(QTY) AS QTY,
					ROUND(ISNULL(SUM(isnull(A.QTY/ISNULL(B.SEGMENT3,1),0)),0),0) AS QTY,
					--(case when A.FROM_SITE = 'G184-A' then  isnull(SUM(isnull(A.QTY,0)),0) / 252 
					--      when A.FROM_SITE = 'G634-A' then  isnull(SUM(isnull(A.QTY,0)),0) / 288 
					--	  else 0 
					--	  end ) AS QTY,
					'SYSTEM' AS CREATED_BY,
					GETDATE() AS CREATION_DATE,
					'SYSTEM' AS LAST_UPDATED_BY,
					GETDATE() AS LAST_UPDATE_DATE,
					'' AS ATTRIBUTE1,
					'' AS ATTRIBUTE2,
					'' AS ATTRIBUTE3,
					'' AS ATTRIBUTE4,
					'' AS ATTRIBUTE5,
					'' AS ATTRIBUTE6,
					'' AS ATTRIBUTE7,
					'' AS ATTRIBUTE8,
					'' AS ATTRIBUTE9,
					'' AS ATTRIBUTE10
			FROM #tmp_SCP_ANL_CELL_Tray_Simulation_Daily A
			LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
				 ON B.LOOKUP_TYPE like 'CELL_TRAY_SIMULATION_SITE'
				 AND B.VALID_YN = 'Y'
				 AND B.SEGMENT1 = A.FROM_SITE
				 AND B.SEGMENT2 = A.TO_SITE
			GROUP BY A.FROM_SITE, A.TO_SITE, A.MEASURE, A.SEQ_FLAG, left(A.YYYYMMDD,6), left(A.YYYYMMDD,6)+format(DATEPART(WEEK, A.YYYYMMDD),'00') 

-- 이하 BOH_STOCK_OSP start --

			insert into SCP_ANL_CELL_Tray_Simulation_Weekly
			SELECT  @V_DIVISION_ID as DIVISION_ID,   -- '82'
					@V_PLAN_START_YYYYMMDD as PLAN_START_YYYYMMDD,   -- '20240826'
					@V_PLAN_TYPE as plan_type,   -- 'FN'
					c.SCM_SITE_ID AS FROM_SITE, 
					so.scm_site_id AS TO_SITE,  -- 'KR32625300_82-P'
					'BOH_STOCK_OSP' MEASURE, -- 'BOH_STOCK_OSP'
					'210' SEQ_FLAG,  -- '210'
					left(@V_PLAN_START_YYYYMMDD,6) AS YYYYMM,  -- left('20240826',6)
					left(@V_PLAN_START_YYYYMMDD,6)+format(DATEPART(WEEK, @V_PLAN_START_YYYYMMDD),'00') AS WEEK, -- left('20240826',6)+format(DATEPART(WEEK, '20240826'),'00') 
					ROUND(isnull(sum(isnull(so.qty/ISNULL(B.SEGMENT3,1),0)),0),0) AS BOH_QTY,
					--(case when SCM_SITE_ID = 'G184-A' then  isnull(SUM(isnull(so.qty,0)),0) / 252 
					--      when SCM_SITE_ID = 'G634-A' then  isnull(SUM(isnull(so.qty,0)),0) / 288 
					--	  else 0 
					--	  end ) AS BOH_QTY,
					0 AS QTY,  --SUM(QTY) AS QTY,
					'SYSTEM' AS CREATED_BY,
					GETDATE() AS CREATION_DATE,
					'SYSTEM' AS LAST_UPDATED_BY,
					GETDATE() AS LAST_UPDATE_DATE,
					'' AS ATTRIBUTE1,
					'' AS ATTRIBUTE2,
					'' AS ATTRIBUTE3,
					'' AS ATTRIBUTE4,
					'' AS ATTRIBUTE5,
					'' AS ATTRIBUTE6,
					'' AS ATTRIBUTE7,
					'' AS ATTRIBUTE8,
					'' AS ATTRIBUTE9,
					'' AS ATTRIBUTE10
			--select top 100 *
			FROM  [10.34.221.78,7433].lgce_scmprod.dbo.scm_dnm_stock_osp so WITH(NOLOCK) 
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site c with(nolock)
					on c.plant_id =so.attribute2  --  so.attribute2 는 plant 임.
					and c.operation_group = 'A'
			LEFT JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B   -- segment3(plt환산) 의 값을 반영한다.
				 ON B.LOOKUP_TYPE like 'CELL_TRAY_SIMULATION_SITE'
				 AND B.VALID_YN = 'Y'
				 AND B.SEGMENT1 = C.SCM_SITE_ID
				 AND B.SEGMENT2 = so.scm_site_id
			where so.division_id = @V_DIVISION_ID  --'82'
			and so.yyyymmdd = dateadd(d, -1, @V_PLAN_START_YYYYMMDD)     --'20240901'
			--and so.scm_site_id in ('G184-A','G634-A','KR32625300_82-P')
			and  exists ( select 'Y'
							from SCM_ADM_LOOKUP_MASTER_DETAIL b
							where b.LOOKUP_TYPE like 'CELL_TRAY_SIMULATION_SITE'
							and b.valid_yn = 'Y'
							AND B.SEGMENT1 = c.SCM_SITE_ID
							AND B.SEGMENT2 = so.scm_site_id
						)
			group by c.SCM_SITE_ID, so.scm_site_id

/*
select 'jjg111'
return
select 'jjg999'
-- exec zjjg_PR_SCP_ANL_CELL_Tray_Simulation_for_Proc_RealTable '82', '20240902', 'FN'
*/

/*
insert into SCP_ANL_CELL_Tray_Simulation_Weekly
SELECT  '82' as DIVISION_ID, 
		'20240826' as PLAN_START_YYYYMMDD, 
		'FN' as plan_type, 
		'A050-A' AS FROM_SITE, 
		'KR32625300_82-P' AS TO_SITE, 
		'BOH_STOCK_OSP' MEASURE, 
		'210' SEQ_FLAG, 
		left('20240826',6) AS YYYYMM, 
		left('20240826',6)+format(DATEPART(WEEK, '20240826'),'00') AS WEEK, 
		100 AS BOH_QTY,
		0 AS QTY,  --SUM(QTY) AS QTY,
		'SYSTEM' AS CREATED_BY,
		GETDATE() AS CREATION_DATE,
		'SYSTEM' AS LAST_UPDATED_BY,
		GETDATE() AS LAST_UPDATE_DATE,
		'' AS ATTRIBUTE1,
		'' AS ATTRIBUTE2,
		'' AS ATTRIBUTE3,
		'' AS ATTRIBUTE4,
		'' AS ATTRIBUTE5,
		'' AS ATTRIBUTE6,
		'' AS ATTRIBUTE7,
		'' AS ATTRIBUTE8,
		'' AS ATTRIBUTE9,
		'' AS ATTRIBUTE10



insert into SCP_ANL_CELL_Tray_Simulation_Weekly
SELECT  '82' as DIVISION_ID, 
		'20240826' as PLAN_START_YYYYMMDD, 
		'FN' as plan_type, 
		'G184-A' AS FROM_SITE, 
		'KR32625300_82-P' AS TO_SITE, 
		'BOH_STOCK_OSP' MEASURE, 
		'210' SEQ_FLAG, 
		left('20240826',6) AS YYYYMM, 
		left('20240826',6)+format(DATEPART(WEEK, '20240826'),'00') AS WEEK, 
		2647 AS BOH_QTY,
		0 AS QTY,  --SUM(QTY) AS QTY,
		'SYSTEM' AS CREATED_BY,
		GETDATE() AS CREATION_DATE,
		'SYSTEM' AS LAST_UPDATED_BY,
		GETDATE() AS LAST_UPDATE_DATE,
		'' AS ATTRIBUTE1,
		'' AS ATTRIBUTE2,
		'' AS ATTRIBUTE3,
		'' AS ATTRIBUTE4,
		'' AS ATTRIBUTE5,
		'' AS ATTRIBUTE6,
		'' AS ATTRIBUTE7,
		'' AS ATTRIBUTE8,
		'' AS ATTRIBUTE9,
		'' AS ATTRIBUTE10


insert into SCP_ANL_CELL_Tray_Simulation_Weekly
SELECT  '82' as DIVISION_ID, 
		'20240826' as PLAN_START_YYYYMMDD, 
		'FN' as plan_type, 
		'G634-A' AS FROM_SITE, 
		'KR32625300_82-P' AS TO_SITE, 
		'BOH_STOCK_OSP' MEASURE, 
		'210' SEQ_FLAG, 
		left('20240826',6) AS YYYYMM, 
		left('20240826',6)+format(DATEPART(WEEK, '20240826'),'00') AS WEEK, 
		990 AS BOH_QTY,
		0 AS QTY,  --SUM(QTY) AS QTY,
		'SYSTEM' AS CREATED_BY,
		GETDATE() AS CREATION_DATE,
		'SYSTEM' AS LAST_UPDATED_BY,
		GETDATE() AS LAST_UPDATE_DATE,
		'' AS ATTRIBUTE1,
		'' AS ATTRIBUTE2,
		'' AS ATTRIBUTE3,
		'' AS ATTRIBUTE4,
		'' AS ATTRIBUTE5,
		'' AS ATTRIBUTE6,
		'' AS ATTRIBUTE7,
		'' AS ATTRIBUTE8,
		'' AS ATTRIBUTE9,
		'' AS ATTRIBUTE10
*/
-- 이하 BOH_STOCK_OSP end --


--================= 회수 포장재 end




		
			drop table #tmp_SCP_ANL_CELL_Tray_Simulation_Usage
--			#tmp_FINAL_ITEM_BOM_V_CELL_TRAY
		    drop table #tmp_SCP_ANL_CELL_Tray_Simulation_Daily   
			drop table #tmp_CELL_TRAY_EXFACTORY_RESULT   

            
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



