

/*
 * Program ID   : PR_SCP_BI_FP_RESULT_DAILY
 * Description  : SCP_FP_생산실적 생성 Daily
 * OutTable     :
 * Execute      :
                 EXEC PR_SCP_BI_FP_RESULT_DAILY  @p_PLAN_START_YYYYMMDD = '20221031'
				 EXEC PR_SCP_BI_FP_RESULT_DAILY  @p_PLAN_START_YYYYMMDD = ''

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.11.01   LWY           Initial Release       Power BI - SCP_FP_생산실적 생성 DAILY
 * 2023.07.20   HRK           PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : FP 실적 UPDATE 쿼리 변경
 * 2024.06.09   vadabi3       NERP - 특정 Company 별도 처리 개선
 * 2024.11.19   vadabi3       NERP - 개발DB 적용 및 개선
 ----------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_SCP_BI_FP_RESULT_DAILY_0729_ORG_dev]
(
    @p_plan_start_yyyymmdd	  NVARCHAR(008) = '' 
)
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';
    SET @v_batch_user = 'System'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_BI_FP_RESULT_DAILY';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_BI_FP_RESULT_DAILY'; -- 테이블
    DECLARE @d_event_date   DATETIME;

	-- NERP 매핑코드
    DECLARE @v_ESOC NVARCHAR(8);-- C100 -> HQ00
    DECLARE @v_ESNJ NVARCHAR(8);-- G180 -> WA00
    DECLARE @v_ESMI NVARCHAR(8);-- G380 -> MI00
    DECLARE @v_ESNA NVARCHAR(8);-- G450 -> NA00
    DECLARE @v_ESWA NVARCHAR(8);-- G480 -> WA00
    DECLARE @v_ESNB NVARCHAR(8);-- G630 -> NB00
    DECLARE @v_HZP  NVARCHAR(8);-- G388 -> G388 

    DECLARE @v_ESOC_NAME  NVARCHAR(8); -- ESOC
    DECLARE @v_ESNJ_NAME  NVARCHAR(8); -- ESNJ
    DECLARE @v_ESMI_NAME  NVARCHAR(8); -- ESMI
    DECLARE @v_ESNA_NAME  NVARCHAR(8); -- ESNA
    DECLARE @v_ESWA_NAME  NVARCHAR(8); -- ESWA
    DECLARE @v_ESNB_NAME  NVARCHAR(8); -- ESNB
    DECLARE @v_HZP_NAME  NVARCHAR(8);  -- HZP

	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESOC');
	SELECT @v_ESNJ = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESNJ');
	SELECT @v_ESMI = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESMI');
	SELECT @v_ESNA = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESNA');
	SELECT @v_ESWA = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESWA');
	SELECT @v_ESNB = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','ESNB');
	SELECT @v_HZP  = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_BI_FP_RESULT','HZP' );

	select @v_ESOC_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESOC
	select @v_ESNJ_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESNJ
	select @v_ESMI_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESMI
	select @v_ESNA_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESNA
	select @v_ESWA_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESWA
	select @v_ESNB_NAME = segment2 from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC' and segment1 = @v_ESNB
	select @v_HZP_NAME  = dbo.FN_GET_LOOKUP_VALUE('PLANT_DESC',@v_HZP)

    --시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' Power BI - SCP_FP_생산실적 DAILY CREATE';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count
                              ,@p_log_message   = @v_log_message
                              ,@p_description   = @v_description
                              ,@p_event_date    = @d_event_date
                              ,@p_user_id       = @v_batch_user
                              ;


    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';


	DECLARE   @v_plan_start_yyyymmdd  NVARCHAR(20) = ''
	        , @v_cur_plan_start_yyyymmdd  NVARCHAR(20) = ''  -- 당주
			, @v_plan_week            NVARCHAR(20) = ''
			, @v_bf_date			  NVARCHAR(20) = ''
			, @v_at_date			  NVARCHAR(20) = ''
	;	
    
    -- ISUZU item
	IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
    BEGIN
        DROP TABLE #tmp_ISUZU;
    END
    
    BEGIN TRY
      BEGIN	  
        
		/* 2023.07.20 변경전 쿼리
        SELECT A.ITEM_ID
        INTO #tmp_ISUZU
        FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
        INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
        WHERE A.IS_YN = 'Y'
		*/

		-- 2023.07.20 변경후 쿼리 (중복데이터 제거)
        SELECT A.ITEM_ID
        INTO #tmp_ISUZU
        FROM dbo.SCP_MST_FINAL_ITEM_V A WITH(NOLOCK)
        WHERE A.IS_YN = 'Y'

	    -- 입력 p_plan_start_yyyymmdd 로 수행
	    IF( (@p_plan_start_yyyymmdd IS NOT NULL AND @p_plan_start_yyyymmdd  != '' ) )
			BEGIN
				SET @v_plan_start_yyyymmdd     = format(DATEADD(WK, DATEDIFF(WK, 0, @p_plan_start_yyyymmdd)-1, 0), 'yyyyMMdd') ;  -- 전주
				SET @v_cur_plan_start_yyyymmdd = format(DATEADD(WK, DATEDIFF(WK, 0, @p_plan_start_yyyymmdd), 0), 'yyyyMMdd');     -- 당주
			END
		ELSE
			BEGIN	
				/* 20230720 변경전 소스
				SET @v_plan_start_yyyymmdd     = format(DATEADD(WK, DATEDIFF(WK, 0, getdate())-1, 0), 'yyyyMMdd')  -- 전주
				SET @v_cur_plan_start_yyyymmdd = format(DATEADD(WK, DATEDIFF(WK, 0, getdate()), 0), 'yyyyMMdd')    -- 당주
				;
				*/
				-- 2023.07.20 변경후 전주/당주 
				SELECT @v_cur_plan_start_yyyymmdd = MAX(BASIS_YYYYMMDD)												-- 당주
					 , @v_plan_start_yyyymmdd	  = CONVERT(NVARCHAR(8), DATEADD(WEEK, -1, MAX(BASIS_DATE)),112)	-- 전주 
				 FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
				WHERE 1=1
				  AND BASIS_DATE <= GETDATE()
				  AND DAYOFWEEK   = 'MON'
				  ;
			END


		-- 집계데이타 : 당주 - 일주일(Daily)
		SELECT @v_bf_date = ISO_YYYYWW
		     , @v_at_date = ISO_YYYYWW
	    FROM SCM_SYS_CALENDAR_M WITH (NOLOCK)
	    WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(day,  0, @v_cur_plan_start_yyyymmdd), 112)		-- 당주
	    ;


		-- Get plan_week
		SELECT	@v_plan_week = ISO_YYYYWW
		FROM	SCM_MST_PLAN A WITH(NOLOCK), SCM_SYS_CALENDAR_M B WITH(NOLOCK)
		WHERE	1=1
		AND		A.PLAN_NAME   = @v_plan_start_yyyymmdd
		AND		A.PLAN_CYCLE  = 'WEEKLY' 
		AND		A.DIVISION_ID = '81'
		AND		A.PLAN_NAME   = B.BASIS_YYYYMMDD
		;

		-------------- Log ---------------------------------
		--print @v_plan_week;
		--print @v_plan_start_yyyymmdd;
		--print @v_cur_plan_start_yyyymmdd
		--print @v_bf_date;
		--print @v_at_date;
		----------------------------------------------------
		
		-------------------------------------------------------------------------------------------------------------
		-- 기존 데이타 DELETE
		-------------------------------------------------------------------------------------------------------------

		IF EXISTS 
		(
			SELECT *
			  FROM SCP_BI_FP_RESULT_DAILY with(nolock)
			WHERE 1 = 1
			AND PLAN_WEEK   = @v_plan_week
		)
		
		BEGIN
			DELETE FROM SCP_BI_FP_RESULT_DAILY
			WHERE 1 = 1
			AND PLAN_WEEK   = @v_plan_week
			;
		END
		;
		---------------------

		-------------------------------------------------
		-- logic Start _Create By SCM Solution팀
		-------------------------------------------------
		
		WITH PLAN_INFO AS
		(
			SELECT	 @v_plan_week			AS PLAN_WEEK
					,@v_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
					,@v_bf_date				AS BF_DATE
					,@v_at_date				AS AT_DATE
		),
		PLAN_SEQ_INFO AS -- SCP PLAN_INFO_DETAIL 
		(
			SELECT	DISTINCT 
					DIVISION_ID,					-- DIVISION_ID
					PLAN_TYPE,						-- PLAN_TYPE
					MAX(SEQ) AS SEQ					-- 버전 별 최종 SEQ
			FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
			      , PLAN_INFO B
			WHERE	1=1
			AND		A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			AND		DIVISION_ID IN ('81','82','40','EE')
			GROUP	BY DIVISION_ID, PLAN_TYPE
		),
		PLAN_INFO_DET AS
		(
			SELECT	A.*, DATE_FULL_NAME AS PLAN_ST_DATE
			FROM	PLAN_INFO A
			      , DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK)
			WHERE	1=1
			AND		A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD
		),
		PLAN_DATE_INFO AS 
		(
			SELECT	C.PLAN_ST_DATE, A.MONTH_NAME, A.ISO_YYYYWW, CONCAT(CONCAT(A.MONTH_NAME,'-'), SUBSTRING(A.BASIS_START_DATE,7,2)) AS PARTIAL_START_DATE, B.BASIS_DATE AS TARGET_ST_DATE, CONCAT(D.KPI_MONTH,'-01') AS KPI_MONTH
			FROM	DBO.SCM_SYS_CALENDAR_M A WITH(NOLOCK)
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CONVERT(CHAR(10), BASIS_DATE, 23) AS BASIS_DATE
									FROM	DBO.SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE	1=1
									AND		DAYOFWEEK = 'MON'				
									) B ON A.ISO_YYYYWW = B.ISO_YYYYWW
					LEFT OUTER JOIN (
									SELECT	ISO_YYYYWW, CALENDAR_YYYY+'-'+CALENDAR_MONTH AS KPI_MONTH
									FROM	DBO.SCM_SYS_CALENDAR_M WITH(NOLOCK)
									WHERE	1=1
									AND		DAYOFWEEK = 'THU'					
									) D ON A.ISO_YYYYWW = D.ISO_YYYYWW
					, PLAN_INFO_DET C
			WHERE	1=1
			AND		A.END_FLAG = 'Y'
		),
		-- ■ 마스터 데이터 집계 시작
		MODEL_TYPE AS
		(
			-- 자동차 MODEL_TYPE LIST
			SELECT	C.*,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C WITH(NOLOCK)
			WHERE	1=1
			AND		DIVISION_ID = '81'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'		
			AND		SUBSTRING(ITEM_ID,1,2) IN ('AC','AM','AP')	-- 자동차 완제품 기준
			UNION ALL
			-- ESS MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
						 WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE,
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'CELL'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('House'  , C.ITEM_CLASS_NAME) > 0) THEN 'House'
								WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Rack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Rack'
						ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C WITH(NOLOCK)
			WHERE	1=1
			AND		DIVISION_ID = '82'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('E','M','A') -- ESS 완제품 기준
			UNION ALL
			-- 소형 MODEL_TYPE LIST
			SELECT	C.*, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS MODEL_TYPE, 
					CASE WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Cell', C.ITEM_CLASS_NAME) > 0) THEN 'Cell'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', C.ITEM_CLASS_NAME) > 0) THEN 'Module'
							WHEN (C.FORECAST_INFO_BIZ_TYPE IS NULL AND  CHARINDEX('Pack'  , C.ITEM_CLASS_NAME) > 0) THEN 'Pack'
					ELSE C.FORECAST_INFO_BIZ_TYPE END AS ORI_MODEL_TYPE
			FROM	DM_MST_ITEM_SINGLE_V C WITH(NOLOCK)
			WHERE	1=1
			AND		DIVISION_ID = '40'
			--AND		ITEM_TYPE = 'P'
			AND		ACTIVE_FLAG = 'Y'
			AND		SUBSTRING(ITEM_ID,1,1) IN ('M','E','A') -- 소형 완제품 기준	
		),
		END_CUSTOMER AS
		(	
			-- 고객사 Logic : 1) SITE, PROJECT 둘다 매핑되는 고객사 셋팅 2) 1에서 NULL 나오는 CASE는 SITE만 있으면 매핑 3) 그래도 매핑 안되는 case는 'NULL_Site' 정보 제공
			SELECT	DISTINCT 
					A.DIVISION_ID, 
					A.PROJECT_CODE, 
					A.SCM_SITE_ID, 
					A.ITEM_ID, 
					A.CELL_PER_CAR,
					A.CELL_PER_MODULE,
					-- 40에서 APPLICATION으로 CATEGORY 구분함(EX> 노트북 등..)
					A.CUST_GROUP, 
					A.CUST_GROUP_DTL, 
					A.APPLICATION,
					A.CELL_MODEL, 
					A.PRODUCT_GROUP,
					CASE WHEN A.DIVISION_ID = '40' THEN D.DEPT_NAME_KO
							ELSE C.DEPT_NAME_KO END AS DEPT_NAME_KO,
					A.VMI_YN,
					-- 40은 PROJECT_CODE가 END_CUSTOMER임.
					CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE 
							ELSE (CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END) END AS END_CUSTOMER
					---CASE WHEN A.END_CUSTOMER IS NULL THEN B.END_CUSTOMER ELSE A.END_CUSTOMER END AS END_CUSTOMER
			FROM	(
					SELECT	DISTINCT A.DIVISION_ID, 
							A.PROJECT_CODE, 
							A.SCM_SITE_ID, 
							A.ITEM_ID, 
							B.END_CUSTOMER, 
							A.CELL_PER_CAR, 
							A.CELL_PER_MODULE, 
							A.CUST_GROUP, 
							A.CUST_GROUP_DTL, 
							A.APPLICATION, 
							A.ATTRIBUTE5 AS CELL_MODEL, 
							A.REPORT_GROUP3 AS PRODUCT_GROUP,
							B.VMI_YN,
							-- 81, 82의 경우 DEPT_ID는 PROJECT 정보를(SCM_MST_SITE에서) 참조하나, 40인 경우에는 OWNER의 부서정보를 참조함(공용화모델 CASE로 중복 발생 때문)
							B.DEPT_ID AS DEPT_ID,	-- 81, 82
						(	SELECT SU.DEPT_ID  
							FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
							WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](A.owner, ',')) ) DEPT_ID_SMALL  -- 40
					FROM	SCM_MST_SITE_ITEM A WITH(NOLOCK), SCM_MST_SITE B WITH(NOLOCK)
					WHERE	1=1
					AND		A.DIVISION_ID = B.DIVISION_ID
					AND		A.SCM_SITE_ID = B.SCM_SITE_ID
					AND		A.VALID_YN = 'Y'
					AND		B.VALID_YN = 'Y'	
					) A 
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO C ON A.DEPT_ID = C.DEPT_ID
					LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO D ON A.DEPT_ID_SMALL = D.DEPT_ID
					, SCM_MST_SITE B
			WHERE	1=1
			AND		A.SCM_SITE_ID = B.SCM_SITE_ID
			AND		A.DIVISION_ID = B.DIVISION_ID
			AND		B.VALID_YN = 'Y'
		),
		PRODUCT_GROUP AS
		(
			SELECT	DISTINCT DIVISION_ID, ITEM_ID, MAX(PRODUCT_GROUP) AS PRODUCT_GROUP
			FROM	END_CUSTOMER
			GROUP	BY DIVISION_ID, ITEM_ID
		),
		SCP_MST_FINAL_ITEM_VIEW AS
		(
			SELECT	A.*, B.SEGMENT2 
			FROM	SCP_MST_FINAL_ITEM A WITH(NOLOCK)
					LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
			WHERE	1=1
		),
		LINE_INFO AS
		(
			SELECT	OPERATION_ID, LINE_ID, MAX(DESCRIPTION) AS DESCRIPTION
			FROM	(
					SELECT	*--DISTINCT OPERATION_ID, LINE_ID, LINE_NAME
					FROM	[dbo].[SCM_MST_LINE_SN] WITH(NOLOCK)
					WHERE	1=1
					AND		ACTIVE_FLAG = 'Y'
					AND		SUBSTRING(OPERATION_ID,1,1) IN ('A','P','E')
					) A
			WHERE	1=1
			GROUP	BY OPERATION_ID, LINE_ID
		),
		MODEL_BOM AS
		(
			SELECT	DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID, ROUND(AVG(ACCUMULATED_CHILD_QTY),1) AS ACCUMULATED_CHILD_QTY
			FROM	DBO.SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK),
					(
					SELECT	DISTINCT ITEM_ID
					FROM	SCP_MST_FINAL_ITEM WITH(NOLOCK)
					WHERE	1=1
					AND		OPERATION_GROUP = 'A'
					) B
			WHERE	1=1
			AND		A.OPERATION_GROUP_ID = 'A'	
			AND		A.CHILD_ITEM_ID = B.ITEM_ID
			GROUP	BY DIVISION_ID, MODEL_ID, OPERATION_GROUP_ID
		),
		OUTSOURCING_PLANT_INFO AS
		(
			SELECT	DISTINCT DIVISION_ID, PLANT_ID, SITE_DESCRIPTION
			FROM	SCM_MST_SITE WITH(NOLOCK)
			WHERE	1=1
			AND		SITE_TYPE = 'PLANT'
			AND		VALID_YN = 'Y'
			AND		OSP_YN = 'Y'
		),
		ELEC_CONVERT_QTY_CELL AS
		(	-- Pouch용 전극 Cell 환산 수량 컨버젼 데이터
			SELECT	DISTINCT A.DIVISION_ID, A.ITEM_ID, A.OPERATION_GROUP, A.CELL_ITEM_ID, 
					CASE WHEN A.DIVISION_ID NOT IN ('40') THEN 'Pouch' ELSE B.SEGMENT2 END AS ELECTRODE_TYPE, A.CONVERT_QTY_CELL
			FROM	SCP_MST_FINAL_ITEM A WITH(NOLOCK)
					LEFT OUTER JOIN 
					(
					SELECT	DISTINCT DIVISION_ID, ITEM_ID, B.SEGMENT2
					FROM	SCP_MST_FINAL_ITEM A WITH(NOLOCK)
							LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.CELL_TYPE_GROUP_CODE = B.SEGMENT1 AND B.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE' AND B.VALID_YN = 'Y'
					WHERE	1=1
					AND		OPERATION_GROUP <> 'E'		
					) B ON A.DIVISION_ID = B.DIVISION_ID AND A.CELL_ITEM_ID = B.ITEM_ID
			WHERE	1=1
			AND		OPERATION_GROUP = 'E'
		),
		GROUP_CODE AS
		(
			SELECT	DISTINCT DIVISION_ID, ITEM_ID, DOE, MAX(SCP_EXTRA_SPEC) AS EXTRA_SPEC
			FROM	[dbo].[scm_item_m_sn] WITH(NOLOCK)
			WHERE	1=1
			AND		ITEM_TYPE = 'P'	
			GROUP	BY DIVISION_ID, ITEM_ID, DOE
		),
		-- ■ FP 생산계획 집계 시작
		FP_PLAN AS -- DPP
		(
			-- FP 계획 210 
			SELECT	'FP' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(PLAN_QTY) AS FP_QTY,
					convert(varchar,PLAN_DATE, 112) as YYYYMMDD

			FROM	(
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	[dbo].[SCM_DNM_FP_RELEASE_PROD_PLAN_SN] A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D
					WHERE	A.PLAN_TYPE = 'RELEASE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, convert(varchar,PLAN_DATE, 112)
			HAVING	SUM(PLAN_QTY) > 0
		),
		FP_WPP_PLAN AS -- WPP
		(
			-- FP 계획 210 
			SELECT	'FP' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(PLAN_QTY) AS FP_WPP_QTY,
					convert(varchar,PLAN_DATE, 112) as YYYYMMDD
			FROM	(
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	[dbo].[SCM_DNM_FP_RELEASE_PROD_PLAN_SN] A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B, PLAN_INFO D
					WHERE	A.PLAN_TYPE = 'WPP'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, convert(varchar,PLAN_DATE, 112)
			HAVING	SUM(PLAN_QTY) > 0
		),
		FP_WPP_PLAN_SUNDAY AS -- 일요일 자정 Cutoff WPP 
		(
			-- FP 계획 210 
			SELECT	'FP' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(PLAN_QTY) AS FP_SUN_WPP_QTY,
					convert(varchar,PLAN_DATE, 112) as YYYYMMDD
			FROM	(
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	[dbo].[SCM_DNM_FP_RELEASE_PROD_PLAN_DW_SN] A WITH(NOLOCK) -- FP_DAILY_PRODUCTIOIN_PLAN_H A 일요일 자정 cutoff 데이터 추가.
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B, PLAN_INFO D
					WHERE	A.PLAN_TYPE = 'WPP'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')				
					AND		A.YYYYWW = D.PLAN_WEEK -- 주별 버전 관리함.
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, convert(varchar,PLAN_DATE, 112)
			HAVING	SUM(PLAN_QTY) > 0
		),	
		FP_MPP_PLAN AS -- MPP
		(
			-- FP 계획 210 
			SELECT	'FP' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					PRODUCTION_TYPE, 
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(PLAN_QTY) AS FP_MPP_QTY,
					convert(varchar,PLAN_DATE, 112) as YYYYMMDD
			FROM	(
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	[dbo].[SCM_DNM_FP_RELEASE_PROD_PLAN_SN] A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B, PLAN_INFO D
					WHERE	A.PLAN_TYPE = 'MPP'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')

                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, convert(varchar,PLAN_DATE, 112)
			HAVING	SUM(PLAN_QTY) > 0
		),
		SCP_FP_V AS
		(
			-- FP 계획 210 
			SELECT	'SCP_FP_V' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(PLAN_QTY) AS FP_V_QTY,
					convert(varchar,PLAN_DATE, 112) as YYYYMMDD
			FROM	(
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCM_DNM_FP_RELEASE_PROD_PLAN_C A WITH(NOLOCK)--[LGCE_FP_TR].[DBO].[IF_FP_RELEASE_PLAN_V] A
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D
					WHERE	1=1
					AND		A.YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, convert(varchar,PLAN_DATE, 112)
			HAVING	SUM(PLAN_QTY) > 0
		),
		-- ■ 생산실적 집계 시작
		PROD_RESULT AS
		(
			-- FP 실적 228
			SELECT	'PROD_RESULT' AS PLAN_TYPE,
					DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH, 
					GROUP_CODE, 
					PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(ACTUAL_GOOD_QTY) AS RESULT_QTY,
					YYYYMMDD
			FROM	(
					-- 사내 생산 실적
					SELECT	A.DIVISION_ID, A.ITEM_ID, A.LINE_ID, A.OPERATION_ID, A.ACTUAL_GOOD_QTY, A.PRODUCTION_TYPE, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					       ,convert(varchar,PLAN_DATE, 112) as YYYYMMDD
					FROM	[dbo].[SCM_DNM_DAILY_PRODUCT_RESULT_SN] A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D
					WHERE	1=1
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('E2000','A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN (
                                                SELECT DISTINCT b.SEGMENT4
                                                FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                AND b.valid_yn    = 'Y'
                                                AND b.segment3    = 'Y' -- Capa 세부 공정 여부
                                               )
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.PLAN_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					UNION ALL
					-- 외주 팩 실적
					SELECT	A.DIVISION_ID, A.ITEM_ID, A.LINE_ID, 
							-- 외주 팩 생산 실적 테이블의 불필요한 구분자를 제거하여 SCP OPERATION_ID와 동일한 값으로 수정함.
							CASE WHEN (CHARINDEX('_', A.PACKER_CODE) > 0) THEN SUBSTRING(A.PACKER_CODE, 1, CHARINDEX('_', A.PACKER_CODE)-1)
								 ELSE (CASE WHEN (CHARINDEX('-', A.PACKER_CODE) > 0) THEN SUBSTRING(A.PACKER_CODE, 1, CHARINDEX('-', A.PACKER_CODE)-1) ELSE A.PACKER_CODE END)
							END AS OPERATION_ID,
							A.PROD_QTY AS ACTUAL_GOOD_QTY, '' AS PRODUCTION_TYPE, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
							,convert(varchar,PROD_DATE, 112) as YYYYMMDD
					FROM	SCM_DNM_SCS_PROD_RESULT A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D
					WHERE	1=1
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		A.PROD_DATE = B.BASIS_DATE
					AND		A.DIVISION_ID IN ('81','82','40')
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, DIVISION_ID, PRODUCTION_TYPE, PLAN_WEEK, MONTH_NAME, YYYYMMDD
		),
		-- ■ SCP 생산계획 집계 시작
		SCP_PLAN_FN AS
		(
			-- SCP W42(20211018)에 짠 SCP PROD PLAN의 차주( W43 : 10/25 ~ 10/31) 데이터 251
			SELECT	'SCP' AS PLAN_TYPE,
					ORIGIN_DIVISION_ID AS DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					'' AS PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(QTY) AS SCP_QTY,
					YYYYMMDD
			FROM	(
					-- 자체 사내 생산 (EE 제외)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40')
					AND		A.PLAN_TYPE = 'FN'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 자체 사내 생산 (EE) ← DIV = 'EE'인데 OPERATION_ID가 A9000등 데이터가 있음... 
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('EE')
					AND		A.PLAN_TYPE = 'FN'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		A.OPERATION_ID IN ('E2000')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 외주 물량 (외주 팩 계획)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40') -- EE는 외주 X
					AND		A.PLAN_TYPE = 'FN'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		SUBSTRING(A.OPERATION_ID,1,1) NOT IN ('A','F','P')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, ORIGIN_DIVISION_ID, PLAN_WEEK, MONTH_NAME, YYYYMMDD
		),
		SCP_PLAN_TE AS
		(
			-- SCP W42(20211018)에 짠 SCP PROD PLAN의 차주( W43 : 10/25 ~ 10/31) 데이터 251
			SELECT	'SCP' AS PLAN_TYPE,
					ORIGIN_DIVISION_ID AS DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					'' AS PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(QTY) AS SCP_QTY,
					YYYYMMDD
			FROM	(
					-- 자체 사내 생산 (EE 제외)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40')
					AND		A.PLAN_TYPE = 'TE'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
							
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 자체 사내 생산 (EE) ← DIV = 'EE'인데 OPERATION_ID가 A9000등 데이터가 있음... 
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('EE')
					AND		A.PLAN_TYPE = 'TE'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		A.OPERATION_ID IN ('E2000')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 외주 물량 (외주 팩 계획)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40') -- EE는 외주 X
					AND		A.PLAN_TYPE = 'TE'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_AMEND'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		SUBSTRING(A.OPERATION_ID,1,1) NOT IN ('A','F','P')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, ORIGIN_DIVISION_ID, PLAN_WEEK, MONTH_NAME, YYYYMMDD
		),
		SCP_PLAN_PR AS
		(
			-- SCP W42(20211018)에 짠 SCP PROD PLAN의 차주( W43 : 10/25 ~ 10/31) 데이터 251
			SELECT	'SCP' AS PLAN_TYPE,
					ORIGIN_DIVISION_ID AS DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					'' AS PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(QTY) AS SCP_QTY,
					YYYYMMDD
			FROM	(
					-- 자체 사내 생산 (EE 제외)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40')
					AND		A.PLAN_TYPE = 'PR'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
					
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 자체 사내 생산 (EE) ← DIV = 'EE'인데 OPERATION_ID가 A9000등 데이터가 있음... 
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('EE')
					AND		A.PLAN_TYPE = 'PR'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		A.OPERATION_ID IN ('E2000')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 외주 물량 (외주 팩 계획)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40') -- EE는 외주 X
					AND		A.PLAN_TYPE = 'PR'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		SUBSTRING(A.OPERATION_ID,1,1) NOT IN ('A','F','P')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, ORIGIN_DIVISION_ID, PLAN_WEEK, MONTH_NAME, YYYYMMDD
		),
		SCP_PLAN_MA AS
		(
			-- SCP W42(20211018)에 짠 SCP PROD PLAN의 차주( W43 : 10/25 ~ 10/31) 데이터 251
			SELECT	'SCP' AS PLAN_TYPE,
					ORIGIN_DIVISION_ID AS DIVISION_ID,
					PLAN_WEEK,
					ISO_YYYYWW AS TARGET_WEEK,
					MONTH_NAME AS TARGET_MONTH,
					GROUP_CODE, 
					'' AS PRODUCTION_TYPE,
					ITEM_ID, 
					LINE_ID, OPERATION_ID, SUM(QTY) AS SCP_QTY,
					YYYYMMDD
			FROM	(
					-- 자체 사내 생산 (EE 제외)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40')
					AND		A.PLAN_TYPE = 'MA'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					-- AND		A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
					
                    -- PJ20216891	
                    -- ISUZU item
                    AND     (
                             A.OPERATION_ID IN ('A3000','A9000','P5500','P9500')
                             OR (
                                 A.OPERATION_ID = 'P5000'
                                 AND EXISTS (
                                             SELECT 1
                                             FROM   #tmp_ISUZU
                                             WHERE  ITEM_ID = A.ITEM_ID
                                            )
                                )
                            )
					
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 자체 사내 생산 (EE) ← DIV = 'EE'인데 OPERATION_ID가 A9000등 데이터가 있음... 
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('EE')
					AND		A.PLAN_TYPE = 'MA'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		A.OPERATION_ID IN ('E2000')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					UNION ALL
					-- 외주 물량 (외주 팩 계획)
					SELECT	A.*, B.ISO_YYYYWW, CASE WHEN C.DOE IS NULL THEN A.ITEM_ID ELSE C.DOE END AS GROUP_CODE, PLAN_WEEK, MONTH_NAME
					FROM	SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK)
							LEFT OUTER JOIN GROUP_CODE C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
							, DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK), PLAN_INFO D, PLAN_SEQ_INFO E
					WHERE	1=1
					AND		A.DIVISION_ID IN ('81','82','40') -- EE는 외주 X
					AND		A.PLAN_TYPE = 'MA'
					AND		A.PLAN_START_YYYYMMDD = D.PLAN_START_YYYYMMDD
					AND		A.MEASURE = 'PROD_PLAN_ENGINE'
					AND		B.ISO_YYYYWW BETWEEN D.BF_DATE AND D.AT_DATE 
					AND		SUBSTRING(A.OPERATION_ID,1,1) NOT IN ('A','F','P')
					AND		A.QTY > 0
					AND		A.YYYYMMDD = B.BASIS_YYYYMMDD
					AND		A.DIVISION_ID = E.DIVISION_ID
					AND		A.PLAN_TYPE = E.PLAN_TYPE
					AND		A.SEQ = E.SEQ
					) A
			WHERE	1=1
			GROUP	BY ITEM_ID, GROUP_CODE, LINE_ID, OPERATION_ID, ISO_YYYYWW, ORIGIN_DIVISION_ID, PLAN_WEEK, MONTH_NAME, YYYYMMDD
		),
		-- ■ 생산 데이터 LIST 집계 시작
		CASE_LIST AS
		(
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	FP_PLAN
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	SCP_PLAN_FN		
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	SCP_PLAN_MA		
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	SCP_PLAN_PR		
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	SCP_PLAN_TE	
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	FP_WPP_PLAN		
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	FP_MPP_PLAN
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	PROD_RESULT	
			UNION 
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	SCP_FP_V
			UNION
			SELECT	DISTINCT PLAN_WEEK, TARGET_WEEK, DIVISION_ID, GROUP_CODE, ITEM_ID, LINE_ID, PRODUCTION_TYPE, OPERATION_ID, TARGET_MONTH, YYYYMMDD
			FROM	FP_WPP_PLAN_SUNDAY
		),
		SEMI_FINAL AS -- 323
		(
			SELECT	A.*,
					ISNULL(B.SCP_QTY,0) AS SCP_FN_QTY, 
					ISNULL(E.SCP_QTY,0) AS SCP_TE_QTY, 
					ISNULL(F.SCP_QTY,0) AS SCP_MA_QTY, 
					ISNULL(G.SCP_QTY,0) AS SCP_PR_QTY, 
					ISNULL(H.FP_V_QTY,0) AS FP_V_QTY, 
					ISNULL(C.FP_QTY,0) AS FP_DPP_QTY,
					ISNULL(J.FP_WPP_QTY,0) AS FP_WPP_QTY,				
					ISNULL(L.FP_SUN_WPP_QTY,0) AS FP_SUN_WPP_QTY,
					ISNULL(K.FP_MPP_QTY,0) AS FP_MPP_QTY,
					ISNULL(I.RESULT_QTY,0) AS RESULT_QTY
			FROM	CASE_LIST A
					LEFT OUTER JOIN SCP_PLAN_FN B ON A.DIVISION_ID = B.DIVISION_ID AND A.GROUP_CODE = B.GROUP_CODE AND A.ITEM_ID = B.ITEM_ID AND A.LINE_ID = B.LINE_ID AND A.OPERATION_ID = B.OPERATION_ID AND A.PLAN_WEEK = B.PLAN_WEEK AND A.TARGET_WEEK = B.TARGET_WEEK AND A.TARGET_MONTH = B.TARGET_MONTH AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.YYYYMMDD = B.YYYYMMDD
					LEFT OUTER JOIN SCP_PLAN_TE E ON A.DIVISION_ID = E.DIVISION_ID AND A.GROUP_CODE = E.GROUP_CODE AND A.ITEM_ID = E.ITEM_ID AND A.LINE_ID = E.LINE_ID AND A.OPERATION_ID = E.OPERATION_ID AND A.PLAN_WEEK = E.PLAN_WEEK AND A.TARGET_WEEK = E.TARGET_WEEK AND A.TARGET_MONTH = E.TARGET_MONTH AND A.PRODUCTION_TYPE = E.PRODUCTION_TYPE AND A.YYYYMMDD = E.YYYYMMDD
					LEFT OUTER JOIN SCP_PLAN_MA F ON A.DIVISION_ID = F.DIVISION_ID AND A.GROUP_CODE = F.GROUP_CODE AND A.ITEM_ID = F.ITEM_ID AND A.LINE_ID = F.LINE_ID AND A.OPERATION_ID = F.OPERATION_ID AND A.PLAN_WEEK = F.PLAN_WEEK AND A.TARGET_WEEK = F.TARGET_WEEK AND A.TARGET_MONTH = F.TARGET_MONTH AND A.PRODUCTION_TYPE = F.PRODUCTION_TYPE AND A.YYYYMMDD = F.YYYYMMDD
					LEFT OUTER JOIN SCP_PLAN_PR G ON A.DIVISION_ID = G.DIVISION_ID AND A.GROUP_CODE = G.GROUP_CODE AND A.ITEM_ID = G.ITEM_ID AND A.LINE_ID = G.LINE_ID AND A.OPERATION_ID = G.OPERATION_ID AND A.PLAN_WEEK = G.PLAN_WEEK AND A.TARGET_WEEK = G.TARGET_WEEK AND A.TARGET_MONTH = G.TARGET_MONTH AND A.PRODUCTION_TYPE = G.PRODUCTION_TYPE AND A.YYYYMMDD = G.YYYYMMDD
					LEFT OUTER JOIN SCP_FP_V H ON A.DIVISION_ID = H.DIVISION_ID AND A.GROUP_CODE = H.GROUP_CODE AND A.ITEM_ID = H.ITEM_ID AND A.LINE_ID = H.LINE_ID AND A.OPERATION_ID = H.OPERATION_ID AND A.PLAN_WEEK = H.PLAN_WEEK AND A.TARGET_WEEK = H.TARGET_WEEK AND A.TARGET_MONTH = H.TARGET_MONTH AND A.PRODUCTION_TYPE = H.PRODUCTION_TYPE	 AND A.YYYYMMDD = H.YYYYMMDD
					LEFT OUTER JOIN FP_PLAN C ON A.DIVISION_ID = C.DIVISION_ID AND A.GROUP_CODE = C.GROUP_CODE AND A.ITEM_ID = C.ITEM_ID AND A.LINE_ID = C.LINE_ID AND A.OPERATION_ID = C.OPERATION_ID AND A.PLAN_WEEK = C.PLAN_WEEK AND A.TARGET_WEEK = C.TARGET_WEEK AND A.TARGET_MONTH = C.TARGET_MONTH AND A.PRODUCTION_TYPE = C.PRODUCTION_TYPE     AND A.YYYYMMDD = C.YYYYMMDD
					LEFT OUTER JOIN FP_WPP_PLAN J ON A.DIVISION_ID = J.DIVISION_ID AND A.GROUP_CODE = J.GROUP_CODE AND A.ITEM_ID = J.ITEM_ID AND A.LINE_ID = J.LINE_ID AND A.OPERATION_ID = J.OPERATION_ID AND A.PLAN_WEEK = J.PLAN_WEEK AND A.TARGET_WEEK = J.TARGET_WEEK AND A.TARGET_MONTH = J.TARGET_MONTH AND A.PRODUCTION_TYPE = J.PRODUCTION_TYPE AND A.YYYYMMDD = J.YYYYMMDD
					LEFT OUTER JOIN FP_MPP_PLAN K ON A.DIVISION_ID = K.DIVISION_ID AND A.GROUP_CODE = K.GROUP_CODE AND A.ITEM_ID = K.ITEM_ID AND A.LINE_ID = K.LINE_ID AND A.OPERATION_ID = K.OPERATION_ID AND A.PLAN_WEEK = K.PLAN_WEEK AND A.TARGET_WEEK = K.TARGET_WEEK AND A.TARGET_MONTH = K.TARGET_MONTH AND A.PRODUCTION_TYPE = K.PRODUCTION_TYPE AND A.YYYYMMDD = K.YYYYMMDD
					LEFT OUTER JOIN FP_WPP_PLAN_SUNDAY L ON A.DIVISION_ID = L.DIVISION_ID AND A.GROUP_CODE = L.GROUP_CODE AND A.ITEM_ID = L.ITEM_ID AND A.LINE_ID = L.LINE_ID AND A.OPERATION_ID = L.OPERATION_ID AND A.PLAN_WEEK = L.PLAN_WEEK AND A.TARGET_WEEK = L.TARGET_WEEK AND A.TARGET_MONTH = L.TARGET_MONTH AND A.PRODUCTION_TYPE = L.PRODUCTION_TYPE  AND A.YYYYMMDD = L.YYYYMMDD
					LEFT OUTER JOIN PROD_RESULT I ON A.DIVISION_ID = I.DIVISION_ID AND A.GROUP_CODE = I.GROUP_CODE AND A.ITEM_ID = I.ITEM_ID AND A.LINE_ID = I.LINE_ID AND A.OPERATION_ID = I.OPERATION_ID AND A.PLAN_WEEK = I.PLAN_WEEK AND A.TARGET_WEEK = I.TARGET_WEEK AND A.TARGET_MONTH = I.TARGET_MONTH AND A.PRODUCTION_TYPE = I.PRODUCTION_TYPE  AND A.YYYYMMDD = I.YYYYMMDD
			
		),
		FINAL AS
		(
			SELECT	A.*, B.MODEL_TYPE, B.ORI_MODEL_TYPE, B.SCP_EXTRA_SPEC, C.PRODUCT_GROUP, B.MATERIAL_CLASS_NAME, B.NICK_NAME, D.PLAN_ST_DATE, D.PARTIAL_START_DATE, D.TARGET_ST_DATE, D.KPI_MONTH, B.ENERGE, E.EXTRA_SPEC
			FROM	SEMI_FINAL A
					LEFT OUTER JOIN MODEL_TYPE B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
					LEFT OUTER JOIN PRODUCT_GROUP C ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
					LEFT OUTER JOIN PLAN_DATE_INFO D ON A.TARGET_WEEK = D.ISO_YYYYWW AND A.TARGET_MONTH = D.MONTH_NAME
					LEFT OUTER JOIN GROUP_CODE E ON A.DIVISION_ID = E.DIVISION_ID AND A.ITEM_ID = E.ITEM_ID
		),
		RESULT AS
		(
 		SELECT	A.*, D.COMPANY_ID, D.PLANT_ID,
				CASE WHEN D.COMPANY_ID = @v_ESOC THEN @v_ESOC_NAME 
					 WHEN D.COMPANY_ID = @v_ESNJ THEN @v_ESNJ_NAME
					 WHEN D.COMPANY_ID = @v_ESMI THEN (
														CASE 
														WHEN D.PLANT_ID = @v_HZP
														THEN @v_HZP_NAME 
														ELSE @v_ESMI
														END
														) 
					 WHEN D.COMPANY_ID = @v_ESNA THEN @v_ESNA_NAME  
					 WHEN D.COMPANY_ID = @v_ESWA THEN @v_ESWA_NAME
					 WHEN D.COMPANY_ID = @v_ESNB THEN @v_ESNB_NAME
					 ELSE A.OPERATION_ID 
					 END AS PLANT_CODE -- PLANT 늘어나면 추가해야 함. ★

		FROM	FINAL A
				LEFT OUTER JOIN [dbo].[SCM_MST_LINE_SN] D ON A.LINE_ID = D.LINE_ID AND A.OPERATION_ID = D.OPERATION_ID AND D.ACTIVE_FLAG = 'Y'
				LEFT OUTER JOIN SCM_SYS_CALENDAR_M H WITH(NOLOCK) ON A.YYYYMMDD = H.BASIS_YYYYMMDD				
		WHERE	1=1
		)


		-------------------------------------------------------
		-- SCP_BI_FP_RESULT 반영
		-------------------------------------------------------
		INSERT INTO SCP_BI_FP_RESULT_DAILY
		(
			 PLAN_WEEK,PLAN_ST_DATE,TARGET_WEEK,TARGET_MONTH,KPI_MONTH,TARGET_ST_DATE,PARTIAL_START_DATE,PLAN_DATE,DAYOFWEEK,DIVISION_ID,GROUP_CODE,PRODUCTION_TYPE,
			 MODEL,NICK_NAME,ITEM_ID,FACTORY_ID,PLANT_ID,LINE_ID,LINE_DESCRIPTION,OPERATION_ID,OPERATION_NAME,SCP_TE_QTY,SCP_PR_QTY,SCP_MA_QTY,SCP_FN_QTY,FP_V_QTY,FP_DPP_QTY,FP_WPP_QTY,
			 FP_SUN_WPP_QTY,FP_MPP_QTY,RESULT_QTY,ACCUMULATED_CHILD_QTY,OPERATION_GROUP,OPERATION_GROUP_DETAIL,
			 EXTRA_SPEC,ENERGY_KWH,PRODUCT_GROUP,COMPANY_ID,PLANT_CODE,CELL_GROUP,PACK_GROUP,LEVEL2,LEVEL3,LEVEL4,
			 CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
		)

		-- 
		SELECT	
				A.PLAN_WEEK, 
				PLAN_ST_DATE,
				TARGET_WEEK, 
				CONCAT(TARGET_MONTH,'-01') AS TARGET_MONTH,
				KPI_MONTH,
				TARGET_ST_DATE,
				PARTIAL_START_DATE,				
				format(cast(A.YYYYMMDD as date),'yyyy-MM-dd') AS PLAN_DATE,
				A.DAYOFWEEK,      -- ****
				A.DIVISION_ID, 
				GROUP_CODE, 
				A.PRODUCTION_TYPE,
				CASE WHEN A.DIVISION_ID IN ('40') THEN ISNULL(B.NICK_NAME, A.ITEM_ID)
					 WHEN A.DIVISION_ID IN ('81') THEN ISNULL(B.GROUP_CODE2, A.ITEM_ID)
					 WHEN A.DIVISION_ID IN ('82') THEN A.ITEM_ID
					 ELSE A.ITEM_ID 
				END AS MODEL,
				A.NICK_NAME, 
				A.ITEM_ID,
				CASE WHEN A.FACTORY_ID IS NULL THEN '-' ELSE A.FACTORY_ID END FACTORY_ID,
				CASE WHEN A.PLANT_ID IS NULL THEN '-' ELSE A.PLANT_ID END PLANT_ID,
				CASE WHEN A.COMPANY_ID IS NULL THEN 'Outsourcing' ELSE A.LINE_ID END LINE_ID,
				CASE WHEN A.COMPANY_ID IS NULL THEN 'Outsourcing' ELSE (CASE WHEN (C.DESCRIPTION IS NULL OR C.DESCRIPTION = '') THEN A.LINE_ID ELSE C.DESCRIPTION END) END LINE_DESCRIPTION,
				A.OPERATION_ID,
				I.OPERATION_NAME,      -- ****

				-- 'Pouch용 전극' 일 경우 Cell 환산 수 계산
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN SCP_TE_QTY * F.CONVERT_QTY_CELL ELSE SCP_TE_QTY END SCP_TE_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN SCP_PR_QTY * F.CONVERT_QTY_CELL ELSE SCP_PR_QTY END SCP_PR_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN SCP_MA_QTY * F.CONVERT_QTY_CELL ELSE SCP_MA_QTY END SCP_MA_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN SCP_FN_QTY * F.CONVERT_QTY_CELL ELSE SCP_FN_QTY END SCP_FN_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN FP_V_QTY * F.CONVERT_QTY_CELL ELSE FP_V_QTY END FP_V_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN FP_DPP_QTY * F.CONVERT_QTY_CELL ELSE FP_DPP_QTY END FP_DPP_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN FP_WPP_QTY * F.CONVERT_QTY_CELL ELSE FP_WPP_QTY END FP_WPP_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN FP_SUN_WPP_QTY * F.CONVERT_QTY_CELL ELSE FP_SUN_WPP_QTY END FP_SUN_WPP_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN FP_MPP_QTY * F.CONVERT_QTY_CELL ELSE FP_MPP_QTY END FP_MPP_QTY,
				CASE WHEN (SUBSTRING(A.OPERATION_ID,1,1) = 'E' AND F.ELECTRODE_TYPE = 'Pouch') THEN RESULT_QTY * F.CONVERT_QTY_CELL ELSE RESULT_QTY END RESULT_QTY,
				ACCUMULATED_CHILD_QTY,			
				CASE WHEN SUBSTRING(A.OPERATION_ID,1,1) = 'A' THEN 'Cell' 
					 WHEN SUBSTRING(A.OPERATION_ID,1,1) = 'P' THEN 'Pack'  
					 WHEN SUBSTRING(A.OPERATION_ID,1,1) = 'E' THEN 'Elec'  
					 ELSE (CASE WHEN MODEL_TYPE = 'CELL' THEN 'Cell' ELSE 'Pack' END) -- 소형도 외주 셀 생산이 있었음..
				END AS OPERATION_GROUP, 
				CASE WHEN ORI_MODEL_TYPE = 'CELL' THEN 'Cell' WHEN ORI_MODEL_TYPE = 'PACK' THEN 'Pack' 
					 ELSE (CASE WHEN SUBSTRING(A.OPERATION_ID,1,1) = 'E' THEN 'Elec' ELSE ORI_MODEL_TYPE END) END AS OPERATION_GROUP_DETAIL,
				EXTRA_SPEC, 
				ENERGE AS ENERGY_KWH,
				CASE WHEN A.DIVISION_ID IN ('40') THEN B.SEGMENT2 ELSE '-' END AS PRODUCT_GROUP, -- 소형만 쓰이는 컬럼
				CASE WHEN A.COMPANY_ID IS NULL THEN 'Outsourcing' ELSE A.COMPANY_ID END COMPANY_ID, 
				CASE WHEN A.COMPANY_ID IS NULL THEN E.SITE_DESCRIPTION ELSE PLANT_CODE END PLANT_CODE,
				B.GROUP_CODE1,
				B.GROUP_CODE2,
				B.GROUP_CODE3,
				B.GROUP_CODE4,
				B.GROUP_CODE5,
				'scp_batch' AS CREATED_BY, convert(nvarchar, getdate(), 120) as CREATION_DATE, 'scp_batch' AS LAST_UPDATED_BY, convert(nvarchar, getdate(), 120) as LAST_UPDATE_DATE
	
		FROM	RESULT A
				LEFT OUTER JOIN SCP_MST_FINAL_ITEM_VIEW B WITH(NOLOCK) ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
				LEFT OUTER JOIN LINE_INFO C ON A.OPERATION_ID = C.OPERATION_ID AND A.LINE_ID = C.LINE_ID
				LEFT OUTER JOIN MODEL_BOM D ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.MODEL_ID 
				LEFT OUTER JOIN OUTSOURCING_PLANT_INFO E ON A.DIVISION_ID = E.DIVISION_ID AND A.PLANT_CODE = E.PLANT_ID
				LEFT OUTER JOIN ELEC_CONVERT_QTY_CELL F ON A.DIVISION_ID = F.DIVISION_ID AND A.ITEM_ID = F.ITEM_ID
				LEFT OUTER JOIN SCM_MST_OPERATION_SN I WITH(NOLOCK) ON A.COMPANY_ID = I.COMPANY_ID AND A.DIVISION_ID = I.DIVISION_ID AND A.OPERATION_ID = I.OPERATION_ID
				, PLAN_INFO G
				

		WHERE	1=1
		AND     A.DIVISION_ID = '81'  -- '81' 만 적용
		--and A.ITEM_ID = 'ACHP2005I-A1-020'

		ORDER	BY A.DIVISION_ID, A.LINE_ID, A.OPERATION_ID, A.GROUP_CODE, A.PRODUCTION_TYPE, A.YYYYMMDD
		;



		---------------------------------------------------------------
        --1.  -4주 ~ -1주 : 변동이력 update
		--2. SCM_DNM_DAILY_PRODUCT_RESULT_SN -> SCP_BI_FP_RESULT_DAILY
        ---------------------------------------------------------------
		
		--  -4주전 시작일(Monday) : 20220912
		declare @v_from_yyyymmdd nvarchar(8);
		declare @v_to_yyyymmdd nvarchar(8);

		set @v_from_yyyymmdd = format(DATEADD(WK, DATEDIFF(WK, 0, @v_cur_plan_start_yyyymmdd)-4, 0), 'yyyyMMdd')
		;
		
		--  -1주전 종료일(Sunday) : 20221009
		set @v_to_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,@v_cur_plan_start_yyyymmdd) * -1 + 1,@v_cur_plan_start_yyyymmdd),120),'-','')
		;

		--print '-------------------------------';
		--print @v_from_yyyymmdd;
		--print @v_to_yyyymmdd;


		/* 2023.07.20 변경전 쿼리 시작 

		UPDATE S
		SET    S.RESULT_QTY = T.ACTUAL_GOOD_QTY
		      ,LAST_UPDATED_BY = 'scp_batch'
			  ,LAST_UPDATE_DATE = GETDATE()
		FROM   [dbo].[SCP_BI_FP_RESULT_DAILY] S  WITH(NOLOCK),
		       (
			       SELECT A.*
				     FROM [dbo].[SCM_DNM_DAILY_PRODUCT_RESULT_SN] A WITH(NOLOCK)
					WHERE 1 = 1
					  AND A.DIVISION_ID = '81'
					  AND A.PLAN_DATE >= @v_from_yyyymmdd
                      AND A.PLAN_DATE <=  @v_to_yyyymmdd
					  AND A.ACTUAL_GOOD_QTY > 0
					  --AND A.ITEM_ID = 'ACHP2005I-A1-020'   -- TEST

					  AND (
							A.OPERATION_ID IN (
											SELECT DISTINCT b.SEGMENT4
											FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
											WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
											AND b.valid_yn    = 'Y'
											AND b.segment3     = 'Y' -- Capa 세부 공정 여부
											)
							OR (
								A.OPERATION_ID = 'P5000'
								AND EXISTS (
											SELECT 1
											FROM   #tmp_ISUZU
											WHERE  ITEM_ID = A.ITEM_ID
								)
							)
						)
			   ) T			  
		WHERE S.COMPANY_ID      = T.COMPANY_ID
		AND   S.DIVISION_ID     = T.DIVISION_ID
		AND   S.ITEM_ID	        = T.ITEM_ID
		AND   S.OPERATION_ID    = T.OPERATION_ID
		AND   S.PRODUCTION_TYPE = T.PRODUCTION_TYPE
		AND   S.PLAN_DATE       = CONVERT(VARCHAR, T.PLAN_DATE, 112)
		;

		 2023.07.20 변경전 update 쿼리 끝. */ 

		-------------------------------------------------
		-- logic End _Create By SCM Solution팀
		-------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...당주(target week) : ' + ':' + @v_cur_plan_start_yyyymmdd + N', 전주(plan week) : ' + ':' + @v_plan_start_yyyymmdd;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;

		-------------------------------------------------------------------------------------------------------------------
		-- Begin --  PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 자동차(81) FP 실적 UPDATE 쿼리 변경 (-1주~-4주) 
		-------------------------------------------------------------------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'#TEMP_DATE_INFO 데이터 생성 시작 ';
        SET @v_description = N'';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;

		print convert(varchar(30), getdate(), 121) + N'#TEMP_DATE_INFO 데이터 생성 시작' ------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TEMP_DATE_INFO') is not null 
		   DROP TABLE #TEMP_DATE_INFO;

		SELECT CONVERT(VARCHAR(10), CONVERT(DATE, PD.BASIS_YYYYMMDD, 112), 120) 	AS TARGET_ST_DATE			-- 당주(plan_date기준) 
			  ,PD.ISO_YYYYWW														AS TARGET_WEEK				-- 당주(plan_date기준) 
			  ,CONVERT(VARCHAR(10), CONVERT(DATE, PW.BASIS_YYYYMMDD, 112), 120) 	AS PLAN_DATE				-- 당주(plan_date기준)  
			  ,PW.MONTH_NAME+'-01'													AS TARGET_MONTH				-- 당주(plan_date기준) 
			  ,CONVERT(VARCHAR(10), CONVERT(DATE, PW.BASIS_START_DATE, 112), 120)	AS PARTIAL_START_DATE		-- 당주(plan_date기준) 
			  ,PW.DAYOFWEEK															AS DAYOFWEEK				-- 당주(plan_date기준)  
			  ,CONVERT(VARCHAR(10), CONVERT(DATE, PR.basis_yyyymmdd, 112), 120) 	AS PLAN_ST_DATE				-- 전주(plan_date기준)
			  ,PR.ISO_YYYYWW														AS PLAN_WEEK				-- 전주(plan_date기준) week 
			  ,KC.MONTH_NAME+'-01'													AS KPI_MONTH				-- 당주(plan_date기준) 목요일의 해당월
		 INTO #TEMP_DATE_INFO
		 FROM SCM_SYS_CALENDAR_M PD WITH(NOLOCK)			 -- 당주(plan_date기준)
			  INNER JOIN SCM_SYS_CALENDAR_M PW WITH(NOLOCK)  -- 당주(plan_date기준)
					  ON PW.ISO_YYYYWW = pd.ISO_YYYYWW 
			  LEFT  JOIN SCM_SYS_CALENDAR_M pr WITH(NOLOCK)  -- 전주(plan_date기준)
					  ON PR.BASIS_YYYYMMDD = CONVERT(VARCHAR(8), DATEADD(DAY, -7, CONVERT(DATE, PD.BASIS_YYYYMMDD, 112)) ,112) 
			  LEFT  JOIN SCM_SYS_CALENDAR_M kc WITH(NOLOCK) 
					  ON KC.DAYOFWEEK = 'THU' 
					 AND KC.ISO_YYYYWW = PD.ISO_YYYYWW
		WHERE 1=1
		  AND PD.DAYOFWEEK = 'MON' --- 당주 plan start date 대상 (월요일) 
		  AND PW.BASIS_YYYYMMDD BETWEEN @v_from_yyyymmdd AND @v_to_yyyymmdd


		print convert(varchar(30), getdate(), 121) + N'#GROUP_CODE_INFO 데이터 생성 시작' -----------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#GROUP_CODE_INFO') is not null 
		   DROP TABLE #GROUP_CODE_INFO;

		SELECT I.DIVISION_ID
			  ,I.ITEM_ID
			  ,ISNULL(MAX(I.DOE),I.ITEM_ID) AS GROUP_CODE
			  ,MAX(FI.GROUP_CODE1)			AS GROUP_CODE1
			  ,MAX(FI.GROUP_CODE2)			AS GROUP_CODE2
			  ,MAX(FI.GROUP_CODE3)			AS GROUP_CODE3
			  ,MAX(FI.GROUP_CODE4)			AS GROUP_CODE4
			  ,MAX(FI.GROUP_CODE5)			AS GROUP_CODE5
			  ,MAX(FI.OPERATION_GROUP)		AS OPERATION_GROUP
			  ,MAX(FI.CONVERT_QTY_CELL)		AS CONVERT_QTY_CELL
		  INTO #GROUP_CODE_INFO
		 FROM SCM_ITEM_M_SN I WITH(NOLOCK)
			  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
					  ON FI.DIVISION_ID		= I.DIVISION_ID
					 AND FI.ITEM_ID			= I.ITEM_ID 
		WHERE 1=1
		GROUP BY I.DIVISION_ID
				,I.ITEM_ID 

		print convert(varchar(30), getdate(), 121) + N'#LINE_INFO 데이터 생성 시작' -----------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#LINE_INFO') is not null 
		   DROP TABLE #LINE_INFO;

			SELECT LI.OPERATION_ID
				  ,LI.LINE_ID
				  ,MAX(LI.DESCRIPTION)	AS LINE_DESCRIPTION
				  ,MAX(LI.COMPANY_ID)	AS COMPANY_ID
				  ,MAX(LI.PLANT_ID)		AS PLANT_ID 
			 INTO #LINE_INFO
			 FROM SCM_MST_LINE_SN LI WITH(NOLOCK)
			WHERE ACTIVE_FLAG = 'Y'
			GROUP BY LI.OPERATION_ID
					,LI.LINE_ID

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'#MODEL_BOM_INFO 데이터 생성 시작';
        SET @v_description = N'';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;


		print convert(varchar(30), getdate(), 121) + N'#MODEL_BOM_INFO 데이터 생성 시작' ------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#MODEL_BOM_INFO') is not null 
		   DROP TABLE #MODEL_BOM_INFO;

		SELECT	B.DIVISION_ID
			  , B.MODEL_ID
			  , ROUND(AVG(B.ACCUMULATED_CHILD_QTY),1) AS ACCUMULATED_CHILD_QTY
		 INTO #MODEL_BOM_INFO
		 FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH (NOLOCK)
		WHERE 1=1
		  AND B.OPERATION_GROUP_ID = 'A'	
		GROUP BY B.DIVISION_ID
				,B.MODEL_ID


        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'#TEMP_TARGET_TO_MERGE 데이터 생성 시작';
        SET @v_description = N'';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;

		print convert(varchar(30), getdate(), 121) + N'#TEMP_TARGET_TO_MERGE 데이터 생성 시작' ------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TEMP_TARGET_TO_MERGE') is not null 
		   DROP TABLE #TEMP_TARGET_TO_MERGE;

		SELECT DI.TARGET_ST_DATE
			  ,DI.TARGET_WEEK
			  ,DI.PLAN_DATE
			  ,DI.TARGET_MONTH
			  ,DI.PARTIAL_START_DATE
			  ,DI.DAYOFWEEK
			  ,DI.PLAN_ST_DATE
			  ,DI.PLAN_WEEK
			  ,DI.KPI_MONTH
			  ,PR.DIVISION_ID
			  ,PR.ITEM_ID
			  ,PR.PLANT_ID
			  ,PR.FACTORY_ID
			  ,PR.LINE_ID
			  ,PR.OPERATION_ID
			  ,PR.PRODUCTION_TYPE 
			  ,SUM(ACTUAL_GOOD_QTY)  AS RESULT_QTY
		 INTO #TEMP_TARGET_TO_MERGE
		 FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN PR WITH(NOLOCK)
			  INNER JOIN #TEMP_DATE_INFO DI WITH(NOLOCK)
					  ON CONVERT(DATE, DI.PLAN_DATE, 120) = PR.PLAN_DATE 
		WHERE 1=1
		  AND PR.DIVISION_ID = '81'
		  AND PR.ACTUAL_GOOD_QTY > 0
		  AND (
				PR.OPERATION_ID IN (
								SELECT DISTINCT b.SEGMENT4
								FROM scm_adm_lookup_master_detail b WITH(NOLOCK)
								WHERE b.lookup_type = 'LOCATION_GROUP_ROUTE'
								AND b.valid_yn    = 'Y'
								AND b.segment3     = 'Y' -- Capa 세부 공정 여부
								)
				OR (
					PR.OPERATION_ID = 'P5000'
					AND EXISTS (
								SELECT 1
								FROM   #tmp_ISUZU
								WHERE  ITEM_ID = PR.ITEM_ID
					)
				)
			)
		GROUP BY DI.TARGET_ST_DATE
				,DI.TARGET_WEEK
				,DI.PLAN_DATE
				,DI.TARGET_MONTH
				,DI.PARTIAL_START_DATE
				,DI.DAYOFWEEK
				,DI.PLAN_ST_DATE
				,DI.PLAN_WEEK
				,DI.KPI_MONTH
				,PR.DIVISION_ID
				,PR.ITEM_ID
				,PR.PLANT_ID
				,PR.FACTORY_ID
				,PR.LINE_ID
				,PR.OPERATION_ID
				,PR.PRODUCTION_TYPE 
		;


        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'#TEMP_FINAL_TARGET_TO_MERGE 데이터 생성 시작';
        SET @v_description = N'';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;

		print convert(varchar(30), getdate(), 121) + N'#TEMP_FINAL_TARGET_TO_MERGE 데이터 생성 시작' ------------------------------------------------------------------------
		IF OBJECT_ID('tempdb..#TEMP_FINAL_TARGET_TO_MERGE') is not null 
		   DROP TABLE #TEMP_FINAL_TARGET_TO_MERGE;

		SELECT
			   TG.PLAN_WEEK
			  ,TG.PLAN_ST_DATE
			  ,TG.TARGET_WEEK
			  ,TG.TARGET_MONTH
			  ,TG.KPI_MONTH
			  ,TG.TARGET_ST_DATE
			  ,TG.PARTIAL_START_DATE
			  ,TG.PLAN_DATE
			  ,TG.DAYOFWEEK
			  ,TG.DIVISION_ID
			  ,GI.GROUP_CODE
			  ,TG.PRODUCTION_TYPE
			  ,CASE WHEN ISNULL(GI.GROUP_CODE2,'')= '' 
					THEN TG.ITEM_ID 
					ELSE GI.GROUP_CODE2 
				END 								AS  MODEL   -- 81 자동차 
			  ,DI.NICK_NAME 
			  ,TG.ITEM_ID
			  ,TG.PLANT_ID
			  ,TG.FACTORY_ID
			  ,CASE WHEN LI.COMPANY_ID IS NULL
					THEN 'Outsourcing'
					ELSE TG.LINE_ID
				END									AS LINE_ID 
			  ,CASE WHEN LI.COMPANY_ID IS NULL
					THEN 'Outsourcing'
					WHEN ISNULL(LI.LINE_DESCRIPTION, '') = ''
					THEN TG.LINE_ID
					ELSE LI.LINE_DESCRIPTION
				END									AS LINE_DESCRIPTION
			  ,TG.OPERATION_ID
			  ,OP.OPERATION_NAME
			  ,CASE WHEN GI.OPERATION_GROUP = 'E' -- 'Pouch용 전극' 일 경우 Cell 환산 적용 (자동차는 Pouch로 분류)
				    THEN GI.CONVERT_QTY_CELL * TG.RESULT_QTY
					ELSE TG.RESULT_QTY
				END									AS RESULT_QTY 
			  ,BI.ACCUMULATED_CHILD_QTY
			  ,CASE WHEN GI.OPERATION_GROUP = 'A' THEN 'Cell'
					WHEN GI.OPERATION_GROUP = 'E' THEN 'Elec'
					WHEN GI.OPERATION_GROUP = 'P' THEN 'Pack'
					ELSE GI.OPERATION_GROUP
			   END  AS OPERATION_GROUP 
			  ,CASE WHEN GI.OPERATION_GROUP = 'A' THEN 'Cell'
					WHEN GI.OPERATION_GROUP = 'E' THEN 'Elec'
					WHEN DI.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Module', DI.ITEM_CLASS_NAME) > 0 THEN 'Module'
					WHEN DI.FORECAST_INFO_BIZ_TYPE IS NULL AND CHARINDEX('Pack'  , DI.ITEM_CLASS_NAME) > 0 THEN 'Pack'
					ELSE DI.FORECAST_INFO_BIZ_TYPE
			   END  AS OPERATION_GROUP_DETAIL
			  ,NULL									AS  EXTRA_SPEC
			  ,DI.ENERGE							AS  ENERGY_KWH
			  ,'-'									AS  PRODUCT_GROUP
			  ,CASE WHEN LI.COMPANY_ID IS NULL
					THEN 'Outsourcing'
					ELSE LI.COMPANY_ID
				END									AS COMPANY_ID
			  ,CASE	WHEN LI.COMPANY_ID = 'C100'		THEN 'ESOC' 
	  				WHEN LI.COMPANY_ID = 'G180'		THEN 'ESNJ' 
	  				WHEN LI.COMPANY_ID = 'G380'		THEN (CASE WHEN LI.PLANT_ID = 'G388' THEN 'HZP' ELSE 'ESMI' END) 
	  				WHEN LI.COMPANY_ID = 'G450'		THEN 'ESNA'  
	  				WHEN LI.COMPANY_ID = 'G480'		THEN 'ESWA' 
	  				WHEN LI.COMPANY_ID = 'G630'		THEN 'ESNB'
					WHEN MS.OSP_YN     = 'Y'		THEN MS.SITE_DESCRIPTION -- 외주 
	  				ELSE TG.OPERATION_ID 
			   END									AS  PLANT_CODE
			  ,GI.GROUP_CODE1						AS  CELL_GROUP
			  ,GI.GROUP_CODE2						AS  PACK_GROUP
			  ,GI.GROUP_CODE3						AS  LEVEL2
			  ,GI.GROUP_CODE4						AS  LEVEL3
			  ,GI.GROUP_CODE5						AS  LEVEL4
		 INTO #TEMP_FINAL_TARGET_TO_MERGE
		 FROM #TEMP_TARGET_TO_MERGE TG WITH(NOLOCK)
			  INNER JOIN #GROUP_CODE_INFO GI WITH(NOLOCK)
					  ON GI.DIVISION_ID		= TG.DIVISION_ID
					 AND GI.ITEM_ID			= TG.ITEM_ID
			  LEFT JOIN DM_MST_ITEM_SINGLE_V DI WITH(NOLOCK)
					  ON DI.DIVISION_ID		= TG.DIVISION_ID
					 AND DI.ITEM_ID			= TG.ITEM_ID 
			  LEFT  JOIN SCM_MST_SITE MS WITH(NOLOCK)
					  ON MS.DIVISION_ID		= TG.DIVISION_ID
					 AND MS.PLANT_ID		= TG.PLANT_ID
					 AND MS.SITE_TYPE		= 'PLANT'
					 AND MS.OPERATION_GROUP = GI.OPERATION_GROUP 
			  LEFT  JOIN SCM_MST_OPERATION_SN OP WITH(NOLOCK)
					  ON OP.COMPANY_ID		= MS.COMPANY_ID
					 AND OP.DIVISION_ID		= MS.DIVISION_ID
					 AND OP.SITE_ID			= MS.SITE_ID
					 AND OP.OPERATION_ID	= TG.OPERATION_ID 
			  LEFT  JOIN #LINE_INFO LI WITH(NOLOCK)
					  ON LI.OPERATION_ID	= TG.OPERATION_ID
					 AND LI.LINE_ID			= TG.LINE_ID
			  LEFT  JOIN #MODEL_BOM_INFO BI WITH(NOLOCK)
					  ON BI.DIVISION_ID		= TG.DIVISION_ID
					 AND BI.MODEL_ID		= TG.ITEM_ID
		WHERE 1=1 
		;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @v_log_message = N'MERGE INTO SCP_BI_FP_RESULT_DAILY -- Start ';
        SET @v_description = N'';
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                  ,@p_log_type      = @v_log_type
                                  ,@p_log_count     = @n_log_count
                                  ,@p_log_message   = @v_log_message
                                  ,@p_description   = @v_description
                                  ,@p_event_date    = @d_event_date
                                  ,@p_user_id       = @v_batch_user
                                  ;

		print convert(varchar(30), getdate(), 121) + N'MERGE INTO SCP_BI_FP_RESULT_DAILY ' ------------------------------------------------------------------------
		MERGE INTO SCP_BI_FP_RESULT_DAILY TGT 
		USING (
				SELECT *
				  FROM #TEMP_FINAL_TARGET_TO_MERGE
			  ) AS SRC
		  ON TGT.DIVISION_ID		= SRC.DIVISION_ID	
		 AND TGT.PLAN_DATE			= SRC.PLAN_DATE		
		 AND TGT.ITEM_ID			= SRC.ITEM_ID		
		 AND TGT.PLANT_ID			= SRC.PLANT_ID		
		 AND TGT.FACTORY_ID			= SRC.FACTORY_ID		
		 AND TGT.LINE_ID			= SRC.LINE_ID		
		 AND TGT.OPERATION_ID		= SRC.OPERATION_ID	
		 AND TGT.PRODUCTION_TYPE 	= SRC.PRODUCTION_TYPE

		WHEN MATCHED THEN
			  UPDATE SET TGT.RESULT_QTY			= CASE WHEN TGT.RESULT_QTY != SRC.RESULT_QTY -- 수량이 다른 경우만  
													   THEN SRC.RESULT_QTY
													   ELSE TGT.RESULT_QTY
												  END 
						,TGT.LAST_UPDATED_BY	= CASE WHEN TGT.RESULT_QTY != SRC.RESULT_QTY -- 수량이 다른 경우만  
													   THEN 'scp_batch_merge_update'
													   ELSE TGT.LAST_UPDATED_BY
												  END 
						,TGT.LAST_UPDATE_DATE	= CASE WHEN TGT.RESULT_QTY != SRC.RESULT_QTY -- 수량이 다른 경우만  
													   THEN GETDATE()
													   ELSE TGT.LAST_UPDATE_DATE
												  END 
						,TGT.ATTRIBUTE10		= CASE WHEN TGT.RESULT_QTY != SRC.RESULT_QTY -- 수량이 다른 경우만  
													   THEN 'BEFORE QTY : ' + CONVERT(NVARCHAR, TGT.RESULT_QTY)
													   ELSE TGT.ATTRIBUTE10
												  END
		WHEN NOT MATCHED THEN
			  INSERT (
					  PLAN_WEEK
					 ,PLAN_ST_DATE
					 ,TARGET_WEEK
					 ,TARGET_MONTH
					 ,KPI_MONTH
					 ,TARGET_ST_DATE
					 ,PARTIAL_START_DATE
					 ,PLAN_DATE
					 ,DAYOFWEEK
					 ,DIVISION_ID
					 ,GROUP_CODE
					 ,PRODUCTION_TYPE
					 ,MODEL
					 ,NICK_NAME
					 ,ITEM_ID
					 ,PLANT_ID
					 ,FACTORY_ID
					 ,LINE_ID
					 ,LINE_DESCRIPTION
					 ,OPERATION_ID
					 ,OPERATION_NAME
					 ,SCP_TE_QTY
					 ,SCP_PR_QTY
					 ,SCP_MA_QTY
					 ,SCP_FN_QTY
					 ,FP_V_QTY
					 ,FP_DPP_QTY
					 ,FP_WPP_QTY
					 ,FP_SUN_WPP_QTY
					 ,FP_MPP_QTY
					 ,RESULT_QTY
					 ,ACCUMULATED_CHILD_QTY
					 ,OPERATION_GROUP
					 ,OPERATION_GROUP_DETAIL
					 ,EXTRA_SPEC
					 ,ENERGY_KWH
					 ,PRODUCT_GROUP
					 ,COMPANY_ID
					 ,PLANT_CODE
					 ,CELL_GROUP
					 ,PACK_GROUP
					 ,LEVEL2
					 ,LEVEL3
					 ,LEVEL4
					 ,CREATED_BY
					 ,CREATION_DATE
					 ,LAST_UPDATED_BY
					 ,LAST_UPDATE_DATE
			 )
			  VALUES (
					  SRC.PLAN_WEEK
					 ,SRC.PLAN_ST_DATE
					 ,SRC.TARGET_WEEK
					 ,SRC.TARGET_MONTH
					 ,SRC.KPI_MONTH
					 ,SRC.TARGET_ST_DATE
					 ,SRC.PARTIAL_START_DATE
					 ,SRC.PLAN_DATE
					 ,SRC.DAYOFWEEK
					 ,SRC.DIVISION_ID
					 ,SRC.GROUP_CODE
					 ,SRC.PRODUCTION_TYPE
					 ,SRC.MODEL
					 ,SRC.NICK_NAME
					 ,SRC.ITEM_ID
					 ,SRC.PLANT_ID
					 ,SRC.FACTORY_ID
					 ,SRC.LINE_ID
					 ,SRC.LINE_DESCRIPTION
					 ,SRC.OPERATION_ID
					 ,SRC.OPERATION_NAME
					 ,0  -- SCP_TE_QTY
					 ,0  -- SCP_PR_QTY
					 ,0  -- SCP_MA_QTY
					 ,0  -- SCP_FN_QTY
					 ,0  -- FP_V_QTY
					 ,0  -- FP_DPP_QTY
					 ,0  -- FP_WPP_QTY
					 ,0  -- FP_SUN_WPP_QTY
					 ,0  -- FP_MPP_QTY
					 ,SRC.RESULT_QTY
					 ,SRC.ACCUMULATED_CHILD_QTY
					 ,SRC.OPERATION_GROUP
					 ,SRC.OPERATION_GROUP_DETAIL
					 ,SRC.EXTRA_SPEC
					 ,SRC.ENERGY_KWH
					 ,SRC.PRODUCT_GROUP
					 ,SRC.COMPANY_ID
					 ,SRC.PLANT_CODE
					 ,SRC.CELL_GROUP
					 ,SRC.PACK_GROUP
					 ,SRC.LEVEL2
					 ,SRC.LEVEL3
					 ,SRC.LEVEL4
					 ,'scp_batch_merge_insert'	-- CREATED_BY
					 ,GETDATE()					-- CREATION_DATE
					 ,'scp_batch_merge_insert'  -- LAST_UPDATED_BY
					 ,GETDATE()					-- LAST_UPDATE_DATE
			  )
		;
		---------------------------------------------------------------------------------------------------------------
		-- End PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 자동차(81) FP 실적 UPDATE 쿼리 변경 (-1주~-4주) 
		---------------------------------------------------------------------------------------------------------------


	    IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
        BEGIN
            DROP TABLE #tmp_ISUZU;
        END
	  
      END;

    END TRY

    BEGIN CATCH

      IF @@TRANCOUNT > 0
        BEGIN
          ROLLBACK;
        END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                                ,@p_log_type      = @v_log_type
                                ,@p_log_count     = @n_log_count
                                ,@p_log_message   = @v_log_message
                                ,@p_description   = @v_description
                                ,@p_event_date    = @d_event_date
                                ,@p_user_id       = @v_batch_user
                                ;

      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count
                              ,@p_log_message   =@v_log_message
                              ,@p_description   =@v_description
                              ,@p_event_date    =@d_event_date
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1


  END;

