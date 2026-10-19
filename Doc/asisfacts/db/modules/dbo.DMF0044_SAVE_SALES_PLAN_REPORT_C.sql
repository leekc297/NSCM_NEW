
/*===============================================================================================================================
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===============================================================================================================================
 *   Date       In Charge   Description
 *===============================================================================================================================
 * 2019-05-29	KHSONG		Initial Release [PJ20189106] 전지.GSCM 고도화 이행, DM 시스템
 * 2019-0-719	JSYOUN		사업계획리포트테이블 변경(DM_PLN_BP_FCST_C -> DM_PLN_BP_FCST_REPORT_C)
 * 2019-08-22	JSYOUN		DM_PLN_SALES_PLAN_REPORT_C PK에서 DIVISION_ID 제외 CURRENCY 추가, DM_PLN_BP_FCST_REPORT_C PK에 CURRENCY 추가
 * 2019-10-30	KYH			Attribute1 에 ProductDetails 를 '기타'로 세팅
 * 2020-01-23	hwi1993		company_id 추가
 * 2020-02-06	hwi1993		cutoff_yyyymmdd 보완
 * 2020-03-19	hwi1993		DeptName, DepartmentName 의 룩업화에 따라 JOIN 조건에서 사용하지 않도록 변경
 * 2020-05-22	hwi1993		Save 이후에 Transfer 처리
 * 2020-09-09   P.C.I		[C20200909-000203] LOG 표준화 적용
 * 2022-01-24	rosia27		[C20211112-000213]GSCM의 Cell Model 컬럼 관련 요청의 건
 * 2023-09-07	jssbae		[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 
 * 2026-02-03	JSSBAE		[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선   
 ===============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0044_SAVE_SALES_PLAN_REPORT_C]
	-- Add the parameters for the stored procedure here
	  @p_active_flag		    NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_version_no				NVARCHAR(MAX)
	, @p_cutoff_type			NVARCHAR(MAX)
	, @p_cutoff_yyyymmdd		NVARCHAR(MAX)
	, @p_department_id			NVARCHAR(MAX)
	, @p_department_name		NVARCHAR(MAX)
	, @p_dept_id				NVARCHAR(MAX)
	, @p_dept_name				NVARCHAR(MAX)
	, @p_end_cust_report		NVARCHAR(MAX)
	, @p_cust_report			NVARCHAR(MAX)
	, @p_product_group			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_measure				NVARCHAR(MAX)
	, @p_yyyymmdd				NVARCHAR(MAX)
	, @p_currency				NVARCHAR(MAX)
	, @p_company_id				NVARCHAR(MAX)
	, @p_qty					NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_cell_model_info		NVARCHAR(MAX)  --[C20211112-000213]
	, @p_cell_model				NVARCHAR(MAX)   --[C20211112-000213]

/*
''고정
PROJECT_CODE
SCM_SITE_ID
DOM_EXP
FCST_TYPE
INCOTERMS
PLANT_SITE_ID
*/

AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	--==========================================================================================
	-- 스플릿관련 변수
	--==========================================================================================
    DECLARE	@v_active_flag			NVARCHAR(MAX);
    DECLARE	@v_division_id			NVARCHAR(MAX);
    DECLARE	@v_version_no			NVARCHAR(MAX);
    DECLARE	@v_cutoff_type			NVARCHAR(MAX);
    DECLARE	@v_cutoff_yyyymmdd		NVARCHAR(MAX);
    DECLARE	@v_department_id		NVARCHAR(MAX);
    DECLARE	@v_department_name		NVARCHAR(MAX);
    DECLARE	@v_dept_id				NVARCHAR(MAX);
    DECLARE	@v_dept_name			NVARCHAR(MAX);
    DECLARE	@v_end_cust_report		NVARCHAR(MAX);
    DECLARE	@v_cust_report			NVARCHAR(MAX);
    DECLARE	@v_product_group		NVARCHAR(MAX);
    DECLARE	@v_item_id				NVARCHAR(MAX);
    DECLARE	@v_measure				NVARCHAR(MAX);
    DECLARE	@v_yyyymmdd				NVARCHAR(MAX);
    DECLARE	@v_currency				NVARCHAR(MAX);
    DECLARE	@v_company_id			NVARCHAR(MAX);
    DECLARE	@v_qty					NVARCHAR(MAX);
    DECLARE	@v_created_by			NVARCHAR(MAX);
	DECLARE	@v_cell_model_info		NVARCHAR(MAX);  --[C20211112-000213]
	DECLARE	@v_cell_model			NVARCHAR(MAX);  --[C20211112-000213]

	DECLARE	@v_delimiter			NVARCHAR(1)
	SET		@v_delimiter = '^'  -- 데이터 구분자
	DECLARE @max_loop_cnt			INTEGER = 0; 
	DECLARE @mst_loop_cnt			INTEGER = 0;
	
	--==========================================================================================
	-- LOG 용 변수 설정
	--==========================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0044_SAVE_SALES_PLAN_REPORT_C';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_log_description		NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
    DECLARE @n_delete_count			INTEGER = 0;
    DECLARE @n_insert_count			INTEGER = 0;
    DECLARE @n_input_count			INTEGER = 0;
    DECLARE @n_logo_count			INTEGER = 0;
	
	--==========================================================================================
	-- 마지막 데이터 처리를 위한 구분자 추가
	--==========================================================================================
	SET @p_active_flag				= RTRIM(@p_active_flag		) + '^';
	SET @p_division_id				= RTRIM(@p_division_id		) + '^';
	SET @p_version_no				= RTRIM(@p_version_no		) + '^';
	SET @p_cutoff_type				= RTRIM(@p_cutoff_type		) + '^';
	SET @p_cutoff_yyyymmdd			= RTRIM(@p_cutoff_yyyymmdd	) + '^';
	SET @p_department_id			= RTRIM(@p_department_id	) + '^';
	SET @p_department_name			= RTRIM(@p_department_name	) + '^';
	SET @p_dept_id					= RTRIM(@p_dept_id			) + '^';
	SET @p_dept_name				= RTRIM(@p_dept_name		) + '^';
	SET @p_end_cust_report			= RTRIM(@p_end_cust_report	) + '^';
	SET @p_cust_report				= RTRIM(@p_cust_report		) + '^';
	SET @p_product_group			= RTRIM(@p_product_group	) + '^';
	SET @p_item_id					= RTRIM(@p_item_id			) + '^';
	SET @p_measure					= RTRIM(@p_measure			) + '^';
	SET @p_yyyymmdd					= RTRIM(@p_yyyymmdd			) + '^';
	SET @p_currency					= RTRIM(@p_currency			) + '^';
	SET @p_company_id				= RTRIM(@p_company_id		) + '^';
	SET @p_qty						= RTRIM(@p_qty				) + '^'; 
	SET @p_created_by				= RTRIM(@p_created_by		) + '^';
	SET @p_cell_model_info			= RTRIM(@p_cell_model_info	) + '^';  --[C20211112-000213]
	SET @p_cell_model				= RTRIM(@p_cell_model		) + '^';  --[C20211112-000213]
	
	--==========================================================================================
	-- #results_MST TEMP TABLE
	--==========================================================================================
	CREATE TABLE #results_MST  
	( active_flag			NVARCHAR(MAX)
	, division_id			NVARCHAR(MAX)
	, version_no			NVARCHAR(MAX)
	, cutoff_type			NVARCHAR(MAX)
	, cutoff_yyyymmdd		NVARCHAR(MAX)
	, department_id			NVARCHAR(MAX)
	, department_name		NVARCHAR(MAX)
	, dept_id				NVARCHAR(MAX)
	, dept_name				NVARCHAR(MAX)
	, end_cust_report		NVARCHAR(MAX)
	, cust_report			NVARCHAR(MAX)
	, product_group			NVARCHAR(MAX)	  
	, project_code			NVARCHAR(MAX)
	, scm_site_id			NVARCHAR(MAX)
	, dom_exp				NVARCHAR(MAX)
	, fcst_type				NVARCHAR(MAX)
	, incoterms				NVARCHAR(MAX)
	, cell_model_info		NVARCHAR(MAX)
	, cell_model			NVARCHAR(MAX)	  
	, item_id				NVARCHAR(MAX)
	, measure				NVARCHAR(MAX)
	, yyyymmdd				NVARCHAR(MAX)
	, currency				NVARCHAR(MAX)
	, company_id			NVARCHAR(MAX)
	, qty					NVARCHAR(MAX)
	, created_by			NVARCHAR(MAX))
	
	--==========================================================================================
	-- 시작 LOG  (START)
	--==========================================================================================
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
	--==========================================================================================
	-- 시작 LOG  (END)
	--==========================================================================================

	-- 트랜잭션 (START)
	BEGIN TRANSACTION DM_PLN_SALES_PLAN_REPORT_C;
	BEGIN TRY
	
	--==========================================================================================
	-- #results_MST 테이블에 split후 insert (start)
	--###############################################  #results_MST 테이블에 split후 insert (START)
	WHILE LEN(@p_division_id) > 0
	BEGIN
		DECLARE @index_active_flag		INT
		DECLARE @index_division_id		INT
		DECLARE @index_version_no		INT
		DECLARE @index_cutoff_type		INT
		DECLARE @index_cutoff_yyyymmdd	INT
		DECLARE @index_department_id	INT
		DECLARE @index_department_name	INT
		DECLARE @index_dept_id			INT
		DECLARE @index_dept_name		INT
		DECLARE @index_end_cust_report	INT
		DECLARE @index_cust_report		INT
		DECLARE @index_product_group	INT
		DECLARE @index_item_id			INT
		DECLARE @index_measure			INT
		DECLARE @index_yyyymmdd			INT
		DECLARE @index_currency			INT
		DECLARE @index_company_id		INT
		DECLARE @index_qty				INT
		DECLARE @index_created_by		INT
		DECLARE @index_cell_model_info	INT
		DECLARE @index_cell_model		INT

		SET @index_active_flag			= PATINDEX('%' + '^' + '%', @p_active_flag			)
		SET @index_division_id			= PATINDEX('%' + '^' + '%', @p_division_id			)
		SET @index_version_no			= PATINDEX('%' + '^' + '%', @p_version_no			)
		SET @index_cutoff_type			= PATINDEX('%' + '^' + '%', @p_cutoff_type			)
		SET @index_cutoff_yyyymmdd		= PATINDEX('%' + '^' + '%', @p_cutoff_yyyymmdd		)
		SET @index_department_id		= PATINDEX('%' + '^' + '%', @p_department_id		)
		SET @index_department_name		= PATINDEX('%' + '^' + '%', @p_department_name		)
		SET @index_dept_id				= PATINDEX('%' + '^' + '%', @p_dept_id				)
		SET @index_dept_name			= PATINDEX('%' + '^' + '%', @p_dept_name			)
		SET @index_end_cust_report		= PATINDEX('%' + '^' + '%', @p_end_cust_report		)
		SET @index_cust_report			= PATINDEX('%' + '^' + '%', @p_cust_report			)
		SET @index_product_group		= PATINDEX('%' + '^' + '%', @p_product_group		)
		SET @index_item_id				= PATINDEX('%' + '^' + '%', @p_item_id				)
		SET @index_measure				= PATINDEX('%' + '^' + '%', @p_measure				)
		SET @index_yyyymmdd				= PATINDEX('%' + '^' + '%', @p_yyyymmdd				)
		SET @index_currency				= PATINDEX('%' + '^' + '%', @p_currency				)
		SET @index_company_id			= PATINDEX('%' + '^' + '%', @p_company_id			)
		SET @index_qty					= PATINDEX('%' + '^' + '%', @p_qty					)
		SET @index_created_by			= PATINDEX('%' + '^' + '%', @p_created_by			)
		SET @index_cell_model_info		= PATINDEX('%' + '^' + '%', @p_cell_model_info		)
		SET @index_cell_model			= PATINDEX('%' + '^' + '%', @p_cell_model			)
		
		IF LEN(@p_division_id) > 0
		BEGIN
			set @v_active_flag				= substring(@p_active_flag			, 0, @index_active_flag			)
			set @v_division_id				= substring(@p_division_id			, 0, @index_division_id			)
			set @v_version_no				= substring(@p_version_no			, 0, @index_version_no			)
			set @v_cutoff_type				= substring(@p_cutoff_type			, 0, @index_cutoff_type			)
			set @v_cutoff_yyyymmdd			= substring(@p_cutoff_yyyymmdd		, 0, @index_cutoff_yyyymmdd		)
			set @v_department_id			= substring(@p_department_id		, 0, @index_department_id		)
			set @v_department_name			= substring(@p_department_name		, 0, @index_department_name		)
			set @v_dept_id					= substring(@p_dept_id				, 0, @index_dept_id				)
			set @v_dept_name				= substring(@p_dept_name			, 0, @index_dept_name			)
			set @v_end_cust_report			= substring(@p_end_cust_report		, 0, @index_end_cust_report		)
			set @v_cust_report				= substring(@p_cust_report			, 0, @index_cust_report			)
			set @v_product_group			= substring(@p_product_group		, 0, @index_product_group		)
			set @v_item_id					= substring(@p_item_id				, 0, @index_item_id				)
			set @v_measure					= substring(@p_measure				, 0, @index_measure				)
			set @v_yyyymmdd					= substring(@p_yyyymmdd				, 0, @index_yyyymmdd			)
			set @v_currency					= substring(@p_currency				, 0, @index_currency			)
			set @v_company_id				= substring(@p_company_id			, 0, @index_company_id			)
			set @v_qty						= substring(@p_qty					, 0, @index_qty					)
			set @v_created_by				= substring(@p_created_by			, 0, @index_created_by			)
			set @v_cell_model_info			= substring(@p_cell_model_info		, 0, @index_cell_model_info		)
			set @v_cell_model				= substring(@p_cell_model			, 0, @index_cell_model			)

			set @p_active_flag				 = substring(@p_active_flag			, len(@v_active_flag		+ '^') + 1, len(@p_active_flag		))
			set @p_division_id				 = substring(@p_division_id			, len(@v_division_id		+ '^') + 1, len(@p_division_id		))
			set @p_version_no				 = substring(@p_version_no			, len(@v_version_no			+ '^') + 1, len(@p_version_no		))
			set @p_cutoff_type				 = substring(@p_cutoff_type			, len(@v_cutoff_type		+ '^') + 1, len(@p_cutoff_type		))
			set @p_cutoff_yyyymmdd			 = substring(@p_cutoff_yyyymmdd		, len(@v_cutoff_yyyymmdd	+ '^') + 1, len(@p_cutoff_yyyymmdd	))
			set @p_department_id			 = substring(@p_department_id		, len(@v_department_id		+ '^') + 1, len(@p_department_id	))
			set @p_department_name			 = substring(@p_department_name		, len(@v_department_name	+ '^') + 1, len(@p_department_name	))
			set @p_dept_id					 = substring(@p_dept_id				, len(@v_dept_id			+ '^') + 1, len(@p_dept_id			))
			set @p_dept_name				 = substring(@p_dept_name			, len(@v_dept_name			+ '^') + 1, len(@p_dept_name		))
			set @p_end_cust_report			 = substring(@p_end_cust_report		, len(@v_end_cust_report	+ '^') + 1, len(@p_end_cust_report	))
			set @p_cust_report				 = substring(@p_cust_report			, len(@v_cust_report		+ '^') + 1, len(@p_cust_report		))
			set @p_product_group			 = substring(@p_product_group		, len(@v_product_group		+ '^') + 1, len(@p_product_group	))
			set @p_item_id					 = substring(@p_item_id				, len(@v_item_id			+ '^') + 1, len(@p_item_id			))
			set @p_measure					 = substring(@p_measure				, len(@v_measure			+ '^') + 1, len(@p_measure			))
			set @p_yyyymmdd					 = substring(@p_yyyymmdd			, len(@v_yyyymmdd			+ '^') + 1, len(@p_yyyymmdd			))
			set @p_currency					 = substring(@p_currency			, len(@v_currency			+ '^') + 1, len(@p_currency			))
			set @p_company_id				 = substring(@p_company_id			, len(@v_company_id			+ '^') + 1, len(@p_company_id		))
			set @p_qty						 = substring(@p_qty					, len(@v_qty				+ '^') + 1, len(@p_qty				))
			set @p_created_by				 = substring(@p_created_by			, len(@v_created_by			+ '^') + 1, len(@p_created_by		))
			set @p_cell_model_info			 = substring(@p_cell_model_info		, len(@v_cell_model_info	+ '^') + 1, len(@p_cell_model_info	))
			set @p_cell_model				 = substring(@p_cell_model			, len(@v_cell_model			+ '^') + 1, len(@p_cell_model		))

			--공백제거
			set @v_active_flag						= rtrim(ltrim(@v_active_flag		))
			set @v_division_id						= rtrim(ltrim(@v_division_id		))
			set @v_version_no						= rtrim(ltrim(@v_version_no			))
			set @v_cutoff_type						= rtrim(ltrim(@v_cutoff_type		))
			set @v_cutoff_yyyymmdd					= rtrim(ltrim(@v_cutoff_yyyymmdd	))
			set @v_department_id					= rtrim(ltrim(@v_department_id		))
			set @v_department_name					= rtrim(ltrim(@v_department_name	))
			set @v_dept_id							= rtrim(ltrim(@v_dept_id			))
			set @v_dept_name						= rtrim(ltrim(@v_dept_name			))
			set @v_end_cust_report					= rtrim(ltrim(@v_end_cust_report	))
			set @v_cust_report						= rtrim(ltrim(@v_cust_report		))
			set @v_product_group					= rtrim(ltrim(@v_product_group		))
			set @v_item_id							= rtrim(ltrim(@v_item_id			))
			set @v_measure							= rtrim(ltrim(@v_measure			))
			set @v_yyyymmdd							= rtrim(ltrim(@v_yyyymmdd			))
			set @v_currency							= rtrim(ltrim(@v_currency			))
			set @v_company_id						= rtrim(ltrim(@v_company_id			))
			set @v_qty								= rtrim(ltrim(@v_qty				))
			set @v_created_by						= rtrim(ltrim(@v_created_by			))
			set @v_cell_model_info					= rtrim(ltrim(@v_cell_model_info	))
			set @v_cell_model						= rtrim(ltrim(@v_cell_model			))


			if @v_qty = ''
				set @v_qty = '0'

			--------------------------------------------------------------------------------------------
			-- 공백제거	
			--------------------------------------------------------------------------------------------			
			SELECT @v_cutoff_yyyymmdd = B.YYYYMMDD 
			FROM DM_MDF_VERSION A
			JOIN DM_MST_VERSION B ON A.DIVISION_ID = B.DIVISION_ID AND A.ORI_VERSION_NO = B.VERSION_NO
			WHERE A.VERSION_NO = @v_version_no
			AND A.division_id = @v_division_id
				
			--------------------------------------------------------------------------------------------
			-- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
			--------------------------------------------------------------------------------------------
			SET @v_yyyymmdd = (select MIN(basis_start_date) from [dbo].[SCM_SYS_CALENDAR_M] with(nolock) where substring(basis_yyyymmdd,1,6) = substring(@v_yyyymmdd,1,6) and DAYOFWEEK in ('MON','TUE','WED','THU','FRI'))

			INSERT INTO #results_MST 
			( active_flag, division_id, version_no, cutoff_type, cutoff_yyyymmdd	
			, department_id, department_name, dept_id, dept_name, end_cust_report	
			, cust_report, product_group, project_code, scm_site_id, dom_exp		
			, fcst_type, incoterms, cell_model_info, cell_model, item_id			
			, measure, yyyymmdd, currency, company_id, qty				
			, created_by ) 
			VALUES 
			( @v_active_flag, @v_division_id, @v_version_no, @v_cutoff_type, @v_cutoff_yyyymmdd	
			, @v_department_id, @v_department_name, @v_dept_id, @v_dept_name, @v_end_cust_report	
			, @v_cust_report, @v_product_group, '' /*project_code*/, '' /*scm_site_id*/, '' /*dom_exp*/			
			, '' /*fcst_type*/, '' /*incoterms*/, @v_cell_model_info, @v_cell_model, @v_item_id			
			, @v_measure, @v_yyyymmdd, @v_currency, @v_company_id, @v_qty				
			, @v_created_by )

		END
		ELSE
		BEGIN
			--SET @v_active_flag = @p_active_flag
			--SET @p_active_flag = NULL
			-------------------------------------------------------------------------------------------- 
			--공백제거
			-------------------------------------------------------------------------------------------- 
			SET @v_active_flag						= rtrim(ltrim(@v_active_flag		))
			SET @v_division_id						= rtrim(ltrim(@v_division_id		))
			SET @v_version_no						= rtrim(ltrim(@v_version_no			))
			SET @v_cutoff_type						= rtrim(ltrim(@v_cutoff_type		))
			SET @v_cutoff_yyyymmdd					= rtrim(ltrim(@v_cutoff_yyyymmdd	))
			SET @v_department_id					= rtrim(ltrim(@v_department_id		))
			SET @v_department_name					= rtrim(ltrim(@v_department_name	))
			SET @v_dept_id							= rtrim(ltrim(@v_dept_id			))
			SET @v_dept_name						= rtrim(ltrim(@v_dept_name			))
			SET @v_end_cust_report					= rtrim(ltrim(@v_end_cust_report	))
			SET @v_cust_report						= rtrim(ltrim(@v_cust_report		))
			SET @v_product_group					= rtrim(ltrim(@v_product_group		))
			SET @v_item_id							= rtrim(ltrim(@v_item_id			))
			SET @v_measure							= rtrim(ltrim(@v_measure			))
			SET @v_yyyymmdd							= rtrim(ltrim(@v_yyyymmdd			))
			SET @v_currency							= rtrim(ltrim(@v_currency			))
			SET @v_company_id						= rtrim(ltrim(@v_company_id			))
			SET @v_qty								= rtrim(ltrim(@v_qty				))
			SET @v_created_by						= rtrim(ltrim(@v_created_by			))
			SET @v_cell_model_info					= rtrim(ltrim(@v_cell_model_info	))
			SET @v_cell_model						= rtrim(ltrim(@v_cell_model			))

			IF @v_qty = ''
				SET @v_qty = '0'

			--------------------------------------------------------------------------------------------
			--공백제거
			--------------------------------------------------------------------------------------------			
			--------------------------------------------------------------------------------------------
			-- yyyymm 값을 월별 첫 영업일(yyyymmdd)로 변환
			--------------------------------------------------------------------------------------------
			SET @v_yyyymmdd = (SELECT MIN(BASIS_START_DATE) FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE SUBSTRING(BASIS_YYYYMMDD, 1, 6) = SUBSTRING(@v_yyyymmdd, 1, 6) AND DAYOFWEEK IN ('MON','TUE','WED','THU','FRI'))

			INSERT INTO #results_MST 
			( active_flag, division_id, version_no, cutoff_type, cutoff_yyyymmdd	
			, department_id, department_name, dept_id, dept_name, end_cust_report	
			, cust_report, product_group, project_code, scm_site_id, dom_exp		
			, fcst_type, incoterms, cell_model_info, cell_model, item_id			
			, measure, yyyymmdd, currency, company_id, qty				
			, created_by ) 
			VALUES 
			( @v_active_flag, @v_division_id, @v_version_no, @v_cutoff_type, @v_cutoff_yyyymmdd	
			, @v_department_id, @v_department_name, @v_dept_id, @v_dept_name, @v_end_cust_report	
			, @v_cust_report, @v_product_group, ''	/*project_code*/, '' /*scm_site_id*/, '' /*dom_exp*/
			, '' /*fcst_type*/, '' /*incoterms*/, @v_cell_model_info, @v_cell_model, @v_item_id			
			, @v_measure, @v_yyyymmdd, @v_currency, @v_company_id, @v_qty				
			, @v_created_by	)
		END
	END
	
	--==========================================================================================
	--[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선 (START)  
	--==========================================================================================
	IF EXISTS ( SELECT * FROM #results_MST R WHERE R.company_id IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'COMPANY_ID' GROUP BY OLD_VALUE1))
	BEGIN
		SET @v_log_type		= 'INVALID';
		SET @v_log_description	=  N'구코드 COMPANY_ID는 저장할 수 없습니다.';		
		GOTO ERR_RTN
	END			
	--==========================================================================================
	--[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선 (END)  
	--==========================================================================================	
	--==========================================================================================
	-- #results_MST 테이블에 split후 insert (end	)
	--==========================================================================================
	-- INPUT COUNT 확인
	SET @n_input_count = ( SELECT COUNT(active_flag) FROM #results_MST)

	IF @v_cutoff_type = 'REPORT_SP_W'
	--------------------------------------------------------------------------------------------◇◇◇◇
	--  DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN	
		--------------------------------------------------------------------------------------------
		-- DELETE COUNT 확인
		--------------------------------------------------------------------------------------------
		SET @n_delete_count = ( SELECT COUNT(DIVISION_ID) FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								WHERE (	SELECT COUNT(1) FROM #results_MST M	WHERE M.active_flag	= 'D') > 0)


		DELETE A
		  FROM DM_PLN_SALES_PLAN_REPORT_C A
		  JOIN #results_MST B ON A.VERSION_NO				= B.VERSION_NO
							 AND A.DIVISION_ID				= B.DIVISION_ID
							 AND A.DEPARTMENT_ID			= B.DEPARTMENT_ID
							 --AND A.DEPARTMENT_NAME		= B.DEPARTMENT_NAME
							 AND A.DEPT_ID					= B.DEPT_ID
							 --AND A.DEPT_NAME				= B.DEPT_NAME
							 AND A.END_CUST_REPORT			= B.END_CUST_REPORT
							 AND A.CUST_REPORT				= B.CUST_REPORT
							 AND A.PRODUCT_GROUP			= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE				= B.PROJECT_CODE
							 AND A.SCM_SITE_ID				= B.SCM_SITE_ID
							 AND A.ITEM_ID					= B.ITEM_ID
							 AND A.MEASURE					= B.MEASURE
							 AND A.YYYYMMDD					= B.YYYYMMDD
							 AND A.CURRENCY					= B.CURRENCY
							 AND A.COMPANY_ID				= B.COMPANY_ID
							 AND A.FORECAST_INFO_CELL_MODEL  = B.CELL_MODEL_INFO
							 AND A.ATTRIBUTE3				= B.CELL_MODEL
		WHERE B.ACTIVE_FLAG = 'D'
		  AND A.DATA_TYPE = '2'

--select @@Rowcount	
		--DELETE 
		--FROM [dbo].DM_PLN_SALES_PLAN_REPORT_C
		--WHERE (
		--		SELECT count(1) 
		--			FROM #results_MST M
		--			where M.active_flag		= 'D'
		--				and DATA_TYPE = '2'
		--				--and DM_PLN_SALES_PLAN_REPORT_C.division_id		= M.division_id		--20190822
		--				and DM_PLN_SALES_PLAN_REPORT_C.version_no		= M.version_no			
		--				and DM_PLN_SALES_PLAN_REPORT_C.department_id	= M.department_id		
		--				and DM_PLN_SALES_PLAN_REPORT_C.department_name	= M.department_name	
		--				and DM_PLN_SALES_PLAN_REPORT_C.dept_id			= M.dept_id			
		--				and DM_PLN_SALES_PLAN_REPORT_C.dept_name		= M.dept_name			
		--				and DM_PLN_SALES_PLAN_REPORT_C.end_cust_report	= M.end_cust_report	
		--				and DM_PLN_SALES_PLAN_REPORT_C.cust_report		= M.cust_report		
		--				and DM_PLN_SALES_PLAN_REPORT_C.product_group	= M.product_group		

		--				and ISNULL(DM_PLN_SALES_PLAN_REPORT_C.project_code	,'')	= M.project_code		
		--				and ISNULL(DM_PLN_SALES_PLAN_REPORT_C.scm_site_id	,'')	= M.scm_site_id		
		--				and ISNULL(DM_PLN_SALES_PLAN_REPORT_C.dom_exp		,'')	= M.dom_exp		
		--				and ISNULL(DM_PLN_SALES_PLAN_REPORT_C.fcst_type		,'')	= M.fcst_type		
		--				and ISNULL(DM_PLN_SALES_PLAN_REPORT_C.incoterms		,'')	= M.incoterms		

		--				and DM_PLN_SALES_PLAN_REPORT_C.item_id			= M.item_id			
		--				and DM_PLN_SALES_PLAN_REPORT_C.currency			= M.currency			-- 20190822
		--				and DM_PLN_SALES_PLAN_REPORT_C.COMPANY_ID		= M.company_id			-- 20200123
		--				and DM_PLN_SALES_PLAN_REPORT_C.measure			= M.measure		
		--				--and DM_PLN_SALES_PLAN_REPORT_C.yyyymmdd			= M.yyyymmdd	
		--		) > 0;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                          DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇

		--------------------------------------------------------------------------------------------◇◇◇◇
		-- DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (START)
		--------------------------------------------------------------------------------------------◇◇◇◇
		-- INSERT COUNT 확인
		SET @n_insert_count = ( SELECT COUNT(M.division_id) FROM #results_MST M WHERE M.active_flag <> 'D' )
					
		MERGE INTO DM_PLN_SALES_PLAN_REPORT_C A
		USING (	SELECT * FROM #results_MST M WHERE M.active_flag <> 'D'	) B
		   ON (	A.division_id					= B.division_id			
		  AND	A.version_no					= B.version_no		
		  AND	A.department_id					= B.department_id			
		  --AND	  A.department_name				= B.department_name		
		  AND	A.dept_id						= B.dept_id				
		  --AND	  A.dept_name					= B.dept_name				
		  AND	A.end_cust_report				= B.end_cust_report		
		  AND	A.cust_report					= B.cust_report			
		  AND	A.product_group					= B.product_group			
		  AND	ISNULL(A.project_code	,'')	= B.project_code			
		  AND	ISNULL(A.scm_site_id	,'')	= B.scm_site_id			
		  AND	ISNULL(A.dom_exp		,'')	= B.dom_exp				
		  AND	ISNULL(A.fcst_type		,'')	= B.fcst_type				
		  AND	ISNULL(A.incoterms		,'')	= B.incoterms				
		  AND	ISNULL(A.FORECAST_INFO_CELL_MODEL,'')		= B.CELL_MODEL_INFO
		  AND	ISNULL(A.ATTRIBUTE3		,'')	 = B.CELL_MODEL
		  AND	A.item_id						 = B.item_id				
		  AND	A.currency						 = B.currency			-- 20190822	
		  AND	A.company_id					 = B.company_id			-- 20200123
		  AND	A.measure						 = B.measure				
		  AND	A.yyyymmdd						 = B.yyyymmdd				
		  AND	A.DATA_TYPE = '2' )
		WHEN MATCHED THEN
		UPDATE SET 
			A.QTY				= B.QTY		
		  , A.last_updated_by	= B.created_by
		  , A.last_update_date	= GETDATE()					                
		WHEN NOT MATCHED THEN
		INSERT ( -- VER_SEQ
		  DATA_TYPE, division_id, version_no, cutoff_type, cutoff_yyyymmdd	
		, department_id, department_name, dept_id, dept_name, end_cust_report	
		, cust_report, product_group, project_code, scm_site_id, dom_exp	
		, fcst_type, incoterms, plant_site_id, item_id, measure	
		, yyyymmdd, currency, company_id, qty, created_by	
		, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2
		, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, FORECAST_INFO_CELL_MODEL )
		VALUES 
		( '2', B.division_id, B.version_no, B.cutoff_type, B.cutoff_yyyymmdd	
		 , B.department_id, B.department_name, B.dept_id, B.dept_name, B.end_cust_report	
		 , B.cust_report, B.product_group, '' /*project_code*/, '' /*scm_site_id*/, '' /*dom_exp*/
		 , '' /*fcst_type*/, '' /*incoterms*/, '' /*plant_site_id*/, B.item_id, B.measure
		 , B.yyyymmdd, B.currency, B.company_id, B.qty, B.CREATED_BY
		 , GETDATE(), B.CREATED_BY, GETDATE(), N'기타', ''
		 , B.CELL_MODEL, NULL, NULL, B.CELL_MODEL_INFO );

	END
		--------------------------------------------------------------------------------------------◇◇◇◇
		-- DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
		--------------------------------------------------------------------------------------------◇◇◇◇
		--ELSE
	--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 20230907 
	BEGIN
		UPDATE A
		SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT
			, A.FORECAST_INFO_BIZ_TYPE = LOOKA.BIZ_TYPE
		FROM DM_PLN_SALES_PLAN_REPORT_C A
		INNER JOIN ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK, A.DIVISION_ID
					   FROM ( SELECT SEGMENT2 AS MODEL, SEGMENT3 AS BIZ_TYPE, SEGMENT4 AS CELL_PACK_COUNT, SEGMENT1 AS DIVISION_ID
								   , RANK () OVER ( PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC ) MODEL_RANK 
								FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							   WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40' ) A
					  WHERE MODEL_RANK = '1' ) LOOKA
				ON LOOKA.MODEL = A.ITEM_ID		
			   AND LOOKA.DIVISION_ID = A.DIVISION_ID
		WHERE A.DIVISION_ID = '40'
		AND A.ITEM_ID = LOOKA.MODEL
		AND A.VERSION_NO = @v_version_no
		AND A.YYYYMMDD = @v_yyyymmdd;
	END

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_PLN_BP_FCST_REPORT_C 테이블 DELETE (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--BEGIN
		
		---- DELETE COUNT 확인
		--SET @n_delete_count =  (SELECT COUNT(division_id)  FROM [dbo].DM_PLN_BP_FCST_REPORT_C A WITH(NOLOCK)
		--						WHERE (
		--								SELECT count(1) 
		--									FROM #results_MST M
		--									where M.active_flag		= 'D'
		--								) > 0)

		----  select * from #results_MST
		--DELETE 
		--FROM [dbo].DM_PLN_BP_FCST_REPORT_C
		--WHERE (
		--		SELECT count(1) 
		--			FROM #results_MST M
		--			where M.active_flag		= 'D'
		--				and DATA_TYPE = '2'
		--				and DM_PLN_BP_FCST_REPORT_C.division_id		= M.division_id		
		--				and DM_PLN_BP_FCST_REPORT_C.version_no		= M.version_no			
		--				and DM_PLN_BP_FCST_REPORT_C.department_id	= M.department_id		
		--				--and DM_PLN_BP_FCST_REPORT_C.department_name	= M.department_name	
		--				and DM_PLN_BP_FCST_REPORT_C.dept_id			= M.dept_id			
		--				--and DM_PLN_BP_FCST_REPORT_C.dept_name		= M.dept_name			
		--				and DM_PLN_BP_FCST_REPORT_C.end_cust_report	= M.end_cust_report	
		--				and DM_PLN_BP_FCST_REPORT_C.cust_report		= M.cust_report		
		--				and DM_PLN_BP_FCST_REPORT_C.product_group	= M.product_group		

		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.project_code	,'')	= M.project_code		
		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.scm_site_id	,'')	= M.scm_site_id		
		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.dom_exp		,'')	= M.dom_exp		
		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.fcst_type	,'')	= M.fcst_type		
		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.incoterms	,'')	= M.incoterms		
		--				and ISNULL(DM_PLN_BP_FCST_REPORT_C.

		--				and DM_PLN_BP_FCST_REPORT_C.item_id			= M.item_id			
		--				and DM_PLN_BP_FCST_REPORT_C.currency	    = M.currency			-- 20190822
		--				and DM_PLN_BP_FCST_REPORT_C.company_id	    = M.company_id			-- 20200123
		--				and DM_PLN_BP_FCST_REPORT_C.measure			= M.measure		
		--				and DM_PLN_BP_FCST_REPORT_C.yyyymm			= SUBSTRING(M.yyyymmdd,1,6)
		--		) > 0;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                                  DM_PLN_BP_FCST_C 테이블 DELETE (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
			
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_PLN_BP_FCST_C 테이블 UPDATE, INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
		-- INSERT COUNT 확인
		--SET @n_insert_count = ( SELECT count(M.division_id) 
		--							FROM #results_MST M
		--								where M.active_flag      <> 'D' )
					
		--			MERGE INTO [dbo].[DM_PLN_BP_FCST_REPORT_C] A
		--			USING (
		--					SELECT *
		--						FROM #results_MST M
		--							where M.active_flag      <> 'D'
		--				  ) B
		--			ON(
		--						A.division_id		 = B.division_id			
		--				AND	    A.version_no		 = B.version_no		
		--				AND	    A.department_id		 = B.department_id			
		--				--AND	    A.department_name	 = B.department_name		
		--				AND	    A.dept_id			 = B.dept_id				
		--				--AND	    A.dept_name			 = B.dept_name				
		--				AND	    A.end_cust_report	 = B.end_cust_report		
		--				AND	    A.cust_report		 = B.cust_report			
		--				AND	    A.product_group		 = B.product_group			

		--				AND	    ISNULL(A.project_code	,'')	 = B.project_code			
		--				AND	    ISNULL(A.scm_site_id	,'')	 = B.scm_site_id			
		--				AND	    ISNULL(A.dom_exp		,'')	 = B.dom_exp				
		--				AND	    ISNULL(A.fcst_type		,'')	 = B.fcst_type				
		--				AND	    ISNULL(A.incoterms		,'')	 = B.incoterms				

		--				AND	    A.item_id			 = B.item_id				
		--				AND	    A.currency			 = B.currency				-- 20190822
		--				AND	    A.company_id		 = B.company_id				-- 20200123
		--				AND	    A.measure			 = B.measure				
		--				AND	    A.yyyymm			 = substring(B.yyyymmdd,1,6)		
		--				AND		a.DATA_TYPE = '2'	
		--			  )
		--			WHEN MATCHED THEN
		--				 UPDATE SET 
		--							 A.QTY				= B.QTY		
		--							,A.last_updated_by	= B.created_by
		--							,A.last_update_date	= GETDATE()
					                
		--			WHEN NOT MATCHED THEN

		--				 INSERT ( -- VER_SEQ
		--						   DATA_TYPE
		--						  ,division_id		
		--						  ,version_no		
		--						  ,cutoff_type		
		--						  ,cutoff_yyyymmdd	
		--						  ,department_id	
		--						  ,department_name	
		--						  ,dept_id			
		--						  ,dept_name		
		--						  ,end_cust_report	
		--						  ,cust_report		
		--						  ,product_group	
		--						  ,project_code
		--						  ,scm_site_id
		--						  ,dom_exp	
		--						  ,fcst_type	
		--						  ,incoterms	
		--						  ,plant_site_id

		--						  ,item_id	
		--						  ,measure	
		--						  ,yyyymm	
		--						  ,currency	
		--						  ,company_id
		--						  ,qty			
		--						  ,created_by	
		--						  ,CREATION_DATE
		--						  ,LAST_UPDATED_BY
		--						  ,LAST_UPDATE_DATE
		--						  ,ATTRIBUTE1
		--						  ,ATTRIBUTE2
		--						  ,ATTRIBUTE3
		--						  ,ATTRIBUTE4
		--						  ,ATTRIBUTE5
		--						)
		--				 VALUES (   '2'
		--						   ,B.division_id
		--						   ,B.version_no		
		--						   ,B.cutoff_type		
		--						   ,B.cutoff_yyyymmdd	
		--						   ,B.department_id	
		--						   ,B.department_name	
		--						   ,B.dept_id			
		--						   ,B.dept_name		
		--						   ,B.end_cust_report	
		--						   ,B.cust_report		
		--						   ,B.product_group	
		--							,''  --project_code
		--							,''	 --scm_site_id
		--							,''	 --dom_exp	
		--							,''	 --fcst_type	
		--							,''	 --incoterms	
		--							,''	 --plant_site_id
		--						   ,B.item_id
		--						   ,B.measure
		--						   ,substring(B.yyyymmdd,1,6)		
		--						   ,B.currency	
		--						   ,B.company_id		
		--						   ,B.qty
		--						   ,B.CREATED_BY
		--						   ,GETDATE()
		--						   ,B.CREATED_BY
		--						   ,GETDATE()
		--						   ,N'기타','',NULL,NULL,NULL
		--						);

	--END
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_PLN_BP_FCST_REPORT_C 테이블 UPDATE, INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
				
		-- UPDATE 후에 전송처리를 다시 한다.
		IF EXISTS ( SELECT DIVISION_ID FROM DM_MDF_VERSION WITH(NOLOCK) 
					 WHERE DIVISION_ID = @p_division_id 
					   AND VERSION_NO = @p_version_no 
					  AND SEND_YN = 'Y' )
		BEGIN
			EXEC DMF0044_MOBILE_REPORT_CREATE @p_division_id, @p_version_no, @p_cutoff_type, N'T', @p_created_by
		END


  	-- 트랜잭션 (COMMIT)
        COMMIT TRANSACTION DM_PLN_SALES_PLAN_REPORT_C;  -- sss
	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		ROLLBACK TRANSACTION DM_PLN_SALES_PLAN_REPORT_C;  -- sss

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
		
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;
    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;

  END;
  	--============================================================================================================
    -- [E20260107-001542]_INVALID, END 로그 (START)
	--============================================================================================================
    ERR_RTN:
    IF @v_log_type = 'INVALID'
    BEGIN
        ROLLBACK TRANSACTION;
		SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
		SELECT  N'구코드 COMPANY_ID는 저장할 수 없습니다.'	
        
		--============================================================================================================
		-- 종료 LOG (START)
		--============================================================================================================
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
		--============================================================================================================
		-- 종료 LOG (END)
		--============================================================================================================
	END
	--============================================================================================================
    -- [E20260107-001542]_INVALID, END 로그 (END)
	--============================================================================================================