/*
 * Program ID   : SCP0054
 * Description  : CAPA SIMULATION
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/04/05   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 최초작성
 * 2021/04/21   khj79          [PJ20209642] Production CAPA(MAX) , Production CAPA(MIN) 추가
 * 2021/07/08   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BEST , WORST 수정
 * 2021/07/27   khj79          [PJ20214907] LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 CAPA ( SCP Planner 만 조회)
 * 2021/12/21   khj79          이력 테이블(HIST) 조회
 * 2022/11/09   lgda106        조회 속도개선
 
ex>	DECLARE @p_from_yyyymm			NVARCHAR(6) = '202104'
	,@p_to_yyyymm			NVARCHAR(6) = '202204'
	,@p_division_id			NVARCHAR(20) = '81'
	,@p_group				NVARCHAR(1) = ''
	,@p_plant_id			NVARCHAR(MAX) = ''
	,@p_factory_id			NVARCHAR(MAX) = ''
	,@p_version_id			NVARCHAR(20) = '202111_001'
	,@p_line_id				NVARCHAR(MAX) = 'A1A04'
	,@p_user_id				NVARCHAR(30) = 'khj79'
	,@p_user_auth			NVARCHAR(30) = 'SCM PI Admin'
	,@p_plan_start_yyyymmdd	NVARCHAR(8) = '20210405'
	,@p_plan_type			NVARCHAR(2) = 'MA'
	,@p_plan_seq			NVARCHAR(2) = '1'
	,@debug_mode			CHAR(1) = 'T'
 */



CREATE PROCEDURE [dbo].[SCP0054_GET_CAPA_SIMULATION]
	 @p_from_yyyymm			NVARCHAR(6)
	,@p_to_yyyymm			NVARCHAR(6)
	,@p_division_id			NVARCHAR(20)
	,@p_group				NVARCHAR(MAX)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_factory_id			NVARCHAR(MAX)
	,@p_version_id			NVARCHAR(20)
	,@p_line_id				NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(30)
	,@p_user_auth			NVARCHAR(30)
	,@p_plan_start_yyyymmdd	NVARCHAR(8)
	,@p_plan_type			NVARCHAR(2)
	,@p_plan_seq			NVARCHAR(2)
	,@debug_mode			CHAR(1)
AS
-----------------------backup start 
--declare
-- @p_from_yyyymm			NVARCHAR(6)='202203'	
-- ,@p_to_yyyymm			NVARCHAR(6)='202309'	
-- ,@p_division_id			NVARCHAR(20)='81'	
-- ,@p_group				NVARCHAR(MAX)='A,E,F,P'	
-- ,@p_plant_id			NVARCHAR(MAX)='A040,A041,G382,G383,G388,G451,G452,G481,G482,G631,G632'	
-- ,@p_factory_id			NVARCHAR(MAX)='A1,A2,A3,A4,A5,A6,A7,A8,A9,AA,AC,E5,E6,E9,EA,EB,EC,ED,EF,EG,EJ,P1,P2,P4,P5,P6,P7,P8,P9,PA,PB,PC'	
-- ,@p_version_id			NVARCHAR(20)='202233_005'	
-- ,@p_line_id				NVARCHAR(MAX)='A1A02,A1A02-1,A1A02-2,A1A03,A1A04,A1A05,A1A06,A1A07,A1A08,A1AP1,A1AP2,A1AV1,A2A10,A2A11,A2A13,A2A14,A2AP3,A2AP4,A2AV1,A3A01,A3A02,A3A03,A3A04,A3A05,A3A06,A3A07,A3AV1,A4A01,A4A02,A4A03,A4A04,A4A05,A4AV1,A5A01,A5A02,A5A03,A5AV1,A6A04,A6A05,A6A06,A6A07,A6A25,A6AV2,A7A08,A7A09,A7A10,A7A11,A7A12,A7A13,A7A14,A7A15,A7A16,A7A17,A7A18,A7A19,A7A20,A7A21,A7A22,A7A23,A7A24,A7AH1,A7AH2,A7AR1,A7AV3,A8A03,A8A04,A8A05,A8AA1,A8AA2,A8AB1,A8AB2,A8AF1,A8AF2,A8AH1,A8AH2,A8AH3,A8AL1,A9A01,A9AP5,A9AV1,AAA10,AAA11,AAA12,AAAH1,aarty,ACA26,ACA27,ACA28,E5D01,E5DP1,E6D01,E9D01,EAD01,EBD01,ECD01,EDD01,EFD01,EGDP1,EJD01,FP_A3A07_1,FP_A3A07_2,FP_E5M01_A,FP_E5M01_C,FP_E5M02_A,FP_E5M02_C,FP_E6M01_A,FP_E6M01_C,FP_E6M02_A,FP_E6M02_C,FP_E9M01_A,FP_E9M01_C,FP_E9M02_A,FP_E9M02_C,FP_EAM01_A,FP_EAM01_C,FP_EAM02_A,FP_EAM02_C,FP_EAM03_A,FP_EAM03_C,FP_EBM01_A,FP_EBM01_C,FP_EBM02_A,FP_EBM02_C,FP_EBR01_A,FP_EBR01-1_C,FP_EBR01-2_C,FP_EBR02_A,FP_EBR02-1_C,FP_EBR02-2_C,FP_EBS01_A,FP_EBS01_C,FP_EBS02_A,FP_EBS02_C,FP_EBS03_A,FP_EBS03_C,FP_EBS04_A,FP_EBS04_C,FP_ECM01_A,FP_ECM01_C,FP_ECM02_A,FP_ECM02_C,FP_ECM03_A,FP_ECM03_C,FP_EDM03_A,FP_EDM03_C,FP_EDM04_A,FP_EDM04_C,FP_EDM05_A,FP_EDM05_C,FP_EDM06_A,FP_EDM06_C,FP_EDM07_A,FP_EDM07_C,FP_EDR03-1_A,FP_EDR03-1_C,FP_EDR03-2_C,FP_EDR03-3_C,FP_EDR04-1_A,FP_EDR04-1_C,FP_EDR04-2_A,FP_EDR04-2_C,FP_EDR04-3_C,FP_EDR05-1_A,FP_EDR05-1_C,FP_EDR05-2_A,FP_EDR05-2_C,FP_EDR05-3_C,FP_EDR06-1_A,FP_EDR06-1_C,FP_EDR06-2_A,FP_EDR06-2_C,FP_EDR06-3_C,FP_EDR07-1_A,FP_EDR07-1_C,FP_EDR07-2_C,FP_EDR07-3_C,FP_EDS03-1_A,FP_EDS03-1_C,FP_EDS03-2_C,FP_EDS03-3_C,FP_EDS04-1_A,FP_EDS04-1_C,FP_EDS04-2_A,FP_EDS04-2_C,FP_EDS04-3_C,FP_EDS05-1_A,FP_EDS05-1_C,FP_EDS06-1_A,FP_EDS06-1_C,FP_EDS06-2_A,FP_EDS06-2_C,FP_EDS06-3_C,FP_EDS06-4_C,FP_EDS07-1_C,FP_EDSH5-1_A,FP_EDSH6-1_A,FP_EDSH6-2_A,FP_EDSH7-1_A,FP_EDSH7-2_A,FP_EDSH7-3_A,FP_EFM04_A,FP_EFM04_C,FP_EGM01_A,FP_EGM01_C,FP_EJM08_A,FP_EJM08_C,FP_EJM09_A,FP_EJM09_C,FP_EJM10_A,FP_EJM10_C,P1QP1,P1QP2,P1QP3,P1QP4,P2Q02,P2Q11,P4Q08,P4Q09,P4Q10,P5Q01,P5Q02,P5Q03,P5Q04,P6Q03,P6Q08,P6Q09,P6Q10,P6Q12,P6Q13,P7Q01,P7Q02,P7Q03,P7Q04,P7Q05,P7Q06,P7Q07,P7Q08,P7Q09,P7Q10,P7Q11,P7Q12,P7Q13,P7Q14,P7Q15,P7Q16,P7Q17,P7Q18,P7Q19,P7Q20,P7Q21,P7Q23,P8Q01,P8Q02,P8Q03,P8Q04,P8Q05,P8Q06,P8Q07,P8Q08,P8Q09,P8Q10,P8Q11,P8Q12,P8Q13,P8Q14,P8Q15,P8Q16,P8Q17,P8Q18,P8Q19,P8Q20,P8Q21,P8Q22,P8Q24,P8Q25,P8Q26,P8Q27,P8Q28,P8Q29,P8Q30,P8Q31,PAQ01,PAQ02,PAQ03,PAQ04,PBQ01,PBQ02,PBQ03,PCQ01'	
-- ,@p_user_id				NVARCHAR(30)='lgda106'	
-- ,@p_user_auth			NVARCHAR(30)='ADMIN'	
-- ,@p_plan_start_yyyymmdd	NVARCHAR(8)='20220815'	
-- ,@p_plan_type			NVARCHAR(2)='FN'	
-- ,@p_plan_seq			NVARCHAR(2)='1'	
-- ,@debug_mode			CHAR(1)='F'	

BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- 쿼리 실행용 변수 설정
	DECLARE @MEXEC		NVARCHAR(MAX);
	DECLARE @MEXEC2		NVARCHAR(MAX);
	DECLARE @MQRY_SUM	NVARCHAR(MAX);

	-- 날짜 조건용 변수 설정
	DECLARE @v_start_month		NVARCHAR(6);	--시작 월(현재월 +1 년)
	DECLARE @v_end_month		NVARCHAR(6);	--마지막 월
	DECLARE @v_start_avg		NVARCHAR(6);	--시작 월(현재월 -3 개월)
	DECLARE @v_end_avg			NVARCHAR(6);	--마지막 월
	DECLARE @v_start_rlt_month	NVARCHAR(6);	-- 실적 시작 월
	DECLARE @v_end_rlt_month	NVARCHAR(6);	-- 실적 종료 월
	DECLARE @v_start_rlt_day	NVARCHAR(8);	-- 실적 시작 일자
	DECLARE @v_end_rlt_day		NVARCHAR(8);	-- 실적 종료 일자
	DECLARE @v_start_prod_day	NVARCHAR(8);	-- 계획 시작 일자
	DECLARE @v_end_prd_day		NVARCHAR(8);	-- 계획 종료 일자
	
	-- 평균 계산용 변수 설정
	DECLARE @v_bef_m6_count		INT;  -- 현재월 -6 해당월의 날짜 수
	DECLARE @v_bef_m5_count		INT;  -- 현재월 -5 해당월의 날짜 수
	DECLARE @v_bef_m4_count		INT;  -- 현재월 -4 해당월의 날짜 수
	DECLARE @v_bef_m3_count		INT;  -- 현재월 -3 해당월의 날짜 수
	DECLARE @v_bef_m2_count		INT;  -- 현재월 -2 해당월의 날짜 수
	DECLARE @v_bef_m1_count		INT;  -- 현재월 -1 해당월의 날짜 수
	DECLARE @v_bef_max_count	INT;  -- 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 큰 값(BEST,WORST)
	DECLARE @v_bef_min_count	INT;  -- 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 작은 값(BEST,WORST)

	----------- 과거 이력(HIST) 테이블을 조회하기 위한 변수 설정
	DECLARE @v_start_result_avg	NVARCHAR(6);	--과거 시작 월(과거 테이블 조회)
	DECLARE @v_end_result_avg	NVARCHAR(6);	--과거 마지막 월(과거 테이블 조회)
	DECLARE @v_result_month		INT = 2;		--과거 데이터 조회 월	

	DECLARE @v_result_table_month NVARCHAR(8) = CONVERT(VARCHAR(8) , DATEADD(MM, -@v_result_month  ,GETDATE()),112); -- 이력 테이블 조회 기준 월

	-- 실적(과거) , 계획(미래) 일자 설정
	SET @v_start_rlt_day	= LEFT(@p_plan_start_yyyymmdd, 6) + '01';
	SET @v_end_rlt_day		= CONVERT(NVARCHAR(8),DATEADD(DD,-1 , @p_plan_start_yyyymmdd),112);
	SET @v_start_prod_day	= @p_plan_start_yyyymmdd;
	-- 평균 일자(현재일 이전 3개월 데이터) 설정
	--SET @v_start_avg	= @p_from_yyyymm;
	--SET @v_end_avg		= CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_plan_start_yyyymmdd),112); -- 현재일 -1 개월 이전 월(EX> 20200721 => 202006 )

	-- 과거 조회 일자 설정
	IF @p_from_yyyymm < @v_result_table_month
		BEGIN
			-- 이력 테이블 조회
			SET @v_start_result_avg = @p_from_yyyymm;
			SET @v_end_result_avg	= @v_result_table_month
			SET @v_start_avg	= CONVERT(VARCHAR(6) , DATEADD(MM,1 ,@v_result_table_month),112) ; -- 현재월 -1@v_result_table_month
			SET @v_end_avg		= CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_plan_start_yyyymmdd),112); -- 현재일 -1 개월 이전 월(EX> 20200721 => 202006 )
		END
	ELSE
		BEGIN
			-- 이력 테이블 조회 하지 않는다.
			SET @v_start_result_avg = @p_to_yyyymm;
			SET @v_end_result_avg	= @p_from_yyyymm;
			SET @v_start_avg		= @p_from_yyyymm;  -- 조회 시작 월
			SET @v_end_avg			= CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_plan_start_yyyymmdd),112); -- 현재일 -1 개월 이전 월(EX> 20200721 => 202006 )
		END


	DECLARE @v_bef_m6_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-6 ,GETDATE()),112);
	DECLARE @v_bef_m5_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-5 ,GETDATE()),112);
	DECLARE @v_bef_m4_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-4 ,GETDATE()),112);
	DECLARE @v_bef_m3_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-3 ,GETDATE()),112);
	DECLARE @v_bef_m2_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-2 ,GETDATE()),112);
	DECLARE @v_bef_m1_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,GETDATE()),112);
	
	-- 해당 월에 마지막일자(날짜 수 )를 구한다(평균데이터를 구하는 곳 사용)
	SELECT @v_bef_m6_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-6 ,GETDATE()),112);

	SELECT @v_bef_m5_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-5 ,GETDATE()),112);

	SELECT @v_bef_m4_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-4 ,GETDATE()),112);

	SELECT @v_bef_m3_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-3 ,GETDATE()),112);

	SELECT @v_bef_m2_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-2 ,GETDATE()),112);

	SELECT @v_bef_m1_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,GETDATE()),112);

	-- ////////////////////////////////////////////////////////////////
	-- 날짜 설정
	-- ////////////////////////////////////////////////////////////////
	DECLARE @v_max_day NVARCHAR(8) = CONVERT(NVARCHAR(4),DATEADD(YY,1, @p_plan_start_yyyymmdd ),112) + '1231'; -- 기준일 Y+1 까지만 조회 가능

	BEGIN
		SET @v_start_month	= LEFT(@p_plan_start_yyyymmdd, 6);
		SET @v_end_month	= @p_to_yyyymm;
	END

	SELECT @v_bef_max_count = MAX(CALENDAR_DAY)
	     , @v_bef_min_count = MIN(CALENDAR_DAY)
      FROM (
			SELECT BASIS_YYYYMM , CONVERT(INT,MAX(CALENDAR_DAY)) CALENDAR_DAY
			  FROM SCM_SYS_CALENDAR_M
			 WHERE BASIS_YYYYMM >= @p_from_yyyymm  -- 조회 시작 월
			   AND BASIS_YYYYMM <= @v_end_avg
			 GROUP BY BASIS_YYYYMM
			) A ;
	
	-- 날짜 확인
	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT '@v_start_rlt_day		=' +@v_start_rlt_day;
		PRINT '@v_end_rlt_day		=' +@v_end_rlt_day;
		PRINT '@v_start_prod_day	=' +@v_start_prod_day;
		PRINT '----------------------------------';
		PRINT '@v_start_month		=' +@v_start_month;
		PRINT '@v_end_month			=' +@v_end_month;
		PRINT '----------------------------------';
		PRINT '@v_start_avg			=' +@v_start_avg;
		PRINT '@v_end_avg			=' +@v_end_avg;
		PRINT '----------------------------------';
		PRINT '@v_bef_m6_yyyymm		=' +@v_bef_m6_yyyymm;
		PRINT '@v_bef_m5_yyyymm		=' +@v_bef_m5_yyyymm;
		PRINT '@v_bef_m4_yyyymm		=' +@v_bef_m4_yyyymm;
		PRINT '@v_bef_m3_yyyymm		=' +@v_bef_m3_yyyymm;
		PRINT '@v_bef_m2_yyyymm		=' +@v_bef_m2_yyyymm;
		PRINT '@v_bef_m1_yyyymm		=' +@v_bef_m1_yyyymm;
		PRINT '----------------------------------';
	END;

	-- 버전별 division, op group 설정
	DECLARE @v_ver_division_id	NVARCHAR(20);
	DECLARE @v_ver_group		NVARCHAR(MAX);
	
	BEGIN
		SELECT 	  @v_ver_division_id = CASE WHEN @p_version_id = 'Current' THEN NULL ELSE B.ATTRIBUTE1 END
				, @v_ver_group   	 = CASE WHEN @p_version_id = 'Current' THEN NULL ELSE B.ATTRIBUTE2 END
		  FROM 	SCM_MASTER_VERSION_INFO_H_SN A WITH(NOLOCK),
				SCM_SYS_LOOKUP_VALUE_SN B  WITH(NOLOCK)
		 WHERE 	1=1		
		   AND 	LOOKUP_TYPE_CODE = 'MASTER_DATA_DIVISION_SYSTEM'
		   AND 	A.DIVISION_ID 	= B.SEGMENT2
		   AND 	A.VERSION_ID 	= @p_version_id
	END	

	-- LOSS LOOKUP 정보 조회( PRODUCTION 계산 LOSS 추가)
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0054_LOOKUP') IS NOT NULL
			DROP TABLE #TMP_SCP0054_LOOKUP;
		
		SELECT SEGMENT1		AS LOSS_CODE
			 , ATTRIBUTE1	AS CATEGORY_ID
			 , ATTRIBUTE2	AS KEY_ID
			 , ATTRIBUTE3	AS DATA_TABLE
			 , CONVERT(NUMERIC(20,10),ATTRIBUTE8) AS CATEGORY_ORDER
			 , SORT_ORDER
			 , ATTRIBUTE9	AS UOM
		 INTO #TMP_SCP0054_LOOKUP
		 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
		WHERE 1=1
		  AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
		  AND ACTIVE_FLAG = 'Y'
		  AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('Admin','SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- PJ20214907 : 형교환 CAPA 권한 사용자만 조회

		------------------------------------------------------------
		UNION ALL
		SELECT 'XP001'						AS LOSS_CODE
			 , 'Production Plan'			AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1111							AS SOR_ORDER
			 , ''							AS UOM
		 UNION ALL
		SELECT 'XP002'						AS LOSS_CODE
			 , 'Production Plan'			AS CATEGORY_ID
			 , 'TOTAL'						AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1112							AS SOR_ORDER
			 , ''							AS UOM
		UNION ALL
		SELECT 'XP003'						AS LOSS_CODE
			 , 'Model Mix(%)'				AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1113							AS SOR_ORDER
			 , ''							AS UOM
		  UNION ALL
		SELECT 'XP004'						AS LOSS_CODE
			 , 'Mixed TACT TIME'			AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 130							AS CATEGORY_ORDER
			 , 1302							AS SOR_ORDER
			 , ''							AS UOM
		 UNION ALL
		SELECT 'XP005'						AS LOSS_CODE
			 , 'Mixed YIELD'				AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 140							AS CATEGORY_ORDER
			 , 1402							AS SOR_ORDER
			 , ''							AS UOM
		 UNION ALL
		SELECT 'XP006'						AS LOSS_CODE
			 , N'Production CAPA'			AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1102							AS SOR_ORDER
			 , ''							AS UOM
		 UNION ALL
		SELECT 'XP007'						AS LOSS_CODE
			 , N'Production CAPA(In)'		AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1103							AS SOR_ORDER
			 , ''							AS UOM
		  UNION ALL
		SELECT 'XP008'						AS LOSS_CODE
			 , 'Production CAPA(MAX)'			AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1104							AS SOR_ORDER
			 , ''							AS UOM
		 UNION ALL
		SELECT 'XP009'						AS LOSS_CODE
			 , 'Production CAPA(MIN)'		AS CATEGORY_ID
			 , ''							AS KEY_ID
			 , 'SCP_ANL_PRODUCTION_PLAN'	AS DATA_TABLE
			 , 110							AS CATEGORY_ORDER
			 , 1105							AS SOR_ORDER
			 , ''							AS UOM
	END


	/*SQL 수정*/
    CREATE CLUSTERED INDEX [CL01_#TMP_SCP0054_LOOKUP] ON [#TMP_SCP0054_LOOKUP] (LOSS_CODE)
	-- ///////////////////////////////////////////////////////////////////////////////////
	-- 기준 테이블 생성
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0054_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0054_STD;

		SELECT DISTINCT
			   DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , SITE_NAME
			 , PLANT_ID
			 , A.OPERATION_GROUP_ID
			 , OPERATION_GROUP AS OPERATION_GROUP_NAME 
			 , FACTORY_ID
			 , FACTORY_NAME
			 , A.OPERATION_ID
			 , OPERATION_NAME
			 , LINE_ID
			 , LINE_NAME
			 , ELECTRODE_TYPE
		  INTO #TMP_SCP0054_STD 
		  FROM SCM_LINE_HIERARCHY_V_SN A
		  JOIN (SELECT SEGMENT1 AS OPERATION_GROUP_ID
					 , SEGMENT2 AS OPERATION_ID
				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				 WHERE LOOKUP_TYPE_CODE = 'CAPA_SIMUL_OP'
				   AND ACTIVE_FLAG = 'Y'
				) LK
			ON A.OPERATION_ID = LK.OPERATION_ID
		 WHERE 1=1
		   AND (( @p_division_id		IS NULL OR @p_division_id		='') OR A.DIVISION_ID  			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
		   AND (( @p_plant_id			IS NULL OR @p_plant_id			='') OR A.PLANT_ID     			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id			, ',')))
		   AND (( @p_factory_id			IS NULL OR @p_factory_id		='') OR A.FACTORY_ID   			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_factory_id		, ',')))
		   AND (( @p_line_id			IS NULL OR @p_line_id			='') OR A.LINE_ID      			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_line_id			, ',')))
		   AND (( @p_group				IS NULL OR @p_group				='') OR A.OPERATION_GROUP_ID    IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_group				, ',')))
		   AND (( @v_ver_division_id	IS NULL OR @v_ver_division_id	='') OR A.DIVISION_ID  			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_division_id	, ',')))		   
		   AND (( @v_ver_group			IS NULL OR @v_ver_group			='') OR A.OPERATION_GROUP_ID    IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_group			, ',')))
		   --AND A.OPERATION_ID IN ( 'A9000')

	END
	
	-- ///////////////////////////////////////////////////////////////////////////////////
	-- 테이블 생성
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN

	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_MM') IS NOT NULL
		DROP TABLE #TMP_SCP0054_MM;

	CREATE TABLE #TMP_SCP0054_MM
	(	
		COMPANY_ID			NVARCHAR(030)
	  , DIVISION_ID			NVARCHAR(030)
	  , SITE_ID				NVARCHAR(030)
	  , PLANT_ID			NVARCHAR(030)
	  , FACTORY_ID			NVARCHAR(030)
	  , OPERATION_ID		NVARCHAR(030)
	  , LINE_ID				NVARCHAR(030)
	  , ELECTRODE_TYPE		NVARCHAR(030)
	  , LOSS_CODE			NVARCHAR(030)
	  , YYYYMMDD			NVARCHAR(008)
	  , YYYYMM				NVARCHAR(006)
	  , YYYY				NVARCHAR(004)
	  , ITEM_VALUE			NUMERIC(20,6)
	 )


	-- 3개월 평균 값 저장 (loss(CALENDAR , LOSS)  ,  tact , yeild)

	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_AVG_DATA') IS NOT NULL
		DROP TABLE #TMP_SCP0054_AVG_DATA;

	CREATE TABLE #TMP_SCP0054_AVG_DATA
	(
		  COMPANY_ID			NVARCHAR(030)
		, DIVISION_ID			NVARCHAR(030)
		, SITE_ID				NVARCHAR(030)
		, PLANT_ID				NVARCHAR(030)
		, FACTORY_ID			NVARCHAR(030)
		, OPERATION_ID			NVARCHAR(030)
		, LINE_ID				NVARCHAR(030)
		, ELECTRODE_TYPE		NVARCHAR(030)
		, LOSS_CODE				NVARCHAR(030)
		, ITEM_ID				NVARCHAR(030)
		, LANE_QTY				INT
		, YYYYMM				NVARCHAR(006)
		, ITEM_VALUE_RESULT		NUMERIC(10,3)
	)
	
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_AVG') IS NOT NULL
		DROP TABLE #TMP_SCP0054_AVG;

	CREATE TABLE #TMP_SCP0054_AVG
	(
		  COMPANY_ID			NVARCHAR(030)
		, DIVISION_ID			NVARCHAR(030)
		, SITE_ID				NVARCHAR(030)
		, PLANT_ID				NVARCHAR(030)
		, FACTORY_ID			NVARCHAR(030)
		, OPERATION_ID			NVARCHAR(030)
		, LINE_ID				NVARCHAR(030)
		, ELECTRODE_TYPE		NVARCHAR(030)
		, LOSS_CODE				NVARCHAR(030)
		, ITEM_ID				NVARCHAR(030)
		, LANE_QTY				INT
		, BEF_M6_RESULT			NUMERIC(10,3)
		, BEF_M5_RESULT			NUMERIC(10,3)
		, BEF_M4_RESULT			NUMERIC(10,3)
		, BEF_M3_RESULT			NUMERIC(10,3)
		, BEF_M2_RESULT			NUMERIC(10,3)
		, BEF_M1_RESULT			NUMERIC(10,3)
	)

	-- ////////////////////////////////////////
	-- 과거 테이블 중 최대값 최소 값을 저장한다
	-- LOSS 는 최소값이 BEST
	-- DAILY CAPA , YIELD 는 최대값이 BEST
	-- ////////////////////////////////////////
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_AVG_MIN_MAX') IS NOT NULL
		DROP TABLE #TMP_SCP0054_AVG_MIN_MAX;

	CREATE TABLE #TMP_SCP0054_AVG_MIN_MAX
	(
		  COMPANY_ID			NVARCHAR(030)
		, DIVISION_ID			NVARCHAR(030)
		, SITE_ID				NVARCHAR(030)
		, PLANT_ID				NVARCHAR(030)
		, FACTORY_ID			NVARCHAR(030)
		, OPERATION_ID			NVARCHAR(030)
		, LINE_ID				NVARCHAR(030)
		, ELECTRODE_TYPE		NVARCHAR(030)
		, LOSS_CODE				NVARCHAR(030)
		, ITEM_ID				NVARCHAR(030)
		, LANE_QTY				INT
		, BEF_BEST_RESULT		NUMERIC(10,3)
		, BEF_WORST_RESULT		NUMERIC(10,3)
	)

	-- STD(기준) 테이블 기준으로 loss 저장
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_ADD_STD') IS NOT NULL
		DROP TABLE #TMP_SCP0054_ADD_STD;
	
	CREATE TABLE #TMP_SCP0054_ADD_STD
	(
		  DIVISION_ID		NVARCHAR(030)
		, COMPANY_ID		NVARCHAR(030)
		, SITE_ID			NVARCHAR(030)
		, PLANT_ID			NVARCHAR(030)
		, FACTORY_ID		NVARCHAR(030)
		, LINE_ID			NVARCHAR(030)
		, ELECTRODE_TYPE	NVARCHAR(030)
		, OPERATION_ID		NVARCHAR(030)
		, LOSS_CODE			NVARCHAR(030)
		, ITEM_ID			NVARCHAR(030)
		, LANE_QTY			INT
		, YYYYMMDD			NVARCHAR(008)
		, YYYYMM			NVARCHAR(006)
		, YYYY				NVARCHAR(004)
		, ITEM_VALUE		NUMERIC(10,4)
	)

	-- tact , yield 저장
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_LTY') IS NOT NULL
		DROP TABLE #TMP_SCP0054_LTY;
				
	CREATE TABLE #TMP_SCP0054_LTY
	(
		  DIVISION_ID		NVARCHAR(030)
		, COMPANY_ID		NVARCHAR(030)
		, SITE_ID			NVARCHAR(030)
		, PLANT_ID			NVARCHAR(030)
		, FACTORY_ID		NVARCHAR(030)
		, LINE_ID			NVARCHAR(030)
		, ELECTRODE_TYPE	NVARCHAR(030)
		, OPERATION_ID		NVARCHAR(030)
		, LOSS_CODE			NVARCHAR(030)
		, ITEM_ID			NVARCHAR(030)
		, LANE_QTY			INT
		, YYYYMMDD			NVARCHAR(008)
		, YYYYMM			NVARCHAR(006)
		, YYYY				NVARCHAR(004)
		, ITEM_VALUE		NUMERIC(15,4)
	)

	-- loss , tact , yeild 가 합쳐진 테이블
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_ALL') IS NOT NULL
		DROP TABLE #TMP_SCP0054_ALL;

	CREATE TABLE #TMP_SCP0054_ALL
	( 
		  DIVISION_ID		NVARCHAR(030)
		, COMPANY_ID		NVARCHAR(030)
		, SITE_ID			NVARCHAR(030)
		, PLANT_ID			NVARCHAR(030)
		, FACTORY_ID		NVARCHAR(030)
		, LINE_ID			NVARCHAR(030)
		, ELECTRODE_TYPE	NVARCHAR(030)
		, OPERATION_ID		NVARCHAR(030)
		, LOSS_CODE			NVARCHAR(030)
		, ITEM_ID			NVARCHAR(030)
		, LANE_QTY			INT
		, YYYYMMDD			NVARCHAR(008)
		, YYYYMM			NVARCHAR(006)
		, YYYY				NVARCHAR(004)
		, ITEM_VALUE		NUMERIC(15,4)
		, BEF_M6_RESULT		NUMERIC(10,3)
		, BEF_M5_RESULT		NUMERIC(10,3)
		, BEF_M4_RESULT		NUMERIC(10,3)
		, BEF_M3_RESULT		NUMERIC(10,3)
		, BEF_M2_RESULT		NUMERIC(10,3)
		, BEF_M1_RESULT		NUMERIC(10,3)
		, BEF_BEST_RESULT	NUMERIC(10,3)
		, BEF_WORST_RESULT	NUMERIC(10,3)
	)

	-- PRODUCTION 데이터를 저장하는 테이블
	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_PRODUCTION') IS NOT NULL
		DROP TABLE #TMP_SCP0054_PRODUCTION;

	CREATE TABLE #TMP_SCP0054_PRODUCTION
	( 
		  DIVISION_ID		NVARCHAR(030)
		, COMPANY_ID		NVARCHAR(030)
		, SITE_ID			NVARCHAR(030)
		, PLANT_ID			NVARCHAR(030)
		, FACTORY_ID		NVARCHAR(030)
		, LINE_ID			NVARCHAR(030)
		, ELECTRODE_TYPE	NVARCHAR(030)
		, OPERATION_ID		NVARCHAR(030)
		, LOSS_CODE			NVARCHAR(030)
		, ITEM_ID			NVARCHAR(030)
		, LANE_QTY			INT
		, YYYYMMDD			NVARCHAR(008)
		, YYYYMM			NVARCHAR(006)
		, YYYY				NVARCHAR(004)
		, ITEM_VALUE		NUMERIC(15,4)
	)


	IF OBJECT_ID('TEMPDB..#TMP_SCP0054_PRODUCTION_AVG') IS NOT NULL
		DROP TABLE #TMP_SCP0054_PRODUCTION_AVG;

	CREATE TABLE #TMP_SCP0054_PRODUCTION_AVG
	( 
	    DIVISION_ID			NVARCHAR(030)
	  , COMPANY_ID			NVARCHAR(030)
	  , SITE_ID				NVARCHAR(030)
	  , PLANT_ID			NVARCHAR(030)
	  , FACTORY_ID			NVARCHAR(030)
	  , OPERATION_ID		NVARCHAR(030)
	  , LINE_ID				NVARCHAR(030)
	  , ELECTRODE_TYPE		NVARCHAR(030)
	  , LOSS_CODE			NVARCHAR(030)
	  , ITEM_ID				NVARCHAR(030)
	  , LANE_QTY			INT
	)

	END

	-- /////////////////////////////////////////////////////////////////////
	-- PRODUCTION 데이터 조회
	-- 월별 데이터 조회(현재 월 데이터)
	-- 계획(P) , 실적(R) 데이터 조회 - PLAN DATE 기준
	-- /////////////////////////////////////////////////////////////////////
	BEGIN
		INSERT INTO #TMP_SCP0054_PRODUCTION
		(
			  DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, OPERATION_ID
			, LOSS_CODE
			, ITEM_ID
			, LANE_QTY
			, YYYYMMDD
			, YYYYMM
			, YYYY
			, ITEM_VALUE
		)
		SELECT DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , LINE_ID
			 , ELECTRODE_TYPE
			 , OPERATION_ID
			 , LOSS_CODE
			 , ITEM_ID
			 , LANE_QTY
			 , YYYYMMDD
			 , YYYYMM
			 , YYYY
			 , SUM(ITEM_VALUE)
		  FROM (
				-- 계획 구간 데이터 조회
				SELECT A.DIVISION_ID
					 , L.COMPANY_ID
					 , L.SITE_ID
					 , L.PLANT_ID
					 , L.FACTORY_ID
					 , A.LINE_ID
					 , L.ELECTRODE_TYPE
					 , A.OPERATION_ID
					 , 'XP001'			AS LOSS_CODE
					 , A.ITEM_ID
					 , 0				AS LANE_QTY
					 , NULL				AS YYYYMMDD
					 , LEFT(YYYYMMDD,6) AS YYYYMM
					 , NULL				AS YYYY
					 , A.QTY			AS ITEM_VALUE
				  FROM SCP_ANL_PRODUCTION_PLAN A WITH(NOLOCK INDEX(IX05_SCP_ANL_PRODUCTION_PLAN))

				  INNER MERGE JOIN #TMP_SCP0054_STD L
					ON A.LINE_ID		= L.LINE_ID
				   AND A.OPERATION_ID	= L.OPERATION_ID

				 WHERE PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
				   AND PLAN_TYPE			= @p_plan_type
				   AND SEQ					= @p_plan_seq
				   AND YYYYMMDD				>= @v_start_prod_day
				   AND YYYYMMDD				<= @v_end_month + '31'
				   AND MEASURE				= 'PROD_PLAN_AMEND'
				   AND QTY					> 0
				
				UNION ALL
				-- 실적(과거) 구간 데이터 조회
				SELECT A.DIVISION_ID
					 , L.COMPANY_ID
					 , L.SITE_ID
					 , L.PLANT_ID
					 , L.FACTORY_ID
					 , A.LINE_ID
					 , L.ELECTRODE_TYPE
					 , A.OPERATION_ID
					 , 'XP001'								AS LOSS_CODE
					 , A.ITEM_ID
					 , 0									AS LANE_QTY
					 , NULL									AS YYYYMMDD
					 , CONVERT(VARCHAR(6),A.PLAN_DATE,112)	AS YYYYMM
					 , NULL									AS YYYY
					 , A.ACTUAL_GOOD_QTY					AS ITEM_VALUE
				 FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK)

				 JOIN #TMP_SCP0054_STD L
				   ON A.LINE_ID			= L.LINE_ID
				  AND A.OPERATION_ID	= L.OPERATION_ID

				WHERE 1=1
				  --AND CONVERT(VARCHAR(8),A.PLAN_DATE,112)  >= @v_start_rlt_day
				  --AND CONVERT(VARCHAR(8),A.PLAN_DATE,112)  <= @v_end_rlt_day
				  AND A.PLAN_DATE  >= CONVERT(DATETIME, @v_start_rlt_day + ' 00:00:00.000', 121)
				  AND A.PLAN_DATE  <= CONVERT(DATETIME, @v_end_rlt_day + ' 23:59:59.997', 121)
			) X

		 GROUP BY DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , PLANT_ID
			 , FACTORY_ID
			 , LINE_ID
			 , ELECTRODE_TYPE
			 , OPERATION_ID
			 , LOSS_CODE
			 , ITEM_ID
			 , LANE_QTY
			 , YYYYMMDD
			 , YYYYMM
			 , YYYY
	END


	-- ///////////////////////////////////////////////////////////////////////////////////
	-- PRODCUTION 의 실적(과거) 데이터 조회
	-- 과거 3개월
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		INSERT INTO #TMP_SCP0054_AVG_DATA
		(
			  DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, LOSS_CODE
			, ITEM_ID
			, LANE_QTY
			, YYYYMM
			, ITEM_VALUE_RESULT
		)
		SELECT A.DIVISION_ID
			 , L.COMPANY_ID
			 , L.SITE_ID
			 , L.PLANT_ID
			 , L.FACTORY_ID
			 , A.OPERATION_ID
			 , A.LINE_ID
			 , L.ELECTRODE_TYPE
			 , 'XP001'								AS LOSS_CODE
			 , A.ITEM_ID
			 , 0									AS LANE_QTY
			 , CONVERT(VARCHAR(6),A.PLAN_DATE,112)	AS YYYYMM
			 , SUM(A.ACTUAL_GOOD_QTY )				AS ITEM_VALUE_RESULT
		  FROM SCM_DNM_DAILY_PRODUCT_RESULT_SN A WITH(NOLOCK)  -- 실적(과거) 테이블

		  JOIN #TMP_SCP0054_STD L
			ON A.LINE_ID		= L.LINE_ID
		   AND A.OPERATION_ID	= L.OPERATION_ID

		 WHERE 1=1
		   /*SQL 수정*/
		   --AND CONVERT(VARCHAR(6),A.PLAN_DATE,112)  >= @p_from_yyyymm -- 조회 시작 월
		   --AND CONVERT(VARCHAR(6),A.PLAN_DATE,112)  <= @v_end_avg
		   AND A.PLAN_DATE  >= CONVERT(DATETIME, @p_from_yyyymm + '01 00:00:00.000', 121) -- 조회 시작 월
		   AND A.PLAN_DATE  <= DATEADD(DAY, -1, DATEADD(MONTH, +1 , CONVERT(DATETIME, @v_end_avg + '01 23:59:59.997', 121)))

		 GROUP BY A.DIVISION_ID
				 , L.COMPANY_ID
				 , L.COMPANY_ID
				 , L.SITE_ID
				 , L.PLANT_ID
				 , L.FACTORY_ID
				 , A.LINE_ID
				 , L.ELECTRODE_TYPE
				 , A.OPERATION_ID
				 , A.ITEM_ID
				 , CONVERT(VARCHAR(6),A.PLAN_DATE,112)
	END

	

	-- ///////////////////////////////////////////////////////////////////////////////////
	-- 기준 ITEM 생성
	-- PRODCUTION 의 데이터(과거 , 실적)를 기준으로 기준 ITEM 정보 생성
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0054_STD_ITEM') IS NOT NULL
			DROP TABLE #TMP_SCP0054_STD_ITEM;

		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.SITE_NAME
			 , A.PLANT_ID
			 , A.OPERATION_GROUP_ID
			 , A.OPERATION_GROUP_NAME
			 , A.FACTORY_ID
			 , A.FACTORY_NAME
			 , A.OPERATION_ID
			 , A.OPERATION_NAME
			 , A.LINE_ID
			 , A.LINE_NAME
			 , A.ELECTRODE_TYPE
			 , C.NICK_NAME
			 , B.ITEM_ID
			 , 0			AS LANE_QTY
		INTO #TMP_SCP0054_STD_ITEM
		FROM #TMP_SCP0054_STD A
		LEFT OUTER JOIN #TMP_SCP0054_PRODUCTION B
		  ON A.DIVISION_ID 						= B.DIVISION_ID
		 AND A.SITE_ID 							= B.SITE_ID
		 AND A.PLANT_ID 						= B.PLANT_ID
		 AND A.FACTORY_ID 						= B.FACTORY_ID
		 AND A.LINE_ID 							= B.LINE_ID
		 AND A.OPERATION_ID 					= B.OPERATION_ID
		 AND A.ELECTRODE_TYPE 					= B.ELECTRODE_TYPE
		LEFT OUTER JOIN SCM_ITEM_M_SN C
		  ON B.COMPANY_ID 						= C.COMPANY_ID
		 AND B.DIVISION_ID 						= C.DIVISION_ID
		 AND B.SITE_ID 							= C.SITE_ID
		 AND B.ITEM_ID 							= C.ITEM_ID
		 AND C.ACTIVE_FLAG 						= 'Y'
	END


	-- ///////////////////////////////////////////////////////////////////////////////////
	-- TACT TIME 기준 테이블 생성(LANE QTY 컬럼 없음)
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0054_STD_ITEM_TACT') IS NOT NULL
			DROP TABLE #TMP_SCP0054_STD_ITEM_TACT;

		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.SITE_NAME
			 , A.PLANT_ID
			 , A.OPERATION_GROUP_ID
			 , A.OPERATION_GROUP_NAME
			 , A.FACTORY_ID
			 , A.FACTORY_NAME
			 , A.OPERATION_ID
			 , A.OPERATION_NAME
			 , A.LINE_ID
			 , A.LINE_NAME
			 , A.ELECTRODE_TYPE
			 , A.NICK_NAME
			 , A.ITEM_ID
		INTO #TMP_SCP0054_STD_ITEM_TACT
		FROM #TMP_SCP0054_STD_ITEM A
	END

	-- ///////////////////////////////////////////////////////////////////////////////////
	-- YIELD 기준 테이블 생성(LANE QTY , ELECTRODE_TYPE 컬럼 없음)
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0054_STD_ITEM_YIELD') IS NOT NULL
			DROP TABLE #TMP_SCP0054_STD_ITEM_YIELD;

		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.COMPANY_ID
			 , A.SITE_ID
			 , A.SITE_NAME
			 , A.PLANT_ID
			 , A.OPERATION_GROUP_ID
			 , A.OPERATION_GROUP_NAME
			 , A.FACTORY_ID
			 , A.FACTORY_NAME
			 , A.OPERATION_ID
			 , A.OPERATION_NAME
			 , A.LINE_ID
			 , A.LINE_NAME
			 , A.NICK_NAME
			 , A.ITEM_ID
		INTO #TMP_SCP0054_STD_ITEM_YIELD
		FROM #TMP_SCP0054_STD_ITEM A
	END	-- // 기준 테이블 생성

	BEGIN
		-- ///////////////////////////////////////////////////////////////////////////////
		-- 실적(과거) 데이터 조회
		-- 3월 간 월별 평균, 3개월 평균 , SCM_WORK_CALENDAR_M_SN , SCM_LOSS_M_SN
		-- , SCM_TACT_TIME_M_SN , SCM_YIELD_M_SN, SCM_YIELD_M_SN
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			-- CALENDAR , LOSS 정보
			BEGIN
				INSERT INTO #TMP_SCP0054_AVG_DATA
				(
					  COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, LOSS_CODE
					, ITEM_ID
					, LANE_QTY
					, YYYYMM
					, ITEM_VALUE_RESULT
				)
				SELECT CM.COMPANY_ID
					 , CM.DIVISION_ID
					 , CM.SITE_ID
					 , CM.PLANT_ID
					 , CM.FACTORY_ID
					 , CM.OPERATION_ID
					 , CM.LINE_ID
					 , CM.ELECTRODE_TYPE
					 , CM.LOSS_CODE
					 , NULL										AS ITEM_ID
					 , 0										AS LANE_QTY
					 , CONVERT(VARCHAR(6),CM.WORK_DATE ,112)	AS YYYYMM
					 , ISNULL(SUM(CM.TIME_TERM_RESULT),0)		AS ITEM_VALUE_RESULT
				  FROM #TMP_SCP0054_LOOKUP LU

				  JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)  -- CURRENT 테이블
				    ON CM.LOSS_CODE		= LU.LOSS_CODE

				  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
					ON CM.DIVISION_ID		= L.DIVISION_ID
				   AND CM.COMPANY_ID		= L.COMPANY_ID
				   AND CM.SITE_ID			= L.SITE_ID
				   AND CM.PLANT_ID			= L.PLANT_ID
				   AND CM.FACTORY_ID		= L.FACTORY_ID
				   AND CM.OPERATION_ID		= L.OPERATION_ID
				   AND CM.LINE_ID			= L.LINE_ID
				   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				 WHERE LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				   /*SQL 수정*/
				   --AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) >= @v_start_avg -- '202004'
				   --AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_avg   -- '202006'
				   AND CM.WORK_DATE >= CONVERT(DATETIME, @v_start_avg + '01 00:00:00.000', 121)
				   AND CM.WORK_DATE <= DATEADD(DAY, -1, DATEADD(MONTH, +1 , CONVERT(DATETIME, @v_end_avg + '01 23:59:59.997', 121)))

				 GROUP BY CM.COMPANY_ID
						, CM.DIVISION_ID
						, CM.SITE_ID
						, CM.PLANT_ID
						, CM.FACTORY_ID
						, CM.OPERATION_ID
						, CM.LINE_ID
						, CM.ELECTRODE_TYPE
						, CM.LOSS_CODE
						, CONVERT(VARCHAR(6),CM.WORK_DATE ,112)
			
				UNION ALL

				-- SCM_LOSS_M_SN (월별 데이터)
				SELECT LM.COMPANY_ID
					 , LM.DIVISION_ID
					 , LM.SITE_ID
					 , LM.PLANT_ID
					 , LM.FACTORY_ID
					 , LM.OPERATION_ID
					 , LM.LINE_ID
					 , LM.ELECTRODE_TYPE
					 , LM.LOSS_CODE
					 , NULL									AS ITEM_ID
					 , 0									AS LANE_QTY
					 , LM.WORK_MONTH						AS YYYYMM
					 , ISNULL(LM.LOSS_RATE_RESULT,0) * 100	AS ITEM_VALUE_RESULT
					 
				  FROM #TMP_SCP0054_LOOKUP LU

				  JOIN SCM_LOSS_M_SN LM WITH(NOLOCK)  -- CURRENT 테이블
					ON LM.LOSS_CODE		= LU.LOSS_CODE

				  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
					ON LM.DIVISION_ID		= L.DIVISION_ID
				   AND LM.COMPANY_ID		= L.COMPANY_ID
				   AND LM.SITE_ID			= L.SITE_ID
				   AND LM.PLANT_ID			= L.PLANT_ID
				   AND LM.FACTORY_ID		= L.FACTORY_ID
				   AND LM.OPERATION_ID		= L.OPERATION_ID
				   AND LM.LINE_ID			= L.LINE_ID
				   AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				 WHERE 1 = 1
				   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
				   AND LM.WORK_MONTH >= @v_start_avg -- '202004'
				   AND LM.WORK_MONTH <= @v_end_avg   -- '202006'
				;


				-- 이력 테이블 조회
				IF @v_end_result_avg > @v_start_result_avg
				BEGIN
					INSERT INTO #TMP_SCP0054_AVG_DATA
					(
						  COMPANY_ID
						, DIVISION_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, OPERATION_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, LOSS_CODE
						, ITEM_ID
						, LANE_QTY
						, YYYYMM
						, ITEM_VALUE_RESULT
					)
					SELECT CM.COMPANY_ID
						 , CM.DIVISION_ID
						 , CM.SITE_ID
						 , CM.PLANT_ID
						 , CM.FACTORY_ID
						 , CM.OPERATION_ID
						 , CM.LINE_ID
						 , CM.ELECTRODE_TYPE
						 , CM.LOSS_CODE
						 , NULL										AS ITEM_ID
						 , 0										AS LANE_QTY
						 , CONVERT(VARCHAR(6),CM.WORK_DATE ,112)	AS YYYYMM
						 , ISNULL(SUM(CM.TIME_TERM_RESULT),0)		AS ITEM_VALUE_RESULT
					  FROM #TMP_SCP0054_LOOKUP LU

					  JOIN HIST_SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)  -- 이력(HIST) 테이블 조회
					    ON CM.LOSS_CODE		= LU.LOSS_CODE

					  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
						ON CM.DIVISION_ID		= L.DIVISION_ID
					   AND CM.COMPANY_ID		= L.COMPANY_ID
					   AND CM.SITE_ID			= L.SITE_ID
					   AND CM.PLANT_ID			= L.PLANT_ID
					   AND CM.FACTORY_ID		= L.FACTORY_ID
					   AND CM.OPERATION_ID		= L.OPERATION_ID
					   AND CM.LINE_ID			= L.LINE_ID
					   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

					 WHERE LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				       /*SQL 수정*/
					   --AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) >= @v_start_result_avg
					   --AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_result_avg
				       AND CM.WORK_DATE >= CONVERT(DATETIME, @v_start_result_avg + '01 00:00:00.000', 121)
				       AND CM.WORK_DATE <= DATEADD(DAY, -1, DATEADD(MONTH, +1 , CONVERT(DATETIME, @v_end_result_avg + '01 23:59:59.997', 121)))

					 GROUP BY CM.COMPANY_ID
							, CM.DIVISION_ID
							, CM.SITE_ID
							, CM.PLANT_ID
							, CM.FACTORY_ID
							, CM.OPERATION_ID
							, CM.LINE_ID
							, CM.ELECTRODE_TYPE
							, CM.LOSS_CODE
							, CONVERT(VARCHAR(6),CM.WORK_DATE ,112)
				
					UNION ALL

					-- SCM_LOSS_M_SN (월별 데이터)
					SELECT LM.COMPANY_ID
						 , LM.DIVISION_ID
						 , LM.SITE_ID
						 , LM.PLANT_ID
						 , LM.FACTORY_ID
						 , LM.OPERATION_ID
						 , LM.LINE_ID
						 , LM.ELECTRODE_TYPE
						 , LM.LOSS_CODE
						 , NULL									AS ITEM_ID
						 , 0									AS LANE_QTY
						 , LM.WORK_MONTH						AS YYYYMM
						 , ISNULL(LM.LOSS_RATE_RESULT,0) * 100	AS ITEM_VALUE_RESULT
						 
					  FROM #TMP_SCP0054_LOOKUP LU

					  JOIN HIST_SCM_LOSS_M_SN LM WITH(NOLOCK)  -- 이력(HIST) 테이블 조회
						ON LM.LOSS_CODE		= LU.LOSS_CODE

					  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
						ON LM.DIVISION_ID		= L.DIVISION_ID
					   AND LM.COMPANY_ID		= L.COMPANY_ID
					   AND LM.SITE_ID			= L.SITE_ID
					   AND LM.PLANT_ID			= L.PLANT_ID
					   AND LM.FACTORY_ID		= L.FACTORY_ID
					   AND LM.OPERATION_ID		= L.OPERATION_ID
					   AND LM.LINE_ID			= L.LINE_ID
					   AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

					 WHERE 1 = 1
					   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
					   AND LM.WORK_MONTH >= @v_start_result_avg
					   AND LM.WORK_MONTH <= @v_end_result_avg
					;
				END --// 이력 테이블 조회 끝

			END  -- //CALENDAR , LOSS

			-- TACT TIME AVG
			BEGIN
				INSERT INTO #TMP_SCP0054_AVG_DATA
				(
					  COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, LOSS_CODE
					, ITEM_ID
					, LANE_QTY
					, YYYYMM
					, ITEM_VALUE_RESULT
				)
				-- TACT TIME (월별 데이터)
				SELECT TM.COMPANY_ID
					 , TM.DIVISION_ID
					 , TM.SITE_ID
					 , TM.PLANT_ID
					 , TM.FACTORY_ID
					 , TM.OPERATION_ID
					 , TM.LINE_ID
					 , TM.ELECTRODE_TYPE
					 , 'LA002'					AS LOSS_CODE
					 , TM.ITEM_ID				AS ITEM_ID
					 , 0						AS LANE_QTY
					 , TM.MONTH					AS YYYYMM
					 , ISNULL(TM.TACT_TIME,0)	AS ITEM_VALUE_RESULT
				  FROM SCM_MST_TACT_TIME_SN TM WITH(NOLOCK) -- CURRENT 테이블

				  JOIN #TMP_SCP0054_STD_ITEM_TACT I WITH(NOLOCK)
					ON TM.DIVISION_ID		= I.DIVISION_ID
				   AND TM.COMPANY_ID		= I.COMPANY_ID
				   AND TM.SITE_ID			= I.SITE_ID
				   AND TM.PLANT_ID			= I.PLANT_ID
				   AND TM.FACTORY_ID		= I.FACTORY_ID
				   AND TM.OPERATION_ID		= I.OPERATION_ID
				   AND TM.LINE_ID			= I.LINE_ID
				   AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				   AND TM.ITEM_ID			= I.ITEM_ID

				  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				   AND LV.SEGMENT1 			= 'LA002'
				   AND TM.PLANT_ID			= LV.SEGMENT2
				   AND TM.OPERATION_ID		= LV.SEGMENT3
				   AND LV.ACTIVE_FLAG		= 'Y'

				 WHERE TM.MONTH >= @v_start_avg
				   AND TM.MONTH <= @v_end_avg

				-- 이력 테이블 조회
				IF @v_end_result_avg > @v_start_result_avg
				BEGIN
					INSERT INTO #TMP_SCP0054_AVG_DATA
					(
						  COMPANY_ID
						, DIVISION_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, OPERATION_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, LOSS_CODE
						, ITEM_ID
						, LANE_QTY
						, YYYYMM
						, ITEM_VALUE_RESULT
					)
					-- TACT TIME (월별 데이터)
					SELECT TM.COMPANY_ID
						 , TM.DIVISION_ID
						 , TM.SITE_ID
						 , TM.PLANT_ID
						 , TM.FACTORY_ID
						 , TM.OPERATION_ID
						 , TM.LINE_ID
						 , TM.ELECTRODE_TYPE
						 , 'LA002'					AS LOSS_CODE
						 , TM.ITEM_ID				AS ITEM_ID
						 , 0						AS LANE_QTY
						 , TM.MONTH					AS YYYYMM
						 , ISNULL(TM.TACT_TIME,0)	AS ITEM_VALUE_RESULT
					  FROM HIST_SCM_TACT_TIME_M_SN TM WITH(NOLOCK) -- 이력(HIST) 테이블 조회

					  JOIN #TMP_SCP0054_STD_ITEM_TACT I WITH(NOLOCK)
						ON TM.DIVISION_ID		= I.DIVISION_ID
					   AND TM.COMPANY_ID		= I.COMPANY_ID
					   AND TM.SITE_ID			= I.SITE_ID
					   AND TM.PLANT_ID			= I.PLANT_ID
					   AND TM.FACTORY_ID		= I.FACTORY_ID
					   AND TM.OPERATION_ID		= I.OPERATION_ID
					   AND TM.LINE_ID			= I.LINE_ID
					   AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
					   AND TM.ITEM_ID			= I.ITEM_ID

					  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
					    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
					   AND LV.SEGMENT1 			= 'LA002'
					   AND TM.PLANT_ID			= LV.SEGMENT2
					   AND TM.OPERATION_ID		= LV.SEGMENT3
					   AND LV.ACTIVE_FLAG		= 'Y'

					 WHERE TM.MONTH >= @v_start_result_avg
					   AND TM.MONTH <= @v_end_result_avg
				END --// 이력 테이블 조회 끝
				
				 
			END  -- // TACT TIME AVG

			-- // YIELD AVG
			BEGIN
				INSERT INTO #TMP_SCP0054_AVG_DATA
				(
					  COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, LOSS_CODE
					, ITEM_ID
					, LANE_QTY
					, YYYYMM
					, ITEM_VALUE_RESULT
				)
				SELECT YM.COMPANY_ID
					 , YM.DIVISION_ID
					 , YM.SITE_ID
					 , YM.PLANT_ID
					 , YM.FACTORY_ID
					 , YM.OPERATION_ID
					 , YM.LINE_ID
					 , '-'								AS ELECTRODE_TYPE
					 , 'LA003'							AS LOSS_CODE
					 , YM.ITEM_ID						AS ITEM_ID
					 , 0								AS LANE_QTY
					 , YM.MONTH							AS YYYYMM
					 , ISNULL(YM.RESULT_YIELD,0) * 100 	AS ITEM_VALUE_RESULT
				  FROM SCM_MST_YIELD_SN YM WITH(NOLOCK) -- CURRENT 테이블

				  JOIN #TMP_SCP0054_STD_ITEM_YIELD I WITH(NOLOCK)
					ON YM.DIVISION_ID		= I.DIVISION_ID
				   AND YM.COMPANY_ID		= I.COMPANY_ID
				   AND YM.SITE_ID			= I.SITE_ID
				   AND YM.PLANT_ID			= I.PLANT_ID
				   AND YM.FACTORY_ID		= I.FACTORY_ID
				   AND YM.OPERATION_ID		= I.OPERATION_ID
				   AND YM.LINE_ID			= I.LINE_ID
				   AND YM.ITEM_ID			= I.ITEM_ID

				 WHERE YM.MONTH >= @v_start_avg -- '202004'
				   AND YM.MONTH <= @v_end_avg   -- '202006'
				;

				-- 이력 테이블 조회
				IF @v_end_result_avg > @v_start_result_avg
				BEGIN
					INSERT INTO #TMP_SCP0054_AVG_DATA
					(
						  COMPANY_ID
						, DIVISION_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, OPERATION_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, LOSS_CODE
						, ITEM_ID
						, LANE_QTY
						, YYYYMM
						, ITEM_VALUE_RESULT
					)
					SELECT YM.COMPANY_ID
						 , YM.DIVISION_ID
						 , YM.SITE_ID
						 , YM.PLANT_ID
						 , YM.FACTORY_ID
						 , YM.OPERATION_ID
						 , YM.LINE_ID
						 , '-'								AS ELECTRODE_TYPE
						 , 'LA003'							AS LOSS_CODE
						 , YM.ITEM_ID						AS ITEM_ID
						 , 0								AS LANE_QTY
						 , YM.MONTH							AS YYYYMM
						 , ISNULL(YM.RESULT_YIELD,0) * 100 	AS ITEM_VALUE_RESULT
					  FROM HIST_SCM_YIELD_M_SN YM WITH(NOLOCK) -- 이력(HIST) 테이블 조회

					  JOIN #TMP_SCP0054_STD_ITEM_YIELD I WITH(NOLOCK)
						ON YM.DIVISION_ID		= I.DIVISION_ID
					   AND YM.COMPANY_ID		= I.COMPANY_ID
					   AND YM.SITE_ID			= I.SITE_ID
					   AND YM.PLANT_ID			= I.PLANT_ID
					   AND YM.FACTORY_ID		= I.FACTORY_ID
					   AND YM.OPERATION_ID		= I.OPERATION_ID
					   AND YM.LINE_ID			= I.LINE_ID
					   AND YM.ITEM_ID			= I.ITEM_ID

					 WHERE YM.MONTH >= @v_start_result_avg
					   AND YM.MONTH <= @v_end_result_avg
					;
				END -- // 이력(HIST) 테이블 조회 끝
			END -- // YIELD
		END  --// 평균(3개월) 데이터 끝(CALENDAR , LOSS , TACT TIME , YIELD)


		BEGIN
		INSERT INTO #TMP_SCP0054_AVG
		(
			  DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, LOSS_CODE
			, ITEM_ID
			, LANE_QTY
			, BEF_M6_RESULT
			, BEF_M5_RESULT
			, BEF_M4_RESULT
			, BEF_M3_RESULT
			, BEF_M2_RESULT
			, BEF_M1_RESULT
		)
		SELECT DIVISION_ID
			, COMPANY_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, LOSS_CODE
			, ITEM_ID
			, LANE_QTY
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M6_RESULT
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M5_RESULT
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M4_RESULT
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M3_RESULT
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M2_RESULT
			, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M1_RESULT
		FROM #TMP_SCP0054_AVG_DATA
		GROUP BY COMPANY_ID
		, DIVISION_ID
		, SITE_ID
		, PLANT_ID
		, FACTORY_ID
		, OPERATION_ID
		, LINE_ID
		, ELECTRODE_TYPE
		, LOSS_CODE
		, ITEM_ID
		, LANE_QTY
	END -- // PRODUCTION 의 실적(과거) 데이터

	-- /////////////////////////////////////////////////////////////////////////
	-- 조회된 과거 데이터를 BEST , WORST 를 저장한다.
	-- LOSS, TACT TIME 는 작은값이 BEST
	-- DAILY CPAP(LA002), YIELD(LA003) 는 큰값이 BEST
	-- 죄회된 데이터에 해당 월 값이 없을 경우 0 값으로 설정해서 MIN, MAX 값을 구한다
	-- /////////////////////////////////////////////////////////////////////////
	BEGIN
		INSERT INTO #TMP_SCP0054_AVG_MIN_MAX
		(
			  COMPANY_ID
			, DIVISION_ID
			, SITE_ID
			, PLANT_ID
			, FACTORY_ID
			, OPERATION_ID
			, LINE_ID
			, ELECTRODE_TYPE
			, LOSS_CODE
			, ITEM_ID
			, LANE_QTY
			, BEF_BEST_RESULT
			, BEF_WORST_RESULT
		)
					
		SELECT T.COMPANY_ID
					, T.DIVISION_ID
					, T.SITE_ID
					, T.PLANT_ID
					, T.FACTORY_ID
					, T.OPERATION_ID
					, T.LINE_ID
					, T.ELECTRODE_TYPE
					, T.LOSS_CODE
					, T.ITEM_ID
					, T.LANE_QTY
					, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
						--ELSE  MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_BEST_RESULT
						ELSE  MIN(X.ITEM_VALUE_RESULT) END AS BEF_BEST_RESULT
					--, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
					, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(X.ITEM_VALUE_RESULT) 
						ELSE  MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_WORST_RESULT
				FROM (
					SELECT A.COMPANY_ID
							, A.DIVISION_ID
							, A.SITE_ID
							, A.PLANT_ID
							, A.FACTORY_ID
							, A.OPERATION_ID
							, A.LINE_ID
							, A.ELECTRODE_TYPE
							, A.LOSS_CODE
							, A.ITEM_ID
							, A.LANE_QTY
							, C.BASIS_YYYYMM	AS YYYYMM
							, 0				AS ITEM_VALUE
							, 0				AS ITEM_VALUE_RESULT
						FROM #TMP_SCP0054_AVG_DATA A
						CROSS JOIN ( SELECT DISTINCT BASIS_YYYYMM 
									   FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
									  WHERE BASIS_YYYYMM >= @p_from_yyyymm -- 조회 시작 월
										AND BASIS_YYYYMM <= @v_end_avg
									) C
					) T
			LEFT JOIN #TMP_SCP0054_AVG_DATA  X
				ON T.LINE_ID				= X.LINE_ID
				AND T.OPERATION_ID			= X.OPERATION_ID
				AND ISNULL(T.ELECTRODE_TYPE,'-')	= ISNULL(X.ELECTRODE_TYPE,'-')
				AND T.LOSS_CODE			= X.LOSS_CODE
				AND ISNULL(T.ITEM_ID,'-')	= ISNULL(X.ITEM_ID,'-')
				AND T.YYYYMM				= X.YYYYMM

			JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				AND LV.SEGMENT1 			= 'LA002'
				AND T.PLANT_ID			= LV.SEGMENT2
				AND T.OPERATION_ID		= LV.SEGMENT3
				AND LV.ACTIVE_FLAG = 'Y'
			GROUP BY T.COMPANY_ID
				, T.DIVISION_ID
				, T.SITE_ID
				, T.PLANT_ID
				, T.FACTORY_ID
				, T.OPERATION_ID
				, T.LINE_ID
				, T.ELECTRODE_TYPE
				, T.LOSS_CODE
				, T.ITEM_ID
				, T.LANE_QTY
				, LV.ATTRIBUTE1
	END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- SCM_WORK_CALENDAR_M_SN , SCM_LOSS_M_SN
		-- 월 데이터 조회
		-- CAL : 실적(과거) 구간 + 계획 구간 
		--       PLAN DATE 를 기준으로 PLAN DATE 이전은 과거구간 조회 PLAN DATE 부터 계획 구간 조회
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			INSERT INTO #TMP_SCP0054_MM
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, YYYYMMDD
				, YYYYMM
				, YYYY
				, ITEM_VALUE
			)
			SELECT DIVISION_ID
				 , COMPANY_ID
				 , SITE_ID
				 , PLANT_ID
				 , FACTORY_ID
				 , LINE_ID
				 , ELECTRODE_TYPE
				 , OPERATION_ID
				 , LOSS_CODE
				 , YYYYMMDD
				 , YYYYMM
				 , YYYY
				 , SUM(ITEM_VALUE) AS ITEM_VALUE
			  FROM (
					-- 실적(과거) 데이터 조회
					SELECT CM.DIVISION_ID
						 , CM.COMPANY_ID
						 , CM.SITE_ID
						 , CM.PLANT_ID
						 , CM.FACTORY_ID
						 , CM.LINE_ID
						 , CM.ELECTRODE_TYPE
						 , CM.OPERATION_ID
						 , CM.LOSS_CODE
						 , NULL										AS YYYYMMDD
						 , CONVERT(VARCHAR(6), CM.WORK_DATE,112)	AS YYYYMM
						 , NULL										AS YYYY
						 , CM.TIME_TERM								AS ITEM_VALUE  -- 실적 데이터는 다음달에 생성되므로 실적 컬럼을 사용하지 않는다.
					  FROM #TMP_SCP0054_LOOKUP LU

					  JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)  -- CURRENT 테이블
						ON CM.LOSS_CODE		= LU.LOSS_CODE

					  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
						ON CM.DIVISION_ID		= L.DIVISION_ID
					   AND CM.COMPANY_ID		= L.COMPANY_ID
					   AND CM.SITE_ID			= L.SITE_ID
					   AND CM.PLANT_ID			= L.PLANT_ID
					   AND CM.FACTORY_ID		= L.FACTORY_ID
					   AND CM.OPERATION_ID		= L.OPERATION_ID
					   AND CM.LINE_ID			= L.LINE_ID
					   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

					 WHERE LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
					   /*SQL 수정*/
					   /*AND CONVERT(VARCHAR(8),CM.WORK_DATE ,112) >= @v_start_rlt_day
					   AND CONVERT(VARCHAR(8),CM.WORK_DATE ,112) <= @v_end_rlt_day*/
				       AND CM.WORK_DATE  >= CONVERT(DATETIME, @v_start_rlt_day + ' 00:00:00.000', 121)
				       AND CM.WORK_DATE  <= CONVERT(DATETIME, @v_end_rlt_day + ' 23:59:59.997', 121)

					UNION ALL

					-- 계획(미래) 데이터 조회
					SELECT CM.DIVISION_ID
						 , CM.COMPANY_ID
						 , CM.SITE_ID
						 , CM.PLANT_ID
						 , CM.FACTORY_ID
						 , CM.LINE_ID
						 , CM.ELECTRODE_TYPE
						 , CM.OPERATION_ID
						 , CM.LOSS_CODE
						 , NULL										AS YYYYMMDD
						 , CONVERT(VARCHAR(6), CM.WORK_DATE,112)	AS YYYYMM
						 , NULL										AS YYYY
						 , CM.TIME_TERM								AS ITEM_VALUE
					  FROM #TMP_SCP0054_LOOKUP LU

					  JOIN SCM_WORK_CAL_VER_H_SN CM WITH(NOLOCK)  -- VERSION 테이블
						ON CM.LOSS_CODE		= LU.LOSS_CODE

					  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
						ON CM.DIVISION_ID		= L.DIVISION_ID
					   AND CM.COMPANY_ID		= L.COMPANY_ID
					   AND CM.SITE_ID			= L.SITE_ID
					   AND CM.PLANT_ID			= L.PLANT_ID
					   AND CM.FACTORY_ID		= L.FACTORY_ID
					   AND CM.OPERATION_ID		= L.OPERATION_ID
					   AND CM.LINE_ID			= L.LINE_ID
					   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

					 WHERE 1 = 1
					   AND CM.VERSION_ID  = @p_version_id
					   AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
					   /*SQL 수정*/
					   --AND CONVERT(VARCHAR(8),CM.WORK_DATE ,112) >= @v_start_prod_day -- '202008'
					   --AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_month   -- '202106'
					   AND CM.WORK_DATE  >= CONVERT(DATETIME, @v_start_prod_day + ' 00:00:00.000', 121)
				       AND CM.WORK_DATE  <= DATEADD(DAY, -1, DATEADD(MONTH, +1 , CONVERT(DATETIME, @v_end_month + '01 23:59:59.997', 121)))
				) T

			 GROUP BY COMPANY_ID
					, DIVISION_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, OPERATION_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, LOSS_CODE
					, YYYYMMDD
					, YYYYMM
					, YYYY

			UNION ALL

			-- SCM_LOSS_M_SN
			SELECT LM.DIVISION_ID
				 , LM.COMPANY_ID				AS COMPANY_ID
				 , LM.SITE_ID					AS SITE_ID
				 , LM.PLANT_ID					AS PLANT_ID
				 , LM.FACTORY_ID				AS FACTORY_ID
				 , LM.LINE_ID					AS LINE_ID
				 , LM.ELECTRODE_TYPE			AS ELECTRODE_TYPE
				 , LM.OPERATION_ID				AS OPERATION_ID
				 , LU.LOSS_CODE					AS LOSS_CODE
				 , NULL							AS YYYYMMDD
				 , WORK_MONTH					AS YYYYMM
				 , NULL							AS YYYY
				 , ISNULL(ROUND(LOSS_RATE * 100 , 2),0)			AS ITEM_VALUE
			  FROM #TMP_SCP0054_LOOKUP LU

			  JOIN SCM_LOSS_VER_H_SN LM WITH(NOLOCK)  -- VERSION 테이블
				ON LM.LOSS_CODE		= LU.LOSS_CODE

			  JOIN #TMP_SCP0054_STD L WITH(NOLOCK)
				ON LM.DIVISION_ID		= L.DIVISION_ID
			   AND LM.COMPANY_ID		= L.COMPANY_ID
			   AND LM.SITE_ID			= L.SITE_ID
			   AND LM.PLANT_ID			= L.PLANT_ID
			   AND LM.FACTORY_ID		= L.FACTORY_ID
			   AND LM.OPERATION_ID		= L.OPERATION_ID
			   AND LM.LINE_ID			= L.LINE_ID
			   AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

			 WHERE 1 = 1
			   AND LM.VERSION_ID  = @p_version_id
			   AND LU.LOSS_CODE <> 'M08'
			   AND WORK_MONTH >=  @v_start_month
			   AND WORK_MONTH <=  @v_end_month
			   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
		END  --//월별 데이터 끝(CALENDAR , LOSS) 

		-- ///////////////////////////////////////////////////////////////////////////////
		-- TACT TIME(DAILY_CAPA) , YIELD 월별 데이터
		-- 계획 구간 데이터 ( VERSION 테이블 이용)
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			-- // TACT TIME(DAILY CAPA 포함) , DAILY CAPA 월별 데이터
			INSERT INTO #TMP_SCP0054_LTY
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, ITEM_ID
				, LANE_QTY
				, YYYYMMDD
				, YYYYMM
				, YYYY
				, ITEM_VALUE
			)
			SELECT TE.DIVISION_ID
				 , TE.COMPANY_ID		AS COMPANY_ID
				 , TE.SITE_ID			AS SITE_ID
				 , TE.PLANT_ID			AS PLANT_ID
				 , TE.FACTORY_ID		AS FACTORY_ID
				 , TE.LINE_ID			AS LINE_ID
				 , TE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
				 , TE.OPERATION_ID		AS OPERATION_ID
				 , 'LA002'				AS LOSS_CODE
				 , TE.ITEM_ID			AS ITEM_ID
				 , 0					AS LANE_QTY
				 , NULL					AS YYYYMMDD
				 , TE.MONTH				AS YYYYMM
				 , NULL					AS YYYY
				 , TE.TACT_TIME 		AS ITEM_VALUE
			  FROM SCM_TACT_TIME_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

			  JOIN #TMP_SCP0054_STD_ITEM_TACT I WITH(NOLOCK)
				ON TE.DIVISION_ID		= I.DIVISION_ID
			   AND TE.COMPANY_ID		= I.COMPANY_ID
			   AND TE.SITE_ID			= I.SITE_ID
			   AND TE.PLANT_ID			= I.PLANT_ID
			   AND TE.FACTORY_ID		= I.FACTORY_ID
			   AND TE.OPERATION_ID		= I.OPERATION_ID
			   AND TE.LINE_ID			= I.LINE_ID
			   AND TE.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
			   AND TE.ITEM_ID			= I.ITEM_ID

			  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)     -- 2020/11/18, khj79
			    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
			   AND LV.SEGMENT1 			= 'LA002'
			   AND TE.PLANT_ID			= LV.SEGMENT2
			   AND TE.OPERATION_ID		= LV.SEGMENT3
			   AND LV.ACTIVE_FLAG		= 'Y'

			 WHERE 1 = 1
			   AND TE.VERSION_ID  = @p_version_id
			   AND TE.MONTH >= @v_start_month
			   AND TE.MONTH <= @v_end_month
			   ;
		
			--// YIELD 월별 데이터
			INSERT INTO #TMP_SCP0054_LTY
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, ITEM_ID
				, LANE_QTY
				, YYYYMMDD
				, YYYYMM
				, YYYY
				, ITEM_VALUE
			)
			SELECT YE.DIVISION_ID
				 , YE.COMPANY_ID
				 , YE.SITE_ID
				 , YE.PLANT_ID
				 , YE.FACTORY_ID
				 , YE.LINE_ID
				 , '-'								AS ELECTRODE_TYPE
				 , YE.OPERATION_ID					AS OPERATION_ID
				 , 'LA003'							AS LOSS_CODE
				 , YE.ITEM_ID						AS ITEM_ID
				 , 0								AS LANE_QTY
				 , NULL								AS YYYYMMDD
				 , YE.MONTH							AS YYYYMM
				 , NULL								AS YYYY
				 , ROUND(YE.YIELD *100 , 2 )		AS ITEM_VALUE
			  FROM SCM_YIELD_VER_H_SN YE WITH(NOLOCK)  -- VERSION 테이블
			  JOIN #TMP_SCP0054_STD_ITEM_YIELD I WITH(NOLOCK)
				ON YE.DIVISION_ID		= I.DIVISION_ID
			   AND YE.COMPANY_ID		= I.COMPANY_ID
			   AND YE.SITE_ID			= I.SITE_ID
			   AND YE.PLANT_ID			= I.PLANT_ID
			   AND YE.FACTORY_ID		= I.FACTORY_ID
			   AND YE.OPERATION_ID		= I.OPERATION_ID
			   AND YE.LINE_ID			= I.LINE_ID
			   AND YE.ITEM_ID			= I.ITEM_ID

			 WHERE 1 = 1
			   AND YE.VERSION_ID  = @p_version_id
			   AND YE.MONTH >= @v_start_month
			   AND YE.MONTH <= @v_end_month
			   ;
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 기준 데이터를 기준으로 데이터 저장
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			INSERT INTO #TMP_SCP0054_ADD_STD
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, YYYYMMDD
				, YYYYMM
				, YYYY
				, ITEM_VALUE
			)
			SELECT DISTINCT X1.DIVISION_ID
					, X1.COMPANY_ID
					, X1.SITE_ID
					, X1.PLANT_ID
					, X1.FACTORY_ID
					, X1.LINE_ID
					, X1.ELECTRODE_TYPE
					, X1.OPERATION_ID
					, X1.LOSS_CODE
					, X1.YYYYMMDD
					, X1.YYYYMM
					, X1.YYYY
					, R.ITEM_VALUE
				 FROM (
						SELECT DISTINCT
							   R.DIVISION_ID
							 , R.COMPANY_ID
							 , R.SITE_ID
							 , R.PLANT_ID
							 , R.FACTORY_ID
							 , R.LINE_ID
							 , R.ELECTRODE_TYPE
							 , R.OPERATION_ID
							 , LU.LOSS_CODE
							 , R.YYYYMMDD
							 , R.YYYYMM
							 , R.YYYY
						  FROM (SELECT A.DIVISION_ID
									 , A.COMPANY_ID
									 , A.SITE_ID
									 , A.PLANT_ID
									 , A.FACTORY_ID
									 , A.LINE_ID
									 , A.ELECTRODE_TYPE
									 , A.OPERATION_ID
									 , B.YYYYMMDD
									 , B.YYYYMM
									 , B.YYYY
								  FROM #TMP_SCP0054_STD A
								  LEFT JOIN #TMP_SCP0054_MM B
									ON A.DIVISION_ID	= B.DIVISION_ID
								   AND A.COMPANY_ID		= B.COMPANY_ID
								   AND A.SITE_ID		= B.SITE_ID
								   AND A.PLANT_ID		= B.PLANT_ID
								   AND A.FACTORY_ID		= B.FACTORY_ID
								   AND A.LINE_ID		= B.LINE_ID
								   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								   AND A.OPERATION_ID	= B.OPERATION_ID
								) R  -- 기준 정보(LINE , OPERATION 등 정보 추가)
							  LEFT JOIN #TMP_SCP0054_LOOKUP LU
								ON 1=1
							 WHERE 1=1
							   AND LU.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
						) X1   -- LOOKUP 정보 추가
				 LEFT JOIN #TMP_SCP0054_MM R
				   ON R.DIVISION_ID		= X1.DIVISION_ID
				  AND R.COMPANY_ID		= X1.COMPANY_ID
				  AND R.SITE_ID			= X1.SITE_ID
				  AND R.PLANT_ID		= X1.PLANT_ID
				  AND R.FACTORY_ID		= X1.FACTORY_ID
				  AND R.LINE_ID			= X1.LINE_ID
				  AND R.ELECTRODE_TYPE	= X1.ELECTRODE_TYPE
				  AND R.OPERATION_ID	= X1.OPERATION_ID
				  AND R.LOSS_CODE		= X1.LOSS_CODE
				  AND ISNULL(R.YYYYMMDD,'-')	= ISNULL(X1.YYYYMMDD,'-')
				  AND ISNULL(R.YYYYMM,'-')		= ISNULL(X1.YYYYMM,'-')
				  AND ISNULL(R.YYYY,'-')		= ISNULL(X1.YYYY,'-')
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 화면 계산용 가상 LOSS 코드 추가
		-- PRODUCTION TOTAL , Model Mix(%) , Mixed TACT TIME , Mixed YIELD , 생산 CAPA , 생산 CAPA(IN) 
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			INSERT INTO #TMP_SCP0054_PRODUCTION
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, ITEM_ID
				, YYYYMM
				, ITEM_VALUE
			)
			SELECT DISTINCT
				  R.DIVISION_ID
				, R.COMPANY_ID
				, R.SITE_ID
				, R.PLANT_ID
				, R.FACTORY_ID
				, R.LINE_ID
				, '-'				AS ELECTRODE_TYPE
				, R.OPERATION_ID
				, X.LOSS_CODE
				, NULL				AS ITEM_ID
				, @v_start_month	AS YYYYMM    -- 조회 시작일자
				, 0					AS ITEM_VALUE
			 FROM #TMP_SCP0054_PRODUCTION R
			
			 LEFT JOIN ( SELECT LOSS_CODE
						   FROM #TMP_SCP0054_LOOKUP
						  WHERE LOSS_CODE LIKE 'XP%'
						    AND LOSS_CODE not in (  'XP001' , 'XP003')
						) X
					ON 1=1
			 WHERE R.LOSS_CODE = 'XP001'
			 


			---- Production Plan	TOTAL - 1 개의 ROW
			--SELECT DISTINCT
			--	  R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP002'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, @v_start_month    -- 조회 시작일자
			--	, 0					AS ITEM_VALUE 
			-- FROM #TMP_SCP0054_PRODUCTION R
			--WHERE R.LOSS_CODE = 'XP001'

			UNION ALL
			-- Model Mix(%) - ITEM 개수 ROW
			SELECT DISTINCT
				  R.DIVISION_ID
				, R.COMPANY_ID
				, R.SITE_ID
				, R.PLANT_ID
				, R.FACTORY_ID
				, R.LINE_ID
				, '-'				AS ELECTRODE_TYPE
				, R.OPERATION_ID
				, 'XP003'			AS LOSS_CODE
				, R.ITEM_ID			AS ITEM_ID
				, @v_start_month    -- 조회 시작일자
				, 0					AS ITEM_VALUE
			 FROM #TMP_SCP0054_PRODUCTION R
			WHERE R.LOSS_CODE = 'XP001'

			--UNION ALL
			----Mixed TACT TIME - 1 개의 ROW
			--SELECT DISTINCT
			--	  R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP004'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, @v_start_month    -- 조회 시작일자
			--	, 0					AS ITEM_VALUE 
			-- FROM #TMP_SCP0054_PRODUCTION R
			--WHERE R.LOSS_CODE = 'XP001'

			--UNION ALL
			---- Mixed YIELD - 1 개의 ROW
			--SELECT DISTINCT
			--	  R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP005'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, @v_start_month    -- 조회 시작일자
			--	, 0					AS ITEM_VALUE
			-- FROM #TMP_SCP0054_PRODUCTION R
			--WHERE R.LOSS_CODE = 'XP001'
		
			--UNION ALL
			---- 생산 CAPA - 1 개의 ROW
			--SELECT DISTINCT
			--	  R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP006'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, @v_start_month    -- 조회 시작일자
			--	, 0					AS ITEM_VALUE
			-- FROM #TMP_SCP0054_PRODUCTION R
			--WHERE R.LOSS_CODE = 'XP001'

			--UNION ALL
			---- 생산 CAPA(in) - 1 개의 ROW
			--SELECT DISTINCT
			--	  R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP007'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, @v_start_month    -- 조회 시작일자
			--	, 0					AS ITEM_VALUE
			-- FROM #TMP_SCP0054_PRODUCTION R
			--WHERE R.LOSS_CODE = 'XP001'

			------------------------------------------------------------------------------------ KHJ
			--UNION ALL
			--SELECT R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP008'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, R.YYYYMM			AS YYYYMM
			--	, MAX(ITEM_VALUE)	AS ITEM_VALUE
			-- FROM #TMP_SCP0054_LTY R
			--WHERE R.LOSS_CODE = 'LA002'  -- TACT TIME
			--GROUP BY R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, R.OPERATION_ID
			--	, R.YYYYMM

			--UNION ALL

			--SELECT R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, '-'				AS ELECTRODE_TYPE
			--	, R.OPERATION_ID
			--	, 'XP009'			AS LOSS_CODE
			--	, NULL				AS ITEM_ID
			--	, R.YYYYMM			AS YYYYMM
			--	, MIN(ITEM_VALUE)	AS ITEM_VALUE
			-- FROM #TMP_SCP0054_LTY R
			--WHERE R.LOSS_CODE = 'LA002'  -- TACT TIME
			--GROUP BY R.DIVISION_ID
			--	, R.COMPANY_ID
			--	, R.SITE_ID
			--	, R.PLANT_ID
			--	, R.FACTORY_ID
			--	, R.LINE_ID
			--	, R.OPERATION_ID
			--	, R.YYYYMM

			---------------------------------------------------------------------------------- KHJ
		END


		-- ///////////////////////////////////////////////////////////////////////////////
		-- 1. 데이터 합치기 - LOSS(CALENDAR , LOSS) , LTY , PRODUCTION
		-- 2. 계산을 위한 XA001(Working Day)  추가(조회월 추가) -월별 날짜가 다르다.
		-- 3. 화면 계산용 데이터 생성 ( 시작월만 추가)
		-- 4. 평균값 UPDATE
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			-- 1. 데이터 합치기 - LOSS(CALENDAR , LOSS) , LTY , PRODUCTION
			INSERT INTO #TMP_SCP0054_ALL
			(
				  DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, LOSS_CODE
				, ITEM_ID
				, LANE_QTY
				, YYYYMMDD
				, YYYYMM
				, YYYY
				, ITEM_VALUE
				, BEF_M6_RESULT
				, BEF_M5_RESULT
				, BEF_M4_RESULT
				, BEF_M3_RESULT
				, BEF_M2_RESULT
				, BEF_M1_RESULT
				, BEF_BEST_RESULT
				, BEF_WORST_RESULT
				)
				SELECT LK.DIVISION_ID
						, LK.COMPANY_ID
						, LK.SITE_ID
						, LK.PLANT_ID
						, LK.FACTORY_ID
						, LK.LINE_ID
						, LK.ELECTRODE_TYPE
						, LK.OPERATION_ID
						, LK.LOSS_CODE
						, '-'			AS ITEM_ID
						, NULL			AS LANE_QTY
						, LK.YYYYMMDD
						, LK.YYYYMM		AS YYYYMM
						, LK.YYYY		AS YYYY
						, LK.ITEM_VALUE
						, 0				AS BEF_M6_RESULT
						, 0				AS BEF_M5_RESULT
						, 0				AS BEF_M4_RESULT
						, 0				AS BEF_M3_RESULT
						, 0				AS BEF_M2_RESULT
						, 0				AS BEF_M1_RESULT
						, 0				AS BEF_BEST_RESULT
						, 0				AS BEF_WORST_RESULT
					FROM #TMP_SCP0054_ADD_STD LK

					UNION ALL

				   SELECT LTY.DIVISION_ID
						, LTY.COMPANY_ID
						, LTY.SITE_ID
						, LTY.PLANT_ID
						, LTY.FACTORY_ID
						, LTY.LINE_ID
						, LTY.ELECTRODE_TYPE
						, LTY.OPERATION_ID
						, LTY.LOSS_CODE
						, LTY.ITEM_ID
						, LTY.LANE_QTY
						, LTY.YYYYMMDD
						, LTY.YYYYMM
						, LTY.YYYY
						, LTY.ITEM_VALUE
						, 0				AS BEF_M6_RESULT
						, 0				AS BEF_M5_RESULT
						, 0				AS BEF_M4_RESULT
						, 0				AS BEF_M3_RESULT
						, 0				AS BEF_M2_RESULT
						, 0				AS BEF_M1_RESULT
						, 0				AS BEF_BEST_RESULT
						, 0				AS BEF_WORST_RESULT
					 FROM #TMP_SCP0054_LTY LTY


					  UNION ALL

					 SELECT DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, LOSS_CODE
						, ITEM_ID
						, LANE_QTY
						, YYYYMMDD
						, YYYYMM
						, YYYY
						, ITEM_VALUE
						, 0				AS BEF_M6_RESULT
						, 0				AS BEF_M5_RESULT
						, 0				AS BEF_M4_RESULT
						, 0				AS BEF_M3_RESULT
						, 0				AS BEF_M2_RESULT
						, 0				AS BEF_M1_RESULT
						, 0				AS BEF_BEST_RESULT
						, 0				AS BEF_WORST_RESULT
					 FROM #TMP_SCP0054_PRODUCTION

				;

				-- 2. 계산을 위한 XA001(Working Day)  추가(조회월 추가) -월별 날짜가 다르다.
				INSERT INTO #TMP_SCP0054_ALL
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, LOSS_CODE		, ITEM_ID
					, YYYYMMDD		, YYYYMM		, YYYY			
					, ITEM_VALUE
					, BEF_M6_RESULT	, BEF_M5_RESULT	, BEF_M4_RESULT	, BEF_M3_RESULT	, BEF_M2_RESULT
					, BEF_M1_RESULT
				)
				SELECT COMPANY_ID		, DIVISION_ID		, SITE_ID		, PLANT_ID	, FACTORY_ID
					 , OPERATION_ID		, LINE_ID			, ELECTRODE_TYPE, 'XA001'	, '-'
					 , NULL				, C1.BASIS_YYYYMM	, NULL
					 , CALENDAR_DAY		
					 , 0					, 0				, 0				, 0			, 0
					 , 0
				  FROM (
						SELECT DISTINCT
							   COMPANY_ID
							 , DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
					 		 , FACTORY_ID
					 		 , OPERATION_ID
					 		 , LINE_ID
					 		 , ELECTRODE_TYPE
					 		 , ITEM_ID
						  FROM #TMP_SCP0054_ALL A
						  JOIN #TMP_SCP0054_LOOKUP L
							ON A.LOSS_CODE = L.LOSS_CODE
						   AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
					  ) X
				  LEFT JOIN (SELECT BASIS_YYYYMM , MAX(CALENDAR_DAY) AS CALENDAR_DAY
							   FROM [SCM_SYS_CALENDAR_M] 
							  WHERE BASIS_YYYYMM  >= @v_start_month
								AND BASIS_YYYYMM  <= @v_end_month
							  GROUP BY BASIS_YYYYMM
						   ) C1
					ON 1=1

				-- 3. 화면 계산용 데이터 생성 ( 시작월만 추가)
				INSERT INTO #TMP_SCP0054_ALL
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, LOSS_CODE		, ITEM_ID
					, YYYYMMDD		, YYYYMM		, YYYY
					, ITEM_VALUE	
					, BEF_M6_RESULT	, BEF_M5_RESULT	, BEF_M4_RESULT	, BEF_M3_RESULT	, BEF_M2_RESULT
					, BEF_M1_RESULT
				)
				SELECT COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
					 , OPERATION_ID		, LINE_ID		, ELECTRODE_TYPE, LK.LOSS_CODE	, '-'
					 , YYYYMMDD			, YYYYMM		, YYYY
					 , 0				
					 , 0				, 0				, 0				, 0			, 0
					 , 0
				  FROM (
						SELECT DISTINCT
							   COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID	, FACTORY_ID
					 		 , OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, ITEM_ID	, YYYYMMDD
							 , YYYYMM		, YYYY
						  FROM #TMP_SCP0054_ALL A
						 WHERE LOSS_CODE = 'XA001'
						   AND YYYYMM = @v_start_month
						) A
					  LEFT JOIN #TMP_SCP0054_LOOKUP LK
						ON LK.DATA_TABLE = 'CAL'
					   AND LK.LOSS_CODE <> 'XA001'

		END

		-- 4. 평균값 UPDATE
		BEGIN
			UPDATE X
			   SET X.BEF_M6_RESULT = ISNULL(A.BEF_M6_RESULT,0)
				 , X.BEF_M5_RESULT = ISNULL(A.BEF_M5_RESULT,0)
				 , X.BEF_M4_RESULT = ISNULL(A.BEF_M4_RESULT,0)
				 , X.BEF_M3_RESULT = ISNULL(A.BEF_M3_RESULT,0)
				 , X.BEF_M2_RESULT = ISNULL(A.BEF_M2_RESULT,0)
				 , X.BEF_M1_RESULT = ISNULL(A.BEF_M1_RESULT,0)
			  FROM #TMP_SCP0054_ALL X
			  JOIN #TMP_SCP0054_AVG A
				ON A.DIVISION_ID	= X.DIVISION_ID
			   AND A.COMPANY_ID		= X.COMPANY_ID
			   AND A.SITE_ID		= X.SITE_ID
			   AND A.PLANT_ID		= X.PLANT_ID
			   AND A.FACTORY_ID		= X.FACTORY_ID
			   AND A.LINE_ID		= X.LINE_ID
			   AND ISNULL(A.ELECTRODE_TYPE,'-')	= ISNULL(X.ELECTRODE_TYPE,'-')
			   AND A.OPERATION_ID	= X.OPERATION_ID
			   AND A.LOSS_CODE		= X.LOSS_CODE
			   AND ISNULL(A.ITEM_ID,'-')	= ISNULL(X.ITEM_ID,'-')
			   ;
			
			-- Working Day UPDATE
			UPDATE X
			   SET X.BEF_M6_RESULT		= @v_bef_m6_count
				 , X.BEF_M5_RESULT		= @v_bef_m5_count
				 , X.BEF_M4_RESULT		= @v_bef_m4_count
				 , X.BEF_M3_RESULT		= @v_bef_m3_count
				 , X.BEF_M2_RESULT		= @v_bef_m2_count
				 , X.BEF_M1_RESULT		= @v_bef_m1_count
				 , X.BEF_BEST_RESULT	= @v_bef_max_count
				 , X.BEF_WORST_RESULT	= @v_bef_min_count
			  FROM #TMP_SCP0054_ALL X
			  WHERE LOSS_CODE = 'XA001'
			  ;


			  UPDATE X
			   SET X.BEF_BEST_RESULT = ISNULL(A.BEF_BEST_RESULT,0)
				 , X.BEF_WORST_RESULT = ISNULL(A.BEF_WORST_RESULT,0)
			  FROM #TMP_SCP0054_ALL X
			  JOIN #TMP_SCP0054_AVG_MIN_MAX A
				ON A.DIVISION_ID	= X.DIVISION_ID
			   AND A.COMPANY_ID		= X.COMPANY_ID
			   AND A.SITE_ID		= X.SITE_ID
			   AND A.PLANT_ID		= X.PLANT_ID
			   AND A.FACTORY_ID		= X.FACTORY_ID
			   AND A.LINE_ID		= X.LINE_ID
			   AND ISNULL(A.ELECTRODE_TYPE,'-')	= ISNULL(X.ELECTRODE_TYPE,'-')
			   AND A.OPERATION_ID	= X.OPERATION_ID
			   AND A.LOSS_CODE		= X.LOSS_CODE
			   AND ISNULL(A.ITEM_ID,'-')	= ISNULL(X.ITEM_ID,'-')
		END


		-- ///////////////////////////////////////////////////////////////////////////////
		-- LINE 정보를 조회
		-- YIELD 는 ELECTRODE TYPE 정보가 없기 때문에 YIELD 기준 정보 테이블에서 데이터 추가 함
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF OBJECT_ID('TEMPDB..#TMP_SCP0054_ALL_LINE') IS NOT NULL
				DROP TABLE #TMP_SCP0054_ALL_LINE;
			
			SELECT T1.DIVISION_ID
				 , T1.COMPANY_ID
				 , T1.SITE_ID
				 , ST.SITE_NAME
				 , T1.PLANT_ID
				 , T1.FACTORY_ID
				 , ST.FACTORY_NAME
				 , T1.LINE_ID
				 , ST.LINE_NAME
				 , T1.ELECTRODE_TYPE
				 , ST.OPERATION_GROUP_NAME
				 , T1.OPERATION_ID
				 , ST.OPERATION_NAME
				 , T1.LOSS_CODE
				 , T1.ITEM_ID
				 , SI.NICK_NAME
				 , T1.LANE_QTY
				 , T1.ITEM_VALUE
				 , T1.YYYYMMDD
				 , T1.YYYYMM
				 , T1.YYYY
				 , T1.BEF_M6_RESULT
				 , T1.BEF_M5_RESULT
				 , T1.BEF_M4_RESULT
				 , T1.BEF_M3_RESULT
				 , T1.BEF_M2_RESULT
				 , T1.BEF_M1_RESULT
				 , T1.BEF_BEST_RESULT
				 , T1.BEF_WORST_RESULT
			  INTO #TMP_SCP0054_ALL_LINE
			  FROM #TMP_SCP0054_ALL T1
			  LEFT JOIN #TMP_SCP0054_STD	ST WITH(NOLOCK)
				ON T1.COMPANY_ID		= ST.COMPANY_ID
			   AND T1.DIVISION_ID		= ST.DIVISION_ID
			   AND T1.SITE_ID			= ST.SITE_ID
			   AND T1.PLANT_ID			= ST.PLANT_ID
			   AND T1.FACTORY_ID		= ST.FACTORY_ID
			   AND T1.OPERATION_ID		= ST.OPERATION_ID
			   AND T1.LINE_ID			= ST.LINE_ID
			   AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE

			  LEFT JOIN #TMP_SCP0054_STD_ITEM_TACT SI WITH(NOLOCK)
				ON T1.COMPANY_ID		= SI.COMPANY_ID
			   AND T1.DIVISION_ID		= SI.DIVISION_ID
			   AND T1.SITE_ID			= SI.SITE_ID
			   AND T1.PLANT_ID			= SI.PLANT_ID
			   AND T1.FACTORY_ID		= SI.FACTORY_ID
			   AND T1.OPERATION_ID		= SI.OPERATION_ID
			   AND T1.LINE_ID			= SI.LINE_ID
			   AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE
			   AND T1.ITEM_ID 			= SI.ITEM_ID
			 WHERE T1.LOSS_CODE <> 'LA003'   -- YIELD 제외

			 UNION ALL

			 SELECT T1.DIVISION_ID
				 , T1.COMPANY_ID
				 , T1.SITE_ID
				 , SI.SITE_NAME
				 , T1.PLANT_ID
				 , T1.FACTORY_ID
				 , SI.FACTORY_NAME
				 , T1.LINE_ID
				 , SI.LINE_NAME
				 , ISNULL(T1.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE
				 , SI.OPERATION_GROUP_NAME
				 , T1.OPERATION_ID
				 , SI.OPERATION_NAME
				 , T1.LOSS_CODE
				 , T1.ITEM_ID
				 , SI.NICK_NAME
				 , T1.LANE_QTY
				 , T1.ITEM_VALUE
				 , T1.YYYYMMDD
				 , T1.YYYYMM
				 , T1.YYYY
				 , T1.BEF_M6_RESULT
				 , T1.BEF_M5_RESULT
				 , T1.BEF_M4_RESULT
				 , T1.BEF_M3_RESULT
				 , T1.BEF_M2_RESULT
				 , T1.BEF_M1_RESULT
				 , T1.BEF_BEST_RESULT
				 , T1.BEF_WORST_RESULT
			  FROM #TMP_SCP0054_ALL T1

			  LEFT JOIN #TMP_SCP0054_STD_ITEM_YIELD SI WITH(NOLOCK)
				ON T1.COMPANY_ID		= SI.COMPANY_ID
			   AND T1.DIVISION_ID		= SI.DIVISION_ID
			   AND T1.SITE_ID			= SI.SITE_ID
			   AND T1.PLANT_ID			= SI.PLANT_ID
			   AND T1.FACTORY_ID		= SI.FACTORY_ID
			   AND T1.OPERATION_ID		= SI.OPERATION_ID
			   AND T1.LINE_ID			= SI.LINE_ID
			   AND T1.ITEM_ID 			= SI.ITEM_ID

			 WHERE T1.LOSS_CODE = 'LA003'   -- YIELD
		END;


		-- ///////////////////////////////////////////////////////////////////////////////
		-- 기준정보별 부가정보 (담당자, operation, factory, line, site)
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			-- 임시 테이블 삭제
			IF OBJECT_ID('TEMPDB..#TMP_SCP0054_RESULT') IS NOT NULL
				DROP TABLE #TMP_SCP0054_RESULT;

				SELECT RL.DIVISION_ID
					 , RL.COMPANY_ID
					 , RL.SITE_ID
					 , RL.SITE_NAME
					 , RL.PLANT_ID
					 , RL.FACTORY_ID
					 , RL.FACTORY_NAME
					 , RL.LINE_ID
					 , RL.LINE_NAME
					 , RL.ELECTRODE_TYPE
					 , RL.OPERATION_GROUP_NAME
					 , RL.OPERATION_ID
					 , RL.OPERATION_NAME
					 , CASE WHEN RL.LOSS_CODE in ( 'LA002', 'LA999' ) THEN 'TACT TIME' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID
					 , CASE WHEN RL.LOSS_CODE IN ('LA002','LA003','XP001','XP003') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
					 , RL.LOSS_CODE
					 , RL.ITEM_ID
					 , RL.LANE_QTY
					 , ISNULL(M.DEPARTMENT, CASE WHEN RL.SITE_ID = 'A001' THEN C.DEPT_NAME_KO
												 WHEN RL.SITE_ID = 'A002' THEN C.DEPT_NAME_CN
											ELSE DEPT_NAME_EN	
									END) AS DEPARTMENT
					 , M.USER_ID_1									AS USER_ID_1
					 , C.USER_NAME									AS MANAGER
					 , M.USER_ID_2									AS USER_ID_2
					 , M.USER_ID_3									AS USER_ID_3
					 , M.USER_ID_4									AS USER_ID_4
					 , M.USER_ID_5									AS USER_ID_5
					 , M.USER_ID_6									AS USER_ID_6
					 , M.USER_ID_7									AS USER_ID_7
					 , M.USER_ID_8									AS USER_ID_8
					 , M.USER_ID_8									AS USER_ID_9
					 , M.USER_ID_10									AS USER_ID_10
					 , 'D_' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD
					 , 'M_' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM
					 , 'Y_' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY
					 , RL.ITEM_VALUE
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
					   END AS BEF_M6_RESULT
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
					   END AS BEF_M5_RESULT
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
					   END AS BEF_M4_RESULT
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
					   END AS BEF_M3_RESULT
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
					   END AS BEF_M2_RESULT
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
					   END AS BEF_M1_RESULT
					 , RL.BEF_BEST_RESULT
					 , RL.BEF_WORST_RESULT
					 , SORT_ORDER
					 , CASE WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = 'TACT TIME' THEN LK.UOM ELSE 'EA' END AS UOM
				  INTO #TMP_SCP0054_RESULT
				  FROM #TMP_SCP0054_ALL_LINE RL
				  LEFT JOIN (SELECT   LU.*
									, LV.SEGMENT2 		AS PLANT_ID
									, LV.SEGMENT3 		AS OPERATION_ID
									, LV.ATTRIBUTE1 	AS CATEGORY_2
							   FROM #TMP_SCP0054_LOOKUP LU
							   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV
								 ON 	1=1
								AND 	LV.LOOKUP_TYPE_CODE = 'CAPA_UI_CAPA_DEFINIT'
								AND 	LU.LOSS_CODE = LV.SEGMENT1
								AND 	LV.ACTIVE_FLAG = 'Y') LK    -- 공정별 CAPA 보완
					ON RL.LOSS_CODE			= LK.LOSS_CODE
				   AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.PLANT_ID ELSE RL.PLANT_ID END
				   AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END

				  LEFT JOIN SCM_MASTER_MANAGER_VER_H_SN M WITH(NOLOCK) --기준정보별 담당자 정보
					ON RL.COMPANY_ID		= M.COMPANY_ID
				   AND RL.DIVISION_ID		= M.DIVISION_ID
				   AND RL.SITE_ID			= M.SITE_ID
				   AND RL.PLANT_ID			= M.PLANT_ID
				   AND RL.FACTORY_ID		= M.FACTORY_ID
				   AND RL.OPERATION_ID		= M.OPERATION_ID
				   AND RL.LINE_ID			= M.LINE_ID
				   AND RL.ELECTRODE_TYPE	= M.ELECTRODE_TYPE
				   AND RL.LOSS_CODE			= M.LOSS_CODE
				   AND M.VERSION_ID			= @p_version_id

				  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
							  FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
								 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
							 WHERE 1=1
							   AND A.DEPT_ID = B.DEPT_ID
							) C
				   ON 1 = 1
				  AND M.USER_ID_1 = C.USER_ID
		END

		-- /////////////////////////// PIVOT 처리를 위한 SUM QUERY 생성
		BEGIN
			SET @MQRY_SUM = '';
			
			SELECT @MQRY_SUM = @MQRY_SUM+','+ CASE	WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYYMM   = RIGHT('''+YYYYMMDD+''',8)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
													WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYY     = RIGHT('''+YYYYMMDD+''',6)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
										END +''+  CHAR(10)
			 FROM ( 
					SELECT 'M_'+A.BASIS_YYYYMM  AS YYYYMMDD
						 , CONVERT(CHAR(2), '20') + MIN(A.BASIS_START_DATE)  AS SORT_ORDER_NO
					  FROM [DBO].[SCM_SYS_CALENDAR_M] A
					 WHERE A.BASIS_YYYYMM  >= @v_start_month
					   AND A.BASIS_YYYYMM  <= @v_end_month
					 GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
				
					 UNION ALL
		
					SELECT 'Y_' + A.CALENDAR_YYYY 
						 , CONVERT(CHAR(2), '30') + MIN(A.BASIS_END_DATE)   AS SORT_ORDER_NO
					  FROM [DBO].[SCM_SYS_CALENDAR_M] A
					 WHERE A.CALENDAR_YYYY  >= '9999'
					   AND A.CALENDAR_YYYY  <= '9999'
					   GROUP BY A.CALENDAR_YYYY
					) AS A
			ORDER BY SORT_ORDER_NO;
		END

		--IF OBJECT_ID('TEMPDB..##TMP_SCP0054_LAST') IS NOT NULL
		--	DROP TABLE ##TMP_SCP0054_LAST;

		SET @MEXEC = '';
		
		SET @MEXEC = @MEXEC+'	;WITH CTE_SCP0054_ALL_LINE AS (																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				SELECT T1.DIVISION_ID																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.COMPANY_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.SITE_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ST.SITE_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.PLANT_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.FACTORY_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ST.FACTORY_NAME																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LINE_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ST.LINE_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.ELECTRODE_TYPE																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ST.OPERATION_GROUP_NAME																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.OPERATION_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ST.OPERATION_NAME																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LOSS_CODE																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.ITEM_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.NICK_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LANE_QTY																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.ITEM_VALUE																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYYMMDD																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYYMM																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYY																																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M6_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M5_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M4_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M3_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M2_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M1_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_BEST_RESULT																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_WORST_RESULT																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  FROM #TMP_SCP0054_ALL T1																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  LEFT JOIN #TMP_SCP0054_STD	ST WITH(NOLOCK)																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				ON T1.COMPANY_ID		= ST.COMPANY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.DIVISION_ID		= ST.DIVISION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.SITE_ID			= ST.SITE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.PLANT_ID			= ST.PLANT_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.FACTORY_ID		= ST.FACTORY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.OPERATION_ID		= ST.OPERATION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.LINE_ID			= ST.LINE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE																									' + CHAR(10);

		SET @MEXEC = @MEXEC+'			  LEFT JOIN #TMP_SCP0054_STD_ITEM_TACT SI WITH(NOLOCK)																							' + CHAR(10);
		SET @MEXEC = @MEXEC+'				ON T1.COMPANY_ID		= SI.COMPANY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.DIVISION_ID		= SI.DIVISION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.SITE_ID			= SI.SITE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.PLANT_ID			= SI.PLANT_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.FACTORY_ID		= SI.FACTORY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.OPERATION_ID		= SI.OPERATION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.LINE_ID			= SI.LINE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.ITEM_ID 			= SI.ITEM_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 WHERE T1.LOSS_CODE <> ''LA003''   																												' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 UNION ALL																																		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 SELECT T1.DIVISION_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.COMPANY_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.SITE_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.SITE_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.PLANT_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.FACTORY_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.FACTORY_NAME																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LINE_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.LINE_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , ISNULL(T1.ELECTRODE_TYPE,''-'') AS ELECTRODE_TYPE																							' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.OPERATION_GROUP_NAME																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.OPERATION_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.OPERATION_NAME																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LOSS_CODE																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.ITEM_ID																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , SI.NICK_NAME																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.LANE_QTY																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.ITEM_VALUE																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYYMMDD																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYYMM																																' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.YYYY																																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M6_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M5_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M4_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M3_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M2_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_M1_RESULT																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_BEST_RESULT																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'				 , T1.BEF_WORST_RESULT																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  FROM #TMP_SCP0054_ALL T1																														' + CHAR(10);

		SET @MEXEC = @MEXEC+'			  LEFT JOIN #TMP_SCP0054_STD_ITEM_YIELD SI WITH(NOLOCK)																							' + CHAR(10);
		SET @MEXEC = @MEXEC+'				ON T1.COMPANY_ID		= SI.COMPANY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.DIVISION_ID		= SI.DIVISION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.SITE_ID			= SI.SITE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.PLANT_ID			= SI.PLANT_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.FACTORY_ID		= SI.FACTORY_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.OPERATION_ID		= SI.OPERATION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.LINE_ID			= SI.LINE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   AND T1.ITEM_ID 			= SI.ITEM_ID																									' + CHAR(10);

		SET @MEXEC = @MEXEC+'			 WHERE T1.LOSS_CODE = ''LA003''  																												' + CHAR(10);
		SET @MEXEC = @MEXEC+'	),																																						' + CHAR(10);

		SET @MEXEC = @MEXEC+'	CTE_SCP0054_RESULT AS (																																	' + CHAR(10);
		SET @MEXEC = @MEXEC+'				SELECT RL.DIVISION_ID																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.COMPANY_ID																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.SITE_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.SITE_NAME																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.PLANT_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.FACTORY_ID																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.FACTORY_NAME																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LINE_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LINE_NAME																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ELECTRODE_TYPE																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_GROUP_NAME																												' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_ID																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_NAME																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN RL.LOSS_CODE in ( ''LA002'', ''LA999'' ) THEN ''TACT TIME'' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID	' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN RL.LOSS_CODE IN (''LA002'',''LA003'',''XP001'',''XP003'') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID							' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LOSS_CODE																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ITEM_ID																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LANE_QTY																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ISNULL(M.DEPARTMENT, CASE WHEN RL.SITE_ID = ''A001'' THEN C.DEPT_NAME_KO																' + CHAR(10);
		SET @MEXEC = @MEXEC+'												 WHEN RL.SITE_ID = ''A002'' THEN C.DEPT_NAME_CN																' + CHAR(10);
		SET @MEXEC = @MEXEC+'											ELSE DEPT_NAME_EN																								' + CHAR(10);
		SET @MEXEC = @MEXEC+'									END) AS DEPARTMENT																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_1									AS USER_ID_1																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , C.USER_NAME									AS MANAGER																				' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_2									AS USER_ID_2																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_3									AS USER_ID_3																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_4									AS USER_ID_4																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_5									AS USER_ID_5																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_6									AS USER_ID_6																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_7									AS USER_ID_7																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_8									AS USER_ID_8																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_8									AS USER_ID_9																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , M.USER_ID_10									AS USER_ID_10																			' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''D_'' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''M_'' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''Y_'' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY																						' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ITEM_VALUE																														' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M6_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M5_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M4_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M3_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M2_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M1_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_BEST_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_WORST_RESULT																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , SORT_ORDER																															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = ''TACT TIME'' THEN LK.UOM ELSE ''EA'' END AS UOM										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				  FROM 																														  ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				  /*#TMP_SCP0054_ALL_LINE RL*/																												' + CHAR(10);
		SET @MEXEC = @MEXEC+'				  CTE_SCP0054_ALL_LINE RL																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'				  LEFT JOIN (SELECT   LU.*																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'									, LV.SEGMENT2 		AS PLANT_ID																							' + CHAR(10);
		SET @MEXEC = @MEXEC+'									, LV.SEGMENT3 		AS OPERATION_ID																						' + CHAR(10);
		SET @MEXEC = @MEXEC+'									, LV.ATTRIBUTE1 	AS CATEGORY_2																						' + CHAR(10);
		SET @MEXEC = @MEXEC+'							   FROM #TMP_SCP0054_LOOKUP LU																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'							   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV																					' + CHAR(10);
		SET @MEXEC = @MEXEC+'								 ON 	1=1																													' + CHAR(10);
		SET @MEXEC = @MEXEC+'								AND 	LV.LOOKUP_TYPE_CODE = ''CAPA_UI_CAPA_DEFINIT''																		' + CHAR(10);
		SET @MEXEC = @MEXEC+'								AND 	LU.LOSS_CODE = LV.SEGMENT1																							' + CHAR(10);
		SET @MEXEC = @MEXEC+'								AND 	LV.ACTIVE_FLAG = ''Y'') LK																		' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ON RL.LOSS_CODE			= LK.LOSS_CODE																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = ''LA002'' THEN LK.PLANT_ID ELSE RL.PLANT_ID END										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = ''LA002'' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END								' + CHAR(10);

		SET @MEXEC = @MEXEC+'				  LEFT JOIN SCM_MASTER_MANAGER_VER_H_SN M WITH(NOLOCK)															' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ON RL.COMPANY_ID		= M.COMPANY_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.DIVISION_ID		= M.DIVISION_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.SITE_ID			= M.SITE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.PLANT_ID			= M.PLANT_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.FACTORY_ID		= M.FACTORY_ID																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.OPERATION_ID		= M.OPERATION_ID																								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.LINE_ID			= M.LINE_ID																										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.ELECTRODE_TYPE	= M.ELECTRODE_TYPE																								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND RL.LOSS_CODE			= M.LOSS_CODE																									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   AND M.VERSION_ID			= ' + CHAR(10); 


		--SET @MEXEC = @MEXEC+   ''''  + CHAR(10);
		--SET @MEXEC = @MEXEC+   @p_version_id  + CHAR(10);
		--SET @MEXEC = @MEXEC+   ''''  + CHAR(10);
		
		SET @MEXEC2 = '';
		SET @MEXEC2 = @MEXEC2+'				  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'							  FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)																						' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'								 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)																						' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'							 WHERE 1=1																														' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'							   AND A.DEPT_ID = B.DEPT_ID																									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'							) C																																' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				   ON 1 = 1																	' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				  AND M.USER_ID_1 = C.USER_ID												' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'	)		' + CHAR(10);
		
		SET @MEXEC2 = @MEXEC2+'	SELECT														' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			  R.DIVISION_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.COMPANY_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.SITE_ID											' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.SITE_NAME										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.PLANT_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.FACTORY_ID 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.FACTORY_NAME  									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.LINE_ID 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.LINE_NAME 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.ELECTRODE_TYPE 									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.OPERATION_GROUP_NAME 							' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.OPERATION_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.OPERATION_NAME									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.CATEGORY_ID 									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.KEY_ID 											' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.LOSS_CODE 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.ITEM_ID 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CASE WHEN  R.LOSS_CODE = ''LA001'' THEN CONVERT(NVARCHAR(10),R.LANE_QTY) ELSE ''-'' END AS LANE_QTY	' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.DEPARTMENT										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_1										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_2										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_3										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_4										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_5										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_6										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_7										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_8										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_9										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.USER_ID_10										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, R.MANAGER											' + CHAR(10);
		
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M6_RESULT))	AS BEF_M6_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M5_RESULT))	AS BEF_M5_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M4_RESULT))	AS BEF_M4_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M3_RESULT))	AS BEF_M3_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M2_RESULT))	AS BEF_M2_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CONVERT(NVARCHAR(10),MAX(R.BEF_M1_RESULT))	AS BEF_M1_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, MAX(R.BEF_BEST_RESULT)						AS BEF_BEST_RESULT		' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, MAX(R.BEF_WORST_RESULT)						AS BEF_WORST_RESULT		' + CHAR(10);
		
		SET @MEXEC2 = @MEXEC2+'			, R.UOM												' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, LK.DATA_TABLE										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, LK.CATEGORY_ORDER									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, LK.SORT_ORDER										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'			, CASE WHEN R.ELECTRODE_TYPE =''-'' THEN ''ZZ'' ELSE R.ELECTRODE_TYPE END  AS ELECTRODE_ORDER	' + CHAR(10); --  YIELD 는 ELECTRODE_TYPE 이 없기 때문에 정열을 위한 컬럼
		SET @MEXEC2 = @MEXEC2+'			' + @MQRY_SUM										  + CHAR(10);
		--SET @MEXEC2 = @MEXEC2+'		 INTO ##TMP_SCP0054_LAST								' + CHAR(10); -- 결과 테이블 저장
		--SET @MEXEC2 = @MEXEC2+'		 FROM #TMP_SCP0054_RESULT	R							' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'		 FROM CTE_SCP0054_RESULT	R							' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'		 JOIN #TMP_SCP0054_LOOKUP	LK							' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'		   ON R.LOSS_CODE	= LK.LOSS_CODE						' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'		GROUP BY  R.DIVISION_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.COMPANY_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.SITE_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.SITE_NAME									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.PLANT_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.FACTORY_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.FACTORY_NAME								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.LINE_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.LINE_NAME									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.ELECTRODE_TYPE								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.OPERATION_GROUP_NAME 						' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.OPERATION_ID								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.OPERATION_NAME								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.CATEGORY_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.KEY_ID 										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.LOSS_CODE 									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.ITEM_ID 									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.LANE_QTY 									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.DEPARTMENT									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.MANAGER										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_1									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_2									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_3									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_4									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_5									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_6									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_7									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_8									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_9									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.USER_ID_10									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.UOM											' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, LK.DATA_TABLE									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, LK.CATEGORY_ORDER								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, LK.SORT_ORDER									' + CHAR(10);

		
		SET @MEXEC2 = @MEXEC2+'		ORDER BY  R.DIVISION_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.COMPANY_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.SITE_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.PLANT_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.FACTORY_ID									' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.LINE_ID										' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.OPERATION_ID	DESC						' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, R.ELECTRODE_TYPE								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, LK.CATEGORY_ORDER								' + CHAR(10);
		SET @MEXEC2 = @MEXEC2+'				, LK.SORT_ORDER									' + CHAR(10);

		IF( @debug_mode ='T')
			BEGIN				
				DECLARE @POS INT =1;
				DECLARE @LEN INT =LEN(@MEXEC);
				WHILE @POS <= @LEN
					BEGIN
						PRINT SUBSTRING(@MEXEC,@POS,4000);
						SET @POS = @POS+4000;
					END;
			END;

		EXEC(@MEXEC + '''' + @p_version_id + '''' + @MEXEC2);

	END -- END OF VERSION_ID
END

--/* ============================ 테이블 확인 ============================== */
---- 공통 LOOKUP 테이블
----SELECT * FROM #TMP_SCP0054_LOOKUP

---- 결과 테이블 
----SELECT * FROM ##TMP_SCP0054_LAST WHERE LOSS_CODE = 'LA001'
----SELECT * FROM ##TMP_SCP0054_LAST ORDER BY DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID, CATEGORY_ORDER, SORT_ORDER


