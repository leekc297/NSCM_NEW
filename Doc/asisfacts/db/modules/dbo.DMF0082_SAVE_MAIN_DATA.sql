

/*============================================================================================================================
 * Program ID  : [DMF0082_SAVE_MAIN_DATA]                                                           
 * Description : Procedure 작성 가이드                                                              
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                    
 *=============================================================================================================================
 * Date        In Charge    Description                                                             
 *=============================================================================================================================
 * 2025.01.23	dsiol		Initial Release [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선
 * 2025.04.15	dsiol		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가
 * 2025.04.26	dsiol		[PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선 : BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
 * 2025.05.21	dsiol		[PJ2025-50188]LGES SCM DM 소형사업부 매출계획 동기화 개선 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다.
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : CELL_PROD_SITE_ID 검증 로직 보완
 * 2025.06.19	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : BIZ TYPE 검증 로직 보완
 * 2025.07.15	JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * 2025.07.18	JSSBAE		[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청
 * 2025.07.22	kjiyoon		[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 저장 속도 개선
 * 2025.08.26	JSSBAE		[E20250825-000297]_SCM_DM 매출계획 BPS 전송 로직 개선
 * 2025.09.12	JSSBAE		[E20250912-001720]_40사업부 MKT FCST 입력제한 기능 보완
 * 2025.09.15	JSSBAE		[E20250915-000105]_GSCM 시스템 DP 입력 오류
 * 2025.09.30	JSSBAE		[E20250919-001699]_Incoterms 데이터 처리 VALID 처리
 * 2025.10.27	JSSBAE		[E20251021-000634]_FCST&PRICE MGMT SALES PLAN 데이터 동기화 속도개선
 * 2025.12.09	JSSBAE		[E20251208-000309]_FCST&PRICE MGMT MKT FCST AMT 메저 로직 개선
 * 2025.12.10	JSSBAE		[E20251209-000712]_40사업부 RTF 간편조정 후 CUTOFF 데이터 미반영 현상 확인 요청
 * 2026.01.21	JSSBAE		[E20260107-001651]_BPS 전송 데이터 From_Site_ID 생성 로직 개선
 * 2026.03.10	JSSBAE		[E20260309-000271]_DMF0082 UI Sales Price 저장 로직 개선
 * 2026.04.22	JSSBAE		[E20260422-001123]_40사업부 FCST&PRICE MGMT UI Price 데이터 저장 로직 개선
 * 2026.06.12	JSSBAE		[E20260608-000294]_FCST&PRICE MGMT UI Biz Type 오류 메시지 수정 요청
 *============================================================================================================================*/
--exec DMF0082_SAVE_MAIN_DATA @p_active_flag=N'M^M^M^M^M^M^M^M^M',@p_division_id=N'40^40^40^40^40^40^40^40^40',@p_project_code=N'^^^^^^^^',@p_end_customer=N'NT^NT^NT^NT^NT^NT^NT^NT^NT',@p_scm_site_id=N'Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI^Desay_CN_HUI',@p_item_id=N'MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11^MDP2949A9B11',@p_dom_exp=N'E^E^E^E^E^E^E^E^E',@p_fcst_type=N'MPS^MPS^MPS^MPS^MPS^MPS^MPS^MPS^MPS',@p_incoterms=N'DDP^DDP^DDP^DDP^DDP^DDP^DDP^DDP^DDP',@p_measure=N'MKT_FCST^MKT_FCST^LOC^LOC^LOC^LOC^LOC^LOC^LOC',@p_plant_site_id=N'^^^^^^^^',@p_cell_prod_site_id=N'G182-A^G182-A^G182-A^G182-A^G182-A^G182-A^G182-A^G182-A^G182-A',@p_yyyymmdd=N'20250214^20250221^20250217^20250218^20250219^20250220^20250221^20250222^20250223',@p_currency=N'^^USD^USD^USD^USD^USD^USD^USD',@p_qty=N'1000^2000^3000^0^0^0^0^0^0',@p_created_by=N'dsiol^dsiol^dsiol^dsiol^dsiol^dsiol^dsiol^dsiol^dsiol'

CREATE PROCEDURE [dbo].[DMF0082_SAVE_MAIN_DATA]
	-- Add the parameters for the stored procedure here
	  @p_active_flag			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_project_code			NVARCHAR(MAX)
	, @p_end_customer			NVARCHAR(MAX)
	, @p_scm_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_dom_exp				NVARCHAR(MAX)
	, @p_fcst_type				NVARCHAR(MAX)
	, @p_incoterms				NVARCHAR(MAX)
	, @p_measure				NVARCHAR(MAX)
	, @p_plant_site_id  	    NVARCHAR(MAX)
	, @p_cell_prod_site_id		NVARCHAR(MAX)
	, @p_yyyymmdd				NVARCHAR(MAX)
	, @p_currency			    NVARCHAR(MAX)
	, @p_qty					NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
	--=================================================================================================================================
	-- LOG 용 변수 설정	
	--=================================================================================================================================
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0082_SAVE_MAIN_DATA';
    DECLARE @v_log_type				NVARCHAR(30);
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_description			NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_변수 추가 (START)
	-----------------------------------------------------------------------------------------------------------------------------------
    DECLARE @v_created_by			NVARCHAR(500);	--로그저장시 사용자ID
	SET		@v_created_by = LEFT(@P_created_by, CASE WHEN PATINDEX('%^%', @P_created_by) > 1 THEN PATINDEX('%^%', @P_created_by) ELSE 100 END -1);
	DECLARE @n_update_cnt			INT = 0;		--변경이 발생하는 Row Count
	-----------------------------------------------------------------------------------------------------------------------------------
	-- [E20250915-000105]_변수 추가 (END)
	-----------------------------------------------------------------------------------------------------------------------------------	
	--=================================================================================================================================
	-- 예외처리 변수 설정
	--=================================================================================================================================
	DECLARE @v_err_code				INTEGER;
	DECLARE @v_err_message			NVARCHAR(4000)='';
	
	DECLARE @V_DIVISION_ID			NVARCHAR(10);
	SET		@V_DIVISION_ID = '40'
	DECLARE @valid_item_id			NVARCHAR(MAX);
	DECLARE @plan_start_yyyymmdd	NVARCHAR(MAX);  -- 20180611 KHSONG ADDED
	DECLARE @valid_shipto			NVARCHAR(MAX);
	DECLARE @EDIT_CNT				INT;
PRINT @v_program_name + ' : A001--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
	
	BEGIN TRY
	
		--=============================================================================================================================
		-- 시작 LOG (START)
		--=============================================================================================================================
		SET @v_log_type		= 'START';
		SET @v_log_message	= '########## Start of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
		-------------------------------------------------------------------------------------------------------------------------------
		
		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
		-------------------------------------------------------------------------------------------------------------------------------
		--=============================================================================================================================
		-- 시작 LOG (END)
		--=============================================================================================================================
	
PRINT @v_program_name + ' : A00A--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

		--=============================================================================================================================
		-- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 상단에서 진행하도록 수정 (START)
		--=============================================================================================================================		
		IF OBJECT_ID (N'tempdb..#T_MAIN', N'U') IS NOT NULL 
			DROP TABLE #T_MAIN

		IF OBJECT_ID (N'tempdb..#mshychu1', N'U') IS NOT NULL 
			DROP TABLE #mshychu1

		IF OBJECT_ID (N'tempdb..#mshychu2', N'U') IS NOT NULL 
			DROP TABLE #mshychu2

		-- [E20251021-000634]_TEMP TABLE DROP 추가 (START)
		IF OBJECT_ID (N'tempdb..#TEMP_DAYINFO', N'U') IS NOT NULL 
			DROP TABLE #TEMP_DAYINFO

		IF OBJECT_ID (N'tempdb..#TEMP_EXCH', N'U') IS NOT NULL 
			DROP TABLE #TEMP_EXCH			
		-- [E20251021-000634]_TEMP TABLE DROP 추가 (END)

		IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 		
			DROP TABLE #T_PRICE
			
		-------------------------------------------------------------------------------------------------------------------------------
		-- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 DROP
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#T_FCST', N'U') IS NOT NULL 		
			DROP TABLE #T_FCST
			
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE LOOKUP정보용 테이블 DROP
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#TEMP_EXCEPTION_BIZ_TYPE', N'U') IS NOT NULL 
			DROP TABLE #TEMP_EXCEPTION_BIZ_TYPE;	
			
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE과 매핑되는 저장정보 테이블 DROP
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#TEMP_EXCEPTION_ITEM_LIST', N'U') IS NOT NULL 
			DROP TABLE #TEMP_EXCEPTION_ITEM_LIST;	

		CREATE TABLE #T_MAIN  
		( [ACTION]			NVARCHAR(1)		
		, DIVISION_ID		NVARCHAR(30)	
		, PROJECT_CODE		NVARCHAR(50)	
		, END_CUSTOMER		NVARCHAR(50)	
		, SCM_SITE_ID		NVARCHAR(30)	
		, ITEM_ID			NVARCHAR(50)	
		, DOM_EXP			NVARCHAR(3)		
		, FCST_TYPE			NVARCHAR(20)	
		, INCOTERMS			NVARCHAR(10)	
		, MEASURE			NVARCHAR(50)	
		, PLANT_SITE_ID		NVARCHAR(30)	
		, CELL_PROD_SITE_ID	NVARCHAR(30)	
		, YYYYMMDD			NVARCHAR(8)		
		, CURRENCY			NVARCHAR(8)		
		, QTY_PRICE			NUMERIC(30,10)	
		, CREATED_BY		NVARCHAR(150)	
		, V_ATTRIBUTE1		NVARCHAR(150)	
		, V_ATTRIBUTE2		NVARCHAR(150)	
		, V_ATTRIBUTE3		NVARCHAR(150)	
		, V_ATTRIBUTE4		NVARCHAR(MAX)	 
		, V_ATTRIBUTE5		NVARCHAR(MAX)	 
		, V_ATTRIBUTE6		NVARCHAR(150)	
		, V_ATTRIBUTE7		NVARCHAR(150)	
		, V_ATTRIBUTE8		NVARCHAR(150)	
		, V_ATTRIBUTE9		NVARCHAR(150)	
		, V_ATTRIBUTE10		NVARCHAR(150)	
		, V_BOM_YN			NCHAR(1)			 
		, V_VMI_YN			NCHAR(1))

		CREATE TABLE #T_PRICE 
		( DIVISION_ID			NVARCHAR(30)
		, PROJECT_CODE			NVARCHAR(50)
		, END_CUSTOMER			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, PLANT_SITE_ID			NVARCHAR(30)
		, CELL_PROD_SITE_ID		NVARCHAR(50)
		, ITEM_ID				NVARCHAR(50)
		, YYYYMMDD				NVARCHAR(8)
		, CURRENCY				NVARCHAR(10)
		, MEASURE				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(20)
		, INCOTERMS				NVARCHAR(10)
		, PRICE					NUMERIC(30,10))		
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 CREATE
		-------------------------------------------------------------------------------------------------------------------------------

		CREATE TABLE #T_FCST 
		( DIVISION_ID			NVARCHAR(30)
		, PROJECT_CODE			NVARCHAR(50)
		, END_CUSTOMER			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, PLANT_SITE_ID			NVARCHAR(30)
		, CELL_PROD_SITE_ID		NVARCHAR(50)
		, ITEM_ID				NVARCHAR(50)
		, YYYYMMDD				NVARCHAR(8)
		, MEASURE				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(20)
		, INCOTERMS				NVARCHAR(10))
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE LOOKUP정보용 테이블 CREATE
		-------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #TEMP_EXCEPTION_BIZ_TYPE 
		( DIVISION_ID		NVARCHAR(8)
		, ITEM_ID			NVARCHAR(50)
		, ITEM_TYPE			NVARCHAR(8)
		, SEQ				INT		IDENTITY(1,1))		
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE과 매핑되는 저장정보 테이블 CREATE
		-------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #TEMP_EXCEPTION_ITEM_LIST 
		(	DIVISION_ID		NVARCHAR(8)
		, ITEM_ID			NVARCHAR(50)
		, ITEM_TYPE			NVARCHAR(8))	

		--=============================================================================================================================
		-- [E20251021-000634]_TEMP TABLE DROP -> CREATE (START) 가장 사단에서 진행하도록 수정 (END)
		--=============================================================================================================================
				

		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_해당 작업이 시간이 너무 오래 걸려서 주석처리하고 다른 방식으로 진행하도록 하단에 작성 (START)
		-------------------------------------------------------------------------------------------------------------------------------
		/*
		-- [E20250522-001188]_해당 화면에서도 TRIM처리가 전혀 안되어 있어서 TRIM 처리 (START)	
		-- 나머지는 가운데에 공백이 존재할 수 있으므로, RTRIM, LTRIM 처리만 진행하고
		-- ITEM의 경우 중간의 공백이 없으므로 RTRM, LTRM으로 지워지지 않는 건들이 있고, 특수 문자가 안지워지는 건도 있어서 어떻게든 지우겠다는 의지
		SELECT RTRIM(LTRIM(B1.TOKEN)) AS [ACTION]
			 , RTRIM(LTRIM(B2.TOKEN)) AS DIVISION_ID
			 -- 40사업부 특성상 PROJECT_CODE가 공란이라서 END_CUSTOMER 값을 PROJECT_CODE 에 넣기로 했습니다. , B4.TOKEN  AS PROJECT_CODE는 의도 된 것..
			 , RTRIM(LTRIM(B4.TOKEN)) AS PROJECT_CODE
			 , RTRIM(LTRIM(B4.TOKEN)) AS END_CUSTOMER
			 , RTRIM(LTRIM(B5.TOKEN)) AS SCM_SITE_ID		 
			 --1).CHAR(13): Carriage return / 2).CHAR(10): Line feed / 3).CHAR(9): TAB / 4).' ' 공백 '' 처리
			 , REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(B6.TOKEN)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '') AS ITEM_ID
			 , RTRIM(LTRIM(B7.TOKEN)) AS DOM_EXP
			 , RTRIM(LTRIM(B8.TOKEN)) AS FCST_TYPE
			 , RTRIM(LTRIM(B9.TOKEN)) AS INCOTERMS
			 , RTRIM(LTRIM(B10.TOKEN)) AS MEASURE
			 , RTRIM(LTRIM(B11.TOKEN)) AS PLANT_SITE_ID	
			 , RTRIM(LTRIM(B12.TOKEN)) AS CELL_PROD_SITE_ID
			 , RTRIM(LTRIM(B13.TOKEN)) AS YYYYMMDD
			 , RTRIM(LTRIM(B14.TOKEN)) AS CURRENCY
			 , CONVERT(NUMERIC(30,10), RTRIM(LTRIM(B15.TOKEN))) AS QTY_PRICE -- SALES_PRICE에서는 PRICE
			 , RTRIM(LTRIM(B16.TOKEN)) AS CREATED_BY
		-- [E20250522-001188]_해당 화면에서도 TRIM처리가 전혀 안되어 있어서 TRIM 처리 (END)	
		-----------------------------------------------------------------------------------------------------------------------------------
			 , '' AS V_ATTRIBUTE1 
			 , '' AS V_ATTRIBUTE2
			 , '' AS V_ATTRIBUTE3
			 , '' AS V_ATTRIBUTE4
			 , '' AS V_ATTRIBUTE5
			 , '' AS V_ATTRIBUTE6
			 , '' AS V_ATTRIBUTE7
			 , '' AS V_ATTRIBUTE8
			 , '' AS V_ATTRIBUTE9
			 , '' AS V_ATTRIBUTE10
			 , '' AS V_BOM_YN
			 , '' AS V_VMI_YN
		INTO #T_MAIN
		FROM DBO.UF_FX_STRING_SPLIT(@p_active_flag                          , '^') B1
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_division_id			    , '^') B2  ON B1.NR = B2.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_project_code			    , '^') B3  ON B1.NR = B3.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_end_customer			    , '^') B4  ON B1.NR = B4.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_scm_site_id			    , '^') B5  ON B1.NR = B5.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_item_id				    , '^') B6  ON B1.NR = B6.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_dom_exp			        , '^') B7  ON B1.NR = B7.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_fcst_type			        , '^') B8  ON B1.NR = B8.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_incoterms		            , '^') B9  ON B1.NR = B9.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_measure	                , '^') B10 ON B1.NR = B10.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_plant_site_id	            , '^') B11 ON B1.NR = B11.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_cell_prod_site_id	        , '^') B12 ON B1.NR = B12.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_yyyymmdd	                , '^') B13 ON B1.NR = B13.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_currency	                , '^') B14 ON B1.NR = B14.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_qty	                    , '^') B15 ON B1.NR = B15.NR
		LEFT OUTER JOIN DBO.UF_FX_STRING_SPLIT(@p_created_by	            , '^') B16 ON B1.NR = B16.NR
		*/
		/* [E20251021-000634]_#T_MAIN 테이블 DROP 후 CREATE 하도록 상단에서 실행 (START)
		CREATE TABLE #T_MAIN  
		( [ACTION]			NVARCHAR(1)		
		, DIVISION_ID		NVARCHAR(30)	
		, PROJECT_CODE		NVARCHAR(50)	
		, END_CUSTOMER		NVARCHAR(50)	
		, SCM_SITE_ID		NVARCHAR(30)	
		, ITEM_ID			NVARCHAR(50)	
		, DOM_EXP			NVARCHAR(3)		
		, FCST_TYPE			NVARCHAR(20)	
		, INCOTERMS			NVARCHAR(10)	
		, MEASURE			NVARCHAR(50)	
		, PLANT_SITE_ID		NVARCHAR(30)	
		, CELL_PROD_SITE_ID	NVARCHAR(30)	
		, YYYYMMDD			NVARCHAR(8)		
		, CURRENCY			NVARCHAR(8)		
		, QTY_PRICE			NUMERIC(30,10)	
		, CREATED_BY		NVARCHAR(150)	
		, V_ATTRIBUTE1		NVARCHAR(150)	
		, V_ATTRIBUTE2		NVARCHAR(150)	
		, V_ATTRIBUTE3		NVARCHAR(150)	
		, V_ATTRIBUTE4		NVARCHAR(MAX)	 
		, V_ATTRIBUTE5		NVARCHAR(MAX)	 
		, V_ATTRIBUTE6		NVARCHAR(150)	
		, V_ATTRIBUTE7		NVARCHAR(150)	
		, V_ATTRIBUTE8		NVARCHAR(150)	
		, V_ATTRIBUTE9		NVARCHAR(150)	
		, V_ATTRIBUTE10		NVARCHAR(150)	
		, V_BOM_YN			NCHAR(1)			 
		, V_VMI_YN			NCHAR(1))
		[E20251021-000634]_#T_MAIN 테이블 DROP 후 CREATE 하도록 상단에서 실행 (END) */
		
		DECLARE @v_active_flag			NVARCHAR(MAX);
		DECLARE @v_p_division_id		NVARCHAR(MAX);
		DECLARE @v_project_code			NVARCHAR(MAX);
		DECLARE @v_end_customer			NVARCHAR(MAX);
		DECLARE @v_scm_site_id			NVARCHAR(MAX);
		DECLARE @v_item_id				NVARCHAR(MAX);
		DECLARE @v_dom_exp				NVARCHAR(MAX);
		DECLARE @v_fcst_type			NVARCHAR(MAX);
		DECLARE @v_incoterms			NVARCHAR(MAX);
		DECLARE @v_measure				NVARCHAR(MAX);
		DECLARE @v_plant_site_id		NVARCHAR(MAX);
		DECLARE @v_cell_prod_site_id	NVARCHAR(MAX);
		DECLARE @v_yyyymmdd				NVARCHAR(MAX);
		DECLARE @v_currency				NVARCHAR(MAX);
		DECLARE @v_qty					NVARCHAR(MAX);
		DECLARE @v_p_created_by			NVARCHAR(MAX);		
		
		SET @v_active_flag			= NULL;
		SET @v_p_division_id		= NULL;
		SET @v_project_code			= NULL;
		SET @v_end_customer			= NULL;
		SET @v_scm_site_id			= NULL;
		SET @v_item_id				= NULL;	 
		SET @v_dom_exp				= NULL;	 
		SET @v_fcst_type			= NULL;	 
		SET @v_incoterms			= NULL;	 
		SET @v_measure				= NULL;	 
		SET @v_plant_site_id		= NULL;	 
		SET @v_cell_prod_site_id	= NULL;	 
		SET @v_yyyymmdd				= NULL;	
		SET @v_currency				= NULL;	
		SET @v_qty					= NULL;	  
		SET @v_p_created_by			= NULL;
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
		--1. 화면에서 전달받은 데이터 -> temp 테이블로 insert
		--■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
PRINT @v_program_name + ' : A00B--' + CONVERT(NVARCHAR(30), GETDATE(), 121);		

		-- 마지막 데이터 처리를 위한 구분자 추가
		SET @p_active_flag			= RTRIM(@p_active_flag			) + '^';
		SET @p_division_id			= RTRIM(@p_division_id			) + '^';
		SET @p_project_code			= RTRIM(@p_project_code			) + '^';
		SET @p_end_customer			= RTRIM(@p_end_customer			) + '^';
		SET @p_scm_site_id			= RTRIM(@p_scm_site_id			) + '^';
		SET @p_item_id				= RTRIM(@p_item_id				) + '^';
		SET @p_dom_exp				= RTRIM(@p_dom_exp				) + '^';
		SET @p_fcst_type			= RTRIM(@p_fcst_type			) + '^';
		SET @p_incoterms			= RTRIM(@p_incoterms			) + '^';
		SET @p_measure				= RTRIM(@p_measure				) + '^';
		SET @p_plant_site_id		= RTRIM(@p_plant_site_id		) + '^';
		SET @p_cell_prod_site_id	= RTRIM(@p_cell_prod_site_id	) + '^';
		SET @p_yyyymmdd				= RTRIM(@p_yyyymmdd				) + '^';
		SET @p_currency				= RTRIM(@p_currency				) + '^';
		SET @p_qty					= RTRIM(@p_qty					) + '^';
		SET @p_created_by			= RTRIM(@p_created_by			) + '^';
		
		DECLARE @index_active_flag			INT
		DECLARE @index_division_id			INT
		DECLARE @index_project_code			INT
		DECLARE @index_end_customer			INT
		DECLARE @index_scm_site_id			INT
		DECLARE @index_item_id				INT
		DECLARE @index_dom_exp				INT
		DECLARE @index_fcst_type			INT
		DECLARE @index_incoterms			INT
		DECLARE @index_measure				INT
		DECLARE @index_plant_site_id		INT
		DECLARE @index_cell_prod_site_id	INT
		DECLARE @index_yyyymmdd				INT
		DECLARE @index_currency				INT
		DECLARE @index_qty					INT
		DECLARE @index_created_by			INT	 

				
		DECLARE @i_count INT;
		SET		@i_count = 0
		DECLARE @idx INT;
		SET		@idx = 1

		--총 COUNT를 구한다. 
		--하나라도 들어오면 수치가 1이 된다.
		SET @i_count = LEN(@p_DIVISION_ID) - LEN(REPLACE(@p_DIVISION_ID, '^','')) 
PRINT @v_program_name + ' : A00C--' + CONVERT(NVARCHAR(30), GETDATE(), 121) +' / ' + CONVERT(NVARCHAR(10), @i_count)

		IF @i_count > 0
		BEGIN
PRINT @v_program_name + ' : A00D--' + CONVERT(NVARCHAR(30), GETDATE(), 121) +' / ' + CONVERT(NVARCHAR(10), @i_count)
			WHILE @idx <= @i_count 
			BEGIN
				SET	@idx = @idx + 1				
				
				SET @index_active_flag			= PATINDEX('%' + '^' + '%', @p_active_flag			)
				SET @index_division_id			= PATINDEX('%' + '^' + '%', @p_division_id			)
				SET @index_project_code			= PATINDEX('%' + '^' + '%', @p_project_code			)
				SET @index_end_customer			= PATINDEX('%' + '^' + '%', @p_end_customer			)
				SET @index_scm_site_id			= PATINDEX('%' + '^' + '%', @p_scm_site_id			)
				SET @index_item_id				= PATINDEX('%' + '^' + '%', @p_item_id				)
				SET @index_dom_exp				= PATINDEX('%' + '^' + '%', @p_dom_exp				)
				SET @index_fcst_type			= PATINDEX('%' + '^' + '%', @p_fcst_type			)
				SET @index_incoterms			= PATINDEX('%' + '^' + '%', @p_incoterms			)
				SET @index_measure				= PATINDEX('%' + '^' + '%', @p_measure				)
				SET @index_plant_site_id		= PATINDEX('%' + '^' + '%', @p_plant_site_id		)
				SET @index_cell_prod_site_id	= PATINDEX('%' + '^' + '%', @p_cell_prod_site_id	)
				SET @index_yyyymmdd				= PATINDEX('%' + '^' + '%', @p_yyyymmdd				)
				SET @index_currency				= PATINDEX('%' + '^' + '%', @p_currency				)
				SET @index_qty					= PATINDEX('%' + '^' + '%', @p_qty					)
				SET @index_created_by			= PATINDEX('%' + '^' + '%', @p_created_by			)	

				SET @v_active_flag			= SUBSTRING(@p_active_flag		, 0, @index_active_flag			)
				SET @v_p_division_id		= SUBSTRING(@p_division_id		, 0, @index_division_id			)
				SET @v_project_code			= SUBSTRING(@p_project_code		, 0, @index_project_code		)
				SET @v_end_customer			= SUBSTRING(@p_end_customer		, 0, @index_end_customer		)
				SET @v_scm_site_id			= SUBSTRING(@p_scm_site_id		, 0, @index_scm_site_id			)
				SET @v_item_id				= SUBSTRING(@p_item_id			, 0, @index_item_id				)
				SET @v_dom_exp				= SUBSTRING(@p_dom_exp			, 0, @index_dom_exp				)
				SET @v_fcst_type			= SUBSTRING(@p_fcst_type		, 0, @index_fcst_type			)
				SET @v_incoterms			= SUBSTRING(@p_incoterms		, 0, @index_incoterms			)
				SET @v_measure				= SUBSTRING(@p_measure			, 0, @index_measure				)
				SET @v_plant_site_id		= SUBSTRING(@p_plant_site_id	, 0, @index_plant_site_id		)
				SET @v_cell_prod_site_id	= SUBSTRING(@p_cell_prod_site_id, 0, @index_cell_prod_site_id   )
				SET @v_yyyymmdd				= SUBSTRING(@p_yyyymmdd			, 0, @index_yyyymmdd			)
				SET @v_currency				= SUBSTRING(@p_currency			, 0, @index_currency			)
				SET @v_qty					= SUBSTRING(@p_qty				, 0, @index_qty					)
				SET @v_p_created_by			= SUBSTRING(@p_created_by		, 0, @index_created_by			)
				
PRINT @v_program_name + ' : A00E--' + CONVERT(NVARCHAR(30), GETDATE(), 121) +' / ' + CONVERT(NVARCHAR(10), @idx)

				SET @p_active_flag			= SUBSTRING(@p_active_flag		, LEN(@v_active_flag				+ '^') + 1, LEN(@p_active_flag		))
				SET @p_division_id			= SUBSTRING(@p_division_id		, LEN(@v_p_division_id				+ '^') + 1, LEN(@p_division_id		))
				SET @p_project_code			= SUBSTRING(@p_project_code		, LEN(@v_project_code				+ '^') + 1, LEN(@p_project_code		))
				SET @p_end_customer			= SUBSTRING(@p_end_customer		, LEN(@v_end_customer				+ '^') + 1, LEN(@p_end_customer		))
				SET @p_scm_site_id			= SUBSTRING(@p_scm_site_id		, LEN(@v_scm_site_id				+ '^') + 1, LEN(@p_scm_site_id		))
				SET @p_item_id				= SUBSTRING(@p_item_id			, LEN(@v_item_id					+ '^') + 1, LEN(@p_item_id			))
				SET @p_dom_exp				= SUBSTRING(@p_dom_exp			, LEN(@v_dom_exp					+ '^') + 1, LEN(@p_dom_exp			))
				SET @p_fcst_type			= SUBSTRING(@p_fcst_type		, LEN(@v_fcst_type					+ '^') + 1, LEN(@p_fcst_type		))
				SET @p_incoterms			= SUBSTRING(@p_incoterms		, LEN(@v_incoterms					+ '^') + 1, LEN(@p_incoterms		))
				SET @p_measure				= SUBSTRING(@p_measure			, LEN(@v_measure					+ '^') + 1, LEN(@p_measure			))
				SET @p_plant_site_id		= SUBSTRING(@p_plant_site_id	, LEN(@v_plant_site_id				+ '^') + 1, LEN(@p_plant_site_id	))
				SET @p_cell_prod_site_id	= SUBSTRING(@p_cell_prod_site_id, LEN(@v_cell_prod_site_id			+ '^') + 1, LEN(@p_cell_prod_site_id))
				SET @p_yyyymmdd				= SUBSTRING(@p_yyyymmdd			, LEN(@v_yyyymmdd					+ '^') + 1, LEN(@p_yyyymmdd			))
				SET @p_currency				= SUBSTRING(@p_currency			, LEN(@v_currency					+ '^') + 1, LEN(@p_currency			))
				SET @p_qty					= SUBSTRING(@p_qty				, LEN(@v_qty						+ '^') + 1, LEN(@p_qty				))
				SET @p_created_by			= SUBSTRING(@p_created_by		, LEN(@v_p_created_by				+ '^') + 1, LEN(@p_created_by		))
				 
				SET @v_active_flag			= RTRIM(LTRIM(@v_active_flag))
				SET @v_p_division_id		= RTRIM(LTRIM(@v_p_division_id))
				SET @v_project_code			= RTRIM(LTRIM(@v_project_code))
				SET @v_end_customer			= RTRIM(LTRIM(@v_end_customer))
				SET @v_scm_site_id			= RTRIM(LTRIM(@v_scm_site_id))
				SET @v_item_id				= REPLACE(REPLACE(REPLACE(REPLACE(RTRIM(LTRIM(@v_item_id)),CHAR(13),''),CHAR(10),''),CHAR(9),''), ' ', '')
				SET @v_dom_exp				= RTRIM(LTRIM(@v_dom_exp))
				SET @v_fcst_type			= RTRIM(LTRIM(@v_fcst_type))
				SET @v_incoterms			= RTRIM(LTRIM(@v_incoterms))
				SET @v_measure				= RTRIM(LTRIM(@v_measure))
				SET @v_plant_site_id		= RTRIM(LTRIM(@v_plant_site_id))
				SET @v_cell_prod_site_id	= RTRIM(LTRIM(@v_cell_prod_site_id))
				SET @v_yyyymmdd				= RTRIM(LTRIM(@v_yyyymmdd))
				SET @v_qty					= RTRIM(LTRIM(@v_qty))
				SET @v_currency				= RTRIM(LTRIM(@v_currency))
				SET @v_p_created_by			= RTRIM(LTRIM(@v_p_created_by))
--PRINT @v_program_name + ' : A00G--' + CONVERT(NVARCHAR(30), GETDATE(), 121) +' / ' + CONVERT(NVARCHAR(10), @idx)
--PRINT @v_program_name + ' : A00G--@v_active_flag: ' + @v_active_flag +' / @v_p_division_id: ' + @v_p_division_id +' / @v_project_code: ' + @v_project_code +' / @v_end_customer: ' + @v_end_customer +' / @v_scm_site_id: ' + @v_scm_site_id
--PRINT @v_program_name + ' : A00H--@v_item_id: ' + @v_item_id +' / @v_dom_exp: ' + @v_dom_exp +' / @v_fcst_type: ' + @v_fcst_type +' / @v_incoterms: ' + @v_incoterms +' / @v_measure: ' + @v_measure +' / @v_plant_site_id: ' + @v_plant_site_id
--PRINT @v_program_name + ' : A00I--@v_cell_prod_site_id: ' + @v_cell_prod_site_id +' / @v_yyyymmdd: ' + @v_yyyymmdd  +' / @v_qty: ' + CONVERT(NVARCHAR(10), @v_qty) +' / @v_currency: ' + @v_currency +' / @v_p_created_by: ' + @v_p_created_by 
								
				INSERT INTO #T_MAIN
				( [ACTION], DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
				, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, QTY_PRICE, CREATED_BY, V_ATTRIBUTE1, V_ATTRIBUTE2, V_ATTRIBUTE3, V_ATTRIBUTE4
				, V_ATTRIBUTE5, V_ATTRIBUTE6, V_ATTRIBUTE7, V_ATTRIBUTE8, V_ATTRIBUTE9, V_ATTRIBUTE10, V_BOM_YN, V_VMI_YN	) 
				VALUES 
				( @v_active_flag, @v_division_id, @v_project_code, @v_end_customer, @v_scm_site_id, @v_item_id, @v_dom_exp, @v_fcst_type, @v_incoterms, @v_measure
				, @v_plant_site_id, @v_cell_prod_site_id, @v_yyyymmdd, @v_currency, @v_qty, @v_p_created_by, '', '', '', ''
				, '', '', '', '', '', '', '', '')
			END
		END

		SELECT @EDIT_CNT = COUNT(1) FROM #T_MAIN
PRINT @v_program_name + ' : A002--' + CONVERT(NVARCHAR(30), GETDATE(), 121);			
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_해당 작업이 시간이 너무 오래 걸려서 주석처리하고 다른 방식으로 진행하도록 하단에 작성 (END)
		-------------------------------------------------------------------------------------------------------------------------------
		--=============================================================================================================================
		-- PARAMETER => TABLE 적재 LOG (START)
		--=============================================================================================================================
		SET @v_log_type		= N'ING';
		SET @v_log_message	= N'■ 1. PARAMETER TO #T_MAIN IMPORT';
		SET @n_log_count	= @i_count;
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();
	
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
		--=============================================================================================================================
		-- PARAMETER => TABLE 적재 LOG (END)
		--=============================================================================================================================
		/* [E20251021-000634]_프로그램 실행하자 마자 하도록 상단에서 실행 (START)
		--=============================================================================================================================
		-- TEMP TABLE DROP (START)
		--=============================================================================================================================
		IF OBJECT_ID (N'tempdb..#mshychu1', N'U') IS NOT NULL 
			DROP TABLE #mshychu1
		IF OBJECT_ID (N'tempdb..#mshychu2', N'U') IS NOT NULL 
			DROP TABLE #mshychu2
		IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 		
			DROP TABLE #T_PRICE
		-------------------------------------------------------------------------------------------------------------------------------
		-- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#T_FCST', N'U') IS NOT NULL 		
			DROP TABLE #T_FCST
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE LOOKUP정보용 테이블 DROP 
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#TEMP_EXCEPTION_BIZ_TYPE', N'U') IS NOT NULL 
			DROP TABLE #TEMP_EXCEPTION_BIZ_TYPE;	
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE과 매핑되는 저장정보 테이블 DROP --[E20251021-000634]_조건문과 DROP문 동일하도록 수정
		-------------------------------------------------------------------------------------------------------------------------------
		IF OBJECT_ID (N'tempdb..#TEMP_EXCEPTION_ITEM_LIST', N'U') IS NOT NULL 
			DROP TABLE #TEMP_EXCEPTION_ITEM_LIST;	
		--=============================================================================================================================
		-- TEMP TABLE DROP (END)
		--=============================================================================================================================		
		--=============================================================================================================================
		-- TEMP TABLE CREATE (START)
		--=============================================================================================================================
		CREATE TABLE #T_PRICE 
		( DIVISION_ID			NVARCHAR(30)
		, PROJECT_CODE			NVARCHAR(50)
		, END_CUSTOMER			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, PLANT_SITE_ID			NVARCHAR(30)
		, CELL_PROD_SITE_ID		NVARCHAR(50)
		, ITEM_ID				NVARCHAR(50)
		, YYYYMMDD				NVARCHAR(8)
		, CURRENCY				NVARCHAR(10)
		, MEASURE				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(20)
		, INCOTERMS				NVARCHAR(10)
		, PRICE					NUMERIC(30,10))
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가
		-------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #T_FCST 
		( DIVISION_ID			NVARCHAR(30)
		, PROJECT_CODE			NVARCHAR(50)
		, END_CUSTOMER			NVARCHAR(50)
		, SCM_SITE_ID			NVARCHAR(30)
		, PLANT_SITE_ID			NVARCHAR(30)
		, CELL_PROD_SITE_ID		NVARCHAR(50)
		, ITEM_ID				NVARCHAR(50)
		, YYYYMMDD				NVARCHAR(8)
		, MEASURE				NVARCHAR(50)
		, DOM_EXP				NVARCHAR(3)
		, FCST_TYPE				NVARCHAR(20)
		, INCOTERMS				NVARCHAR(10))
		
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE LOOKUP정보용 테이블 CREATE 
		-------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #TEMP_EXCEPTION_BIZ_TYPE 
		( DIVISION_ID		NVARCHAR(8)
		, ITEM_ID			NVARCHAR(50)
		, ITEM_TYPE			NVARCHAR(8)
		, SEQ				INT		IDENTITY(1,1))		
				
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250714-000331]_EXCEPTION_BIZ_TYPE과 매핑되는 저장정보 테이블 CREATE 
		-------------------------------------------------------------------------------------------------------------------------------
		CREATE TABLE #TEMP_EXCEPTION_ITEM_LIST 
		(	DIVISION_ID		NVARCHAR(8)
		, ITEM_ID			NVARCHAR(50)
		, ITEM_TYPE			NVARCHAR(8))	
				
		--=============================================================================================================================
		-- TEMP TABLE CREATE (END)
		--=============================================================================================================================
		[E20251021-000634]_프로그램 실행하자 마자 하도록 상단에서 실행 (END)*/ 

		BEGIN TRAN

			SET @n_update_cnt = 0; -- [E20250915-000105]_ROW_COUNT 확인		
			--==========================================================================================================================	
			-- VALIDATION 시작 (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 2. VALIDATION CHECK START';
			SET @n_log_count	= @n_update_cnt
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- VALIDATION 시작 (END)
			--==========================================================================================================================			
			--==========================================================================================================================
			-- Validaion Check (START)
			--==========================================================================================================================
			--==========================================================================================================================
			-- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
			--==========================================================================================================================
			----------------------------------------------------------------------------------------------------------------------------
			-- [E20250912-001720]_수정 저장 VALIDATION 추가 (START)
			----------------------------------------------------------------------------------------------------------------------------
			SELECT DAYOFWEEK AS DAYOFWEEKS
			INTO #TEMP_DAYINFO
			FROM [dbo].[SCM_SYS_CALENDAR_M] WITH (NOLOCK)
			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), GETDATE(), 112)
			
			DECLARE	@TARGET_DATE	NVARCHAR(10);
			DECLARE	@MEASURE		NVARCHAR(100);
			DECLARE	@FROM_TIME		NVARCHAR(4);
			DECLARE	@TO_TIME		NVARCHAR(4);

			SELECT @TARGET_DATE		= A.ATTRIBUTE1
				 , @FROM_TIME		= A.ATTRIBUTE2
				 , @TO_TIME			= A.ATTRIBUTE3
				 , @MEASURE			= A.ATTRIBUTE4
			FROM (  SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, ATTRIBUTE4
					FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
					WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
					AND B.VALID_YN = 'Y' 
					AND B.SEGMENT2 = 'DMF0082' 
					AND ISNULL(B.ATTRIBUTE4, '') != ''
					AND (B.ATTRIBUTE1 = 'ALL' OR B.ATTRIBUTE1 IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
					AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(B.ATTRIBUTE2 AS INT) AND CAST(B.ATTRIBUTE3 AS INT)
					AND B.SEGMENT3 = @V_DIVISION_ID	) A
			GROUP BY A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, ATTRIBUTE4			   			 			

			IF 	(	SELECT COUNT(*) AS CNT
					FROM #T_MAIN A
					INNER JOIN ( SELECT A.SEGMENT3 AS DIVISION_ID, A.ATTRIBUTE1 AS TARGET_DATE, A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, TOKEN AS MEASURE
								 FROM (  SELECT B.SEGMENT3, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3, B.ATTRIBUTE4
										 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
										 WHERE B.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
										 AND B.VALID_YN = 'Y' 
										 AND B.SEGMENT2 = 'DMF0082' 
										 AND ISNULL(B.ATTRIBUTE4, '') != '') A
								 CROSS APPLY STRING_SPLIT(A.ATTRIBUTE4, ',' )) C 
							ON A.DIVISION_ID	= C.DIVISION_ID
						   AND A.MEASURE		= C.MEASURE
					WHERE A.QTY_PRICE <> 0
					AND (C.TARGET_DATE = 'ALL' OR C.TARGET_DATE IN (SELECT DAYOFWEEKS FROM #TEMP_DAYINFO))
					AND CAST(REPLACE(LEFT(CONVERT(VARCHAR,GETDATE(), 108),5), ':', '')AS INT) BETWEEN CAST(C.FROM_TIME AS INT) AND CAST(C.TO_TIME AS INT)) > 1
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	=  @MEASURE+N' 메져는 "'+@TARGET_DATE+N'" 요일의 '+LEFT(@FROM_TIME,2)+':'+RIGHT(@FROM_TIME,2)+N' ~ '+LEFT(@TO_TIME,2)+':'+RIGHT(@TO_TIME,2)+N' 시간에는 수정 불가능합니다.';		
				GOTO ERR_RTN
			END			
			----------------------------------------------------------------------------------------------------------------------------
			-- [E20250912-001720]_수정 저장 VALIDATION 추가 (END)
			----------------------------------------------------------------------------------------------------------------------------
			----------------------------------------------------------------------------------------------------------------------------
			-- 1.1). SALES PRICE 미리 수집
			----------------------------------------------------------------------------------------------------------------------------
			DECLARE @MIN_DATE	NCHAR(8)
			DECLARE @MAX_DATE	NCHAR(8)

			SELECT @MIN_DATE = MIN(BASIS_START_DATE)
				 , @MAX_DATE = MAX(BASIS_END_DATE)
			  FROM SCM_SYS_CALENDAR_M M WITH(NOLOCK) 
			-----------------------------------------------------------------------------------------------------------------------------------
			-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
			/*
			WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
									   AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지*/
			-----------------------------------------------------------------------------------------------------------------------------------
			WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
			AND   M.BASIS_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
			-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
			-----------------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A003--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			----------------------------------------------------------------------------------------------------------------------------
			-- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (START)
			-- Sales Price 52주 구간 확인을 할 때는 UI에서 입력한 값이든, 이미 DB에 있던 값이든 상관없이 데이터가 있다면 상관없다. 
			----------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #T_PRICE
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
			, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE	)
			SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
				 , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, PRICE 
			FROM  (	SELECT DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID
						 , YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS, SUM(PRICE) AS PRICE
					  FROM ( -- DB에 있는 원래 데이터
							 SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID, B.ITEM_ID
										   , B.YYYYMMDD, B.CURRENCY, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PRICE AS PRICE
							   FROM #T_MAIN A
							   JOIN DM_PLN_CFM_SELLING_PRICE B WITH(NOLOCK)
								 ON A.DIVISION_ID       = B.DIVISION_ID
								AND A.PROJECT_CODE      = B.PROJECT_CODE
								AND A.END_CUSTOMER      = B.END_CUSTOMER
								AND A.SCM_SITE_ID       = B.SCM_SITE_ID
								AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
								AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
								AND A.ITEM_ID           = B.ITEM_ID
								AND A.DOM_EXP           = B.DOM_EXP
								AND A.FCST_TYPE         = B.FCST_TYPE
								AND A.INCOTERMS         = B.INCOTERMS
							 WHERE B.DIVISION_ID	= A.DIVISION_ID
							   AND B.YYYYMMDD BETWEEN @MIN_DATE AND @MAX_DATE
							   AND B.PRICE <> 0
							   AND B.MEASURE = 'LOC'
							 UNION 
							----------------------------------------------------------------------------------------------------------------------------
							-- UI에서 입력한 신규 데이터 혹은 기존 DB 값을 UI에서 수정한 데이터
							-- MKT Fcst 와 같이 입력되는 Price의 경우 Validation에 포함 (UI에서 MKT_FCST MEASURE랑 LOC MEASURE를 동시에 입력하는 경우를 말함)
							----------------------------------------------------------------------------------------------------------------------------
							SELECT DISTINCT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ITEM_ID
										  , A.YYYYMMDD, A.CURRENCY, A.MEASURE, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.QTY_PRICE AS PRICE
							  FROM #T_MAIN A
							 WHERE A.YYYYMMDD BETWEEN @MIN_DATE AND @MAX_DATE
							   AND A.QTY_PRICE <> 0
							   AND A.MEASURE = 'LOC' ) A 
							 GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS ) AA
			----------------------------------------------------------------------------------------------------------------------------
			-- 1.2). Sales Price 52주 구간 데이터 TEMP 테이블 INSERT (END)
			----------------------------------------------------------------------------------------------------------------------------
PRINT @v_program_name + ' : A004--' + CONVERT(NVARCHAR(30), GETDATE(), 121);
			----------------------------------------------------------------------------------------------------------------------------
			-- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (START)  
			-- 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 
			----------------------------------------------------------------------------------------------------------------------------			
			INSERT INTO #T_FCST
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, PLANT_SITE_ID, CELL_PROD_SITE_ID
			, ITEM_ID, YYYYMMDD, MEASURE, DOM_EXP, FCST_TYPE, INCOTERMS	)
			SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.CELL_PROD_SITE_ID
						  , B.ITEM_ID, B.YYYYMMDD, B.MEASURE, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS
			FROM #T_MAIN A
            JOIN DM_PLN_CFM_MKT_DEMAND_PLAN B WITH(NOLOCK)
              ON A.DIVISION_ID		= B.DIVISION_ID
             AND A.PROJECT_CODE		= B.PROJECT_CODE
             AND A.END_CUSTOMER		= B.END_CUSTOMER
             AND A.SCM_SITE_ID		= B.SCM_SITE_ID
             AND A.PLANT_SITE_ID	= B.PLANT_SITE_ID
             --AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
             AND A.ITEM_ID			= B.ITEM_ID
             AND A.DOM_EXP			= B.DOM_EXP
             AND A.FCST_TYPE		= B.FCST_TYPE
             AND A.INCOTERMS		= B.INCOTERMS
			 AND A.YYYYMMDD			= B.YYYYMMDD
			 AND A.MEASURE			= B.MEASURE
		   WHERE B.DIVISION_ID		= A.DIVISION_ID
			 AND B.QTY <> 0
			 --AND B.CELL_PROD_SITE_ID = '-'
			 AND A.MEASURE IN ( 'MKT_FCST', 'VMI_In_Req', 'SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
			----------------------------------------------------------------------------------------------------------------------------
			-- 1.3). 입력된 데이터의 기존 셀 생산지 데이터 수집 (END)  
			----------------------------------------------------------------------------------------------------------------------------
			--==========================================================================================================================
			-- 1. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A005--' + CONVERT(NVARCHAR(30), GETDATE(), 121);				
			--==========================================================================================================================
			-- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (START)
			--==========================================================================================================================
			----------------------------------------------------------------------------------------------------------------------------
			-- 2.1). #T_MAIN 테이블의 VMI_YN UPDATE
			----------------------------------------------------------------------------------------------------------------------------
			UPDATE A
			SET V_VMI_YN = CASE WHEN ISNULL(B.VMI_YN, '') = 'Y' THEN 'Y' ELSE 'N' END
			FROM #T_MAIN A
			JOIN SCM_MST_SITE B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
				
			----------------------------------------------------------------------------------------------------------------------------
			-- 2.2).AS 이더라도 AS Plant 에는 Attribute10 을 지워준다.
			----------------------------------------------------------------------------------------------------------------------------
			UPDATE A
			SET v_ATTRIBUTE10 = ''
			FROM #T_MAIN A
			where SCM_SITE_ID = v_ATTRIBUTE10
	
			--==========================================================================================================================
			-- 2. 40 Validation 필요 대상 : VMI Site 여부 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A006--' + CONVERT(NVARCHAR(30), GETDATE(), 121);						
			--==========================================================================================================================
			-- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (START)
			--==========================================================================================================================
			DECLARE	@FROM_DATE		NCHAR(8)
			DECLARE	@TO_DATE		NCHAR(8);

			SELECT @FROM_DATE = MIN(BASIS_YYYYMMDD), @TO_DATE = MAX(BASIS_YYYYMMDD)
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
			JOIN SCM_SYS_CALENDAR_M C WITH(NOLOCK)
			  ON C.BASIS_YYYYMM = L.ATTRIBUTE1 OR C.BASIS_YYYYMM = L.ATTRIBUTE2
			WHERE L.LOOKUP_TYPE = 'DM_LONG_PLAN' AND L.SEGMENT1 = '40' AND L.SEGMENT2 = 'MKT FCST' AND L.VALID_YN = 'Y'
			
			---------------------------------------------------------------------------------------------------------------------------
			-- 소형일 경우 중장기계획 관련 2022년 입력 마감여부 확인
			-- 소형이고 2022년이 마감되어있는데, 2022년 데이터가 들어있으면 에러처리
			---------------------------------------------------------------------------------------------------------------------------
			IF @V_DIVISION_ID = '40' AND EXISTS ( SELECT * FROM #T_MAIN R  WHERE R.YYYYMMDD <  @FROM_DATE OR R.YYYYMMDD > @TO_DATE)
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	=  @FROM_DATE + N' ~ ' + @TO_DATE + N' 구간 내의 데이터만 수정할 수 있습니다.';		
				GOTO ERR_RTN
			END			
			--==========================================================================================================================
			-- 3. 40 Validation 필요 대상 : 중장기 구간 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A007--' + CONVERT(NVARCHAR(30), GETDATE(), 121);						

			--==========================================================================================================================
			-- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (START)
			--==========================================================================================================================
			IF @V_DIVISION_ID = '40' AND EXISTS ( SELECT * FROM #T_MAIN R WHERE R.INCOTERMS IN ( SELECT OLD_VALUE1 FROM [dbo].[NERP_CONV_MASTER] WITH(NOLOCK) WHERE CODETYPE = 'INCOTERMS_ID' GROUP BY OLD_VALUE1))
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	=  N'구코드 INCOTERMS는 저장할 수 없습니다.';		
				GOTO ERR_RTN
			END			
			--==========================================================================================================================
			-- 3-1. [E20250919-001699]_Incoterms 데이터 처리 VALID 처리 (END)
			--==========================================================================================================================

			--==========================================================================================================================
			-- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (START)
			--==========================================================================================================================
			DECLARE @s_BLOCK_Model			NVARCHAR(MAX);

			SET @s_BLOCK_Model = '';
			SET @s_BLOCK_Model = ISNULL(( SELECT TOP 1 ITEM_ID FROM #T_MAIN A 
										  WHERE 1 = 1
										  AND ( SELECT COUNT(1)
												  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
												 WHERE LOOKUP_TYPE = 'FCST_EXCEPT_MODEL' AND SEGMENT1 = '40' AND VALID_YN = 'Y'	AND SEGMENT2 = A.ITEM_ID ) > 0
										  AND A.QTY_PRICE <> 0), '') 

			IF @s_BLOCK_Model <> ''
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	= 'Model : ' + @s_BLOCK_Model +char(10) + N'FCST INPUT BLOCK Model. contact 영업관리팀'
				GOTO ERR_RTN
			END
			--==========================================================================================================================
			-- 4. 40 Validation 필요 대상 : MKT Fcst Exception Model 대상 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A008--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)
			--==========================================================================================================================
			BEGIN
				SET @valid_item_id = ( SELECT TOP 1 A.ITEM_ID FROM #T_MAIN A
										WHERE NOT EXISTS ( SELECT ITEM.DIVISION_ID  
															FROM SCM_MST_SITE_ITEM ITEM WITH(NOLOCK)
															   , SCM_MST_ITEM_SN SN WITH(NOLOCK)  
															WHERE 1 = 1
 															  AND ITEM.DIVISION_ID   = A.DIVISION_ID 
															  AND ITEM.SCM_SITE_ID   = A.SCM_SITE_ID
															  AND ITEM.ITEM_ID       = A.ITEM_ID 
															  AND ITEM.DIVISION_ID   = SN.DIVISION_ID
															  AND ITEM.ITEM_ID       = SN.ITEM_ID 
															  AND SN.ACTIVE_FLAG = 'Y' 
															  AND ITEM.VALID_YN = 'Y' ))

				IF @valid_item_id IS NOT NULL
				BEGIN
					SET @v_log_type		= 'INVALID';
					SET @v_description	= '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
					goto err_rtn
				END
			END
			--==========================================================================================================================
			-- 5. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A009--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (START)
			--==========================================================================================================================
			DECLARE @v_BIZ_TYPE_CHECK			NVARCHAR(500);
			SET		@v_BIZ_TYPE_CHECK = NULL
			----------------------------------------------------------------------------------------------------------------------------
			--[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (STRAT)
			
			----------------------------------------------------------------------------------------------------------------------------
			-- 6.1). 룩업: EXCEPTION_BIZ_TYPE 데이터를 #TEMP_EXCEPTION_BIZ_TYPE에 담는다.
			----------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #TEMP_EXCEPTION_BIZ_TYPE
			( DIVISION_ID, ITEM_ID, ITEM_TYPE)
			SELECT SEGMENT1 AS DIVISION_ID, SEGMENT2 AS ITEM_ID, SEGMENT3 AS ITEM_TYPE
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
			WHERE LOOKUP_TYPE = N'EXCEPTION_BIZ_TYPE'
			AND VALID_YN = 'Y'		
			AND SEGMENT1 = @V_DIVISION_ID		
			
			----------------------------------------------------------------------------------------------------------------------------
			-- 6.2). 룩업에 저장된 데이터가 1건 이상인 경우가 존재할 수 있으므로, LOOP 실행하여, 
			--	     한건씩 매핑된 데이터로 #TEMP_EXCEPTION_ITEM_LIST에 데이터 적재
			--       ITEM_ID 일부로 시작하는 것으로 요청했으므로 뒷쪽만 LIKE 처리하여 데이터 처리
			----------------------------------------------------------------------------------------------------------------------------
			DECLARE @ROWCNT						INT			
			DECLARE @I							INT
			DECLARE @CNT						INT	

			SET @ROWCNT = @@ROWCOUNT
			
			SELECT @I = 1, @CNT = COUNT(*)
			FROM #TEMP_EXCEPTION_BIZ_TYPE WITH(NOLOCK);
			
			DECLARE @V_EXCEPTION_DIVISION_ID	VARCHAR(8)
			DECLARE @V_EXCEPTION_ITEM_ID		VARCHAR(50);
			DECLARE @V_EXCEPTION_ITEM_TYPE		VARCHAR(8);
			DECLARE @v_sql_text					NVARCHAR(MAX);

			DECLARE @V_EXCEPTION_COUNT			INT;
			SET		@V_EXCEPTION_COUNT	= 0;
					   			 		  		  		 
			WHILE ( @I <= @CNT )
			BEGIN			
				SELECT @V_EXCEPTION_DIVISION_ID	= A.DIVISION_ID
					 , @V_EXCEPTION_ITEM_ID		= A.ITEM_ID
					 , @V_EXCEPTION_ITEM_TYPE	= A.ITEM_TYPE
				FROM #TEMP_EXCEPTION_BIZ_TYPE A WITH(NOLOCK)
				WHERE SEQ = @I;		

				INSERT INTO #TEMP_EXCEPTION_ITEM_LIST
				( DIVISION_ID, ITEM_ID, ITEM_TYPE)
				SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, @V_EXCEPTION_ITEM_TYPE AS ITEM_TYPE
				FROM #T_MAIN A WITH(NOLOCK)
				WHERE A.DIVISION_ID = @V_EXCEPTION_DIVISION_ID
				AND   A.ITEM_ID LIKE '' + @V_EXCEPTION_ITEM_ID + '%';

			SET @I += 1
			END
			
			----------------------------------------------------------------------------------------------------------------------------
			-- 6.3).  #TEMP_EXCEPTION_ITEM_LIST에 존재하는 데이터는 NOT EXISTS 체크하여 VALIDATION 체크한다. 
			----------------------------------------------------------------------------------------------------------------------------
			BEGIN			
				SET @v_BIZ_TYPE_CHECK =  ( 	SELECT TOP 1 A.ITEM_ID 
											FROM (	SELECT T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
													FROM #T_MAIN T1 WITH (NOLOCK)
													OUTER APPLY (	SELECT T2.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE
																	FROM SCM_ITEM_M_SN T2 WITH(NOLOCK)
																	WHERE 1=1
																	AND T1.DIVISION_ID	= T2.DIVISION_ID
																	AND T1.ITEM_ID		= T2.ITEM_ID
																	AND T2.ACTIVE_FLAG = 'Y' ) T2
													WHERE T1.[ACTION] = 'I'
													AND T2.FORECAST_INFO_BIZ_TYPE IS NULL
													GROUP BY T1.DIVISION_ID, T1.ITEM_ID, T2.ITEM_TYPE, T2.FORECAST_INFO_BIZ_TYPE ) A
											WHERE NOT EXISTS (	SELECT B.ITEM_ID
																FROM #TEMP_EXCEPTION_ITEM_LIST B WITH (NOLOCK)
																WHERE A.DIVISION_ID = B.DIVISION_ID
																AND   A.ITEM_ID = B.ITEM_ID
																AND   A.ITEM_TYPE = B.ITEM_TYPE )
											GROUP BY A.ITEM_ID 
											/*
											SELECT STRING_AGG(A.ITEM_ID,',') WITHIN GROUP(ORDER BY A.ITEM_ID)
											FROM(
											SELECT TOP 10 T1.ITEM_ID -- 최대 10개씩 표시
											FROM #T_MAIN T1 WITH (NOLOCK)
											-------------------------------------------------------------------------------------
											--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : BIZ TYPE 검증 로직 보완 START
											--FORECAST_INFO_BIZ_TYPE가 NULL 이 아닌 값이 하나라도 있으면 PASS
											OUTER APPLY (SELECT TOP(1) 
																T2.ITEM_ID
																, T2.FORECAST_INFO_BIZ_TYPE
															FROM [SCM_ITEM_M_SN] T2 WITH (NOLOCK) 
															WHERE 1=1
															AND T1.DIVISION_ID = T2.DIVISION_ID
															AND T1.ITEM_ID = T2.ITEM_ID 
															AND T2.ACTIVE_FLAG = 'Y'
															ORDER BY ISNULL(T2.FORECAST_INFO_BIZ_TYPE,'ZZZZZZ') ) T2
											/*LEFT JOIN [SCM_ITEM_M_SN] T2 WITH (NOLOCK) 
											ON  T1.DIVISION_ID = T2.DIVISION_ID
											AND T1.ITEM_ID = T2.ITEM_ID */
											--[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : BIZ TYPE 검증 로직 보완 END
											-------------------------------------------------------------------------------------
											WHERE T2.FORECAST_INFO_BIZ_TYPE IS NULL
											AND T1.[ACTION] = 'I' -- 20250520 신규 일때만 Validation Check를 진행 한다.
											--AND T2.ACTIVE_FLAG = 'Y' --[PJ2025-50188]소형 매출계획 동기화 개선 고도화 : 주석처리
											GROUP BY T1.ITEM_ID
											)A
											*/
										)
			--[E20250714-000331]_[공급생산 SCM PI팀] FCSTPrice MGMT화면 전극(AP) Item id 입력 시 Biz Type Validation 제외 요청 (END)
			-----------------------------------------------------------------------------------------------------------------------
				IF @v_BIZ_TYPE_CHECK IS NOT NULL
					BEGIN
						--BIZ_TYPE 이 없어서 저장을 할 수 없습니다.
						--[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (START)
						--SET @v_description = N'Model*: ' + @v_BIZ_TYPE_CHECK + N'는 BIZ_TYPE 이 없어서 저장을 할 수 없습니다.' --[E20260608-000294]_원소스 주석
						SET @v_description = N'1. MDM에서 Biz Type을 입력하시기 바랍니다.'+ CHAR(10) +N'2. MDM에 Biz Type이 입력된 상태면 SCM_FP에 CSR 요청하시기 바랍니다.'	
						--[E20260608-000294]_문구변경 요청으로 인하여 문구 변경 진행 (END)
						SET @v_log_type = 'INVALID';
						GOTO ERR_RTN;	
					END
			END
			--==========================================================================================================================
			-- 6. 40 Validation 필요 대상 : BIZ_TYPE 존재여부 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A010--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (START)
			--==========================================================================================================================
			DECLARE @v_CELL_TYPE_CHECK		NVARCHAR(500);
			SET @v_CELL_TYPE_CHECK = NULL

			BEGIN			
				SET @v_CELL_TYPE_CHECK = ( SELECT STRING_AGG(A.ITEM_ID,',') WITHIN GROUP(ORDER BY A.ITEM_ID)
											FROM ( SELECT TOP 10 T1.ITEM_ID -- 최대 10개씩 표시
													 FROM #T_MAIN T1 WITH (NOLOCK) 
													 LEFT JOIN SCM_ITEM_M_SN T2 WITH (NOLOCK) 
													   ON T1.DIVISION_ID = T2.DIVISION_ID AND T1.ITEM_ID = T2.ITEM_ID 	
												    WHERE (T2.FORECAST_INFO_BIZ_TYPE = 'CELL' --CELL인 데이터 중에서
														  --마스터상 CELL이 아니라도 ITEM_ID가 MC로 시작하면 CELL 이라고 판단함.
													   OR T1.ITEM_ID LIKE 'MC%')
													  AND T1.CELL_PROD_SITE_ID = '-' -- Common은 Name 이고 , '-'는 Code 이다.
													  AND T2.ACTIVE_FLAG = 'Y'
													  AND ISNULL(T1.QTY_PRICE, 0) <> 0 
													  AND (T1.[ACTION] = 'I' -- 신규 일때만 Validation Check를 진행 한다.
										   --계획구간부터 MKT_FCST 메저의 값이 0이 아닌 데이터가 있는지 확인 (없으면 검증 대상)
										   OR NOT EXISTS ( SELECT 1 FROM DM_PLN_CFM_MKT_DEMAND_PLAN X WITH(NOLOCK)
															WHERE 1=1
															  AND T1.DIVISION_ID       = X.DIVISION_ID
															  AND T1.PROJECT_CODE      = X.PROJECT_CODE
															  AND T1.END_CUSTOMER      = X.END_CUSTOMER
															  AND T1.SCM_SITE_ID       = X.SCM_SITE_ID
															  AND T1.PLANT_SITE_ID     = X.PLANT_SITE_ID
															  AND T1.CELL_PROD_SITE_ID = X.CELL_PROD_SITE_ID
															  AND T1.ITEM_ID           = X.ITEM_ID
															  AND T1.DOM_EXP           = X.DOM_EXP
															  AND T1.FCST_TYPE         = X.FCST_TYPE
															  AND T1.INCOTERMS         = X.INCOTERMS
															  AND X.MEASURE			  = 'MKT_FCST'
															  AND X.YYYYMMDD		  >= @plan_start_yyyymmdd 
															  AND X.QTY				  <> 0))
									GROUP BY T1.ITEM_ID	) A
								)
				
				IF @v_CELL_TYPE_CHECK IS NOT NULL
					BEGIN
						SET @v_description	= N'Model*: ' + @v_CELL_TYPE_CHECK + N'는 Cell Prod Site* 를 Common으로 등록 할 수 없습니다.'
						SET @v_log_type		= 'INVALID';
						GOTO ERR_RTN;	
					END
				END
			--==========================================================================================================================
			-- 7. 40 Validation 필요 대상 : ITEM_ID가 CELL인 경우 CELL_PROD_SITE_ID를 Common으로 등록 할 수 없습니다 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A011--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (START)
			--==========================================================================================================================		
			DECLARE @s_cell_prod_valid			NVARCHAR(1000);
			SET @s_cell_prod_valid = null;
			
			BEGIN			
				SET @s_cell_prod_valid = ( SELECT TOP 1 A.ITEM_ID
											FROM ( SELECT P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID, P.ITEM_ID, P.YYYYMMDD
														, P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID AS CELL_PROD_SITE_FCST, T.CELL_PROD_SITE_ID AS CELL_PROD_SITE_MAIN
													FROM #T_FCST P 
												   INNER JOIN #T_MAIN T
														   ON ( T.DIVISION_ID      = P.DIVISION_ID         
														  AND T.PROJECT_CODE       = P.PROJECT_CODE      
														  AND T.END_CUSTOMER       = P.END_CUSTOMER
														  AND T.SCM_SITE_ID        = P.SCM_SITE_ID
														  AND T.PLANT_SITE_ID      = P.PLANT_SITE_ID
														  AND T.ITEM_ID            = P.ITEM_ID     
														  AND T.YYYYMMDD           = P.YYYYMMDD 
														  AND T.MEASURE            = P.MEASURE      
														  AND T.DOM_EXP            = P.DOM_EXP      
														  AND T.FCST_TYPE          = P.FCST_TYPE      
														  AND T.INCOTERMS          = P.INCOTERMS  
														  AND T.CELL_PROD_SITE_ID <> P.CELL_PROD_SITE_ID )
											WHERE T.[ACTION] = 'I'
											GROUP BY P.DIVISION_ID, P.PROJECT_CODE, P.END_CUSTOMER, P.SCM_SITE_ID, P.PLANT_SITE_ID
												   , P.ITEM_ID, P.YYYYMMDD, P.MEASURE, P.DOM_EXP, P.FCST_TYPE, P.INCOTERMS, P.CELL_PROD_SITE_ID, T.CELL_PROD_SITE_ID 
											HAVING P.CELL_PROD_SITE_ID = '-' OR  T.CELL_PROD_SITE_ID = '-' ) A
										 )

				IF @s_cell_prod_valid IS NOT NULL
					BEGIN
						SET @v_description = N'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.'
						SET @v_log_type = 'INVALID';
						GOTO ERR_RTN;	
					END
			END
			--==========================================================================================================================
			-- 8. 40 Validation 필요 대상 : 셀 생산지가 Common인 경우에 다른 생산지는 입력 불가하도록 Validation 추가 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A012--' + CONVERT(NVARCHAR(30), GETDATE(), 121);		
			
			--==========================================================================================================================
			-- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (START)
			-- Common 식별을 위해 Common의 Dash 값은 XX로 치환하고 XX 를 포함 두개 이상의 Cell Prod Site가 입력되었는지를 확인.
			--==========================================================================================================================				
			SET @s_cell_prod_valid = null;			
			BEGIN			
				SET @s_cell_prod_valid = ( SELECT TOP 1 'N'
											FROM ( SELECT T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
														, T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
														, STRING_AGG(IIF(T.CELL_PROD_SITE_ID='-', 'XX', T.CELL_PROD_SITE_ID), ', ') AS CELL_PROD_ALL
												  FROM   #T_MAIN T
												  WHERE T.[ACTION] = 'I'
												  GROUP BY T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.PLANT_SITE_ID
														 , T.ITEM_ID, T.YYYYMMDD, T.MEASURE, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
												  HAVING COUNT(*) > 1 )  A
											WHERE CHARINDEX('XX', A.CELL_PROD_ALL) > 0 )

				IF @s_cell_prod_valid IS NOT NULL
					BEGIN
						SET @v_description	= N'Common과 다른 Cell Prod SIte를 중복으로 입력할 수 없습니다.'
						SET @v_log_type		= 'INVALID';
						GOTO ERR_RTN;	
					END
			END
			
			--==========================================================================================================================
			-- 9. 40 Validation 필요 대상 : #T_MAIN 에 들어온 Site가 Common을 포함 두 건 이상인 경우 Invalid 처리 (END)
			--==========================================================================================================================		
PRINT @v_program_name + ' : A013--' + CONVERT(NVARCHAR(30), GETDATE(), 121);			

			--==========================================================================================================================
			-- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (START)
			--==========================================================================================================================
			/* @s_unit_price_valid 변수내에는 Null이 발생하는 컬럼값이 존재하면 안됨 (변수전체가 Null로 저장됨)  */
			SELECT MST.SEGMENT2 
			INTO #mshychu1										  
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)  -- SCM_FCST - MEASURE 추가, 아래의 룩업에 SCM_FCST 정보를 추가했습니다.
			WHERE 1=1
			AND MST.LOOKUP_TYPE		= 'MKT_FCST_VALIDATION_PRICE'
			AND MST.SEGMENT1		= 'MEASURE'
			AND MST.VALID_YN			= 'Y' 

			SELECT MST.SEGMENT2 
			INTO #mshychu2 
			FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)
			WHERE 1=1
			AND MST.LOOKUP_TYPE		= 'MKT_FCST_VALIDATION_PRICE'
			AND MST.SEGMENT1		= 'FCST_TYPE'
			AND MST.VALID_YN        = 'Y' 
	
			DECLARE @s_unit_price_valid				NVARCHAR(1000);
			SET @s_unit_price_valid = null;
			SET @s_unit_price_valid = (	SELECT TOP 1	 'End Customer________ : '   + ISNULL(A.END_CUSTOMER ,'')
											+ CHAR(10) + 'Sales site_____________ : '+ ISNULL(A.SCM_SITE_ID ,'') 
											+ CHAR(10) + 'Model________________ : '  + ISNULL(A.ITEM_ID ,'')  
											+ CHAR(10) + 'Customs Handbook__ : '     + ISNULL(A.DOM_EXP ,'')    
											+ CHAR(10) + 'Fcst Type_____________ : ' + ISNULL(( SELECT TOP 1 SEGMENT2 FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)
																								WHERE 1 = 1
																								  AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																								  AND MST.SEGMENT1    = A.FCST_TYPE),'') 
											+ CHAR(10) + 'Incoterms____________ : '    + ISNULL(A.INCOTERMS ,'')    
											+ CHAR(10) + 'Plant Site___________ : '    + ISNULL(A.PLANT_SITE_ID ,'')    
                                            + CHAR(10) + 'Cell Prod Site___________ : '+ ISNULL(A.CELL_PROD_SITE_ID ,'')    
											+ CHAR(10) + 'YYYYMMDD_________ : '        + ISNULL(MIN(M.BASIS_START_DATE),'')  + ' ~ ' + ISNULL(MAX(M.BASIS_START_DATE),'')   
											+ CHAR(10) + CHAR(10)
										FROM #T_MAIN A
										INNER JOIN SCM_MST_SITE_ITEM Z WITH(NOLOCK)
												ON A.DIVISION_ID = z.DIVISION_ID
											   AND A.PROJECT_CODE   	 = z.PROJECT_CODE
											   AND A.SCM_SITE_ID		 = z.SCM_SITE_ID
											   AND A.ITEM_ID			 = z.ITEM_ID
											   AND z.VALID_YN			 = 'Y'
											   AND ( z.SALES_PLAN_ADJUST_YN = 'Y' OR z.SALES_PLAN_ADJUST_YN = '' OR z.SALES_PLAN_ADJUST_YN IS NULL ) 
										LEFT JOIN (	SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M M WITH(NOLOCK) 										
													-----------------------------------------------------------------------------------------------------------------------------------
													-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
													/*
													WHERE M.BASIS_YYYYMMDD BETWEEN CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
																				AND CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지 */
													-----------------------------------------------------------------------------------------------------------------------------------
													WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  --당주 월요일부터
													AND   M.BASIS_YYYYMMDD	< CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)  -- 52주후 월요일까지
													-- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
													-----------------------------------------------------------------------------------------------------------------------------------
													GROUP BY BASIS_START_DATE ) M
											    ON 1=1
										LEFT HASH JOIN #T_PRICE P WITH (NOLOCK)
													ON ( A.DIVISION_ID     = P.DIVISION_ID
												   AND A.PROJECT_CODE      = P.PROJECT_CODE
												   AND A.END_CUSTOMER      = P.END_CUSTOMER
												   AND A.SCM_SITE_ID       = P.SCM_SITE_ID
												   AND A.PLANT_SITE_ID     = P.PLANT_SITE_ID
												   AND A.CELL_PROD_SITE_ID = P.CELL_PROD_SITE_ID
												   AND A.ITEM_ID           = P.ITEM_ID
												   AND A.DOM_EXP           = P.DOM_EXP
												   AND A.FCST_TYPE         = P.FCST_TYPE
												   AND A.INCOTERMS         = P.INCOTERMS
												   AND P.YYYYMMDD          = M.BASIS_START_DATE
												   AND P.PRICE             > 0 )
										WHERE 1=1
										  AND P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
										  AND A.MEASURE IN (SELECT * FROM #mshychu1 )
										  AND A.QTY_PRICE <> 0
										  AND A.FCST_TYPE NOT IN (  SELECT * FROM #mshychu2 )
										GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID ,A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD 
										ORDER BY A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, P.YYYYMMDD )
						
			IF @s_unit_price_valid IS NOT NULL
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	= @s_unit_price_valid + N'Unit Price Not Found !'+ CHAR(10) + N'해당주차의 Sales Price 값을 입력하시기 바랍니다.'+ CHAR(10) + N'미래구간 52주차까지 Sales Price 값이 모두 입력되어야 합니다.'
				GOTO ERR_RTN
			END
			
			--==========================================================================================================================
			-- 10. 40 Validation 필요 대상 : Sales Price 52주 구간 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A014--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (START)
			--==========================================================================================================================
			IF ( SELECT ISNULL(COUNT(*), 0) FROM #T_MAIN 
				  WHERE FCST_TYPE = 'RMA'
                   AND MEASURE IN ('MKT_FCST','SCM_FCST')
				   AND ISNULL(CAST(QTY_PRICE AS NUMERIC(30,10)), 0) > 0) > 0
			BEGIN
				SET @v_log_type		= 'INVALID';
				SET @v_description	= N'반품수량(RMA)은 음수값만 입력가능합니다 !'
				GOTO ERR_RTN
			END
			--==========================================================================================================================
			-- 11. 40 Validation 필요 대상 : RMA 음수 Validation은 MKT_FCST, SCM_FCST Measure에 한정 필요 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A015--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (START)
			--==========================================================================================================================
			IF ( SELECT ISNULL(COUNT(*), 0) FROM #T_MAIN 
				  WHERE FCST_TYPE <> 'RMA'
				   AND ISNULL(CAST(QTY_PRICE AS NUMERIC(30,10)), 0) < 0 ) > 0
			BEGIN
				SET @v_log_type = 'INVALID';
				SET @v_description = N'정수값만 입력가능합니다 !'
				GOTO ERR_RTN
			END
			--==========================================================================================================================
			-- 12. 40 Validation 필요 대상 : RMA 이외 정수값 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A016--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 13. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (START)
			-- 저장하려는 ITEM의 11주 구간에 BOM이 없으면 값을 저장하지 못하도록 함
			--==========================================================================================================================
			BEGIN
				UPDATE A
				SET V_BOM_YN = 'N'
				FROM #T_MAIN A
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) 
				  ON B.LOOKUP_TYPE	= 'AS_SITE_PLANT' 
				 AND B.SEGMENT3		= @V_DIVISION_ID
				 AND B.VALID_YN		= 'Y'
				 AND A.V_ATTRIBUTE10 = B.SEGMENT2
				JOIN SCM_MST_ITEM_SN C WITH(NOLOCK) ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK) ON D.LOOKUP_TYPE = 'DM_BOM_EXCEPT_CLASS' AND D.VALID_YN = 'Y' AND C.EVAL_CLASS	= D.SEGMENT1
				WHERE A.DIVISION_ID	= @V_DIVISION_ID
				AND A.MEASURE IN ('MKT_FCST','SCM_FCST') --SCM_FCST - MEASURE 추가
													
				IF EXISTS ( SELECT * FROM #T_MAIN WHERE V_BOM_YN IS NULL)
				BEGIN
					-- 저장전 변수 초기화
					DECLARE @valid_bom		 NVARCHAR(MAX);
					SET @valid_bom		= NULL
					SET @valid_shipto	= NULL

					SET @valid_bom = ( SELECT TOP 1 A.ITEM_ID
										 FROM #T_MAIN A
										INNER JOIN DM_MST_ITEM_SINGLE_V C WITH(NOLOCK)
												ON  A.ITEM_ID			= C.ITEM_ID
											   AND A.DIVISION_ID		= C.DIVISION_ID
											   AND C.ITEM_TYPE IN ( 'P','H' )
											   AND C.ACTIVE_FLAG		= 'Y' 
										LEFT JOIN SCM_MST_BOM_ENG_SN X WITH(NOLOCK)	ON A.DIVISION_ID = X.DIVISION_ID AND A.ITEM_ID = X.PARENT_ITEM_ID
										LEFT JOIN (	SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE, TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
													 FROM SCP_MST_BOD_V WITH(NOLOCK)
													WHERE PRIORITY = 1
													GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END, TO_SITE, INCOTERMS ) BOD  
												ON A.DIVISION_ID		= BOD.DIVISION_ID
											   AND A.PLANT_SITE_ID	    = BOD.FROM_SITE
											   AND A.SCM_SITE_ID		= BOD.TO_SITE
											   AND A.INCOTERMS		    = BOD.INCOTERMS
									   WHERE A.MEASURE IN ('MKT_FCST','Vmi_In_Req','SCM_FCST') --SCM_FCST - MEASURE 추가
									     AND A.YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
									     AND A.YYYYMMDD	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*10) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일 + 11주 까지
									     AND A.QTY_PRICE > 0
									     AND X.PARENT_ITEM_ID IS NULL  -- 존재하지 않는대상
									     AND A.ITEM_ID NOT IN ('ECE0074N5-01')  
									     AND A.ITEM_ID NOT IN ('MCCH120022B2-K','MCCH120022B2-GD')  
									     AND A.V_BOM_YN IS NULL	)

					IF @valid_bom IS NOT NULL
						BEGIN
							SET @v_log_type		= 'INVALID';
							SET @v_description	= '['+ @valid_bom +']'+ N' BOM does not exist !'
							goto err_rtn
						END
					END
			END

			--==========================================================================================================================
			-- 14. 40 Validation 필요 대상 :  BOM Valid 여부 확인 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A017--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (START)
			-- 저장하려는 SITE의 11주 구간에 SHIPTO 연결 없으면 값을 저장하지 못하도록 함
			--==========================================================================================================================
			BEGIN
				SET @valid_shipto =	( SELECT TOP 1 A.SCM_SITE_ID
									   FROM #T_MAIN A
									   LEFT JOIN SCM_MST_SITE_CUSTOMER X WITH(NOLOCK)
											  ON A.DIVISION_ID		= X.DIVISION_ID
											 AND A.SCM_SITE_ID		= X.SCM_SITE_ID
											 AND X.VALID_YN			= 'Y'
											 AND X.REP_YN			= 'Y'
									   LEFT JOIN ( SELECT DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END FROM_SITE, TO_SITE, INCOTERMS, MIN(LT_TOTAL) AS LT_TOTAL
													 FROM SCP_MST_BOD_V WITH(NOLOCK)
													WHERE PRIORITY = 1
													GROUP BY DIVISION_ID, CASE WHEN DIVISION_ID IN ('82','40') THEN '' ELSE FROM_SITE END, TO_SITE, INCOTERMS) BOD  
											  ON A.DIVISION_ID		= BOD.DIVISION_ID
											 AND A.PLANT_SITE_ID	= BOD.FROM_SITE
											 AND A.SCM_SITE_ID		= BOD.TO_SITE
											 AND A.INCOTERMS		= BOD.INCOTERMS
										WHERE A.MEASURE	IN ('MKT_FCST','Vmi_In_Req','SCM_FCST') --[PJ2025-50188] SCM_FCST - MEASURE 추가
										  AND A.YYYYMMDD	>= CONVERT(CHAR(8), DATEADD(DD, -7*1, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- 당주 월요일부터
										  AND A.YYYYMMDD	< CONVERT(CHAR(8), DATEADD(DD, ISNULL(LT_TOTAL,0)+(7*3) , DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)   -- BOD LT + 4W
										  AND A.QTY_PRICE	> 0
										  AND X.SHIPTO_CODE IS NULL	)
				IF @valid_shipto IS NOT NULL
					BEGIN
						SET @v_log_type		= 'INVALID';
						SET @v_description	= '['+ @valid_shipto +']'+ N' SITE SHIP-TO does not exist !'
						goto err_rtn
					END
			END
			--==========================================================================================================================
			-- 15. 40 Validation 필요 대상 :  ShipTo Valid 여부 확인 (END)			
			--==========================================================================================================================
PRINT @v_program_name + ' : A018--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	


			--==========================================================================================================================
			-- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (START)			
			--==========================================================================================================================
			BEGIN
				SET @plan_start_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)  -- 월요일 변수설정

				DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
				WHERE MEASURE = 'RTF_SYS_RP'  
				AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
				AND EXISTS ( SELECT RSLT.DIVISION_ID 
							   FROM #T_MAIN RSLT
							      , DM_MST_ITEM_SINGLE_V ITEM WITH(NOLOCK)
							  WHERE 1=1
								AND RSLT.DIVISION_ID								= ITEM.DIVISION_ID
								AND RSLT.ITEM_ID									= ITEM.ITEM_ID
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID			= RSLT.DIVISION_ID      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE	    	= RSLT.PROJECT_CODE 
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.END_CUSTOMER			= RSLT.END_CUSTOMER  
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID			= RSLT.SCM_SITE_ID  
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID				= RSLT.ITEM_ID      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP				= RSLT.DOM_EXP      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE			= RSLT.FCST_TYPE    
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS			= RSLT.INCOTERMS    
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID		= RSLT.PLANT_SITE_ID
								-- AND DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd		   	   >=   @plan_start_yyyymmdd
								-- AND DM_PLN_CFM_MKT_DEMAND_PLAN.yyyymmdd		   	    =   rslt.YYYYMMDD	-- 2025.03.18 hsj - Validation Check RMA 저장시 로직 개선
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID    =   RSLT.CELL_PROD_SITE_ID
								AND ITEM.ACTIVE_FLAG = 'Y'
								AND RSLT.FCST_TYPE   = 'RMA') 
							  OPTION ( FORCE ORDER, optimize for(@plan_start_yyyymmdd unknown));

				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
				( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
				, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
				SELECT RSLT.DIVISION_ID, RSLT.PROJECT_CODE, RSLT.END_CUSTOMER, RSLT.SCM_SITE_ID, RSLT.ITEM_ID ,RSLT.DOM_EXP, RSLT.FCST_TYPE, RSLT.INCOTERMS,'RTF_SYS_RP' AS MEASURE
					 , RSLT.PLANT_SITE_ID, RSLT.YYYYMMDD
					 --[E20260309-000271]_ISNULL처리 추가 (START)
					 --, RSLT.QTY_PRICE	--원소스 주석처리
					 , ISNULL(RSLT.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
					 --[E20260309-000271]_ISNULL처리 추가 (END)
					 , 'SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE, 'SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , RSLT.V_ATTRIBUTE1, RSLT.V_ATTRIBUTE2, RSLT.V_ATTRIBUTE3, RSLT.V_ATTRIBUTE4, RSLT.V_ATTRIBUTE5, RSLT.V_ATTRIBUTE6, RSLT.V_ATTRIBUTE7, RSLT.V_ATTRIBUTE8
					 , RSLT.V_ATTRIBUTE9, RSLT.V_ATTRIBUTE10, RSLT.CELL_PROD_SITE_ID
				FROM #T_MAIN RSLT
			   INNER JOIN DM_MST_ITEM_SINGLE_V ITEM WITH(NOLOCK)
					   ON RSLT.DIVISION_ID    =	ITEM.DIVISION_ID
					  AND RSLT.ITEM_ID		  =	ITEM.ITEM_ID
					  AND ITEM.ACTIVE_FLAG	  = 'Y'
					  AND RSLT.FCST_TYPE	  = 'RMA'
			    WHERE RSLT.MEASURE IN ('MKT_FCST','SCM_FCST') -- SCM_FCST - MEASURE 추가
			      AND RSLT.yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
			END
			--==========================================================================================================================
			-- 16. 40 Validation 필요 대상 :  RMA 인 경우에 RTF를 MKT_FCST와 동일하게 생성 (END)			
			--==========================================================================================================================
PRINT @v_program_name + ' : A018--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (START)	
			-- DM_PLN_CFM_SELLING_PRICE Validation Check
			--==========================================================================================================================
			SET @valid_item_id = NULL
			IF EXISTS (SELECT * FROM #T_MAIN WHERE (DIVISION_ID LIKE '81%' OR DIVISION_ID = '40')) 
			BEGIN					
				SELECT TOP 1 @valid_item_id = A.ITEM_ID
				  FROM #T_MAIN A
				  LEFT OUTER JOIN SCM_MST_SITE_ITEM ITEM
							   ON ITEM.DIVISION_ID	= A.DIVISION_ID 
							  AND ITEM.SCM_SITE_ID	= A.SCM_SITE_ID
							  AND ITEM.ITEM_ID		= A.ITEM_ID
							  AND ITEM.VALID_YN		= 'Y'
				  LEFT OUTER JOIN DBO.DM_MST_ITEM_SINGLE_V SN
							   ON ITEM.DIVISION_ID	= SN.DIVISION_ID
							  AND ITEM.ITEM_ID		= SN.ITEM_ID
							  AND SN.ACTIVE_FLAG	 = 'Y'
				  WHERE 1 = 1
					AND A.QTY_PRICE <> 0
                    AND ( ITEM.ITEM_ID IS NULL OR SN.ITEM_ID IS NULL )

				IF @valid_item_id IS NOT NULL
					BEGIN
						SET @v_log_type		= 'INVALID';
						SET @v_description	= '['+ @valid_item_id +']'+ N' Invalid Site Item ID !'
						goto ERR_RTN;
					END
			END

			--==========================================================================================================================
			-- 17. 40 Validation 필요 대상 :  Site/Item Master Valid 여부 확인 (END)	
			--==========================================================================================================================
PRINT @v_program_name + ' : A019--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================
			-- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다. (START)
			--==========================================================================================================================
			UPDATE #T_MAIN
			SET [ACTION] = DD.[ACTION]
			FROM
			(	SELECT CASE WHEN SUM(A.QTY_PRICE) OVER (PARTITION BY D.ISO_YYYYWW + D.PARTIAL_WEEK_NAME ) = 0 THEN 'D' ELSE 'M' END AS [ACTION], D.BASIS_YYYYMMDD
				FROM #T_MAIN A
				JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) 
				ON A.YYYYMMDD = D.BASIS_YYYYMMDD
				WHERE A.MEASURE = 'LOC' AND A.[ACTION] <> 'I'
			) DD
			WHERE YYYYMMDD = DD.BASIS_YYYYMMDD AND MEASURE = 'LOC'
			--==========================================================================================================================
			-- Measure가 LOC이면서 , 같은 월의 같은 주차의 합이 0이라면 D로 업데이트 한다. 그 외는 M으로 업데이트 한다.(END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A020--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
			
			--==========================================================================================================================
			-- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (START)	
			--==========================================================================================================================
			DECLARE @v_invalid_Site				NVARCHAR(200);
			DECLARE @n_Dflag_chk				INTEGER = 0;
			SET @v_invalid_Site = null
			
			-----------------------------------------------------------------------------------------------------------------------------------
			-- ACTIVE_FLAG가 한건이라도 D인경우에만 처리한다. 
			-----------------------------------------------------------------------------------------------------------------------------------
			SET @n_Dflag_chk = (  SELECT COUNT(*) 
								    FROM #T_MAIN 
								   WHERE MEASURE = 'LOC' AND [ACTION] = 'D'  -- Delete 가능 - UI에서 MKT_FCST를 D로 보내는 경우가 있어서 작성함.
								)				

			IF @n_Dflag_chk > 0
			BEGIN	
				-----------------------------------------------------------------------------------------------------------------------------------
				-- 52주 이후의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다. 
				-----------------------------------------------------------------------------------------------------------------------------------
				SET @v_invalid_Site = ( SELECT TOP 1 N'● Sales Site : ' + SCM_SITE_ID + N' / ● Model : ' + ITEM_ID
										  FROM DM_PLN_CFM_MKT_DEMAND_PLAN F WITH(NOLOCK)
										  JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) 
											ON F.YYYYMMDD = B.BASIS_YYYYMMDD
										 WHERE EXISTS ( SELECT A.DIVISION_ID
														  FROM #T_MAIN A
														  JOIN SCM_SYS_CALENDAR_M D WITH(NOLOCK) 
														    ON A.YYYYMMDD			= D.BASIS_YYYYMMDD
														  WHERE A.[ACTION]			= 'D'
															AND F.DIVISION_ID		= A.DIVISION_ID         
															AND F.PROJECT_CODE		= A.PROJECT_CODE      
															AND F.SCM_SITE_ID		= A.SCM_SITE_ID
															AND F.PLANT_SITE_ID		= A.PLANT_SITE_ID
															AND F.ITEM_ID			= A.ITEM_ID     
															AND F.DOM_EXP			= A.DOM_EXP      
															AND F.FCST_TYPE			= A.FCST_TYPE      
															AND F.INCOTERMS			= A.INCOTERMS 
															AND A.MEASURE			= 'LOC' 
															AND F.MEASURE IN  ('MKT_FCST','RTF_SCP','AS_In_Req','SCM_FCST') -- SCM_FCST - MEASURE 추가
															AND F.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID															
														    -----------------------------------------------------------------------------------------------------------------------------------
														    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (START)
															--AND F.YYYYMMDD  >  CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
															-----------------------------------------------------------------------------------------------------------------------------------
															AND F.YYYYMMDD  >=  CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112)
														    -- [E20250825-000297]_52주구간은 당주월요일 기준으로 52주구간을 구한다 원소스 주석처리 (END)
														    -----------------------------------------------------------------------------------------------------------------------------------
															AND B.ISO_YYYYWW		= D.ISO_YYYYWW
															AND F.QTY		     <>  0  -- 제로값은 제외함
															AND F.FCST_TYPE NOT IN ( SELECT SEGMENT1 -- FCST_TYPE
																					   FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK) 
																					  WHERE 1 = 1
																					    AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																					    AND MST.SEGMENT4 = 'FREE'  -- 무상 제공인경우
																					  GROUP BY SEGMENT1 )  -- 무상제공인경우는 Validation 에서 제외
														) 
										)

				IF @v_invalid_Site IS NOT NULL
					BEGIN
						SET @v_description	= N'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이후 동일 주차에 존재하므로 Sales Price 삭제가 불가합니다.'+ CHAR(10) + @v_invalid_Site
						SET @v_log_type		= 'INVALID';
						GOTO ERR_RTN;	
					END
					
				-----------------------------------------------------------------------------------------------------------------------------------
				-- 52주 이내의 데이터의 FLAG를 0으로 변경하여 삭제하려고 하는 경우는 아래 로직으로 데이터를 확인한다. 
				-----------------------------------------------------------------------------------------------------------------------------------
				SET @v_invalid_Site = ( SELECT TOP 1 N'● Sales Site : ' + SCM_SITE_ID + N' / ● Model : ' + ITEM_ID
										  FROM DM_PLN_CFM_MKT_DEMAND_PLAN F WITH(NOLOCK)
										 WHERE EXISTS (	SELECT A.DIVISION_ID
														  FROM #T_MAIN A 
														 WHERE A.[ACTION]			= 'D'
														   AND F.DIVISION_ID        = A.DIVISION_ID         
														   AND F.PROJECT_CODE       = A.PROJECT_CODE      
														   AND F.SCM_SITE_ID        = A.SCM_SITE_ID
														   AND F.PLANT_SITE_ID      = A.PLANT_SITE_ID
														   AND F.ITEM_ID            = A.ITEM_ID     
														   AND F.DOM_EXP            = A.DOM_EXP      
														   AND F.FCST_TYPE          = A.FCST_TYPE      
														   AND F.INCOTERMS          = A.INCOTERMS 
														   AND F.MEASURE IN ('MKT_FCST','RTF_SCP','AS_In_Req','SCM_FCST')  -- SCM_FCST - MEASURE 추가
														   AND F.CELL_PROD_SITE_ID  = A.CELL_PROD_SITE_ID
														   -----------------------------------------------------------------------------------------------------------------------------------
														   -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (START)
														   /*
														   AND F.YYYYMMDD           BETWEEN  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후건만 확인
																					AND      CONVERT(CHAR(8), DATEADD(WW, 52, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- SCP PLANNING 구간이 52주 */
														  -----------------------------------------------------------------------------------------------------------------------------------
														   AND F.YYYYMMDD           >=  CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 이후건만 확인
														   AND F.YYYYMMDD 			<   CONVERT(CHAR(8), DATEADD(WW, 52, CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)),112) -- 52주후 월요일까지
														  -- [E20250825-000297]_52주구간을 계산하면서, BETWEEN을 사용하게 되니, 52주후 월요일을 포함하게 되어 구문 수정 원소스 주석처리 (END)
														  -----------------------------------------------------------------------------------------------------------------------------------
														   AND F.QTY		         <>  0  -- 제로값은 제외함
														   AND F.FCST_TYPE NOT IN (	SELECT SEGMENT1 -- FCST_TYPE
																					  FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)
																					 WHERE 1 = 1
																					   AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE'
																					   AND MST.SEGMENT4 = 'FREE'  -- 무상 제공인경우
																					 GROUP BY SEGMENT1 )  -- 무상제공인경우는 Validation 에서 제외
													  ) 
									  )

				IF @v_invalid_Site IS NOT NULL
					BEGIN
						SET @v_description	= N'MKT FCST or RTF or AS_In_Req or SCM_FCST 정보가 미래구간 52주이내에 존재하므로 Sales Price 삭제가 불가합니다.'+ CHAR(10) + @v_invalid_Site
						SET @v_log_type		= 'INVALID';
						GOTO ERR_RTN;	
					END
			END	
			
			--==========================================================================================================================
			-- 18. 40 Validation 필요 대상 : SALES PRICE를 삭제하는 경우 52주간 MKT FCST or RTF 데이터 확인 (END)	
			--==========================================================================================================================
PRINT @v_program_name + ' : A021--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
		
			--==========================================================================================================================
			-- Validaion Check (END)
			--==========================================================================================================================	
			--==========================================================================================================================	
			-- VALIDATION 종료 (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 3. VALIDATION CHECK END';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- VALIDATION 종료 (END)
			--==========================================================================================================================		
			--==========================================================================================================================
			-- #T_MAIN 테이블에 메져를 추가한다. (START)
			-- DM_PLN_CFM_SELLING_PRICE 테이블 기준 MEASURE 
			-- 'KRW','USD','LOC'
			--  KRW , USD 2개를 만드는 로직 추가해야함
			--==========================================================================================================================
			----------------------------------------------------------------------------------------------------------------------------
			-- 1. 환율정보 가져옴.
			----------------------------------------------------------------------------------------------------------------------------
			SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
			INTO #TEMP_EXCH
			FROM DM_MST_EXCHANGE_RATE A WITH(NOLOCK)
			JOIN #T_MAIN B ON A.DIVISION_ID = B.DIVISION_ID AND A.YYYYMMDD = LEFT(B.YYYYMMDD, 6) + '01'	AND A.CURRENCY = 'KRW'
			WHERE B.MEASURE = 'LOC';

			----------------------------------------------------------------------------------------------------------------------------
			-- 2. KRW, USD 메져 환율정보로 계산하여 추가
			----------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #T_MAIN
			SELECT T.[ACTION], T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				, 'KRW' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY				
				--[E20260309-000271]_ISNULL처리 추가 (START)
				--, ROUND(T.QTY_PRICE * IIF(T.CURRENCY = 'KRW', 1, EX.EXCHANGE_PRICE), 3) AS QTY_PRICE --[E20260309-000271]_원소스 주석처리
				, ROUND(ISNULL(T.QTY_PRICE, 0) * IIF(T.CURRENCY = 'KRW', 1, EX.EXCHANGE_PRICE), 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
				--[E20260309-000271]_ISNULL처리 추가 (END)
				, T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6
				, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
			  FROM #T_MAIN T
			  LEFT OUTER JOIN #TEMP_EXCH EX
						   ON EX.DIVISION_ID	= T.DIVISION_ID
						  AND EX.UNIT_CURRENCY  = T.CURRENCY
						  AND EX.YYYYMMDD LIKE CONCAT(LEFT(T.YYYYMMDD, 6), '%')
						  AND EX.CURRENCY		= 'KRW'
			 WHERE T.MEASURE = 'LOC'
			 UNION ALL
			SELECT T.[ACTION], T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID, T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS
				, 'USD' AS MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY	
				--[E20260309-000271]_ISNULL처리 추가 (START)
                --, ROUND(ROUND((T.QTY_PRICE * IIF(T.CURRENCY = 'KRW', 1, EX.EXCHANGE_PRICE)), 3)/USD.EXCHANGE_PRICE, 3) AS QTY_PRICE --[E20260309-000271]_원소스 주석처리
                , ROUND(ROUND((ISNULL(T.QTY_PRICE, 0) * IIF(T.CURRENCY = 'KRW', 1, EX.EXCHANGE_PRICE)), 3)/USD.EXCHANGE_PRICE, 3) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
				--[E20260309-000271]_ISNULL처리 추가 (END)
                , T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5, '' AS V_ATTRIBUTE6
				, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10, '' AS V_BOM_YN, '' AS V_VMI_YN
			  FROM #T_MAIN T
			  LEFT OUTER JOIN #TEMP_EXCH EX
						   ON EX.DIVISION_ID	= T.DIVISION_ID
						  AND EX.UNIT_CURRENCY	= T.CURRENCY
						  AND EX.YYYYMMDD LIKE CONCAT(LEFT(T.YYYYMMDD, 6), '%')
			  LEFT OUTER JOIN #TEMP_EXCH USD
						   ON USD.DIVISION_ID	= T.DIVISION_ID
						  AND USD.YYYYMMDD LIKE CONCAT(LEFT(T.YYYYMMDD, 6), '%')
						  AND USD.CURRENCY		= 'KRW'
						  AND USD.UNIT_CURRENCY = 'USD'
			WHERE T.MEASURE = 'LOC';
			
PRINT @v_program_name + ' : A022--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
			----------------------------------------------------------------------------------------------------------------------------
			-- 3. MKT_AMT_KRW, MKT_AMT_LOC 메져 환율정보로 계산하여 추가
			----------------------------------------------------------------------------------------------------------------------------
			INSERT INTO #T_MAIN
			SELECT AMT.ACT AS [ACTION], AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID, AMT.DOM_EXP, AMT.FCST_TYPE
				 , AMT.INCOTERMS, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD, MAX(AMT.CURRENCY) AS CURRENCY
				 , SUM(AMT.QTY) AS QTY
				 , MAX(AMT.CREATED_BY) AS CREATED_BY, MAX(AMT.V_ATTRIBUTE1) AS V_ATTRIBUTE1, MAX(AMT.V_ATTRIBUTE2) AS V_ATTRIBUTE2
				 , MAX(AMT.V_ATTRIBUTE3) AS V_ATTRIBUTE3, MAX(AMT.V_ATTRIBUTE4) AS V_ATTRIBUTE4, MAX(AMT.V_ATTRIBUTE5) AS V_ATTRIBUTE5, MAX(AMT.V_ATTRIBUTE6) AS V_ATTRIBUTE6
				 , MAX(AMT.V_ATTRIBUTE7) AS V_ATTRIBUTE7, MAX(AMT.V_ATTRIBUTE8) AS V_ATTRIBUTE8, MAX(AMT.V_ATTRIBUTE9) AS V_ATTRIBUTE9, MAX(AMT.V_ATTRIBUTE10) AS V_ATTRIBUTE10
				 , MAX(AMT.V_BOM_YN) AS V_BOM_YN, MAX(AMT.V_VMI_YN) AS V_VMI_YN
			 FROM (  SELECT	W.[ACTION] AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID 
				   		  , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
						  , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								 WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
							END AS MEASURE
						  , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD
						  , '' AS CURRENCY
						  --[E20260309-000271]_ISNULL처리 추가 (START)
						  --, CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(W.QTY_PRICE * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_원소스 주석처리
						  --	   WHEN SP.MEASURE = 'LOC' THEN CAST(STR(W.QTY_PRICE * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_원소스 주석처리
						  , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(ISNULL(W.QTY_PRICE, 0) * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
								 WHEN SP.MEASURE = 'LOC' THEN CAST(STR(ISNULL(W.QTY_PRICE, 0) * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
							END AS QTY
						  --[E20260309-000271]_ISNULL처리 추가 (END)
						  , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5
						  , '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10
						  , '' AS V_BOM_YN, '' AS V_VMI_YN
					  FROM #T_MAIN W WITH(NOLOCK)
					 INNER JOIN #T_MAIN SP WITH(NOLOCK)
							 ON ( SP.DIVISION_ID		= W.DIVISION_ID
							AND	  SP.PROJECT_CODE		= W.PROJECT_CODE
							AND	  SP.END_CUSTOMER		= W.END_CUSTOMER
							AND	  SP.SCM_SITE_ID		= W.SCM_SITE_ID
							AND	  SP.ITEM_ID			= W.ITEM_ID
							AND	  SP.DOM_EXP			= W.DOM_EXP
							AND	  SP.FCST_TYPE			= W.FCST_TYPE
							AND	  SP.INCOTERMS			= W.INCOTERMS
							AND	  SP.PLANT_SITE_ID		= W.PLANT_SITE_ID
							AND	  SP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID
							AND	  SP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
							AND	  SP.MEASURE IN ( 'LOC', 'KRW'))
					 WHERE W.MEASURE = 'MKT_FCST'
					 UNION ALL
					 SELECT	W.[ACTION] AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID 
						  , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
						  , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								 WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
							END AS MEASURE
						  , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
						  --[E20260309-000271]_ISNULL처리 추가 (START)
						  --, CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(W.QTY_PRICE * ISNULL(SP.PRICE , 0), 20, 5 ) AS NUMERIC(30, 10))  --[E20260309-000271]_원소스 주석처리
						  --	 WHEN SP.MEASURE = 'LOC' THEN CAST(STR(W.QTY_PRICE * ISNULL(SP.PRICE , 0), 20, 5 ) AS NUMERIC(30, 10))  --[E20260309-000271]_원소스 주석처리
						  , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(ISNULL(W.QTY_PRICE, 0)  * ISNULL(SP.PRICE , 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
								 WHEN SP.MEASURE = 'LOC' THEN CAST(STR(ISNULL(W.QTY_PRICE, 0)  * ISNULL(SP.PRICE , 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
							END AS QTY
						  --[E20260309-000271]_ISNULL처리 추가 (END)
						  , W.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5
						  , '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10
						  , '' AS V_BOM_YN, '' AS V_VMI_YN
					  FROM #T_MAIN W WITH(NOLOCK)
					 INNER JOIN DM_PLN_CFM_SELLING_PRICE SP WITH(NOLOCK)
							 ON ( SP.DIVISION_ID		= W.DIVISION_ID
							AND   SP.PROJECT_CODE		= W.PROJECT_CODE
							AND   SP.END_CUSTOMER		= W.END_CUSTOMER
							AND   SP.SCM_SITE_ID		= W.SCM_SITE_ID
							AND   SP.ITEM_ID			= W.ITEM_ID
							AND   SP.DOM_EXP			= W.DOM_EXP
							AND   SP.FCST_TYPE			= W.FCST_TYPE
							AND   SP.INCOTERMS			= W.INCOTERMS
							AND   SP.PLANT_SITE_ID		= W.PLANT_SITE_ID
							AND   SP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID
							AND   SP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
							AND   SP.MEASURE IN ( 'LOC', 'KRW'))
					 WHERE W.MEASURE = 'MKT_FCST'
					   AND NOT EXISTS ( SELECT 1 FROM #T_MAIN W2
										 WHERE W2.DIVISION_ID          = W.DIVISION_ID
										   AND W2.PROJECT_CODE         = W.PROJECT_CODE
										   AND W2.END_CUSTOMER         = W.END_CUSTOMER
										   AND W2.SCM_SITE_ID          = W.SCM_SITE_ID
										   AND W2.ITEM_ID              = W.ITEM_ID
										   AND W2.DOM_EXP              = W.DOM_EXP
										   AND W2.FCST_TYPE            = W.FCST_TYPE
										   AND W2.INCOTERMS            = W.INCOTERMS
										   AND W2.PLANT_SITE_ID        = W.PLANT_SITE_ID
										   AND W2.CELL_PROD_SITE_ID    = W.CELL_PROD_SITE_ID
										   AND W2.YYYYMMDD             = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD )
										   AND W2.MEASURE             IN ( 'LOC', 'KRW'))
					 UNION ALL 
					 SELECT	SP.[ACTION] AS ACT, W.DIVISION_ID, W.PROJECT_CODE, W.END_CUSTOMER, W.SCM_SITE_ID, W.ITEM_ID 
						  , W.DOM_EXP, W.FCST_TYPE, W.INCOTERMS
						  , CASE WHEN SP.MEASURE = 'KRW' THEN 'MKT_AMT_KRW' 
								 WHEN SP.MEASURE = 'LOC' THEN 'MKT_AMT_LOC'
							END AS MEASURE
						  , W.PLANT_SITE_ID, W.CELL_PROD_SITE_ID, W.YYYYMMDD, '' AS CURRENCY
						  --[E20260309-000271]_ISNULL처리 추가 (START)
						  --, CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(W.QTY * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_원소스 주석처리
						  --		 WHEN SP.MEASURE = 'LOC' THEN CAST(STR(W.QTY * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_원소스 주석처리
						  , CASE WHEN SP.MEASURE = 'KRW' THEN CAST(STR(ISNULL(W.QTY, 0) * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
								 WHEN SP.MEASURE = 'LOC' THEN CAST(STR(ISNULL(W.QTY, 0) * ISNULL(SP.QTY_PRICE, 0), 20, 5 ) AS NUMERIC(30, 10)) --[E20260309-000271]_ISNULL처리 추가
							END AS QTY
						  --[E20260309-000271]_ISNULL처리 추가 (END)
						  , SP.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5
						  , '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10
						  , '' AS V_BOM_YN, '' AS V_VMI_YN
					  FROM DM_PLN_CFM_MKT_DEMAND_PLAN W WITH(NOLOCK)
					 INNER JOIN #T_MAIN SP WITH(NOLOCK)
							 ON ( SP.DIVISION_ID		= W.DIVISION_ID
							AND	  SP.PROJECT_CODE		= W.PROJECT_CODE
							AND	  SP.END_CUSTOMER		= W.END_CUSTOMER
							AND	  SP.SCM_SITE_ID		= W.SCM_SITE_ID
							AND	  SP.ITEM_ID			= W.ITEM_ID
							AND	  SP.DOM_EXP			= W.DOM_EXP
							AND	  SP.FCST_TYPE			= W.FCST_TYPE
							AND	  SP.INCOTERMS			= W.INCOTERMS
							AND	  SP.PLANT_SITE_ID		= W.PLANT_SITE_ID
							AND	  SP.CELL_PROD_SITE_ID	= W.CELL_PROD_SITE_ID
							AND	  SP.YYYYMMDD = ( SELECT BASIS_START_DATE FROM SCM_SYS_CALENDAR_M WITH(NOLOCK) WHERE BASIS_YYYYMMDD = W.YYYYMMDD ) 
							AND	  SP.MEASURE IN ( 'LOC', 'KRW'))
					 WHERE W.MEASURE = 'MKT_FCST'
					   AND NOT EXISTS (SELECT 1	FROM #T_MAIN W2
										WHERE W2.DIVISION_ID          = W.DIVISION_ID
										  AND W2.PROJECT_CODE         = W.PROJECT_CODE
										  AND W2.END_CUSTOMER         = W.END_CUSTOMER
										  AND W2.SCM_SITE_ID          = W.SCM_SITE_ID
										  AND W2.ITEM_ID              = W.ITEM_ID
										  AND W2.DOM_EXP              = W.DOM_EXP
										  AND W2.FCST_TYPE            = W.FCST_TYPE
										  AND W2.INCOTERMS            = W.INCOTERMS
										  AND W2.PLANT_SITE_ID        = W.PLANT_SITE_ID
										  AND W2.CELL_PROD_SITE_ID    = W.CELL_PROD_SITE_ID
										  AND W2.YYYYMMDD             = W.YYYYMMDD
										  AND W2.MEASURE              = W.MEASURE )
					--[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (START)
					UNION ALL
					SELECT T.[ACTION] AS ACT, T.DIVISION_ID, T.PROJECT_CODE, T.END_CUSTOMER, T.SCM_SITE_ID, T.ITEM_ID 
						 , T.DOM_EXP, T.FCST_TYPE, T.INCOTERMS, B.MEASURE, T.PLANT_SITE_ID, T.CELL_PROD_SITE_ID, T.YYYYMMDD, T.CURRENCY
						 --[E20260309-000271]_ISNULL처리 추가 (START)
						 --, T.QTY_PRICE --[E20260309-000271]_원소스 주석처리
						 , ISNULL(T.QTY_PRICE, 0) AS QTY_PRICE --[E20260309-000271]_ISNULL처리 추가
						  --[E20260309-000271]_ISNULL처리 추가 (END)
						 , T.CREATED_BY, '' AS V_ATTRIBUTE1, '' AS V_ATTRIBUTE2, '' AS V_ATTRIBUTE3, '' AS V_ATTRIBUTE4, '' AS V_ATTRIBUTE5
						, '' AS V_ATTRIBUTE6, '' AS V_ATTRIBUTE7, '' AS V_ATTRIBUTE8, '' AS V_ATTRIBUTE9, '' AS V_ATTRIBUTE10
						, '' AS V_BOM_YN, '' AS V_VMI_YN 
					FROM (	SELECT * FROM #T_MAIN
							WHERE QTY_PRICE = 0
							AND MEASURE = 'MKT_FCST' ) T ,		
					( SELECT 'MKT_AMT_KRW' MEASURE
					  UNION 
					  SELECT 'MKT_AMT_LOC' MEASURE
					) B	
					--[E20251208-000309]_0인 경우를 처리하는 로직이 존재하지 않아서, 0인 경우에 MKT FCST AMT 생성하도록 추가 (END)
			) AMT
			GROUP BY  AMT.ACT, AMT.DIVISION_ID, AMT.PROJECT_CODE, AMT.END_CUSTOMER, AMT.SCM_SITE_ID, AMT.ITEM_ID, AMT.DOM_EXP, AMT.FCST_TYPE, AMT.INCOTERMS
					, AMT.MEASURE, AMT.PLANT_SITE_ID, AMT.CELL_PROD_SITE_ID, AMT.YYYYMMDD ;

			SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		

			--==========================================================================================================================
			-- #T_MAIN 테이블에 메져를 추가한다. (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A023--' + CONVERT(NVARCHAR(30), GETDATE(), 121);

			--==========================================================================================================================	
			-- 환율정보로 계산 (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 4. MKT_AMT_KRW, MKT_AMT_LOC, LOC, KRW #T_MAIN IMPORT';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- 환율정보로 계산 (END)
			--==========================================================================================================================		

			--==========================================================================================================================
			-- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (START)
			--==========================================================================================================================
			DECLARE @GETDATE			DATETIME
			SET @GETDATE = GETDATE()

PRINT 'MERGE INTO DM_PLN_CFM_SELLING_PRICE START'

			MERGE INTO DM_PLN_CFM_SELLING_PRICE A
			USING (SELECT * FROM #T_MAIN WITH(NOLOCK) WHERE MEASURE IN ('KRW','USD','LOC')) B
			   ON (A.DIVISION_ID       = B.DIVISION_ID
			   AND A.PROJECT_CODE      = B.PROJECT_CODE
			   AND A.END_CUSTOMER      = B.END_CUSTOMER
			   AND A.SCM_SITE_ID       = B.SCM_SITE_ID
			   AND A.PLANT_SITE_ID     = B.PLANT_SITE_ID
			   AND A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			   AND A.ITEM_ID           = B.ITEM_ID
			   AND A.YYYYMMDD          = B.YYYYMMDD
			   AND A.MEASURE           = B.MEASURE
			   AND A.DOM_EXP           = B.DOM_EXP
			   AND A.FCST_TYPE         = B.FCST_TYPE
			   AND A.INCOTERMS         = B.INCOTERMS )
			WHEN MATCHED AND B.QTY_PRICE = 0 THEN 
			DELETE
			WHEN MATCHED THEN
			UPDATE 
			SET A.CURRENCY         = B.CURRENCY
			  , A.PRICE            = ISNULL(B.QTY_PRICE, 0) --[E20260422-001123]_ISNULL처리
			  , A.LAST_UPDATED_BY  = B.CREATED_BY
			  , A.LAST_UPDATE_DATE = @GETDATE
			WHEN NOT MATCHED AND B.QTY_PRICE <> 0 THEN
			INSERT 
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
			, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			VALUES
			( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
			, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.CURRENCY, ISNULL(B.QTY_PRICE, 0) /*[E20260422-001123]_ISNULL처리*/, B.CREATED_BY, @GETDATE, B.CREATED_BY, @GETDATE );

			SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인	

PRINT 'MERGE INTO DM_PLN_CFM_SELLING_PRICE END'
			--==========================================================================================================================
			-- DM_PLN_CFM_SELLING_PRICE 데이터 작업 시작 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A024--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
	
			--==========================================================================================================================	
			-- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 5. DM_PLN_CFM_SELLING_PRICE IMPORT';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- DM_PLN_CFM_SELLING_PRICE 테이블 IMPORT (END)
			--==========================================================================================================================	
			--==========================================================================================================================
			-- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (START)
			/* DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 기준 MEASURE */
			-- 수정 및 INSERT가 가능한 'MKT_FCST','VMI_In_Req'만 해당 된다.
			-- SCM_FCST 는 수정만 된다. ( INSERT 불가능 , UI에서 막음. )	
			--==========================================================================================================================
PRINT 'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN START'

			MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN AS A
			USING (SELECT * FROM #T_MAIN WITH(NOLOCK) WHERE MEASURE IN ('MKT_FCST','VMI_In_Req','MKT_AMT_KRW','MKT_AMT_LOC','SCM_FCST')) B -- SCM_FCST - MEASURE 추가 , -- SCM_FCST 는 수정만 된다. ( INSERT 불가능 )
			   ON ( A.DIVISION_ID       = B.DIVISION_ID
			  AND   A.PROJECT_CODE      = B.PROJECT_CODE
			  AND   A.END_CUSTOMER      = B.END_CUSTOMER
			  AND   A.SCM_SITE_ID       = B.SCM_SITE_ID
			  AND   A.ITEM_ID           = B.ITEM_ID
			  AND   A.DOM_EXP           = B.DOM_EXP
			  AND   A.FCST_TYPE         = B.FCST_TYPE
			  AND   A.INCOTERMS         = B.INCOTERMS
			  AND   A.MEASURE           = B.MEASURE
			  AND   A.PLANT_SITE_ID     = B.PLANT_SITE_ID
			  AND   A.CELL_PROD_SITE_ID = B.CELL_PROD_SITE_ID
			  AND   A.YYYYMMDD          = B.YYYYMMDD  )
			WHEN MATCHED AND B.QTY_PRICE = 0 AND B.MEASURE IN('MKT_AMT_KRW','MKT_AMT_LOC') THEN -- 행 Delete 가능 - 편집 가능, 삭제 불가 행의 경우 값 일괄 업데이트 - D로 들어올 경우도 존재 한다.
			DELETE --검색조건이 없는 WHEN MATCHED가 제일 뒤에있어야 문법오류가 안나오니 DELETE랑 UPDATE랑 순서 바꾸지 마세요
			WHEN MATCHED THEN
			UPDATE 
			SET A.QTY              = B.QTY_PRICE
			  , A.LAST_UPDATED_BY  = B.CREATED_BY
			  , A.LAST_UPDATE_DATE = @GETDATE
			WHEN NOT MATCHED AND B.QTY_PRICE <> 0 THEN
			INSERT           
			( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
			, CELL_PROD_SITE_ID	, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			VALUES
			( B.DIVISION_ID, B.PROJECT_CODE, B.END_CUSTOMER, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.PLANT_SITE_ID
			, B.CELL_PROD_SITE_ID, B.YYYYMMDD, B.QTY_PRICE, B.CREATED_BY, @GETDATE, B.CREATED_BY, @GETDATE );
			
			SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		
PRINT 'MERGE INTO DM_PLN_CFM_MKT_DEMAND_PLAN END'
			--==========================================================================================================================
			-- DM_PLN_CFM_MKT_DEMAND_PLAN 데이터 작업 시작 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A025--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
			
			--==========================================================================================================================	
			-- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 6. DM_PLN_CFM_MKT_DEMAND_PLAN IMPORT';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
			--==========================================================================================================================		
PRINT @v_program_name + ' : A025_EE--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			--[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (START)
			--==========================================================================================================================	
			-- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (START)
			--==========================================================================================================================	
			DECLARE @n_EE_chk	INTEGER = 0;
			SET @n_EE_chk = (	SELECT COUNT(*)
								  FROM #T_MAIN RSLT
								     , DM_MST_ITEM_SINGLE_V ITEM WITH(NOLOCK)
								 WHERE 1=1
								   AND RSLT.DIVISION_ID	= ITEM.DIVISION_ID
								   AND RSLT.ITEM_ID		= ITEM.ITEM_ID
								   AND ITEM.ACTIVE_FLAG	= 'Y'
								   --↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
								   AND	( RSLT.ITEM_ID IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH (NOLOCK) 
															 WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y')))
			IF @n_EE_chk > 0
			BEGIN
				DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
				WHERE MEASURE = 'RTF_SYS_RP'  
				AND yyyymmdd >= @plan_start_yyyymmdd -- 당주 월요일이후
				AND EXISTS ( SELECT RSLT.DIVISION_ID 
							   FROM #T_MAIN RSLT
							      , DM_MST_ITEM_SINGLE_V ITEM WITH(NOLOCK)
							  WHERE 1=1
								AND RSLT.DIVISION_ID								= ITEM.DIVISION_ID
								AND RSLT.ITEM_ID									= ITEM.ITEM_ID
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.DIVISION_ID			= RSLT.DIVISION_ID      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.PROJECT_CODE	    	= RSLT.PROJECT_CODE 
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.END_CUSTOMER			= RSLT.END_CUSTOMER  
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.SCM_SITE_ID			= RSLT.SCM_SITE_ID  
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.ITEM_ID				= RSLT.ITEM_ID      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.DOM_EXP				= RSLT.DOM_EXP      
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.FCST_TYPE			= RSLT.FCST_TYPE    
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.INCOTERMS			= RSLT.INCOTERMS    
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.PLANT_SITE_ID		= RSLT.PLANT_SITE_ID
								AND DM_PLN_CFM_MKT_DEMAND_PLAN.CELL_PROD_SITE_ID    = RSLT.CELL_PROD_SITE_ID
								AND ITEM.ACTIVE_FLAG = 'Y'
								--↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
								AND	( RSLT.ITEM_ID IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH (NOLOCK) 
														 WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'  )))  --20180720 ACTIVE_FLAG 조건추가
							  OPTION ( FORCE ORDER, optimize for(@plan_start_yyyymmdd unknown));

				INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN
				( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
				, PLANT_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
				, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6
				, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, CELL_PROD_SITE_ID )
				SELECT A.DIVISION_ID, A.PROJECT_CODE, A.END_CUSTOMER, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'RTF_SYS_RP' AS MEASURE
					 , A.PLANT_SITE_ID, A.YYYYMMDD, A.QTY, 'DMF0082_SYSTEM' AS CREATED_BY, GETDATE() AS CREATION_DATE,'DMF0082_SYSTEM' AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
					 , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6
					 , A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10, A.CELL_PROD_SITE_ID
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
				WHERE A.MEASURE = ( SELECT MEASURE FROM #T_MAIN WHERE MEASURE IN ('SCM_FCST', 'MKT_FCST') GROUP BY MEASURE)
				AND A.YYYYMMDD  >= @plan_start_yyyymmdd -- 당주 월요일이후
				AND EXISTS ( SELECT RSLT.DIVISION_ID 
							 FROM #T_MAIN RSLT
								, DM_MST_ITEM_SINGLE_V ITEM WITH(NOLOCK)
							  WHERE 1=1
								AND RSLT.DIVISION_ID	= ITEM.DIVISION_ID
								AND RSLT.ITEM_ID		= ITEM.ITEM_ID
								AND A.DIVISION_ID		= RSLT.DIVISION_ID      
								AND A.PROJECT_CODE	    = RSLT.PROJECT_CODE 
								AND A.END_CUSTOMER		= RSLT.END_CUSTOMER  
								AND A.SCM_SITE_ID		= RSLT.SCM_SITE_ID  
								AND A.ITEM_ID			= RSLT.ITEM_ID      
								AND A.DOM_EXP			= RSLT.DOM_EXP      
								AND A.FCST_TYPE			= RSLT.FCST_TYPE    
								AND A.INCOTERMS			= RSLT.INCOTERMS      
								AND A.PLANT_SITE_ID		= RSLT.PLANT_SITE_ID
								AND A.CELL_PROD_SITE_ID = RSLT.CELL_PROD_SITE_ID
								AND ITEM.ACTIVE_FLAG	= 'Y'
								--↓전극인 경우에 RTF를 MKT_FCST와 동일하게 생성
								AND	( RSLT.ITEM_ID IN ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH (NOLOCK) 
														 WHERE K.DIVISION_ID = RSLT.DIVISION_ID AND K.SCP_OPERATION_GROUP = 'E' AND K.ACTIVE_FLAG = 'Y'  )))  --20180720 ACTIVE_FLAG 조건추가
							  OPTION ( FORCE ORDER, optimize for(@plan_start_yyyymmdd unknown));

				--[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) START
				UPDATE A
				SET A.ATTRIBUTE2 = LOOK.SEGMENT3
				FROM DM_PLN_CFM_MKT_DEMAND_PLAN A WITH(NOLOCK)
				INNER JOIN ( SELECT * FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
							  WHERE LOOKUP_TYPE = 'DM_ELECTROD_FROM_SITE_ID'
								AND VALID_YN = 'Y' ) LOOK
						ON A.DIVISION_ID = LOOK.SEGMENT1
				WHERE A.MEASURE = 'RTF_SYS_RP'
				  AND A.YYYYMMDD >= @plan_start_yyyymmdd
				  AND A.ITEM_ID LIKE '' + ISNULL(LOOK.ATTRIBUTE1, A.ITEM_ID) + '%'
				  AND A.ITEM_ID IN  ( SELECT K.ITEM_ID FROM SCM_MST_ITEM_SN K WITH (NOLOCK) 
									  WHERE K.DIVISION_ID = A.DIVISION_ID AND K.SCP_OPERATION_GROUP = LOOK.SEGMENT2 AND K.ACTIVE_FLAG = 'Y'  ) 
				--[E20260107-001651]_룩업에 설정된 값으로 ATTRIBUTE2 UPDATE (BPS I/F시 FROM_SITE_ID 전송하기 위함) END


				SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		
				--==========================================================================================================================	
				-- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (START)
				--==========================================================================================================================	
				SET @v_log_type		= N'ING';
				SET @v_log_message	= N'■ 6_EE. DM_PLN_CFM_MKT_DEMAND_PLAN_EE IMPORT';
				SET @n_log_count	= @n_update_cnt;
				SET @v_description	= '';
				SET @d_event_date	= SYSDATETIME();
	
				EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
				--==========================================================================================================================	
				-- DM_PLN_CFM_MKT_DEMAND_PLAN_EE 테이블 IMPORT (END)
				--==========================================================================================================================	
			END
			--==========================================================================================================================	
			-- 전극인 경우에는 RTF를 생성해준다 (SCP RTF를 반영하지 않기때문에) (END)
			--==========================================================================================================================	
			--[E20251209-000712]_전극의 경우 SCP RTF를 받아오지 않도록 처리했기때문에, MKT FCST 수정시 -> MKT FCST 메져로 RTF 생성 / SCM FCST 수정시 -> SCM FCST 메져로 RTF 생성하도록 수정 (END)	
			----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------			
			--==========================================================================================================================
			-- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (START)
			--==========================================================================================================================
PRINT 'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H START'

			INSERT INTO DM_PLN_CFM_SELLING_PRICE_H 
			( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
			, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, PRICE, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE, HISTORY_CREATION_DATE )
			SELECT DIVISION_ID, NEXT VALUE FOR SEQ1_DM_PLN_CFM_SELLING_PRICE_H, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, CURRENCY, ISNULL(QTY_PRICE, 0), CREATED_BY, @GETDATE
				 , CREATED_BY, @GETDATE, GETDATE()
			  FROM #T_MAIN WITH(NOLOCK) 
			 WHERE MEASURE IN ('KRW','USD','LOC') 
			   --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정

			SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		

PRINT 'INSERT INTO DM_PLN_CFM_SELLING_PRICE_H END'	
			--==========================================================================================================================
			-- DM_PLN_CFM_SELLING_PRICE_H 데이터 작업 시작 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A026--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	
					
			--==========================================================================================================================	
			-- DM_PLN_CFM_SELLING_PRICE_H 테이블 IMPORT (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 7. DM_PLN_CFM_SELLING_PRICE_H IMPORT';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- DM_PLN_CFM_MKT_DEMAND_PLAN 테이블 IMPORT (END)
			--==========================================================================================================================	

			--==========================================================================================================================
			-- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (START)
			--==========================================================================================================================
PRINT 'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H START'

			INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H 
			( DIVISION_ID, HISTORY_SEQ, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
			, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, CREATED_BY, CREATION_DATE
			, LAST_UPDATED_BY, LAST_UPDATE_DATE )
			SELECT DIVISION_ID, NEXT VALUE FOR SEQ1_DM_PLN_CFM_MKT_DEMAND_PLAN_H, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
				 , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY_PRICE, CREATED_BY, @GETDATE
				 , CREATED_BY, @GETDATE	
			  FROM #T_MAIN WITH(NOLOCK) 
			 WHERE MEASURE IN ('MKT_FCST','VMI_In_Req','MKT_AMT_KRW','MKT_AMT_LOC','SCM_FCST') 
			   --AND QTY_PRICE <> 0 --[E20251208-000309]_0으로 저장하는 경우에도 이력이 남도록 수정

			SET @n_update_cnt = @@ROWCOUNT; -- [E20250915-000105]_ROW_COUNT 확인		
PRINT 'INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_H END'	
			--==========================================================================================================================
			-- DM_PLN_CFM_MKT_DEMAND_PLAN_H 데이터 작업 시작 (END)
			--==========================================================================================================================
PRINT @v_program_name + ' : A027--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

			--==========================================================================================================================	
			-- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 8. DM_PLN_CFM_MKT_DEMAND_PLAN_H IMPORT';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- DM_PLN_CFM_MKT_DEMAND_PLAN_H 테이블 IMPORT (END)
			--==========================================================================================================================
			--==========================================================================================================================	
			-- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START (START)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 9. PR_DM_PLN_CFM_TO_MKT_FCST START';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 START  (END)
			--==========================================================================================================================		
			--==========================================================================================================================
			-- MKT FCST 데이터 생성 프로시저 호출 시작 (START)
			--==========================================================================================================================
			EXEC PR_DM_PLN_CFM_TO_MKT_FCST @v_created_by;
			--==========================================================================================================================
			-- MKT FCST 데이터 생성 프로시저 호출 시작 (END)
			--==========================================================================================================================
			--==========================================================================================================================	
			-- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
			--==========================================================================================================================	
			SET @v_log_type		= N'ING';
			SET @v_log_message	= N'■ 10. PR_DM_PLN_CFM_TO_MKT_FCST END';
			SET @n_log_count	= @n_update_cnt;
			SET @v_description	= '';
			SET @d_event_date	= SYSDATETIME();
	
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			--==========================================================================================================================	
			-- PR_DM_PLN_CFM_TO_MKT_FCST 프로시져 실행 END (END)
			--==========================================================================================================================		
PRINT @v_program_name + ' : A028--' + CONVERT(NVARCHAR(30), GETDATE(), 121);	

		--=============================================================================================================================
		-- 종료 LOG (START)
		--=============================================================================================================================
		SET @v_log_type		= 'END';
		SET @v_log_message	= '########## SUCCESS END of procedure ##########';
		SET @v_description	= '';
		SET @d_event_date	= SYSDATETIME();		
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
		-------------------------------------------------------------------------------------------------------------------------------
	
		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
		-------------------------------------------------------------------------------------------------------------------------------
		-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
		-------------------------------------------------------------------------------------------------------------------------------
		--=============================================================================================================================
		-- 종료 LOG (END)
		--=============================================================================================================================

	--=============================================================================================================================
	-- 결과코드, 결과 카운트 반환
	--=============================================================================================================================
	SELECT  'S' AS result_code,  @EDIT_CNT AS result_cnt ;

	COMMIT
	END TRY
	
	--------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (START)	
	--------------------------------------------------------------------------------------------------------------
	BEGIN CATCH 
		BEGIN
			ROLLBACK
			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			SET @v_log_type		= 'ERROR';		--[E20250915-000105]_END -> ERROR로 변경
			SET @v_log_message	= '########## FAIL-1 END of procedure ##########'; -- SQL문법 실행 중 오류
			SET @d_event_date	= SYSDATETIME();			
			-------------------------------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
			-------------------------------------------------------------------------------------------------------------------------------
	
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_err_message, @d_event_date, @v_created_by;
			-------------------------------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
			-------------------------------------------------------------------------------------------------------------------------------
			-- DataTable[0]
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT 	'F' AS RESULT_CODE, @v_err_code AS ERR_CODE, @v_err_message AS ERR_MESSAGE, 'BEGIN CATCH - SQL ERROR' AS ERR_EVENT
		END;
	END CATCH;
	--------------------------------------------------------------------------------------------------------------
	-- 트랜잭션 (END)	
	--------------------------------------------------------------------------------------------------------------
	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			ROLLBACK
			SET @v_log_type		= 'END';
			SET @v_log_message	= '########## FAIL-2 END of procedure ##########'; -- Validation Check 에 해당
			SET @d_event_date	= SYSDATETIME();
			-------------------------------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (START)
			-------------------------------------------------------------------------------------------------------------------------------
	
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date, @v_created_by;
			-------------------------------------------------------------------------------------------------------------------------------
			-- [E20250915-000105]_로그저장시 사용자ID로 저장되도록 변수 추가 및 원소스 로그처리 주석 후 작성 (END)
			-------------------------------------------------------------------------------------------------------------------------------

			-- DataTable[0]
			-- 결과코드, 결과 카운트 반환
			SELECT  'F' AS RESULT_CODE,  @v_description AS RESULT_MSG, 'ERR_RTN: - Validation Check' AS ERR_EVENT
		END
END
