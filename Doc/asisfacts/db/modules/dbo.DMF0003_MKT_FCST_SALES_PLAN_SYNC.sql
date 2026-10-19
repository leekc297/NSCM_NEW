---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : DMF0003_MKT_FCST_SALES_PLAN_SYNC
 * Description  : MKT_FCST & SALES_PLAN DATA SYNC
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20230607   chano0612 고희선님 요청으로 MKT_FCST 와 SALES_PLAN 데이터 SYNC
  */


CREATE PROCEDURE [dbo].[DMF0003_MKT_FCST_SALES_PLAN_SYNC]

	-- Add the parameters for the stored procedure here
	@p_division_id				NVARCHAR(MAX)		,
	@p_CREATED_BY               NVARCHAR(MAX)	

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	


	-- CUTOFF 변수 설정

	-- 스플릿관련 변수
	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
    DECLARE @v_division_id      NVARCHAR(MAX);
	DECLARE @v_created_by       NVARCHAR(MAX);

	--[2018-03-15][추가][사용자를 매개변수로 받아서 처리]
	--            [있는경우][매개변수로 처리]
	--			  [없는경우][ROLLING 에서 처리하므로 'CUTOFF'로 처리]
	IF ISNULL(@p_CREATED_BY, '') = ''
		SET @v_created_by = 'CUTOFF';
	ELSE
		SET @v_created_by = @p_CREATED_BY;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_MKT_FCST_SALES_PLAN_SYNC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' +'@v_created_by : ' +  ISNULL(@v_created_by, 'NULL');
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION SALES_PLAN_AMT_CREATE_LOCAL_KRW;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_division_id, @v_delimiter);    
		-- SELECT @max_loop_cnt  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
		-- SELECT Convert(NVARCHAR(10), @max_loop_cnt)  as '@max_loop_cnt (input된 division값)';  -- 확인용 81^82^83
PRINT ( 'A--' + CONVERT(NVARCHAR(30), GETDATE(), 121))		
        /*---------------------------------------------------------------*/
		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN	
			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				-- Loop Count +1씩 증가시킴
				SET @mst_loop_cnt = @mst_loop_cnt + 1;
				SET @v_division_id  = [dbo].[SCM_ARR_SPL_VAL] (@p_division_id  ,  @v_delimiter , @mst_loop_cnt) ;    
			END

          /*----------------------------- MULTI & SINGLE ROW START -------------------------------------------------------------*/
		  /*-- max_loop_cnt:전체 Row수 , mst_loop_cnt:1씩 증가시켜서 전체 Row수 까지만 로직을 수행하도록함 --*/
          IF       @mst_loop_cnt <= @max_loop_cnt  

		    BEGIN
				-- 기존 정보 삭제
				delete dbo.dm_pln_sales_plan
				-- where yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
				 where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
							   and a.division_id    = dm_pln_sales_plan.division_id
							   and a.project_code   = dm_pln_sales_plan.project_code
							   and a.scm_site_id    = dm_pln_sales_plan.scm_site_id
							   and a.item_id        = dm_pln_sales_plan.item_id
				       ) 
				 ;        
PRINT ( 'B--' + CONVERT(NVARCHAR(30), GETDATE(), 121))				                  
                -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서도 'MKT_FCST', 'RTF' 는 다시 계산.
				delete dbo.dm_pln_sales_plan
				 where yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
				   and division_id = @v_division_id
				   -- MKT/금형비처럼 사람이 넣은것 삭제.
				   and item_id in (select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id )
				   and MEASURE in ( 'MKT_FCST','CUST_FCST', 'RTF','RTF_SYS_RP','TMM_FCST' )  -- 20180417 modify skh  -- 20190709 KHSONG [CSR ID:4034895] 'RTF_SYS_RP' MEASURE 추가 -- 20200309 KHSONG TMM_FCST ADD
				;
PRINT ( 'C--' + CONVERT(NVARCHAR(30), GETDATE(), 121))						
				-- 2021.08.25
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE
				INTO #T_PRICE
				FROM SCM_MST_FUTURE_PRICE A
				WHERE DIVISION_ID = @v_division_id
					AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
					AND A.MEASURE IN ( 'KRW', 'LOC', 'USD' )
PRINT ( 'D--' + CONVERT(NVARCHAR(30), GETDATE(), 121))				   				            
				SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, CREATED_BY, CREATION_DATE
				INTO #T_MKT_FCST
				FROM DM_PLN_MKT_FCST A
				WHERE A.DIVISION_ID = @v_division_id
					-- and w.yyyymmdd >= convert(varchar, dateadd(week, datediff(week, 0, dateadd( dd, -1*7,  getdate() ) ), 7) , 112)
					and A.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
					and A.MEASURE IN ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')
					and A.ITEM_ID in ( select item_id  from dbo.scm_mst_item_sn WITH(NOLOCK) group by item_id)
PRINT ( 'E--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
				IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP_LOC') IS NOT NULL
					BEGIN 
						DROP TABLE  #SALES_PLAN_TEMP_LOC          
					END 
			  	--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				CREATE TABLE #SALES_PLAN_TEMP_LOC (
				DIVISION_ID			NVARCHAR(30)
				, PROJECT_CODE		NVARCHAR(50)
				, SCM_SITE_ID		NVARCHAR(30)
				, ITEM_ID			NVARCHAR(50)
				, DOM_EXP			NVARCHAR(3)
				, FCST_TYPE			NVARCHAR(20)
				, INCOTERMS			NVARCHAR(10)
				, MEASURE			NVARCHAR(50)
				, PLANT_SITE_ID		NVARCHAR(30)
				, YYYYMMDD			NCHAR(8)
				, CURRENCY			NVARCHAR(3)
				, QTY				NUMERIC(30,10)
				, CREATED_BY		NVARCHAR(150)
				, CREATION_DATE		DATETIME
				)

--SELECT * FROM #T_PRICE
PRINT ( 'F--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
				--PRINT 'EXEC_001                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)

				-- 신규 정보 추가

				-- Temp 테이블에 저장
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT INTO #SALES_PLAN_TEMP_LOC
					(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE)
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
						,w.CREATED_BY
						,w.CREATION_DATE
					from #T_MKT_FCST w  WITH(NOLOCK)
					left outer join #T_PRICE si WITH(NOLOCK)
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
					where w.measure in ('MKT_FCST','CUST_FCST','TMM_FCST', 'RTF','RTF_SYS_RP')  -- 20180417 modify skh  -- 20200309 KHSONG TMM_FCST ADD
				
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'SalesAmt_KRW'
								WHEN FP.MEASURE = 'LOC' THEN 'SalesAmt_LOC'
								WHEN FP.MEASURE = 'USD' THEN  'SalesAmt_USD'
								ELSE FP.MEASURE 
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'USD' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								end as qty
						, NULL, NULL
					from #T_MKT_FCST w  WITH(NOLOCK)
					join #T_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						--AND FP.MEASURE = 'KRW' 
					   )
					where w.measure = 'RTF_SYS_RP' --[C20201208-000087] ESS 'RTF' -> 'RTF_SYS_RP' 적용
				   -- Sales Plan을 Unsync 하고 한번이라도 수정한 건에 대해서는 삭제 하지 않음.
				   and NOT EXISTS (
							select A.DIVISION_ID
							  from SCM_MST_SITE_ITEM a WITH(NOLOCK)
								  ,dm_pln_sales_plan b WITH(NOLOCK)
							 where sales_plan_adjust_yn = 'N'
							   and a.ITEM_ID = b.ITEM_ID
							   and a.DIVISION_ID = b.DIVISION_ID
							   and a.PROJECT_CODE = b.PROJECT_CODE
							   and a.SCM_SITE_ID = b.SCM_SITE_ID
							   and b.LAST_UPDATED_BY not in ( 'SYSTEM','CUTOFF')
							   and yyyymmdd >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(getdate(), 'MON')), 112)
							   and a.division_id    = w.division_id
							   and a.project_code   = w.project_code
							   and a.scm_site_id    = w.scm_site_id
							   and a.item_id        = w.item_id
				       ) 
				
						
				------------------------------------------------------------------------------------------------------------------------
				-- 2020/08/06		hwi1993		[C20200803-000105] MKT FCST 금액 Measure 추가 개발 요청의 건
				------------------------------------------------------------------------------------------------------------------------
				UNION ALL 
				-- KRW 값을 계산
				select   w.DIVISION_ID
						,w.PROJECT_CODE
						,w.SCM_SITE_ID
						,w.ITEM_ID 
						,w.DOM_EXP
						,w.FCST_TYPE
						,w.INCOTERMS
						, CASE WHEN FP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								WHEN FP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
								END AS MEASURE
						,w.PLANT_SITE_ID
						,w.YYYYMMDD
						,fp.CURRENCY
						--,cast( STR( w.QTY * isnull (FP.PRICE , 1) , 20, 5 ) as numeric)
						, CASE WHEN FP.MEASURE = 'KRW' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								WHEN FP.MEASURE = 'LOC' THEN cast( STR( w.QTY * isnull (FP.PRICE , 0) , 20, 5 ) as numeric(30, 10))
								END AS QTY
						, NULL, NULL
					from #T_MKT_FCST w  WITH(NOLOCK)
					join #T_PRICE FP  WITH(NOLOCK)
					on (    FP.DIVISION_ID   = w.DIVISION_ID
						AND FP.PROJECT_CODE  = w.PROJECT_CODE
						AND FP.SCM_SITE_ID   = w.SCM_SITE_ID
						AND FP.ITEM_ID       = w.ITEM_ID
						AND FP.DOM_EXP       = w.DOM_EXP
						AND FP.FCST_TYPE     = w.FCST_TYPE
						AND FP.INCOTERMS     = w.INCOTERMS
						and FP.plant_site_id = w.plant_site_id
						AND FP.YYYYMMDD = ( select basis_start_date from [dbo].[SCM_SYS_CALENDAR_M] where basis_yyyymmdd = w.yyyymmdd )
						AND FP.MEASURE IN ( 'KRW' , 'LOC' )
					   )
					where w.measure = 'MKT_FCST'

PRINT ( 'G--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
				-- 확인용
				-- select * from #SALES_PLAN_TEMP_LOC;
				-- 테이블의 중복제거
				   BEGIN
					   DELETE 
					   FROM dbo.dm_pln_sales_plan 
					   WHERE exists(
								SELECT B.DIVISION_ID 
								  FROM #SALES_PLAN_TEMP_LOC B WITH(NOLOCK)
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
							  )
				   END
PRINT ( 'H--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
				--20191114 KHSONG SALES_PLAN 테이블 컬럼추가되어 에러발생으로 SELECT조건에 컬럼명을 추가
				INSERT  INTO  dbo.dm_pln_sales_plan 
				(DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10)
				SELECT distinct 
					   DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,YYYYMMDD,CURRENCY,QTY
					  ,ISNULL(CREATED_BY, @v_created_by) , ISNULL(CREATION_DATE, GETDATE())
					  ,@v_created_by, SYSDATETIME() as LAST_UPDATE_DATE
					  , NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
				FROM #SALES_PLAN_TEMP_LOC WITH(NOLOCK) 
PRINT ( 'I--' + CONVERT(NVARCHAR(30), GETDATE(), 121))
		    END
          /*----------------------------- MULTI & SINGLE ROW END ---------------------------------------------------------------*/

		END	
        /*---------------------------------------------------------------*/

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
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
   --  IF @v_log_message IS NULL
	  --SELECT 'success'
	;

    -- 종료 LOG
    IF @v_log_message IS NULL
		BEGIN
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '@p_division_id : ' + @p_division_id + ' / ' +'@v_created_by : ' +  ISNULL(@v_created_by, 'NULL');
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

  END;



