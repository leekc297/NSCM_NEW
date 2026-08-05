CREATE OR REPLACE PROCEDURE           "DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP"
(
	-- Add the parameters for the stored procedure here
    p_active_flag             IN  VARCHAR2,
    p_DIVISION_ID             IN  VARCHAR2,
    p_PROJECT_CODE            IN  VARCHAR2,
    p_SCM_SITE_ID             IN  VARCHAR2,
    p_PLANT_SITE_ID           IN  VARCHAR2,
    p_ITEM_ID                 IN  VARCHAR2,
    p_YYYYMMDD                IN  VARCHAR2,
    p_CURRENCY                IN  VARCHAR2,
    p_MEASURE                 IN  VARCHAR2,
    p_DOM_EXP                 IN  VARCHAR2,
    p_FCST_TYPE               IN  VARCHAR2,
    p_INCOTERMS               IN  VARCHAR2,
    p_PRICE                   IN  VARCHAR2,
    p_CREATED_BY              IN  VARCHAR2,
    p_CREATION_DATE           IN  VARCHAR2,
    p_LAST_UPDATED_BY         IN  VARCHAR2,
    p_result_cursor           OUT SYS_REFCURSOR
)
IS

	-- 스플릿관련 변수

    v_active_flag        VARCHAR2(4000 CHAR);
    v_DIVISION_ID        VARCHAR2(4000 CHAR);
    v_PROJECT_CODE       VARCHAR2(4000 CHAR);
    v_SCM_SITE_ID        VARCHAR2(4000 CHAR);
    v_PLANT_SITE_ID      VARCHAR2(4000 CHAR);
    v_ITEM_ID            VARCHAR2(4000 CHAR);
    v_YYYYMMDD           VARCHAR2(4000 CHAR);
    v_CURRENCY           VARCHAR2(4000 CHAR);
    v_MEASURE            VARCHAR2(4000 CHAR);
    v_DOM_EXP            VARCHAR2(4000 CHAR);
    v_FCST_TYPE          VARCHAR2(4000 CHAR);
    v_INCOTERMS          VARCHAR2(4000 CHAR);
    v_PRICE              VARCHAR2(4000 CHAR);
    v_CREATED_BY         VARCHAR2(4000 CHAR);
    v_CREATION_DATE      VARCHAR2(4000 CHAR);
    v_LAST_UPDATED_BY    VARCHAR2(4000 CHAR);

    -- 입력 파라미터 복사본 (IN 파라미터를 직접 변경할 수 없으므로 로컬 변수에 복사)
    l_active_flag        VARCHAR2(32767);
    l_DIVISION_ID        VARCHAR2(32767);
    l_PROJECT_CODE       VARCHAR2(32767);
    l_SCM_SITE_ID        VARCHAR2(32767);
    l_PLANT_SITE_ID      VARCHAR2(32767);
    l_ITEM_ID            VARCHAR2(32767);
    l_YYYYMMDD           VARCHAR2(32767);
    l_CURRENCY           VARCHAR2(32767);
    l_MEASURE            VARCHAR2(32767);
    l_DOM_EXP            VARCHAR2(32767);
    l_FCST_TYPE          VARCHAR2(32767);
    l_INCOTERMS          VARCHAR2(32767);
    l_PRICE              VARCHAR2(32767);
    l_CREATED_BY         VARCHAR2(32767);
    l_LAST_UPDATED_BY    VARCHAR2(32767);

	v_delimiter VARCHAR2(1 CHAR);
	max_loop_cnt		PLS_INTEGER := 0;
	mst_loop_cnt		PLS_INTEGER := 0;

	-- LOG 용 변수 설정
    v_program_name VARCHAR2(150 CHAR) := 'DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP';
    v_log_type     VARCHAR2(30 CHAR); -- START/END/ERROR/...
    n_log_count    PLS_INTEGER := 0;
    v_log_message  VARCHAR2(1000 CHAR);
    v_description  VARCHAR2(500 CHAR);
    d_event_date   DATE;
    n_delete_count    PLS_INTEGER := 0;
    n_insert_count     PLS_INTEGER := 0;
    n_logo_count      PLS_INTEGER := 0;

    -- 결과 메시지 보관 (MSSQL SELECT '...' 대체)
    v_result_message  VARCHAR2(4000 CHAR);

    index_DIVISION_ID     PLS_INTEGER;
    index_active_flag     PLS_INTEGER;
    index_PROJECT_CODE    PLS_INTEGER;
    index_SCM_SITE_ID     PLS_INTEGER;
    index_PLANT_SITE_ID   PLS_INTEGER;
    index_ITEM_ID         PLS_INTEGER;
    index_YYYYMMDD        PLS_INTEGER;
    index_CURRENCY        PLS_INTEGER;
    index_MEASURE         PLS_INTEGER;
    index_DOM_EXP         PLS_INTEGER;
    index_FCST_TYPE       PLS_INTEGER;
    index_INCOTERMS       PLS_INTEGER;
    index_PRICE           PLS_INTEGER;
    index_CREATED_BY      PLS_INTEGER;
    --index_CREATION_DATE   PLS_INTEGER;
    index_LAST_UPDATED_BY PLS_INTEGER;

    -- 20180814 KHSONG Invalid Site Item validation 추가
    valid_item_id        VARCHAR2(32767);

    -- 사용자 정의 예외 (INVALID 상태 처리용)
    e_invalid_data EXCEPTION;

BEGIN
    -- SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    -- SET NOCOUNT ON;
    -- SET XACT_ABORT ON;

	v_delimiter := '^';  -- 데이터 구분자

	-- 마지막 데이터 처리를 위한 구분자 추가
	l_active_flag      := RTRIM(p_active_flag     ) || '^';
	l_DIVISION_ID      := RTRIM(p_DIVISION_ID     ) || '^';
	l_PROJECT_CODE     := RTRIM(p_PROJECT_CODE    ) || '^';
	l_SCM_SITE_ID      := RTRIM(p_SCM_SITE_ID     ) || '^';
	l_PLANT_SITE_ID    := RTRIM(p_PLANT_SITE_ID   ) || '^';
	l_ITEM_ID          := RTRIM(p_ITEM_ID         ) || '^';
	l_YYYYMMDD         := RTRIM(p_YYYYMMDD        ) || '^';
	l_CURRENCY         := RTRIM(p_CURRENCY        ) || '^';
	l_MEASURE          := RTRIM(p_MEASURE         ) || '^';
	l_DOM_EXP          := RTRIM(p_DOM_EXP         ) || '^';
	l_FCST_TYPE        := RTRIM(p_FCST_TYPE       ) || '^';
	l_INCOTERMS        := RTRIM(p_INCOTERMS       ) || '^';
	l_PRICE            := RTRIM(p_PRICE           ) || '^';
	l_CREATED_BY       := RTRIM(p_CREATED_BY      ) || '^';
	--l_CREATION_DATE    := RTRIM(p_CREATION_DATE   ) || '^';
	l_LAST_UPDATED_BY  := RTRIM(p_LAST_UPDATED_BY ) || '^';


-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (START)
	-- #results_MST TEMP TABLE
	-- GTT 변환: GT_DMF0020_RESULTS_MST (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
	-- CLUSTERED INDEX IDX_RESULTS_N1 → GTT 에는 인덱스 별도 정의 (DDL 파일 참조)

	-- #results TEMP TABLE (PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 로 전달할 대상)
	-- GTT 변환: GT_DMF0020_RESULTS (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
	-- CLUSTERED INDEX IDX_RESULTS_N2 → GTT 에는 인덱스 별도 정의 (DDL 파일 참조)

	-- 환율 테이블
	-- GTT 변환: GT_DMF0020_EXCH (별도 DDL 파일 PKG_DMF0020_GTT_DDL.sql 참조)
-- 20180718  KHSONG  기존 @TEMP TABLE 에서 INDEX적용 테이블로 변경 (END)

		-- 시작 LOG  (START)
		v_log_type := 'START';
		v_log_message := '########## Start of procedure @@@##########';
		v_description := '';
		d_event_date := SYSDATE;
		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
		v_log_message := NULL;      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		-- Oracle 은 명시적 SAVEPOINT 사용 (BEGIN TRANSACTION 대체)
		SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;  -- sss

	--------------------------------------------------------------------------------------------
		BEGIN
	--------------------------------------------------------------------------------------------	 DECIMAL

--===================================================================================== #results_MST 테이블에 split후 insert start
--###############################################  #results_MST 테이블에 split후 insert (START)
WHILE LENGTH(l_DIVISION_ID) > 0
LOOP

    index_DIVISION_ID      := INSTR(l_DIVISION_ID,      '^');
	index_active_flag      := INSTR(l_active_flag,      '^');
	index_PROJECT_CODE     := INSTR(l_PROJECT_CODE,     '^');
	index_SCM_SITE_ID      := INSTR(l_SCM_SITE_ID,      '^');
	index_PLANT_SITE_ID    := INSTR(l_PLANT_SITE_ID,    '^');
	index_ITEM_ID          := INSTR(l_ITEM_ID,          '^');
	index_YYYYMMDD         := INSTR(l_YYYYMMDD,         '^');
	index_CURRENCY         := INSTR(l_CURRENCY,         '^');
	index_MEASURE          := INSTR(l_MEASURE,          '^');
	index_DOM_EXP          := INSTR(l_DOM_EXP,          '^');
	index_FCST_TYPE        := INSTR(l_FCST_TYPE,        '^');
	index_INCOTERMS        := INSTR(l_INCOTERMS,        '^');
	index_PRICE            := INSTR(l_PRICE,            '^');
	index_CREATED_BY       := INSTR(l_CREATED_BY,       '^');
	--index_CREATION_DATE    := INSTR(l_CREATION_DATE,    '^');
	index_LAST_UPDATED_BY  := INSTR(l_LAST_UPDATED_BY,  '^');


	--확인  select @index_DIVISION_ID as '@index_DIVISION_ID';
    IF index_DIVISION_ID > 0 THEN

			-- MSSQL SUBSTRING(s, 0, n) 은 1번째부터 (n-1)글자 반환과 동일 → Oracle SUBSTR(s, 1, n-1)
			v_active_flag := SUBSTR(l_active_flag, 1, index_active_flag - 1);
			l_active_flag := SUBSTR(l_active_flag, LENGTH(v_active_flag || '^') + 1, LENGTH(l_active_flag));

			v_DIVISION_ID := SUBSTR(l_DIVISION_ID, 1, index_DIVISION_ID - 1);
			l_DIVISION_ID := SUBSTR(l_DIVISION_ID, LENGTH(v_DIVISION_ID || '^') + 1, LENGTH(l_DIVISION_ID));

			v_PROJECT_CODE := SUBSTR(l_PROJECT_CODE , 1, index_PROJECT_CODE - 1);
			l_PROJECT_CODE := SUBSTR(l_PROJECT_CODE , LENGTH(v_PROJECT_CODE || '^') + 1, LENGTH(l_PROJECT_CODE ));

			v_SCM_SITE_ID := SUBSTR(l_SCM_SITE_ID, 1, index_SCM_SITE_ID - 1);
			l_SCM_SITE_ID := SUBSTR(l_SCM_SITE_ID, LENGTH(v_SCM_SITE_ID || '^') + 1, LENGTH(l_SCM_SITE_ID));

			v_PLANT_SITE_ID := SUBSTR(l_PLANT_SITE_ID, 1, index_PLANT_SITE_ID - 1);
			l_PLANT_SITE_ID := SUBSTR(l_PLANT_SITE_ID, LENGTH(v_PLANT_SITE_ID || '^') + 1, LENGTH(l_PLANT_SITE_ID));

			v_ITEM_ID := SUBSTR(l_ITEM_ID, 1, index_ITEM_ID - 1);
			l_ITEM_ID := SUBSTR(l_ITEM_ID, LENGTH(v_ITEM_ID || '^') + 1, LENGTH(l_ITEM_ID));

			v_YYYYMMDD := SUBSTR(l_YYYYMMDD, 1, index_YYYYMMDD - 1);
			l_YYYYMMDD := SUBSTR(l_YYYYMMDD, LENGTH(v_YYYYMMDD || '^') + 1, LENGTH(l_YYYYMMDD));

			v_CURRENCY := SUBSTR(l_CURRENCY, 1, index_CURRENCY - 1);
			l_CURRENCY := SUBSTR(l_CURRENCY, LENGTH(v_CURRENCY || '^') + 1, LENGTH(l_CURRENCY));

			v_MEASURE := SUBSTR(l_MEASURE, 1, index_MEASURE - 1);
			l_MEASURE := SUBSTR(l_MEASURE, LENGTH(v_MEASURE || '^') + 1, LENGTH(l_MEASURE));

			v_DOM_EXP := SUBSTR(l_DOM_EXP, 1, index_DOM_EXP - 1);
			l_DOM_EXP := SUBSTR(l_DOM_EXP, LENGTH(v_DOM_EXP || '^') + 1, LENGTH(l_DOM_EXP));

			v_FCST_TYPE := SUBSTR(l_FCST_TYPE, 1, index_FCST_TYPE - 1);
			l_FCST_TYPE := SUBSTR(l_FCST_TYPE, LENGTH(v_FCST_TYPE || '^') + 1, LENGTH(l_FCST_TYPE));

			v_INCOTERMS := SUBSTR(l_INCOTERMS, 1, index_INCOTERMS - 1);
			l_INCOTERMS := SUBSTR(l_INCOTERMS, LENGTH(v_INCOTERMS || '^') + 1, LENGTH(l_INCOTERMS));

			v_PRICE := SUBSTR(l_PRICE, 1, index_PRICE - 1);
			l_PRICE := SUBSTR(l_PRICE, LENGTH(v_PRICE || '^') + 1, LENGTH(l_PRICE));

			v_CREATED_BY := SUBSTR(l_CREATED_BY, 1, index_CREATED_BY - 1);
			l_CREATED_BY := SUBSTR(l_CREATED_BY, LENGTH(v_CREATED_BY || '^') + 1, LENGTH(l_CREATED_BY));

			v_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, 1, index_LAST_UPDATED_BY - 1);
			l_LAST_UPDATED_BY := SUBSTR(l_LAST_UPDATED_BY, LENGTH(v_LAST_UPDATED_BY || '^') + 1, LENGTH(l_LAST_UPDATED_BY));

			--20181005 khsong 공백제거로직추가 (START)
			v_active_flag    	:= rtrim(ltrim(v_active_flag));
			v_DIVISION_ID    	:= rtrim(ltrim(v_DIVISION_ID));
			v_PROJECT_CODE   	:= rtrim(ltrim(v_PROJECT_CODE));
			v_SCM_SITE_ID    	:= rtrim(ltrim(v_SCM_SITE_ID));
			v_PLANT_SITE_ID  	:= rtrim(ltrim(v_PLANT_SITE_ID));
			v_ITEM_ID        	:= rtrim(ltrim(v_ITEM_ID));
			v_YYYYMMDD       	:= rtrim(ltrim(v_YYYYMMDD));
			v_CURRENCY       	:= rtrim(ltrim(v_CURRENCY));
			v_MEASURE        	:= rtrim(ltrim(v_MEASURE));
			v_DOM_EXP        	:= rtrim(ltrim(v_DOM_EXP));
			v_FCST_TYPE      	:= rtrim(ltrim(v_FCST_TYPE));
			v_INCOTERMS      	:= rtrim(ltrim(v_INCOTERMS));
			v_PRICE          	:= rtrim(ltrim(v_PRICE));
			v_CREATED_BY     	:= rtrim(ltrim(v_CREATED_BY));
			v_LAST_UPDATED_BY	:= rtrim(ltrim(v_LAST_UPDATED_BY));
			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO GT_DMF0020_RESULTS_MST (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,TO_NUMBER(v_PRICE)
									,v_CREATED_BY
									,SYSDATE -- @v_CREATION_DATE
									,v_LAST_UPDATED_BY
			);

    ELSE

			v_DIVISION_ID := l_DIVISION_ID;
			l_DIVISION_ID := NULL;

			--20181005 khsong 공백제거로직추가 (START)
			v_active_flag    	:= rtrim(ltrim(v_active_flag));
			v_DIVISION_ID    	:= rtrim(ltrim(v_DIVISION_ID));
			v_PROJECT_CODE   	:= rtrim(ltrim(v_PROJECT_CODE));
			v_SCM_SITE_ID    	:= rtrim(ltrim(v_SCM_SITE_ID));
			v_PLANT_SITE_ID  	:= rtrim(ltrim(v_PLANT_SITE_ID));
			v_ITEM_ID        	:= rtrim(ltrim(v_ITEM_ID));
			v_YYYYMMDD       	:= rtrim(ltrim(v_YYYYMMDD));
			v_CURRENCY       	:= rtrim(ltrim(v_CURRENCY));
			v_MEASURE        	:= rtrim(ltrim(v_MEASURE));
			v_DOM_EXP        	:= rtrim(ltrim(v_DOM_EXP));
			v_FCST_TYPE      	:= rtrim(ltrim(v_FCST_TYPE));
			v_INCOTERMS      	:= rtrim(ltrim(v_INCOTERMS));
			v_PRICE          	:= rtrim(ltrim(v_PRICE));
			v_CREATED_BY     	:= rtrim(ltrim(v_CREATED_BY));
			v_LAST_UPDATED_BY	:= rtrim(ltrim(v_LAST_UPDATED_BY));

			--20181005 khsong 공백제거로직추가 (END)

			INSERT INTO GT_DMF0020_RESULTS_MST (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY
			) VALUES (
			                         v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,TO_NUMBER(v_PRICE)
									,v_CREATED_BY
									,SYSDATE --@v_CREATION_DATE
									,v_LAST_UPDATED_BY
			);
    END IF;
END LOOP;

BEGIN

	INSERT INTO GT_DMF0020_EXCH (DIVISION_ID, YYYYMMDD, CURRENCY, UNIT_CURRENCY, EXCHANGE_PRICE)
	SELECT DISTINCT A.DIVISION_ID, A.YYYYMMDD, A.CURRENCY, A.UNIT_CURRENCY, A.EXCHANGE_PRICE
	FROM DM_MST_EXCHANGE_RATE A
	JOIN GT_DMF0020_RESULTS_MST B
		ON A.DIVISION_ID	= B.v_DIVISION_ID
		AND A.YYYYMMDD		= SUBSTR(B.v_YYYYMMDD, 1, 6) || '01'
		AND A.CURRENCY		= 'KRW';

	-- LOC 동일값
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,v_CURRENCY AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,v_PRICE
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY IN('KRW', 'USD');

		-- KRW값 구하기
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,'KRW' AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,ROUND(A.v_PRICE * B.EXCHANGE_PRICE, 3)
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		JOIN GT_DMF0020_EXCH B
		ON B.UNIT_CURRENCY = A.v_CURRENCY
		AND B.YYYYMMDD = SUBSTR(A.v_YYYYMMDD, 1, 6) || '01'
		WHERE A.v_MEASURE = 'LOC'
		AND A.v_CURRENCY <> 'KRW';

		-- USD값 구하기
		INSERT INTO GT_DMF0020_RESULTS_MST ( v_active_flag
									,v_DIVISION_ID
									,v_PROJECT_CODE
									,v_SCM_SITE_ID
									,v_PLANT_SITE_ID
									,v_ITEM_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_MEASURE
									,v_DOM_EXP
									,v_FCST_TYPE
									,v_INCOTERMS
									,v_PRICE
									,v_CREATED_BY
									,v_CREATION_DATE
									,v_LAST_UPDATED_BY)
		SELECT  v_active_flag
				,v_DIVISION_ID
				,v_PROJECT_CODE
				,v_SCM_SITE_ID
				,v_PLANT_SITE_ID
				,v_ITEM_ID
				,v_YYYYMMDD
				,v_CURRENCY
				,'USD' AS v_MEASURE
				,v_DOM_EXP
				,v_FCST_TYPE
				,v_INCOTERMS
				,ROUND(A.v_PRICE / B.EXCHANGE_PRICE, 3)
				,v_CREATED_BY
				,v_CREATION_DATE
				,v_LAST_UPDATED_BY
		FROM GT_DMF0020_RESULTS_MST A
		JOIN GT_DMF0020_EXCH B
		ON B.UNIT_CURRENCY = 'USD'
		AND B.YYYYMMDD = SUBSTR(A.v_YYYYMMDD, 1, 6) || '01'
		WHERE A.v_MEASURE = 'KRW'
		AND A.v_CURRENCY <> 'USD';
END;

	--###############################################   #results_MST 테이블에 split후 insert (END)
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
		   DECLARE
		       v_chk_cnt PLS_INTEGER;
		   BEGIN
		   IF v_DIVISION_ID <> '40' THEN

			   SELECT count(1) INTO v_chk_cnt
			     FROM GT_DMF0020_RESULTS_MST R
			    WHERE ( SELECT count(1) FROM scm_mst_project WHERE project_code = R.v_PROJECT_CODE ) = 0;

			   IF v_chk_cnt > 0 THEN
				   v_log_type := 'INVALID';
				   v_result_message := '['|| v_PROJECT_CODE ||']'|| ' Invalid Project Code !';
				   RAISE e_invalid_data;
			   END IF;


			   SELECT count(1) INTO v_chk_cnt
			     FROM GT_DMF0020_RESULTS_MST R
			    WHERE ( SELECT count(1) FROM SCM_MST_ITEM_SN WHERE ITEM_ID = R.v_ITEM_ID ) = 0;

			   IF v_chk_cnt > 0 THEN
				   v_log_type := 'INVALID';
				   v_result_message := '['|| v_ITEM_ID ||']'|| ' Invalid Item ID !';
				   RAISE e_invalid_data;
			   END IF;

				-- 20180814 KHSONG Invalid Site Item validation 추가
				valid_item_id := NULL;

		----------------------------------------------------------------------------------------------------------◎◎◎◎
			SELECT count(1) INTO v_chk_cnt
			  FROM GT_DMF0020_RESULTS_MST
			 WHERE v_division_id IN ('81','40');  -- 자동차,소형인경우

			IF v_chk_cnt > 0 THEN

					BEGIN
						SELECT A.v_item_id INTO valid_item_id
							FROM GT_DMF0020_RESULTS_MST A
							WHERE 1=1
							AND NOT EXISTS (SELECT  ITEM.division_id
												FROM scm_mst_site_item ITEM
													,DM_MST_ITEM_SINGLE_V SN
												where 1=1
 													and ITEM.division_id   = A.v_division_id
													and ITEM.PROJECT_CODE  = A.v_project_code
													and ITEM.scm_site_id   = A.v_scm_site_id
													and ITEM.ITEM_ID       = A.v_ITEM_ID
													and ITEM.division_id   = SN.division_id
													and ITEM.ITEM_ID       = SN.ITEM_ID
													and SN.ACTIVE_FLAG	   = 'Y'
													and ITEM.VALID_YN	   = 'Y'
													and ITEM.division_id IN ('81','40')
											  )
								AND A.v_division_id IN ('81','40')
								AND ROWNUM = 1;
					EXCEPTION
						WHEN NO_DATA_FOUND THEN
							valid_item_id := NULL;
					END;
						-------------------------------------------------------------------◎◎◎◎
						IF valid_item_id IS NOT NULL THEN
								v_log_type := 'INVALID';
								v_result_message := '['|| valid_item_id ||']'|| ' Invalid Site Item ID !';
								v_description := '['|| valid_item_id ||']'|| ' Invalid Site Item ID !';
								RAISE e_invalid_data;
						END IF;
						-------------------------------------------------------------------◎◎◎◎
			END IF;
				----------------------------------------------------------------------------------◎◎◎◎


		   END IF;
		   END;
	       -- PROJECT_CODE 잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------


--===================================================================================== #results_MST 테이블에 split후 insert end

--  SELECT * FROM #results_MST;  -- 확인용
--===================================================================================== delete start
BEGIN
		   -- DELETE COUNT 확인
		   SELECT COUNT(DIVISION_ID) INTO n_delete_count
		     FROM SCM_MST_FUTURE_PRICE TGT
		    WHERE (
							SELECT count(1)
							  FROM GT_DMF0020_RESULTS_MST
							 where v_active_flag      = 'D'
							   and TGT.DIVISION_ID    =   v_DIVISION_ID
							   AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
							   AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
							   AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
							   AND TGT.ITEM_ID        =   v_ITEM_ID
							   AND TGT.YYYYMMDD       =   v_YYYYMMDD
							   --AND TGT.CURRENCY       =   v_CURRENCY
							   AND TGT.MEASURE        =   v_MEASURE
							   AND TGT.DOM_EXP        =   v_DOM_EXP
							   AND TGT.FCST_TYPE      =   v_FCST_TYPE
							   AND TGT.INCOTERMS      =   v_INCOTERMS
						  ) > 0;

		   --  select * from #results_MST
		   DELETE
           FROM SCM_MST_FUTURE_PRICE TGT
           WHERE (
                    SELECT count(1)
					  FROM GT_DMF0020_RESULTS_MST
					 where v_active_flag      = 'D'
                       and TGT.DIVISION_ID    =   v_DIVISION_ID
                       AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
                       AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
                       AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
                       AND TGT.ITEM_ID        =   v_ITEM_ID
                       AND TGT.YYYYMMDD       =   v_YYYYMMDD
                       --AND TGT.CURRENCY       =   v_CURRENCY
                       AND TGT.MEASURE        =   v_MEASURE
                       AND TGT.DOM_EXP        =   v_DOM_EXP
                       AND TGT.FCST_TYPE      =   v_FCST_TYPE
                       AND TGT.INCOTERMS      =   v_INCOTERMS
				  ) > 0;
END;
--===================================================================================== delete end


--===================================================================================== update, insert start
-- 20180718  KHSONG  기존 MERGE - INTO 구조에서 오류발견되어 DELETE - INSERT 구조로 변경함 (START)
BEGIN
		   -- INSERT COUNT 확인
		   SELECT count(v_DIVISION_ID) INTO n_insert_count
		    		FROM GT_DMF0020_RESULTS_MST
						where v_active_flag      <> 'D';

		   -- INSERT전 동일대상 delete 수행
		   DELETE
           FROM SCM_MST_FUTURE_PRICE TGT
           WHERE (
                    SELECT count(1)
					  FROM GT_DMF0020_RESULTS_MST
					 where v_active_flag      <> 'D'
                       and TGT.DIVISION_ID    =   v_DIVISION_ID
                       AND TGT.PROJECT_CODE   =   v_PROJECT_CODE
                       AND TGT.SCM_SITE_ID    =   v_SCM_SITE_ID
                       AND TGT.PLANT_SITE_ID  =   v_PLANT_SITE_ID
                       AND TGT.ITEM_ID        =   v_ITEM_ID
                       AND TGT.YYYYMMDD       =   v_YYYYMMDD
                       --AND TGT.CURRENCY       =   v_CURRENCY
                       AND TGT.MEASURE        =   v_MEASURE
                       AND TGT.DOM_EXP        =   v_DOM_EXP
                       AND TGT.FCST_TYPE      =   v_FCST_TYPE
                       AND TGT.INCOTERMS      =   v_INCOTERMS
				  ) > 0;

		   -- INSERT 수행
			INSERT INTO SCM_MST_FUTURE_PRICE
					( DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,PLANT_SITE_ID
					,ITEM_ID
					,YYYYMMDD
					,CURRENCY
					,MEASURE
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,PRICE
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
				    )
			SELECT   NVL(V_DIVISION_ID, '-')
					,NVL(V_PROJECT_CODE, '-')
					,NVL(V_SCM_SITE_ID, '-')
					,NVL(V_PLANT_SITE_ID, '-')
					,NVL(V_ITEM_ID, '-')
					,NVL(V_YYYYMMDD, '-')
					,NVL(V_CURRENCY, '-')
					,NVL(V_MEASURE, '-')
					,NVL(V_DOM_EXP, '-')
					,NVL(V_FCST_TYPE, '-')
					,NVL(V_INCOTERMS, '-')
					,cast(V_PRICE as NUMBER(20,10))
					,V_CREATED_BY
					,SYSDATE
					,V_LAST_UPDATED_BY
					,SYSDATE
				FROM GT_DMF0020_RESULTS_MST
					where v_active_flag    <> 'D';

							INSERT INTO  SCM_MST_FUTURE_PRICE_H
									   ( DIVISION_ID
										,HISTORY_SEQ
										,PROJECT_CODE
										,SCM_SITE_ID
										,PLANT_SITE_ID
										,ITEM_ID
										,YYYYMMDD
										,CURRENCY
										,MEASURE
										,DOM_EXP
										,FCST_TYPE
										,INCOTERMS
										,PRICE
										,CREATED_BY
										,CREATION_DATE
										,LAST_UPDATED_BY
										,LAST_UPDATE_DATE
									  )
								SELECT
										 v_DIVISION_ID
										,SEQ1_SCM_MST_FUTURE_PRICE_H.NEXTVAL
										,v_PROJECT_CODE
										,v_SCM_SITE_ID
										,v_PLANT_SITE_ID
										,v_ITEM_ID
										,v_YYYYMMDD
										,v_CURRENCY
										,v_MEASURE
										,v_DOM_EXP
										,v_FCST_TYPE
										,v_INCOTERMS
										,v_PRICE
										,v_CREATED_BY
										,SYSDATE
										,v_LAST_UPDATED_BY
										,SYSDATE
								 FROM  GT_DMF0020_RESULTS_MST  WHERE v_active_flag <> 'D';   -- DELETE값이 아닌경우만

						--------------------------------------------------------------------------------------  20180510 SKH ADD START
                        INSERT INTO GT_DMF0020_RESULTS
									(v_DIVISION_ID
								    ,v_PROJECT_CODE
								    ,v_SCM_SITE_ID
								    ,v_ITEM_ID
								    ,v_DOM_EXP
								    ,v_FCST_TYPE
								    ,v_INCOTERMS
								    ,v_MEASURE
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
									)

						SELECT       v_DIVISION_ID
								    ,v_PROJECT_CODE
								    ,v_SCM_SITE_ID
								    ,v_ITEM_ID
								    ,v_DOM_EXP
								    ,v_FCST_TYPE
								    ,v_INCOTERMS
								    ,v_MEASURE
								    ,v_PLANT_SITE_ID
									,v_YYYYMMDD
									,v_CURRENCY
									,v_PRICE
									,v_CREATED_BY
						  FROM  GT_DMF0020_RESULTS_MST  WHERE v_active_flag <> 'D';   -- DELETE값이 아닌경우만

						-- Procedure 호출 #results 테이블의 데이터를 전달하여 처리함
						PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE;
						--------------------------------------------------------------------------------------  20180510 SKH ADD END

END;
--===================================================================================== update, insert end

  	-- 트랜잭션 (COMMIT)
        COMMIT;  -- sss
	--------------------------------------------------------------------------------------------
		EXCEPTION
			WHEN e_invalid_data THEN
				--------------------------------------------------------------
				--  	err_rtn:
				IF v_log_type = 'INVALID' THEN
						ROLLBACK TO SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;
						v_log_message := '########## END of procedure @@@##########';
						v_description := 'delete_count: '|| TO_CHAR(n_delete_count) || ' / insert_count: ' || TO_CHAR(n_insert_count);
						d_event_date := SYSDATE;
						PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
				END IF;
				--------------------------------------------------------------
			WHEN OTHERS THEN
				--------------------------------------------------------------
				--[C20200909-000203] LOG 표준화 적용
				-- 트랜잭션 (END)
				ROLLBACK TO SAVEPOINT SCM_MST_FUTURE_PRICE_ALL;  -- sss

				v_log_type := 'ERROR';
				v_log_message := SUBSTR(SQLERRM, 1, 1000);
				v_description := 'ERROR_LINE : ' || TO_CHAR($$PLSQL_LINE);
				d_event_date := SYSDATE;

				v_result_message := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;  /*-- 에러메시지 DISPLAY --*/

				PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
				--------------------------------------------------------------
	--------------------------------------------------------------------------------------------
		END;
	--------------------------------------------------------------------------------------------

	-- 수행결과 성공여부 DISPLAY
    IF v_log_message IS NULL THEN
		v_result_message := 'success';

	END IF;

    -- 종료 LOG
    v_log_type := 'END';
    v_log_message := '########## END of procedure @@@##########';
    v_description := 'delete_count: '|| TO_CHAR(n_delete_count) || ' / insert_count: ' || TO_CHAR(n_insert_count);
    d_event_date := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);

	-- 결과셋 반환 (MSSQL SELECT 결과셋 → SYS_REFCURSOR OUT)
	OPEN p_result_cursor FOR
		SELECT v_result_message AS RESULT_MSG FROM DUAL;

END;
/
