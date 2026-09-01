CREATE OR REPLACE PACKAGE BODY         PKG_DMF0053 AS

    PROCEDURE P_DMF0053_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD    IN  VARCHAR2,
        P_END_YYYYMMDD      IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_DIVISION_ID       IN  VARCHAR2,
        P_BUCKET            IN  VARCHAR2,
        P_USER_ID           IN  VARCHAR2,
        P_MENU_ID           IN  VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_ID    VARCHAR2(50) := 'DMF0053';
        V_SHEET_NAME    VARCHAR2(50) := 'CUST Fcst Waterfall';
        V_USER_COL_CNT  NUMBER       := 0;
        -- SQLERRM 은 SQL 문 안에서 직접 못 쓴다(ORA-00904). 변수에 담아 커서로 넘긴다.
        V_ERR_MSG       VARCHAR2(4000);
    BEGIN
        -- 사용자별 컬럼 설정 보유 여부
        SELECT COUNT(*)
          INTO V_USER_COL_CNT
          FROM SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = V_PROGRAM_ID
           AND U.SHEET_NAME = V_SHEET_NAME
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
           AND U.USER_ID    = P_CREATED_BY;

        IF V_USER_COL_CNT > 0 THEN
            ----------------------------------------------------------------------------------------
            -- 사용자 설정이 있는 경우
            ----------------------------------------------------------------------------------------
            OPEN O_RC1 FOR
                SELECT U.PROGRAM_ID, U.SHEET_NAME, U.COLUMN_NAME, C.COLUMN_LABEL_NAME
                     , U.SORT_ORDER_NO, U.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                     , '' AS DAY_CODE
                     , C.FIXED_FLAG, C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
                  FROM SCM_MST_TITLESET_USER  U
                     , SCM_MST_SHEET_COLUMNS  C
                 WHERE U.PROGRAM_ID  = C.PROGRAM_ID
                   AND U.SHEET_NAME  = C.SHEET_NAME
                   AND U.COLUMN_NAME = C.COLUMN_NAME
                   AND U.PROGRAM_ID  = V_PROGRAM_ID
                   AND U.SHEET_NAME  = V_SHEET_NAME
                   AND U.USER_ID     = P_CREATED_BY
                   AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                   AND P_DIVISION_ID IN (
                           SELECT REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL)
                             FROM DUAL
                          CONNECT BY LEVEL <= REGEXP_COUNT(C.DIVISION_ID, ',') + 1
                       )
                UNION ALL
                -- 숨김 컬럼 편입 (MEASURE) — 보정 조건. 머리글 주석 참조.
                SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                     , '' AS DAY_CODE
                     , C.FIXED_FLAG, C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
                  FROM SCM_MST_SHEET_COLUMNS C
                 WHERE C.PROGRAM_ID   = V_PROGRAM_ID
                   AND C.SHEET_NAME   = V_SHEET_NAME
                   AND C.VISIBLE_FLAG = 'N'
                   AND NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'
                   AND C.VALID_YN     = 'Y'
                   AND P_DIVISION_ID IN (
                           SELECT REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL)
                             FROM DUAL
                          CONNECT BY LEVEL <= REGEXP_COUNT(C.DIVISION_ID, ',') + 1
                       )
                UNION ALL
                -- 기간 컬럼 (달력)
                SELECT V_PROGRAM_ID AS PROGRAM_ID, V_SHEET_NAME AS SHEET_NAME
                     , T.COLUMN_NAME, T.COLUMN_LABEL_NAME, T.SORT_ORDER_NO
                     , '' AS DATA_SORT_METHOD_CODE
                     , T.SMALL_CLASS_LABEL_NAME, T.LARGE_CLASS_LABEL_NAME, T.DAY_CODE
                     , '' AS FIXED_FLAG, 50 AS COLUMN_WIDTH
                     , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                     , '' AS CELL_COMBO_DATA_TYPE
                     , 3 AS DATA_SCALE_NUMBER, CAST(NULL AS NUMBER) AS DATA_MAX_LENGTH
                     , 'R' AS HORIZONTAL_ALIGN_CODE, 'Y' AS UPPERCASE_APPLY_FLAG
                     , 'Y' AS VISIBLE_FLAG, '' AS DEFAULT_FLAG
                     , '' AS USER_SELECTABLE_FLAG, '' AS VALID_YN, '' AS DIVISION_ID
                  FROM (
                        SELECT 'D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                             , A.CALENDAR_DAY  AS COLUMN_LABEL_NAME
                             , A.WEEK_NAME     AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME    AS LARGE_CLASS_LABEL_NAME
                             , A.DAYOFWEEK     AS DAY_CODE
                             , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                           AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                        UNION ALL
                        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
                             , A.WEEK_NAME  AS COLUMN_LABEL_NAME
                             , A.WEEK_NAME  AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                             , '' AS DAY_CODE
                             , TO_NUMBER(A.BASIS_START_DATE || '21') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME
                                , A.BASIS_START_DATE
                        UNION ALL
                        SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                             , A.MONTH_NAME AS COLUMN_LABEL_NAME
                             , A.MONTH_NAME AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                             , '' AS DAY_CODE
                             , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       ) T
                 ORDER BY SORT_ORDER_NO;

        ELSE
            ----------------------------------------------------------------------------------------
            -- 사용자 설정이 없는 경우 — 컬럼 메타 DEFAULT_FLAG='Y'
            ----------------------------------------------------------------------------------------
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                     , '' AS DAY_CODE
                     , C.FIXED_FLAG, C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
                  FROM SCM_MST_SHEET_COLUMNS C
                 WHERE C.PROGRAM_ID   = V_PROGRAM_ID
                   AND C.SHEET_NAME   = V_SHEET_NAME
                   AND C.DEFAULT_FLAG = 'Y'
                   AND C.VALID_YN     = 'Y'
                   AND P_DIVISION_ID IN (
                           SELECT REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL)
                             FROM DUAL
                          CONNECT BY LEVEL <= REGEXP_COUNT(C.DIVISION_ID, ',') + 1
                       )
                UNION ALL
                -- 숨김 컬럼 편입 (MEASURE) — 보정 조건. 머리글 주석 참조.
                SELECT C.PROGRAM_ID, C.SHEET_NAME, C.COLUMN_NAME, C.COLUMN_LABEL_NAME
                     , C.SORT_ORDER_NO, C.DATA_SORT_METHOD_CODE
                     , C.SMALL_CLASS_LABEL_NAME, C.LARGE_CLASS_LABEL_NAME
                     , '' AS DAY_CODE
                     , C.FIXED_FLAG, C.COLUMN_WIDTH
                     , C.CELL_CONTROL_OBJECT_TYPE_CODE, C.CELL_COMBO_DATA_TYPE
                     , C.DATA_SCALE_NUMBER, C.DATA_MAX_LENGTH, C.HORIZONTAL_ALIGN_CODE
                     , C.UPPERCASE_APPLY_FLAG, C.VISIBLE_FLAG, C.DEFAULT_FLAG
                     , C.USER_SELECTABLE_FLAG, C.VALID_YN, C.DIVISION_ID
                  FROM SCM_MST_SHEET_COLUMNS C
                 WHERE C.PROGRAM_ID   = V_PROGRAM_ID
                   AND C.SHEET_NAME   = V_SHEET_NAME
                   AND C.VISIBLE_FLAG = 'N'
                   AND NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'
                   AND C.VALID_YN     = 'Y'
                   AND P_DIVISION_ID IN (
                           SELECT REGEXP_SUBSTR(C.DIVISION_ID, '[^,]+', 1, LEVEL)
                             FROM DUAL
                          CONNECT BY LEVEL <= REGEXP_COUNT(C.DIVISION_ID, ',') + 1
                       )
                UNION ALL
                -- 기간 컬럼 (달력)
                SELECT V_PROGRAM_ID AS PROGRAM_ID, V_SHEET_NAME AS SHEET_NAME
                     , T.COLUMN_NAME, T.COLUMN_LABEL_NAME, T.SORT_ORDER_NO
                     , '' AS DATA_SORT_METHOD_CODE
                     , T.SMALL_CLASS_LABEL_NAME, T.LARGE_CLASS_LABEL_NAME, T.DAY_CODE
                     , '' AS FIXED_FLAG, 50 AS COLUMN_WIDTH
                     , 'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                     , '' AS CELL_COMBO_DATA_TYPE
                     , 3 AS DATA_SCALE_NUMBER, CAST(NULL AS NUMBER) AS DATA_MAX_LENGTH
                     , 'R' AS HORIZONTAL_ALIGN_CODE, 'Y' AS UPPERCASE_APPLY_FLAG
                     , 'Y' AS VISIBLE_FLAG, '' AS DEFAULT_FLAG
                     , '' AS USER_SELECTABLE_FLAG, '' AS VALID_YN, '' AS DIVISION_ID
                  FROM (
                        SELECT 'D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                             , A.CALENDAR_DAY  AS COLUMN_LABEL_NAME
                             , A.WEEK_NAME     AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME    AS LARGE_CLASS_LABEL_NAME
                             , A.DAYOFWEEK     AS DAY_CODE
                             , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                           AND 1 = CASE WHEN P_BUCKET = 'DAILY' THEN 1 ELSE 2 END
                        UNION ALL
                        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS COLUMN_NAME
                             , A.WEEK_NAME  AS COLUMN_LABEL_NAME
                             , A.WEEK_NAME  AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                             , '' AS DAY_CODE
                             , TO_NUMBER(A.BASIS_START_DATE || '21') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.WEEK_NAME, A.MONTH_NAME
                                , A.BASIS_START_DATE
                        UNION ALL
                        SELECT 'M_' || A.BASIS_YYYYMM AS COLUMN_NAME
                             , A.MONTH_NAME AS COLUMN_LABEL_NAME
                             , A.MONTH_NAME AS SMALL_CLASS_LABEL_NAME
                             , A.MONTH_NAME AS LARGE_CLASS_LABEL_NAME
                             , '' AS DAY_CODE
                             , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01') AS SORT_ORDER_NO
                          FROM SCM_SYS_CALENDAR_M A
                         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
                           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
                         GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                       ) T
                 ORDER BY SORT_ORDER_NO;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := '[' || $$PLSQL_UNIT || '] ' || SQLERRM;
            -- 커서를 안 열고 나가면 BE 가 읽다 죽는다. 빈 커서라도 반드시 연다.
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT * FROM SCM_MST_SHEET_COLUMNS WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS CODE
                     , V_ERR_MSG AS MSG
                     , '' AS EVENT
                  FROM DUAL;
    END P_DMF0053_GET_SPREAD_TITLE;


    -- ============================================================================================
    --  본문 조회
    --
    --  원본 : DMF0053_GET_CUST_FCST_WATERFALL (MSSQL, 1,330행)
    --  변환 방식은 같은 구조의 자매 화면 PKG_DMF0021 실측을 그대로 따랐다.
    --    · #임시테이블      -> GT_DMF0053_* (GTT, 초기화는 DELETE)
    --    · SELECT INTO #WF  -> WITH WF 인라인 뷰 (동적 SQL 안에서는 임시표를 만들 수 없다)
    --    · EXEC SP_EXECUTESQL -> OPEN O_RC1 FOR v_sql_text
    --    · MSSQL PIVOT 대괄호 식별자 [X] 변환
    --        PIVOT IN 리스트  : [X] -> 'X' AS "X"
    --        피벗 결과 컬럼   : [X] -> "X"
    --        그룹/정렬 컬럼   : [X] -> X   (대괄호만 제거)
    --
    --  ★ 원본에서 고친 곳
    --   (1) `C.MEASURE <> ''` -> `C.MEASURE IS NOT NULL`
    --       Oracle 은 빈 문자열이 NULL 이라 `<> ''` 가 늘 UNKNOWN 이다. 그대로 두면
    --       CUST_FCST 하위 Measure 가 통째로 빠진다(CNS 가이드 10항 2번과 같은 자리).
    --   (2) 컬럼 목록의 `DEFAULT_FLAG = ''` -> `NVL(TRIM(DEFAULT_FLAG),'-') = '-'`
    --       머리글 프로시저와 같은 보정이다. 이 조건이 죽으면 MEASURE 열이 목록에서 빠지고
    --       [MEASURE] -> [MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO] 치환도 일어나지 않는다.
    --   (3) SELECT_MEASURE 의 SORT_ORDER_NO 는 원본대로 **덧셈**(A + B)을 유지한다.
    --       하이픈 통일 변환본은 이 자리를 `||`(문자열 연결)로 바꿔 두었는데, 그러면
    --       20 + 0.14 = 20.14 가 '200.14' 가 되어 Measure 정렬이 어긋난다.
    --   (4) `WITH(NOLOCK, INDEX(...))` · `option (hash join)` · `option (order group)` 제거.
    --   (5) DELETE ... FROM ... LEFT JOIN (토큰) WHERE TOKEN IS NULL
    --       -> DELETE ... WHERE [EXISTS(마스터)] AND NOT EXISTS(토큰 매칭)
    --       원본의 INNER/LEFT 구분을 그대로 살렸다 — 마스터에 없는 행은 삭제 대상이 아니다.
    --
    --  ★ 셀 환산(CellQtyYN)은 AS-IS 에서 죽어 있다. 자리표시자를 채우는 치환 한 줄이 주석
    --    처리되어 조건이 늘 거짓이고, 화면도 값을 보내지 않으며 인자 목록에도 없다.
    --    되살리지 않고 그대로 둔다(설계서 4-7항).
    -- ============================================================================================
    PROCEDURE P_DMF0053_GET_CUST_FCST_WATERFALL
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_DEPT_ID           IN  VARCHAR2,
        P_END_CUSTOMER      IN  VARCHAR2,
        P_SCM_SITE_ID       IN  VARCHAR2,
        P_PROJECT_CODE      IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_ITEM_TYPE         IN  VARCHAR2,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_PLANT_SITE_ID     IN  VARCHAR2,
        P_BIZ_TYPE          IN  VARCHAR2,
        P_OWNER             IN  VARCHAR2,
        P_BUCKET            IN  VARCHAR2,
        P_USER_DEPT_ID      IN  VARCHAR2,
        P_GROUP_ID          IN  VARCHAR2,
        P_VERSION_NO        IN  VARCHAR2,
        P_FROM_CREATEDATE   IN  VARCHAR2,
        P_TO_CREATEDATE     IN  VARCHAR2,
        P_USER_ID           IN  VARCHAR2,
        P_MENU_ID           IN  VARCHAR2,

        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RC3               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_ID     VARCHAR2(50)  := 'DMF0053';
        V_SHEET_NAME     VARCHAR2(50)  := 'CUST Fcst Waterfall';
        V_USER_MEA_CNT   NUMBER        := 0;
        V_USER_COL_CNT   NUMBER        := 0;

        V_COL_LIST       CLOB;          /* [A],[B],...  사용자 표시 컬럼 */
        V_ORDER_LIST     CLOB;          /* [A] ASC,...  정렬 문자열 */
        V_PV_LIST        CLOB;          /* [D_...],[W_...]  기간 컬럼 */
        V_PV_COL         CLOB;          /* NVL([X],0) AS [X]  (40 전용 표기) */
        V_SQL_SELECT     CLOB;          /* 산출식을 이어 붙인 SELECT 절 */
        V_SQL_GROUPBY    CLOB;          /* 위에서 별칭을 뗀 GROUP BY 절 */

        V_COL_PLAIN      CLOB;          /* 대괄호 뗀 컬럼 목록 */
        V_ORDERBY_PLAIN  CLOB;          /* 대괄호 뗀 정렬 문자열 */
        V_PV_IN          CLOB;          /* PIVOT IN 리스트 */
        V_PV_PROJ        CLOB;          /* 피벗 결과 컬럼 */

        V_SQL_TEXT       CLOB;
        V_ORDER          CLOB;
        V_ERR_MSG        VARCHAR2(4000);

        /* 0 을 버리지 않는 Measure — 고객이 0 을 보낸 것과 안 보낸 것을 가르기 위한 처리다.
           비교값을 -9999999999 로 두어 사실상 걸러내지 않는다(설계서 4-8항). */
        V_KEEP_ZERO      VARCHAR2(400)  :=
            '''CUST_FCST'',''CUST_FCST_EDI'',''Immidiate'',''Planning_Forecast''' ||
            ',''Commercial_Agreement'',''Firm_Temp'',''Manumacturing_Material_Temp''' ||
            ',''Material_Temp'',''Backorder''';
    BEGIN
        --========================================================================================
        -- 1. GTT 초기화
        --    ★ TRUNCATE 금지. Oracle 에서 TRUNCATE 는 DDL 이라 암묵적 커밋이 일어나
        --      뒤에서 예외가 나도 ROLLBACK 이 듣지 않는다(PKG_DMF0021 도 DELETE 를 쓴다).
        --========================================================================================
        DELETE FROM GT_DMF0053_RAW_DATA;
        DELETE FROM GT_DMF0053_SELECT_MEASURE;
        DELETE FROM GT_DMF0053_EDI_CALLOFF;
        DELETE FROM GT_DMF0053_ITEM_SINGLE_V;
        DELETE FROM GT_DMF0053_ITEM_SINGLE_V_T;
        DELETE FROM GT_DMF0053_SCM_MST_SITE_ITEM;
        DELETE FROM GT_DMF0053_SCM_MST_SITE;
        DELETE FROM GT_DMF0053_COLUMN_SETUP;
        DELETE FROM GT_DMF0053_T;

        --========================================================================================
        -- 2. 사용자 Measure 설정이 하나도 없으면 기본 Measure 를 그 사용자 이름으로 등록
        --========================================================================================
        SELECT COUNT(*)
          INTO V_USER_MEA_CNT
          FROM SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = V_PROGRAM_ID
           AND U.SHEET_NAME = V_SHEET_NAME
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
           AND U.USER_ID    = P_CREATED_BY;

        IF V_USER_MEA_CNT = 0 THEN
            INSERT INTO SCM_MST_TITLESET_USER
                 ( USER_ID, PROGRAM_ID, SHEET_NAME, USER_INQUIRY_COLUMN_TYPE_CODE
                 , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
            SELECT P_CREATED_BY, C.PROGRAM_ID, C.SHEET_NAME, 'M'
                 , C.COLUMN_NAME, C.SORT_ORDER_NO, 'N', NULL
                 , P_CREATED_BY, SYSDATE, P_CREATED_BY, SYSDATE
              FROM SCM_MST_SHEET_MEASURE C
             WHERE C.PROGRAM_ID   = V_PROGRAM_ID
               AND C.SHEET_NAME   = V_SHEET_NAME
               AND C.DEFAULT_FLAG = 'Y'
               AND C.VALID_YN     = 'Y';
        END IF;

        --========================================================================================
        -- 3. 표시 대상 Measure 펼치기
        --    (1) 사용자가 고른 Measure 그대로
        --    (2) CUST_FCST_EDI 를 골랐으면 하위 일곱으로 펼침 (SP 본문에 박힌 목록)
        --    (3) CUST_FCST 를 골랐으면 DM_MST_CUSTOMER_FCST 의 Measure 로 펼침
        --========================================================================================
        INSERT INTO GT_DMF0053_SELECT_MEASURE
             ( PROGRAM_ID, SHEET_NAME, USER_ID, MEASURE_GROUP, MEASURE, SORT_ORDER_NO, SYSTEM_ADD )
        SELECT DISTINCT NVL(U.PROGRAM_ID, V_PROGRAM_ID)
             , U.SHEET_NAME
             , U.USER_ID
             , U.COLUMN_NAME
             , U.COLUMN_NAME
             , SMSM.SORT_ORDER_NO
             , 'N'
          FROM SCM_MST_TITLESET_USER U
          JOIN SCM_MST_SHEET_MEASURE SMSM
            ON U.PROGRAM_ID  = SMSM.PROGRAM_ID
           AND U.SHEET_NAME  = SMSM.SHEET_NAME
           AND U.COLUMN_NAME = SMSM.COLUMN_NAME
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
           AND SMSM.VALID_YN = 'Y'
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T
            ON U.USER_ID      = T.SEGMENT4
           AND P_CREATED_BY   = T.SEGMENT4
           AND T.LOOKUP_TYPE  = 'TMM_MEASURE_ADMIN'
           AND T.VALID_YN     = 'Y'
         WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
           AND U.PROGRAM_ID = V_PROGRAM_ID
           AND U.SHEET_NAME = V_SHEET_NAME
           AND U.USER_ID    = P_CREATED_BY
           AND U.USER_ID    = CASE WHEN U.COLUMN_NAME = 'TMM_FCST' THEN T.SEGMENT4 ELSE P_CREATED_BY END
        UNION ALL
        SELECT NVL(A.PROGRAM_ID, V_PROGRAM_ID)
             , A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
             , A.SORT_ORDER_NO + B.SORT_ORDER_NO   /* 원본대로 덧셈 — 20 + 0.14 = 20.14 */
             , 'N'
          FROM ( SELECT U.PROGRAM_ID, U.SHEET_NAME, U.USER_ID
                      , 'CUST_FCST_EDI' AS MEASURE_GROUP
                      , SMSM.SORT_ORDER_NO
                   FROM SCM_MST_TITLESET_USER U
                   JOIN SCM_MST_SHEET_MEASURE SMSM
                     ON U.PROGRAM_ID  = SMSM.PROGRAM_ID
                    AND U.SHEET_NAME  = SMSM.SHEET_NAME
                    AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                    AND SMSM.VALID_YN = 'Y'
                  WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                    AND U.PROGRAM_ID  = V_PROGRAM_ID
                    AND U.SHEET_NAME  = V_SHEET_NAME
                    AND U.USER_ID     = P_CREATED_BY
                    AND U.COLUMN_NAME = 'CUST_FCST_EDI'
               ) A
             , ( SELECT 'Immidiate'                   AS MEASURE, 0.14 AS SORT_ORDER_NO FROM DUAL
           UNION ALL SELECT 'Planning_Forecast'           , 0.17 FROM DUAL
           UNION ALL SELECT 'Commercial_Agreement'        , 0.12 FROM DUAL
           UNION ALL SELECT 'Firm_Temp'                   , 0.13 FROM DUAL
           UNION ALL SELECT 'Manumacturing_Material_Temp' , 0.15 FROM DUAL
           UNION ALL SELECT 'Material_Temp'               , 0.16 FROM DUAL
           UNION ALL SELECT 'Backorder'                   , 0.11 FROM DUAL
               ) B
         GROUP BY A.PROGRAM_ID, A.SHEET_NAME, A.USER_ID, A.MEASURE_GROUP, B.MEASURE
                , A.SORT_ORDER_NO + B.SORT_ORDER_NO
        UNION ALL
        SELECT DISTINCT V_PROGRAM_ID
             , V_SHEET_NAME
             , P_CREATED_BY
             , 'CUST_FCST'
             , C.MEASURE
             , ( SELECT SMSM.SORT_ORDER_NO
                   FROM SCM_MST_TITLESET_USER U
                   JOIN SCM_MST_SHEET_MEASURE SMSM
                     ON U.PROGRAM_ID  = SMSM.PROGRAM_ID
                    AND U.SHEET_NAME  = SMSM.SHEET_NAME
                    AND U.COLUMN_NAME = SMSM.COLUMN_NAME
                    AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                    AND SMSM.VALID_YN = 'Y'
                  WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                    AND U.PROGRAM_ID  = V_PROGRAM_ID
                    AND U.SHEET_NAME  = V_SHEET_NAME
                    AND U.USER_ID     = P_CREATED_BY
                    AND U.COLUMN_NAME = 'CUST_FCST' ) + 0.1
             , 'N'
          FROM DM_MST_CUSTOMER_FCST C
         WHERE C.MEASURE_GROUP = 'CUST_FCST'
           AND C.MEASURE IS NOT NULL          /* 원본 `<> ''` — Oracle 은 늘 UNKNOWN 이라 바꿨다 */
           AND C.VALID_YN = 'Y'
           AND EXISTS ( SELECT 1
                          FROM SCM_MST_TITLESET_USER X
                         WHERE X.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'
                           AND X.PROGRAM_ID  = V_PROGRAM_ID
                           AND X.SHEET_NAME  = V_SHEET_NAME
                           AND X.USER_ID     = P_CREATED_BY
                           AND X.COLUMN_NAME = 'CUST_FCST'
                           AND X.COLUMN_NAME = C.MEASURE_GROUP );

        --========================================================================================
        -- 4. 예외 표시(Exception · Excepted date) 원천
        --========================================================================================
        INSERT INTO GT_DMF0053_EDI_CALLOFF
             ( DIVISION_ID, SENDER_CODE, UNLOADING_POINT, CUST_MATERIAL_CODE
             , EXCEPTION_FLAG, EXCEPTION_DATE )
        SELECT DIVISION_ID, SENDER_CODE, UNLOADING_POINT, CUST_MATERIAL_CODE
             , MAX(EXCEPTION_FLAG)
             , MAX(TO_CHAR(EXCEPTION_DATE, 'YYYYMMDD'))
          FROM DM_DNM_EDI_CALLOFF_ITEM
         WHERE DIVISION_ID = P_DIVISION_ID
         GROUP BY DIVISION_ID, SENDER_CODE, UNLOADING_POINT, CUST_MATERIAL_CODE;

        --========================================================================================
        -- 5. 원장에서 원천 행 적재
        --========================================================================================
        INSERT INTO GT_DMF0053_RAW_DATA
             ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
             , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME, SENDER_CODE
             , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
             , QTY, CREATE_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
             , EDI_IF_SEQ, CUSTOMER_PLANT, EXCEPTION_FLAG, EXCEPTION_DATE )
        SELECT DISTINCT
               A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.YYYYMMDD
             , A.CUST_MATERIAL_CODE, A.COUNTRY, A.CITY, A.FCST_TYPE, A.DOM_EXP
             , A.SENDER_NAME, A.SENDER_CODE
             , A.PLANT_SITE_ID, A.INCOTERMS, A.UNLOADING_POINT, A.MEASURE
             , ( CASE WHEN A.DIVISION_ID = '40' AND E.MEASURE_GROUP IS NULL THEN NULL
                      WHEN A.DIVISION_ID = '40' THEN E.MEASURE_GROUP
                      ELSE NULL END )
             , A.QTY
             , REPLACE(A.CREATE_DATE, '-', '')
             , A.LAST_UPDATED_BY
             , TO_CHAR(A.LAST_UPDATE_DATE, 'YYYYMMDD')
             , A.EDI_IF_SEQ
             , A.CUSTOMER_PLANT
             , CITM.EXCEPTION_FLAG
             , CITM.EXCEPTION_DATE
          FROM DM_PLN_CUST_FCST_H A
          JOIN GT_DMF0053_SELECT_MEASURE E
            ON A.MEASURE = E.MEASURE
          LEFT OUTER JOIN GT_DMF0053_EDI_CALLOFF CITM
            ON CITM.DIVISION_ID        = A.DIVISION_ID
           AND CITM.SENDER_CODE        = A.SENDER_CODE
           AND CITM.UNLOADING_POINT    = A.UNLOADING_POINT
           AND CITM.CUST_MATERIAL_CODE = A.CUST_MATERIAL_CODE
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD   >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD   <= P_TO_YYYYMMDD
           AND A.CREATE_DATE >= P_FROM_CREATEDATE
           AND A.CREATE_DATE <= P_TO_CREATEDATE;

        --========================================================================================
        -- 6. 품목 마스터 (사업부 · 품목 단위로 하나로 눌러 담는다)
        --
        --    ★ 성능 — 원본은 사업부 전체 품목을 집계한 뒤 마지막에 원천 행으로 좁힌다.
        --      81 은 품목이 220,594건이라 이 구조로는 이 단계에서만 10분을 넘겼다(개발 실측).
        --      그래서 두 스캔 모두 앞단에서 원천 행 범위로 좁혔다. 결과는 같다 —
        --        · T1 : 집계 단위가 (DIVISION_ID, ITEM_ID) 라 품목을 미리 걸러도 각 품목의 값은 그대로다.
        --               어차피 마지막 JOIN B 로 원천 행에 있는 품목만 남는다.
        --        · T2 : 집계 단위가 앞 12자리라 12자리 기준으로 걸러야 한다.
        --               같은 12자리 그룹은 통째로 남으므로 MAX 결과가 달라지지 않는다.
        --========================================================================================
        INSERT INTO GT_DMF0053_ITEM_SINGLE_V
             ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC
             , FORECAST_INFOR_VERSION, ENERGE, CELL_QUANTITY, MDM_PROJECT_NAME
             , CELL_TYPE, SCP_EXTRA_SPEC )
        SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS
             , A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_CELL_PACK_COUNT
             , A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL
             , A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
             , A.ENERGE, A.CELL_QUANTITY, A.MDM_PROJECT_NAME, A.CELL_TYPE, A.SCP_EXTRA_SPEC
          FROM ( SELECT T1.DIVISION_ID
                      , T1.ITEM_ID
                      , MAX(T1.ITEM_NAME)       AS ITEM_NAME
                      , MAX(T1.ITEM_CLASS)      AS ITEM_CLASS
                      , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
                      , MAX(T1.NICK_NAME)       AS NICK_NAME
                      , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                                       WHEN T1.ITEM_TYPE = 'H' THEN 2
                                       WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                       ELSE 4 END )
                             WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END AS ITEM_TYPE
                      , MAX(T1.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
                      , MAX(T1.MIN_CAPACITY)     AS MIN_CAPACITY
                      , MAX(T2.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                      , MAX(T2.FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                      , MAX(T2.FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                      , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                      , MAX(T2.FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                      , MAX(T2.FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                      , MAX(T2.CELL_TYPE)        AS CELL_TYPE
                      , MAX(T1.ENERGE)           AS ENERGE
                      , MAX(T1.CELL_QUANTITY)    AS CELL_QUANTITY
                      , MAX(T1.SCP_EXTRA_SPEC)   AS SCP_EXTRA_SPEC
                   FROM SCM_MST_ITEM_SN T1
                   JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
                               , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                               , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                               , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                               , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                               , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                               , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                               , MAX(CELL_TYPE)                     AS CELL_TYPE
                            FROM SCM_MST_ITEM_SN S2
                           WHERE S2.DIVISION_ID = P_DIVISION_ID
                             AND EXISTS ( SELECT 1
                                            FROM GT_DMF0053_RAW_DATA R
                                           WHERE R.DIVISION_ID = S2.DIVISION_ID
                                             AND SUBSTR(R.ITEM_ID, 1, 12) = SUBSTR(S2.ITEM_ID, 1, 12) )
                           GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
                        ) T2
                     ON T1.DIVISION_ID = T2.DIVISION_ID
                    AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
                  WHERE T1.DIVISION_ID = P_DIVISION_ID
                    AND EXISTS ( SELECT 1
                                   FROM GT_DMF0053_RAW_DATA R
                                  WHERE R.DIVISION_ID = T1.DIVISION_ID
                                    AND R.ITEM_ID     = T1.ITEM_ID )
                  GROUP BY T1.DIVISION_ID, T1.ITEM_ID
               ) A
          JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DMF0053_RAW_DATA ) B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND A.ITEM_ID     = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID;

        --========================================================================================
        -- 7. 사이트 · 품목 마스터 (담당자 이름 · 부서 포함)
        --========================================================================================
        INSERT INTO GT_DMF0053_SCM_MST_SITE_ITEM
             ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
             , APPLICATION, CUST_GROUP, ROUTE, CUST_GROUP_DTL
             , CELL_PER_CAR, CELL_PER_MODULE, SALES_COMPANY
             , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5, ATTRIBUTE7, ATTRIBUTE8
             , REPORT_GROUP6, OWNER, OWNER_NAME, OWNER_NAME_KO, DEPT_ID, VALID_YN )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
             , A.APPLICATION, A.CUST_GROUP, A.ROUTE, A.CUST_GROUP_DTL
             , A.CELL_PER_CAR, A.CELL_PER_MODULE, A.SALES_COMPANY
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE5, A.ATTRIBUTE7, A.ATTRIBUTE8
             , A.REPORT_GROUP6
             , A.OWNER
             , FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'EN')
             , FN_GET_DM_MKT_OWNER_NAME(A.OWNER, ',', 'KO')
             , ( SELECT MIN(SU.DEPT_ID)
                   FROM SCM_MST_SSO_USER_INFO SU
                  WHERE SU.USER_ID = TRIM(REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)) )
             , A.VALID_YN
          FROM SCM_MST_SITE_ITEM A
          JOIN ( SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
                   FROM GT_DMF0053_RAW_DATA ) B
            ON A.DIVISION_ID  = B.DIVISION_ID
           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
           AND A.PROJECT_CODE = B.PROJECT_CODE
           AND A.ITEM_ID      = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID;

        --========================================================================================
        -- 8. 조회조건 필터링
        --    원본은 `DELETE A FROM #RAW_DATA A LEFT JOIN (토큰) C ... WHERE C.TOKEN IS NULL` —
        --    "어떤 토큰과도 안 맞는 행을 지운다" 는 뜻이므로 NOT EXISTS 로 옮겼다.
        --========================================================================================
        /* Project — 40 은 화면에서 비활성이라 값이 오지 않는다.
           값이 오면 먼저 프로젝트 코드가 빈 행을 지운 뒤, 코드 · 프로젝트명 부분일치로 거른다. */
        IF P_PROJECT_CODE IS NOT NULL AND P_PROJECT_CODE <> '' THEN
            DELETE FROM GT_DMF0053_RAW_DATA WHERE PROJECT_CODE IS NULL;

            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE EXISTS ( SELECT 1
                              FROM SCM_MST_PROJECT B
                             WHERE B.DIVISION_ID  = A.DIVISION_ID
                               AND B.PROJECT_CODE = A.PROJECT_CODE
                               AND NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ',')) C
                                                 WHERE B.PROJECT_CODE LIKE '%' || C.TOKEN || '%' )
                               AND NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_PROJECT_CODE, ',')) D
                                                 WHERE B.PROJECT_NAME LIKE '%' || D.TOKEN || '%' ) );
        END IF;

        /* Model / Nickname — 모델 코드와 모델 별칭에 부분일치 */
        IF P_ITEM_ID IS NOT NULL AND P_ITEM_ID <> '' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ',')) C
                                 WHERE A.ITEM_ID LIKE '%' || C.TOKEN || '%' )
               AND NOT EXISTS ( SELECT 1
                                  FROM GT_DMF0053_ITEM_SINGLE_V B
                                     , TABLE(FN_STRING_SPLIT(P_ITEM_ID, ',')) D
                                 WHERE B.ITEM_ID = A.ITEM_ID
                                   AND B.NICK_NAME LIKE '%' || D.TOKEN || '%' );
        END IF;

        /* Owner — 담당자 ID · 영문명 · 한글명 셋 중 하나에 부분일치 */
        IF P_OWNER IS NOT NULL AND P_OWNER <> '' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1
                                  FROM GT_DMF0053_SCM_MST_SITE_ITEM B
                                     , TABLE(FN_STRING_SPLIT(P_OWNER, ',')) C
                                 WHERE B.ITEM_ID      = A.ITEM_ID
                                   AND B.SCM_SITE_ID  = A.SCM_SITE_ID
                                   AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND ( B.OWNER         LIKE '%' || C.TOKEN || '%'
                                      OR B.OWNER_NAME    LIKE '%' || C.TOKEN || '%'
                                      OR B.OWNER_NAME_KO LIKE '%' || C.TOKEN || '%' ) );
        END IF;

        /* Team — 담당자가 속한 부서 기준 (PJ2024-50461 Team Mapping) */
        IF P_DEPT_ID <> 'ALL' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1
                                  FROM GT_DMF0053_SCM_MST_SITE_ITEM B
                                     , TABLE(FN_STRING_SPLIT(P_DEPT_ID, ',')) C
                                 WHERE B.ITEM_ID      = A.ITEM_ID
                                   AND B.SCM_SITE_ID  = A.SCM_SITE_ID
                                   AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND B.DEPT_ID      = C.TOKEN );
        END IF;

        /* End Customer — 40 은 프로젝트 코드로, 그 밖은 사이트 마스터의 최종 고객으로 거른다 */
        IF P_END_CUSTOMER <> 'ALL' THEN
            IF P_DIVISION_ID = '40' THEN
                DELETE FROM GT_DMF0053_RAW_DATA A
                 WHERE NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ',')) C
                                     WHERE A.PROJECT_CODE = C.TOKEN );
            ELSE
                DELETE FROM GT_DMF0053_RAW_DATA A
                 WHERE NOT EXISTS ( SELECT 1
                                      FROM SCM_MST_SITE B
                                         , TABLE(FN_STRING_SPLIT(P_END_CUSTOMER, ',')) C
                                     WHERE B.SCM_SITE_ID = A.SCM_SITE_ID
                                       AND B.DIVISION_ID = P_DIVISION_ID
                                       AND B.END_CUSTOMER = C.TOKEN );
            END IF;
        END IF;

        /* Sales Site */
        IF P_SCM_SITE_ID <> 'ALL' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_SCM_SITE_ID, ',')) C
                                 WHERE A.SCM_SITE_ID = C.TOKEN );
        END IF;

        /* Plant Site */
        IF P_PLANT_SITE_ID <> 'ALL' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_PLANT_SITE_ID, ',')) C
                                 WHERE A.PLANT_SITE_ID = C.TOKEN );
        END IF;

        /* Item Type */
        IF P_ITEM_TYPE <> 'ALL' THEN
            DELETE FROM GT_DMF0053_RAW_DATA A
             WHERE NOT EXISTS ( SELECT 1
                                  FROM GT_DMF0053_ITEM_SINGLE_V B
                                     , TABLE(FN_STRING_SPLIT(P_ITEM_TYPE, ',')) C
                                 WHERE B.ITEM_ID   = A.ITEM_ID
                                   AND B.ITEM_TYPE = C.TOKEN );
        END IF;

        /* Biz Type — 40 은 품목 마스터 사업유형 완전일치, 그 밖은 프로젝트 마스터 부분일치 */
        IF P_BIZ_TYPE <> 'ALL' THEN
            IF P_DIVISION_ID = '40' THEN
                DELETE FROM GT_DMF0053_RAW_DATA A
                 WHERE NOT EXISTS ( SELECT 1
                                      FROM GT_DMF0053_ITEM_SINGLE_V B
                                         , TABLE(FN_STRING_SPLIT(P_BIZ_TYPE, ',')) C
                                     WHERE B.ITEM_ID = A.ITEM_ID
                                       AND B.FORECAST_INFO_BIZ_TYPE = C.TOKEN );
            ELSE
                DELETE FROM GT_DMF0053_RAW_DATA A
                 WHERE EXISTS ( SELECT 1
                                  FROM SCM_MST_PROJECT B
                                 WHERE B.DIVISION_ID  = A.DIVISION_ID
                                   AND B.PROJECT_CODE = A.PROJECT_CODE
                                   AND NOT EXISTS ( SELECT 1 FROM TABLE(FN_STRING_SPLIT(P_BIZ_TYPE, ',')) C
                                                     WHERE B.BIZ_TYPE LIKE '%' || C.TOKEN || '%' ) );
            END IF;
        END IF;

        --========================================================================================
        -- 9. 고객수요 Measure 통합 (2023-12-07)
        --    CUST_FCST_EDI 로 읽어온 행을 Measure · Measure 묶음만 CUST_FCST 로 바꿔 한 벌 더 넣는다.
        --========================================================================================
        INSERT INTO GT_DMF0053_RAW_DATA
             ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
             , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME, SENDER_CODE
             , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT, MEASURE, MEASURE_GROUP
             , QTY, CREATE_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
             , EDI_IF_SEQ, CUSTOMER_PLANT, EXCEPTION_FLAG, EXCEPTION_DATE )
        SELECT DISTINCT
               DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, YYYYMMDD
             , CUST_ITEM_ID, COUNTRY, CITY, FCST_TYPE, DOM_EXP, SENDER_NAME, SENDER_CODE
             , PLANT_SITE_ID, INCOTERMS, UNLOADING_POINT
             , 'CUST_FCST', 'CUST_FCST'
             , QTY, CREATE_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
             , EDI_IF_SEQ, CUSTOMER_PLANT, EXCEPTION_FLAG, EXCEPTION_DATE
          FROM GT_DMF0053_RAW_DATA A
         WHERE A.MEASURE = 'CUST_FCST_EDI';

        --========================================================================================
        -- 10. 사이트 마스터 · 품목 마스터 보강분
        --========================================================================================
        INSERT INTO GT_DMF0053_SCM_MST_SITE
             ( SCM_SITE_ID, DIVISION_ID, DEPT_ID, SOLDTO_CODE, VMI_YN
             , END_CUSTOMER, SOLDTO_CUSTOMER, CITY_NAME, COUNTRY_NAME )
        SELECT B.SCM_SITE_ID, B.DIVISION_ID, B.DEPT_ID, K.SOLDTO_CODE, B.VMI_YN
             , B.END_CUSTOMER, B.SOLDTO_CUSTOMER, H.CITY_NAME, J.COUNTRY_NAME
          FROM SCM_MST_SITE B
          LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER K
            ON B.DIVISION_ID = K.DIVISION_ID
           AND B.SCM_SITE_ID = K.SCM_SITE_ID
           AND K.REP_YN      = 'Y'
          LEFT OUTER JOIN SCM_MST_CITY    H ON B.CITY    = H.CITY
          LEFT OUTER JOIN SCM_MST_COUNTRY J ON B.COUNTRY = J.COUNTRY;

        INSERT INTO GT_DMF0053_ITEM_SINGLE_V_T
             ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC
             , FORECAST_INFOR_VERSION, ENERGE, CELL_QUANTITY, MDM_PROJECT_NAME
             , CELL_TYPE, SCP_EXTRA_SPEC, SEGMENT2, CELL_MODEL_NICK_NAME )
        SELECT D.DIVISION_ID, D.ITEM_ID, D.ITEM_CLASS, D.ITEM_NAME, D.ITEM_CLASS_NAME, D.NICK_NAME
             , D.ITEM_TYPE, D.MIN_CAPACITY, D.FORECAST_INFO_BIZ_TYPE, D.FORECAST_INFO_CELL_PACK_COUNT
             , D.FORECAST_INFO_PRODUCT_GROUP, D.FORECAST_INFO_CELL_MODEL, D.FORECAST_INFO_SPEC
             , D.FORECAST_INFOR_VERSION, D.ENERGE, D.CELL_QUANTITY, D.MDM_PROJECT_NAME
             , D.CELL_TYPE, D.SCP_EXTRA_SPEC
             , E.SEGMENT2
             , NVL(F.NICK_NAME, ' ')
          FROM GT_DMF0053_ITEM_SINGLE_V D
          LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E
            ON D.CELL_TYPE   = E.SEGMENT1
           AND E.LOOKUP_TYPE = 'CELL_TYPE'
          LEFT OUTER JOIN GT_DMF0053_ITEM_SINGLE_V F
            ON D.DIVISION_ID = F.DIVISION_ID
           AND D.FORECAST_INFO_CELL_MODEL = F.ITEM_ID;

        --========================================================================================
        -- 11. 표시 컬럼 목록 만들기
        --     사용자 설정(구분값 C)이 있으면 그것을, 없으면 메타의 DEFAULT_FLAG = 'Y' 를 쓴다.
        --     ★ 숨김 컬럼 편입 조건은 머리글과 같은 보정을 쓴다 — MEASURE 를 목록에 넣기 위함이다.
        --========================================================================================
        SELECT COUNT(*)
          INTO V_USER_COL_CNT
          FROM SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = V_PROGRAM_ID
           AND U.SHEET_NAME = V_SHEET_NAME
           AND U.USER_ID    = P_CREATED_BY
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C';

        IF V_USER_COL_CNT = 0 THEN
            SELECT LISTAGG('[' || COLUMN_NAME || ']', ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG('[' || COLUMN_NAME || '] ' || NVL(DATA_SORT_METHOD_CODE, 'ASC'), ',')
                       WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST, V_ORDER_LIST
              FROM SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = V_PROGRAM_ID
               AND C.SHEET_NAME = V_SHEET_NAME
               AND ( C.DEFAULT_FLAG = 'Y'
                  OR ( C.VISIBLE_FLAG = 'N'
                   AND NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'
                   AND C.VALID_YN = 'Y' ) );
        ELSE
            SELECT LISTAGG('[' || COLUMN_NAME || ']', ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG('[' || COLUMN_NAME || '] ' || NVL(DATA_SORT_METHOD_CODE, 'ASC'), ',')
                       WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST, V_ORDER_LIST
              FROM ( SELECT U.SORT_ORDER_NO, C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
                       FROM SCM_MST_TITLESET_USER U
                       JOIN SCM_MST_SHEET_COLUMNS C
                         ON U.PROGRAM_ID  = C.PROGRAM_ID
                        AND U.SHEET_NAME  = C.SHEET_NAME
                        AND U.COLUMN_NAME = C.COLUMN_NAME
                      WHERE U.PROGRAM_ID  = V_PROGRAM_ID
                        AND U.SHEET_NAME  = V_SHEET_NAME
                        AND U.USER_ID     = P_CREATED_BY
                        AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                        AND U.COLUMN_NAME <> 'MEASURE'
                      UNION ALL
                     SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
                       FROM SCM_MST_SHEET_COLUMNS C
                      WHERE C.PROGRAM_ID   = V_PROGRAM_ID
                        AND C.SHEET_NAME   = V_SHEET_NAME
                        AND C.VISIBLE_FLAG = 'N'
                        AND NVL(TRIM(C.DEFAULT_FLAG), '-') = '-'
                        AND C.VALID_YN     = 'Y' );
        END IF;

        /* Measure 자리를 묶음 · Measure · 정렬순서 셋으로 바꾼다 */
        V_COL_LIST := REPLACE(V_COL_LIST, '[MEASURE]', '[MEASURE_GROUP],[MEASURE],[SORT_ORDER_NO]');

        /* 정렬에서 빼는 컬럼 — 원본은 사업부 코드 완전일치다(81_HD 등 하위코드는 걸리지 않는다) */
        IF P_DIVISION_ID = '81' THEN
            V_ORDER_LIST := REPLACE(V_ORDER_LIST, ',[EDI_IF_SEQ] ASC,[CREATE_DATE] ASC', '');
        ELSIF P_DIVISION_ID = '40' THEN
            V_ORDER_LIST := REPLACE(V_ORDER_LIST, ',[CREATE_DATE] ASC', '');
        END IF;
        V_ORDER_LIST := REPLACE(V_ORDER_LIST, '[MEASURE]', '[SORT_ORDER_NO]');

        --========================================================================================
        -- 12. 컬럼별 산출식 등록
        --     컬럼 목록과 이름이 맞는 산출식만 뒤에서 골라 쓴다.
        --     ※ DEPT_ID · END_CUSTOMER40 · BIZ_TYPE_NAME · BIZ_TYPE_NAME40 · COUNTRY_NAME ·
        --       CITY_NAME · ITEM_ID40 · SCM_SITE_ID40 은 컬럼 메타에 없어 결과셋에 실리지 않는다.
        --       AS-IS 와 같게 등록만 해 둔다(설계서 4-11항).
        --========================================================================================
        INSERT INTO GT_DMF0053_COLUMN_SETUP ( COLUMN_NAME, COLUMN_STRING, SORT_KEY )
        SELECT COLUMN_NAME, COLUMN_STRING, ROWNUM
          FROM (
            SELECT 'DIVISION_ID'      AS COLUMN_NAME, 'A.DIVISION_ID'                     AS COLUMN_STRING FROM DUAL
  UNION ALL SELECT 'DEPT_ID'          , 'C.DEPT_ID'                                        FROM DUAL
  UNION ALL SELECT 'END_CUSTOMER40'   , 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.PROJECT_CODE ELSE '' '' END AS END_CUSTOMER40' FROM DUAL
  UNION ALL SELECT 'END_CUSTOMER'     , 'NVL(B.END_CUSTOMER, '' '') AS END_CUSTOMER'       FROM DUAL
  UNION ALL SELECT 'BIZ_TYPE_NAME'    , 'G.BIZ_TYPE AS BIZ_TYPE_NAME'                      FROM DUAL
  UNION ALL SELECT 'COUNTRY_NAME'     , 'B.COUNTRY_NAME'                                   FROM DUAL
  UNION ALL SELECT 'CITY_NAME'        , 'B.CITY_NAME'                                      FROM DUAL
  UNION ALL SELECT 'SCM_SITE_ID'      , 'A.SCM_SITE_ID'                                    FROM DUAL
  UNION ALL SELECT 'PROJECT_CODE'     , 'A.PROJECT_CODE'                                   FROM DUAL
  UNION ALL SELECT 'PROJECT_NAME'     , 'G.PROJECT_NAME'                                   FROM DUAL
  UNION ALL SELECT 'PROJECT_STATUS'   , 'G.PROJECT_STATUS'                                 FROM DUAL
  UNION ALL SELECT 'PROJECT_OWNER'    , 'G.PROJECT_OWNER'                                  FROM DUAL
  UNION ALL SELECT 'ITEM_ID'          , 'A.ITEM_ID'                                        FROM DUAL
  UNION ALL SELECT 'ITEM_ID40'        , 'A.ITEM_ID AS ITEM_ID40'                           FROM DUAL
  UNION ALL SELECT 'ITEM_NAME'        , 'NVL(D.ITEM_NAME, '' '') AS ITEM_NAME'             FROM DUAL
  UNION ALL SELECT 'NICK_NAME'        , 'NVL(D.NICK_NAME, '' '') AS NICK_NAME'             FROM DUAL
  UNION ALL SELECT 'INCOTERMS'        , 'A.INCOTERMS'                                      FROM DUAL
  UNION ALL SELECT 'ITEM_TYPE'        , 'NVL(D.ITEM_TYPE, '' '') AS ITEM_TYPE'             FROM DUAL
  UNION ALL SELECT 'FCST_TYPE'        , 'A.FCST_TYPE'                                      FROM DUAL
  UNION ALL SELECT 'DOM_EXP'          , 'A.DOM_EXP'                                        FROM DUAL
  UNION ALL SELECT 'PLANT_SITE_ID'    , 'A.PLANT_SITE_ID'                                  FROM DUAL
  UNION ALL SELECT 'CUST_GROUP'       , 'C.CUST_GROUP'                                     FROM DUAL
  UNION ALL SELECT 'CUST_GROUP_DTL'   , 'C.CUST_GROUP_DTL'                                 FROM DUAL
  UNION ALL SELECT 'OWNER'            , 'C.OWNER_NAME AS OWNER'                            FROM DUAL
  UNION ALL SELECT 'APPLICATION'      , 'C.APPLICATION'                                    FROM DUAL
  UNION ALL SELECT 'ROUTE'            , 'C.ROUTE'                                          FROM DUAL
  UNION ALL SELECT 'MDM_PROJECT_NAME' , 'D.MDM_PROJECT_NAME'                               FROM DUAL
  UNION ALL SELECT 'MIN_CAPACITY'     , 'D.MIN_CAPACITY'                                   FROM DUAL
  UNION ALL SELECT 'BIZ_TYPE_NAME40'  , 'D.FORECAST_INFO_BIZ_TYPE AS BIZ_TYPE_NAME40'      FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_PRODUCT_GROUP', 'D.FORECAST_INFO_PRODUCT_GROUP'          FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_CELL_MODEL'   , 'C.ATTRIBUTE5 AS FORECAST_INFO_CELL_MODEL' FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_CELL_PACK_COUNT', 'D.FORECAST_INFO_CELL_PACK_COUNT'      FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_ALL', 'D.FORECAST_INFO_SPEC || D.FORECAST_INFOR_VERSION AS FORECAST_INFO_ALL' FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_SPEC'    , 'D.FORECAST_INFO_SPEC'                        FROM DUAL
  UNION ALL SELECT 'FORECAST_INFOR_VERSION', 'D.FORECAST_INFOR_VERSION'                    FROM DUAL
  UNION ALL SELECT 'CELL_MODEL_NICK_NAME'  , 'NVL(D.NICK_NAME, '' '') AS CELL_MODEL_NICK_NAME' FROM DUAL
  UNION ALL SELECT 'VMI_YN'           , 'B.VMI_YN'                                         FROM DUAL
  UNION ALL SELECT 'CELL_TYPE'        , 'D.SEGMENT2 AS CELL_TYPE'                          FROM DUAL
  UNION ALL SELECT 'CELL_PER_CAR'     , 'C.CELL_PER_CAR'                                   FROM DUAL
  UNION ALL SELECT 'CELL_PER_MODULE'  , 'C.CELL_PER_MODULE'                                FROM DUAL
  UNION ALL SELECT 'MODULE_PER_CAR'   , 'CASE WHEN C.CELL_PER_MODULE <> 0 THEN C.CELL_PER_CAR / C.CELL_PER_MODULE ELSE 0 END AS MODULE_PER_CAR' FROM DUAL
  UNION ALL SELECT 'ENERGE'           , 'D.ENERGE'                                         FROM DUAL
  UNION ALL SELECT 'CELL_QUANTITY'    , 'D.CELL_QUANTITY'                                  FROM DUAL
  UNION ALL SELECT 'PRIORITY'         , 'C.ATTRIBUTE7 AS PRIORITY'                         FROM DUAL
  UNION ALL SELECT 'MEASURE'          , 'CASE WHEN A.MEASURE = ''Customer FCST'' THEN CASE WHEN INSTR(NVL(A.LAST_UPDATED_BY, '' ''), ''robot'') > 0 THEN ''Cust.FCST_RPA'' ELSE ''Cust.FCST_EXCEL'' END ELSE A.MEASURE END AS MEASURE' FROM DUAL
  UNION ALL SELECT 'MEASURE_GROUP'    , 'M.MEASURE_GROUP'                                  FROM DUAL
  UNION ALL SELECT 'DMS_SALES'        , 'NVL(C.ATTRIBUTE1, '' '') AS DMS_SALES'            FROM DUAL
  UNION ALL SELECT 'DMS_CUSTOMER'     , 'NVL(C.ATTRIBUTE2, '' '') AS DMS_CUSTOMER'         FROM DUAL
  UNION ALL SELECT 'REPORT_GROUP6'    , 'C.REPORT_GROUP6'                                  FROM DUAL
  UNION ALL SELECT 'TEAM_NAME_KO'     , 'N.DEPT_NAME_KO AS TEAM_NAME_KO'                   FROM DUAL
  UNION ALL SELECT 'DEPT_NAME_KO'     , 'O.DEPT_NAME_KO'                                   FROM DUAL
  UNION ALL SELECT 'FORECAST_INFO_BIZ_TYPE', 'D.FORECAST_INFO_BIZ_TYPE'                    FROM DUAL
  UNION ALL SELECT 'BIZ_TYPE'         , 'G.BIZ_TYPE'                                       FROM DUAL
  UNION ALL SELECT 'SOLDTO_CUSTOMER'  , 'B.SOLDTO_CUSTOMER'                                FROM DUAL
  UNION ALL SELECT 'SCM_SITE_ID40'    , 'CASE WHEN A.DIVISION_ID = ''40'' THEN A.SCM_SITE_ID ELSE '' '' END AS SCM_SITE_ID40' FROM DUAL
  UNION ALL SELECT 'SCP_USE_YN'       , 'CASE WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Req'' THEN ''Y'' WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN ( ''MKT_FCST_RP'',''MKT_FCST'' ) THEN ''Y'' WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''Y'' AND A.MEASURE = ''VMI_In_Plan'' THEN ''Y'' WHEN A.DIVISION_ID IN (''40'') AND B.VMI_YN = ''N'' AND A.MEASURE IN (''RTF'',''RTF_SCP'',''RTF_SYS_RP'') THEN ''Y'' ELSE ''N'' END AS SCP_USE_YN' FROM DUAL
  UNION ALL SELECT 'SCP_EXTRA_SPEC'   , 'D.SCP_EXTRA_SPEC'                                 FROM DUAL
  UNION ALL SELECT 'SALES_COMPANY'    , 'C.SALES_COMPANY'                                  FROM DUAL
  UNION ALL SELECT 'SOLDTO_CODE'      , 'B.SOLDTO_CODE'                                    FROM DUAL
  UNION ALL SELECT 'KWH_CELL'         , 'C.ATTRIBUTE8 AS KWH_CELL'                         FROM DUAL
  UNION ALL SELECT 'KWH_MODULE'       , 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_MODULE > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN TO_CHAR(C.CELL_PER_MODULE * TO_NUMBER(C.ATTRIBUTE8)) ELSE '' '' END AS KWH_MODULE' FROM DUAL
  UNION ALL SELECT 'KWH_PACK'         , 'CASE WHEN A.DIVISION_ID LIKE ''81%'' AND C.CELL_PER_CAR > 0 AND C.ATTRIBUTE8 IS NOT NULL THEN TO_CHAR(C.CELL_PER_CAR * TO_NUMBER(C.ATTRIBUTE8)) ELSE '' '' END AS KWH_PACK' FROM DUAL
  UNION ALL SELECT 'CUST_ITEM_ID'     , 'A.CUST_ITEM_ID'                                   FROM DUAL
  UNION ALL SELECT 'SENDER_NAME'      , 'A.SENDER_NAME'                                    FROM DUAL
  UNION ALL SELECT 'UNLOADING_POINT'  , 'A.UNLOADING_POINT'                                FROM DUAL
  UNION ALL SELECT 'CREATE_DATE'      , 'A.CREATE_DATE'                                    FROM DUAL
  UNION ALL SELECT 'LAST_UPDATE_DATE' , 'A.LAST_UPDATE_DATE'                               FROM DUAL
  UNION ALL SELECT 'LAST_UPDATED_BY'  , 'A.LAST_UPDATED_BY'                                FROM DUAL
  UNION ALL SELECT 'CITY'             , 'A.CITY'                                           FROM DUAL
  UNION ALL SELECT 'COUNTRY'          , 'A.COUNTRY'                                        FROM DUAL
  UNION ALL SELECT 'EDI_IF_SEQ'       , 'A.EDI_IF_SEQ'                                     FROM DUAL
  UNION ALL SELECT 'CUSTOMER_PLANT'   , 'A.CUSTOMER_PLANT'                                 FROM DUAL
  UNION ALL SELECT 'EXCEPTION_FLAG'   , 'A.EXCEPTION_FLAG'                                 FROM DUAL
  UNION ALL SELECT 'EXCEPTION_DATE'   , 'A.EXCEPTION_DATE'                                 FROM DUAL
  UNION ALL SELECT 'SORT_ORDER_NO'    , 'M.SORT_ORDER_NO'                                  FROM DUAL
          );

        --========================================================================================
        -- 13. 사용자 컬럼 목록과 맞물린 산출식만 순서대로 추리기
        --========================================================================================
        INSERT INTO GT_DMF0053_T ( COLUMN_STRING, SEQ )
        SELECT B.COLUMN_STRING, ROW_NUMBER() OVER ( ORDER BY A.NR )
          FROM TABLE(UF_FX_STRING_SPLIT(V_COL_LIST, ',')) A
          JOIN GT_DMF0053_COLUMN_SETUP B
            ON REPLACE(REPLACE(A.TOKEN, '[', ''), ']', '') = B.COLUMN_NAME;

        SELECT LISTAGG(COLUMN_STRING, ',') WITHIN GROUP (ORDER BY SEQ)
             , LISTAGG( CASE WHEN INSTR(COLUMN_STRING, ' AS ') > 0
                             THEN SUBSTR(COLUMN_STRING, 1, INSTR(COLUMN_STRING, ' AS ') - 1)
                             ELSE COLUMN_STRING END, ',' ) WITHIN GROUP (ORDER BY SEQ)
          INTO V_SQL_SELECT, V_SQL_GROUPBY
          FROM GT_DMF0053_T;

        --========================================================================================
        -- 14. 기간(피벗) 컬럼 목록 만들기
        --========================================================================================
        SELECT LISTAGG('[' || COLUMN_NAME || ']', ',') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
          INTO V_PV_LIST
          FROM (
                SELECT 'D_' || A.BASIS_YYYYMMDD AS COLUMN_NAME
                     , TO_NUMBER(A.BASIS_YYYYMMDD || '31') AS SORT_ORDER_NO
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND P_BUCKET = 'DAILY'
                 UNION ALL
                SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK
                     , TO_NUMBER(A.BASIS_START_DATE || '21')
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND P_BUCKET <> 'ONLY_WEEKLY'
                 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                 UNION ALL
                SELECT 'M_' || A.BASIS_YYYYMM
                     , TO_NUMBER(MIN(A.BASIS_START_DATE) || '01')
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND P_BUCKET <> 'ONLY_WEEKLY'
                 GROUP BY A.BASIS_YYYYMM
                 UNION ALL
                SELECT 'W_' || SUBSTR(MAX(A.BASIS_YYYYMMDD), 1, 6) || A.ISO_WEEK
                     , TO_NUMBER(MAX(A.BASIS_YYYYMMDD) || '21')
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND A.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND P_BUCKET = 'ONLY_WEEKLY'
                 GROUP BY A.ISO_YYYYWW, A.ISO_WEEK, A.WEEK_NAME
               );

        /* 40 은 빈 칸을 0 으로 채워 내려준다(AS-IS 표기 차이) */
        V_PV_COL := REGEXP_REPLACE(V_PV_LIST, '\[([^]]+)\]', 'NVL("\1", 0) AS "\1"');

        --========================================================================================
        -- 15. 동적 SQL 조립
        --     MSSQL 대괄호 식별자를 Oracle 표기로 바꾼다(PKG_DMF0021 과 같은 규칙).
        --========================================================================================
        V_COL_PLAIN     := REPLACE(REPLACE(V_COL_LIST,   '[', ''), ']', '');
        V_ORDERBY_PLAIN := REPLACE(REPLACE(V_ORDER_LIST, '[', ''), ']', '');
        V_PV_IN         := REGEXP_REPLACE(V_PV_LIST, '\[([^]]+)\]', '''\1'' AS "\1"');
        V_PV_PROJ       := REGEXP_REPLACE(V_PV_LIST, '\[([^]]+)\]', '"\1"');

        V_SQL_TEXT :=
'WITH WF AS (
    SELECT A.QTY AS QTY
         , CASE WHEN ''' || P_BUCKET || ''' = ''DAILY'' THEN A.YYYYMMDD ELSE '' '' END AS YYYYMMDD
         , CAL.BASIS_YYYYMM, CAL.ISO_WEEK
         , SUBSTR(CAL.BASIS_YYYYMM, 1, 6) || CAL.ISO_WEEK AS BASIS_YYYYMMWW
         , CASE WHEN C2.MONTH_END_DATE IS NOT NULL THEN ''Y'' ELSE ''N'' END AS MONTH_END_YN
         , CASE WHEN C3.WEEK_END_DATE  IS NOT NULL THEN ''Y'' ELSE ''N'' END AS WEEK_END_YN
         , ' || V_SQL_SELECT || '
      FROM GT_DMF0053_RAW_DATA A
      LEFT OUTER JOIN GT_DMF0053_SCM_MST_SITE B
        ON A.SCM_SITE_ID = B.SCM_SITE_ID AND A.DIVISION_ID = B.DIVISION_ID
      LEFT OUTER JOIN GT_DMF0053_SCM_MST_SITE_ITEM C
        ON A.DIVISION_ID = C.DIVISION_ID AND A.PROJECT_CODE = C.PROJECT_CODE
       AND A.SCM_SITE_ID = C.SCM_SITE_ID AND A.ITEM_ID = C.ITEM_ID
      LEFT OUTER JOIN GT_DMF0053_ITEM_SINGLE_V_T D
        ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
      LEFT OUTER JOIN SCM_MST_PROJECT G
        ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE
      JOIN GT_DMF0053_SELECT_MEASURE M
        ON A.MEASURE = M.MEASURE
      LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO N ON C.DEPT_ID = N.DEPT_ID
      LEFT OUTER JOIN SCM_MST_SSO_DEPT_INFO O ON N.UPPER_DEPT_ID = O.DEPT_ID
      JOIN SCM_SYS_CALENDAR_M CAL ON A.YYYYMMDD = CAL.BASIS_YYYYMMDD
      LEFT OUTER JOIN ( SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || '''
                         GROUP BY BASIS_YYYYMM ) C2 ON A.YYYYMMDD = C2.MONTH_END_DATE
      LEFT OUTER JOIN ( SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || '''
                         GROUP BY ISO_YYYYWW || PARTIAL_WEEK_NAME ) C3 ON A.YYYYMMDD = C3.WEEK_END_DATE
)
SELECT ' || V_COL_PLAIN || '
     , ' || CASE WHEN P_DIVISION_ID = '40' THEN V_PV_COL ELSE V_PV_PROJ END || '
  FROM (';

        /* Bucket 이 DAILY 면 일 컬럼을 먼저 얹는다 */
        IF P_BUCKET = 'DAILY' THEN
            V_SQL_TEXT := V_SQL_TEXT || '
        SELECT ' || V_COL_PLAIN || ', ''D_'' || F.YYYYMMDD AS YYYYMMDD, F.QTY
          FROM WF F
         WHERE F.QTY <> ( CASE WHEN F.MEASURE IN ( ' || V_KEEP_ZERO || ' ) THEN -9999999999 ELSE 0 END )
        UNION ALL';
        END IF;

        IF P_BUCKET <> 'ONLY_WEEKLY' THEN
            V_SQL_TEXT := V_SQL_TEXT || '
        SELECT ' || V_COL_PLAIN || ', ''W_'' || F.BASIS_YYYYMM || F.ISO_WEEK AS YYYYMMDD
             , CASE WHEN F.MEASURE IN ( ''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
                         THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END
                    WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)
                    ELSE SUM(F.QTY) END AS QTY
          FROM WF F
         WHERE F.QTY <> ( CASE WHEN F.MEASURE IN ( ' || V_KEEP_ZERO || ' ) THEN -9999999999 ELSE 0 END )
         GROUP BY ' || V_COL_PLAIN || ', F.BASIS_YYYYMM, F.ISO_WEEK, F.WEEK_END_YN
        UNION ALL
        SELECT ' || V_COL_PLAIN || ', ''M_'' || F.BASIS_YYYYMM AS YYYYMMDD
             , CASE WHEN F.MEASURE IN ( ''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
                         THEN CASE WHEN F.MONTH_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END
                    WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)
                    ELSE SUM(F.QTY) END AS QTY
          FROM WF F
         WHERE F.QTY <> ( CASE WHEN F.MEASURE IN ( ' || V_KEEP_ZERO || ' ) THEN -9999999999 ELSE 0 END )
         GROUP BY ' || V_COL_PLAIN || ', F.BASIS_YYYYMM, F.MONTH_END_YN
      )
      PIVOT ( SUM(QTY) FOR YYYYMMDD IN ( ' || V_PV_IN || ' ) )
     ORDER BY ' || V_ORDERBY_PLAIN;
        ELSE
            V_SQL_TEXT := V_SQL_TEXT || '
        SELECT ' || V_COL_PLAIN || ', ''W_'' || F.BASIS_YYYYMMWW AS YYYYMMDD
             , CASE WHEN F.MEASURE IN ( ''BALANCE'', ''VMI_Inv'', ''AS_Inv'', ''SS_LVL'', ''SS_GAP'' )
                         THEN CASE WHEN F.WEEK_END_YN = ''Y'' THEN SUM(F.QTY) ELSE 0 END
                    WHEN F.MEASURE = ''LOC'' THEN AVG(F.QTY)
                    ELSE SUM(F.QTY) END AS QTY
          FROM WF F
         WHERE F.QTY <> ( CASE WHEN F.MEASURE IN ( ' || V_KEEP_ZERO || ' ) THEN -9999999999 ELSE 0 END )
         GROUP BY ' || V_COL_PLAIN || ', F.BASIS_YYYYMMWW, F.ISO_WEEK, F.WEEK_END_YN
      )
      PIVOT ( SUM(QTY) FOR YYYYMMDD IN ( ' || V_PV_IN || ' ) )
     ORDER BY ' || V_ORDERBY_PLAIN;
        END IF;

        --========================================================================================
        -- 16. 결과셋
        --========================================================================================
        OPEN O_RC1 FOR V_SQL_TEXT;

        OPEN O_RC2 FOR
            SELECT ISO_WEEK, BASIS_DATE
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

        /* 정렬 문자열 — 사용자 컬럼 설정 + CREATE_DATE DESC + SORT_ORDER_NO */
        SELECT LISTAGG(COLUMN_NAME || ' ' || NVL(DATA_SORT_METHOD_CODE, 'ASC'), ',')
                   WITHIN GROUP (ORDER BY SORT_ORDER_NO) || ','
          INTO V_ORDER
          FROM SCM_MST_TITLESET_USER U
         WHERE U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
           AND U.PROGRAM_ID = V_PROGRAM_ID
           AND U.SHEET_NAME = V_SHEET_NAME
           AND U.USER_ID    = P_CREATED_BY;

        OPEN O_RC3 FOR
            SELECT NVL(V_ORDER, '') || 'CREATE_DATE DESC, SORT_ORDER_NO' AS DATA_ORDER
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := '[' || $$PLSQL_UNIT || '] ' || SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT * FROM GT_DMF0053_RAW_DATA WHERE 1 = 0;
            END IF;
            IF O_RC2%ISOPEN = FALSE THEN
                OPEN O_RC2 FOR SELECT NULL AS ISO_WEEK, NULL AS BASIS_DATE FROM DUAL WHERE 1 = 0;
            END IF;
            IF O_RC3%ISOPEN = FALSE THEN
                OPEN O_RC3 FOR SELECT NULL AS DATA_ORDER FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    END P_DMF0053_GET_CUST_FCST_WATERFALL;

END PKG_DMF0053;
/
