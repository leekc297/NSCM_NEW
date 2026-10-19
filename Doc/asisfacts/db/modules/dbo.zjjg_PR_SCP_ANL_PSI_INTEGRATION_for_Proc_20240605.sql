

/*******************************************************************************************************************                      
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION                        
 * Description  : 재료비 TASK                      
 * OutTable     : SCP_ANL_PSI_INTEGRATION                     
 * Execute      : 
                  EXEC PR_SCP_ANL_PSI_INTEGRATION
                       @p_division_id         = '81'
                     , @p_plan_start_yyyymmdd = '20240527'
                  
 * Program History                      
 *===================================================================================================                      
 *   Date       In Charge      Description                      
 *===================================================================================================                      
 * 2024.05.08                  Initial 재료비 TASK PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 PSI용 정보 구성
 *
 *******************************************************************************************************************/                    
                    
-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81', '20240527'  --수행 시간 ==> 11분 04초 걸림. : 36,487건
-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81_UC', '20240527'  --수행 시간 ==> 7분 53초 걸림 : 1,308건
-- 운영 DB Link : select * from [10.34.221.78,7433].lgce_scmprod.dbo.[SCM_MST_SITE_item]  with(nolock)

CREATE PROCEDURE [dbo].[PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PSI_INTEGRATION_for_Proc';                        
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...                        
    DECLARE @n_log_count    INTEGER = 0;                        
    DECLARE @v_log_message  NVARCHAR(1000);                        
    DECLARE @v_description  NVARCHAR(500);            
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PSI_INTEGRATION';                         
    DECLARE @d_event_date   DATETIME;                        
	                   
    DECLARE @V_KSG_TEMP  NVARCHAR(1000) = 'START'; 
	
  -- 시작 LOG                        
    SET @v_log_type     = N'START';                        
    SET @v_log_message  = N'########## Start of procedure ##########';                        
    SET @v_description  = @v_program_name + ':' + @v_table_id + N' INSERT LOGIC';                        
    SET @d_event_date   = SYSDATETIME();                        
    --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
    --                          ,@p_log_type      =@v_log_type                        
    --                          ,@p_log_count     =@n_log_count                         
    --                          ,@p_log_message   =@v_log_message                         
    --                          ,@p_description   =@v_description                         
    --                          ,@p_event_date    =@d_event_date                         
    --                          ,@p_user_id       =@v_batch_user                        
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
	DECLARE @V_EE_PLAN_SEQ				BIGINT			= 1
	DECLARE @V_EE_MASTER_ID				NVARCHAR(100)	= NULL
	DECLARE @V_EE_ENG_PLAN_ID			NVARCHAR(100)	= NULL

	


    BEGIN TRY                        
        BEGIN  

			---------------------------------------------------------------------------------------------------
			-- SCP PLAN 버전 정보 (PRODUCTION) 
			---------------------------------------------------------------------------------------------------
select 'jjg1 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = 'Plan seq';

/*

@V_PLAN_SEQ : 1
@V_PLAN_START_YYYYMMDD : 20240527
@V_PLAN_START_YYYYMM : 202405
@V_HORIZON_END_YYYYMMDD : 20250525
@V_MASTER_ID : 81::WEEKLY
@V_ENG_PLAN_ID : 1341::FN::1

*/
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

/*
			select top 1 D.PLAN_SEQ, P.PLAN_NAME, CONVERT(DATE, P.PLAN_NAME, 112) , SUBSTRING(P.PLAN_NAME, 1, 6) , SUBSTRING(P.HORIZON_END_DATE, 1, 8) , P.DIVISION_ID + '::' + P.PLAN_CYCLE , P.PLAN_ID + '::' + D.PLAN_TYPE + '::' + CONVERT(NVARCHAR(3), D.PLAN_SEQ)
			 FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN  P WITH(NOLOCK)
				  INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
						  ON D.DIVISION_ID  = P.DIVISION_ID
						 AND D.PLAN_ID      = P.PLAN_ID
						 AND D.PLAN_TYPE    = 'FN'  --@V_PLAN_TYPE -- FN
						 AND D.PLAN_STATUS  = '1'  -- 정상 완료
						 AND D.CONFIRM_FLAG = 'Y'  -- 최종 Confirm
			WHERE 1=1
			  AND P.DIVISION_ID  = '81'  --@V_DIVISION_ID			
			  AND P.PLAN_NAME    = '20240527'  --@P_PLAN_START_YYYYMMDD  -- JJGKSK 수정했음.
			  AND P.PLAN_CYCLE   = 'WEEKLY'   
			ORDER BY P.PLAN_NAME DESC
				   , D.PLAN_SEQ 

*/
/*
select '@V_PLAN_SEQ : ' + CONVERT(VARCHAR(8), @V_PLAN_SEQ)  -- 2
select '@V_PLAN_START_YYYYMMDD : ' + @V_PLAN_START_YYYYMMDD  -- 20240527
select '@V_PLAN_START_YYYYMM : ' + @V_PLAN_START_YYYYMM  -- 202405
select '@V_HORIZON_END_YYYYMMDD : ' + @V_HORIZON_END_YYYYMMDD  --20250525
select '@V_MASTER_ID : ' + @V_MASTER_ID  -- 82::WEEKLY
select '@V_ENG_PLAN_ID : ' + @V_ENG_PLAN_ID  -- 1341::FN::2
*/
--select 'jjg11 : ' + convert(varchar(19), getdate(), 121)


--RETURN

-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81', '20240527'  

--select 'jjg2 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = 'division EE ';
             -- 전극 @V_EE_DIVISION_ID 구하기.
			SELECT TOP 1 @V_EE_DIVISION_ID = b.DIVISION_ID
			from [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION A with(nolock)
			INNER JOIN [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_DIVISION B WITH(NOLOCK)
			on b.attribute4 = a.ATTRIBUTE4
			and b.ATTRIBUTE3 = 'EE'
			where a.DIVISION_ID = @V_DIVISION_ID	-- '81_HM'


--select '@V_EE_DIVISION_ID : ' + @V_EE_DIVISION_ID			
--select 'jjg3 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = ' plan EE';
			---------------------------------------------------------------------------------------------------
			-- 'EE'추가  SCP PLAN 버전 정보 (PRODUCTION) 
			---------------------------------------------------------------------------------------------------
/*
@V_EE_DIVISION_ID : EE
@V_EE_PLAN_SEQ : 1
@V_EE_PLAN_START_YYYYMMDD : 20240527
@V_EE_MASTER_ID : EE::WEEKLY
@V_EE_ENG_PLAN_ID : 1341::FN::1
*/
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
select '@V_EE_PLAN_SEQ : ' + convert(varchar(8), @V_EE_PLAN_SEQ)
select '@V_EE_PLAN_START_YYYYMMDD : ' + @V_EE_PLAN_START_YYYYMMDD
select '@V_EE_MASTER_ID : ' + @V_EE_MASTER_ID
select '@V_EE_ENG_PLAN_ID : ' + @V_EE_ENG_PLAN_ID
*/

/*

@V_PLAN_SEQ : 1
@V_PLAN_START_YYYYMMDD : 20240527
@V_PLAN_START_YYYYMM : 202405
@V_HORIZON_END_YYYYMMDD : 20250525
@V_MASTER_ID : 81::WEEKLY
@V_ENG_PLAN_ID : 1341::FN::1

@V_EE_DIVISION_ID : EE
@V_EE_PLAN_SEQ : 1
@V_EE_PLAN_START_YYYYMMDD : 20240527
@V_EE_MASTER_ID : EE::WEEKLY
@V_EE_ENG_PLAN_ID : 1341::FN::1

*/



-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81', '20240527'  

          -------------------------------------------------------------------------------------------------------------                         
          -- 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서                        
          -------------------------------------------------------------------------------------------------------------                   
          IF OBJECT_ID('tempdb..#tmp_psi_integration_inv') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_inv     
			  
          IF OBJECT_ID('tempdb..#tmp_psi_integration_bbb') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_bbb     
			  
          IF OBJECT_ID('tempdb..#tmp_psi_integration_ccc') IS NOT NULL                        
              DROP TABLE #tmp_psi_integration_ccc                                        
			  
          IF OBJECT_ID('tempdb..#tmp_SCP_ANL_PSI_INTEGRATION') IS NOT NULL                        
              DROP TABLE #tmp_SCP_ANL_PSI_INTEGRATION 			  
			 

           CREATE TABLE #tmp_PSI_INTEGRATION_INV(                        
                DIVISION_ID             NVARCHAR(10)    NULL,
	            FROM_SITE               NVARCHAR(30)    NULL,
	            ITEM_ID                 NVARCHAR(40)    NULL,
				YYYYMMDD				NVARCHAR(8)     NULL,
	            QTY			            NUMERIC(20, 10) NULL,
				DESCR					NVARCHAR(4000)  NULL,
                ATTRIBUTE8              NVARCHAR(150)   NULL,     
				FLOW_ID					NVARCHAR(200)   NULL, 
				OPERATION_GROUP			NVARCHAR(1)     NULL
            );   

           CREATE TABLE #tmp_PSI_INTEGRATION_BBB(                        
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
 
                        
           CREATE TABLE #tmp_SCP_ANL_PSI_INTEGRATION(                        
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
			create index i_tmp_SCP_ANL_PSI_INTEGRATION_01 on #tmp_SCP_ANL_PSI_INTEGRATION(item_id)
           
          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    0.MKT FCST 입력
          ------------------------------------------------------------------------------------------------------------- 

select 'jjg4 : ' + convert(varchar(19), getdate(), 121)

--return
-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81', '20240527'  

set @V_KSG_TEMP = '0.MKT FCST ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
         SELECT a.DIVISION_ID,
				'' as COMPANY_ID, 
				'' as PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.operation_group,
				'-' as FROM_SITE,
                '' AS CELL_ITEM_ID,  -- temp 테이블 전체를 마지막에서 한꺼번에 반영함.
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				''  as LINE_ID,   -- shipment 에는 Line_id 없으므로 공백처리gka.
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
				a.incoterms, 
				(CASE WHEN a.operation_group = 'P' THEN '100'
					  WHEN a.operation_group = 'A' THEN '300'
				      END ) AS SEQ_FLAG,  -- 정렬   --JJGKSK CASE 문으로 100, 300 추가
				left(a.YYYYMMDD,6) as YYYYMM,
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
			  AND a.operation_group IN ('A','P')   --JJGKSK 'A','P' 추가해서 동시 수행.
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.SEQ,
					a.operation_group,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					a.incoterms,
					(CASE WHEN a.operation_group = 'P' THEN '100'
					  WHEN a.operation_group = 'A' THEN '300'
				      END ) ,
					left(a.YYYYMMDD,6)

          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    1.Ship. Plan(RTF) 입력
          ------------------------------------------------------------------------------------------------------------- 
		  
select 'jjg5 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = '1.Ship. Plan(RTF)  ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				B.PLANT_ID,  
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.operation_group,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'SHIP_PLAN_RTF' as MEASURE,
				''  as LINE_ID,   
                0 as BOH_QTY,
					(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ) AS TO_SITE,
				a.incoterms,
				(CASE WHEN a.operation_group = 'P' THEN '110'
					  WHEN a.operation_group = 'A' THEN '310'
				      END ) AS SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(ALLOCATION_QTY,1)),1) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.plant_site_id
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.sales_site_id
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE   
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.operation_group IN ('A','P')   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 B.PLANT_ID,
					 a.PLAN_START_YYYYMMDD,
					 a.SEQ,
					 a.operation_group,
					 a.ITEM_ID,
					 (case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					 a.incoterms,
					(CASE WHEN a.operation_group = 'P' THEN '110'
						  WHEN a.operation_group = 'A' THEN '310'
						  END ),
					left(a.YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    5.PROD_PLAN 입력
          -------------------------------------------------------------------------------------------------------------  

select 'jjg6 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '5.PROD_PLAN ';
		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				B.PLANT_ID,  
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.OPERATION_GROUP,
				'-' AS FROM_SITE,   
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' AS INCOTERMS,
				(CASE WHEN a.operation_group = 'P' THEN '150'
					  WHEN a.operation_group = 'A' THEN '450'
				      END ) AS SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
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
			  AND a.operation_group IN ('A','P') 
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			  group by a.DIVISION_ID,
					 B.COMPANY_ID,
					 B.PLANT_ID,  
				     a.PLAN_START_YYYYMMDD,
				     a.SEQ,
					 a.OPERATION_GROUP,
		             a.ITEM_ID,
					 a.LINE_ID,
					(CASE WHEN a.operation_group = 'P' THEN '150'
						  WHEN a.operation_group = 'A' THEN '450'
						  END ),
					left(a.YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 )
		  --    6.BOH 입력
          -------------------------------------------------------------------------------------------------------------  

select 'jjg7 : ' + convert(varchar(19), getdate(), 121)
 
set @V_KSG_TEMP = '6.BOH ';

			insert into #tmp_PSI_INTEGRATION_INV
			SELECT   SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)   
					on C.item_id = A.ITEM_ID
					and C.division_id = SUBSTRING(A.MASTER_ID,1,2)
					and C.division_id = @V_DIVISION_ID  
					and c.FLOW_ID <> 'P5000' 
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID  
			AND A.PLAN_ID     = @V_ENG_PLAN_ID  
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR
					,C.attribute8, C.FLOW_ID, C.OPERATION_GROUP


			/*****************************************
				#tmp_psi_integration_inv  'P5000'을 추가.
			******************************************/

select 'jjg8 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = '6.BOH P5000';

			INSERT INTO #tmp_psi_integration_inv
			SELECT   SUBSTRING(A.MASTER_ID,1,2) AS DIVISION_ID
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,'' as attribute8, C.FLOW_ID, 'P' as OPERATION_GROUP
			
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)   
			inner join (select distinct division_id, item_id, isnull(scp_flow_id, flow_id) flow_id
			            from [10.34.221.78,7433].lgce_fp_tr.dbo.SCM_ITEM_M WITH(NOLOCK)   
						where division_id = @V_DIVISION_ID 
						and isnull(scp_flow_id, flow_id) = 'P5000'
				        ) c
					on  c.division_id = SUBSTRING(A.MASTER_ID,1,2) 
					and c.item_id = A.ITEM_ID
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_MASTER_ID 
			AND A.PLAN_ID     = @V_ENG_PLAN_ID 
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR
					,C.FLOW_ID


			/****************************************************
			EE 재고('560')를 #tmp_psi_integration_inv 에 추가로 insert 해야함.
			****************************************************/

select 'jjg9 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = '6.BOH EE';

			INSERT INTO #tmp_psi_integration_inv
			SELECT   @V_DIVISION_ID 
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)  AS FROM_SITE
					,A.ITEM_ID                                 
					,CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)  AS YYYYMMDD
					,SUM(ISNULL(A.QTY,0))   AS QTY     
					,A.DESCR
					,'' as attribute8, 'E2000' FLOW_ID, 'E' as OPERATION_GROUP			
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_TH_ENG_STOCK_PLAN A WITH(NOLOCK)  
			inner join (select distinct item_id from [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item  WITH(NOLOCK)   
			            where division_id = @V_DIVISION_ID
						and FLOW_ID like 'E2000%'
			           ) c
					on C.item_id = A.ITEM_ID
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site d WITH(NOLOCK)   
					on d.scm_sitE_id = SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)
					and d.division_id = @V_DIVISION_ID 
			WHERE 1 = 1           
			AND A.MASTER_ID   = @V_EE_MASTER_ID 
			AND A.PLAN_ID     = @V_EE_ENG_PLAN_ID 
			AND CONVERT(NVARCHAR, A.RECEIVING_DTTM,112) = convert(nvarchar(8),dateadd(d,-1,@V_PLAN_START_YYYYMMDD),112)  -- plan_start_yyyymmdd 보다 하루 전날 재고를 가져옴.
			GROUP BY                     
					SUBSTRING(A.MASTER_ID,1,2)                          
					,SUBSTRING(A.SITE_ID, 1, CHARINDEX('~',A.SITE_ID)-1)      
					,A.ITEM_ID                                 
					, CONVERT(NVARCHAR, A.RECEIVING_DTTM,112)   
					,A.DESCR

select 'jjg10 : ' + convert(varchar(19), getdate(), 121)

set @V_KSG_TEMP = '6.BOH inv';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
			SELECT   a.division_id as DIVISION_ID
					,b.company_id
					,b.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,@V_PLAN_SEQ AS SEQ
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
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
			FROM #tmp_psi_integration_inv A WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID  
					and b.SCM_SITE_ID = a.from_site			
			WHERE a.operation_group IN ('A','P')    
			group by a.division_id
					,b.company_id
					,b.plant_id
					,a.OPERATION_GROUP
					,A.ITEM_ID 
					,(case when a.operation_group='P' and  a.Flow_id in ('P5500','P9500')      then '160'  
						   when a.operation_group='P' and  a.Flow_id not in ('P5500','P9500')  then '260'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CP'  then '360'  
						   when a.operation_group='A' and  substring(a.attribute8,1,2) = 'CA'  then '460'  
						   end ) 


select 'jjg11 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '6.BOH inv E';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
			SELECT   a.division_id as DIVISION_ID
					,b.company_id
					,b.plant_id
					,@V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
					,@V_PLAN_SEQ AS SEQ
					,a.OPERATION_GROUP as OPERATION_GROUP
					,'-'  AS FROM_SITE
					,'' as CELL_ITEM_ID 
					,A.ITEM_ID 
					,'INV' as MEASURE
					,'-' as LINE_ID
					,isnull(sum(isnull(A.QTY,0)),0)   AS BOH_QTY  
					,'-' as TO_SITE
					,'-' as incoterms
					,'560' as SEQ_FLAG
					,convert(nvarchar(6),getdate(),112)
					,0 QTY
			FROM #tmp_psi_integration_inv A WITH(NOLOCK)
			left outer join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
					on  b.DIVISION_ID = a.DIVISION_ID
					and b.SCM_SITE_ID = a.from_site			
			WHERE a.operation_group = 'E'         
			group by a.division_id
					,b.company_id
					,b.plant_id
					,a.OPERATION_GROUP
					,A.ITEM_ID 

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

select 'jjg12 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = 'bbb  1';

			insert into #tmp_PSI_INTEGRATION_BBB
	        SELECT  a.DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					b.PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					a.SEQ,
					a.operation_group,
					a.FROM_SITE,
					a.ITEM_ID,
					a.TO_SITE,
					c.SSP_INCOTERMS as INCOTERMS,
					a.qty,
					c.lt_total_ssp,
					a.YYYYMMDD as departure_YYYYMMDD,
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
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
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'A'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD

select 'jjg13 : ' + convert(varchar(19), getdate(), 121)
 

set @V_KSG_TEMP = 'bbb  320';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            SEQ,
				operation_group,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID, 
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            to_plant_id AS TO_SITE,  
				INCOTERMS,
				'320'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
	            isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_bbb a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			group by DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 SEQ,
					 operation_group,
					 ITEM_ID,
					 to_plant_id,  
					 INCOTERMS,
					 left(a.arrival_YYYYMMDD,6)

          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    4.Semi WH-IN
          -------------------------------------------------------------------------------------------------------------  

select 'jjg14 : ' + convert(varchar(19), getdate(), 121)

set @V_KSG_TEMP = '4.Semi WH-IN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            SEQ,
				operation_group,
				'-' as FROM_SITE,  
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as incoterms,
				'340'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_bbb a WITH(NOLOCK)
			where PLANT_ID <> to_plant_id
			group by DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 SEQ,
					 operation_group,
					 ITEM_ID,
					 left(a.arrival_YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  


select 'jjg15 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '3.IN_HOUSE_MOVING';  


-- 10초 소요됨.

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            a.SEQ,
				c.OPERATION_GROUP_ID,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
				B.child_item_id,
	            'IN_HOUSE_MOVING' as MEASURE,
--				a.LINE_ID,   
				'-' as LINE_ID,   
                0 as BOH_QTY,
--	            '-' as TO_SITE,
	            a.PLANT_ID as TO_SITE,
				'-' as INCOTERMS,
				'330'  as SEQ_FLAG,  
				a.YYYYMM,
				isnull(sum(isnull(a.QTY,0) * isnull(b.accumulated_child_qty,1) / isnull(y.yield,1)),0) as QTY  -- pack, cell 수율반영
			FROM #tmp_SCP_ANL_PSI_INTEGRATION a
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = a.DIVISION_ID
					and b.plant_id = a.plant_id
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_final_item c WITH(NOLOCK)
					on c.item_id = B.child_item_id
					and c.DIVISION_ID = a.DIVISION_ID
					and c.OPERATION_GROUP_ID = 'A'  
					and c.attribute8 = 'CP'
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
			where a.SEQ_FLAG = '150'  
			group by a.DIVISION_ID,
					 a.COMPANY_ID,
					 a.PLANT_ID,
					 a.PLAN_START_YYYYMMDD,
					 a.SEQ,
					 c.OPERATION_GROUP_ID,
				     a.CELL_ITEM_ID,
		             B.child_item_id,
					 a.LINE_ID,
					 a.YYYYMM

          -------------------------------------------------------------------------------------------------------------                         
          -- 3. 셀 제품 ( N/A : 없음)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  

select 'jjg16 : ' + convert(varchar(19), getdate(), 121)  -- 위의 쿼리 10초 소요 되었음.


set @V_KSG_TEMP = '5.PROD_PLAN';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				b.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.operation_group,
				'-'  as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				'-' as TO_SITE, 
				'-' as INCOTERMS,
				'350'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(a.QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = a.DIVISION_ID
				 and b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = a.DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE			
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			  AND a.PLAN_TYPE			= @V_PLAN_TYPE
			  AND a.SEQ					= @V_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_DIVISION_ID
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'A'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					 b.COMPANY_ID,
					 b.PLANT_ID,
				     a.PLAN_START_YYYYMMDD,
				     a.SEQ,
					 a.operation_group,
				     a.ITEM_ID,
					 left(a.YYYYMMDD,6)


          -------------------------------------------------------------------------------------------------------------                         
          -- 4. 셀 반제품 ( N/A : 4.1, 4.2, 4.4)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  

select 'jjg17 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = '3.IN_HOUSE_MOVING';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            a.SEQ,
				a.operation_group,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            x.item_id_assy as ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
--	            a.TO_SITE,  
	            a.PLANT_ID as TO_SITE,  
				'-' as INCOTERMS,
				'430'  as SEQ_FLAG, 
				a.YYYYMM as YYYYMM,
				isnull(sum(isnull(a.QTY,0)  / isnull(y.scp_fromation_yield,1)),0) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
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
				       and x.item_id_prod = a.ITEM_ID
				-- 활성화 수율 가져오기 
				left join ( SELECT	a.DIVISION_ID, ITEM_ID, x.PLANT_ID 
									, CASE  WHEN ISNULL(a.ssp_modify_yield, -99) = -99 THEN
												 CASE WHEN formation_total_yield = 0 THEN 1
													  WHEN formation_total_yield > 1 THEN 1
													  ELSE ISNULL(formation_total_yield, 1)
												 END  
											ELSE 
												 CASE WHEN ssp_modify_yield = 0 THEN 1
													  WHEN ssp_modify_yield > 1 THEN 1
													  ELSE ISNULL(ssp_modify_yield, 1)
												 END
									  END AS scp_fromation_yield   
								FROM   [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_formation a WITH (NOLOCK)
								left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
									 on  x.DIVISION_ID = a.DIVISION_ID
									 and x.SCM_SITE_ID = a.PLANT_SITE_ID
								where 1=1
								and a.division_id = @V_DIVISION_ID 
								) y
					on y.division_id = a.DIVISION_ID
					and y.plant_id = a.PLANT_ID
					and y.item_id =x.ITEM_ID_ASSY
			where a.SEQ_FLAG = '350'  
			group by a.DIVISION_ID,
					 a.COMPANY_ID,
					 a.PLANT_ID,
				     a.PLAN_START_YYYYMMDD,
				     a.SEQ,
					 a.operation_group,
					 x.item_id_assy,
	            --     a.TO_SITE,
					 a.YYYYMM

          -------------------------------------------------------------------------------------------------------------                         
          -- 4. 셀 반제품 ( N/A : 4.1, 4.2, 4.4)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    0.  MKT_FCST
          ------------------------------------------------------------------------------------------------------------- 
		  
select 'jjg18 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '0.  MKT_FCST EE';	 
/*
	INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				LINE_ID,
                BOH_QTY,
	            TO_SITE,
				INCOTERMS,
				SEQ_FLAG,
				YYYYMM,
				QTY
			 )
         SELECT @V_DIVISION_ID, 
				'-'  as COMPANY_ID,   
				'-'  as PLANT_ID,     
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.operation_group,
				'-' as FROM_SITE,
                a.CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'MKT_FCST' as MEASURE,
				''  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ) AS TO_SITE,
				a.incoterms, 
				'500'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_ANL_PSI_GLOBAL a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on  x.DIVISION_ID = @V_DIVISION_ID
				 and x.SCM_SITE_ID = a.to_SITE
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  and a.measure = 'MKT_FCST' 
			  AND a.operation_group = 'E'
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD
			group by a.DIVISION_ID,
					a.PLAN_START_YYYYMMDD,
					a.SEQ,
					a.operation_group,
					a.CELL_ITEM_ID,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ),
					a.incoterms,
					left(a.YYYYMMDD,6)
*/

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    1.Ship. Plan(RTF)
          -------------------------------------------------------------------------------------------------------------
	
select 'jjg19 : ' + convert(varchar(19), getdate(), 121)
set @V_KSG_TEMP = '1.Ship. Plan(RTF) EE';	 	  

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				B.PLANT_ID,  
				a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.OPERATION_GROUP,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            a.ITEM_ID,
	            'SHIP_PLAN_RTF' as MEASURE,
				'-'  as LINE_ID,   
                0 as BOH_QTY,
				(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ),
				'-' as INCOTERMS,
				'510'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(a.ALLOCATION_QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCP_PLN_RTF_ALLOCATION_V a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on  b.DIVISION_ID = @V_DIVISION_ID  
				 and b.SCM_SITE_ID = a.plant_site_id
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
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
					B.PLANT_ID,
					a.PLAN_START_YYYYMMDD,
					a.SEQ,
					a.OPERATION_GROUP,
					a.ITEM_ID,
					(case when x.SITE_TYPE = 'SALES' then a.sales_site_id
						when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
						else ''
						end ),
					left(a.YYYYMMDD,6) 


select 'jjg20 : ' + convert(varchar(19), getdate(), 121)

set @V_KSG_TEMP = '2.Ship. Plan(Semi) EE';	 
          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    2.Ship. Plan(Semi)
          ------------------------------------------------------------------------------------------------------------- 
			
			insert into #tmp_PSI_INTEGRATION_CCC
	        SELECT  a.DIVISION_ID,
					a.ORIGIN_FROM_DIVISION_ID,
					A.ORIGIN_TO_DIVISION_ID,
					b.COMPANY_ID,
					x.COMPANY_ID as to_COMPANY_ID,
					b.PLANT_ID,
					to_plant_id=(case when x.SITE_TYPE = 'SALES' then a.TO_SITE
								      when x.SITE_TYPE = 'PLANT' THEN x.PLANT_ID
									  else ''
									  end ),
					a.BOD_ID,
					a.PLAN_START_YYYYMMDD,
					a.SEQ,
					a.operation_group,
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
					arrival_YYYYMMDD = convert(varchar(8),dateadd(d, c.lt_total_ssp, a.yyyymmdd),112)
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_shipment_plan_semi a WITH(NOLOCK)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
				 on b.SCM_SITE_ID = a.FROM_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site x WITH(NOLOCK)
				 on x.SCM_SITE_ID = a.to_SITE
			left join [10.34.221.78,7433].lgce_scmprod.dbo.scp_mst_bod_n_v c with(nolock)
				  on c.division_id = @V_DIVISION_ID
				  and c.bod_id = a.bod_id 
			WHERE a.PLAN_START_YYYYMMDD	= @V_EE_PLAN_START_YYYYMMDD  
			  AND a.PLAN_TYPE			= @V_EE_PLAN_TYPE
			  AND a.SEQ					= @V_EE_PLAN_SEQ
			  AND a.DIVISION_ID			= @V_EE_DIVISION_ID  
			  AND (a.ORIGIN_FROM_DIVISION_ID = @V_DIVISION_ID or a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID)
			  AND a.measure = 'SHIP_PLAN_AMEND' 
			  and a.OPERATION_GROUP = 'E'   
			  AND a.YYYYMMDD <= @V_HORIZON_END_YYYYMMDD


select 'jjg21 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '2.Ship. Plan(Semi) EE 520';	 

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            SEQ,
				OPERATION_GROUP,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SHIP_PLAN_SEMI' as MEASURE,
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
			group by ORIGIN_FROM_DIVISION_ID,
					 COMPANY_ID,
					 PLANT_ID,
					 PLAN_START_YYYYMMDD,
					 SEQ,
					 operation_group,
					 ITEM_ID,
					 to_plant_id,
					 INCOTERMS,
					 left(a.arrival_YYYYMMDD,6)

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    4.Semi WH-IN
          ------------------------------------------------------------------------------------------------------------- 

select 'jjg22 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = '4.Semi WH-IN  EE';	

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            SEQ,
				OPERATION_GROUP,
				'-' AS FROM_SITE,
                '' as CELL_ITEM_ID,  
	            ITEM_ID,
	            'SEMI_WH_IN' as MEASURE,
				''  as LINE_ID,   
                0 as BOH_QTY,
	            '-' AS TO_SITE,  
				'-' AS INCOTERMS,
				'540'  as SEQ_FLAG,  
				left(a.arrival_YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM #tmp_psi_integration_ccc a WITH(NOLOCK)
			where a.COMPANY_ID <> a.to_COMPANY_ID
			and a.ORIGIN_TO_DIVISION_ID = @V_DIVISION_ID 
			group by ORIGIN_TO_DIVISION_ID,
					 to_COMPANY_ID,
					 to_plant_id,
					 PLAN_START_YYYYMMDD,
					 SEQ,
					 operation_group,
					 ITEM_ID,
					 TO_SITE,
					 left(a.arrival_YYYYMMDD,6)

/*
select *
into jjg22_tmp_SCP_ANL_PSI_INTEGRATION
from #tmp_SCP_ANL_PSI_INTEGRATION
*/

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  

select 'jjg23 : ' + convert(varchar(19), getdate(), 121)--여기까지 17초 됨.


set @V_KSG_TEMP = '3.IN_HOUSE_MOVING  EE';


			select y.operation_group,  a.version_id, a.division_id, a.company_id, a.site_id, a.plant_id, a.factory_id, a.plant_site_id, a.item_id, a.operation_id, a.line_id, a.month, a.yield
			into #tmp_YIELD_VER_H_V_A
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

			create index i_#tmp_YIELD_VER_H_V_A_01 on #tmp_YIELD_VER_H_V_A(item_id)
			
			
			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
	            a.SEQ,
				b.operation_group_id,
				'-' as FROM_SITE,
                '' as CELL_ITEM_ID, 
	            B.child_item_id as ITEM_ID,
	            'IN_HOUSE_MOVING' as MEASURE,
				'-'  as LINE_ID, 
                0 as BOH_QTY,
--	            '-' as TO_SITE,
	            substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as TO_SITE,
				'-' as INCOTERMS,
				'530'  as SEQ_FLAG, 
				a.YYYYMM,
				isnull(sum(a.QTY * isnull(b.accumulated_child_qty,1)  / isnull(y.yield,1)),0) as QTY
			FROM #tmp_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V b WITH(NOLOCK)
					on  b.division_id = @V_DIVISION_ID
					and b.plant_id = a.plant_id
					and b.operation_group_id = 'E' 
					and b.model_id = a.item_id
					and a.PLAN_START_YYYYMMDD between b.eff_start_date and b.eff_end_date  
			-- pack/cell 수율 반영 start 
			left join #tmp_YIELD_VER_H_V_A y 
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
				     a.SEQ,
					 b.operation_group_id,
		             B.child_item_id,
					 a.YYYYMM

          -------------------------------------------------------------------------------------------------------------                         
          -- 5. 전극 ( N/A : 없음)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  

select 'jjg24 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = '5.PROD_PLAN  EE';

		  INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
				b.PLANT_ID,
	            a.PLAN_START_YYYYMMDD,
	            a.SEQ,
				a.OPERATION_GROUP,
				'-' AS FROM_SITE,
                '' as CELL_ITEM_ID,
	            a.ITEM_ID,
	            'PROD_PLAN' as MEASURE,
				a.LINE_ID,
                0 as BOH_QTY,
	            '-' as TO_SITE,
				'-' as INCOTERMS,
				'550'  as SEQ_FLAG,  
				left(a.YYYYMMDD,6) as YYYYMM,
				isnull(sum(isnull(QTY,0)),0) as QTY
			FROM [10.34.221.78,7433].lgce_scmprod.dbo.scp_anl_production_plan a WITH(NOLOCK)
			inner join [10.34.221.78,7433].lgce_scmprod.dbo.scm_mst_site b WITH(NOLOCK)
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
					 b.PLANT_ID,
				     a.PLAN_START_YYYYMMDD,
				     a.SEQ,
					 a.OPERATION_GROUP,
					 a.ITEM_ID,
					 a.LINE_ID,
					 left(a.YYYYMMDD,6)

---- exec PR_SCP_ANL_PSI_INTEGRATION '81', '20240513'

          -------------------------------------------------------------------------------------------------------------                                         
          -- 9.1  CELL_ITEM_ID UPDATE
          ------------------------------------------------------------------------------------------------------------- 

select 'jjg25 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = 'CELL_ITEM_ID Pack';


				select model_id, child_item_id
				into #tmp_FINAL_ITEM_BOM_V
				FROM [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
				WHERE Y.CELL_TYPE			 = 'CP'		
				AND Y.OPERATION_GROUP_ID = 'A'
				and Y.DIVISION_ID        = @V_DIVISION_ID  -- 3742

				create index i_tmp_FINAL_ITEM_BOM_V_01 on #tmp_FINAL_ITEM_BOM_V(model_id)

                -- PACK 일경우 
				-- CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = X.ITEM_ID),'-')
													--and Y.DIVISION_ID        = X.DIVISION_ID
													--AND Y.CELL_TYPE			 = 'CP'		
													--AND Y.OPERATION_GROUP_ID = 'A'),'')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'  -- 전극 제외
				and isnull(x.CELL_ITEM_ID,'') < '0'




				-- 상위 모델 이용하여 CELL_ITEM_ID 적용
                UPDATE X
                   SET CELL_ITEM_ID      = isnull(( SELECT TOP 1 CHILD_ITEM_ID
													FROM #tmp_FINAL_ITEM_BOM_V AS Y WITH (NOLOCK)
													WHERE Y.MODEL_ID           = ( 	SELECT top 1 model_id
																					FROM SCM_MST_MODEL_ONE_LEVEL_BOM_V AS Y WITH (NOLOCK)
																					WHERE Y.DIVISION_ID        = X.DIVISION_ID
																					AND Y.child_item_id         = X.ITEM_ID
																					and y.plant_id = x.plant_id)),'-')
													--and Y.DIVISION_ID        = X.DIVISION_ID
													--AND Y.CELL_TYPE			 = 'CP'		
													--AND Y.OPERATION_GROUP_ID = 'A'),'')
                FROM #tmp_SCP_ANL_PSI_INTEGRATION X
                WHERE OPERATION_GROUP   = 'P'
				and left(x.SEQ_FLAG,1) <> '5'   
				and isnull(x.CELL_ITEM_ID,'') < '0'


select 'jjg26 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = 'CELL_ITEM_ID Cell';

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
				  FROM #tmp_SCP_ANL_PSI_INTEGRATION X 
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

select 'jjg27 : ' + convert(varchar(19), getdate(), 121)


set @V_KSG_TEMP = 'CELL_ITEM_ID MEB';

			----------------------------------------------------
			-- PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - start
			----------------------------------------------------
			UPDATE X
               SET X.CELL_ITEM_ID = isnull(Z.CELL_ITEM_ID,'')
              FROM #tmp_SCP_ANL_PSI_INTEGRATION X 
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



          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    3.IN_HOUSE_MOVING
          -------------------------------------------------------------------------------------------------------------  

select 'jjg28 : ' + convert(varchar(19), getdate(), 121)

set @V_KSG_TEMP = '3.IN_HOUSE_MOVING 222';

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
					i.LINE_ID,
					i.BOH_QTY,
					I.TO_SITE,
					'-' as INCOTERMS,
					'250' as SEQ_FLAG, 
					i.YYYYMM,
					isnull(sum(isnull(i.qty,0) * isnull(a.ACCUMULATED_CHILD_QTY,1) ),0) as QTY 
			from #tmp_SCP_ANL_PSI_INTEGRATION i with(nolock)
			left join [10.34.221.78,7433].lgce_scmprod.dbo.SCM_MST_BOM_EFFECTIVE_SN_V a with(nolock)
				on a.model_id = i.ITEM_ID
				and a.parent_item_id = i.ITEM_ID
				and a.division_id = i.division_id
				and a.COMPANY_ID = i.company_id 
				AND i.PLAN_START_YYYYMMDD BETWEEN a.eff_start_date and a.eff_end_date  
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
					i.BOH_QTY,
					I.TO_SITE,
					i.YYYYMM

          -------------------------------------------------------------------------------------------------------------                         
          -- 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4)
		  --    5.PROD_PLAN
          -------------------------------------------------------------------------------------------------------------  

select 'jjg29 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = '5.PROD_PLAN 222';

			INSERT INTO #tmp_SCP_ANL_PSI_INTEGRATION
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
--					i.LINE_ID,
					'-' as LINE_ID,
					i.BOH_QTY,
--					I.TO_SITE,
					i.PLANT_ID as TO_SITE,
					i.INCOTERMS,
					'230' as SEQ_FLAG,   
					i.YYYYMM,
					i.qty as QTY   
			from #tmp_SCP_ANL_PSI_INTEGRATION i with(nolock)
			where i.SEQ_FLAG in ('250')


-- INV 생성 START 

select 'jjg30 : ' + convert(varchar(19), getdate(), 121)



set @V_KSG_TEMP = 'INV';
			DECLARE @MIN_YYYYMM NVARCHAR(6)
			DECLARE @MAX_YYYYMM NVARCHAR(6)
			DECLARE @PRE_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMM NVARCHAR(6)
			DECLARE @PROC_YYYYMMDD NVARCHAR(8)

			SELECT @MIN_YYYYMM = substring(@V_PLAN_START_YYYYMMDD,1,6)

			select @MAX_YYYYMM=MAX(YYYYMM)  
			FROM #tmp_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
			WHERE DIVISION_ID =  @V_DIVISION_ID 
			AND PLAN_START_YYYYMMDD = @V_PLAN_START_YYYYMMDD 
			AND SEQ = @V_PLAN_SEQ  

			SET @PROC_YYYYMM = @MIN_YYYYMM

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
					insert into #tmp_SCP_ANL_PSI_INTEGRATION
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
							,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
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
					FROM #TMP_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK) 
					where not exists (  select 'y' 
										from #TMP_SCP_ANL_PSI_INTEGRATION b 
										where b.DIVISION_ID = a.DIVISION_ID
										and b.PLAN_START_YYYYMMDD = a.PLAN_START_YYYYMMDD
										and b.SEQ = a.SEQ
										and b.OPERATION_GROUP = a.OPERATION_GROUP
										and b.ITEM_ID = a.ITEM_ID
										and b.MEASURE = 'INV')
					and a.measure <> 'MKT_FCST'

					-- 첫번째 월의 재고(QTY) 반영
					update a set qty = ISNULL(( SELECT SUM(CASE WHEN MEASURE = 'INV' THEN  BOH_QTY
																WHEN MEASURE = 'SHIP_PLAN_SEMI' THEN  QTY * -1
																WHEN MEASURE = 'SHIP_PLAN_RTF' THEN  QTY * -1
																WHEN MEASURE = 'IN_HOUSE_MOVING' THEN  QTY * -1
																WHEN MEASURE = 'SEMI_WH_IN' THEN  QTY
																WHEN MEASURE = 'PROD_PLAN' THEN  QTY
																END) QTY
												FROM #TMP_SCP_ANL_PSI_INTEGRATION B WITH(NOLOCK)
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
					FROM #TMP_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)   
					where a.measure = 'INV'
					and a.YYYYMM=@PROC_YYYYMM

				END  
				ELSE -- 두번째 월부터 마지막 월까지 재고 생성.
				BEGIN

					insert into #tmp_SCP_ANL_PSI_INTEGRATION
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
							,a.SEQ
							,a.OPERATION_GROUP
							,a.FROM_SITE
							,a.CELL_ITEM_ID
							,a.ITEM_ID
							,'INV' AS MEASURE
							,'-' AS LINE_ID
							,a.BOH_QTY AS BOH_QTY
							,'-' AS TO_SITE
							,'-' AS INCOTERMS
							,LEFT(a.SEQ_FLAG,1) + '60' as seq_flag
							,@PROC_YYYYMM AS YYYYMM
							,ISNULL(A.QTY,0) + ISNULL(( SELECT SUM(CASE  WHEN b.MEASURE = 'SHIP_PLAN_SEMI' THEN  QTY * -1
																		 WHEN b.MEASURE = 'SHIP_PLAN_RTF' THEN  QTY * -1
																		 WHEN b.MEASURE = 'IN_HOUSE_MOVING' THEN  QTY * -1
																		 WHEN b.MEASURE = 'SEMI_WH_IN' THEN  QTY
																		 WHEN b.MEASURE = 'PROD_PLAN' THEN  QTY
																		 END) QTY
															FROM #TMP_SCP_ANL_PSI_INTEGRATION B WITH(NOLOCK)
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
					FROM #tmp_SCP_ANL_PSI_INTEGRATION a WITH(NOLOCK)
					where a.measure = 'INV'
					and a.YYYYMM=@PRE_YYYYMM 
				END

				SET @I = @I + 1

				SET @PROC_YYYYMMDD = CONVERT(VARCHAR(8),DATEADD(M, 1, @PROC_YYYYMMDD),112)
				SET @PRE_YYYYMM = @PROC_YYYYMM
				SET @PROC_YYYYMM = LEFT(@PROC_YYYYMMDD,6)

			END 

			-------------------------------------------------------------------------------------------------------------                         
			-- 이전 동일 수행건 삭제 후 수행내역 Insert
			-- 삭제 & insert   
			------------------------------------------------------------------------------------------------------------- 

select 'jjg31 : ' + convert(varchar(19), getdate(), 121)
return
-- exec PR_SCP_ANL_PSI_INTEGRATION_for_Proc_20240605 '81', '20240527'
set @V_KSG_TEMP = 'Delete';

			DELETE A FROM SCP_ANL_PSI_INTEGRATION A
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID

-- exec PR_SCP_ANL_PSI_INTEGRATION '81', '20240513'

set @V_KSG_TEMP = 'insert';
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
					,ISNULL(COMPANY_ID,'')
					,ISNULL(PLANT_ID,'')
					,PLAN_START_YYYYMMDD
					,SEQ
					,OPERATION_GROUP
					,FROM_SITE
					,CELL_ITEM_ID
					,ITEM_ID
					,MEASURE
					,LINE_ID
					,BOH_QTY
					,TO_SITE
					,ISNULL(INCOTERMS,'')
					,SEQ_FLAG
					,YYYYMM
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
			from #tmp_SCP_ANL_PSI_INTEGRATION

/* 운영 이관시 주석 처리 함.
			select * 
			from SCP_ANL_PSI_INTEGRATION a with(nolock)
			WHERE a.PLAN_START_YYYYMMDD	= @V_PLAN_START_YYYYMMDD
			AND a.SEQ					= @V_PLAN_SEQ
			AND a.DIVISION_ID			= @V_DIVISION_ID
			ORDER BY substring(SEQ_FLAG,1,1), ITEM_ID, YYYYMM, substring(SEQ_FLAG,2,1), TO_SITE
	*/
		
			drop table #tmp_SCP_ANL_PSI_INTEGRATION
			drop table #tmp_psi_integration_inv
			drop table #tmp_psi_integration_bbb
			drop table #tmp_psi_integration_ccc
			drop table #tmp_YIELD_VER_H_V_A

select 'jjg99 : ' + convert(varchar(19), getdate(), 121)
            
			-- TXN LOG                        
			SET @v_log_type     = N'TXN';          
			SET @n_log_count    = @@ROWCOUNT;                        
			SET @v_log_message  = N'INSERT INTO '+@v_table_id;                               
			SET @d_event_date   = SYSDATETIME();                                     
			SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);    
                        
			--EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
			--						 ,@p_log_type      =@v_log_type                        
			--						  ,@p_log_count     =@n_log_count                         
			--						  ,@p_log_message   =@v_log_message                         
			--						  ,@p_description   =@v_description                         
			--						  ,@p_event_date    =@d_event_date                         
			--						  ,@p_user_id       =@v_batch_user     

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
      SET @v_description  = @V_KSG_TEMP + N'  ERROR_LINE : ' + STR(ERROR_LINE());                        
      SET @d_event_date   = SYSDATETIME();                        
      --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                        
      --                          ,@p_log_type      =@v_log_type                        
      --                          ,@p_log_count     =@n_log_count                         
      --                          ,@p_log_message   =@v_log_message                         
      --                          ,@p_description   =@v_description                         
      --                          ,@p_event_date    =@d_event_date                         
      --                          ,@p_user_id       =@v_batch_user                        
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
    SET @v_description  = N'['+@V_KSG_TEMP+']['+@V_PLAN_START_YYYYMMDD+'][' + @v_exec_time + ']';                
    SET @d_event_date   =  SYSDATETIME()  ;                        

    --EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
    --                          ,@p_log_type      =@v_log_type                        
    --                          ,@p_log_count     =@n_log_count                         
    --                          ,@p_log_message   =@v_log_message                         
    --                          ,@p_description   =@v_description                         
    --                          ,@p_event_date    =@d_event_date                         
    --                          ,@p_user_id       =@v_batch_user                        
                              ;                        
    return 1  
	
end  



