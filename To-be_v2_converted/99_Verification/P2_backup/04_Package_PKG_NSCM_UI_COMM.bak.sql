/*=============================================================================================
 * File         : 04_Package_PKG_NSCM_UI_COMM.sql
 * Description  : Package — PKG_NSCM_UI_COMM
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_NSCM_UI_COMM
AS

/*******************************************************/
/*  NSCM 프레임워크 공통 기능 관련    */
/*  !!!deprecated!!!  */
/*  하위 PACKAGE(COMM_MENU, COMM_AUTH 등)으로 분리 후 삭제 예정  */


	/* business 관련 프로시저로 PG_NSCM_GENERAL로 이관 */
	/** key 값으로 호출 할 프로시저의 정보를 반환한다.  */
	PROCEDURE PR_GET_PROC_INFO_LIST (
		P_MNU_ID		IN 		VARCHAR2,
		P_SHT_NM 		IN		VARCHAR2,
		P_MNU_BTN_CD	IN 		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR
	);

	PROCEDURE PR_GET_API_INFO_LIST (
		P_API_ID		IN 		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR
	);

	/* 다국어 아이디용 시퀀스 생성 프로시저 */
	PROCEDURE PR_CRT_SEQ (
		P_SEQ_NM IN VARCHAR2
	);
	
	/* 다국어 아이디 생성 함수 */
	FUNCTION FN_GET_MSG_SEQ(
		P_PREFIX IN VARCHAR2
	) RETURN VARCHAR2;

	/* 메시지 저장용 임시 아이디 시퀀스 조회  */
	FUNCTION FN_GET_TEMP_MSG_SEQ RETURN VARCHAR2;

	/* Oracle 데이터 유형 */
	FUNCTION FN_GET_SYSTEM_DATA_TP( 
		P_DATA_TP IN VARCHAR2 
	) RETURN VARCHAR2;

	/* camelcase */
	FUNCTION FN_TO_CAMEL_CASE(
		P_STR IN VARCHAR2 
	) RETURN VARCHAR2;


	TYPE TY_JSON_ROW IS RECORD (COL_IDX NUMBER, COL_KEY VARCHAR2(100), COL_VALUE VARCHAR2(4000));
	TYPE TY_JSON_TABLE IS TABLE OF TY_JSON_ROW;

	FUNCTION TFN_JSON(
		P_JSON CLOB
	) 
	RETURN TY_JSON_TABLE PIPELINED;
   
   

END PKG_NSCM_UI_COMM;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_NSCM_UI_COMM
AS

--==============================================================================================
	/** key 값으로 호출 할 프로시저의 정보를 반환한다.  */
	PROCEDURE PR_GET_PROC_INFO_LIST (
		P_MNU_ID		IN 		VARCHAR2,
		P_SHT_NM 		IN		VARCHAR2,
		P_MNU_BTN_CD	IN 		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR
	) IS
	
		V_PROC_NM	VARCHAR2(200) := '';
		V_PROC_CNT	NUMBER;
	BEGIN
		
		SELECT  T2.API_URL
		  INTO  V_PROC_NM
	      FROM  SCM_MGR.SCM_ADM_MNU_BTN_MPG_M T1
	      JOIN  SCM_MGR.SCM_ADM_API_M T2
	        ON  T1.API_ID = T2.API_ID
		 WHERE  1=1
		   AND  T1.MNU_ID = P_MNU_ID
		   AND  T1.SHT_NM = P_SHT_NM
		   AND  T1.MNU_BTN_CD = P_MNU_BTN_CD; 
		
		SELECT  COUNT(1)
		  INTO  V_PROC_CNT
		  FROM  SCM_MGR.SCM_ADM_PROC_M
		 WHERE  1=1
		   AND  PROC_NM = V_PROC_NM
	  ORDER BY  SORT_ORD;

		IF V_PROC_CNT = 0 THEN
			OPEN O_CURSOR FOR
			SELECT  V_PROC_NM PROC_NM, '' COL_NM, 'NORMAL' DATA_TP_CD, 'NORMAL' COL_TP_CD, 0 SORT_ORD
			  FROM  DUAL;
		ELSE
			OPEN O_CURSOR FOR
			SELECT  PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
			  FROM  SCM_MGR.SCM_ADM_PROC_M
			 WHERE  1=1
			   AND  PROC_NM = V_PROC_NM
		  ORDER BY  SORT_ORD;
		END IF;
	END;
--==============================================================================================
	PROCEDURE PR_GET_API_INFO_LIST (
		P_API_ID		IN 		VARCHAR2,
		O_CURSOR		OUT		SYS_REFCURSOR
	) IS
	
		V_PROC_NM	VARCHAR2(200) := '';
		V_PROC_CNT	NUMBER;
	BEGIN
		
		SELECT  T1.API_URL
		  INTO  V_PROC_NM
	      FROM  SCM_MGR.SCM_ADM_API_M T1
		 WHERE  1=1
		   AND  T1.API_ID = P_API_ID;
		
		SELECT  COUNT(1)
		  INTO  V_PROC_CNT
		  FROM  SCM_MGR.SCM_ADM_PROC_M
		 WHERE  1=1
		   AND  PROC_NM = V_PROC_NM
	  ORDER BY  SORT_ORD;

		IF V_PROC_CNT = 0 THEN
			OPEN O_CURSOR FOR
			SELECT  V_PROC_NM PROC_NM, '' COL_NM, 'NORMAL' DATA_TP_CD, 'NORMAL' COL_TP_CD, 0 SORT_ORD
			  FROM  DUAL;
		ELSE
			OPEN O_CURSOR FOR
			SELECT  PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD
			  FROM  SCM_MGR.SCM_ADM_PROC_M
			 WHERE  1=1
			   AND  PROC_NM = V_PROC_NM
		  ORDER BY  SORT_ORD;
		END IF;
	END;



--==============================================================================================
	-- 다국어용 아이디 시퀀스 생성 
	PROCEDURE PR_CRT_SEQ( 
		P_SEQ_NM IN VARCHAR2 
	) IS
	
	    PRAGMA AUTONOMOUS_TRANSACTION;
	    V_CNT NUMBER;
	    V_UPPER_NM VARCHAR2(50) := UPPER(P_SEQ_NM); 
	BEGIN
	    SELECT COUNT(*) INTO V_CNT 
	      FROM USER_SEQUENCES 
	     WHERE SEQUENCE_NAME = V_UPPER_NM;
	
	    IF V_CNT = 0 THEN
	        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || V_UPPER_NM || 
	                         ' START WITH 1 INCREMENT BY 1 MAXVALUE 99999 CYCLE NOCACHE';
	    END IF;
	    COMMIT;
	END PR_CRT_SEQ;
	
   
--==============================================================================================
   -- 다국어용 아이디 시퀀스 조회 
	FUNCTION FN_GET_MSG_SEQ( 
		P_PREFIX IN VARCHAR2 
	) RETURN VARCHAR2 IS
	
	    V_SEQ_NAME VARCHAR2(50) := 'SEQ_MSG_' || UPPER(P_PREFIX);
	    V_NUM      NUMBER;
	BEGIN
	    PR_CRT_SEQ(V_SEQ_NAME);
	
	    EXECUTE IMMEDIATE 'SELECT ' || V_SEQ_NAME || '.NEXTVAL FROM DUAL' INTO V_NUM;
	
	    RETURN UPPER(P_PREFIX) || LPAD(V_NUM, 5, '0');
	END FN_GET_MSG_SEQ;

--===
   -- 메시지 저장용 임시 아이디 시퀀스 조회 
	FUNCTION FN_GET_TEMP_MSG_SEQ RETURN VARCHAR2 IS
	    V_NUM      NUMBER;
	BEGIN
	    EXECUTE IMMEDIATE 'SELECT MSG_TEMP_SEQ.NEXTVAL FROM DUAL' INTO V_NUM;
	
	    RETURN 'MSG_TEMP_SEQ' || LPAD(V_NUM, 28, '0');
	END FN_GET_TEMP_MSG_SEQ;

--==============================================================================================
	-- Oracle DB 데이터 유형 변환 
	FUNCTION FN_GET_SYSTEM_DATA_TP( 
		P_DATA_TP IN VARCHAR2 
	) RETURN VARCHAR2 IS
	
		V_SYS_DATA_TP VARCHAR2(100) := 'UNKNOWN';
	BEGIN
	    SELECT  CASE 
		    		WHEN P_DATA_TP = 'VARCHAR2' THEN 'VARCHAR'
		    		WHEN P_DATA_TP = 'REF CURSOR' THEN 'CURSOR'
		    		WHEN P_DATA_TP = 'BINARY_INTEGER' THEN 'NUMBER'
		    		WHEN P_DATA_TP = 'NUMBER' THEN 'NUMERIC'
		    		WHEN P_DATA_TP = 'JVARCHAR' THEN 'VARCHAR'
		    		ELSE P_DATA_TP
		        END 
		  INTO  V_SYS_DATA_TP
		  FROM  DUAL;
	
	
	    RETURN V_SYS_DATA_TP;
	END FN_GET_SYSTEM_DATA_TP;

--==============================================================================================

	FUNCTION FN_TO_CAMEL_CASE (
	    P_STR IN VARCHAR2
	) RETURN VARCHAR2 
	IS
	    V_TEMP_STR   VARCHAR2(4000);
	    V_RETURN_STR VARCHAR2(4000);
	BEGIN
	    IF p_str IS NULL THEN
	        RETURN NULL;
	    END IF;
	
	    -- 1. INITCAP을 적용하여 각 단어의 첫 글자를 대문자로 변환
	    V_TEMP_STR := INITCAP(P_STR);
	
	    -- 2. 공백(' ')과 밑줄('_')을 모두 제거
	    V_TEMP_STR := REPLACE(REPLACE(V_TEMP_STR, ' ', ''), '_', '');
	
	    -- 3. 최종 결과의 첫 글자만 소문자로 변환하여 결합
	    V_RETURN_STR := LOWER(SUBSTR(V_TEMP_STR, 1, 1)) || SUBSTR(V_TEMP_STR, 2);
	
	    RETURN V_RETURN_STR;
	EXCEPTION
	    WHEN OTHERS THEN
	        RETURN P_STR;
	END;



--==============================================================================================

	FUNCTION TFN_JSON(
		P_JSON IN CLOB
	) RETURN TY_JSON_TABLE PIPELINED 
    IS
	    v_array   JSON_ARRAY_T;
	    v_obj     JSON_OBJECT_T;
	    v_keys    JSON_KEY_LIST;
	    v_element JSON_ELEMENT_T;
	BEGIN
	    -- 1. 입력된 CLOB을 JSON 배열로 파싱
	    v_array := JSON_ARRAY_T.parse(P_JSON);
	
	    -- 2. 배열의 크기만큼 루프 (각 객체 꺼내기)
	    FOR i IN 0 .. v_array.get_size - 1 LOOP
	        v_obj := JSON_OBJECT_T(v_array.get(i));
	        v_keys := v_obj.get_keys;
	
	        -- 3. 객체 내부의 모든 Key를 동적으로 추출
	        FOR j IN 1 .. v_keys.COUNT LOOP
	            v_element := v_obj.get(v_keys(j));
	            
	            -- 결과 배출 (배열번호+1, 키이름, 값)
	            PIPE ROW(TY_JSON_ROW(
	                i + 1, 
	                v_keys(j), 
	                TRIM(BOTH '"' FROM v_element.to_string)
	            ));
	        END LOOP;
	    END LOOP;
	
	    RETURN;
	END TFN_JSON;
	
	
END PKG_NSCM_UI_COMM;
/
