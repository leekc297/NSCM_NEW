/*
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV
 * Description  : Business Plan PRICE 계산 Procedure
 *                1. Procedure에서 저장시 : @s_flag = 'CALL'
					 (1) DMF0042_SAVE_DM_PLN_BP_FCST 프로시져에서 호출시 TEMP TABLE로 대상을 전달받음
                     (2) DM_PLN_BP_FCST 테이블에 생성할 FUTURE PRICE 금액을 생성하여 TEMP TABLE로 RETURN해줌
                  2. ui에서 Set Price 버튼을 클릭하여 전체 재계산 요청시 : @s_flag <> 'CALL'
					 (1) Division만 전달받아 전체 Item에 대하여 재계산수행함			
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 20190429 KHSONG Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 20190830 JSYOUN 81, 82 사업부에 따른 변경
 * 2020/04/09	P.C.I    [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020/06/12	hwi1993	 temp3 에 넣을 때 Price <> 0 조건 제거 ( 오류내역 : Loc 를 0으로 변경시, USD, KRW Price 가 변경안됨 )
 * 2020/08/25	hwi1993	[C20200820-000170] Business Plan. Set Price 버튼 클릭시 Amnt 메저들 업데이트( 현재는 Price 메저만 업데이트함 )
 * 2020/08/27	hwi1993	[C20200820-000170] Business Plan. 운영에서 실행시간이 너무 오래 걸려서 속도개선함.
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2021/07/23	hwi1993	incoterms 추가 등 ( 중장기계획 과제 관련 ) 
 * 2021/08/06	hwi1993	MKT FCST 메저 추가
 * 2022/06/21	rosia27	[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 */

CREATE PROCEDURE [dbo].[DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV]

	-- Add the parameters for the stored procedure here
	 @s_flag                   NVARCHAR(MAX),
	 @s_division_id            NVARCHAR(MAX)

AS

PRINT 'EXEC_001                                       =>  ' + CONVERT(VARCHAR(8), GETDATE(), 108)
BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- cursor 별 로딩할 변수설정
    DECLARE @v_DIVISION_ID           nvarchar(MAX)    ;
    DECLARE @v_PROJECT_CODE          nvarchar(MAX)    ;
    DECLARE @v_PROJECT_NAME          nvarchar(MAX)    ;
    DECLARE @v_SCM_SITE_ID           nvarchar(MAX)    ;
    DECLARE @v_PLANT_SITE_ID         nvarchar(MAX)    ;
    DECLARE @v_ITEM_ID               nvarchar(MAX)    ;
    DECLARE @v_YYYYMM                nvarchar(MAX)    ;
    DECLARE @v_CURRENCY              nvarchar(MAX)    ;
    DECLARE @v_MEASURE               nvarchar(MAX)    ;
    DECLARE @v_DOM_EXP               nvarchar(MAX)    ;
    DECLARE @v_FCST_TYPE             nvarchar(MAX)    ;
    DECLARE @v_INCOTERMS             nvarchar(MAX)    ;-- [PJ20200138] Incoterms 삭제
	-- [PJ20200138] item_use, unit_energy 추가
    DECLARE @v_ITEM_USE			     nvarchar(MAX)	  ;
    DECLARE @v_UNIT_ENERGY	         numeric(30,10)	  ;
	DECLARE @v_CELL_PROD_SITE		 nvarchar(MAX)	  ;
    DECLARE @v_PRICE                 numeric(30,10)   ;
    DECLARE @v_CREATED_BY            nvarchar(MAX)    ;
    DECLARE @v_CREATION_DATE         DATETIME         ;
    DECLARE @v_LAST_UPDATED_BY       nvarchar(MAX)    ;
    DECLARE @v_LAST_UPDATE_DATE      DATETIME         ;
    DECLARE @v_ROW_COUNT             nvarchar(MAX)    ;

    -- 20190830 추가
    DECLARE  @v_DEPT_ID              NVARCHAR(MAX)    ;    
    DECLARE  @v_END_CUSTOMER         NVARCHAR(MAX)    ;    
    DECLARE  @v_BIZ_TYPE             NVARCHAR(MAX)    ;

    DECLARE @n1_MEASURE              nvarchar(MAX)    ;
    DECLARE @n2_MEASURE              nvarchar(MAX)    ;
    DECLARE @n1_PRICE                numeric(30,10)   ;
    DECLARE @n2_PRICE                numeric(30,10)   ;
	


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		--SET @v_description = 'DIVISION_ID : ' + @p_division_id;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		--BEGIN TRANSACTION DM_PLN_BP_FCST_PRICE_CONV;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		
		BEGIN	

			-- Temp Table0 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP0') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP0
				END 


			CREATE TABLE #FUTURE_PRICE_TEMP0 (
										 DIVISION_ID        NVARCHAR(MAX)
										,PROJECT_CODE       NVARCHAR(MAX)
										,PROJECT_NAME       NVARCHAR(MAX)
										,SCM_SITE_ID        NVARCHAR(MAX)
										,ITEM_ID            NVARCHAR(MAX)
										,DOM_EXP            NVARCHAR(MAX)
										,FCST_TYPE          NVARCHAR(MAX)
										,INCOTERMS          NVARCHAR(MAX)-- [PJ20200138] Incoterms 삭제
										-- [PJ20200138] item_use, unit_energy 추가	
										,ITEM_USE			NVARCHAR(MAX)
										,UNIT_ENERGY		NVARCHAR(MAX)
										,CELL_PROD_SITE		NVARCHAR(MAX)
										,MEASURE            NVARCHAR(MAX)
										,PLANT_SITE_ID      NVARCHAR(MAX)
										,YYYYMM			    NVARCHAR(MAX)
										,CURRENCY           NVARCHAR(MAX)
										,QTY	            NVARCHAR(MAX)
                                        -- 20190830 추가
										,DEPT_ID            NVARCHAR(MAX)
										,END_CUSTOMER       NVARCHAR(MAX)
										,BIZ_TYPE           NVARCHAR(MAX)
										
                                        ,G_COUNT            BIGINT
										  )

			-- Temp Table2 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP2') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP2          
				END

			CREATE TABLE #FUTURE_PRICE_TEMP2 (
										 DIVISION_ID        NVARCHAR(MAX)
										,PROJECT_CODE       NVARCHAR(MAX)
										,PROJECT_NAME       NVARCHAR(MAX)
										,SCM_SITE_ID        NVARCHAR(MAX)
										,ITEM_ID            NVARCHAR(MAX)
										,DOM_EXP            NVARCHAR(MAX)
										,FCST_TYPE          NVARCHAR(MAX)
										,INCOTERMS          NVARCHAR(MAX)-- [PJ20200138] Incoterms 삭제
										-- [PJ20200138] item_use, unit_energy 추가	
										,ITEM_USE			NVARCHAR(MAX)
										,UNIT_ENERGY		NVARCHAR(MAX)
										,CELL_PROD_SITE		NVARCHAR(MAX)
										,MEASURE            NVARCHAR(MAX)
										,PLANT_SITE_ID      NVARCHAR(MAX)
										,YYYYMM			    NVARCHAR(MAX)
										,CURRENCY           NVARCHAR(MAX)
										,QTY	            NVARCHAR(MAX)
                                        -- 20190830 추가
										,DEPT_ID            NVARCHAR(MAX)
										,END_CUSTOMER       NVARCHAR(MAX)
										,BIZ_TYPE           NVARCHAR(MAX)
										
										,G_COUNT            BIGINT
										,ROW_COUNT          BIGINT
										  )

				IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP_QTY') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP_QTY          
				END						  
						CREATE TABLE #FUTURE_PRICE_TEMP_QTY (
										 DIVISION_ID        NVARCHAR(MAX)
										,PROJECT_CODE       NVARCHAR(MAX)
										,PROJECT_NAME       NVARCHAR(MAX)
										,SCM_SITE_ID        NVARCHAR(MAX)
										,ITEM_ID            NVARCHAR(MAX)
										,DOM_EXP            NVARCHAR(MAX)
										,FCST_TYPE          NVARCHAR(MAX)
										,INCOTERMS          NVARCHAR(MAX)-- [PJ20200138] Incoterms 삭제
										-- [PJ20200138] item_use, unit_energy 추가	
										,ITEM_USE			NVARCHAR(MAX)
										,UNIT_ENERGY		NVARCHAR(MAX)
										,CELL_PROD_SITE		NVARCHAR(MAX)
										,MEASURE            NVARCHAR(MAX)
										,PLANT_SITE_ID      NVARCHAR(MAX)
										,YYYYMM			    NVARCHAR(MAX)
										,CURRENCY           NVARCHAR(MAX)
										,QTY	            NVARCHAR(MAX)
                                        -- 20190830 추가
										,DEPT_ID            NVARCHAR(MAX)
										,END_CUSTOMER       NVARCHAR(MAX)
										,BIZ_TYPE           NVARCHAR(MAX)
										
										,G_COUNT            BIGINT
										,ROW_COUNT          BIGINT
										  )

			----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- PROCEDURE 에서 #TEMP_BP_FCST 테이블로 CALL받은경우
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			IF @s_flag = 'CALL'
				BEGIN
					--임시확인
					--SELECT '#TEMP_BP_FCST'
					--SELECT * FROM #TEMP_BP_FCST

					
					insert into #FUTURE_PRICE_TEMP0
					SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,'' AS DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제
						  ,ITEM_USE, UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
						  ,CELL_PROD_SITE
					      ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) AS QTY
                          ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                          ,COUNT(*) AS G_COUNT 
					 FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE 1=1
						  --AND DIVISION_ID = @p_division_id
						  --AND YYYYMM >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터만 대상으로함
						  AND MEASURE NOT IN ('Business_Plan', 'MKT_FCST')
   					  GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
					   ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE, MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE

				END
			ELSE
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 전체대상인경우
			----------------------------------------------------------------------------------------------------------------------------------------------------------
				BEGIN
					insert into #FUTURE_PRICE_TEMP0
					SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제
						  ,ITEM_USE, UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
						  ,CELL_PROD_SITE
					      ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) AS QTY
                          ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                          ,COUNT(*) AS G_COUNT 
					 FROM dbo.DM_PLN_BP_FCST WITH(NOLOCK) WHERE 1=1
						  AND DIVISION_ID = @s_division_id
						  --AND YYYYMM >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일이후 데이터만 대상으로함
   					  GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
					   ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,DEPT_ID,END_CUSTOMER,BIZ_TYPE
				END

			-- Temp Table1 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP1') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP1
				END 

			-- 임시확인
			--SELECT '#FUTURE_PRICE_TEMP0'
			--SELECT * FROM #FUTURE_PRICE_TEMP0

			-- Temp Table1 에 작업대상을 저장
			SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제
				  ,ITEM_USE, UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
				  ,CELL_PROD_SITE
			      ,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,MAX(QTY) AS QTY
                  ,DEPT_ID,END_CUSTOMER,BIZ_TYPE-- 20190830 추가
                  ,G_COUNT 
				 INTO #FUTURE_PRICE_TEMP1
			 FROM #FUTURE_PRICE_TEMP0 WITH(NOLOCK) WHERE 1=1
					  --AND G_COUNT < 3     -- 3개 정상 셋트가 아닌경우만 대상으로함 -> 20180720 KHSONG 주석처리 전체를 다시 계산함
   		      GROUP BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE
			   ORDER BY DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,ITEM_USE, UNIT_ENERGY,CELL_PROD_SITE,MEASURE,PLANT_SITE_ID,YYYYMM,CURRENCY,G_COUNT,DEPT_ID,END_CUSTOMER,BIZ_TYPE

			-- 임시확인
			--SELECT '#FUTURE_PRICE_TEMP1'
			--SELECT * FROM #FUTURE_PRICE_TEMP1

			
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- PROCEDURE 에서 #TEMP_BP_FCST 테이블로 CALL받은경우
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			IF @s_flag = 'CALL'
				BEGIN
					-- 대상데이터 INSERT
					insert into #FUTURE_PRICE_TEMP2
					SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.ITEM_ID,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS-- [PJ20200138] Incoterms 삭제
					      ,B.ITEM_USE, B.UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
						  ,B.CELL_PROD_SITE
					      ,B.MEASURE,B.PLANT_SITE_ID,B.YYYYMM,B.CURRENCY,B.QTY
                          ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE-- 20190830 추가
                          ,G_COUNT,row_number() OVER (ORDER BY B.DIVISION_ID) AS ROW_COUNT
					 FROM #FUTURE_PRICE_TEMP1 B WITH(NOLOCK)
					ORDER BY G_COUNT

					
					-- Business Plan 메저만 별도 저장
					insert into #FUTURE_PRICE_TEMP_QTY
					SELECT *
					FROM #FUTURE_PRICE_TEMP2
					WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST')

				END

			ELSE
			----------------------------------------------------------------------------------------------------------------------------------------------------------
			-- 전체대상인경우
			----------------------------------------------------------------------------------------------------------------------------------------------------------
				BEGIN
					-- 대상데이터 INSERT
					insert into #FUTURE_PRICE_TEMP2
					SELECT B.DIVISION_ID,B.PROJECT_CODE,B.PROJECT_NAME,B.SCM_SITE_ID,B.ITEM_ID,B.DOM_EXP,B.FCST_TYPE,B.INCOTERMS-- [PJ20200138] Incoterms 삭제
					      ,B.ITEM_USE, B.UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
						  ,B.CELL_PROD_SITE
					      ,B.MEASURE,B.PLANT_SITE_ID,B.YYYYMM,B.CURRENCY,B.QTY
                          ,B.DEPT_ID,B.END_CUSTOMER,B.BIZ_TYPE-- 20190830 추가
                          ,G_COUNT,row_number() OVER (ORDER BY B.DIVISION_ID) AS ROW_COUNT
					 FROM #FUTURE_PRICE_TEMP1 B WITH(NOLOCK)
					ORDER BY G_COUNT

					-- Business Plan 메저만 별도 저장
					insert into #FUTURE_PRICE_TEMP_QTY
					SELECT *
					FROM #FUTURE_PRICE_TEMP2
					WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST')

				END

			-- 임시확인
			--SELECT '#FUTURE_PRICE_TEMP2'
			--SELECT * FROM #FUTURE_PRICE_TEMP2

			-- Temp Table3 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP3') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP3
				END 

			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP3') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP3
				END 

			SELECT TOP 0 * INTO #FUTURE_PRICE_TEMP3
				FROM dbo.DM_PLN_BP_FCST WITH(NOLOCK) ;  -- TEMP 테이블 컬럼생성

			-- 임시확인
			--SELECT '#FUTURE_PRICE_TEMP2'
			--DROP TABLE TEMP_SKH_0605_FUTURE_PRICE_TEMP2
			--SELECT * INTO TEMP_SKH_0605_FUTURE_PRICE_TEMP2
			--FROM #FUTURE_PRICE_TEMP2
--SELECT * FROM #FUTURE_PRICE_TEMP2
--SELECT * FROM #FUTURE_PRICE_TEMP_QTY

			-- 변수선언
			--declare @ROW_COUNT nvarchar(2)
			DECLARE @V_BP_QTY NUMERIC(30,10)	-- [C20200820-000170]
			

			-- 데이터 확인하여 INSERT
		    -- 커서 확인후 초기화
			IF  EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'future_price_cur') 
			BEGIN
				close future_price_cur
				deallocate future_price_cur
			END;

			declare future_price_cur cursor fast_forward for
			select   A.DIVISION_ID     
					   ,A.PROJECT_CODE    
					   ,A.PROJECT_NAME
					   ,A.SCM_SITE_ID     
					   ,A.PLANT_SITE_ID   
					   ,A.ITEM_ID         
					   ,A.YYYYMM        
					   ,A.CURRENCY        
					   ,A.MEASURE         
					   ,A.DOM_EXP         
					   ,A.FCST_TYPE       
					   ,A.INCOTERMS-- [PJ20200138] Incoterms 삭제
					   -- [PJ20200138] item_use, unit_energy 추가	
					   ,A.ITEM_USE
					   ,A.UNIT_ENERGY
					   ,A.CELL_PROD_SITE
					   ,A.QTY           
                       -- 20190830 추가
                       ,A.DEPT_ID
                       ,A.END_CUSTOMER
                       ,A.BIZ_TYPE

					   ,A.ROW_COUNT
					   ,B.QTY AS BP_QTY
				from #FUTURE_PRICE_TEMP2 A
				JOIN #FUTURE_PRICE_TEMP_QTY B ON 
												A.DIVISION_ID = B.DIVISION_ID 
												AND A.PROJECT_CODE = B.PROJECT_CODE 
												AND A.SCM_SITE_ID = B.SCM_SITE_ID 
												AND A.ITEM_ID = B.ITEM_ID 
												AND A.CELL_PROD_SITE = B.CELL_PROD_SITE 
												AND A.FCST_TYPE = B.FCST_TYPE 
												AND A.PLANT_SITE_ID= B.PLANT_SITE_ID 
												AND A.DEPT_ID = B.DEPT_ID 
												AND A.END_CUSTOMER = B.END_CUSTOMER 
												AND A.BIZ_TYPE = B.BIZ_TYPE 
												AND A.YYYYMM = B.YYYYMM 
												AND A.CURRENCY = B.CURRENCY 
												AND A.ITEM_USE = B.ITEM_USE 
												AND A.UNIT_ENERGY= B.UNIT_ENERGY
												AND A.INCOTERMS= B.INCOTERMS
				where A.measure = 'LOC'
				ORDER BY A.ROW_COUNT

		    -- 커서 오픈
			open future_price_cur;

			--------------------------------------------------------------------------------------------------------
			fetch next from future_price_cur into
                        @v_DIVISION_ID     
					   ,@v_PROJECT_CODE    
					   ,@v_PROJECT_NAME    
					   ,@v_SCM_SITE_ID     
					   ,@v_PLANT_SITE_ID   
					   ,@v_ITEM_ID         
					   ,@v_YYYYMM        
					   ,@v_CURRENCY        
					   ,@v_MEASURE         
					   ,@v_DOM_EXP         
					   ,@v_FCST_TYPE       
					   ,@v_INCOTERMS  -- [PJ20200138] Incoterms 삭제    
					   -- [PJ20200138] item_use, unit_energy 추가	
					   ,@v_ITEM_USE
					   ,@v_UNIT_ENERGY 
					   ,@v_CELL_PROD_SITE
					   ,@v_PRICE       
                       -- 20190830 추가
                       ,@v_DEPT_ID
                       ,@v_END_CUSTOMER
                       ,@v_BIZ_TYPE
    
					   ,@v_ROW_COUNT
					   ,@V_BP_QTY
			--------------------------------------------------------------------------------------------------------
			while @@FETCH_STATUS = 0 
			--------------------------------------------------------------------------------------------------------
			BEGIN
			--------------------------------------------------------------------------------------------------------
			  --확인 SELECT @ROW_COUNT AS '@ROW_COUNT'
			  --확인 SELECT * FROM #FUTURE_PRICE_TEMP2  WHERE ROW_COUNT = @ROW_COUNT

			  -- 변수 초기화
			  SET @n1_MEASURE = NULL;
			  SET @n2_MEASURE = NULL;
			  SET @n1_PRICE   = 0;
			  SET @n2_PRICE   = 0;

			  -- 임시확인
			  --SELECT '@v_MEASURE',@v_MEASURE,'@v_CURRENCY',@v_CURRENCY
			--------------------------------------------------------------------------------------------------------
			  IF  @v_MEASURE='LOC' AND @v_CURRENCY = 'KRW'   -- LOCAL CURRENCY 가 KRW 인경우 INPUT PRICE 그대로 사용하면됨
			      BEGIN
				    -- KRW SETTING
				    set @n1_MEASURE = 'KRW'
				    set @n1_PRICE   = @v_PRICE

				    -- USD 산출
				    set @n2_MEASURE = 'USD'
                    SET @n2_PRICE = ISNULL(@v_PRICE / ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_BP_EXCHANGE_RATE WITH(NOLOCK) where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END

			  IF  @v_MEASURE='LOC' AND @v_CURRENCY = 'USD'   -- LOCAL CURRENCY 가 USD 인경우 INPUT PRICE 그대로 사용하면됨
			      BEGIN
				    -- USD SETTING
				    set @n1_MEASURE = 'USD'
				    set @n1_PRICE   = @v_PRICE

				    -- KRW 산출
				    set @n2_MEASURE = 'KRW'
                    SET @n2_PRICE = ISNULL(@v_PRICE * ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_BP_EXCHANGE_RATE WITH(NOLOCK) where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END

			  IF  @v_MEASURE='LOC' AND @v_CURRENCY NOT IN ('KRW','USD')
			      BEGIN
				    set @n1_MEASURE = 'KRW'
				    -- KRW 산출
                    SET @n1_PRICE = @v_PRICE * ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_BP_EXCHANGE_RATE WITH(NOLOCK) where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = @v_CURRENCY),1)
				    set @n2_MEASURE = 'USD'
                    SET @n2_PRICE = ISNULL(@n1_PRICE / ISNULL((SELECT EXCHANGE_PRICE FROM dbo.DM_BP_EXCHANGE_RATE WITH(NOLOCK) where DIVISION_ID = @v_DIVISION_ID  
			                                   AND YYYYMMDD = SUBSTRING(@v_YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD'),1),0)
			      END

				-- 임시확인
				--SELECT   @v_DIVISION_ID,@v_PROJECT_CODE,@v_PROJECT_NAME,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMM,@v_CURRENCY,@n2_MEASURE     
				--		,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS,ROUND(@n2_PRICE,3),'SYSTEM',SYSDATETIME(),'SYSTEM',SYSDATETIME()

			  IF  @n1_MEASURE IS NOT NULL -- AND @n1_PRICE > 0
			    BEGIN
					-- PRICE INSERT #1
					insert into  #FUTURE_PRICE_TEMP3
						(DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제						
					    ,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
						,CELL_PROD_SITE
						,QTY
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
					values
						(@v_DIVISION_ID,@v_PROJECT_CODE,@v_PROJECT_NAME,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMM,@v_CURRENCY,@n1_MEASURE
						,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS -- [PJ20200138] Incoterms 삭제
						,@v_ITEM_USE,@v_UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
						,@v_CELL_PROD_SITE
						,ROUND(@n1_PRICE,3),'SYSTEM',SYSDATETIME(),'SYSTEM',SYSDATETIME()  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
						,null,null,null,null,null,null,null,null,null,null
                        ,@v_DEPT_ID,@v_END_CUSTOMER,@v_BIZ_TYPE)  -- 20190830 추가

					IF @s_flag <> 'CALL'
					BEGIN
						-- Amount INSERT #1
						insert into  #FUTURE_PRICE_TEMP3
							(DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제						
							,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가	
							,CELL_PROD_SITE
							,QTY
							,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
							,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
						values
							(@v_DIVISION_ID,@v_PROJECT_CODE,@v_PROJECT_NAME,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMM,@v_CURRENCY, N'SalesAmt_' + @n1_MEASURE
							,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS-- [PJ20200138] Incoterms 삭제
							,@v_ITEM_USE,@v_UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
							,@v_CELL_PROD_SITE
							,ROUND(@n1_PRICE * @V_BP_QTY,3)
							,'SYSTEM',SYSDATETIME(),'SYSTEM',SYSDATETIME()  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
							,null,null,null,null,null,null,null,null,null,null
							,@v_DEPT_ID,@v_END_CUSTOMER,@v_BIZ_TYPE)  -- 20190830 추가
					END

			    END
	
			  IF  @n2_MEASURE IS NOT NULL -- AND @n2_PRICE > 0
			    BEGIN
					-- PRICE INSERT #2
					insert into  #FUTURE_PRICE_TEMP3
						(DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제
						,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
						,CELL_PROD_SITE
						,QTY
						,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
						,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                        ,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
					values
						(@v_DIVISION_ID,@v_PROJECT_CODE,@v_PROJECT_NAME,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMM,@v_CURRENCY,@n2_MEASURE     
						,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS-- [PJ20200138] Incoterms 삭제
						,@v_ITEM_USE,@v_UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
						,@v_CELL_PROD_SITE
						,ROUND(@n2_PRICE, 3),'SYSTEM',SYSDATETIME(),'SYSTEM',SYSDATETIME()  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
						,null,null,null,null,null,null,null,null,null,null
                        ,@v_DEPT_ID,@v_END_CUSTOMER,@v_BIZ_TYPE)  -- 20190830 추가

					IF @s_flag <> 'CALL'
					BEGIN
						-- Amount INSERT #2
						insert into  #FUTURE_PRICE_TEMP3
							(DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE,INCOTERMS-- [PJ20200138] Incoterms 삭제
							,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
							,CELL_PROD_SITE
							,QTY
							,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
							,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
							,DEPT_ID,END_CUSTOMER,BIZ_TYPE)  -- 20190830 추가
						values
							(@v_DIVISION_ID,@v_PROJECT_CODE,@v_PROJECT_NAME,@v_SCM_SITE_ID,@v_PLANT_SITE_ID,@v_ITEM_ID,@v_YYYYMM,@v_CURRENCY, N'SalesAmt_' + @n2_MEASURE    
							,@v_DOM_EXP,@v_FCST_TYPE,@v_INCOTERMS-- [PJ20200138] Incoterms 삭제
							,@v_ITEM_USE, @v_UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
							,@v_CELL_PROD_SITE
							,ROUND(@n2_PRICE * @V_BP_QTY, 3),'SYSTEM',SYSDATETIME(),'SYSTEM',SYSDATETIME()  -- 20190213 KHSONG [CSR ID:3921022] GSCM 판가 소수점 관리 개선 요청의 건 -> 소수점 3번째자리까지 반올림하여 저장
							,null,null,null,null,null,null,null,null,null,null
							,@v_DEPT_ID,@v_END_CUSTOMER,@v_BIZ_TYPE)  -- 20190830 추가
					END
			    END
			
			--------------------------------------------------------------------------------------------------------
			fetch next from future_price_cur into
                        @v_DIVISION_ID     
					   ,@v_PROJECT_CODE 
					   ,@v_PROJECT_NAME   
					   ,@v_SCM_SITE_ID     
					   ,@v_PLANT_SITE_ID   
					   ,@v_ITEM_ID         
					   ,@v_YYYYMM        
					   ,@v_CURRENCY        
					   ,@v_MEASURE         
					   ,@v_DOM_EXP         
					   ,@v_FCST_TYPE       
					   ,@v_INCOTERMS -- [PJ20200138] Incoterms 삭제
					   -- [PJ20200138] item_use, unit_energy 추가
					   ,@v_ITEM_USE
					   ,@v_UNIT_ENERGY 
					   ,@v_CELL_PROD_SITE
					   ,@v_PRICE           
                       -- 20190830 추가
                       ,@v_DEPT_ID
                       ,@v_END_CUSTOMER
                       ,@v_BIZ_TYPE

					   ,@v_ROW_COUNT
					   ,@V_BP_QTY
			END
			--------------------------------------------------------------------------------------------------------
			close future_price_cur
			deallocate  future_price_cur
--select '#FUTURE_PRICE_TEMP3', * from #FUTURE_PRICE_TEMP3
			--임시확인 
			--SELECT '#FUTURE_PRICE_TEMP3'
			--SELECT * FROM #FUTURE_PRICE_TEMP3


			BEGIN
			DELETE
				FROM  dbo.DM_PLN_BP_FCST 
                  WHERE (
                    SELECT count(1) 
					  FROM #FUTURE_PRICE_TEMP3 B WITH(NOLOCK)
				     where  1=1
					   and  DM_PLN_BP_FCST.DIVISION_ID     =  B.DIVISION_ID
					   and  DM_PLN_BP_FCST.PROJECT_CODE    =  B.PROJECT_CODE                         
					   --and  DM_PLN_BP_FCST.PROJECT_NAME    =  B.PROJECT_NAME
					   and  DM_PLN_BP_FCST.SCM_SITE_ID     =  B.SCM_SITE_ID                         
					   and  DM_PLN_BP_FCST.PLANT_SITE_ID   =  B.PLANT_SITE_ID                         
					   and  DM_PLN_BP_FCST.ITEM_ID         =  B.ITEM_ID                         
					   and  DM_PLN_BP_FCST.YYYYMM          =  B.YYYYMM                         
					   and  DM_PLN_BP_FCST.CURRENCY        =  B.CURRENCY                         
					   and  DM_PLN_BP_FCST.MEASURE         =  B.MEASURE                         
					   and  DM_PLN_BP_FCST.DOM_EXP         =  B.DOM_EXP                         
					   and  DM_PLN_BP_FCST.FCST_TYPE       =  B.FCST_TYPE                         
					   and  DM_PLN_BP_FCST.INCOTERMS       =  B.INCOTERMS     -- [PJ20200138] Incoterms 삭제
					   -- [PJ20200138] item_use, unit_energy 추가
					   and  DM_PLN_BP_FCST.ITEM_USE        =  B.ITEM_USE                         
					   and  DM_PLN_BP_FCST.UNIT_ENERGY     =  B.UNIT_ENERGY                         
					   and  DM_PLN_BP_FCST.CELL_PROD_SITE  =  B.CELL_PROD_SITE                         
                       -- 20190830 추가                    
					   and  DM_PLN_BP_FCST.DEPT_ID         =  B.DEPT_ID     
					   and  DM_PLN_BP_FCST.END_CUSTOMER    =  B.END_CUSTOMER     
					   and  DM_PLN_BP_FCST.BIZ_TYPE        =  B.BIZ_TYPE     
				  ) > 0
			END


  			BEGIN
			INSERT INTO dbo.DM_PLN_BP_FCST
 			   ( DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
				,INCOTERMS-- [PJ20200138] Incoterms 삭제
				,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
				,CELL_PROD_SITE
				,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
				,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가    
				)
			  SELECT DIVISION_ID,PROJECT_CODE,PROJECT_NAME,SCM_SITE_ID,PLANT_SITE_ID,ITEM_ID,YYYYMM,CURRENCY,MEASURE,DOM_EXP,FCST_TYPE
					,INCOTERMS-- [PJ20200138] Incoterms 삭제
					,ITEM_USE,UNIT_ENERGY -- [PJ20200138] item_use, unit_energy 추가
					,CELL_PROD_SITE
					,QTY,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
					,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                    ,DEPT_ID,END_CUSTOMER,BIZ_TYPE  -- 20190830 추가    
				FROM #FUTURE_PRICE_TEMP3 WITH(NOLOCK)
			END


		END	
        /*---------------------------------------------------------------*/

     -- IF @@TRANCOUNT > 0 
  	-- 트랜잭션 (COMMIT)
        --COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	
	  --[C20200909-000203] LOG 표준화 적용
	  -- 트랜잭션 (END)
	  --ROLLBACK TRANSACTION DM_PLN_BP_FCST_PRICE_CONV;
	  SELECT 'ERROR';

      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
	  --[C20200909-000203] LOG 표준화 적용
	  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	


	-- 수행결과 성공여부 DISPLAY
		IF @s_flag <> 'CALL' and @v_log_message IS NULL
			BEGIN
				--SELECT 'success'
				SELECT N'Sales Price Recalculation is Complete'
			END


			-- Temp Table0 존재여부 확인하여 삭제
			IF OBJECT_ID('tempdb..#FUTURE_PRICE_TEMP0') IS NOT NULL
				BEGIN 
					DROP TABLE  #FUTURE_PRICE_TEMP0
				END 

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    --SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
