
/*===============================================================================================================================
 * Program ID   : DMF0042_SAVE_DM_PLN_BP_FCST
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===============================================================================================================================
 *   Date       In Charge      Description
 *===============================================================================================================================
 * 2019-04-11	KHSONG			Initial Release [PJ20189106] 전지본부 GSCM(DM) 고도화 프로젝트
 * 2019-04-26					DM_PLN_BP_FCST 테이블에 SalesAmt_KRW, SalesAmt_LOC, SalesAmt_USD 값을 계산하여 Insert 처리
 * 2019-08-30	JSYOUN			81, 82 사업부에 따른 변경
 * 2019-09-16	KHSONG			ADDED COLUMN
 * 2020-01-06	KHSONG			수정
 * 2020-04-08	P.C.I			[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - Incoterms 삭제, item_use, unit_energy 추가
 * 2020-06-10	hwi1993			대량데이터 저장시 오류 수정 ( 대량관련 오류는 없고, loc 메저가 저장되지 않는 현상 수정함 )
 * 2020-07-31	hwi1993			NUMERIC CONVERT 오류 수정
 * 2020-09-04	hwi1993			[c20200722-000060] biz plan active YN
 * 2021-07-23	hwi1993			incoterms 추가 등 ( 중장기계획 과제 관련 ) 
 * 2021-08-06	hwi1993			MKT FCST 메저 추가
 * 2022-06-21	rosia27			[C20220609-000168]GSCM Business Plan 신규 키컬럼 추가 및 체크박스 옵션 추가 요청의 건
 * 2024-08-01	JSSBAE			[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청
 * 2025-07-15	JSSBAE			[E20250522-001188]_	Business Plan UI 데이터 저장 시 Trim 처리
 * 2025-10-02	JSSBAE			[E20250919-001699]_Incoterms 데이터 처리 VALID 처리     
 ===============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0042_SAVE_DM_PLN_BP_FCST]
    -- Add the parameters for the stored procedure here
      @p_active_flag				NVARCHAR(MAX)
	, @p_DIVISION_ID				NVARCHAR(MAX)
	, @p_PROJECT_CODE				NVARCHAR(MAX)
	, @p_PROJECT_NAME				NVARCHAR(MAX)
	, @p_SCM_SITE_ID				NVARCHAR(MAX)
	, @p_PLANT_SITE_ID				NVARCHAR(MAX)
	, @p_ITEM_ID					NVARCHAR(MAX)
	--, @p_DOM_EXP					NVARCHAR(MAX)
	, @p_FCST_TYPE					NVARCHAR(MAX)
	, @p_INCOTERMS					NVARCHAR(MAX) -- [PJ20200138] Incoterms 삭제
	--------------------------------------------------------------------------------------------------
	-- [PJ20200138] item_use, unit_energy 추가 (START)
	, @p_ITEM_USE					NVARCHAR(MAX)
	, @p_UNIT_ENERGY				NVARCHAR(MAX)
	-- [PJ20200138] item_use, unit_energy 추가 (END)
	--------------------------------------------------------------------------------------------------
	, @p_MEASURE					NVARCHAR(MAX)
	, @p_YYYYMM						NVARCHAR(MAX)
	, @p_QTY						NVARCHAR(MAX)
	, @p_CURRENCY					NVARCHAR(MAX)
	--------------------------------------------------------------------------------------------------
	-- 20190830 파라미터추가 (START)
	, @p_DEPT_ID					NVARCHAR(MAX)
	, @p_END_CUSTOMER				NVARCHAR(MAX)
	, @p_BIZ_TYPE					NVARCHAR(MAX)
	, @p_CELL_PROD_SITE				NVARCHAR(MAX)
    --, @p_CELL_PER_PACK            NVARCHAR(MAX)
    --, @p_CELL_PER_MODULE          NVARCHAR(MAX)
    --, @p_MODULE_PER_PACK          NVARCHAR(MAX)
    -- 20190830 파라미터추가 (END)
	--------------------------------------------------------------------------------------------------
	, @p_CREATED_BY					NVARCHAR(MAX)
	, @p_LAST_UPDATED_BY			NVARCHAR(MAX)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	
	--======================================================
    -- 스플릿관련 변수
	--======================================================
	DECLARE	@n_active_flag			NVARCHAR(MAX);
	DECLARE	@v_active_flag			NVARCHAR(MAX);
	DECLARE	@v_DIVISION_ID			NVARCHAR(MAX);
	DECLARE	@v_PROJECT_CODE			NVARCHAR(MAX);
	DECLARE	@v_PROJECT_NAME			NVARCHAR(MAX);
	DECLARE	@v_SCM_SITE_ID			NVARCHAR(MAX);
	DECLARE	@v_PLANT_SITE_ID		NVARCHAR(MAX);
	DECLARE	@v_ITEM_ID				NVARCHAR(MAX);
	--DECLARE @v_DOM_EXP			NVARCHAR(MAX);
	DECLARE @v_FCST_TYPE			NVARCHAR(MAX);
	DECLARE @v_INCOTERMS			NVARCHAR(MAX);-- [PJ20200138] Incoterms 삭제
	--------------------------------------------------------------------------------------------------
	-- [PJ20200138] item_use, unit_energy 추가 (START)
	DECLARE @v_ITEM_USE				NVARCHAR(MAX);
	DECLARE @v_UNIT_ENERGY			NVARCHAR(MAX);
	-- [PJ20200138] item_use, unit_energy 추가 (END)
	--------------------------------------------------------------------------------------------------
	DECLARE @v_MEASURE				NVARCHAR(MAX);
	DECLARE @v_YYYYMM				NVARCHAR(MAX);
	DECLARE @v_CURRENCY				NVARCHAR(MAX);
	DECLARE @v_QTY					NVARCHAR(MAX);
	--------------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
	DECLARE @v_DEPT_ID				NVARCHAR(MAX);
	DECLARE @v_END_CUSTOMER			NVARCHAR(MAX);
	DECLARE @v_BIZ_TYPE				NVARCHAR(MAX);
	DECLARE @v_CELL_PROD_SITE		NVARCHAR(MAX);
	--DECLARE @v_CELL_PER_PACK		NVARCHAR(MAX);
	--DECLARE @v_CELL_PER_MODULE	NVARCHAR(MAX);
	--DECLARE @v_MODULE_PER_PACK	NVARCHAR(MAX);
	-- 20190830 변수 추가 (END)
	--------------------------------------------------------------------------------------------------
    DECLARE @v_CREATED_BY			NVARCHAR(MAX);
    DECLARE @v_LAST_UPDATED_BY		NVARCHAR(MAX);
	
	--======================================================
    -- LOG 용 변수 설정
	--======================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0042_SAVE_DM_PLN_BP_FCST';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
    DECLARE @n_del_count			INTEGER = 0;
    DECLARE @n_insert_count			INTEGER = 0;	
	
	--======================================================
    -- SEQUENCE
	--======================================================
    DECLARE @n_history_seq			INTEGER;
	
	--======================================================
    -- 마지막 데이터 처리를 위한 구분자 추가
	--======================================================
    SET @p_active_flag        = RTRIM(@p_active_flag     ) + '^';
    SET @p_DIVISION_ID        = RTRIM(@p_DIVISION_ID     ) + '^';
    SET @p_PROJECT_CODE       = RTRIM(@p_PROJECT_CODE    ) + '^';
    SET @p_PROJECT_NAME       = RTRIM(@p_PROJECT_NAME    ) + '^';
    SET @p_SCM_SITE_ID        = RTRIM(@p_SCM_SITE_ID     ) + '^';
    SET @p_PLANT_SITE_ID      = RTRIM(@p_PLANT_SITE_ID   ) + '^';
    SET @p_ITEM_ID            = RTRIM(@p_ITEM_ID         ) + '^';
    --SET @p_DOM_EXP            = RTRIM(@p_DOM_EXP         ) + '^';
    SET @p_FCST_TYPE          = RTRIM(@p_FCST_TYPE       ) + '^';
    SET @p_INCOTERMS          = RTRIM(@p_INCOTERMS       ) + '^';-- [PJ20200138] Incoterms 삭제
	--------------------------------------------------------------------------------------------------
	-- [PJ20200138] item_use, unit_energy 추가 (START)
    SET @p_ITEM_USE		      = RTRIM(@p_ITEM_USE        ) + '^';
    SET @p_UNIT_ENERGY		  = RTRIM(@p_UNIT_ENERGY     ) + '^';
	-- [PJ20200138] item_use, unit_energy 추가 (END)
	--------------------------------------------------------------------------------------------------
    SET @p_MEASURE            = RTRIM(@p_MEASURE         ) + '^';
    SET @p_YYYYMM             = RTRIM(@p_YYYYMM          ) + '^';
    SET @p_CURRENCY           = RTRIM(@p_CURRENCY        ) + '^';
    SET @p_QTY                = RTRIM(@p_QTY             ) + '^';
	--------------------------------------------------------------------------------------------------
    -- 20190830 변수 추가 (START)
    SET @p_DEPT_ID            = RTRIM(@p_DEPT_ID         ) + '^';
    SET @p_END_CUSTOMER       = RTRIM(@p_END_CUSTOMER    ) + '^';
    SET @p_BIZ_TYPE           = RTRIM(@p_BIZ_TYPE        ) + '^';
	SET @p_CELL_PROD_SITE     = RTRIM(@p_CELL_PROD_SITE  ) + '^';
    --SET @p_CELL_PER_PACK      = RTRIM(@p_CELL_PER_PACK   ) + '^';
    --SET @p_CELL_PER_MODULE    = RTRIM(@p_CELL_PER_MODULE ) + '^';
    --SET @p_MODULE_PER_PACK    = RTRIM(@p_MODULE_PER_PACK ) + '^';
	-- 20190830 변수 추가 (END)
	--------------------------------------------------------------------------------------------------
    SET @p_CREATED_BY         = RTRIM(@p_CREATED_BY      ) + '^';
    SET @p_LAST_UPDATED_BY    = RTRIM(@p_LAST_UPDATED_BY ) + '^';
	
	--======================================================
    -- TEMP TABLE DROP
	--======================================================
    IF OBJECT_ID(N'tempdb..#TEMP_BP_FCST', N'U') IS NOT NULL
        DROP TABLE #TEMP_BP_FCST;	
    IF OBJECT_ID(N'tempdb..#TMP_DM_PLN_BP_FCST_X', N'U') IS NOT NULL
		DROP TABLE #TMP_DM_PLN_BP_FCST_X;	
	--------------------------------------------------------------------------------------------------
	-- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (START)
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_V', N'U') IS NOT NULL 		
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_V
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_ORI_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_ORI_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_A_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_A_V;
	IF OBJECT_ID (N'tempdb..#TEMP_DM_MST_ITEM_SINGLE_B_V', N'U') IS NOT NULL 	
		DROP TABLE #TEMP_DM_MST_ITEM_SINGLE_B_V;	
	-- [E20250522-001188]_속도 개선을 위해 해당 테이블의 원테이블로 조회하여 TEMP로 사용함 (END)
	--------------------------------------------------------------------------------------------------
	
	--======================================================
    -- TEMP TABLE CREATE
	--======================================================
	CREATE TABLE #TEMP_BP_FCST 
	( ACTIVE_FLAG			NVARCHAR(10)
	, DIVISION_ID			NVARCHAR(30)
	, PROJECT_CODE			NVARCHAR(50)
	, PROJECT_NAME			NVARCHAR(50)
	, SCM_SITE_ID			NVARCHAR(30)
	, PLANT_SITE_ID			NVARCHAR(30)
	, ITEM_ID				NVARCHAR(50)
	--, DOM_EXP				NVARCHAR(3)
	, FCST_TYPE				NVARCHAR(20)
	, INCOTERMS				NVARCHAR(MAX) -- [PJ20200138] Incoterms 삭제
	-------------------------------------------------
	-- [PJ20200138] item_use, unit_energy 추가 (START)
	, ITEM_USE				NVARCHAR(4)
	, UNIT_ENERGY			NVARCHAR(MAX)
	-- [PJ20200138] item_use, unit_energy 추가 (END)
	--------------------------------------------------------------------------------------------------
	, MEASURE				NVARCHAR(50)
	, YYYYMM				NVARCHAR(6)
	, CURRENCY				NVARCHAR(10)
	, QTY					NUMERIC(30,10)
	--------------------------------------------------------------------------------------------------
    -- 20190830 추가 (START)
	, DEPT_ID				NVARCHAR(50)
	, END_CUSTOMER			NVARCHAR(50)
	, BIZ_TYPE				NVARCHAR(30)
	, CELL_PROD_SITE		NVARCHAR(30)
	--, CELL_PER_PACK		NVARCHAR(MAX)
    --, CELL_PER_MODULE		NVARCHAR(MAX)
    --, MODULE_PER_PACK		NVARCHAR(MAX)
    -- 20190830 추가 (END)
	--------------------------------------------------------------------------------------------------
	, CREATED_BY			NVARCHAR(150)
	, LAST_UPDATED_BY		NVARCHAR(150))

	CREATE TABLE #TMP_DM_PLN_BP_FCST_X 
	( DIVISION_ID			NVARCHAR(30)	NOT NULL
	, PROJECT_CODE			NVARCHAR(50)	NOT NULL
	, PROJECT_NAME			NVARCHAR(50)	NOT NULL
	, SCM_SITE_ID			NVARCHAR(30)	NOT NULL
	, ITEM_ID				NVARCHAR(50)	NOT NULL
	--, DOM_EXP				NVARCHAR(3)		NULL
	, FCST_TYPE				NVARCHAR(20)	NOT NULL
	, INCOTERMS				NVARCHAR(10)	NOT NULL  -- [PJ20200138] Incoterms 삭제
	--------------------------------------------------------------------------------------------------
	-- [PJ20200138] item_use, unit_energy 추가 (START)
	, ITEM_USE				NVARCHAR(50)	NOT NULL
	, UNIT_ENERGY			NUMERIC(30,10)	NULL
	-- [PJ20200138] item_use, unit_energy 추가 (END)
	--------------------------------------------------------------------------------------------------
	, MEASURE				NVARCHAR(50)	NOT NULL
	, PLANT_SITE_ID			NVARCHAR(30)	NOT NULL
	, YYYYMM				NVARCHAR(6)		NOT NULL
	, CURRENCY				NVARCHAR(10)	NOT NULL
	, QTY					NUMERIC(30,10)	NULL
	--------------------------------------------------------------------------------------------------
    -- 20190830 추가 (START)
	, DEPT_ID				NVARCHAR(50)	NOT NULL
	, END_CUSTOMER			NVARCHAR(50)	NOT NULL
	, BIZ_TYPE				NVARCHAR(30)	NOT NULL
	, CELL_PROD_SITE		NVARCHAR(30)	NOT NULL
	--, CELL_PER_PACK		NUMERIC(30,10)	NULL
	--, CELL_PER_MODULE		NUMERIC(30,10)	NULL
	--, MODULE_PER_PACK		NUMERIC(30,10)	NULL
    -- 20190830 추가 (END)
	--------------------------------------------------------------------------------------------------
	, CREATED_BY			NVARCHAR(150)	NULL
	, LAST_UPDATED_BY		NVARCHAR(150)	NULL);
	
	--======================================================
	-- 시작 LOG  (START)
	--======================================================
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	--======================================================
	-- 시작 LOG  (END)
	--======================================================	
PRINT @v_program_name + ' : A001-- :' + CONVERT(VARCHAR(30), GETDATE(), 121);  
	--======================================================
	-- 트랜잭션 (START)
	--======================================================
	BEGIN TRANSACTION SAVE_DM_PLN_BP_FCST;
		--------------------------------------------------------------------------------------------
        BEGIN TRY
		--------------------------------------------------------------------------------------------
			WHILE LEN(@p_DIVISION_ID) > 0
			--======================================================
			--#TEMP_BP_FCST 테이블에 split후 insert (START)
			--======================================================
			BEGIN
				BEGIN
					DECLARE @index_active_flag     INT
					DECLARE @index_DIVISION_ID     INT
					DECLARE @index_PROJECT_CODE    INT
					DECLARE @index_PROJECT_NAME    INT
					DECLARE @index_SCM_SITE_ID     INT
					DECLARE @index_PLANT_SITE_ID   INT
					DECLARE @index_ITEM_ID         INT
					--DECLARE @index_DOM_EXP         INT
					DECLARE @index_FCST_TYPE       INT
					DECLARE @index_INCOTERMS       INT -- [PJ20200138] Incoterms 삭제	
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)
					DECLARE @index_ITEM_USE		   INT
					DECLARE @index_UNIT_ENERGY	   INT
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					DECLARE @index_MEASURE         INT
					DECLARE @index_YYYYMM          INT
					DECLARE @index_CURRENCY        INT
					DECLARE @index_QTY             INT
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					DECLARE @index_DEPT_ID         INT
					DECLARE @index_END_CUSTOMER    INT
					DECLARE @index_BIZ_TYPE   INT
					DECLARE @index_CELL_PROD_SITE  INT
					--DECLARE @index_CELL_PER_PACK   INT
					--DECLARE @index_CELL_PER_MODULE INT
					--DECLARE @index_MODULE_PER_PACK INT
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------
					DECLARE @index_CREATED_BY      INT
					DECLARE @index_LAST_UPDATED_BY INT

					SET @index_active_flag      = PATINDEX('%' + '^' + '%', @p_active_flag    )
					SET @index_DIVISION_ID      = PATINDEX('%' + '^' + '%', @p_DIVISION_ID    )
					SET @index_PROJECT_CODE     = PATINDEX('%' + '^' + '%', @p_PROJECT_CODE   )
					SET @index_PROJECT_NAME     = PATINDEX('%' + '^' + '%', @p_PROJECT_NAME   )
					SET @index_SCM_SITE_ID      = PATINDEX('%' + '^' + '%', @p_SCM_SITE_ID    )
					SET @index_PLANT_SITE_ID    = PATINDEX('%' + '^' + '%', @p_PLANT_SITE_ID  )
					SET @index_ITEM_ID          = PATINDEX('%' + '^' + '%', @p_ITEM_ID        )
					--SET @index_DOM_EXP          = PATINDEX('%' + '^' + '%', @p_DOM_EXP        )
					SET @index_FCST_TYPE        = PATINDEX('%' + '^' + '%', @p_FCST_TYPE      )
					SET @index_INCOTERMS        = PATINDEX('%' + '^' + '%', @p_INCOTERMS      ) -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)
					SET @index_ITEM_USE			= PATINDEX('%' + '^' + '%', @p_ITEM_USE		  )
					SET @index_UNIT_ENERGY		= PATINDEX('%' + '^' + '%', @p_UNIT_ENERGY	  )
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					SET @index_MEASURE          = PATINDEX('%' + '^' + '%', @p_MEASURE        )
					SET @index_YYYYMM           = PATINDEX('%' + '^' + '%', @p_YYYYMM         )
					SET @index_CURRENCY         = PATINDEX('%' + '^' + '%', @p_CURRENCY       )
					SET @index_QTY              = PATINDEX('%' + '^' + '%', @p_QTY            )
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					SET @index_DEPT_ID          = PATINDEX('%' + '^' + '%', @p_DEPT_ID        )
					SET @index_END_CUSTOMER     = PATINDEX('%' + '^' + '%', @p_END_CUSTOMER   )
					SET @index_BIZ_TYPE         = PATINDEX('%' + '^' + '%', @p_BIZ_TYPE       )
					SET @index_CELL_PROD_SITE   = PATINDEX('%' + '^' + '%', @p_CELL_PROD_SITE )
					--SET @index_CELL_PER_PACK    = PATINDEX('%' + '^' + '%', @p_CELL_PER_PACK  )
					--SET @index_CELL_PER_MODULE  = PATINDEX('%' + '^' + '%', @p_CELL_PER_MODULE)
					--SET @index_MODULE_PER_PACK  = PATINDEX('%' + '^' + '%', @p_MODULE_PER_PACK)	
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------			
					SET @index_CREATED_BY       = PATINDEX('%' + '^' + '%', @p_CREATED_BY     )
					SET @index_LAST_UPDATED_BY  = PATINDEX('%' + '^' + '%', @p_LAST_UPDATED_BY)
				END
				IF @index_DIVISION_ID > 0
				BEGIN
					SET @v_active_flag = SUBSTRING(@p_active_flag, 0, @index_active_flag)
					SET @p_active_flag = SUBSTRING(@p_active_flag, LEN(@v_active_flag + '^') + 1, LEN(@p_active_flag))

					SET @v_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, 0, @index_DIVISION_ID)
					SET @p_DIVISION_ID = SUBSTRING(@p_DIVISION_ID, LEN(@v_DIVISION_ID + '^') + 1, LEN(@p_DIVISION_ID))

					SET @v_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE, 0, @index_PROJECT_CODE)
					SET @p_PROJECT_CODE = SUBSTRING(@p_PROJECT_CODE, LEN(@v_PROJECT_CODE + '^') + 1, LEN(@p_PROJECT_CODE))

					SET @v_PROJECT_NAME = SUBSTRING(@p_PROJECT_NAME, 0, @index_PROJECT_NAME)
					SET @p_PROJECT_NAME = SUBSTRING(@p_PROJECT_NAME, LEN(@v_PROJECT_NAME + '^') + 1, LEN(@p_PROJECT_NAME))

					SET @v_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, 0, @index_SCM_SITE_ID)
					SET @p_SCM_SITE_ID = SUBSTRING(@p_SCM_SITE_ID, LEN(@v_SCM_SITE_ID + '^') + 1, LEN(@p_SCM_SITE_ID))

					SET @v_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, 0, @index_PLANT_SITE_ID)
					SET @p_PLANT_SITE_ID = SUBSTRING(@p_PLANT_SITE_ID, LEN(@v_PLANT_SITE_ID + '^') + 1, LEN(@p_PLANT_SITE_ID))

					SET @v_ITEM_ID = SUBSTRING(@p_ITEM_ID, 0, @index_ITEM_ID)
					SET @p_ITEM_ID = SUBSTRING(@p_ITEM_ID, LEN(@v_ITEM_ID + '^') + 1, LEN(@p_ITEM_ID))

					--SET @v_DOM_EXP  = SUBSTRING(@p_DOM_EXP , 0, @index_DOM_EXP )
					--SET @p_DOM_EXP  = SUBSTRING(@p_DOM_EXP , LEN(@v_DOM_EXP  + '^') + 1, LEN(@p_DOM_EXP ))

					SET @v_FCST_TYPE  = SUBSTRING(@p_FCST_TYPE , 0, @index_FCST_TYPE )
					SET @p_FCST_TYPE  = SUBSTRING(@p_FCST_TYPE , LEN(@v_FCST_TYPE  + '^') + 1, LEN(@p_FCST_TYPE ))

					SET @v_INCOTERMS  = SUBSTRING(@p_INCOTERMS , 0, @index_INCOTERMS ) -- [PJ20200138] Incoterms 삭제
					SET @p_INCOTERMS  = SUBSTRING(@p_INCOTERMS , LEN(@v_INCOTERMS  + '^') + 1, LEN(@p_INCOTERMS ))				
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)			
					SET @v_ITEM_USE  = SUBSTRING(@p_ITEM_USE , 0, @index_ITEM_USE )
					SET @p_ITEM_USE  = SUBSTRING(@p_ITEM_USE , LEN(@v_ITEM_USE  + '^') + 1, LEN(@p_ITEM_USE ))

					SET @v_UNIT_ENERGY  = SUBSTRING(@p_UNIT_ENERGY , 0, @index_UNIT_ENERGY )
					SET @p_UNIT_ENERGY  = SUBSTRING(@p_UNIT_ENERGY , LEN(@v_UNIT_ENERGY  + '^') + 1, LEN(@p_UNIT_ENERGY ))
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------				
					SET @v_MEASURE  = SUBSTRING(@p_MEASURE , 0, @index_MEASURE )
					SET @p_MEASURE  = SUBSTRING(@p_MEASURE , LEN(@v_MEASURE  + '^') + 1, LEN(@p_MEASURE ))

					SET @v_YYYYMM  = SUBSTRING(@p_YYYYMM , 0, @index_YYYYMM )
					SET @p_YYYYMM  = SUBSTRING(@p_YYYYMM , LEN(@v_YYYYMM  + '^') + 1, LEN(@p_YYYYMM ))

					SET @v_CURRENCY  = SUBSTRING(@p_CURRENCY , 0, @index_CURRENCY )
					SET @p_CURRENCY  = SUBSTRING(@p_CURRENCY , LEN(@v_CURRENCY  + '^') + 1, LEN(@p_CURRENCY ))					
					--------------------------------------------------------------------------------------------------
					-- 20180319 skh added (START)	
					IF @p_CURRENCY is null
					BEGIN
						SET @p_CURRENCY = ''
					END
					-- 20180319 skh added (END)
					--------------------------------------------------------------------------------------------------
					SET @v_QTY  = SUBSTRING(@p_QTY , 0, @index_QTY )
					SET @p_QTY  = SUBSTRING(@p_QTY , LEN(@v_QTY  + '^') + 1, LEN(@p_QTY ))					
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					SET @v_DEPT_ID  = SUBSTRING(@p_DEPT_ID , 0, @index_DEPT_ID )
					SET @p_DEPT_ID  = SUBSTRING(@p_DEPT_ID , LEN(@v_DEPT_ID  + '^') + 1, LEN(@p_DEPT_ID ))

					SET @v_END_CUSTOMER  = SUBSTRING(@p_END_CUSTOMER , 0, @index_END_CUSTOMER )
					SET @p_END_CUSTOMER  = SUBSTRING(@p_END_CUSTOMER , LEN(@v_END_CUSTOMER  + '^') + 1, LEN(@p_END_CUSTOMER ))

					SET @v_BIZ_TYPE  = SUBSTRING(@p_BIZ_TYPE , 0, @index_BIZ_TYPE )
					SET @p_BIZ_TYPE  = SUBSTRING(@p_BIZ_TYPE , LEN(@v_BIZ_TYPE  + '^') + 1, LEN(@p_BIZ_TYPE ))

					SET @v_CELL_PROD_SITE   = SUBSTRING(@p_CELL_PROD_SITE  , 0, @index_CELL_PROD_SITE  )
					SET @p_CELL_PROD_SITE   = SUBSTRING(@p_CELL_PROD_SITE  , LEN(@v_CELL_PROD_SITE   + '^') + 1, LEN(@p_CELL_PROD_SITE  ))				
					--------------------------------------------------------------------------------------------------
					--[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (START)
					-- 화면에서 코드를 넘기는 것으로 변경했으므로, 더이상 필요없는 작업이므로 주석처리해서 막음
					/*
					-- 룩업 Code 로 바꿔준다.
					SELECT @v_CELL_PROD_SITE = ISNULL(SEGMENT1,'')
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL
					WHERE lookup_type = 'dm_cell_prod_site'
						AND ATTRIBUTE1 = @v_CELL_PROD_SITE
					*/
					--[E20240731-000845]_[공급 SCM PI팀] Business Plan 저장 관련 소스 수정 요청 (END)
					--------------------------------------------------------------------------------------------------

					/*SET @v_CELL_PER_PACK  = SUBSTRING(@p_CELL_PER , 0, @index_CELL_PER_PACK )
					SET @p_CELL_PER_PACK  = SUBSTRING(@p_CELL_PER_PACK , LEN(@v_CELL_PER_PACK  + '^') + 1, LEN(@p_CELL_PER_PACK ))

					SET @v_CELL_PER_MODULE  = SUBSTRING(@p_CELL_PER_MODULE , 0, @index_CELL_PER_MODULE )
					SET @p_CELL_PER_MODULE  = SUBSTRING(@p_CELL_PER_MODULE , LEN(@v_CELL_PER_MODULE  + '^') + 1, LEN(@p_CELL_PER_MODULE ))

					SET @v_MODULE_PER_PACK  = SUBSTRING(@p_MODULE_PER_PACK , 0, @index_MODULE_PER_PACK )
					SET @p_MODULE_PER_PACK  = SUBSTRING(@p_MODULE_PER_PACK , LEN(@v_MODULE_PER_PACK  + '^') + 1, LEN(@p_MODULE_PER_PACK ))*/			
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------
					SET @v_CREATED_BY  = SUBSTRING(@p_CREATED_BY , 0, @index_CREATED_BY )
					SET @p_CREATED_BY  = SUBSTRING(@p_CREATED_BY , LEN(@v_CREATED_BY  + '^') + 1, LEN(@p_CREATED_BY ))

					SET @v_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , 0, @index_LAST_UPDATED_BY )
					SET @p_LAST_UPDATED_BY  = SUBSTRING(@p_LAST_UPDATED_BY , LEN(@v_LAST_UPDATED_BY  + '^') + 1, LEN(@p_LAST_UPDATED_BY ))

					--------------------------------------------------------------------------------------------------
					-- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (START)	
					-- ITEM의 경우 중간의 공백이 없으므로 RTRM, LTRM으로 지워지지 않는 건들이 있고, 특수 문자가 안지워지는 건도 있어서 어떻게든 지우겠다는 의지
					SET @v_active_flag		= RTRIM(LTRIM(@v_active_flag))
					SET @v_DIVISION_ID		= RTRIM(LTRIM(@v_DIVISION_ID))
					SET @v_PROJECT_CODE		= RTRIM(LTRIM(@v_PROJECT_CODE))
					SET @v_PROJECT_NAME		= RTRIM(LTRIM(@v_PROJECT_NAME))
					SET @v_SCM_SITE_ID		= RTRIM(LTRIM(@v_SCM_SITE_ID))
					SET @v_PLANT_SITE_ID	= RTRIM(LTRIM(@v_PLANT_SITE_ID))
					--CHAR(13): Carriage return / CHAR(10): Line feed / CHAR(9): TAB 
					SET @v_ITEM_ID			= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_ITEM_ID)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
					SET @v_FCST_TYPE		= RTRIM(LTRIM(@v_FCST_TYPE))
					SET @v_INCOTERMS		= RTRIM(LTRIM(@v_INCOTERMS))
					SET @v_ITEM_USE			= RTRIM(LTRIM(@v_ITEM_USE))
					SET @v_UNIT_ENERGY		= RTRIM(LTRIM(@v_UNIT_ENERGY))
					SET @v_MEASURE			= RTRIM(LTRIM(@v_MEASURE))
					SET @v_YYYYMM			= RTRIM(LTRIM(@v_YYYYMM))
					SET @v_CURRENCY			= RTRIM(LTRIM(@v_CURRENCY))
					SET @v_QTY				= RTRIM(LTRIM(@v_QTY))
					SET @v_DEPT_ID			= RTRIM(LTRIM(@v_DEPT_ID))
					SET @v_END_CUSTOMER		= RTRIM(LTRIM(@v_END_CUSTOMER))
					SET @v_BIZ_TYPE			= RTRIM(LTRIM(@v_BIZ_TYPE))
					SET @v_CELL_PROD_SITE	= RTRIM(LTRIM(@v_CELL_PROD_SITE))
					SET @v_CREATED_BY		= RTRIM(LTRIM(@v_CREATED_BY	))
					SET @v_LAST_UPDATED_BY	= RTRIM(LTRIM(@v_LAST_UPDATED_BY))
					-- [E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리 (END)
					--------------------------------------------------------------------------------------------------

					INSERT INTO #TEMP_BP_FCST 
					( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
					, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)	
					, ITEM_USE, UNIT_ENERGY
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					, MEASURE, YYYYMM, CURRENCY, QTY
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					, DEPT_ID
					, END_CUSTOMER
					, BIZ_TYPE			
					, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------
					, CREATED_BY, LAST_UPDATED_BY ) 	
					VALUES 
					( @v_active_flag, @v_DIVISION_ID, @v_PROJECT_CODE, @v_PROJECT_NAME, @v_SCM_SITE_ID, @v_PLANT_SITE_ID ,@v_ITEM_ID--,@v_DOM_EXP
					, @v_FCST_TYPE, @v_INCOTERMS -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)			
					, @v_ITEM_USE, (CASE WHEN @v_UNIT_ENERGY = '' THEN CONVERT(NUMERIC(30,1),0) ELSE @v_UNIT_ENERGY END) 
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					, @v_MEASURE, @v_YYYYMM, @v_CURRENCY, @v_QTY
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_DEPT_ID END 
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_END_CUSTOMER END 
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_BIZ_TYPE END 
					, @v_CELL_PROD_SITE --,@v_CELL_PER_PACK--,@v_CELL_PER_MODULE--,@v_MODULE_PER_PACK		
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------				
					, @v_CREATED_BY, @v_LAST_UPDATED_BY )
				END
				-------------------------------------------
				ELSE
				-------------------------------------------
				BEGIN
					SET @v_DIVISION_ID = @p_DIVISION_ID
					SET @p_DIVISION_ID = NULL

					INSERT INTO #TEMP_BP_FCST 
					( active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
					, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)		
					, ITEM_USE, UNIT_ENERGY
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					, MEASURE, YYYYMM, CURRENCY, QTY
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					, DEPT_ID
					, END_CUSTOMER
					, BIZ_TYPE			
					, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------
					, CREATED_BY, LAST_UPDATED_BY )
					VALUES 
					( @v_active_flag, @v_DIVISION_ID, @v_PROJECT_CODE, @v_PROJECT_NAME, @v_SCM_SITE_ID, @v_PLANT_SITE_ID ,@v_ITEM_ID--,@v_DOM_EXP
					, @v_FCST_TYPE, @v_INCOTERMS -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)			
					, @v_ITEM_USE, (CASE WHEN @v_UNIT_ENERGY = '' THEN CONVERT(NUMERIC(30,1),0) ELSE @v_UNIT_ENERGY END)
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------
					, @v_MEASURE, @v_YYYYMM, @v_CURRENCY, @v_QTY
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_DEPT_ID END 
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_END_CUSTOMER END
					, CASE WHEN @v_DIVISION_ID = '40' THEN '' ELSE @v_BIZ_TYPE END 
					, @v_CELL_PROD_SITE --,@v_CELL_PER_PACK--,@v_CELL_PER_MODULE--,@v_MODULE_PER_PACK		
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------				
					, @v_CREATED_BY, @v_LAST_UPDATED_BY ) 
				END
		
			END			
			--==========================================================================================================================
			-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
			--==========================================================================================================================
			IF EXISTS ( SELECT * FROM #TEMP_BP_FCST R WHERE R.INCOTERMS IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1))
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	=  N'구코드 INCOTERMS는 저장할 수 없습니다.';		
				GOTO ERR_RTN
			END			
			--==========================================================================================================================
			-- [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
			--==========================================================================================================================
			--[E20260107-001542]_Validation 위치를 제일 상단으로 변경한다. (START)
			----------------------------------------------------------------------------------------------------------------------------
			-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START)
			IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE DIVISION_ID <> '40') > 0 -- 20180614 KHSOMG 40 DIVISION 조건 추가
			BEGIN
				IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) 
						WHERE ( SELECT COUNT(1) FROM SCM_MST_PROJECT WITH(NOLOCK)
								WHERE PROJECT_CODE = PROJECT_CODE ) = 0
						AND PROJECT_CODE <> 'N'  --20180423 SKH validation 조건에서 제외시킴
						AND DIVISION_ID <> '40'  -- 20180614 KHSOMG 40 DIVISION 조건 추가
					) > 0
				BEGIN
					SET @v_log_type = 'INVALID';
					SET @v_log_message = '['+ ( SELECT PROJECT_CODE FROM #TEMP_BP_FCST WITH(NOLOCK)
												WHERE PROJECT_CODE NOT IN (	SELECT PROJECT_CODE	FROM SCM_MST_PROJECT WITH(NOLOCK))
												) +']'+ N' Invalid Project Code !';
					SELECT @v_log_message
					GOTO ERR_RTN
				END
			END
			-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END)  
			----------------------------------------------------------------------------------------------------------------------------           
			----------------------------------------------------------------------------------------------------------------------------
			-- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (START) [c20200722-000060]
			IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE DIVISION_ID = '40') > 0
			BEGIN
				IF EXISTS (	SELECT * 
							FROM #TEMP_BP_FCST A WITH (NOLOCK)
							LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
											ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
							WHERE B.DIVISION_ID IS NULL	)
				BEGIN					
					SET @v_log_type = 'INVALID';
					SET @v_log_message = '['+ (	SELECT TOP 1 A.SCM_SITE_ID 
												FROM #TEMP_BP_FCST A WITH(NOLOCK)
												LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
																ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
												WHERE B.DIVISION_ID IS NULL
												) +']'+ N' Invalid Sales Site !';
					SELECT @v_log_message
					GOTO ERR_RTN
				END

			IF EXISTS (	SELECT * 
						FROM #TEMP_BP_FCST A WITH(NOLOCK)
						LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
									ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
						WHERE B.DIVISION_ID IS NULL	)
			BEGIN
				SET @v_log_type = 'INVALID';
				SET @v_log_message = '['+ (	SELECT TOP 1 RTRIM(A.SCM_SITE_ID) + N'/ ' + RTRIM(A.PROJECT_CODE) + N'/ ' + RTRIM(A.ITEM_ID)
											FROM #TEMP_BP_FCST A WITH(NOLOCK)
											LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
															ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
														AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
											WHERE B.DIVISION_ID IS NULL
											) +']'+ N' Invalid Sales Site/Project Code/Item !';
				SELECT @v_log_message
				GOTO ERR_RTN
			END
			END
			-- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (END) [c20200722-000060]
			--------------------------------------------------------------------------------------------------	
			--[E20260107-001542]_Validation 위치를 제일 상단으로 변경한다. (END)
PRINT @v_program_name + ' : A002-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 			
			--------------------------------------------------------------------------------------------------
			-- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (START)
			BEGIN
				--> SCM_MST_ITEM_SN 테이블을 TEMP로 넣는다.
				SELECT *
				INTO #TEMP_DM_MST_ITEM_SINGLE_ORI_V
				FROM SCM_MST_ITEM_SN WITH (NOLOCK)		
				WHERE DIVISION_ID = @p_division_id		
				AND	ACTIVE_FLAG = 'Y'	

				--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
				SELECT T1.DIVISION_ID, T1.ITEM_ID
					 , MAX(T1.ITEM_NAME)						AS ITEM_NAME
					 , MAX(T1.ITEM_CLASS)						AS ITEM_CLASS
					 , MAX(T1.ITEM_CLASS_NAME)					AS ITEM_CLASS_NAME
					 , MAX(T1.NICK_NAME)						AS NICK_NAME
					 , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1	
									  WHEN T1.ITEM_TYPE = 'H' THEN 2	
									  WHEN T1.ITEM_TYPE = 'Q' THEN 3
								 ELSE 4 END )  
												WHEN 1 THEN 'P' 
												WHEN 2 THEN 'H'
												WHEN 3 THEN 'Q'
												ELSE 'R' END	AS ITEM_TYPE
					 , MAX(T1.MATERIAL_CLASS_NAME)				AS MATERIAL_CLASS_NAME
					 , MAX(T1.ITEM_UOM)							AS ITEM_UOM
					 , MAX(T1.SPEC)								AS SPEC
					 , MAX(T1.MDM_PROJECT_NAME)					AS MDM_PROJECT_NAME
					 , MAX(T1.MIN_CAPACITY)						AS MIN_CAPACITY
					 , MAX(T1.ACTIVE_FLAG)						AS ACTIVE_FLAG
					 , MAX(T1.ENERGE)							AS ENERGE
					 , MAX(T1.CELL_QUANTITY)					AS CELL_QUANTITY
					 , MAX(T1.SCP_EXTRA_SPEC)					AS SCP_EXTRA_SPEC		
				INTO #TEMP_DM_MST_ITEM_SINGLE_A_V
				FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T1 WITH (NOLOCK)				
				WHERE 1=1
				GROUP BY T1.DIVISION_ID, T1.ITEM_ID
			
				--멈춤 현상이 발생하므로, 아예 모두 나눠서 INSERT 한다.
				SELECT DIVISION_ID
					 , LEFT(ITEM_ID, 12) AS ITEM_ID
					 , MAX(FORECAST_INFO_BIZ_TYPE) AS FORECAST_INFO_BIZ_TYPE
					 , MAX(FORECAST_INFO_PRODUCT_GROUP) AS FORECAST_INFO_PRODUCT_GROUP
					 , MAX(FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
					 , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
					 , MAX(FORECAST_INFO_SPEC) AS FORECAST_INFO_SPEC
					 , MAX(FORECAST_INFOR_VERSION) AS FORECAST_INFOR_VERSION
					 , MAX(CELL_TYPE) AS CELL_TYPE
				INTO #TEMP_DM_MST_ITEM_SINGLE_B_V
				FROM #TEMP_DM_MST_ITEM_SINGLE_ORI_V T2 WITH (NOLOCK) 
				GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)
			
				--TEMP 테이블에 넣은 데이터를 JOIN 한다.
				SELECT DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
					 , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
					 , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
					 , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 
				INTO #TEMP_DM_MST_ITEM_SINGLE_V
				FROM ( SELECT T1.DIVISION_ID, T1.ITEM_ID, T1.ITEM_NAME, T1.ITEM_CLASS, T1.ITEM_CLASS_NAME, T1.NICK_NAME, T1.ITEM_TYPE, T1.MATERIAL_CLASS_NAME
							, T1.ITEM_UOM, T1.SPEC, T1.MDM_PROJECT_NAME, T1.MIN_CAPACITY, T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
							, T2.FORECAST_INFO_CELL_MODEL, T2.FORECAST_INFO_CELL_PACK_COUNT, T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
							, T1.ACTIVE_FLAG, T2.CELL_TYPE, T1.ENERGE, T1.CELL_QUANTITY, T1.SCP_EXTRA_SPEC
					   FROM #TEMP_DM_MST_ITEM_SINGLE_A_V T1 WITH (NOLOCK)					
					   INNER JOIN #TEMP_DM_MST_ITEM_SINGLE_B_V T2 WITH (NOLOCK)	ON T1.DIVISION_ID = T2.DIVISION_ID AND SUBSTRING(T1.ITEM_ID,1,12) = T2.ITEM_ID
					   WHERE 1=1 ) T2						
				WHERE DIVISION_ID = @p_division_id					
				GROUP BY DIVISION_ID, ITEM_ID, ITEM_NAME, ITEM_CLASS, ITEM_CLASS_NAME, NICK_NAME, ITEM_TYPE, MATERIAL_CLASS_NAME
					   , ITEM_UOM, SPEC, MDM_PROJECT_NAME, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_PRODUCT_GROUP
					   , FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_SPEC, FORECAST_INFOR_VERSION
					   , ACTIVE_FLAG, CELL_TYPE, ENERGE, CELL_QUANTITY, SCP_EXTRA_SPEC 
			END
			-- [E20250522-001188]_속도 개선을 위해 DM_MST_ITEM_SINGLE_V를 TEMP로 생성함 (END)
			--------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A003-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			--======================================================
			--INPUT된 active_flag='D' 인것 삭제수행 (START)
			--======================================================
			BEGIN
				SELECT @n_del_count = COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE ACTIVE_FLAG = 'D';
				
				DELETE
				FROM DM_PLN_BP_FCST
				WHERE ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK)
						WHERE 1=1
						AND ACTIVE_FLAG  = 'D'
						AND DM_PLN_BP_FCST.DIVISION_ID		= DIVISION_ID
						AND DM_PLN_BP_FCST.PROJECT_CODE		= PROJECT_CODE
						--AND DM_PLN_BP_FCST.PROJECT_NAME	= PROJECT_NAME
						AND DM_PLN_BP_FCST.SCM_SITE_ID      = SCM_SITE_ID
						AND DM_PLN_BP_FCST.PLANT_SITE_ID    = PLANT_SITE_ID
						AND DM_PLN_BP_FCST.ITEM_ID          = ITEM_ID
						AND DM_PLN_BP_FCST.CELL_PROD_SITE   = CELL_PROD_SITE
						AND DM_PLN_BP_FCST.FCST_TYPE		= FCST_TYPE
						AND DM_PLN_BP_FCST.INCOTERMS        = INCOTERMS -- [PJ20200138] Incoterms 삭제
						--------------------------------------------------------------------------------------------------
						-- [PJ20200138] item_use, unit_energy 추가 (START)			
						AND DM_PLN_BP_FCST.ITEM_USE         = ITEM_USE
						AND DM_PLN_BP_FCST.UNIT_ENERGY      = UNIT_ENERGY
						-- [PJ20200138] item_use, unit_energy 추가 (END)
						--------------------------------------------------------------------------------------------------
						AND DM_PLN_BP_FCST.MEASURE          = MEASURE
						AND DM_PLN_BP_FCST.YYYYMM           = YYYYMM
						--------------------------------------------------------------------------------------------------
						-- 20190830 추가 (START)
						AND DM_PLN_BP_FCST.DEPT_ID          = DEPT_ID
						AND DM_PLN_BP_FCST.END_CUSTOMER     = END_CUSTOMER
						AND DM_PLN_BP_FCST.BIZ_TYPE         = BIZ_TYPE
						AND DM_PLN_BP_FCST.CURRENCY         = CURRENCY
						-- 20190830 추가 (END)
						--------------------------------------------------------------------------------------------------	
						) > 0;

				--------------------------------------------------------------------------------------------------	
				-- 삭제완료건 TEMP TABLE에서 제거
				--------------------------------------------------------------------------------------------------	
				DELETE FROM #TEMP_BP_FCST WHERE ACTIVE_FLAG  = 'D'
			END
PRINT @v_program_name + ' : A004-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			--======================================================
			--INPUT된 active_flag='D' 인것 삭제수행 (END)
			--======================================================			
			--======================================================
			-- 2021.7.23 키 업데이트용으로 들어온 데이터 처리 (START)
			--======================================================
			BEGIN
				IF EXISTS ( SELECT * 
							FROM DM_PLN_BP_FCST A WITH(NOLOCK)
							JOIN (	SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
										, CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
									FROM #TEMP_BP_FCST WITH(NOLOCK)
									WHERE MEASURE = 'Business_Plan'
									GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
											, CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
									) B  ON A.DIVISION_ID		= B.DIVISION_ID
										AND A.PROJECT_CODE		= B.PROJECT_CODE
										AND A.SCM_SITE_ID		= B.SCM_SITE_ID
										AND A.ITEM_ID			= B.ITEM_ID
										AND A.DEPT_ID			= B.DEPT_ID
										AND A.END_CUSTOMER		= B.END_CUSTOMER
										AND A.BIZ_TYPE			= B.BIZ_TYPE
										AND A.CURRENCY			= B.CURRENCY
										AND A.ITEM_USE			= B.ITEM_USE
										AND A.UNIT_ENERGY		= B.UNIT_ENERGY
										AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE
							WHERE A.FCST_TYPE = '' OR A.INCOTERMS = ''
							--OR A.DOM_EXP = ''								
							--AND  A.PLANT_SITE_ID	= B.PLANT_SITE_ID
							--AND  A.FCST_TYPE		= B.FCST_TYPE
							--AND  A.DOM_EXP			= B.DOM_EXP
							--AND  A.INCOTERMS		= B.INCOTERMS
						 ) AND @v_DIVISION_ID = '40'
				BEGIN
					UPDATE A
					SET FCST_TYPE = B.FCST_TYPE
						--, DOM_EXP = B.DOM_EXP
						, INCOTERMS = B.INCOTERMS
					FROM DM_PLN_BP_FCST A
					JOIN ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
								, CURRENCY, ITEM_USE, UNIT_ENERGY, MAX(FCST_TYPE) AS FCST_TYPE--, MAX(DOM_EXP) AS DOM_EXP
								, MAX(INCOTERMS) AS INCOTERMS, CELL_PROD_SITE
							FROM #TEMP_BP_FCST WITH(NOLOCK)
							WHERE MEASURE = 'Business_Plan'
							GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DEPT_ID, END_CUSTOMER, BIZ_TYPE
								   , CURRENCY, ITEM_USE, UNIT_ENERGY, CELL_PROD_SITE
						 ) B ON A.DIVISION_ID		= B.DIVISION_ID
							AND A.PROJECT_CODE		= B.PROJECT_CODE
							AND A.SCM_SITE_ID		= B.SCM_SITE_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.DEPT_ID			= B.DEPT_ID
							AND A.END_CUSTOMER		= B.END_CUSTOMER
							AND A.BIZ_TYPE			= B.BIZ_TYPE
							AND A.CURRENCY			= B.CURRENCY
							AND A.ITEM_USE			= B.ITEM_USE
							AND A.UNIT_ENERGY		= B.UNIT_ENERGY
							AND A.CELL_PROD_SITE	= B.CELL_PROD_SITE
					GOTO END_PKUPDATE
				END
			END			
PRINT @v_program_name + ' : A005-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			--======================================================
			-- INPUT된 Business_Plan MEASURE INSERT (START)
			--======================================================
			-- INSERT 전 중복값 삭제
			BEGIN
				DELETE A
				FROM DM_PLN_BP_FCST A
				JOIN #TEMP_BP_FCST B WITH(NOLOCK)
				  ON A.DIVISION_ID		= B.DIVISION_ID
				 AND A.PROJECT_CODE     = B.PROJECT_CODE
				 AND A.SCM_SITE_ID      = B.SCM_SITE_ID
				 AND A.PLANT_SITE_ID    = B.PLANT_SITE_ID
				 AND A.ITEM_ID          = B.ITEM_ID
				 AND A.CELL_PROD_SITE   = B.CELL_PROD_SITE
				 AND A.FCST_TYPE        = B.FCST_TYPE
				 AND A.ITEM_USE         = B.ITEM_USE
				 AND A.UNIT_ENERGY      = B.UNIT_ENERGY
				 AND A.MEASURE          = B.MEASURE
				 AND A.YYYYMM           = B.YYYYMM
				 AND A.DEPT_ID          = B.DEPT_ID
				 AND A.END_CUSTOMER     = B.END_CUSTOMER
				 AND A.BIZ_TYPE         = B.BIZ_TYPE
				 AND A.CURRENCY         = B.CURRENCY
				 AND A.INCOTERMS        = B.INCOTERMS         
				WHERE A.MEASURE IN ( 'Business_Plan', 'LOC', 'CAR_QTY', 'MKT_FCST' )
			END
PRINT @v_program_name + ' : A006-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			BEGIN			
				INSERT INTO DM_PLN_BP_FCST
				( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
				, MEASURE, DOM_EXP, FCST_TYPE		
				--------------------------------------------------------------------------------------------------
				-- [PJ20200138] item_use, unit_energy 추가 (START)			
				, ITEM_USE, UNIT_ENERGY 
				-- [PJ20200138] item_use, unit_energy 추가 (END)
				--------------------------------------------------------------------------------------------------
				, CELL_PROD_SITE, INCOTERMS, QTY-- [PJ20200138] Incoterms 삭제
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE 
				--------------------------------------------------------------------------------------------------
				-- 20190830 추가 (START)
				, DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK  
				-- 20190830 추가 (END)
				--------------------------------------------------------------------------------------------------	
				)
				SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
					 , MEASURE, '' AS DOM_EXP, FCST_TYPE
					 --------------------------------------------------------------------------------------------------
					 -- [PJ20200138] item_use, unit_energy 추가 (START)	
					 , ITEM_USE, UNIT_ENERGY 
					 -- [PJ20200138] item_use, unit_energy 추가 (END)
					 --------------------------------------------------------------------------------------------------
					 , CELL_PROD_SITE, INCOTERMS, QTY -- [PJ20200138] Incoterms 삭제
					 , CREATED_BY, GETDATE(), LAST_UPDATED_BY, GETDATE()
					 --------------------------------------------------------------------------------------------------
					 -- 20190830 추가 (START)
					 , DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK 
					 -- 20190830 추가 (END)
					 --------------------------------------------------------------------------------------------------	
				FROM #TEMP_BP_FCST WITH(NOLOCK)
				WHERE MEASURE IN ( 'Business_Plan', 'MKT_FCST', 'LOC' )
		
				--------------------------------------------------------------------------------------------------
				-- 20190830 81사업부 CAR_QTY 저장
				--------------------------------------------------------------------------------------------------
				INSERT INTO #TEMP_BP_FCST
				( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMM, CURRENCY
				, MEASURE, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
				--------------------------------------------------------------------------------------------------
				-- [PJ20200138] item_use, unit_energy 추가 (START)			
				, ITEM_USE, UNIT_ENERGY 	
				-- [PJ20200138] item_use, unit_energy 추가 (END)
				--------------------------------------------------------------------------------------------------
				, CELL_PROD_SITE
				, QTY
				, CREATED_BY, LAST_UPDATED_BY
				--------------------------------------------------------------------------------------------------
				-- 20190830 추가 (START)
				, DEPT_ID, END_CUSTOMER, BIZ_TYPE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
				-- 20190830 추가 (END)
				--------------------------------------------------------------------------------------------------	
				)
				SELECT F.DIVISION_ID, F.PROJECT_CODE, F.PROJECT_NAME, F.SCM_SITE_ID, F.PLANT_SITE_ID, F.ITEM_ID, F.YYYYMM, F.CURRENCY
						, 'CAR_QTY' AS MEASURE, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
						--------------------------------------------------------------------------------------------------
						-- [PJ20200138] item_use, unit_energy 추가 (START)			
						, ITEM_USE, ISNULL(CONVERT(NUMERIC,UNIT_ENERGY),0)
						-- [PJ20200138] item_use, unit_energy 추가 (END)
						--------------------------------------------------------------------------------------------------
						, CELL_PROD_SITE
						/*,CASE WHEN BIZ_TYPE = 'CELL' THEN ISNULL(CONVERT(NUMERIC,QTY),0) / CASE WHEN CONVERT(NUMERIC,CELL_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
							WHEN BIZ_TYPE = 'MODULE' THEN ISNULL(CONVERT(NUMERIC,QTY),0) / CASE WHEN CONVERT(NUMERIC,MODULE_PER_PACK) = 0 THEN 1 END  -- 20190906 ZERO값 발생하는 오류로 CASE문 추가
							WHEN BIZ_TYPE = 'PACK' THEN QTY
						END AS QTY			   */
						, CASE  WHEN CHARINDEX('Cell',   I.ITEM_CLASS_NAME) > 0  AND ISNULL(SI.CELL_PER_CAR, 0) > 0   THEN ISNULL(CONVERT(NUMERIC,F.QTY),0) /CASE WHEN SI.CELL_PER_CAR = 0 THEN 1 ELSE SI.CELL_PER_CAR END
								WHEN CHARINDEX('Module', I.ITEM_CLASS_NAME) > 0  AND ISNULL(SI.CELL_PER_CAR/SI.CELL_PER_MODULE, 0) > 0 THEN ISNULL(CONVERT(NUMERIC,F.QTY),0) /CASE WHEN SI.CELL_PER_CAR/SI.CELL_PER_MODULE = 0 THEN 1 ELSE SI.CELL_PER_CAR/SI.CELL_PER_MODULE END
								WHEN CHARINDEX('Pack' , I.ITEM_CLASS_NAME) > 0  THEN ISNULL(CONVERT(NUMERIC,F.QTY),0)
								ELSE 0 
						  END AS QTY
						, F.CREATED_BY, F.LAST_UPDATED_BY
						--------------------------------------------------------------------------------------------------
						-- 20190830 추가 (START)
						, DEPT_ID, END_CUSTOMER, BIZ_TYPE --,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
						-- 20190830 추가 (END)
						--------------------------------------------------------------------------------------------------	
				FROM #TEMP_BP_FCST F WITH(NOLOCK)
				--------------------------------------------------------------------------------------------------	
				-- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (START)
				--LEFT JOIN DM_MST_ITEM_SINGLE_V I WITH (NOLOCK)
				LEFT JOIN #TEMP_DM_MST_ITEM_SINGLE_V I WITH (NOLOCK)
				-- [E20250522-001188]_DM_MST_ITEM_SINGLE_V 대신 TEMP로 생성한 테이블을 사용 원소스 주석처리 (END)
				--------------------------------------------------------------------------------------------------	
					   ON F.DIVISION_ID		= I.DIVISION_ID
					  AND F.ITEM_ID			= I.ITEM_ID
				LEFT JOIN SCM_MST_SITE_ITEM SI WITH (NOLOCK)
					   ON F.DIVISION_ID		= SI.DIVISION_ID
					  AND F.PROJECT_CODE	= SI.PROJECT_CODE
					  AND F.SCM_SITE_ID		= SI.SCM_SITE_ID
					  AND F.ITEM_ID			= SI.ITEM_ID
				WHERE MEASURE = 'Business_Plan'
				AND F.DIVISION_ID = '81'
				AND SI.VALID_YN	= 'Y' 
			END
			--======================================================
			-- INPUT된 Business_Plan MEASURE INSERT (END)
			--======================================================
PRINT @v_program_name + ' : A007-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			--======================================================
			-- FUTURE PRICE 계산 Procedure 호출 (START)
			--======================================================
			-- TEMP TABLE 을 전달함 #TEMP_BP_FCST
			BEGIN
				EXEC DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CONV @s_flag='CALL', @s_division_id=''
			END			
			--======================================================
			-- FUTURE PRICE 계산 Procedure 호출 (END)
			--======================================================
			
PRINT @v_program_name + ' : A008-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			--======================================================
			--#TEMP_BP_FCST 테이블에 split후 INSERT (END)
			--======================================================
			BEGIN			
				--[E20260107-001542]_Validation 위치를 제일 상단으로 변경한다.원소스 주석처리(START)
				/*
				--------------------------------------------------------------------------------------------------	
				-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (START)
				IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE DIVISION_ID <> '40') > 0 -- 20180614 KHSOMG 40 DIVISION 조건 추가
				BEGIN
					IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) 
						 WHERE ( SELECT COUNT(1) FROM SCM_MST_PROJECT WITH(NOLOCK)
								 WHERE PROJECT_CODE = PROJECT_CODE ) = 0
						 AND PROJECT_CODE <> 'N'  --20180423 SKH validation 조건에서 제외시킴
						 AND DIVISION_ID <> '40'  -- 20180614 KHSOMG 40 DIVISION 조건 추가
						) > 0
					BEGIN
						SET @v_log_type = 'INVALID';
						SET @v_log_message = '['+ ( SELECT PROJECT_CODE FROM #TEMP_BP_FCST WITH(NOLOCK)
													WHERE PROJECT_CODE NOT IN (	SELECT PROJECT_CODE	FROM SCM_MST_PROJECT WITH(NOLOCK))
												   ) +']'+ N' Invalid Project Code !';
						SELECT @v_log_message
						GOTO ERR_RTN
					END
				END
				-- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 (END)  
				--------------------------------------------------------------------------------------------------
           
				--------------------------------------------------------------------------------------------------	
				-- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (START) [c20200722-000060]
				IF ( SELECT COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE DIVISION_ID = '40') > 0
				BEGIN
					IF EXISTS (	SELECT * 
								FROM #TEMP_BP_FCST A WITH (NOLOCK)
								LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
											 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
								WHERE B.DIVISION_ID IS NULL	)
					BEGIN					
						SET @v_log_type = 'INVALID';
						SET @v_log_message = '['+ (	SELECT TOP 1 A.SCM_SITE_ID 
													FROM #TEMP_BP_FCST A WITH(NOLOCK)
													LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
																 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.VALID_YN = 'Y'
													WHERE B.DIVISION_ID IS NULL
												   ) +']'+ N' Invalid Sales Site !';
						SELECT @v_log_message
						GOTO ERR_RTN
					END

					IF EXISTS (	SELECT * 
								FROM #TEMP_BP_FCST A WITH(NOLOCK)
								LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
											ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
								WHERE B.DIVISION_ID IS NULL	)
					BEGIN
						SET @v_log_type = 'INVALID';
						SET @v_log_message = '['+ (	SELECT TOP 1 RTRIM(A.SCM_SITE_ID) + N'/ ' + RTRIM(A.PROJECT_CODE) + N'/ ' + RTRIM(A.ITEM_ID)
													FROM #TEMP_BP_FCST A WITH(NOLOCK)
													LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
																 ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID 
																AND A.PROJECT_CODE = B.PROJECT_CODE AND A.ITEM_ID = B.ITEM_ID AND B.VALID_YN = 'Y'
													WHERE B.DIVISION_ID IS NULL
												   ) +']'+ N' Invalid Sales Site/Project Code/Item !';
						SELECT @v_log_message
						GOTO ERR_RTN
					END
				END
				-- SITE/SITE ITEM 잘못들어왔을때 강제 에러발생시킴 (END) [c20200722-000060]
				--------------------------------------------------------------------------------------------------	
				*/
				--[E20260107-001542]_Validation 위치를 제일 상단으로 변경한다. 원소스 주석처리(END)
				BEGIN
					--======================================================
					-- LOC INSERT (START)
					--======================================================
					INSERT INTO #TEMP_BP_FCST
					SELECT active_flag, TMP.DIVISION_ID, TMP.PROJECT_CODE, TMP.PROJECT_NAME, TMP.SCM_SITE_ID, TMP.PLANT_SITE_ID, TMP.ITEM_ID--,TMP.DOM_EXP
						 , TMP.FCST_TYPE, TMP.INCOTERMS -- [PJ20200138] Incoterms 삭제
						 --------------------------------------------------------------------------------------------------
						 -- [PJ20200138] item_use, unit_energy 추가 (START)			
						 , TMP.ITEM_USE, TMP.UNIT_ENERGY
						 -- [PJ20200138] item_use, unit_energy 추가 (END)
						 --------------------------------------------------------------------------------------------------
						 , 'SalesAmt_LOC' AS MEASURE, TMP.YYYYMM, TMP.CURRENCY, ISNULL(FCST.QTY * TMP.QTY,0) 
						 --( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH (NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
						 --  AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
						 AS QTY
						 --, ( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
						 --			  ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN ISNULL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH (NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
						 --																		  AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
						 --				   ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW','USD') THEN ISNULL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH (NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
						 --																							AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
						 --						END
						 --				   END
						 --			  END )
						 --------------------------------------------------------------------------------------------------
						 -- 20190830 추가 (START)
						 , TMP.DEPT_ID, TMP.END_CUSTOMER, TMP.BIZ_TYPE, TMP.CELL_PROD_SITE
						 -- 20190830 추가 (END)
						 --------------------------------------------------------------------------------------------------	
						 , TMP.CREATED_BY, TMP.LAST_UPDATED_BY
					FROM #TEMP_BP_FCST TMP
					INNER JOIN DM_PLN_BP_FCST FCST WITH(NOLOCK)
							ON TMP.DIVISION_ID		= FCST.DIVISION_ID
						   AND TMP.PROJECT_CODE		= FCST.PROJECT_CODE
						   --------------------------------------------------------------------------------------------------
						   -- 20200106 KHSONG 수정 (START)
						   --AND TMP.PROJECT_NAME			= FCST.PROJECT_NAME  -- 주석처리
						   AND TMP.SCM_SITE_ID		= FCST.SCM_SITE_ID  -- ADDED
						   -- 20200106 KHSONG 수정 (END)
						   --------------------------------------------------------------------------------------------------
						   AND TMP.PLANT_SITE_ID	= FCST.PLANT_SITE_ID
						   AND TMP.ITEM_ID			= FCST.ITEM_ID
						   AND TMP.CELL_PROD_SITE	= FCST.CELL_PROD_SITE
						   AND TMP.FCST_TYPE		= FCST.FCST_TYPE
						   AND TMP.INCOTERMS		= FCST.INCOTERMS -- [PJ20200138] Incoterms 삭제
						   AND TMP.YYYYMM			= FCST.YYYYMM
						   AND TMP.CURRENCY			= FCST.CURRENCY
						   AND FCST.MEASURE	IN ( 'Business_Plan', 'MKT_FCST' )
						   --------------------------------------------------------------------------------------------------
						   -- 20190830 추가 (START)
						   AND TMP.DEPT_ID            = FCST.DEPT_ID
						   AND TMP.END_CUSTOMER       = FCST.END_CUSTOMER
						   AND TMP.BIZ_TYPE           = FCST.BIZ_TYPE
						   -- 20190830 추가 (END)
						   --------------------------------------------------------------------------------------------------
						   --------------------------------------------------------------------------------------------------
						   -- [PJ20200138] item_use, unit_energy 추가 (START)		
						   AND TMP.ITEM_USE           = FCST.ITEM_USE
						   AND TMP.UNIT_ENERGY        = FCST.UNIT_ENERGY
						   -- [PJ20200138] item_use, unit_energy 추가 (END)
						   --------------------------------------------------------------------------------------------------	
					WHERE 1=1
					AND TMP.MEASURE = 'LOC'
					--======================================================
					-- LOC INSERT (END)
					--======================================================
					--======================================================
					-- KRW INSERT (START)
					--======================================================
					INSERT INTO #TEMP_BP_FCST
					SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
						 , FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
						 --------------------------------------------------------------------------------------------------
						 -- [PJ20200138] item_use, unit_energy 추가 (START)		
						 , ITEM_USE, UNIT_ENERGY
						 -- [PJ20200138] item_use, unit_energy 추가 (END)
						 --------------------------------------------------------------------------------------------------	
						 , 'SalesAmt_KRW' AS MEASURE, YYYYMM, CURRENCY
						 , ISNULL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN TMP.QTY
										   ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN ISNULL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH(NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
																									   AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
												ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') THEN ISNULL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH(NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
																														  AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
													 END
												END
										   END),0)
						 --------------------------------------------------------------------------------------------------
						 -- 20190830 추가 (START)
						 , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
						 -- 20190830 추가 (END)
						 --------------------------------------------------------------------------------------------------
						 , CREATED_BY, LAST_UPDATED_BY
					FROM #TEMP_BP_FCST TMP WITH(NOLOCK)
					WHERE TMP.MEASURE = 'SalesAmt_LOC'
					--======================================================
					-- KRW INSERT (END)
					--======================================================
					--======================================================
					-- USD INSERT (START)
					--======================================================
					-- 20190906
					INSERT INTO #TEMP_BP_FCST
					SELECT active_flag, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
						 , FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
						 --------------------------------------------------------------------------------------------------
						 -- [PJ20200138] item_use, unit_energy 추가 (START)		
						 , ITEM_USE, UNIT_ENERGY
						 -- [PJ20200138] item_use, unit_energy 추가 (END)
						 --------------------------------------------------------------------------------------------------	
						 , 'SalesAmt_USD' AS MEASURE, YYYYMM, CURRENCY
						 , QTY = ISNULL(( SELECT CASE WHEN TMP.CURRENCY = 'KRW' THEN ISNULL(TMP.QTY / ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH (NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
																										AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE),0)
												 ELSE CASE WHEN TMP.CURRENCY = 'USD' THEN TMP.QTY
													  ELSE CASE WHEN TMP.CURRENCY NOT IN ('KRW', 'USD') -- KRW산출후 / USD
																THEN ISNULL(TMP.QTY * ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH(NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
																						AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = TMP.CURRENCY GROUP BY EXCHANGE_PRICE),0)
																						/ ( SELECT EXCHANGE_PRICE FROM DM_BP_EXCHANGE_RATE WITH(NOLOCK) WHERE DIVISION_ID = TMP.DIVISION_ID
																							AND YYYYMMDD = SUBSTRING(TMP.YYYYMM, 1, 6) + '01' AND UNIT_CURRENCY = 'USD' GROUP BY EXCHANGE_PRICE)
														   END
													  END
												 END),0)
						 --------------------------------------------------------------------------------------------------
						 -- 20190830 추가 (START)
						 , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE
						 -- 20190830 추가 (END)
						 --------------------------------------------------------------------------------------------------
						 , CREATED_BY, LAST_UPDATED_BY
					FROM #TEMP_BP_FCST TMP WITH (NOLOCK)
					WHERE TMP.MEASURE = 'SalesAmt_LOC'
				END
PRINT @v_program_name + ' : A008-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 

				BEGIN
					( SELECT @n_insert_count = COUNT(1) FROM #TEMP_BP_FCST WITH(NOLOCK) WHERE MEASURE = 'SalesAmt_LOC')
				END

				BEGIN
					INSERT INTO #TMP_DM_PLN_BP_FCST_X
					( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
					, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
					--------------------------------------------------------------------------------------------------
					-- [PJ20200138] item_use, unit_energy 추가 (START)			
					, ITEM_USE, UNIT_ENERGY
					-- [PJ20200138] item_use, unit_energy 추가 (END)
					--------------------------------------------------------------------------------------------------	
					, MEASURE, YYYYMM, CURRENCY, QTY
					--------------------------------------------------------------------------------------------------
					-- 20190830 추가 (START)
					, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
					-- 20190830 추가 (END)
					--------------------------------------------------------------------------------------------------
					, CREATED_BY, LAST_UPDATED_BY )
					SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
						 , FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
						 --------------------------------------------------------------------------------------------------
						 -- [PJ20200138] item_use, unit_energy 추가 (START)			
						 , ITEM_USE, UNIT_ENERGY
						 -- [PJ20200138] item_use, unit_energy 추가 (END)
						 --------------------------------------------------------------------------------------------------	
						 , MEASURE, YYYYMM, CURRENCY, ISNULL(QTY,0) 
						 --------------------------------------------------------------------------------------------------
						 -- 20190830 추가 (START)
						 , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
						 -- 20190830 추가 (END)
						 --------------------------------------------------------------------------------------------------
						 , CREATED_BY, LAST_UPDATED_BY
					FROM #TEMP_BP_FCST WITH(NOLOCK)  
					WHERE 1=1

					-------------------------------------------------------------------
					/* [2018-03-19][CURSOR를 이용해 HISTORY TABLE ADD
						방법1 : PROCEDURE CALL
						방법2 : 바로입력
					*/
					-------------------------------------------------------------------
					-- 커서를 이용해 DIVISION_ID 만큼 LOOP
					DECLARE SAVE_DM_PLN_BP_FCST_CUR CURSOR FAST_FORWARD FOR
					
					SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID--,DOM_EXP
							, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
							--------------------------------------------------------------------------------------------------
							-- [PJ20200138] item_use, unit_energy 추가 (START)			
							, ITEM_USE, UNIT_ENERGY
							-- [PJ20200138] item_use, unit_energy 추가 (END)
							--------------------------------------------------------------------------------------------------	
							, MEASURE, YYYYMM, CURRENCY, QTY
							--------------------------------------------------------------------------------------------------
							-- 20190830 추가 (START)
							, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
							-- 20190830 추가 (END)
							--------------------------------------------------------------------------------------------------
							, CREATED_BY, LAST_UPDATED_BY
					FROM #TEMP_BP_FCST WITH(NOLOCK)
					WHERE 1=1

					OPEN SAVE_DM_PLN_BP_FCST_CUR
					FETCH NEXT FROM SAVE_DM_PLN_BP_FCST_CUR INTO @v_DIVISION_ID, @v_PROJECT_CODE, @v_PROJECT_NAME, @v_SCM_SITE_ID, @v_PLANT_SITE_ID, @v_ITEM_ID--,@v_DOM_EXP
											, @v_FCST_TYPE, @v_INCOTERMS -- [PJ20200138] Incoterms 삭제
											--------------------------------------------------------------------------------------------------
											-- [PJ20200138] item_use, unit_energy 추가 (START)			
											, @v_ITEM_USE, @v_UNIT_ENERGY
											-- [PJ20200138] item_use, unit_energy 추가 (END)
											--------------------------------------------------------------------------------------------------	
											, @v_MEASURE, @v_YYYYMM, @v_CURRENCY, @v_QTY
											--------------------------------------------------------------------------------------------------
											-- 20190830 추가 (START)
											, @v_DEPT_ID, @v_END_CUSTOMER, @v_BIZ_TYPE, @v_CELL_PROD_SITE--,@v_CELL_PER_PACK--,@v_CELL_PER_MODULE--,@v_MODULE_PER_PACK		
											-- 20190830 추가 (END)
											--------------------------------------------------------------------------------------------------
											, @v_CREATED_BY, @v_LAST_UPDATED_BY

					WHILE @@FETCH_STATUS = 0
					BEGIN
						SET @n_history_seq = NEXT VALUE FOR SEQ1_DM_PLN_BP_FCST_H		
							--======================================================
							-- HISTORY INSERT (START)
							--======================================================
							 INSERT INTO DM_PLN_BP_FCST_H
							( HISTORY_SEQ, ACTIVE_FLAG, DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
							--------------------------------------------------------------------------------------------------
							-- [PJ20200138] item_use, unit_energy 추가 (START)			
							, ITEM_USE, UNIT_ENERGY 
							-- [PJ20200138] item_use, unit_energy 추가 (END)
							--------------------------------------------------------------------------------------------------
							, INCOTERMS, MEASURE, YYYYMM, CURRENCY, QTY -- [PJ20200138] Incoterms 삭제
 							, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
							--------------------------------------------------------------------------------------------------
							-- 20190830 추가 (START)
							, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK,CELL_PER_MODULE,MODULE_PER_PACK
							-- 20190830 추가 (END)
							--------------------------------------------------------------------------------------------------
							)
							VALUES
							( @n_history_seq, @v_active_flag, @v_DIVISION_ID, @v_PROJECT_CODE, @v_PROJECT_NAME, @v_SCM_SITE_ID, @v_PLANT_SITE_ID, @v_ITEM_ID, '', @v_FCST_TYPE
							--------------------------------------------------------------------------------------------------
							-- [PJ20200138] item_use, unit_energy 추가 (START)			
							, @v_ITEM_USE, @v_UNIT_ENERGY 
							-- [PJ20200138] item_use, unit_energy 추가 (END)
							--------------------------------------------------------------------------------------------------
							, @v_INCOTERMS, @v_MEASURE, @v_YYYYMM, @v_CURRENCY, ISNULL(@v_QTY,0) -- [PJ20200138] Incoterms 삭제
							, @v_CREATED_BY, GETDATE(), @v_LAST_UPDATED_BY, GETDATE()
							--------------------------------------------------------------------------------------------------
							-- 20190830 추가 (START)
							, @v_DEPT_ID, @v_END_CUSTOMER, @v_BIZ_TYPE, @v_CELL_PROD_SITE--,@v_CELL_PER_PACK,@v_CELL_PER_MODULE,@v_MODULE_PER_PACK
							-- 20190830 추가 (END)
							--------------------------------------------------------------------------------------------------
							);	
							--======================================================
							-- HISTORY INSERT (END)
							--======================================================

							FETCH NEXT FROM SAVE_DM_PLN_BP_FCST_CUR INTO @v_DIVISION_ID, @v_PROJECT_CODE, @v_PROJECT_NAME, @v_SCM_SITE_ID, @v_PLANT_SITE_ID, @v_ITEM_ID--,@v_DOM_EXP
																	   , @v_FCST_TYPE, @v_INCOTERMS -- [PJ20200138] Incoterms 삭제
																	   --------------------------------------------------------------------------------------------------
																	   -- [PJ20200138] item_use, unit_energy 추가 (START)			
																	   , @v_ITEM_USE, @v_UNIT_ENERGY 
																	   -- [PJ20200138] item_use, unit_energy 추가 (END)
																	   --------------------------------------------------------------------------------------------------
																	   , @v_MEASURE, @v_YYYYMM, @v_CURRENCY, @v_QTY
																	   --------------------------------------------------------------------------------------------------
																	   -- 20190830 추가 (START)
																	   , @v_DEPT_ID, @v_END_CUSTOMER, @v_BIZ_TYPE, @v_CELL_PROD_SITE--,@v_CELL_PER_PACK--,@v_CELL_PER_MODULE--,@v_MODULE_PER_PACK
																	   -- 20190830 추가 (END)
																	   --------------------------------------------------------------------------------------------------
																	   , @v_CREATED_BY, @v_LAST_UPDATED_BY
					END

					CLOSE SAVE_DM_PLN_BP_FCST_CUR
					DEALLOCATE SAVE_DM_PLN_BP_FCST_CUR
				END
				--======================================================
				-- INPUT된 Business_Plan MEASURE INSERT (END)
				--======================================================
			END
PRINT @v_program_name + ' : A009-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 

			--======================================================
			-- DELETE (START)
			--======================================================
            BEGIN
				DELETE
				FROM DM_PLN_BP_FCST
				WHERE ( SELECT COUNT(1) FROM #TMP_DM_PLN_BP_FCST_X WITH(NOLOCK)
						WHERE 1=1
						AND DM_PLN_BP_FCST.DIVISION_ID		= DIVISION_ID
						AND DM_PLN_BP_FCST.PROJECT_CODE		= PROJECT_CODE
						--AND DM_PLN_BP_FCST.PROJECT_NAME	= PROJECT_NAME
						AND DM_PLN_BP_FCST.SCM_SITE_ID		= SCM_SITE_ID
						AND DM_PLN_BP_FCST.PLANT_SITE_ID	= PLANT_SITE_ID
						AND DM_PLN_BP_FCST.ITEM_ID			= ITEM_ID
						AND DM_PLN_BP_FCST.CELL_PROD_SITE	= CELL_PROD_SITE
						AND DM_PLN_BP_FCST.FCST_TYPE		= FCST_TYPE
						AND DM_PLN_BP_FCST.INCOTERMS		= INCOTERMS -- [PJ20200138] Incoterms 삭제
						--------------------------------------------------------------------------------------------------
						-- [PJ20200138] item_use, unit_energy 추가 (START)		
						AND DM_PLN_BP_FCST.ITEM_USE			= ITEM_USE
						AND DM_PLN_BP_FCST.UNIT_ENERGY		= UNIT_ENERGY	
						-- [PJ20200138] item_use, unit_energy 추가 (END)
						--------------------------------------------------------------------------------------------------
						AND DM_PLN_BP_FCST.MEASURE			= MEASURE
						AND DM_PLN_BP_FCST.YYYYMM			= YYYYMM
						--------------------------------------------------------------------------------------------------
						-- 20190830 추가 (START)
						AND DM_PLN_BP_FCST.DEPT_ID			= DEPT_ID
						AND DM_PLN_BP_FCST.END_CUSTOMER		= END_CUSTOMER
						AND DM_PLN_BP_FCST.BIZ_TYPE			= BIZ_TYPE
						-- 20190830 추가 (END)
						--------------------------------------------------------------------------------------------------																  
						AND DM_PLN_BP_FCST.CURRENCY			= CURRENCY  -- 20190916 KHSONG ADDED
						) > 0;
            END
			--======================================================
			-- DELETE (END)
			--======================================================
			
PRINT @v_program_name + ' : A010-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
			INSERT INTO DM_PLN_BP_FCST
			( DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, DOM_EXP ,FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
			--------------------------------------------------------------------------------------------------
			-- [PJ20200138] item_use, unit_energy 추가 (START)		
			, ITEM_USE, UNIT_ENERGY
			-- [PJ20200138] item_use, unit_energy 추가 (END)
			--------------------------------------------------------------------------------------------------
			, MEASURE, YYYYMM, CURRENCY, QTY
			--------------------------------------------------------------------------------------------------
			-- 20190830 추가 (START)
			, DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK
			-- 20190830 추가 (END)
			--------------------------------------------------------------------------------------------------				
			, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			SELECT DIVISION_ID, PROJECT_CODE, PROJECT_NAME, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, '' AS DOM_EXP, FCST_TYPE, INCOTERMS -- [PJ20200138] Incoterms 삭제
				 --------------------------------------------------------------------------------------------------
				 -- [PJ20200138] item_use, unit_energy 추가 (START)		
				 , ITEM_USE, UNIT_ENERGY
				 -- [PJ20200138] item_use, unit_energy 추가 (END)
				 --------------------------------------------------------------------------------------------------
				 , MEASURE ,YYYYMM, CURRENCY, QTY
				 --------------------------------------------------------------------------------------------------
				 -- 20190830 추가 (START)
				 , DEPT_ID, END_CUSTOMER, BIZ_TYPE, CELL_PROD_SITE--,CELL_PER_PACK--,CELL_PER_MODULE--,MODULE_PER_PACK		
				 -- 20190830 추가 (END)
				 --------------------------------------------------------------------------------------------------			
				 , CREATED_BY, GETDATE(), LAST_UPDATED_BY, GETDATE()
			FROM #TMP_DM_PLN_BP_FCST_X WITH(NOLOCK) 
			WHERE 1=1

			-- PK UPDATE 를 위해서 들어온경우 UPDATE 처리 후 바로 빠짐
			END_PKUPDATE:
			
PRINT @v_program_name + ' : A011-- :' + CONVERT(VARCHAR(30), GETDATE(), 121); 
		--======================================================
		-- 트랜잭션 (COMMIT)
		--======================================================
        COMMIT WORK;
		--------------------------------------------------------------------------------------------
        END TRY
	--------------------------------------------------------------------------------------------	
	BEGIN CATCH
	--------------------------------------------------------------------------------------------	
		-- ROLLBACK
		--======================================================
		-- 트랜잭션 (END)
		--======================================================
		ROLLBACK TRANSACTION SAVE_DM_PLN_BP_FCST;
		-- ERROR LOG VALUE SAVE
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	--------------------------------------------------------------------------------------------	
	END CATCH;
	--------------------------------------------------------------------------------------------	
	
	-- 수행결과 성공여부 DISPLAY
	IF @v_log_message IS NULL
	SELECT 'success';
	
	--======================================================
    -- 종료 LOG (START)
	--======================================================
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
	--======================================================
    -- INVALID 로그 (START)
	--======================================================
    ERR_RTN:
    IF @v_log_type = 'INVALID'
    BEGIN
        ROLLBACK TRANSACTION;
        SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) +  ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
		SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
		--======================================================
		-- 종료 LOG (START)
		--======================================================
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = 'delete_count= ' + Convert(NVARCHAR(10), @n_del_count) + ' / insert_count= ' + Convert(NVARCHAR(10), @n_insert_count)  ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		--======================================================
		-- 종료 LOG (END)
		--======================================================
	END
	--======================================================
    -- INVALID 로그 (END)
	--======================================================