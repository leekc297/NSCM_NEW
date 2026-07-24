CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0044_GET_SPREAD_TITLE" 
(
	P_DIVISION_ID			VARCHAR2 DEFAULT '40',
	P_CREATED_BY			VARCHAR2 DEFAULT 'greenzun',
	P_START_DT				VARCHAR2 DEFAULT '20190101',
	P_END_DT				VARCHAR2 DEFAULT '20191231',
	O_RC1					OUT SYS_REFCURSOR,
	O_RESULT_CURSOR			OUT SYS_REFCURSOR
)
/****************************************************************************************************/
/* Program ID  : DMF0044_GET_SPREAD_TITLE                                                          */
/* Description : MDF Reports 스프레드 타이틀(컬럼 정의 + 기간 월별 동적컬럼) 조회                  */
/* Program History                                                                                 */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/05/15  JYE          DMF0044_GET_SPREAD_TITLE                                                */
/* 2020/10/06  hwi1993      C20201005-000291 Sales Report 대량변경. 소수점 자리수를 룩업에서 먼저   */
/*                          찾도록 함 ( 소형만 10자리 )                                             */
/* 2022.04.13  HWI1993      GM JV 작업                                                              */
/* 2026.06.08  변환         [PJ20264226] NextSCM Pilot 재변환 (깨진 자동변환 정정:                  */
/*                          OUT커서 래핑 / 변수 중복선언 제거 / ) MA; 조기종료·ORDER BY 분리 수정)  */
/****************************************************************************************************/
IS

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

    /* ── 비즈니스 변수 ── */
    P_PROGRAM_ID        VARCHAR2(50 CHAR);
    P_SHEET_NAME        VARCHAR2(50 CHAR);
    V_DATA_SCALE_NUMBER VARCHAR2(2 CHAR);

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 소수점 자리수 룩업 (해당 division 설정이 없으면 NULL 유지) ── */
    BEGIN
        SELECT SEGMENT3
          INTO V_DATA_SCALE_NUMBER
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'DMF0044_CONFIG'
           AND SEGMENT1 = P_DIVISION_ID
           AND SEGMENT2 = 'DIGIT_NUMBER';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN V_DATA_SCALE_NUMBER := NULL;
    END;

    P_PROGRAM_ID := 'DMF0044';
    P_SHEET_NAME := 'MDF Reports';

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    OPEN O_RC1 FOR
    SELECT C.PROGRAM_ID
        , C.SHEET_NAME
        , C.COLUMN_NAME
        , C.COLUMN_LABEL_NAME
        --, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
        , CASE WHEN P_DIVISION_ID = '40' THEN C.SORT_ORDER_NO
               WHEN P_DIVISION_ID like '81%' THEN TO_NUMBER(C.ATTRIBUTE2)
               WHEN P_DIVISION_ID = '82' THEN TO_NUMBER(C.ATTRIBUTE3)
               END AS SORT_ORDER_NO   -- CASE/UNION 타입통일(NUMBER): 원본 MSSQL precedence(int) 동등
        , C.DATA_SORT_METHOD_CODE
        , C.SMALL_CLASS_LABEL_NAME
        , C.LARGE_CLASS_LABEL_NAME
        , '' AS DAY_CODE
        , C.FIXED_FLAG
        , CASE WHEN
                CASE WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
                     WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
                     WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
                     END = 'Y'
                     THEN C.COLUMN_WIDTH
            ELSE 0
            END AS COLUMN_WIDTH
        , C.CELL_CONTROL_OBJECT_TYPE_CODE
        , C.CELL_COMBO_DATA_TYPE
        , C.DATA_SCALE_NUMBER
        , C.DATA_MAX_LENGTH
        , C.HORIZONTAL_ALIGN_CODE
        , C.UPPERCASE_APPLY_FLAG
        , CASE  WHEN P_DIVISION_ID = '40' THEN C.VISIBLE_FLAG
                WHEN P_DIVISION_ID like '81%' THEN C.ATTRIBUTE4
                WHEN P_DIVISION_ID = '82' THEN C.ATTRIBUTE5
                END AS VISIBLE_FLAG
        , C.DEFAULT_FLAG
        , C.USER_SELECTABLE_FLAG
        , C.VALID_YN
        , C.DIVISION_ID
        , P_DIVISION_ID as ATTRIBUTE1		-- COMMONDATALIST 에서 사용하도록 DIVISION 을 넣어준다.
        , CASE WHEN CELL_COMBO_DATA_TYPE = 'DM_LOOKUP_DIV' THEN C.ATTRIBUTE1 ELSE C.ATTRIBUTE1 END AS ATTRIBUTE2
        , C.ATTRIBUTE3
        , C.ATTRIBUTE4
        , C.ATTRIBUTE5
    FROM   SCM_MST_SHEET_COLUMNS C
    WHERE  1 = 1
        AND    C.PROGRAM_ID  = P_PROGRAM_ID
        AND    C.SHEET_NAME  = P_SHEET_NAME
        AND    C.VALID_YN     = 'Y'
        --AND	   C.DIVISION_ID LIKE '%' + P_DIVISION_ID + '%'
        AND	    P_DIVISION_ID IN (SELECT token FROM TABLE(FN_STRING_SPLIT(C.DIVISION_ID ,',')) )
    UNION ALL

    SELECT
        P_PROGRAM_ID   AS PROGRAM_ID
        , P_SHEET_NAME AS SHEET_NAME
        , MA.COLUMN_NAME
        , MA.COLUMN_LABEL_NAME
        , TO_NUMBER(MA.SORT_ORDER_NO)         AS SORT_ORDER_NO   -- UNION 타입통일(NUMBER): 원본 MSSQL 결과타입 보존
        , ''         AS DATA_SORT_METHOD_CODE
        , MA.SMALL_CLASS_LABEL_NAME
        , MA.LARGE_CLASS_LABEL_NAME
        , MA.DAY_CODE
        , ''         AS FIXED_FLAG
        , CASE WHEN V_DATA_SCALE_NUMBER IS NULL THEN 120 ELSE 200 END         AS COLUMN_WIDTH
        , MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
        , ''         AS CELL_COMBO_DATA_TYPE
        --, '2'         AS DATA_SCALE_NUMBER
        , TO_NUMBER(NVL(V_DATA_SCALE_NUMBER, '3'))         AS DATA_SCALE_NUMBER -- 20181029  (UNION 타입통일 NUMBER)
        , 2         AS DATA_MAX_LENGTH
        , 'R'        AS HORIZONTAL_ALIGN_CODE
        , ''        AS UPPERCASE_APPLY_FLAG
        , 'Y'        AS VISIBLE_FLAG
        , ''         AS DEFAULT_FLAG
        , ''     AS USER_SELECTABLE_FLAG
        , ''         AS VALID_YN
        , ''			AS DIVISION_ID
        , '' AS ATTRIBUTE1
        , '' AS ATTRIBUTE2
        , '' AS ATTRIBUTE3
        , '' AS ATTRIBUTE4
        , '' AS ATTRIBUTE5
    FROM  (
        SELECT
            DISTINCT
            'M_'  ||  BASIS_YYYYMM								AS COLUMN_NAME
            , MONTH_NAME										AS COLUMN_LABEL_NAME
            , MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
            , MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
            , ''														AS DAY_CODE
            , BASIS_YYYYMM									AS SORT_ORDER_NO
            , 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
        FROM SCM_SYS_CALENDAR_M
        WHERE  BASIS_YYYYMMDD >= P_START_DT
            AND BASIS_YYYYMMDD <= P_END_DT

    ) MA
    ORDER BY SORT_ORDER_NO;

    /*  ── (참고) 구버전 백업 쿼리 — 원본 주석 보존 ──

	p_program_id := 'DMF0044';
	p_sheet_name := 'MDF Reports';

	SELECT C.PROGRAM_ID
		, C.SHEET_NAME
		, C.COLUMN_NAME
		, C.COLUMN_LABEL_NAME
		, C.SORT_ORDER_NO        --TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO
		, C.DATA_SORT_METHOD_CODE
		, C.SMALL_CLASS_LABEL_NAME
		, C.LARGE_CLASS_LABEL_NAME
		, '' AS DAY_CODE
		, C.FIXED_FLAG
		, C.COLUMN_WIDTH
		, C.CELL_CONTROL_OBJECT_TYPE_CODE
		, C.CELL_COMBO_DATA_TYPE
		, C.DATA_SCALE_NUMBER
		, C.DATA_MAX_LENGTH
		, C.HORIZONTAL_ALIGN_CODE
		, C.UPPERCASE_APPLY_FLAG
		, C.VISIBLE_FLAG
		, C.DEFAULT_FLAG
		, C.USER_SELECTABLE_FLAG
		, C.VALID_YN
		, C.DIVISION_ID
		, C.ATTRIBUTE1
	FROM   SCM_MST_SHEET_COLUMNS C
	WHERE  1 = 1
		AND    C.PROGRAM_ID  = p_program_id
		AND    C.SHEET_NAME  = p_sheet_name
		--AND    C.DEFAULT_FLAG = 'Y'
		AND    C.VALID_YN     = 'Y'
		AND	 p_division_id IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,',')) )
		--AND    C.COLUMN_NAME IN ('LAST_UPDATE_DATE', 'LAST_UPDATED_BY')
	UNION ALL

	SELECT
		p_program_id   AS PROGRAM_ID
		, p_sheet_name AS SHEET_NAME
		, MA.COLUMN_NAME
		, MA.COLUMN_LABEL_NAME
		, MA.SORT_ORDER_NO
		, ''         AS DATA_SORT_METHOD_CODE
		, MA.SMALL_CLASS_LABEL_NAME
		, MA.LARGE_CLASS_LABEL_NAME
		, MA.DAY_CODE
		, ''         AS FIXED_FLAG
		, 120         AS COLUMN_WIDTH
		, MA.CELL_CONTROL_OBJECT_TYPE_CODE   --'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
		, ''         AS CELL_COMBO_DATA_TYPE
		--, '2'         AS DATA_SCALE_NUMBER
		, '3'         AS DATA_SCALE_NUMBER -- 20181029
		, '2'         AS DATA_MAX_LENGTH
		, 'R'        AS HORIZONTAL_ALIGN_CODE
		, ''        AS UPPERCASE_APPLY_FLAG
		, 'Y'        AS VISIBLE_FLAG
		, ''         AS DEFAULT_FLAG
		, ''         AS USER_SELECTABLE_FLAG
		, ''         AS VALID_YN
		, ''			AS DIVISION_ID
		, '' AS ATTRIBUTE1
	FROM  (
		SELECT
			DISTINCT
			'M_' || BASIS_YYYYMM								AS COLUMN_NAME
			, MONTH_NAME										AS COLUMN_LABEL_NAME
			, MONTH_NAME										AS SMALL_CLASS_LABEL_NAME
			, MONTH_NAME										AS LARGE_CLASS_LABEL_NAME
			, ''														AS DAY_CODE
			, BASIS_YYYYMM									AS SORT_ORDER_NO
			, 'FPNumber'											AS CELL_CONTROL_OBJECT_TYPE_CODE
		FROM SCM_SYS_CALENDAR_M
		WHERE  BASIS_YYYYMMDD >= p_start_dt
			AND BASIS_YYYYMMDD <= p_end_dt

	) MA
	ORDER BY SORT_ORDER_NO
    */

    /* ── 프로시저 처리 결과 반환 (O_RESULT_CURSOR) — 조회 성공 ── */
    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
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
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_CREATED_BY'  VALUE P_CREATED_BY,
            'P_START_DT'    VALUE P_START_DT,
            'P_END_DT'      VALUE P_END_DT
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
        RAISE;
END DMF0044_GET_SPREAD_TITLE;