






/*
 * Program ID   : SCP0049_GET_CAPA
 * Description  : Master Data Management
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/07/14   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2020/09/11   khj79          p_check_daily 선택 시 일자 조회 ,loss ,line,tact,yield 선택 시 조회
 * 2020/09/24   khj79          속도 개선 및 전극 수율 반영 수정 , 누락 데이터 수정
 * 2020/10/12   khj79          버전별 division, op group 설정
 * 2020/11/18   khj79          TACT TIME : DAILY CAPA, TACT TIME 구분 수정 , CAPA_UI_CAPA_DEFINIT LOOKUP 정보 추가
 * 2021/01/11   khj79          EXCEL 를 위한 조회 PARAMETER 추가 및 쿼리 수정
 * 2021/01/25   khj79          YEILD 항목 ELECTRODE_TYPE NULL 값 처리(YIELD 항목은 ELECTRODE_TYPE 값이 없음)
 * 2021/07/08   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 2년(24+5) 조회 변경
 * 2021/07/22   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 3년(36+5) 조회 변경
 * 2021/07/27   khj79          [PJ20214907] LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 형교환 CAPA ( SCP Planner 만 조회)
 * 2021/07/27   grimhanlges2   동적 쿼리의 group by 컬럼을 줄이기 위해 #TMP_SCP0049_RESULT의 컬럼수를 줄이고
                               group by 후에 조인하도록 변경. Park Sungchool
 * 2021/11/29   khj79		   [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - TACT TIME 과거실적 조회
 * 2021/12/15	khj79		   이력 테이블 조회 되도록 수정(HIST_XXXXX)	
 * 2022/01/18	khj79		   MODEL 조건 수정 (BOM 조회)
 * 2022/10/24	lgda106		   속도 개선(임시테이블 수정 등)
 * 2023/06/15	hsbyeon		   단종된 ITEM 조회되지 않도록 수정
 * 2023/06/30   chkim.68       조회 결과(TABLE0)에 ITEM_CLASS 포함
 * 2023/06/30   chkim.68       SYNONYM 적용 (LGCE_FPDEV_TR.DBO.SCM_ITEM_M -> SCM_ITEM_M_SN
 * 2023/01/17   leejsthira2    월을 과거구간으로만 선택할 경우 조회 오류 발생하는 문제 수정

ex>		DECLARE @p_today_yyyymmdd		NVARCHAR(8) = '20210503'
	,@p_from_yyyymm			NVARCHAR(6) = '202011'
	,@p_to_yyyymm			NVARCHAR(6) = '202205'
	,@p_division_id			NVARCHAR(20) = '81'
	,@p_group				NVARCHAR(1) = 'A'
	,@p_plant_id			NVARCHAR(MAX) = 'A040'
	,@p_factory_id			NVARCHAR(MAX) = 'A1'
	,@p_version_id			NVARCHAR(20) = 'Current'
	,@p_line_id				NVARCHAR(MAX) = 'A1A02'
	,@p_operation_id		NVARCHAR(MAX) = 'A8000'
	,@p_model_id			NVARCHAR(30) = ''
	,@p_item_id				NVARCHAR(30) = ''
	,@p_nick_name			NVARCHAR(30) = ''
	,@p_bucket				NVARCHAR(15) = 'M'
	,@p_check_loss			CHAR(1) = 'N'
	,@p_check_line			CHAR(1) = 'Y'
	,@p_check_tact			CHAR(1) = 'N'
	,@p_check_yield			CHAR(1) = 'N'
	,@p_check_empty			CHAR(1) = 'N'
	,@p_user_id				NVARCHAR(30) = 'khj79'
	,@p_user_auth			NVARCHAR(30) = 'SCM PI Admin'
	,@p_search_type			NVARCHAR(30) = 'CAPA'
	,@debug_mode			CHAR(1) = 'T'
 */

 --DECLARE @p_today_yyyymmdd		NVARCHAR(8) = '20221222'
	--,@p_from_yyyymm			NVARCHAR(6) = '202207'
	--,@p_to_yyyymm			NVARCHAR(6) = '202301'
	--,@p_division_id			NVARCHAR(20) = '81'
	--,@p_group				NVARCHAR(1) = 'E'
	--,@p_plant_id			NVARCHAR(MAX) = 'G383'
	--,@p_factory_id			NVARCHAR(MAX) = ''
	--,@p_version_id			NVARCHAR(20) = 'Current'
	--,@p_line_id				NVARCHAR(MAX) = 'E9D01,FP_E9M01_A,FP_E9M01_C,FP_E9M02_A,FP_E9M02_C'
	--,@p_operation_id		NVARCHAR(MAX) = ''
	--,@p_model_id			NVARCHAR(30) = ''
	--,@p_item_id				NVARCHAR(30) = ''
	--,@p_nick_name			NVARCHAR(30) = ''
	--,@p_bucket				NVARCHAR(15) = 'M'
	--,@p_check_loss			CHAR(1) = 'N'
	--,@p_check_line			CHAR(1) = 'N'
	--,@p_check_tact			CHAR(1) = 'Y'
	--,@p_check_yield			CHAR(1) = 'N'
	--,@p_check_empty			CHAR(1) = 'N'
	--,@p_user_id				NVARCHAR(30) = 'eunseopark'
	--,@p_user_auth			NVARCHAR(30) = 'FP Planner'
	--,@p_search_type			NVARCHAR(30) = 'CAPA'
	--,@debug_mode			CHAR(1) = 'F'


CREATE PROCEDURE [dbo].[SCP0049_GET_CAPA_0729_ORG]
	 @p_today_yyyymmdd		NVARCHAR(8)
	,@p_from_yyyymm			NVARCHAR(6)
	,@p_to_yyyymm			NVARCHAR(6)
	,@p_division_id			NVARCHAR(20)
	,@p_group				NVARCHAR(MAX)
	,@p_plant_id			NVARCHAR(MAX)
	,@p_factory_id			NVARCHAR(MAX)
	,@p_version_id			NVARCHAR(20)
	,@p_line_id				NVARCHAR(MAX)
	,@p_operation_id		NVARCHAR(MAX)
	,@p_model_id			NVARCHAR(30)
	,@p_item_id				NVARCHAR(30)
	,@p_nick_name			NVARCHAR(30)
	,@p_bucket				NVARCHAR(15)
	,@p_check_loss			CHAR(1)
	,@p_check_line			CHAR(1)
	,@p_check_tact			CHAR(1)
	,@p_check_yield			CHAR(1)
	,@p_check_empty			CHAR(1)
	,@p_user_id				NVARCHAR(30)
	,@p_user_auth			NVARCHAR(30)
	,@p_search_type			NVARCHAR(30)
	,@debug_mode			CHAR(1)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- 쿼리 실행용 변수
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
       
	IF ( CHARINDEX( 'D' , @p_bucket) > 0 ) 	BEGIN SET @v_check_daily = 'Y'; END;

	-- Daily 미 체크 시 일별 조회 안되도록 수정
	IF @v_check_daily = 'Y'
	BEGIN
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
	END
	ELSE
	BEGIN
		SET @v_start_day = '999999' ;  -- 일자 조회 않되도록 설정
		SET @v_end_day = '999999' ;    -- 일자 조회 않되도록 설정
		-- 기준일 Y+1 년 과 조회 마지막 일자를 비교하여 조회일 설정
		IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
		BEGIN
			--SET @v_start_month	= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd);
			SET @v_start_month	= @p_from_yyyymm; -- 시작 월 값 그대로 넣는식으로 변경(월을 과거구간으로만 선택할 경우 조회 오류 발생하는 문제 수정)
			SET @v_end_month	= CONVERT(NVARCHAR(6),@v_max_day,112);  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
		END
		ELSE
		BEGIN
			--SET @v_start_month	= CONVERT(NVARCHAR(6) , @p_today_yyyymmdd);
			SET @v_start_month	= @p_from_yyyymm; -- 시작 월 값 그대로 넣는식으로 변경(월을 과거구간으로만 선택할 경우 조회 오류 발생하는 문제 수정)
			SET @v_end_month	= @p_to_yyyymm;
		END
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
	DECLARE @v_ver_group		NVARCHAR(MAX);
	
	BEGIN
		SELECT @v_ver_division_id = CASE WHEN @p_version_id = 'Current' THEN NULL ELSE B.ATTRIBUTE1 END
			 , @v_ver_group   	  = CASE WHEN @p_version_id = 'Current' THEN NULL ELSE B.ATTRIBUTE2 END
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
		
		SELECT SEGMENT1		AS LOSS_CODE
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
		  AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('Admin','SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회
		  --AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회
	END


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

	IF @p_check_empty = 'Y' BEGIN SET @p_check_line = 'Y' END 


	IF @debug_mode ='T'
	BEGIN
		PRINT '----------------------------------';
		PRINT '@v_max_day			=' +@v_max_day;
		PRINT '@v_start_day			=' +@v_start_day;
		PRINT '@v_end_day			=' +@v_end_day;
		PRINT '----------------------------------';
		PRINT '@v_start_month		=' +@v_start_month;
		PRINT '@v_end_month			=' +@v_end_month;
		PRINT '----------------------------------';
		PRINT '@v_start_avg			=' +@v_start_avg;
		PRINT '@v_end_avg			=' +@v_end_avg;
		PRINT '@v_start_result_avg	=' +@v_start_result_avg;
		PRINT '@v_end_result_avg	=' +@v_end_result_avg;
		PRINT '----------------------------------';
		PRINT '@v_start_year		=' +@v_start_year;
		PRINT '@v_end_year			=' +@v_end_year;
		PRINT '----------------------------------';
		PRINT '@v_bef_m6_yyyymm		=' +@v_bef_m6_yyyymm;
		PRINT '@v_bef_m5_yyyymm		=' +@v_bef_m5_yyyymm;
		PRINT '@v_bef_m4_yyyymm		=' +@v_bef_m4_yyyymm;
		PRINT '@v_bef_m3_yyyymm		=' +@v_bef_m3_yyyymm;
		PRINT '@v_bef_m2_yyyymm		=' +@v_bef_m2_yyyymm;
		PRINT '@v_bef_m1_yyyymm		=' +@v_bef_m1_yyyymm;
		PRINT '----------------------------------';
	END;

	-- ///////////////////////////////////////////////////////////////////////////////////
	-- 기준 테이블 생성
	-- SCM_LINE_HIERARCHY_V_SN 에 존재하는 데이터만 조회한다.
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD_ITEM') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD_ITEM;

		CREATE TABLE #TMP_SCP0049_STD_ITEM
		(
			   DIVISION_ID			NVARCHAR(030)
			 , COMPANY_ID			NVARCHAR(030)
			 , SITE_ID				NVARCHAR(030)
			 , SITE_NAME			NVARCHAR(100)
			 , PLANT_ID				NVARCHAR(030)
			 , OPERATION_GROUP_ID	NVARCHAR(030)
			 , OPERATION_GROUP_NAME	NVARCHAR(100)
			 , FACTORY_ID			NVARCHAR(030)
			 , FACTORY_NAME			NVARCHAR(100)
			 , OPERATION_ID			NVARCHAR(030)
			 , OPERATION_NAME		NVARCHAR(100)
			 , LINE_ID				NVARCHAR(030)
			 , LINE_NAME			NVARCHAR(100)
			 , ELECTRODE_TYPE		NVARCHAR(030)
			 , NICK_NAME			NVARCHAR(100)
			 , ITEM_ID				NVARCHAR(030)
			 , LANE_QTY				INT
		)

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD;

		CREATE TABLE #TMP_SCP0049_STD
		(
			   DIVISION_ID			NVARCHAR(030)
			 , COMPANY_ID			NVARCHAR(030)
			 , SITE_ID				NVARCHAR(030)
			 , SITE_NAME			NVARCHAR(100)
			 , PLANT_ID				NVARCHAR(030)
			 , OPERATION_GROUP_ID	NVARCHAR(030)
			 , OPERATION_GROUP_NAME	NVARCHAR(100)
			 , FACTORY_ID			NVARCHAR(030)
			 , FACTORY_NAME			NVARCHAR(100)
			 , OPERATION_ID			NVARCHAR(030)
			 , OPERATION_NAME		NVARCHAR(100)
			 , LINE_ID				NVARCHAR(030)
			 , LINE_NAME			NVARCHAR(100)
			 , ELECTRODE_TYPE		NVARCHAR(030)
		)

		INSERT INTO #TMP_SCP0049_STD
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
			 , OPERATION_ID
			 , OPERATION_NAME
			 , LINE_ID
			 , LINE_NAME
			 , ELECTRODE_TYPE
--		  INTO #TMP_SCP0049_STD 
		  FROM SCM_LINE_HIERARCHY_V_SN A
		 WHERE 1=1
		   AND (( @p_division_id		IS NULL OR @p_division_id		='') OR A.DIVISION_ID  			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_division_id		, ',')))
		   AND (( @p_plant_id			IS NULL OR @p_plant_id			='') OR A.PLANT_ID     			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_plant_id			, ',')))
		   AND (( @p_factory_id			IS NULL OR @p_factory_id		='') OR A.FACTORY_ID   			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_factory_id		, ',')))
		   AND (( @p_line_id			IS NULL OR @p_line_id			='') OR A.LINE_ID      			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_line_id			, ',')))
		   AND (( @p_operation_id		IS NULL OR @p_operation_id		='') OR A.OPERATION_ID 			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_operation_id		, ',')))
		   AND (( @p_group				IS NULL OR @p_group				='') OR A.OPERATION_GROUP_ID    IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_group				, ',')))
		   AND (( @v_ver_division_id	IS NULL OR @v_ver_division_id	='') OR A.DIVISION_ID  			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_division_id	, ',')))
		   AND (( @v_ver_group			IS NULL OR @v_ver_group			='') OR A.OPERATION_GROUP_ID    IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_group			, ',')))
	END
	
	-- ///////////////////////////////////////////////////////////////////////////////////
	-- LINE ASSIGN 기준 테이블 생성
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD_ITEM_DATA') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD_ITEM_DATA;

		CREATE TABLE #TMP_SCP0049_STD_ITEM_DATA
		(
			   DIVISION_ID			NVARCHAR(030)
			 , COMPANY_ID			NVARCHAR(030)
			 , SITE_ID				NVARCHAR(030)
			 , SITE_NAME			NVARCHAR(100)
			 , PLANT_ID				NVARCHAR(030)
			 , OPERATION_GROUP_ID	NVARCHAR(030)
			 , OPERATION_GROUP_NAME	NVARCHAR(100)
			 , FACTORY_ID			NVARCHAR(030)
			 , FACTORY_NAME			NVARCHAR(100)
			 , OPERATION_ID			NVARCHAR(030)
			 , OPERATION_NAME		NVARCHAR(100)
			 , LINE_ID				NVARCHAR(030)
			 , LINE_NAME			NVARCHAR(100)
			 , ELECTRODE_TYPE		NVARCHAR(030)
			 , NICK_NAME			NVARCHAR(100)
			 , ITEM_ID				NVARCHAR(030)
			 , LANE_QTY				INT
			 , PRIORITY             NVARCHAR(50)
			 ,ITEM_CLASS            NVARCHAR(50)
		)
			
        INSERT INTO #TMP_SCP0049_STD_ITEM_DATA
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
			 , ISNULL(B.LANE_QTY,0) AS LANE_QTY
			 , PRIORITY
			 , C.ITEM_CLASS -- cell assy 구분용 item class 추가... 20230703
		--INTO #TMP_SCP0049_STD_ITEM_DATA
		FROM #TMP_SCP0049_STD A
		LEFT OUTER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B
		  ON  1=1
		 AND A.DIVISION_ID 						= B.DIVISION_ID
		 AND A.SITE_ID 							= B.SITE_ID
		 AND A.PLANT_ID 						= B.PLANT_ID
		 AND A.FACTORY_ID 						= B.FACTORY_ID
		 AND A.LINE_ID 							= B.LINE_ID
		 AND A.OPERATION_ID 					= B.OPERATION_ID
		 AND A.ELECTRODE_TYPE 					= B.ELECTRODE_TYPE
		 AND B.MONTH 							>= @v_start_month
		 AND CONVERT(VARCHAR(4), B.MONTH,112) 	<= @v_end_year
			 --AND B.PRIORITY NOT IN ('0','9')
		LEFT OUTER JOIN SCM_ITEM_M_SN C
		  ON 1=1
		 AND B.COMPANY_ID 						= C.COMPANY_ID
		 AND B.DIVISION_ID 						= C.DIVISION_ID
		 AND B.SITE_ID 							= C.SITE_ID
		 AND B.ITEM_ID 							= C.ITEM_ID
		 AND C.ACTIVE_FLAG 						= 'Y'
	   WHERE 1=1
		 AND CASE WHEN @p_check_line = 'Y' OR @p_check_tact = 'Y' OR @p_check_yield = 'Y' THEN 'Y' ELSE 'N' END = 'Y'
		 AND (( @p_model_id     IS NULL OR @p_model_id     ='') OR ISNULL(C.APPLIED_MODEL,C.ITEM_ID) LIKE '%' + @p_model_id    +'%')
		 AND (( @p_item_id      IS NULL OR @p_item_id      ='') OR B.ITEM_ID      					LIKE '%' + @p_item_id     +'%')
		 AND (( @p_nick_name    IS NULL OR @p_nick_name    ='') OR C.NICK_NAME     					LIKE '%' + @p_nick_name   +'%')
		 AND B.ITEM_ID IS NOT NULL

		 --- 7월 한달 ITEM_ID 중 CELL_PRODUCT는 제외
		 --AND ( (A.OPERATION_ID IN ('A9000','A3000','F6000') AND ITEM_CLASS = 'ES1901')
		 --OR A.OPERATION_ID NOT IN ('A9000','A3000','F6000'))

		 ;

		/*
		--- site 별 처리에서 인스턴스 별 처리로 변경하여 주석처리... 20230725
		--* A9000, F6000 공정 활성화 코드 구분 관련 item 정리 :: 8월 해외 확장시 국내 로직 제거 및 해외 로직에 site 조건 제거 필요!! ... 20230703
		-- 1) 국내 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
		DELETE FROM #TMP_SCP0049_STD_ITEM_DATA
		WHERE  1=1
		AND    OPERATION_ID IN ('A9000','A3000','F6000') 
		AND    SITE_ID IN ( SELECT B.SEGMENT1 AS SITE_ID FROM SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK) WHERE  B.ACTIVE_FLAG = 'Y' AND B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY' )
		AND    ITEM_CLASS != 'ES1901'
		;
		
		-- 2) 해외 : A9000,F6000 의 cell assy 를 지우고 cell product 를 남긴다.
		DELETE FROM #TMP_SCP0049_STD_ITEM_DATA
		WHERE  1=1
		AND    OPERATION_ID IN ('A9000','A3000','F6000') 
		AND    SITE_ID NOT IN ( SELECT B.SEGMENT1 AS SITE_ID FROM SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK) WHERE  B.ACTIVE_FLAG = 'Y' AND B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY' )
		AND    ITEM_CLASS = 'ES1901'
		;
		*/

		/*
		---- 로직 통일화에 따라서 cell assy 만 남는걸로 통일... 20230809
		--- site 별 처리에서 인스턴스 별 처리로 변경... 20230725
		-- 1. cell assy 유효 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
		DELETE FROM #TMP_SCP0049_STD_ITEM_DATA
		FROM (
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
			FROM   FP_INSTANCE_LINE_V_SN A WITH(NOLOCK)
			WHERE  1=1
			AND    A.INSTANCE_ID IN (
				SELECT AA.SEGMENT1 AS INSTNACE_ID
				FROM   SCM_SYS_LOOKUP_VALUE_SN AA WITH(NOLOCK)
				WHERE  AA.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE'
				AND    AA.ATTRIBUTE1  = 'Y'
				AND    AA.ACTIVE_FLAG = 'Y'
			)
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
		) B
		WHERE  1=1
		AND    #TMP_SCP0049_STD_ITEM_DATA.COMPANY_ID     = B.COMPANY_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.DIVISION_ID    = B.DIVISION_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.SITE_ID        = B.SITE_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.PLANT_ID       = B.PLANT_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.FACTORY_ID     = B.FACTORY_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.OPERATION_ID   = B.OPERATION_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.LINE_ID        = B.LINE_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		AND    #TMP_SCP0049_STD_ITEM_DATA.OPERATION_ID IN ('A9000','A3000','F6000')
		AND    #TMP_SCP0049_STD_ITEM_DATA.ITEM_CLASS != 'ES1901'
		;

		-- 2. cell product 유효 : A9000,F6000 의 cell product 를 남기고 cell assy 를 지운다.
		DELETE FROM #TMP_SCP0049_STD_ITEM_DATA
		FROM (
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
			FROM   FP_INSTANCE_LINE_V_SN A WITH(NOLOCK)
			WHERE  1=1
			AND    A.INSTANCE_ID NOT IN (
				SELECT AA.SEGMENT1 AS INSTNACE_ID
				FROM   SCM_SYS_LOOKUP_VALUE_SN AA WITH(NOLOCK)
				WHERE  AA.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY_INSTANCE'
				AND    AA.ATTRIBUTE1  = 'Y'
				AND    AA.ACTIVE_FLAG = 'Y'
			)
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
		) B
		WHERE  1=1
		AND    #TMP_SCP0049_STD_ITEM_DATA.COMPANY_ID     = B.COMPANY_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.DIVISION_ID    = B.DIVISION_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.SITE_ID        = B.SITE_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.PLANT_ID       = B.PLANT_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.FACTORY_ID     = B.FACTORY_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.OPERATION_ID   = B.OPERATION_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.LINE_ID        = B.LINE_ID
		AND    #TMP_SCP0049_STD_ITEM_DATA.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		AND    #TMP_SCP0049_STD_ITEM_DATA.OPERATION_ID IN ('A9000','A3000','F6000')
		AND    #TMP_SCP0049_STD_ITEM_DATA.ITEM_CLASS = 'ES1901'
		;
		*/

		---- 로직 통일화에 따라서 cell assy 만 남는걸로 통일... 20230809
		-- 1. cell assy 유효 : A9000,F6000 의 cell assy 를 남기고 cell product 를 지운다.
		DELETE FROM #TMP_SCP0049_STD_ITEM_DATA
		WHERE  1=1
		AND    #TMP_SCP0049_STD_ITEM_DATA.OPERATION_ID IN ('A9000','A3000','F6000')
		AND    #TMP_SCP0049_STD_ITEM_DATA.ITEM_CLASS != 'ES1901'
		;

		
		INSERT INTO #TMP_SCP0049_STD_ITEM
		(
			   DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , SITE_NAME
			 , PLANT_ID
			 , OPERATION_GROUP_ID
			 , OPERATION_GROUP_NAME
			 , FACTORY_ID
			 , FACTORY_NAME
			 , OPERATION_ID
			 , OPERATION_NAME
			 , LINE_ID
			 , LINE_NAME
			 , ELECTRODE_TYPE
			 , NICK_NAME
			 , ITEM_ID
			 , LANE_QTY
			)
		SELECT DISTINCT
			   DIVISION_ID
			 , COMPANY_ID
			 , SITE_ID
			 , SITE_NAME
			 , PLANT_ID
			 , OPERATION_GROUP_ID
			 , OPERATION_GROUP_NAME
			 , FACTORY_ID
			 , FACTORY_NAME
			 , OPERATION_ID
			 , OPERATION_NAME
			 , LINE_ID
			 , LINE_NAME
			 , ELECTRODE_TYPE
			 , NICK_NAME
			 , ITEM_ID
			 , LANE_QTY
		  FROM #TMP_SCP0049_STD_ITEM_DATA A
		 WHERE (@p_check_empty = 'N' ) 
		    OR (@p_check_empty = 'Y' AND  PRIORITY NOT IN ('0','9') )
	END
	
	-- ///////////////////////////////////////////////////////////////////////////////////
	-- TACT TIME 기준 테이블 생성
	-- TACT TIME 은 LANE QTY 정보를 관리하지 않는다
	-- ///////////////////////////////////////////////////////////////////////////////////
	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD_ITEM_TACT') IS NOT NULL
		DROP TABLE #TMP_SCP0049_STD_ITEM_TACT;

		
		CREATE TABLE #TMP_SCP0049_STD_ITEM_TACT
		(
			   DIVISION_ID			NVARCHAR(030)
			 , COMPANY_ID			NVARCHAR(030)
			 , SITE_ID				NVARCHAR(030)
			 , SITE_NAME			NVARCHAR(100)
			 , PLANT_ID				NVARCHAR(030)
			 , OPERATION_GROUP_ID	NVARCHAR(030)
			 , OPERATION_GROUP_NAME	NVARCHAR(100)
			 , FACTORY_ID			NVARCHAR(030)
			 , FACTORY_NAME			NVARCHAR(100)
			 , OPERATION_ID			NVARCHAR(030)
			 , OPERATION_NAME		NVARCHAR(100)
			 , LINE_ID				NVARCHAR(030)
			 , LINE_NAME			NVARCHAR(100)
			 , ELECTRODE_TYPE		NVARCHAR(030)
			 , NICK_NAME			NVARCHAR(100)
			 , ITEM_ID				NVARCHAR(030)
		)

		INSERT INTO #TMP_SCP0049_STD_ITEM_TACT
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
		 -- INTO #TMP_SCP0049_STD_ITEM_TACT
		  FROM #TMP_SCP0049_STD_ITEM A
		;

	-- ///////////////////////////////////////////////////////////////////////////////////
	-- YIELD 기준 테이블 생성
	-- YIELD 은 LANE QTY , ELECTRODE_TYPE 정보를 관리하지 않는다
	-- ///////////////////////////////////////////////////////////////////////////////////
	BEGIN
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_STD_ITEM_YIELD') IS NOT NULL
			DROP TABLE #TMP_SCP0049_STD_ITEM_YIELD;


		CREATE TABLE #TMP_SCP0049_STD_ITEM_YIELD
		(
			   DIVISION_ID			NVARCHAR(030)
			 , COMPANY_ID			NVARCHAR(030)
			 , SITE_ID				NVARCHAR(030)
			 , SITE_NAME			NVARCHAR(100)
			 , PLANT_ID				NVARCHAR(030)
			 , OPERATION_GROUP_ID	NVARCHAR(030)
			 , OPERATION_GROUP_NAME	NVARCHAR(100)
			 , FACTORY_ID			NVARCHAR(030)
			 , FACTORY_NAME			NVARCHAR(100)
			 , OPERATION_ID			NVARCHAR(030)
			 , OPERATION_NAME		NVARCHAR(100)
			 , LINE_ID				NVARCHAR(030)
			 , LINE_NAME			NVARCHAR(100)
			 , NICK_NAME			NVARCHAR(100)
			 , ITEM_ID				NVARCHAR(030)
		)

		INSERT INTO #TMP_SCP0049_STD_ITEM_YIELD
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
			 , MAX(A.LINE_NAME) AS LINE_NAME
			 , A.NICK_NAME
			 , A.ITEM_ID
		--INTO #TMP_SCP0049_STD_ITEM_YIELD
		FROM #TMP_SCP0049_STD_ITEM A
		GROUP BY A.DIVISION_ID
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
			 , A.NICK_NAME
			 , A.ITEM_ID
	END	

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
			, ITEM_VALUE			NUMERIC(20,3)
			, ITEM_VALUE_RESULT		NUMERIC(20,3)
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
			, BEF_M6				NUMERIC(20,3)
			, BEF_M5				NUMERIC(20,3)
			, BEF_M4				NUMERIC(20,3)
			, BEF_M3				NUMERIC(20,3)
			, BEF_M2				NUMERIC(20,3)
			, BEF_M1				NUMERIC(20,3)
			, BEF_M6_RESULT			NUMERIC(20,3)
			, BEF_M5_RESULT			NUMERIC(20,3)
			, BEF_M4_RESULT			NUMERIC(20,3)
			, BEF_M3_RESULT			NUMERIC(20,3)
			, BEF_M2_RESULT			NUMERIC(20,3)
			, BEF_M1_RESULT			NUMERIC(20,3)
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
			, BEF_BEST				NUMERIC(20,3)
			, BEF_WORST				NUMERIC(20,3)
			, BEF_BEST_RESULT		NUMERIC(20,3)
			, BEF_WORST_RESULT		NUMERIC(20,3)
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

        -- 2021-09-39
		CREATE NONCLUSTERED INDEX TempTalbeIndex_LTY ON [dbo].[#TMP_SCP0049_LTY] ([LOSS_CODE], [DIVISION_ID],[COMPANY_ID],[SITE_ID],[PLANT_ID],[FACTORY_ID],[LINE_ID],[ELECTRODE_TYPE],[OPERATION_ID],[ITEM_ID]);

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
			, BEF_M6			NUMERIC(20,3)
			, BEF_M5			NUMERIC(20,3)
			, BEF_M4			NUMERIC(20,3)
			, BEF_M3			NUMERIC(20,3)
			, BEF_M2			NUMERIC(20,3)
			, BEF_M1			NUMERIC(20,3)
			, BEF_M6_RESULT		NUMERIC(20,3)
			, BEF_M5_RESULT		NUMERIC(20,3)
			, BEF_M4_RESULT		NUMERIC(20,3)
			, BEF_M3_RESULT		NUMERIC(20,3)
			, BEF_M2_RESULT		NUMERIC(20,3)
			, BEF_M1_RESULT		NUMERIC(20,3)
			, BEF_BEST			NUMERIC(20,3)
			, BEF_WORST			NUMERIC(20,3)
			, BEF_BEST_RESULT	NUMERIC(20,3)
			, BEF_WORST_RESULT	NUMERIC(20,3)
		)
	END

	IF @p_version_id = 'Current'  -- 현재
	BEGIN
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
				 JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				   ON CM.DIVISION_ID	= L.DIVISION_ID
				  AND CM.COMPANY_ID		= L.COMPANY_ID
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
				   ON LM.LOSS_CODE		= LU.LOSS_CODE
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
				
		IF @p_check_line = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_AVG_DATA
			
			-- LINE ASSIGN (월별 데이터)
			SELECT LM.COMPANY_ID
					, LM.DIVISION_ID
					, LM.SITE_ID
					, LM.PLANT_ID
					, LM.FACTORY_ID
					, LM.OPERATION_ID
					, LM.LINE_ID
					, LM.ELECTRODE_TYPE
					, 'LA001'								AS LOSS_CODE
					, LM.ITEM_ID
					, ISNULL(CONVERT(INT,LM.LANE_QTY),0)	AS LANE_QTY
					, LM.MONTH								AS YYYYMM
					, ISNULL(LM.PRIORITY,0)					AS ITEM_VALUE
					, ISNULL(LM.PRIORITY,0)					AS ITEM_VALUE_RESULT
				FROM SCM_MST_ITEM_LINE_ASSIGN_SN LM WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
				  ON LM.DIVISION_ID			= I.DIVISION_ID
				 AND LM.COMPANY_ID			= I.COMPANY_ID
				 AND LM.SITE_ID				= I.SITE_ID
				 AND LM.PLANT_ID			= I.PLANT_ID
				 AND LM.FACTORY_ID			= I.FACTORY_ID
				 AND LM.OPERATION_ID		= I.OPERATION_ID
				 AND LM.LINE_ID				= I.LINE_ID
				 AND LM.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				 AND LM.ITEM_ID				= I.ITEM_ID
				 AND ISNULL(LM.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

			   WHERE LM.MONTH >= @v_start_avg
				 AND LM.MONTH <= @v_end_avg

			-- 이력 테이블 조회
			IF @v_end_result_avg > @v_start_result_avg
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA
			
				-- LINE ASSIGN (월별 데이터)
				SELECT LM.COMPANY_ID
						, LM.DIVISION_ID
						, LM.SITE_ID
						, LM.PLANT_ID
						, LM.FACTORY_ID
						, LM.OPERATION_ID
						, LM.LINE_ID
						, LM.ELECTRODE_TYPE
						, 'LA001'								AS LOSS_CODE
						, LM.ITEM_ID
						, ISNULL(CONVERT(INT,LM.LANE_QTY),0)	AS LANE_QTY
						, LM.MONTH								AS YYYYMM
						, ISNULL(LM.PRIORITY,0)					AS ITEM_VALUE
						, ISNULL(LM.PRIORITY,0)					AS ITEM_VALUE_RESULT
					FROM HIST_SCM_ITEM_LINE_ASSIGN_M_SN LM WITH(NOLOCK)		-- 이력 테이블(HIST) 조회

					JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
					  ON LM.DIVISION_ID			= I.DIVISION_ID
					 AND LM.COMPANY_ID			= I.COMPANY_ID
					 AND LM.SITE_ID				= I.SITE_ID
					 AND LM.PLANT_ID			= I.PLANT_ID
					 AND LM.FACTORY_ID			= I.FACTORY_ID
					 AND LM.OPERATION_ID		= I.OPERATION_ID
					 AND LM.LINE_ID				= I.LINE_ID
					 AND LM.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
					 AND LM.ITEM_ID				= I.ITEM_ID
					 AND ISNULL(LM.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				   WHERE LM.MONTH >= @v_start_result_avg
					 AND LM.MONTH <= @v_end_result_avg
			END -- 이력 테이블(HIST) 조회
					
		END

		IF @p_check_tact = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_AVG_DATA
			
			SELECT TM.COMPANY_ID
					, TM.DIVISION_ID
					, TM.SITE_ID
					, TM.PLANT_ID
					, TM.FACTORY_ID
					, TM.OPERATION_ID
					, TM.LINE_ID
					, TM.ELECTRODE_TYPE
					, 'LA002'				AS LOSS_CODE
					, TM.ITEM_ID			AS ITEM_ID
					, 0						AS LANE_QTY
					, TM.MONTH				AS YYYYMM
					, ISNULL(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TM.DAILY_CAPA  ELSE  TM.TACT_TIME END,0) ITEM_VALUE
					, ISNULL(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TM.DAILY_CAPA  ELSE  TM.RESULT_TACT_TIME END,0) ITEM_VALUE_RESULT
				 FROM SCM_MST_TACT_TIME_SN TM WITH(NOLOCK)

				 JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
				   ON TM.DIVISION_ID	= I.DIVISION_ID
				  AND TM.COMPANY_ID		= I.COMPANY_ID
				  AND TM.SITE_ID		= I.SITE_ID
				  AND TM.PLANT_ID		= I.PLANT_ID
				  AND TM.FACTORY_ID		= I.FACTORY_ID
				  AND TM.OPERATION_ID	= I.OPERATION_ID
				  AND TM.LINE_ID		= I.LINE_ID
				  AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				  AND TM.ITEM_ID		= I.ITEM_ID
					   
				 JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				   ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				  AND LV.SEGMENT1 			= 'LA002'
				  AND TM.PLANT_ID			= LV.SEGMENT2
				  AND TM.OPERATION_ID		= LV.SEGMENT3
				  AND LV.ACTIVE_FLAG = 'Y'					   

				WHERE TM.MONTH >= @v_start_avg
				  AND TM.MONTH <= @v_end_avg
					

			-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
			UNION ALL

			SELECT TM.COMPANY_ID
					, TM.DIVISION_ID
					, TM.SITE_ID
					, TM.PLANT_ID
					, TM.FACTORY_ID
					, TM.OPERATION_ID
					, TM.LINE_ID
					, TM.ELECTRODE_TYPE
					, 'LA999'					AS LOSS_CODE			
					, TM.ITEM_ID				AS ITEM_ID
					, 0							AS LANE_QTY
					, TM.MONTH					AS YYYYMM
					, ISNULL(TM.DAILY_CAPA,0)	AS ITEM_VALUE
					, ISNULL(TM.DAILY_CAPA,0)	AS ITEM_VALUE_RESULT
				FROM SCM_MST_TACT_TIME_SN TM WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
				  ON TM.DIVISION_ID		= I.DIVISION_ID
				 AND TM.COMPANY_ID		= I.COMPANY_ID
				 AND TM.SITE_ID			= I.SITE_ID
				 AND TM.PLANT_ID		= I.PLANT_ID
				 AND TM.FACTORY_ID		= I.FACTORY_ID
				 AND TM.OPERATION_ID	= I.OPERATION_ID
				 AND TM.LINE_ID			= I.LINE_ID
				 AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				 AND TM.ITEM_ID			= I.ITEM_ID
					   
				JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
				  ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				 AND LV.SEGMENT1 			= 'LA002'
				 AND TM.PLANT_ID			= LV.SEGMENT2
				 AND TM.OPERATION_ID		= LV.SEGMENT3
				 AND LV.ACTIVE_FLAG			= 'Y'
				 AND LV.ATTRIBUTE1			= 'TACT TIME'

			   WHERE TM.MONTH >= @v_start_avg
				 AND TM.MONTH <= @v_end_avg

			-- 이력 테이블 조회
			IF @v_end_result_avg > @v_start_result_avg
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA

				SELECT TM.COMPANY_ID
					, TM.DIVISION_ID
					, TM.SITE_ID
					, TM.PLANT_ID
					, TM.FACTORY_ID
					, TM.OPERATION_ID
					, TM.LINE_ID
					, TM.ELECTRODE_TYPE
					, 'LA002'				AS LOSS_CODE
					, TM.ITEM_ID			AS ITEM_ID
					, 0						AS LANE_QTY
					, TM.MONTH				AS YYYYMM
					, ISNULL(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TM.DAILY_CAPA  ELSE  TM.TACT_TIME END,0) ITEM_VALUE
					, ISNULL(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TM.DAILY_CAPA  ELSE  TM.RESULT_TACT_TIME END,0) ITEM_VALUE_RESULT
				 FROM HIST_SCM_TACT_TIME_M_SN TM WITH(NOLOCK)		-- 이력 테이블(HIST) 조회

				 JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
				   ON TM.DIVISION_ID	= I.DIVISION_ID
				  AND TM.COMPANY_ID		= I.COMPANY_ID
				  AND TM.SITE_ID		= I.SITE_ID
				  AND TM.PLANT_ID		= I.PLANT_ID
				  AND TM.FACTORY_ID		= I.FACTORY_ID
				  AND TM.OPERATION_ID	= I.OPERATION_ID
				  AND TM.LINE_ID		= I.LINE_ID
				  AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				  AND TM.ITEM_ID		= I.ITEM_ID
					   
				 JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				   ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				  AND LV.SEGMENT1 			= 'LA002'
				  AND TM.PLANT_ID			= LV.SEGMENT2
				  AND TM.OPERATION_ID		= LV.SEGMENT3
				  AND LV.ACTIVE_FLAG = 'Y'					   

				WHERE TM.MONTH >= @v_start_result_avg
				  AND TM.MONTH <= @v_end_result_avg
					

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL

				SELECT TM.COMPANY_ID
						, TM.DIVISION_ID
						, TM.SITE_ID
						, TM.PLANT_ID
						, TM.FACTORY_ID
						, TM.OPERATION_ID
						, TM.LINE_ID
						, TM.ELECTRODE_TYPE
						, 'LA999'					AS LOSS_CODE			
						, TM.ITEM_ID				AS ITEM_ID
						, 0							AS LANE_QTY
						, TM.MONTH					AS YYYYMM
						, ISNULL(TM.DAILY_CAPA,0)	AS ITEM_VALUE
						, ISNULL(TM.DAILY_CAPA,0)	AS ITEM_VALUE_RESULT
					FROM HIST_SCM_TACT_TIME_M_SN TM WITH(NOLOCK)		-- 이력 테이블(HIST) 조회

					JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
					  ON TM.DIVISION_ID		= I.DIVISION_ID
					 AND TM.COMPANY_ID		= I.COMPANY_ID
					 AND TM.SITE_ID			= I.SITE_ID
					 AND TM.PLANT_ID		= I.PLANT_ID
					 AND TM.FACTORY_ID		= I.FACTORY_ID
					 AND TM.OPERATION_ID	= I.OPERATION_ID
					 AND TM.LINE_ID			= I.LINE_ID
					 AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
					 AND TM.ITEM_ID			= I.ITEM_ID
						   
					JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
					  ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
					 AND LV.SEGMENT1 			= 'LA002'
					 AND TM.PLANT_ID			= LV.SEGMENT2
					 AND TM.OPERATION_ID		= LV.SEGMENT3
					 AND LV.ACTIVE_FLAG			= 'Y'
					 AND LV.ATTRIBUTE1			= 'TACT TIME'

				   WHERE TM.MONTH >= @v_start_result_avg
					 AND TM.MONTH <= @v_end_result_avg
			END -- 이력 테이블(HIST) 조회
		END

		IF @p_check_yield = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_AVG_DATA
			
		    SELECT YM.COMPANY_ID
					, YM.DIVISION_ID
					, YM.SITE_ID
					, YM.PLANT_ID
					, YM.FACTORY_ID
					, YM.OPERATION_ID
					, YM.LINE_ID
					, '-'									AS ELECTRODE_TYPE
					, 'LA003'								AS LOSS_CODE
					, YM.ITEM_ID							AS ITEM_ID
					, 0										AS LANE_QTY
					, YM.MONTH								AS YYYYMM
					, ISNULL(YM.YIELD			* 100,0)	AS ITEM_VALUE
					, ISNULL(YM.RESULT_YIELD	* 100,0)	AS ITEM_VALUE_RESULT
				FROM SCM_MST_YIELD_SN YM WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
				  ON YM.DIVISION_ID		= I.DIVISION_ID
				 AND YM.COMPANY_ID		= I.COMPANY_ID
				 AND YM.SITE_ID			= I.SITE_ID
				 AND YM.PLANT_ID		= I.PLANT_ID
				 AND YM.FACTORY_ID		= I.FACTORY_ID
				 AND YM.OPERATION_ID	= I.OPERATION_ID
				 AND YM.LINE_ID			= I.LINE_ID
				 AND YM.ITEM_ID			= I.ITEM_ID

			   WHERE YM.MONTH >= @v_start_avg
				 AND YM.MONTH <= @v_end_avg

			-- 이력 테이블 조회
			IF @v_end_result_avg > @v_start_result_avg
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA
			
			    SELECT YM.COMPANY_ID
						, YM.DIVISION_ID
						, YM.SITE_ID
						, YM.PLANT_ID
						, YM.FACTORY_ID
						, YM.OPERATION_ID
						, YM.LINE_ID
						, '-'									AS ELECTRODE_TYPE
						, 'LA003'								AS LOSS_CODE
						, YM.ITEM_ID							AS ITEM_ID
						, 0										AS LANE_QTY
						, YM.MONTH								AS YYYYMM
						, ISNULL(YM.YIELD			* 100,0)	AS ITEM_VALUE
						, ISNULL(YM.RESULT_YIELD	* 100,0)	AS ITEM_VALUE_RESULT
					FROM HIST_SCM_YIELD_M_SN YM WITH(NOLOCK)	-- 이력 테이블(HIST) 조회

					JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
					  ON YM.DIVISION_ID		= I.DIVISION_ID
					 AND YM.COMPANY_ID		= I.COMPANY_ID
					 AND YM.SITE_ID			= I.SITE_ID
					 AND YM.PLANT_ID		= I.PLANT_ID
					 AND YM.FACTORY_ID		= I.FACTORY_ID
					 AND YM.OPERATION_ID	= I.OPERATION_ID
					 AND YM.LINE_ID			= I.LINE_ID
					 AND YM.ITEM_ID			= I.ITEM_ID

				   WHERE YM.MONTH >= @v_start_result_avg
					 AND YM.MONTH <= @v_end_result_avg
			END -- 이력 테이블(HIST) 조회
		END

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
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M6
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M5
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M4
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M3
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M2
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			AS BEF_M1
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M6_RESULT
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M5_RESULT
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M4_RESULT
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M3_RESULT
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M2_RESULT
				--, ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0)	AS BEF_M1_RESULT

					, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)		   , '##0.###')	AS BEF_M6
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			, '##0.###') AS BEF_M5
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			, '##0.###') AS BEF_M4
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			, '##0.###') AS BEF_M3
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			, '##0.###') AS BEF_M2
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE ELSE 0 END ),0)			, '##0.###') AS BEF_M1
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m6_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M6_RESULT
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m5_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M5_RESULT
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m4_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M4_RESULT
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m3_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M3_RESULT
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m2_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M2_RESULT
				, FORMAT(ISNULL(SUM(CASE WHEN YYYYMM = @v_bef_m1_yyyymm THEN ITEM_VALUE_RESULT ELSE 0 END ),0) , '##0.###')	AS BEF_M1_RESULT

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
				AND CONVERT(CHAR(8), CM.WORK_DATE , 112) >=  @v_start_day
				AND CONVERT(CHAR(8), CM.WORK_DATE , 112) <=  @v_end_day
		END
	
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
		-- Line Priority , TACT TIME , YIELD 데이터 일별
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_line = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
			-- 일 별 Line Priority 정의
			SELECT LE.DIVISION_ID
					, LE.COMPANY_ID		AS COMPANY_ID
					, LE.SITE_ID			AS SITE_ID
					, LE.PLANT_ID			AS PLANT_ID
					, LE.FACTORY_ID		AS FACTORY_ID
					, LE.LINE_ID			AS LINE_ID
					, LE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					, LE.OPERATION_ID		AS OPERATION_ID
					, 'LA001'				AS LOSS_CODE
					, LE.ITEM_ID			AS ITEM_ID
					, ISNULL(CONVERT(INT , LE.LANE_QTY),0) 	AS LANE_QTY
					, CONVERT(CHAR(8), LE.START_TIME , 112)	AS YYYYMMDD
					, NULL										AS YYYYMM
					, NULL										AS YYYY
					, LE.PRIORITY			AS ITEM_VALUE
			FROM SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN  LE WITH(NOLOCK)

			JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)  -- 수정
				ON LE.DIVISION_ID			= I.DIVISION_ID
				    AND LE.COMPANY_ID			= I.COMPANY_ID
				    AND LE.SITE_ID				= I.SITE_ID
				    AND LE.PLANT_ID				= I.PLANT_ID
				    AND LE.FACTORY_ID			= I.FACTORY_ID
				    AND LE.OPERATION_ID			= I.OPERATION_ID
				    AND LE.LINE_ID				= I.LINE_ID
				    AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				    AND LE.ITEM_ID				= I.ITEM_ID
				    AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

			JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
				ON LE.DIVISION_ID		= L.DIVISION_ID
				    AND LE.COMPANY_ID		= L.COMPANY_ID
				    AND LE.SITE_ID			= L.SITE_ID
				    AND LE.PLANT_ID			= L.PLANT_ID
				    AND LE.FACTORY_ID		= L.FACTORY_ID
				    AND LE.OPERATION_ID		= L.OPERATION_ID
				    AND LE.LINE_ID			= L.LINE_ID
				    AND LE.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				WHERE 1 = 1
				AND CONVERT(CHAR(8), LE.START_TIME , 112) >= @v_start_day
				AND CONVERT(CHAR(8), LE.START_TIME , 112) <= @v_end_day
		END

		IF @p_check_tact = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, CONVERT(CHAR(8), TE.START_TIME , 112)	AS YYYYMMDD
					, NULL										AS YYYYMM
					, NULL										AS YYYY
					, CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						WHEN LV.ATTRIBUTE1 = 'TACT TIME' THEN TE.TACT_TIME END		AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_EXCEPT_SN TE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
				ON TE.DIVISION_ID		= I.DIVISION_ID
				AND TE.COMPANY_ID		= I.COMPANY_ID
				AND TE.SITE_ID			= I.SITE_ID
				AND TE.PLANT_ID			= I.PLANT_ID
				AND TE.FACTORY_ID		= I.FACTORY_ID
				AND TE.OPERATION_ID		= I.OPERATION_ID
				AND TE.LINE_ID			= I.LINE_ID
				AND TE.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				AND TE.ITEM_ID			= I.ITEM_ID
				   
				JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				AND LV.SEGMENT1 			= 'LA002'
				AND TE.PLANT_ID			= LV.SEGMENT2
				AND TE.OPERATION_ID		= LV.SEGMENT3
				AND LV.ACTIVE_FLAG = 'Y'			   

				WHERE 1 = 1
				AND CONVERT(CHAR(8), TE.START_TIME , 112) >= @v_start_day
				AND CONVERT(CHAR(8), TE.START_TIME , 112) <= @v_end_day

			-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
			UNION ALL

			SELECT TE.DIVISION_ID
					, TE.COMPANY_ID		AS COMPANY_ID
					, TE.SITE_ID			AS SITE_ID
					, TE.PLANT_ID			AS PLANT_ID
					, TE.FACTORY_ID		AS FACTORY_ID
					, TE.LINE_ID			AS LINE_ID
					, TE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					, TE.OPERATION_ID		AS OPERATION_ID
					, 'LA999'				AS LOSS_CODE
					, TE.ITEM_ID			AS ITEM_ID
					, 0					AS LANE_QTY
					, CONVERT(CHAR(8), TE.START_TIME , 112)	AS YYYYMMDD
					, NULL										AS YYYYMM
					, NULL										AS YYYY
					, TE.DAILY_CAPA							AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_EXCEPT_SN TE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
				ON TE.DIVISION_ID		= I.DIVISION_ID
				AND TE.COMPANY_ID		= I.COMPANY_ID
				AND TE.SITE_ID			= I.SITE_ID
				AND TE.PLANT_ID			= I.PLANT_ID
				AND TE.FACTORY_ID		= I.FACTORY_ID
				AND TE.OPERATION_ID		= I.OPERATION_ID
				AND TE.LINE_ID			= I.LINE_ID
				AND TE.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				AND TE.ITEM_ID			= I.ITEM_ID
				   
				JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				AND LV.SEGMENT1 			= 'LA002'
				AND TE.PLANT_ID			= LV.SEGMENT2
				AND TE.OPERATION_ID		= LV.SEGMENT3
				AND LV.ACTIVE_FLAG		= 'Y'
				AND LV.ATTRIBUTE1		= 'TACT TIME'

				WHERE 1 = 1
				AND CONVERT(CHAR(8), TE.START_TIME , 112) >= @v_start_day
				AND CONVERT(CHAR(8), TE.START_TIME , 112) <= @v_end_day
		END

		IF @p_check_yield = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, YE.COMPANY_ID		AS COMPANY_ID
					, YE.SITE_ID			AS SITE_ID
					, YE.PLANT_ID			AS PLANT_ID
					, YE.FACTORY_ID		AS FACTORY_ID
					, YE.LINE_ID			AS LINE_ID
					, '-'					AS ELECTRODE_TYPE   -- I.ELECTRODE_TYPE
					, YE.OPERATION_ID		AS OPERATION_ID
					, 'LA003'				AS LOSS_CODE
					, YE.ITEM_ID			AS ITEM_ID
					, 0					AS LANE_QTY
					, CONVERT(CHAR(8), YE.START_TIME , 112)	AS YYYYMMDD
					, NULL										AS YYYYMM
					, NULL										AS YYYY
					, ROUND(YE.YIELD * 100 , 2 )				AS ITEM_VALUE
				FROM SCM_MST_YIELD_EXCEPT_SN YE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
				ON YE.DIVISION_ID		= I.DIVISION_ID
				AND YE.COMPANY_ID		= I.COMPANY_ID
				AND YE.SITE_ID			= I.SITE_ID
				AND YE.PLANT_ID			= I.PLANT_ID
				AND YE.FACTORY_ID		= I.FACTORY_ID
				AND YE.OPERATION_ID		= I.OPERATION_ID
				AND YE.LINE_ID			= I.LINE_ID
				AND YE.ITEM_ID			= I.ITEM_ID

				WHERE 1 = 1
				AND CONVERT(CHAR(8), YE.START_TIME , 112) >= @v_start_day
				AND CONVERT(CHAR(8), YE.START_TIME , 112) <= @v_end_day
		END
	
		-- ///////////////////////////////////////////////////////////////////////////////
		-- Line Priority , TACT TIME , YIELD 월별 데이터
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_line = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY        -- 여기부터
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
			SELECT LE.DIVISION_ID
					, LE.COMPANY_ID		AS COMPANY_ID
					, LE.SITE_ID			AS SITE_ID
					, LE.PLANT_ID			AS PLANT_ID
					, LE.FACTORY_ID		AS FACTORY_ID
					, LE.LINE_ID			AS LINE_ID
					, LE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					, LE.OPERATION_ID		AS OPERATION_ID
					, 'LA001'				AS LOSS_CODE
					, LE.ITEM_ID			AS ITEM_ID
					, ISNULL(CONVERT(INT,LE.LANE_QTY),0)	AS LANE_QTY
					, NULL							AS YYYYMMDD
					, LE.MONTH						AS YYYYMM
					, NULL							AS YYYY
					, CONVERT(NUMERIC(10,4),LE.PRIORITY)			AS ITEM_VALUE
				FROM SCM_MST_ITEM_LINE_ASSIGN_SN LE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
				ON LE.DIVISION_ID			= I.DIVISION_ID
				AND LE.COMPANY_ID			= I.COMPANY_ID
				AND LE.SITE_ID				= I.SITE_ID
				AND LE.PLANT_ID				= I.PLANT_ID
				AND LE.FACTORY_ID			= I.FACTORY_ID
				AND LE.OPERATION_ID			= I.OPERATION_ID
				AND LE.LINE_ID				= I.LINE_ID
				AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				AND LE.ITEM_ID				= I.ITEM_ID
				AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				WHERE 1 = 1
				AND LE.MONTH >= @v_start_month
				AND LE.MONTH <= @v_end_month
		END

		IF @p_check_tact = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						WHEN LV.ATTRIBUTE1 = 'TACT TIME' THEN TE.TACT_TIME END		AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_SN TE WITH(NOLOCK)
				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				AND LV.ACTIVE_FLAG = 'Y'

				WHERE 1 = 1
				AND TE.MONTH >= @v_start_month
				AND TE.MONTH <= @v_end_month

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL

				SELECT TE.DIVISION_ID
					, TE.COMPANY_ID		AS COMPANY_ID
					, TE.SITE_ID			AS SITE_ID
					, TE.PLANT_ID			AS PLANT_ID
					, TE.FACTORY_ID		AS FACTORY_ID
					, TE.LINE_ID			AS LINE_ID
					, TE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					, TE.OPERATION_ID		AS OPERATION_ID
					, 'LA999'				AS LOSS_CODE
					, TE.ITEM_ID			AS ITEM_ID
					, 0					AS LANE_QTY
					, NULL					AS YYYYMMDD
					, TE.MONTH				AS YYYYMM
					, NULL					AS YYYY
					, TE.DAILY_CAPA		AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_SN TE WITH(NOLOCK)
				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				AND LV.ATTRIBUTE1		= 'TACT TIME'

				WHERE 1 = 1
				AND TE.MONTH >= @v_start_month
				AND TE.MONTH <= @v_end_month
		END

		IF @p_check_yield = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, '-' 							AS ELECTRODE_TYPE  --I.ELECTRODE_TYPE
					, YE.OPERATION_ID					AS OPERATION_ID
					, 'LA003'							AS LOSS_CODE
					, YE.ITEM_ID						AS ITEM_ID
					, 0								AS LANE_QTY
					, NULL								AS YYYYMMDD
					, YE.MONTH							AS YYYYMM
					, NULL								AS YYYY
					, ROUND(YE.YIELD * 100 , 2 )		AS ITEM_VALUE
				FROM SCM_MST_YIELD_SN YE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
				ON YE.DIVISION_ID		= I.DIVISION_ID
				AND YE.COMPANY_ID		= I.COMPANY_ID
				AND YE.SITE_ID			= I.SITE_ID
				AND YE.PLANT_ID			= I.PLANT_ID
				AND YE.FACTORY_ID		= I.FACTORY_ID
				AND YE.OPERATION_ID		= I.OPERATION_ID
				AND YE.LINE_ID			= I.LINE_ID
				AND YE.ITEM_ID			= I.ITEM_ID

				WHERE 1 = 1
				AND YE.MONTH >= @v_start_month
				AND YE.MONTH <= @v_end_month
		END

		-- /////////////////////////////////////////////////////////////////////
		-- LTY YEAR 값 조회
		-- /////////////////////////////////////////////////////////////////////
		IF @p_check_line = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
			SELECT LE.DIVISION_ID
					, LE.COMPANY_ID
					, LE.SITE_ID
					, LE.PLANT_ID
					, LE.FACTORY_ID
					, LE.LINE_ID
					, LE.ELECTRODE_TYPE
					, LE.OPERATION_ID
					, 'LA001'									AS LOSS_CODE
					, LE.ITEM_ID								AS ITEM_ID
					, ISNULL(CONVERT(INT,LE.LANE_QTY),0)		AS LANE_QTY
					, NULL										AS YYYYMMDD
					, NULL										AS YYYYMM
					, CONVERT(VARCHAR(4), LE.MONTH,112)		AS YYYY
					, MIN(CONVERT(NUMERIC(10,4),LE.PRIORITY))	AS ITEM_VALUE
				FROM SCM_MST_ITEM_LINE_ASSIGN_SN LE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
				ON LE.DIVISION_ID			= I.DIVISION_ID
				AND LE.COMPANY_ID			= I.COMPANY_ID
				AND LE.SITE_ID				= I.SITE_ID
				AND LE.PLANT_ID				= I.PLANT_ID
				AND LE.FACTORY_ID			= I.FACTORY_ID
				AND LE.OPERATION_ID			= I.OPERATION_ID
				AND LE.LINE_ID				= I.LINE_ID
				AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				AND LE.ITEM_ID				= I.ITEM_ID
				AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				WHERE 1 = 1
				AND CONVERT(VARCHAR(4),LE.MONTH) >= @v_start_year
				AND CONVERT(VARCHAR(4),LE.MONTH) <= @v_end_year

				GROUP BY LE.COMPANY_ID
				, LE.DIVISION_ID
				, LE.SITE_ID
				, LE.PLANT_ID
				, LE.FACTORY_ID
				, LE.OPERATION_ID
				, LE.LINE_ID
				, LE.ELECTRODE_TYPE
				, LE.ITEM_ID
				, ISNULL(CONVERT(INT,LE.LANE_QTY),0)
				, CONVERT(VARCHAR(4), LE.MONTH,112)
		END

		IF @p_check_tact = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, TE.COMPANY_ID						AS COMPANY_ID
					, TE.SITE_ID							AS SITE_ID
					, TE.PLANT_ID							AS PLANT_ID
					, TE.FACTORY_ID						AS FACTORY_ID
					, TE.LINE_ID							AS LINE_ID
					, TE.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					, TE.OPERATION_ID						AS OPERATION_ID
					, 'LA002'								AS LOSS_CODE
					, TE.ITEM_ID							AS ITEM_ID
					, 0									AS LANE_QTY
					, NULL									AS YYYYMMDD
					, NULL									AS YYYYMM
					, CONVERT(VARCHAR(4), TE.MONTH,112)	AS YYYY
					, MIN(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						 	WHEN LV.ATTRIBUTE1 = 'TACT TIME'  THEN TE.TACT_TIME END)		AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_SN TE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				AND LV.ACTIVE_FLAG = 'Y'							   

				WHERE 1 = 1
				AND CONVERT(VARCHAR(4),TE.MONTH) >= @v_start_year
				AND CONVERT(VARCHAR(4),TE.MONTH) <= @v_end_year

				GROUP BY TE.COMPANY_ID
				, TE.DIVISION_ID
				, TE.SITE_ID
				, TE.PLANT_ID
				, TE.FACTORY_ID
				, TE.OPERATION_ID
				, TE.LINE_ID
				, TE.ELECTRODE_TYPE
				, TE.ITEM_ID
				, CONVERT(VARCHAR(4), TE.MONTH,112)

			-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
			UNION ALL

			SELECT TE.DIVISION_ID
					, TE.COMPANY_ID						AS COMPANY_ID
					, TE.SITE_ID							AS SITE_ID
					, TE.PLANT_ID							AS PLANT_ID
					, TE.FACTORY_ID						AS FACTORY_ID
					, TE.LINE_ID							AS LINE_ID
					, TE.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					, TE.OPERATION_ID						AS OPERATION_ID
					, 'LA999'								AS LOSS_CODE
					, TE.ITEM_ID							AS ITEM_ID
					, 0									AS LANE_QTY
					, NULL									AS YYYYMMDD
					, NULL									AS YYYYMM
					, CONVERT(VARCHAR(4), TE.MONTH,112)	AS YYYY
					, MIN(TE.DAILY_CAPA) 					AS ITEM_VALUE
				FROM SCM_MST_TACT_TIME_SN TE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				AND LV.ATTRIBUTE1		= 'TACT TIME'

				WHERE 1 = 1
				AND CONVERT(VARCHAR(4),TE.MONTH) >= @v_start_year
				AND CONVERT(VARCHAR(4),TE.MONTH) <= @v_end_year

				GROUP BY TE.COMPANY_ID
				, TE.DIVISION_ID
				, TE.SITE_ID
				, TE.PLANT_ID
				, TE.FACTORY_ID
				, TE.OPERATION_ID
				, TE.LINE_ID
				, TE.ELECTRODE_TYPE
				, TE.ITEM_ID
				, CONVERT(VARCHAR(4), TE.MONTH,112)
		END

		IF @p_check_yield = 'Y'
		BEGIN
			INSERT INTO #TMP_SCP0049_LTY
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
					, YE.COMPANY_ID		AS COMPANY_ID
					, YE.SITE_ID			AS SITE_ID
					, YE.PLANT_ID			AS PLANT_ID
					, YE.FACTORY_ID		AS FACTORY_ID
					, YE.LINE_ID			AS LINE_ID
					, '-'					AS ELECTRODE_TYPE --I.ELECTRODE_TYPE
					, YE.OPERATION_ID		AS OPERATION_ID
					, 'LA003'				AS LOSS_CODE
					, YE.ITEM_ID			AS ITEM_ID
					, 0					AS LANE_QTY
					, NULL					AS YYYYMMDD
					, NULL									AS YYYYMM
					, CONVERT(VARCHAR(4), YE.MONTH,112)	AS YYYY
					, ROUND(MAX(YE.YIELD * 100 ) , 2)		AS ITEM_VALUE
				FROM SCM_MST_YIELD_SN YE WITH(NOLOCK)

				JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
				ON YE.DIVISION_ID		= I.DIVISION_ID
				AND YE.COMPANY_ID		= I.COMPANY_ID
				AND YE.SITE_ID			= I.SITE_ID
				AND YE.PLANT_ID			= I.PLANT_ID
				AND YE.FACTORY_ID		= I.FACTORY_ID
				AND YE.OPERATION_ID		= I.OPERATION_ID
				AND YE.LINE_ID			= I.LINE_ID
				AND YE.ITEM_ID			= I.ITEM_ID

				WHERE 1 = 1
				AND CONVERT(VARCHAR(4),YE.MONTH) >= @v_start_year
				AND CONVERT(VARCHAR(4),YE.MONTH) <= @v_end_year

			GROUP BY YE.COMPANY_ID
				, YE.DIVISION_ID
				, YE.SITE_ID
				, YE.PLANT_ID
				, YE.FACTORY_ID
				, YE.OPERATION_ID
				, YE.LINE_ID
				, YE.ITEM_ID
				, CONVERT(VARCHAR(4), YE.MONTH,112)
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

		-- ///////////////////////////////////////////////////////////////////////////////
		-- LTY Line Priority 기준으로 정보 Tact Time , Yield 추가
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_tact = 'Y'
		BEGIN 
			INSERT INTO #TMP_SCP0049_LTY
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
			)
			SELECT DISTINCT DIVISION_ID         -- 2021-09-30 distinct 추가
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, 'LA002'
				, ITEM_ID
				, @v_start_month
			FROM 
            (
                SELECT --DISTINCT         -- 2021-09-30 distinct 제거
		                R.DIVISION_ID
	                , R.COMPANY_ID
	                , R.SITE_ID
	                , R.PLANT_ID
	                , R.FACTORY_ID
	                , R.LINE_ID
	                , R.ELECTRODE_TYPE
	                , R.OPERATION_ID
	                , R.ITEM_ID
                FROM #TMP_SCP0049_STD_ITEM R

				EXCEPT

				SELECT --DISTINCT         -- 2021-09-30 distinct 제거
						R.DIVISION_ID
					, R.COMPANY_ID
					, R.SITE_ID
					, R.PLANT_ID
					, R.FACTORY_ID
					, R.LINE_ID
					, R.ELECTRODE_TYPE
					, R.OPERATION_ID
					, R.ITEM_ID
				FROM #TMP_SCP0049_LTY R
				WHERE R.LOSS_CODE = 'LA002'
            ) A
				
			-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
			INSERT INTO #TMP_SCP0049_LTY
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
			)
			SELECT DISTINCT DIVISION_ID         -- 2021-09-30 distinct 추가
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, 'LA999'
				, ITEM_ID
				, @v_start_month
			FROM
            (
                SELECT --DISTINCT         -- 2021-09-30 distinct 제거
		                R.DIVISION_ID
	                , R.COMPANY_ID
	                , R.SITE_ID
	                , R.PLANT_ID
	                , R.FACTORY_ID
	                , R.LINE_ID
	                , R.ELECTRODE_TYPE
	                , R.OPERATION_ID
	                , R.ITEM_ID
                FROM #TMP_SCP0049_LTY R
                JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
	                ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
	                AND LV.SEGMENT1 			= 'LA002'
	                AND R.PLANT_ID		= LV.SEGMENT2
	                AND R.OPERATION_ID	= LV.SEGMENT3
	                AND LV.ACTIVE_FLAG = 'Y'
	                AND LV.ATTRIBUTE1	= 'TACT TIME'
                WHERE R.LOSS_CODE = 'LA001'

                EXCEPT

                SELECT --DISTINCT         -- 2021-09-30 distinct 제거
		                R.DIVISION_ID
	                , R.COMPANY_ID
	                , R.SITE_ID
	                , R.PLANT_ID
	                , R.FACTORY_ID
	                , R.LINE_ID
	                , R.ELECTRODE_TYPE
	                , R.OPERATION_ID
	                , R.ITEM_ID
                FROM #TMP_SCP0049_LTY R
                WHERE R.LOSS_CODE = 'LA999'
            ) A
		END

		IF @p_check_yield = 'Y'
		BEGIN 
			INSERT INTO #TMP_SCP0049_LTY
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
			)
			SELECT DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, ELECTRODE_TYPE
				, OPERATION_ID
				, 'LA003'
				, ITEM_ID
				, @v_start_month
			FROM (
					SELECT DISTINCT
							R.DIVISION_ID
						, R.COMPANY_ID
						, R.SITE_ID
						, R.PLANT_ID
						, R.FACTORY_ID
						, R.LINE_ID
						, '-'			AS ELECTRODE_TYPE
						, R.OPERATION_ID
						, R.ITEM_ID
					FROM #TMP_SCP0049_STD_ITEM R
					EXCEPT
					SELECT DISTINCT
							R.DIVISION_ID
						, R.COMPANY_ID
						, R.SITE_ID
						, R.PLANT_ID
						, R.FACTORY_ID
						, R.LINE_ID
						, '-'			AS ELECTRODE_TYPE
						, R.OPERATION_ID
						, R.ITEM_ID
					FROM #TMP_SCP0049_LTY R
					WHERE R.LOSS_CODE = 'LA003'
				) A
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- LTY 최종 결과 테이블 생성
		-- Tact Time(Needed) , Yield(Needed) 체크 시 조회 월에 데이터 있는 경우 결과에서 제외한다.
		-- ///////////////////////////////////////////////////////////////////////////////
		IF @p_check_empty = 'Y'
		BEGIN
					SELECT DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, X.LOSS_CODE
					, ITEM_ID
					INTO #TMP_SCP0049_NOT_LA
					FROM #TMP_SCP0049_LTY A
					LEFT JOIN ( SELECT LOSS_CODE
					            FROM #TMP_SCP0049_LOOKUP
								WHERE (	 ( @p_check_tact = 'Y'  AND LOSS_CODE  = 'LA002' ) 
										OR ( @p_check_yield = 'Y' AND LOSS_CODE  = 'LA003' ) 
									)
						) X
					ON 1=1
					WHERE A.LOSS_CODE = 'LA001'
					AND ITEM_VALUE = 9.0
					AND YYYYMM IS NOT NULL
				GROUP BY DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, X.LOSS_CODE
					, ITEM_ID HAVING COUNT(1) = @v_month_cnt

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
				FROM #TMP_SCP0049_LTY T
				WHERE LOSS_CODE = 'LA002'
					AND ITEM_VALUE > 0 
					AND YYYYMM IS NOT NULL
					AND @p_check_tact = 'Y'
				GROUP BY DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, LOSS_CODE
					, ITEM_ID HAVING COUNT(1) = @v_month_cnt

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
				FROM #TMP_SCP0049_LTY T
				WHERE LOSS_CODE = 'LA003'
					AND ITEM_VALUE > 0 
					AND YYYYMM IS NOT NULL
					AND @p_check_yield = 'Y'
				GROUP BY DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, LOSS_CODE
					, ITEM_ID HAVING COUNT(1) = @v_month_cnt

			;

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
				SELECT A.DIVISION_ID
					, A.COMPANY_ID
					, A.SITE_ID
					, A.PLANT_ID
					, A.FACTORY_ID
					, A.LINE_ID
					, A.ELECTRODE_TYPE
					, A.OPERATION_ID
					, A.LOSS_CODE
					, A.ITEM_ID
					, A.LANE_QTY
					, A.YYYYMMDD
					, A.YYYYMM
					, A.YYYY
					, A.ITEM_VALUE
				FROM #TMP_SCP0049_LTY A
				WHERE NOT EXISTS (SELECT *
									FROM #TMP_SCP0049_NOT_LA T
									WHERE T.DIVISION_ID		= A.DIVISION_ID
										AND T.COMPANY_ID	= A.COMPANY_ID
										AND T.SITE_ID		= A.SITE_ID
										AND T.PLANT_ID		= A.PLANT_ID
										AND T.FACTORY_ID	= A.FACTORY_ID
										AND T.OPERATION_ID	= A.OPERATION_ID
										AND T.LINE_ID		= A.LINE_ID
										AND T.ITEM_ID		= A.ITEM_ID
										AND T.LOSS_CODE =  (CASE WHEN A.LOSS_CODE = 'LA999' THEN 'LA002' ELSE A.LOSS_CODE END ) 
							)
					
		END
		ELSE
		BEGIN
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
			END
			
		;


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

		---- ///////////////////////////////////////////////////////////////////////////////
		---- LINE 정보를 조회
		---- YIELD 는 ELECTRODE TYPE 정보가 없어 다른 테이블 조인이 필요함
		---- ///////////////////////////////////////////////////////////////////////////////
		--IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ALL_LINE') IS NOT NULL
		--	DROP TABLE #TMP_SCP0049_ALL_LINE;
			
		--SELECT T1.DIVISION_ID
		--		, T1.COMPANY_ID
		--		, T1.SITE_ID
		--		, ST.SITE_NAME
		--		, T1.PLANT_ID
		--		, T1.FACTORY_ID
		--		, ST.FACTORY_NAME
		--		, T1.LINE_ID
		--		, ST.LINE_NAME
		--		, T1.ELECTRODE_TYPE
		--		, ST.OPERATION_GROUP_NAME
		--		, T1.OPERATION_ID
		--		, ST.OPERATION_NAME
		--		, T1.LOSS_CODE
		--		, T1.ITEM_ID
		--		, SI.NICK_NAME
		--		, T1.LANE_QTY
		--		, T1.ITEM_VALUE
		--		, T1.YYYYMMDD
		--		, T1.YYYYMM
		--		, T1.YYYY
		--		, T1.BEF_M6
		--		, T1.BEF_M5
		--		, T1.BEF_M4
		--		, T1.BEF_M3
		--		, T1.BEF_M2
		--		, T1.BEF_M1
		--		, T1.BEF_M6_RESULT
		--		, T1.BEF_M5_RESULT
		--		, T1.BEF_M4_RESULT
		--		, T1.BEF_M3_RESULT
		--		, T1.BEF_M2_RESULT
		--		, T1.BEF_M1_RESULT
		--		, T1.BEF_BEST
		--		, T1.BEF_WORST
		--		, T1.BEF_BEST_RESULT
		--		, T1.BEF_WORST_RESULT
		--	INTO #TMP_SCP0049_ALL_LINE
		--	FROM #TMP_SCP0049_ALL T1
		--	LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) -- LINE 정보
		--	ON T1.COMPANY_ID		= ST.COMPANY_ID
		--	AND T1.DIVISION_ID		= ST.DIVISION_ID
		--	AND T1.SITE_ID			= ST.SITE_ID
		--	AND T1.PLANT_ID			= ST.PLANT_ID
		--	AND T1.FACTORY_ID		= ST.FACTORY_ID
		--	AND T1.OPERATION_ID		= ST.OPERATION_ID
		--	AND T1.LINE_ID			= ST.LINE_ID
		--	AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE

		--	LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) -- LINE 정보
		--	ON T1.COMPANY_ID		= SI.COMPANY_ID
		--	AND T1.DIVISION_ID		= SI.DIVISION_ID
		--	AND T1.SITE_ID			= SI.SITE_ID
		--	AND T1.PLANT_ID			= SI.PLANT_ID
		--	AND T1.FACTORY_ID		= SI.FACTORY_ID
		--	AND T1.OPERATION_ID		= SI.OPERATION_ID
		--	AND T1.LINE_ID			= SI.LINE_ID
		--	AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE
		--	AND T1.ITEM_ID 			= SI.ITEM_ID
		--	WHERE T1.LOSS_CODE <> 'LA003'   -- YIELD 제외

		--	UNION ALL

		--	SELECT T1.DIVISION_ID
		--		, T1.COMPANY_ID
		--		, T1.SITE_ID
		--		, SI.SITE_NAME
		--		, T1.PLANT_ID
		--		, T1.FACTORY_ID
		--		, SI.FACTORY_NAME
		--		, T1.LINE_ID
		--		, SI.LINE_NAME
		--		, ISNULL(T1.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE
		--		, SI.OPERATION_GROUP_NAME
		--		, T1.OPERATION_ID
		--		, SI.OPERATION_NAME
		--		, T1.LOSS_CODE
		--		, T1.ITEM_ID
		--		, SI.NICK_NAME
		--		, T1.LANE_QTY
		--		, T1.ITEM_VALUE
		--		, T1.YYYYMMDD
		--		, T1.YYYYMM
		--		, T1.YYYY
		--		, T1.BEF_M6
		--		, T1.BEF_M5
		--		, T1.BEF_M4
		--		, T1.BEF_M3
		--		, T1.BEF_M2
		--		, T1.BEF_M1
		--		, T1.BEF_M6_RESULT
		--		, T1.BEF_M5_RESULT
		--		, T1.BEF_M4_RESULT
		--		, T1.BEF_M3_RESULT
		--		, T1.BEF_M2_RESULT
		--		, T1.BEF_M1_RESULT
		--		, T1.BEF_BEST
		--		, T1.BEF_WORST
		--		, T1.BEF_BEST_RESULT
		--		, T1.BEF_WORST_RESULT
		--	FROM #TMP_SCP0049_ALL T1

		--	LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) -- LINE 정보
		--	ON T1.COMPANY_ID		= SI.COMPANY_ID
		--	AND T1.DIVISION_ID		= SI.DIVISION_ID
		--	AND T1.SITE_ID			= SI.SITE_ID
		--	AND T1.PLANT_ID			= SI.PLANT_ID
		--	AND T1.FACTORY_ID		= SI.FACTORY_ID
		--	AND T1.OPERATION_ID		= SI.OPERATION_ID
		--	AND T1.LINE_ID			= SI.LINE_ID
		--	AND T1.ITEM_ID 			= SI.ITEM_ID

		--	WHERE T1.LOSS_CODE = 'LA003'   -- YIELD

  --      -- 2021-10-12 ParkSungchool #TMP_SCP0049_RESULT 결과 컬럼 줄이기
		---- ///////////////////////////////////////////////////////////////////////////////
		---- 기준정보별 부가정보 (담당자, operation, factory, line, site)
		---- ///////////////////////////////////////////////////////////////////////////////
		--BEGIN
		--	-- 임시 테이블 삭제
		--	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_RESULT_NEW') IS NOT NULL
		--		DROP TABLE #TMP_SCP0049_RESULT_NEW;

		--		SELECT RL.DIVISION_ID
		--			 , RL.COMPANY_ID
		--			 , RL.SITE_ID
		--			 , RL.SITE_NAME
		--			 , RL.PLANT_ID
		--			 , RL.FACTORY_ID
		--			 , RL.FACTORY_NAME
		--			 , RL.LINE_ID
		--			 , RL.LINE_NAME
		--			 , RL.ELECTRODE_TYPE
		--			 , RL.OPERATION_GROUP_NAME
		--			 , RL.OPERATION_ID
		--			 , RL.OPERATION_NAME
		--			 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'DAILY CAPA' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID
		--			 , CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003','LA999') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
		--			 , RL.LOSS_CODE
		--			 , RL.ITEM_ID
		--			 , RL.LANE_QTY
		--			 , 'D_' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD
		--			 , 'M_' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM
		--			 , 'Y_' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY
		--			 , RL.ITEM_VALUE
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M6)  
		--			   END AS BEF_M6
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M5)  
		--			   END AS BEF_M5
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M4)  
		--			   END AS BEF_M4

		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M3)  
		--			   END AS BEF_M3
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M2)  
		--			   END AS BEF_M2
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M1)  
		--			   END AS BEF_M1
		--			, CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
		--			   END AS BEF_M6_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
		--			   END AS BEF_M5_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
		--			   END AS BEF_M4_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
		--			   END AS BEF_M3_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
		--			   END AS BEF_M2_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
		--			   END AS BEF_M1_RESULT
		--			   -----------------------------------------
		--			 , RL.BEF_BEST
		--			 , RL.BEF_WORST
		--			 , RL.BEF_BEST_RESULT
		--			 , RL.BEF_WORST_RESULT
		--			-----------------------------------------

		--			 , SORT_ORDER
		--			 , CASE WHEN RL.LOSS_CODE = N'LA999' THEN N'EA'
		--					WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = N'TACT TIME' THEN LK.UOM ELSE N'EA' END AS UOM
		--	    INTO #TMP_SCP0049_RESULT_NEW
		--	    FROM #TMP_SCP0049_ALL_LINE RL
		--	        LEFT JOIN
  --                  (
  --                      SELECT   LU.*
		--					        , LV.SEGMENT2 		AS PLANT_ID
		--					        , LV.SEGMENT3 		AS OPERATION_ID
		--					        , LV.ATTRIBUTE1 	AS CATEGORY_2
		--				FROM #TMP_SCP0049_LOOKUP LU
		--				    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV
		--					    ON 	1=1
		--				            AND 	LV.LOOKUP_TYPE_CODE = N'CAPA_UI_CAPA_DEFINIT'
		--				            AND 	LU.LOSS_CODE = LV.SEGMENT1
		--				            AND 	LV.ACTIVE_FLAG = N'Y'
  --                  ) LK    -- 공정별 CAPA 보완
		--	            ON RL.LOSS_CODE			= LK.LOSS_CODE
		--	                AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = N'LA002' THEN LK.PLANT_ID ELSE RL.PLANT_ID END
		--	                AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = N'LA002' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END
  --      END

		-- /////////////////////////// PIVOT 처리를 위한 SUM QUERY 생성
		BEGIN
			SET @MQRY_SUM = '';
			
			SELECT @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('D_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYYMMDD = RIGHT('''+YYYYMMDD+''',10) THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
													WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYYMM   = RIGHT('''+YYYYMMDD+''',8)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
													WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYY     = RIGHT('''+YYYYMMDD+''',6)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
										END +''+  CHAR(10)
			FROM
            ( 
                SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
		                ,  CONVERT(CHAR(2), '10') + A.BASIS_YYYYMMDD  AS SORT_ORDER_NO
	            FROM [DBO].[SCM_SYS_CALENDAR_M] A 
	            WHERE A.BASIS_YYYYMMDD  >= @v_start_day
	                AND A.BASIS_YYYYMMDD  <= @v_end_day
	            GROUP BY A.BASIS_YYYYMMDD

	            UNION ALL

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
	            WHERE A.CALENDAR_YYYY  >= @v_start_year
	                AND A.CALENDAR_YYYY  <= @v_end_year
	            GROUP BY A.CALENDAR_YYYY
            ) AS A
			ORDER BY SORT_ORDER_NO;
		END

        -- /////////////////////////// PIVOT 처리를 위한 SUM QUERY에서 부모부분 만들기. 2021-10-12 ParkSungchool
		BEGIN
	        SET @DYNAMIC_PIVOT_COL_PARENT = '';
	
	        SELECT @DYNAMIC_PIVOT_COL_PARENT = @DYNAMIC_PIVOT_COL_PARENT + '    , R2.'+  YYYYMMDD + CHAR(10)
	        FROM
	        ( 
		        SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
				        ,  CONVERT(CHAR(2), '10') + A.BASIS_YYYYMMDD  AS SORT_ORDER_NO
		        FROM [DBO].[SCM_SYS_CALENDAR_M] A 
		        WHERE A.BASIS_YYYYMMDD  >= @v_start_day
			        AND A.BASIS_YYYYMMDD  <= @v_end_day
		        GROUP BY A.BASIS_YYYYMMDD

		        UNION ALL

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
		        WHERE A.CALENDAR_YYYY  >= @v_start_year
			        AND A.CALENDAR_YYYY  <= @v_end_year
		        GROUP BY A.CALENDAR_YYYY
	        ) AS A
	        ORDER BY SORT_ORDER_NO;
        END     

		--IF OBJECT_ID('TEMPDB..##TMP_SCP0049_LAST') IS NOT NULL
		--	DROP TABLE ##TMP_SCP0049_LAST;

		SET @MEXEC = '';

		SET @MEXEC = @MEXEC+' ;WITH    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		CTE_SCP0049_ALL_LINE AS ( ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				SELECT T1.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ST.SITE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ST.FACTORY_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ST.LINE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.ELECTRODE_TYPE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ST.OPERATION_GROUP_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ST.OPERATION_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LOSS_CODE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.NICK_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LANE_QTY' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.ITEM_VALUE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYYMMDD' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYYMM' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYY' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M6' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M5' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M4' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M3' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M2' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M1' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M6_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M5_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M4_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M3_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M2_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M1_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_BEST' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_WORST' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_BEST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_WORST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'			FROM #TMP_SCP0049_ALL T1' + CHAR(10);
		SET @MEXEC = @MEXEC+'			LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON T1.COMPANY_ID		= ST.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.DIVISION_ID		= ST.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.SITE_ID			= ST.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.PLANT_ID			= ST.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.FACTORY_ID		= ST.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.OPERATION_ID		= ST.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.LINE_ID			= ST.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE' + CHAR(10);
		SET @MEXEC = @MEXEC+'			LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON T1.COMPANY_ID		= SI.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.DIVISION_ID		= SI.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.SITE_ID			= SI.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.PLANT_ID			= SI.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.FACTORY_ID		= SI.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.OPERATION_ID		= SI.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.LINE_ID			= SI.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.ITEM_ID 			= SI.ITEM_ID' + CHAR(10);
		-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'			LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON	T1.COMPANY_ID	= SIM.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.DIVISION_ID	= SIM.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.SITE_ID		= SIM.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.ITEM_ID		= SIM.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			WHERE T1.LOSS_CODE <> ''LA003''' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	  ISNULL(SIM.ACTIVE_FLAG, ''Y'')  <> ''N''' + CHAR(10);-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'			UNION ALL' + CHAR(10);
		SET @MEXEC = @MEXEC+'			SELECT T1.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.SITE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.FACTORY_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.LINE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, ISNULL(T1.ELECTRODE_TYPE,''-'') AS ELECTRODE_TYPE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.OPERATION_GROUP_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.OPERATION_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LOSS_CODE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, SI.NICK_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.LANE_QTY' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.ITEM_VALUE' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYYMMDD' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYYMM' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.YYYY' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M6' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M5' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M4' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M3' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M2' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M1' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M6_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M5_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M4_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M3_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M2_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_M1_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_BEST' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_WORST' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_BEST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, T1.BEF_WORST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'			FROM #TMP_SCP0049_ALL T1' + CHAR(10);
		SET @MEXEC = @MEXEC+'			LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON T1.COMPANY_ID		= SI.COMPANY_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.DIVISION_ID		= SI.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.SITE_ID			= SI.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.PLANT_ID			= SI.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.FACTORY_ID		= SI.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.OPERATION_ID		= SI.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.LINE_ID			= SI.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND T1.ITEM_ID 			= SI.ITEM_ID' + CHAR(10);
		-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'			LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON	T1.COMPANY_ID	= SIM.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.DIVISION_ID	= SIM.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.SITE_ID		= SIM.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	T1.ITEM_ID		= SIM.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			WHERE T1.LOSS_CODE = ''LA003''   -- YIELD' + CHAR(10);
		SET @MEXEC = @MEXEC+'			AND	  ISNULL(SIM.ACTIVE_FLAG, ''Y'')  <> ''N''' + CHAR(10);-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'		)' + CHAR(10);
		SET @MEXEC = @MEXEC+'		, CTE_SCP0049_RESULT_NEW AS (' + CHAR(10);
		SET @MEXEC = @MEXEC+'				SELECT RL.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.SITE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.FACTORY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.FACTORY_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LINE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LINE_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ELECTRODE_TYPE' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_GROUP_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.OPERATION_NAME' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN RL.LOSS_CODE = ''LA999'' THEN ''DAILY CAPA'' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN RL.LOSS_CODE IN (''LA001'',''LA002'',''LA003'',''LA999'') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LOSS_CODE' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.LANE_QTY' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''D_'' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''M_'' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , ''Y_'' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.ITEM_VALUE' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M6) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M6)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M6) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M6)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M6' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M5) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M5)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M5) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M5)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M5' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M4) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M4)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M4) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M4)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M4' + CHAR(10);

		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M3) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M3)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M3) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M3)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M3' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M2) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M2)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M2) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M2)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M2' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M1) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M1)' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M1) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M1)  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M1' + CHAR(10);
		SET @MEXEC = @MEXEC+'					, CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M6_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M5_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M4_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M3_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M2_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   END AS BEF_M1_RESULT					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_BEST' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_WORST' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_BEST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , RL.BEF_WORST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , SORT_ORDER' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 , CASE WHEN RL.LOSS_CODE = N''LA999'' THEN N''EA''' + CHAR(10);
		SET @MEXEC = @MEXEC+'							WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = N''TACT TIME'' THEN LK.UOM ELSE N''EA'' END AS UOM' + CHAR(10);
		SET @MEXEC = @MEXEC+'			    FROM				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				     CTE_SCP0049_ALL_LINE RL' + CHAR(10);
		SET @MEXEC = @MEXEC+'			        LEFT JOIN' + CHAR(10);
		SET @MEXEC = @MEXEC+'                    (' + CHAR(10);
		SET @MEXEC = @MEXEC+'                        SELECT   LU.*' + CHAR(10);
		SET @MEXEC = @MEXEC+'							        , LV.SEGMENT2 		AS PLANT_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'							        , LV.SEGMENT3 		AS OPERATION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'							        , LV.ATTRIBUTE1 	AS CATEGORY_2' + CHAR(10);
		SET @MEXEC = @MEXEC+'						FROM #TMP_SCP0049_LOOKUP LU' + CHAR(10);
		SET @MEXEC = @MEXEC+'						    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV' + CHAR(10);
		SET @MEXEC = @MEXEC+'							    ON 	1=1' + CHAR(10);
		SET @MEXEC = @MEXEC+'						            AND 	LV.LOOKUP_TYPE_CODE = N''CAPA_UI_CAPA_DEFINIT''' + CHAR(10);
		SET @MEXEC = @MEXEC+'						            AND 	LU.LOSS_CODE = LV.SEGMENT1' + CHAR(10);
		SET @MEXEC = @MEXEC+'						            AND 	LV.ACTIVE_FLAG = N''Y''' + CHAR(10);
		SET @MEXEC = @MEXEC+'                    ) LK  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			            ON RL.LOSS_CODE			= LK.LOSS_CODE' + CHAR(10);
		SET @MEXEC = @MEXEC+'			                AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = N''LA002'' THEN LK.PLANT_ID ELSE RL.PLANT_ID END' + CHAR(10);
		SET @MEXEC = @MEXEC+'			                AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = N''LA002'' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END' + CHAR(10);
		SET @MEXEC = @MEXEC+'		)' + CHAR(10);

		SET @MEXEC = @MEXEC+'SELECT                                 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'     R2.DIVISION_ID                   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.COMPANY_ID	                    ' + CHAR(10);									
		SET @MEXEC = @MEXEC+'	, R2.SITE_ID		                ' + CHAR(10);									
		SET @MEXEC = @MEXEC+'	, R2.SITE_NAME			            ' + CHAR(10);							
		SET @MEXEC = @MEXEC+'	, R2.PLANT_ID		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.FACTORY_ID 	                ' + CHAR(10);									
		SET @MEXEC = @MEXEC+'	, R2.FACTORY_NAME  	                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.LINE_ID 		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.LINE_NAME 		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.ELECTRODE_TYPE                 ' + CHAR(10);									
		SET @MEXEC = @MEXEC+'	, R2.OPERATION_GROUP_NAME 	        ' + CHAR(10);						
		SET @MEXEC = @MEXEC+'	, R2.OPERATION_ID	                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.OPERATION_NAME	                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.CATEGORY_ID 	                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.KEY_ID 		                ' + CHAR(10);									
		SET @MEXEC = @MEXEC+'	, R2.LOSS_CODE 		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.EDITORBLE_YN	                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, R2.ITEM_ID 		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, UM.ITEM_CLASS AS ITEM_CLASS 		                ' + CHAR(10);								
		SET @MEXEC = @MEXEC+'	, ISNULL(UM.CELL_TYPE,''-'') AS CELL_TYPE ' + CHAR(10); -- CELL_TYPE 추가... 20230904
		SET @MEXEC = @MEXEC+'	, CASE WHEN R2.LOSS_CODE = N''LA001'' THEN CONVERT(NVARCHAR(10),R2.LANE_QTY) ELSE ''-'' END AS LANE_QTY	        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'    , ISNULL(M.DEPARTMENT, CASE WHEN R2.SITE_ID = N''A001'' THEN C.DEPT_NAME_KO                                    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'												 WHEN R2.SITE_ID = N''A002'' THEN C.DEPT_NAME_CN                    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'											ELSE DEPT_NAME_EN	                                                    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'									END) AS DEPARTMENT                                                              ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_1				        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_2						' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_3						' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_4						' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_5						' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, M.USER_ID_6						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, M.USER_ID_7						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, M.USER_ID_8						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, M.USER_ID_9						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, M.USER_ID_10						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, C.USER_NAME		AS MANAGER		' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, CASE WHEN M.CONFIRM_FLAG = ''Y'' THEN ''True'' ELSE ''False'' END AS CONFIRM_FLAG	                            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M6				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M5				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M4				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M3				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M2				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M1				            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M6_RESULT		            ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_M5_RESULT	                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'   , R2.BEF_M4_RESULT                  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'   , R2.BEF_M3_RESULT                  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'   , R2.BEF_M2_RESULT                  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'   , R2.BEF_M1_RESULT                  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_BEST						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, R2.BEF_WORST						' + CHAR(10);			
		SET @MEXEC = @MEXEC+'	, R2.BEF_BEST_RESULT		        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	, R2.BEF_WORST_RESULT		        ' + CHAR(10);
		
	
		SET @MEXEC = @MEXEC+' , CASE WHEN R2.CATEGORY_ID = N''DAILY CAPA'' THEN UM.ITEM_UOM  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ELSE R2.UOM END AS UOM   ' + CHAR(10);


		SET @MEXEC = @MEXEC+'	, R2.DATA_TABLE						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, R2.CATEGORY_ORDER					' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, R2.SORT_ORDER						' + CHAR(10);				
		SET @MEXEC = @MEXEC+'	, R2.ROW_RANKING					' + CHAR(10);	
        SET @MEXEC = @MEXEC+'	, R2.ELECTRODE_ORDER	            ' + CHAR(10);
        SET @MEXEC = @MEXEC+'' + @DYNAMIC_PIVOT_COL_PARENT     	  + CHAR(10);
		SET @MEXEC = @MEXEC+'FROM                                   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'(	SELECT								' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  R.DIVISION_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.COMPANY_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.SITE_ID					' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.SITE_NAME				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.PLANT_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.FACTORY_ID 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.FACTORY_NAME  			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LINE_ID 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LINE_NAME 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.ELECTRODE_TYPE 			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_GROUP_NAME 	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_ID			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_NAME			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.CATEGORY_ID 			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.KEY_ID 					' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LOSS_CODE 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.EDITORBLE_YN			' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.ITEM_ID 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE = ''LA001'' THEN CONVERT(NVARCHAR(10),R.LANE_QTY) ELSE ''-'' END AS LANE_QTY	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M6),0)				AS BEF_M6		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M5),0)				AS BEF_M5		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M4),0)				AS BEF_M4		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M3),0)				AS BEF_M3		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M2),0)				AS BEF_M2		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M1),0)				AS BEF_M1		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M6_RESULT))	END 	AS BEF_M6_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M5_RESULT))	END 	AS BEF_M5_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M4_RESULT))	END 	AS BEF_M4_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M3_RESULT))	END 	AS BEF_M3_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M2_RESULT))	END 	AS BEF_M2_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100),MAX(R.BEF_M1_RESULT))	END 	AS BEF_M1_RESULT		                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_BEST),0)				AS BEF_BEST										                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_WORST),0)			AS BEF_WORST									                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''					                ' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100), ISNULL(MAX(R.BEF_BEST_RESULT),0))		END		AS BEF_BEST_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA999'' ) THEN ''-''									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(100), ISNULL(MAX(R.BEF_WORST_RESULT),0))	END		AS BEF_WORST_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.UOM												    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.DATA_TABLE										    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.CATEGORY_ORDER									    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.SORT_ORDER										    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, RANK() OVER(PARTITION BY R.DIVISION_ID , R.COMPANY_ID , R.SITE_ID , R.PLANT_ID , R.FACTORY_ID	        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'									, R.LINE_ID , R.ELECTRODE_TYPE, R.OPERATION_ID,R.LOSS_CODE				        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ORDER BY R.ITEM_ID) AS ROW_RANKING												        ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.ELECTRODE_TYPE =''-'' THEN ''ZZ'' ELSE R.ELECTRODE_TYPE END  AS ELECTRODE_ORDER	        ' + CHAR(10); --  YIELD 는 ELECTRODE_TYPE 이 없기 때문에 정열을 위한 컬럼
		SET @MEXEC = @MEXEC+'			' + @MQRY_SUM										  + CHAR(10);
		SET @MEXEC = @MEXEC+'		 FROM CTE_SCP0049_RESULT_NEW	R						' + CHAR(10);
		-- #TMP_SCP0049_RESULT_NEW -> CTE_SCP0049_RESULT_NEW
		SET @MEXEC = @MEXEC+'		 JOIN #TMP_SCP0049_LOOKUP	LK							' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   ON ( CASE WHEN R.LOSS_CODE = ''LA999'' THEN ''LA002'' ELSE R.LOSS_CODE END )	= LK.LOSS_CODE		        ' + CHAR(10);


		IF @p_search_type = 'EXCEL'
		BEGIN
			SET @MEXEC = @MEXEC+'		 WHERE  R.LOSS_CODE NOT IN (''LA999'')				' + CHAR(10);
			SET @MEXEC = @MEXEC+'		   AND  LK.EDITORBLE_YN = ''Y''						' + CHAR(10);
			SET @MEXEC = @MEXEC+'		   AND  LK.DATA_TABLE  != ''SCM_WORK_CALENDAR_M''	' + CHAR(10);
		END
		ELSE IF @p_search_type = 'EXCEL_DAY' -- day 기준 엑셀 정보 출력
		BEGIN
			SET @MEXEC = @MEXEC+'		 WHERE  R.LOSS_CODE NOT IN (''LA999'')				' + CHAR(10);
			SET @MEXEC = @MEXEC+'		   AND  LK.EDITORBLE_YN = ''Y''						' + CHAR(10);
			SET @MEXEC = @MEXEC+'		   AND  LK.DATA_TABLE   = ''SCM_WORK_CALENDAR_M''	' + CHAR(10);			
		END

		SET @MEXEC = @MEXEC+'		GROUP BY  R.DIVISION_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.COMPANY_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.SITE_ID					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.SITE_NAME				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.PLANT_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.FACTORY_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.FACTORY_NAME			' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LINE_ID					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LINE_NAME				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.ELECTRODE_TYPE			' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_GROUP_NAME 	' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_ID			' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_NAME			' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.CATEGORY_ID				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.KEY_ID 					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LOSS_CODE 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.ITEM_ID 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LANE_QTY 				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.UOM						' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.DATA_TABLE				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.CATEGORY_ORDER			' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.SORT_ORDER				' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.EDITORBLE_YN			' + CHAR(10);

		-- [ 최소 행 크기가 내부 오버헤드 109바이트를 포함하여 13562이(가) ] 에러가 발생하여 화면에서 정열한다
		--SET @MEXEC = @MEXEC+'		ORDER BY  R.DIVISION_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.COMPANY_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.SITE_ID										' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.PLANT_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.FACTORY_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.LINE_ID										' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.OPERATION_ID	DESC						' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.ELECTRODE_TYPE								' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, LK.CATEGORY_ORDER								' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, LK.SORT_ORDER									' + CHAR(10);
        SET @MEXEC = @MEXEC+') R2                                   ' + CHAR(10);
        SET @MEXEC = @MEXEC+'   LEFT JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK)                                                      ' + CHAR(10);--기준정보별 담당자 정보
        SET @MEXEC = @MEXEC+'	    ON      R2.COMPANY_ID		= M.COMPANY_ID                                                        ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.DIVISION_ID		= M.DIVISION_ID                                                       ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.SITE_ID			= M.SITE_ID                                                           ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.PLANT_ID			= M.PLANT_ID                                                          ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.FACTORY_ID		= M.FACTORY_ID                                                        ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.OPERATION_ID		= M.OPERATION_ID                                                      ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.LINE_ID			= M.LINE_ID                                                           ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND R2.ELECTRODE_TYPE	= M.ELECTRODE_TYPE ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		    AND (CASE WHEN R2.LOSS_CODE = N''LA999'' THEN N''LA002'' ELSE R2.LOSS_CODE END)	= M.LOSS_CODE ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		                                                                                                  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'	LEFT JOIN                                                                                             ' + CHAR(10);
        SET @MEXEC = @MEXEC+'    (                                                                                                    ' + CHAR(10);
        SET @MEXEC = @MEXEC+'        SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN         ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)                                                         ' + CHAR(10);
        SET @MEXEC = @MEXEC+'			JOIN SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)   ON A.DEPT_ID = B.DEPT_ID                          ' + CHAR(10);
        SET @MEXEC = @MEXEC+'    ) C                                                                                                  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		ON M.USER_ID_1 = C.USER_ID                                                                        ' + CHAR(10);

        SET @MEXEC = @MEXEC+'		LEFT JOIN SCM_ITEM_M_SN UM WITH(NOLOCK)  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		ON      R2.COMPANY_ID		= UM.COMPANY_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.DIVISION_ID		= UM.DIVISION_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.SITE_ID			= UM.SITE_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.ITEM_ID			= UM.ITEM_ID ' + CHAR(10);



		IF @p_search_type = 'EXCEL'
		BEGIN
			SET @MEXEC = @MEXEC+'		 WHERE (''SCM PI Admin''= ''' + @p_user_auth+ '''	' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_1	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_2	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_3	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_4	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_5	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_6	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_7	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_8	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_9	= ''' + @p_user_id	+ '''		' + CHAR(10);
			SET @MEXEC = @MEXEC+'			OR  M.USER_ID_10	= ''' + @p_user_id	+ ''')	' + CHAR(10);
		END


	  	-----------------------------------------------------------	
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


		EXEC(@MEXEC);

        --#endregion

		-- //////////////////////////////////////////////////////////////////////
		-- PROGRESS 조회
		-- 현재 조회된 건수는 화면에서 처리 한다
		WITH FP_LINE_MASTER_MANAGEMENT
		AS (
			SELECT A.DIVISION_ID , A.OPERATION_GROUP_ID
					, COUNT(1) AS CNT
					, SUM(CASE WHEN ISNULL(B.CONFIRM_FLAG, 'N') = 'N' THEN 0 ELSE 1 END ) AS CONFIRM_CNT
				FROM (
					SELECT DISTINCT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE
						, B.LOSS_CODE, B.CATEGORY, B.LOSS_NAME, LEFT(C.INSTANCE_TYPE,1) AS OPERATION_GROUP_ID
						FROM SCM_LINE_M_SN A
						, ( SELECT A.SEGMENT1 AS LOSS_CODE, A.ATTRIBUTE1 AS CATEGORY, A.ATTRIBUTE2 AS LOSS_NAME, A.SORT_ORDER
								FROM SCM_SYS_LOOKUP_VALUE_SN A
								WHERE 1=1
								AND A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								AND A.ATTRIBUTE7 = 'Y'
							) B
						, FP_INSTANCE_OPERATION_V_SN C
					WHERE 	1=1
						AND A.ACTIVE_FLAG		= 'Y'
						AND A.COMPANY_ID		= C.COMPANY_ID
						AND A.DIVISION_ID		= C.DIVISION_ID
						AND A.SITE_ID			= C.SITE_ID
						AND A.OPERATION_ID	= C.OPERATION_ID
					) A
				LEFT OUTER MERGE JOIN SCM_MASTER_MANAGER_M_SN B
				ON 	1=1
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.DIVISION_ID		= B.DIVISION_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
				AND A.LOSS_CODE			= B.LOSS_CODE
				GROUP BY A.DIVISION_ID , A.OPERATION_GROUP_ID
		)

		
		SELECT CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, TOT_CONFIRM      ) / TOT_CNT       * 100,2)) + ' %' AS TOT_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, AUTO_CONFIRM     ) / AUTO_CNT      * 100,2)) + ' %' AS AUTO_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, SMALL_CONFIRM    ) / SMALL_CNT     * 100,2)) + ' %' AS SMALL_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, ELECTRODE_CONFIRM) / ELECTRODE_CNT * 100,2)) + ' %' AS ELECTRODE_PROGRESS
			FROM (
				SELECT SUM(CNT)																	AS TOT_CNT
						, SUM(CONFIRM_CNT)															AS TOT_CONFIRM
						, SUM (CASE WHEN DIVISION_ID IN ( '81','82') THEN CNT         ELSE 0 END ) AS AUTO_CNT
						, SUM (CASE WHEN DIVISION_ID IN ( '81','82') THEN CONFIRM_CNT ELSE 0 END ) AS AUTO_CONFIRM
						, SUM (CASE WHEN DIVISION_ID = '40'		  THEN CNT         ELSE 0 END ) AS SMALL_CNT
						, SUM (CASE WHEN DIVISION_ID = '40'		  THEN CONFIRM_CNT ELSE 0 END ) AS SMALL_CONFIRM
						, SUM (CASE WHEN OPERATION_GROUP_ID = 'E'    THEN CNT         ELSE 0 END ) AS ELECTRODE_CNT
						, SUM (CASE WHEN OPERATION_GROUP_ID = 'E'    THEN CONFIRM_CNT ELSE 0 END ) AS ELECTRODE_CONFIRM
					FROM  FP_LINE_MASTER_MANAGEMENT
				) X
                
        -- 2021-10-12 ParkSungchool SCM_MASTER_MANAGER_M_SN left 조인 추가

		 ;WITH 	CTE_SCP0049_ALL_LINE AS ( 
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
					, T1.BEF_M6
					, T1.BEF_M5
					, T1.BEF_M4
					, T1.BEF_M3
					, T1.BEF_M2
					, T1.BEF_M1
					, T1.BEF_M6_RESULT
					, T1.BEF_M5_RESULT
					, T1.BEF_M4_RESULT
					, T1.BEF_M3_RESULT
					, T1.BEF_M2_RESULT
					, T1.BEF_M1_RESULT
					, T1.BEF_BEST
					, T1.BEF_WORST
					, T1.BEF_BEST_RESULT
					, T1.BEF_WORST_RESULT
				FROM #TMP_SCP0049_ALL T1
				LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) 
				ON T1.COMPANY_ID		= ST.COMPANY_ID
				AND T1.DIVISION_ID		= ST.DIVISION_ID
				AND T1.SITE_ID			= ST.SITE_ID
				AND T1.PLANT_ID			= ST.PLANT_ID
				AND T1.FACTORY_ID		= ST.FACTORY_ID
				AND T1.OPERATION_ID		= ST.OPERATION_ID
				AND T1.LINE_ID			= ST.LINE_ID
				AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE
				LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) 
				ON T1.COMPANY_ID		= SI.COMPANY_ID
				AND T1.DIVISION_ID		= SI.DIVISION_ID
				AND T1.SITE_ID			= SI.SITE_ID
				AND T1.PLANT_ID			= SI.PLANT_ID
				AND T1.FACTORY_ID		= SI.FACTORY_ID
				AND T1.OPERATION_ID		= SI.OPERATION_ID
				AND T1.LINE_ID			= SI.LINE_ID
				AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE
				AND T1.ITEM_ID 			= SI.ITEM_ID
				-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
				LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
				ON	T1.COMPANY_ID	= SIM.COMPANY_ID
				AND	T1.DIVISION_ID	= SIM.DIVISION_ID
				AND	T1.SITE_ID		= SIM.SITE_ID
				AND	T1.ITEM_ID		= SIM.ITEM_ID
				WHERE T1.LOSS_CODE <> 'LA003'
				AND	  ISNULL(SIM.ACTIVE_FLAG, 'Y')  <> 'N' -- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
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
					, T1.BEF_M6
					, T1.BEF_M5
					, T1.BEF_M4
					, T1.BEF_M3
					, T1.BEF_M2
					, T1.BEF_M1
					, T1.BEF_M6_RESULT
					, T1.BEF_M5_RESULT
					, T1.BEF_M4_RESULT
					, T1.BEF_M3_RESULT
					, T1.BEF_M2_RESULT
					, T1.BEF_M1_RESULT
					, T1.BEF_BEST
					, T1.BEF_WORST
					, T1.BEF_BEST_RESULT
					, T1.BEF_WORST_RESULT
				FROM #TMP_SCP0049_ALL T1
				LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) 
				ON T1.COMPANY_ID		= SI.COMPANY_ID 
				AND T1.DIVISION_ID		= SI.DIVISION_ID
				AND T1.SITE_ID			= SI.SITE_ID
				AND T1.PLANT_ID			= SI.PLANT_ID
				AND T1.FACTORY_ID		= SI.FACTORY_ID
				AND T1.OPERATION_ID		= SI.OPERATION_ID
				AND T1.LINE_ID			= SI.LINE_ID
				AND T1.ITEM_ID 			= SI.ITEM_ID
				-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
				LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
				ON	T1.COMPANY_ID	= SIM.COMPANY_ID
				AND	T1.DIVISION_ID	= SIM.DIVISION_ID
				AND	T1.SITE_ID		= SIM.SITE_ID
				AND	T1.ITEM_ID		= SIM.ITEM_ID
				WHERE T1.LOSS_CODE = 'LA003'   -- YIELD
				AND	  ISNULL(SIM.ACTIVE_FLAG, 'Y')  <> 'N' -- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
			)
			, CTE_SCP0049_RESULT_NEW AS (
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
						 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'DAILY CAPA' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID 
						 , CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003','LA999') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID 
						 , RL.LOSS_CODE
						 , RL.ITEM_ID
						 , RL.LANE_QTY
						 , 'D_' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD
						 , 'M_' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM
						 , 'Y_' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY
						 , RL.ITEM_VALUE
						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M6)  
						   END AS BEF_M6
						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M5)  
						   END AS BEF_M5
						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M4)  
						   END AS BEF_M4

						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M3)  
						   END AS BEF_M3
						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M2)  
						   END AS BEF_M2
						 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1) 
								WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1)
								WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1) 
								ELSE CONVERT(numeric(10,2),RL.BEF_M1)  
						   END AS BEF_M1
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
						 , RL.BEF_BEST
						 , RL.BEF_WORST
						 , RL.BEF_BEST_RESULT
						 , RL.BEF_WORST_RESULT
						 , SORT_ORDER
						 , CASE WHEN RL.LOSS_CODE = N'LA999' THEN N'EA'
								WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = N'TACT TIME' THEN LK.UOM ELSE N'EA' END AS UOM
				    FROM				  
					     CTE_SCP0049_ALL_LINE RL
				        LEFT JOIN
	                    (
	                        SELECT   LU.*
								        , LV.SEGMENT2 		AS PLANT_ID
								        , LV.SEGMENT3 		AS OPERATION_ID
								        , LV.ATTRIBUTE1 	AS CATEGORY_2
							FROM #TMP_SCP0049_LOOKUP LU
							    LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV
								    ON 	1=1
							            AND 	LV.LOOKUP_TYPE_CODE = N'CAPA_UI_CAPA_DEFINIT'
							            AND 	LU.LOSS_CODE = LV.SEGMENT1
							            AND 	LV.ACTIVE_FLAG = N'Y'
	                    ) LK  
				            ON RL.LOSS_CODE			= LK.LOSS_CODE
				                AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = N'LA002' THEN LK.PLANT_ID ELSE RL.PLANT_ID END
				                AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = N'LA002' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END
			)
		SELECT CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, SUM(CONFIRM_CNT)) / COUNT(1) * 100,2)) + ' %'  AS FILTER
		FROM
        ( 
            SELECT R2.DIVISION_ID, R2.COMPANY_ID, R2.SITE_ID, R2.PLANT_ID, R2.FACTORY_ID 
				, R2.LINE_ID, R2.OPERATION_ID, R2.ELECTRODE_TYPE , R2.OPERATION_GROUP_NAME, R2.LOSS_CODE 
				, MAX(case when isnull(M.confirm_flag,'N') = 'N' THEN 0  ELSE 1 END ) AS CONFIRM_CNT
			FROM CTE_SCP0049_RESULT_NEW R2
                LEFT JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK)                                                      
                    ON      R2.COMPANY_ID		= M.COMPANY_ID                                                        
        	            AND R2.DIVISION_ID		= M.DIVISION_ID                                                       
        	            AND R2.SITE_ID			= M.SITE_ID                                                           
        	            AND R2.PLANT_ID			= M.PLANT_ID                                                          
        	            AND R2.FACTORY_ID		= M.FACTORY_ID                                                        
        	            AND R2.OPERATION_ID		= M.OPERATION_ID                                                      
        	            AND R2.LINE_ID			= M.LINE_ID                                                           
        	            AND R2.ELECTRODE_TYPE	= M.ELECTRODE_TYPE                                                    
        	            AND (CASE WHEN R2.LOSS_CODE = N'LA999' THEN N'LA002' ELSE R2.LOSS_CODE END)	= M.LOSS_CODE   
			WHERE R2.LOSS_CODE NOT LIKE 'X%'
			    AND R2.LOSS_CODE <> 'M08'
			    AND M.USER_ID_1 = @p_user_id 
			GROUP BY 
                  R2.DIVISION_ID
				, R2.COMPANY_ID
				, R2.SITE_ID
				, R2.PLANT_ID
				, R2.FACTORY_ID
				, R2.LINE_ID
				, R2.OPERATION_ID
				, R2.ELECTRODE_TYPE
				, R2.OPERATION_GROUP_NAME
				, R2.LOSS_CODE
		) A


	END -- END OF VERSION_ID = 'C'

	-- NOT CURRENT VERSION_ID 조회
	ELSE
	BEGIN
		-- ///////////////////////////////////////////////////////////////////////////////
		-- 3월 간 월별 평균, 3개월 평균 , SCM_WORK_CALENDAR_M_SN , SCM_LOSS_M_SN
		-- , SCM_TACT_TIME_M_SN , SCM_YIELD_M_SN, SCM_YIELD_M_SN
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF @p_check_loss = 'Y'
			BEGIN
				--INSERT INTO #TMP_SCP0049_AVG
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
						, NULL									AS ITEM_ID
						, 0										AS LANE_QTY
						, CONVERT(VARCHAR(6),CM.WORK_DATE ,112) AS YYYYMM
						, ISNULL(SUM(CM.TIME_TERM),0)			AS ITEM_VALUE
						, 0										AS ITEM_VALUE_RESULT
					 FROM #TMP_SCP0049_LOOKUP LU

					 JOIN SCM_WORK_CAL_VER_H_SN CM WITH(NOLOCK)  -- VERSION 테이블
					   ON CM.LOSS_CODE		= LU.LOSS_CODE

					 JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
					   ON CM.DIVISION_ID		= L.DIVISION_ID
					  AND CM.COMPANY_ID		= L.COMPANY_ID
					  AND CM.SITE_ID			= L.SITE_ID
					  AND CM.PLANT_ID		= L.PLANT_ID
					  AND CM.FACTORY_ID		= L.FACTORY_ID
					  AND CM.OPERATION_ID	= L.OPERATION_ID
					  AND CM.LINE_ID			= L.LINE_ID
					  AND CM.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

					WHERE 1 = 1
					  AND CM.VERSION_ID  = @p_version_id
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
				SELECT LM.COMPANY_ID
					 , LM.DIVISION_ID
					 , LM.SITE_ID
					 , LM.PLANT_ID
					 , LM.FACTORY_ID
					 , LM.OPERATION_ID
					 , LM.LINE_ID
					 , LM.ELECTRODE_TYPE
					 , LM.LOSS_CODE
					 , NULL								AS ITEM_ID
					 , 0								AS LANE_QTY
					 , LM.WORK_MONTH					AS YYYYMM
					 , ISNULL(LM.LOSS_RATE	* 100,0)	AS ITEM_VALUE
					 , 0 AS ITEM_VALUE_RESULT
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_LOSS_VER_H_SN LM WITH(NOLOCK)  -- VERSION 테이블
					ON LM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND LM.VERSION_ID  = @p_version_id
				   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
				   AND LM.WORK_MONTH >= @v_start_avg -- '202004'
				   AND LM.WORK_MONTH <= @v_end_avg   -- '202006'

			END

			IF @p_check_line = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA
				
				-- LINE ASSIGN (월별 데이터)
				SELECT LM.COMPANY_ID
					 , LM.DIVISION_ID
					 , LM.SITE_ID
					 , LM.PLANT_ID
					 , LM.FACTORY_ID
					 , LM.OPERATION_ID
					 , LM.LINE_ID
					 , LM.ELECTRODE_TYPE
					 , 'LA001'										AS LOSS_CODE
					 , LM.ITEM_ID									AS ITEM_ID
					 , ISNULL(CONVERT(INT,LM.LANE_QTY),0)			AS LANE_QTY
					 , LM.MONTH										AS YYYYMM
					 , ISNULL(LM.PRIORITY,0)						AS ITEM_VALUE
					 , ISNULL(LM.PRIORITY,0)						AS ITEM_VALUE_RESULT
				  FROM SCM_ITEM_LINE_ASSIGN_VER_H_SN LM WITH(NOLOCK) -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
					ON LM.DIVISION_ID			= I.DIVISION_ID
				   AND LM.COMPANY_ID			= I.COMPANY_ID
				   AND LM.SITE_ID				= I.SITE_ID
				   AND LM.PLANT_ID				= I.PLANT_ID
				   AND LM.FACTORY_ID			= I.FACTORY_ID
				   AND LM.OPERATION_ID			= I.OPERATION_ID
				   AND LM.LINE_ID				= I.LINE_ID
				   AND LM.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				   AND LM.ITEM_ID				= I.ITEM_ID
				   AND ISNULL(LM.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				 WHERE 1 = 1
				   AND LM.VERSION_ID  = @p_version_id
				   AND LM.MONTH >= @v_start_avg -- '202004'
				   AND LM.MONTH <= @v_end_avg   -- '202006'
			END

			IF @p_check_tact = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA
				
				-- TACT TIME (월별 데이터)
				SELECT TM.COMPANY_ID
					 , TM.DIVISION_ID
					 , TM.SITE_ID
					 , TM.PLANT_ID
					 , TM.FACTORY_ID
					 , TM.OPERATION_ID
					 , TM.LINE_ID
					 , TM.ELECTRODE_TYPE
					 , 'LA002'				AS LOSS_CODE
					 , TM.ITEM_ID			AS ITEM_ID
					 , 0					AS LANE_QTY
					 , TM.MONTH				AS YYYYMM
					 , ISNULL(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TM.DAILY_CAPA  ELSE  TM.TACT_TIME END,0) AS ITEM_VALUE
					 , 0					AS ITEM_VALUE_RESULT
				  FROM SCM_TACT_TIME_VER_H_SN TM WITH(NOLOCK) -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
					ON TM.DIVISION_ID		= I.DIVISION_ID
				   AND TM.COMPANY_ID		= I.COMPANY_ID
				   AND TM.SITE_ID			= I.SITE_ID
				   AND TM.PLANT_ID			= I.PLANT_ID
				   AND TM.FACTORY_ID		= I.FACTORY_ID
				   AND TM.OPERATION_ID		= I.OPERATION_ID
				   AND TM.LINE_ID			= I.LINE_ID
				   AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				   AND TM.ITEM_ID			= I.ITEM_ID

				  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				   AND LV.SEGMENT1 			= 'LA002'
				   AND TM.PLANT_ID			= LV.SEGMENT2
				   AND TM.OPERATION_ID		= LV.SEGMENT3
				   AND LV.ACTIVE_FLAG		= 'Y'

				 WHERE 1 = 1
				   AND TM.VERSION_ID  = @p_version_id
				   AND TM.MONTH >= @v_start_avg -- '202004'
				   AND TM.MONTH <= @v_end_avg   -- '202006'

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL 

				SELECT TM.COMPANY_ID
					 , TM.DIVISION_ID
					 , TM.SITE_ID
					 , TM.PLANT_ID
					 , TM.FACTORY_ID
					 , TM.OPERATION_ID
					 , TM.LINE_ID
					 , TM.ELECTRODE_TYPE
					 , 'LA999'					AS LOSS_CODE
					 , TM.ITEM_ID				AS ITEM_ID
					 , 0						AS LANE_QTY
					 , TM.MONTH					AS YYYYMM
					 , ISNULL(TM.DAILY_CAPA,0)	AS ITEM_VALUE
					 , 0						AS ITEM_VALUE_RESULT
				  FROM SCM_TACT_TIME_VER_H_SN TM WITH(NOLOCK) -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
					ON TM.DIVISION_ID		= I.DIVISION_ID
				   AND TM.COMPANY_ID		= I.COMPANY_ID
				   AND TM.SITE_ID			= I.SITE_ID
				   AND TM.PLANT_ID			= I.PLANT_ID
				   AND TM.FACTORY_ID		= I.FACTORY_ID
				   AND TM.OPERATION_ID		= I.OPERATION_ID
				   AND TM.LINE_ID			= I.LINE_ID
				   AND TM.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				   AND TM.ITEM_ID			= I.ITEM_ID

				  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				   AND LV.SEGMENT1 			= 'LA002'
				   AND TM.PLANT_ID			= LV.SEGMENT2
				   AND TM.OPERATION_ID		= LV.SEGMENT3
				   AND LV.ACTIVE_FLAG		= 'Y'
				   AND LV.ATTRIBUTE1		= 'TACT TIME'

				 WHERE 1 = 1
				   AND TM.VERSION_ID  = @p_version_id
				   AND TM.MONTH >= @v_start_avg -- '202004'
				   AND TM.MONTH <= @v_end_avg   -- '202006'
			END

			IF @p_check_yield = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_AVG_DATA
				
				-- YIELD (월별 데이터)
				SELECT YM.COMPANY_ID
					 , YM.DIVISION_ID
					 , YM.SITE_ID
					 , YM.PLANT_ID
					 , YM.FACTORY_ID
					 , YM.OPERATION_ID
					 , YM.LINE_ID
					 , '-'						AS ELECTRODE_TYPE
					 , 'LA003'					AS LOSS_CODE
					 , YM.ITEM_ID				AS ITEM_ID
					 , 0						AS LANE_QTY
					 , YM.MONTH					AS YYYYMM
					 , ISNULL(YM.YIELD * 100,0)	AS ITEM_VALUE
					 , 0						AS ITEM_VALUE_RESULT
				  FROM SCM_YIELD_VER_H_SN YM WITH(NOLOCK) -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
					ON YM.DIVISION_ID		= I.DIVISION_ID
				   AND YM.COMPANY_ID		= I.COMPANY_ID
				   AND YM.SITE_ID			= I.SITE_ID
				   AND YM.PLANT_ID			= I.PLANT_ID
				   AND YM.FACTORY_ID		= I.FACTORY_ID
				   AND YM.OPERATION_ID		= I.OPERATION_ID
				   AND YM.LINE_ID			= I.LINE_ID
				   AND YM.ITEM_ID			= I.ITEM_ID

				 WHERE 1 = 1
				   AND YM.VERSION_ID  = @p_version_id
				   AND YM.MONTH >= @v_start_avg -- '202004'
				   AND YM.MONTH <= @v_end_avg   -- '202006'
			END

			BEGIN
				INSERT INTO #TMP_SCP0049_AVG
				
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
					
				END

				BEGIN
					INSERT INTO #TMP_SCP0049_AVG_MIN_MAX
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
						, BEF_BEST
						, BEF_WORST
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
						 --, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) 
							--	ELSE  MIN(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) END AS BEF_BEST
						 --, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) 
							--	ELSE  MAX(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) END AS BEF_WORST
						 --, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
							--	ELSE  MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_BEST_RESULT
						 --, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
							--	ELSE  MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_WORST_RESULT
				
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) 
						ELSE  MIN(ISNULL(X.ITEM_VALUE, T.ITEM_VALUE)) END AS BEF_BEST
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(X.ITEM_VALUE) 
						ELSE  FORMAT(MAX(X.ITEM_VALUE), '##0.###') END AS BEF_WORST
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MAX(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) 
						ELSE  MIN(ISNULL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT)) END AS BEF_BEST_RESULT
				, CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND  LV.ATTRIBUTE1 = 'DAILY CAPA' ) THEN MIN(X.ITEM_VALUE_RESULT) 
						ELSE  FORMAT(MAX(X.ITEM_VALUE_RESULT),  '##0.#3#') END AS BEF_WORST_RESULT
				
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
				END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 일별 테이블 조회
		-- TABLE_NAME : SCM_WORK_CALENDAR_M_SN
		 -- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			-- 일별 데이터 임시 테이블 삭제
			IF OBJECT_ID('tempdb..#TMP_SCP0049_DAILY2') IS NOT NULL
				DROP TABLE #TMP_SCP0049_DAILY2;
			
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
				  INTO #TMP_SCP0049_DAILY2
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_WORK_CAL_VER_H_SN CM WITH(NOLOCK)  -- VERSION 테이블
					ON CM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND CM.VERSION_ID  = @p_version_id
				   AND LU.DATA_TABLE  = 'SCM_WORK_CALENDAR_M'
				   AND CONVERT(CHAR(8), CM.WORK_DATE , 112) >=  @v_start_day
				   AND CONVERT(CHAR(8), CM.WORK_DATE , 112) <=  @v_end_day
			END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- SCM_WORK_CALENDAR_M_SN , SCM_LOSS_M_SN
		-- 월 합계 구하기(1년 기준)
		-- EX > 7월 조회 기준 8월 ~ 6월 까지
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_MM2') IS NOT NULL
				DROP TABLE #TMP_SCP0049_MM2;

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
				  INTO #TMP_SCP0049_MM2
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_WORK_CAL_VER_H_SN CM WITH(NOLOCK)  -- VERSION 테이블
					ON CM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND CM.VERSION_ID  = @p_version_id
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

				  JOIN SCM_LOSS_VER_H_SN LM WITH(NOLOCK)  -- VERSION 테이블
					ON LM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND LM.VERSION_ID  = @p_version_id
				   AND LU.LOSS_CODE <> 'M08'
				   AND WORK_MONTH >=  @v_start_month
				   AND WORK_MONTH <=  @v_end_month
				   AND LU.DATA_TABLE  = 'SCM_LOSS_M'
			END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 연 합계 구하기(3년 기준)
		-- EX > 2020 7월 조회 기준 2021 ~ 2023 까지
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_YEAR2') IS NOT NULL
				DROP TABLE #TMP_SCP0049_YEAR2;

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
				  INTO #TMP_SCP0049_YEAR2
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_WORK_CAL_VER_H_SN CM WITH(NOLOCK)  -- VERSION 테이블
					ON CM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND CM.VERSION_ID  = @p_version_id
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

				-- SCM_LOSS_M_SN
				SELECT LM.DIVISION_ID
					 , LM.COMPANY_ID						AS COMPANY_ID
					 , LM.SITE_ID							AS SITE_ID
					 , LM.PLANT_ID							AS PLANT_ID
					 , LM.FACTORY_ID						AS FACTORY_ID			-- 공장(오창)
					 , LM.LINE_ID							AS LINE_ID				-- 라인
					 , LM.ELECTRODE_TYPE					AS ELECTRODE_TYPE		-- 라인 구분
					 , LM.OPERATION_ID						AS OPERATION_ID			-- 공정
					 , LM.LOSS_CODE							AS LOSS_CODE
					 , NULL									AS YYYYMMDD
					 , NULL									AS YYYYMM
					 , CONVERT(VARCHAR(4),WORK_MONTH,112)	AS YYYY
					 , SUM(LOSS_RATE)						AS ITEM_VALUE
				  FROM #TMP_SCP0049_LOOKUP LU

				  JOIN SCM_LOSS_VER_H_SN LM WITH(NOLOCK)  -- VERSION 테이블
					ON LM.LOSS_CODE		= LU.LOSS_CODE

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
				   AND LM.VERSION_ID  = @p_version_id
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
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- Line Priority , TACT TIME , YIELD
		-- ///////////////////////////////////////////////////////////////////////////////
	
		BEGIN
			IF @p_check_line = 'Y'
			BEGIN	
				INSERT INTO #TMP_SCP0049_LTY
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
				SELECT LE.DIVISION_ID
					 , LE.COMPANY_ID		AS COMPANY_ID
					 , LE.SITE_ID			AS SITE_ID
					 , LE.PLANT_ID			AS PLANT_ID
					 , LE.FACTORY_ID		AS FACTORY_ID
					 , LE.LINE_ID			AS LINE_ID
					 , LE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					 , LE.OPERATION_ID		AS OPERATION_ID
					 , 'LA001'				AS LOSS_CODE
					 , LE.ITEM_ID			AS ITEM_ID
					 , ISNULL(CONVERT(INT , LE.LANE_QTY),0)		AS LANE_QTY
					 , CONVERT(CHAR(8), LE.START_TIME , 112)	AS YYYYMMDD
					 , NULL										AS YYYYMM
					 , NULL										AS YYYY
					 , LE.PRIORITY			AS ITEM_VALUE
				  FROM SCM_LINE_ASSIGN_EXCT_VER_H_SN  LE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)  -- 수정
					ON LE.DIVISION_ID			= I.DIVISION_ID
				   AND LE.COMPANY_ID			= I.COMPANY_ID
				   AND LE.SITE_ID				= I.SITE_ID
				   AND LE.PLANT_ID				= I.PLANT_ID
				   AND LE.FACTORY_ID			= I.FACTORY_ID
				   AND LE.OPERATION_ID			= I.OPERATION_ID
				   AND LE.LINE_ID				= I.LINE_ID
				   AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				   AND LE.ITEM_ID				= I.ITEM_ID
				   AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				  JOIN #TMP_SCP0049_STD L WITH(NOLOCK)
					ON LE.DIVISION_ID		= L.DIVISION_ID
				   AND LE.COMPANY_ID		= L.COMPANY_ID
				   AND LE.SITE_ID			= L.SITE_ID
				   AND LE.PLANT_ID			= L.PLANT_ID
				   AND LE.FACTORY_ID		= L.FACTORY_ID
				   AND LE.OPERATION_ID		= L.OPERATION_ID
				   AND LE.LINE_ID			= L.LINE_ID
				   AND LE.ELECTRODE_TYPE	= L.ELECTRODE_TYPE

				 WHERE 1 = 1
				   AND LE.VERSION_ID  = @p_version_id
				   AND CONVERT(CHAR(8), LE.START_TIME , 112) >= @v_start_day
				   AND CONVERT(CHAR(8), LE.START_TIME , 112) <= @v_end_day
			END

			IF @p_check_tact = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , CONVERT(CHAR(8), TE.START_TIME , 112)	AS YYYYMMDD -- 날짜
					 , NULL										AS YYYYMM
					 , NULL										AS YYYY
					 , CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						 	WHEN LV.ATTRIBUTE1 = 'TACT TIME' THEN TE.TACT_TIME END		AS ITEM_VALUE
				  FROM SCM_TACT_TIME_EXCT_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
					ON TE.DIVISION_ID		= I.DIVISION_ID
				   AND TE.COMPANY_ID		= I.COMPANY_ID
				   AND TE.SITE_ID			= I.SITE_ID
				   AND TE.PLANT_ID			= I.PLANT_ID
				   AND TE.FACTORY_ID		= I.FACTORY_ID
				   AND TE.OPERATION_ID		= I.OPERATION_ID
				   AND TE.LINE_ID			= I.LINE_ID
				   AND TE.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				   AND TE.ITEM_ID			= I.ITEM_ID

				  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				   AND LV.SEGMENT1 			= 'LA002'
				   AND TE.PLANT_ID			= LV.SEGMENT2
				   AND TE.OPERATION_ID		= LV.SEGMENT3
				   AND LV.ACTIVE_FLAG		= 'Y'

				 WHERE 1 = 1
				   AND TE.VERSION_ID  = @p_version_id
				   AND CONVERT(CHAR(8), TE.START_TIME , 112) >= @v_start_day
				   AND CONVERT(CHAR(8), TE.START_TIME , 112) <= @v_end_day

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL

				SELECT TE.DIVISION_ID
					 , TE.COMPANY_ID		AS COMPANY_ID
					 , TE.SITE_ID			AS SITE_ID
					 , TE.PLANT_ID			AS PLANT_ID
					 , TE.FACTORY_ID		AS FACTORY_ID
					 , TE.LINE_ID			AS LINE_ID
					 , TE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					 , TE.OPERATION_ID		AS OPERATION_ID
					 , 'LA999'				AS LOSS_CODE
					 , TE.ITEM_ID			AS ITEM_ID
					 , 0					AS LANE_QTY
					 , CONVERT(CHAR(8), TE.START_TIME , 112)	AS YYYYMMDD -- 날짜
					 , NULL										AS YYYYMM
					 , NULL										AS YYYY
					 , TE.DAILY_CAPA							AS ITEM_VALUE
				  FROM SCM_TACT_TIME_EXCT_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
					ON TE.DIVISION_ID		= I.DIVISION_ID
				   AND TE.COMPANY_ID		= I.COMPANY_ID
				   AND TE.SITE_ID			= I.SITE_ID
				   AND TE.PLANT_ID			= I.PLANT_ID
				   AND TE.FACTORY_ID		= I.FACTORY_ID
				   AND TE.OPERATION_ID		= I.OPERATION_ID
				   AND TE.LINE_ID			= I.LINE_ID
				   AND TE.ELECTRODE_TYPE	= I.ELECTRODE_TYPE
				   AND TE.ITEM_ID			= I.ITEM_ID

				  JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
				    ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
				   AND LV.SEGMENT1 			= 'LA002'
				   AND TE.PLANT_ID			= LV.SEGMENT2
				   AND TE.OPERATION_ID		= LV.SEGMENT3
				   AND LV.ACTIVE_FLAG		= 'Y'
				   AND LV.ATTRIBUTE1		= 'TACT TIME'

				 WHERE 1 = 1
				   AND TE.VERSION_ID  = @p_version_id
				   AND CONVERT(CHAR(8), TE.START_TIME , 112) >= @v_start_day
				   AND CONVERT(CHAR(8), TE.START_TIME , 112) <= @v_end_day
				   ;
			END

			IF @p_check_yield = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , YE.COMPANY_ID		AS COMPANY_ID
					 , YE.SITE_ID			AS SITE_ID
					 , YE.PLANT_ID			AS PLANT_ID
					 , YE.FACTORY_ID		AS FACTORY_ID
					 , YE.LINE_ID			AS LINE_ID
					 , '-'					AS ELECTRODE_TYPE -- I.ELECTRODE_TYPE
					 , YE.OPERATION_ID		AS OPERATION_ID
					 , 'LA003'				AS LOSS_CODE
					 , YE.ITEM_ID			AS ITEM_ID
					 , 0					AS LANE_QTY
					 , CONVERT(CHAR(8), YE.START_TIME , 112)	AS YYYYMMDD -- 날짜
					 , NULL										AS YYYYMM
					 , NULL										AS YYYY
					 , ISNULL(YE.YIELD * 100,0)					AS ITEM_VALUE
				  FROM SCM_YIELD_EXCT_VER_H_SN YE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
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
				   AND CONVERT(CHAR(8), YE.START_TIME , 112) >= @v_start_day
				   AND CONVERT(CHAR(8), YE.START_TIME , 112) <= @v_end_day
			END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- Line Priority 월 별
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF @p_check_line = 'Y'  -- Line Priority
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
				SELECT LE.DIVISION_ID
					 , LE.COMPANY_ID			AS COMPANY_ID
					 , LE.SITE_ID				AS SITE_ID
					 , LE.PLANT_ID				AS PLANT_ID
					 , LE.FACTORY_ID			AS FACTORY_ID
					 , LE.LINE_ID				AS LINE_ID
					 , LE.ELECTRODE_TYPE		AS ELECTRODE_TYPE
					 , LE.OPERATION_ID			AS OPERATION_ID
					 , 'LA001'					AS LOSS_CODE
					 , LE.ITEM_ID							AS ITEM_ID
					 , ISNULL(CONVERT(INT,LE.LANE_QTY),0)	AS LANE_QTY
					 , NULL						AS YYYYMMDD
					 , LE.MONTH					AS YYYYMM
					 , NULL						AS YYYY
					 , CONVERT(NUMERIC(10,4),LE.PRIORITY)			AS ITEM_VALUE
				  FROM SCM_ITEM_LINE_ASSIGN_VER_H_SN LE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
					ON LE.DIVISION_ID			= I.DIVISION_ID
				   AND LE.COMPANY_ID			= I.COMPANY_ID
				   AND LE.SITE_ID				= I.SITE_ID
				   AND LE.PLANT_ID				= I.PLANT_ID
				   AND LE.FACTORY_ID			= I.FACTORY_ID
				   AND LE.OPERATION_ID			= I.OPERATION_ID
				   AND LE.LINE_ID				= I.LINE_ID
				   AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				   AND LE.ITEM_ID				= I.ITEM_ID
				   AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				 WHERE 1 = 1
				   AND LE.VERSION_ID  = @p_version_id
				   AND LE.MONTH >= @v_start_month
				   AND LE.MONTH <= @v_end_month
			END

			IF @p_check_tact = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						 	WHEN LV.ATTRIBUTE1 = 'TACT TIME' THEN TE.TACT_TIME END		AS ITEM_VALUE
				  FROM SCM_TACT_TIME_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL

				SELECT TE.DIVISION_ID
					 , TE.COMPANY_ID		AS COMPANY_ID
					 , TE.SITE_ID			AS SITE_ID
					 , TE.PLANT_ID			AS PLANT_ID
					 , TE.FACTORY_ID		AS FACTORY_ID
					 , TE.LINE_ID			AS LINE_ID
					 , TE.ELECTRODE_TYPE	AS ELECTRODE_TYPE
					 , TE.OPERATION_ID		AS OPERATION_ID
					 , 'LA999'				AS LOSS_CODE
					 , TE.ITEM_ID			AS ITEM_ID
					 , 0					AS LANE_QTY
					 , NULL					AS YYYYMMDD
					 , TE.MONTH				AS YYYYMM
					 , NULL					AS YYYY
					 , TE.DAILY_CAPA 		AS ITEM_VALUE
				  FROM SCM_TACT_TIME_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				   AND LV.ATTRIBUTE1		= 'TACT TIME'

				 WHERE 1 = 1
				   AND TE.VERSION_ID  = @p_version_id
				   AND TE.MONTH >= @v_start_month
				   AND TE.MONTH <= @v_end_month
			END

			IF @p_check_yield = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , '-'								AS ELECTRODE_TYPE -- I.ELECTRODE_TYPE
					 , YE.OPERATION_ID					AS OPERATION_ID
					 , 'LA003'							AS LOSS_CODE
					 , YE.ITEM_ID						AS ITEM_ID
					 , 0								AS LANE_QTY
					 , NULL								AS YYYYMMDD
					 , YE.MONTH							AS YYYYMM
					 , NULL								AS YYYY
					 , ROUND(YE.YIELD * 100 , 2 )		AS ITEM_VALUE
				  FROM SCM_YIELD_VER_H_SN YE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
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
			END
		END

		-- /////////////////////////////////////////////////////////////////////
		-- LTY YEAR 값 조회
		-- /////////////////////////////////////////////////////////////////////
		BEGIN
			IF @p_check_line = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
				SELECT LE.DIVISION_ID
					 , LE.COMPANY_ID
					 , LE.SITE_ID
					 , LE.PLANT_ID
					 , LE.FACTORY_ID
					 , LE.LINE_ID
					 , LE.ELECTRODE_TYPE
					 , LE.OPERATION_ID
					 , 'LA001'								AS LOSS_CODE
					 , LE.ITEM_ID							AS ITEM_ID
					 , ISNULL(CONVERT(INT,LE.LANE_QTY),0)	AS LANE_QTY
					 , NULL									AS YYYYMMDD
					 , NULL									AS YYYYMM
					 , CONVERT(VARCHAR(4), LE.MONTH,112)	AS YYYY
					 , MIN(CONVERT(NUMERIC(10,4),LE.PRIORITY))		AS ITEM_VALUE
				  FROM SCM_ITEM_LINE_ASSIGN_VER_H_SN LE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM I WITH(NOLOCK)
					ON LE.DIVISION_ID			= I.DIVISION_ID
				   AND LE.COMPANY_ID			= I.COMPANY_ID
				   AND LE.SITE_ID				= I.SITE_ID
				   AND LE.PLANT_ID				= I.PLANT_ID
				   AND LE.FACTORY_ID			= I.FACTORY_ID
				   AND LE.OPERATION_ID			= I.OPERATION_ID
				   AND LE.LINE_ID				= I.LINE_ID
				   AND LE.ELECTRODE_TYPE		= I.ELECTRODE_TYPE
				   AND LE.ITEM_ID				= I.ITEM_ID
				   AND ISNULL(LE.LANE_QTY,0)	= ISNULL(I.LANE_QTY,0)

				 WHERE 1 = 1
				   AND LE.VERSION_ID  = @p_version_id
				   AND CONVERT(VARCHAR(4),LE.MONTH) >= @v_start_year
				   AND CONVERT(VARCHAR(4),LE.MONTH) <= @v_end_year

				  GROUP BY LE.COMPANY_ID
					, LE.DIVISION_ID
					, LE.SITE_ID
					, LE.PLANT_ID
					, LE.FACTORY_ID
					, LE.OPERATION_ID
					, LE.LINE_ID
					, LE.ELECTRODE_TYPE
					, LE.ITEM_ID
					, ISNULL(CONVERT(INT,LE.LANE_QTY),0)
					, CONVERT(VARCHAR(4), LE.MONTH,112)
			END

			IF @p_check_tact = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , TE.COMPANY_ID						AS COMPANY_ID
					 , TE.SITE_ID							AS SITE_ID
					 , TE.PLANT_ID							AS PLANT_ID
					 , TE.FACTORY_ID						AS FACTORY_ID
					 , TE.LINE_ID							AS LINE_ID
					 , TE.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					 , TE.OPERATION_ID						AS OPERATION_ID
					 , 'LA002'								AS LOSS_CODE
					 , TE.ITEM_ID							AS ITEM_ID
					 , 0									AS LANE_QTY
					 , NULL									AS YYYYMMDD
					 , NULL									AS YYYYMM
					 , CONVERT(VARCHAR(4), TE.MONTH,112)	AS YYYY
					 , MIN(CASE WHEN LV.ATTRIBUTE1 = 'DAILY CAPA' THEN TE.DAILY_CAPA 
						 		WHEN LV.ATTRIBUTE1 = 'TACT TIME'  THEN TE.TACT_TIME END)		AS ITEM_VALUE
				  FROM SCM_TACT_TIME_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				   AND CONVERT(VARCHAR(4),TE.MONTH) >= @v_start_year
				   AND CONVERT(VARCHAR(4),TE.MONTH) <= @v_end_year

				   GROUP BY TE.COMPANY_ID
					, TE.DIVISION_ID
					, TE.SITE_ID
					, TE.PLANT_ID
					, TE.FACTORY_ID
					, TE.OPERATION_ID
					, TE.LINE_ID
					, TE.ELECTRODE_TYPE
					, TE.ITEM_ID
					, CONVERT(VARCHAR(4), TE.MONTH,112)

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				UNION ALL

				SELECT TE.DIVISION_ID
					 , TE.COMPANY_ID						AS COMPANY_ID
					 , TE.SITE_ID							AS SITE_ID
					 , TE.PLANT_ID							AS PLANT_ID
					 , TE.FACTORY_ID						AS FACTORY_ID
					 , TE.LINE_ID							AS LINE_ID
					 , TE.ELECTRODE_TYPE					AS ELECTRODE_TYPE
					 , TE.OPERATION_ID						AS OPERATION_ID
					 , 'LA999'								AS LOSS_CODE
					 , TE.ITEM_ID							AS ITEM_ID
					 , 0									AS LANE_QTY
					 , NULL									AS YYYYMMDD
					 , NULL									AS YYYYMM
					 , CONVERT(VARCHAR(4), TE.MONTH,112)	AS YYYY
					 , MIN(TE.DAILY_CAPA )					AS ITEM_VALUE
				  FROM SCM_TACT_TIME_VER_H_SN TE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_TACT I WITH(NOLOCK)
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
				   AND LV.ATTRIBUTE1		= 'TACT TIME'

				 WHERE 1 = 1
				   AND TE.VERSION_ID  = @p_version_id
				   AND CONVERT(VARCHAR(4),TE.MONTH) >= @v_start_year
				   AND CONVERT(VARCHAR(4),TE.MONTH) <= @v_end_year

				   GROUP BY TE.COMPANY_ID
					, TE.DIVISION_ID
					, TE.SITE_ID
					, TE.PLANT_ID
					, TE.FACTORY_ID
					, TE.OPERATION_ID
					, TE.LINE_ID
					, TE.ELECTRODE_TYPE
					, TE.ITEM_ID
					, CONVERT(VARCHAR(4), TE.MONTH,112)
				;
			END

			IF @p_check_yield = 'Y'
			BEGIN
				INSERT INTO #TMP_SCP0049_LTY
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
					 , YE.COMPANY_ID		AS COMPANY_ID
					 , YE.SITE_ID			AS SITE_ID
					 , YE.PLANT_ID			AS PLANT_ID
					 , YE.FACTORY_ID		AS FACTORY_ID
					 , YE.LINE_ID			AS LINE_ID
					 , '-'					AS ELECTRODE_TYPE -- I.ELECTRODE_TYPE
					 , YE.OPERATION_ID		AS OPERATION_ID
					 , 'LA003'				AS LOSS_CODE
					 , YE.ITEM_ID			AS ITEM_ID
					 , 0					AS LANE_QTY
					 , NULL					AS YYYYMMDD
					 , NULL									AS YYYYMM
					 , CONVERT(VARCHAR(4), YE.MONTH,112)	AS YYYY
					 , ROUND(MAX(YE.YIELD * 100 ) , 2)		AS ITEM_VALUE
				  FROM SCM_YIELD_VER_H_SN YE WITH(NOLOCK)  -- VERSION 테이블

				  JOIN #TMP_SCP0049_STD_ITEM_YIELD I WITH(NOLOCK)
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
				   AND CONVERT(VARCHAR(4),YE.MONTH) >= @v_start_year
				   AND CONVERT(VARCHAR(4),YE.MONTH) <= @v_end_year

				GROUP BY YE.COMPANY_ID
					, YE.DIVISION_ID
					, YE.SITE_ID
					, YE.PLANT_ID
					, YE.FACTORY_ID
					, YE.OPERATION_ID
					, YE.LINE_ID
					, YE.ITEM_ID
					, CONVERT(VARCHAR(4), YE.MONTH,112)
			END
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- DAILY , MM ,YEAR 합기기
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF @p_check_loss = 'Y'
			BEGIN
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
				  FROM #TMP_SCP0049_DAILY2
				 UNION ALL
				SELECT *
				  FROM #TMP_SCP0049_MM2
				 UNION ALL
				SELECT *
				  FROM #TMP_SCP0049_YEAR2
			END
		END


		-- ///////////////////////////////////////////////////////////////////////////////
		-- AVG 정보 추가
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
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
							  FROM (  SELECT A.DIVISION_ID
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
								AND A.COMPANY_ID	= B.COMPANY_ID
								AND A.SITE_ID		= B.SITE_ID
								AND A.PLANT_ID		= B.PLANT_ID
								AND A.FACTORY_ID	= B.FACTORY_ID
								AND A.LINE_ID		= B.LINE_ID
								AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
								AND A.OPERATION_ID	= B.OPERATION_ID
							) R
							  LEFT JOIN #TMP_SCP0049_LOOKUP LU
								ON 1=1
							 WHERE 1=1
							   AND LU.DATA_TABLE IN ('SCM_WORK_CALENDAR_M','SCM_LOSS_M')
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
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- LTY Line Priority 기준으로 정보 Tact Time , Yield 추가
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
			IF @p_check_tact = 'Y'
			BEGIN 
				INSERT INTO #TMP_SCP0049_LTY
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
				)
				SELECT DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, 'LA002'
					, ITEM_ID
					, @v_start_month    -- 조회 시작일자
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
								, R.ITEM_ID
							FROM #TMP_SCP0049_STD_ITEM R
						EXCEPT
							SELECT DISTINCT
								R.DIVISION_ID
								, R.COMPANY_ID
								, R.SITE_ID
								, R.PLANT_ID
								, R.FACTORY_ID
								, R.LINE_ID
								, R.ELECTRODE_TYPE
								, R.OPERATION_ID
								, R.ITEM_ID
							FROM #TMP_SCP0049_LTY R
							WHERE R.LOSS_CODE = 'LA002'
					) A
				;

				-- TACT TIME 공정 인 경우 DAILY CAPA 도 보여주기 위한 처리
				INSERT INTO #TMP_SCP0049_LTY
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
				)
				SELECT DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, 'LA999'
					, ITEM_ID
					, @v_start_month    -- 조회 시작일자
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
								, R.ITEM_ID
							FROM #TMP_SCP0049_LTY R
							JOIN SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)    -- 2020/11/18, khj79
							  ON LV.LOOKUP_TYPE_CODE 	= 'CAPA_UI_CAPA_DEFINIT'
							 AND LV.SEGMENT1 			= 'LA002'
							 AND R.PLANT_ID			= LV.SEGMENT2
							 AND R.OPERATION_ID		= LV.SEGMENT3
							 AND LV.ACTIVE_FLAG		= 'Y'
							 AND LV.ATTRIBUTE1		= 'TACT TIME'
							WHERE R.LOSS_CODE = 'LA001'

						EXCEPT
							SELECT DISTINCT
								R.DIVISION_ID
								, R.COMPANY_ID
								, R.SITE_ID
								, R.PLANT_ID
								, R.FACTORY_ID
								, R.LINE_ID
								, R.ELECTRODE_TYPE
								, R.OPERATION_ID
								, R.ITEM_ID
							FROM #TMP_SCP0049_LTY R
							WHERE R.LOSS_CODE = 'LA999'
					) A
					;
			END

			IF @p_check_yield = 'Y'
			BEGIN 
				INSERT INTO #TMP_SCP0049_LTY
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
				)
				SELECT DIVISION_ID
					, COMPANY_ID
					, SITE_ID
					, PLANT_ID
					, FACTORY_ID
					, LINE_ID
					, ELECTRODE_TYPE
					, OPERATION_ID
					, 'LA003'
					, ITEM_ID
					, @v_start_month    -- 조회 시작일자
				FROM (
						SELECT DISTINCT
							R.DIVISION_ID
							, R.COMPANY_ID
							, R.SITE_ID
							, R.PLANT_ID
							, R.FACTORY_ID
							, R.LINE_ID
							, '-'				AS ELECTRODE_TYPE
							, R.OPERATION_ID
							, R.ITEM_ID
						FROM #TMP_SCP0049_STD_ITEM R
						EXCEPT
						SELECT DISTINCT
							R.DIVISION_ID
							, R.COMPANY_ID
							, R.SITE_ID
							, R.PLANT_ID
							, R.FACTORY_ID
							, R.LINE_ID
							, '-'				AS ELECTRODE_TYPE
							, R.OPERATION_ID
							, R.ITEM_ID
						FROM #TMP_SCP0049_LTY R
						WHERE R.LOSS_CODE = 'LA003'
					) A
			END
		END

		
		

		BEGIN
			--IF @p_check_tact_needed = 'Y' OR @p_check_yield_needed = 'Y'

			IF OBJECT_ID('TEMPDB..#TMP_SCP0049_NOT_LA_VER') IS NOT NULL
			DROP TABLE #TMP_SCP0049_NOT_LA_VER;

			IF @p_check_empty = 'Y'
			BEGIN
					 SELECT DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, X.LOSS_CODE
						, ITEM_ID
					 INTO #TMP_SCP0049_NOT_LA_VER
					 FROM #TMP_SCP0049_LTY A
					 LEFT JOIN ( SELECT LOSS_CODE
					               FROM #TMP_SCP0049_LOOKUP
								  WHERE (	 ( @p_check_tact = 'Y'  AND LOSS_CODE  = 'LA002' ) 
										  OR ( @p_check_yield = 'Y' AND LOSS_CODE  = 'LA003' ) 
										)
							) X
						ON 1=1
					 WHERE A.LOSS_CODE = 'LA001'
					   AND ITEM_VALUE = 9.0
					   AND YYYYMM IS NOT NULL
					GROUP BY DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, X.LOSS_CODE
						, ITEM_ID HAVING COUNT(1) = @v_month_cnt

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
					FROM #TMP_SCP0049_LTY T
					WHERE LOSS_CODE = 'LA002'
						AND ITEM_VALUE > 0 
						AND YYYYMM IS NOT NULL
						AND @p_check_tact = 'Y'
					GROUP BY DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, LOSS_CODE
						, ITEM_ID HAVING COUNT(1) = @v_month_cnt

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
					FROM #TMP_SCP0049_LTY T
					WHERE LOSS_CODE = 'LA003'
						AND ITEM_VALUE > 0 
						AND YYYYMM IS NOT NULL
						AND @p_check_yield = 'Y'
					GROUP BY DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, LOSS_CODE
						, ITEM_ID HAVING COUNT(1) = @v_month_cnt

				;

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
					SELECT A.DIVISION_ID
						, A.COMPANY_ID
						, A.SITE_ID
						, A.PLANT_ID
						, A.FACTORY_ID
						, A.LINE_ID
						, A.ELECTRODE_TYPE
						, A.OPERATION_ID
						, A.LOSS_CODE
						, A.ITEM_ID
						, A.LANE_QTY
						, A.YYYYMMDD
						, A.YYYYMM
						, A.YYYY
						, A.ITEM_VALUE
					FROM #TMP_SCP0049_LTY A
				   WHERE NOT EXISTS (SELECT *
									   FROM #TMP_SCP0049_NOT_LA_VER T
										WHERE T.DIVISION_ID		= A.DIVISION_ID
											AND T.COMPANY_ID	= A.COMPANY_ID
											AND T.SITE_ID		= A.SITE_ID
											AND T.PLANT_ID		= A.PLANT_ID
											AND T.FACTORY_ID	= A.FACTORY_ID
											AND T.OPERATION_ID	= A.OPERATION_ID
											AND T.LINE_ID		= A.LINE_ID
											AND T.ITEM_ID		= A.ITEM_ID
											AND T.LOSS_CODE =  (CASE WHEN A.LOSS_CODE = 'LA999' THEN 'LA002' ELSE A.LOSS_CODE END ) 
								)
					
			END
			ELSE
			BEGIN
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
				END
			
			;
		END

		-- ///////////////////////////////////////////////////////////////////////////////
		-- 데이터 합치기
		-- ///////////////////////////////////////////////////////////////////////////////
		BEGIN
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
						, '-'			AS ITEM_ID
						, NULL			AS LANE_QTY
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
					  LEFT JOIN #TMP_SCP0049_LOOKUP LK
						ON LK.DATA_TABLE = 'CAL'
					   AND LK.LOSS_CODE <> 'XA001'
		END

		BEGIN
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
			   ;


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
			  ;

			  
			  UPDATE X
			   SET X.BEF_BEST = ISNULL(A.BEF_BEST,0)
				 , X.BEF_WORST = ISNULL(A.BEF_WORST,0)
				 , X.BEF_BEST_RESULT = ISNULL(A.BEF_BEST_RESULT,0)
				 , X.BEF_WORST_RESULT = ISNULL(A.BEF_WORST_RESULT,0)
			  FROM #TMP_SCP0049_ALL X
			  JOIN #TMP_SCP0049_AVG_MIN_MAX A
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


		---- ///////////////////////////////////////////////////////////////////////////////
		---- LINE 정보를 조회
		---- YIELD 는 ELECTRODE TYPE 정보가 없어 다른 테이블 조인이 필요함
		---- ///////////////////////////////////////////////////////////////////////////////
		--BEGIN
		--	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ALL_LINE2') IS NOT NULL
		--		DROP TABLE #TMP_SCP0049_ALL_LINE2;
			
		--	SELECT T1.DIVISION_ID
		--		 , T1.COMPANY_ID
		--		 , T1.SITE_ID
		--		 , ST.SITE_NAME
		--		 , T1.PLANT_ID
		--		 , T1.FACTORY_ID
		--		 , ST.FACTORY_NAME
		--		 , T1.LINE_ID
		--		 , ST.LINE_NAME
		--		 , T1.ELECTRODE_TYPE
		--		 , ST.OPERATION_GROUP_NAME
		--		 , T1.OPERATION_ID
		--		 , ST.OPERATION_NAME
		--		 , T1.LOSS_CODE
		--		 , T1.ITEM_ID
		--		 , SI.NICK_NAME
		--		 , T1.LANE_QTY
		--		 , T1.ITEM_VALUE
		--		 , T1.YYYYMMDD
		--		 , T1.YYYYMM
		--		 , T1.YYYY
		--		 , T1.BEF_M6
		--		 , T1.BEF_M5
		--		 , T1.BEF_M4
		--		 , T1.BEF_M3
		--		 , T1.BEF_M2
		--		 , T1.BEF_M1
		--		 , T1.BEF_M6_RESULT
		--		 , T1.BEF_M5_RESULT
		--		 , T1.BEF_M4_RESULT
		--		 , T1.BEF_M3_RESULT
		--		 , T1.BEF_M2_RESULT
		--		 , T1.BEF_M1_RESULT
		--		 , T1.BEF_BEST
		--		 , T1.BEF_WORST
		--		 , T1.BEF_BEST_RESULT
		--		 , T1.BEF_WORST_RESULT
		--	  INTO #TMP_SCP0049_ALL_LINE2
		--	  FROM #TMP_SCP0049_ALL T1
		--	  LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) -- LINE 정보
		--		ON T1.COMPANY_ID		= ST.COMPANY_ID
		--	   AND T1.DIVISION_ID		= ST.DIVISION_ID
		--	   AND T1.SITE_ID			= ST.SITE_ID
		--	   AND T1.PLANT_ID			= ST.PLANT_ID
		--	   AND T1.FACTORY_ID		= ST.FACTORY_ID
		--	   AND T1.OPERATION_ID		= ST.OPERATION_ID
		--	   AND T1.LINE_ID			= ST.LINE_ID
		--	   AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE

		--	  LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) -- LINE 정보
		--		ON T1.COMPANY_ID		= SI.COMPANY_ID
		--	   AND T1.DIVISION_ID		= SI.DIVISION_ID
		--	   AND T1.SITE_ID			= SI.SITE_ID
		--	   AND T1.PLANT_ID			= SI.PLANT_ID
		--	   AND T1.FACTORY_ID		= SI.FACTORY_ID
		--	   AND T1.OPERATION_ID		= SI.OPERATION_ID
		--	   AND T1.LINE_ID			= SI.LINE_ID
		--	   AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE
		--	   AND T1.ITEM_ID 			= SI.ITEM_ID
		--	 WHERE T1.LOSS_CODE <> 'LA003'   -- YIELD 제외

		--	 UNION ALL

		--	 SELECT T1.DIVISION_ID
		--		 , T1.COMPANY_ID
		--		 , T1.SITE_ID
		--		 , SI.SITE_NAME
		--		 , T1.PLANT_ID
		--		 , T1.FACTORY_ID
		--		 , SI.FACTORY_NAME
		--		 , T1.LINE_ID
		--		 , SI.LINE_NAME
		--		 , ISNULL(T1.ELECTRODE_TYPE,'-') AS ELECTRODE_TYPE
		--		 , SI.OPERATION_GROUP_NAME
		--		 , T1.OPERATION_ID
		--		 , SI.OPERATION_NAME
		--		 , T1.LOSS_CODE
		--		 , T1.ITEM_ID
		--		 , SI.NICK_NAME
		--		 , T1.LANE_QTY
		--		 , T1.ITEM_VALUE
		--		 , T1.YYYYMMDD
		--		 , T1.YYYYMM
		--		 , T1.YYYY
		--		 , T1.BEF_M6
		--		 , T1.BEF_M5
		--		 , T1.BEF_M4
		--		 , T1.BEF_M3
		--		 , T1.BEF_M2
		--		 , T1.BEF_M1
		--		 , T1.BEF_M6_RESULT
		--		 , T1.BEF_M5_RESULT
		--		 , T1.BEF_M4_RESULT
		--		 , T1.BEF_M3_RESULT
		--		 , T1.BEF_M2_RESULT
		--		 , T1.BEF_M1_RESULT
		--		 , T1.BEF_BEST
		--		 , T1.BEF_WORST
		--		 , T1.BEF_BEST_RESULT
		--		 , T1.BEF_WORST_RESULT
		--	  FROM #TMP_SCP0049_ALL T1

		--	  LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) -- LINE 정보
		--		ON T1.COMPANY_ID		= SI.COMPANY_ID
		--	   AND T1.DIVISION_ID		= SI.DIVISION_ID
		--	   AND T1.SITE_ID			= SI.SITE_ID
		--	   AND T1.PLANT_ID			= SI.PLANT_ID
		--	   AND T1.FACTORY_ID		= SI.FACTORY_ID
		--	   AND T1.OPERATION_ID		= SI.OPERATION_ID
		--	   AND T1.LINE_ID			= SI.LINE_ID
		--	   AND T1.ITEM_ID 			= SI.ITEM_ID

		--	 WHERE T1.LOSS_CODE = 'LA003'   -- YIELD
		--END;


		---- ///////////////////////////////////////////////////////////////////////////////
		---- 기준정보별 부가정보 (담당자, operation, factory, line, site)
		---- ///////////////////////////////////////////////////////////////////////////////
		--BEGIN
		--	-- 임시 테이블 삭제
		--	IF OBJECT_ID('TEMPDB..#TMP_SCP0049_RESULT2') IS NOT NULL
		--		DROP TABLE #TMP_SCP0049_RESULT2;

		--		SELECT RL.DIVISION_ID
		--			 , RL.COMPANY_ID
		--			 , RL.SITE_ID
		--			 , RL.SITE_NAME
		--			 , RL.PLANT_ID
		--			 , RL.FACTORY_ID
		--			 , RL.FACTORY_NAME
		--			 , RL.LINE_ID
		--			 , RL.LINE_NAME
		--			 , RL.ELECTRODE_TYPE
		--			 , RL.OPERATION_GROUP_NAME
		--			 , RL.OPERATION_ID
		--			 , RL.OPERATION_NAME
		--			 --, LK.CATEGORY_ID
		--			 --, CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
		--			 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'DAILY CAPA' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID
		--			 , CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003','LA999') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
		--			 , RL.LOSS_CODE
		--			 , RL.ITEM_ID
		--			 , RL.LANE_QTY
		--			 , ISNULL(M.DEPARTMENT, CASE WHEN RL.SITE_ID = 'A001' THEN C.DEPT_NAME_KO
		--										 WHEN RL.SITE_ID = 'A002' THEN C.DEPT_NAME_CN
		--									ELSE DEPT_NAME_EN	
		--							END) AS DEPARTMENT
		--			 , M.USER_ID_1									AS USER_ID_1
		--			 , C.USER_NAME									AS MANAGER
		--			 , M.USER_ID_2									AS USER_ID_2
		--			 , M.USER_ID_3									AS USER_ID_3
		--			 , M.USER_ID_4									AS USER_ID_4
		--			 , M.USER_ID_5									AS USER_ID_5
		--			 , M.USER_ID_6									AS USER_ID_6
		--			 , M.USER_ID_7									AS USER_ID_7
		--			 , M.USER_ID_8									AS USER_ID_8
		--			 , M.USER_ID_9									AS USER_ID_9
		--			 , M.USER_ID_10									AS USER_ID_10
		--			 , M.CONFIRM_FLAG
		--			 , 'D_' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD
		--			 , 'M_' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM
		--			 , 'Y_' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY
		--			 , RL.ITEM_VALUE
		--			  , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M6)  
		--			   END AS BEF_M6
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M5)  
		--			   END AS BEF_M5
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M4)  
		--			   END AS BEF_M4

		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M3)  
		--			   END AS BEF_M3
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M2)  
		--			   END AS BEF_M2
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1)
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M1)  
		--			   END AS BEF_M1
		--			, CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 
		--			   END AS BEF_M6_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 
		--			   END AS BEF_M5_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 
		--			   END AS BEF_M4_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 
		--			   END AS BEF_M3_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 
		--			   END AS BEF_M2_RESULT
		--			 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
		--					WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
		--					WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 
		--					ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 
		--			   END AS BEF_M1_RESULT
		--			   -----------------------------------------
		--			 , RL.BEF_BEST
		--			 , RL.BEF_WORST
		--			 , RL.BEF_BEST_RESULT
		--			 , RL.BEF_WORST_RESULT
		--			-----------------------------------------
		--			 , SORT_ORDER
		--			 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'EA'
		--					WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = 'TACT TIME' THEN LK.UOM ELSE 'EA' END AS UOM
		--		  INTO #TMP_SCP0049_RESULT2
		--		  FROM #TMP_SCP0049_ALL_LINE2 RL
		--		  LEFT JOIN (SELECT   LU.*
		--							, LV.SEGMENT2 		AS PLANT_ID
		--							, LV.SEGMENT3 		AS OPERATION_ID
		--							, LV.ATTRIBUTE1 	AS CATEGORY_2
		--					   FROM #TMP_SCP0049_LOOKUP LU
		--					   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV
		--						 ON 	1=1
		--						AND 	LV.LOOKUP_TYPE_CODE = 'CAPA_UI_CAPA_DEFINIT'
		--						AND 	LU.LOSS_CODE = LV.SEGMENT1
		--						AND 	LV.ACTIVE_FLAG = 'Y') LK    -- 공정별 CAPA 보완
		--			ON RL.LOSS_CODE			= LK.LOSS_CODE
		--		   AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.PLANT_ID ELSE RL.PLANT_ID END
		--		   AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END

		--		  LEFT JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK) --기준정보별 담당자 정보
		--			ON RL.COMPANY_ID		= M.COMPANY_ID
		--		   AND RL.DIVISION_ID		= M.DIVISION_ID
		--		   AND RL.SITE_ID			= M.SITE_ID
		--		   AND RL.PLANT_ID			= M.PLANT_ID
		--		   AND RL.FACTORY_ID		= M.FACTORY_ID
		--		   AND RL.OPERATION_ID		= M.OPERATION_ID
		--		   AND RL.LINE_ID			= M.LINE_ID
		--		   AND RL.ELECTRODE_TYPE	= M.ELECTRODE_TYPE
		--		   --AND RL.LOSS_CODE			= M.LOSS_CODE
		--		   AND (CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'LA002' ELSE RL.LOSS_CODE END)	= M.LOSS_CODE

		--		  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
		--					  FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
		--						 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
		--					 WHERE 1=1
		--					   AND A.DEPT_ID = B.DEPT_ID
		--					) C
		--		   ON 1 = 1
		--		  AND M.USER_ID_1 = C.USER_ID
			
		--END

		-- /////////////////////////// PIVOT 처리를 위한 SUM QUERY 생성
		BEGIN
			SET @MQRY_SUM = '';
			
			SELECT @MQRY_SUM = @MQRY_SUM+','+  CASE WHEN CHARINDEX('D_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYYMMDD = RIGHT('''+YYYYMMDD+''',10) THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
													WHEN CHARINDEX('M_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYYMM   = RIGHT('''+YYYYMMDD+''',8)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
													WHEN CHARINDEX('Y_', YYYYMMDD) =1 THEN 'SUM(CASE WHEN R.YYYY     = RIGHT('''+YYYYMMDD+''',6)  THEN CONVERT(NUMERIC(20,4), ISNULL(R.ITEM_VALUE, 0)) ELSE 0 END ) AS ' + YYYYMMDD
										END +''+  CHAR(10)
			 FROM ( 
					SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
						 ,  CONVERT(CHAR(2), '10') + A.BASIS_YYYYMMDD  AS SORT_ORDER_NO
					  FROM [DBO].[SCM_SYS_CALENDAR_M] A 
					 WHERE A.BASIS_YYYYMMDD  >= @v_start_day
					   AND A.BASIS_YYYYMMDD  <= @v_end_day
					 GROUP BY A.BASIS_YYYYMMDD

					 UNION ALL

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
					 WHERE A.CALENDAR_YYYY  >= @v_start_year
					   AND A.CALENDAR_YYYY  <= @v_end_year
					   GROUP BY A.CALENDAR_YYYY
					) AS A
			ORDER BY SORT_ORDER_NO;
		END

		--IF OBJECT_ID('TEMPDB..##TMP_SCP0049_LAST2') IS NOT NULL
		--	DROP TABLE ##TMP_SCP0049_LAST2;

		SET @MEXEC = '';

		SET @MEXEC = @MEXEC+' ;WITH    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		CTE_SCP0049_ALL_LINE2 AS ( ' + CHAR(10);
	    SET @MEXEC = @MEXEC+'SELECT T1.DIVISION_ID					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.COMPANY_ID				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.SITE_ID					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ST.SITE_NAME					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.PLANT_ID					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.FACTORY_ID				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ST.FACTORY_NAME				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LINE_ID					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ST.LINE_NAME					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.ELECTRODE_TYPE			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ST.OPERATION_GROUP_NAME		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.OPERATION_ID				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ST.OPERATION_NAME			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LOSS_CODE					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.ITEM_ID					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.NICK_NAME					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LANE_QTY					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.ITEM_VALUE				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYYMMDD					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYYMM					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYY						  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M6					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M5					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M4					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M3					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M2					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M1					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M6_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M5_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M4_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M3_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M2_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M1_RESULT				  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_BEST					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_WORST					  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_BEST_RESULT			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_WORST_RESULT			  ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'	  INTO #TMP_SCP0049_ALL_LINE2		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  FROM #TMP_SCP0049_ALL T1			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) ' + CHAR(10);-- LINE 정보
		SET @MEXEC = @MEXEC+'		ON T1.COMPANY_ID		= ST.COMPANY_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.DIVISION_ID		= ST.DIVISION_ID	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.SITE_ID			= ST.SITE_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.PLANT_ID			= ST.PLANT_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.FACTORY_ID		= ST.FACTORY_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.OPERATION_ID		= ST.OPERATION_ID	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.LINE_ID			= ST.LINE_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE	  ' + CHAR(10);

		SET @MEXEC = @MEXEC+'	  LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) ' + CHAR(10); -- LINE 정보
		SET @MEXEC = @MEXEC+'		ON T1.COMPANY_ID		= SI.COMPANY_ID			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.DIVISION_ID		= SI.DIVISION_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.SITE_ID			= SI.SITE_ID			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.PLANT_ID			= SI.PLANT_ID			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.FACTORY_ID		= SI.FACTORY_ID			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.OPERATION_ID		= SI.OPERATION_ID		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.LINE_ID			= SI.LINE_ID			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE		  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.ITEM_ID 			= SI.ITEM_ID			  ' + CHAR(10);
		-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'	  LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  ON	T1.COMPANY_ID	= SIM.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  AND	T1.DIVISION_ID	= SIM.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  AND	T1.SITE_ID		= SIM.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  AND	T1.ITEM_ID		= SIM.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 WHERE T1.LOSS_CODE <> ''LA003''   	' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 AND	ISNULL(SIM.ACTIVE_FLAG, ''Y'')  <> ''N''' + CHAR(10);-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'														  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 UNION ALL											  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'														  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 SELECT T1.DIVISION_ID								  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.COMPANY_ID								  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.SITE_ID									  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.SITE_NAME									  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.PLANT_ID									  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.FACTORY_ID								  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.FACTORY_NAME								  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LINE_ID									  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.LINE_NAME									  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , ISNULL(T1.ELECTRODE_TYPE,''-'') AS ELECTRODE_TYPE ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.OPERATION_GROUP_NAME							 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.OPERATION_ID									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.OPERATION_NAME								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LOSS_CODE										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.ITEM_ID										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , SI.NICK_NAME										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.LANE_QTY										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.ITEM_VALUE									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYYMMDD										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYYMM										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.YYYY											 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M6										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M5										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M4										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M3										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M2										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M1										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M6_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M5_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M4_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M3_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M2_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_M1_RESULT									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_BEST										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_WORST										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_BEST_RESULT								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 , T1.BEF_WORST_RESULT								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  FROM #TMP_SCP0049_ALL T1								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'															 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	  LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) ' + CHAR(10); -- LINE 정보
		SET @MEXEC = @MEXEC+'		ON T1.COMPANY_ID		= SI.COMPANY_ID    ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.DIVISION_ID		= SI.DIVISION_ID   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.SITE_ID			= SI.SITE_ID	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.PLANT_ID			= SI.PLANT_ID	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.FACTORY_ID		= SI.FACTORY_ID	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.OPERATION_ID		= SI.OPERATION_ID  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.LINE_ID			= SI.LINE_ID	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	   AND T1.ITEM_ID 			= SI.ITEM_ID	   ' + CHAR(10);
		-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'	  LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)' + CHAR(10);
		SET @MEXEC = @MEXEC+'		ON	T1.COMPANY_ID		= SIM.COMPANY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'		AND	T1.DIVISION_ID		= SIM.DIVISION_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'		AND	T1.SITE_ID			= SIM.SITE_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'		AND	T1.ITEM_ID			= SIM.ITEM_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 WHERE T1.LOSS_CODE = ''LA003''   -- YIELD	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'	 AND   ISNULL(SIM.ACTIVE_FLAG, ''Y'')  <> ''N''' + CHAR(10);-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		SET @MEXEC = @MEXEC+'		)' + CHAR(10);						
		SET @MEXEC = @MEXEC+'		, CTE_SCP0049_RESULT2 AS (   ' + CHAR(10);
		SET @MEXEC = @MEXEC+' SELECT RL.DIVISION_ID							   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.COMPANY_ID					   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.SITE_ID						   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.SITE_NAME						   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.PLANT_ID						   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.FACTORY_ID					   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.FACTORY_NAME					   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.LINE_ID						   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.LINE_NAME						   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.ELECTRODE_TYPE				   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.OPERATION_GROUP_NAME			   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.OPERATION_ID					   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.OPERATION_NAME				   ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'			 --, LK.CATEGORY_ID ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'			 --, CASE WHEN RL.LOSS_CODE IN (''LA001'',''LA002'',''LA003'') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN RL.LOSS_CODE = ''LA999'' THEN ''DAILY CAPA'' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN RL.LOSS_CODE IN (''LA001'',''LA002'',''LA003'',''LA999'') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.LOSS_CODE ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.ITEM_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.LANE_QTY ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , ISNULL(M.DEPARTMENT, CASE WHEN RL.SITE_ID = ''A001'' THEN C.DEPT_NAME_KO ' + CHAR(10);
		SET @MEXEC = @MEXEC+'										 WHEN RL.SITE_ID = ''A002'' THEN C.DEPT_NAME_CN ' + CHAR(10);
		SET @MEXEC = @MEXEC+'									ELSE DEPT_NAME_EN	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							END) AS DEPARTMENT ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_1									AS USER_ID_1	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , C.USER_NAME									AS MANAGER		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_2									AS USER_ID_2	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_3									AS USER_ID_3	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_4									AS USER_ID_4	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_5									AS USER_ID_5	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_6									AS USER_ID_6	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_7									AS USER_ID_7	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_8									AS USER_ID_8	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_9									AS USER_ID_9	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.USER_ID_10									AS USER_ID_10	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , M.CONFIRM_FLAG												 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , ''D_'' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , ''M_'' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM			 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , ''Y_'' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY			 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.ITEM_VALUE												 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M6) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M6)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M6) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M6)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M6																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M5) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M5)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M5) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M5)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M5																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M4) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M4)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M4) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M4)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M4																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'																										  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M3) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M3)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M3) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M3)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M3																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M2) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M2)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M2) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M2)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M2																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M1) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M1)	  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M1) ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M1)  												  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M1																			  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M6_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M6_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M6_RESULT																					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M5_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M5_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M5_RESULT																					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M4_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M4_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M4_RESULT																					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M3_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M3_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M3_RESULT																					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M2_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M2_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M2_RESULT																					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN LK.DATA_TABLE = ''SCM_WORK_CALENDAR_M''	THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.DATA_TABLE = ''SCM_LOSS_M''			THEN CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 		 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.LOSS_CODE  IN (''XA001'',''LA002'')		THEN CONVERT(numeric(10,1),RL.BEF_M1_RESULT) 	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					ELSE CONVERT(numeric(10,2),RL.BEF_M1_RESULT) 													 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			   END AS BEF_M1_RESULT																					 ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'			   ----------------------------------------- ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.BEF_BEST' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.BEF_WORST' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.BEF_BEST_RESULT' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , RL.BEF_WORST_RESULT' + CHAR(10);
		--SET @MEXEC = @MEXEC+'			-----------------------------------------' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , SORT_ORDER' + CHAR(10);
		SET @MEXEC = @MEXEC+'			 , CASE WHEN RL.LOSS_CODE = ''LA999'' THEN ''EA''' + CHAR(10);
		SET @MEXEC = @MEXEC+'					WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = ''TACT TIME'' THEN LK.UOM ELSE ''EA'' END AS UOM' + CHAR(10);
		--SET @MEXEC = @MEXEC+'		  INTO #TMP_SCP0049_RESULT2												 ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'		  FROM #TMP_SCP0049_ALL_LINE2 RL										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		  FROM CTE_SCP0049_ALL_LINE2 RL										 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		  LEFT JOIN (SELECT   LU.*												 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							, LV.SEGMENT2 		AS PLANT_ID						 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							, LV.SEGMENT3 		AS OPERATION_ID					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'							, LV.ATTRIBUTE1 	AS CATEGORY_2					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   FROM #TMP_SCP0049_LOOKUP LU								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV				 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'						 ON 	1=1												 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'						AND 	LV.LOOKUP_TYPE_CODE = ''CAPA_UI_CAPA_DEFINIT''	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'						AND 	LU.LOSS_CODE = LV.SEGMENT1						 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'						AND 	LV.ACTIVE_FLAG = ''Y'') LK  					 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ON RL.LOSS_CODE			= LK.LOSS_CODE								 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = ''LA002'' THEN LK.PLANT_ID ELSE RL.PLANT_ID END ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = ''LA002'' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'
		SET @MEXEC = @MEXEC+'		  LEFT JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK) ' + CHAR(10);--기준정보별 담당자 정보
		SET @MEXEC = @MEXEC+'			ON RL.COMPANY_ID		= M.COMPANY_ID		   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.DIVISION_ID		= M.DIVISION_ID		   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.SITE_ID			= M.SITE_ID			   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.PLANT_ID			= M.PLANT_ID		   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.FACTORY_ID		= M.FACTORY_ID		   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.OPERATION_ID		= M.OPERATION_ID	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.LINE_ID			= M.LINE_ID			   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND RL.ELECTRODE_TYPE	= M.ELECTRODE_TYPE	   ' + CHAR(10);
		--SET @MEXEC = @MEXEC+'		   --AND RL.LOSS_CODE			= M.LOSS_CODE	   ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   AND (CASE WHEN RL.LOSS_CODE = ''LA999'' THEN ''LA002'' ELSE RL.LOSS_CODE END)	= M.LOSS_CODE' + CHAR(10);

		SET @MEXEC = @MEXEC+'		  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN' + CHAR(10);
		SET @MEXEC = @MEXEC+'					  FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'						 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)	 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					 WHERE 1=1									 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					   AND A.DEPT_ID = B.DEPT_ID				 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'					) C											 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   ON 1 = 1												 ' + CHAR(10);
		SET @MEXEC = @MEXEC+'		  AND M.USER_ID_1 = C.USER_ID ' + CHAR(10);
		SET @MEXEC = @MEXEC+')' + CHAR(10);


		SET @MEXEC = @MEXEC+' SELECT	R2.* 													' + CHAR(10);
		
		SET @MEXEC = @MEXEC+' , CASE WHEN R2.CATEGORY_ID = N''DAILY CAPA'' THEN UM.ITEM_UOM  ' + CHAR(10);
		SET @MEXEC = @MEXEC+'			ELSE R2.UOM_TMP END AS UOM   ' + CHAR(10);
		SET @MEXEC = @MEXEC+' , ISNULL(UM.CELL_TYPE,''-'') AS CELL_TYPE ' + CHAR(10); -- CELL_TYPE 추가... 20230904
		
		SET @MEXEC = @MEXEC+'  FROM													' + CHAR(10);	

		SET @MEXEC = @MEXEC+' (	SELECT														' + CHAR(10);
		SET @MEXEC = @MEXEC+'			  R.DIVISION_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.COMPANY_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.SITE_ID											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.SITE_NAME										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.PLANT_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.FACTORY_ID 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.FACTORY_NAME  									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LINE_ID 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LINE_NAME 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.ELECTRODE_TYPE 									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_GROUP_NAME 							' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.OPERATION_NAME									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.CATEGORY_ID 									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.KEY_ID 											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.LOSS_CODE 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.ITEM_ID 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN  R.LOSS_CODE = ''LA001'' THEN CONVERT(NVARCHAR(10),R.LANE_QTY) ELSE ''-'' END AS LANE_QTY	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.DEPARTMENT										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_1										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_2										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_3										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_4										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_5										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_6										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_7										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_8										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_9										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.USER_ID_10										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.MANAGER											' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN CONFIRM_FLAG = ''Y'' THEN ''True'' ELSE ''False'' END AS CONFIRM_FLAG	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M6),0)				AS BEF_M6				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M5),0)				AS BEF_M5				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M4),0)				AS BEF_M4				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M3),0)				AS BEF_M3				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M2),0)				AS BEF_M2				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_M1),0)				AS BEF_M1				' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M6_RESULT))	END 	AS BEF_M6_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M5_RESULT))	END 	AS BEF_M5_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M4_RESULT))	END 	AS BEF_M4_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M3_RESULT))	END 	AS BEF_M3_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M2_RESULT))	END 	AS BEF_M2_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''					' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10),MAX(R.BEF_M1_RESULT))	END 	AS BEF_M1_RESULT		' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_BEST),0)	AS BEF_BEST																' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, ISNULL(MAX(R.BEF_WORST),0)			AS BEF_WORST												' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10), ISNULL(MAX(R.BEF_BEST_RESULT),0))		END		AS BEF_BEST_RESULT	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.LOSS_CODE IN (''LA001'',''LA002'',''LA999'' ) THEN ''-''								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				   ELSE CONVERT(NVARCHAR(10), ISNULL(MAX(R.BEF_WORST_RESULT),0))	END		AS BEF_WORST_RESULT	' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, R.UOM AS UOM_TMP										' + CHAR(10);		
			

	
		
		SET @MEXEC = @MEXEC+'			, LK.DATA_TABLE										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.CATEGORY_ORDER									' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, LK.SORT_ORDER										' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, RANK() OVER(PARTITION BY R.DIVISION_ID , R.COMPANY_ID , R.SITE_ID , R.PLANT_ID , R.FACTORY_ID	' + CHAR(10);
		SET @MEXEC = @MEXEC+'									, R.LINE_ID , R.ELECTRODE_TYPE, R.OPERATION_ID,R.LOSS_CODE				' + CHAR(10);
		SET @MEXEC = @MEXEC+'							ORDER BY R.ITEM_ID) AS ROW_RANKING												' + CHAR(10);
		SET @MEXEC = @MEXEC+'			, CASE WHEN R.ELECTRODE_TYPE =''-'' THEN ''ZZ'' ELSE R.ELECTRODE_TYPE END  AS ELECTRODE_ORDER	' + CHAR(10); --  YIELD 는 ELECTRODE_TYPE 이 없기 때문에 정열을 위한 컬럼
		SET @MEXEC = @MEXEC+'			' + @MQRY_SUM										  + CHAR(10);
		--SET @MEXEC = @MEXEC+'		 INTO ##TMP_SCP0049_LAST2								' + CHAR(10); -- 결과 테이블 저장
		--SET @MEXEC = @MEXEC+'		 FROM #TMP_SCP0049_RESULT2	R							' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 FROM CTE_SCP0049_RESULT2	R							' + CHAR(10);
		SET @MEXEC = @MEXEC+'		 JOIN #TMP_SCP0049_LOOKUP	LK							' + CHAR(10);
		SET @MEXEC = @MEXEC+'		   ON ( CASE WHEN R.LOSS_CODE = ''LA999'' THEN ''LA002'' ELSE R.LOSS_CODE END )	= LK.LOSS_CODE		' + CHAR(10);
		SET @MEXEC = @MEXEC+'		GROUP BY  R.DIVISION_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.COMPANY_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.SITE_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.SITE_NAME									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.PLANT_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.FACTORY_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.FACTORY_NAME								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LINE_ID										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LINE_NAME									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.ELECTRODE_TYPE								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_GROUP_NAME 						' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_ID								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.OPERATION_NAME								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.CATEGORY_ID									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.KEY_ID 										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LOSS_CODE 									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.ITEM_ID 									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.LANE_QTY 									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.DEPARTMENT									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.MANAGER										' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_1									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_2									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_3									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_4									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_5									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_6									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_7									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_8									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_9									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.USER_ID_10									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.CONFIRM_FLAG								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, R.UOM											' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.DATA_TABLE									' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.CATEGORY_ORDER								' + CHAR(10);
		SET @MEXEC = @MEXEC+'				, LK.SORT_ORDER									' + CHAR(10);
						
		SET @MEXEC = @MEXEC+'				) AS R2	' + CHAR(10);

		SET @MEXEC = @MEXEC+'		LEFT JOIN SCM_ITEM_M_SN UM WITH(NOLOCK)  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		ON      R2.COMPANY_ID		= UM.COMPANY_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.DIVISION_ID		= UM.DIVISION_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.SITE_ID			= UM.SITE_ID  ' + CHAR(10);
        SET @MEXEC = @MEXEC+'		AND R2.ITEM_ID			= UM.ITEM_ID ' + CHAR(10);


		-- [ 최소 행 크기가 내부 오버헤드 109바이트를 포함하여 13562이(가) ] 에러가 발생하여 화면에서 정열한다
		--SET @MEXEC = @MEXEC+'		ORDER BY  R.DIVISION_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.COMPANY_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.SITE_ID										' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.PLANT_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.FACTORY_ID									' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.LINE_ID										' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.OPERATION_ID	DESC						' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, R.ELECTRODE_TYPE								' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, LK.CATEGORY_ORDER								' + CHAR(10);
		--SET @MEXEC = @MEXEC+'				, LK.SORT_ORDER									' + CHAR(10);



		EXEC(@MEXEC);

		-- //////////////////////////////////////////////////////////////////////
		-- PROGRESS 조회
		-- 현재 조회된 건수는 화면에서 처리 한다
		WITH FP_LINE_MASTER_MANAGEMENT
		AS (
			SELECT A.DIVISION_ID , A.OPERATION_GROUP_ID
					, COUNT(1) AS CNT
					, SUM(CASE WHEN ISNULL(B.CONFIRM_FLAG, 'N') = 'N' THEN 0 ELSE 1 END ) AS CONFIRM_CNT
				FROM (
					SELECT DISTINCT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.LINE_ID, A.OPERATION_ID, A.ELECTRODE_TYPE
						, B.LOSS_CODE, B.CATEGORY, B.LOSS_NAME, LEFT(C.INSTANCE_TYPE,1) AS OPERATION_GROUP_ID
						FROM SCM_LINE_M_SN A
						, ( SELECT A.SEGMENT1 AS LOSS_CODE, A.ATTRIBUTE1 AS CATEGORY, A.ATTRIBUTE2 AS LOSS_NAME, A.SORT_ORDER
								FROM SCM_SYS_LOOKUP_VALUE_SN A
								WHERE 1=1
								AND A.LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
								AND A.ATTRIBUTE7 = 'Y'
							) B
						, FP_INSTANCE_OPERATION_V_SN C
					WHERE 	1=1
						AND A.ACTIVE_FLAG		= 'Y'
						AND A.COMPANY_ID		= C.COMPANY_ID
						AND A.DIVISION_ID		= C.DIVISION_ID
						AND A.SITE_ID			= C.SITE_ID
						AND A.OPERATION_ID	= C.OPERATION_ID
					) A
				LEFT OUTER JOIN SCM_MASTER_MANAGER_VER_H_SN B
				ON 	1=1
				AND B.VERSION_ID		= @p_version_id
				AND A.COMPANY_ID		= B.COMPANY_ID
				AND A.DIVISION_ID		= B.DIVISION_ID
				AND A.SITE_ID			= B.SITE_ID
				AND A.PLANT_ID			= B.PLANT_ID
				AND A.FACTORY_ID		= B.FACTORY_ID
				AND A.OPERATION_ID		= B.OPERATION_ID
				AND A.LINE_ID			= B.LINE_ID
				AND A.ELECTRODE_TYPE	= B.ELECTRODE_TYPE
				AND A.LOSS_CODE			= B.LOSS_CODE

				GROUP BY A.DIVISION_ID , A.OPERATION_GROUP_ID
		)
		SELECT CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, TOT_CONFIRM      ) / TOT_CNT       * 100,2)) + ' %' AS TOT_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, AUTO_CONFIRM     ) / AUTO_CNT      * 100,2)) + ' %' AS AUTO_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, SMALL_CONFIRM    ) / SMALL_CNT     * 100,2)) + ' %' AS SMALL_PROGRESS
				, CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, ELECTRODE_CONFIRM) / ELECTRODE_CNT * 100,2)) + ' %' AS ELECTRODE_PROGRESS
			FROM (
				SELECT SUM(CNT)																	AS TOT_CNT
					, SUM(CONFIRM_CNT)															AS TOT_CONFIRM
					, SUM (CASE WHEN DIVISION_ID IN ( '81','82') THEN CNT         ELSE 0 END ) AS AUTO_CNT
					, SUM (CASE WHEN DIVISION_ID IN ( '81','82') THEN CONFIRM_CNT ELSE 0 END ) AS AUTO_CONFIRM
					, SUM (CASE WHEN DIVISION_ID = '40'			 THEN CNT         ELSE 0 END ) AS SMALL_CNT
					, SUM (CASE WHEN DIVISION_ID = '40'			 THEN CONFIRM_CNT ELSE 0 END ) AS SMALL_CONFIRM
					, SUM (CASE WHEN OPERATION_GROUP_ID = 'E'    THEN CNT         ELSE 0 END ) AS ELECTRODE_CNT
					, SUM (CASE WHEN OPERATION_GROUP_ID = 'E'    THEN CONFIRM_CNT ELSE 0 END ) AS ELECTRODE_CONFIRM
					FROM  FP_LINE_MASTER_MANAGEMENT
				) X


					;WITH CTE_SCP0049_ALL_LINE2 AS (
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
				 , T1.BEF_M6
				 , T1.BEF_M5
				 , T1.BEF_M4
				 , T1.BEF_M3
				 , T1.BEF_M2
				 , T1.BEF_M1
				 , T1.BEF_M6_RESULT
				 , T1.BEF_M5_RESULT
				 , T1.BEF_M4_RESULT
				 , T1.BEF_M3_RESULT
				 , T1.BEF_M2_RESULT
				 , T1.BEF_M1_RESULT
				 , T1.BEF_BEST
				 , T1.BEF_WORST
				 , T1.BEF_BEST_RESULT
				 , T1.BEF_WORST_RESULT
			  FROM #TMP_SCP0049_ALL T1
			  LEFT JOIN #TMP_SCP0049_STD	ST WITH(NOLOCK) -- LINE 정보
				ON T1.COMPANY_ID		= ST.COMPANY_ID
			   AND T1.DIVISION_ID		= ST.DIVISION_ID
			   AND T1.SITE_ID			= ST.SITE_ID
			   AND T1.PLANT_ID			= ST.PLANT_ID
			   AND T1.FACTORY_ID		= ST.FACTORY_ID
			   AND T1.OPERATION_ID		= ST.OPERATION_ID
			   AND T1.LINE_ID			= ST.LINE_ID
			   AND T1.ELECTRODE_TYPE	= ST.ELECTRODE_TYPE

			  LEFT JOIN #TMP_SCP0049_STD_ITEM_TACT SI WITH(NOLOCK) -- LINE 정보
				ON T1.COMPANY_ID		= SI.COMPANY_ID
			   AND T1.DIVISION_ID		= SI.DIVISION_ID
			   AND T1.SITE_ID			= SI.SITE_ID
			   AND T1.PLANT_ID			= SI.PLANT_ID
			   AND T1.FACTORY_ID		= SI.FACTORY_ID
			   AND T1.OPERATION_ID		= SI.OPERATION_ID
			   AND T1.LINE_ID			= SI.LINE_ID
			   AND T1.ELECTRODE_TYPE	= SI.ELECTRODE_TYPE
			   AND T1.ITEM_ID 			= SI.ITEM_ID
				-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
				LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
				ON	T1.COMPANY_ID	= SIM.COMPANY_ID
				AND	T1.DIVISION_ID	= SIM.DIVISION_ID
				AND	T1.SITE_ID		= SIM.SITE_ID
				AND	T1.ITEM_ID		= SIM.ITEM_ID
			 WHERE T1.LOSS_CODE <> 'LA003'   -- YIELD 제외
			 AND	ISNULL(SIM.ACTIVE_FLAG, 'Y')  <> 'N' -- 2023-06-14 단종된 ITEM 조회되지 않도록 수정

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
				 , T1.BEF_M6
				 , T1.BEF_M5
				 , T1.BEF_M4
				 , T1.BEF_M3
				 , T1.BEF_M2
				 , T1.BEF_M1
				 , T1.BEF_M6_RESULT
				 , T1.BEF_M5_RESULT
				 , T1.BEF_M4_RESULT
				 , T1.BEF_M3_RESULT
				 , T1.BEF_M2_RESULT
				 , T1.BEF_M1_RESULT
				 , T1.BEF_BEST
				 , T1.BEF_WORST
				 , T1.BEF_BEST_RESULT
				 , T1.BEF_WORST_RESULT
			  FROM #TMP_SCP0049_ALL T1

			  LEFT JOIN #TMP_SCP0049_STD_ITEM_YIELD SI WITH(NOLOCK) -- LINE 정보
				ON T1.COMPANY_ID		= SI.COMPANY_ID
			   AND T1.DIVISION_ID		= SI.DIVISION_ID
			   AND T1.SITE_ID			= SI.SITE_ID
			   AND T1.PLANT_ID			= SI.PLANT_ID
			   AND T1.FACTORY_ID		= SI.FACTORY_ID
			   AND T1.OPERATION_ID		= SI.OPERATION_ID
			   AND T1.LINE_ID			= SI.LINE_ID
			   AND T1.ITEM_ID 			= SI.ITEM_ID
			-- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
			LEFT OUTER JOIN SCM_ITEM_M_SN SIM WITH(NOLOCK)
			ON	T1.COMPANY_ID	= SIM.COMPANY_ID
			AND	T1.DIVISION_ID	= SIM.DIVISION_ID
			AND	T1.SITE_ID		= SIM.SITE_ID
			AND	T1.ITEM_ID		= SIM.ITEM_ID
			 WHERE T1.LOSS_CODE = 'LA003'   -- YIELD
			AND	  ISNULL(SIM.ACTIVE_FLAG, 'Y')  <> 'N' -- 2023-06-14 단종된 ITEM 조회되지 않도록 수정
		)
	     /*#TMP_SCP0049_RESULT2 -> CTE_SCP0049_RESULT2*/
		, CTE_SCP0049_RESULT2 AS (
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
					 --, LK.CATEGORY_ID
					 --, CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
					 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'DAILY CAPA' ELSE ISNULL(LK.CATEGORY_2, LK.CATEGORY_ID) END AS CATEGORY_ID
					 , CASE WHEN RL.LOSS_CODE IN ('LA001','LA002','LA003','LA999') THEN RL.NICK_NAME ELSE LK.KEY_ID END AS KEY_ID
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
					 , M.USER_ID_9									AS USER_ID_9
					 , M.USER_ID_10									AS USER_ID_10
					 , M.CONFIRM_FLAG
					 , 'D_' + CONVERT(NVARCHAR(8), RL.YYYYMMDD)	AS YYYYMMDD
					 , 'M_' + CONVERT(NVARCHAR(6), RL.YYYYMM)	AS YYYYMM
					 , 'Y_' + CONVERT(NVARCHAR(4), RL.YYYY)		AS YYYY
					 , RL.ITEM_VALUE
					  , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M6) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M6)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M6) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M6)  
					   END AS BEF_M6
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M5) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M5)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M5) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M5)  
					   END AS BEF_M5
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M4) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M4)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M4) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M4)  
					   END AS BEF_M4

					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M3) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M3)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M3) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M3)  
					   END AS BEF_M3
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M2) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M2)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M2) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M2)  
					   END AS BEF_M2
					 , CASE WHEN LK.DATA_TABLE = 'SCM_WORK_CALENDAR_M'	THEN CONVERT(numeric(10,1),RL.BEF_M1) 
							WHEN LK.DATA_TABLE = 'SCM_LOSS_M'			THEN CONVERT(numeric(10,2),RL.BEF_M1)
							WHEN LK.LOSS_CODE  IN ('XA001','LA002')		THEN CONVERT(numeric(10,1),RL.BEF_M1) 
							ELSE CONVERT(numeric(10,2),RL.BEF_M1)  
					   END AS BEF_M1
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
					   -----------------------------------------
					 , RL.BEF_BEST
					 , RL.BEF_WORST
					 , RL.BEF_BEST_RESULT
					 , RL.BEF_WORST_RESULT
					-----------------------------------------
					 , SORT_ORDER
				
					 , CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'EA'
					WHEN LK.CATEGORY_2 IS NULL OR LK.CATEGORY_2 = 'TACT TIME' THEN LK.UOM ELSE 'EA' END AS UOM
				

				  FROM /*SQL 수정*/
				       /*#TMP_SCP0049_ALL_LINE2 RL*/
				       CTE_SCP0049_ALL_LINE2 RL
				  LEFT JOIN (SELECT   LU.*
									, LV.SEGMENT2 		AS PLANT_ID
									, LV.SEGMENT3 		AS OPERATION_ID
									, LV.ATTRIBUTE1 	AS CATEGORY_2
							   FROM #TMP_SCP0049_LOOKUP LU
							   LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE_SN LV
								 ON 	1=1
								AND 	LV.LOOKUP_TYPE_CODE = 'CAPA_UI_CAPA_DEFINIT'
								AND 	LU.LOSS_CODE = LV.SEGMENT1
								AND 	LV.ACTIVE_FLAG = 'Y') LK    -- 공정별 CAPA 보완
					ON RL.LOSS_CODE			= LK.LOSS_CODE
				   AND RL.PLANT_ID 			= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.PLANT_ID ELSE RL.PLANT_ID END
				   AND RL.OPERATION_ID 		= CASE WHEN RL.LOSS_CODE = 'LA002' THEN LK.OPERATION_ID ELSE RL.OPERATION_ID END

				  LEFT JOIN SCM_MASTER_MANAGER_M_SN M WITH(NOLOCK) --기준정보별 담당자 정보
					ON RL.COMPANY_ID		= M.COMPANY_ID
				   AND RL.DIVISION_ID		= M.DIVISION_ID
				   AND RL.SITE_ID			= M.SITE_ID
				   AND RL.PLANT_ID			= M.PLANT_ID
				   AND RL.FACTORY_ID		= M.FACTORY_ID
				   AND RL.OPERATION_ID		= M.OPERATION_ID
				   AND RL.LINE_ID			= M.LINE_ID
				   AND RL.ELECTRODE_TYPE	= M.ELECTRODE_TYPE
				   --AND RL.LOSS_CODE			= M.LOSS_CODE
				   AND (CASE WHEN RL.LOSS_CODE = 'LA999' THEN 'LA002' ELSE RL.LOSS_CODE END)	= M.LOSS_CODE

				  LEFT JOIN (SELECT A.USER_NAME, A.USER_ID, A.DEPT_ID, B.DEPT_NAME_KO, B.DEPT_NAME_EN, B.DEPT_NAME_CN
							  FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK)
								 , SCM_MST_SSO_DEPT_INFO B WITH(NOLOCK)
							 WHERE 1=1
							   AND A.DEPT_ID = B.DEPT_ID
							) C
				   ON 1 = 1
				  AND M.USER_ID_1 = C.USER_ID
		)
		SELECT CONVERT(NVARCHAR,ROUND(CONVERT(FLOAT, SUM(CONFIRM_CNT)) / COUNT(1) * 100,2)) + ' %'  AS FILTER
		FROM ( SELECT DIVISION_ID ,COMPANY_ID , SITE_ID , PLANT_ID , FACTORY_ID 
				, LINE_ID , OPERATION_ID , ELECTRODE_TYPE , OPERATION_GROUP_NAME, LOSS_CODE 
				, MAX(case when isnull(confirm_flag,'N') = 'N' THEN 0  ELSE 1 END ) AS CONFIRM_CNT
			FROM CTE_SCP0049_RESULT2
			--#TMP_SCP0049_RESULT2
			WHERE LOSS_CODE NOT LIKE 'X%'
			AND LOSS_CODE <> 'M08'
			AND USER_ID_1 = @p_user_id
			GROUP BY DIVISION_ID
				, COMPANY_ID
				, SITE_ID
				, PLANT_ID
				, FACTORY_ID
				, LINE_ID
				, OPERATION_ID
				, ELECTRODE_TYPE
				, OPERATION_GROUP_NAME
				, LOSS_CODE
		) A

	END -- END OF VERSION_ID


END



/* ============================ 테이블 확인 ============================== */
-- 공통 LOOKUP 테이블
--SELECT * FROM #TMP_SCP0049_LOOKUP

-- 결과 테이블 
--SELECT * FROM ##TMP_SCP0049_LAST WHERE LOSS_CODE = 'LA001'
--SELECT * FROM ##TMP_SCP0049_LAST ORDER BY DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID, CATEGORY_ORDER, SORT_ORDER
