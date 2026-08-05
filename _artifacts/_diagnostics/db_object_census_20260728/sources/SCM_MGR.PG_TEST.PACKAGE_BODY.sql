PACKAGE BODY           "PG_TEST"
AS

	-- 테스트용
	PROCEDURE PROCTEST (
	    p_str1 IN VARCHAR2,
	    p_str2 IN VARCHAR2,
	    p_num  IN NUMBER,
	    INPUTDATA OUT SYS_REFCURSOR,
	    DUMMYDATA OUT SYS_REFCURSOR
	) AS
	BEGIN
	    -- 입력받은 값을 SELECT 구조로 만들어 커서에 할당합니다.
	    OPEN INPUTDATA FOR
	        SELECT p_str1 AS STR1,
	               p_str2 AS STR2,
	               p_num  AS NUM
	        FROM DUAL;

	    OPEN DUMMYDATA FOR
	        SELECT 1 AS NUM_1,
	               2 AS NUM_2,
	               3 AS NUM_3
	        FROM DUAL;
	END;


	PROCEDURE PROCTEST2 (
	    p_str1 IN VARCHAR2,
	    p_str2 IN VARCHAR2,
	    OUT1   OUT SYS_REFCURSOR,
	    INPUTDATA OUT SYS_REFCURSOR,
	    DUMMYDATA OUT SYS_REFCURSOR
	) AS
	BEGIN
		OPEN OUT1 FOR
	        SELECT  *
	          FROM  SCM_ADM_PROC_M;

	    OPEN INPUTDATA FOR
	        SELECT  p_str1 AS STR1,
	                p_str2 AS STR2
	          FROM  DUAL;

	    OPEN DUMMYDATA FOR
	        SELECT  1 AS NUM_1,
	                2 AS NUM_2,
	                3 AS NUM_3,
	                5 AS NUM_4,
	                5 AS NUM_5
	          FROM  DUAL;

	END;

	PROCEDURE PROCTEST3 (
	    I_STR1 		IN VARCHAR2,
	    I_STR2 		IN VARCHAR2,
	    O_CODE 		OUT NUMBER,
	    O_MESSAGE	OUT VARCHAR2
	) AS
	BEGIN

		SELECT 1 , 'TEST'
		 INTO  O_CODE, O_MESSAGE
		 FROM  DUAL;

		O_CODE := 0;
		O_MESSAGE := 'success';
	EXCEPTION
    	WHEN OTHERS THEN

		O_CODE := -1;
		O_MESSAGE := 'error: '|| SQLERRM;
	END;

	PROCEDURE PROCTEST4

	AS

	BEGIN

		INSERT INTO SCM_MGR.SCM_COM_SQL_LOG
			(LOG_SEQ, SQL_ID, SQL_TYPE, SQL_TEXT, PARAMS, ELAPSED_MS, EXECUTE_TIME, RESULT_COUNT, "EXCEPTION", CREATE_DATE, CREATED_BY)

	EXCEPTION
    	WHEN OTHERS THEN
	    	RAISE_APPLICATION_ERROR(-20001, '에러데이타 샘플 :' || SQLERRM);

	END;




	PROCEDURE PROCTEST5 (
	    langCd 		IN VARCHAR2,
	    OUT11		OUT NUMBER
--	    DATARESULT11	OUT SYS_REFCURSOR
	) AS
	BEGIN

		OUT11 := 1;
/*
		OPEN DATARESULT11 FOR
	        SELECT  OPT_VAL_CTN1 MSG_ID, LANG_CD, MSG_TXT_CTN
				, OPT_VAL_CTN2 AS MSG_TYP, OPT_VAL_CTN1||'='||MSG_TXT_CTN AS I18N_CTN
		  FROM  TB_RPJTE_MSG_M
 		 WHERE  USE_YN = 'Y'
 		   AND  LANG_CD = langCd;
*/
	END;



	PROCEDURE PROCTEST_JSON (
	    p_str1 IN CLOB,
	    -- 결과셋을 담을 커서 변수 (OUT)
	    data1 OUT SYS_REFCURSOR
	) AS
	BEGIN
	    -- 입력받은 값을 SELECT 구조로 만들어 커서에 할당합니다.
	    OPEN data1 FOR
	    	SELECT *
	    	  FROM JSON_TABLE(p_str1, '$[*]'
	    	 	COLUMNS (
	    	 		DATA_1 VARCHAR(20) PATH '$.col1',
	    	 		DATA_2 VARCHAR(20) PATH '$.col2',
	    	 		DATA_3 NUMBER PATH '$.col3'
	    	 	)
	    	  );

	END;



END PG_TEST;