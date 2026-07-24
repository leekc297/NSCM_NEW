CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_GET_TEXTBOX" 
(
    P_VERSION_NO      IN VARCHAR2,
    P_USER_ID	      IN VARCHAR2, -- For EditYn
    P_MNU_ID	      IN VARCHAR2, -- For EditYn
    O_RC1	      OUT SYS_REFCURSOR,
    O_RC2	      OUT SYS_REFCURSOR,
    O_RC3	      OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
/*************************************************************************************************
* Program ID  : DMF0044_GET_TEXTBOX
* Description : Procedure 작성 가이드
* Usage       : TextBox 를 열 때 사용. 생성된 VERSION_NO 를 조회할 때에는 날짜와 13개의 DESCRIPTION 받음.
* Parameter   :
*
*------------------------------------------------------------------------------------------------
* Date	      In Charge    Description
*------------------------------------------------------------------------------------------------
* 2021-09-15   ROSIA27		[과제] TEXTBOX
* 2026.03.20   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발
***************************************************************************************************/
IS

    V_YYYYMMDD	      VARCHAR2(8 CHAR);

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE	    VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE	    VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE	  := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 결과셋 1: DESCRIPTION 컬럼 조회 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT
	DESCRIPTION1
	, DESCRIPTION2
	, DESCRIPTION3
	, DESCRIPTION4
	, DESCRIPTION5
	, DESCRIPTION6
	, DESCRIPTION7
	, DESCRIPTION8
	, DESCRIPTION9
	, DESCRIPTION10
	, DESCRIPTION11
	, DESCRIPTION12
	, DESCRIPTION13
    FROM DM_MDF_VERSION T1
    INNER JOIN (SELECT * -- EDIT_YN
		FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
		WHERE USER_ID = P_USER_ID
		AND MNU_ID = P_MNU_ID
		AND UNIT_TP_CD = 'D') T2
	ON T1.DIVISION_ID = T2.UNIT_ID
    WHERE
	T1.DIVISION_ID = '82'
	AND VERSION_NO = P_VERSION_NO;

    /* ── YYYYMMDD 변수 조회 ── */
    BEGIN
	SELECT YYYYMMDD
	INTO   V_YYYYMMDD
	FROM   DM_MDF_VERSION
	WHERE  DIVISION_ID = '82'
	AND    VERSION_NO = P_VERSION_NO;
    EXCEPTION
	WHEN NO_DATA_FOUND THEN
	    V_YYYYMMDD := NULL;
    END;

    /* ── 결과셋 2: YYYYMMDD (O_RC2) ── */
    OPEN O_RC2 FOR
    SELECT V_YYYYMMDD AS YYYYMMDD FROM DUAL;

    /* ── 결과셋 3: MONDAY 계산 (O_RC3) ── */
    /* CONVERT(CHAR(11), DATEADD(DD, -7, dbo.FN_NEXT_DAY(@YYYYMMDD, 'MON')), 120) */
    /* → TO_CHAR(FN_NEXT_DAY(TO_DATE(V_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYY-MM-DD') */
    OPEN O_RC3 FOR
    SELECT TO_CHAR(FN_NEXT_DAY(TO_DATE(V_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYY-MM-DD') AS MONDAY FROM DUAL;

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE	  := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
	ROLLBACK;

        -- 2) 에러 정보 캡처
	V_LOG_TYPE    := 'ERROR';
	V_LOG_MESSAGE := 'EXCEPTION';
	V_DESCRIPTION := '';
	D_EVENT_DATE  := SYSDATE;
	V_SQL_CODE    := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG  := SQLERRM;
	V_PROC_INPUT  := JSON_OBJECT(
	    'P_VERSION_NO' VALUE P_VERSION_NO,
	    'P_USER_ID'   VALUE P_USER_ID,
	    'P_MNU_ID'	 VALUE P_MNU_ID
	);
	V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
	BEGIN
	    SCM_MGR.PR_SCM_SYS_LOG_BATCH(
		$$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
		V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
		V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
	    );
	END;

        -- 4) 에러 전파 (O_RESULT_CURSOR 미오픈)
	RAISE_APPLICATION_ERROR(-20001,
	  '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
	  ' / SQLERRM=' || V_SQL_ERRMSG ||
	  ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	  ' / PARAMS=' || V_PROC_INPUT
	);
END DMF0044_GET_TEXTBOX;