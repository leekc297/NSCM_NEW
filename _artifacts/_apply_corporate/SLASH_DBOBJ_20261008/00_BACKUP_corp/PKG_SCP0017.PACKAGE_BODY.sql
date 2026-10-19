PACKAGE BODY PKG_SCP0017
IS
/*
 * Program ID   : PKG_SCP0017
 * Description  : SCP0017 Waterfall Production Plan
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS          화면 조회조건 사이트 · 라인 · 전극유형의 ALL 을 조건 없음으로 처리(AS-IS 빈 값과 같은 의미)
 * 2026.10.07   AJS          조회 속도 개선 : 기준정보 적재(GT_0017_RAW)의 사업부명 · 생산품목 함수 결과 재사용, 사이트명 · 별칭은 값마다 한 번 조회, 달력 해시 조인
 */

    /*******************************************************************************
     * FN_ORDER_EXPR
     *   AS-IS 정렬 순서를 내는 ORDER BY 식을 만든다.
     *   문자 칸은 공용 함수 FN_ASIS_SORT_KEY 를 쓴다
     *   (AS-IS 순서를 글자 95 자 전수로 재어 만든 것 · 하이픈·홑따옴표는 빠지고
     *    구두점·기호는 숫자·문자보다 앞 · 대소문자를 가리지 않음).
     *   ★NULLS FIRST 를 반드시 붙인다 — 값이 하이픈뿐이면 정렬 열쇠가 NULL 이 되고
     *     Oracle 기본은 NULL 을 맨 뒤에 두지만 AS-IS 는 맨 앞이다.
     *   숫자 칸은 바꾸지 않는다.
     *******************************************************************************/
    FUNCTION FN_ORDER_EXPR
    (
        P_COLS  IN VARCHAR2
    )
    RETURN VARCHAR2
    IS

        C_NUMBER_COLS   CONSTANT VARCHAR2(200) := ',CELL_CF,QTY,';

        V_RESULT        VARCHAR2(4000);
        V_TOKEN         VARCHAR2(200);
        V_COL           VARCHAR2(200);
        V_DESC_YN       VARCHAR2(1);
        V_EXPR          VARCHAR2(600);
        V_IDX           PLS_INTEGER := 1;

    BEGIN

        LOOP

            V_TOKEN := TRIM(REGEXP_SUBSTR(P_COLS, '[^,]+', 1, V_IDX));

            EXIT WHEN V_TOKEN IS NULL;

            IF UPPER(V_TOKEN) LIKE '% DESC' THEN
                V_COL     := TRIM(SUBSTR(V_TOKEN, 1, LENGTH(V_TOKEN) - 5));
                V_DESC_YN := 'Y';
            ELSE
                V_COL     := V_TOKEN;
                V_DESC_YN := 'N';
            END IF;

            IF INSTR(C_NUMBER_COLS, ',' || UPPER(V_COL) || ',') > 0 THEN
                /* 숫자 칸 */
                IF V_DESC_YN = 'Y' THEN
                    V_EXPR := V_COL || ' DESC NULLS LAST';
                ELSE
                    V_EXPR := V_COL || ' NULLS FIRST';
                END IF;
            ELSE
                /* 문자 칸 : AS-IS 정렬 순서를 내는 공용 함수 */
                V_EXPR := 'FN_ASIS_SORT_KEY(' || V_COL || ')';

                IF V_DESC_YN = 'Y' THEN
                    V_EXPR := V_EXPR || ' DESC NULLS LAST';
                ELSE
                    V_EXPR := V_EXPR || ' NULLS FIRST';
                END IF;
            END IF;

            IF V_RESULT IS NULL THEN
                V_RESULT := V_EXPR;
            ELSE
                V_RESULT := V_RESULT || CHR(10) || '        , ' || V_EXPR;
            END IF;

            V_IDX := V_IDX + 1;

        END LOOP;

        RETURN V_RESULT;

    END FN_ORDER_EXPR;

    /*******************************************************************************
     * P_SCP0017_GET_SHEET_CALENDAR_3SPAN
     *   화면 머리글 달력. AS-IS 에 SCP0017 전용 프로시저가 없고
     *   화면 등록이 이 패키지를 가리키므로 공용
     *   PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN 과 같은 내용으로 둔다.
     *
     * 전환 기준 (AS-IS 동작 재현)
     *   1. 인자는 AS-IS NVARCHAR(8) 이므로 앞 8 자만 사용
     *   2. AS-IS 비교 콜레이션은 하이픈·아포스트로피를 견주지 않고 기호·공백류를 숫자보다 앞에 둔다
     *   3. 시작일이 빈값이면 AS-IS 는 '' 비교로 전체 기간 조회
     *   4. DAY_CODE 빈 문자('')는 Oracle 에서 NULL
     *******************************************************************************/
    PROCEDURE P_SCP0017_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_START_KEY     VARCHAR2(40);
        V_END_KEY       VARCHAR2(40);

        /* AS-IS 문자열 비교 기준으로 인자 변환 */
        FUNCTION F_COMPARE_KEY(P_VALUE IN VARCHAR2) RETURN VARCHAR2
        IS
            V_VALUE     VARCHAR2(40);
        BEGIN
            /* NVARCHAR(8) 절삭 */
            V_VALUE := SUBSTR(P_VALUE, 1, 8);
            /* 비교에서 견주지 않는 문자 제거 : 아포스트로피 · 하이픈 · 소프트 하이픈 · EN DASH */
            V_VALUE := TRANSLATE(V_VALUE
                               , CHR(1) || '''-' || UNISTR('\00AD\2013')
                               , CHR(1));
            /* 전각·위첨자 숫자는 숫자로, 숫자보다 앞에 정렬되는 기호·공백류는 공백으로 */
            V_VALUE := TRANSLATE(V_VALUE
                               , UNISTR('\FF10\FF11\FF12\FF13\FF14\FF15\FF16\FF17\FF18\FF19\00B9\00B2\00B3')
                                 || ':;<=>?@[\]^_`{|}~'
                                 || UNISTR('\3000\00A0')
                               , '0123456789123'
                                 || RPAD(' ', 19));
            RETURN V_VALUE;
        END F_COMPARE_KEY;

    BEGIN

        /* 시작일 빈값 = AS-IS '' 비교(전체) */
        V_START_KEY := NVL(F_COMPARE_KEY(P_START_YYYYMMDD), ' ');
        /* 종료일 빈값 = NULL 비교(0건), AS-IS '' 비교와 같은 결과 */
        V_END_KEY   := F_COMPARE_KEY(P_END_YYYYMMDD);

        OPEN O_RC1 FOR
            SELECT 'D_' || BASIS_YYYYMMDD           AS COLUMN_NAME
                 , CALENDAR_DAY                     AS COLUMN_LABEL_NAME
                 , WEEK_NAME                        AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , DAYOFWEEK                        AS DAY_CODE
                 , BASIS_YYYYMMDD || '31'           AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             UNION ALL
            SELECT 'W_' || BASIS_YYYYMM || ISO_WEEK AS COLUMN_NAME
                 , WEEK_NAME                        AS COLUMN_LABEL_NAME
                 , WEEK_NAME                        AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , NULL                             AS DAY_CODE
                 , BASIS_START_DATE || '21'         AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             GROUP BY BASIS_YYYYMM
                    , ISO_WEEK
                    , WEEK_NAME
                    , MONTH_NAME
                    , BASIS_START_DATE
             UNION ALL
            SELECT 'M_' || BASIS_YYYYMM             AS COLUMN_NAME
                 , MONTH_NAME                       AS COLUMN_LABEL_NAME
                 , MONTH_NAME                       AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                       AS LARGE_CLASS_LABEL_NAME
                 , NULL                             AS DAY_CODE
                 , MIN(BASIS_START_DATE) || '01'    AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= V_START_KEY
               AND BASIS_YYYYMMDD <= V_END_KEY
             GROUP BY BASIS_YYYYMM
                    , MONTH_NAME
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20001, '[PKG_SCP0017.P_SCP0017_GET_SHEET_CALENDAR_3SPAN] ' || SQLERRM);

    END P_SCP0017_GET_SHEET_CALENDAR_3SPAN;


    /*******************************************************************************
     * P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL
     *   AS-IS SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL
     *
     * 전환 기준
     *   1. AS-IS 임시 자료는 전역 임시 테이블(GT_0017_*)로 옮기고 시작할 때 비운다.
     *   2. AS-IS 가 문자열로 조립하던 조회문은 조건 분기가 있는 정적 SQL 로 바꾼다.
     *      조회 기간에 따라 칸 개수가 달라지는 마지막 피벗만 동적으로 둔다.
     *   3. AS-IS 가 만들기만 하고 쓰지 않는 임시 자료(NICKITEM)는 만들지 않는다.
     *   4. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_MODEL_ID              IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_VERSION_NO            IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_GAP                   IN  VARCHAR2
      , P_LINE_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_PLAN_START_YYYYMMDD   VARCHAR2(4000);
        V_TO_PERIOD             VARCHAR2(20);
        V_CNT_USER_MEASURE      PLS_INTEGER := 0;
        V_CNT_USR_COLUMN        PLS_INTEGER := 0;
        V_CNT_USR_COLUMN_FINAL  PLS_INTEGER := 0;

        V_FROM_YYYYMMDD         VARCHAR2(8);
        V_TO_YYYYMMDD           VARCHAR2(8);
        V_FROM_RESULT           VARCHAR2(8);
        V_TO_RESULT             VARCHAR2(8);

        V_CURR_CNT              PLS_INTEGER := 0;
        V_CURR_PLAN_START       VARCHAR2(100);

        V_DIV_ATTRIBUTE3        VARCHAR2(100);
        V_CURR_YYYYMM           VARCHAR2(6);

        /* 화면 칸 목록 */
        V_USER_COLS             VARCHAR2(4000);     /* AS-IS @v_final_user_cols   : MEASURE 가 두 번 들어갈 수 있다 */
        V_USER_COLS_UNIQ        VARCHAR2(4000);     /* 같은 목록에서 중복 이름을 뺀 것 (적재용) */
        V_USER_COLS_ORDER       VARCHAR2(4000);     /* AS-IS @v_final_user_cols_order */
        V_GAP_USER_COLS         VARCHAR2(4000);     /* AS-IS @v_gap_user_cols : 'A.' 를 붙인 것 */
        V_GAP_USER_KEYS         VARCHAR2(4000);     /* AS-IS @v_gap_user_keys : 키 연결식 */

        /* 피벗 칸 */
        V_PIVOT_COLS            CLOB;               /* 결과 칸 이름 목록 ('     , A.D_20260601' 꼴) */
        V_ACC_SEL_COLS          CLOB;               /* 누계 조회에서 고른 값 목록 */
        V_SUM_COLS              CLOB;
        V_ACC_DAY_COLS          CLOB;
        V_ACC_WEEK_COLS         CLOB;
        V_ACC_MONTH_COLS        CLOB;
        V_SQL                   CLOB;

        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_PIVOT_COLS,     TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ACC_SEL_COLS,   TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SUM_COLS,       TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ACC_DAY_COLS,   TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ACC_WEEK_COLS,  TRUE);
        DBMS_LOB.CREATETEMPORARY(V_ACC_MONTH_COLS, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL,            TRUE);

        /* 임시 자료 비우기 */
        DELETE FROM GT_0017_COLUMN_ALL;
        DELETE FROM GT_0017_COLUMN;
        DELETE FROM GT_0017_UOM;
        DELETE FROM GT_0017_CELL_TYPE_GROUP;
        DELETE FROM GT_0017_PRE;
        DELETE FROM GT_0017_FINAL_ITEM;
        DELETE FROM GT_0017_STD;
        DELETE FROM GT_0017_STD_PLAN;
        DELETE FROM GT_0017_STD_RESULT;
        DELETE FROM GT_0017_STD_RESULT_TEMP;
        DELETE FROM GT_0017_STD_TEMP;
        DELETE FROM GT_0017_RAW;
        DELETE FROM GT_0017_RAW_ALL_UOM;
        DELETE FROM GT_0017_FINAL_RAW;
        DELETE FROM GT_0017_GAP_DAY;
        DELETE FROM GT_0017_GAP_WEEK;
        DELETE FROM GT_0017_GAP_MONTH;

        V_PLAN_START_YYYYMMDD := REPLACE(P_VERSION_NO, 'PP_W_', '');
        V_TO_PERIOD           := P_TO_YYYYMMDD;
        V_CURR_YYYYMM         := TO_CHAR(SYSDATE, 'YYYYMM');

        SELECT COUNT(*)
          INTO V_CNT_USER_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;
           /* AND USER_INQUIRY_COLUMN_TYPE_CODE = 'M' */

        /* 사업부 계열 (E20260907-000019 신규로직에서 쓴다) */
        BEGIN
            SELECT ATTRIBUTE3
              INTO V_DIV_ATTRIBUTE3
              FROM SCM_MST_DIVISION
             WHERE DIVISION_ID = P_DIVISION_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_DIV_ATTRIBUTE3 := NULL;
        END;

        /*==========================================================================
         * 화면 칸 목록
         *========================================================================*/
        INSERT INTO GT_0017_COLUMN_ALL
        (
            COLUMN_NAME
          , USER_SORT_ORDER_NO
        )
        SELECT COLUMN_NAME
             , USER_SORT_ORDER_NO
          FROM ( SELECT A.COLUMN_NAME
                      , ROW_NUMBER() OVER (ORDER BY NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO))  AS USER_SORT_ORDER_NO
                   FROM SCM_MST_SHEET_COLUMNS   A
                      , SCM_MST_TITLESET_USER   B
                  WHERE B.PROGRAM_ID(+)                    = A.PROGRAM_ID
                    AND B.SHEET_NAME(+)                    = A.SHEET_NAME
                    AND B.COLUMN_NAME(+)                   = A.COLUMN_NAME
                    AND B.USER_ID(+)                       = P_USER_ID
                    AND B.USER_INQUIRY_COLUMN_TYPE_CODE(+) = 'C'
                    AND A.PROGRAM_ID                       = P_PROGRAM_ID
                    AND A.SHEET_NAME                       = P_SHEET_NAME
                    AND A.VALID_YN                         = 'Y'
                    AND A.VISIBLE_FLAG                     = 'Y'
               )  IA;

        SELECT COUNT(1)
          INTO V_CNT_USR_COLUMN
          FROM GT_0017_COLUMN_ALL;

        INSERT INTO GT_0017_COLUMN
        (
            COLUMN_NAME
          , USER_SORT_ORDER_NO
        )
        SELECT A.COLUMN_NAME
             , A.USER_SORT_ORDER_NO
          FROM GT_0017_COLUMN_ALL  A
         WHERE 1 = 1
           AND ( V_CNT_USR_COLUMN = 0
                 OR EXISTS (SELECT 1
                              FROM SCM_MST_TITLESET_USER
                             WHERE 1 = 1
                               AND PROGRAM_ID                      = P_PROGRAM_ID
                               AND SHEET_NAME                      = P_SHEET_NAME
                               AND COLUMN_NAME                     = A.COLUMN_NAME
                               AND USER_ID                         = P_USER_ID
                               AND USER_INQUIRY_COLUMN_TYPE_CODE   = 'C')
               );

        SELECT COUNT(*)
          INTO V_CNT_USR_COLUMN_FINAL
          FROM GT_0017_COLUMN;

        /* 사용자ID 오류로 인해서 컬럼 못 가져오는 경우 있음(원인불명) */
        IF V_CNT_USR_COLUMN_FINAL = 0 THEN

            INSERT INTO GT_0017_COLUMN
            (
                COLUMN_NAME
              , USER_SORT_ORDER_NO
            )
            SELECT COLUMN_NAME
                 , USER_SORT_ORDER_NO
              FROM GT_0017_COLUMN_ALL;

        END IF;

        /*==========================================================================
         * UOM 은 DIV = 'EE' & @p_operation_group = 'E' 일때만 표시
         *========================================================================*/
        IF P_DIVISION_ID = 'EE' AND P_OPERATION_GROUP = 'E' THEN

            INSERT INTO GT_0017_UOM (UOM) SELECT 'M'  AS UOM FROM DUAL;
            INSERT INTO GT_0017_UOM (UOM) SELECT 'EA' AS UOM FROM DUAL;

        ELSE

            INSERT INTO GT_0017_UOM (UOM) SELECT 'EA' AS UOM FROM DUAL;

        END IF;

        /*==========================================================================
         * 셀 종류 묶음
         *========================================================================*/
        INSERT INTO GT_0017_CELL_TYPE_GROUP
        (
            CELL_TYPE_CODE
          , FLOW_TYPE
          , CELL_TYPE_GROUP_CODE
          , CELL_TYPE_GROUP_NAME
          , DISPLAY_SEQ
        )
        SELECT A.CODE                   AS CELL_TYPE_CODE
             , SUBSTR(A.NAME, 1, 1)     AS FLOW_TYPE
             , A.GROUP_CODE             AS CELL_TYPE_GROUP_CODE
             , G.NAME                   AS CELL_TYPE_GROUP_NAME
             , A.DISPLAY_SEQ
          FROM ( SELECT B.SEGMENT1  AS CODE
                      , B.SEGMENT2  AS NAME
                      , B.SEGMENT3  AS GROUP_CODE
                      , B.DISPLAY_SEQ
                   FROM SCM_ADM_LOOKUP_MASTER          A
                      , SCM_ADM_LOOKUP_MASTER_DETAIL   B
                  WHERE A.LOOKUP_TYPE = B.LOOKUP_TYPE
                    AND B.VALID_YN    = 'Y'
                    AND A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_CODE'
                    AND A.VALID_YN    = 'Y'
               )  A
             , ( SELECT B.SEGMENT1  AS CODE
                      , B.SEGMENT2  AS NAME
                   FROM SCM_ADM_LOOKUP_MASTER          A
                      , SCM_ADM_LOOKUP_MASTER_DETAIL   B
                  WHERE A.LOOKUP_TYPE = B.LOOKUP_TYPE
                    AND B.VALID_YN    = 'Y'
                    AND A.LOOKUP_TYPE = 'CELL_TYPE_ITEM_GROUP'
                    AND A.VALID_YN    = 'Y'
               )  G
         WHERE A.GROUP_CODE = G.CODE;

        /*==========================================================================
         * 대상 품목
         *   [PJ20257329] Cell 완성 공정 하드 코딩 변경
         *   AS-IS 는 완성 공정 목록을 테이블 변수에 담아 외부조인했다.
         *   목록이 중복 없는 한 칸짜리라 EXISTS 로 옮겨도 결과가 같다.
         *========================================================================*/
        INSERT INTO GT_0017_PRE
        (
            DIVISION_ID
          , OPERATION_ID
          , ITEM_ID
          , CELL_TYPE_CODE
          , LEVEL_EXCEPT
          , CELL_NICKNAME
          , BASIC_NICKNAME_CELL40
          , NICKNAME_40
          , GROUP_CODE4
          , GROUP_CODE5
          , GROUP_CODE6
          , GROUP_CODE7
          , FLOW_TYPE
        )
        SELECT A.DIVISION_ID
             , A.FLOW_ID                        AS OPERATION_ID
             , A.ITEM_ID
             , SUBSTR(A.ITEM_ID, 3, 1)          AS CELL_TYPE_CODE
             , SUBSTR(A.ITEM_ID, 1, 2)          AS LEVEL_EXCEPT /* 예외적용 */
             , CASE
                 WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81'  THEN A.GROUP_CODE1
                 WHEN A.DIVISION_ID = '82'                THEN A.LEVEL2_CODE
                 ELSE ''
               END                              AS CELL_NICKNAME
             , CASE
                 WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'EC' THEN 'ESS'
                 WHEN SUBSTR(A.ITEM_ID, 1, 2) = 'AM' THEN 'M50L'
                 ELSE
                   CASE
                     WHEN A.OPERATION_GROUP = 'P'
                     THEN (SELECT SA.NICK_NAME
                             FROM ( SELECT B.NICK_NAME
                                      FROM SCP_MST_FINAL_ITEM B
                                     WHERE B.DIVISION_ID = A.DIVISION_ID
                                       AND B.ITEM_ID     = (SELECT XA.DOE
                                                              FROM ( SELECT C.DOE
                                                                       FROM SCM_MST_ITEM_SN C
                                                                      WHERE C.DIVISION_ID = A.DIVISION_ID
                                                                        AND C.ITEM_ID     = A.ATTRIBUTE1
                                                                        AND C.DOE IS NOT NULL
                                                                   )  XA
                                                             WHERE ROWNUM = 1)
                                  )  SA
                            WHERE ROWNUM = 1)
                     ELSE (SELECT SA.NICK_NAME
                             FROM ( SELECT B.NICK_NAME
                                      FROM SCP_MST_FINAL_ITEM B
                                     WHERE B.DIVISION_ID = A.DIVISION_ID
                                       AND B.ITEM_ID     = (SELECT XA.DOE
                                                              FROM ( SELECT C.DOE
                                                                       FROM SCM_MST_ITEM_SN C
                                                                      WHERE C.DIVISION_ID = A.DIVISION_ID
                                                                        AND C.ITEM_ID     = A.ITEM_ID
                                                                        AND C.DOE IS NOT NULL
                                                                   )  XA
                                                             WHERE ROWNUM = 1)
                                  )  SA
                            WHERE ROWNUM = 1)
                   END
               END                              AS BASIC_NICKNAME_CELL40
             , A.NICK_NAME                      AS NICKNAME_40
             , A.GROUP_CODE4
             , A.GROUP_CODE5
             , A.GROUP_CODE6
             , A.GROUP_CODE7
             , CASE
                 /* [PJ20257329] 변경전 WHEN A.FLOW_ID IN ('A3000', 'A9000') THEN 'C' */
                 WHEN EXISTS (SELECT 1                      /* [PJ20257329] Cell 완성 공정 하드 코딩 변경 */
                                FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK
                               WHERE LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                 AND LK.SEGMENT3    = 'A'   /* 공정그룹(Cell) */
                                 AND LK.ATTRIBUTE1  = 'Y'   /* Final Operation */
                                 AND LK.SEGMENT1    = A.FLOW_ID)
                 THEN 'C'
                 ELSE 'E'
               END                              AS FLOW_TYPE
          FROM SCP_MST_FINAL_ITEM A
         WHERE 1 = 1
           AND (SUBSTR(A.ATTRIBUTE8, 1, 2) <> 'CA' OR A.ATTRIBUTE8 IS NULL)   /* 활성화코드 분리 */
           AND A.DIVISION_ID = P_DIVISION_ID
           AND ( TRIM(P_OPERATION_GROUP) IS NULL
                 OR A.OPERATION_GROUP IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_OPERATION_GROUP, ','))) )
           AND ( TRIM(P_MODEL_ID) IS NULL
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_MODEL_ID, ','))) );

        INSERT INTO GT_0017_FINAL_ITEM
        (
            DIVISION_ID
          , OPERATION_ID
          , ITEM_ID
          , CELL_TYPE_CODE
          , LEVEL_EXCEPT
          , CELL_NICKNAME
          , BASIC_NICKNAME_CELL40
          , NICKNAME_40
          , GROUP_CODE4
          , GROUP_CODE5
          , GROUP_CODE6
          , GROUP_CODE7
          , FLOW_TYPE
          , CELL_TYPE_GROUP_NAME
        )
        SELECT P.DIVISION_ID
             , P.OPERATION_ID
             , P.ITEM_ID
             , P.CELL_TYPE_CODE
             , P.LEVEL_EXCEPT
             , P.CELL_NICKNAME
             , P.BASIC_NICKNAME_CELL40
             , P.NICKNAME_40
             , P.GROUP_CODE4
             , P.GROUP_CODE5
             , P.GROUP_CODE6
             , P.GROUP_CODE7
             , P.FLOW_TYPE
             , CASE
                 WHEN P.LEVEL_EXCEPT = 'EC' THEN 'Pouch'
                 WHEN P.LEVEL_EXCEPT = 'AM' THEN 'Cylindrical'
                 WHEN SUBSTR(P.ITEM_ID, 3, 1) = 'M' AND P.OPERATION_ID = 'P9500' THEN 'Pouch'
                 ELSE G.CELL_TYPE_GROUP_NAME
               END                              AS CELL_TYPE_GROUP_NAME
          FROM GT_0017_PRE               P
             , GT_0017_CELL_TYPE_GROUP   G
         WHERE P.FLOW_TYPE      = G.FLOW_TYPE(+)
           AND P.CELL_TYPE_CODE = G.CELL_TYPE_CODE(+);


        /*==========================================================================
         * 기준일(버전)별 되풀이
         *   AS-IS 는 커서로 @p_plan_start_yyyymmdd 를 쉼표로 나눠 돌린다.
         *   AS-IS String_Split 의 순번(nr)은 1 부터이므로 ROWNUM 으로 옮긴다.
         *========================================================================*/
        FOR CUR_SCP0017 IN ( SELECT ROWNUM        AS NR
                                  , COLUMN_VALUE  AS TOKEN
                               FROM TABLE(STRING_SPLIT(V_PLAN_START_YYYYMMDD, ','))
                           )
        LOOP

            V_CURR_CNT        := CUR_SCP0017.NR;
            V_CURR_PLAN_START := CUR_SCP0017.TOKEN;

            BEGIN
                SELECT C.BASIS_START_DATE
                  INTO V_FROM_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M C
                 WHERE 1 = 1
                   AND C.BASIS_YYYYMMDD = V_CURR_PLAN_START;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_FROM_YYYYMMDD := NULL;
            END;

            BEGIN
                SELECT C.BASIS_START_DATE
                  INTO V_FROM_RESULT
                  FROM SCM_SYS_CALENDAR_M C
                 WHERE 1 = 1
                   AND C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_FROM_RESULT := NULL;
            END;

            BEGIN
                SELECT C.BASIS_START_DATE
                  INTO V_TO_RESULT
                  FROM SCM_SYS_CALENDAR_M C
                 WHERE 1 = 1
                   AND C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_TO_RESULT := NULL;
            END;

            IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
                /* 실적 보여줌 */
                V_TO_YYYYMMDD   := P_TO_YYYYMMDD;
                V_TO_RESULT     := V_FROM_YYYYMMDD;
            ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
                /* 실적 없음 */
                V_TO_YYYYMMDD   := P_TO_YYYYMMDD;
                V_FROM_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(V_CURR_PLAN_START, 'YYYYMMDD'),  6), 'YYYYMMDD');
                V_TO_RESULT     := TO_CHAR(ADD_MONTHS(TO_DATE(V_CURR_PLAN_START, 'YYYYMMDD'), -6), 'YYYYMMDD');
            ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
                V_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_CURR_PLAN_START, 'YYYYMMDD'), -6), 'YYYYMMDD');
                V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(V_CURR_PLAN_START, 'YYYYMMDD'), -6), 'YYYYMMDD');
                V_FROM_RESULT   := P_FROM_YYYYMMDD;
                V_TO_RESULT     := P_TO_YYYYMMDD;
            ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
                V_TO_YYYYMMDD   := V_FROM_YYYYMMDD;
                V_FROM_RESULT   := P_FROM_YYYYMMDD;
                V_TO_RESULT     := P_TO_YYYYMMDD;
            END IF;

            /*======================================================================
             * 기준정보 RESULT C : 회차마다 비운다
             *====================================================================*/
            DELETE FROM GT_0017_STD;
            DELETE FROM GT_0017_STD_PLAN;
            DELETE FROM GT_0017_STD_RESULT;
            DELETE FROM GT_0017_STD_RESULT_TEMP;
            DELETE FROM GT_0017_STD_TEMP;

            /* 계획 */
            INSERT INTO GT_0017_STD_PLAN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , CASE WHEN TRIM(A.ORIGIN_DIVISION_ID) IS NULL THEN A.DIVISION_ID
                        ELSE A.ORIGIN_DIVISION_ID END               AS ORIGIN_DIVISION_ID
                 , CASE WHEN TRIM(A.ELECTRODE_TYPE) IS NULL THEN '-'
                        ELSE A.ELECTRODE_TYPE END                   AS ELECTRODE_TYPE
              FROM SCP_ANL_PRODUCTION_PLAN_C A
             WHERE 1 = 1
               AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD            <= P_TO_YYYYMMDD
               AND A.DIVISION_ID          = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD  = V_CURR_PLAN_START
               /* 2026.09.26 성능 : 버전을 함께 걸어 기본키(사업부 · 버전 · …) 선두를 쓰게 한다.
                *   버전을 빼면 기본키 건너뛰기 조회가 되어 결과가 742 행인데 100 만 블록을 뒤진다.
                *   원장에서 버전은 언제나 'PP_W_' + 기준일 이다(실측 2026-09-26 · 사업부 82 어긋남 0 행).
                *   화면이 이 값을 받아 라인 조회에 그대로 넘기고 라인 조회가 버전으로 조회하므로
                *   짝이 어긋나면 라인 조회가 애초에 0 행이 된다. */
               AND A.VERSION_NO           = 'PP_W_' || V_CURR_PLAN_START
               AND A.OPERATION_GROUP      = P_OPERATION_GROUP
               AND A.QTY                 <> 0
               AND ( TRIM(P_SCM_SITE_ID) IS NULL
                  OR UPPER(TRIM(P_SCM_SITE_ID)) = 'ALL'                                                       --  2026.10.07 AJS
                     OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
               AND ( ( TRIM(P_ITEM_ID) IS NULL AND TRIM(P_NICK_NAME) IS NULL )
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME))) )
               AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
                  OR UPPER(TRIM(P_ELECTRODE_TYPE)) = 'ALL'                                                    --  2026.10.07 AJS
                     OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
               AND ( TRIM(P_LINE_ID) IS NULL
                  OR UPPER(TRIM(P_LINE_ID)) = 'ALL'                                                           --  2026.10.07 AJS
                     OR A.LINE_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) );

            /* 실적 */
            INSERT INTO GT_0017_STD_RESULT_TEMP
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT CASE
                     /* E20260907-000019 기존 로직 주석처리 */
                     /* WHEN @p_division_id = 'EE' OR @p_division_id = 'EE_UC' OR @p_division_id = 'EE_HM' THEN @p_division_id */
                     /* E20260907-000019 신규로직 */
                     WHEN V_DIV_ATTRIBUTE3 = 'EE' THEN P_DIVISION_ID
                     ELSE A.DIVISION_ID
                   END                                              AS DIVISION_ID
                 , A.SCP_OPERATION_GROUP                            AS OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , 'PROD_PLAN_ENGINE'                               AS MEASURE
                 , TO_CHAR(A.PLAN_DATE, 'YYYYMMDD')                 AS YYYYMMDD
                 , A.ACTUAL_GOOD_QTY                                AS QTY
                 , A.DIVISION_ID                                    AS ORIGIN_DIVISION_ID
                 , CASE WHEN TRIM(A.ELECTRODE_TYPE) IS NULL THEN '-'
                        ELSE A.ELECTRODE_TYPE END                   AS ELECTRODE_TYPE
              FROM SCM_DNM_PRODUCT_RESULT_V A
             WHERE 1 = 1
               /* AND ( @p_division_id IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) OR A.division_id = @p_division_id ) --div_commonization */
               AND ( A.DIVISION_ID = P_DIVISION_ID
                     OR A.DIVISION_ID IN (SELECT DIVISION_ID
                                            FROM SCM_MST_DIVISION
                                           WHERE ATTRIBUTE4 IN (SELECT ATTRIBUTE4
                                                                  FROM SCM_MST_DIVISION
                                                                 WHERE DIVISION_ID = P_DIVISION_ID)
                                             AND ATTRIBUTE3 <> 'EE') )    /* div_commonization */
               AND A.COMPANY_ID IN (SELECT DISTINCT COMPANY_ID
                                      FROM SCM_MST_SITE
                                     WHERE 1 = 1
                                       AND ( P_DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                             OR DIVISION_ID = P_DIVISION_ID )   /* div_commonization */
                                       AND SITE_TYPE = 'PLANT'
                                       AND VALID_YN  = 'Y')
               AND A.PLAN_DATE >= TO_DATE(V_FROM_RESULT, 'YYYYMMDD')
               AND A.PLAN_DATE <  TO_DATE(V_TO_RESULT,   'YYYYMMDD');

            INSERT INTO GT_0017_STD_RESULT
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
              FROM GT_0017_STD_RESULT_TEMP A
             WHERE 1 = 1
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND ( SUBSTR(A.OPERATION_ID, 1, 5) IN    /* LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회 */
                                                     (SELECT SEGMENT1  AS OPERATION_ID
                                                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                       WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                         AND SEGMENT1   <> 'F6000'
                                                         AND VALID_YN    = 'Y')
                     OR A.OPERATION_ID IN             /* 외주PACKER의 업체코드 */
                                                     (SELECT S.PLANT_ID  AS OPERATION_ID
                                                        FROM SCM_MST_SITE S
                                                       WHERE 1 = 1
                                                         AND ( ( P_DIVISION_ID = 'EE'
                                                                 AND S.DIVISION_ID IN ('40', '81', '82') )
                                                               OR ( P_DIVISION_ID = 'EE_UC'
                                                                    AND S.DIVISION_ID = '81_UC' )
                                                               OR ( P_DIVISION_ID NOT IN ('EE', 'EE_UC')
                                                                    AND S.DIVISION_ID = P_DIVISION_ID ) )
                                                         AND S.SITE_TYPE = 'PLANT'
                                                         AND S.OSP_YN    = 'Y'
                                                         AND S.VALID_YN  = 'Y') )
               AND ( TRIM(P_SCM_SITE_ID) IS NULL
                  OR UPPER(TRIM(P_SCM_SITE_ID)) = 'ALL'                                                       --  2026.10.07 AJS
                     OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
               AND ( ( TRIM(P_ITEM_ID) IS NULL AND TRIM(P_NICK_NAME) IS NULL )
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME))) )
               AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
                  OR UPPER(TRIM(P_ELECTRODE_TYPE)) = 'ALL'                                                    --  2026.10.07 AJS
                     OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))) )
               AND ( TRIM(P_LINE_ID) IS NULL
                  OR UPPER(TRIM(P_LINE_ID)) = 'ALL'                                                           --  2026.10.07 AJS
                     OR A.LINE_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))) );

            INSERT INTO GT_0017_STD
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , OPERATION_ID
                 , LINE_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
              FROM GT_0017_STD_PLAN
             UNION ALL
            SELECT DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , OPERATION_ID
                 , LINE_ID
                 , MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
              FROM GT_0017_STD_RESULT;

            /*======================================================================
             * (PROD PLAN AMEND) 추가
             *====================================================================*/
            INSERT INTO GT_0017_STD_TEMP
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , OPERATION_ID
                 , LINE_ID
                 , 'PROD_PLAN_AMEND'  AS MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
              FROM GT_0017_STD
             WHERE 1 = 1
               AND MEASURE = 'PROD_PLAN_ENGINE';

            DELETE FROM GT_0017_STD
             WHERE 1 = 1
               AND MEASURE = 'PROD_PLAN_AMEND';

            INSERT INTO GT_0017_STD
            (
                DIVISION_ID
              , OPERATION_GROUP
              , SCM_SITE_ID
              , ITEM_ID
              , OPERATION_ID
              , LINE_ID
              , MEASURE
              , YYYYMMDD
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
            )
            SELECT DIVISION_ID
                 , OPERATION_GROUP
                 , SCM_SITE_ID
                 , ITEM_ID
                 , OPERATION_ID
                 , LINE_ID
                 , 'PROD_PLAN_AMEND'  AS MEASURE
                 , YYYYMMDD
                 , QTY
                 , ORIGIN_DIVISION_ID
                 , ELECTRODE_TYPE
              FROM GT_0017_STD_TEMP
             WHERE 1 = 1
               AND MEASURE = 'PROD_PLAN_AMEND';

            /*======================================================================
             * 데이타조회, 임시테이블에 저장
             *   AS-IS 는 FN_GET_ITEM_PROD_OP 를 조인조건과 조회목록에서 두 번 부른다.
             *   같은 값이므로 인라인 뷰에서 한 번만 불러 쓴다.
             *====================================================================*/
            INSERT INTO GT_0017_RAW
            (
                KEY_IDX
              , DIVISION_ID
              , DIVISION_NAME
              , OPERATION_GROUP
              , OPERATION_GROUP_NAME
              , SCM_SITE_ID
              , SCM_SITE_DESCRIPTION
              , LINE_ID
              , CELL_NICKNAME
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MODEL_ID
              , ITEM_ID
              , NICK_NAME
              , MEASURE
              , MEASURE_NAME
              , USER_SORT_ORDER_NO
              , UOM
              , CELL_CF
              , PLAN_START_YYYYMMDD
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
              , WEEK_YN
              , MONTH_YN
              , VERSION_NO
              , VERSION_IDX
            )
            SELECT    A.DIVISION_ID
                   || ';' || A.DIVISION_NAME
                   || ';' || A.OPERATION_GROUP
                   || ';' || A.OPERATION_GROUP_NAME
                   || ';' || A.SCM_SITE_ID
                   || ';' || A.SCM_SITE_DESCRIPTION
                   || ';' || A.LINE_ID
                   || ';' || A.CELL_NICKNAME
                   || ';' || A.PRODUCT_LEVEL1
                   || ';' || A.PRODUCT_LEVEL2
                   || ';' || A.PRODUCT_LEVEL3
                   || ';' || A.MODEL_ID
                   || ';' || A.ITEM_ID
                   || ';' || A.NICK_NAME
                   || ';' || A.UOM
                   || ';' || A.CELL_CF
                   || ';' || A.PLAN_START_YYYYMMDD
                   || ';' || A.FROM_YYYYMMDD
                   || ';' || A.TO_YYYYMMDD
                   || ';' || A.YYYYMMDD
                   || ';' || A.YYYYMM
                   || ';' || A.ISO_WEEK
                   || ';' || A.ORIGIN_DIVISION_ID
                   || ';' || A.ELECTRODE_TYPE
                   || ';' || A.WEEK_YN
                   || ';' || A.MONTH_YN
                   || ';' || A.VERSION_NO
                   || ';' || A.VERSION_IDX                                          AS KEY_IDX
                 , A.DIVISION_ID
                 , A.DIVISION_NAME
                 , A.OPERATION_GROUP
                 , A.OPERATION_GROUP_NAME
                 , A.SCM_SITE_ID
                 , A.SCM_SITE_DESCRIPTION
                 , A.LINE_ID
                 , A.CELL_NICKNAME
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , A.MEASURE
                 , A.MEASURE_NAME
                 , A.USER_SORT_ORDER_NO
                 , A.UOM
                 , A.CELL_CF
                 , A.PLAN_START_YYYYMMDD
                 , A.FROM_YYYYMMDD
                 , A.TO_YYYYMMDD
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
                 , A.QTY
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.WEEK_YN
                 , A.MONTH_YN
                 , A.VERSION_NO
                 , A.VERSION_IDX
--            FROM ( SELECT A.DIVISION_ID
              FROM ( SELECT /*+ USE_HASH(O IB IC) */                           /* AJS 20261007 속도 : 달력 · 사이트명 · 별칭 해시 조인 */
                            A.DIVISION_ID
--                        , FN_GET_DIVISION_NAME(A.DIVISION_ID)                     AS DIVISION_NAME
                          , (SELECT FN_GET_DIVISION_NAME(A.DIVISION_ID) FROM DUAL)  AS DIVISION_NAME          /* AJS 20261007 속도 */
                          , A.OPERATION_GROUP
                          , ( SELECT SA.SEGMENT2
                                FROM ( SELECT C.SEGMENT2
                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL C
                                        WHERE C.LOOKUP_TYPE = 'OPERATION_GROUP'
                                          AND NVL(TRIM(C.SEGMENT1), '@') = NVL(TRIM(A.OPERATION_GROUP), '@')
                                     )  SA
                               WHERE ROWNUM = 1 )                                   AS OPERATION_GROUP_NAME
                          , A.SCM_SITE_ID
--                        , ( SELECT SA.SITE_DESCRIPTION
--                              FROM ( SELECT X.SITE_DESCRIPTION
--                                       FROM SCM_MST_SITE X
--                                      WHERE X.SCM_SITE_ID = A.SCM_SITE_ID
--                                   )  SA
--                             WHERE ROWNUM = 1 )                                   AS SCM_SITE_DESCRIPTION
                          , IB.SCM_SITE_DESCRIPTION   /* AJS 20261007 속도 */
                          , A.LINE_ID
                          , F.CELL_NICKNAME
                          , CASE
                              WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82'  THEN F.GROUP_CODE6
                              ELSE                                                                  F.CELL_TYPE_GROUP_NAME
                            END                                                     AS PRODUCT_LEVEL1
                          , CASE
                              WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81' OR A.DIVISION_ID = '82'  THEN F.GROUP_CODE7
                              ELSE                                                                  F.BASIC_NICKNAME_CELL40
                            END                                                     AS PRODUCT_LEVEL2
                          , CASE
                              WHEN SUBSTR(A.DIVISION_ID, 1, 2) = '81'                          THEN F.GROUP_CODE5
                              WHEN A.DIVISION_ID = '82'                                        THEN F.GROUP_CODE4
                              ELSE                                                                  F.NICKNAME_40
                            END                                                     AS PRODUCT_LEVEL3
                          , A.MODEL_ID
                          , A.ITEM_ID
--                        , ( SELECT SA.NICK_NAME
--                              FROM ( SELECT CASE
--                                              WHEN X.NICK_NAME IS NULL OR X.NICK_NAME = ' ' THEN '-'
--                                              ELSE                                               X.NICK_NAME
--                                            END  AS NICK_NAME
--                                       FROM SCM_MST_ITEM_SN X
--                                      WHERE X.ITEM_ID = A.ITEM_ID
--                                   )  SA
--                             WHERE ROWNUM = 1 )                                   AS NICK_NAME
                          , IC.NICK_NAME   /* AJS 20261007 속도 */
                          , A.MEASURE
                          , A.MEASURE_NAME
                          , A.USER_SORT_ORDER_NO
                          , 'EA'                                                    AS UOM
                          , 0                                                       AS CELL_CF
                          , V_CURR_PLAN_START                                       AS PLAN_START_YYYYMMDD
                          , P_FROM_YYYYMMDD                                         AS FROM_YYYYMMDD
                          , P_TO_YYYYMMDD                                           AS TO_YYYYMMDD
                          , 'D_' || A.YYYYMMDD                                      AS YYYYMMDD
                          , O.BASIS_YYYYMM                                          AS YYYYMM
                          , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK                AS ISO_WEEK
                          , NVL(N.QTY, 0)                                           AS QTY
                          , A.ORIGIN_DIVISION_ID
                          , A.ELECTRODE_TYPE
                          , 'N'                                                     AS WEEK_YN
                          , 'N'                                                     AS MONTH_YN
                          , 'PP_W_' || V_CURR_PLAN_START                            AS VERSION_NO
                          , TO_CHAR(V_CURR_CNT)                                     AS VERSION_IDX
                       FROM ( SELECT XA.DIVISION_ID
                                   , XA.OPERATION_GROUP
                                   , XA.SCM_SITE_ID
                                   , XA.ITEM_ID
                                   , XA.LINE_ID
                                   , XA.OPERATION_ID
                                   , XA.MEASURE
                                   , XA.MEASURE_NAME
                                   , XA.USER_SORT_ORDER_NO
                                   , XA.YYYYMMDD
                                   , XA.ORIGIN_DIVISION_ID
                                   , XA.ELECTRODE_TYPE
--                                 , FN_GET_ITEM_PROD_OP(XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID)  AS MODEL_ID
                                   , (SELECT FN_GET_ITEM_PROD_OP(XA.DIVISION_ID, XA.OPERATION_GROUP, XA.ITEM_ID) FROM DUAL)  AS MODEL_ID   /* AJS 20261007 속도 */
                                FROM ( SELECT C.DIVISION_ID
                                            , C.OPERATION_GROUP
                                            , C.SCM_SITE_ID
                                            , C.ITEM_ID
                                            , C.LINE_ID
                                            , C.OPERATION_ID
                                            , A.COLUMN_NAME                         AS MEASURE
                                            , A.COLUMN_LABEL_NAME                   AS MEASURE_NAME
                                            , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO) AS USER_SORT_ORDER_NO
                                            , C.YYYYMMDD
                                            , C.ORIGIN_DIVISION_ID
                                            , C.ELECTRODE_TYPE
                                         FROM SCM_MST_SHEET_MEASURE    A
                                            , SCM_MST_TITLESET_USER    B
                                            , GT_0017_STD              C
                                        WHERE B.PROGRAM_ID(+)  = A.PROGRAM_ID
                                          AND B.SHEET_NAME(+)  = A.SHEET_NAME
                                          AND B.COLUMN_NAME(+) = A.COLUMN_NAME
                                          AND B.USER_ID(+)     = P_USER_ID
                                          AND A.PROGRAM_ID     = P_PROGRAM_ID
                                          AND A.SHEET_NAME     = P_SHEET_NAME
                                          AND A.VALID_YN       = 'Y'
                                          AND ( P_OPERATION_GROUP = 'A' OR NVL(TRIM(A.ATTRIBUTE1), '@') <> 'A' )
                                          AND ( V_CNT_USER_MEASURE = 0
                                                OR EXISTS (SELECT 1
                                                             FROM SCM_MST_TITLESET_USER
                                                            WHERE PROGRAM_ID  = P_PROGRAM_ID
                                                              AND SHEET_NAME  = P_SHEET_NAME
                                                              AND USER_ID     = P_USER_ID
                                                              AND COLUMN_NAME = A.COLUMN_NAME) )
                                        GROUP BY C.DIVISION_ID
                                               , C.OPERATION_GROUP
                                               , C.SCM_SITE_ID
                                               , C.ITEM_ID
                                               , C.LINE_ID
                                               , C.OPERATION_ID
                                               , A.COLUMN_NAME
                                               , A.COLUMN_LABEL_NAME
                                               , C.YYYYMMDD
                                               , C.ORIGIN_DIVISION_ID
                                               , C.ELECTRODE_TYPE
                                               , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO)
                                     )  XA
                            )  A
                          , GT_0017_FINAL_ITEM   F
                          , GT_0017_STD          N
                          , SCM_SYS_CALENDAR_M   O
                          , ( SELECT XB.SCM_SITE_ID                                 /* AJS 20261007 속도 : 사이트명 - 같은 하위질의를 사이트마다 한 번 */
                                   , ( SELECT SA.SITE_DESCRIPTION
                                         FROM ( SELECT X.SITE_DESCRIPTION
                                                  FROM SCM_MST_SITE X
                                                 WHERE X.SCM_SITE_ID = XB.SCM_SITE_ID
                                              )  SA
                                        WHERE ROWNUM = 1 )                          AS SCM_SITE_DESCRIPTION
                                FROM ( SELECT DISTINCT SCM_SITE_ID
                                         FROM GT_0017_STD
                                     )  XB
                            )  IB
                          , ( SELECT XC.ITEM_ID                                     /* AJS 20261007 속도 : 별칭 - 같은 하위질의를 품목마다 한 번 */
                                   , ( SELECT SA.NICK_NAME
                                         FROM ( SELECT CASE
                                                         WHEN X.NICK_NAME IS NULL OR X.NICK_NAME = ' ' THEN '-'
                                                         ELSE                                               X.NICK_NAME
                                                       END  AS NICK_NAME
                                                  FROM SCM_MST_ITEM_SN X
                                                 WHERE X.ITEM_ID = XC.ITEM_ID
                                              )  SA
                                        WHERE ROWNUM = 1 )                          AS NICK_NAME
                                FROM ( SELECT DISTINCT ITEM_ID
                                         FROM GT_0017_STD
                                     )  XC
                            )  IC
                      WHERE A.DIVISION_ID          = F.DIVISION_ID(+)
                        AND A.MODEL_ID             = F.ITEM_ID(+)
                        AND A.DIVISION_ID          = N.DIVISION_ID(+)
                        AND A.OPERATION_GROUP      = N.OPERATION_GROUP(+)
                        AND A.SCM_SITE_ID          = N.SCM_SITE_ID(+)
                        AND A.ITEM_ID              = N.ITEM_ID(+)
                        AND A.OPERATION_ID         = N.OPERATION_ID(+)
                        AND A.LINE_ID              = N.LINE_ID(+)
                        AND A.MEASURE              = N.MEASURE(+)
                        AND A.YYYYMMDD             = N.YYYYMMDD(+)
                        AND A.ORIGIN_DIVISION_ID   = N.ORIGIN_DIVISION_ID(+)
                        AND A.ELECTRODE_TYPE       = N.ELECTRODE_TYPE(+)
                        AND A.YYYYMMDD             = O.BASIS_YYYYMMDD
                        AND A.SCM_SITE_ID          = IB.SCM_SITE_ID(+)   /* AJS 20261007 속도 */
                        AND A.ITEM_ID              = IC.ITEM_ID(+)   /* AJS 20261007 속도 */
                        AND A.LINE_ID IS NOT NULL
                        AND A.LINE_ID <> '*'
                   )  A
             WHERE 1 = 1;

            /* FILTER BEGIN */
            IF P_DIVISION_ID = 'EE' THEN

                DELETE FROM GT_0017_RAW
                 WHERE ORIGIN_DIVISION_ID NOT IN ('40', '81', '82');

            ELSIF P_DIVISION_ID = 'EE_UC' THEN

                DELETE FROM GT_0017_RAW
                 WHERE ORIGIN_DIVISION_ID <> '81_UC';

            ELSE

                DELETE FROM GT_0017_RAW
                 WHERE DIVISION_ID <> P_DIVISION_ID;

            END IF;

--          IF TRIM(P_SCM_SITE_ID) IS NOT NULL THEN                                                           --  2026.10.07 AJS
            IF TRIM(P_SCM_SITE_ID) IS NOT NULL AND UPPER(TRIM(P_SCM_SITE_ID)) <> 'ALL' THEN                   --  2026.10.07 AJS

                DELETE FROM GT_0017_RAW
                 WHERE SCM_SITE_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ',')));

            END IF;

            IF TRIM(P_MODEL_ID) IS NOT NULL THEN

                DELETE FROM GT_0017_RAW
                 WHERE MODEL_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_MODEL_ID, ',')));

            END IF;

            IF TRIM(P_ITEM_ID) IS NOT NULL OR TRIM(P_NICK_NAME) IS NOT NULL THEN

                DELETE FROM GT_0017_RAW
                 WHERE ITEM_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME)));

            END IF;

--          IF TRIM(P_ELECTRODE_TYPE) IS NOT NULL THEN                                                        --  2026.10.07 AJS
            IF TRIM(P_ELECTRODE_TYPE) IS NOT NULL AND UPPER(TRIM(P_ELECTRODE_TYPE)) <> 'ALL' THEN             --  2026.10.07 AJS

                DELETE FROM GT_0017_RAW
                 WHERE ELECTRODE_TYPE NOT IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ',')));

            END IF;

--          IF TRIM(P_LINE_ID) IS NOT NULL THEN                                                               --  2026.10.07 AJS
            IF TRIM(P_LINE_ID) IS NOT NULL AND UPPER(TRIM(P_LINE_ID)) <> 'ALL' THEN                           --  2026.10.07 AJS

                DELETE FROM GT_0017_RAW
                 WHERE LINE_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_LINE_ID, ',')));

            END IF;
            /* FILTER END */

            /*======================================================================
             * MEASURE = ONHAND_EOH의 경우
             *====================================================================*/
            UPDATE GT_0017_RAW A
               SET A.WEEK_YN = 'Y'
             WHERE 1 = 1
               AND A.MEASURE     = 'ONHAND_EOH'
               AND A.VERSION_IDX = TO_CHAR(V_CURR_CNT)
               AND EXISTS (SELECT 1
                             FROM ( SELECT MAX(BASIS_YYYYMMDD)  AS YYYYMMDD
                                      FROM SCM_SYS_CALENDAR_M
                                     WHERE BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
                                       AND BASIS_YYYYMMDD <= V_TO_PERIOD    /* 마지막 구간 오류 발생으로 1개월 더함 */
                                     GROUP BY ISO_WEEK
                                            , PARTIAL_WEEK_NAME
                                  )  XA
                            WHERE XA.YYYYMMDD = SUBSTR(A.YYYYMMDD, -8));

            UPDATE GT_0017_RAW A
               SET A.MONTH_YN = 'Y'
             WHERE 1 = 1
               AND A.MEASURE     = 'ONHAND_EOH'
               AND A.VERSION_IDX = TO_CHAR(V_CURR_CNT)
               AND EXISTS (SELECT 1
                             FROM ( SELECT MAX(BASIS_YYYYMMDD)  AS YYYYMMDD
                                      FROM SCM_SYS_CALENDAR_M
                                     WHERE BASIS_YYYYMMDD >= V_FROM_YYYYMMDD
                                       AND BASIS_YYYYMMDD <= V_TO_PERIOD    /* 마지막 구간 오류 발생으로 1개월 더함 */
                                     GROUP BY BASIS_YYYYMM
                                  )  XA
                            WHERE XA.YYYYMMDD = SUBSTR(A.YYYYMMDD, -8));

            /* MEASURE => PROD_PLAN_ENGINE(B) 기준으로 PROD_PLAN_AMEND(A) 값 맞춤 20220914 by 신재욱책임님
             *
             * ★AS-IS 결함 : 갱신 대상은 MEASURE = 'PROD_PLAN_AMEND' 인 행인데
             *   짝을 찾는 조건에 A.MEASURE = B.MEASURE 가 있고 B 는 MEASURE = 'PROD_PLAN_ENGINE' 이므로
             *   두 값이 같아질 수 없어 AS-IS 에서도 갱신 건수가 언제나 0 이다.
             *   결과가 달라지지 않도록 조건을 그대로 두고 옮긴다. */
            UPDATE GT_0017_RAW A
               SET A.QTY = ( SELECT SUM(B.QTY)
                               FROM GT_0017_RAW B
                              WHERE B.KEY_IDX             = A.KEY_IDX
                                AND B.DIVISION_ID         = A.DIVISION_ID
                                AND B.OPERATION_GROUP     = A.OPERATION_GROUP
                                AND B.SCM_SITE_ID         = A.SCM_SITE_ID
                                AND B.LINE_ID             = A.LINE_ID
                                AND B.CELL_NICKNAME       = A.CELL_NICKNAME
                                AND B.PRODUCT_LEVEL1      = A.PRODUCT_LEVEL1
                                AND B.PRODUCT_LEVEL2      = A.PRODUCT_LEVEL2
                                AND B.PRODUCT_LEVEL3      = A.PRODUCT_LEVEL3
                                AND B.MODEL_ID            = A.MODEL_ID
                                AND B.ITEM_ID             = A.ITEM_ID
                                AND B.MEASURE             = A.MEASURE   /* chaan */
                                AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                AND B.FROM_YYYYMMDD       = A.FROM_YYYYMMDD
                                AND B.TO_YYYYMMDD         = A.TO_YYYYMMDD
                                AND B.YYYYMMDD            = A.YYYYMMDD
                                AND B.MEASURE             = 'PROD_PLAN_ENGINE'
                                AND B.YYYYMM             <= V_CURR_YYYYMM )   /* 당월까지 수량 일치시킴 */
             WHERE A.MEASURE = 'PROD_PLAN_AMEND'
               AND EXISTS (SELECT 1
                             FROM GT_0017_RAW B
                            WHERE B.KEY_IDX             = A.KEY_IDX
                              AND B.DIVISION_ID         = A.DIVISION_ID
                              AND B.OPERATION_GROUP     = A.OPERATION_GROUP
                              AND B.SCM_SITE_ID         = A.SCM_SITE_ID
                              AND B.LINE_ID             = A.LINE_ID
                              AND B.CELL_NICKNAME       = A.CELL_NICKNAME
                              AND B.PRODUCT_LEVEL1      = A.PRODUCT_LEVEL1
                              AND B.PRODUCT_LEVEL2      = A.PRODUCT_LEVEL2
                              AND B.PRODUCT_LEVEL3      = A.PRODUCT_LEVEL3
                              AND B.MODEL_ID            = A.MODEL_ID
                              AND B.ITEM_ID             = A.ITEM_ID
                              AND B.MEASURE             = A.MEASURE   /* chaan */
                              AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                              AND B.FROM_YYYYMMDD       = A.FROM_YYYYMMDD
                              AND B.TO_YYYYMMDD         = A.TO_YYYYMMDD
                              AND B.YYYYMMDD            = A.YYYYMMDD
                              AND B.MEASURE             = 'PROD_PLAN_ENGINE'
                              AND B.YYYYMM             <= V_CURR_YYYYMM);

        END LOOP;


        /*==========================================================================
         * GAP
         *   AS-IS 는 Prod Plan(Amend) 의 1 회차(#..._RAW_PLAN_1)와 2 회차(#..._RAW_PLAN_2)를
         *   따로 담아 서로 외부조인한다. 두 벌을 그대로 인라인 뷰로 옮긴다.
         *
         *   ★측정값 이름 : AS-IS 는 첫 번째를 'GAP', 두 번째를 'Gap' 으로 넣는다.
         *     MSSQL 은 묶을 때 대소문자를 가리지 않아 두 행이 한 묶음이 되고
         *     묶음의 이름은 행마다 'GAP' 또는 'Gap' 으로 섞여 나온다(정해져 있지 않다).
         *     Oracle 은 갈리므로 그대로 두면 Gap 행이 두 줄로 나뉜다.
         *     그래서 두 곳 모두 'Gap' 으로 넣어 AS-IS 와 같은 행 구성을 만든다.
         *     실측(2026-09-26) : 'Gap' 으로 맞추면 사업부 82 Pack 425 행 · Cell 260 행으로
         *     AS-IS 와 같고, 나누면 Cell 이 306 행으로 늘어난다.
         *========================================================================*/
        IF P_GAP = 'Y' THEN

            INSERT INTO GT_0017_RAW
            (
                KEY_IDX
              , DIVISION_ID
              , DIVISION_NAME
              , OPERATION_GROUP
              , OPERATION_GROUP_NAME
              , SCM_SITE_ID
              , SCM_SITE_DESCRIPTION
              , LINE_ID
              , CELL_NICKNAME
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MODEL_ID
              , ITEM_ID
              , NICK_NAME
              , MEASURE
              , MEASURE_NAME
              , USER_SORT_ORDER_NO
              , UOM
              , CELL_CF
              , PLAN_START_YYYYMMDD
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
              , WEEK_YN
              , MONTH_YN
              , VERSION_NO
              , VERSION_IDX
            )
            SELECT A.KEY_IDX
                 , A.DIVISION_ID
                 , A.DIVISION_NAME
                 , A.OPERATION_GROUP
                 , A.OPERATION_GROUP_NAME
                 , A.SCM_SITE_ID
                 , ( SELECT SA.SITE_DESCRIPTION
                       FROM ( SELECT X.SITE_DESCRIPTION
                                FROM SCM_MST_SITE X
                               WHERE X.SCM_SITE_ID = A.SCM_SITE_ID
                            )  SA
                      WHERE ROWNUM = 1 )                             AS SCM_SITE_DESCRIPTION
                 , A.LINE_ID
                 , A.CELL_NICKNAME
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , 'GAP'                                             AS MEASURE
                 , 'Gap'                                             AS MEASURE_NAME
                 , A.USER_SORT_ORDER_NO
                 , A.UOM
                 , A.CELL_CF
                 , '99991231'                                        AS PLAN_START_YYYYMMDD
                 , NULL                                              AS FROM_YYYYMMDD
                 , NULL                                              AS TO_YYYYMMDD
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
                 , (NVL(A.QTY, 0.0) - NVL(B.QTY, 0.0))               AS QTY
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.WEEK_YN
                 , A.MONTH_YN
                 , '-'                                               AS VERSION_NO
                 , '3'                                               AS VERSION_IDX
              FROM ( SELECT *
                       FROM GT_0017_RAW
                      WHERE 1 = 1
                        AND MEASURE_NAME = 'Prod Plan(Amend)'
                        AND VERSION_IDX  = '2'
                   )  A
                 , ( SELECT *
                       FROM GT_0017_RAW
                      WHERE 1 = 1
                        AND MEASURE_NAME = 'Prod Plan(Amend)'
                        AND VERSION_IDX  = '1'
                   )  B
             WHERE A.KEY_IDX            = B.KEY_IDX(+)
               AND A.DIVISION_ID        = B.DIVISION_ID(+)
               AND A.OPERATION_GROUP    = B.OPERATION_GROUP(+)
               AND A.MEASURE            = B.MEASURE(+)
               AND A.MEASURE_NAME       = B.MEASURE_NAME(+)
               AND A.FROM_YYYYMMDD      = B.FROM_YYYYMMDD(+)
               AND A.TO_YYYYMMDD        = B.TO_YYYYMMDD(+)
               AND A.SCM_SITE_ID        = B.SCM_SITE_ID(+)
               AND A.LINE_ID            = B.LINE_ID(+)
               AND A.CELL_NICKNAME      = B.CELL_NICKNAME(+)
               AND A.PRODUCT_LEVEL1     = B.PRODUCT_LEVEL1(+)
               AND A.PRODUCT_LEVEL2     = B.PRODUCT_LEVEL2(+)
               AND A.PRODUCT_LEVEL3     = B.PRODUCT_LEVEL3(+)
               AND A.MODEL_ID           = B.MODEL_ID(+)
               AND A.ITEM_ID            = B.ITEM_ID(+)
               AND A.YYYYMMDD           = B.YYYYMMDD(+)
               AND A.ISO_WEEK           = B.ISO_WEEK(+)
               AND A.USER_SORT_ORDER_NO = B.USER_SORT_ORDER_NO(+);

            INSERT INTO GT_0017_RAW
            (
                KEY_IDX
              , DIVISION_ID
              , DIVISION_NAME
              , OPERATION_GROUP
              , OPERATION_GROUP_NAME
              , SCM_SITE_ID
              , SCM_SITE_DESCRIPTION
              , LINE_ID
              , CELL_NICKNAME
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MODEL_ID
              , ITEM_ID
              , NICK_NAME
              , MEASURE
              , MEASURE_NAME
              , USER_SORT_ORDER_NO
              , UOM
              , CELL_CF
              , PLAN_START_YYYYMMDD
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , ISO_WEEK
              , QTY
              , ORIGIN_DIVISION_ID
              , ELECTRODE_TYPE
              , WEEK_YN
              , MONTH_YN
              , VERSION_NO
              , VERSION_IDX
            )
            SELECT A.KEY_IDX
                 , A.DIVISION_ID
                 , A.DIVISION_NAME
                 , A.OPERATION_GROUP
                 , A.OPERATION_GROUP_NAME
                 , A.SCM_SITE_ID
                 , ( SELECT SA.SITE_DESCRIPTION
                       FROM ( SELECT X.SITE_DESCRIPTION
                                FROM SCM_MST_SITE X
                               WHERE X.SCM_SITE_ID = A.SCM_SITE_ID
                            )  SA
                      WHERE ROWNUM = 1 )                             AS SCM_SITE_DESCRIPTION
                 , A.LINE_ID
                 , A.CELL_NICKNAME
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.MODEL_ID
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , 'GAP'                                             AS MEASURE
                 , 'Gap'                                             AS MEASURE_NAME
                 , A.USER_SORT_ORDER_NO
                 , A.UOM
                 , A.CELL_CF
                 , '99991231'                                        AS PLAN_START_YYYYMMDD
                 , NULL                                              AS FROM_YYYYMMDD
                 , NULL                                              AS TO_YYYYMMDD
                 , A.YYYYMMDD
                 , A.YYYYMM
                 , A.ISO_WEEK
                 , (NVL(B.QTY, 0.0) - NVL(A.QTY, 0.0))               AS QTY
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.WEEK_YN
                 , A.MONTH_YN
                 , '-'                                               AS VERSION_NO
                 , '3'                                               AS VERSION_IDX
              FROM ( SELECT *
                       FROM GT_0017_RAW
                      WHERE 1 = 1
                        AND MEASURE_NAME = 'Prod Plan(Amend)'
                        AND VERSION_IDX  = '1'
                   )  A
                 , ( SELECT *
                       FROM GT_0017_RAW
                      WHERE 1 = 1
                        AND MEASURE_NAME = 'Prod Plan(Amend)'
                        AND VERSION_IDX  = '2'
                   )  B
             WHERE A.KEY_IDX            = B.KEY_IDX(+)
               AND A.DIVISION_ID        = B.DIVISION_ID(+)
               AND A.OPERATION_GROUP    = B.OPERATION_GROUP(+)
               AND A.MEASURE            = B.MEASURE(+)
               AND A.MEASURE_NAME       = B.MEASURE_NAME(+)
               AND A.FROM_YYYYMMDD      = B.FROM_YYYYMMDD(+)
               AND A.TO_YYYYMMDD        = B.TO_YYYYMMDD(+)
               AND A.SCM_SITE_ID        = B.SCM_SITE_ID(+)
               AND A.LINE_ID            = B.LINE_ID(+)
               AND A.CELL_NICKNAME      = B.CELL_NICKNAME(+)
               AND A.PRODUCT_LEVEL1     = B.PRODUCT_LEVEL1(+)
               AND A.PRODUCT_LEVEL2     = B.PRODUCT_LEVEL2(+)
               AND A.PRODUCT_LEVEL3     = B.PRODUCT_LEVEL3(+)
               AND A.MODEL_ID           = B.MODEL_ID(+)
               AND A.ITEM_ID            = B.ITEM_ID(+)
               AND A.YYYYMMDD           = B.YYYYMMDD(+)
               AND A.ISO_WEEK           = B.ISO_WEEK(+)
               AND A.USER_SORT_ORDER_NO = B.USER_SORT_ORDER_NO(+);

        END IF;

        /*==========================================================================
         * 단위 환산
         *   AS-IS 는 #..._RAW_ALL (RAW x UOM) 을 만든 뒤 환산해 #..._RAW_ALL_UOM 에 담는다.
         *   #..._RAW_ALL 은 한 번만 읽히므로 한 문장으로 합친다.
         *========================================================================*/
        INSERT INTO GT_0017_RAW_ALL_UOM
        (
            KEY_IDX
          , DIVISION_ID
          , DIVISION_NAME
          , OPERATION_GROUP
          , OPERATION_GROUP_NAME
          , SCM_SITE_ID
          , SCM_SITE_DESCRIPTION
          , LINE_ID
          , CELL_NICKNAME
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , MODEL_ID
          , ITEM_ID
          , NICK_NAME
          , MEASURE
          , MEASURE_NAME
          , USER_SORT_ORDER_NO
          , UOM
          , CELL_CF
          , PLAN_START_YYYYMMDD
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
          , QTY
          , ORIGIN_DIVISION_ID
          , ELECTRODE_TYPE
          , WEEK_YN
          , MONTH_YN
          , VERSION_NO
          , VERSION_IDX
        )
        SELECT A.KEY_IDX
             , A.DIVISION_ID
             , A.DIVISION_NAME
             , A.OPERATION_GROUP
             , A.OPERATION_GROUP_NAME
             , A.SCM_SITE_ID
             , A.SCM_SITE_DESCRIPTION
             , A.LINE_ID
             , A.CELL_NICKNAME
             , A.PRODUCT_LEVEL1
             , A.PRODUCT_LEVEL2
             , A.PRODUCT_LEVEL3
             , A.MODEL_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.MEASURE
             , A.MEASURE_NAME
             , A.USER_SORT_ORDER_NO
             , U.UOM
             , T.CELL_CF
             , A.PLAN_START_YYYYMMDD
             , A.FROM_YYYYMMDD
             , A.TO_YYYYMMDD
             , A.YYYYMMDD
             , A.YYYYMM
             , A.ISO_WEEK
             , CASE
                 WHEN T.CELL_CF IS NOT NULL THEN A.QTY
                 WHEN TT.UOM = 'M'          THEN A.QTY * TT.CELL_CF
                 ELSE A.QTY / CASE WHEN NVL(TE.CELL_CF, 0) = 0 THEN 1.0 ELSE TE.CELL_CF END
               END                                                      AS QTY
             , A.ORIGIN_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.WEEK_YN
             , A.MONTH_YN
             , A.VERSION_NO
             , A.VERSION_IDX
          FROM GT_0017_RAW    A
             , GT_0017_UOM    U        /* UOM 갯수만큼 행 복제를 위해 풀조인함 */
             , ( SELECT ITEM_ID
                      , UNIT                                AS UOM
                      , CAST(CELL_CF AS NUMBER(23,10))      AS CELL_CF
                   FROM SCP_MST_ITEM_CELL_CF
                  WHERE 1 = 1
               )  T
             , ( SELECT ITEM_ID
                      , UNIT                                AS UOM
                      , CAST(CELL_CF AS NUMBER(23,10))      AS CELL_CF
                   FROM SCP_MST_ITEM_CELL_CF
                  WHERE 1 = 1
               )  TT
             , ( SELECT XA.DIVISION_ID
                      , XA.ITEM_ID
                      , XA.VALUE  AS CELL_CF
                   FROM ( SELECT C.DIVISION_ID
                               , C.ITEM_ID
                               , C.VALUE
                               , ROW_NUMBER() OVER (PARTITION BY C.DIVISION_ID
                                                               , C.ITEM_ID
                                                       ORDER BY C.VALUE DESC)  AS RN
                            FROM SCM_MST_ITEM_CONV_CALC_SN C
                           WHERE 1 = 1
                             AND C.CATEGORY     = 'Pancake (cell/m)'   /* 고정 */
                             AND C.VERSION_TYPE = 'MASS'               /* 고정 */
                             AND C.MAX_VER_FLAG = 'Y'                  /* 고정 */
                        )  XA
                  WHERE 1 = 1
                    AND XA.RN = 1
               )  TE
         WHERE A.ITEM_ID            = T.ITEM_ID(+)
           AND U.UOM                = T.UOM(+)      /* CELL_CF 가 NULL 이 아닌 경우로 원래 UNIT 판별 */
           AND A.ITEM_ID            = TT.ITEM_ID(+) /* ITEM_ID와 UOM 로 조인하는 경우 CELL_CF 가 NULL 일 수 있으므로 CELL_CF 를 다시 검색하기위한 조인 */
           AND A.ORIGIN_DIVISION_ID = TE.DIVISION_ID(+)  /* EA->M 변환시 환산로직 */
           AND A.ITEM_ID            = TE.ITEM_ID(+);

        /*==========================================================================
         * pivot 전 사용자 지정 컬럼별로 합산 - 컬럼 변수셋팅
         *========================================================================*/
        FOR R IN ( SELECT COLUMN_NAME
                     FROM GT_0017_COLUMN
                    ORDER BY USER_SORT_ORDER_NO
                 )
        LOOP
            V_USER_COLS := V_USER_COLS || ', ' || R.COLUMN_NAME;
        END LOOP;

        V_USER_COLS       := SUBSTR(V_USER_COLS, 3) || ', MEASURE';   /* UI에서 MEASURE 필수 컬럼 */
        V_USER_COLS       := REPLACE(V_USER_COLS, 'VERSION_NO', 'USER_SORT_ORDER_NO, VERSION_IDX, VERSION_NO');

        /* ★같은 칸 이름이 두 번 들어가면 묶을 수도 담을 수도 없으므로 중복을 뺀다.
         *   AS-IS 는 MEASURE 를 보이지 않는 칸으로 두어 목록에 한 번만 들어가므로
         *   중복을 뺀 목록이 곧 AS-IS 목록이다.
         *   (기준 데이터베이스는 이관 과정에서 MEASURE 가 보이는 칸으로 바뀌어 있어 두 번 들어간다.
         *    칸 설정을 AS-IS 와 같게 되돌리는 조치문을 따로 낸다.) */
        DECLARE
            V_TOKEN     VARCHAR2(200);
            V_IDX       PLS_INTEGER := 1;
        BEGIN
            LOOP
                V_TOKEN := TRIM(REGEXP_SUBSTR(V_USER_COLS, '[^,]+', 1, V_IDX));
                EXIT WHEN V_TOKEN IS NULL;

                IF INSTR(',' || REPLACE(V_USER_COLS_UNIQ, ' ', '') || ',', ',' || V_TOKEN || ',') = 0 THEN
                    IF V_USER_COLS_UNIQ IS NULL THEN
                        V_USER_COLS_UNIQ := V_TOKEN;
                    ELSE
                        V_USER_COLS_UNIQ := V_USER_COLS_UNIQ || ', ' || V_TOKEN;
                    END IF;
                END IF;

                V_IDX := V_IDX + 1;
            END LOOP;
        END;

        V_USER_COLS       := V_USER_COLS_UNIQ;
        V_USER_COLS_ORDER := REPLACE(V_USER_COLS, ', UOM', ', UOM DESC');

        V_GAP_USER_COLS   := 'A.' || REPLACE(V_USER_COLS, ', ', ', A.');
        V_GAP_USER_KEYS   := REPLACE(V_GAP_USER_COLS, ', A.', ' || '';'' || A.');

        /*==========================================================================
         * PIVOT COLUMNS
         *========================================================================*/
        /* 정렬 보조 키(BLK) : AS-IS 는 SORT_ORDER_NO 가 같은 칸이 여럿이어서
         *   (같은 주의 주계 칸과 ISO 주계 칸은 값이 같다) 순서가 정해지지 않는다.
         *   MSSQL 은 UNION ALL 을 적은 차례대로 내보내므로 그 차례를 두 번째 키로 둔다. */
        FOR R IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK              AS YYYYMMDD
                                 , A.BASIS_START_DATE || '21'                        AS SORT_ORDER_NO
                                 , 1                                                 AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.ISO_WEEK
                                    , A.BASIS_START_DATE
                             UNION ALL
                            SELECT 'W_' || A.ISO_YYYYMM || A.ISO_WEEK || '_ISO'      AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '21'                   AS SORT_ORDER_NO
                                 , 2                                                 AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.ISO_YYYYMM
                                    , A.ISO_WEEK
                             UNION ALL
                            SELECT 'M_' || A.BASIS_YYYYMM                            AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '01'                   AS SORT_ORDER_NO
                                 , 3                                                 AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.MONTH_NAME
                             UNION ALL
                            SELECT 'D_' || A.BASIS_YYYYMMDD                          AS YYYYMMDD
                                 , A.BASIS_YYYYMMDD || '31'                          AS SORT_ORDER_NO
                                 , 4                                                 AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMMDD
                          )  A
                    ORDER BY SORT_ORDER_NO
                           , BLK
                 )
        LOOP

            /* 결과 칸 이름 목록과, 누계 조회에서 어느 자료의 값을 쓸지 고른 목록
             *   AS-IS 는 일 누계 자료를 만든 뒤 주 칸은 주 누계로, 월 칸은 월 누계로 덮어쓴다.
             *   덮어쓰기는 키가 맞을 때만 일어나므로 키가 없으면 일 누계 값이 남는다.
             *   외부조인 + NVL 로 같은 결과를 낸다. */
            V_PIVOT_COLS := V_PIVOT_COLS || CHR(10) || '     , A.' || R.YYYYMMDD;

            IF SUBSTR(R.YYYYMMDD, 1, 2) = 'D_' THEN
                V_ACC_SEL_COLS := V_ACC_SEL_COLS || CHR(10) || '     , DA.' || R.YYYYMMDD || '  AS ' || R.YYYYMMDD;
            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN
                V_ACC_SEL_COLS := V_ACC_SEL_COLS || CHR(10) || '     , NVL(WA.' || R.YYYYMMDD || ', DA.' || R.YYYYMMDD || ')  AS ' || R.YYYYMMDD;
            ELSE
                V_ACC_SEL_COLS := V_ACC_SEL_COLS || CHR(10) || '     , NVL(MA.' || R.YYYYMMDD || ', DA.' || R.YYYYMMDD || ')  AS ' || R.YYYYMMDD;
            END IF;

            /* 구간 수량 */
            IF SUBSTR(R.YYYYMMDD, 1, 2) = 'M_' THEN

                DBMS_LOB.APPEND(V_SUM_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_DAY_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_WEEK_COLS, TO_CLOB(CHR(10) || '     , CAST(0 AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_MONTH_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));

            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN

                IF SUBSTR(R.YYYYMMDD, -4) <> '_ISO' THEN
                    DBMS_LOB.APPEND(V_SUM_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                    DBMS_LOB.APPEND(V_ACC_DAY_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                ELSE
                    DBMS_LOB.APPEND(V_SUM_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN SUBSTR(ISO_WEEK, 1, 2) || SUBSTR(ISO_WEEK, 5, 2) = SUBSTR(''' || R.YYYYMMDD || ''', 5, 2) || SUBSTR(''' || R.YYYYMMDD || ''', 9, 2) THEN QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                    DBMS_LOB.APPEND(V_ACC_DAY_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN SUBSTR(ISO_WEEK, 1, 2) || SUBSTR(ISO_WEEK, 5, 2) = SUBSTR(''' || R.YYYYMMDD || ''', 5, 2) || SUBSTR(''' || R.YYYYMMDD || ''', 9, 2) THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                END IF;

                DBMS_LOB.APPEND(V_ACC_WEEK_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', 3, 8) THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_MONTH_COLS, TO_CLOB(CHR(10) || '     , CAST(0 AS NUMBER(23,10))  AS ' || R.YYYYMMDD));

            ELSE    /* D_ */

                DBMS_LOB.APPEND(V_SUM_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                /* 누계 yyyymmdd 컬럼은 'D_20230101' 형태가 아닌 '20230101' 형태이므로 RIGHT(YYYYMMDD, 8) 로 비교한다!!! */
                DBMS_LOB.APPEND(V_ACC_DAY_COLS, TO_CLOB(CHR(10) || '     , CAST(NVL(SUM(CASE WHEN YYYYMMDD = ''' || SUBSTR(R.YYYYMMDD, -8) || ''' THEN ACC_QTY END), 0) AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_WEEK_COLS, TO_CLOB(CHR(10) || '     , CAST(0 AS NUMBER(23,10))  AS ' || R.YYYYMMDD));
                DBMS_LOB.APPEND(V_ACC_MONTH_COLS, TO_CLOB(CHR(10) || '     , CAST(0 AS NUMBER(23,10))  AS ' || R.YYYYMMDD));

            END IF;

        END LOOP;


        /*==========================================================================
         * GAP 누계
         *   AS-IS 는 GAP 여부와 상관없이 #..._Final_RAW 를 만들지만
         *   그 자료를 읽는 곳이 GAP 누계 산출뿐이므로 GAP 일 때만 담는다.
         *========================================================================*/
        IF P_GAP = 'Y' THEN

            /* #..._Final_RAW */
            DBMS_LOB.TRIM(V_SQL, 0);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'INSERT INTO GT_0017_FINAL_RAW (' || V_USER_COLS || ', YYYYMM, ISO_WEEK, YYYYMMDD, QTY)' || CHR(10)
             || 'SELECT ' || V_USER_COLS || CHR(10)
             || '     , YYYYMM' || CHR(10)
             || '     , ISO_WEEK' || CHR(10)
             || '     , YYYYMMDD' || CHR(10)
             || '     , SUM(QTY)  AS QTY' || CHR(10)
             || '  FROM GT_0017_RAW_ALL_UOM' || CHR(10)
             || ' GROUP BY ' || V_USER_COLS || CHR(10)
             || '        , YYYYMM' || CHR(10)
             || '        , ISO_WEEK' || CHR(10)
             || '        , YYYYMMDD'));
            EXECUTE IMMEDIATE V_SQL;

            /* #..._Final_RAW_GAP_DAY
             *   AS-IS 는 기간의 모든 날짜 x 키 조합을 만든 뒤(#..._GAP_DAY_KEYS)
             *   GAP 수량을 외부조인해 없는 날은 0 으로 채운다. 한 문장으로 합친다. */
            DBMS_LOB.TRIM(V_SQL, 0);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'INSERT INTO GT_0017_GAP_DAY (' || V_USER_COLS || ', KEY_IDX, YYYYMM, ISO_WEEK, YYYYMMDD, QTY)' || CHR(10)
             || 'SELECT ' || V_GAP_USER_COLS || CHR(10)
             || '     , A.KEY_IDX' || CHR(10)
             || '     , B.YYYYMM' || CHR(10)
             || '     , B.ISO_WEEK' || CHR(10)
             || '     , B.YYYYMMDD' || CHR(10)
             || '     , NVL(C.QTY, 0)  AS QTY' || CHR(10)
             || '  FROM ( SELECT DISTINCT ' || V_USER_COLS || CHR(10)
             || '              , ' || V_GAP_USER_KEYS || '  AS KEY_IDX' || CHR(10)
             || '           FROM GT_0017_FINAL_RAW A' || CHR(10)
             || '          WHERE 1 = 1' || CHR(10)
             || '            AND A.MEASURE = ''GAP''' || CHR(10)
             || '       )  A' || CHR(10)
             || '     , ( SELECT DISTINCT XA.BASIS_YYYYMM                    AS YYYYMM' || CHR(10)
             || '              , XA.BASIS_YYYYMM || XA.ISO_WEEK              AS ISO_WEEK' || CHR(10)
             || '              , XA.BASIS_YYYYMMDD                           AS YYYYMMDD' || CHR(10)
             || '           FROM SCM_SYS_CALENDAR_M XA' || CHR(10)
             || '          WHERE XA.BASIS_YYYYMMDD BETWEEN ''' || P_FROM_YYYYMMDD || ''' AND ''' || P_TO_YYYYMMDD || '''' || CHR(10)
             || '       )  B' || CHR(10)
             || '     , ( SELECT ' || V_GAP_USER_KEYS || '  AS KEY_IDX' || CHR(10)
             || '              , A.YYYYMM' || CHR(10)
             || '              , A.YYYYMM || SUBSTR(A.ISO_WEEK, -2)          AS ISO_WEEK' || CHR(10)
             || '              , SUBSTR(A.YYYYMMDD, -8)                      AS YYYYMMDD' || CHR(10)
             || '              , A.QTY' || CHR(10)
             || '           FROM GT_0017_FINAL_RAW A' || CHR(10)
             || '          WHERE 1 = 1' || CHR(10)
             || '            AND A.MEASURE = ''GAP''' || CHR(10)
             || '       )  C' || CHR(10)
             || ' WHERE A.KEY_IDX  = C.KEY_IDX(+)' || CHR(10)
             || '   AND B.YYYYMM   = C.YYYYMM(+)' || CHR(10)
             || '   AND B.ISO_WEEK = C.ISO_WEEK(+)' || CHR(10)
             || '   AND B.YYYYMMDD = C.YYYYMMDD(+)'));
            EXECUTE IMMEDIATE V_SQL;

            /* #..._Final_RAW_GAP_WEEK */
            DBMS_LOB.TRIM(V_SQL, 0);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'INSERT INTO GT_0017_GAP_WEEK (' || V_USER_COLS || ', KEY_IDX, YYYYMM, ISO_WEEK, QTY)' || CHR(10)
             || 'SELECT ' || V_USER_COLS || CHR(10)
             || '     , KEY_IDX' || CHR(10)
             || '     , YYYYMM' || CHR(10)
             || '     , ISO_WEEK' || CHR(10)
             || '     , SUM(QTY)  AS QTY' || CHR(10)
             || '  FROM GT_0017_GAP_DAY' || CHR(10)
             || ' GROUP BY ' || V_USER_COLS || CHR(10)
             || '        , KEY_IDX' || CHR(10)
             || '        , YYYYMM' || CHR(10)
             || '        , ISO_WEEK'));
            EXECUTE IMMEDIATE V_SQL;

            /* #..._Final_RAW_GAP_MONTH */
            DBMS_LOB.TRIM(V_SQL, 0);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'INSERT INTO GT_0017_GAP_MONTH (' || V_USER_COLS || ', KEY_IDX, YYYYMM, QTY)' || CHR(10)
             || 'SELECT ' || V_USER_COLS || CHR(10)
             || '     , KEY_IDX' || CHR(10)
             || '     , YYYYMM' || CHR(10)
             || '     , SUM(QTY)  AS QTY' || CHR(10)
             || '  FROM GT_0017_GAP_WEEK' || CHR(10)
             || ' GROUP BY ' || V_USER_COLS || CHR(10)
             || '        , KEY_IDX' || CHR(10)
             || '        , YYYYMM'));
            EXECUTE IMMEDIATE V_SQL;

        END IF;

        /*==========================================================================
         * 결과
         *   AS-IS #..._FIANL_SUM = 사용자 칸으로 묶은 구간 합계 + 키
         *   GAP 이면 누계(#..._Final_ACC_DAY)를 같은 칸 구성으로 덧붙인다.
         *========================================================================*/
        DBMS_LOB.TRIM(V_SQL, 0);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT * FROM (' || CHR(10)
         || 'SELECT ' || V_GAP_USER_COLS));
        DBMS_LOB.APPEND(V_SQL, V_PIVOT_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            CHR(10) || '     , ' || V_GAP_USER_KEYS || '  AS KEY_IDX' || CHR(10)
         || '  FROM ( SELECT ' || V_USER_COLS));
        DBMS_LOB.APPEND(V_SQL, V_SUM_COLS);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            CHR(10) || '           FROM GT_0017_RAW_ALL_UOM' || CHR(10)
         || '          GROUP BY ' || V_USER_COLS || CHR(10)
         || '       )  A'));

        IF P_GAP = 'Y' THEN

            /* 누계 : 사용자 칸 가운데 측정값 이름만 Gap(Acc) 로 바꾼다 */
            DECLARE
                V_TOKEN     VARCHAR2(200);
                V_IDX       PLS_INTEGER := 1;
                V_ACC_COLS  VARCHAR2(4000);
                V_ONE       VARCHAR2(400);
            BEGIN
                LOOP
                    V_TOKEN := TRIM(REGEXP_SUBSTR(V_USER_COLS, '[^,]+', 1, V_IDX));
                    EXIT WHEN V_TOKEN IS NULL;

                    IF V_TOKEN = 'MEASURE' THEN
                        V_ONE := '''GAP_ACC''  AS MEASURE';
                    ELSIF V_TOKEN = 'MEASURE_NAME' THEN
                        V_ONE := '''Gap(Acc)''  AS MEASURE_NAME';
                    ELSE
                        V_ONE := 'DA.' || V_TOKEN;
                    END IF;

                    IF V_ACC_COLS IS NULL THEN
                        V_ACC_COLS := V_ONE;
                    ELSE
                        V_ACC_COLS := V_ACC_COLS || CHR(10) || '     , ' || V_ONE;
                    END IF;

                    V_IDX := V_IDX + 1;
                END LOOP;

                DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                    CHR(10) || ' UNION ALL' || CHR(10)
                 || 'SELECT ' || V_ACC_COLS));
            END;

            DBMS_LOB.APPEND(V_SQL, V_ACC_SEL_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '     , DA.KEY_IDX' || CHR(10)
             || '  FROM ( SELECT ' || V_USER_COLS || CHR(10)
             || '              , KEY_IDX'));
            DBMS_LOB.APPEND(V_SQL, V_ACC_DAY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM ( SELECT ' || V_USER_COLS || CHR(10)
             || '                       , KEY_IDX' || CHR(10)
             || '                       , YYYYMM' || CHR(10)
             || '                       , ISO_WEEK' || CHR(10)
             || '                       , YYYYMMDD' || CHR(10)
             || '                       , SUM(QTY) OVER (PARTITION BY KEY_IDX ORDER BY YYYYMM, ISO_WEEK, YYYYMMDD)  AS ACC_QTY' || CHR(10)
             || '                    FROM GT_0017_GAP_DAY' || CHR(10)
             || '                )  IA' || CHR(10)
             || '          GROUP BY ' || V_USER_COLS || CHR(10)
             || '                 , KEY_IDX' || CHR(10)
             || '       )  DA' || CHR(10)
             || '     , ( SELECT KEY_IDX'));
            DBMS_LOB.APPEND(V_SQL, V_ACC_WEEK_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM ( SELECT ' || V_USER_COLS || CHR(10)
             || '                       , KEY_IDX' || CHR(10)
             || '                       , YYYYMM' || CHR(10)
             || '                       , ISO_WEEK' || CHR(10)
             || '                       , SUM(QTY) OVER (PARTITION BY KEY_IDX ORDER BY YYYYMM, ISO_WEEK)  AS ACC_QTY' || CHR(10)
             || '                    FROM GT_0017_GAP_WEEK' || CHR(10)
             || '                )  IA' || CHR(10)
             || '          GROUP BY ' || V_USER_COLS || CHR(10)
             || '                 , KEY_IDX' || CHR(10)
             || '       )  WA' || CHR(10)
             || '     , ( SELECT KEY_IDX'));
            DBMS_LOB.APPEND(V_SQL, V_ACC_MONTH_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM ( SELECT ' || V_USER_COLS || CHR(10)
             || '                       , KEY_IDX' || CHR(10)
             || '                       , YYYYMM' || CHR(10)
             || '                       , SUM(QTY) OVER (PARTITION BY KEY_IDX ORDER BY YYYYMM)  AS ACC_QTY' || CHR(10)
             || '                    FROM GT_0017_GAP_MONTH' || CHR(10)
             || '                )  IA' || CHR(10)
             || '          GROUP BY ' || V_USER_COLS || CHR(10)
             || '                 , KEY_IDX' || CHR(10)
             || '       )  MA' || CHR(10)
             || ' WHERE DA.KEY_IDX = WA.KEY_IDX(+)' || CHR(10)
             || '   AND DA.KEY_IDX = MA.KEY_IDX(+)'));

        END IF;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            CHR(10) || ')' || CHR(10)
         || ' ORDER BY ' || FN_ORDER_EXPR(V_USER_COLS_ORDER)));

        OPEN O_RC1 FOR V_SQL;

        DBMS_LOB.FREETEMPORARY(V_PIVOT_COLS);
        DBMS_LOB.FREETEMPORARY(V_ACC_SEL_COLS);
        DBMS_LOB.FREETEMPORARY(V_SUM_COLS);
        DBMS_LOB.FREETEMPORARY(V_ACC_DAY_COLS);
        DBMS_LOB.FREETEMPORARY(V_ACC_WEEK_COLS);
        DBMS_LOB.FREETEMPORARY(V_ACC_MONTH_COLS);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0017_GET_PRODUCTION_PLAN_MODEL_WATERFALL;


    /*******************************************************************************
     * P_SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL
     *   AS-IS SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL
     *   모델 화면에서 라인 상세를 펼칠 때 쓴다.
     *   조회 기간에 따라 칸 개수가 달라지는 마지막 피벗만 동적으로 둔다.
     *******************************************************************************/
    PROCEDURE P_SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_VERSION_NO            IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_ELECTRODE_TYPE        IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL,     TRUE);

        DELETE FROM GT_0017_LINE;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        /*==========================================================================
         * 데이타조회, 임시테이블에 저장
         *========================================================================*/
        INSERT INTO GT_0017_LINE
        (
            DIVISION_ID
          , OPERATION_GROUP
          , SCM_SITE_ID
          , LINE_ID
          , ITEM_ID
          , MEASURE
          , MEASURE_NAME
          , USER_SORT_ORDER_NO
          , OPERATION_ID
          , FROM_YYYYMMDD
          , VERSION_NO
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
          , QTY
          , DIVISION_NAME
          , OPERATION_GROUP_NAME
          , SCM_SITE_DESCRIPTION
          , NICK_NAME
          , ORIGIN_DIVISION_ID
          , ELECTRODE_TYPE
        )
        SELECT M.DIVISION_ID
             , M.OPERATION_GROUP
             , M.SCM_SITE_ID
             , M.LINE_ID
             , M.ITEM_ID
             , M.MEASURE
             , M.MEASURE_NAME
             , M.USER_SORT_ORDER_NO
             , M.OPERATION_ID
             , P_FROM_YYYYMMDD                              AS FROM_YYYYMMDD
             , P_VERSION_NO                                 AS VERSION_NO
             , 'D_' || M.YYYYMMDD                           AS YYYYMMDD
             , O.BASIS_YYYYMM                               AS YYYYMM
             , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK     AS ISO_WEEK
             , N.QTY
             , M.DIVISION_NAME
             , M.OPERATION_GROUP_NAME
             , M.SCM_SITE_DESCRIPTION
             , CASE WHEN M.NICK_NAME IS NULL OR M.NICK_NAME = ' ' THEN '-'
                    ELSE M.NICK_NAME END                    AS NICK_NAME
             , M.ORIGIN_DIVISION_ID
             , M.ELECTRODE_TYPE
          FROM ( SELECT C.DIVISION_ID
                      , C.VERSION_NO
                      , C.OPERATION_GROUP
                      , C.SCM_SITE_ID
                      , C.ITEM_ID
                      , C.LINE_ID
                      , C.OPERATION_ID
                      , A.COLUMN_NAME                           AS MEASURE
                      , A.COLUMN_LABEL_NAME                     AS MEASURE_NAME
                      , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO)   AS USER_SORT_ORDER_NO
                      , C.YYYYMMDD
                      , C.DIVISION_NAME
                      , C.OPERATION_GROUP_NAME
                      , C.SCM_SITE_DESCRIPTION
                      , C.NICK_NAME
                      , CASE WHEN TRIM(C.ORIGIN_DIVISION_ID) IS NULL THEN '-'
                             ELSE C.ORIGIN_DIVISION_ID END       AS ORIGIN_DIVISION_ID
                      , CASE WHEN TRIM(C.ELECTRODE_TYPE) IS NULL THEN '-'
                             ELSE C.ELECTRODE_TYPE END           AS ELECTRODE_TYPE
                   FROM SCM_MST_SHEET_MEASURE   A
                      , SCM_MST_TITLESET_USER   B
                      , ( SELECT DIVISION_ID
                               , VERSION_NO
                               , OPERATION_GROUP
                               , SCM_SITE_ID
                               , ITEM_ID
                               , LINE_ID
                               , OPERATION_ID
                               , MEASURE
                               , YYYYMMDD
                               , DIVISION_NAME
                               , OPERATION_GROUP_NAME
                               , SCM_SITE_DESCRIPTION
                               , NICK_NAME
                               , ORIGIN_DIVISION_ID
                               , ELECTRODE_TYPE
                            FROM SCP_ANL_PRODUCTION_PLAN_C
                           WHERE 1 = 1
                             AND YYYYMMDD        >= P_FROM_YYYYMMDD
                             AND YYYYMMDD        <= P_TO_YYYYMMDD
                             AND DIVISION_ID      = P_DIVISION_ID
                             AND OPERATION_GROUP  = P_OPERATION_GROUP
                             AND SCM_SITE_ID      = P_SCM_SITE_ID
                             AND ITEM_ID          = P_ITEM_ID
                             AND VERSION_NO       = P_VERSION_NO
                             AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
                                   OR P_ELECTRODE_TYPE = '-'
                                   OR ELECTRODE_TYPE = P_ELECTRODE_TYPE )
                           GROUP BY DIVISION_ID
                                  , VERSION_NO
                                  , OPERATION_GROUP
                                  , SCM_SITE_ID
                                  , ITEM_ID
                                  , LINE_ID
                                  , OPERATION_ID
                                  , MEASURE
                                  , YYYYMMDD
                                  , DIVISION_NAME
                                  , OPERATION_GROUP_NAME
                                  , SCM_SITE_DESCRIPTION
                                  , NICK_NAME
                                  , ORIGIN_DIVISION_ID
                                  , ELECTRODE_TYPE
                        )  C
                  WHERE B.PROGRAM_ID(+)  = A.PROGRAM_ID
                    AND B.SHEET_NAME(+)  = A.SHEET_NAME
                    AND B.COLUMN_NAME(+) = A.COLUMN_NAME
                    AND B.USER_ID(+)     = P_USER_ID
                    AND A.PROGRAM_ID     = P_PROGRAM_ID
                    AND A.SHEET_NAME     = P_SHEET_NAME
                    AND A.VALID_YN       = 'Y'
                    AND ( V_CNT_USR_MEASURE = 0
                          OR EXISTS (SELECT 1
                                       FROM SCM_MST_TITLESET_USER
                                      WHERE PROGRAM_ID  = P_PROGRAM_ID
                                        AND SHEET_NAME  = P_SHEET_NAME
                                        AND USER_ID     = P_USER_ID
                                        AND COLUMN_NAME = A.COLUMN_NAME) )
                  GROUP BY C.DIVISION_ID
                         , C.VERSION_NO
                         , C.OPERATION_GROUP
                         , C.SCM_SITE_ID
                         , C.ITEM_ID
                         , C.LINE_ID
                         , C.OPERATION_ID
                         , A.COLUMN_NAME
                         , A.COLUMN_LABEL_NAME
                         , C.YYYYMMDD
                         , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO)
                         , C.DIVISION_NAME
                         , C.OPERATION_GROUP_NAME
                         , C.SCM_SITE_DESCRIPTION
                         , C.NICK_NAME
                         , C.ORIGIN_DIVISION_ID
                         , C.ELECTRODE_TYPE
               )  M
             , ( /* 계획 */
                 SELECT A.DIVISION_ID
                      , A.OPERATION_GROUP
                      , A.SCM_SITE_ID
                      , A.ITEM_ID
                      , A.OPERATION_ID
                      , A.LINE_ID
                      , A.MEASURE
                      , A.YYYYMMDD
                      , CASE WHEN TRIM(A.ORIGIN_DIVISION_ID) IS NULL THEN '-'
                             ELSE A.ORIGIN_DIVISION_ID END  AS ORIGIN_DIVISION_ID
                      , CASE WHEN TRIM(A.ELECTRODE_TYPE) IS NULL THEN '-'
                             ELSE A.ELECTRODE_TYPE END      AS ELECTRODE_TYPE
                      , A.QTY
                   FROM SCP_ANL_PRODUCTION_PLAN_C A
                  WHERE 1 = 1
                    AND A.YYYYMMDD        >= P_FROM_YYYYMMDD
                    AND A.YYYYMMDD        <= P_TO_YYYYMMDD
                    AND A.DIVISION_ID      = P_DIVISION_ID
                    AND A.OPERATION_GROUP  = P_OPERATION_GROUP
                    AND A.SCM_SITE_ID      = P_SCM_SITE_ID
                    AND A.ITEM_ID          = P_ITEM_ID
                    AND A.VERSION_NO       = P_VERSION_NO
                    AND ( TRIM(P_ELECTRODE_TYPE) IS NULL
                          OR P_ELECTRODE_TYPE = '-'
                          OR A.ELECTRODE_TYPE = P_ELECTRODE_TYPE )
               )  N
             , SCM_SYS_CALENDAR_M O
         WHERE M.DIVISION_ID        = N.DIVISION_ID(+)
           AND M.OPERATION_GROUP    = N.OPERATION_GROUP(+)
           AND M.SCM_SITE_ID        = N.SCM_SITE_ID(+)
           AND M.ITEM_ID            = N.ITEM_ID(+)
           AND M.OPERATION_ID       = N.OPERATION_ID(+)
           AND M.LINE_ID            = N.LINE_ID(+)
           AND M.MEASURE            = N.MEASURE(+)
           AND M.YYYYMMDD           = N.YYYYMMDD(+)
           AND M.ORIGIN_DIVISION_ID = N.ORIGIN_DIVISION_ID(+)
           AND M.ELECTRODE_TYPE     = N.ELECTRODE_TYPE(+)
           AND M.YYYYMMDD           = O.BASIS_YYYYMMDD
           /* 조회조건 추가부분 (Model Tab에서만 사용하는 REQUIREMENT , FORMATION_YIELD Measure는 *로 입력되어 Line조회시 제외함) */
           AND M.LINE_ID IS NOT NULL
           AND M.LINE_ID <> '*';

        /*==========================================================================
         * PIVOIT처리 - PIVOIT 대상 날짜문자열 생성
         *========================================================================*/
        FOR R IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK      AS YYYYMMDD
                                 , A.BASIS_START_DATE || '21'                AS SORT_ORDER_NO
                                 , 1                                         AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.ISO_WEEK
                                    , A.BASIS_START_DATE
                             UNION ALL
                            SELECT 'M_' || A.BASIS_YYYYMM                    AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '01'           AS SORT_ORDER_NO
                                 , 2                                         AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.MONTH_NAME
                             UNION ALL
                            SELECT 'D_' || A.BASIS_YYYYMMDD                  AS YYYYMMDD
                                 , A.BASIS_YYYYMMDD || '31'                  AS SORT_ORDER_NO
                                 , 3                                         AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMMDD
                          )  A
                    ORDER BY SORT_ORDER_NO
                           , BLK
                 )
        LOOP

            IF SUBSTR(R.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END)  AS ' || R.YYYYMMDD));
            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END)  AS ' || R.YYYYMMDD));
            ELSE
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END)  AS ' || R.YYYYMMDD));
            END IF;

        END LOOP;

        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT DIVISION_ID' || CHR(10)
         || '     , DIVISION_NAME' || CHR(10)
         || '     , OPERATION_GROUP' || CHR(10)
         || '     , OPERATION_GROUP_NAME' || CHR(10)
         || '     , SCM_SITE_ID' || CHR(10)
         || '     , SCM_SITE_DESCRIPTION' || CHR(10)
         || '     , LINE_ID' || CHR(10)
         || '     , ITEM_ID' || CHR(10)
         || '     , NICK_NAME' || CHR(10)
         || '     , MEASURE' || CHR(10)
         || '     , MEASURE_NAME' || CHR(10)
         || '     , OPERATION_ID' || CHR(10)
         || '     , VERSION_NO' || CHR(10)
         || '     , FROM_YYYYMMDD' || CHR(10)
         || '     , USER_SORT_ORDER_NO' || CHR(10)
         || '     , ORIGIN_DIVISION_ID' || CHR(10)
         || '     , ELECTRODE_TYPE'));
        DBMS_LOB.APPEND(V_SQL, V_QRY_SUM);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            CHR(10) || '  FROM GT_0017_LINE' || CHR(10)
         || ' GROUP BY DIVISION_ID' || CHR(10)
         || '        , DIVISION_NAME' || CHR(10)
         || '        , OPERATION_GROUP' || CHR(10)
         || '        , OPERATION_GROUP_NAME' || CHR(10)
         || '        , SCM_SITE_ID' || CHR(10)
         || '        , SCM_SITE_DESCRIPTION' || CHR(10)
         || '        , LINE_ID' || CHR(10)
         || '        , ITEM_ID' || CHR(10)
         || '        , NICK_NAME' || CHR(10)
         || '        , MEASURE' || CHR(10)
         || '        , MEASURE_NAME' || CHR(10)
         || '        , OPERATION_ID' || CHR(10)
         || '        , VERSION_NO' || CHR(10)
         || '        , FROM_YYYYMMDD' || CHR(10)
         || '        , USER_SORT_ORDER_NO' || CHR(10)
         || '        , ORIGIN_DIVISION_ID' || CHR(10)
         || '        , ELECTRODE_TYPE' || CHR(10)
         || ' ORDER BY ' || FN_ORDER_EXPR('DIVISION_ID, OPERATION_GROUP, SCM_SITE_ID, LINE_ID, ITEM_ID, USER_SORT_ORDER_NO')));

        OPEN O_RC1 FOR V_SQL;

        DBMS_LOB.FREETEMPORARY(V_QRY_SUM);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0017_GET_PRODUCTION_PLAN_LINE_WATERFALL;

END PKG_SCP0017;