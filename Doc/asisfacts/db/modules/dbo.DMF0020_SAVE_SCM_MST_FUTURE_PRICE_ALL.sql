
/*============================================================================================================================																																				
 * Program ID   : DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL																							
 * Description  : 'SCM_MST_FUTURE_PRICE' TABLE INSERT/UPDATE/DELETE																				
 * Program History
 *=============================================================================================================================
 *   Date       In Charge		Description		
 *=============================================================================================================================
 * 2017/02/12	DWOK/KHSONG		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트												
 * 2017/03/13	JHBAEK			INPUT KEY VALUE(PROJECT_CODE, MODEL) VALIDATION CHECK															
 *								: PROJECT_CODE, MODEL(ITEM) 값을 수기로 입력할 수 있기에 INSERT 전에 VALIDATION CHECK를 한다.							
 * 2018/05/14	KHSONG			Sales Price 화면에서 저장시 SalesAmt 계산후 dm_pln_sales_plan 테이블 SAVE Procedure 호출하는 로직 추가					
 * 2018/07/18	KHSONG			기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함													
 * 2018/07/18	KHSONG			기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경																		
 * 2018/08/14	KHSONG			Invalid Site Item validation 추가																				
 * 2018/10/05	khsong			공백제거로직추가																									
 * 2020/03/04	P.C.I			[PJ20200138] 입력된 Price가 주변 주차와 Range Rate 가 초과되어 차이나는 데이터 Return									
 * 2020/04/22	KHSONG			C20200102-000131 GSCM Sales Price 수정 제한 조건 추가 요청의 건														
 * 2020/08/14	P.C.I			[C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인											
 * 2020/09/09	P.C.I			[C20200909-000203] LOG 표준화 적용																				
 * 2021/12/02	kdw2819			[C20211126-000348] AS In Req관련 추가 체크 로직 보완																
 * 2022/03/24	rosia27			[C20220317-000402]MDM 상 block 된 제품의 GSCM 상 삭제 방안 요청														
 * 2022/04/01	rosia27			[과제PJ20216891R]GM_JV																							
 * 2022/07/22	hwi1993			삭제시에는 단가변동 체크 안하도록 하는 로직 테스트중입니다.																
 * 2022/08/26	rosia27			환율 정보가 없을 시에 validation 체크하는 로직 추가																	
 * 2024/02/13	JSSBAE			[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선														
 * 2024/11/22	JSSBAE			[E20241125-000026]_Sales Price Validation 추가																					
 * 2025/01/24	JSSBAE			[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가									
 * 2025/03/12	JSSBAE			[E20250306-001052]_Sales Price Validation 추가																	
 * 2025/03/25	P.C.I			[PJ2025-50017] 소형사업부 편집 제외 Validation 추가      
 * 2025/07/21	JSSBAE			[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리          
 * 2025/08/26	JSSBAE			[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선                                                
*============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL]

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
    @p_LAST_UPDATED_BY         NVARCHAR(MAX),
	@p_ROWNUM                  NVARCHAR(MAX) --[PJ20200138] RowNum 추가

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
    DECLARE  @v_ROWNUM             NVARCHAR(MAX);


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @n_delete_count    INTEGER = 0;
    DECLARE @n_insert_count   INTEGER = 0;
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
	SET @p_ROWNUM           = RTRIM(@p_ROWNUM ) + '^';  --[PJ20200138] RowNum 추가
	
	
	-- [C20200814-000093] TEMP TABLE 확인후 삭제
	IF OBJECT_ID (N'tempdb..#results', N'U') IS NOT NULL 
		DROP TABLE #results
	IF OBJECT_ID (N'tempdb..#results_MST', N'U') IS NOT NULL 
		DROP TABLE #results_MST
	IF OBJECT_ID (N'tempdb..#results_MST_Dup', N'U') IS NOT NULL 
		DROP TABLE #results_MST_Dup
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
			,v_ROWNUM		      NVARCHAR(150) NOT NULL --[PJ20200138] RowNum 추가
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
		,v_ROWNUM          ASC --[PJ20200138] RowNum 추가
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
	DECLARE @index_ROWNUM          INT --[PJ20200138] RowNum 추가

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
	SET @index_ROWNUM           = PATINDEX('%' + '^' + '%', @p_ROWNUM) --[PJ20200138] RowNum 추가
	

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

			--SET @v_CREATION_DATE = SUBSTRING(@p_CREATION_DATE, 0, @index_CREATION_DATE)
			--SET @p_CREATION_DATE = SUBSTRING(@p_CREATION_DATE, LEN(@v_CREATION_DATE + '^') + 1, LEN(@p_CREATION_DATE))

			SET @v_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, 0, @index_LAST_UPDATED_BY)
			SET @p_LAST_UPDATED_BY = SUBSTRING(@p_LAST_UPDATED_BY, LEN(@v_LAST_UPDATED_BY + '^') + 1, LEN(@p_LAST_UPDATED_BY))
 
			SET @v_ROWNUM = SUBSTRING(@p_ROWNUM, 0, @index_ROWNUM) --[PJ20200138] RowNum 추가
			SET @p_ROWNUM = SUBSTRING(@p_ROWNUM, LEN(@v_ROWNUM + '^') + 1, LEN(@p_ROWNUM))
 
			--20181005 khsong 공백제거로직추가 (START)
			SET @v_active_flag    	= rtrim(ltrim(@v_active_flag))
			SET @v_DIVISION_ID    	= rtrim(ltrim(@v_DIVISION_ID))
			SET @v_PROJECT_CODE   	= rtrim(ltrim(@v_PROJECT_CODE))
			SET @v_SCM_SITE_ID    	= rtrim(ltrim(@v_SCM_SITE_ID))
			SET @v_PLANT_SITE_ID  	= rtrim(ltrim(@v_PLANT_SITE_ID))
			--------------------------------------------------------------------------------------------------
			-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
			--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
			--SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
			SET @v_item_id			= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
			-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
			--------------------------------------------------------------------------------------------------
			SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
			SET @v_CURRENCY       	= rtrim(ltrim(@v_CURRENCY))
			SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
			SET @v_DOM_EXP        	= rtrim(ltrim(@v_DOM_EXP))
			SET @v_FCST_TYPE      	= rtrim(ltrim(@v_FCST_TYPE))
			SET @v_INCOTERMS      	= rtrim(ltrim(@v_INCOTERMS))
			SET @v_PRICE          	= rtrim(ltrim(@v_PRICE))
			SET @v_CREATED_BY     	= rtrim(ltrim(@v_CREATED_BY))
			SET @v_LAST_UPDATED_BY	= rtrim(ltrim(@v_LAST_UPDATED_BY))
			SET @v_ROWNUM          	= rtrim(ltrim(@v_ROWNUM))
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
									,v_ROWNUM --[PJ20200138] RowNum 추가
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
									,CAST(@v_ROWNUM AS INT)
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
			--------------------------------------------------------------------------------------------------
			-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (START)	
			--1).RTRIM / 2).LTRIM / 3).CHAR(13): Carriage return / 4).CHAR(10): Line feed / 5).CHAR(9): TAB / 6).' '공백을 ''
			--SET @v_ITEM_ID        	= rtrim(ltrim(@v_ITEM_ID))
			SET @v_ITEM_ID			= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
			-- [E20250522-001188]_TRIM처리를 했음에도 지워지지 않는 데이터가 존재하는건 확인하여 ITEM에 추가처리 (END)	
			--------------------------------------------------------------------------------------------------
			SET @v_YYYYMMDD       	= rtrim(ltrim(@v_YYYYMMDD))
			SET @v_CURRENCY       	= rtrim(ltrim(@v_CURRENCY))
			SET @v_MEASURE        	= rtrim(ltrim(@v_MEASURE))
			SET @v_DOM_EXP        	= rtrim(ltrim(@v_DOM_EXP))
			SET @v_FCST_TYPE      	= rtrim(ltrim(@v_FCST_TYPE))
			SET @v_INCOTERMS      	= rtrim(ltrim(@v_INCOTERMS))
			SET @v_PRICE          	= rtrim(ltrim(@v_PRICE))
			SET @v_CREATED_BY     	= rtrim(ltrim(@v_CREATED_BY))
			SET @v_LAST_UPDATED_BY	= rtrim(ltrim(@v_LAST_UPDATED_BY))
			SET @v_ROWNUM          	= rtrim(ltrim(@v_ROWNUM)) --[PJ20200138] RowNum 추가
			
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
									,v_ROWNUM		 --[PJ20200138] RowNum 추가
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
									,CAST(@v_ROWNUM AS INT)
			)
		END
END

PRINT '1'

--[PJ2025-50017] 소형사업부 편집 제외 Validation 추가
IF (SELECT TOP 1 v_DIVISION_ID FROM #results_MST ) = '40' 
	BEGIN
		SELECT N'해당 사업부 편집은 Demand - Demand Plan - FcstPrice MGMT 에서 할 수 있습니다.'
		SET @v_log_type = 'INVALID';
		GOTO ERR_RTN;	
	END
	
PRINT '2'

--[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 START 
BEGIN 
	UPDATE #results_MST 
	SET v_CURRENCY = T.v_CURRENCY
	FROM #results_MST A
	JOIN 
	(
		SELECT A.v_ACTIVE_FLAG    
				, A.v_DIVISION_ID    
				, A.v_PROJECT_CODE   
				, A.v_SCM_SITE_ID    
				, A.v_PLANT_SITE_ID  
				, A.v_ITEM_ID        
				, A.v_YYYYMMDD       
				, A.v_CURRENCY       
				, A.v_MEASURE        
				, A.v_DOM_EXP        
				, A.v_FCST_TYPE      
				, A.v_INCOTERMS
			FROM 
			(	  SELECT  v_ACTIVE_FLAG    
						, v_DIVISION_ID    
						, v_PROJECT_CODE   
						, v_SCM_SITE_ID    
						, v_PLANT_SITE_ID  
						, v_ITEM_ID        
						, v_YYYYMMDD       
						, v_CURRENCY       
						, v_MEASURE        
						, v_DOM_EXP        
						, v_FCST_TYPE      
						, v_INCOTERMS    
				FROM #results_MST
				WHERE v_MEASURE = 'LOC'	) A
			JOIN (SELECT  v_ACTIVE_FLAG    
						, v_DIVISION_ID    
						, v_PROJECT_CODE   
						, v_SCM_SITE_ID    
						, v_PLANT_SITE_ID  
						, v_ITEM_ID        
						, v_YYYYMMDD       
						, v_CURRENCY       
						, v_MEASURE        
						, v_DOM_EXP        
						, v_FCST_TYPE      
						, v_INCOTERMS   
				FROM #results_MST
				WHERE v_MEASURE NOT IN ('LOC')) B
			ON a.v_DIVISION_ID = b.v_DIVISION_ID
			AND a.v_PROJECT_CODE = b.v_PROJECT_CODE
			AND a.v_SCM_SITE_ID = b.v_SCM_SITE_ID
			AND a.v_PLANT_SITE_ID = b.v_PLANT_SITE_ID
			AND a.v_ITEM_ID = b.v_ITEM_ID
			AND a.v_YYYYMMDD = b.v_YYYYMMDD
			AND a.v_DOM_EXP = b.v_DOM_EXP
			AND a.v_FCST_TYPE = b.v_FCST_TYPE
			AND a.v_INCOTERMS = b.v_INCOTERMS
			WHERE A.v_CURRENCY <> B.v_CURRENCY
	) T
		ON a.v_DIVISION_ID = T.v_DIVISION_ID
		AND a.v_PROJECT_CODE = T.v_PROJECT_CODE
		AND a.v_SCM_SITE_ID = T.v_SCM_SITE_ID
		AND a.v_PLANT_SITE_ID = T.v_PLANT_SITE_ID
		AND a.v_ITEM_ID = T.v_ITEM_ID
		AND a.v_YYYYMMDD = T.v_YYYYMMDD
		AND a.v_DOM_EXP = T.v_DOM_EXP
		AND a.v_FCST_TYPE = T.v_FCST_TYPE
		AND a.v_INCOTERMS = T.v_INCOTERMS
	WHERE A.v_CURRENCY <> T.v_CURRENCY
END
--[E20250113-000150]_[공급/생산 SCM PI팀] Sales Price화면 Edit시 Currency 수정기능 추가 END 

PRINT '3'
---------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START-----------------------------------
		--LOC메져만 수정할 수 있는 시스템으로, KRW나 USD에 들어온 값과 관계없이 ACTIVE_FLAG를 LOC기준으로 변경작업 진행
		--발생한현상: 환율이 없는 경우 KRW나 USD가 0으로 들어오는데, ACTIVE_FLAG가 D로 변경되어 VALIDATION에 걸려 데이터 수정이 불가능함--
-------------------------------------------------------------------------------------------------------------------------------------
		BEGIN 
			UPDATE #results_MST 
			SET v_ACTIVE_FLAG = T.v_ACTIVE_FLAG
			FROM #results_MST A
			JOIN 
			(
				SELECT A.v_ACTIVE_FLAG    
					 , A.v_DIVISION_ID    
					 , A.v_PROJECT_CODE   
					 , A.v_SCM_SITE_ID    
					 , A.v_PLANT_SITE_ID  
					 , A.v_ITEM_ID        
					 , A.v_YYYYMMDD       
					 , A.v_CURRENCY       
					 , A.v_MEASURE        
					 , A.v_DOM_EXP        
					 , A.v_FCST_TYPE      
					 , A.v_INCOTERMS
				 FROM 
				  (	  SELECT  v_ACTIVE_FLAG    
							  , v_DIVISION_ID    
							  , v_PROJECT_CODE   
							  , v_SCM_SITE_ID    
							  , v_PLANT_SITE_ID  
							  , v_ITEM_ID        
							  , v_YYYYMMDD       
							  , v_CURRENCY       
							  , v_MEASURE        
							  , v_DOM_EXP        
							  , v_FCST_TYPE      
							  , v_INCOTERMS    
						FROM #results_MST
						WHERE v_MEASURE = 'LOC'	) A
				  JOIN (SELECT  v_ACTIVE_FLAG    
							  , v_DIVISION_ID    
							  , v_PROJECT_CODE   
							  , v_SCM_SITE_ID    
							  , v_PLANT_SITE_ID  
							  , v_ITEM_ID        
							  , v_YYYYMMDD       
							  , v_CURRENCY       
							  , v_MEASURE        
							  , v_DOM_EXP        
							  , v_FCST_TYPE      
							  , v_INCOTERMS   
						FROM #results_MST
						WHERE v_MEASURE NOT IN ('LOC')) B
					ON a.v_DIVISION_ID = b.v_DIVISION_ID
				   AND a.v_PROJECT_CODE = b.v_PROJECT_CODE
				   AND a.v_SCM_SITE_ID = b.v_SCM_SITE_ID
				   AND a.v_PLANT_SITE_ID = b.v_PLANT_SITE_ID
				   AND a.v_ITEM_ID = b.v_ITEM_ID
				   AND a.v_YYYYMMDD = b.v_YYYYMMDD
				   AND a.v_CURRENCY = b.v_CURRENCY
				   AND a.v_DOM_EXP = b.v_DOM_EXP
				   AND a.v_FCST_TYPE = b.v_FCST_TYPE
				   AND a.v_INCOTERMS = b.v_INCOTERMS
				 WHERE A.v_ACTIVE_FLAG <> B.v_ACTIVE_FLAG
			) T
				ON a.v_DIVISION_ID = T.v_DIVISION_ID
				AND a.v_PROJECT_CODE = T.v_PROJECT_CODE
				AND a.v_SCM_SITE_ID = T.v_SCM_SITE_ID
				AND a.v_PLANT_SITE_ID = T.v_PLANT_SITE_ID
				AND a.v_ITEM_ID = T.v_ITEM_ID
				AND a.v_YYYYMMDD = T.v_YYYYMMDD
				AND a.v_CURRENCY = T.v_CURRENCY
				AND a.v_DOM_EXP = T.v_DOM_EXP
				AND a.v_FCST_TYPE = T.v_FCST_TYPE
				AND a.v_INCOTERMS = T.v_INCOTERMS
			WHERE A.v_ACTIVE_FLAG <> T.v_ACTIVE_FLAG
		END
----------------------------------[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 END------------------------------------	
-------------------------------------------------------------------------------------------------------------------------------------

PRINT '4'

	--###############################################   #results_MST 테이블에 split후 insert (END)
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   BEGIN
		   	--[E20250306-001052]_비정상적으로 3쌍이 아닌 메져가 들어오는 경우가 발생함(매번 발생하는 건이 아닌, 가끔 발생하는 부분임) 
			--VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 START		
			--데이터 중 메져가 LOC, KRW, USD 세쌍으로 이루어지지 않은 데이터를 추출한다.
			IF
			(	SELECT COUNT(1)
				FROM
				(	
					SELECT v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID, v_YYYYMMDD, v_CURRENCY, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS
					FROM #results_MST 	 
					GROUP BY v_DIVISION_ID, v_PROJECT_CODE, v_SCM_SITE_ID, v_PLANT_SITE_ID, v_ITEM_ID, v_YYYYMMDD, v_CURRENCY, v_DOM_EXP, v_FCST_TYPE, v_INCOTERMS
					HAVING COUNT(*) < 3 ) A
			) > 0				
			BEGIN
				--MSG00452: 입력하신 데이터의 메져: LOC값을 확인 후 재저장 하시기 바랍니다.
				SELECT KO FROM TB_FX_MESSAGEINFO WHERE MESSAGEID = 'MSG00452';
				SET @v_log_type = 'INVALID';
				GOTO ERR_RTN;	
			END
			--VALIDATION을 추가하여, 3쌍이 아닌 메져가 들어오는 경우 체크 END

PRINT '5'
		   IF @v_DIVISION_ID <> '40'
			   IF (select count(1)  from #results_MST where ( select count(1) from dbo.scm_mst_project WITH(NOLOCK) where project_code  = v_PROJECT_CODE ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_PROJECT_CODE +']'+ N' Invalid Project Code !';
				   GOTO ERR_RTN;	
			   end

PRINT '6'

			   IF (select count(1)  from #results_MST where ( select count(1) from dbo.SCM_MST_ITEM_SN WITH(NOLOCK) where ITEM_ID  = v_ITEM_ID ) = 0 ) > 0
			   begin
				   SET @v_log_type = 'INVALID';
				   SELECT '['+ @v_ITEM_ID +']'+ N' Invalid Item ID !';
				   GOTO ERR_RTN;	
			   end

				-- 20180814 KHSONG Invalid Site Item validation 추가
				DECLARE @valid_item_id		     NVARCHAR(MAX);
				SET @valid_item_id = NULL

PRINT '7'
		----------------------------------------------------------------------------------------------------------◎◎◎◎
			IF EXISTS(select * 
					from #results_MST  where (v_division_id LIKE '81%' OR v_division_id = '40')  -- 자동차,소형인경우
				) 

				BEGIN
					
					SELECT TOP 1 @valid_item_id = A.v_ITEM_ID
						FROM #results_MST A
							LEFT OUTER JOIN DBO.SCM_MST_SITE_ITEM ITEM
										ON ITEM.DIVISION_ID   = A.v_DIVISION_ID 
										AND ITEM.PROJECT_CODE  = A.v_PROJECT_CODE
										AND ITEM.SCM_SITE_ID   = A.v_SCM_SITE_ID
										AND ITEM.ITEM_ID       = A.v_ITEM_ID
										AND ITEM.VALID_YN	   = 'Y'
							LEFT OUTER JOIN DBO.DM_MST_ITEM_SINGLE_V SN
										ON ITEM.DIVISION_ID   = SN.DIVISION_ID
										AND ITEM.ITEM_ID       = SN.ITEM_ID
										AND SN.ACTIVE_FLAG	   = 'Y'
						WHERE 1=1
						AND A.v_PRICE <> 0
                        AND ( ITEM.ITEM_ID IS NULL 
                            OR SN.ITEM_ID IS NULL )

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

PRINT '8'

		   END
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------
--===================================================================================== #results_MST 테이블에 split후 insert end

--  SELECT * FROM #results_MST;  -- 확인용


			--------------------------------------------------------------------------------------------------------------------------------
			--                                                                 20200422 KHSONG C20200102-000131 Validation 로직 추가 (BEGIN)
			--------------------------------------------------------------------------------------------------------------------------------
			DECLARE @v_invalid_Site	NVARCHAR(200);
			set @v_invalid_Site = null

-------------------------------------------------------------------------------------------------------------------------------------
			--[E20240206-000758]_[영업마케팅 PI팀] Sales Price 화면 로직 개선 START	
			--ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다. 			
-------------------------------------------------------------------------------------------------------------------------------------
			DECLARE @n_Dflag_chk INTEGER = 0;
			SET @n_Dflag_chk = (	
										SELECT COUNT(*) 
										FROM #results_MST 
										WHERE v_active_flag = 'D'
									)		

			IF @n_Dflag_chk > 0
			BEGIN
					--52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다. 
					set @v_invalid_Site = 
								(SELECT top 1 N'● Sales Site : ' + SCM_SITE_ID + N' / ● Model : ' + ITEM_ID
									FROM [dbo].DM_PLN_MKT_FCST F WITH(NOLOCK)
									JOIN SCM_SYS_CALENDAR_M B (NOLOCK) 
										ON F.YYYYMMDD = B.BASIS_YYYYMMDD
									WHERE EXISTS (
														SELECT v_DIVISION_ID
														FROM #results_MST A
														JOIN SCM_SYS_CALENDAR_M D (NOLOCK) 
															ON A.v_YYYYMMDD = D.BASIS_YYYYMMDD
														WHERE v_active_flag      = 'D'
														AND F.DIVISION_ID    = A.v_DIVISION_ID         
														AND F.PROJECT_CODE	 = A.v_PROJECT_CODE      
														AND F.SCM_SITE_ID    = A.v_SCM_SITE_ID
														AND F.PLANT_SITE_ID  = A.v_PLANT_SITE_ID
														AND F.ITEM_ID        = A.v_ITEM_ID     
														AND F.DOM_EXP        = A.v_DOM_EXP      
														AND F.FCST_TYPE      = A.v_FCST_TYPE      
														AND F.INCOTERMS      = A.v_INCOTERMS 
														AND F.MEASURE   IN  ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
														-----------------------------------------------------------------------------------------------------------------------------------
														-- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
														--AND F.YYYYMMDD  >  CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
														-----------------------------------------------------------------------------------------------------------------------------------
														AND F.YYYYMMDD  >=  CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)
														-- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (END)
														-----------------------------------------------------------------------------------------------------------------------------------
														AND B.ISO_YYYYWW = D.ISO_YYYYWW
														AND F.QTY		     <>  0  -- 제로값은 제외함
														AND F.FCST_TYPE NOT IN (
																					SELECT SEGMENT1 -- FCST_TYPE
																					FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																					WHERE 1=1
																					AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																					AND MST.SEGMENT4 = 'FREE'  -- 무상 제공인경우
																					GROUP BY SEGMENT1
																				)  -- 무상제공인경우는 Validation 에서 제외
														) 
								)

					IF @v_invalid_Site IS NOT NULL
						BEGIN
							SELECT N'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.'+char(10) + @v_invalid_Site
							SET @v_log_type = 'INVALID';
							GOTO ERR_RTN;	
						END


					set @v_invalid_Site = 
								(SELECT top 1 N'● Sales Site : ' + SCM_SITE_ID + N' / ● Model : ' + ITEM_ID
									FROM [dbo].DM_PLN_MKT_FCST F WITH(NOLOCK)
										WHERE exists (
														SELECT v_DIVISION_ID
															FROM #results_MST 
															where v_active_flag      = 'D'
															and F.DIVISION_ID        =   v_DIVISION_ID         
															AND F.PROJECT_CODE       =   v_PROJECT_CODE      
															AND F.SCM_SITE_ID        =   v_SCM_SITE_ID
															AND F.PLANT_SITE_ID      =   v_PLANT_SITE_ID
															AND F.ITEM_ID            =   v_ITEM_ID     
															AND F.DOM_EXP            =   v_DOM_EXP      
															AND F.FCST_TYPE          =   v_FCST_TYPE      
															AND F.INCOTERMS          =   v_INCOTERMS 
															-- [C20211126-000348] AS_In_Req 메저 추가
															AND F.MEASURE            IN  ('MKT_FCST','RTF_SCP','AS_In_Req')  -- 대상 MEASURE
															-----------------------------------------------------------------------------------------------------------------------------------
															-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
															/*
															AND F.YYYYMMDD           BETWEEN  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후건만 확인
																					 AND      CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- SCP PLANNING 구간이 52주 */
															-----------------------------------------------------------------------------------------------------------------------------------
															AND	F.YYYYMMDD  >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
															AND F.YYYYMMDD	<  CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
															-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
															-----------------------------------------------------------------------------------------------------------------------------------
															AND F.QTY		         <>  0  -- 제로값은 제외함
															AND F.FCST_TYPE not in (
																						SELECT SEGMENT1 -- FCST_TYPE
																							FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
																								WHERE 1=1
																									AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																									AND MST.SEGMENT4 = 'FREE'  -- 무상 제공인경우
																						GROUP BY SEGMENT1
																					)  -- 무상제공인경우는 Validation 에서 제외
														) 
								)

					IF @v_invalid_Site IS NOT NULL
						BEGIN
							SELECT N'MKT FCST or RTF or AS_In_Req 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.'+char(10) + @v_invalid_Site
							SET @v_log_type = 'INVALID';
							GOTO ERR_RTN;	
						END

			END
			--------------------------------------------------------------------------------------------------------------------------------
			--                                                                   20200422 KHSONG C20200102-000131 Validation 로직 추가 (END)
			--------------------------------------------------------------------------------------------------------------------------------
			
			--Start [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인
	
PRINT '9'		
			DECLARE @v_invalid_Dup	NVARCHAR(200);
			set @v_invalid_Dup = null

			BEGIN

				select top 1 V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE, count(V_CURRENCY) as cnt
				into   #results_MST_Dup
				from   #results_MST 
				where    isnull(v_PRICE, 0) <> 0
				group by V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID, V_YYYYMMDD, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_MEASURE
				having   count(V_CURRENCY) > 1 
									
				set @v_invalid_Dup = 
					(select top 1  V_ITEM_ID
					from #results_MST_Dup a )

				IF @v_invalid_Dup IS NOT NULL
					BEGIN
						SELECT N'동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
						SET @v_log_type = 'INVALID';
						GOTO ERR_RTN;	
					END
			END
	
PRINT '10'			
			--End [C20200814-000093] 동일 기간에 두 개 이상의 Currency가 중복으로 입력되는지 확인

			--[E20241125-000026]_Sales Price Validation 추가 START
			DECLARE @v_invalid_Dup_Data	NVARCHAR(200);
			set @v_invalid_Dup_Data = null

			BEGIN			
				set @v_invalid_Dup_Data = 
				( SELECT TOP 1 ITEM_ID
				  FROM [dbo].SCM_MST_FUTURE_PRICE
				  WHERE (
							SELECT count(1) 
								FROM #results_MST 
								WHERE DIVISION_ID      =   v_DIVISION_ID         
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
								AND v_active_flag	   = 'I'
							) > 0)

				IF @v_invalid_Dup_Data IS NOT NULL
					BEGIN
						SELECT N'동일 기간에 두 개 이상의 Currency에 해당하는 Sales Price가 존재합니다.'
						SET @v_log_type = 'INVALID';
						GOTO ERR_RTN;	
					END
			END
			--[E20241125-000026]_Sales Price Validation 추가 END

PRINT '11'	
			/*
			--START 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
			DECLARE @valid_yyyymmdd		     NVARCHAR(8);
			SET @valid_yyyymmdd = NULL

			SELECT TOP 1 @valid_yyyymmdd = MIN(A.v_YYYYMMDD)
						FROM #results_MST A
						WHERE A.v_PRICE = 0
                        AND A.v_MEASURE <> 'LOC'
						AND A.v_active_flag <> 'D'

			IF @valid_yyyymmdd IS NOT NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SET @v_description = '['+ @valid_yyyymmdd +']'+ N' 환율정보가 없습니다. 해당 구간은 저장되지 않습니다.'
				END
			--END 20220826 - LOC를 제외한 MEASURE의 PRICE값이 0인 것 체크
--===================================================================================== #results_MST delete start
			
			DELETE A
			FROM #results_MST A
			INNER JOIN #results_MST B
					ON A.v_DIVISION_ID		= B.v_DIVISION_ID
					AND A.v_PROJECT_CODE	= B.v_PROJECT_CODE
					AND A.v_SCM_SITE_ID		= B.v_SCM_SITE_ID
					AND A.v_PLANT_SITE_ID	= B.v_PLANT_SITE_ID
					AND A.v_ITEM_ID			= B.v_ITEM_ID
					AND A.v_YYYYMMDD		= B.v_YYYYMMDD
					AND A.v_CURRENCY        = B.v_CURRENCY           
					AND A.v_DOM_EXP		    = B.v_DOM_EXP      
					AND A.v_FCST_TYPE       = B.v_FCST_TYPE      
					AND A.v_INCOTERMS       = B.v_INCOTERMS 
			WHERE B.v_PRICE = 0
			*/

--===================================================================================== #results_MST delete end

--===================================================================================== delete start
BEGIN

PRINT '12'	
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

PRINT '13'	
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
                       and DIVISION_ID =   v_DIVISION_ID         
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

-- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (END)

/*
						--[2018-03-20][수정][기존소스]
						-- HISTORY 생성
						   BEGIN
							  EXEC [dbo].[PR_DM_ANL_SALES_PRICE_HIST]
			  										 @v_division_id   
				  									,@v_project_code  
													,@v_scm_site_id   
													,@v_plant_site_id 
													,@v_item_id       
													,@v_yyyymmdd      
													,@v_currency      
													,@v_measure       
													,@v_dom_exp       
													,@v_fcst_type     
													,@v_incoterms     
													,@v_price         
													,@v_created_by    
													,@v_last_updated_by
						   END
*/

						   -- [2018-03-20][수정][수정소스]
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

PRINT '14'	
						-- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
						EXEC dbo.PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE  
						--------------------------------------------------------------------------------------  20180510 SKH ADD END

PRINT '15'	

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
		
	    --[PJ20200138] 입력된 Price가 주변 주차와 Range Rate 가 초과되어 차이나는 데이터 Return
	    with w_min_max_date(rownum, yyyymmdd, min_yyyymmdd, max_yyyymmdd) as (
			select CAST(r.v_rownum AS INT), r.v_yyyymmdd
			     , (select isnull(max(s_min.yyyymmdd), '') 
					from  SCM_MST_FUTURE_PRICE s_min with(nolock)
					where s_min.division_id = r.v_division_id
					and   s_min.project_code = r.v_project_code
					and   s_min.scm_site_id = r.v_scm_site_id
					and   s_min.plant_site_id = r.v_plant_site_id
					and   s_min.item_id = r.v_item_id
					and   s_min.currency = r.v_currency
					and   s_min.measure = r.v_measure
					and   s_min.dom_exp = r.v_dom_exp
					and   s_min.fcst_type = r.v_fcst_type
					and   s_min.incoterms = r.v_incoterms
					and   s_min.measure = 'LOC'
					and   s_min.yyyymmdd < r.v_yyyymmdd ) as min_yyyymmdd
			     , (select isnull(min(s_max.yyyymmdd), '') 
					from  SCM_MST_FUTURE_PRICE s_max with(nolock)
					where s_max.division_id = r.v_division_id
					and   s_max.project_code = r.v_project_code
					and   s_max.scm_site_id = r.v_scm_site_id
					and   s_max.plant_site_id = r.v_plant_site_id
					and   s_max.item_id = r.v_item_id
					and   s_max.currency = r.v_currency
					and   s_max.measure = r.v_measure
					and   s_max.dom_exp = r.v_dom_exp
					and   s_max.fcst_type = r.v_fcst_type
					and   s_max.incoterms = r.v_incoterms
					and   s_max.measure = 'LOC'
					and   s_max.yyyymmdd > r.v_yyyymmdd ) as max_yyyymmdd
			from   #results_MST r with(nolock) 
			where 1=1
			and   r.v_measure = 'LOC'
			AND		R.v_active_flag <> 'D'	-- 2022.07.22
		)
		, w_return as (
			select r.v_rownum, (CASE WHEN s.division_id = '40' THEN s.project_code ELSE c.end_customer END) as end_customer
			     , s.project_code, s.scm_site_id, s.item_id, s.incoterms, s.fcst_type, s.currency
			     , s.division_id, s.plant_site_id, s.measure, s.dom_exp
				 , r.v_yyyymmdd as ch_yyyymmdd, convert(numeric(13,3), r.v_price) as ch_price
				 , s.yyyymmdd   as st_yyyymmdd, convert(numeric(13,3), s.price) as st_price
				 , row_number() over(partition by r.v_rownum, r.v_yyyymmdd order by r.v_rownum, r.v_yyyymmdd) as rep_rownum
			from  #results_MST r with(nolock)
			inner join SCM_MST_FUTURE_PRICE s with(nolock) 
			on    s.division_id = r.v_division_id
			and   s.project_code = r.v_project_code
			and   s.scm_site_id = r.v_scm_site_id
			and   s.plant_site_id = r.v_plant_site_id
			and   s.item_id = r.v_item_id
			and   s.currency = r.v_currency
			and   s.measure = r.v_measure
			and   s.dom_exp = r.v_dom_exp
			and   s.fcst_type = r.v_fcst_type
			and   s.incoterms = r.v_incoterms
			inner join w_min_max_date w
			on    r.v_rownum = w.rownum
			and   r.v_yyyymmdd = w.yyyymmdd
			LEFT  JOIN  SCM_MST_SITE c WITH(NOLOCK)  
			ON    s.DIVISION_ID = C.DIVISION_ID 
			AND   s.SCM_SITE_ID = C.SCM_SITE_ID 
			AND   C.SITE_TYPE = 'SALES'
			join (select segment1 as division_id, segment2 as range
				  from   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				  WHERE  VALID_YN = 'Y'
				  AND    LOOKUP_TYPE = 'SALES_PRICE_RANGE_RATE' ) l
            on    s.division_id = l.division_id
			where s.measure = 'LOC'
			and   c.VALID_YN = 'Y'
			and   (s.price * l.range) < abs(s.price - r.v_price)
			and   s.yyyymmdd in ( w.min_yyyymmdd, w.max_yyyymmdd)
		)
		select *
		from   w_return with(nolock)
		where  rep_rownum = 1
		order by 1,2,3,8,9
	;
		SELECT @v_description
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



