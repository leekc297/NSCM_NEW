
/*
 * Program ID   : PR_DM_MOBILE_SALES_PLAN_MONTH
 * Description  : Sales Plan AMT Create ( Local/KRW ) 소형용임시
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 08. 01    KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */

CREATE PROCEDURE [dbo].[PR_DM_MOBILE_SALES_PLAN_MONTH]

	-- Add the parameters for the stored procedure here
	--@p_division_id				NVARCHAR(MAX)		,
	--@p_CREATED_BY               NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

    DECLARE @v_division_id      NVARCHAR(MAX);
	DECLARE @v_created_by       NVARCHAR(MAX);
	DECLARE @v_start_date       NVARCHAR(MAX);

	SET @v_division_id = '40';
	SET @v_created_by = 'mobile_conv'
	SET @v_start_date = '20180801'  -- CONVERT(VARCHAR(6), GETDATE(), 112) + '01'  -- 당월1일부터
	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_MOBILE_SALES_PLAN_MONTH';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	


		    BEGIN
				-- 기존 정보 삭제
				delete dbo.dm_pln_sales_plan
				-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
				 where yyyymmdd >= @v_start_date
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @v_start_date
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       ) = 0
				 ;        
				                  
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dbo.dm_pln_sales_plan
				 where yyyymmdd >= @v_start_date
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF' )  -- 20180417 modify skh
				;
									   				            

				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP          
					END 
			  	SELECT TOP 0 * INTO #SALES_PLAN_TEMP  FROM dbo.dm_pln_sales_plan WITH(NOLOCK);



				-- 신규 정보 추가

				-- Temp 테이블에 저장
				INSERT INTO #SALES_PLAN_TEMP
				-- MKT FCST 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,@v_created_by
						,w.CREATION_DATE
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by					    --[2018-03-15][수정][입력받은 매개변수로 처리]		
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
					left outer join [dbo].[SCM_MST_FUTURE_PRICE] si WITH(NOLOCK)
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						-- and w.yyyymmdd      = si.yyyymmdd
						and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
					)
					where w.measure in ('MKT_FCST','CUST_FCST')  -- 20180417 modify skh
					and w.division_id = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					and w.yyyymmdd >= @v_start_date
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
				UNION ALL 
				-- RTF 값을 update 함.
				select   distinct
				         w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,w.MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,si.CURRENCY
						,w.QTY
						,@v_created_by
						,w.CREATION_DATE
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by					    --[2018-03-15][수정][입력받은 매개변수로 처리]		
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.dm_pln_mkt_fcst w WITH(NOLOCK)
					left outer join [dbo].[SCM_MST_FUTURE_PRICE] si WITH(NOLOCK)
					on ( 1=1
						and w.DIVISION_ID   = si.DIVISION_ID
						and w.PROJECT_CODE  = si.PROJECT_CODE
						and w.SCM_SITE_ID   = si.SCM_SITE_ID
						and w.ITEM_ID       = si.ITEM_ID
						and w.DOM_EXP       = si.dom_exp
						and w.fcst_type     = si.fcst_type
						and w.INCOTERMS     = si.INCOTERMS
						and w.plant_site_id = si.plant_site_id
						-- and w.yyyymmdd      = si.yyyymmdd
						and ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )     = si.yyyymmdd
					)
					where w.measure = 'RTF'
					and w.division_id = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					and w.yyyymmdd >= @v_start_date
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_KRW' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY						--[2018-03-15][수정]
						--,w.CREATION_DATE					--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY				--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE				--[2018-03-15][수정]
						,@v_created_by						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,@v_created_by						--[2018-03-15][수정]
						,GETDATE()							--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
					left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						-- AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'KRW' 
					   )
                    /*
					left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
					on ( 1=1
					and w.DIVISION_ID = si.DIVISION_ID
					and w.PROJECT_CODE = si.PROJECT_CODE
					and w.SCM_SITE_ID = si.SCM_SITE_ID
					and w.ITEM_ID = si.ITEM_ID
					)
					*/
					where w.measure = 'RTF'
					and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)   
					and w.yyyymmdd >= @v_start_date
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @v_start_date
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_LOC' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,FP.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY							--[2018-03-15][수정]
						--,w.CREATION_DATE						--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY					--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE					--[2018-03-15][수정]
						,@v_created_by							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,@v_created_by    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1	
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
					left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						--AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] WITH(NOLOCK) where basis_yyyymmdd = w.yyyymmdd )
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'LOC' 
					   )
					/*
					left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
					on ( 1=1
					and w.DIVISION_ID = si.DIVISION_ID
					and w.PROJECT_CODE = si.PROJECT_CODE
					and w.SCM_SITE_ID = si.SCM_SITE_ID
					and w.ITEM_ID = si.ITEM_ID
					)
					*/
					where w.measure = 'RTF'
					and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)   
				    and w.yyyymmdd >= @v_start_date   
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @v_start_date
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
				UNION ALL 
				-- LOC 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						,'SalesAmt_USD' MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,FP.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						,cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))  -- 20180404 SongKH numeric->numeric(30,10)으로 수정
						--,w.CREATED_BY								--[2018-03-15][수정]
						--,w.CREATION_DATE							--[2018-03-15][수정]
						--,w.LAST_UPDATED_BY						--[2018-03-15][수정]
						--,w.LAST_UPDATE_DATE						--[2018-03-15][수정]
						,@v_created_by								--[2018-03-15][수정]
						,GETDATE()									--[2018-03-15][수정]
						,@v_created_by    							--[2018-03-15][수정]
						,GETDATE()								--[2018-03-15][수정]
						,NULL -- ATTRIBUTE1
						,NULL -- ATTRIBUTE2
						,NULL -- ATTRIBUTE3
						,NULL -- ATTRIBUTE4
						,NULL -- ATTRIBUTE5
						,NULL -- ATTRIBUTE6
						,NULL -- ATTRIBUTE7
						,NULL -- ATTRIBUTE8
						,NULL -- ATTRIBUTE9
						,NULL -- ATTRIBUTE10
					from dbo.dm_pln_mkt_fcst w  WITH(NOLOCK)
					left outer join dbo.SCM_MST_FUTURE_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						--AND FP.YYYYMMDD = CASE WHEN SUBSTRING(W.YYYYMMDD, 7,2) = '01' then w.YYYYMMDD else   convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  end
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						--AND FP.YYYYMMDD = convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  cast( w.yyyymmdd as datetime ) ) ), 7) , 112)  
						AND FP.MEASURE = 'USD' 
					   )
                    /*  
					left outer join dbo.SCM_MST_SITE_ITEM si WITH(NOLOCK)
					on ( 1=1
					and w.DIVISION_ID = si.DIVISION_ID
					and w.PROJECT_CODE = si.PROJECT_CODE
					and w.SCM_SITE_ID = si.SCM_SITE_ID
					and w.ITEM_ID = si.ITEM_ID
					)
					*/
					where w.measure = 'RTF'
					and w.division_id = @v_division_id
				--	and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)    
				   and w.yyyymmdd >= @v_start_date     
					and w.item_id in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and (
							select count(1)
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= @v_start_date
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) = 0
					; 

				-- select * from #SALES_PLAN_TEMP;
				-- 테이블의 중복제거
				   BEGIN
					   DELETE 
					   FROM dbo.dm_pln_sales_plan 
					   WHERE (
								SELECT count(1) 
								  FROM #SALES_PLAN_TEMP B WITH(NOLOCK)
								 where 1=1
								   and dm_pln_sales_plan.DIVISION_ID    =  B.DIVISION_ID  
								   and dm_pln_sales_plan.PROJECT_CODE   =  B.PROJECT_CODE                          
								   and dm_pln_sales_plan.SCM_SITE_ID    =  B.SCM_SITE_ID                           
								   and dm_pln_sales_plan.ITEM_ID        =  B.ITEM_ID                               
								   and dm_pln_sales_plan.DOM_EXP        =  B.DOM_EXP                               
								   and dm_pln_sales_plan.FCST_TYPE      =  B.FCST_TYPE                             
								   and dm_pln_sales_plan.INCOTERMS      =  B.INCOTERMS                             
								   and dm_pln_sales_plan.MEASURE        =  B.MEASURE                               
								   and dm_pln_sales_plan.PLANT_SITE_ID  =  B.PLANT_SITE_ID                         
								   and dm_pln_sales_plan.YYYYMMDD       =  B.YYYYMMDD                              
							  ) > 0
				   END

				INSERT  INTO  dbo.dm_pln_sales_plan 
				SELECT distinct 
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,@v_created_by,CREATION_DATE,@v_created_by,SYSDATETIME() as LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
					  ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
				FROM #SALES_PLAN_TEMP WITH(NOLOCK) 

				-- Cut Off 데이터 생성 (Table : DM_PLN_SALES_PLAN_C)
				EXEC [dbo].PR_DM_PLN_SALES_PLAN_CUTOFF  
				                     @v_division_id               -- @p_division_id
									 ,'SALES_PLAN_MANUAL_CUTOFF'  -- @p_version_description
									 ,'SP_M'                      -- @@p_ver_type
									 ,@v_created_by               -- @p_created_by
									 ;
		    END


     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
