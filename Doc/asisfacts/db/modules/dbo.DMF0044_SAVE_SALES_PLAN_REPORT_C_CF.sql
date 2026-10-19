
/*============================================================================================================================
 * Program ID   : DMF0044_SAVE_SALES_PLAN_REPORT_C_CF
 * Description  : 'DM_PLN_SALES_PLAN_REPORT_C' TABLE INSERT/UPDATE/DELETE
 * Program History
 *============================================================================================================================
 *   Date       In Charge      Description
 *============================================================================================================================
 * 2020/01/17	HWI1993			SCM_SITE_ID, COMPANY_ID, PROJECT_CODE 추가하면서 이름 변경함 - DMF0044_SAVE_SALES_PLAN_REPORT_C_CF ( Cutoff Data 전용임 )
 * 2020/03/26	hwi1993			department_name, dept_name 을 join 조건에서 제거함 ( lookup 적용으로 인해 같은 코드인데 화면과 db data 가 다를 수 있음 
 * 2020/05/22	hwi1993			Save 이후에 Transfer 처리
 * 2020/06/18	hwi1993			81번 로직 분리
 * 2020/09/09   P.C.I			[C20200909-000203] LOG 표준화 적용
 * 2020/09/18	HWI1993			[C20200909-000188] YYYYMMDD 를 영업일로 변환하는 로직 제거 LEFT(YYYYMMDD, 6) + '01' 로 변경
 * 2020/10/05	HWI1993			[C20201005-000291] Sales Report 대량 변경시 Time out 문제, QTY DATA TYPE 도 NUMERIC(30,10) 으로 변경
 * 2021/07/23	HWI1993			상반기과제 - 소형 마스터 정비
 * 2022/04/13   HWI1993			GM JV 작업
 * 2023/09/07	JSSBAE			[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 
 * 2024/05/09	JSSBAE			[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
 * 2025/05/09   JSSBAE			[E20250418-001567]_40사업부 Sales Report, ETC Report 개선
 * 2026/02/03	JSSBAE			[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선   
 *============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0044_SAVE_SALES_PLAN_REPORT_C_CF]
	  @p_active_flag			NVARCHAR(MAX)
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
	, @p_qty					NVARCHAR(MAX)
	, @p_scm_site_id			NVARCHAR(MAX)
	, @p_project_code			NVARCHAR(MAX)
	, @p_company_id				NVARCHAR(MAX)
	, @p_fcst_type				NVARCHAR(MAX)
	, @p_incoterms				NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET NOCOUNT ON; 
	SET XACT_ABORT ON;

	-----------------------------------------------------------------------------------------------
	-- 스플릿관련 변수
	-----------------------------------------------------------------------------------------------
	DECLARE	@v_active_flag			NVARCHAR(1);
	DECLARE	@v_division_id			NVARCHAR(30);
	DECLARE	@v_version_no			NVARCHAR(30);
	DECLARE	@v_cutoff_type			NVARCHAR(20);
	DECLARE	@v_cutoff_yyyymmdd		NVARCHAR(8);
	DECLARE	@v_department_id		NVARCHAR(10);
	DECLARE	@v_department_name		NVARCHAR(50);
	DECLARE	@v_dept_id				NVARCHAR(10);
	DECLARE	@v_dept_name			NVARCHAR(50);
	DECLARE	@v_end_cust_report		NVARCHAR(30);
	
	DECLARE	@v_cust_report			NVARCHAR(30);
	DECLARE	@v_product_group		NVARCHAR(30);
	DECLARE	@v_item_id				NVARCHAR(50);
	DECLARE	@v_measure				NVARCHAR(20);
	DECLARE	@v_yyyymmdd				NVARCHAR(8);
	DECLARE	@v_currency				NVARCHAR(5);
	DECLARE	@v_qty					NVARCHAR(40);
	DECLARE	@v_scm_site_id			NVARCHAR(30);
	DECLARE	@v_project_code			NVARCHAR(30);
	DECLARE	@v_company_id			NVARCHAR(30);
	
	DECLARE	@v_fcst_type			NVARCHAR(10);
	DECLARE	@v_incoterms			NVARCHAR(10);
	DECLARE	@v_created_by			NVARCHAR(150);
	DECLARE	@v_ori_version_no		NVARCHAR(50);	
	DECLARE	@v_delimiter			NVARCHAR(1)
	SET		@v_delimiter = '^'  -- 데이터 구분자
	DECLARE	@max_loop_cnt			INTEGER = 0; 
	DECLARE	@mst_loop_cnt			INTEGER = 0;

	-----------------------------------------------------------------------------------------------
	-- LOG 용 변수 설정
	-----------------------------------------------------------------------------------------------
	DECLARE	@v_program_name			NVARCHAR(150) = 'DMF0044_SAVE_SALES_PLAN_REPORT_C_CF';
	DECLARE	@v_log_type				NVARCHAR(30); -- START/END/ERROR/...
	DECLARE	@n_log_count			INTEGER = 0;
	DECLARE	@v_log_message			NVARCHAR(1000);
	DECLARE	@v_log_description		NVARCHAR(500);
	DECLARE	@d_event_date			DATETIME;
	DECLARE	@n_delete_count			INTEGER = 0;
	DECLARE	@n_insert_count			INTEGER = 0;
	DECLARE	@n_input_count			INTEGER = 0;
	DECLARE	@n_logo_count			INTEGER = 0;

	-----------------------------------------------------------------------------------------------
	--계산용 변수
	-----------------------------------------------------------------------------------------------
	DECLARE   @i 					INT
			, @Cnt 					INT
			, @AdjQty 				NUMERIC(30,10)	-- 수정후 총 수량
			, @rest 				NUMERIC(30,10)	-- 계산후의 나머지 수량
			, @OriQty 				NUMERIC(30,10)	-- 수정전 총 수량
			, @QtyCnt 				INT				-- 건수
			, @MinDate 				VARCHAR(8)		-- 가장 앞의 일자 ( 해당월에서 )
			, @v_plan_yn 			CHAR(1)			-- 계획구간여부
			, @v_loc_salesamt_loc	NUMERIC(30,10)	-- 실적구간의 단가를 인서트하기 위한 변수
			, @v_loc_rtf			NUMERIC(30,10)	-- 실적구간의 단가를 인서트하기 위한 변수
			, @v_loc_price			NUMERIC(30,10)	-- 실적구간의 단가를 인서트하기 위한 변수

	-----------------------------------------------------------------------------------------------
	-- 마지막 데이터 처리를 위한 구분자 추가
	-----------------------------------------------------------------------------------------------
	SET	@p_active_flag				= RTRIM(@p_active_flag		) + '^';
	SET	@p_division_id				= RTRIM(@p_division_id		) + '^';
	SET	@p_version_no				= RTRIM(@p_version_no		) + '^';
	SET	@p_cutoff_type				= RTRIM(@p_cutoff_type		) + '^';
	SET	@p_cutoff_yyyymmdd			= RTRIM(@p_cutoff_yyyymmdd	) + '^';
	SET	@p_department_id			= RTRIM(@p_department_id	) + '^';
	SET	@p_department_name			= RTRIM(@p_department_name	) + '^';
	SET	@p_dept_id					= RTRIM(@p_dept_id			) + '^';
	SET	@p_dept_name				= RTRIM(@p_dept_name		) + '^';
	SET	@p_end_cust_report			= RTRIM(@p_end_cust_report	) + '^';
	
	SET	@p_cust_report				= RTRIM(@p_cust_report		) + '^';
	SET	@p_product_group			= RTRIM(@p_product_group	) + '^';
	SET	@p_item_id					= RTRIM(@p_item_id			) + '^';
	SET	@p_measure					= RTRIM(@p_measure			) + '^';
	SET	@p_yyyymmdd					= RTRIM(@p_yyyymmdd			) + '^';
	SET	@p_currency					= RTRIM(@p_currency			) + '^';
	SET	@p_qty						= RTRIM(@p_qty				) + '^';
	SET	@p_scm_site_id				= RTRIM(@p_scm_site_id		) + '^';
	SET	@p_project_code				= RTRIM(@p_project_code		) + '^';
	SET	@p_company_id				= RTRIM(@p_company_id		) + '^';
	
	SET	@p_fcst_type				= RTRIM(@p_fcst_type		) + '^';
	SET	@p_incoterms				= RTRIM(@p_incoterms		) + '^';
	SET	@p_created_by				= RTRIM(@p_created_by		) + '^';
	
	-----------------------------------------------------------------------------------------------
	-- #results_MST TEMP TABLE DROP
	-----------------------------------------------------------------------------------------------
	IF OBJECT_ID (N'tempdb..#results_MST', N'U') IS NOT NULL 
		DROP TABLE #results_MST		

	-----------------------------------------------------------------------------------------------
	-- #results_MST TEMP TABLE CREATE
	-----------------------------------------------------------------------------------------------
	CREATE TABLE #results_MST  (  active_flag			NVARCHAR(1)
								, division_id			NVARCHAR(30)
								, version_no			NVARCHAR(30)
								, cutoff_type			NVARCHAR(20)
								, cutoff_yyyymmdd		NVARCHAR(8)
								, department_id			NVARCHAR(10)
								, department_name		NVARCHAR(50)
								, dept_id				NVARCHAR(10)
								, dept_name				NVARCHAR(50)
								, end_cust_report		NVARCHAR(30)
								, cust_report			NVARCHAR(30)
								, product_group			NVARCHAR(30)
								, project_code			NVARCHAR(30)
								, scm_site_id			NVARCHAR(30)
								, dom_exp				NVARCHAR(2)
								, fcst_type				NVARCHAR(10)
								, incoterms				NVARCHAR(10)
								, company_id			NVARCHAR(30)
								, item_id				NVARCHAR(50)
								, measure				NVARCHAR(20)
								, yyyymmdd				NVARCHAR(8)
								, currency				NVARCHAR(5)
								, qty					NVARCHAR(40)
								, created_by			NVARCHAR(150)
								, plan_yn				NVARCHAR(1)
								, SEQ_RANK				INT				-- measure를 제외한 key 값별 순서( yyyymmdd 는 yyyymm 로 조정 )
								, SEQ_ROWNUM			INT )

	--=============================================================================================
	-- 시작 LOG  (START)
	--=============================================================================================
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date;
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 
	--=============================================================================================
	-- 시작 LOG  (END)
	--=============================================================================================

	--=============================================================================================
	-- 트랜잭션 (START)
	--=============================================================================================
	BEGIN TRANSACTION DM_PLN_SALES_PLAN_REPORT_C;
	BEGIN TRY
	
	--=============================================================================================
	--#results_MST 테이블에 split후 insert (START)
	--=============================================================================================
	WHILE LEN(@p_division_id) > 0
	BEGIN
		DECLARE	@index_active_flag		INT
		DECLARE	@index_division_id		INT
		DECLARE	@index_version_no		INT
		DECLARE	@index_cutoff_type		INT
		DECLARE	@index_cutoff_yyyymmdd	INT
		DECLARE	@index_department_id	INT
		DECLARE	@index_department_name	INT
		DECLARE	@index_dept_id			INT
		DECLARE	@index_dept_name		INT
		DECLARE	@index_end_cust_report	INT
		
		DECLARE	@index_cust_report		INT
		DECLARE	@index_product_group	INT
		DECLARE	@index_item_id			INT
		DECLARE	@index_measure			INT
		DECLARE	@index_yyyymmdd			INT
		DECLARE	@index_currency			INT
		DECLARE	@index_qty				INT
		DECLARE	@index_scm_site_id		INT
		DECLARE	@index_project_code		INT
		DECLARE	@index_company_id		INT
		
		DECLARE	@index_fcst_type		INT
		DECLARE	@index_incoterms		INT
		DECLARE	@index_created_by		INT

		SET	@index_active_flag			= PATINDEX('%' + '^' + '%', @p_active_flag			)
		SET	@index_division_id			= PATINDEX('%' + '^' + '%', @p_division_id			)
		SET	@index_version_no			= PATINDEX('%' + '^' + '%', @p_version_no			)
		SET	@index_cutoff_type			= PATINDEX('%' + '^' + '%', @p_cutoff_type			)
		SET	@index_cutoff_yyyymmdd		= PATINDEX('%' + '^' + '%', @p_cutoff_yyyymmdd		)
		SET	@index_department_id			= PATINDEX('%' + '^' + '%', @p_department_id	)
		SET	@index_department_name		= PATINDEX('%' + '^' + '%', @p_department_name		)
		SET	@index_dept_id				= PATINDEX('%' + '^' + '%', @p_dept_id				)
		SET	@index_dept_name				= PATINDEX('%' + '^' + '%', @p_dept_name		)
		SET	@index_end_cust_report		= PATINDEX('%' + '^' + '%', @p_end_cust_report		)
		
		SET	@index_cust_report			= PATINDEX('%' + '^' + '%', @p_cust_report			)
		SET	@index_product_group			= PATINDEX('%' + '^' + '%', @p_product_group	)
		SET	@index_item_id				= PATINDEX('%' + '^' + '%', @p_item_id				)
		SET	@index_measure				= PATINDEX('%' + '^' + '%', @p_measure				)
		SET	@index_yyyymmdd				= PATINDEX('%' + '^' + '%', @p_yyyymmdd				)
		SET	@index_currency				= PATINDEX('%' + '^' + '%', @p_currency				)
		SET	@index_qty					= PATINDEX('%' + '^' + '%', @p_qty					)
		SET	@index_scm_site_id			= PATINDEX('%' + '^' + '%', @p_scm_site_id			)
		SET	@index_project_code			= PATINDEX('%' + '^' + '%', @p_project_code			)
		SET	@index_company_id			= PATINDEX('%' + '^' + '%', @p_company_id			)
		
		SET	@index_fcst_type				= PATINDEX('%' + '^' + '%', @p_fcst_type		)
		SET	@index_incoterms				= PATINDEX('%' + '^' + '%', @p_incoterms		)
		SET	@index_created_by			= PATINDEX('%' + '^' + '%', @p_created_by			)
		
		IF LEN(@p_division_id) > 0
		BEGIN
			set	@v_active_flag				= substring(@p_active_flag			, 0, @index_active_flag			)
			set	@v_division_id				= substring(@p_division_id			, 0, @index_division_id			)
			set	@v_version_no				= substring(@p_version_no			, 0, @index_version_no			)
			set	@v_cutoff_type				= substring(@p_cutoff_type			, 0, @index_cutoff_type			)
			set	@v_cutoff_yyyymmdd			= substring(@p_cutoff_yyyymmdd		, 0, @index_cutoff_yyyymmdd		)
			set	@v_department_id			= substring(@p_department_id		, 0, @index_department_id		)
			set	@v_department_name			= substring(@p_department_name		, 0, @index_department_name		)
			set	@v_dept_id					= substring(@p_dept_id				, 0, @index_dept_id				)
			set	@v_dept_name				= substring(@p_dept_name			, 0, @index_dept_name			)
			set	@v_end_cust_report			= substring(@p_end_cust_report		, 0, @index_end_cust_report		)
			
			set	@v_cust_report				= substring(@p_cust_report			, 0, @index_cust_report			)
			set	@v_product_group			= substring(@p_product_group		, 0, @index_product_group		)
			set	@v_item_id					= substring(@p_item_id				, 0, @index_item_id				)
			set	@v_measure					= substring(@p_measure				, 0, @index_measure				)
			set	@v_yyyymmdd					= substring(@p_yyyymmdd				, 0, @index_yyyymmdd			)
			set	@v_currency					= substring(@p_currency				, 0, @index_currency			)
			set	@v_qty						= substring(@p_qty					, 0, @index_qty					)
			set	@v_scm_site_id				= substring(@p_scm_site_id			, 0, @index_scm_site_id			)
			set	@v_project_code				= substring(@p_project_code			, 0, @index_project_code		)
			set	@v_company_id				= substring(@p_company_id			, 0, @index_company_id			)
			
			set	@v_fcst_type				= substring(@p_fcst_type			, 0, @index_fcst_type			)
			set	@v_incoterms				= substring(@p_incoterms			, 0, @index_incoterms			)
			set	@v_created_by				= substring(@p_created_by			, 0, @index_created_by			)

			set @p_active_flag				= substring(@p_active_flag			, len(@v_active_flag		+ '^') + 1, len(@p_active_flag		))
			set @p_division_id				= substring(@p_division_id			, len(@v_division_id		+ '^') + 1, len(@p_division_id		))
			set @p_version_no				= substring(@p_version_no			, len(@v_version_no			+ '^') + 1, len(@p_version_no		))
			set @p_cutoff_type				= substring(@p_cutoff_type			, len(@v_cutoff_type		+ '^') + 1, len(@p_cutoff_type		))
			set @p_cutoff_yyyymmdd			= substring(@p_cutoff_yyyymmdd		, len(@v_cutoff_yyyymmdd	+ '^') + 1, len(@p_cutoff_yyyymmdd	))
			set @p_department_id			= substring(@p_department_id		, len(@v_department_id		+ '^') + 1, len(@p_department_id	))
			set @p_department_name			= substring(@p_department_name		, len(@v_department_name	+ '^') + 1, len(@p_department_name	))
			set @p_dept_id					= substring(@p_dept_id				, len(@v_dept_id			+ '^') + 1, len(@p_dept_id			))
			set @p_dept_name				= substring(@p_dept_name			, len(@v_dept_name			+ '^') + 1, len(@p_dept_name		))
			set @p_end_cust_report			= substring(@p_end_cust_report		, len(@v_end_cust_report	+ '^') + 1, len(@p_end_cust_report	))
			
			set @p_cust_report				= substring(@p_cust_report			, len(@v_cust_report		+ '^') + 1, len(@p_cust_report		))
			set @p_product_group			= substring(@p_product_group		, len(@v_product_group		+ '^') + 1, len(@p_product_group	))
			set @p_item_id					= substring(@p_item_id				, len(@v_item_id			+ '^') + 1, len(@p_item_id			))
			set @p_measure					= substring(@p_measure				, len(@v_measure			+ '^') + 1, len(@p_measure			))
			set @p_yyyymmdd					= substring(@p_yyyymmdd				, len(@v_yyyymmdd			+ '^') + 1, len(@p_yyyymmdd			))
			set @p_currency					= substring(@p_currency				, len(@v_currency			+ '^') + 1, len(@p_currency			))
			set @p_qty						= substring(@p_qty					, len(@v_qty				+ '^') + 1, len(@p_qty				))
			set @p_scm_site_id				= substring(@p_scm_site_id			, len(@v_scm_site_id		+ '^') + 1, len(@p_scm_site_id		))
			set @p_project_code				= substring(@p_project_code			, len(@v_project_code		+ '^') + 1, len(@p_project_code		))
			set @p_company_id				= substring(@p_company_id			, len(@v_company_id			+ '^') + 1, len(@p_company_id		))
			
			set @p_fcst_type				= substring(@p_fcst_type			, len(@v_fcst_type			+ '^') + 1, len(@p_fcst_type		))
			set @p_incoterms				= substring(@p_incoterms			, len(@v_incoterms			+ '^') + 1, len(@p_incoterms		))
			set @p_created_by				= substring(@p_created_by			, len(@v_created_by			+ '^') + 1, len(@p_created_by		))

			-----------------------------------------------------------------------------------------------
			--공백제거
			-----------------------------------------------------------------------------------------------
			set	@v_active_flag				= rtrim(ltrim(@v_active_flag		))
			set	@v_division_id				= rtrim(ltrim(@v_division_id		))
			set	@v_version_no				= rtrim(ltrim(@v_version_no			))
			set	@v_cutoff_type				= rtrim(ltrim(@v_cutoff_type		))
			set	@v_cutoff_yyyymmdd			= rtrim(ltrim(@v_cutoff_yyyymmdd	))
			set	@v_department_id			= rtrim(ltrim(@v_department_id		))
			set	@v_department_name			= rtrim(ltrim(@v_department_name	))
			set	@v_dept_id					= rtrim(ltrim(@v_dept_id			))
			set	@v_dept_name				= rtrim(ltrim(@v_dept_name			))
			set	@v_end_cust_report			= rtrim(ltrim(@v_end_cust_report	))
			
			set	@v_cust_report				= rtrim(ltrim(@v_cust_report		))
			set	@v_product_group			= rtrim(ltrim(@v_product_group		))
			set	@v_item_id					= rtrim(ltrim(@v_item_id			))
			set	@v_measure					= rtrim(ltrim(@v_measure			))
			set	@v_yyyymmdd					= rtrim(ltrim(@v_yyyymmdd			))
			set	@v_currency					= rtrim(ltrim(@v_currency			))
			set	@v_qty						= rtrim(ltrim(@v_qty				))
			set	@v_scm_site_id				= rtrim(ltrim(@v_scm_site_id		))
			set	@v_project_code				= rtrim(ltrim(@v_project_code		))
			set	@v_company_id				= rtrim(ltrim(@v_company_id			))
			
			set	@v_fcst_type				= rtrim(ltrim(@v_fcst_type			))
			set	@v_incoterms				= rtrim(ltrim(@v_incoterms			))
			set	@v_created_by				= rtrim(ltrim(@v_created_by			))

			if @v_qty = ''
				set @v_qty = '0'

			SET @v_yyyymmdd = LEFT(@v_yyyymmdd, 6) + '01'
			INSERT INTO #results_MST 
			( active_flag, division_id, version_no, cutoff_type, cutoff_yyyymmdd	
			, department_id, department_name, dept_id, dept_name, end_cust_report	
			, cust_report, product_group, project_code, scm_site_id, dom_exp		
			, fcst_type, incoterms, item_id, measure, yyyymmdd			
			, currency, qty, company_id, created_by	) 
			VALUES 
			( @v_active_flag, @v_division_id, @v_version_no	, @v_cutoff_type, @v_cutoff_yyyymmdd	
			, @v_department_id, @v_department_name, @v_dept_id, @v_dept_name, @v_end_cust_report	
			, @v_cust_report, @v_product_group, @v_project_code, @v_scm_site_id, ''	--dom_exp			
			, @v_fcst_type, @v_incoterms, @v_item_id, @v_measure, @v_yyyymmdd			
			, @v_currency, @v_qty, @v_company_id, @v_created_by	)
		END
		ELSE
		BEGIN 
			-----------------------------------------------------------------------------------------------
			--공백제거
			-----------------------------------------------------------------------------------------------
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
			set @v_qty								= rtrim(ltrim(@v_qty				))
			set @v_scm_site_id						= rtrim(ltrim(@v_scm_site_id		))
			set @v_project_code						= rtrim(ltrim(@v_project_code		))
			set @v_company_id						= rtrim(ltrim(@v_company_id			))
			
			set @v_fcst_type						= rtrim(ltrim(@v_fcst_type			))
			set @v_incoterms						= rtrim(ltrim(@v_incoterms			))
			set @v_created_by						= rtrim(ltrim(@v_created_by			))

			if @v_qty = ''
				set @v_qty = '0'

			SET @v_yyyymmdd = LEFT(@v_yyyymmdd, 6) + '01'
			INSERT INTO #results_MST 
			( active_flag, division_id, version_no, cutoff_type, cutoff_yyyymmdd	
			, department_id, department_name, dept_id, dept_name, end_cust_report	
			, cust_report, product_group, project_code, scm_site_id, dom_exp		
			, fcst_type, incoterms, item_id, measure, yyyymmdd			
			, currency, qty, company_id, created_by	) 
			VALUES 
			( @v_active_flag, @v_division_id, @v_version_no	, @v_cutoff_type, @v_cutoff_yyyymmdd	
			, @v_department_id, @v_department_name, @v_dept_id, @v_dept_name, @v_end_cust_report	
			, @v_cust_report, @v_product_group, @v_project_code, @v_scm_site_id, ''	--dom_exp			
			, @v_fcst_type, @v_incoterms, @v_item_id, @v_measure, @v_yyyymmdd			
			, @v_currency, @v_qty, @v_company_id, @v_created_by	)
		END
	END
	--=============================================================================================
	--#results_MST 테이블에 split후 insert (END)
	--=============================================================================================
	--=============================================================================================
	--[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선 (START)  
	--=============================================================================================
	IF EXISTS ( SELECT * FROM #results_MST R WHERE R.company_id IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'COMPANY_ID' GROUP BY OLD_VALUE1))
	BEGIN
		SET @v_log_type		= 'INVALID';
		SET @v_log_description	=  N'구코드 COMPANY_ID는 저장할 수 없습니다.';		
		GOTO ERR_RTN
	END			
	--=============================================================================================
	--[E20260107-001542]_DM_COMPANY 룩업코드 로직 개선 (END)  
	--=============================================================================================

	-----------------------------------------------------------------------------------------------
	--ORI_VERSION_NO을 조회하여 변수에 보관한다.
	-----------------------------------------------------------------------------------------------
	SELECT @v_ori_version_no = ORI_VERSION_NO
	FROM   DM_MDF_VERSION WITH(NOLOCK)
	WHERE VERSION_TYPE 	= @v_cutoff_type
	AND	  VERSION_NO 	= @v_version_no	
	
	-----------------------------------------------------------------------------------------------
	-- 처리할 데이터에 순번을 넣어준다. ( 메저들을 묶어서 한 세트로 )
	-----------------------------------------------------------------------------------------------
	UPDATE A
	SET SEQ_RANK = B.SEQ_RANK
	FROM #results_MST A
	JOIN ( SELECT DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
	  			, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID
				, ITEM_ID, LEFT(YYYYMMDD, 6) AS YYYYMMDD, CURRENCY, COMPANY_ID, PROJECT_CODE
				, DENSE_RANK() OVER ( ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
											 , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID
											 , ITEM_ID, LEFT(YYYYMMDD, 6), CURRENCY ) AS SEQ_RANK
			FROM #results_MST
		 ) B 
	  ON A.VERSION_NO 		= B.VERSION_NO
	 AND A.DIVISION_ID 		= B.DIVISION_ID
	 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
	 --AND A.DEPARTMENT_NAME 	= B.DEPARTMENT_NAME
	 AND A.DEPT_ID 			= B.DEPT_ID
	 --AND A.DEPT_NAME 		= B.DEPT_NAME
	 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
	 AND A.CUST_REPORT 		= B.CUST_REPORT
	 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
	 AND A.PROJECT_CODE 	= B.PROJECT_CODE
	 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
	 AND A.ITEM_ID 			= B.ITEM_ID
	 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
	 AND A.CURRENCY 		= B.CURRENCY
	 AND A.COMPANY_ID 		= B.COMPANY_ID

	UPDATE A
	SET SEQ_ROWNUM = B.SEQ_ROWNUM
	FROM #results_MST A
	JOIN ( SELECT DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
	  			, DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID
				, ITEM_ID, LEFT(YYYYMMDD, 6) AS YYYYMMDD, CURRENCY, COMPANY_ID, PROJECT_CODE
				, ROW_NUMBER() OVER ( PARTITION BY SEQ_RANK ORDER BY DIVISION_ID, VERSION_NO, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID
																   , DEPT_NAME, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID
																   , ITEM_ID, LEFT(YYYYMMDD, 6), CURRENCY ) AS SEQ_ROWNUM
		   FROM #results_MST ) B 
	  ON A.VERSION_NO 		= B.VERSION_NO
	 AND A.DIVISION_ID 		= B.DIVISION_ID
	 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
	 --AND A.DEPARTMENT_NAME 	= B.DEPARTMENT_NAME
	 AND A.DEPT_ID 			= B.DEPT_ID
	 --AND A.DEPT_NAME 		= B.DEPT_NAME
	 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
	 AND A.CUST_REPORT 		= B.CUST_REPORT
	 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
	 AND A.PROJECT_CODE 	= B.PROJECT_CODE
	 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
	 AND A.ITEM_ID 			= B.ITEM_ID
	 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
	 AND A.CURRENCY 		= B.CURRENCY
	 AND A.COMPANY_ID 		= B.COMPANY_ID

	-----------------------------------------------------------------------------------------------
	-- 계획구간 여부 UPDATE
	-----------------------------------------------------------------------------------------------
	UPDATE #results_MST
	SET PLAN_YN = CASE WHEN LEFT(YYYYMMDD, 6) >= CONVERT(CHAR(6), GETDATE(), 112) THEN 'Y' ELSE 'N' END

	SET @n_input_count = ( SELECT COUNT(active_flag) FROM #results_MST)

	--=============================================================================================
	--DM_PLN_SALES_PLAN_REPORT_C 테이블 DELETE (START)
	--=============================================================================================
	IF @v_cutoff_type = 'REPORT_SP_W'
	BEGIN
PRINT @v_program_name + ' / cutoff_type: ' + @v_cutoff_type + ' / A001: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
		-----------------------------------------------------------------------------------------------			
		-- 초기화
		-----------------------------------------------------------------------------------------------			
		SELECT @i  = 1, @Cnt = 0, @AdjQty = 0, @rest = 0, @OriQty = 0, @QtyCnt = 0, @MinDate = NULL, @v_plan_yn = N'N'

		SELECT @i = 1, @Cnt = MAX(SEQ_RANK)
		FROM #results_MST

		IF ( @v_division_id = '40' )
		BEGIN
PRINT @v_program_name + ' / division_id: ' + @v_division_id + ' / A002: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
			WHILE ( @i <= @Cnt )
			BEGIN				
				SELECT TOP 1 @v_plan_yn = PLAN_YN
				FROM  #results_MST A
				WHERE SEQ_RANK = @i

				-----------------------------------------------------------------------------------------------			
				-- Pricce 가 변경된 경우 ( 계획구간 ) -- 일단 Price 만 업데이트
				-----------------------------------------------------------------------------------------------			
				IF EXISTS ( SELECT * FROM #results_MST A
							WHERE SEQ_RANK = @i
							AND   MEASURE = 'LOC'	)
				BEGIN
PRINT @v_program_name + ' / A003: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
					-----------------------------------------------------------------------------------------------		
					-- LOC 가 있으면 업데이트, 없으면 인서트
					-----------------------------------------------------------------------------------------------	
					IF EXISTS ( SELECT 1 
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO
								 AND A.DIVISION_ID 		= B.DIVISION_ID
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID
								 AND A.MEASURE 			= B.MEASURE
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE = 'LOC'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN	
PRINT @v_program_name + ' / A004: ' + CONVERT(VARCHAR(30), GETDATE(), 121);			
						UPDATE A
						SET QTY = B.QTY
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'LOC'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
					ELSE
					BEGIN
PRINT @v_program_name + ' / A005: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							 , A.FCST_TYPE, A.INCOTERMS, 'LOC' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
							 , A.CURRENCY, B.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
							 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
							 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND B.SEQ_RANK 		= @i
						 AND B.MEASURE 			= 'LOC'
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
				END
								
				-----------------------------------------------------------------------------------------------	
				-- 수량등이 변경된 건이 있을 경우 기존 데이터의 비율대로 배부하고 남은건을 첫번째 날짜에 몰아준다.					
				-----------------------------------------------------------------------------------------------			
				IF EXISTS ( SELECT * FROM #results_MST A
							WHERE SEQ_RANK = @i
							AND   MEASURE IN ( N'RTF', N'RTF_SYS_RP'))
				BEGIN
PRINT @v_program_name + ' / A006: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
					SELECT @AdjQty  = Qty
					FROM  #results_MST
					WHERE SEQ_RANK = @i
					AND   Measure IN ( N'RTF', N'RTF_SYS_RP')

					-----------------------------------------------------------------------------------------------	
					-- 수정전 DM_PLN_SALES_PLAN_REPORT_C 테이블의 수량 합계, 건수 계산
					-----------------------------------------------------------------------------------------------	
					SELECT @OriQty = SUM(A.QTY)
						 , @QtyCnt = COUNT(*)
						 , @MinDate = MIN(A.YYYYMMDD)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID
					 AND A.MEASURE 			= B.MEASURE
					 AND B.SEQ_RANK 		= @i
					WHERE A.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
					AND   A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no

					-----------------------------------------------------------------------------------------------
					-- 수정후 수량 = 수정된 총수량 * 원래개별수량/원래총수량
					-----------------------------------------------------------------------------------------------
					IF ( ISNULL(@OriQty,0) <> 0)
					BEGIN
PRINT @v_program_name + ' / A007: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = CASE WHEN @OriQty  <> 0 THEN ROUND(@ADjQty * A.Qty/@OriQty , 0)
									   ELSE ROUND(@AdjQty / @QtyCnt, 0)
								  END
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						-----------------------------------------------------------------------------------------------
						--나머지 배부
						-----------------------------------------------------------------------------------------------
						SELECT @rest = @AdjQty - SUM(A.Qty)
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						-----------------------------------------------------------------------------------------------
						-- SalesAmt_KRW, _LOC 메저 처리
						-----------------------------------------------------------------------------------------------
						IF @Rest <> 0
						BEGIN
PRINT @v_program_name + ' / A008: ' + CONVERT(VARCHAR(30), GETDATE(), 121);										
							UPDATE A
							SET QTY = A.QTY + @rest
							  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							FROM DM_PLN_SALES_PLAN_REPORT_C A
							JOIN #results_MST B 
							  ON A.VERSION_NO		= B.VERSION_NO
							 AND A.DIVISION_ID 		= B.DIVISION_ID
							 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
							 AND A.DEPT_ID 			= B.DEPT_ID
							 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
							 AND A.CUST_REPORT 		= B.CUST_REPORT
							 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE 	= B.PROJECT_CODE
							 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
							 AND A.ITEM_ID 			= B.ITEM_ID
							 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
							 AND A.CURRENCY 		= B.CURRENCY
							 AND A.COMPANY_ID 		= B.COMPANY_ID
							 AND A.MEASURE 			= B.MEASURE
							 AND B.SEQ_RANK 		= @i
							 AND A.YYYYMMDD 		= @MinDate
							WHERE A.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
							AND   A.DIVISION_ID 	= @v_division_id
							AND   A.VERSION_NO 		= @v_version_no
						END
					END 
					ELSE
					-----------------------------------------------------------------------------------------------
					-- RTF 가 원래 없었을 경우
					-----------------------------------------------------------------------------------------------
					BEGIN		
PRINT @v_program_name + ' / A009: ' + CONVERT(VARCHAR(30), GETDATE(), 121);						
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							 , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
							 , A.CURRENCY, B.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
							 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
							 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND B.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
						 AND B.SEQ_RANK 		= @i
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
				END
						
				-----------------------------------------------------------------------------------------------
				-- 금액처리_SalesAmt_LOC ( 여기서는 Qty 변수들을 Amnt 로 활용한다. )
				-----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT * FROM #results_MST A
							WHERE SEQ_RANK = @i
							AND   MEASURE = N'SalesAmt_LOC' )
				BEGIN
PRINT @v_program_name + ' / A010: ' + CONVERT(VARCHAR(30), GETDATE(), 121);							
					SELECT @AdjQty = 0, @rest = 0

					SELECT @AdjQty	= Qty
					FROM  #results_MST
					WHERE SEQ_RANK	= @i
					AND   MEASURE	= N'SalesAmt_LOC'

					-----------------------------------------------------------------------------------------------
					-- 수정전 금액 합계, 건수 계산
					-----------------------------------------------------------------------------------------------
					SELECT @OriQty = SUM(A.QTY)
						 , @QtyCnt = COUNT(*)
						 , @MinDate = MIN(A.YYYYMMDD)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID
					 AND A.MEASURE 			= B.MEASURE
					 AND B.SEQ_RANK 		= @i
					WHERE A.MEASURE 		= 'SalesAmt_LOC'
					AND   A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO		= @v_version_no

					-----------------------------------------------------------------------------------------------
					-- 수정후 금액 = 수정된 총 금액 * 원래 개별 금액 / 원래 총금액  
					-----------------------------------------------------------------------------------------------
					IF EXISTS (	SELECT A.DIVISION_ID
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO
								 AND A.DIVISION_ID 		= B.DIVISION_ID
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID
								 AND A.MEASURE 			= B.MEASURE
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE 		= 'SalesAmt_LOC'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A011: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = CASE WHEN @OriQty  <> 0 THEN ROUND(@ADjQty * A.Qty/@OriQty , 0)
									   ELSE ROUND(@AdjQty / @QtyCnt, 0)
								  END
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_LOC'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						-----------------------------------------------------------------------------------------------
						--나머지 배부
						-----------------------------------------------------------------------------------------------
						SELECT @rest = @AdjQty - SUM(A.Qty)
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.Measure 			= B.Measure
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_LOC'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						IF @Rest <> 0
						BEGIN
PRINT @v_program_name + ' / A012: ' + CONVERT(VARCHAR(30), GETDATE(), 121);							
							UPDATE A
							SET QTY = A.QTY + @rest
							  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							FROM DM_PLN_SALES_PLAN_REPORT_C A
							JOIN #results_MST B 
							  ON A.VERSION_NO 		= B.VERSION_NO
							 AND A.DIVISION_ID 		= B.DIVISION_ID
							 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
							 AND A.DEPT_ID 			= B.DEPT_ID
							 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
							 AND A.CUST_REPORT 		= B.CUST_REPORT
							 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE 	= B.PROJECT_CODE
							 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
							 AND A.ITEM_ID 			= B.ITEM_ID
							 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
							 AND A.CURRENCY 		= B.CURRENCY
							 AND A.COMPANY_ID 		= B.COMPANY_ID
							 AND A.MEASURE 			= B.MEASURE
							 AND B.SEQ_RANK 		= @i
							 AND A.YYYYMMDD 		= @MinDate
							WHERE A.MEASURE 		= 'SalesAmt_LOC'
							AND   A.DIVISION_ID 	= @v_division_id
							AND   A.VERSION_NO 		= @v_version_no
						END
					END
					ELSE	
					-----------------------------------------------------------------------------------------------
					-- 원래 SalesAmt_LOC 메저가 없었던 경우
					-----------------------------------------------------------------------------------------------
					BEGIN
PRINT @v_program_name + ' / A013: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							 , A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_LOC' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
							 , A.CURRENCY, B.QTY, @p_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @p_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
							 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
							 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND B.MEASURE 			= 'SalesAmt_LOC'
						 AND B.SEQ_RANK 		= @i
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
				END
					
				-----------------------------------------------------------------------------------------------
				-- 금액처리_SalesAmt_KRW
				-----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT * FROM #results_MST A
							WHERE SEQ_RANK 	= @i
							AND   MEASURE 	= N'SalesAmt_KRW' )							
				BEGIN
PRINT @v_program_name + ' / A014: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
					SELECT @AdjQty  = Qty
					FROM  #results_MST
					WHERE SEQ_RANK 	= @i
					AND   MEASURE 	= N'SalesAmt_KRW'

					-----------------------------------------------------------------------------------------------
					-- 수정전 금액 합계, 건수 계산
					-----------------------------------------------------------------------------------------------
					SELECT @OriQty 	= SUM(A.QTY)
						 , @QtyCnt 	= COUNT(*)
						 , @MinDate = MIN(A.YYYYMMDD)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID			= B.ITEM_ID
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID
					 AND A.MEASURE 			= B.MEASURE
					 AND B.SEQ_RANK 		= @i
					WHERE A.MEASURE 		= 'SalesAmt_KRW'
					AND   A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no

					-----------------------------------------------------------------------------------------------
					-- 수정후 금액 = 수정된 총 금액 * 원래 개별 금액 / 원래 총금액  
					-----------------------------------------------------------------------------------------------
					IF EXISTS (	SELECT A.DIVISION_ID
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO
								 AND A.DIVISION_ID 		= B.DIVISION_ID
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID
								 AND A.MEASURE 			= B.MEASURE
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE 		= 'SalesAmt_KRW'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A015: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = CASE WHEN @OriQty  <> 0 THEN ROUND(@ADjQty * A.Qty/@OriQty , 0)
									   ELSE ROUND(@AdjQty / @QtyCnt, 0)
								  END
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_KRW'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						-----------------------------------------------------------------------------------------------
						--나머지 배부
						-----------------------------------------------------------------------------------------------
						SELECT @rest = @AdjQty - SUM(A.Qty)
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.Measure 			= B.Measure
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_KRW'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						IF @Rest <> 0
						BEGIN
PRINT @v_program_name + ' / A016: ' + CONVERT(VARCHAR(30), GETDATE(), 121);							
							UPDATE A
							SET QTY = A.QTY + @rest
							  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							FROM DM_PLN_SALES_PLAN_REPORT_C A
							JOIN #results_MST B 
							  ON A.VERSION_NO 		= B.VERSION_NO
							 AND A.DIVISION_ID 		= B.DIVISION_ID
							 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
							 AND A.DEPT_ID 			= B.DEPT_ID
							 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
							 AND A.CUST_REPORT 		= B.CUST_REPORT
							 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE 	= B.PROJECT_CODE
							 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
							 AND A.ITEM_ID 			= B.ITEM_ID
							 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
							 AND A.CURRENCY 		= B.CURRENCY
							 AND A.COMPANY_ID 		= B.COMPANY_ID
							 AND A.MEASURE 			= B.MEASURE
							 AND B.SEQ_RANK 		= @i
							 AND A.YYYYMMDD 		= @MinDate
							WHERE A.MEASURE 		= 'SalesAmt_KRW'
							AND  A.DIVISION_ID 		= @v_division_id
							AND  A.VERSION_NO 		= @v_version_no
						END
					END
					ELSE	
					-----------------------------------------------------------------------------------------------
					-- 원래 SalesAmt_KRW 메저가 없었던 경우
					-----------------------------------------------------------------------------------------------
					BEGIN
PRINT @v_program_name + ' / A017: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							 , A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
							 , A.CURRENCY, B.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
							 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
							 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND B.MEASURE 			= 'SalesAmt_KRW'
						 AND B.SEQ_RANK 		= @i
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
				END

				-----------------------------------------------------------------------------------------------
				-- 금액처리_SalesAmt_USD
				-----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT * FROM #results_MST A
							WHERE SEQ_RANK 	= @i
							AND   MEASURE 	= N'SalesAmt_USD')
				BEGIN
PRINT @v_program_name + ' / A018: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
					SELECT @AdjQty  = Qty
					FROM #results_MST
					WHERE SEQ_RANK = @i
					AND   MEASURE = N'SalesAmt_USD'

					-----------------------------------------------------------------------------------------------
					-- 수정전 금액 합계, 건수 계산
					-----------------------------------------------------------------------------------------------
					SELECT @OriQty = SUM(A.QTY)
						 , @QtyCnt = COUNT(*)
						 , @MinDate = MIN(A.YYYYMMDD)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID
					 AND A.MEASURE 			= B.Measure
					 AND B.SEQ_RANK 		= @i
					WHERE A.MEASURE 		= 'SalesAmt_USD'
					AND   A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no

					-----------------------------------------------------------------------------------------------
					-- 수정후 금액 = 수정된 총 금액 * 원래 개별 금액 / 원래 총금액  					
					-----------------------------------------------------------------------------------------------
					IF EXISTS (	SELECT A.DIVISION_ID
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO
								 AND A.DIVISION_ID 		= B.DIVISION_ID
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID
								 AND A.MEASURE 			= B.MEASURE
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE			= 'SalesAmt_USD'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A019: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = CASE WHEN @OriQty  <> 0 THEN ROUND(@ADjQty * A.Qty/@OriQty , 0)
									   ELSE ROUND(@AdjQty / @QtyCnt, 0)
								  END
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.Measure 			= B.Measure
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_USD'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						-----------------------------------------------------------------------------------------------
						--나머지 배부
						-----------------------------------------------------------------------------------------------
						SELECT @rest = @AdjQty - SUM(A.Qty)
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND A.MEASURE 			= B.MEASURE
						 AND B.SEQ_RANK 		= @i
						WHERE A.MEASURE 		= 'SalesAmt_USD'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no

						IF @Rest <> 0
						BEGIN			
PRINT @v_program_name + ' / A020: ' + CONVERT(VARCHAR(30), GETDATE(), 121);				
							UPDATE A
							SET QTY = A.QTY + @rest
							  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
							FROM DM_PLN_SALES_PLAN_REPORT_C A
							JOIN #results_MST B 
							  ON A.VERSION_NO 		= B.VERSION_NO
							 AND A.DIVISION_ID 		= B.DIVISION_ID
							 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
							 AND A.DEPT_ID 			= B.DEPT_ID
							 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
							 AND A.CUST_REPORT 		= B.CUST_REPORT
							 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE 	= B.PROJECT_CODE
							 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
							 AND A.ITEM_ID 			= B.ITEM_ID
							 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
							 AND A.CURRENCY 		= B.CURRENCY
							 AND A.COMPANY_ID 		= B.COMPANY_ID
							 AND A.Measure 			= B.Measure
							 AND B.SEQ_RANK 		= @i
							 AND A.YYYYMMDD 		= @MinDate
							WHERE A.MEASURE 		= 'SalesAmt_USD'
							AND   A.DIVISION_ID 	= @v_division_id
							AND   A.VERSION_NO 		= @v_version_no
						END
					END
					ELSE	
					-----------------------------------------------------------------------------------------------
					-- 원래 SalesAmt_USD 메저가 없었던 경우
					-----------------------------------------------------------------------------------------------
					BEGIN
PRINT @v_program_name + ' / A021: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
							 , A.FCST_TYPE, A.INCOTERMS, 'SalesAmt_USD' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
							 , A.CURRENCY, B.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
							 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
							 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%'
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID
						 AND B.MEASURE 			= 'SalesAmt_USD'
						 AND B.SEQ_RANK 		= @i
						WHERE A.Division_id 	= @v_division_id
						AND   A.Version_no 		= @v_version_no
					END
				END
					
				--====================================================================================================================================================
				--여기부터는 구간 일괄 업데이트
				--====================================================================================================================================================

				IF @v_plan_yn = 'Y'
				-----------------------------------------------------------------------------------------------
				-- 계획구간은 금액을 업데이트함 ( LOC )
				-----------------------------------------------------------------------------------------------
				BEGIN				
PRINT @v_program_name + ' / A022: ' + CONVERT(VARCHAR(30), GETDATE(), 121);							
					IF EXISTS (	SELECT 1
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO 
								 AND A.DIVISION_ID 		= B.DIVISION_ID 
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID 
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID 
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID 
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE 		= 'SalesAmt_LOC'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A023: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = C.QTY * D.QTY
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO 
						 AND A.DIVISION_ID 		= B.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID 
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID 
						 AND B.SEQ_RANK = @i
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID		= C.DIVISION_ID									
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID 
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD 		= C.YYYYMMDD
						 AND A.CURRENCY 		= C.CURRENCY 
						 AND A.COMPANY_ID 		= C.COMPANY_ID 
						 AND C.MEASURE IN ( N'RTF', N'RTF_SYS_RP')
						JOIN DM_PLN_SALES_PLAN_REPORT_C D WITH(NOLOCK)
						  ON A.VERSION_NO 		= D.VERSION_NO 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= D.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= D.DEPT_ID 
						 AND A.END_CUST_REPORT 	= D.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= D.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= D.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= D.PROJECT_CODE 
						 AND A.SCM_SITE_ID 		= D.SCM_SITE_ID
						 AND A.ITEM_ID 			= D.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= D.CURRENCY 
						 AND A.COMPANY_ID 		= D.COMPANY_ID
						 AND D.MEASURE 			= 'LOC'
						WHERE A.MEASURE 		= 'SalesAmt_LOC'
						AND A.DIVISION_ID 		= @v_division_id
						AND A.VERSION_NO 		= @v_version_no
					END
					ELSE
					BEGIN
PRINT @v_program_name + ' / A024: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						-----------------------------------------------------------------------------------------------				
						-- SalesAmt_LOC				
						-----------------------------------------------------------------------------------------------
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD
							 , C.DEPARTMENT_ID, C.DEPARTMENT_NAME, C.DEPT_ID, C.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, C.DOM_EXP
							 , C.FCST_TYPE, C.INCOTERMS, 'SalesAmt_LOC' AS MEASURE, '' AS PLANT_SITE_ID, A.YYYYMMDD
							 , A.CURRENCY, SUM(C.QTY) * MAX(D.QTY) AS QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4
							 , C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9
							 , C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME
							 , C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL
							 , C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
							 , C.COUNTRY_KR_NAME, C.ROUTE, C.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM #results_MST A
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID 		= C.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID 
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE 
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(C.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= C.CURRENCY 
						 AND A.COMPANY_ID 		= C.COMPANY_ID 
						 AND C.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
						JOIN DM_PLN_SALES_PLAN_REPORT_C D WITH(NOLOCK)
						  ON A.VERSION_NO 		= D.VERSION_NO 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= D.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= D.DEPT_ID
						 AND A.END_CUST_REPORT 	= D.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= D.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= D.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= D.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= D.SCM_SITE_ID 
						 AND A.ITEM_ID 			= D.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= D.CURRENCY
						 AND A.COMPANY_ID 		= D.COMPANY_ID 
						 AND D.MEASURE 			= 'LOC'
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
						AND   A.SEQ_RANK 		= @i
						GROUP BY A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD, C.DEPARTMENT_ID
							   , C.DEPARTMENT_NAME, C.DEPT_ID, C.DEPT_NAME, A.END_CUST_REPORT, A.CUST_REPORT
							   , A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, C.DOM_EXP, C.FCST_TYPE
							   , C.INCOTERMS, A.YYYYMMDD, A.CURRENCY, C.ATTRIBUTE1, C.ATTRIBUTE2
							   , C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7
							   , C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE
							   , C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC
							   , C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME
							   , C.APPLICATION, C.APPLICATION_GR, C.COUNTRY_KR_NAME, C.ROUTE
					END
					
					-----------------------------------------------------------------------------------------------	
					-- 계획구간은 금액을 업데이트함 ( KRW )
					-----------------------------------------------------------------------------------------------	
					IF EXISTS (	SELECT 1
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO 
								 AND A.DIVISION_ID 		= B.DIVISION_ID 
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID 
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID 
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID 
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE 		= 'SalesAmt_KRW'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A025: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						UPDATE A
						SET QTY = ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO 
						 AND A.DIVISION_ID 		= B.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID 
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID 
						 AND B.SEQ_RANK 		= @i
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID 		= C.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD 		= C.YYYYMMDD 
						 AND A.CURRENCY 		= C.CURRENCY
						 AND A.COMPANY_ID		= C.COMPANY_ID 
						 AND C.MEASURE 			= 'SalesAmt_LOC'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
						  ON D.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%'
						 AND D.CURRENCY 		= N'KRW' 
						 AND D.UNIT_CURRENCY 	= A.CURRENCY
						WHERE A.MEASURE 		= 'SalesAmt_KRW'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
					ELSE
					BEGIN			
						-----------------------------------------------------------------------------------------------	
						-- 계획구간은 금액을 업데이트함 ( SalesAmt_KRW )
						-----------------------------------------------------------------------------------------------
PRINT @v_program_name + ' / A026: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
						, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
						, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
						, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
						, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
						, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
						, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD
							 , C.DEPARTMENT_ID, C.DEPARTMENT_NAME, C.DEPT_ID, C.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, C.DOM_EXP
							 , C.FCST_TYPE, C.INCOTERMS, 'SalesAmt_KRW' AS MEASURE, '' AS PLANT_SITE_ID, A.YYYYMMDD
							 , A.CURRENCY, ROUND(C.QTY * D.EXCHANGE_PRICE, 0) AS QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
							 , GETDATE() AS LAST_UPDATE_DATE, C.ATTRIBUTE1, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4
							 , C.ATTRIBUTE5, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9
							 , C.ATTRIBUTE10, C.COMPANY_ID, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME
							 , C.CUST_GROUP_DTL, C.PRODUCT_DETAILS, C.FORECAST_INFO_SPEC, C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL
							 , C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR
							 , C.COUNTRY_KR_NAME, C.ROUTE, C.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM #results_MST A
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID 		= C.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(C.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= C.CURRENCY
						 AND A.COMPANY_ID 		= C.COMPANY_ID 
						 AND C.MEASURE 			= 'SalesAmt_LOC'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
						  ON D.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%'
						 AND D.CURRENCY 		= N'KRW' 
						 AND D.UNIT_CURRENCY 	= A.CURRENCY
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
						AND   A.SEQ_RANK 		= @i
					END				
					-----------------------------------------------------------------------------------------------		
					-- 계획구간은 금액을 업데이트함 ( USD )
					-----------------------------------------------------------------------------------------------	
					IF EXISTS (	SELECT 1
								FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
								JOIN #results_MST B 
								  ON A.VERSION_NO 		= B.VERSION_NO 
								 AND A.DIVISION_ID 		= B.DIVISION_ID 
								 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
								 AND A.DEPT_ID 			= B.DEPT_ID 
								 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
								 AND A.CUST_REPORT 		= B.CUST_REPORT
								 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
								 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
								 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
								 AND A.ITEM_ID 			= B.ITEM_ID 
								 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
								 AND A.CURRENCY 		= B.CURRENCY
								 AND A.COMPANY_ID 		= B.COMPANY_ID 
								 AND B.SEQ_RANK 		= @i
								WHERE A.MEASURE 		= 'SalesAmt_USD'
								AND   A.DIVISION_ID 	= @v_division_id
								AND   A.VERSION_NO 		= @v_version_no	)
					BEGIN
PRINT @v_program_name + ' / A027: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
						UPDATE A
						SET QTY = CASE WHEN ISNULL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE/E.EXCHANGE_PRICE, 0)
									   ELSE 0 
								  END
						  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
						FROM DM_PLN_SALES_PLAN_REPORT_C A
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO 
						 AND A.DIVISION_ID 		= B.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID 
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= B.CURRENCY
						 AND A.COMPANY_ID 		= B.COMPANY_ID 
						 AND B.SEQ_RANK 		= @i
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID 		= C.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD 		= C.YYYYMMDD 
						 AND A.CURRENCY 		= C.CURRENCY
						 AND A.COMPANY_ID 		= C.COMPANY_ID 
						 AND C.MEASURE 			= 'SalesAmt_LOC'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
						  ON D.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%'
						 AND D.CURRENCY 		= N'KRW' 
						 AND D.UNIT_CURRENCY 	= N'USD'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C E WITH(NOLOCK)
						  ON E.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= E.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(E.YYYYMMDD, 6) + '%'
						 AND E.CURRENCY 		= N'KRW' 
						 AND E.UNIT_CURRENCY 	= A.CURRENCY
						WHERE A.MEASURE 		= 'SalesAmt_USD'
						AND   A.DIVISION_ID 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
					END
					ELSE
					BEGIN
PRINT @v_program_name + ' / A028: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
						INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
						( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
						, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
						, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
						, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
						, CURRENCY
						, QTY
						, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
						, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
						, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
						, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
						, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE
						, COMPANY_NAME, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
						, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, C.CUTOFF_YYYYMMDD
							 , C.DEPARTMENT_ID, C.DEPARTMENT_NAME, C.DEPT_ID, C.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, C.DOM_EXP
							 , C.FCST_TYPE, C.INCOTERMS, 'SalesAmt_USD' AS MEASURE, '' AS PLANT_SITE_ID, A.YYYYMMDD
							 , A.CURRENCY
							 , CASE WHEN ISNULL(E.EXCHANGE_PRICE,0) <> 0 THEN ROUND(C.QTY * D.EXCHANGE_PRICE/E.EXCHANGE_PRICE, 0)
									ELSE 0 
							   END AS QTY
							, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, C.ATTRIBUTE1
							, C.ATTRIBUTE2, C.ATTRIBUTE3, C.ATTRIBUTE4, C.ATTRIBUTE5, C.ATTRIBUTE6
							, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE10, C.COMPANY_ID
							, C.PROJECT_CODE, C.SOLDTO_CUST_REPORT, C.OWNER_NAME, C.CUST_GROUP_DTL, C.PRODUCT_DETAILS
							, C.FORECAST_INFO_SPEC, C.NICK_NAME, C.FORECAST_INFO_CELL_MODEL, C.FORECAST_INFO_CELL_PACK_COUNT, C.FORECAST_INFO_BIZ_TYPE
							, C.COMPANY_NAME, C.APPLICATION, C.APPLICATION_GR, C.COUNTRY_KR_NAME, C.ROUTE
							, C.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM #results_MST A
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO 
						 AND A.DIVISION_ID 		= C.DIVISION_ID 
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID 
						 AND A.DEPT_ID 			= C.DEPT_ID
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
						 AND A.CUST_REPORT 		= C.CUST_REPORT 
						 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID 
						 AND A.ITEM_ID 			= C.ITEM_ID 
						 AND A.YYYYMMDD LIKE LEFT(C.YYYYMMDD, 6) + '%' 
						 AND A.CURRENCY 		= C.CURRENCY
						 AND A.COMPANY_ID 		= C.COMPANY_ID 
						 AND C.MEASURE 			= 'SalesAmt_LOC'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
						  ON D.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= D.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(D.YYYYMMDD, 6) + '%'
						 AND D.CURRENCY 		= N'KRW' 
						 AND D.UNIT_CURRENCY 	= N'USD'
						JOIN DM_PLN_SALES_REPORT_EXCHANGE_C E WITH(NOLOCK)
						  ON E.VERSION_NO 		= @v_version_no 
						 AND A.DIVISION_ID 		= E.DIVISION_ID 
						 AND A.YYYYMMDD LIKE LEFT(E.YYYYMMDD, 6) + '%'
						 AND E.CURRENCY 		= N'KRW' 
						 AND E.UNIT_CURRENCY 	= A.CURRENCY
						WHERE A.Division_id 	= @v_division_id
						AND   A.VERSION_NO 		= @v_version_no
						AND   A.SEQ_RANK 		= @i	
					END
				END
				ELSE 				
				-----------------------------------------------------------------------------------------------	
				-- 실적구간은 단가를 업데이트
				-----------------------------------------------------------------------------------------------	
				BEGIN
PRINT @v_program_name + ' / A029: ' + CONVERT(VARCHAR(30), GETDATE(), 121);				
				-----------------------------------------------------------------------------------------------
				-- SalesAmt_LOC 를 Qty 로 나눠서 단가를 계산한다. ( 본테이블에서 LOC 를 지우고, 다시 계산해서 INSERT 한다. )
				-----------------------------------------------------------------------------------------------
					-----------------------------------------------------------------------------------------------
					-- INSERT 할 날짜				
					-----------------------------------------------------------------------------------------------		
					SELECT TOP 1 @v_yyyymmdd = YYYYMMDD
					FROM  #results_MST A
					WHERE SEQ_RANK = @I

					SET @v_yyyymmdd = LEFT(@v_yyyymmdd, 6) + '01'

					-----------------------------------------------------------------------------------------------
					-- 삭제
					-----------------------------------------------------------------------------------------------
					DELETE A
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID 
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID 
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID 
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID 
					 AND B.SEQ_RANK 		= @i 
					 AND A.MEASURE 			= 'LOC'

					-----------------------------------------------------------------------------------------------
					-- INSERT
					-----------------------------------------------------------------------------------------------
					SELECT @v_loc_salesamt_loc = SUM(A.QTY)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID 
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID 
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID 
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID 
					 AND B.SEQ_RANK 		= @i 
					 AND B.SEQ_ROWNUM 		= 1
					 AND A.MEASURE 			= 'SalesAmt_LOC'
					 
					SELECT @v_loc_rtf = SUM(A.QTY)
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID 
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID 
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID 
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%' 
					 AND A.CURRENCY			= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID 
					 AND B.SEQ_RANK 		= @i 
					 AND B.SEQ_ROWNUM 		= 1
					 AND A.MEASURE IN ( N'RTF', N'RTF_SYS_RP' )
					 
					INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
					( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
					, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
					, CURRENCY, QTY
					, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
					, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
					, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
					, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS
					, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE
					, COMPANY_NAME, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE
					, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
						 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						 , A.FCST_TYPE, A.INCOTERMS, 'LOC' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
						 , A.CURRENCY, CASE WHEN ISNULL(@v_loc_rtf, 0) <> 0 THEN ROUND(@v_loc_salesamt_loc/@v_loc_rtf, 3) ELSE 0 END AS QTY
						 , @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1
						 , A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
						 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
						 , A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS
						 , A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE
						 , A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE
						 , A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO 
					 AND A.DIVISION_ID 		= B.DIVISION_ID 
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID 
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID 
					 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 4) + '%' 
					 AND A.CURRENCY 		= B.CURRENCY
					 AND A.COMPANY_ID 		= B.COMPANY_ID 
					 AND B.SEQ_RANK 		= @i 
					 AND B.SEQ_ROWNUM 		= 1
					WHERE A.DIVISION_ID		= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no							
				END
					

			SET @i = @i + 1
			END
		END
		ELSE			
		-----------------------------------------------------------------------------------------------
		-- 자동차 ESS ( 데이터는 1일자에만 들어있고, 수정은 계획구간의 LOC 만 가능, 자동차는 Product_group 을 조건에서 제외함 )
		-----------------------------------------------------------------------------------------------
		BEGIN					
			WHILE ( @i <= @Cnt )
			BEGIN				
PRINT @v_program_name + ' / A030: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
			-----------------------------------------------------------------------------------------------
			-- LOC 가 있으면 업데이트, 없으면 인서트
			-----------------------------------------------------------------------------------------------
				IF EXISTS ( SELECT 1
							FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
							JOIN #results_MST B 
							  ON A.VERSION_NO 		= B.VERSION_NO
							 AND A.DIVISION_ID 		= B.DIVISION_ID
							 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
							 AND A.DEPT_ID 			= B.DEPT_ID
							 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
							 AND A.CUST_REPORT 		= B.CUST_REPORT
							 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
							 AND A.PROJECT_CODE 	= B.PROJECT_CODE
							 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
							 AND A.ITEM_ID 			= B.ITEM_ID
							 AND A.YYYYMMDD 		= B.YYYYMMDD
							 AND A.CURRENCY 		= B.CURRENCY
							 --AND A.COMPANY_ID 		= B.COMPANY_ID
							 AND A.MEASURE 			= B.MEASURE
							 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
							 AND A.INCOTERMS 		= B.INCOTERMS
							 AND B.SEQ_RANK 		= @i
							WHERE A.MEASURE 		= 'LOC'
							AND   A.DIVISION_ID 	= @v_division_id
							AND   A.VERSION_NO 		= @v_version_no	)
				BEGIN
PRINT @v_program_name + ' / A031: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
				-----------------------------------------------------------------------------------------------					
				-- 1. LOC 메저를 업데이트 한다.
				-----------------------------------------------------------------------------------------------
					UPDATE A
					SET QTY = B.QTY
					  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
					  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
					FROM DM_PLN_SALES_PLAN_REPORT_C A
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID
					 AND A.YYYYMMDD 		= B.YYYYMMDD
					 AND A.CURRENCY		 	= B.CURRENCY
					 --AND A.COMPANY_ID 		= B.COMPANY_ID
					 AND A.Measure 			= B.Measure
					 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
					 AND A.INCOTERMS 		= B.INCOTERMS
					 AND B.SEQ_RANK 		= @i
					WHERE A.MEASURE 		= 'LOC'
					AND   A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no								
				END
				ELSE
				BEGIN
PRINT @v_program_name + ' / A032: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
					INSERT INTO DM_PLN_SALES_PLAN_REPORT_C 
					( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID, DOM_EXP
					, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
					, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
					, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
					, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
					, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
					, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
					, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
					, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					SELECT TOP 1 '1' AS DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
						 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
						 , A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
						 , A.FCST_TYPE, A.INCOTERMS, 'LOC' AS MEASURE, '' AS PLANT_SITE_ID, B.YYYYMMDD
						 , A.CURRENCY, B.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY
						 , GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4
						 , A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9
						 , A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
						 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
						 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
						 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
					FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
					JOIN #results_MST B 
					  ON A.VERSION_NO 		= B.VERSION_NO
					 AND A.DIVISION_ID 		= B.DIVISION_ID
					 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
					 AND A.DEPT_ID 			= B.DEPT_ID
					 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
					 AND A.CUST_REPORT 		= B.CUST_REPORT
					 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
					 AND A.PROJECT_CODE 	= B.PROJECT_CODE
					 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
					 AND A.ITEM_ID 			= B.ITEM_ID
					 AND A.CURRENCY 		= B.CURRENCY
					 --AND A.COMPANY_ID 		= B.COMPANY_ID
					 --AND A.MEASURE 			= B.MEASURE
					 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
					 AND A.INCOTERMS 		= B.INCOTERMS
					 AND B.MEASURE 			= 'LOC'
					 AND B.SEQ_RANK 		= @i
					WHERE A.DIVISION_ID 	= @v_division_id
					AND   A.VERSION_NO 		= @v_version_no
				END
				
PRINT @v_program_name + ' / A033: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
				-----------------------------------------------------------------------------------------------		
				-- 2. 기타 금액메저 모두 삭제
				-----------------------------------------------------------------------------------------------		
				DELETE A
				FROM DM_PLN_SALES_PLAN_REPORT_C A
				JOIN #results_MST B 
				  ON A.VERSION_NO 		= B.VERSION_NO
				 AND A.DIVISION_ID 		= B.DIVISION_ID
				 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
				 AND A.DEPT_ID 			= B.DEPT_ID
				 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
				 AND A.CUST_REPORT 		= B.CUST_REPORT
				 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
				 AND A.PROJECT_CODE 	= B.PROJECT_CODE
				 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
				 AND A.ITEM_ID 			= B.ITEM_ID
				 AND A.YYYYMMDD 		= B.YYYYMMDD
				 AND A.CURRENCY 		= B.CURRENCY
				 --AND A.COMPANY_ID 		= B.COMPANY_ID						
				 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
				 AND A.INCOTERMS		= B.INCOTERMS
				 AND B.SEQ_RANK 		= @i
				WHERE ( A.MEASURE IN ( 'KRW','USD' ) OR A.MEASURE LIKE 'SalesAmt%')
				AND 	A.Division_id 	= @v_division_id
				AND 	A.Version_no 	= @v_version_no

				-----------------------------------------------------------------------------------------------	
				-- 3. KRW, USD 메저 업데이트 또는 생성
				-----------------------------------------------------------------------------------------------		
PRINT @v_program_name + ' / A034: ' + CONVERT(VARCHAR(30), GETDATE(), 121);						
				-----------------------------------------------------------------------------------------------		
				-- KRW
				-----------------------------------------------------------------------------------------------		
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
					 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
					 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
					 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
					 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
					 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
					 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
					 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
					 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME
					 , CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
					 , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
					 , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, N'KRW' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY, A.QTY * EX.EXCHANGE_PRICE AS QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
					 , @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
					 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
					 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
					 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (  SELECT DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, A.QTY
							 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
							 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
							 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
							 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
							 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
							 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD 		= B.YYYYMMDD
						 AND A.CURRENCY 		= B.CURRENCY
						 --AND A.COMPANY_ID 		= B.COMPANY_ID
						 --AND A.MEASURE 			= B.MEASURE
						 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
						 AND A.INCOTERMS 		= B.INCOTERMS
						 AND B.SEQ_RANK 		= @i 
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.MEASURE 		= 'LOC'
						AND   A.VERSION_NO 		= @v_version_no	) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX WITH(NOLOCK)
				  ON A.DIVISION_ID 		= EX.DIVISION_ID 
				 AND A.VERSION_NO 		= EX.VERSION_NO 
				 AND A.CUTOFF_TYPE 		= EX.CUTOFF_TYPE 
				 AND A.CUTOFF_YYYYMMDD 	= EX.CUTOFF_YYYYMMDD 
				 AND EX.CURRENCY 		= 'KRW' 
				 AND A.CURRENCY 		= EX.UNIT_CURRENCY 
				 AND A.YYYYMMDD 		= EX.YYYYMMDD 
				 AND EX.VERSION_NO 		= @v_version_no

PRINT @v_program_name + ' / A035: ' + CONVERT(VARCHAR(30), GETDATE(), 121);						
				-----------------------------------------------------------------------------------------------		
				-- USD
				-----------------------------------------------------------------------------------------------	
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				, CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				, YYYYMMDD, CURRENCY
				, QTY
				, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1
				, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID
				, SOLDTO_CUST_REPORT, OWNER_NAME, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC
				, NICK_NAME, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME
				, APPLICATION, APPLICATION_GR, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, N'USD' AS MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY
					 , CASE WHEN ISNULL(EX.EXCHANGE_PRICE, 0) <> 0 THEN ROUND( A.QTY / EX.EXCHANGE_PRICE, 3)
							ELSE 0 END AS QTY
					 , @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1
					 , A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
					 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID
					 , A.SOLDTO_CUST_REPORT, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC
					 , A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME
					 , A.APPLICATION, A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (	SELECT DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							, A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
							, A.YYYYMMDD, A.CURRENCY, A.QTY, A.ATTRIBUTE1, A.ATTRIBUTE2
							, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7
							, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							, A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
							, A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
							, A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD 		= B.YYYYMMDD
						 AND A.CURRENCY 		= B.CURRENCY
						 --AND A.COMPANY_ID 		= B.COMPANY_ID
						 --AND A.MEASURE 			= B.MEASURE
						 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
						 AND A.INCOTERMS 		= B.INCOTERMS
						 AND B.SEQ_RANK 		= @i 
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.MEASURE 		= 'KRW'
						AND   A.VERSION_NO 		= @v_version_no	) A
				JOIN DM_PLN_SALES_REPORT_EXCHANGE_C EX WITH(NOLOCK)
				  ON A.DIVISION_ID 		= EX.DIVISION_ID 
				 AND A.VERSION_NO 		= EX.VERSION_NO 
				 AND A.CUTOFF_TYPE 		= EX.CUTOFF_TYPE 
				 AND A.CUTOFF_YYYYMMDD 	= EX.CUTOFF_YYYYMMDD 
				 AND EX.CURRENCY 		= 'KRW' 
				 AND EX.UNIT_CURRENCY 	= 'USD'
				 AND A.YYYYMMDD 		= EX.YYYYMMDD 
				 AND EX.VERSION_NO 		= @v_version_no

PRINT @v_program_name + ' / A036: ' + CONVERT(VARCHAR(30), GETDATE(), 121);			
				-----------------------------------------------------------------------------------------------		
				-- 4. SalesAmt_LOC, KRW, USD 업데이트 또는 생성
				-----------------------------------------------------------------------------------------------	
				-----------------------------------------------------------------------------------------------	
				-- KRW				
				-----------------------------------------------------------------------------------------------		
				INSERT INTO DM_PLN_SALES_PLAN_REPORT_C
				 ( DATA_TYPE, DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
				 , DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME, END_CUST_REPORT
				 , CUST_REPORT, PRODUCT_GROUP, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
				 , DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				 , YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE
				 , LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
				 , ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
				 , ATTRIBUTE9, ATTRIBUTE10, COMPANY_ID, SOLDTO_CUST_REPORT, OWNER_NAME
				 , CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
				 , FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
				 , COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )--[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
					 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
					 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
					 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
					 , A.YYYYMMDD, A.CURRENCY, A.QTY, @v_created_by AS CREATED_BY, GETDATE() AS CREATION_DATE
					 , @v_created_by AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
					 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
					 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.SOLDTO_CUST_REPORT, A.OWNER_NAME
					 , A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME, A.FORECAST_INFO_CELL_MODEL
					 , A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION, A.APPLICATION_GR
					 , A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
				FROM (	SELECT A.DATA_TYPE, A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
							 , A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME, A.END_CUST_REPORT
							 , A.CUST_REPORT, A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
							 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, N'SalesAmt_' + C.MEASURE AS MEASURE, A.PLANT_SITE_ID
							 , A.YYYYMMDD, A.CURRENCY, ROUND(A.QTY * C.QTY, 3) AS QTY, A.ATTRIBUTE1, A.ATTRIBUTE2
							 , A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7
							 , A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.SOLDTO_CUST_REPORT
							 , A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
							 , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
							 , A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE --[E20240429-000397]_[공급 SCM PI팀] Sales Report화면 Cell Prod Site(셀 생산지) 칼럼 추가요청
						FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
						JOIN #results_MST B 
						  ON A.VERSION_NO 		= B.VERSION_NO
						 AND A.DIVISION_ID 		= B.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
						 AND A.DEPT_ID 			= B.DEPT_ID
						 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
						 AND A.CUST_REPORT 		= B.CUST_REPORT
						 --AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= B.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
						 AND A.ITEM_ID 			= B.ITEM_ID
						 AND A.YYYYMMDD 		= B.YYYYMMDD
						 AND A.CURRENCY 		= B.CURRENCY
						 --AND A.COMPANY_ID 		= B.COMPANY_ID
						 --AND A.MEASURE 			= B.MEASURE
						 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE A.FCST_TYPE END
						 AND A.INCOTERMS 		= B.INCOTERMS
						 AND B.SEQ_RANK 		= @i 
						JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
						  ON A.VERSION_NO 		= C.VERSION_NO
						 AND A.DIVISION_ID 		= C.DIVISION_ID
						 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
						 AND A.DEPT_ID 			= C.DEPT_ID
						 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
						 AND A.CUST_REPORT 		= C.CUST_REPORT
						 --AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP
						 AND A.PROJECT_CODE 	= C.PROJECT_CODE
						 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
						 AND A.ITEM_ID 			= C.ITEM_ID
						 AND A.YYYYMMDD 		= C.YYYYMMDD
						 AND A.CURRENCY 		= C.CURRENCY
						 --AND A.COMPANY_ID 		= C.COMPANY_ID
						 --AND A.MEASURE 			= C.MEASURE
						 AND A.FCST_TYPE 		= CASE WHEN @v_division_id LIKE '81%' THEN B.FCST_TYPE ELSE C.FCST_TYPE END
						 AND A.INCOTERMS 		= C.INCOTERMS
						 AND C.MEASURE IN ( 'LOC', 'USD', 'KRW' )
						WHERE A.DIVISION_ID 	= @v_division_id
						AND   A.MEASURE 		= CASE WHEN @v_division_id LIKE '81%' THEN 'RTF_SYS_RP' ELSE 'RTF' END
						AND   A.VERSION_NO 		= @v_version_no	) A						
				SET @I = @I + 1
			END
		END
	END
	--=============================================================================================
	--DM_PLN_SALES_PLAN_REPORT_C 테이블 UPDATE, INSERT (END)
	--=============================================================================================	
	--=============================================================================================
	--BP인 경우 (START)
	--=============================================================================================
	ELSE 
	--[C20201005-000291] BP 부분을 루프에서 원쿼리로 변경함.
	BEGIN
PRINT @v_program_name + ' / A037: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
		-----------------------------------------------------------------------------------------------
		-- 단가 변경이 있을 경우 LOC, KRW, USD 를 같이 변경함	
		-----------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT * FROM #results_MST A
					WHERE measure = 'LOC' )
		BEGIN
PRINT @v_program_name + ' / A038: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
			-----------------------------------------------------------------------------------------------
			-- LOC
			-----------------------------------------------------------------------------------------------
			UPDATE A
			SET QTY = B.QTY
			  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			JOIN #results_MST B 
			  ON A.VERSION_NO 		= B.VERSION_NO
			 AND A.DIVISION_ID 		= B.DIVISION_ID
			 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
			 AND A.DEPT_ID 			= B.DEPT_ID
			 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
			 AND A.CUST_REPORT 		= B.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
			 AND A.PROJECT_CODE 	= B.PROJECT_CODE
			 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
			 AND A.ITEM_ID 			= B.ITEM_ID
			 AND A.YYYYMMDD 		= B.YYYYMMDD
			 AND A.CURRENCY 		= B.CURRENCY
			 AND A.COMPANY_ID 		= B.COMPANY_ID
			 AND A.MEASURE 			= B.MEASURE
			WHERE A.MEASURE 		= 'LOC'
			AND   A.Division_id 	= @v_division_id
			AND   A.Version_no 		= @v_version_no

PRINT @v_program_name + ' / A039: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
			-----------------------------------------------------------------------------------------------
			-- KRW
			-----------------------------------------------------------------------------------------------
			UPDATE A
			SET QTY = ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
			  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			JOIN #results_MST B 
			  ON A.VERSION_NO 		= B.VERSION_NO 
			 AND A.DIVISION_ID 		= B.DIVISION_ID 
			 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
			 AND A.DEPT_ID 			= B.DEPT_ID 
			 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
			 AND A.CUST_REPORT 		= B.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
			 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
			 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
			 AND A.ITEM_ID 			= B.ITEM_ID 
			 AND A.YYYYMMDD 		= B.YYYYMMDD 	
			 AND A.CURRENCY 		= B.CURRENCY
			 AND A.COMPANY_ID 		= B.COMPANY_ID 
			 AND B.MEASURE 			= 'LOC'
			JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
			  ON A.VERSION_NO 		= C.VERSION_NO
			 AND A.DIVISION_ID 		= C.DIVISION_ID
			 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
			 AND A.DEPT_ID 			= C.DEPT_ID
			 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
			 AND A.CUST_REPORT 		= C.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP
			 AND A.PROJECT_CODE 	= C.PROJECT_CODE
			 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
			 AND A.ITEM_ID 			= C.ITEM_ID
			 AND A.YYYYMMDD 		= C.YYYYMMDD
			 AND A.CURRENCY 		= C.CURRENCY
			 AND A.COMPANY_ID 		= C.COMPANY_ID
			 AND C.MEASURE 			= 'LOC'
			JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
			  ON D.VERSION_NO 		= @v_version_no
			 AND A.DIVISION_ID 		= D.DIVISION_ID
			 AND A.YYYYMMDD 		= D.YYYYMMDD
			 AND D.CURRENCY 		= N'KRW'
			 AND D.UNIT_CURRENCY 	= A.CURRENCY
			WHERE A.MEASURE 		= 'KRW'
			AND   A.DIVISION_ID 	= @v_division_id
			AND   A.VERSION_NO 		= @v_version_no

PRINT @v_program_name + ' / A040: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
			-----------------------------------------------------------------------------------------------
			-- USD	
			-----------------------------------------------------------------------------------------------					
			UPDATE A
			SET QTY = ROUND( CASE WHEN ISNULL(D.EXCHANGE_PRICE,0) = 0 THEN 0
								  ELSE C.QTY/ISNULL(D.EXCHANGE_PRICE,0)
							 END, 0)
			  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			JOIN #results_MST B 
			  ON A.VERSION_NO 		= B.VERSION_NO 
			 AND A.DIVISION_ID 		= B.DIVISION_ID 
			 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
			 AND A.DEPT_ID 			= B.DEPT_ID 
			 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
			 AND A.CUST_REPORT 		= B.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
			 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
			 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
			 AND A.ITEM_ID 			= B.ITEM_ID 
			 AND A.YYYYMMDD 		= B.YYYYMMDD 
			 AND A.CURRENCY 		= B.CURRENCY
			 AND A.COMPANY_ID 		= B.COMPANY_ID 
			 AND B.MEASURE 			= 'USD'
			JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
			  ON A.VERSION_NO 		= C.VERSION_NO
			 AND A.DIVISION_ID 		= C.DIVISION_ID
			 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
			 AND A.DEPT_ID 			= C.DEPT_ID
			 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
			 AND A.CUST_REPORT 		= C.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP
			 AND A.PROJECT_CODE 	= C.PROJECT_CODE
			 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
			 AND A.ITEM_ID 			= C.ITEM_ID
			 AND A.YYYYMMDD 		= C.YYYYMMDD
			 AND A.CURRENCY 		= C.CURRENCY
			 AND A.COMPANY_ID 		= C.COMPANY_ID
			 AND C.MEASURE 			= 'KRW'
			JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
			  ON D.VERSION_NO 		= @v_version_no
			 AND A.DIVISION_ID 		= D.DIVISION_ID
			 AND A.YYYYMMDD 		= D.YYYYMMDD
			 AND D.CURRENCY 		= N'KRW'
			 AND D.UNIT_CURRENCY 	= 'USD'
			WHERE A.MEASURE = 'USD'
			AND   A.DIVISION_ID = @v_division_id
			AND   A.VERSION_NO = @v_version_no
		END

PRINT @v_program_name + ' / A041: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
		-----------------------------------------------------------------------------------------------
		--	수량 변경이 있을 경우 처리 ( 수량은 수량만 수정 )
		-----------------------------------------------------------------------------------------------
		IF EXISTS ( SELECT * FROM #results_MST A
					WHERE MEASURE = N'Business_Plan' )
		BEGIN			
PRINT @v_program_name + ' / A042: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
			UPDATE A
			SET QTY = B.QTY
			  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
			FROM DM_PLN_SALES_PLAN_REPORT_C A
			JOIN #results_MST B 
			  ON A.VERSION_NO 		= B.VERSION_NO
			 AND A.DIVISION_ID 		= B.DIVISION_ID
			 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
			 AND A.DEPT_ID 			= B.DEPT_ID
			 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
			 AND A.CUST_REPORT 		= B.CUST_REPORT
			 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
			 AND A.PROJECT_CODE 	= B.PROJECT_CODE
			 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
			 AND A.ITEM_ID 			= B.ITEM_ID
			 AND A.YYYYMMDD 		= B.YYYYMMDD
			 AND A.CURRENCY 		= B.CURRENCY
			 AND A.COMPANY_ID 		= B.COMPANY_ID
			 AND A.MEASURE 			= B.Measure
			WHERE A.MEASURE 		= 'Business_Plan'
			AND   A.DIVISION_ID 	= @v_division_id
			AND   A.VERSION_NO 		= @v_version_no
		END

PRINT @v_program_name + ' / A043: ' + CONVERT(VARCHAR(30), GETDATE(), 121);
		-----------------------------------------------------------------------------------------------
		-- 위에서 수량이나 단가는 업데이트 했으므로, 그에 따른 금액을 수정한다.
		-- BP는 모든 구간이 계획이므로 IF 구분없이 금액을 조정한다. 
		-----------------------------------------------------------------------------------------------
		UPDATE A
		SET QTY = C.QTY * D.QTY
		  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		FROM DM_PLN_SALES_PLAN_REPORT_C A
		JOIN #results_MST B 
		  ON A.VERSION_NO 		= B.VERSION_NO 
		 AND A.DIVISION_ID		= B.DIVISION_ID 
		 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
		 AND A.DEPT_ID 			= B.DEPT_ID 
		 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
		 AND A.CUST_REPORT 		= B.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
		 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
		 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
		 AND A.ITEM_ID 			= B.ITEM_ID 
		 AND A.YYYYMMDD 		= B.YYYYMMDD 
		 AND A.CURRENCY 		= B.CURRENCY
		 AND A.COMPANY_ID 		= B.COMPANY_ID
		JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
		  ON A.VERSION_NO 		= C.VERSION_NO
		 AND A.DIVISION_ID 		= C.DIVISION_ID
		 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
		 AND A.DEPT_ID 			= C.DEPT_ID
		 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
		 AND A.CUST_REPORT 		= C.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP
		 AND A.PROJECT_CODE 	= C.PROJECT_CODE
		 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
		 AND A.ITEM_ID 			= C.ITEM_ID
		 AND A.YYYYMMDD 		= C.YYYYMMDD
		 AND A.CURRENCY 		= C.CURRENCY
		 AND A.COMPANY_ID 		= C.COMPANY_ID
		 AND C.MEASURE 			= 'Business_Plan'
		JOIN DM_PLN_SALES_PLAN_REPORT_C D WITH(NOLOCK)
		  ON A.VERSION_NO 		= D.VERSION_NO
		 AND A.DIVISION_ID 		= D.DIVISION_ID
		 AND A.DEPARTMENT_ID 	= D.DEPARTMENT_ID
		 AND A.DEPT_ID 			= D.DEPT_ID
		 AND A.END_CUST_REPORT 	= D.END_CUST_REPORT
		 AND A.CUST_REPORT 		= D.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= D.PRODUCT_GROUP
		 AND A.PROJECT_CODE 	= D.PROJECT_CODE
		 AND A.SCM_SITE_ID 		= D.SCM_SITE_ID
		 AND A.ITEM_ID 			= D.ITEM_ID
		 AND A.YYYYMMDD 		= D.YYYYMMDD
		 AND A.CURRENCY 		= D.CURRENCY
		 AND A.COMPANY_ID 		= D.COMPANY_ID
		 AND D.MEASURE 			= 'LOC'
		WHERE A.MEASURE 		= 'SalesAmt_LOC'
		 AND  A.DIVISION_ID 	= @v_division_id
		 AND  A.VERSION_NO 		= @v_version_no
						
PRINT @v_program_name + ' / A044: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	
		UPDATE A
		SET QTY = ROUND(C.QTY * D.EXCHANGE_PRICE, 0)
		  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		FROM DM_PLN_SALES_PLAN_REPORT_C A
		JOIN #results_MST B 
		  ON A.VERSION_NO 		= B.VERSION_NO 
		 AND A.DIVISION_ID 		= B.DIVISION_ID 
		 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
		 AND A.DEPT_ID 			= B.DEPT_ID 
		 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT 
		 AND A.CUST_REPORT 		= B.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP 
		 AND A.PROJECT_CODE 	= B.PROJECT_CODE 
		 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
		 AND A.ITEM_ID 			= B.ITEM_ID 
		 AND A.YYYYMMDD 		= B.YYYYMMDD 
		 AND A.CURRENCY 		= B.CURRENCY
		 AND A.COMPANY_ID 		= B.COMPANY_ID
		JOIN DM_PLN_SALES_PLAN_REPORT_C C WITH(NOLOCK)
		  ON A.VERSION_NO 		= C.VERSION_NO
		 AND A.DIVISION_ID 		= C.DIVISION_ID
		 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
		 AND A.DEPT_ID 			= C.DEPT_ID
		 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT
		 AND A.CUST_REPORT 		= C.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP
		 AND A.PROJECT_CODE 	= C.PROJECT_CODE
		 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
		 AND A.ITEM_ID 			= C.ITEM_ID
		 AND A.YYYYMMDD 		= C.YYYYMMDD
		 AND A.CURRENCY 		= C.CURRENCY
		 AND A.COMPANY_ID 		= C.COMPANY_ID
		 AND C.MEASURE 			= 'SalesAmt_LOC'
		JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
		  ON D.VERSION_NO 		= @v_version_no
		 AND A.DIVISION_ID 		= D.DIVISION_ID
		 AND A.YYYYMMDD 		= D.YYYYMMDD
		 AND D.CURRENCY 		= N'KRW'
		 AND D.UNIT_CURRENCY 	= A.CURRENCY
		WHERE A.MEASURE 		= 'SalesAmt_KRW'
		AND   A.DIVISION_ID 	= @v_division_id
		AND   A.VERSION_NO 		= @v_version_no

PRINT @v_program_name + ' / A045: ' + CONVERT(VARCHAR(30), GETDATE(), 121);	

		UPDATE A
		SET QTY = ROUND( CASE WHEN ISNULL(D.EXCHANGE_PRICE,0) = 0 THEN 0
							 ELSE B.QTY/ISNULL(D.EXCHANGE_PRICE,0)
						 END, 0)		  
		  , LAST_UPDATED_BY 	= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		  , LAST_UPDATE_DATE 	= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
		FROM DM_PLN_SALES_PLAN_REPORT_C A					
		JOIN #results_MST C 
		  ON A.VERSION_NO 		= C.VERSION_NO 
		 AND A.DIVISION_ID 		= C.DIVISION_ID 
		 AND A.DEPARTMENT_ID 	= C.DEPARTMENT_ID
		 AND A.DEPT_ID 			= C.DEPT_ID 
		 AND A.END_CUST_REPORT 	= C.END_CUST_REPORT 
		 AND A.CUST_REPORT 		= C.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= C.PRODUCT_GROUP 
		 AND A.PROJECT_CODE 	= C.PROJECT_CODE 
		 AND A.SCM_SITE_ID 		= C.SCM_SITE_ID
		 AND A.ITEM_ID 			= C.ITEM_ID 
		 AND A.YYYYMMDD 		= C.YYYYMMDD 
		 AND A.CURRENCY 		= C.CURRENCY
		 AND A.COMPANY_ID 		= C.COMPANY_ID
		JOIN (	SELECT A.DIVISION_ID, A.DEPARTMENT_ID, A.DEPT_ID, A.END_CUST_REPORT, A.CUST_REPORT		
		  			 , A.PRODUCT_GROUP, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.YYYYMMDD			
					 , A.CURRENCY, A.COMPANY_ID, A.QTY
				FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
				JOIN #results_MST B 
				  ON A.VERSION_NO		= B.VERSION_NO
				 AND A.DIVISION_ID		= B.DIVISION_ID
				 AND A.DEPARTMENT_ID	= B.DEPARTMENT_ID
				 AND A.DEPT_ID			= B.DEPT_ID
				 AND A.END_CUST_REPORT	= B.END_CUST_REPORT
				 AND A.CUST_REPORT		= B.CUST_REPORT
				 AND A.PRODUCT_GROUP	= B.PRODUCT_GROUP
				 AND A.PROJECT_CODE		= B.PROJECT_CODE
				 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
				 AND A.ITEM_ID			= B.ITEM_ID
				 AND A.YYYYMMDD			= B.YYYYMMDD
				 AND A.CURRENCY			= B.CURRENCY
				 AND A.COMPANY_ID		= B.COMPANY_ID
				WHERE A.MEASURE 		= 'SalesAmt_KRW'
				AND   A.VERSION_NO 		= @v_version_no
				AND   A.DIVISION_ID 	= @v_division_id ) B 
		  ON A.DIVISION_ID 		= B.DIVISION_ID
		 AND A.DEPARTMENT_ID 	= B.DEPARTMENT_ID
		 AND A.DEPT_ID 			= B.DEPT_ID
		 AND A.END_CUST_REPORT 	= B.END_CUST_REPORT
		 AND A.CUST_REPORT 		= B.CUST_REPORT
		 AND A.PRODUCT_GROUP 	= B.PRODUCT_GROUP
		 AND A.PROJECT_CODE 	= B.PROJECT_CODE
		 AND A.SCM_SITE_ID 		= B.SCM_SITE_ID
		 AND A.ITEM_ID 			= B.ITEM_ID
		 AND A.YYYYMMDD 		= B.YYYYMMDD
		 AND A.CURRENCY 		= B.CURRENCY
		 AND A.COMPANY_ID 		= B.COMPANY_ID
		JOIN DM_PLN_SALES_REPORT_EXCHANGE_C D WITH(NOLOCK)
		  ON D.VERSION_NO 		= @v_version_no
		 AND A.DIVISION_ID 		= D.DIVISION_ID
		 AND A.YYYYMMDD 		= D.YYYYMMDD
		 AND D.CURRENCY 		= N'KRW'
		 AND D.UNIT_CURRENCY 	= 'USD'
		 AND D.VERSION_NO 		= @v_version_no
		WHERE A.MEASURE 		= 'SalesAmt_USD'
		AND   A.DIVISION_ID = @v_division_id
		AND   A.VERSION_NO = @v_version_no		
	END
	--=============================================================================================
	--BP인 경우 (END)
	--=============================================================================================	
PRINT @v_program_name + ' / A046: ' + CONVERT(VARCHAR(30), GETDATE(), 121);			
	--=============================================================================================
	--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 START 
	--=============================================================================================
	UPDATE A
	SET A.FORECAST_INFO_CELL_PACK_COUNT = LOOKA.CELL_PACK_COUNT
	  , A.FORECAST_INFO_BIZ_TYPE 		= LOOKA.BIZ_TYPE		 
	  , LAST_UPDATED_BY 				= @v_created_by --[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
	  , LAST_UPDATE_DATE 				= GETDATE()		--[E20250418-001567]_정보보관을 위하여 해당 부분도 함께 수정
	FROM DM_PLN_SALES_PLAN_REPORT_C A
	INNER JOIN ( SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT, A.MODEL_RANK, A.DIVISION_ID
				 FROM 
				(	SELECT SEGMENT2  AS MODEL       
						 , SEGMENT3  AS BIZ_TYPE
						 , SEGMENT4  AS CELL_PACK_COUNT
						 , SEGMENT1  AS DIVISION_ID
						 , RANK () OVER ( PARTITION BY SEGMENT2	ORDER BY DISPLAY_SEQ DESC ) MODEL_RANK 
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
					WHERE LOOKUP_TYPE = 'DM_BIZ_TYPE_40') A
				WHERE MODEL_RANK = '1') LOOKA
			ON LOOKA.MODEL		 = A.ITEM_ID		
		   AND LOOKA.DIVISION_ID = A.DIVISION_ID
	WHERE A.DIVISION_ID = '40'
	AND   A.ITEM_ID 	= LOOKA.MODEL
	AND   A.VERSION_NO 	= @v_version_no;
	
PRINT @v_program_name + ' / A047: ' + CONVERT(VARCHAR(30), GETDATE(), 121);			
	--=============================================================================================
	--[E20230906-001160] GDW 송신용 데이터 Lookup 수정 특정 상품에 대한 BIZ_TYPE과 COUNT 정보를 변환하여 저장되도록 요청 END 
	--=============================================================================================
	--=============================================================================================
	--[E20250418-001567]_Sales Report 이력 테이블 생성 START
	--=============================================================================================
	INSERT INTO DM_PLN_SALES_PLAN_REPORT_H 
	( DATA_TYPE, DIVISION_ID, HISTORY_SEQ, VERSION_NO, CUTOFF_TYPE
	, CUTOFF_YYYYMMDD, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME
	, END_CUST_REPORT, CUST_REPORT, PRODUCT_GROUP, SCM_SITE_ID, ITEM_ID
	, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
	, YYYYMMDD, CURRENCY, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY
	, LAST_UPDATE_DATE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4
	, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9
	, ATTRIBUTE10, COMPANY_ID, PROJECT_CODE, SOLDTO_CUST_REPORT, OWNER_NAME
	, CUST_GROUP_DTL, PRODUCT_DETAILS, FORECAST_INFO_SPEC, NICK_NAME, FORECAST_INFO_CELL_MODEL
	, FORECAST_INFO_CELL_PACK_COUNT, FORECAST_INFO_BIZ_TYPE, COMPANY_NAME, APPLICATION, APPLICATION_GR
	, COUNTRY_KR_NAME, ROUTE, CELL_PROD_SITE )
	SELECT A.DATA_TYPE, A.DIVISION_ID, NEXT VALUE FOR SEQ1_DM_PLN_SALES_PLAN_REPORT_H, A.VERSION_NO, A.CUTOFF_TYPE
		 , A.CUTOFF_YYYYMMDD, A.DEPARTMENT_ID, A.DEPARTMENT_NAME, A.DEPT_ID, A.DEPT_NAME
		 , A.END_CUST_REPORT, A.CUST_REPORT, A.PRODUCT_GROUP, A.SCM_SITE_ID, A.ITEM_ID
		 , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID
		 , A.YYYYMMDD, A.CURRENCY, A.QTY, A.CREATED_BY, A.CREATION_DATE
		 , A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
		 , A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8
		 , A.ATTRIBUTE9, A.ATTRIBUTE10, A.COMPANY_ID, A.PROJECT_CODE, A.SOLDTO_CUST_REPORT
		 , A.OWNER_NAME, A.CUST_GROUP_DTL, A.PRODUCT_DETAILS, A.FORECAST_INFO_SPEC, A.NICK_NAME
		 , A.FORECAST_INFO_CELL_MODEL, A.FORECAST_INFO_CELL_PACK_COUNT, A.FORECAST_INFO_BIZ_TYPE, A.COMPANY_NAME, A.APPLICATION
		 , A.APPLICATION_GR, A.COUNTRY_KR_NAME, A.ROUTE, A.CELL_PROD_SITE 
	FROM DM_PLN_SALES_PLAN_REPORT_C A WITH(NOLOCK)
	JOIN #results_MST B 
	  ON A.VERSION_NO		= B.VERSION_NO
	 AND A.DIVISION_ID		= B.DIVISION_ID
	 AND A.DEPARTMENT_ID	= B.DEPARTMENT_ID
	 AND A.DEPT_ID			= B.DEPT_ID
	 AND A.END_CUST_REPORT	= B.END_CUST_REPORT
	 AND A.CUST_REPORT		= B.CUST_REPORT
	 AND A.PRODUCT_GROUP	= B.PRODUCT_GROUP
	 AND A.PROJECT_CODE		= B.PROJECT_CODE
	 AND A.SCM_SITE_ID		= B.SCM_SITE_ID
	 AND A.ITEM_ID			= B.ITEM_ID
	 AND A.YYYYMMDD LIKE LEFT(B.YYYYMMDD, 6) + '%'
	 AND A.CURRENCY			= B.CURRENCY
	 AND A.COMPANY_ID		= B.COMPANY_ID
	 AND A.MEASURE			= B.MEASURE
	WHERE A.DIVISION_ID		= @v_division_id
	AND   A.VERSION_NO		= @v_version_no 			
	
PRINT @v_program_name + ' / A048: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
	--=============================================================================================
	--[E20250418-001567]_Sales Report 이력 테이블 생성 END
	--=============================================================================================
	-----------------------------------------------------------------------------------------------
	-- UPDATE 후에 전송처리를 다시 한다.
	-----------------------------------------------------------------------------------------------
	IF EXISTS ( SELECT DIVISION_ID 
				FROM DM_MDF_VERSION WITH(NOLOCK)
				WHERE DIVISION_ID 	= @v_division_id 
				AND VERSION_NO 		= @v_version_no 
				AND SEND_YN 		= 'Y' )
	BEGIN
PRINT @v_program_name + ' / A049: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		
		EXEC DMF0044_MOBILE_REPORT_CREATE @v_division_id, @v_version_no, @v_cutoff_type, N'T', @v_created_by
	END
		
PRINT @v_program_name + ' / A050: ' + CONVERT(VARCHAR(30), GETDATE(), 121);		

	--=============================================================================================
  	-- 트랜잭션 (COMMIT)
	--=============================================================================================
    COMMIT TRANSACTION DM_PLN_SALES_PLAN_REPORT_C;  
	END TRY
	
	-----------------------------------------------------------------------------------------------
    BEGIN CATCH
	-----------------------------------------------------------------------------------------------	
		--[C20200909-000203] LOG 표준화 적용
		--=============================================================================================
		-- 트랜잭션 (END)
		--=============================================================================================
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
	  SELECT 'success';
	  
	--=============================================================================================
    -- 종료 LOG
	--=============================================================================================
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