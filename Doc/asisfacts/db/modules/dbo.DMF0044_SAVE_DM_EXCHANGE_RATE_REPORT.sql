
 /*==================================================================================================================
 * Program ID   : DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT
 * Description  : DM_PLN_SALES_REPORT_EXCHANGE_C TABLE INSERT/UPDATE/DELETE
 * Program History
 *==================================================================================================================
 *   Date       In Charge		Description
 *==================================================================================================================
 * 2020/03/26	P.C.I			Initial Release [PJ20200138] 
 * 2020/09/09	P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/21	HWI1993			[C20200909-000188] ESS 용도
 * 2021/02/05	P.C.I			[C20210205-000093] Sales Amt USD 업데이트 수정
 * 2025/12/02	JSSBAE			[E20251126-001120]_Currency Code 관리 개선 (하드코딩 → Lookup 관리)
 *================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT]
	@p_active_flag            NVARCHAR(MAX)
,	@p_division_id            NVARCHAR(MAX)
,	@p_version_no	          NVARCHAR(MAX)
,   @p_YYYYMMDD               NVARCHAR(MAX)    
,   @p_CURRENCY               NVARCHAR(MAX)    
,   @p_UNIT_CURRENCY          NVARCHAR(MAX)    
,   @p_EXCHANGE_PRICE         NVARCHAR(MAX)    
,   @p_CREATED_BY             NVARCHAR(MAX)    
,   @p_LAST_UPDATED_BY        NVARCHAR(MAX)    

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	------------------------------------------------------------------------------------------------------------------
	-- 스플릿관련 변수
	------------------------------------------------------------------------------------------------------------------
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET		@recv_active_flag = NULL;
	SET		@recv_active_flag = @p_active_flag;

    DECLARE  @v_active_flag      NVARCHAR(10);
    DECLARE  @v_division_id      NVARCHAR(50);
    DECLARE  @v_version_no       NVARCHAR(100);
    DECLARE  @v_YYYYMMDD         NVARCHAR(8);
    DECLARE  @v_CURRENCY         NVARCHAR(10);
    DECLARE  @v_UNIT_CURRENCY    NVARCHAR(10);
    DECLARE  @v_EXCHANGE_PRICE   NVARCHAR(100);
    DECLARE  @v_CREATED_BY       NVARCHAR(100);
    DECLARE  @v_LAST_UPDATED_BY  NVARCHAR(100);
	
	------------------------------------------------------------------------------------------------------------------
	-- recv init
	------------------------------------------------------------------------------------------------------------------
    SET  @v_active_flag      =  NULL;
    SET  @v_division_id      =  NULL;
    SET  @v_version_no       =  NULL;
    SET  @v_YYYYMMDD         =  NULL;
    SET  @v_CURRENCY         =  NULL;
    SET  @v_UNIT_CURRENCY    =  NULL;
    SET  @v_EXCHANGE_PRICE   =  NULL;
    SET  @v_CREATED_BY       =  NULL;
    SET  @v_LAST_UPDATED_BY  =  NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET		@v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @V_CUTOFF_TYPE		NVARCHAR(20)
	DECLARE @V_CUTOFF_YYYYMMDD	NVARCHAR(8)
	
	------------------------------------------------------------------------------------------------------------------
	-- 마지막 데이터 처리를 위한 구분자 추가
	------------------------------------------------------------------------------------------------------------------
	SET @p_active_flag      = RTRIM(@p_active_flag     ) + '^';
	SET @p_division_id      = RTRIM(@p_division_id     ) + '^';
	SET @p_version_no       = RTRIM(@p_version_no        ) + '^';
	SET @p_YYYYMMDD         = RTRIM(@p_YYYYMMDD        ) + '^';
	SET @p_CURRENCY         = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_UNIT_CURRENCY    = RTRIM(@p_UNIT_CURRENCY   ) + '^';
	SET @p_EXCHANGE_PRICE   = RTRIM(@p_EXCHANGE_PRICE  ) + '^';
	SET @p_CREATED_BY       = RTRIM(@p_CREATED_BY      ) + '^';
	SET @p_LAST_UPDATED_BY  = RTRIM(@p_LAST_UPDATED_BY ) + '^';
	
	------------------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정 (STRAT)
	------------------------------------------------------------------------------------------------------------------
    DECLARE @v_program_name		NVARCHAR(150) = 'DMF0044_SAVE_DM_EXCHANGE_RATE_REPORT';
    DECLARE @v_log_type			NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count		INTEGER = 0;
    DECLARE @v_log_message		NVARCHAR(1000);
    DECLARE @v_description		NVARCHAR(500);
    DECLARE @d_event_date		DATETIME;
    DECLARE @n_delete_count		INTEGER = 0;
    DECLARE @n_merge_count		INTEGER = 0;
	------------------------------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정 (END)
	------------------------------------------------------------------------------------------------------------------	
	
	------------------------------------------------------------------------------------------------------------------
	-- #results 테이블 데이터 DROP / CREATE
	------------------------------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 
		DROP TABLE #results

	CREATE TABLE #results 
	( active_flag		NVARCHAR(10)
	, division_id		NVARCHAR(50)
	, version_no		NVARCHAR(100)
	, CUTOFF_TYPE		NVARCHAR(20)
	, CUTOFF_YYYYMMDD	NVARCHAR(8)
	, YYYYMMDD			NVARCHAR(8)
	, CURRENCY			NVARCHAR(10)
	, UNIT_CURRENCY		NVARCHAR(10)
	, EXCHANGE_PRICE	NVARCHAR(100)
	, CREATED_BY		NVARCHAR(100)
	, LAST_UPDATED_BY	NVARCHAR(100))
	
	------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (START)
	------------------------------------------------------------------------------------------------------------------
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	------------------------------------------------------------------------------------------------------------------
	-- 시작 LOG  (END)
	------------------------------------------------------------------------------------------------------------------
	
	------------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)
	------------------------------------------------------------------------------------------------------------------
	BEGIN TRANSACTION;
		BEGIN TRY

--###############################################  #results 테이블에 split후 insert (START)
WHILE LEN(@p_DIVISION_ID) > 0
BEGIN
    DECLARE @index_active_flag       INT
	DECLARE @index_division_id       INT
	DECLARE @index_version_no        INT
	DECLARE @index_YYYYMMDD          INT
	DECLARE @index_CURRENCY          INT
	DECLARE @index_UNIT_CURRENCY     INT
	DECLARE @index_EXCHANGE_PRICE    INT
	DECLARE @index_CREATED_BY        INT
	DECLARE @index_LAST_UPDATED_BY   INT

    SET @index_active_flag       = PATINDEX('%' + '^' + '%', @p_active_flag     )
	SET @index_division_id       = PATINDEX('%' + '^' + '%', @p_division_id     )
	SET @index_version_no        = PATINDEX('%' + '^' + '%', @p_version_no      )
	SET @index_YYYYMMDD          = PATINDEX('%' + '^' + '%', @p_YYYYMMDD        )
	SET @index_CURRENCY          = PATINDEX('%' + '^' + '%', @p_CURRENCY        )
	SET @index_UNIT_CURRENCY     = PATINDEX('%' + '^' + '%', @p_UNIT_CURRENCY   )
	SET @index_EXCHANGE_PRICE    = PATINDEX('%' + '^' + '%', @p_EXCHANGE_PRICE  )
	SET @index_CREATED_BY        = PATINDEX('%' + '^' + '%', @p_CREATED_BY      )
	SET @index_LAST_UPDATED_BY   = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY )

	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF @index_DIVISION_ID > 0
		BEGIN
			SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
			SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

			SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
			SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))
			
			SET @v_VERSION_NO = SUBSTRING(@p_VERSION_NO, 0, @index_VERSION_NO)
			SET @p_VERSION_NO = SUBSTRING(@p_VERSION_NO, LEN(@v_VERSION_NO + '^') + 1, LEN(@p_VERSION_NO))

			SET @v_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, 0, @index_YYYYMMDD)
			SET @p_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, LEN(@v_YYYYMMDD + '^') + 1, LEN(@p_YYYYMMDD))

			SET @v_CURRENCY = SUBSTRING(@p_CURRENCY, 0, @index_CURRENCY)
			SET @p_CURRENCY = SUBSTRING(@p_CURRENCY, LEN(@v_CURRENCY + '^') + 1, LEN(@p_CURRENCY))

			SET @v_UNIT_CURRENCY = SUBSTRING(@p_UNIT_CURRENCY, 0, @index_UNIT_CURRENCY)
			SET @p_UNIT_CURRENCY = SUBSTRING(@p_UNIT_CURRENCY, LEN(@v_UNIT_CURRENCY + '^') + 1, LEN(@p_UNIT_CURRENCY))

			SET @v_EXCHANGE_PRICE = SUBSTRING(@p_EXCHANGE_PRICE, 0, @index_EXCHANGE_PRICE)
			SET @p_EXCHANGE_PRICE = SUBSTRING(@p_EXCHANGE_PRICE, LEN(@v_EXCHANGE_PRICE + '^') + 1, LEN(@p_EXCHANGE_PRICE))

			SET @v_CREATED_BY = SUBSTRING(@p_CREATED_BY, 0, @index_CREATED_BY)
			SET @p_CREATED_BY = SUBSTRING(@p_CREATED_BY, LEN(@v_CREATED_BY + '^') + 1, LEN(@p_CREATED_BY))

			SET @v_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, 0, @index_LAST_UPDATED_BY)
			SET @p_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, LEN(@v_LAST_UPDATED_BY + '^') + 1, LEN(@p_LAST_UPDATED_BY))
 
			INSERT INTO #results ( 
			                         active_flag    
									,division_id    
									,version_no    
									,YYYYMMDD       
									,CURRENCY       
									,UNIT_CURRENCY  
									,EXCHANGE_PRICE 
									,CREATED_BY     
									,LAST_UPDATED_BY
			) VALUES ( 
			                         @v_active_flag    
									,@v_division_id      
									,@v_version_no   
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_UNIT_CURRENCY  
									,@v_EXCHANGE_PRICE 
									,@v_CREATED_BY     
									,@v_LAST_UPDATED_BY
			)
		END
    ELSE
		BEGIN
			SET @v_DIVISION_ID = @p_DIVISION_ID
			SET @p_DIVISION_ID = NULL
 
			INSERT INTO #results ( 
			                         active_flag    
									,division_id    
									,version_no   
									,YYYYMMDD       
									,CURRENCY       
									,UNIT_CURRENCY  
									,EXCHANGE_PRICE 
									,CREATED_BY     
									,LAST_UPDATED_BY
			) VALUES ( 
			                         @v_active_flag    
									,@v_division_id      
									,@v_version_no   
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_UNIT_CURRENCY  
									,@v_EXCHANGE_PRICE 
									,@v_CREATED_BY     
									,@v_LAST_UPDATED_BY
			)
		END
			-- Division_id Null Validation
			IF NOT EXISTS ( SELECT 1 FROM [dbo].SCM_MST_DIVISION WITH (NOLOCK) WHERE 1=1
									  AND DIVISION_ID = @v_DIVISION_ID ) 
				BEGIN 
					SET @v_log_type = 'INVALID'
					GOTO ERR_RTN
				END
END

	--###############################################   #results 테이블에 split후 insert (END)

SELECT @V_CUTOFF_TYPE = CUTOFF_TYPE
	, @V_CUTOFF_YYYYMMDD = CUTOFF_YYYYMMDD
FROM DM_PLN_SALES_PLAN_REPORT_C
WHERE DIVISION_ID = @v_division_id
	AND VERSION_NO = @v_version_no

UPDATE #RESULTS
SET CUTOFF_TYPE = @V_CUTOFF_TYPE
	, CUTOFF_YYYYMMDD = @V_CUTOFF_YYYYMMDD


--===================================================================================== delete start
BEGIN
		   --  select * from #results
		   DELETE 
           FROM [dbo].DM_PLN_SALES_REPORT_EXCHANGE_C 
           WHERE exists(
                    SELECT DIVISION_ID
					  FROM #results 
					 where active_flag      = 'D'
                       and DM_PLN_SALES_REPORT_EXCHANGE_C.DIVISION_ID        =   DIVISION_ID         
                       AND DM_PLN_SALES_REPORT_EXCHANGE_C.VERSION_NO         =   VERSION_NO          
                       AND DM_PLN_SALES_REPORT_EXCHANGE_C.YYYYMMDD           =   YYYYMMDD          
                       AND DM_PLN_SALES_REPORT_EXCHANGE_C.CURRENCY           =   CURRENCY     
                       AND DM_PLN_SALES_REPORT_EXCHANGE_C.UNIT_CURRENCY      =   UNIT_CURRENCY
				  );
END
--===================================================================================== delete end

--===================================================================================== update, insert start
BEGIN
					MERGE INTO [dbo].DM_PLN_SALES_REPORT_EXCHANGE_C A
					USING (
							SELECT 
								     division_id   
									,VERSION_NO
									,CUTOFF_TYPE
									,CUTOFF_YYYYMMDD
								    ,YYYYMMDD      
								    ,CURRENCY      
								    ,UNIT_CURRENCY 
								    ,max(EXCHANGE_PRICE)  as EXCHANGE_PRICE
									,max(CREATED_BY)      as CREATED_BY
									,max(LAST_UPDATED_BY) as LAST_UPDATED_BY
                             FROM  #results WHERE active_flag <> 'D'   -- DELETE값이 아닌경우만
                          group by   division_id   
						            ,VERSION_NO  
									,CUTOFF_TYPE
									,CUTOFF_YYYYMMDD
								    ,YYYYMMDD       
								    ,CURRENCY       	
								    ,UNIT_CURRENCY   
						  ) B
					ON(
                                A.division_id        =   B.division_id      
                            AND A.VERSION_NO         =   B.VERSION_NO       
                            AND A.CUTOFF_TYPE        =   B.CUTOFF_TYPE      
                            AND A.CUTOFF_YYYYMMDD    =   B.CUTOFF_YYYYMMDD      
                            AND A.YYYYMMDD           =   B.YYYYMMDD       
                            AND A.CURRENCY           =   B.CURRENCY      
                            AND A.UNIT_CURRENCY      =   B.UNIT_CURRENCY 
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
 									 division_id         =  b.division_id   
									,VERSION_NO          =  b.VERSION_NO      
									,CUTOFF_TYPE         =  b.CUTOFF_TYPE      
									,CUTOFF_YYYYMMDD     =  b.CUTOFF_YYYYMMDD      
									,YYYYMMDD            =  b.YYYYMMDD      
									,CURRENCY            =  b.CURRENCY      
									,UNIT_CURRENCY       =  b.UNIT_CURRENCY 
									,EXCHANGE_PRICE      =  b.EXCHANGE_PRICE
									,CREATED_BY          =  b.CREATED_BY     
									,CREATION_DATE       =  sysdatetime()	--,CREATION_DATE       =  @v_CREATION_DATE  
									,LAST_UPDATED_BY     =  b.LAST_UPDATED_BY
									,LAST_UPDATE_DATE    =  sysdatetime()     

					WHEN NOT MATCHED THEN

					     INSERT 
								  ( division_id   
								   ,VERSION_NO
								   ,CUTOFF_TYPE
								   ,CUTOFF_YYYYMMDD
								   ,YYYYMMDD      
								   ,CURRENCY      
								   ,UNIT_CURRENCY 
								   ,EXCHANGE_PRICE
								   ,CREATED_BY      
								   ,CREATION_DATE   
								   ,LAST_UPDATED_BY 
								   ,LAST_UPDATE_DATE
								)
						 VALUES (   
									b.division_id   
								   ,b.VERSION_NO
								   ,b.CUTOFF_TYPE
								   ,b.CUTOFF_YYYYMMDD
								   ,b.YYYYMMDD      
								   ,b.CURRENCY      
								   ,b.UNIT_CURRENCY 
								   ,b.EXCHANGE_PRICE
								   ,b.CREATED_BY     
								   ,sysdatetime()    
								   ,b.LAST_UPDATED_BY
								   ,sysdatetime()     
								);


END

--===================================================================================== update, insert end

--===================================================================================== Sales Report update start
BEGIN

		--KRW
		UPDATE A
		SET QTY = ISNULL(ROUND(C.QTY * B.EXCHANGE_PRICE, 3), 0)
		   , LAST_UPDATED_BY = 'EXCHANGE_PRICE'
		   , LAST_UPDATE_DATE = getdate()
		FROM DM_PLN_SALES_PLAN_REPORT_C A with(nolock)
		JOIN #results B 
		ON  A.VERSION_NO = B.VERSION_NO 
		AND A.DIVISION_ID = B.DIVISION_ID 
		AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
		AND B.CURRENCY = N'KRW'
		AND B.UNIT_CURRENCY = A.CURRENCY
		JOIN DM_PLN_SALES_PLAN_REPORT_C C with(nolock)
		ON  A.VERSION_NO = C.VERSION_NO
		AND A.DIVISION_ID = C.DIVISION_ID
		AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
		AND A.DEPT_ID = C.DEPT_ID
		AND A.END_CUST_REPORT = C.END_CUST_REPORT
		AND A.CUST_REPORT = C.CUST_REPORT
		AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
		AND A.PROJECT_CODE = C.PROJECT_CODE
		AND A.SCM_SITE_ID = C.SCM_SITE_ID
		AND A.ITEM_ID = C.ITEM_ID
		AND A.YYYYMMDD = C.YYYYMMDD
		AND A.CURRENCY = C.CURRENCY
		AND A.COMPANY_ID = C.COMPANY_ID
		AND C.MEASURE = 'SalesAmt_LOC'
		WHERE A.MEASURE = 'SalesAmt_KRW'
		and A.Division_id = B.DIVISION_ID
		and A.Version_no = B.VERSION_NO 
		AND A.CURRENCY <> 'KRW'
		;
		
		--USD
		UPDATE A
		--[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
		--SET QTY = ISNULL(ROUND(C.QTY * (CASE WHEN A.CURRENCY = 'RMB' THEN D.KRW_RMB_PRICE
		SET QTY = ISNULL(ROUND(C.QTY * (CASE WHEN A.CURRENCY = 'CNY' THEN D.KRW_CNY_PRICE
		--[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
											 WHEN A.CURRENCY = 'EUR' THEN D.KRW_EUR_PRICE
											 WHEN A.CURRENCY = 'JPY' THEN D.KRW_JPY_PRICE 
											 ELSE 1 END)/D.KRW_USD_PRICE , 3), 0) --[C20210205-000093] Sales Amt USD 업데이트 수정 (D.KRW_USD_PRICE-> 1)
		   , LAST_UPDATED_BY = 'EXCHANGE_PRICE'
		   , LAST_UPDATE_DATE = getdate()
		FROM DM_PLN_SALES_PLAN_REPORT_C A with(nolock)
		JOIN #results B 
		ON  A.VERSION_NO = B.VERSION_NO 
		AND A.DIVISION_ID = B.DIVISION_ID 
		AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
		AND B.CURRENCY = N'KRW'
		AND A.CURRENCY = CASE WHEN A.CURRENCY = 'KRW' THEN B.CURRENCY ELSE B.UNIT_CURRENCY END --[C20210205-000093] Sales Amt USD 업데이트 수정
		--AND B.UNIT_CURRENCY = A.CURRENCY--[C20210205-000093] Sales Amt USD 업데이트 수정
		JOIN DM_PLN_SALES_PLAN_REPORT_C C with(nolock)
		ON  A.VERSION_NO = C.VERSION_NO
		AND A.DIVISION_ID = C.DIVISION_ID
		AND A.DEPARTMENT_ID = C.DEPARTMENT_ID
		AND A.DEPT_ID = C.DEPT_ID
		AND A.END_CUST_REPORT = C.END_CUST_REPORT
		AND A.CUST_REPORT = C.CUST_REPORT
		AND A.PRODUCT_GROUP = C.PRODUCT_GROUP
		AND A.PROJECT_CODE = C.PROJECT_CODE
		AND A.SCM_SITE_ID = C.SCM_SITE_ID
		AND A.ITEM_ID = C.ITEM_ID
		AND A.YYYYMMDD = C.YYYYMMDD
		AND A.CURRENCY = C.CURRENCY
		AND A.COMPANY_ID = C.COMPANY_ID
		AND C.MEASURE = 'SalesAmt_LOC'
		JOIN (SELECT DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY
				 --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (START)
				 --, SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'RMB' THEN EXCHANGE_PRICE END) AS KRW_RMB_PRICE
				 , SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'CNY' THEN EXCHANGE_PRICE END) AS KRW_CNY_PRICE
				 --[E20251126-001120]_환율정보 RMB -> CNY로 변경 원소스 주석처리 후 소스 수정 (END)
				 , SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'EUR' THEN EXCHANGE_PRICE END) AS KRW_EUR_PRICE
				 , SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'JPY' THEN EXCHANGE_PRICE END) AS KRW_JPY_PRICE
				 , SUM(CASE WHEN CURRENCY = 'KRW' AND UNIT_CURRENCY = 'USD' THEN EXCHANGE_PRICE END) AS KRW_USD_PRICE
			FROM  DM_PLN_SALES_REPORT_EXCHANGE_C E with(nolock) 
			WHERE E.DIVISION_ID = @v_DIVISION_ID
			AND   E.VERSION_NO = @v_VERSION_NO
			AND   CURRENCY = N'KRW'
			GROUP BY DIVISION_ID, VERSION_NO, YYYYMMDD, CURRENCY) D
		ON  A.VERSION_NO = D.VERSION_NO
		AND A.DIVISION_ID = D.DIVISION_ID
		AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%'
		WHERE A.MEASURE = 'SalesAmt_USD'
		and A.Division_id = B.DIVISION_ID
		and A.Version_no = B.VERSION_NO 
		AND A.CURRENCY <> 'USD'
		;

END
--===================================================================================== Sales Report update end


     -- IF @@TRANCOUNT > 0 

  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION;

      -- ROLLBACK
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
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / merge_count: ' + Convert(NVARCHAR(10), @n_merge_count) ;
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK TRANSACTION;
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SELECT N'Division 값이 존재하지 않습니다.'
		END

  END;


