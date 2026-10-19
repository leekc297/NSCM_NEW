

/*
 * Program ID   : SCP0049_SAVE_NEW_VERSION
 * Description  : Master Data Management New Version 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020/08/25   khj79          [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 최초작성
 * 2021/01/14   khj79          [PJ20199555] VERSION 정보가 DIVISION ID 별 저장되도록 수정 , DIVISION_ID 가 'EE' 인 경우 전체 저장 그외 해당 DIV 만 저장
 * 2021/02/05   khj79          [PJ20199555] LOSS Available(%) , Loading(%) , Operating(%) , OEE(%) 계산 로직 추가
 * 2021/03/10   khj79          부동 소수점 오류 개선
 * 2021/10/07	khj79	       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - M11 => M12 로 변경
 * 2024/01/10   leejsthira2    [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청

DECLARE	@p_today_yyyymmdd nvarchar(8) = '20210118' 
		,@p_chk_bp nvarchar(1)= 'N',
		@p_chk_rp nvarchar(1) = 'N',
		@p_chk_scp nvarchar(1)= 'N',
		@p_version_division nvarchar(200)= '40,81',
		@p_version_name nvarchar(100)= 'TEST',
		@p_update_id nvarchar(100) = 'khj79'
 */

CREATE PROCEDURE [dbo].[SCP0049_SAVE_NEW_VERSION]
	 @p_today_yyyymmdd		NVARCHAR(8)
	,@p_chk_bp				NVARCHAR(1)
	,@p_chk_rp				NVARCHAR(1)
	,@p_chk_scp				NVARCHAR(1)
	,@p_version_division	NVARCHAR(50)
	,@p_version_name		NVARCHAR(100)
	,@p_update_id			NVARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	-- 부동 소수점 오류(0이나 NULL값을 무시한 연산을 수행) 
	SET ANSI_WARNINGS OFF
	SET ARITHIGNORE ON
	SET ARITHABORT OFF

	DECLARE @max_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = ','

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0049_SAVE_NEW_VERSION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_progress		NUMERIC(20,10);

	DECLARE @v_iso_yyyyww		NVARCHAR(6);
	DECLARE @v_start_month		NVARCHAR(6);
	DECLARE @v_end_month		NVARCHAR(6); -- LOSS Available(%) 등을 계산하기 위한 월
	
	DECLARE @v_max_version_id	NVARCHAR(15);
	DECLARE @v_new_version_id	NVARCHAR(15);

	DECLARE @v_division_id		NVARCHAR(10);

	SET @v_start_month = CONVERT(VARCHAR(6) , DATEADD(MM,-3 ,@p_today_yyyymmdd),112);

	SELECT @v_end_month = MAX(WORK_MONTH) 
	  FROM SCM_LOSS_M_SN WITH(NOLOCK) ;


	-- ////////////////////////////////////////// SUM 임시 테이블 //////////////////////////////////////////////////////
	BEGIN
		-- LOOKUP 정보 조회
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_LOOKUP') IS NOT NULL
			DROP TABLE #TMP_SCP0049_VER_LOOKUP;
		
		SELECT SEGMENT1		AS LOSS_CODE
			 , ATTRIBUTE1	AS CATEGORY_ID
			 , ATTRIBUTE2	AS KEY_ID
			 , ATTRIBUTE3	AS DATA_TABLE
			 , CONVERT(NUMERIC(20,10),ATTRIBUTE8) AS CATEGORY_ORDER
			 , ATTRIBUTE9	AS UOM
			 , SORT_ORDER
		 INTO #TMP_SCP0049_VER_LOOKUP
		 FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)
		WHERE 1=1
		  AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
		  AND ACTIVE_FLAG = 'Y'
		;

		-- 월별 날짜 저장
		-- 날짜별 시간을 곱한 값 ( 일수 * 1440) 
		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_DAY_OF_MONTH') IS NOT NULL
			DROP TABLE #TMP_SCP0049_VER_DAY_OF_MONTH;

		SELECT BASIS_YYYYMM AS YYYYMM 
			 , CONVERT(INT,MAX(CALENDAR_DAY))         AS WORKING_DAY
			 , CONVERT(INT,MAX(CALENDAR_DAY)) * 1440  AS WORKING_TIME
		  INTO #TMP_SCP0049_VER_DAY_OF_MONTH
		  FROM SCM_SYS_CALENDAR_M
		 WHERE BASIS_YYYYMM >= @v_start_month
		   AND BASIS_YYYYMM <= @v_end_month
		 GROUP BY BASIS_YYYYMM

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_MM') IS NOT NULL
			DROP TABLE #TMP_SCP0049_VER_MM;

		CREATE TABLE #TMP_SCP0049_VER_MM
		(
			  VERSION_ID		NVARCHAR(030)
			, DIVISION_ID		NVARCHAR(030)
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
			, YYYYMM			NVARCHAR(006)
			, ITEM_VALUE		NUMERIC(20,4)
		)

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD_SUM') IS NOT NULL
			DROP TABLE #TMP_SCP0049_VER_STD_SUM;

		CREATE TABLE #TMP_SCP0049_VER_STD_SUM
		( 
			  DIVISION_ID			NVARCHAR(030)
			, COMPANY_ID			NVARCHAR(030)
			, SITE_ID				NVARCHAR(030)
			, PLANT_ID				NVARCHAR(030)
			, FACTORY_ID			NVARCHAR(030)
			, LINE_ID				NVARCHAR(030)
			, ELECTRODE_TYPE		NVARCHAR(030)
			, OPERATION_ID			NVARCHAR(030)
			, LOSS_CODE				NVARCHAR(030)
			, YYYYMM				NVARCHAR(006)
			, NON_OPERATION_VALUE	NUMERIC(20,4)
			, NO_LOAD_VALUE			NUMERIC(20,4)
			, NO_RUN_NOT_PM_VALUE	NUMERIC(20,4)
			, NO_RUN_PM_VALUE		NUMERIC(20,4)
		)

		IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD_CAL') IS NOT NULL
			DROP TABLE #TMP_SCP0049_VER_STD_CAL;

		CREATE TABLE #TMP_SCP0049_VER_STD_CAL
		( 
			  DIVISION_ID			NVARCHAR(030)
			, COMPANY_ID			NVARCHAR(030)
			, SITE_ID				NVARCHAR(030)
			, PLANT_ID				NVARCHAR(030)
			, FACTORY_ID			NVARCHAR(030)
			, LINE_ID				NVARCHAR(030)
			, ELECTRODE_TYPE		NVARCHAR(030)
			, OPERATION_ID			NVARCHAR(030)
			, LOSS_CODE				NVARCHAR(030)
			, YYYYMM				NVARCHAR(006)
			, ITEM_VALUE			NUMERIC(20,4)
		)
	END -- LOSS LOSS Available(%) 을 위한 임시테이블 생성

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY
		BEGIN
			-- /////////////////////////////////////////////////////////////////
			-- VERSION_ID 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				-- 현재일 기준 생성주차 확인
				SELECT @v_iso_yyyyww = ISO_YYYYWW 
					FROM SCM_SYS_CALENDAR_M 
					WHERE BASIS_YYYYMMDD = @p_today_yyyymmdd;

				-- 생성주차 일련번호 확인
				SELECT @v_max_version_id = ISNULL(SUBSTRING(MAX(VERSION_ID) , 8,3) , '')
					FROM SCM_MASTER_VERSION_INFO_H_SN 
					--WHERE SUBSTRING(VERSION_ID , 1, 6) = @p_iso_yyyyww;
					WHERE SUBSTRING(VERSION_ID , 1, 6) = @v_iso_yyyyww;;


					IF @v_max_version_id = ''
						BEGIN
						-- 생성주차에 일련번호 없으면 신규 생성
						SET @v_new_version_id = @v_iso_yyyyww  + '_001' ;
						END
					ELSE
						BEGIN
						-- 생성주차에 일련번호 있으면 일련번호 + 1
						DECLARE @p_seq_num		INT			= CONVERT(INT , @v_max_version_id) + 1 ;
						DECLARE @p_seq_num_txt	NVARCHAR(3) = RIGHT('000' + CAST(@p_seq_num AS NVARCHAR), 3 ) ;
						SET @v_new_version_id = @v_iso_yyyyww + '_' + @p_seq_num_txt;
					END
			END

			-- /////////////////////////////////////////////////////////////////
			-- PROGRESS 정보 설정
			-- /////////////////////////////////////////////////////////////////
			BEGIN
					SELECT @v_progress = ROUND(
											CONVERT(float, COUNT(CASE WHEN A.CONFIRM_FLAG = 'Y' THEN 1 END)) /COUNT(*) * 100
											,2)
					FROM SCM_MASTER_MANAGER_M_SN A	
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_MASTER_VERSION_INFO_H_SN 기준 버전 정보 생성
			-- DIVISION ID 별 저장
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_version_division, @v_delimiter);

				WHILE @mst_loop_cnt < @max_loop_cnt
				BEGIN
					SET @mst_loop_cnt = @mst_loop_cnt + 1

					SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_version_division , @v_delimiter , @mst_loop_cnt) ;

					INSERT INTO SCM_MASTER_VERSION_INFO_H_SN
					(
							VERSION_ID	, VERSION_NAME		, DIVISION_ID		, SCP_USE_FLAG		, BP_USE_FLAG
						, RP_USE_FLAG	, SYSTEM1_USE_FLAG	, SYSTEM2_USE_FLAG	, SYSTEM3_USE_FLAG	, PROGRESS
						, DESCRIPTION
						, INSERT_ID		, INSERT_TIME
					)
					VALUES
					(
						  @v_new_version_id , @p_version_name	, @v_division_id	, @p_chk_scp, @p_chk_bp
						, @p_chk_rp			, null				, null				,  null		, @v_progress
						, null
						, @p_update_id, SYSDATETIME()
					)
				END
			END

			-- /////////////////////////////////////////////////////////////////
			-- 기준 데이터 생성
			-- 전극 포함이면 전체 DIVISION 저장 , 그외 해당 DIVISION 만 저장 한다
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD') IS NOT NULL
					DROP TABLE #TMP_SCP0049_VER_STD;

				SELECT DISTINCT
					   DIVISION_ID
					 , COMPANY_ID
					 , SITE_ID
					 , PLANT_ID
					 , OPERATION_GROUP_ID
					 , FACTORY_ID
					 , OPERATION_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
				  INTO #TMP_SCP0049_VER_STD 
				  FROM SCM_LINE_HIERARCHY_V_SN A
				 WHERE ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- 기준 ITEM 데이터 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD_ITEM') IS NOT NULL
					DROP TABLE #TMP_SCP0049_VER_STD_ITEM;

				SELECT DISTINCT
					   A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.OPERATION_GROUP_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , B.ITEM_ID
					 , B.LANE_QTY
				  INTO #TMP_SCP0049_VER_STD_ITEM
				  FROM #TMP_SCP0049_VER_STD A
				  JOIN SCM_MST_ITEM_LINE_ASSIGN_SN B
					ON 1 = 1
				   AND A.DIVISION_ID 	= B.DIVISION_ID
				   AND A.SITE_ID 		= B.SITE_ID
				   AND A.PLANT_ID 		= B.PLANT_ID
				   AND A.FACTORY_ID 	= B.FACTORY_ID
				   AND A.LINE_ID 		= B.LINE_ID
				   AND A.OPERATION_ID 	= B.OPERATION_ID
				   AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				   AND B.MONTH 			>= @v_start_month
				   AND B.PRIORITY NOT IN ('0','9')
				  LEFT OUTER JOIN SCM_ITEM_M_SN C
				    ON 1 = 1
				   AND B.COMPANY_ID 	= C.COMPANY_ID
				   AND B.DIVISION_ID 	= C.DIVISION_ID
				   AND B.SITE_ID 		= C.SITE_ID
				   AND B.ITEM_ID 		= C.ITEM_ID
				   AND C.ACTIVE_FLAG 	= 'Y'
			END

			-- /////////////////////////////////////////////////////////////////
			-- 기준 ITEM 데이터 생성(TACT TIME)
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD_ITEM_TACT') IS NOT NULL
					DROP TABLE #TMP_SCP0049_VER_STD_ITEM_TACT;

				SELECT DISTINCT
					   A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.OPERATION_GROUP_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ELECTRODE_TYPE
					 , A.ITEM_ID
				  INTO #TMP_SCP0049_VER_STD_ITEM_TACT
				  FROM #TMP_SCP0049_VER_STD_ITEM A
			END

			-- /////////////////////////////////////////////////////////////////
			-- 기준 ITEM 데이터 생성( YIELD)
			-- ELECTRODE TYPE 중복 생성되어 YIELD 용 임시 테이블 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				IF OBJECT_ID('TEMPDB..#TMP_SCP0049_VER_STD_ITEM_YIELD') IS NOT NULL
					DROP TABLE #TMP_SCP0049_VER_STD_ITEM_YIELD;

				SELECT DISTINCT
					   A.DIVISION_ID
					 , A.COMPANY_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.OPERATION_GROUP_ID
					 , A.FACTORY_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.ITEM_ID
				  INTO #TMP_SCP0049_VER_STD_ITEM_YIELD
				  FROM #TMP_SCP0049_VER_STD_ITEM A
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_WORK_CALENDAR_M 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_WORK_CAL_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID			, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, WORK_DATE	, LOSS_CODE
					, TIME_TERM		, INSERT_ID		, INSERT_TIME		, UPDATE_ID	, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE	, A.WORK_DATE	, A.LOSS_CODE
					 , A.TIME_TERM
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID		, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_WORK_CALENDAR_M_SN A WITH(NOLOCK)
				INNER JOIN SCM_LINE_M_SN B WITH(NOLOCK)
				ON     1=1
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.PLANT_ID       = B.PLANT_ID
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				WHERE  CONVERT(NVARCHAR(6) , A.WORK_DATE , 112) >= @v_start_month
				AND    B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
				AND  ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_LOSS_M_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_LOSS_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, WORK_MONTH, LOSS_CODE
					, LOSS_RATE		, DESCRIPTION	
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID , A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE	, A.WORK_MONTH	, A.LOSS_CODE
					 , A.LOSS_RATE		, A.DESCRIPTION 
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID		, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_LOSS_M_SN A WITH(NOLOCK)
				INNER JOIN SCM_LINE_M_SN B WITH(NOLOCK)
				ON     1=1
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.PLANT_ID       = B.PLANT_ID
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				WHERE 1 = 1
				AND   A.WORK_MONTH >= @v_start_month
				AND   B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
				AND ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_MST_ITEM_LINE_ASSIGN_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_ITEM_LINE_ASSIGN_VER_H_SN
				(
					  COMPANY_ID		, DIVISION_ID	, SITE_ID		, PLANT_ID			, FACTORY_ID
					, ITEM_ID			, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE	, MONTH
					, LANE_QTY			, WORK_CENTER_ID, PRIORITY		, CERTIFICATION_DATE, ACTIVE_FLAG
					, DESCRIPTION
					, INSERT_ID			, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID		, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID		, A.SITE_ID	, A.PLANT_ID			, A.FACTORY_ID
					 , A.ITEM_ID		, A.OPERATION_ID	, A.LINE_ID	, A.ELECTRODE_TYPE		, A.MONTH
					 , A.LANE_QTY		, A.WORK_CENTER_ID	, A.PRIORITY, A.CERTIFICATION_DATE	, A.ACTIVE_FLAG
					 , A.DESCRIPTION
					 , A.INSERT_ID		, A.INSERT_TIME		, A.UPDATE_ID, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				  FROM SCM_MST_ITEM_LINE_ASSIGN_SN A WITH(NOLOCK)
				 WHERE A.MONTH >= @v_start_month
				   AND ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_LINE_ASSIGN_EXCT_VER_H_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_LINE_ASSIGN_EXCT_VER_H_SN
				(
					  COMPANY_ID, DIVISION_ID	, SITE_ID	, PLANT_ID		, FACTORY_ID
					, ITEM_ID	, OPERATION_ID	, LINE_ID	, ELECTRODE_TYPE, WORK_CENTER_ID
					, PRIORITY	, START_TIME	, END_TIME	, DESCRIPTION	, ACTIVE_FLAG
					, LANE_QTY
					, INSERT_ID	, INSERT_TIME , UPDATE_ID, UPDATE_TIME
					, VERSION_ID, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID	, A.PLANT_ID		, A.FACTORY_ID
					 , A.ITEM_ID		, A.OPERATION_ID, A.LINE_ID	, A.ELECTRODE_TYPE	, A.WORK_CENTER_ID
					 , A.PRIORITY		, A.START_TIME	, A.END_TIME, A.DESCRIPTION		, A.ACTIVE_FLAG
					 , A.LANE_QTY 
					 , A.INSERT_ID		, A.INSERT_TIME , A.UPDATE_ID, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				  FROM SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN A WITH(NOLOCK)
				 WHERE CONVERT(NVARCHAR(6) , A.START_TIME , 112) >= @v_start_month
				   AND ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_TACT_TIME_VER_H 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_TACT_TIME_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, ITEM_ID		, MONTH
					, WORK_CENTER_ID, TACT_TIME		, TACT_TIME_UOM	, DAILY_CAPA	, DESCRIPTION
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE	, A.ITEM_ID		, A.MONTH
					 , A.WORK_CENTER_ID	, A.TACT_TIME	, A.TACT_TIME_UOM	, A.DAILY_CAPA	, A.DESCRIPTION 
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID		, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_MST_TACT_TIME_SN A WITH(NOLOCK)
				INNER JOIN SCM_LINE_M_SN B WITH(NOLOCK)
				ON     1=1
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.PLANT_ID       = B.PLANT_ID
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				WHERE  A.MONTH >= @v_start_month
				AND    B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
				AND  ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_TACT_TIME_EXCT_VER_H_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_TACT_TIME_EXCT_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, ITEM_ID	, WORK_CENTER_ID
					, TACT_TIME		, TACT_TIME_UOM	, DAILY_CAPA	, START_TIME, END_TIME
					, ACTIVE_FLAG	, DESCRIPTION
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID		, A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID			, A.ELECTRODE_TYPE	, A.ITEM_ID		, A.WORK_CENTER_ID
					 , A.TACT_TIME		, A.TACT_TIME_UOM	, A.DAILY_CAPA		, A.START_TIME	, A.END_TIME
					 , A.ACTIVE_FLAG	, A.DESCRIPTION
					 , A.INSERT_ID		, A.INSERT_TIME		, A.UPDATE_ID		, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_MST_TACT_TIME_EXCEPT_SN A WITH(NOLOCK)
				INNER JOIN SCM_LINE_M_SN B WITH(NOLOCK)
				ON     1=1
				AND    A.COMPANY_ID     = B.COMPANY_ID
				AND    A.DIVISION_ID    = B.DIVISION_ID
				AND    A.SITE_ID        = B.SITE_ID
				AND    A.PLANT_ID       = B.PLANT_ID
				AND    A.FACTORY_ID     = B.FACTORY_ID
				AND    A.OPERATION_ID   = B.OPERATION_ID
				AND    A.LINE_ID        = B.LINE_ID
				AND    A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
				WHERE  CONVERT(NVARCHAR(6) , A.START_TIME , 112) >= @v_start_month
				AND    B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
				AND ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_YIELD_VER_H_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_YIELD_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID, PLANT_ID	, FACTORY_ID
					, OPERATION_ID	, LINE_ID		, ITEM_ID, MONTH	, WORK_CENTER_ID
					, YIELD			, DESCRIPTION
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID		, A.PLANT_ID	, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ITEM_ID		, A.MONTH		, A.WORK_CENTER_ID
					 , A.YIELD			, A.DESCRIPTION
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID	, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_MST_YIELD_SN A WITH(NOLOCK)
				INNER JOIN (
					SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID
					FROM   SCM_LINE_M_SN B WITH(NOLOCK)
					WHERE  B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
					GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID
				) B
				ON     1=1
				AND    A.COMPANY_ID   = B.COMPANY_ID
				AND    A.DIVISION_ID  = B.DIVISION_ID
				AND    A.SITE_ID      = B.SITE_ID
				AND    A.PLANT_ID     = B.PLANT_ID
				AND    A.FACTORY_ID   = B.FACTORY_ID
				AND    A.OPERATION_ID = B.OPERATION_ID
				AND    A.LINE_ID      = B.LINE_ID
				WHERE A.MONTH >= @v_start_month
				AND  ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_YIELD_EXCT_VER_H_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_YIELD_EXCT_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID		, FACTORY_ID 
					, OPERATION_ID	, LINE_ID		, ITEM_ID		, WORK_CENTER_ID, YIELD
					, START_TIME	, END_TIME		, ACTIVE_FLAG	, DESCRIPTION
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID		, A.PLANT_ID		, A.FACTORY_ID
					 , A.OPERATION_ID	, A.LINE_ID		, A.ITEM_ID		, A.WORK_CENTER_ID	, A.YIELD
					 , A.START_TIME		, A.END_TIME	, A.ACTIVE_FLAG , A.DESCRIPTION 
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID	, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				FROM SCM_MST_YIELD_EXCEPT_SN A WITH(NOLOCK)
				INNER JOIN (
					SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID
					FROM   SCM_LINE_M_SN B WITH(NOLOCK)
					WHERE  B.ACTIVE_FLAG = 'Y' -- [ES20240109-00456] 비활성화 라인 정보 생성 수정 요청
					GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID, B.OPERATION_ID, B.LINE_ID
				) B
				ON     1=1
				AND    A.COMPANY_ID   = B.COMPANY_ID
				AND    A.DIVISION_ID  = B.DIVISION_ID
				AND    A.SITE_ID      = B.SITE_ID
				AND    A.PLANT_ID     = B.PLANT_ID
				AND    A.FACTORY_ID   = B.FACTORY_ID
				AND    A.OPERATION_ID = B.OPERATION_ID
				AND    A.LINE_ID      = B.LINE_ID
				WHERE CONVERT(NVARCHAR(6) , A.START_TIME , 112) >= @v_start_month
				AND   ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR A.DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			-- SCM_MASTER_MANAGER_VER_H_SN 정보 생성
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO SCM_MASTER_MANAGER_VER_H_SN
				(
					  COMPANY_ID	, DIVISION_ID	, SITE_ID		, PLANT_ID	, FACTORY_ID 
					, OPERATION_ID	, LINE_ID		, ELECTRODE_TYPE, LOSS_CODE	, USER_ID_1
					, USER_ID_2		, USER_ID_3		, USER_ID_4		, USER_ID_5
					, USER_ID_6		, USER_ID_7		, USER_ID_8		, USER_ID_9
					, USER_ID_10
					, DESCRIPTION	, CONFIRM_FLAG	, CONFIRM_ID	, CONFIRM_TIME
					, INSERT_ID		, INSERT_TIME	, UPDATE_ID		, UPDATE_TIME
					, VERSION_ID	, RELEASE_TIME
				)
				SELECT A.COMPANY_ID		, A.DIVISION_ID	, A.SITE_ID			, A.PLANT_ID	, A.FACTORY_ID 
					 , A.OPERATION_ID	, A.LINE_ID		, A.ELECTRODE_TYPE	, A.LOSS_CODE	, A.USER_ID_1
					 , A.USER_ID_2		, A.USER_ID_3	, A.USER_ID_4		, A.USER_ID_5
					 , A.USER_ID_6		, A.USER_ID_7	, A.USER_ID_8		, A.USER_ID_9
					 , A.USER_ID_10
					 , A.DESCRIPTION	, A.CONFIRM_FLAG, A.CONFIRM_ID		, A.CONFIRM_TIME
					 , A.INSERT_ID		, A.INSERT_TIME	, A.UPDATE_ID		, A.UPDATE_TIME
					 , @v_new_version_id, SYSDATETIME()
				  FROM SCM_MASTER_MANAGER_M_SN A WITH(NOLOCK)
				 WHERE ( CASE WHEN CHARINDEX('EE',@p_version_division) > 0 THEN 'Y' ELSE 'N' END = 'Y'
							OR DIVISION_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_version_division , ','))
						)
			END

			-- /////////////////////////////////////////////////////////////////
			--  LOSS 계산을 위한 월별 데이터 조회
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				INSERT INTO #TMP_SCP0049_VER_MM
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
					, YYYYMM
					, ITEM_VALUE
				)
				SELECT CM.DIVISION_ID
					 , CM.COMPANY_ID
					 , CM.SITE_ID
					 , CM.PLANT_ID
					 , CM.FACTORY_ID
					 , CM.LINE_ID
					 , CM.ELECTRODE_TYPE
					 , CM.OPERATION_ID
					 , CM.LOSS_CODE
					 , CONVERT(VARCHAR(6), CM.WORK_DATE,112)	AS YYYYMM
					 , SUM(CM.TIME_TERM)						AS ITEM_VALUE
				  FROM #TMP_SCP0049_VER_LOOKUP LU

				  JOIN SCM_WORK_CALENDAR_M_SN CM WITH(NOLOCK)
					ON CM.LOSS_CODE		= LU.LOSS_CODE

				  JOIN #TMP_SCP0049_VER_STD L WITH(NOLOCK)
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
					 , WORK_MONTH					AS YYYYMM
					 , ISNULL(ROUND(LOSS_RATE * 100 , 2),0)	AS ITEM_VALUE
				  FROM #TMP_SCP0049_VER_LOOKUP LU
				  JOIN SCM_LOSS_M_SN LM WITH(NOLOCK)
					ON LM.LOSS_CODE		= LU.LOSS_CODE

				  JOIN #TMP_SCP0049_VER_STD L WITH(NOLOCK)
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
			END -- // 현재(Current) LOSS

			-- /////////////////////////////////////////////////////////////////
			--  LOSS Available(%) , Loading(%) , Operating(%) , OEE(%) 계산 로직 추가
			-- /////////////////////////////////////////////////////////////////
			BEGIN
				-- ##############################################################
				-- 1. SUM 값 (NON OPERATION,NO_ROAD,NO_RUN_NOT_PM,NO_RUN_PM)
				-- ##############################################################
				BEGIN
					INSERT INTO #TMP_SCP0049_VER_STD_SUM
					(
						  DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, YYYYMM
						, NON_OPERATION_VALUE
						, NO_LOAD_VALUE
						, NO_RUN_NOT_PM_VALUE
						, NO_RUN_PM_VALUE
					)
					SELECT DIVISION_ID
						 , COMPANY_ID
						 , SITE_ID
						 , PLANT_ID
						 , FACTORY_ID
						 , LINE_ID
						 , ELECTRODE_TYPE
						 , OPERATION_ID
						 , YYYYMM
						 , SUM(CASE WHEN LK.CATEGORY_ID = 'Not-Available'				THEN T.ITEM_VALUE ELSE 0 END ) AS NON_OPERATION_VALUE
						 , SUM(CASE WHEN LK.CATEGORY_ID = 'No-Load'						THEN T.ITEM_VALUE ELSE 0 END ) AS NO_LOAD_VALUE
						 , SUM(CASE WHEN LK.CATEGORY_ID = 'No-Run' AND KEY_ID <> 'PM'	THEN T.ITEM_VALUE ELSE 0 END ) AS NO_RUN_NOT_PM_VALUE
						 , SUM(CASE WHEN LK.CATEGORY_ID = 'No-Run' AND KEY_ID =  'PM'	THEN T.ITEM_VALUE ELSE 0 END ) AS NO_RUN_PM_VALUE
					  FROM #TMP_SCP0049_VER_MM    T
					  JOIN #TMP_SCP0049_VER_LOOKUP LK
						ON T.LOSS_CODE = LK.LOSS_CODE
					   AND LK.LOSS_CODE NOT LIKE 'X%'
					 GROUP BY DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, OPERATION_ID, YYYYMM
				END

				-- ##############################################################
				-- 2. Available(%)
				-- ##############################################################
				BEGIN
					INSERT INTO #TMP_SCP0049_VER_STD_CAL
					(
						  DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, YYYYMM
						, ITEM_VALUE
						, LOSS_CODE
					)
					SELECT DIVISION_ID
						 , COMPANY_ID
						 , SITE_ID
						 , PLANT_ID
						 , FACTORY_ID
						 , LINE_ID
						 , ELECTRODE_TYPE
						 , OPERATION_ID
						 , T.YYYYMM
						 , (D.WORKING_TIME - T.NON_OPERATION_VALUE) /D.WORKING_TIME * 100  AS AVAILABLE
						 , 'XB021'
					  FROM #TMP_SCP0049_VER_STD_SUM T
					  JOIN #TMP_SCP0049_VER_DAY_OF_MONTH D
						ON T.YYYYMM = D.YYYYMM
				END
				-- ##############################################################
				-- 3. Loading(%)
				-- ##############################################################
				BEGIN
					INSERT INTO #TMP_SCP0049_VER_STD_CAL
					(
						  DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, YYYYMM
						, ITEM_VALUE
						, LOSS_CODE
					)
					SELECT DIVISION_ID
						 , COMPANY_ID
						 , SITE_ID
						 , PLANT_ID
						 , FACTORY_ID
						 , LINE_ID
						 , ELECTRODE_TYPE
						 , OPERATION_ID
						 , T.YYYYMM
						 , ( (D.WORKING_TIME - ( T.NON_OPERATION_VALUE + T.NO_LOAD_VALUE) ) / (D.WORKING_TIME - T.NON_OPERATION_VALUE ) ) * 100 AS LOADING
						 , 'XC042'
					  FROM #TMP_SCP0049_VER_STD_SUM T
					  JOIN #TMP_SCP0049_VER_DAY_OF_MONTH D
						ON T.YYYYMM = D.YYYYMM
				END
				-- ##############################################################
				-- 4. Operating(%)
				-- ##############################################################
				BEGIN
					INSERT INTO #TMP_SCP0049_VER_STD_CAL
					(
						  DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, YYYYMM
						, ITEM_VALUE
						, LOSS_CODE
					)
					SELECT T.DIVISION_ID
						 , T.COMPANY_ID
						 , T.SITE_ID
						 , T.PLANT_ID
						 , T.FACTORY_ID
						 , T.LINE_ID
						 , T.ELECTRODE_TYPE
						 , T.OPERATION_ID
						 , T.YYYYMM
						 , 100 - (T.NO_RUN_NOT_PM_VALUE + ( T.NO_RUN_PM_VALUE / ( D.WORKING_TIME - (T.NON_OPERATION_VALUE + T.NO_LOAD_VALUE) ) * 100) )  AS OPERATING
						 , 'M08'
					  FROM #TMP_SCP0049_VER_STD_SUM T
					  JOIN #TMP_SCP0049_VER_DAY_OF_MONTH D
						ON T.YYYYMM = D.YYYYMM
				END
				-- ##############################################################
				-- 5. OEE(%)
				-- ##############################################################
				BEGIN
					INSERT INTO #TMP_SCP0049_VER_STD_CAL
					(
						  DIVISION_ID
						, COMPANY_ID
						, SITE_ID
						, PLANT_ID
						, FACTORY_ID
						, LINE_ID
						, ELECTRODE_TYPE
						, OPERATION_ID
						, YYYYMM
						, ITEM_VALUE
						, LOSS_CODE
					)
					SELECT T.DIVISION_ID
						 , T.COMPANY_ID
						 , T.SITE_ID
						 , T.PLANT_ID
						 , T.FACTORY_ID
						 , T.LINE_ID
						 , T.ELECTRODE_TYPE
						 , T.OPERATION_ID
						 , T.YYYYMM
						 , ISNULL((EXP(SUM(LOG(X.ITEM_VALUE))) * ISNULL(T.ITEM_VALUE,1) ) /10000 , 0 ) AS OEE
						 , 'XD101'
					  FROM #TMP_SCP0049_VER_STD_CAL T

					  JOIN #TMP_SCP0049_VER_DAY_OF_MONTH D
						ON T.YYYYMM = D.YYYYMM

					  LEFT JOIN #TMP_SCP0049_VER_MM X
						ON T.DIVISION_ID	= X.DIVISION_ID
					   AND T.COMPANY_ID		= X.COMPANY_ID
					   AND T.SITE_ID		= X.SITE_ID
					   AND T.PLANT_ID		= X.PLANT_ID
					   AND T.FACTORY_ID		= X.FACTORY_ID
					   AND T.LINE_ID		= X.LINE_ID
					   AND T.ELECTRODE_TYPE	= X.ELECTRODE_TYPE
					   AND T.OPERATION_ID	= X.OPERATION_ID
					   AND T.YYYYMM			= X.YYYYMM
					   --AND X.LOSS_CODE		IN ( 'M10','M11')
					   AND X.LOSS_CODE		IN ( 'M10','M12')  -- M11 => M12 로 변경
					WHERE T.LOSS_CODE		= 'M08'
					GROUP BY T.DIVISION_ID, T.COMPANY_ID, T.SITE_ID, T.PLANT_ID	, T.FACTORY_ID, T.LINE_ID, T.ELECTRODE_TYPE, T.OPERATION_ID, T.YYYYMM , T.ITEM_VALUE
				END
			END

			-- ##############################################################
			-- 6. 데이터 저장
			-- ##############################################################
			BEGIN
				INSERT INTO SCM_LOSS_REPORT_VER_H_SN
				(
					   VERSION_ID
					 , DIVISION_ID
					 , COMPANY_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , OPERATION_ID
					 , WORK_MONTH
					 , LOSS_CODE
					 , LOSS_RATE
					 , INSERT_ID
					 , INSERT_TIME
					 , UPDATE_ID
					 , UPDATE_TIME
				)
				SELECT @v_new_version_id AS VERSION_ID
					 , DIVISION_ID
					 , COMPANY_ID
					 , SITE_ID
					 , PLANT_ID
					 , FACTORY_ID
					 , LINE_ID
					 , ELECTRODE_TYPE
					 , OPERATION_ID
					 , YYYYMM
					 , LOSS_CODE
					 , ITEM_VALUE
					 , @p_update_id
					 , SYSDATETIME()
					 , @p_update_id
					 , SYSDATETIME()
				  FROM #TMP_SCP0049_VER_STD_CAL
				 WHERE ITEM_VALUE IS NOT NULL
			END

		END

		
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code ;

	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END



