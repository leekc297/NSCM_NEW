

-- round 4 흡수:
/*=============================================================================================
 * File         : 05_Standalone_SP_DMF0035.sql
 * Description  : Standalone Procedures — DMF0035 화면 (2개)
 *              : 향후 PKG_DMF0035로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.DMF0035_GET_SPREAD_TITLE
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_BUCKET          IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : DM0035_GET_SPREAD_TITLE                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/02/05  pjs       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2019/02/01	JYE		42, 44 추가                          */
/* 2021/11/03	rosia27		MKT FCST WATERFALL 속도개선												*/
/*
 * 2022/07/19	kdw2819		[C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
 */
/* 2026.03.18   jcnam        [PJ20264226] NextSCM Pilot 설계 및 개발                                  */ 
/****************************************************************************************************/
/*****************************************************************************************************
 ※ 작성 Rule 
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
IS

    V_USER_COL_CNT    PLS_INTEGER := 0;
    V_PROGRAM_ID      VARCHAR2(50 CHAR) := 'DMF0035';
    V_SHEET_NAME      VARCHAR2(50 CHAR) := 'Mkt Fcst Waterfall';

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

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 사용자 컬럼 설정 건수 조회 (Case 28/29: EXISTS 패턴) ── */
    BEGIN
        SELECT 1
        INTO   V_USER_COL_CNT
        FROM   DUAL
        WHERE  EXISTS (
            SELECT 1
            FROM   SCM_MST_TITLESET_USER U
            WHERE  1 = 1
            AND    U.PROGRAM_ID = V_PROGRAM_ID
            AND    U.SHEET_NAME = V_SHEET_NAME
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND    U.USER_ID    = P_CREATED_BY
        );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_USER_COL_CNT := 0;
    END;

    /* ── 메인 조회 결과 반환 (O_RC1) ── */
    IF V_USER_COL_CNT > 0 THEN

        OPEN O_RC1 FOR
        SELECT * FROM (
            /* ── 사용자 설정 컬럼 ── */
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(U.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    U.PROGRAM_ID  = C.PROGRAM_ID
            AND    U.SHEET_NAME  = C.SHEET_NAME
            AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = V_PROGRAM_ID
            AND    U.SHEET_NAME  = V_SHEET_NAME
            AND    U.USER_ID     = P_CREATED_BY
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 비노출 기본 컬럼 ── */
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = V_PROGRAM_ID
            AND    C.SHEET_NAME  = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    C.DEFAULT_FLAG = ''
            AND    C.VALID_YN     = 'Y'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 캘린더 동적 컬럼 ── */
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''         AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''         AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100
                        ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''         AS CELL_COMBO_DATA_TYPE
                 , ''         AS DATA_SCALE_NUMBER
                 , ''         AS DATA_MAX_LENGTH
                 , 'R'        AS HORIZONTAL_ALIGN_CODE
                 , 'Y'        AS UPPERCASE_APPLY_FLAG
                 , 'Y'        AS VISIBLE_FLAG
                 , ''         AS DEFAULT_FLAG
                 , ''         AS USER_SELECTABLE_FLAG
                 , ''         AS VALID_YN
                 --, CASE WHEN INSTR(@p_divisIon_id, '81') > 0 OR INSTR(@p_divisIon_id, '82') > 0 THEN
                    --  CASE WHEN INSTR(@p_divisIon_id, '40') > 0 THEN '40,81,82'
                    --       ELSE '81,82' END
                 --  ELSE
                    --  '40'
                 --  END AS DIVISION_ID
                 , P_DIVISION_ID AS DIVISION_ID      -- 20190201
            FROM  (
                   SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                        , A.DAYOFWEEK               AS DAY_CODE
                        , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                   UNION ALL
                   SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                        , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                        , ''                   AS DAY_CODE
                        , A.BASIS_START_DATE || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.ISO_WEEK
                          , A.WEEK_NAME
                          , A.MONTH_NAME
                          , A.BASIS_START_DATE
                   UNION ALL
                   SELECT 'M_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                         , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                         , ''                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                   FROM    SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
                   UNION ALL
                   SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK AS COLUMN_NAME
                         , WEEK_NAME AS COLUMN_LABEL_NAME
                         , WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                         , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                         || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
                         , ''                   AS DAY_CODE
                         , MAX(BASIS_YYYYMMDD) || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                   AND    1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
              ) T
        ) A
        WHERE INSTR(',' || A.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0
        ORDER BY SORT_ORDER_NO;

    ELSE
        /* ── V_USER_COL_CNT = 0 : 기본 컬럼 설정 ── */
        OPEN O_RC1 FOR
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
             , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
        FROM   SCM_MST_SHEET_COLUMNS C
        WHERE  1 = 1
        AND    C.PROGRAM_ID  = V_PROGRAM_ID
        AND    C.SHEET_NAME  = V_SHEET_NAME
        AND    C.DEFAULT_FLAG = 'Y'
        AND    C.VALID_YN     = 'Y'
        AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

        UNION ALL

        SELECT * FROM (
            /* ── 비노출 기본 컬럼 ── */
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.COLUMN_LABEL_NAME
                 , TO_CHAR(C.SORT_ORDER_NO) AS SORT_ORDER_NO        --CONVERT(NVARCHAR(10), U.SORT_ORDER_NO) AS SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
                 , C.SMALL_CLASS_LABEL_NAME
                 , C.LARGE_CLASS_LABEL_NAME
                 , '' AS DAY_CODE
                 , C.FIXED_FLAG
                 , C.COLUMN_WIDTH
                 , C.CELL_CONTROL_OBJECT_TYPE_CODE
                 , C.CELL_COMBO_DATA_TYPE
                 , TO_CHAR(C.DATA_SCALE_NUMBER) AS DATA_SCALE_NUMBER
                 , TO_CHAR(C.DATA_MAX_LENGTH) AS DATA_MAX_LENGTH
                 , C.HORIZONTAL_ALIGN_CODE
                 , C.UPPERCASE_APPLY_FLAG
                 , C.VISIBLE_FLAG
                 , C.DEFAULT_FLAG
                 , C.USER_SELECTABLE_FLAG
                 , C.VALID_YN
                 , C.DIVISION_ID
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = V_PROGRAM_ID
            AND    C.SHEET_NAME  = V_SHEET_NAME
            AND    C.VISIBLE_FLAG = ''
            AND    C.DEFAULT_FLAG = ''
            AND    C.VALID_YN     = 'Y'
            AND    INSTR(',' || C.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0

            UNION ALL

            /* ── 캘린더 동적 컬럼 ── */
            SELECT V_PROGRAM_ID   AS PROGRAM_ID
                 , V_SHEET_NAME AS SHEET_NAME
                 , T.COLUMN_NAME
                 , T.COLUMN_LABEL_NAME
                 , T.SORT_ORDER_NO
                 , ''         AS DATA_SORT_METHOD_CODE
                 , T.SMALL_CLASS_LABEL_NAME
                 , T.LARGE_CLASS_LABEL_NAME
                 , T.DAY_CODE
                 , ''         AS FIXED_FLAG
                 , CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 100
                        ELSE 50 END AS COLUMN_WIDTH
                 , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                 , ''         AS CELL_COMBO_DATA_TYPE
                 , ''         AS DATA_SCALE_NUMBER
                 , ''         AS DATA_MAX_LENGTH
                 , 'R'        AS HORIZONTAL_ALIGN_CODE
                 , 'Y'        AS UPPERCASE_APPLY_FLAG
                 , 'Y'        AS VISIBLE_FLAG
                 , ''         AS DEFAULT_FLAG
                 , ''         AS USER_SELECTABLE_FLAG
                 , ''         AS VALID_YN
                 --, CASE WHEN INSTR(@p_divisIon_id, '81') > 0 OR INSTR(@p_divisIon_id, '82') > 0 THEN
                    --  CASE WHEN INSTR(@p_divisIon_id, '40') > 0 THEN '40,81,82'
                    --       ELSE '81,82' END
                 --  ELSE
                    --  '40'
                 --  END AS DIVISION_ID
                 , P_DIVISION_ID AS DIVISION_ID      -- 20190201
            FROM  (
                   SELECT 'D_' || A.BASIS_YYYYMMDD   AS COLUMN_NAME
                        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME
                        , A.DAYOFWEEK               AS DAY_CODE
                        , A.BASIS_YYYYMMDD || TO_CHAR(31) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                   UNION ALL
                   SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK   AS COLUMN_NAME
                        , A.WEEK_NAME          AS COLUMN_LABEL_NAME
                        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
                        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME
                        , ''                   AS DAY_CODE
                        , A.BASIS_START_DATE || TO_CHAR(21) AS SORT_ORDER_NO
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.ISO_WEEK
                          , A.WEEK_NAME
                          , A.MONTH_NAME
                          , A.BASIS_START_DATE
                   UNION ALL
                   SELECT 'M_' || A.BASIS_YYYYMM  AS COLUMN_NAME
                         , A.MONTH_NAME          AS COLUMN_LABEL_NAME
                         , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
                         , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
                         , ''                    AS DAY_CODE
                         , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                   FROM    SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --CONVERT(CHAR(8), ADD_MONTHS(CURRENT_TIMESTAMP, (1) * 12), 112)
                   AND    1 = CASE WHEN P_BUCKET != 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   -- [C20220620-000567]GSCM DM 시스템의 수작업 LOSS 및 분석 용이하기 하귀 위한 기능 개선 ( Partail week의 경우 week만 표시)
                   UNION ALL
                   SELECT 'W_' || SUBSTR(MAX(BASIS_YYYYMMDD), 1, 6) || ISO_WEEK  AS COLUMN_NAME
                         , WEEK_NAME AS COLUMN_LABEL_NAME
                         , WEEK_NAME AS SMALL_CLASS_LABEL_NAME
                         , SUBSTR(MIN(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MIN(BASIS_YYYYMMDD), 7, 2)
                         || ' ~ ' || SUBSTR(MAX(BASIS_YYYYMMDD), 5, 2) || '.' || SUBSTR(MAX(BASIS_YYYYMMDD), 7, 2)  AS LARGE_CLASS_LABEL_NAME
                         , ''                   AS DAY_CODE
                         , MAX(BASIS_YYYYMMDD) || TO_CHAR(21) AS SORT_ORDER_NO
                   -- , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                   FROM   SCM_SYS_CALENDAR_M A
                   WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                   AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                   AND    1 = CASE WHEN P_BUCKET = 'ONLY_WEEKLY' THEN 1 ELSE 2 END
                   GROUP BY ISO_YYYYWW, ISO_WEEK, WEEK_NAME
                ) T
            ) A
            WHERE INSTR(',' || A.DIVISION_ID || ',', ',' || P_DIVISION_ID || ',') > 0
          ORDER BY SORT_ORDER_NO;

    END IF;

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
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_BUCKET'         VALUE P_BUCKET
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
END DMF0035_GET_SPREAD_TITLE;
/
