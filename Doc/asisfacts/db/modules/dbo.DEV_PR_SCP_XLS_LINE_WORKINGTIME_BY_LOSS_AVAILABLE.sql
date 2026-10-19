  
/*      
 * Program ID   : PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE        
 * Description  : PR_SCP_XLS_ADD_XLSPSI01_S 에서 호출함.      
 * OutTable     :      
 * Execute      : 

    EXEC PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE
                                 @p_plan_start_yyyymmdd = '20190107'
                               , @p_division_id         = '81'

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2022.09.19   KSW         시뮬레이터에서 생산계획을 일배분하기 위한 CAPA 워킹타임 Available 반환  
 * 2023.10.23   OIJ         SN테이블에 COMPANY와 DIVISION_ID정보를 활용하도록 수정(인덱스 활용을 위함)
 * 2024.06.18   KSK         시뮬레이터의 로컬기준정보 처리를 위하여 전체 라인정보와 오퍼레이션을 반환하도록 처
 */    
 --DROP PROC PR_SCP_XLS_BOH
 CREATE PROCEDURE [dbo].[DEV_PR_SCP_XLS_LINE_WORKINGTIME_BY_LOSS_AVAILABLE]
(              
      @p_plan_start_yyyymmdd	NVARCHAR(0008)               
    , @p_division_id			NVARCHAR(0030)    
)       
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      

	declare @p_to_yyyymmdd			NVARCHAR(8) = '';

	-------------------------------------------------------------------------------------------------------------
	-- PLAN 기간설정 - 2021.11.19
	-------------------------------------------------------------------------------------------------------------
	DECLARE @v_bp_flag		NVARCHAR(8) = '';

	SELECT @p_to_yyyymmdd = p.horizon_end_date,
			@v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
	AND    p.plan_cycle  = 'WEEKLY' 
	;	

	IF @v_bp_flag = 'Y'
	BEGIN
		-- 중장기일 경우 104주차로 변경
		SET @p_to_yyyymmdd = CONVERT(VARCHAR(8), DATEADD(day, 363, (CONVERT(VARCHAR(8), DATEADD(day, 364, @p_plan_start_yyyymmdd), 112))), 112);
	END


	declare @p_today_yyyymmdd		NVARCHAR(8) = @p_plan_start_yyyymmdd;
	declare @p_check_loss			CHAR(1) = 'Y';
	declare @p_from_yyyymm			NVARCHAR(6) = LEFT(@p_plan_start_yyyymmdd, 6);
	declare @p_to_yyyymm			NVARCHAR(6) = LEFT(@p_to_yyyymmdd, 6);
	declare @p_version_id			NVARCHAR(20) = 'Current';
	declare @p_user_auth			NVARCHAR(30) = 'Admin';
	--declare 
	

	-- 쿼리 실행용 변수;
	DECLARE @MEXEC		NVARCHAR(MAX);
	DECLARE @MQRY_SUM	NVARCHAR(MAX);
    DECLARE @DYNAMIC_PIVOT_COL_PARENT	NVARCHAR(MAX);      -- 2021-10-12 ParkSungchool 부모쿼리 만들기 부분

	-- 날짜 조건용 변수 설정
	DECLARE @v_start_day		NVARCHAR(8);	--시작 일자(현재 달)
	DECLARE @v_end_day			NVARCHAR(8);	--마지막 일자
	DECLARE @v_start_month		NVARCHAR(6);	--시작 월(현재월 +1 년)
	DECLARE @v_end_month		NVARCHAR(6);	--마지막 월

	DECLARE @v_start_avg		NVARCHAR(6);	--과거 시작 월
	DECLARE @v_end_avg			NVARCHAR(6);	--과거 마지막 월
	DECLARE @v_start_result_avg	NVARCHAR(6);	--과거 시작 월(과거 테이블 조회)
	DECLARE @v_end_result_avg	NVARCHAR(6);	--과거 마지막 월(과거 테이블 조회)
	DECLARE @v_result_month		INT = 2;		--과거 데이터 조회 월		

	DECLARE @v_result_table_month NVARCHAR(8) = CONVERT(VARCHAR(8) , DATEADD(MM, -@v_result_month  ,@p_today_yyyymmdd),112); -- 이력 테이블 조회 기준 월

	DECLARE @v_start_year		NVARCHAR(4);	--시작 연도(현재년 +1)
	DECLARE @v_end_year			NVARCHAR(4);	--마지막 년도(현재년+3)

	-- 월 조회 개월 수
	DECLARE @v_month_cnt		INT;

	DECLARE @v_check_daily		CHAR(1) = 'N';
	
	-- 평균 계산용 변수 설정
	DECLARE @v_bef_m6_count		INT;  -- 현재월 -6 해당월의 날짜 수
	DECLARE @v_bef_m5_count		INT;  -- 현재월 -5 해당월의 날짜 수
	DECLARE @v_bef_m4_count		INT;  -- 현재월 -4 해당월의 날짜 수
	DECLARE @v_bef_m3_count		INT;  -- 현재월 -3 해당월의 날짜 수
	DECLARE @v_bef_m2_count		INT;  -- 현재월 -2 해당월의 날짜 수
	DECLARE @v_bef_m1_count		INT;  -- 현재월 -1 해당월의 날짜 수
	DECLARE @v_bef_max_count	INT;  -- 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 큰 값(BEST,WORST)
	DECLARE @v_bef_min_count	INT;  -- 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 작은 값(BEST,WORST)

	DECLARE @v_bef_m6_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-6 ,@p_today_yyyymmdd),112);
	DECLARE @v_bef_m5_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-5 ,@p_today_yyyymmdd),112);
	DECLARE @v_bef_m4_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-4 ,@p_today_yyyymmdd),112);
	DECLARE @v_bef_m3_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-3 ,@p_today_yyyymmdd),112);
	DECLARE @v_bef_m2_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-2 ,@p_today_yyyymmdd),112);
	DECLARE @v_bef_m1_yyyymm NVARCHAR(6) = CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_today_yyyymmdd),112);
	
	-- 해당 월에 마지막일자(날짜 수 )를 구한다(평균데이터를 구하는 곳 사용)
	SELECT @v_bef_m6_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m6_yyyymm;

	 SELECT @v_bef_m5_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m5_yyyymm;

	 SELECT @v_bef_m4_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m4_yyyymm;

	SELECT @v_bef_m3_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m3_yyyymm;

	SELECT @v_bef_m2_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m2_yyyymm;

	SELECT @v_bef_m1_count = CONVERT(INT,MAX(CALENDAR_DAY))
	  FROM SCM_SYS_CALENDAR_M
	 WHERE BASIS_YYYYMM = @v_bef_m1_yyyymm;

	-- ////////////////////////////////////////////////////////////////
	-- 조회 날짜 설정
	-- ////////////////////////////////////////////////////////////////
	-- 기준일 Y+1 까지만 월 조회 가능 그후는 년도 조회

    DECLARE @v_max_day NVARCHAR(8) = CONVERT(NVARCHAR(4),DATEADD(YY,3, @p_today_yyyymmdd ),112) + '1231'; -- 3년 조회 변경 ( 2 => 3)
       



	-- 기준일 Y+1 년 과 조회 마지막 일자를 비교하여 조회일 설정
	IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
	BEGIN
		SET @v_start_day	= CONVERT(NVARCHAR(6), @p_today_yyyymmdd) + '01';  -- 조회 Period 시작 일
		SET @v_end_day		= CONVERT(NVARCHAR(6), @v_max_day,112) + '31';  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
		SET @v_start_month	= CONVERT(NVARCHAR(6), @p_today_yyyymmdd); -- 현재일 
		SET @v_end_month	= CONVERT(NVARCHAR(6), @v_max_day,112);  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
	END
	ELSE
	BEGIN
		-- 조회일자가 기준을 넘지 않을 경우 파라미터로 설정
		SET @v_start_day	= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd) + '01'; -- 현재 일자
		SET @v_end_day		= @p_to_yyyymm + '31';							-- 조회 Period 마지막 일
		SET @v_start_month	= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd);
		SET @v_end_month	= @p_to_yyyymm;
	END

	
	-- 기준일 Y+1 까지만 월 조회 가능 그후는 년도 조회
	IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
	BEGIN
		SET @v_start_year = CONVERT(NVARCHAR(4), DATEADD(YY,3, @p_today_yyyymmdd) , 112) ;   -- 3년 조회 변경 ( 3 => 4)
		SET @v_end_year   = CONVERT(NVARCHAR(4), @p_to_yyyymm) ;
	END
	ELSE
		BEGIN
			SET @v_start_year = '9999';
			SET @v_end_year   = '9999';	
		END
	
	-- 과거 조회 일자 설정
	IF @p_from_yyyymm < @v_result_table_month
		BEGIN
			-- 이력 테이블 조회
			SET @v_start_result_avg = @p_from_yyyymm;
			SET @v_end_result_avg	= @v_result_table_month

			SET @v_start_avg		= CONVERT(VARCHAR(6) , DATEADD(MM,1 ,@v_result_table_month),112) ; -- 현재월 -1@v_result_table_month
			SET @v_end_avg			= CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_today_yyyymmdd),112) ; -- 현재월 -1
		END
	ELSE
		BEGIN
			-- 이력 테이블 조회 하지 않는다.
			SET @v_start_result_avg = @p_to_yyyymm;
			SET @v_end_result_avg	= @p_from_yyyymm;
			SET @v_start_avg		= @p_from_yyyymm;  -- 조회 시작 월
			SET @v_end_avg			= CONVERT(VARCHAR(6) , DATEADD(MM,-1 ,@p_today_yyyymmdd),112) ; -- 현재월 -1
		END

	-- 버전별 division, op group 설정
	DECLARE @v_ver_division_id	NVARCHAR(20);
	
	BEGIN --VERSION GROUP 정보
		SELECT @v_ver_division_id = CASE WHEN @p_version_id = 'Current' THEN NULL ELSE B.ATTRIBUTE1 END
		
		  FROM SCM_MASTER_VERSION_INFO_H_SN A,
			   SCM_SYS_LOOKUP_VALUE_SN B
		 WHERE 1=1		
		   AND LOOKUP_TYPE_CODE = 'MASTER_DATA_DIVISION_SYSTEM'
		   AND A.DIVISION_ID 	= B.SEGMENT2
		   AND A.VERSION_ID 	= @p_version_id
	END	

	-- LOSS LOOKUP 정보 조회
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LOOKUP') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LOOKUP;
				
		SELECT SEGMENT1		AS LOSS_CODE -- LOSS_CODE  설명
			 , ATTRIBUTE1	AS CATEGORY_ID
			 , ATTRIBUTE2	AS KEY_ID
			 , ATTRIBUTE3	AS DATA_TABLE
			 , CONVERT(NUMERIC(20,10),ATTRIBUTE8) AS CATEGORY_ORDER
			 , ATTRIBUTE9	AS UOM
			 , ISNULL(ATTRIBUTE7,'N')	AS EDITORBLE_YN
			 , SORT_ORDER
		 INTO #TMP_SCP0049_LOOKUP
		 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
		WHERE 1=1
		  AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
		  AND ACTIVE_FLAG = 'Y'
		  --AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('Admin','SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회
		  AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('Admin','SCP Planner', 'CAPA Planner' ,'SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회
		  AND LV.SEGMENT1 IN ('XA001', 'EL001', 'EL002')
	END	
	 --SELECT  '#TMP_SCP0049_LOOKUP' TN, * FROM #TMP_SCP0049_LOOKUP 

	 SELECT @v_bef_max_count = MAX(CALENDAR_DAY)
	      , @v_bef_min_count = MIN(CALENDAR_DAY)
      FROM (
			SELECT BASIS_YYYYMM , CONVERT(INT,MAX(CALENDAR_DAY)) CALENDAR_DAY
			  FROM SCM_SYS_CALENDAR_M
			 WHERE BASIS_YYYYMM >= @p_from_yyyymm -- 조회 시작 월
			   AND BASIS_YYYYMM <= @v_end_avg
			 GROUP BY BASIS_YYYYMM
			) A ;

	-- Empty Value 용 변수 설정(조회 시작월 ~ 종료월의 개수)
	SET @v_month_cnt = DATEDIFF(MM , @v_start_month + '01' , @v_end_month + '01') + 1;
	
		IF OBJECT_ID('TEMPDB..#TMP_PSI_GLOBAL') IS NOT NULL
			DROP TABLE #TMP_PSI_GLOBAL;

		SELECT  DISTINCT DIVISION_ID, PROD_LINE, ATTRIBUTE9 AS OPERATION_ID
		INTO #TMP_PSI_GLOBAL
		FROM SCP_XLS_PSI_GLOBAL   G WITH (NOLOCK) 
		WHERE MEASURE IN ('PACK_PROD', 'CELL_PROD')

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD;

		SELECT DISTINCT
			   DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , SITE_NAME
			 , PLANT_ID
			 , OPERATION_GROUP_ID
			 , OPERATION_GROUP AS OPERATION_GROUP_NAME 
			 , FACTORY_ID
			 , FACTORY_NAME
			 , A.OPERATION_ID
			 , OPERATION_NAME
			 , LINE_ID
			 , LINE_NAME
			 , ELECTRODE_TYPE
		  INTO #TMP_SCP0049_STD 
		  FROM SCM_LINE_HIERARCHY_V_SN A
		 WHERE 1=1
		  AND EXISTS(SELECT  1 FROM #TMP_PSI_GLOBAL   G WITH (NOLOCK) 
		  				    WHERE A.DIVISION_ID = G.DIVISION_ID 
							AND A.LINE_ID = G.PROD_LINE  
							AND A.OPERATION_ID = G.OPERATION_ID)
	
	-- ///////////////////////////////////////////////////////////////////////////////////
	-- 테이블 생성
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		-- 과거 데이터를 저장하는 테이블
		-- 현재월 기준 - 6 개월 저장
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG_DATA') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG_DATA;

		CREATE TABLE #TMP_SCP0049_AVG_DATA
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
			, ITEM_VALUE			NUMERIC(10,3)
			, ITEM_VALUE_RESULT		NUMERIC(10,3)
		)

		-- 과거 데이터를 월별(컬럼)로 저장하는 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG;

		CREATE TABLE #TMP_SCP0049_AVG
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
			, BEF_M6				NUMERIC(10,3)
			, BEF_M5				NUMERIC(10,3)
			, BEF_M4				NUMERIC(10,3)
			, BEF_M3				NUMERIC(10,3)
			, BEF_M2				NUMERIC(10,3)
			, BEF_M1				NUMERIC(10,3)
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
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG_MIN_MAX') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG_MIN_MAX;

		CREATE TABLE #TMP_SCP0049_AVG_MIN_MAX
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
			, BEF_BEST				NUMERIC(10,3)
			, BEF_WORST				NUMERIC(10,3)
			, BEF_BEST_RESULT		NUMERIC(10,3)
			, BEF_WORST_RESULT		NUMERIC(10,3)
		)

		-- LOSS 정보의 일별, 월별 , 년별 나눠진 데이터를 저장하는 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_DMY') IS NOT NULL
			DROP TABLE #TMP_SCP0049_DMY;

		CREATE TABLE #TMP_SCP0049_DMY
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
			, YYYYMMDD			NVARCHAR(008)
			, YYYYMM			NVARCHAR(006)
			, YYYY				NVARCHAR(004)
			, ITEM_VALUE		NUMERIC(20,4)
		)

		-- 조회된 결과 데이터에서 기준정보에서 누락된 데이터를 생성후 저저장되는 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ADD_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_ADD_STD;
	
		CREATE TABLE #TMP_SCP0049_ADD_STD
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
			, ITEM_VALUE		NUMERIC(20,4)
		)

		-- LINE ASSIGN , TACT TIME(DAILY_CAPA) , YIELD 의 일별, 월별 ,년도별 저장하는 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LTY') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LTY;
				
		CREATE TABLE #TMP_SCP0049_LTY
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
			, ITEM_VALUE		NUMERIC(20,4)
		)

  --      -- 2021-09-39
		--CREATE NONCLUSTERED INDEX TempTalbeIndex_LTY ON [dbo].[#TMP_SCP0049_LTY] ([LOSS_CODE], [DIVISION_ID],[COMPANY_ID],[SITE_ID],[PLANT_ID],[FACTORY_ID],[LINE_ID],[ELECTRODE_TYPE],[OPERATION_ID],[ITEM_ID]);

		-- LINE, TACT , YIELD 최종 결과 테이블
		-- Empty Value 설정 반영되는 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LTY_RESULT') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LTY_RESULT;
				
		CREATE TABLE #TMP_SCP0049_LTY_RESULT
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
			, ITEM_VALUE		NUMERIC(20,4)
		)

		-- LOSS , LINE ,TACT , YEILD 가 합쳐진 테이블
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ALL') IS NOT NULL
			DROP TABLE #TMP_SCP0049_ALL;

		CREATE TABLE #TMP_SCP0049_ALL
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
			, BEF_M6			NUMERIC(10,3)
			, BEF_M5			NUMERIC(10,3)
			, BEF_M4			NUMERIC(10,3)
			, BEF_M3			NUMERIC(10,3)
			, BEF_M2			NUMERIC(10,3)
			, BEF_M1			NUMERIC(10,3)
			, BEF_M6_RESULT		NUMERIC(10,3)
			, BEF_M5_RESULT		NUMERIC(10,3)
			, BEF_M4_RESULT		NUMERIC(10,3)
			, BEF_M3_RESULT		NUMERIC(10,3)
			, BEF_M2_RESULT		NUMERIC(10,3)
			, BEF_M1_RESULT		NUMERIC(10,3)
			, BEF_BEST			NUMERIC(10,3)
			, BEF_WORST			NUMERIC(10,3)
			, BEF_BEST_RESULT	NUMERIC(10,3)
			, BEF_WORST_RESULT	NUMERIC(10,3)
		)
	END

 
		-- ///////////////////////////////////////////////////////////////////////////////
		-- 과거 현재 - 3개월 데이터 및 평균
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_loss = 'Y'
		BEGIN
			-- SCM_WORK_CALENDAR_M_SN 은 일별로 저정되는 테이블
			-- 월별로 SUM 해서 저장한다.
			INSERT INTO #TMP_SCP0049_AVG_DATA
			
			SELECT CM.COMPANY_ID
					, CM.DIVISION_ID
					, CM.SITE_ID
					, CM.PLANT_ID
					, CM.FACTORY_ID
					, CM.OPERATION_ID
					, CM.LINE_ID
					, CM.ELECTRODE_TYPE
					, CM.LOSS_CODE
					, NULL					AS ITEM_ID
					, 0						AS LANE_QTY
					, CONVERT(VARCHAR(6),CM.WORK_DATE ,112)		AS YYYYMM
					, ISNULL(SUM(CM.TIME_TERM),0)				AS ITEM_VALUE
					, ISNULL(SUM(CM.TIME_TERM_RESULT),0)		AS ITEM_VALUE_RESULT
				 FROM #TMP_SCP0049_LOOKUP LU
				 JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)
				   ON CM.LOSS_CODE		= LU.LOSS_CODE
				  AND CM.DIVISION_ID    = @p_division_id
				 JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				   ON  CM.COMPANY_ID		= L.COMPANY_ID
				  AND CM.DIVISION_ID	= L.DIVISION_ID				  
				  AND CM.SITE_ID		= L.SITE_ID
				  AND CM.PLANT_ID		= L.PLANT_ID
				  AND CM.FACTORY_ID		= L.FACTORY_ID
				  AND CM.OPERATION_ID	= L.OPERATION_ID
				  AND CM.LINE_ID		= L.LINE_ID
				  AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE
				WHERE 1 = 1
				  AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				  AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) >= @v_start_avg -- '202004'
				  AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_avg   -- '202006'
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
			-- 비율로 저장되고 (%) 값으로 표시하기 위해서 (값 * 100) 을 해서 저장한다
			SELECT LM.COMPANY_ID
					, LM.DIVISION_ID
					, LM.SITE_ID
					, LM.PLANT_ID
					, LM.FACTORY_ID
					, LM.OPERATION_ID
					, LM.LINE_ID
					, LM.ELECTRODE_TYPE
					, LM.LOSS_CODE
					, NULL					AS ITEM_ID
					, 0						AS LANE_QTY
					, LM.WORK_MONTH			AS YYYYMM
					, ISNULL(LM.LOSS_RATE			* 100,0)	AS ITEM_VALUE
					, ISNULL(LM.LOSS_RATE_RESULT	* 100,0)	AS ITEM_VALUE_RESULT
				 FROM #TMP_SCP0049_LOOKUP LU
				 JOIN SCM_LOSS_M_SN LM WITH(NOLOCK)
				   ON LM.LOSS_CODE		= LU.LOSS_CODE
				  AND LM.DIVISION_ID    = @p_division_id
				 JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				   ON LM.DIVISION_ID	= L.DIVISION_ID
				  AND LM.COMPANY_ID		= L.COMPANY_ID
				  AND LM.SITE_ID		= L.SITE_ID
				  AND LM.PLANT_ID		= L.PLANT_ID
				  AND LM.FACTORY_ID		= L.FACTORY_ID
				  AND LM.OPERATION_ID	= L.OPERATION_ID
				  AND LM.LINE_ID		= L.LINE_ID
				  AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE
				WHERE 1 = 1
				   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
				   AND LM.WORK_MONTH >= @v_start_avg
				   AND LM.WORK_MONTH <= @v_end_avg
				;


			-- 이력 테이블 조회
			IF @v_end_result_avg > @v_start_result_avg
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA

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
					 , ISNULL(SUM(CM.TIME_TERM),0)				AS ITEM_VALUE
					 , ISNULL(SUM(CM.TIME_TERM_RESULT),0)		AS ITEM_VALUE_RESULT
				  FROM #TMP_SCP0049_LOOKUP LU
				  JOIN HIST_SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)   -- 이력 테이블(HIST) 조회				     
				    ON CM.LOSS_CODE		= LU.LOSS_CODE
				   AND CM.DIVISION_ID   = @p_division_id
				  JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				    ON CM.DIVISION_ID		= L.DIVISION_ID
				   AND CM.COMPANY_ID		= L.COMPANY_ID
				   AND CM.SITE_ID			= L.SITE_ID
				   AND CM.PLANT_ID			= L.PLANT_ID
				   AND CM.FACTORY_ID		= L.FACTORY_ID
				   AND CM.OPERATION_ID		= L.OPERATION_ID
				   AND CM.LINE_ID			= L.LINE_ID
				   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE
				 WHERE LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				   AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) >= @v_start_result_avg
				   AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_result_avg
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
				-- 비율로 저장되고 (%) 값으로 표시하기 위해서 (값 * 100) 을 해서 저장한다
				SELECT LM.COMPANY_ID
					, LM.DIVISION_ID
					, LM.SITE_ID
					, LM.PLANT_ID
					, LM.FACTORY_ID
					, LM.OPERATION_ID
					, LM.LINE_ID
					, LM.ELECTRODE_TYPE
					, LM.LOSS_CODE
					, NULL										AS ITEM_ID
					, 0											AS LANE_QTY
					, LM.WORK_MONTH								AS YYYYMM
					, ISNULL(LM.LOSS_RATE			* 100,0)	AS ITEM_VALUE
					, ISNULL(LM.LOSS_RATE_RESULT	* 100,0)	AS ITEM_VALUE_RESULT
				 FROM #TMP_SCP0049_LOOKUP LU
				 JOIN HIST_SCM_LOSS_M_SN LM WITH(NOLOCK)			-- 이력 테이블(HIST) 조회
				   ON  1 = 1
				   --AND LU.COMPANY_ID, LM.COMPANY_ID
				   AND LM.LOSS_CODE		= LU.LOSS_CODE
				  AND LM.DIVISION_ID    = @p_division_id
				 JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				   ON LM.DIVISION_ID	= L.DIVISION_ID
				  AND LM.COMPANY_ID		= L.COMPANY_ID
				  AND LM.SITE_ID		= L.SITE_ID
				  AND LM.PLANT_ID		= L.PLANT_ID
				  AND LM.FACTORY_ID		= L.FACTORY_ID
				  AND LM.OPERATION_ID	= L.OPERATION_ID
				  AND LM.LINE_ID		= L.LINE_ID
				  AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE
				WHERE LU.DATA_TABLE  = 'SCM_LOSS_M'
				  AND LM.WORK_MONTH >= @v_start_result_avg
				  AND LM.WORK_MONTH <= @v_end_result_avg
			END -- 이력 테이블(HIST) 조회
		END
				
		--SELECT '#TMP_SCP0049_AVG_DATA' TN,  * FROM #TMP_SCP0049_AVG_DATA 


		-- /////////////////////////////////////////////////////////////////////////
		-- 조회된 과거 데이터를 날짜별(컬럼)로 저장한다.
		-- /////////////////////////////////////////////////////////////////////////
		INSERT INTO #TMP_SCP0049_AVG
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
			, BEF_M6
			, BEF_M5
			, BEF_M4
			, BEF_M3
			, BEF_M2
			, BEF_M1
			, BEF_M6_RESULT
			, BEF_M5_RESULT
			, BEF_M4_RESULT
			, BEF_M3_RESULT
			, BEF_M2_RESULT
			, BEF_M1_RESULT
		)
		SELECT COMPANY_ID
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
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M6
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M5
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M4
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M3
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M2
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M1
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M6_RESULT
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M5_RESULT
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M4_RESULT
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M3_RESULT
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M2_RESULT
				, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M1_RESULT
			FROM #TMP_SCP0049_AVG_DATA
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
						
				
		-- /////////////////////////////////////////////////////////////////////////
		-- 조회된 과거 데이터를 BEST , WORST 를 저장한다.
		-- LOSS, TACT TIME 는 작은값이 BEST
		-- DAILY CPAP(LA002), YIELD(LA003) 는 큰값이 BEST
		-- 죄회된 데이터에 해당 월 값이 없을 경우 0 값으로 설정해서 MIN, MAX 값을 구한다
		-- /////////////////////////////////////////////////////////////////////////
		INSERT INTO #TMP_SCP0049_AVG_MIN_MAX
					
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
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) 
						ELSE  MIN(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) END AS BEF_BEST
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(X.ITEM_VALUE) 
						ELSE  MAX(X.ITEM_VALUE) END AS BEF_WORST
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
						ELSE  MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_BEST_RESULT
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(X.ITEM_VALUE_RESULT) 
						ELSE  MAX(X.ITEM_VALUE_RESULT) END AS BEF_WORST_RESULT
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
						, 0					AS ITEM_VALUE
						, 0					AS ITEM_VALUE_RESULT
					FROM #TMP_SCP0049_AVG_DATA A
					CROSS JOIN ( SELECT DISTINCT BASIS_YYYYMM 
								   FROM SCM_SYS_CALENDAR_M C WITH(NOLOCK)
								  WHERE BASIS_YYYYMM >= @p_from_yyyymm -- 조회 시작 월
									AND BASIS_YYYYMM <= @v_end_avg
								) C
				) T
			LEFT JOIN #TMP_SCP0049_AVG_DATA  X
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

		-- ///////////////////////////////////////////////////////////////////////////////
		-- LOSS 일별 데이터
		 -- ///////////////////////////////////////////////////////////////////////////////
		IF OBJECT_ID('tempdb..#TMP_SCP0049_DAILY') IS NOT NULL
			DROP TABLE #TMP_SCP0049_DAILY;
			
		IF @p_check_loss = 'Y'
		BEGIN
			SELECT CM.DIVISION_ID
					, CM.COMPANY_ID						AS COMPANY_ID
					, CM.SITE_ID							AS SITE_ID
					, CM.PLANT_ID							AS PLANT_ID
					, CM.FACTORY_ID						AS FACTORY_ID
					, CM.LINE_ID							AS LINE_ID
					, CM.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					, CM.OPERATION_ID						AS OPERATION_ID
					, LU.LOSS_CODE							AS LOSS_CODE
					, CONVERT(CHAR(8), CM.WORK_DATE , 112) AS YYYYMMDD
					, NULL									AS YYYYMM
					, NULL									AS YYYY
					, ISNULL(TIME_TERM,0)					AS ITEM_VALUE
				INTO #TMP_SCP0049_DAILY
				FROM #TMP_SCP0049_LOOKUP LU

				JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)
				ON CM.LOSS_CODE		= LU.LOSS_CODE
			   AND CM.DIVISION_ID   = @p_division_id
				JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				ON   CM.COMPANY_ID		= L.COMPANY_ID
				AND CM.DIVISION_ID		= L.DIVISION_ID				
				AND CM.SITE_ID			= L.SITE_ID
				AND CM.PLANT_ID			= L.PLANT_ID
				AND CM.FACTORY_ID		= L.FACTORY_ID
				AND CM.OPERATION_ID		= L.OPERATION_ID
				AND CM.LINE_ID			= L.LINE_ID
				AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE
				WHERE 1 = 1
				AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				AND CONVERT(CHAR(8), CM.WORK_DATE , 112) >=  @v_start_day
				AND CONVERT(CHAR(8), CM.WORK_DATE , 112) <=  @v_end_day
		END
		
		--SELECT '#TMP_SCP0049_DAILY' TN,  * FROM #TMP_SCP0049_DAILY 
	
		-- ///////////////////////////////////////////////////////////////////////////////
		-- LOSS 월별 데이터(CALENDAR, LOSS )
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_MM') IS NOT NULL
				DROP TABLE #TMP_SCP0049_MM;

			IF @p_check_loss = 'Y'
			BEGIN
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
					 , SUM(CM.TIME_TERM)						AS ITEM_VALUE
				  INTO #TMP_SCP0049_MM
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)
					ON CM.LOSS_CODE		= LU.LOSS_CODE
				   AND CM.DIVISION_ID   = @p_division_id
				  JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
					ON CM.DIVISION_ID		= L.DIVISION_ID
				   AND CM.COMPANY_ID		= L.COMPANY_ID
				   AND CM.SITE_ID			= L.SITE_ID
				   AND CM.PLANT_ID			= L.PLANT_ID
				   AND CM.FACTORY_ID		= L.FACTORY_ID
				   AND CM.OPERATION_ID		= L.OPERATION_ID
				   AND CM.LINE_ID			= L.LINE_ID
				   AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				 WHERE 1 = 1
				   AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				   AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) >= @v_start_month -- '202008'
				   AND CONVERT(VARCHAR(6),CM.WORK_DATE ,112) <= @v_end_month   -- '202106'

				 GROUP BY CM.COMPANY_ID
					, CM.DIVISION_ID
					, CM.SITE_ID
					, CM.PLANT_ID
					, CM.FACTORY_ID
					, CM.OPERATION_ID
					, CM.LINE_ID
					, CM.ELECTRODE_TYPE
					, CM.LOSS_CODE
					, CONVERT(VARCHAR(6), CM.WORK_DATE,112)

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
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_LOSS_M_SN LM WITH(NOLOCK)
					ON LM.LOSS_CODE		= LU.LOSS_CODE
				   AND LM.DIVISION_ID   = @p_division_id
				  JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
					ON LM.DIVISION_ID		= L.DIVISION_ID
				   AND LM.COMPANY_ID		= L.COMPANY_ID
				   AND LM.SITE_ID			= L.SITE_ID
				   AND LM.PLANT_ID			= L.PLANT_ID
				   AND LM.FACTORY_ID		= L.FACTORY_ID
				   AND LM.OPERATION_ID		= L.OPERATION_ID
				   AND LM.LINE_ID			= L.LINE_ID
				   AND LM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				 WHERE 1 = 1
				   AND LU.LOSS_CODE <> 'M08'
				   AND WORK_MONTH >=  @v_start_month
				   AND WORK_MONTH <=  @v_end_month
				   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
			END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- LOSS 연도 데이터(CALENDAR, LOSS )
		-- ///////////////////////////////////////////////////////////////////////////////
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_YEAR') IS NOT NULL
			DROP TABLE #TMP_SCP0049_YEAR;

		IF @p_check_loss = 'Y'
		BEGIN
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
					, NULL										AS YYYYMM
					, CONVERT(VARCHAR(4), CM.WORK_DATE,112)	AS YYYY
					, SUM(CM.TIME_TERM)						AS ITEM_VALUE
				INTO #TMP_SCP0049_YEAR
				FROM #TMP_SCP0049_LOOKUP LU

				JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)
				ON CM.LOSS_CODE		= LU.LOSS_CODE
			   AND CM.DIVISION_ID   = @p_division_id
				JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				ON CM.DIVISION_ID		= L.DIVISION_ID
				AND CM.COMPANY_ID		= L.COMPANY_ID
				AND CM.SITE_ID			= L.SITE_ID
				AND CM.PLANT_ID			= L.PLANT_ID
				AND CM.FACTORY_ID		= L.FACTORY_ID
				AND CM.OPERATION_ID		= L.OPERATION_ID
				AND CM.LINE_ID			= L.LINE_ID
				AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				WHERE 1 = 1
				AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				AND CONVERT(VARCHAR(4),CM.WORK_DATE ,112) >= @v_start_year -- '2021'
				AND CONVERT(VARCHAR(4),CM.WORK_DATE ,112) <= @v_end_year   -- '2023'

				GROUP BY CM.COMPANY_ID
				, CM.DIVISION_ID
				, CM.SITE_ID
				, CM.PLANT_ID
				, CM.FACTORY_ID
				, CM.OPERATION_ID
				, CM.LINE_ID
				, CM.ELECTRODE_TYPE
				, CM.LOSS_CODE
				, CONVERT(VARCHAR(4), CM.WORK_DATE,112)

			UNION ALL

			SELECT LM.DIVISION_ID
					, LM.COMPANY_ID						AS COMPANY_ID
					, LM.SITE_ID							AS SITE_ID
					, LM.PLANT_ID							AS PLANT_ID
					, LM.FACTORY_ID						AS FACTORY_ID
					, LM.LINE_ID							AS LINE_ID
					, LM.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					, LM.OPERATION_ID						AS OPERATION_ID
					, LM.LOSS_CODE							AS LOSS_CODE
					, NULL									AS YYYYMMDD
					, NULL									AS YYYYMM
					, CONVERT(VARCHAR(4),WORK_MONTH,112)	AS YYYY
					, SUM(LOSS_RATE)						AS ITEM_VALUE
				FROM #TMP_SCP0049_LOOKUP LU

				JOIN SCM_LOSS_M_SN LM WITH(NOLOCK)
				ON LM.LOSS_CODE		= LU.LOSS_CODE
		       AND LM.DIVISION_ID   = @p_division_id
				JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
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
				AND CONVERT(VARCHAR(4),WORK_MONTH,112) >=  @v_start_year
				AND CONVERT(VARCHAR(4),WORK_MONTH,112) <=  @v_end_year

				GROUP BY LM.COMPANY_ID
				, LM.DIVISION_ID
				, LM.SITE_ID
				, LM.PLANT_ID
				, LM.FACTORY_ID
				, LM.OPERATION_ID
				, LM.LINE_ID
				, LM.ELECTRODE_TYPE
				, LM.LOSS_CODE
				, CONVERT(VARCHAR(4), LM.WORK_MONTH,112)
		END



		-- ///////////////////////////////////////////////////////////////////////////////
		-- LOSS 의 DAILY , MM ,YEAR
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_loss = 'Y'
		BEGIN
			-- 임시 테이블 삭제
			INSERT INTO #TMP_SCP0049_DMY
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
			SELECT *
				FROM #TMP_SCP0049_DAILY
				UNION ALL
			SELECT *
				FROM #TMP_SCP0049_MM
				UNION ALL
			SELECT *
				FROM #TMP_SCP0049_YEAR
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 기준테이블(STD) 를 기준으로 정보 조회
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_loss = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_ADD_STD
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
						-- 중복 제거를 위해 DISTINCT 처리
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
							FROM (SELECT DISTINCT 
							          	A.DIVISION_ID
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
									FROM #TMP_SCP0049_STD A
									LEFT JOIN #TMP_SCP0049_DMY B
									ON A.DIVISION_ID	= B.DIVISION_ID
									AND A.COMPANY_ID		= B.COMPANY_ID
									AND A.SITE_ID		= B.SITE_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.FACTORY_ID		= B.FACTORY_ID
									AND A.LINE_ID		= B.LINE_ID
									AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
									AND A.OPERATION_ID	= B.OPERATION_ID
								) R
							LEFT JOIN #TMP_SCP0049_LOOKUP LU
							ON 1=1
							WHERE 1=1
							AND 	LU.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
							) X1   -- LOOKUP 정보 추가
					LEFT JOIN #TMP_SCP0049_DMY R
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




			INSERT INTO #TMP_SCP0049_LTY_RESULT
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
				, ITEM_VALUE
				FROM #TMP_SCP0049_LTY



		-- ///////////////////////////////////////////////////////////////////////////////
		-- 데이터 합치기
		-- ///////////////////////////////////////////////////////////////////////////////
		INSERT INTO #TMP_SCP0049_ALL
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
			, BEF_M6
			, BEF_M5
			, BEF_M4
			, BEF_M3
			, BEF_M2
			, BEF_M1
			, BEF_M6_RESULT
			, BEF_M5_RESULT
			, BEF_M4_RESULT
			, BEF_M3_RESULT
			, BEF_M2_RESULT
			, BEF_M1_RESULT
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
					, '-'				AS ITEM_ID
					, NULL				AS LANE_QTY
					, LK.YYYYMMDD
					, LK.YYYYMM		AS YYYYMM
					, LK.YYYY			AS YYYY
					, LK.ITEM_VALUE
					, 0				AS BEF_M6
					, 0				AS BEF_M5
					, 0				AS BEF_M4
					, 0				AS BEF_M3
					, 0				AS BEF_M2
					, 0				AS BEF_M1
					, 0				AS BEF_M6_RESULT
					, 0				AS BEF_M5_RESULT
					, 0				AS BEF_M4_RESULT
					, 0				AS BEF_M3_RESULT
					, 0				AS BEF_M2_RESULT
					, 0				AS BEF_M1_RESULT
				FROM #TMP_SCP0049_ADD_STD LK

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
					, 0				AS BEF_M6
					, 0				AS BEF_M5
					, 0				AS BEF_M4
					, 0				AS BEF_M3
					, 0				AS BEF_M2
					, 0				AS BEF_M1
					, 0				AS BEF_M6_RESULT
					, 0				AS BEF_M5_RESULT
					, 0				AS BEF_M4_RESULT
					, 0				AS BEF_M3_RESULT
					, 0				AS BEF_M2_RESULT
					, 0				AS BEF_M1_RESULT
				FROM #TMP_SCP0049_LTY_RESULT LTY
		;
				
			-- ///////////////////////////////// XA001 데이터 넣기 날짜별 생성 ////////////////
		INSERT INTO #TMP_SCP0049_ALL
		(
				COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID		, FACTORY_ID
			, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, LOSS_CODE		, ITEM_ID
			, YYYYMMDD		, YYYYMM		, YYYY
			, ITEM_VALUE	
			, BEF_M6		, BEF_M5			, BEF_M4		, BEF_M3		, BEF_M2		, BEF_M1		
			, BEF_M6_RESULT	, BEF_M5_RESULT	, BEF_M4_RESULT		, BEF_M3_RESULT	, BEF_M2_RESULT	, BEF_M1_RESULT
		)
		SELECT COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
				, OPERATION_ID		, LINE_ID		, ELECTRODE_TYPE, 'XA001'	, '-'
				, BASIS_YYYYMMDD	, NULL			, NULL
				, 1440				
				, 0				, 0				, 0				, 0			, 0					, 0
				, 0				, 0				, 0				, 0			, 0					, 0
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
					FROM #TMP_SCP0049_ALL A
					JOIN #TMP_SCP0049_LOOKUP L
					ON A.LOSS_CODE = L.LOSS_CODE
					AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
				) X
		LEFT JOIN [SCM_SYS_CALENDAR_M] C1
			ON C1.BASIS_YYYYMMDD  >= @v_start_day
			AND C1.BASIS_YYYYMMDD  <= @v_end_day

		UNION ALL

		SELECT COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
				, OPERATION_ID		, LINE_ID		, ELECTRODE_TYPE, 'XA001'	, '-'
				, NULL	, C1.BASIS_YYYYMM			, NULL
				, CALENDAR_DAY		
				, 0				, 0				, 0				, 0			, 0					, 0
				, 0				, 0				, 0				, 0			, 0					, 0
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
					FROM #TMP_SCP0049_ALL A
					JOIN #TMP_SCP0049_LOOKUP L
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

		UNION ALL

		SELECT COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
				, OPERATION_ID		, LINE_ID		, ELECTRODE_TYPE, 'XA001'	, '-'
				, NULL				, NULL			, CALENDAR_YYYY
				, YEAR_CNT			
				, 0				, 0				, 0				, 0			, 0					, 0
				, 0				, 0				, 0				, 0			, 0					, 0
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
					FROM #TMP_SCP0049_ALL A
					JOIN #TMP_SCP0049_LOOKUP L
					ON A.LOSS_CODE = L.LOSS_CODE
					AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
				) X
			LEFT JOIN ( 
					SELECT CALENDAR_YYYY , COUNT(1) YEAR_CNT
						FROM [SCM_SYS_CALENDAR_M]  A
						WHERE A.CALENDAR_YYYY  >= @v_start_year
						AND A.CALENDAR_YYYY  <= @v_end_year
						GROUP BY CALENDAR_YYYY
					) C1
			ON 1=1

			-- ///////////////////////////////// CACULATOR 날짜별 생성 ////////////////
			INSERT INTO #TMP_SCP0049_ALL
			(
					COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID		, FACTORY_ID
				, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, LOSS_CODE		, ITEM_ID
				, YYYYMMDD		, YYYYMM		, YYYY
				, ITEM_VALUE	
				, BEF_M6		, BEF_M5			, BEF_M4		, BEF_M3		, BEF_M2		, BEF_M1		
				, BEF_M6_RESULT	, BEF_M5_RESULT	, BEF_M4_RESULT		, BEF_M3_RESULT	, BEF_M2_RESULT	, BEF_M1_RESULT
			)
			SELECT COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID		, LINE_ID		, ELECTRODE_TYPE, LK.LOSS_CODE	, '-'
					, YYYYMMDD			, YYYYMM		, YYYY
					, 0				
					, 0				, 0				, 0				, 0			, 0					, 0
					, 0				, 0				, 0				, 0			, 0					, 0
				FROM (
					SELECT DISTINCT
							COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID	, FACTORY_ID
					 		, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, ITEM_ID	, YYYYMMDD
							, YYYYMM		, YYYY
						FROM #TMP_SCP0049_ALL A
					WHERE LOSS_CODE = 'XA001'
						AND YYYYMM = @v_start_month
						) A
						left join #TMP_SCP0049_LOOKUP LK
						on lk.DATA_TABLE = 'CAL'
						AND LK.LOSS_CODE <> 'XA001'

			UPDATE X
			   SET X.BEF_M6 = ISNULL(A.BEF_M6,0)
				 , X.BEF_M5 = ISNULL(A.BEF_M5,0)
				 , X.BEF_M4 = ISNULL(A.BEF_M4,0)
				 , X.BEF_M3 = ISNULL(A.BEF_M3,0)
				 , X.BEF_M2 = ISNULL(A.BEF_M2,0)
				 , X.BEF_M1 = ISNULL(A.BEF_M1,0)
				 , X.BEF_M6_RESULT = ISNULL(A.BEF_M6_RESULT,0)
				 , X.BEF_M5_RESULT = ISNULL(A.BEF_M5_RESULT,0)
				 , X.BEF_M4_RESULT = ISNULL(A.BEF_M4_RESULT,0)
				 , X.BEF_M3_RESULT = ISNULL(A.BEF_M3_RESULT,0)
				 , X.BEF_M2_RESULT = ISNULL(A.BEF_M2_RESULT,0)
				 , X.BEF_M1_RESULT = ISNULL(A.BEF_M1_RESULT,0)
			  FROM #TMP_SCP0049_ALL X
			  JOIN #TMP_SCP0049_AVG A
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


			UPDATE X
			SET X.BEF_M6 = @v_bef_m6_count
				, X.BEF_M5 = @v_bef_m5_count
				, X.BEF_M4 = @v_bef_m4_count
				, X.BEF_M3 = @v_bef_m3_count
				, X.BEF_M2 = @v_bef_m2_count
				, X.BEF_M1 = @v_bef_m1_count
				, X.BEF_M6_RESULT = @v_bef_m6_count
				, X.BEF_M5_RESULT = @v_bef_m5_count
				, X.BEF_M4_RESULT = @v_bef_m4_count
				, X.BEF_M3_RESULT = @v_bef_m3_count
				, X.BEF_M2_RESULT = @v_bef_m2_count
				, X.BEF_M1_RESULT = @v_bef_m1_count
				, X.BEF_BEST			= @v_bef_max_count
				, X.BEF_WORST			= @v_bef_min_count
				, X.BEF_BEST_RESULT	= @v_bef_max_count
				, X.BEF_WORST_RESULT	= @v_bef_min_count
			FROM #TMP_SCP0049_ALL X
			WHERE LOSS_CODE = 'XA001'

			UPDATE X
			SET X.BEF_BEST = ISNULL(A.BEF_BEST,0)
				, X.BEF_WORST = ISNULL(A.BEF_WORST,0)
				, X.BEF_BEST_RESULT = ISNULL(A.BEF_BEST_RESULT,0)
				, X.BEF_WORST_RESULT = ISNULL(A.BEF_WORST_RESULT,0)
			FROM #TMP_SCP0049_ALL X
			JOIN #TMP_SCP0049_AVG_MIN_MAX A
			ON  A.COMPANY_ID		= X.COMPANY_ID
			AND A.DIVISION_ID	= X.DIVISION_ID		
			AND A.SITE_ID		= X.SITE_ID
			AND A.PLANT_ID		= X.PLANT_ID
			AND A.FACTORY_ID		= X.FACTORY_ID
			AND A.LINE_ID		= X.LINE_ID
			AND ISNULL(A.ELECTRODE_TYPE,'-')	= ISNULL(X.ELECTRODE_TYPE,'-')
			AND A.OPERATION_ID	= X.OPERATION_ID
			AND A.LOSS_CODE		= X.LOSS_CODE
			AND ISNULL(A.ITEM_ID,'-')	= ISNULL(X.ITEM_ID,'-')
	 
	 --SELECT '#TMP_SCP0049_ALL' TN,  *  	 FROM #TMP_SCP0049_ALL --TEST

	-- 요청기간(플랜구간)에 따른 CAPA Available working time
	SELECT  A.LINE_ID
		 , A.OPERATION_ID
		, A.YYYYMMDD
		 , A.A_VALUE - (A.B_VALUE + A.C_VALUE) AS G_VALUE
		 --, A.A_VALUE
		 --, A.B_VALUE
		 --, A.C_VALUE
	  FROM (
			select X.LINE_ID
				, X.OPERATION_ID
				, X.YYYYMMDD
				  ,SUM((CASE WHEN X.LOSS_CODE = 'XA001' THEN X.ITEM_VALUE ELSE 0 END)) AS A_VALUE
				  ,SUM((CASE WHEN X.LOSS_CODE = 'EL001' THEN X.ITEM_VALUE ELSE 0 END)) AS B_VALUE
				  ,SUM((CASE WHEN X.LOSS_CODE = 'EL002' THEN X.ITEM_VALUE ELSE 0 END)) AS C_VALUE
			  from #TMP_SCP0049_ALL X with (nolock)
			 inner join #TMP_SCP0049_LOOKUP L with (nolock)
				ON X.LOSS_CODE = L.LOSS_CODE
			 WHERE 1 =1 
			   AND X.LOSS_CODE IN ('XA001', 'EL001', 'EL002')
			   AND X.YYYYMMDD IS NOT NULL
			   AND EXISTS(SELECT  1 FROM #TMP_PSI_GLOBAL   G WITH (NOLOCK) 
									WHERE X.DIVISION_ID = G.DIVISION_ID 
									AND X.LINE_ID = G.PROD_LINE  
									AND X.OPERATION_ID = G.OPERATION_ID)
			 GROUP BY  x.LINE_ID,  X.OPERATION_ID, X.YYYYMMDD 
		   ) A
	 WHERE A.YYYYMMDD BETWEEN @p_plan_start_yyyymmdd AND @p_to_yyyymmdd
	 ORDER BY A.LINE_ID, A.OPERATION_ID, A.YYYYMMDD
	;
	
		IF OBJECT_ID('TEMPDB..#TMP_PSI_GLOBAL') IS NOT NULL
			DROP TABLE #TMP_PSI_GLOBAL;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LOOKUP') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LOOKUP;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG_DATA') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG_DATA;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG_MIN_MAX') IS NOT NULL
			DROP TABLE #TMP_SCP0049_AVG_MIN_MAX;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_DMY') IS NOT NULL
			DROP TABLE #TMP_SCP0049_DMY;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ADD_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_ADD_STD;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LTY') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LTY;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LTY_RESULT') IS NOT NULL
			DROP TABLE #TMP_SCP0049_LTY_RESULT;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ALL') IS NOT NULL
			DROP TABLE #TMP_SCP0049_ALL;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_MM') IS NOT NULL
			DROP TABLE #TMP_SCP0049_MM;

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_YEAR') IS NOT NULL
			DROP TABLE #TMP_SCP0049_YEAR;

  END;       
  
