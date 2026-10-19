
/*
 * Program ID  : [DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL]
 * Description  : 고객수요증감분석 DETAIL 데이터 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 2023.06.14	   bswon		  []  고객수요증감분석 DETAIL 데이터 저장
 2023.10.14	   chutoc730	  []  당사 - 공급(NEW) - 공급 차질(NEW)_Supply Issue
 2023.11.09    kcw3408        [개발요청] 수요분석시스템_12_End Customer 단위 세분화 필요 (Sales site는 미포함)
 2024.01.10    kcw3408        PR_DM_ANL_MKT_PSI_DATA:고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송 배치 작업 신규로  I/F 테이블 INSERT 삭제함
 */
/*
 EXEC DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL
'81','A15BW7001','202308','3357','DP_INIT','CUSTOMER^CUSTOMER^CUSTOMER^COMPANY^COMPANY','DEMAND^DEMAND^DEMAND^OPERATION^OPERATION'
,'PRODUCT^SALES^INVENTORY^VPA^MODELMIX','1^2^3^4^5','100^36^-18^-180^0','3419','^^^^','','leetw85'

 EXEC DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL
'81','A15BW7001','202308','3357','DP_INIT','CUSTOMER^CUSTOMER^CUSTOMER^COMPANY^COMPANY','DEMAND^DEMAND^DEMAND^OPERATION^OPERATION'
,'PRODUCT^SALES^INVENTORY^VPA^MODELMIX','1^2^3^4^5','100^36^-18^-180^0','3419','^^^^','','leetw85'
 COMMIT

 exec DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL @p_division_id=N'81',@p_project_code=N'A22AI4001',@p_yyyymm=N'202310',@p_cust_fcst_m=N'270',
 @p_measure=N'DP_INIT',@p_qtycd1=N'COMPANY',@p_qtycd2=N'SUPPLY',@p_qtycd3=N'SUPPLYISSUE',@p_seq=N'1',@p_qty=N'15000',@p_mkt_fcst_m=N'0',
 @p_desc=N'eeeee',@p_input_limit=N'',@p_created_by=N'chutoc730'
 */
----------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL] @p_division_id NVARCHAR(MAX)
	,@p_project_code NVARCHAR(MAX)
	,@p_yyyymm NVARCHAR(MAX)
	,@p_cust_fcst_m NVARCHAR(MAX)
	,@p_measure NVARCHAR(MAX)
	,@p_qtycd1 NVARCHAR(MAX)
	,@p_qtycd2 NVARCHAR(MAX)
	,@p_qtycd3 NVARCHAR(MAX)
	,@p_seq NVARCHAR(MAX)
	,@p_qty NVARCHAR(MAX)
	,@p_mkt_fcst_m NVARCHAR(MAX)
	,@p_desc NVARCHAR(MAX)
	,@p_input_limit NVARCHAR(MAX)
	,@p_created_by NVARCHAR(MAX)
	,@p_end_customer NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	SET XACT_ABORT ON;

	DECLARE @v_DIVISION_ID NVARCHAR(MAX);
	DECLARE @v_END_CUSTOMER NVARCHAR(MAX);
	DECLARE @v_PROJECT_CODE NVARCHAR(MAX);
	DECLARE @v_YYYYMM NVARCHAR(MAX);
	DECLARE @v_CUST_FCST_M NVARCHAR(MAX);
	DECLARE @v_CUST_FCST_M_PRE NVARCHAR(MAX);
	DECLARE @v_MEASURE NVARCHAR(MAX);
	DECLARE @v_QTYCD1 NVARCHAR(MAX);
	DECLARE @v_QTYCD2 NVARCHAR(MAX);
	DECLARE @v_QTYCD3 NVARCHAR(MAX);
	DECLARE @v_SEQ NVARCHAR(MAX);
	DECLARE @v_QTY NVARCHAR(MAX);
	DECLARE @v_MKT_FCST_M NVARCHAR(MAX);
	DECLARE @v_DESC NVARCHAR(MAX);
	DECLARE @v_INPUT_LIMIT NVARCHAR(MAX);
	DECLARE @v_CREATED_BY NVARCHAR(MAX);
	DECLARE @v_CREATION_DATE NVARCHAR(MAX);
	DECLARE @v_LAST_UPDATED_BY NVARCHAR(MAX);
	DECLARE @v_LAST_UPDATE_DATE NVARCHAR(MAX);
	------------------------------------------------------------------------------------------------------환산자 추가
	DECLARE @v_ITEM_CLASS NVARCHAR(30)
	DECLARE @v_PACK_CNT INT = 0
	DECLARE @v_MODULE_CNT INT = 0
	DECLARE @v_CELL_CNT INT = 0
	DECLARE @v_CELL_PER_PACK NUMERIC(30, 10)
	DECLARE @v_CELL_PER_MODULE NUMERIC(30, 10)
	DECLARE @v_CELL_PER_CELL NUMERIC(30, 10)
	DECLARE @v_TRANSLATOR NUMERIC(30, 10) --환산자
	DECLARE @v_REP_ITEM_ID NVARCHAR(30) --대표환산자 ITEM_ID
	DECLARE @v_REP_TRANSLATOR NVARCHAR(30) --대표환산자
	DECLARE @v_CUST_FCST_M_CELL NUMERIC(30, 10)
	DECLARE @v_P_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_S_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_I_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_V_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_M_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_CP_VALUE_CELL NUMERIC(30, 10)
	DECLARE @v_MKT_FCST_M_CELL NUMERIC(30, 10)

	------------------------------------------------------------------------------------------------------환산자 추가
	SET @v_DIVISION_ID = NULL;
	SET @v_END_CUSTOMER = NULL;
	SET @v_PROJECT_CODE = NULL;
	SET @v_YYYYMM = NULL;
	SET @v_CUST_FCST_M = NULL;
	SET @v_CUST_FCST_M_PRE = NULL;
	SET @v_MEASURE = NULL;
	SET @v_QTYCD1 = NULL;
	SET @v_QTYCD2 = NULL;
	SET @v_QTYCD3 = NULL;
	SET @v_SEQ = NULL;
	SET @v_QTY = NULL;
	SET @v_MKT_FCST_M = NULL;
	SET @v_DESC = NULL;
	SET @v_INPUT_LIMIT = NULL;
	SET @v_CREATED_BY = NULL;
	SET @v_CREATION_DATE = NULL;
	SET @v_LAST_UPDATED_BY = NULL;
	SET @v_LAST_UPDATE_DATE = NULL;
	SET @v_ITEM_CLASS = NULL;
	SET @v_PACK_CNT = NULL;
	SET @v_MODULE_CNT = NULL;
	SET @v_CELL_CNT = NULL;
	SET @v_CELL_PER_PACK = NULL;
	SET @v_CELL_PER_MODULE = NULL;
	SET @v_CELL_PER_CELL = NULL;
	SET @v_TRANSLATOR = NULL;
	SET @v_CUST_FCST_M_CELL = NULL;
	SET @v_P_VALUE_CELL = NULL;
	SET @v_S_VALUE_CELL = NULL;
	SET @v_I_VALUE_CELL = NULL;
	SET @v_V_VALUE_CELL = NULL;
	SET @v_M_VALUE_CELL = NULL;
	SET @v_CP_VALUE_CELL = NULL;
	SET @v_MKT_FCST_M_CELL = NULL;

	DECLARE @v_0month_tuesday NVARCHAR(08);--당월의 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff	
	DECLARE @v_delimiter NVARCHAR(1);

	SET @v_delimiter = '^';

	DECLARE @max_loop_cnt INTEGER = 0;
	DECLARE @mst_loop_cnt INTEGER = 0;
	DECLARE @v_CNT INTEGER = 0;
	DECLARE @v_CNT_PRE INTEGER = 0;
	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL';
	DECLARE @v_log_type NVARCHAR(30);-- START/END/ERROR/...
	DECLARE @n_log_count INTEGER = 0;
	DECLARE @v_log_message NVARCHAR(1000);
	DECLARE @v_description NVARCHAR(500);
	DECLARE @d_event_date DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;

	-- 테이블중복제거
	IF OBJECT_ID(N'tempdb..#TMP_DM_ANL_MKT_PSI', N'U') IS NOT NULL
		DROP TABLE #TMP_DM_ANL_MKT_PSI
	IF OBJECT_ID(N'tempdb..#TMP_PROJECT_DEPT', N'U') IS NOT NULL
		DROP TABLE #TMP_PROJECT_DEPT

	-- 임시확인용테이블 중복제거
	IF OBJECT_ID(N'dbo.#TMP_DM_ANL_MKT_PSI', N'U') IS NOT NULL
		DROP TABLE #TMP_DM_ANL_MKT_PSI
	IF OBJECT_ID(N'dbo..#TMP_PROJECT_DEPT', N'U') IS NOT NULL
		DROP TABLE #TMP_PROJECT_DEPT


	CREATE TABLE #TMP_DM_ANL_MKT_PSI (
		DIVISION_ID NVARCHAR(MAX)
		,END_CUSTOMER NVARCHAR(MAX)
		,PROJECT_CODE NVARCHAR(MAX)
		,YYYYMM NVARCHAR(MAX)
		,CUST_FCST_M NVARCHAR(MAX)
		,MEASURE NVARCHAR(MAX)
		,P_VALUE NVARCHAR(MAX)
		,S_VALUE NVARCHAR(MAX)
		,I_VALUE NVARCHAR(MAX)
		,V_VALUE NVARCHAR(MAX)
		,M_VALUE NVARCHAR(MAX)
		,MKT_FCST_M NVARCHAR(MAX)
		,[DESC] NVARCHAR(MAX)
		,INPUT_LIMIT NVARCHAR(MAX)
		,CUST_FCST_M_CELL NVARCHAR(MAX)
		,P_VALUE_CELL NVARCHAR(MAX)
		,S_VALUE_CELL NVARCHAR(MAX)
		,I_VALUE_CELL NVARCHAR(MAX)
		,V_VALUE_CELL NVARCHAR(MAX)
		,M_VALUE_CELL NVARCHAR(MAX)
		,MKT_FCST_M_CELL NVARCHAR(MAX)
		,CREATED_BY NVARCHAR(MAX)
		,CREATION_DATE NVARCHAR(MAX)
		,LAST_UPDATED_BY NVARCHAR(MAX)
		,LAST_UPDATE_DATE NVARCHAR(MAX)
		,CP_VALUE NVARCHAR(MAX)
		,CP_VALUE_CELL NVARCHAR(MAX)
		,
		)

	CREATE TABLE #TMP_PROJECT_DEPT (
		 DIVISION_ID NVARCHAR(MAX)
		,PROJECT_CODE NVARCHAR(MAX)
		,PROJECT_NAME NVARCHAR(MAX)
		,DEPT_ID NVARCHAR(MAX)
		,DEPT_NAME_KO NVARCHAR(MAX)
		)

	-- 시작 LOG  (END)
	SET @v_log_message = NULL /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN SAVE_DM_ANL_MKT_PSI_DETAIL;

	BEGIN TRY
		IF @p_division_id = ''
			OR @p_division_id IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'DIVISION_ID 입력값을 확인하세요.'

			SET @v_description = N'필수 입력값을 확인하세요.'

			GOTO err_rtn
		END

		IF @p_end_customer = ''
			OR @p_end_customer IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'END_CUSTOMER 입력값을 확인하세요.'

			SET @v_description = N'End_Customer 입력값을 확인하세요.'

			GOTO err_rtn
		END		

		IF @p_project_code = ''
			OR @p_project_code IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'PROJECT_CODE 입력값을 확인하세요.'

			SET @v_description = N'Project 입력값을 확인하세요.'

			GOTO err_rtn
		END

		IF @p_yyyymm = ''
			OR @p_yyyymm IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'YYYYMM 입력값을 확인하세요.'

			SET @v_description = N'YYYYMM 입력값을 확인하세요.'

			GOTO err_rtn
		END

		IF @p_measure = ''
			OR @p_measure IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'MEASURE 입력값을 확인하세요.'

			SET @v_description = N'MEASURE 입력값을 확인하세요.'

			GOTO err_rtn
		END

		 
		IF @p_qtycd3 = ''
			OR @p_qtycd3 IS NULL
			OR LEN(@p_qtycd3) = 0
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'입력값을 확인하세요.'

			SET @v_description = N'입력값을 확인하세요.'

			GOTO err_rtn
		END
		 

		BEGIN
			DELETE
			FROM DM_ANL_MKT_PSI_DETAIL
			WHERE 1 = 1
				AND DIVISION_ID = @p_division_id
				AND END_CUSTOMER = @p_end_customer 
				AND PROJECT_CODE = @p_project_code
				AND YYYYMM = @p_yyyymm
				AND MEASURE = @p_measure
		END

		--BEGIN
		--	-- 테이블중복제거
		--	IF OBJECT_ID (N'tempdb..#TMP_PROJECT_CODE', N'U')			IS NOT NULL	DROP TABLE #TMP_PROJECT_CODE
		--	-- 임시확인용테이블 중복제거
		--	IF OBJECT_ID (N'dbo.#TMP_PROJECT_CODE', N'U')				IS NOT NULL	DROP TABLE #TMP_PROJECT_CODE
		--	SELECT * INTO #TMP_PROJECT_CODE
		--	FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = @p_division_id AND PROJECT_NAME = @V_project_name) A
		--END
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_qtycd3, @v_delimiter);

		PRINT CONVERT(NVARCHAR, @max_loop_cnt) + ' ' + '----------------------------------------------------------------------------------------------------------------------------------------------'

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------START
		BEGIN
			SELECT *
			INTO #TMP_DM_MST_ITEM_SINGLE_V
			FROM DM_MST_ITEM_SINGLE_V WITH (NOLOCK)
			WHERE DIVISION_ID = @p_division_id
				AND ITEM_ID IN (
					SELECT ITEM_ID
					FROM SCM_MST_PROJECT_ITEM
					WHERE PROJECT_CODE = @p_project_code
						AND VALID_YN = 'Y'
					)
				AND ITEM_TYPE = 'P'
		END

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')------------------------------END

		-- 환산자 추출 로직 ======================================================================START
		-- 테이블중복제거
		IF OBJECT_ID(N'tempdb..#TMP_ITEM_CLASS_IN_PROJECT', N'U') IS NOT NULL
			DROP TABLE TMP_ITEM_CLASS_IN_PROJECT

		-- 임시확인용테이블 중복제거
		IF OBJECT_ID(N'dbo.#TMP_ITEM_CLASS_IN_PROJECT', N'U') IS NOT NULL
			DROP TABLE TMP_ITEM_CLASS_IN_PROJECT
		
		PRINT SYSDATETIME();
		PRINT N'환산자 추출 START--------------------------------------------------------------------------------------------------------------------------------------'

		-- 신규 로직으로 변경
		--BEGIN
		--	-- 1.프로젝트에 있는 ITEM을 CLASS별로 추출하여 임시테이블(#TMP_ITEM_CLASS_IN_PROJECT)에 저장한다.
		--	SELECT ITEM_ID
		--		,CASE 
		--			WHEN CHARINDEX('Pack', ITEM_CLASS_NAME) > 0
		--				THEN 'PACK'
		--			WHEN CHARINDEX('Module', ITEM_CLASS_NAME) > 0
		--				THEN 'MODULE'
		--			WHEN CHARINDEX('Cell', ITEM_CLASS_NAME) > 0
		--				THEN 'CELL'
		--			ELSE ''
		--			END ITEM_CLASS
		--	INTO #TMP_ITEM_CLASS_IN_PROJECT
		--	FROM DM_MST_ITEM_SINGLE_V
		--	WHERE DIVISION_ID = '81'
		--		AND ITEM_ID IN (
		--			SELECT ITEM_ID
		--			FROM SCM_MST_PROJECT_ITEM
		--			WHERE PROJECT_CODE = @p_PROJECT_CODE
		--				AND VALID_YN = 'Y'
		--			)
		--		AND ITEM_TYPE = 'P'
		--		AND ACTIVE_FLAG = 'Y'

		--	--SELECT * FROM #TMP_ITEM_CLASS_IN_PROJECT
		--	-- 2. 임시테이블(#TMP_ITEM_CLASS_IN_PROJECT)에서 PACK, MODULE, CELL 별로 수량을 파악한다.
		--	SELECT @v_PACK_CNT = COUNT(1)
		--	FROM #TMP_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'PACK'
		--	GROUP BY ITEM_CLASS

		--	SELECT @v_MODULE_CNT = COUNT(1)
		--	FROM #TMP_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'MODULE'
		--	GROUP BY ITEM_CLASS

		--	SELECT @v_CELL_CNT = COUNT(1)
		--	FROM #TMP_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'CELL'
		--	GROUP BY ITEM_CLASS

		--	PRINT CONVERT(NVARCHAR, @v_PACK_CNT) + ' PACK'
		--	PRINT CONVERT(NVARCHAR, @v_MODULE_CNT) + ' MODULE'
		--	PRINT CONVERT(NVARCHAR, @v_CELL_CNT) + ' CELL'

		--	-- 3. 해당 프로젝트에서(#TMP_ITEM_CLASS_IN_PROJECT)
		--	IF @v_PACK_CNT > 0 -- PACK에 수량이 있으면 PACK 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_PACK'

		--		SELECT @v_CELL_PER_PACK = CELL_PER_CAR
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = @p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = @p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_CAR

		--		SET @v_TRANSLATOR = @v_CELL_PER_PACK;
		--		SET @v_REP_TRANSLATOR = 'PACK'
		--	END
		--	ELSE IF @v_PACK_CNT = 0
		--		AND @v_MODULE_CNT > 0 -- PACK에 수량이 없고 MODULE에 수량이 있으면 MODULE 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_MODULE'

		--		SELECT @v_CELL_PER_MODULE = CELL_PER_MODULE
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = @p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = @p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_MODULE

		--		SET @v_TRANSLATOR = @v_CELL_PER_MODULE;
		--		SET @v_REP_TRANSLATOR = 'MODULE'
		--	END
		--	ELSE IF @v_PACK_CNT = 0
		--		AND @v_MODULE_CNT = 0
		--		AND @v_CELL_CNT > 0 -- PACK, MODULE에 수량이 없고 CELL에 수량이 있으면 CELL 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_CELL'

		--		SELECT @v_CELL_PER_CELL = 1

		--		SET @v_TRANSLATOR = @v_CELL_PER_CELL;
		--		SET @v_REP_TRANSLATOR = 'CELL'
		--	END
		--END
		-- 신규 로직으로 변경

		SET @v_DIVISION_ID = @p_division_id
		SET @v_PROJECT_CODE = @p_project_code

		PRINT @v_DIVISION_ID
		PRINT @v_PROJECT_CODE

		BEGIN

			--SELECT AAAA.PROJECT_CODE, AAAA.ITEM_ID, AAAA.BIZ_TYPE FROM(
			SELECT @v_REP_ITEM_ID = AAAA.ITEM_ID, @v_REP_TRANSLATOR = AAAA.BIZ_TYPE FROM(
			SELECT AAA.PROJECT_CODE, AAA.ITEM_ID
			, CASE WHEN SUBSTRING(AAA.ITEM_ID, 1,2) = 'AP' THEN 'PACK' WHEN SUBSTRING(AAA.ITEM_ID, 1,2) = 'AM' THEN 'MODULE' WHEN SUBSTRING(AAA.ITEM_ID, 1,2) = 'AC' THEN 'CELL' END BIZ_TYPE
			,  ROW_NUMBER() OVER (PARTITION BY AAA.PROJECT_CODE ORDER BY AAA.PROJECT_CODE, SUBSTRING(AAA.ITEM_ID, 2,1) DESC) AS RNK FROM(
			SELECT AA.PROJECT_CODE, BB.ITEM_ID
			, CASE WHEN SUBSTRING(BB.ITEM_ID, 1,2) = 'AP' THEN 3 WHEN SUBSTRING(BB.ITEM_ID, 1,2) = 'AM' THEN 2 WHEN SUBSTRING(BB.ITEM_ID, 1,2) = 'AC' THEN 1 END RNK FROM
			(SELECT DISTINCT PROJECT_CODE FROM DM_ANL_MKT_PSI_DETAIL WHERE DIVISION_ID = @v_DIVISION_ID AND PROJECT_CODE = @v_PROJECT_CODE) AA INNER JOIN 
			(SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
			FROM SCM_MST_SITE_ITEM A INNER JOIN DM_MST_ITEM_SINGLE_V B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID 
			WHERE A.DIVISION_ID = @v_DIVISION_ID AND A.VALID_YN = 'Y' AND B.ITEM_TYPE = 'P') BB 
			ON AA.PROJECT_CODE = BB.PROJECT_CODE
			GROUP BY AA.PROJECT_CODE, BB.ITEM_ID
			) AAA 
			) AAAA WHERE AAAA.RNK = 1
			ORDER BY AAAA.PROJECT_CODE, AAAA.ITEM_ID

		END

		SELECT @v_TRANSLATOR = CELL_CF FROM SCP_MST_FINAL_ITEM WHERE ITEM_ID = @v_REP_ITEM_ID

		PRINT @v_TRANSLATOR

		PRINT N'환산자 추출 END--------------------------------------------------------------------------------------------------------------------------------------'

		PRINT SYSDATETIME();

		-- 환산자 추출 로직 ========================================================================END


		PRINT N'환산자'
		PRINT N'환산자 ' + @v_REP_TRANSLATOR + ' ' + CONVERT(NVARCHAR, @v_TRANSLATOR) 
		 

		WHILE LEN(@p_qtycd3) > 0
			AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_DIVISION_ID = @p_division_id;
				--SELECT @v_DIVISION_ID
				SET @v_END_CUSTOMER = @p_end_customer;
				--SELECT @v_END_CUSTOMER
				SET @v_PROJECT_CODE = @p_project_code;
				--SELECT @v_PROJECT_CODE
				SET @v_YYYYMM = @p_yyyymm;
				--SELECT @v_YYYYMM
				--SET @v_CUST_FCST_M = [dbo].[SCM_ARR_SPL_VAL](@p_qtycd1, @v_delimiter , 1);
				--SET @v_CUST_FCST_M_PRE = [dbo].[SCM_ARR_SPL_VAL](@p_qtycd1, @v_delimiter , 2);
				SET @v_CUST_FCST_M = @p_cust_fcst_m;
				--SELECT @v_CUST_FCST_M
				SET @v_MEASURE = @p_measure;
				--SELECT @v_MEASURE
				SET @v_QTYCD1 = [dbo].[SCM_ARR_SPL_VAL](@p_qtycd1, @v_delimiter, @mst_loop_cnt);
				--SELECT @v_QTYCD1
				SET @v_QTYCD2 = [dbo].[SCM_ARR_SPL_VAL](@p_qtycd2, @v_delimiter, @mst_loop_cnt);
				--SELECT @v_QTYCD2
				SET @v_QTYCD3 = [dbo].[SCM_ARR_SPL_VAL](@p_qtycd3, @v_delimiter, @mst_loop_cnt);
				--SELECT @v_QTYCD3
				SET @v_SEQ = [dbo].[SCM_ARR_SPL_VAL](@p_seq, @v_delimiter, @mst_loop_cnt);;
				--SELECT @v_SEQ
				SET @v_QTY = [dbo].[SCM_ARR_SPL_VAL](@p_qty, @v_delimiter, @mst_loop_cnt);
				--SELECT @v_QTY
				SET @v_MKT_FCST_M = @p_mkt_fcst_m;
				--SELECT @v_MKT_FCST_M
				SET @v_DESC = [dbo].[SCM_ARR_SPL_VAL](@p_desc, @v_delimiter, @mst_loop_cnt);
				--SELECT @v_DESC
				SET @v_INPUT_LIMIT = @p_input_limit;
				--SELECT @v_INPUT_LIMIT
				SET @v_CREATED_BY = @p_created_by;
				--SELECT @v_CREATED_BY
				SET @v_CREATION_DATE = SYSDATETIME();
				--SELECT @v_CREATION_DATE
				SET @v_LAST_UPDATED_BY = @p_created_by;
				--SELECT @v_LAST_UPDATED_BY
				SET @v_LAST_UPDATE_DATE = SYSDATETIME();
					--SELECT @v_LAST_UPDATE_DATE	
			END

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF @v_DIVISION_ID = ''
				OR @v_DIVISION_ID IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'DIVISION_ID 입력값을 확인하세요.'

				SET @v_description = N'필수 입력값을 확인하세요.'

				GOTO err_rtn
			END
			
		IF @v_END_CUSTOMER = ''
			OR @v_END_CUSTOMER IS NULL
		BEGIN
			SET @v_log_type = 'INVALID';

			SELECT N'END_CUSTOMER 입력값을 확인하세요.'

			SET @v_description = N'End_Customer 입력값을 확인하세요.'

			GOTO err_rtn
		END		

			IF @v_PROJECT_CODE = ''
				OR @v_PROJECT_CODE IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'PROJECT_CODE 입력값을 확인하세요.'

				SET @v_description = N'Div 입력값을 확인하세요.'

				GOTO err_rtn
			END

			IF @v_YYYYMM = ''
				OR @v_YYYYMM IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'YYYYMM 입력값을 확인하세요.'

				SET @v_description = N'YYYYMM 입력값을 확인하세요.'

				GOTO err_rtn
			END

			
	 
			/* =================================================
		   주석유지
		    =================================================*/
			/*
			IF @v_CUST_FCST_M = '' OR @v_CUST_FCST_M IS NULL
				BEGIN
					SET @v_log_type = 'INVALID';
					SELECT N'Sold-To 입력값을 확인하세요.'
					SET @v_description = N'Sold-To 입력값을 확인하세요.'
					goto err_rtn
				END
			*/
			/* =================================================*/
			--IF [dbo].[SCM_ARR_SPL_CNT](@p_cust_fcst_m, @v_delimiter) = 2
			--	BEGIN
			--		SET @v_CUST_FCST_M_PRE = [dbo].[SCM_ARR_SPL_VAL](@p_cust_fcst_m, @v_delimiter , 1);
			--		SET @v_CUST_FCST_M = [dbo].[SCM_ARR_SPL_VAL](@p_cust_fcst_m, @v_delimiter , 2);					
			--	END
			-- 테이블중복제거
			IF OBJECT_ID(N'tempdb..#TEMP_DM_MST_VERSION', N'U') IS NOT NULL
				DROP TABLE #TEMP_DM_MST_VERSION

			-- 임시확인용테이블 중복제거
			IF OBJECT_ID(N'dbo.#TEMP_DM_MST_VERSION', N'U') IS NOT NULL
				DROP TABLE #TEMP_DM_MST_VERSION

			CREATE TABLE #TEMP_DM_MST_VERSION (
				NUM INT --NULL
				,VERSION_NO NVARCHAR(100) --NULL
				,VERSION_TYPE NVARCHAR(100) --NULL
				);

			--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
			IF @v_MEASURE = 'DP_INIT'
				IF DATEPART(WEEKDAY, SUBSTRING(CONVERT(VARCHAR, @v_yyyymm, 112), 1, 6) + '01') = '4'
				BEGIN
					SET @v_0month_tuesday = CONVERT(CHAR(8), DATEADD(WW, - 1, DBO.FN_NEXT_DAY(CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR, @v_yyyymm, 112), 1, 6) + '01', 112), 'TUE')), 112)
				END
				ELSE
				BEGIN
					SET @v_0month_tuesday = CONVERT(NVARCHAR, DATEADD(WK, DATEDIFF(WK, 0, DATEADD(DD, 5 - DATEPART(DAY, @v_yyyymm + '01'), @v_yyyymm + '01')), 1), 112) --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff				
				END
			ELSE IF DATEPART(WEEKDAY, SUBSTRING(CONVERT(VARCHAR, @v_yyyymm, 112), 1, 6) + '01') = '4'
			BEGIN
				SET @v_0month_tuesday = CONVERT(CHAR(8), DATEADD(WW, - 1, DBO.FN_NEXT_DAY(DATEADD(MM, 1, CONVERT(VARCHAR, SUBSTRING(CONVERT(VARCHAR, @v_yyyymm, 112), 1, 6) + '01', 112)), 'TUE')), 112)
			END
			ELSE
			BEGIN
				SET @v_0month_tuesday = CONVERT(NVARCHAR, DATEADD(WK, DATEDIFF(WK, 0, DATEADD(DD, 5 - DATEPART(DAY, DATEADD(MM, 1, @v_yyyymm + '01')), DATEADD(MM, 1, @v_yyyymm + '01'))), 1), 112) --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			END

			BEGIN
				INSERT INTO #TEMP_DM_MST_VERSION (
					NUM
					,VERSION_NO
					,VERSION_TYPE
					)
				SELECT ROW_NUMBER() OVER (
						ORDER BY X.VERSION_NO
						) AS NUM
					,X.VERSION_NO
					,X.VERSION_TYPE
				FROM (
					SELECT ROW_NUMBER() OVER (
							PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
							) AS RNK
						,A.VERSION_NO
						,A.VERSION_TYPE
					FROM DM_MST_VERSION A WITH (NOLOCK)
					JOIN SCM_SYS_CALENDAR_M B WITH (NOLOCK) ON A.YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE 1 = 1
						AND A.DIVISION_ID = @p_division_id
						AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
						AND A.YYYYMMDD = @v_0month_tuesday
					) X
				WHERE RNK = 1
			END

			IF OBJECT_ID(N'tempdb..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_MST_SITE

			IF OBJECT_ID(N'dbo..#TEMP_SCM_MST_SITE', N'U') IS NOT NULL
				DROP TABLE #TEMP_SCM_MST_SITE

			
	    	--SCM_MST_SITE 대상건만 추출(end_customer)
		    BEGIN
			    SELECT DIVISION_ID
			         , SCM_SITE_ID
			    	 , END_CUSTOMER
		    	INTO #TEMP_SCM_MST_SITE
		    	FROM SCM_MST_SITE WITH (NOLOCK)
		    	WHERE DIVISION_ID  = @p_division_id
	              AND END_CUSTOMER = @p_end_customer 
	    	END 


			--IF @v_CUST_FCST_M_PRE = '' OR @v_CUST_FCST_M_PRE IS NULL OR @v_CUST_FCST_M_PRE = '0'
			--	BEGIN
			--		SELECT @v_CUST_FCST_M_PRE = (A_QTY + B_QTY)  
			--		FROM (  
			--					SELECT ISNULL(CEILING(SUM(QTY)), 0) AS A_QTY  
			--					FROM DM_PLN_MKT_FCST_C X WITH(NOLOCK)  
			--					JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO											
			--					WHERE 1=1   
			--					AND X.DIVISION_ID = @p_division_id								
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')  
			--					--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
			--					AND PROJECT_CODE = @p_project_code  
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTRING(YYYYMMDD, 1, 6) = @v_yyyymm
			--					AND QTY <> 0
			--					) A,  
			--					(  
			--					SELECT ISNULL(CEILING(SUM(QTY)), 0) AS B_QTY  
			--					FROM DM_PLN_MKT_FCST_RESULT_C X WITH(NOLOCK) 
			--					JOIN #TEMP_DM_MST_VERSION Y WITH(NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
			--					WHERE 1=1   
			--					AND X.DIVISION_ID = @p_division_id  
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')  
			--					--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
			--					AND PROJECT_CODE = @p_project_code  
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTRING(YYYYMMDD, 1, 6) = @v_yyyymm						        
			--					) B  
			--	END		
			IF @v_CUST_FCST_M = ''
				OR @v_CUST_FCST_M IS NULL
				OR @v_CUST_FCST_M = '0'
			BEGIN
				IF @v_MEASURE = 'DP_INIT'
				BEGIN
					SELECT @v_CUST_FCST_M = (A_QTY + B_QTY)
					FROM (
						SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X WITH (NOLOCK)
						JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
						JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
						  	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
						WHERE 1 = 1
							AND X.DIVISION_ID = @p_division_id
							AND X.MEASURE IN (
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
							AND X.PROJECT_CODE = @p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM #TMP_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTRING(X.YYYYMMDD, 1, 6) = @v_yyyymm
							AND X.QTY <> 0
						) A
						,(
							SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X WITH (NOLOCK)
							JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
						    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
							WHERE 1 = 1
								AND X.DIVISION_ID = @p_division_id
								AND X.MEASURE IN (
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
								AND X.PROJECT_CODE = @p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM #TMP_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTRING(X.YYYYMMDD, 1, 6) = @v_yyyymm
							) B
				END
				ELSE
				BEGIN
					SELECT @v_CUST_FCST_M = (A_QTY + B_QTY)
					FROM (
						SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X WITH (NOLOCK)
						JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
					    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
						     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
						WHERE 1 = 1
							AND X.DIVISION_ID = @p_division_id
							AND X.MEASURE IN (
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
							AND X.PROJECT_CODE = @p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM #TMP_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, CONCAT (
											@v_yyyymm
											,'01'
											))), 112)
							AND X.QTY <> 0
						) A
						,(
							SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X WITH (NOLOCK)
							JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
						    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
							WHERE 1 = 1
								AND X.DIVISION_ID = @p_division_id
								AND X.MEASURE IN (
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
								AND X.PROJECT_CODE = @p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM #TMP_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, CONCAT (
												@v_yyyymm
												,'01'
												))), 112)
							) B
				END
			END

			IF @v_MEASURE = ''
				OR @v_MEASURE IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'MEASURE 입력값을 확인하세요.'

				SET @v_description = N'MEASURE 입력값을 확인하세요.'

				GOTO err_rtn
			END

			IF @v_QTYCD1 = ''
				OR @v_QTYCD1 IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'QTYCD1 입력값을 확인하세요.'

				SET @v_description = N'QTYCD1 입력값을 확인하세요.'

				GOTO err_rtn
			END

			IF @v_QTYCD2 = ''
				OR @v_QTYCD2 IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'QTYCD2 입력값을 확인하세요.'

				SET @v_description = N'QTYCD2 입력값을 확인하세요.'

				GOTO err_rtn
			END

			IF @v_QTYCD3 = ''
				OR @v_QTYCD3 IS NULL
			BEGIN
				SET @v_log_type = 'INVALID';

				SELECT N'QTYCD3 입력값을 확인하세요.'

				SET @v_description = N'QTYCD3 입력값을 확인하세요.'

				GOTO err_rtn
			END

			IF @v_SEQ = ''
				OR @v_SEQ IS NULL
			BEGIN
				SELECT @v_SEQ = MAX(SEQ) + 1
				FROM DM_ANL_MKT_PSI_DETAIL WITH (NOLOCK)
				WHERE DIVISION_ID = @v_DIVISION_ID
					AND END_CUSTOMER = @p_end_customer
					AND PROJECT_CODE = @v_PROJECT_CODE
					AND YYYYMM = @v_YYYYMM
					--AND CUST_FCST_M = @v_CUST_FCST_M
					AND MEASURE = @v_MEASURE
					AND QTYCD1 = @v_QTYCD1
					AND QTYCD2 = @v_QTYCD2
					AND QTYCD3 = @v_QTYCD3
			END

			PRINT 'INSERT 1------------------------------------------------------------------------------------------------------------------------------------------------------------'

			IF @mst_loop_cnt > 0
			BEGIN
				INSERT INTO DM_ANL_MKT_PSI_DETAIL (
					DIVISION_ID
					,END_CUSTOMER
					,PROJECT_CODE
					,YYYYMM
					,CUST_FCST_M
					,MEASURE
					,QTYCD1
					,QTYCD2
					,QTYCD3
					,SEQ
					,QTY
					,MKT_FCST_M
					,[DESC]
					,INPUT_LIMIT
					,CUST_FCST_M_CELL
					,QTY_CELL
					,MKT_FCST_M_CELL
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
				SELECT @v_DIVISION_ID
					,@v_END_CUSTOMER
					,@v_PROJECT_CODE
					,@v_YYYYMM
					,@v_CUST_FCST_M AS CUST_FCST_M
					--, CASE WHEN @v_MEASURE = 'DP_INIT' THEN @v_CUST_FCST_M
					--       WHEN @v_MEASURE = 'DP_RESULT' THEN @v_CUST_FCST_M_PRE END AS CUST_FCST_M
					,@v_MEASURE
					,@v_QTYCD1
					,@v_QTYCD2
					,@v_QTYCD3
					,@v_SEQ
					,ISNULL(@v_QTY, 0)
					,ISNULL(@v_MKT_FCST_M, 0)
					,@v_DESC
					,@v_INPUT_LIMIT
					,CONVERT(FLOAT, ISNULL(@v_CUST_FCST_M, 0)) * @v_TRANSLATOR AS CUST_FCST_M_CELL
					--, CASE WHEN @v_MEASURE = 'DP_INIT' THEN CONVERT(FLOAT, ISNULL(@v_CUST_FCST_M, 0)) * @v_TRANSLATOR
					--       WHEN @v_MEASURE = 'DP_RESULT' THEN CONVERT(FLOAT, ISNULL(@v_CUST_FCST_M_PRE, 0)) * @v_TRANSLATOR END AS CUST_FCST_M_CELL
					,CONVERT(FLOAT, ISNULL(@v_QTY, 0)) * @v_TRANSLATOR AS QTY_CELL
					,ISNULL(@v_MKT_FCST_M, 0) * @v_TRANSLATOR AS MKT_FCST_M_CELL
					,@v_CREATED_BY
					,SYSDATETIME()
					,@v_LAST_UPDATED_BY
					,SYSDATETIME()
			END
		END
		PRINT SYSDATETIME();

		--RESULT등록시 신규월 EDI 수량
		BEGIN
			SELECT @v_CUST_FCST_M_PRE = (A_QTY + B_QTY)
			FROM (
				SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS A_QTY
				FROM DM_PLN_MKT_FCST_C X WITH (NOLOCK)
				JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
			    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
				     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
				WHERE 1 = 1
					AND X.DIVISION_ID = @p_division_id
					AND X.MEASURE IN (
						'CUST_FCST_EDI'
						,'CUST_FCST'
						)
					--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
					AND X.PROJECT_CODE = @p_project_code
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND X.ITEM_ID IN (
						SELECT ITEM_ID
						FROM #TMP_DM_MST_ITEM_SINGLE_V
						)
					AND X.FCST_TYPE = 'MPS'
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, CONCAT (
									@v_yyyymm
									,'01'
									))), 112)
					AND QTY <> 0
				) A
				,(
					SELECT ISNULL(CEILING(SUM(X.QTY)), 0) AS B_QTY
					FROM DM_PLN_MKT_FCST_RESULT_C X WITH (NOLOCK)
					JOIN #TEMP_DM_MST_VERSION Y WITH (NOLOCK) ON X.VERSION_NO = Y.VERSION_NO
				    JOIN #TEMP_SCM_MST_SITE Z WITH (NOLOCK) 
					     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID 
					WHERE 1 = 1
						AND X.DIVISION_ID = @p_division_id
						AND X.MEASURE IN (
							'CUST_FCST_EDI'
							,'CUST_FCST'
							)
						--AND PROJECT_CODE IN (SELECT * FROM #TMP_PROJECT_CODE)
						AND X.PROJECT_CODE = @p_project_code
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND X.ITEM_ID IN (
							SELECT ITEM_ID
							FROM #TMP_DM_MST_ITEM_SINGLE_V
							)
						AND X.FCST_TYPE = 'MPS'
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND SUBSTRING(X.YYYYMMDD, 1, 6) = CONVERT(CHAR(6), DATEADD(MM, 1, CONVERT(DATETIME, CONCAT (
										@v_yyyymm
										,'01'
										))), 112)
					) B
		END
		PRINT SYSDATETIME();

		-- MASTER 테이블(DM_ANL_MKT_PSI) 데이터 입력
		BEGIN
			IF @v_MEASURE = 'DP_INIT' -- 수요계획(1st) 저장
			BEGIN
				PRINT 'INSERT 2-0------------------------------------------------------------------------------------------------------------------------------------------------------------'
				PRINT @v_DIVISION_ID + ' /// ' + @v_PROJECT_CODE + ' /// ' + @v_YYYYMM + ' /// ' + @v_MEASURE

				SELECT @v_CNT = COUNT(*) --  해당월 수요계획(1st) 존재여부
				FROM DM_ANL_MKT_PSI WITH (NOLOCK)
				WHERE 1 = 1
					AND DIVISION_ID = @v_DIVISION_ID
					AND END_CUSTOMER = @v_END_CUSTOMER
					AND PROJECT_CODE = @v_PROJECT_CODE
					AND YYYYMM = @v_YYYYMM
					AND MEASURE = @v_MEASURE

				PRINT @v_CNT

				IF @v_CNT > 0 -- 수요계획(1st)가 존재할 시 수요계획(1st)만 DELETE INSERT 처리
				BEGIN
					PRINT N'INSERT 2-1[수요계획(1ST) 존재]------------------------------------------------------------------------------------------------------------------------------------------'

					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = @v_YYYYMM
							AND MEASURE IN (@v_MEASURE)
					END

					BEGIN
						INSERT INTO #TMP_DM_ANL_MKT_PSI (
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,ISNULL(CEILING(T1.P_VALUE), 0)
							,ISNULL(CEILING(T1.S_VALUE), 0)
							,ISNULL(CEILING(T1.I_VALUE), 0)
							,ISNULL(CEILING(T1.V_VALUE), 0)
							,ISNULL(CEILING(T1.M_VALUE), 0)
							,ISNULL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE) + CEILING(T1.S_VALUE) + CEILING(T1.I_VALUE) + CEILING(T1.V_VALUE) + CEILING(T1.M_VALUE) + CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
							,ISNULL(CEILING(T1.CUST_FCST_M * @v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
							,ISNULL(CEILING(T1.P_VALUE * @v_TRANSLATOR), 0) AS P_VALUE_CELL
							,ISNULL(CEILING(T1.S_VALUE * @v_TRANSLATOR), 0) AS S_VALUE_CELL
							,ISNULL(CEILING(T1.I_VALUE * @v_TRANSLATOR), 0) AS I_VALUE_CELL
							,ISNULL(CEILING(T1.V_VALUE * @v_TRANSLATOR), 0) AS V_VALUE_CELL
							,ISNULL(CEILING(T1.M_VALUE * @v_TRANSLATOR), 0) AS M_VALUE_CELL
							,ISNULL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE) + CEILING(T1.S_VALUE) + CEILING(T1.I_VALUE) + CEILING(T1.V_VALUE) + CEILING(T1.M_VALUE) + CEILING(T1.CP_VALUE))) * @v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,ISNULL(CEILING(T1.CP_VALUE), 0)
							,ISNULL(CEILING(T1.CP_VALUE * @v_TRANSLATOR), 0) AS CP_VALUE_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,ISNULL(SUM([PRODUCT]),0) AS P_VALUE
								,ISNULL(SUM([SALES]),0) AS S_VALUE
								,ISNULL(SUM([INVENTORY]),0) AS I_VALUE
								,ISNULL(SUM([VPA]),0) AS V_VALUE
								,ISNULL(SUM([MODELMIX]),0) AS M_VALUE
								,ISNULL(SUM([SUPPLYISSUE]),0) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL WITH (NOLOCK)
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										[PRODUCT]
										,[SALES]
										,[INVENTORY]
										,[VPA]
										,[MODELMIX]
										,[SUPPLYISSUE]
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = @v_DIVISION_ID
								AND END_CUSTOMER = @v_END_CUSTOMER
								AND PROJECT_CODE = @v_PROJECT_CODE
								AND YYYYMM = @v_YYYYMM
								AND MEASURE = @v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1

						SELECT '1'
							,*
						FROM #TMP_DM_ANL_MKT_PSI
					END
				END
				ELSE -- 수요계획(1st)가 존재하지 않을 시 INSERT ALL(해당월 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
				BEGIN
					PRINT N'INSERT 2-1[수요계획(1ST) 미존재]----------------------------------------------------------------------------------------------------------------------------------------'

					BEGIN -- 수요계획(1ST)가 없으면 나머지 MEASURE 데이터도 의미가 없으므로 삭제
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = @v_YYYYMM
					END

					BEGIN
						INSERT INTO #TMP_DM_ANL_MKT_PSI (
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						--AN_LOGIC
						SELECT @v_DIVISION_ID
							,@v_END_CUSTOMER
							,@v_PROJECT_CODE
							,@v_YYYYMM
							,CEILING(@v_CUST_FCST_M) --CUST_FCST_M
							,'AN_LOGIC'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL
							--AN_RESULT[분석로직(%)*고객수요계획]
						
						UNION ALL
						
						SELECT @v_DIVISION_ID
							,@v_END_CUSTOMER
							,@v_PROJECT_CODE
							,@v_YYYYMM
							,CEILING(@v_CUST_FCST_M)
							,'AN_RESULT'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL
						
						UNION ALL
						
						--DP_INIT
						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,ISNULL(CEILING(T1.P_VALUE), 0)
							,ISNULL(CEILING(T1.S_VALUE), 0)
							,ISNULL(CEILING(T1.I_VALUE), 0)
							,ISNULL(CEILING(T1.V_VALUE), 0)
							,ISNULL(CEILING(T1.M_VALUE), 0)
							,ISNULL(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE) + CEILING(T1.S_VALUE) + CEILING(T1.I_VALUE) + CEILING(T1.V_VALUE) + CEILING(T1.M_VALUE) + CEILING(T1.CP_VALUE))), 0) AS MKT_FCST_M
							,ISNULL(CEILING(T1.CUST_FCST_M * @v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
							,ISNULL(CEILING(T1.P_VALUE * @v_TRANSLATOR), 0) AS P_VALUE_CELL
							,ISNULL(CEILING(T1.S_VALUE * @v_TRANSLATOR), 0) AS S_VALUE_CELL
							,ISNULL(CEILING(T1.I_VALUE * @v_TRANSLATOR), 0) AS I_VALUE_CELL
							,ISNULL(CEILING(T1.V_VALUE * @v_TRANSLATOR), 0) AS V_VALUE_CELL
							,ISNULL(CEILING(T1.M_VALUE * @v_TRANSLATOR), 0) AS M_VALUE_CELL
							,ISNULL(CEILING(CEILING(T1.CUST_FCST_M - (CEILING(T1.P_VALUE) + CEILING(T1.S_VALUE) + CEILING(T1.I_VALUE) + CEILING(T1.V_VALUE) + CEILING(T1.M_VALUE) + CEILING(T1.CP_VALUE))) * @v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,ISNULL(CEILING(T1.CP_VALUE), 0)
							,ISNULL(CEILING(T1.CP_VALUE * @v_TRANSLATOR), 0) AS CP_VALUE_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,ISNULL(SUM([PRODUCT]),0) AS P_VALUE
								,ISNULL(SUM([SALES]),0) AS S_VALUE
								,ISNULL(SUM([INVENTORY]),0) AS I_VALUE
								,ISNULL(SUM([VPA]),0) AS V_VALUE
								,ISNULL(SUM([MODELMIX]),0) AS M_VALUE
								,ISNULL(SUM([SUPPLYISSUE]),0) AS CP_VALUE 
							FROM DM_ANL_MKT_PSI_DETAIL WITH (NOLOCK)
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										[PRODUCT]
										,[SALES]
										,[INVENTORY]
										,[VPA]
										,[MODELMIX]
										,[SUPPLYISSUE]
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = @v_DIVISION_ID
								AND END_CUSTOMER = @v_END_CUSTOMER
								AND PROJECT_CODE = @v_PROJECT_CODE
								AND YYYYMM = @v_YYYYMM
								AND MEASURE = @v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
							) T1
						
						UNION ALL
						
						-- DP_RESULT
						SELECT @v_DIVISION_ID
							,@v_END_CUSTOMER
							,@v_PROJECT_CODE
							,@v_YYYYMM
							,CEILING(@v_CUST_FCST_M)
							,'DP_RESULT'
							,0 --P_VALUE
							,0 --S_VALUE
							,0 --I_VALUE
							,0 --V_VALUE
							,0 --M_VALUE
							,0 --MKT_FCST_M
							,0 --CUST_FCST_M_CELL
							,0 --P_VALUE_CELL
							,0 --S_VALUE_CELL
							,0 --I_VALUE_CELL
							,0 --V_VALUE_CELL
							,0 --M_VALUE_CELL
							,0 --MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,0 --CP_VALUE
							,0 --CP_VALUE_CELL
					END
				END
						--SELECT '2', * FROM #TMP_DM_ANL_MKT_PSI
			END
			ELSE -- 수요계획(Result) 저장
			BEGIN
				-- 수요계획(Result) 다음달 데이터 등록여부확인(다음달 데이터 첫등록여부 확인을 위함)
				SELECT @v_CNT = COUNT(*)
				FROM DM_ANL_MKT_PSI WITH (NOLOCK)
				WHERE 1 = 1
					AND DIVISION_ID = @v_DIVISION_ID
					AND END_CUSTOMER = @v_END_CUSTOMER
					AND PROJECT_CODE = @v_PROJECT_CODE
					--AND YYYYMM = @v_YYYYMM
					AND YYYYMM = CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
									@v_YYYYMM
									,'01'
									))), 112)
					AND MEASURE = @v_MEASURE

				-- 수요계획(Result) 당월 분석로직/분석결과/DPINIT이 존재하지않을 시
				SELECT @v_CNT_PRE = COUNT(*)
				FROM DM_ANL_MKT_PSI WITH (NOLOCK)
				WHERE 1 = 1
					AND DIVISION_ID = @v_DIVISION_ID
					AND END_CUSTOMER = @v_END_CUSTOMER
					AND PROJECT_CODE = @v_PROJECT_CODE
					AND YYYYMM = @v_YYYYMM

				IF @v_CNT_PRE = 0
				BEGIN
					PRINT N'INSERT 3[수요계획(Result) 저장, 당월 분석로직/분석결과/DPINIT 미존재]----------------------------------------------------------------------------------------------------'

					--AN_LOGIC
					INSERT INTO DM_ANL_MKT_PSI (
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,CP_VALUE
						,CP_VALUE_CELL
						)
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,@v_YYYYMM
						,CEILING(@v_CUST_FCST_M)
						,'AN_LOGIC'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,0 --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					--AN_RESULT[분석로직(%)*고객수요계획]
					
					UNION ALL
					
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,@v_YYYYMM
						,CEILING(@v_CUST_FCST_M)
						,'AN_RESULT'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,0 --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					-- DP_INIT
					
					UNION ALL
					
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,@v_YYYYMM
						,CEILING(@v_CUST_FCST_M)
						,'DP_INIT'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,CEILING(@v_MKT_FCST_M) --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL;
				END

				BEGIN -- 분석로직 임시테이블 저장(BEGIN~END)
					-- 테이블중복제거
					IF OBJECT_ID(N'tempdb..#TEMP_AN_LOGIC', N'U') IS NOT NULL
						DROP TABLE #TEMP_AN_LOGIC

					-- 임시확인용테이블 중복제거
					IF OBJECT_ID(N'dbo.#TEMP_AN_LOGIC', N'U') IS NOT NULL
						DROP TABLE #TEMP_AN_LOGIC

					CREATE TABLE #TEMP_AN_LOGIC (
						DIVISION_ID NVARCHAR(MAX)
						,END_CUSTOMER NVARCHAR(MAX)
						,PROJECT_CODE NVARCHAR(MAX)
						,YYYYMM NVARCHAR(MAX)
						,CUST_FCST_M NVARCHAR(MAX)
						,MEASURE NVARCHAR(MAX)
						,P_VALUE NVARCHAR(MAX)
						,S_VALUE NVARCHAR(MAX)
						,I_VALUE NVARCHAR(MAX)
						,V_VALUE NVARCHAR(MAX)
						,M_VALUE NVARCHAR(MAX)
						,MKT_FCST_M NVARCHAR(MAX)
						,CUST_FCST_M_CELL NVARCHAR(MAX)
						,P_VALUE_CELL NVARCHAR(MAX)
						,S_VALUE_CELL NVARCHAR(MAX)
						,I_VALUE_CELL NVARCHAR(MAX)
						,V_VALUE_CELL NVARCHAR(MAX)
						,M_VALUE_CELL NVARCHAR(MAX)
						,MKT_FCST_M_CELL NVARCHAR(MAX)
						,CP_VALUE NVARCHAR(MAX)
						,CP_VALUE_CELL NVARCHAR(MAX)
						,
						)

					-- 해당월의 다음달 데이터 분석로직 데이터 저장
					INSERT INTO #TEMP_AN_LOGIC (
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CP_VALUE
						,CP_VALUE_CELL
						)
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
										@v_YYYYMM
										,'01'
										))), 112)
						,CEILING(@v_CUST_FCST_M)
						,'AN_LOGIC'
						,ISNULL(CEILING(B.P_QTY / A.EDI_QTY), 0) AS P_QTY
						,ISNULL(CEILING(B.S_QTY / A.EDI_QTY), 0) AS S_QTY
						,ISNULL(CEILING(B.I_QTY / A.EDI_QTY), 0) AS I_QTY
						,ISNULL(CEILING(B.V_QTY / A.EDI_QTY), 0) AS V_QTY
						,ISNULL(CEILING(B.M_QTY / A.EDI_QTY), 0) AS M_QTY
						,0
						,CEILING(@v_CUST_FCST_M * @v_TRANSLATOR) AS CUST_FCST_M_CELL
						,ISNULL(CEILING(B.P_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS P_VALUE_CELL
						,ISNULL(CEILING(B.S_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS S_VALUE_CELL
						,ISNULL(CEILING(B.I_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS I_VALUE_CELL
						,ISNULL(CEILING(B.V_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS V_VALUE_CELL
						,ISNULL(CEILING(B.M_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS M_VALUE_CELL
						,0 AS MKT_FCST_M_CELL
						,ISNULL(CEILING(B.CP_QTY / A.EDI_QTY), 0) AS CP_QTY
						,ISNULL(CEILING(B.CP_QTY / A.EDI_QTY) * @v_TRANSLATOR, 0) AS CP_VALUE_CELL
					FROM (
						SELECT SUM(QTY) AS EDI_QTY
						FROM DM_PLN_MKT_FCST WITH (NOLOCK)
						WHERE DIVISION_ID = @v_DIVISION_ID
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND MEASURE IN (
								'CUST_FCST'
								,'CUST_FCST_EDI'
								)
							AND YYYYMMDD >= CONCAT (
								CONVERT(CHAR(6), DATEADD(YY, - 1, GETDATE()), 112)
								,'01'
								)
							AND YYYYMMDD <= CONVERT(NVARCHAR, EOMONTH(SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 6) + '01'), 112)
						) A
						,(
							SELECT SUM(P_VALUE) AS P_QTY
								,SUM(S_VALUE) AS S_QTY
								,SUM(I_VALUE) AS I_QTY
								,SUM(V_VALUE) AS V_QTY
								,SUM(M_VALUE) AS M_QTY
								,SUM(CP_VALUE) AS CP_QTY
							FROM DM_ANL_MKT_PSI WITH (NOLOCK)
							WHERE DIVISION_ID = @v_DIVISION_ID
								AND END_CUSTOMER = @v_END_CUSTOMER
								AND PROJECT_CODE = @v_PROJECT_CODE
								AND MEASURE = 'DP_RESULT'
								AND YYYYMM >= SUBSTRING(CONVERT(NVARCHAR, DATEADD(YY, - 1, GETDATE()), 112), 1, 6)
								AND YYYYMM <= SUBSTRING(CONVERT(NVARCHAR, GETDATE(), 112), 1, 6)
							) B
				END

				IF @v_CNT > 0 -- 수요계획(Result)가 존재할 시 수요계획(1st) 제외 DELETE INSERT 처리
				BEGIN
					PRINT N'INSERT 3-1[수요계획(Result) 저장, 수요계획(Result)가 존재시 DPINIT 만 나머지 삭제]----------------------------------------------------------------------------------------'

					-- 분석로직, 분석결과는 해당월의 다음달 데이터 삭제, 수요계획(Result)는 해당월 데이터 삭제 
					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
											@v_YYYYMM
											,'01'
											))), 112)
							AND MEASURE IN (
								'AN_LOGIC'
								,'AN_RESULT'
								)

						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = @v_YYYYMM
							AND MEASURE = 'DP_RESULT'
					END

					-- DM_ANL_MKT_PSI 데이터 저장
					BEGIN
						INSERT INTO #TMP_DM_ANL_MKT_PSI (
							DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,P_VALUE
							,S_VALUE
							,I_VALUE
							,V_VALUE
							,M_VALUE
							,MKT_FCST_M
							,CUST_FCST_M_CELL
							,P_VALUE_CELL
							,S_VALUE_CELL
							,I_VALUE_CELL
							,V_VALUE_CELL
							,M_VALUE_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,CP_VALUE
							,CP_VALUE_CELL
							)
						--AN_LOGIC
						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,@v_CUST_FCST_M_PRE
							,MEASURE
							,ISNULL(P_VALUE, 0)
							,ISNULL(S_VALUE, 0)
							,ISNULL(I_VALUE, 0)
							,ISNULL(V_VALUE, 0)
							,ISNULL(M_VALUE, 0)
							,ISNULL(MKT_FCST_M, 0)
							,ISNULL(CUST_FCST_M_CELL, 0)
							,ISNULL(P_VALUE_CELL, 0)
							,ISNULL(S_VALUE_CELL, 0)
							,ISNULL(I_VALUE_CELL, 0)
							,ISNULL(V_VALUE_CELL, 0)
							,ISNULL(M_VALUE_CELL, 0)
							,ISNULL(MKT_FCST_M_CELL, 0)
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,ISNULL(CP_VALUE, 0)
							,ISNULL(CP_VALUE_CELL, 0)
						FROM #TEMP_AN_LOGIC
						--AN_RESULT[분석로직(%)*고객수요계획]
						
						UNION ALL
						
						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,@v_CUST_FCST_M_PRE
							,'AN_RESULT'
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, P_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, S_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, I_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, V_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, M_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) - (CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, P_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, S_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, I_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, V_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, M_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, CP_VALUE) / 100))), 0)
							,CUST_FCST_M_CELL
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, P_VALUE_CELL) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, S_VALUE_CELL) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, I_VALUE_CELL) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, V_VALUE_CELL) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, M_VALUE_CELL) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) - (CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, P_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, S_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, I_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, V_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, M_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, CP_VALUE_CELL) / 100))), 0)
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, CP_VALUE) / 100), 0)
							,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, CP_VALUE_CELL) / 100), 0)
						FROM #TEMP_AN_LOGIC
						-- DP_RESULT
						
						UNION ALL
						
						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,ISNULL(CEILING(T1.P_VALUE), 0)
							,ISNULL(CEILING(T1.S_VALUE), 0)
							,ISNULL(CEILING(T1.I_VALUE), 0)
							,ISNULL(CEILING(T1.V_VALUE), 0)
							,ISNULL(CEILING(T1.M_VALUE), 0)
							,ISNULL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
							,T1.CUST_FCST_M * @v_TRANSLATOR AS CUST_FCST_M_CELL
							,ISNULL(CEILING(T1.P_VALUE * @v_TRANSLATOR), 0) AS P_VALU_CELL
							,ISNULL(CEILING(T1.S_VALUE * @v_TRANSLATOR), 0) AS S_VALU_CELL
							,ISNULL(CEILING(T1.I_VALUE * @v_TRANSLATOR), 0) AS I_VALU_CELL
							,ISNULL(CEILING(T1.V_VALUE * @v_TRANSLATOR), 0) AS V_VALU_CELL
							,ISNULL(CEILING(T1.M_VALUE * @v_TRANSLATOR), 0) AS M_VALU_CELL
							,ISNULL(CEILING(T1.MKT_FCST_M * @v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,@v_CREATED_BY
							,SYSDATETIME()
							,@v_LAST_UPDATED_BY
							,SYSDATETIME()
							,ISNULL(CEILING(T1.CP_VALUE), 0)
							,ISNULL(CEILING(T1.CP_VALUE * @v_TRANSLATOR), 0) AS CP_VALU_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,ISNULL(SUM([PRODUCT]),0) AS P_VALUE
								,ISNULL(SUM([SALES]),0) AS S_VALUE
								,ISNULL(SUM([INVENTORY]),0) AS I_VALUE
								,ISNULL(SUM([VPA]),0) AS V_VALUE
								,ISNULL(SUM([MODELMIX]),0) AS M_VALUE
								,ISNULL(SUM([SUPPLYISSUE]),0) AS CP_VALUE 
							FROM DM_ANL_MKT_PSI_DETAIL WITH (NOLOCK)
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										[PRODUCT]
										,[SALES]
										,[INVENTORY]
										,[VPA]
										,[MODELMIX]
										,[SUPPLYISSUE]
										)) AS PVT
							WHERE 1 = 1
								AND DIVISION_ID = @v_DIVISION_ID
								AND END_CUSTOMER = @v_END_CUSTOMER
								AND PROJECT_CODE = @v_PROJECT_CODE
								AND YYYYMM = @v_YYYYMM
								AND MEASURE = @v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1;
					END

					SELECT '3'
						,*
					FROM #TMP_DM_ANL_MKT_PSI
				END
				ELSE -- 수요계획(Result)가 존재하지 않을 시 INSERT ALL(해당월의 다음달 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
				BEGIN
					PRINT N'INSERT 3-1[수요계획(Result) 미존재]----------------------------------------------------------------------------------------'

					IF @v_CNT_PRE > 0
					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = @v_YYYYMM
							AND MEASURE = 'DP_RESULT'
					END

					INSERT INTO #TMP_DM_ANL_MKT_PSI (
						DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						,YYYYMM
						,CUST_FCST_M
						,MEASURE
						,P_VALUE
						,S_VALUE
						,I_VALUE
						,V_VALUE
						,M_VALUE
						,MKT_FCST_M
						,CUST_FCST_M_CELL
						,P_VALUE_CELL
						,S_VALUE_CELL
						,I_VALUE_CELL
						,V_VALUE_CELL
						,M_VALUE_CELL
						,MKT_FCST_M_CELL
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,CP_VALUE
						,CP_VALUE_CELL
						)
					--AN_LOGIC
					SELECT DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						--, YYYYMM
						,CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
										@v_YYYYMM
										,'01'
										))), 112)
						,CEILING(@v_CUST_FCST_M_PRE)
						,MEASURE
						,ISNULL(P_VALUE, 0)
						,ISNULL(S_VALUE, 0)
						,ISNULL(I_VALUE, 0)
						,ISNULL(V_VALUE, 0)
						,ISNULL(M_VALUE, 0)
						,ISNULL(MKT_FCST_M, 0)
						,CUST_FCST_M_CELL
						,ISNULL(P_VALUE_CELL, 0)
						,ISNULL(S_VALUE_CELL, 0)
						,ISNULL(I_VALUE_CELL, 0)
						,ISNULL(V_VALUE_CELL, 0)
						,ISNULL(M_VALUE_CELL, 0)
						,ISNULL(MKT_FCST_M_CELL, 0)
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,ISNULL(CP_VALUE, 0)
						,ISNULL(CP_VALUE_CELL, 0)
					FROM #TEMP_AN_LOGIC
					--AN_RESULT[분석로직(%)*고객수요계획]
					
					UNION ALL
					
					SELECT DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						--, YYYYMM
						,CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
										@v_YYYYMM
										,'01'
										))), 112)
						,CEILING(@v_CUST_FCST_M_PRE)
						,'AN_RESULT'
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, P_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, S_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, I_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, V_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, M_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) - (CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, P_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, S_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, I_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, V_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, M_VALUE) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, CP_VALUE) / 100))), 0)
						,CUST_FCST_M_CELL
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, P_VALUE_CELL) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, S_VALUE_CELL) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, I_VALUE_CELL) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, V_VALUE_CELL) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, M_VALUE_CELL) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) - (CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, P_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, S_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, I_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, V_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, M_VALUE_CELL) / 100) + CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, CP_VALUE_CELL) / 100))), 0)
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M) * CONVERT(FLOAT, CP_VALUE) / 100), 0)
						,ISNULL(CEILING(CONVERT(FLOAT, CUST_FCST_M_CELL) * CONVERT(FLOAT, CP_VALUE_CELL) / 100), 0)
					FROM #TEMP_AN_LOGIC
					
					UNION ALL
					
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
										@v_YYYYMM
										,'01'
										))), 112)
						,CEILING(@v_CUST_FCST_M_PRE)
						,'DP_INIT'
						,0
						,0
						,0
						,0
						,0
						,CEILING(@v_MKT_FCST_M)
						,CEILING(@v_CUST_FCST_M_CELL)
						,0
						,0
						,0
						,0
						,0
						,CEILING(@v_MKT_FCST_M_CELL)
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,0
						,0
					
					UNION ALL
					
					SELECT T1.DIVISION_ID
						,T1.END_CUSTOMER
						,T1.PROJECT_CODE
						,T1.YYYYMM
						,T1.CUST_FCST_M
						,T1.MEASURE
						,ISNULL(CEILING(T1.P_VALUE), 0)
						,ISNULL(CEILING(T1.S_VALUE), 0)
						,ISNULL(CEILING(T1.I_VALUE), 0)
						,ISNULL(CEILING(T1.V_VALUE), 0)
						,ISNULL(CEILING(T1.M_VALUE), 0)
						,ISNULL(CEILING(T1.MKT_FCST_M), 0) AS MKT_FCST_M
						,T1.CUST_FCST_M * @v_TRANSLATOR AS CUST_FCST_M_CELL
						,ISNULL(CEILING(T1.P_VALUE * @v_TRANSLATOR), 0) AS P_VALU_CELL
						,ISNULL(CEILING(T1.S_VALUE * @v_TRANSLATOR), 0) AS S_VALU_CELL
						,ISNULL(CEILING(T1.I_VALUE * @v_TRANSLATOR), 0) AS I_VALU_CELL
						,ISNULL(CEILING(T1.V_VALUE * @v_TRANSLATOR), 0) AS V_VALU_CELL
						,ISNULL(CEILING(T1.M_VALUE * @v_TRANSLATOR), 0) AS M_VALU_CELL
						,ISNULL(CEILING(T1.MKT_FCST_M * @v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,ISNULL(CEILING(T1.CP_VALUE), 0)
						,ISNULL(CEILING(T1.CP_VALUE * @v_TRANSLATOR), 0) AS CP_VALU_CELL
					FROM (
						SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,MKT_FCST_M
						    ,ISNULL(SUM([PRODUCT]),0) AS P_VALUE
							,ISNULL(SUM([SALES]),0) AS S_VALUE
							,ISNULL(SUM([INVENTORY]),0) AS I_VALUE
							,ISNULL(SUM([VPA]),0) AS V_VALUE
							,ISNULL(SUM([MODELMIX]),0) AS M_VALUE
							,ISNULL(SUM([SUPPLYISSUE]),0) AS CP_VALUE 
						FROM DM_ANL_MKT_PSI_DETAIL WITH (NOLOCK)
						PIVOT(SUM(QTY) FOR QTYCD3 IN (
									[PRODUCT]
									,[SALES]
									,[INVENTORY]
									,[VPA]
									,[MODELMIX]
									,[SUPPLYISSUE]
									)) AS PVT
						WHERE 1 = 1
							AND DIVISION_ID = @v_DIVISION_ID
							AND END_CUSTOMER = @v_END_CUSTOMER
							AND PROJECT_CODE = @v_PROJECT_CODE
							AND YYYYMM = @v_YYYYMM
							AND MEASURE = @v_MEASURE
						GROUP BY DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,MKT_FCST_M
						) T1
					
					UNION ALL
					
					SELECT @v_DIVISION_ID
						,@v_END_CUSTOMER
						,@v_PROJECT_CODE
						,CONVERT(CHAR(6), DATEADD(mm, 1, CONVERT(DATETIME, CONCAT (
										@v_YYYYMM
										,'01'
										))), 112)
						,CEILING(@v_CUST_FCST_M_PRE)
						,'DP_RESULT'
						,0
						,0
						,0
						,0
						,0
						,0
						,CEILING(@v_CUST_FCST_M_CELL) AS CUST_FCST_M_CELL
						,0 AS P_VALU_CELL
						,0 AS S_VALU_CELL
						,0 AS I_VALU_CELL
						,0 AS V_VALU_CELL
						,0 AS M_VALU_CELL
						,0 AS MKT_FCST_M_CELL
						,@v_CREATED_BY
						,SYSDATETIME()
						,@v_LAST_UPDATED_BY
						,SYSDATETIME()
						,0
						,0 AS CP_VALU_CELL

					SELECT '4'
						,*
					FROM #TMP_DM_ANL_MKT_PSI
				END
			END
		END
		PRINT SYSDATETIME();

		BEGIN -- 본 테이블 INSERT
			SELECT '5'
				,*
			FROM #TMP_DM_ANL_MKT_PSI

			INSERT INTO DM_ANL_MKT_PSI (
				DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,P_VALUE
				,S_VALUE
				,I_VALUE
				,V_VALUE
				,M_VALUE
				,MKT_FCST_M
				,[DESC]
				,INPUT_LIMIT
				,CUST_FCST_M_CELL
				,P_VALUE_CELL
				,S_VALUE_CELL
				,I_VALUE_CELL
				,V_VALUE_CELL
				,M_VALUE_CELL
				,MKT_FCST_M_CELL
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,CP_VALUE
				,CP_VALUE_CELL
				)
			SELECT DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,CONVERT(FLOAT, P_VALUE)
				,CONVERT(FLOAT, S_VALUE)
				,CONVERT(FLOAT, I_VALUE)
				,CONVERT(FLOAT, V_VALUE)
				,CONVERT(FLOAT, M_VALUE)
				,CONVERT(FLOAT, MKT_FCST_M)
				,[DESC]
				,INPUT_LIMIT
				,CONVERT(FLOAT, CUST_FCST_M_CELL)
				,CONVERT(FLOAT, P_VALUE_CELL)
				,CONVERT(FLOAT, S_VALUE_CELL)
				,CONVERT(FLOAT, I_VALUE_CELL)
				,CONVERT(FLOAT, V_VALUE_CELL)
				,CONVERT(FLOAT, M_VALUE_CELL)
				,CONVERT(FLOAT, MKT_FCST_M_CELL)
				,CREATED_BY
				,GETDATE()
				,LAST_UPDATED_BY
				,GETDATE()
				,CONVERT(FLOAT, CP_VALUE)
				,CONVERT(FLOAT, CP_VALUE_CELL)
			FROM #TMP_DM_ANL_MKT_PSI
		END
		PRINT SYSDATETIME();

		
		/*
		2024.01.10    kcw3408        PR_DM_ANL_MKT_PSI_DATA:고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송 배치 작업 신규로  I/F 테이블 INSERT 삭제함
		*/
		/*
		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM #TMP_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM [LGCE_INFDEV].[DBO].XIF_DM_ANL_MKT_PSI_DW_S
				WHERE DIVISION_ID = @v_Division_id
					AND END_CUSTOMER = @p_end_customer
					AND PROJECT_CODE = @p_project_code
			END

			INSERT INTO [LGCE_INFDEV].[DBO].XIF_DM_ANL_MKT_PSI_DW_S (
				DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,P_VALUE
				,S_VALUE
				,I_VALUE
				,V_VALUE
				,M_VALUE
				,MKT_FCST_M
				,[DESC]
				,INPUT_LIMIT
				,CUST_FCST_M_CELL
				,P_VALUE_CELL
				,S_VALUE_CELL
				,I_VALUE_CELL
				,V_VALUE_CELL
				,M_VALUE_CELL
				,MKT_FCST_M_CELL
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,CP_VALUE
				,CP_VALUE_CELL
				)
			SELECT DIVISION_ID
				,END_CUSTOMER
				,PROJECT_CODE
				,YYYYMM
				,CUST_FCST_M
				,MEASURE
				,CONVERT(FLOAT, P_VALUE)
				,CONVERT(FLOAT, S_VALUE)
				,CONVERT(FLOAT, I_VALUE)
				,CONVERT(FLOAT, V_VALUE)
				,CONVERT(FLOAT, M_VALUE)
				,CONVERT(FLOAT, MKT_FCST_M)
				,[DESC]
				,INPUT_LIMIT
				,CONVERT(FLOAT, CUST_FCST_M_CELL)
				,CONVERT(FLOAT, P_VALUE_CELL)
				,CONVERT(FLOAT, S_VALUE_CELL)
				,CONVERT(FLOAT, I_VALUE_CELL)
				,CONVERT(FLOAT, V_VALUE_CELL)
				,CONVERT(FLOAT, M_VALUE_CELL)
				,CONVERT(FLOAT, MKT_FCST_M_CELL)
				,CREATED_BY
				,GETDATE()
				,LAST_UPDATED_BY
				,GETDATE()
				,CONVERT(FLOAT, CP_VALUE)
				,CONVERT(FLOAT, CP_VALUE_CELL)
			FROM DM_ANL_MKT_PSI
			WHERE DIVISION_ID = @v_Division_id
				AND PROJECT_CODE = @p_project_code
				AND END_CUSTOMER = @p_end_customer
		END

		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 START
			BEGIN
				INSERT INTO #TMP_PROJECT_DEPT
				SELECT PRJ.DIVISION_ID,PRJ.PROJECT_CODE, PRJ.PROJECT_NAME, DEPT.DEPT_ID, DEPT.DEPT_NAME_KO FROM SCM_MST_PROJECT PRJ INNER JOIN 
				(
				SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, B.DEPT_NAME_KO 
					FROM [SCM_MST_SSO_USER_INFO] AS A WITH(NOLOCK)
						INNER JOIN SCM_MST_SSO_DEPT_INFO AS B WITH(NOLOCK)
							ON A.DEPT_ID = B.DEPT_ID
				) DEPT ON DEPT.USER_ID = PRJ.PROJECT_OWNER
			END


		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 END

		SELECT ROW_NUMBER() OVER(ORDER BY A.ITEM_ID) SEQ, A.ITEM_ID 
		INTO #TMP_ITEM_ID
		FROM
		(SELECT ITEM_ID FROM #TMP_DM_MST_ITEM_SINGLE_V GROUP BY ITEM_ID) A
		
		DECLARE @i INT = 1
		DECLARE @ITEM_CNT INT = 0
		DECLARE @ITEM_ID NVARCHAR(50)
		
		SELECT @ITEM_CNT = COUNT(*) FROM #TMP_ITEM_ID

		--SELECT * FROM #TMP_ITEM_ID  

		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM #TMP_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM [LGCE_INFDEV].[DBO].XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
				WHERE DIVISION_ID = @v_Division_id
					AND PROJECT_CODE = @p_project_code
					AND END_CUSTOMER = @p_end_customer
			END
			
			WHILE @i <= @ITEM_CNT
			BEGIN
				SELECT @ITEM_ID = ITEM_ID FROM #TMP_ITEM_ID WHERE SEQ = @i
				INSERT INTO [LGCE_INFDEV].[DBO].XIF_DM_ANL_MKT_PSI_DETAIL_DW_S (
							DIVISION_ID
							,DEPT_ID
							,DEPT_NAME_KO
							,PROJECT_NAME
							,PROJECT_CODE
							,ITEM_ID --,SCM_SITE_ID
							,END_CUSTOMER
							,YYYYMM
							,CUST_FCST_M
							,MEASURE
							,QTYCD1
							,QTYCD2
							,QTYCD3
							,SEQ
							,QTY
							,MKT_FCST_M
							,[DESC]
							,INPUT_LIMIT
							,CUST_FCST_M_CELL
							,QTY_CELL
							,MKT_FCST_M_CELL
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE

					)
				SELECT 
					 A.DIVISION_ID
					,B.DEPT_ID
					,B.DEPT_NAME_KO
					,B.PROJECT_NAME
					,A.PROJECT_CODE
					,@ITEM_ID AS ITEM_ID
					,A.END_CUSTOMER
					,A.YYYYMM
					,A.CUST_FCST_M
					,A.MEASURE
					,A.QTYCD1
					,A.QTYCD2
					,A.QTYCD3
					,A.SEQ
					,A.QTY
					,A.MKT_FCST_M
					,A.[DESC]
					,A.INPUT_LIMIT
					,A.CUST_FCST_M * @v_TRANSLATOR -- A.CUST_FCST_M_CELL
					,A.QTY * @v_TRANSLATOR --A.QTY_CELL
					,A.MKT_FCST_M * @v_TRANSLATOR --A.MKT_FCST_M_CELL
					,A.CREATED_BY
					,GETDATE()
					, @p_created_by --,A.LAST_UPDATED_BY
					,GETDATE()

				FROM DM_ANL_MKT_PSI_DETAIL A 
				INNER JOIN #TMP_PROJECT_DEPT B	ON A.DIVISION_ID = B.DIVISION_ID  AND A.PROJECT_CODE = B.PROJECT_CODE
				WHERE A.DIVISION_ID = @v_Division_id
					AND A.PROJECT_CODE = @p_project_code
					AND A.END_CUSTOMER = @p_end_customer
				
				SET @i = @i + 1
			END
		END
	    */

		PRINT SYSDATETIME();

		--EXEC DMF0003_GET_DM_ANL_MKT_PSI_DATA @v_DIVISION_ID, @v_PROJECT_CODE, @v_YYYYMM, @v_CREATED_BY;
		COMMIT;
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN SAVE_DM_ANL_MKT_PSI_DETAIL;

		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
			,@v_log_type
			,@n_log_count
			,@v_log_message
			,@v_description
			,@d_event_date;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;
END;

-- 트랜잭션 (END)
err_rtn:

IF @v_log_type = 'INVALID'
BEGIN
	SELECT @v_description

	ROLLBACK TRAN SAVE_DM_ANL_MKT_PSI_DETAIL;

	SET @v_log_message = '########## END of procedure ##########';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;
		
	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();

	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name
		,@v_log_type
		,@n_log_count
		,@v_log_message
		,@v_description
		,@d_event_date;
END

   