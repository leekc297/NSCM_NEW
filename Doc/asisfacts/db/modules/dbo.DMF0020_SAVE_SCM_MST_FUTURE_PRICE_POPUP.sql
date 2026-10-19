/*
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP
 * Description  : 'SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/03/04   P.C.I		   [PJ20200138]Initial Release
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022/08/31	ROSIA27			중복 환율 생성 로직 수정
 */

CREATE PROCEDURE [dbo].[DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP]

	-- Add the parameters for the stored procedure here
    @p_active_flag             NVARCHAR(MAX),    
    @p_DIVISION_ID             NVARCHAR(MAX),    
    @p_PROJECT_CODE            NVARCHAR(MAX),    
    @p_SCM_SITE_ID             NVARCHAR(MAX),    
    @p_PLANT_SITE_ID           NVARCHAR(MAX),    
    @p_ITEM_ID                 NVARCHAR(MAX),    
    @p_YYYYMMDD                NVARCHAR(MAX),    
    @p_CURRENCY                NVARCHAR(MAX), 
    @p_MEASURE                 NVARCHAR(MAX), 
    @p_DOM_EXP                 NVARCHAR(MAX), 
    @p_FCST_TYPE               NVARCHAR(MAX), 
    @p_INCOTERMS               NVARCHAR(MAX),
    @p_PRICE                   NVARCHAR(MAX),    
    @p_CREATED_BY              NVARCHAR(MAX),    
    @p_CREATION_DATE           NVARCHAR(MAX),    
    @p_LAST_UPDATED_BY         NVARCHAR(MAX)

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	-- 스플릿관련 변수
	
    DECLARE  @v_active_flag        NVARCHAR(MAX);
    DECLARE  @v_DIVISION_ID        NVARCHAR(MAX);
    DECLARE  @v_PROJECT_CODE       NVARCHAR(MAX);
    DECLARE  @v_SCM_SITE_ID        NVARCHAR(MAX);
    DECLARE  @v_PLANT_SITE_ID      NVARCHAR(MAX);
    DECLARE  @v_ITEM_ID            NVARCHAR(MAX);
    DECLARE  @v_YYYYMMDD           NVARCHAR(MAX);
    DECLARE  @v_CURRENCY           NVARCHAR(MAX);
    DECLARE  @v_MEASURE            NVARCHAR(MAX);
    DECLARE  @v_DOM_EXP            NVARCHAR(MAX);
    DECLARE  @v_FCST_TYPE          NVARCHAR(MAX);
    DECLARE  @v_INCOTERMS          NVARCHAR(MAX);
    DECLARE  @v_PRICE              NVARCHAR(MAX);
    DECLARE  @v_CREATED_BY         NVARCHAR(MAX);
    DECLARE  @v_CREATION_DATE      NVARCHAR(MAX);
    DECLARE  @v_LAST_UPDATED_BY    NVARCHAR(MAX);


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count     INTEGER = 0;
    DECLARE @n_logo_count      INTEGER = 0;



	-- 마지막 데이터 처리를 위한 구분자 추가
	SET @p_active_flag      = RTRIM(@p_active_flag     ) + '^';
	SET @p_DIVISION_ID      = RTRIM(@p_DIVISION_ID     ) + '^';
	SET @p_PROJECT_CODE     = RTRIM(@p_PROJECT_CODE    ) + '^';
	SET @p_SCM_SITE_ID      = RTRIM(@p_SCM_SITE_ID     ) + '^';
	SET @p_PLANT_SITE_ID    = RTRIM(@p_PLANT_SITE_ID   ) + '^';
	SET @p_ITEM_ID          = RTRIM(@p_ITEM_ID         ) + '^';
	SET @p_YYYYMMDD         = RTRIM(@p_YYYYMMDD        ) + '^';
	SET @p_CURRENCY         = RTRIM(@p_CURRENCY        ) + '^';
	SET @p_MEASURE          = RTRIM(@p_MEASURE         ) + '^';
	SET @p_DOM_EXP          = RTRIM(@p_DOM_EXP         ) + '^';
	SET @p_FCST_TYPE        = RTRIM(@p_FCST_TYPE       ) + '^';
	SET @p_INCOTERMS        = RTRIM(@p_INCOTERMS       ) + '^';
	SET @p_PRICE            = RTRIM(@p_PRICE           ) + '^';
	SET @p_CREATED_BY       = RTRIM(@p_CREATED_BY      ) + '^';
	--SET @p_CREATION_DATE    = RTRIM(@p_CREATION_DATE   ) + '^';
	SET @p_LAST_UPDATED_BY  = RTRIM(@p_LAST_UPDATED_BY ) + '^';
	

-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (START)
	-- #results_MST TEMP TABLE
	CREATE TABLE #results_MST  (
             v_active_flag        NVARCHAR(01) NULL
			,v_DIVISION_ID        NVARCHAR(30) NOT NULL
			,v_PROJECT_CODE       NVARCHAR(50) NOT NULL
			,v_SCM_SITE_ID        NVARCHAR(30) NOT NULL
			,v_PLANT_SITE_ID      NVARCHAR(30) NOT NULL
			,v_ITEM_ID            NVARCHAR(50) NOT NULL
			,v_YYYYMMDD           NVARCHAR(08) NOT NULL
			,v_CURRENCY           NVARCHAR(10) NOT NULL
			,v_MEASURE            NVARCHAR(50) NOT NULL
			,v_DOM_EXP            NVARCHAR(03) NOT NULL
			,v_FCST_TYPE          NVARCHAR(20) NOT NULL
			,v_INCOTERMS          NVARCHAR(10) NOT NULL
			,v_PRICE              NUMERIC(20,10) NOT NULL
			,v_CREATED_BY         NVARCHAR(150) NOT NULL
			,v_CREATION_DATE      DATETIME NOT NULL
			,v_LAST_UPDATED_BY    NVARCHAR(150) NOT NULL
    )
	
	CREATE CLUSTERED INDEX [IDX_RESULTS_N1] ON [#results_MST]
	(
		 v_active_flag     ASC
		,v_DIVISION_ID     ASC
		,v_PROJECT_CODE    ASC
		,v_SCM_SITE_ID     ASC
		,v_PLANT_SITE_ID   ASC
		,v_ITEM_ID         ASC
		,v_YYYYMMDD        ASC
		,v_CURRENCY        ASC
		,v_MEASURE         ASC
		,v_DOM_EXP         ASC
		,v_FCST_TYPE       ASC
		,v_INCOTERMS       ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	-- #results TEMP TABLE (PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 로 전달할 대상)
	CREATE TABLE #results  (
			 v_DIVISION_ID        NVARCHAR(30) NOT NULL
			,v_PROJECT_CODE       NVARCHAR(50) NOT NULL
			,v_SCM_SITE_ID        NVARCHAR(30) NOT NULL
			,v_PLANT_SITE_ID      NVARCHAR(30) NOT NULL
			,v_ITEM_ID            NVARCHAR(50) NOT NULL
			,v_YYYYMMDD           NVARCHAR(08) NOT NULL
			,v_CURRENCY           NVARCHAR(10) NOT NULL
			,v_MEASURE            NVARCHAR(50) NOT NULL
			,v_DOM_EXP            NVARCHAR(03) NOT NULL
			,v_FCST_TYPE          NVARCHAR(20) NOT NULL
			,v_INCOTERMS          NVARCHAR(10) NOT NULL
			,v_PRICE              NUMERIC(20,10) NOT NULL
			,v_CREATED_BY         NVARCHAR(150) NOT NULL
    )
	
	CREATE CLUSTERED INDEX [IDX_RESULTS_N2] ON [#results]
	(
		 v_DIVISION_ID     ASC
		,v_PROJECT_CODE    ASC
		,v_SCM_SITE_ID     ASC
		,v_PLANT_SITE_ID   ASC
		,v_ITEM_ID         ASC
		,v_YYYYMMDD        ASC
		,v_CURRENCY        ASC
		,v_MEASURE         ASC
		,v_DOM_EXP         ASC
		,v_FCST_TYPE       ASC
		,v_INCOTERMS       ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = ON, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

	-- 환율 테이블
	CREATE TABLE #TEMP_EXCH (
			  DIVISION_ID			NVARCHAR(30) NOT NULL
			, YYYYMMDD				NVARCHAR(8)  NOT NULL
			, CURRENCY				NVARCHAR(10) NOT NULL
			, UNIT_CURRENCY			NVARCHAR(10) NOT NULL
			, EXCHANGE_PRICE		NUMERIC(20,10) NOT NULL
			)
-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (END)

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure @@@##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION SCM_MST_FUTURE_PRICE_ALL;  -- sss

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	 DECIMAL

--===================================================================================== #results_MST 테이블에 split후 insert start
--###############################################  #results_MST 테이블에 split후 insert (START)
WHILE LEN(@p_DIVISION_ID) > 0
BEGIN
    DECLARE @index_DIVISION_ID     INT
	DECLARE @index_active_flag     INT
	DECLARE @index_PROJECT_CODE    INT
	DECLARE @index_SCM_SITE_ID     INT
	DECLARE @index_PLANT_SITE_ID   INT
	DECLARE @index_ITEM_ID         INT
	DECLARE @index_YYYYMMDD        INT
	DECLARE @index_CURRENCY        INT
	DECLARE @index_MEASURE         INT
	DECLARE @index_DOM_EXP         INT
	DECLARE @index_FCST_TYPE       INT
	DECLARE @index_INCOTERMS       INT
	DECLARE @index_PRICE           INT
	DECLARE @index_CREATED_BY      INT
	--DECLARE @index_CREATION_DATE   INT
	DECLARE @index_LAST_UPDATED_BY INT

    SET @index_DIVISION_ID      = PATINDEX('%' + '^' + '%', @p_DIVISION_ID)
	SET @index_active_flag      = PATINDEX('%' + '^' + '%', @p_active_flag)
	SET @index_PROJECT_CODE     = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE)
	SET @index_SCM_SITE_ID      = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID    )
	SET @index_PLANT_SITE_ID    = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID  )
	SET @index_ITEM_ID          = PATINDEX('%' + '^' + '%', @p_ITEM_ID        )
	SET @index_YYYYMMDD         = PATINDEX('%' + '^' + '%', @p_YYYYMMDD       )
	SET @index_CURRENCY         = PATINDEX('%' + '^' + '%', @p_CURRENCY       )
	SET @index_MEASURE          = PATINDEX('%' + '^' + '%', @p_MEASURE        )
	SET @index_DOM_EXP          = PATINDEX('%' + '^' + '%', @p_DOM_EXP        )
	SET @index_FCST_TYPE        = PATINDEX('%' + '^' + '%', @p_FCST_TYPE      )
	SET @index_INCOTERMS        = PATINDEX('%' + '^' + '%', @p_INCOTERMS      )
	SET @index_PRICE            = PATINDEX('%' + '^' + '%', @p_PRICE          )
	SET @index_CREATED_BY       = PATINDEX('%' + '^' + '%', @p_CREATED_BY     )
	--SET @index_CREATION_DATE    = PATINDEX('%' + '^' + '%', @p_CREATION_DATE  )
	SET @index_LAST_UPDATED_BY  = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY)
	

	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF @index_DIVISION_ID > 0
		BEGIN
			SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
			SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

			SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
			SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

			SET @v_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE , 0, @index_PROJECT_CODE)
			SET @p_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE , LEN(@v_PROJECT_CODE + '^') + 1, LEN(@p_PROJECT_CODE ))

			SET @v_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, 0, @index_SCM_SITE_ID)
			SET @p_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, LEN(@v_SCM_SITE_ID + '^') + 1, LEN(@p_SCM_SITE_ID))

			SET @v_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, 0, @index_PLANT_SITE_ID)
			SET @p_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, LEN(@v_PLANT_SITE_ID + '^') + 1, LEN(@p_PLANT_SITE_ID))

			SET @v_ITEM_ID = SUBSTRING(@p_ITEM_ID, 0, @index_ITEM_ID)
			SET @p_ITEM_ID = SUBSTRING(@p_ITEM_ID, LEN(@v_ITEM_ID + '^') + 1, LEN(@p_ITEM_ID))

			SET @v_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, 0, @index_YYYYMMDD)
			SET @p_YYYYMMDD = SUBSTRING(@p_YYYYMMDD, LEN(@v_YYYYMMDD + '^') + 1, LEN(@p_YYYYMMDD))

			SET @v_CURRENCY = SUBSTRING(@p_CURRENCY, 0, @index_CURRENCY)
			SET @p_CURRENCY = SUBSTRING(@p_CURRENCY, LEN(@v_CURRENCY + '^') + 1, LEN(@p_CURRENCY))

			SET @v_MEASURE = SUBSTRING(@p_MEASURE, 0, @index_MEASURE)
			SET @p_MEASURE = SUBSTRING(@p_MEASURE, LEN(@v_MEASURE + '^') + 1, LEN(@p_MEASURE))

			SET @v_DOM_EXP = SUBSTRING(@p_DOM_EXP, 0, @index_DOM_EXP)
			SET @p_DOM_EXP = SUBSTRING(@p_DOM_EXP, LEN(@v_DOM_EXP + '^') + 1, LEN(@p_DOM_EXP))

			SET @v_FCST_TYPE = SUBSTRING(@p_FCST_TYPE, 0, @index_FCST_TYPE)
			SET @p_FCST_TYPE = SUBSTRING(@p_FCST_TYPE, LEN(@v_FCST_TYPE + '^') + 1, LEN(@p_FCST_TYPE))

			SET @v_INCOTERMS = SUBSTRING(@p_INCOTERMS, 0, @index_INCOTERMS)
			SET @p_INCOTERMS = SUBSTRING(@p_INCOTERMS, LEN(@v_INCOTERMS + '^') + 1, LEN(@p_INCOTERMS))

			SET @v_PRICE = SUBSTRING(@p_PRICE, 0, @index_PRICE)
			SET @p_PRICE = SUBSTRING(@p_PRICE, LEN(@v_PRICE + '^') + 1, LEN(@p_PRICE))

			SET @v_CREATED_BY = SUBSTRING(@p_CREATED_BY, 0, @index_CREATED_BY)
			SET @p_CREATED_BY = SUBSTRING(@p_CREATED_BY, LEN(@v_CREATED_BY + '^') + 1, LEN(@p_CREATED_BY))
			
			SET @v_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, 0, @index_LAST_UPDATED_BY)
			SET @p_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, LEN(@v_LAST_UPDATED_BY + '^') + 1, LEN(@p_LAST_UPDATED_BY))
  
			--20181005 khsong 공백제거로직추가 (START)
			SET @v_active_flag    	= rtrim(ltrim(@v_active_flag))
			SET @v_DIVISION_ID    	= rtrim(ltrim(@v_DIVISION_ID))
			SET @v_PROJECT_CODE   	= rtrim(ltrim(@v_PROJECT_CODE))
			SET @v_SCM_SITE_ID    	= rtrim(ltrim(@v_SCM_SITE_ID))
			SET @v_PLANT_SITE_ID  	= rtrim(ltrim(@v_PLANT_SITE_ID))
			SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
			SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
			SET @v_CURRENCY       	= rtrim(ltrim(@v_CURRENCY))
			SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
			SET @v_DOM_EXP        	= rtrim(ltrim(@v_DOM_EXP))
			SET @v_FCST_TYPE      	= rtrim(ltrim(@v_FCST_TYPE))
			SET @v_INCOTERMS      	= rtrim(ltrim(@v_INCOTERMS))
			SET @v_PRICE          	= rtrim(ltrim(@v_PRICE))
			SET @v_CREATED_BY     	= rtrim(ltrim(@v_CREATED_BY))
			SET @v_LAST_UPDATED_BY	= rtrim(ltrim(@v_LAST_UPDATED_BY))
			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO #results_MST ( 
			                         v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY	
			) VALUES ( 
			                         @v_active_flag    
									,@v_DIVISION_ID    
									,@v_PROJECT_CODE   
									,@v_SCM_SITE_ID    
									,@v_PLANT_SITE_ID  
									,@v_ITEM_ID        
									,@v_YYYYMMDD       
									,@v_CURRENCY       
									,@v_MEASURE        
									,@v_DOM_EXP        
									,@v_FCST_TYPE      
									,@v_INCOTERMS      
									,@v_PRICE          
									,@v_CREATED_BY     
									,GETDATE() -- @v_CREATION_DATE  
									,@v_LAST_UPDATED_BY		
			)
		END
    ELSE
		BEGIN
			SET @v_DIVISION_ID = @p_DIVISION_ID
			SET @p_DIVISION_ID = NULL
 
			--20181005 khsong 공백제거로직추가 (START)
			SET @v_active_flag    	= rtrim(ltrim(@v_active_flag))
			SET @v_DIVISION_ID    	= rtrim(ltrim(@v_DIVISION_ID))
			SET @v_PROJECT_CODE   	= rtrim(ltrim(@v_PROJECT_CODE))
			SET @v_SCM_SITE_ID    	= rtrim(ltrim(@v_SCM_SITE_ID))
			SET @v_PLANT_SITE_ID  	= rtrim(ltrim(@v_PLANT_SITE_ID))
			SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
			SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
			SET @v_CURRENCY       	= rtrim(ltrim(@v_CURRENCY))
			SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
			SET @v_DOM_EXP        	= rtrim(ltrim(@v_DOM_EXP))
			SET @v_FCST_TYPE      	= rtrim(ltrim(@v_FCST_TYPE))
			SET @v_INCOTERMS      	= rtrim(ltrim(@v_INCOTERMS))
			SET @v_PRICE          	= rtrim(ltrim(@v_PRICE))
			SET @v_CREATED_BY     	= rtrim(ltrim(@v_CREATED_BY))
			SET @v_LAST_UPDATED_BY	= rtrim(ltrim(@v_LAST_UPDATED_BY))
			
			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO #results_MST ( 
			                         v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY	
			) VALUES ( 
			                         @v_active_flag    
									,@v_DIVISION_ID    
									,@v_PROJECT_CODE   
									,@v_SCM_SITE_ID    
									,@v_PLANT_SITE_ID  
									,@v_ITEM_ID        
									,@v_YYYYMMDD       
									,@v_CURRENCY    
									,@v_MEASURE        
									,@v_DOM_EXP        
									,@v_FCST_TYPE      
									,@v_INCOTERMS      
									,@v_PRICE          
									,@v_CREATED_BY     
									,GETDATE() --@v_CREATION_DATE  
									,@v_LAST_UPDATED_BY	
			)
		END
END

BEGIN

	INSERT INTO #TEMP_EXCH (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
	SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
	FROM DM_MST_EXCHANGE_RATE A
	JOIN #results_MST B
		ON A.DIVISION_ID	= B.v_DIVISION_ID
		AND A.YYYYMMDD		= LEFT(B.v_YYYYMMDD, 6) + '01'
		AND A.CURRENCY		= 'KRW'
	
	-- LOC 동일값
		INSERT INTO #results_MST ( v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag    
				,v_DIVISION_ID    
				,v_PROJECT_CODE   
				,v_SCM_SITE_ID    
				,v_PLANT_SITE_ID  
				,v_ITEM_ID        
				,v_YYYYMMDD       
				,v_CURRENCY       
				,v_CURRENCY AS v_MEASURE       
				,v_DOM_EXP        
				,v_FCST_TYPE      
				,v_INCOTERMS      
				,v_PRICE          
				,v_CREATED_BY     
				,v_CREATION_DATE  
				,v_LAST_UPDATED_BY
		FROM #results_MST A
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY IN('KRW', 'USD')

		-- KRW값 구하기
		INSERT INTO #results_MST ( v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag    
				,v_DIVISION_ID    
				,v_PROJECT_CODE   
				,v_SCM_SITE_ID    
				,v_PLANT_SITE_ID  
				,v_ITEM_ID        
				,v_YYYYMMDD       
				,v_CURRENCY       
				,'KRW' AS v_MEASURE         
				,v_DOM_EXP        
				,v_FCST_TYPE      
				,v_INCOTERMS      
				,ROUND(A.v_PRICE * B.EXCHANGE_PRICE, 3)         
				,v_CREATED_BY		
				,v_CREATION_DATE  
				,v_LAST_UPDATED_BY
		FROM #results_MST A
		JOIN #TEMP_EXCH B 
		ON B.UNIT_CURRENCY = A.v_CURRENCY
		AND B.YYYYMMDD = LEFT(A.v_YYYYMMDD, 6) + '01'
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY <> 'KRW'

		-- USD값 구하기
		INSERT INTO #results_MST ( v_active_flag    
									,v_DIVISION_ID    
									,v_PROJECT_CODE   
									,v_SCM_SITE_ID    
									,v_PLANT_SITE_ID  
									,v_ITEM_ID        
									,v_YYYYMMDD       
									,v_CURRENCY       
									,v_MEASURE        
									,v_DOM_EXP        
									,v_FCST_TYPE      
									,v_INCOTERMS      
									,v_PRICE          
									,v_CREATED_BY     
									,v_CREATION_DATE  
									,v_LAST_UPDATED_BY)
		SELECT  v_active_flag    
				,v_DIVISION_ID    
				,v_PROJECT_CODE   
				,v_SCM_SITE_ID    
				,v_PLANT_SITE_ID  
				,v_ITEM_ID        
				,v_YYYYMMDD       
				,v_CURRENCY       
				,'USD' AS v_MEASURE         
				,v_DOM_EXP        
				,v_FCST_TYPE      
				,v_INCOTERMS      
				,ROUND(A.v_PRICE / B.EXCHANGE_PRICE, 3)         
				,v_CREATED_BY     
				,v_CREATION_DATE  
				,v_LAST_UPDATED_BY
		FROM #results_MST A
		JOIN #TEMP_EXCH B 
		ON B.UNIT_CURRENCY = 'USD'
		AND B.YYYYMMDD = LEFT(A.v_YYYYMMDD, 6) + '01'
		WHERE A.v_MEASURE = 'KRW'
		AND A.v_CURRENCY <> 'USD'
END;

	--###############################################   #results_MST 테이블에 split후 insert (END)
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   BEGIN
		   IF @v_DIVISION_ID <> '40'
			   IF (select count(1)  from #results_MST where ( select count(1) from dbo.scm_mst_project WITH(NOLOCK) where project_code  = v_PROJECT_CODE ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_PROJECT_CODE +']'+ N' Invalid Project Code !';
				   goto err_rtn
			   end


			   IF (select count(1)  from #results_MST where ( select count(1) from dbo.SCM_MST_ITEM_SN WITH(NOLOCK) where ITEM_ID  = v_ITEM_ID ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_ITEM_ID +']'+ N' Invalid Item ID !';
				   goto err_rtn
			   end

				-- 20180814 KHSONG Invalid Site Item validation 추가
				DECLARE @valid_item_id		     NVARCHAR(MAX);
				SET @valid_item_id = NULL

		----------------------------------------------------------------------------------------------------------◎◎◎◎
			IF (select count(1)  
					from #results_MST  where v_division_id IN ('81','40')  -- 자동차,소형인경우
				) > 0

				BEGIN
					SET @valid_item_id =
					(
						SELECT TOP 1 A.v_item_id
							FROM #results_MST A
							WHERE 1=1
							AND NOT EXISTS (SELECT  ITEM.division_id  
												FROM dbo.scm_mst_site_item ITEM WITH(NOLOCK)
													,dbo.DM_MST_ITEM_SINGLE_V SN WITH(NOLOCK)
												where 1=1
 													and ITEM.division_id   = A.v_division_id 
													and ITEM.PROJECT_CODE  = A.v_project_code
													and ITEM.scm_site_id   = A.v_scm_site_id
													and ITEM.ITEM_ID       = A.v_ITEM_ID 
													and ITEM.division_id   = SN.division_id
													and ITEM.ITEM_ID       = SN.ITEM_ID
													and SN.ACTIVE_FLAG	   = 'Y'
													and ITEM.VALID_YN	   = 'Y'
													and ITEM.division_id IN ('81','40') 
											  )
								AND A.v_division_id IN ('81','40') 
					)
						-------------------------------------------------------------------◎◎◎◎
						IF @valid_item_id IS NOT NULL
							BEGIN
								SET @v_log_type = 'INVALID';
								SELECT '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
								SET @v_description = '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
								goto ERR_RTN;
							END
						-------------------------------------------------------------------◎◎◎◎
				END
				----------------------------------------------------------------------------------◎◎◎◎


		   END
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------


--===================================================================================== #results_MST 테이블에 split후 insert end

--  SELECT * FROM #results_MST;  -- 확인용
--===================================================================================== delete start
BEGIN
		   -- DELETE COUNT 확인
		   SET @n_delete_count =  (SELECT COUNT(DIVISION_ID)  FROM [dbo].SCM_MST_FUTURE_PRICE
								   WHERE (
											SELECT count(1) 
											  FROM #results_MST 
											 where v_active_flag      = 'D'
											   and DIVISION_ID        =   v_DIVISION_ID         
											   AND PROJECT_CODE       =   v_PROJECT_CODE      
											   AND SCM_SITE_ID        =   v_SCM_SITE_ID
											   AND PLANT_SITE_ID      =   v_PLANT_SITE_ID
											   AND ITEM_ID            =   v_ITEM_ID     
											   AND YYYYMMDD           =   v_YYYYMMDD      
											   --AND CURRENCY           =   v_CURRENCY      
											   AND MEASURE            =   v_MEASURE      
											   AND DOM_EXP            =   v_DOM_EXP      
											   AND FCST_TYPE          =   v_FCST_TYPE      
											   AND INCOTERMS          =   v_INCOTERMS  
										  ) > 0)

		   --  select * from #results_MST
		   DELETE 
           FROM [dbo].SCM_MST_FUTURE_PRICE
           WHERE (
                    SELECT count(1) 
					  FROM #results_MST 
					 where v_active_flag      = 'D'
                       and DIVISION_ID        =   v_DIVISION_ID         
                       AND PROJECT_CODE       =   v_PROJECT_CODE      
                       AND SCM_SITE_ID        =   v_SCM_SITE_ID
                       AND PLANT_SITE_ID      =   v_PLANT_SITE_ID
                       AND ITEM_ID            =   v_ITEM_ID     
                       AND YYYYMMDD           =   v_YYYYMMDD      
                       --AND CURRENCY           =   v_CURRENCY      
                       AND MEASURE            =   v_MEASURE      
                       AND DOM_EXP            =   v_DOM_EXP      
                       AND FCST_TYPE          =   v_FCST_TYPE      
                       AND INCOTERMS          =   v_INCOTERMS  
				  ) > 0;
END
--===================================================================================== delete end


--===================================================================================== update, insert start
-- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (START)
BEGIN
		   -- INSERT COUNT 확인
		   SET @n_insert_count = ( SELECT count(v_DIVISION_ID) 
										FROM #results_MST 
											where v_active_flag      <> 'D' )
					
		   -- INSERT전 동일대상 delete 수행
		   DELETE 
           FROM [dbo].SCM_MST_FUTURE_PRICE
           WHERE (
                    SELECT count(1) 
					  FROM #results_MST 
					 where v_active_flag      <> 'D'
                       and DIVISION_ID        =   v_DIVISION_ID         
                       AND PROJECT_CODE       =   v_PROJECT_CODE      
                       AND SCM_SITE_ID        =   v_SCM_SITE_ID
                       AND PLANT_SITE_ID      =   v_PLANT_SITE_ID
                       AND ITEM_ID            =   v_ITEM_ID     
                       AND YYYYMMDD           =   v_YYYYMMDD      
                       --AND CURRENCY           =   v_CURRENCY      
                       AND MEASURE            =   v_MEASURE      
                       AND DOM_EXP            =   v_DOM_EXP      
                       AND FCST_TYPE          =   v_FCST_TYPE      
                       AND INCOTERMS          =   v_INCOTERMS  
				  ) > 0;

		   -- INSERT 수행
			INSERT INTO [dbo].SCM_MST_FUTURE_PRICE
					( DIVISION_ID     
					,PROJECT_CODE    
					,SCM_SITE_ID    
					,PLANT_SITE_ID 
					,ITEM_ID         
					,YYYYMMDD        
					,CURRENCY        
					,MEASURE        
					,DOM_EXP        
					,FCST_TYPE        
					,INCOTERMS       
					,PRICE 
					,CREATED_BY      
					,CREATION_DATE   
					,LAST_UPDATED_BY 
					,LAST_UPDATE_DATE
				    )
			SELECT   V_DIVISION_ID     
					,V_PROJECT_CODE    
					,V_SCM_SITE_ID    
					,V_PLANT_SITE_ID 
					,V_ITEM_ID         
					,V_YYYYMMDD        
					,V_CURRENCY        
					,V_MEASURE      
					,V_DOM_EXP        
					,V_FCST_TYPE        
					,V_INCOTERMS       
					,cast(V_PRICE as numeric(20,10))
					,V_CREATED_BY      
					,GETDATE()   
					,V_LAST_UPDATED_BY 
					,GETDATE()
				FROM #results_MST 
					where v_active_flag    <> 'D'

							INSERT INTO  SCM_MST_FUTURE_PRICE_H
									   ( DIVISION_ID 
										,HISTORY_SEQ
										,PROJECT_CODE
										,SCM_SITE_ID
										,PLANT_SITE_ID
										,ITEM_ID
										,YYYYMMDD
										,CURRENCY
										,MEASURE
										,DOM_EXP
										,FCST_TYPE
										,INCOTERMS
										,PRICE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
									  )
								SELECT 
										 v_DIVISION_ID	    
										,NEXT VALUE FOR SEQ1_SCM_MST_FUTURE_PRICE_H
										,v_PROJECT_CODE    
										,v_SCM_SITE_ID		
										,v_PLANT_SITE_ID	
										,v_ITEM_ID		    
										,v_YYYYMMDD	   	    
										,v_CURRENCY		    
										,v_MEASURE		    
										,v_DOM_EXP		    
										,v_FCST_TYPE		
										,v_INCOTERMS		
										,v_PRICE            
										,v_CREATED_BY  
										,GETDATE()  
										,v_LAST_UPDATED_BY
										,GETDATE()
								 FROM  #results_MST  WHERE v_active_flag <> 'D'   -- DELETE값이 아닌경우만

						--------------------------------------------------------------------------------------  20180510 SKH ADD START
                        INSERT INTO #results
									(v_DIVISION_ID	  
								    ,v_PROJECT_CODE    
								    ,v_SCM_SITE_ID		
								    ,v_ITEM_ID		  
								    ,v_DOM_EXP		  
								    ,v_FCST_TYPE		  
								    ,v_INCOTERMS		  
								    ,v_MEASURE		  
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
									)

						SELECT       v_DIVISION_ID	  
								    ,v_PROJECT_CODE    
								    ,v_SCM_SITE_ID		
								    ,v_ITEM_ID		  
								    ,v_DOM_EXP		  
								    ,v_FCST_TYPE		  
								    ,v_INCOTERMS		  
								    ,v_MEASURE		  
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
						  FROM  #results_MST  WHERE v_active_flag <> 'D'   -- DELETE값이 아닌경우만

						-- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
						EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE  
						--------------------------------------------------------------------------------------  20180510 SKH ADD END

END
--===================================================================================== update, insert end

  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION SCM_MST_FUTURE_PRICE_ALL;  -- sss
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION SCM_MST_FUTURE_PRICE_ALL;  -- sss
		
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
    IF @v_log_message IS NULL
	begin
		SELECT 'success'
		;
			
	end

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / insert_count: ' + Convert(NVARCHAR(10), @n_insert_count) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

  	--------------------------------------------------------------	
  	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRANSACTION SCM_MST_FUTURE_PRICE_ALL;
			SET @v_log_message = '########## END of procedure @@@##########';
			SET @v_description = 'delete_count: '+ Convert(NVARCHAR(10), @n_delete_count)  + ' / insert_count: ' + Convert(NVARCHAR(10), @n_insert_count) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
	--------------------------------------------------------------	
