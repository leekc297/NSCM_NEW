CREATE OR REPLACE PROCEDURE           "DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL" 
/**
 * 2026/05/21 byunmj0223 LINE 2082, LINE2091 다른 테이블 조회 위해서는 DB LINK 생성 필요
 * 2026.08 -> 2026.06.08 ZIONEX [PJ202650304] NextSCM Migration : MSSQL 원본에서 블록주석(비활성)이던 I/F 전송 구간이 변환 시 잘못 활성화되어 ORA-00942 발생 → MSSQL과 동일하게 재비활성화(주석 복원). DB LINK/권한 부여 불필요.
 */
(
     p_division_id VARCHAR2
	,p_project_code VARCHAR2
	,p_yyyymm VARCHAR2
	,p_cust_fcst_m VARCHAR2
	,p_measure VARCHAR2
	,p_qtycd1 VARCHAR2
	,p_qtycd2 VARCHAR2
	,p_qtycd3 VARCHAR2
	,p_seq VARCHAR2
	,p_qty VARCHAR2
	,p_mkt_fcst_m VARCHAR2
	,p_desc VARCHAR2
	,p_input_limit VARCHAR2
	,p_created_by VARCHAR2
	,p_end_customer VARCHAR2
	,O_RC1 OUT SYS_REFCURSOR
	,O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
    v_DIVISION_ID VARCHAR2(4000 CHAR);
    v_END_CUSTOMER VARCHAR2(4000 CHAR);
    v_PROJECT_CODE VARCHAR2(4000 CHAR);
    v_YYYYMM VARCHAR2(4000 CHAR);
    v_CUST_FCST_M VARCHAR2(4000 CHAR);
    v_CUST_FCST_M_PRE VARCHAR2(4000 CHAR);
    v_MEASURE VARCHAR2(4000 CHAR);
    v_QTYCD1 VARCHAR2(4000 CHAR);
    v_QTYCD2 VARCHAR2(4000 CHAR);
    v_QTYCD3 VARCHAR2(4000 CHAR);
    v_SEQ VARCHAR2(4000 CHAR);
    v_QTY VARCHAR2(4000 CHAR);
    v_MKT_FCST_M VARCHAR2(4000 CHAR);
    v_DESC VARCHAR2(4000 CHAR);
    v_INPUT_LIMIT VARCHAR2(4000 CHAR);
    v_CREATED_BY VARCHAR2(4000 CHAR);
    v_CREATION_DATE VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY VARCHAR2(4000 CHAR);
    v_LAST_UPDATE_DATE VARCHAR2(4000 CHAR);
    v_ITEM_CLASS VARCHAR2(30 CHAR);
    v_PACK_CNT INTEGER := 0;
    v_MODULE_CNT INTEGER := 0;
    v_CELL_CNT INTEGER := 0;
    v_0month_tuesday VARCHAR2(08 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_CNT INTEGER := 0;
    v_CNT_PRE INTEGER := 0;
    v_program_name VARCHAR2(150 CHAR) := 'DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_i INTEGER := 1;
    V_ITEM_CNT INTEGER := 0;
    V_ITEM_ID VARCHAR2(50 CHAR);
    v_CELL_PER_PACK NUMBER(30, 10);
    v_CELL_PER_MODULE NUMBER(30, 10);
	v_CELL_PER_CELL NUMBER(30, 10);
	v_TRANSLATOR NUMBER(30, 10); --환산자
	v_REP_ITEM_ID VARCHAR2(30 CHAR); --대표환산자 ITEM_ID
	v_REP_TRANSLATOR VARCHAR2(30 CHAR); --대표환산자
	v_CUST_FCST_M_CELL NUMBER(30, 10);
	v_P_VALUE_CELL NUMBER(30, 10);
	v_S_VALUE_CELL NUMBER(30, 10);
	v_I_VALUE_CELL NUMBER(30, 10);
	v_V_VALUE_CELL NUMBER(30, 10);
	v_M_VALUE_CELL NUMBER(30, 10);
	v_CP_VALUE_CELL NUMBER(30, 10);
	v_MKT_FCST_M_CELL NUMBER(30, 10);
    v_err_mesage VARCHAR2(2000 CHAR);
    V_CELL_CF varchar2(2000 char);
    v_err_message VARCHAR2(2000 CHAR);

    GT_DMF0_DM_MST_VERSION DMF0_DM_MST_VERSION_TAB;
    GT_DMF0_SCM_MST_SITE SCM_MST_SITE_TAB;
    GT_DMF0_DM_ANL_MKT_PSI DM_ANL_MKT_PSI_TAB;
    GT_DMF0_AN_LOGIC DM_ANL_MKT_PSI_TAB;
    GT_DMF0_PROJECT_DEPT PROJECT_DEPT_TAB;
    GT_DMF0_ITEM_ID ITEM_ID_TAB;

    TYPE SEARCH_RESULT_ROW IS RECORD (
    	RESULT_NO NUMBER(10, 0)
    	,DIVISION_ID VARCHAR2(30 CHAR)
		,END_CUSTOMER VARCHAR2(50 CHAR)
		,PROJECT_CODE VARCHAR2(50 CHAR)
		,YYYYMM VARCHAR2(6 CHAR)
		,CUST_FCST_M NUMBER(30,10)
		,MEASURE VARCHAR2(30 CHAR)
		,P_VALUE NUMBER(30,10)
		,S_VALUE NUMBER(30,10)
		,I_VALUE NUMBER(30,10)
		,V_VALUE NUMBER(30,10)
		,M_VALUE NUMBER(30,10)
		,MKT_FCST_M NUMBER(30,10)
		,"DESC" VARCHAR2(150 CHAR)
		,INPUT_LIMIT VARCHAR2(10 CHAR)
		,CUST_FCST_M_CELL NUMBER(30,10)
		,P_VALUE_CELL NUMBER(30,10)
		,S_VALUE_CELL NUMBER(30,10)
		,I_VALUE_CELL NUMBER(30,10)
		,V_VALUE_CELL NUMBER(30,10)
		,M_VALUE_CELL NUMBER(30,10)
		,MKT_FCST_M_CELL NUMBER(30,10)
		,CREATED_BY VARCHAR2(150 CHAR)
		,CREATION_DATE DATE
		,LAST_UPDATED_BY VARCHAR2(150 CHAR)
		,LAST_UPDATE_DATE DATE
		,CP_VALUE NUMBER(30,10)
		,CP_VALUE_CELL NUMBER(30,10)
    );

    TYPE SEARCH_RESULT_TAB IS TABLE OF SEARCH_RESULT_ROW;
    V_RES_RESULT SEARCH_RESULT_TAB;
BEGIN
	------------------------------------------------------------------------------------------------------환산자 추가
	v_DIVISION_ID := NULL;
	v_END_CUSTOMER := NULL;
	v_PROJECT_CODE := NULL;
	v_YYYYMM := NULL;
	v_CUST_FCST_M := NULL;
	v_CUST_FCST_M_PRE := NULL;
	v_MEASURE := NULL;
	v_QTYCD1 := NULL;
	v_QTYCD2 := NULL;
	v_QTYCD3 := NULL;
	v_SEQ := NULL;
	v_QTY := NULL;
	v_MKT_FCST_M := NULL;
	v_DESC := NULL;
	v_INPUT_LIMIT := NULL;
	v_CREATED_BY := NULL;
	v_CREATION_DATE := NULL;
	v_LAST_UPDATED_BY := NULL;
	v_LAST_UPDATE_DATE := NULL;
	v_ITEM_CLASS := NULL;
	v_PACK_CNT := NULL;
	v_MODULE_CNT := NULL;
	v_CELL_CNT := NULL;
	v_CELL_PER_PACK := NULL;
	v_CELL_PER_MODULE := NULL;
	v_CELL_PER_CELL := NULL;
	v_TRANSLATOR := NULL;
	v_CUST_FCST_M_CELL := NULL;
	v_P_VALUE_CELL := NULL;
	v_S_VALUE_CELL := NULL;
	v_I_VALUE_CELL := NULL;
	v_V_VALUE_CELL := NULL;
	v_M_VALUE_CELL := NULL;
	v_CP_VALUE_CELL := NULL;
	v_MKT_FCST_M_CELL := NULL;
	v_delimiter := '^';

	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH(
		v_program_name
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date
	);

	-- 시작 LOG  (END)
	v_log_message := NULL; /*; -- <- 변수 재사용을 위하여 초기화해야함 --*/


	BEGIN
		IF p_division_id IS NULL OR p_division_id IS NULL THEN
			v_log_type := 'INVALID';

			SELECT 'DIVISION_ID 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		IF p_end_customer IS NULL OR p_end_customer IS NULL THEN
			v_log_type := 'INVALID';

			SELECT 'END_CUSTOMER 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		IF p_project_code IS NULL OR p_project_code IS NULL THEN
			v_log_type := 'INVALID';

			SELECT 'PROJECT_CODE 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		IF p_yyyymm IS NULL OR p_yyyymm IS NULL THEN
			v_log_type := 'INVALID';

			SELECT 'YYYYMM 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		IF p_measure IS NULL OR p_measure IS NULL THEN
			v_log_type := 'INVALID';

			SELECT 'MEASURE 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		IF p_qtycd3 IS NULL OR p_qtycd3 IS NULL OR LENGTH(p_qtycd3) = 0 THEN
			v_log_type := 'INVALID';

			SELECT 'MEASURE 입력값을 확인하세요.' INTO v_err_mesage
			FROM DUAL;

			GOTO err_rtn;
		END IF;

		<<err_rtn>>
		IF v_log_type = 'INVALID' THEN
			v_log_message := '########## END of procedure ##########';
			d_event_date := SYSTIMESTAMP;

			PR_SCM_SYS_LOG_BATCH(v_program_name
				,v_log_type
				,n_log_count
				,v_log_message
				,v_description
				,d_event_date
				);
			-- 종료 LOG
			v_log_type := 'END';
			v_log_message := '########## END of procedure ##########';
			v_description := NULL;
			d_event_date := SYSTIMESTAMP;

			PR_SCM_SYS_LOG_BATCH(v_program_name
				,v_log_type
				,n_log_count
				,v_log_message
				,v_description
				,d_event_date
				);
		END IF;

		v_description := v_err_mesage;

		BEGIN
			DELETE
			FROM DM_ANL_MKT_PSI_DETAIL
			WHERE 1 = 1
				AND DIVISION_ID = p_division_id
				AND END_CUSTOMER = p_end_customer
				AND PROJECT_CODE = p_project_code
				AND YYYYMM = p_yyyymm
				AND MEASURE = p_measure;
		END;

		--BEGIN
		--	-- 테이블중복제거
		--	--	-- 임시확인용테이블 중복제거
		--	--	SELECT * INTO GT_DMF0_PROJECT_CODE
		--	FROM (SELECT PROJECT_CODE FROM SCM_MST_PROJECT WHERE DIVISION_ID = p_division_id AND PROJECT_NAME = V_project_name) A
		--END
		-- 프로시저 LOOP 길이를 판단
		v_max_loop_cnt := SCM_ARR_SPL_CNT(p_qtycd3, v_delimiter);

		DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_max_loop_cnt)  ||  ' '  ||  '----------------------------------------------------------------------------------------------------------------------------------------------');

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------START
		BEGIN
			/* TODO:GTT:GT_DMF0_DM_MST_ITEM_SINGLE_V-->GT_DMF0_DM_MST_ITEM_SINGLE_V */
			INSERT INTO GT_DMF0_DM_MST_ITEM_SINGLE_V
			SELECT	DIVISION_ID,
					ITEM_ID,
					ITEM_NAME,
					ITEM_CLASS,
					ITEM_CLASS_NAME,
					NICK_NAME,
					ITEM_TYPE,
					MDM_PROJECT_NAME,
					MIN_CAPACITY,
					FORECAST_INFO_BIZ_TYPE,
					FORECAST_INFO_PRODUCT_GROUP,
					FORECAST_INFO_CELL_MODEL,
					FORECAST_INFO_CELL_PACK_COUNT,
					FORECAST_INFO_SPEC,
					FORECAST_INFOR_VERSION,
					CELL_TYPE,
					ENERGE,
					CELL_QUANTITY
			FROM DM_MST_ITEM_SINGLE_V
			WHERE DIVISION_ID = p_division_id
				AND ITEM_ID IN (
					SELECT ITEM_ID
					FROM SCM_MST_PROJECT_ITEM
					WHERE PROJECT_CODE = p_project_code
						AND VALID_YN = 'Y'
					)
				AND ITEM_TYPE = 'P';
		END;

		--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')------------------------------END

		-- 환산자 추출 로직 ======================================================================START
		-- 테이블중복제거
		-- 임시확인용테이블 중복제거
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
		DBMS_OUTPUT.PUT_LINE('환산자 추출 START--------------------------------------------------------------------------------------------------------------------------------------');

		-- 신규 로직으로 변경
		--BEGIN
		--	-- 1.프로젝트에 있는 ITEM을 CLASS별로 추출하여 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에 저장한다.
		--	SELECT ITEM_ID
		--		,CASE
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Pack') > 0
		--				THEN 'PACK'
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Module') > 0
		--				THEN 'MODULE'
		--			WHEN INSTR(ITEM_CLASS_NAME, 'Cell') > 0
		--				THEN 'CELL'
		--			ELSE ''
		--			END ITEM_CLASS
		--	INTO GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	FROM DM_MST_ITEM_SINGLE_V
		--	WHERE DIVISION_ID = '81'
		--		AND ITEM_ID IN (
		--			SELECT ITEM_ID
		--			FROM SCM_MST_PROJECT_ITEM
		--			WHERE PROJECT_CODE = p_PROJECT_CODE
		--				AND VALID_YN = 'Y'
		--			)
		--		AND ITEM_TYPE = 'P'
		--		AND ACTIVE_FLAG = 'Y'

		--	--SELECT * FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	-- 2. 임시테이블(GT_DMF0_ITEM_CLASS_IN_PROJECT)에서 PACK, MODULE, CELL 별로 수량을 파악한다.
		--	SELECT v_PACK_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'PACK'
		--	GROUP BY ITEM_CLASS

		--	SELECT v_MODULE_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'MODULE'
		--	GROUP BY ITEM_CLASS

		--	SELECT v_CELL_CNT = COUNT(1)
		--	FROM GT_DMF0_ITEM_CLASS_IN_PROJECT
		--	WHERE ITEM_CLASS = 'CELL'
		--	GROUP BY ITEM_CLASS

		--	PRINT TO_CHAR(v_PACK_CNT) + ' PACK'
		--	PRINT TO_CHAR(v_MODULE_CNT) + ' MODULE'
		--	PRINT TO_CHAR(v_CELL_CNT) + ' CELL'

		--	-- 3. 해당 프로젝트에서(GT_DMF0_ITEM_CLASS_IN_PROJECT)
		--	IF v_PACK_CNT > 0 -- PACK에 수량이 있으면 PACK 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_PACK'

		--		SELECT v_CELL_PER_PACK = CELL_PER_CAR
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_CAR

		--		v_TRANSLATOR := v_CELL_PER_PACK;
		--		v_REP_TRANSLATOR := 'PACK'
		--	END
		--	ELSE IF v_PACK_CNT = 0
		--		AND v_MODULE_CNT > 0 -- PACK에 수량이 없고 MODULE에 수량이 있으면 MODULE 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_MODULE'

		--		SELECT v_CELL_PER_MODULE = CELL_PER_MODULE
		--		FROM SCM_MST_SITE_ITEM
		--		WHERE PROJECT_CODE = p_PROJECT_CODE
		--			AND ITEM_ID IN (
		--				SELECT ITEM_ID
		--				FROM DM_MST_ITEM_SINGLE_V
		--				WHERE DIVISION_ID = '81'
		--					AND ITEM_ID IN (
		--						SELECT ITEM_ID
		--						FROM SCM_MST_PROJECT_ITEM
		--						WHERE PROJECT_CODE = p_PROJECT_CODE
		--							AND VALID_YN = 'Y'
		--						)
		--					AND ITEM_TYPE = 'P'
		--					AND ACTIVE_FLAG = 'Y'
		--				)
		--			AND VALID_YN = 'Y'
		--			AND CELL_PER_CAR IS NOT NULL
		--		GROUP BY CELL_PER_MODULE

		--		v_TRANSLATOR := v_CELL_PER_MODULE;
		--		v_REP_TRANSLATOR := 'MODULE'
		--	END
		--	ELSE IF v_PACK_CNT = 0
		--		AND v_MODULE_CNT = 0
		--		AND v_CELL_CNT > 0 -- PACK, MODULE에 수량이 없고 CELL에 수량이 있으면 CELL 기준을 사용
		--	BEGIN
		--		PRINT 'CELL_PER_CELL'

		--		SELECT v_CELL_PER_CELL = 1

		--		v_TRANSLATOR := v_CELL_PER_CELL;
		--		v_REP_TRANSLATOR := 'CELL'
		--	END
		--END
		-- 신규 로직으로 변경

		v_DIVISION_ID := p_division_id;
		v_PROJECT_CODE := p_project_code;

		DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID);
		DBMS_OUTPUT.PUT_LINE(v_PROJECT_CODE);

		BEGIN
			--SELECT AAAA.PROJECT_CODE, AAAA.ITEM_ID, AAAA.BIZ_TYPE FROM(
			SELECT AAAA.ITEM_ID, AAAA.BIZ_TYPE  INTO v_REP_ITEM_ID, v_REP_TRANSLATOR
			FROM(
			SELECT AAA.PROJECT_CODE, AAA.ITEM_ID
			, CASE WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AP' THEN 'PACK' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AM' THEN 'MODULE' WHEN SUBSTR(AAA.ITEM_ID, 1,2) = 'AC' THEN 'CELL' END BIZ_TYPE
			,  ROW_NUMBER() OVER (PARTITION BY AAA.PROJECT_CODE ORDER BY AAA.PROJECT_CODE, SUBSTR(AAA.ITEM_ID, 2,1) DESC) AS RNK FROM(
			SELECT AA.PROJECT_CODE, BB.ITEM_ID
			, CASE WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AP' THEN 3 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AM' THEN 2 WHEN SUBSTR(BB.ITEM_ID, 1,2) = 'AC' THEN 1 END RNK FROM
			(SELECT DISTINCT PROJECT_CODE FROM DM_ANL_MKT_PSI_DETAIL WHERE DIVISION_ID = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE) AA INNER JOIN
			(SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_ID
			FROM SCM_MST_SITE_ITEM A INNER JOIN DM_MST_ITEM_SINGLE_V B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID = B.ITEM_ID
			WHERE A.DIVISION_ID = v_DIVISION_ID AND A.VALID_YN = 'Y' AND B.ITEM_TYPE = 'P') BB
			ON AA.PROJECT_CODE = BB.PROJECT_CODE
			GROUP BY AA.PROJECT_CODE, BB.ITEM_ID
			) AAA
			) AAAA WHERE AAAA.RNK = 1
			ORDER BY AAAA.PROJECT_CODE, AAAA.ITEM_ID;
		END;

		SELECT CELL_CF INTO v_TRANSLATOR
		FROM SCP_MST_FINAL_ITEM
		WHERE ITEM_ID = v_REP_ITEM_ID;

		DBMS_OUTPUT.PUT_LINE(v_TRANSLATOR);
		DBMS_OUTPUT.PUT_LINE('환산자 추출 END--------------------------------------------------------------------------------------------------------------------------------------');
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		-- 환산자 추출 로직 ========================================================================END


		DBMS_OUTPUT.PUT_LINE('환산자');
		DBMS_OUTPUT.PUT_LINE('환산자 '  ||  v_REP_TRANSLATOR  ||  ' '  ||  TO_CHAR(v_TRANSLATOR));


		WHILE (LENGTH(p_qtycd3) > 0 AND v_mst_loop_cnt < v_max_loop_cnt)	LOOP
		BEGIN
			-- v_mst_loop_cnt 1증가
			v_mst_loop_cnt := v_mst_loop_cnt || 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				v_DIVISION_ID := p_division_id;
				--SELECT v_DIVISION_ID
				v_END_CUSTOMER := p_end_customer;
				--SELECT v_END_CUSTOMER
				v_PROJECT_CODE := p_project_code;
				--SELECT v_PROJECT_CODE
				v_YYYYMM := p_yyyymm;
				--SELECT v_YYYYMM
				--v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 1);
				--v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter , 2);
				v_CUST_FCST_M := p_cust_fcst_m;
				--SELECT v_CUST_FCST_M
				v_MEASURE := p_measure;
				--SELECT v_MEASURE
				v_QTYCD1 := SCM_ARR_SPL_VAL(p_qtycd1, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD1
				v_QTYCD2 := SCM_ARR_SPL_VAL(p_qtycd2, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD2
				v_QTYCD3 := SCM_ARR_SPL_VAL(p_qtycd3, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTYCD3
				v_SEQ := SCM_ARR_SPL_VAL(p_seq, v_delimiter, v_mst_loop_cnt);
				--SELECT v_SEQ
				v_QTY := SCM_ARR_SPL_VAL(p_qty, v_delimiter, v_mst_loop_cnt);
				--SELECT v_QTY
				v_MKT_FCST_M := p_mkt_fcst_m;
				--SELECT v_MKT_FCST_M
				v_DESC := SCM_ARR_SPL_VAL(p_desc, v_delimiter, v_mst_loop_cnt);
				--SELECT v_DESC
				v_INPUT_LIMIT := p_input_limit;
				--SELECT v_INPUT_LIMIT
				v_CREATED_BY := p_created_by;
				--SELECT v_CREATED_BY
				v_CREATION_DATE := SYSTIMESTAMP;
				--SELECT v_CREATION_DATE
				v_LAST_UPDATED_BY := p_created_by;
				--SELECT v_LAST_UPDATED_BY
				v_LAST_UPDATE_DATE := SYSTIMESTAMP;
					--SELECT v_LAST_UPDATE_DATE
			END;

			-- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start -----------------------------------------------
			IF v_DIVISION_ID = ''
				OR v_DIVISION_ID IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'DIVISION_ID 입력값을 확인하세요.' INTO v_err_message FROM DUAL;
				GOTO err_rtn;
			END IF;

			IF v_END_CUSTOMER = ''
				OR v_END_CUSTOMER IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'END_CUSTOMER 입력값을 확인하세요.' INTO v_err_message FROM DUAL;
				GOTO err_rtn;
			END IF;

			IF v_PROJECT_CODE = ''
				OR v_PROJECT_CODE IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'PROJECT_CODE 입력값을 확인하세요.' INTO v_err_message FROM DUAL;
				GOTO err_rtn;
			END IF;

			IF v_YYYYMM = '' OR v_YYYYMM IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'YYYYMM 입력값을 확인하세요.' INTO v_err_message FROM DUAL;
				GOTO err_rtn;
			END IF;

			v_description := v_err_message;

			/* =================================================
		   주석유지
		    =================================================*/
			/*
			IF v_CUST_FCST_M = '' OR v_CUST_FCST_M IS NULL
				BEGIN
					v_log_type := 'INVALID';
					SELECT 'Sold-To 입력값을 확인하세요.'
					v_description := 'Sold-To 입력값을 확인하세요.';
					goto err_rtn
				*/
			/* =================================================*/
			--IF SCM_ARR_SPL_CNT(p_cust_fcst_m, v_delimiter) = 2
			--	BEGIN
			--		v_CUST_FCST_M_PRE := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 1);
			--		v_CUST_FCST_M := SCM_ARR_SPL_VAL(p_cust_fcst_m, v_delimiter , 2);
			--	END
			-- 테이블중복제거
			-- 임시확인용테이블 중복제거
			EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_DM_MST_VERSION';

			--월의 첫날이 수요일인 경우 전달의 마지막 MKT_FCST Cutoff 일자를 사용한다.
			IF v_MEASURE = 'DP_INIT' THEN
				IF TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01', 'D') = '4' THEN
					v_0month_tuesday := TO_CHAR(/* TODO:DATEADD(WW,- 1,FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + '01', 'YYYYMMDD'), 'TUE')) */
						FN_NEXT_DAY(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) || '01', 'YYYYMMDD'), 'TUE') - (7 * (-1)), 'YYYYMMDD'
					);
				ELSE
					v_0month_tuesday := TO_CHAR(/* TODO:DATEADD(WK, DATEDIFF(WK, 0, DATEADD(DD, 5 - DATEPART(DAY, @v_yyyymm + '01'), @v_yyyymm + '01')), 1) */
						(v_yyyymm || '01' + (5 - EXTRACT(DAY FROM TO_DATE(v_yyyymm || '01', 'YYYYMMDD')))) + (1 * 7), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
				END IF;
			ELSIF TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01', 'D') = '4' THEN
				v_0month_tuesday := TO_CHAR(/* TODO:DATEADD(WW,- 1,FN_NEXT_DAY(DATEADD(MM, 1, TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6) + '01', 'YYYYMMDD')), 'TUE')) */
					FN_NEXT_DAY(ADD_MONTHS(TO_CHAR(SUBSTR(TO_CHAR(v_yyyymm, 'YYYYMMDD'), 1, 6)  ||  '01', 'YYYYMMDD'), 1), 'TUE'), 'YYYYMMDD');
			ELSE
				v_0month_tuesday := TO_CHAR(/* TODO:DATEDIFF(WK,0,DATEADD(DD, 5 - DATEPART(DAY, DATEADD(MM, 1, v_yyyymm + '01') */
				(ADD_MONTHS(v_yyyymm || '01', 1) + (5 - EXTRACT(DAY FROM ADD_MONTHS(v_yyyymm || '01', 1)))) + (1 * 7), 'YYYYMMDD'); --당월 첫번째 수요일이 포함된 주차의 MKT_FCST Cutoff
			END IF;

			BEGIN
				SELECT 	DMF0_DM_MST_VERSION_ROW (
					ROW_NUMBER() OVER (
						ORDER BY X.VERSION_NO
						)
					,X.VERSION_NO
					,X.VERSION_TYPE
				) BULK COLLECT INTO GT_DMF0_DM_MST_VERSION
				FROM (
					SELECT ROW_NUMBER() OVER (
							PARTITION BY A.VERSION_TYPE ORDER BY A.VERSION_NO DESC
							) AS RNK
						,A.VERSION_NO
						,A.VERSION_TYPE
					FROM DM_MST_VERSION A
					JOIN SCM_SYS_CALENDAR_M B  ON A.YYYYMMDD = B.BASIS_YYYYMMDD
					WHERE 1 = 1
						AND A.DIVISION_ID = p_division_id
						AND A.VERSION_TYPE = 'MF_W' --MKT_FCST Weekly Cutoff
						AND A.YYYYMMDD = v_0month_tuesday
					) X
				WHERE RNK = 1;
			END;

			--SCM_MST_SITE 대상건만 추출(end_customer)
		    BEGIN
			    /* TODO:GTT:GT_DMF0_SCM_MST_SITE-->GT_DMF0_SCM_MST_SITE */
			    SELECT SCM_MST_SITE_ROW(DIVISION_ID, SCM_SITE_ID, END_CUSTOMER)
			    BULK COLLECT INTO GT_DMF0_SCM_MST_SITE
		    	FROM SCM_MST_SITE
		    	WHERE DIVISION_ID  = p_division_id
	              AND END_CUSTOMER = p_end_customer;
	    	END;


			--IF v_CUST_FCST_M_PRE = '' OR v_CUST_FCST_M_PRE IS NULL OR v_CUST_FCST_M_PRE = '0'
			--	BEGIN
			--		SELECT v_CUST_FCST_M_PRE = (A_QTY + B_QTY)
			--		FROM (
			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS A_QTY
			--					FROM DM_PLN_MKT_FCST_C X
			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
			--					WHERE 1=1
			--					AND X.DIVISION_ID = p_division_id
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			--					AND PROJECT_CODE = p_project_code
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
			--					AND QTY <> 0
			--					) A,
			--					(
			--					SELECT NVL(CEILING(SUM(QTY)), 0) AS B_QTY
			--					FROM DM_PLN_MKT_FCST_RESULT_C X
			--					JOIN GT_DMF0_DM_MST_VERSION Y  ON X.VERSION_NO = Y.VERSION_NO
			--					WHERE 1=1
			--					AND X.DIVISION_ID = p_division_id
			--					AND MEASURE IN ('CUST_FCST_EDI', 'CUST_FCST')
			--					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
			--					AND PROJECT_CODE = p_project_code
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND ITEM_ID IN (SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V)
			--					AND X.FCST_TYPE = 'MPS'
			--					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
			--					AND SUBSTR(YYYYMMDD, 1, 6) = v_yyyymm
			--					) B
			--	END
			IF v_CUST_FCST_M = '' OR v_CUST_FCST_M IS NULL OR v_CUST_FCST_M = '0' THEN
				IF v_MEASURE = 'DP_INIT' THEN
					SELECT (A_QTY || B_QTY) INTO v_CUST_FCST_M
					FROM (
						SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X
						JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y
						  ON X.VERSION_NO = Y.VERSION_NO
						JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
						  	ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
						WHERE 1 = 1
							AND X.DIVISION_ID = p_division_id
							AND X.MEASURE IN (
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
							AND X.PROJECT_CODE = p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
							AND X.QTY <> 0
						) A
						,(
							SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y  ON X.VERSION_NO = Y.VERSION_NO
						    JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE IN (
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = v_yyyymm
							) B;
				ELSE
					SELECT (A_QTY || B_QTY) INTO v_CUST_FCST_M
					FROM (
						SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
						FROM DM_PLN_MKT_FCST_C X
						JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y  ON X.VERSION_NO = Y.VERSION_NO
					    JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
						     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
						WHERE 1 = 1
							AND X.DIVISION_ID = p_division_id
							AND X.MEASURE IN (
								'CUST_FCST_EDI'
								,'CUST_FCST'
								)
							--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
							AND X.PROJECT_CODE = p_project_code
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND X.ITEM_ID IN (
								SELECT ITEM_ID
								FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
								)
							AND X.FCST_TYPE = 'MPS'
							--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
							AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
							AND X.QTY <> 0
						) A
						,(
							SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
							FROM DM_PLN_MKT_FCST_RESULT_C X
							JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y  ON X.VERSION_NO = Y.VERSION_NO
						    JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
							     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
							WHERE 1 = 1
								AND X.DIVISION_ID = p_division_id
								AND X.MEASURE IN (
									'CUST_FCST_EDI'
									,'CUST_FCST'
									)
								--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
								AND X.PROJECT_CODE = p_project_code
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND X.ITEM_ID IN (
									SELECT ITEM_ID
									FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
									)
								AND X.FCST_TYPE = 'MPS'
								--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
								AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
							) B;
				END IF;
			END IF;

			IF v_MEASURE = '' OR v_MEASURE IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'MEASURE 입력값을 확인하세요.' INTO v_err_message
				FROM DUAL;

				GOTO err_rtn;
			END IF;

			IF v_QTYCD1 = '' OR v_QTYCD1 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD1 입력값을 확인하세요.' INTO v_err_message
				FROM DUAL;

				GOTO err_rtn;
			END IF;

			IF v_QTYCD2 = '' OR v_QTYCD2 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD2 입력값을 확인하세요.' INTO v_err_message
				FROM DUAL;

				GOTO err_rtn;
			END IF;

			IF v_QTYCD3 = '' OR v_QTYCD3 IS NULL THEN
				v_log_type := 'INVALID';

				SELECT 'QTYCD3 입력값을 확인하세요.' INTO v_err_message
				FROM DUAL;

				GOTO err_rtn;
			END IF;

			v_description := v_err_message;

			IF v_SEQ = '' OR v_SEQ IS NULL THEN
				SELECT MAX(SEQ) || 1 INTO v_SEQ
				FROM DM_ANL_MKT_PSI_DETAIL
				WHERE DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = p_end_customer
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM
					--AND CUST_FCST_M = v_CUST_FCST_M
					AND MEASURE = v_MEASURE
					AND QTYCD1 = v_QTYCD1
					AND QTYCD2 = v_QTYCD2
					AND QTYCD3 = v_QTYCD3;
			END IF;

			DBMS_OUTPUT.PUT_LINE('INSERT INTO 1------------------------------------------------------------------------------------------------------------------------------------------------------------');

			IF v_mst_loop_cnt > 0 THEN
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
					,"DESC"
					,INPUT_LIMIT
					,CUST_FCST_M_CELL
					,QTY_CELL
					,MKT_FCST_M_CELL
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					)
				SELECT v_DIVISION_ID
					,v_END_CUSTOMER
					,v_PROJECT_CODE
					,v_YYYYMM
					,v_CUST_FCST_M AS CUST_FCST_M
					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN v_CUST_FCST_M
					--       WHEN v_MEASURE = 'DP_RESULT' THEN v_CUST_FCST_M_PRE END AS CUST_FCST_M
					,v_MEASURE
					,v_QTYCD1
					,v_QTYCD2
					,v_QTYCD3
					,v_SEQ
					,NVL(v_QTY, 0)
					,NVL(v_MKT_FCST_M, 0)
					,v_DESC
					,v_INPUT_LIMIT
					,TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR AS CUST_FCST_M_CELL
					--, CASE WHEN v_MEASURE = 'DP_INIT' THEN TO_NUMBER(NVL(v_CUST_FCST_M, 0)) * v_TRANSLATOR
					--       WHEN v_MEASURE = 'DP_RESULT' THEN TO_NUMBER(NVL(v_CUST_FCST_M_PRE, 0)) * v_TRANSLATOR END AS CUST_FCST_M_CELL
					,TO_NUMBER(NVL(v_QTY, 0)) * v_TRANSLATOR AS QTY_CELL
					,NVL(v_MKT_FCST_M, 0) * v_TRANSLATOR AS MKT_FCST_M_CELL
					,v_CREATED_BY
					,SYSTIMESTAMP
					,v_LAST_UPDATED_BY
					,SYSTIMESTAMP
				FROM DUAL;
			END IF;

			DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

			<<err_rtn>>
			IF v_log_type = 'INVALID' THEN
				v_log_message := '########## END of procedure ##########';
				d_event_date := SYSTIMESTAMP;

				PR_SCM_SYS_LOG_BATCH(v_program_name
					,v_log_type
					,n_log_count
					,v_log_message
					,v_description
					,d_event_date
					);
				-- 종료 LOG
				v_log_type := 'END';
				v_log_message := '########## END of procedure ##########';
				v_description := NULL;
				d_event_date := SYSTIMESTAMP;

				PR_SCM_SYS_LOG_BATCH(v_program_name
					,v_log_type
					,n_log_count
					,v_log_message
					,v_description
					,d_event_date
					);
			END IF;
		END;

		--RESULT등록시 신규월 EDI 수량
		BEGIN
			SELECT (A_QTY  ||  B_QTY) INTO v_CUST_FCST_M_PRE
	 		FROM (
				SELECT NVL(CEIL(SUM(X.QTY)), 0) AS A_QTY
				FROM DM_PLN_MKT_FCST_C X
				JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y  ON X.VERSION_NO = Y.VERSION_NO
			    JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
				     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
				WHERE 1 = 1
					AND X.DIVISION_ID = p_division_id
					AND X.MEASURE IN (
						'CUST_FCST_EDI'
						,'CUST_FCST'
						)
					--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
					AND X.PROJECT_CODE = p_project_code
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND X.ITEM_ID IN (
						SELECT ITEM_ID
						FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
						)
					AND X.FCST_TYPE = 'MPS'
					--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
					AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
					AND QTY <> 0
				) A
				,(
					SELECT NVL(CEIL(SUM(X.QTY)), 0) AS B_QTY
					FROM DM_PLN_MKT_FCST_RESULT_C X
					JOIN TABLE(GT_DMF0_DM_MST_VERSION) Y  ON X.VERSION_NO = Y.VERSION_NO
				    JOIN TABLE(GT_DMF0_SCM_MST_SITE) Z
					     ON X.DIVISION_ID = Z.DIVISION_ID AND  X.SCM_SITE_ID = Z.SCM_SITE_ID
					WHERE 1 = 1
						AND X.DIVISION_ID = p_division_id
						AND X.MEASURE IN (
							'CUST_FCST_EDI'
							,'CUST_FCST'
							)
						--AND PROJECT_CODE IN (SELECT * FROM GT_DMF0_PROJECT_CODE)
						AND X.PROJECT_CODE = p_project_code
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND X.ITEM_ID IN (
							SELECT ITEM_ID
							FROM GT_DMF0_DM_MST_ITEM_SINGLE_V
							)
						AND X.FCST_TYPE = 'MPS'
						--DP, CF값 송출 기준 변경(ITEM_TYPE이 'P', FCST_TYPE이 'MASS')----------------------------------------------------
						AND SUBSTR(X.YYYYMMDD, 1, 6) = TO_CHAR(ADD_MONTHS(TO_DATE((v_yyyymm || '01')), 1), 'YYYYMMDD')
					) B;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		-- MASTER 테이블(DM_ANL_MKT_PSI) 데이터 입력
		BEGIN
			IF v_MEASURE = 'DP_INIT' THEN
				DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-0------------------------------------------------------------------------------------------------------------------------------------------------------------');
				DBMS_OUTPUT.PUT_LINE(v_DIVISION_ID  ||  ' /// '  ||  v_PROJECT_CODE  ||  ' /// '  ||  v_YYYYMM  ||  ' /// '  ||  v_MEASURE);

				SELECT COUNT(*) INTO v_CNT
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM
					AND MEASURE = v_MEASURE;

				DBMS_OUTPUT.PUT_LINE(v_CNT);

				IF v_CNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 존재]------------------------------------------------------------------------------------------------------------------------------------------');

					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE IN (v_MEASURE);
					END;

					BEGIN
						SELECT DM_ANL_MKT_PSI_ROW(
								T1.DIVISION_ID
								,T1.END_CUSTOMER
								,T1.PROJECT_CODE
								,T1.YYYYMM
								,T1.CUST_FCST_M
								,T1.MEASURE
								,NVL(CEIL(T1.P_VALUE), 0)
								,NVL(CEIL(T1.S_VALUE), 0)
								,NVL(CEIL(T1.I_VALUE), 0)
								,NVL(CEIL(T1.V_VALUE), 0)
								,NVL(CEIL(T1.M_VALUE), 0)
								,NVL(CEIL(T1.CUST_FCST_M - (CEIL(T1.P_VALUE)  ||  CEIL(T1.S_VALUE)  ||  CEIL(T1.I_VALUE)  ||  CEIL(T1.V_VALUE)  ||  CEIL(T1.M_VALUE)  ||  CEIL(T1.CP_VALUE))), 0)
								,''
								,''
								,NVL(CEIL(T1.CUST_FCST_M * v_TRANSLATOR), 0)
								,NVL(CEIL(T1.P_VALUE * v_TRANSLATOR), 0)
								,NVL(CEIL(T1.S_VALUE * v_TRANSLATOR), 0)
								,NVL(CEIL(T1.I_VALUE * v_TRANSLATOR), 0)
								,NVL(CEIL(T1.V_VALUE * v_TRANSLATOR), 0)
								,NVL(CEIL(T1.M_VALUE * v_TRANSLATOR), 0)
								,NVL(CEIL(CEIL(T1.CUST_FCST_M - (CEIL(T1.P_VALUE)  ||  CEIL(T1.S_VALUE)  ||  CEIL(T1.I_VALUE)  ||  CEIL(T1.V_VALUE)  ||  CEIL(T1.M_VALUE)  ||  CEIL(T1.CP_VALUE))) * v_TRANSLATOR), 0)
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,NVL(CEIL(T1.CP_VALUE), 0)
								,NVL(CEIL(T1.CP_VALUE * v_TRANSLATOR), 0)
							)
							BULK COLLECT INTO GT_DMF0_DM_ANL_MKT_PSI
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,SUM(PRODUCT) AS P_VALUE
								,SUM(SALES) AS S_VALUE
								,SUM(INVENTORY) AS I_VALUE
								,SUM(VPA) AS V_VALUE
								,SUM(MODELMIX) AS M_VALUE
								,SUM(SUPPLYISSUE) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										'PRODUCT' AS PRODUCT
										,'SALES' AS SALES
										,'INVENTORY' AS INVENTORY
										,'VPA' AS VPA
										,'MODELMIX' AS MODELMIX
										,'SUPPLYISSUE' AS SUPPLYISSUE
										)) PVT
							WHERE 1 = 1
								AND DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND YYYYMM = v_YYYYMM
								AND MEASURE = v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1;

						SELECT '1', A.*
								BULK COLLECT INTO V_RES_RESULT
						FROM TABLE(GT_DMF0_DM_ANL_MKT_PSI) A;
					END;
				ELSE  -- 수요계획(1st)가 존재하지 않을 시 INSERT ALL(해당월 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 2-1[수요계획(1ST) 미존재]----------------------------------------------------------------------------------------------------------------------------------------');

					BEGIN -- 수요계획(1ST)가 없으면 나머지 MEASURE 데이터도 의미가 없으므로 삭제
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM;
					END;

					BEGIN
						SELECT DM_ANL_MKT_PSI_ROW(
							DIVISION_ID,
							END_CUSTOMER,
							PROJECT_CODE,
							YYYYMM,
							CUST_FCST_M,
							MEASURE,
							P_VALUE,
							S_VALUE,
							I_VALUE,
							V_VALUE,
							M_VALUE,
							MKT_FCST_M,
							'',
							'',
							CUST_FCST_M_CELL,
							P_VALUE_CELL,
							S_VALUE_CELL,
							I_VALUE_CELL,
							V_VALUE_CELL,
							M_VALUE_CELL,
							MKT_FCST_M_CELL,
							CREATED_BY,
							CREATION_DATE,
							LAST_UPDATED_BY,
							LAST_UPDATE_DATE,
							CP_VALUE,
							CP_VALUE_CELL
						) BULK COLLECT INTO GT_DMF0_DM_ANL_MKT_PSI
						FROM (
							SELECT v_DIVISION_ID AS DIVISION_ID
									,v_END_CUSTOMER AS END_CUSTOMER
									,v_PROJECT_CODE AS PROJECT_CODE
									,v_YYYYMM AS YYYYMM
									,CEIL(v_CUST_FCST_M) AS CUST_FCST_M
									,'AN_LOGIC' AS MEASURE
									,0 AS P_VALUE--P_VALUE
									,0 AS S_VALUE --S_VALUE
									,0 AS I_VALUE --I_VALUE
									,0 AS V_VALUE--V_VALUE
									,0 AS M_VALUE--M_VALUE
									,0 AS MKT_FCST_M--MKT_FCST_M
									,0 AS CUST_FCST_M_CELL --CUST_FCST_M_CELL
									,0 AS P_VALUE_CELL --P_VALUE_CELL
									,0 AS S_VALUE_CELL--S_VALUE_CELL
									,0 AS I_VALUE_CELL--I_VALUE_CELL
									,0 AS V_VALUE_CELL--V_VALUE_CELL
									,0 AS M_VALUE_CELL--M_VALUE_CELL
									,0 AS MKT_FCST_M_CELL--MKT_FCST_M_CELL
									,v_CREATED_BY AS CREATED_BY
									,SYSTIMESTAMP AS CREATION_DATE
									,v_LAST_UPDATED_BY AS LAST_UPDATED_BY
									,SYSTIMESTAMP AS LAST_UPDATE_DATE
									,0 AS CP_VALUE--CP_VALUE
									,0 AS CP_VALUE_CELL--CP_VALUE_CELL
								--AN_RESULT[분석로직(%)*고객수요계획]
								FROM DUAL

							UNION ALL

							SELECT v_DIVISION_ID
								,v_END_CUSTOMER
								,v_PROJECT_CODE
								,v_YYYYMM
								,CEIL(v_CUST_FCST_M)
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
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,0 --CP_VALUE
								,0 --CP_VALUE_CELL
							FROM DUAL
							UNION ALL

							--DP_INIT
							SELECT T1.DIVISION_ID
								,T1.END_CUSTOMER
								,T1.PROJECT_CODE
								,T1.YYYYMM
								,T1.CUST_FCST_M
								,T1.MEASURE
								,NVL(CEIL(T1.P_VALUE), 0)
								,NVL(CEIL(T1.S_VALUE), 0)
								,NVL(CEIL(T1.I_VALUE), 0)
								,NVL(CEIL(T1.V_VALUE), 0)
								,NVL(CEIL(T1.M_VALUE), 0)
								,NVL(CEIL(T1.CUST_FCST_M - (CEIL(T1.P_VALUE)  ||  CEIL(T1.S_VALUE)  ||  CEIL(T1.I_VALUE)  ||  CEIL(T1.V_VALUE)  ||  CEIL(T1.M_VALUE)  ||  CEIL(T1.CP_VALUE))), 0) AS MKT_FCST_M
								,NVL(CEIL(T1.CUST_FCST_M * v_TRANSLATOR), 0) AS CUST_FCST_M_CELL
								,NVL(CEIL(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALUE_CELL
								,NVL(CEIL(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALUE_CELL
								,NVL(CEIL(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALUE_CELL
								,NVL(CEIL(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALUE_CELL
								,NVL(CEIL(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALUE_CELL
								,NVL(CEIL(CEIL(T1.CUST_FCST_M - (CEIL(T1.P_VALUE)  ||  CEIL(T1.S_VALUE)  ||  CEIL(T1.I_VALUE)  ||  CEIL(T1.V_VALUE)  ||  CEIL(T1.M_VALUE)  ||  CEIL(T1.CP_VALUE))) * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,NVL(CEIL(T1.CP_VALUE), 0)
								,NVL(CEIL(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALUE_CELL
							FROM (
								SELECT DIVISION_ID
									,END_CUSTOMER
									,PROJECT_CODE
									,YYYYMM
									,CUST_FCST_M
									,MEASURE
									,SUM(PRODUCT) AS P_VALUE
									,SUM(SALES) AS S_VALUE
									,SUM(INVENTORY) AS I_VALUE
									,SUM(VPA) AS V_VALUE
									,SUM(MODELMIX) AS M_VALUE
									,SUM(SUPPLYISSUE) AS CP_VALUE
								FROM DM_ANL_MKT_PSI_DETAIL
								PIVOT(SUM(QTY) FOR QTYCD3 IN (
											'PRODUCT' AS PRODUCT
											,'SALES' AS SALES
											,'INVENTORY' AS INVENTORY
											,'VPA' AS VPA
											,'MODELMIX' AS MODELMIX
											,'SUPPLYISSUE' AS SUPPLYISSUE
											)) PVT
								WHERE 1 = 1
									AND DIVISION_ID = v_DIVISION_ID
									AND END_CUSTOMER = v_END_CUSTOMER
									AND PROJECT_CODE = v_PROJECT_CODE
									AND YYYYMM = v_YYYYMM
									AND MEASURE = v_MEASURE
								GROUP BY DIVISION_ID
									,END_CUSTOMER
									,PROJECT_CODE
									,YYYYMM
									,CUST_FCST_M
									,MEASURE
								) T1

							UNION ALL

							-- DP_RESULT
							SELECT v_DIVISION_ID
								,v_END_CUSTOMER
								,v_PROJECT_CODE
								,v_YYYYMM
								,CEIL(v_CUST_FCST_M)
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
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,0 --CP_VALUE
								,0 --CP_VALUE_CELL
							FROM DUAL
						) X;
					END;
				END IF;
			ELSE  -- 수요계획(Result) 저장
				-- 수요계획(Result) 다음달 데이터 등록여부확인(다음달 데이터 첫등록여부 확인을 위함)
				SELECT COUNT(*) INTO v_CNT
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					--AND YYYYMM = v_YYYYMM
					AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
					AND MEASURE = v_MEASURE;

				-- 수요계획(Result) 당월 분석로직/분석결과/DPINIT이 존재하지않을 시
				SELECT COUNT(*) INTO v_CNT_PRE
				FROM DM_ANL_MKT_PSI
				WHERE 1 = 1
					AND DIVISION_ID = v_DIVISION_ID
					AND END_CUSTOMER = v_END_CUSTOMER
					AND PROJECT_CODE = v_PROJECT_CODE
					AND YYYYMM = v_YYYYMM;

				IF v_CNT_PRE = 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3[수요계획(Result) 저장, 당월 분석로직/분석결과/DPINIT 미존재]----------------------------------------------------------------------------------------------------');

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
					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEIL(v_CUST_FCST_M)
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
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					--AN_RESULT[분석로직(%)*고객수요계획]
					FROM DUAL

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEIL(v_CUST_FCST_M)
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
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					-- DP_INIT
					FROM DUAL

					UNION ALL

					SELECT v_DIVISION_ID
						,v_END_CUSTOMER
						,v_PROJECT_CODE
						,v_YYYYMM
						,CEIL(v_CUST_FCST_M)
						,'DP_INIT'
						,0 --P_VALUE
						,0 --S_VALUE
						,0 --I_VALUE
						,0 --V_VALUE
						,0 --M_VALUE
						,CEIL(v_MKT_FCST_M) --MKT_FCST_M
						,0 --CUST_FCST_M_CELL
						,0 --P_VALUE_CELL
						,0 --S_VALUE_CELL
						,0 --I_VALUE_CELL
						,0 --V_VALUE_CELL
						,0 --M_VALUE_CELL
						,0 --MKT_FCST_M_CELL
						,v_CREATED_BY
						,SYSTIMESTAMP
						,v_LAST_UPDATED_BY
						,SYSTIMESTAMP
						,0 --CP_VALUE
						,0 --CP_VALUE_CELL
					FROM DUAL;
				END IF;

				BEGIN -- 분석로직 임시테이블 저장(BEGIN~END)
					-- 테이블중복제거
					-- 해당월의 다음달 데이터 분석로직 데이터 저장
					SELECT DM_ANL_MKT_PSI_ROW(
							v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							,CEIL(v_CUST_FCST_M)
							,'AN_LOGIC'
							,NVL(CEIL(B.P_QTY / A.EDI_QTY), 0)
							,NVL(CEIL(B.S_QTY / A.EDI_QTY), 0)
							,NVL(CEIL(B.I_QTY / A.EDI_QTY), 0)
							,NVL(CEIL(B.V_QTY / A.EDI_QTY), 0)
							,NVL(CEIL(B.M_QTY / A.EDI_QTY), 0)
							,0
							,''
							,''
							,CEIL(v_CUST_FCST_M * v_TRANSLATOR)
							,NVL(CEIL(B.P_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							,NVL(CEIL(B.S_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							,NVL(CEIL(B.I_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							,NVL(CEIL(B.V_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							,NVL(CEIL(B.M_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							,0
							,''
							,NULL
							,''
							,NULL
							,NVL(CEIL(B.CP_QTY / A.EDI_QTY), 0)
							,NVL(CEIL(B.CP_QTY / A.EDI_QTY) * v_TRANSLATOR, 0)
							)
							BULK COLLECT INTO GT_DMF0_AN_LOGIC
					FROM (
						SELECT SUM(QTY) AS EDI_QTY
						FROM DM_PLN_MKT_FCST
						WHERE DIVISION_ID = v_DIVISION_ID
							AND PROJECT_CODE = v_PROJECT_CODE
							AND MEASURE IN (
								'CUST_FCST'
								,'CUST_FCST_EDI'
								)
							AND YYYYMMDD >= (TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD') || '01')
							AND YYYYMMDD <= TO_CHAR(LAST_DAY(SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)  ||  '01'), 'YYYYMMDD')
						) A
						,(
							SELECT SUM(P_VALUE) AS P_QTY
								,SUM(S_VALUE) AS S_QTY
								,SUM(I_VALUE) AS I_QTY
								,SUM(V_VALUE) AS V_QTY
								,SUM(M_VALUE) AS M_QTY
								,SUM(CP_VALUE) AS CP_QTY
							FROM DM_ANL_MKT_PSI
							WHERE DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND MEASURE = 'DP_RESULT'
								AND YYYYMM >= SUBSTR(TO_CHAR(ADD_MONTHS(SYSDATE, (- 1)*12), 'YYYYMMDD'), 1, 6)
								AND YYYYMM <= SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD'), 1, 6)
							) B;
				END;

				IF v_CNT > 0 THEN
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 저장, 수요계획(Result)가 존재시 DPINIT 만 나머지 삭제]----------------------------------------------------------------------------------------');

					-- 분석로직, 분석결과는 해당월의 다음달 데이터 삭제, 수요계획(Result)는 해당월 데이터 삭제
					BEGIN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							AND MEASURE IN ('AN_LOGIC', 'AN_RESULT');

						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE = 'DP_RESULT';
					END;

					-- DM_ANL_MKT_PSI 데이터 저장
					BEGIN
						SELECT DM_ANL_MKT_PSI_ROW(
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
							,''
							,''
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
							) BULK COLLECT INTO GT_DMF0_DM_ANL_MKT_PSI
						--AN_LOGIC
						FROM (
							SELECT
								DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,TO_NUMBER(v_CUST_FCST_M_PRE) AS CUST_FCST_M
								,MEASURE
								,NVL(P_VALUE, 0) AS P_VALUE
								,NVL(S_VALUE, 0) AS S_VALUE
								,NVL(I_VALUE, 0) AS I_VALUE
								,NVL(V_VALUE, 0) AS V_VALUE
								,NVL(M_VALUE, 0) AS M_VALUE
								,NVL(MKT_FCST_M, 0) AS MKT_FCST_M
								,NVL(CUST_FCST_M_CELL, 0) AS CUST_FCST_M_CELL
								,NVL(P_VALUE_CELL, 0) AS P_VALUE_CELL
								,NVL(S_VALUE_CELL, 0) AS S_VALUE_CELL
								,NVL(I_VALUE_CELL, 0) AS I_VALUE_CELL
								,NVL(V_VALUE_CELL, 0) AS V_VALUE_CELL
								,NVL(M_VALUE_CELL, 0) AS M_VALUE_CELL
								,NVL(MKT_FCST_M_CELL, 0) AS MKT_FCST_M_CELL
								,v_CREATED_BY AS CREATED_BY
								,SYSTIMESTAMP AS CREATION_DATE
								,v_LAST_UPDATED_BY AS LAST_UPDATED_BY
								,SYSTIMESTAMP AS LAST_UPDATE_DATE
								,NVL(CP_VALUE, 0) AS CP_VALUE
								,NVL(CP_VALUE_CELL, 0) AS CP_VALUE_CELL
							FROM TABLE(GT_DMF0_AN_LOGIC)
							--AN_RESULT[분석로직(%)*고객수요계획]

							UNION ALL

							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,TO_NUMBER(v_CUST_FCST_M_PRE)
								,'AN_RESULT'
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) - (CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
								,CUST_FCST_M_CELL
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) - (CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
								,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
							FROM TABLE(GT_DMF0_AN_LOGIC)
							-- DP_RESULT

							UNION ALL

							SELECT T1.DIVISION_ID
								,T1.END_CUSTOMER
								,T1.PROJECT_CODE
								,T1.YYYYMM
								,T1.CUST_FCST_M
								,T1.MEASURE
								,NVL(CEIL(T1.P_VALUE), 0)
								,NVL(CEIL(T1.S_VALUE), 0)
								,NVL(CEIL(T1.I_VALUE), 0)
								,NVL(CEIL(T1.V_VALUE), 0)
								,NVL(CEIL(T1.M_VALUE), 0)
								,NVL(CEIL(T1.MKT_FCST_M), 0) AS MKT_FCST_M
								,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
								,NVL(CEIL(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
								,NVL(CEIL(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
								,NVL(CEIL(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
								,NVL(CEIL(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
								,NVL(CEIL(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
								,NVL(CEIL(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
								,v_CREATED_BY
								,SYSTIMESTAMP
								,v_LAST_UPDATED_BY
								,SYSTIMESTAMP
								,NVL(CEIL(T1.CP_VALUE), 0)
								,NVL(CEIL(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
							FROM (
								SELECT DIVISION_ID
									,END_CUSTOMER
									,PROJECT_CODE
									,YYYYMM
									,CUST_FCST_M
									,MEASURE
									,MKT_FCST_M
									,SUM(PRODUCT) AS P_VALUE
									,SUM(SALES) AS S_VALUE
									,SUM(INVENTORY) AS I_VALUE
									,SUM(VPA) AS V_VALUE
									,SUM(MODELMIX) AS M_VALUE
									,SUM(SUPPLYISSUE) AS CP_VALUE
								FROM DM_ANL_MKT_PSI_DETAIL
								PIVOT (SUM(QTY) FOR QTYCD3 IN (
											'PRODUCT' AS PRODUCT
											,'SALES' AS SALES
											,'INVENTORY' AS INVENTORY
											,'VPA' AS VPA
											,'MODELMIX' AS MODELMIX
											,'SUPPLYISSUE' AS SUPPLYISSUE
											)) PVT
								WHERE 1 = 1
									AND DIVISION_ID = v_DIVISION_ID
									AND END_CUSTOMER = v_END_CUSTOMER
									AND PROJECT_CODE = v_PROJECT_CODE
									AND YYYYMM = v_YYYYMM
									AND MEASURE = v_MEASURE
								GROUP BY DIVISION_ID
									,END_CUSTOMER
									,PROJECT_CODE
									,YYYYMM
									,CUST_FCST_M
									,MEASURE
									,MKT_FCST_M
								) T1
							);
					END;

					SELECT '3', A.*
						BULK COLLECT INTO V_RES_RESULT
					FROM TABLE(GT_DMF0_DM_ANL_MKT_PSI) A;
				ELSE  -- 수요계획(Result)가 존재하지 않을 시 INSERT ALL(해당월의 다음달 첫 등록 시 나머지 MEASURE DEFAULT 값 처리)
					DBMS_OUTPUT.PUT_LINE('INSERT INTO 3-1[수요계획(Result) 미존재]----------------------------------------------------------------------------------------');

					IF v_CNT_PRE > 0 THEN
						DELETE
						FROM DM_ANL_MKT_PSI
						WHERE 1 = 1
							AND DIVISION_ID = v_DIVISION_ID
							AND END_CUSTOMER = v_END_CUSTOMER
							AND PROJECT_CODE = v_PROJECT_CODE
							AND YYYYMM = v_YYYYMM
							AND MEASURE = 'DP_RESULT';
					END IF;

					SELECT  DM_ANL_MKT_PSI_ROW(
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
						,''
						,''
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
						) BULK COLLECT INTO GT_DMF0_DM_ANL_MKT_PSI
					FROM (
						--AN_LOGIC
					SELECT DIVISION_ID
						,END_CUSTOMER
						,PROJECT_CODE
						--, YYYYMM
						,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD') AS YYYYMM
						,CEIL(v_CUST_FCST_M_PRE) AS CUST_FCST_M
						,MEASURE
						,NVL(P_VALUE, 0) AS P_VALUE
						,NVL(S_VALUE, 0) AS S_VALUE
						,NVL(I_VALUE, 0) AS I_VALUE
						,NVL(V_VALUE, 0) AS V_VALUE
						,NVL(M_VALUE, 0) AS M_VALUE
						,NVL(MKT_FCST_M, 0) AS MKT_FCST_M
						,CUST_FCST_M_CELL
						,NVL(P_VALUE_CELL, 0) AS P_VALUE_CELL
						,NVL(S_VALUE_CELL, 0) AS S_VALUE_CELL
						,NVL(I_VALUE_CELL, 0) AS I_VALUE_CELL
						,NVL(V_VALUE_CELL, 0) AS V_VALUE_CELL
						,NVL(M_VALUE_CELL, 0) AS M_VALUE_CELL
						,NVL(MKT_FCST_M_CELL, 0) AS MKT_FCST_M_CELL
						,v_CREATED_BY AS CREATED_BY
						,SYSTIMESTAMP AS CREATION_DATE
						,v_LAST_UPDATED_BY AS LAST_UPDATED_BY
						,SYSTIMESTAMP AS LAST_UPDATE_DATE
						,NVL(CP_VALUE, 0) AS CP_VALUE
						,NVL(CP_VALUE_CELL, 0) AS CP_VALUE_CELL
					FROM TABLE(GT_DMF0_AN_LOGIC)
					--AN_RESULT[분석로직(%)*고객수요계획]

					UNION ALL

					SELECT DIVISION_ID
							,END_CUSTOMER
							,PROJECT_CODE
							--, YYYYMM
							,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							,CEIL(v_CUST_FCST_M_PRE)
							,'AN_RESULT'
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) - (CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(P_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(S_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(I_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(V_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(M_VALUE) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100))), 0)
							,CUST_FCST_M_CELL
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) - (CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(P_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(S_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(I_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(V_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(M_VALUE_CELL) / 100)  ||  CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100))), 0)
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M) * TO_NUMBER(CP_VALUE) / 100), 0)
							,NVL(CEIL(TO_NUMBER(CUST_FCST_M_CELL) * TO_NUMBER(CP_VALUE_CELL) / 100), 0)
						FROM TABLE(GT_DMF0_AN_LOGIC)

						UNION ALL

						SELECT v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							,CEIL(v_CUST_FCST_M_PRE)
							,'DP_INIT'
							,0
							,0
							,0
							,0
							,0
							,CEIL(v_MKT_FCST_M)
							,CEIL(v_CUST_FCST_M_CELL)
							,0
							,0
							,0
							,0
							,0
							,CEIL(v_MKT_FCST_M_CELL)
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,0
							,0
						FROM DUAL
						UNION ALL

						SELECT T1.DIVISION_ID
							,T1.END_CUSTOMER
							,T1.PROJECT_CODE
							,T1.YYYYMM
							,T1.CUST_FCST_M
							,T1.MEASURE
							,NVL(CEIL(T1.P_VALUE), 0)
							,NVL(CEIL(T1.S_VALUE), 0)
							,NVL(CEIL(T1.I_VALUE), 0)
							,NVL(CEIL(T1.V_VALUE), 0)
							,NVL(CEIL(T1.M_VALUE), 0)
							,NVL(CEIL(T1.MKT_FCST_M), 0) AS MKT_FCST_M
							,T1.CUST_FCST_M * v_TRANSLATOR AS CUST_FCST_M_CELL
							,NVL(CEIL(T1.P_VALUE * v_TRANSLATOR), 0) AS P_VALU_CELL
							,NVL(CEIL(T1.S_VALUE * v_TRANSLATOR), 0) AS S_VALU_CELL
							,NVL(CEIL(T1.I_VALUE * v_TRANSLATOR), 0) AS I_VALU_CELL
							,NVL(CEIL(T1.V_VALUE * v_TRANSLATOR), 0) AS V_VALU_CELL
							,NVL(CEIL(T1.M_VALUE * v_TRANSLATOR), 0) AS M_VALU_CELL
							,NVL(CEIL(T1.MKT_FCST_M * v_TRANSLATOR), 0) AS MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,NVL(CEIL(T1.CP_VALUE), 0)
							,NVL(CEIL(T1.CP_VALUE * v_TRANSLATOR), 0) AS CP_VALU_CELL
						FROM (
							SELECT DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
								,SUM(PRODUCT) AS P_VALUE
								,SUM(SALES) AS S_VALUE
								,SUM(INVENTORY) AS I_VALUE
								,SUM(VPA) AS V_VALUE
								,SUM(MODELMIX) AS M_VALUE
								,SUM(SUPPLYISSUE) AS CP_VALUE
							FROM DM_ANL_MKT_PSI_DETAIL
							PIVOT(SUM(QTY) FOR QTYCD3 IN (
										'PRODUCT' AS PRODUCT
										,'SALES' AS SALES
										,'INVENTORY' AS INVENTORY
										,'VPA' AS VPA
										,'MODELMIX' AS MODELMIX
										,'SUPPLYISSUE' AS SUPPLYISSUE
										)) PVT
							WHERE 1 = 1
								AND DIVISION_ID = v_DIVISION_ID
								AND END_CUSTOMER = v_END_CUSTOMER
								AND PROJECT_CODE = v_PROJECT_CODE
								AND YYYYMM = v_YYYYMM
								AND MEASURE = v_MEASURE
							GROUP BY DIVISION_ID
								,END_CUSTOMER
								,PROJECT_CODE
								,YYYYMM
								,CUST_FCST_M
								,MEASURE
								,MKT_FCST_M
							) T1

						UNION ALL

						SELECT v_DIVISION_ID
							,v_END_CUSTOMER
							,v_PROJECT_CODE
							,TO_CHAR(ADD_MONTHS(TO_DATE((v_YYYYMM || '01')), 1), 'YYYYMMDD')
							,CEIL(v_CUST_FCST_M_PRE)
							,'DP_RESULT'
							,0
							,0
							,0
							,0
							,0
							,0
							,CEIL(v_CUST_FCST_M_CELL) AS CUST_FCST_M_CELL
							,0 AS P_VALU_CELL
							,0 AS S_VALU_CELL
							,0 AS I_VALU_CELL
							,0 AS V_VALU_CELL
							,0 AS M_VALU_CELL
							,0 AS MKT_FCST_M_CELL
							,v_CREATED_BY
							,SYSTIMESTAMP
							,v_LAST_UPDATED_BY
							,SYSTIMESTAMP
							,0
							,0 AS CP_VALU_CELL
						FROM DUAL
					)	X;

					SELECT '4' ,A.*
						BULK COLLECT INTO V_RES_RESULT
					FROM TABLE(GT_DMF0_DM_ANL_MKT_PSI) A;
				END IF;
			END IF;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		BEGIN
			-- 본 테이블 INSERT INTO
			SELECT '5', A.*
					BULK COLLECT INTO V_RES_RESULT
			FROM TABLE(GT_DMF0_DM_ANL_MKT_PSI) A;

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
				,"DESC"
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
				,TO_NUMBER(P_VALUE)
				,TO_NUMBER(S_VALUE)
				,TO_NUMBER(I_VALUE)
				,TO_NUMBER(V_VALUE)
				,TO_NUMBER(M_VALUE)
				,TO_NUMBER(MKT_FCST_M)
				,"DESC"
				,INPUT_LIMIT
				,TO_NUMBER(CUST_FCST_M_CELL)
				,TO_NUMBER(P_VALUE_CELL)
				,TO_NUMBER(S_VALUE_CELL)
				,TO_NUMBER(I_VALUE_CELL)
				,TO_NUMBER(V_VALUE_CELL)
				,TO_NUMBER(M_VALUE_CELL)
				,TO_NUMBER(MKT_FCST_M_CELL)
				,CREATED_BY
				,SYSDATE
				,LAST_UPDATED_BY
				,SYSDATE
				,TO_NUMBER(CP_VALUE)
				,TO_NUMBER(CP_VALUE_CELL)
			FROM TABLE(GT_DMF0_DM_ANL_MKT_PSI);
			END;
			END LOOP;
		END;
		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);


		/*
		2024.01.10    kcw3408        PR_DM_ANL_MKT_PSI_DATA:고객수요증감분석 데이터 기초값 생성 및 인터페이스 전송 배치 작업 신규로  I/F 테이블 INSERT INTO 삭제함
		*/
		/*
		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S
				WHERE DIVISION_ID = v_Division_id
					AND END_CUSTOMER = p_end_customer
					AND PROJECT_CODE = p_project_code;
			END

			INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DW_S (;
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
				,DESC
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
				,TO_NUMBER(P_VALUE)
				,TO_NUMBER(S_VALUE)
				,TO_NUMBER(I_VALUE)
				,TO_NUMBER(V_VALUE)
				,TO_NUMBER(M_VALUE)
				,TO_NUMBER(MKT_FCST_M)
				,DESC
				,INPUT_LIMIT
				,TO_NUMBER(CUST_FCST_M_CELL)
				,TO_NUMBER(P_VALUE_CELL)
				,TO_NUMBER(S_VALUE_CELL)
				,TO_NUMBER(I_VALUE_CELL)
				,TO_NUMBER(V_VALUE_CELL)
				,TO_NUMBER(M_VALUE_CELL)
				,TO_NUMBER(MKT_FCST_M_CELL)
				,CREATED_BY
				,SYSDATE
				,LAST_UPDATED_BY
				,SYSDATE
				,TO_NUMBER(CP_VALUE)
				,TO_NUMBER(CP_VALUE_CELL)
			FROM DM_ANL_MKT_PSI
			WHERE DIVISION_ID = v_Division_id
				AND PROJECT_CODE = p_project_code
				AND END_CUSTOMER = p_end_customer;
		END
		*/
		/*  [PJ202650304] 아래 I/F 전송 구간은 MSSQL 원본에서 블록주석으로 비활성화된 코드임 (DEPT_ID/ITEM_ID 추출 + XIF I/F 테이블 DELETE/INSERT). 변환 시 잘못 활성화되어 ORA-00942 발생 → 재비활성화.
		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 START
		BEGIN
			SELECT PROJECT_DEPT_ROW(PRJ.DIVISION_ID,PRJ.PROJECT_CODE, PRJ.PROJECT_NAME, DEPT.DEPT_ID, DEPT.DEPT_NAME_KO)
				BULK COLLECT INTO GT_DMF0_PROJECT_DEPT
			  FROM SCM_MST_PROJECT PRJ
			  INNER JOIN (
				SELECT A.USER_ID, A.USER_NAME, A.USER_NAME_EN, A.DEPT_ID, B.DEPT_NAME_KO
					FROM SCM_MST_SSO_USER_INFO A
						INNER JOIN SCM_MST_SSO_DEPT_INFO B
							ON A.DEPT_ID = B.DEPT_ID
				) DEPT ON DEPT.USER_ID = PRJ.PROJECT_OWNER;
		END;


		-- 프로젝트 OWNERSHIP으로 DEPT_ID 정보 추출 END

		TODO:GTT GT_DMF0_ITEM_ID (I/F 구간과 함께 비활성)
		SELECT ITEM_ID_ROW(ROW_NUMBER() OVER(ORDER BY A.ITEM_ID), A.ITEM_ID)
			BULK COLLECT INTO GT_DMF0_ITEM_ID
		FROM
		(SELECT ITEM_ID FROM GT_DMF0_DM_MST_ITEM_SINGLE_V GROUP BY ITEM_ID) A;


		SELECT COUNT(*) INTO V_ITEM_CNT
		FROM TABLE(GT_DMF0_ITEM_ID);

		--SELECT * FROM GT_DMF0_ITEM_ID

		BEGIN -- I/F 테이블 INSERT
			--SELECT '6', * FROM GT_DMF0_DM_ANL_MKT_PSI
			--**중요 -> 운영 반영시 DB명 변경 (운영:LGCE_INF, 개발:LGCE_INFDEV)
			BEGIN -- I/F 테이블 해당 PROJECT 삭제
				DELETE
				FROM LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S
				WHERE DIVISION_ID = v_Division_id
					AND PROJECT_CODE = p_project_code
					AND END_CUSTOMER = p_end_customer;
			END;

			WHILE v_i <= V_ITEM_CNT	 LOOP
			BEGIN
				SELECT ITEM_ID INTO V_ITEM_ID FROM TABLE(GT_DMF0_ITEM_ID) WHERE SEQ = v_i;
				INSERT INTO LGCE_INFDEV.XIF_DM_ANL_MKT_PSI_DETAIL_DW_S (
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
						,"DESC"
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
					,V_ITEM_ID AS ITEM_ID
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
					,A."DESC"
					,A.INPUT_LIMIT
					,A.CUST_FCST_M * v_TRANSLATOR -- A.CUST_FCST_M_CELL
					,A.QTY * v_TRANSLATOR --A.QTY_CELL
					,A.MKT_FCST_M * v_TRANSLATOR --A.MKT_FCST_M_CELL
					,A.CREATED_BY
					,SYSDATE
					, p_created_by --,A.LAST_UPDATED_BY
					,SYSDATE
				FROM DM_ANL_MKT_PSI_DETAIL A
				INNER JOIN TABLE(GT_DMF0_PROJECT_DEPT) B
				ON A.DIVISION_ID = B.DIVISION_ID  AND A.PROJECT_CODE = B.PROJECT_CODE
				WHERE A.DIVISION_ID = v_Division_id
					AND A.PROJECT_CODE = p_project_code
					AND A.END_CUSTOMER = p_end_customer;

				v_i := v_i || 1;
			END;
			END LOOP;
		END;
		*/

		DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);

		--DMF0003_GET_DM_ANL_MKT_PSI_DATA v_DIVISION_ID, v_PROJECT_CODE, v_YYYYMM, v_CREATED_BY;
		COMMIT;
	-- END TRY
	EXCEPTION
	    WHEN OTHERS THEN

		-- ERROR LOG
		v_log_type := 'ERROR';
		v_log_message := SQLERRM;
		v_description := 'ERROR_LINE : ' || TO_CHAR(NULL);
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(
			v_program_name
			,v_log_type
			,n_log_count
			,v_log_message
			,v_description
			,d_event_date
		);
	-- END CATCH

	-- 종료 LOG
	v_log_type := 'END';
	v_log_message := '########## END of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;

	PR_SCM_SYS_LOG_BATCH(
		v_program_name
		,v_log_type
		,n_log_count
		,v_log_message
		,v_description
		,d_event_date
		);
     RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');

	-- 트랜잭션 (END)
<<err_rtn>>
	IF v_log_type = 'INVALID' THEN
		v_log_message := '########## END of procedure ##########';
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(v_program_name
			,v_log_type
			,n_log_count
			,v_log_message
			,v_description
			,d_event_date
			);
		-- 종료 LOG
		v_log_type := 'END';
		v_log_message := '########## END of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;

		PR_SCM_SYS_LOG_BATCH(v_program_name
			,v_log_type
			,n_log_count
			,v_log_message
			,v_description
			,d_event_date
			);
	END IF;

	-- 2026-07-03 [PJ202650304] TO-BE 표준 dual OUT cursor (BE PROC_M 배선용 — 본문 로직 무변경)
	OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
	OPEN O_RESULT_CURSOR FOR
		SELECT CASE WHEN v_log_type = 'INVALID' THEN 'INVALID' ELSE 'SUCCESS' END AS MSG
		     , CASE WHEN v_log_type = 'INVALID' THEN '1' ELSE '0' END AS CODE
		     , TO_CHAR(v_max_loop_cnt) AS EVENT
		  FROM DUAL;
END;
/
