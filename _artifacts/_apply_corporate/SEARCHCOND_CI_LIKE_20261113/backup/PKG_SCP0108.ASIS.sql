CREATE OR REPLACE PACKAGE BODY PKG_SCP0108
IS

/****************************************************************************************************/
/* Program ID  : P_SCP0108_SET_CODE                                                                 */
/* Description : 계층 이름 · 사업부 이름 · 공정 이름을 담는다                                       */
/****************************************************************************************************/
PROCEDURE P_SCP0108_SET_CODE
IS
BEGIN

    DELETE GT_SCP0108_CODE;

    INSERT INTO GT_SCP0108_CODE
                ( CODE_TP
                , CODE
                , NAME )
         SELECT 'S'
              , SITE_ID
              , SITE_NAME
           FROM SCP_MST_CAPA_LINE
          WHERE VALID_YN = 'Y'
          GROUP BY SITE_ID
                 , SITE_NAME
          UNION ALL
         SELECT 'C'
              , COMPANY_ID
              , COMPANY_NAME
           FROM SCP_MST_CAPA_LINE
          WHERE VALID_YN = 'Y'
          GROUP BY COMPANY_ID
                 , COMPANY_NAME
          UNION ALL
         SELECT 'P'
              , PLANT_ID
              , PLANT_NAME
           FROM SCP_MST_CAPA_LINE
          WHERE VALID_YN = 'Y'
          GROUP BY PLANT_ID
                 , PLANT_NAME
          UNION ALL
         SELECT 'F'
              , FACTORY_ID
              , FACTORY_NAME
           FROM SCP_MST_CAPA_LINE
          WHERE VALID_YN = 'Y'
          GROUP BY FACTORY_ID
                 , FACTORY_NAME
          UNION ALL
         SELECT 'L'
              , LINE_ID
              , LINE_NAME
           FROM SCP_MST_CAPA_LINE
          WHERE VALID_YN = 'Y'
          GROUP BY LINE_ID
                 , LINE_NAME
          UNION ALL
         SELECT 'D'
              , DIVISION_ID
              , DIVISION_NAME
           FROM SCM_MST_DIVISION;

    /* 공정 이름 — 기준 공정과 Formation 공정을 합친다 */
    INSERT INTO GT_SCP0108_CODE
                ( CODE_TP
                , CODE
                , NAME )
         SELECT 'O'
              , OPERATION_ID
              , MAX(OPERATION_NAME)
           FROM SCM_MST_OPERATION_SN
          GROUP BY OPERATION_ID
          UNION ALL
         SELECT 'O'
              , B.SEGMENT1
              , B.ATTRIBUTE1
           FROM SCM_ADM_LOOKUP_MASTER A
              , SCM_ADM_LOOKUP_MASTER_DETAIL B
          WHERE B.LOOKUP_TYPE  = A.LOOKUP_TYPE
            AND A.LOOKUP_GROUP = 'SCP'
            AND A.LOOKUP_TYPE  = 'CPS_FORMATION_OPERATION'
            AND B.VALID_YN     = 'Y'
          GROUP BY B.SEGMENT1
                 , B.ATTRIBUTE1;

END P_SCP0108_SET_CODE;


/****************************************************************************************************/
/* Program ID  : P_SCP0108_GET_CAPA_LOB_CURRENT                                                     */
/* Description : LOB Report 현재분 — 손실계획 원장의 생산능력(일)을 라인 배정과 맞춰 본다           */
/*               AS-IS SCP0108_GET_CAPA_LOB_CURRENT                                                 */
/****************************************************************************************************/
PROCEDURE P_SCP0108_GET_CAPA_LOB_CURRENT
(
    P_VERSION               IN  CLOB
  /* , P_VERSION_SEQ           IN  CLOB */ /* AJS 20261007 화면검증 */
  , P_VERSION_SEQ           IN  VARCHAR2   /* AJS 20261007 화면검증 */
  , P_DIVISION_ID           IN  CLOB
  , P_SITE_ID               IN  CLOB
  , P_PLANT_ID              IN  CLOB
  , P_FACTORY_ID            IN  CLOB
  , P_LINE_ID               IN  CLOB
  , P_OPERATION_ID          IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_ELECTRODE_TYPE        IN  CLOB
  , P_BOTTLENECK_FLAG       IN  CLOB
  , P_PROGRAM_ID            IN  CLOB
  , P_SHEET_NAME            IN  CLOB
  , P_USER_ID               IN  CLOB
  , P_DEBUG_MODE            IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RC2                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
    V_VERSION           VARCHAR2(40 CHAR)   := TO_CHAR(P_VERSION);
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(P_DIVISION_ID);
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(P_SITE_ID);
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(P_PLANT_ID);
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(P_FACTORY_ID);
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(P_LINE_ID);
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(P_OPERATION_ID);
    V_NICK_NAME         VARCHAR2(4000 CHAR) := TO_CHAR(P_NICK_NAME);
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(P_ELECTRODE_TYPE);
    V_BOTTLENECK_FLAG   VARCHAR2(600 CHAR)  := TO_CHAR(P_BOTTLENECK_FLAG);
    V_START_YM          VARCHAR2(6 CHAR);
    V_START_YY          VARCHAR2(4 CHAR);
    V_END_YY            VARCHAR2(4 CHAR);
    V_BOUND_YY          VARCHAR2(4 CHAR);
    V_DATE_COLS         CLOB := EMPTY_CLOB();
    V_BTNK_COLS         CLOB := EMPTY_CLOB();
    V_SQL               CLOB;
    V_RESULT_MSG        VARCHAR2(4000 CHAR);
BEGIN

    DELETE GT_SCP0108_DATE_COLS;
    DELETE GT_SCP0108_ASSIGN;
    DELETE GT_SCP0108_CAPA;
    DELETE GT_SCP0108_ADJ;

    V_START_YM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), 1), 'YYYYMM');
    V_START_YY := SUBSTR(V_START_YM, 1, 4);
    V_END_YY   := TO_CHAR(ADD_MONTHS(TO_DATE(V_START_YY || '0101', 'YYYYMMDD'), 60), 'YYYY');
    V_BOUND_YY := TO_CHAR(ADD_MONTHS(TO_DATE(V_START_YY || '0101', 'YYYYMMDD'), 36), 'YYYY');

    P_SCP0108_SET_CODE;

    /* 날짜 칸 — 세 해까지는 달 단위, 그 뒤는 해 단위 */
    INSERT INTO GT_SCP0108_DATE_COLS
                ( COLUMN_NAME
                , YYYYMM
                , PREFIX
                , SORT_ORDER_NO )
         SELECT DISTINCT
                CASE WHEN YYYY < V_BOUND_YY THEN 'M_01' || YYYYMM ELSE 'Y_' || YYYY END
              , CASE WHEN YYYY < V_BOUND_YY THEN YYYYMM ELSE YYYY END
              , CASE WHEN YYYY < V_BOUND_YY THEN 'M_01' ELSE 'Y_' END
              , CASE WHEN YYYY < V_BOUND_YY THEN YYYYMM ELSE YYYY END
           FROM SCM_MST_BUCKET
          WHERE YYYY >= V_START_YY
            AND YYYY <= V_END_YY;

    /* 라인 배정 — 차례가 매겨진 것만 */
    INSERT INTO GT_SCP0108_ASSIGN
                ( DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , NICK_NAME
                , YYYYMM
                , DUMMY_YN )
         SELECT A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.NICK_NAME
              , A.YYYYMM
              , A.DUMMY_YN
           FROM SCP_MST_CAPA_LINE_ASSIGN A
          WHERE A.VALID_YN = 'Y'
            AND NVL(A.ASSIGN_PRIORITY, 0) <> 0
            AND (TRIM(V_DIVISION_ID)    IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' OR A.DIVISION_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_SITE_ID)        IS NULL OR UPPER(V_SITE_ID) = 'ALL' OR A.SITE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_PLANT_ID)       IS NULL OR UPPER(V_PLANT_ID) = 'ALL' OR A.PLANT_ID      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_FACTORY_ID)     IS NULL OR UPPER(V_FACTORY_ID) = 'ALL' OR A.FACTORY_ID    IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_LINE_ID)        IS NULL OR UPPER(V_LINE_ID) = 'ALL' OR A.LINE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_OPERATION_ID)   IS NULL OR UPPER(V_OPERATION_ID) = 'ALL' OR A.OPERATION_ID  IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_ELECTRODE_TYPE) IS NULL OR UPPER(V_ELECTRODE_TYPE) = 'ALL' OR A.ELTR_LN_TP_CD IN (SELECT DECODE(COLUMN_VALUE, 'BLANKS', '-', COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))   /* 조회조건 ALL 은 조건 없음 */   --  2026.11.12 AJS
            AND (TRIM(V_NICK_NAME)      IS NULL OR UPPER(V_NICK_NAME) = 'ALL' OR A.NICK_NAME     IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))));   /* 조회조건 ALL 은 조건 없음 */

    /* 생산능력(일) — 라인 배정에 있는 열쇠만 남긴다 */
    INSERT INTO GT_SCP0108_CAPA
                ( MDL_NM
                , PLANT_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , FACTORY_ID
                , YYYYMM
                , MSR_NVL )
         SELECT A.MDL_NM
              , A.PLANT_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.FACTORY_ID
              , A.YYYYMM
              , A.MSR_NVL
           FROM SCP_MST_CAPA_LOSS_PLAN_MDL A
              , GT_SCP0108_ASSIGN B
          WHERE B.NICK_NAME     = A.MDL_NM
            AND B.DIVISION_ID   = A.DIVISION_ID
            AND B.COMPANY_ID    = A.COMPANY_ID
            AND B.SITE_ID       = A.SITE_ID
            AND B.PLANT_ID      = A.PLANT_ID
            AND B.FACTORY_ID    = A.FACTORY_ID
            AND B.LINE_ID       = A.LINE_ID
            AND B.OPERATION_ID  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
            AND B.YYYYMM        = A.YYYYMM
            AND A.MSR_TP_CD     = 'PROD_CAPA_D'
            AND (TRIM(V_DIVISION_ID)    IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' OR A.DIVISION_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_SITE_ID)        IS NULL OR UPPER(V_SITE_ID) = 'ALL' OR A.SITE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_PLANT_ID)       IS NULL OR UPPER(V_PLANT_ID) = 'ALL' OR A.PLANT_ID      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_FACTORY_ID)     IS NULL OR UPPER(V_FACTORY_ID) = 'ALL' OR A.FACTORY_ID    IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_LINE_ID)        IS NULL OR UPPER(V_LINE_ID) = 'ALL' OR A.LINE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_OPERATION_ID)   IS NULL OR UPPER(V_OPERATION_ID) = 'ALL' OR A.OPERATION_ID  IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_ELECTRODE_TYPE) IS NULL OR UPPER(V_ELECTRODE_TYPE) = 'ALL' OR A.ELTR_LN_TP_CD IN (SELECT DECODE(COLUMN_VALUE, 'BLANKS', '-', COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))   /* 조회조건 ALL 은 조건 없음 */   --  2026.11.12 AJS
            AND (TRIM(V_NICK_NAME)      IS NULL OR UPPER(V_NICK_NAME) = 'ALL' OR A.MDL_NM        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_BOTTLENECK_FLAG) IS NULL OR V_BOTTLENECK_FLAG = 'ALL' OR A.ATTRIBUTE1 = V_BOTTLENECK_FLAG);

    /* 조정 후 생산능력 — 같은 라인·기간 안에서 가장 작은 값이 그 라인의 능력이다 */
    INSERT INTO GT_SCP0108_ADJ
                ( DV
                , DIVISION_ID
                , SITE_ID
                , COMPANY_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , NICK_NAME
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , YYYYMM
                , PRDN_CAPA
                , ADJ_PRDN_CAPA )
         SELECT '2'
              , DIVISION_ID
              , SITE_ID
              , COMPANY_ID
              , PLANT_ID
              , FACTORY_ID
              , LINE_ID
              , MDL_NM
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , YYYYMM
              , MSR_NVL
              , MIN(MSR_NVL) OVER (PARTITION BY MDL_NM
                                              , PLANT_ID
                                              , FACTORY_ID
                                              , LINE_ID
                                              , DIVISION_ID
                                              , COMPANY_ID
                                              , SITE_ID
                                              , YYYYMM)
           FROM GT_SCP0108_CAPA;

    /* 모델을 고른 조회에서는 모델 합계 줄을 하나 더 보여 준다 */
    IF TRIM(V_NICK_NAME) IS NOT NULL THEN

        INSERT INTO GT_SCP0108_ADJ
                    ( DV
                    , DIVISION_ID
                    , SITE_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , FACTORY_ID
                    , LINE_ID
                    , NICK_NAME
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , YYYYMM
                    , PRDN_CAPA
                    , ADJ_PRDN_CAPA )
             SELECT '1'
                  , '*'
                  , '*'
                  , '*'
                  , '*'
                  , '*'
                  , '*'
                  , MDL_NM
                  , OPERATION_ID
                  , ELTR_LN_TP_CD
                  , YYYYMM
                  , SUM(MSR_NVL)
                  , NULL
               FROM GT_SCP0108_CAPA
              GROUP BY MDL_NM
                     , OPERATION_ID
                     , ELTR_LN_TP_CD
                     , YYYYMM;

    END IF;

    /* 날짜 칸을 조회 조건에 맞춰 만든다 — 개수가 달라 이 문장만 동적으로 조립한다 */
    FOR R IN (SELECT COLUMN_NAME
                   , YYYYMM
                FROM GT_SCP0108_DATE_COLS
               ORDER BY SORT_ORDER_NO)
    LOOP

        V_DATE_COLS := V_DATE_COLS || '
         , MAX(CASE WHEN CP.YYYYMM = ''' || R.YYYYMM || ''' THEN CP.PRDN_CAPA END) AS ' || R.COLUMN_NAME;
        V_BTNK_COLS := V_BTNK_COLS || '
         , MAX(CASE WHEN CP.YYYYMM = ''' || R.YYYYMM || ''' AND CP.PRDN_CAPA = CP.ADJ_PRDN_CAPA AND CP.OPERATION_ID LIKE ''A%'' THEN ''Y'' END) AS ' || R.COLUMN_NAME;

    END LOOP;

    V_SQL := '
    SELECT CP.DV
         , CP.DIVISION_ID
         , CP.SITE_ID
         , CP.COMPANY_ID
         , CP.PLANT_ID
         , CP.LINE_ID
         , CP.NICK_NAME
         , CP.OPERATION_ID
         , MAX(O.NAME)          AS OPERATION_NAME
         , CP.ELTR_LN_TP_CD' || V_DATE_COLS || '
         , NVL(MAX(DM.NAME), ''*'') AS DIVISION_NAME
         , NVL(MAX(S.NAME), ''*'')  AS SITE_NAME
         , NVL(MAX(C.NAME), ''*'')  AS COMPANY_NAME
         , NVL(MAX(P.NAME), ''*'')  AS PLANT_NAME
         , NVL(MAX(L.NAME), ''*'')  AS LINE_NAME
      FROM GT_SCP0108_ADJ CP
         , GT_SCP0108_CODE DM
         , GT_SCP0108_CODE S
         , GT_SCP0108_CODE C
         , GT_SCP0108_CODE P
         , GT_SCP0108_CODE L
         , GT_SCP0108_CODE O
     WHERE DM.CODE_TP(+) = ''D''
       AND DM.CODE(+)    = CP.DIVISION_ID
       AND S.CODE_TP(+)  = ''S''
       AND S.CODE(+)     = CP.SITE_ID
       AND C.CODE_TP(+)  = ''C''
       AND C.CODE(+)     = CP.COMPANY_ID
       AND P.CODE_TP(+)  = ''P''
       AND P.CODE(+)     = CP.PLANT_ID
       AND L.CODE_TP(+)  = ''L''
       AND L.CODE(+)     = CP.LINE_ID
       AND O.CODE_TP(+)  = ''O''
       AND O.CODE(+)     = CP.OPERATION_ID
     GROUP BY CP.DV
            , CP.DIVISION_ID
            , CP.SITE_ID
            , CP.COMPANY_ID
            , CP.PLANT_ID
            , CP.LINE_ID
            , CP.NICK_NAME
            , CP.OPERATION_ID
            , CP.ELTR_LN_TP_CD';

    OPEN O_RC1 FOR V_SQL;

    V_SQL := '
    SELECT CP.DV
         , CP.DIVISION_ID
         , CP.SITE_ID
         , CP.COMPANY_ID
         , CP.PLANT_ID
         , CP.LINE_ID
         , CP.NICK_NAME
         , CP.OPERATION_ID
         , CP.ELTR_LN_TP_CD' || V_BTNK_COLS || '
      FROM GT_SCP0108_ADJ CP
     GROUP BY CP.DV
            , CP.DIVISION_ID
            , CP.SITE_ID
            , CP.COMPANY_ID
            , CP.PLANT_ID
            , CP.LINE_ID
            , CP.NICK_NAME
            , CP.OPERATION_ID
            , CP.ELTR_LN_TP_CD';

    OPEN O_RC2 FOR V_SQL;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'S' AS RESULT_CD
             , NULL AS RESULT_MSG
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        V_RESULT_MSG := '[' || SQLCODE || ']' || SUBSTR(SQLERRM, 1, 1000)
                     || ' @' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 2000);

        IF NOT O_RC1%ISOPEN THEN
            OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 2;
        END IF;

        IF NOT O_RC2%ISOPEN THEN
            OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 2;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT 'F'          AS RESULT_CD
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

END P_SCP0108_GET_CAPA_LOB_CURRENT;


/****************************************************************************************************/
/* Program ID  : P_SCP0108_GET_CAPA_LOB                                                             */
/* Description : LOB Report 마감분 — LOB 결과 원장을 라인 배정 마감분과 맞춰 본다                   */
/*               AS-IS SCP0108_GET_CAPA_LOB                                                         */
/****************************************************************************************************/
PROCEDURE P_SCP0108_GET_CAPA_LOB
(
    P_VERSION               IN  CLOB
  /* , P_VERSION_SEQ           IN  CLOB */ /* AJS 20261007 화면검증 */
  , P_VERSION_SEQ           IN  VARCHAR2   /* AJS 20261007 화면검증 */
  , P_DIVISION_ID           IN  CLOB
  , P_SITE_ID               IN  CLOB
  , P_PLANT_ID              IN  CLOB
  , P_FACTORY_ID            IN  CLOB
  , P_LINE_ID               IN  CLOB
  , P_OPERATION_ID          IN  CLOB
  , P_NICK_NAME             IN  CLOB
  , P_ELECTRODE_TYPE        IN  CLOB
  , P_BOTTLENECK_FLAG       IN  CLOB
  , P_PROGRAM_ID            IN  CLOB
  , P_SHEET_NAME            IN  CLOB
  , P_USER_ID               IN  CLOB
  , P_DEBUG_MODE            IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RC2                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
    V_VERSION           VARCHAR2(40 CHAR)   := TO_CHAR(P_VERSION);
    V_VERSION_SEQ       NUMBER(3)           := TO_NUMBER(TO_CHAR(P_VERSION_SEQ));
    V_PROGRAM_ID        VARCHAR2(120 CHAR)  := TO_CHAR(P_PROGRAM_ID);
    V_SHEET_NAME        VARCHAR2(120 CHAR)  := TO_CHAR(P_SHEET_NAME);
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(P_DIVISION_ID);
    V_SITE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(P_SITE_ID);
    V_PLANT_ID          VARCHAR2(4000 CHAR) := TO_CHAR(P_PLANT_ID);
    V_FACTORY_ID        VARCHAR2(4000 CHAR) := TO_CHAR(P_FACTORY_ID);
    V_LINE_ID           VARCHAR2(4000 CHAR) := TO_CHAR(P_LINE_ID);
    V_OPERATION_ID      VARCHAR2(4000 CHAR) := TO_CHAR(P_OPERATION_ID);
    V_NICK_NAME         VARCHAR2(4000 CHAR) := TO_CHAR(P_NICK_NAME);
    V_ELECTRODE_TYPE    VARCHAR2(4000 CHAR) := TO_CHAR(P_ELECTRODE_TYPE);
    V_BOTTLENECK_FLAG   VARCHAR2(600 CHAR)  := TO_CHAR(P_BOTTLENECK_FLAG);
    V_FROM_YYYYMM       VARCHAR2(6 CHAR);
    V_DATE_COLS         CLOB := EMPTY_CLOB();
    V_BTNK_COLS         CLOB := EMPTY_CLOB();
    V_SUM_COLS          CLOB := EMPTY_CLOB();
    V_SUM_BTNK_COLS     CLOB := EMPTY_CLOB();
    V_FINAL_COLS        CLOB := EMPTY_CLOB();
    V_FINAL_BTNK_COLS   CLOB := EMPTY_CLOB();
    V_SQL               CLOB;
    V_RESULT_MSG        VARCHAR2(4000 CHAR);
BEGIN

    DELETE GT_SCP0108_DATE_COLS;
    DELETE GT_SCP0108_ASSIGN;
    DELETE GT_SCP0108_RAW_TEMP;
    DELETE GT_SCP0108_RAW1;
    DELETE GT_SCP0108_RAW;

    V_FROM_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), 1), 'YYYYMM');

    P_SCP0108_SET_CODE;

    INSERT INTO GT_SCP0108_DATE_COLS
                ( COLUMN_NAME
                , SORT_ORDER_NO )
         SELECT COLUMN_NAME
              , SORT_ORDER_NO
           FROM TABLE(FN_SCP0104_GET_SPREAD_TITLE(V_FROM_YYYYMM, V_PROGRAM_ID, V_SHEET_NAME));

    /* LOB 결과 */
    INSERT INTO GT_SCP0108_RAW_TEMP
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , YYYYMM
                , MDL_NM
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , THRY_CAPA
                , PRDN_CAPA
                , PRDN_OPRT
                , LD_RT
                , ADJ_PRDN_CAPA
                , ADJ_PRDN_OPRT
                , ADJ_LD_RT
                , ADJ_ULD_RT
                , BOTTLENECK_FLAG )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.YYYYMM
              , A.MDL_NM
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.THRY_CAPA
              , A.PRDN_CAPA
              , A.PRDN_OPRT
              , A.LD_RT
              , A.ADJ_PRDN_CAPA
              , A.ADJ_PRDN_OPRT
              , A.ADJ_LD_RT
              , A.ADJ_ULD_RT
              , A.ATTRIBUTE1
           FROM SCP_RPT_CAPA_LOB A
          WHERE A.VER_ID  = V_VERSION
            AND A.VER_SEQ = V_VERSION_SEQ
            AND (TRIM(V_DIVISION_ID)    IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' OR A.DIVISION_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_SITE_ID)        IS NULL OR UPPER(V_SITE_ID) = 'ALL' OR A.SITE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_PLANT_ID)       IS NULL OR UPPER(V_PLANT_ID) = 'ALL' OR A.PLANT_ID      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_FACTORY_ID)     IS NULL OR UPPER(V_FACTORY_ID) = 'ALL' OR A.FACTORY_ID    IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_LINE_ID)        IS NULL OR UPPER(V_LINE_ID) = 'ALL' OR A.LINE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_OPERATION_ID)   IS NULL OR UPPER(V_OPERATION_ID) = 'ALL' OR A.OPERATION_ID  IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_ELECTRODE_TYPE) IS NULL OR UPPER(V_ELECTRODE_TYPE) = 'ALL' OR A.ELTR_LN_TP_CD IN (SELECT DECODE(COLUMN_VALUE, 'BLANKS', '-', COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))   /* 조회조건 ALL 은 조건 없음 */   --  2026.11.12 AJS
            AND (TRIM(V_NICK_NAME)      IS NULL OR UPPER(V_NICK_NAME) = 'ALL' OR A.MDL_NM        IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_BOTTLENECK_FLAG) IS NULL OR V_BOTTLENECK_FLAG = 'ALL' OR A.ATTRIBUTE1 = V_BOTTLENECK_FLAG);

    /* 라인 배정 마감분 */
    INSERT INTO GT_SCP0108_ASSIGN
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , FACTORY_ID
                , LINE_ID
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , ITEM_ID
                , NICK_NAME
                , YYYYMM
                , ASSIGN_PRIORITY )
         SELECT V_VERSION
              , V_VERSION_SEQ
              , A.DIVISION_ID
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.FACTORY_ID
              , A.LINE_ID
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.ITEM_ID
              , A.NICK_NAME
              , A.YYYYMM
              , A.ASSIGN_PRIORITY
           FROM SCP_MST_CAPA_LINE_ASSIGN_CUTF A
          WHERE A.VER_ID   = V_VERSION
            AND A.VER_SEQ  = V_VERSION_SEQ
            AND A.VALID_YN = 'Y'
            AND (TRIM(V_DIVISION_ID)    IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' OR A.DIVISION_ID   IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_SITE_ID)        IS NULL OR UPPER(V_SITE_ID) = 'ALL' OR A.SITE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_SITE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_PLANT_ID)       IS NULL OR UPPER(V_PLANT_ID) = 'ALL' OR A.PLANT_ID      IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_PLANT_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_FACTORY_ID)     IS NULL OR UPPER(V_FACTORY_ID) = 'ALL' OR A.FACTORY_ID    IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_FACTORY_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_LINE_ID)        IS NULL OR UPPER(V_LINE_ID) = 'ALL' OR A.LINE_ID       IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_LINE_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_OPERATION_ID)   IS NULL OR UPPER(V_OPERATION_ID) = 'ALL' OR A.OPERATION_ID  IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_OPERATION_ID, ','))))   /* 조회조건 ALL 은 조건 없음 */
            AND (TRIM(V_ELECTRODE_TYPE) IS NULL OR UPPER(V_ELECTRODE_TYPE) = 'ALL' OR A.ELTR_LN_TP_CD IN (SELECT DECODE(COLUMN_VALUE, 'BLANKS', '-', COLUMN_VALUE) FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))   /* 조회조건 ALL 은 조건 없음 */   --  2026.11.12 AJS
            AND (TRIM(V_NICK_NAME)      IS NULL OR UPPER(V_NICK_NAME) = 'ALL' OR A.NICK_NAME     IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))));   /* 조회조건 ALL 은 조건 없음 */

    INSERT INTO GT_SCP0108_RAW1
                ( VER_ID
                , VER_SEQ
                , DIVISION_ID
                , YYYYMM
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , LINE_ID
                , MDL_NM
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , THRY_CAPA
                , PRDN_CAPA
                , PRDN_OPRT
                , LD_RT
                , ADJ_PRDN_CAPA
                , ADJ_PRDN_OPRT
                , ADJ_LD_RT
                , ADJ_ULD_RT
                , BOTTLENECK_FLAG
                , ASSIGN_PRIORITY )
         SELECT A.VER_ID
              , A.VER_SEQ
              , A.DIVISION_ID
              , A.YYYYMM
              , A.COMPANY_ID
              , A.SITE_ID
              , A.PLANT_ID
              , A.LINE_ID
              , A.MDL_NM
              , A.OPERATION_ID
              , A.ELTR_LN_TP_CD
              , A.THRY_CAPA
              , A.PRDN_CAPA
              , A.PRDN_OPRT
              , A.LD_RT
              , A.ADJ_PRDN_CAPA
              , A.ADJ_PRDN_OPRT
              , A.ADJ_LD_RT
              , A.ADJ_ULD_RT
              , A.BOTTLENECK_FLAG
              , NVL(B.ASSIGN_PRIORITY, 0)
           FROM GT_SCP0108_RAW_TEMP A
              , GT_SCP0108_ASSIGN B
          WHERE B.DIVISION_ID   = A.DIVISION_ID
            AND B.COMPANY_ID    = A.COMPANY_ID
            AND B.SITE_ID       = A.SITE_ID
            AND B.PLANT_ID      = A.PLANT_ID
            AND B.FACTORY_ID    = A.FACTORY_ID
            AND B.LINE_ID       = A.LINE_ID
            AND B.OPERATION_ID  = A.OPERATION_ID
            AND B.ELTR_LN_TP_CD = A.ELTR_LN_TP_CD
            AND B.NICK_NAME     = A.MDL_NM
            AND B.YYYYMM        = A.YYYYMM
            AND NVL(B.ASSIGN_PRIORITY, 0) <> 0;

    INSERT INTO GT_SCP0108_RAW
                ( DV
                , VER_ID
                , VER_SEQ
                , DIVISION_ID
                , COMPANY_ID
                , SITE_ID
                , PLANT_ID
                , LINE_ID
                , MDL_NM
                , OPERATION_ID
                , ELTR_LN_TP_CD
                , YYYYMM
                , THRY_CAPA
                , PRDN_CAPA
                , PRDN_OPRT
                , LD_RT
                , ADJ_PRDN_CAPA
                , ADJ_PRDN_OPRT
                , ADJ_LD_RT
                , ADJ_ULD_RT
                , BOTTLENECK_FLAG )
         SELECT '2'
              , VER_ID
              , VER_SEQ
              , DIVISION_ID
              , COMPANY_ID
              , SITE_ID
              , PLANT_ID
              , LINE_ID
              , MDL_NM
              , OPERATION_ID
              , ELTR_LN_TP_CD
              , YYYYMM
              , SUM(THRY_CAPA)
              , SUM(PRDN_CAPA)
              , AVG(PRDN_OPRT)
              , AVG(LD_RT)
              , SUM(ADJ_PRDN_CAPA)
              , SUM(ADJ_PRDN_OPRT)
              , AVG(ADJ_LD_RT)
              , AVG(ADJ_ULD_RT)
              , BOTTLENECK_FLAG
           FROM GT_SCP0108_RAW1
          WHERE ASSIGN_PRIORITY <> 0
          GROUP BY VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , LINE_ID
                 , MDL_NM
                 , OPERATION_ID
                 , ELTR_LN_TP_CD
                 , YYYYMM
                 , BOTTLENECK_FLAG;

    /* 모델을 고른 조회에서는 모델 합계 줄을 하나 더 보여 준다 */
    IF TRIM(V_NICK_NAME) IS NOT NULL THEN

        INSERT INTO GT_SCP0108_RAW
                    ( DV
                    , VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , LINE_ID
                    , MDL_NM
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , YYYYMM
                    , THRY_CAPA
                    , PRDN_CAPA
                    , PRDN_OPRT
                    , LD_RT
                    , ADJ_PRDN_CAPA
                    , ADJ_PRDN_OPRT
                    , ADJ_LD_RT
                    , ADJ_ULD_RT
                    , BOTTLENECK_FLAG )
             SELECT '1'
                  , VER_ID
                  , VER_SEQ
                  , '*'
                  , '*'
                  , '*'
                  , '*'
                  , '*'
                  , MDL_NM
                  , OPERATION_ID
                  , ELTR_LN_TP_CD
                  , YYYYMM
                  , SUM(THRY_CAPA)
                  , SUM(PRDN_CAPA)
                  , AVG(PRDN_OPRT)
                  , AVG(LD_RT)
                  , SUM(ADJ_PRDN_CAPA)
                  , SUM(ADJ_PRDN_OPRT)
                  , AVG(ADJ_LD_RT)
                  , AVG(ADJ_ULD_RT)
                  , 'N'
               FROM GT_SCP0108_RAW
              GROUP BY VER_ID
                     , VER_SEQ
                     , MDL_NM
                     , OPERATION_ID
                     , ELTR_LN_TP_CD
                     , YYYYMM;

    END IF;

    /* 날짜 칸을 조회 조건에 맞춰 만든다 — 개수가 달라 이 문장만 동적으로 조립한다 */
    FOR R IN (SELECT COLUMN_NAME
                FROM GT_SCP0108_DATE_COLS
               ORDER BY SORT_ORDER_NO)
    LOOP

        IF R.COLUMN_NAME LIKE 'M\_01%' ESCAPE '\' THEN
            V_DATE_COLS := V_DATE_COLS || '
             , CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 5, 6) THEN PRDN_CAPA END AS ' || R.COLUMN_NAME;
            V_BTNK_COLS := V_BTNK_COLS || '
             , CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 5, 6) THEN BOTTLENECK_FLAG END AS BOTTLENECK_FLAG_' || R.COLUMN_NAME;
        ELSE
            V_DATE_COLS := V_DATE_COLS || '
             , CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 3, 4) THEN PRDN_CAPA END AS ' || R.COLUMN_NAME;
            V_BTNK_COLS := V_BTNK_COLS || '
             , CASE WHEN YYYYMM = SUBSTR(''' || R.COLUMN_NAME || ''', 3, 4) THEN BOTTLENECK_FLAG END AS BOTTLENECK_FLAG_' || R.COLUMN_NAME;
        END IF;

        V_SUM_COLS        := V_SUM_COLS        || '
             , AVG(' || R.COLUMN_NAME || ') AS ' || R.COLUMN_NAME;
        V_SUM_BTNK_COLS   := V_SUM_BTNK_COLS   || '
             , MAX(BOTTLENECK_FLAG_' || R.COLUMN_NAME || ') AS BOTTLENECK_FLAG_' || R.COLUMN_NAME;
        V_FINAL_COLS      := V_FINAL_COLS      || '
         , XA.' || R.COLUMN_NAME;
        V_FINAL_BTNK_COLS := V_FINAL_BTNK_COLS || '
         , XA.BOTTLENECK_FLAG_' || R.COLUMN_NAME || ' AS ' || R.COLUMN_NAME;

    END LOOP;

    V_SQL := '
    SELECT XA.DV
         , XA.VER_ID
         , XA.VER_SEQ
         , XA.DIVISION_ID
         , XA.COMPANY_ID
         , XA.SITE_ID
         , XA.PLANT_ID
         , XA.LINE_ID
         , XA.NICK_NAME
         , XA.OPERATION_ID
         , O.NAME               AS OPERATION_NAME
         , XA.ELTR_LN_TP_CD' || V_FINAL_COLS || '
         , CASE WHEN XA.DIVISION_ID = ''*'' THEN ''*'' ELSE FN_GET_DIVISION_NAME(XA.DIVISION_ID) END AS DIVISION_NAME
         , CASE WHEN XA.SITE_ID  = ''*'' THEN ''*'' ELSE S.NAME END AS SITE_NAME
         , CASE WHEN XA.PLANT_ID = ''*'' THEN ''*'' ELSE P.NAME END AS PLANT_NAME
         , CASE WHEN XA.LINE_ID  = ''*'' THEN ''*'' ELSE L.NAME END AS LINE_NAME
      FROM (SELECT DV
                 , VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , LINE_ID
                 , MDL_NM       AS NICK_NAME
                 , OPERATION_ID
                 , ELTR_LN_TP_CD' || V_SUM_COLS || V_SUM_BTNK_COLS || '
              FROM (SELECT DV
                         , VER_ID
                         , VER_SEQ
                         , DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , LINE_ID
                         , MDL_NM
                         , OPERATION_ID
                         , ELTR_LN_TP_CD' || V_DATE_COLS || V_BTNK_COLS || '
                      FROM GT_SCP0108_RAW) IA
             GROUP BY DV
                    , VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , MDL_NM) XA
         , GT_SCP0108_CODE S
         , GT_SCP0108_CODE P
         , GT_SCP0108_CODE L
         , GT_SCP0108_CODE O
     WHERE S.CODE_TP(+) = ''S''
       AND S.CODE(+)    = XA.SITE_ID
       AND P.CODE_TP(+) = ''P''
       AND P.CODE(+)    = XA.PLANT_ID
       AND L.CODE_TP(+) = ''L''
       AND L.CODE(+)    = XA.LINE_ID
       AND O.CODE_TP(+) = ''O''
       AND O.CODE(+)    = XA.OPERATION_ID
     ORDER BY FN_ASIS_SORT_KEY(XA.DV) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.VER_ID) NULLS FIRST
            , XA.VER_SEQ NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.DIVISION_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.COMPANY_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.SITE_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.PLANT_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.LINE_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.NICK_NAME) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.OPERATION_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.ELTR_LN_TP_CD) NULLS FIRST';

    OPEN O_RC1 FOR V_SQL;

    V_SQL := '
    SELECT XA.DV
         , XA.VER_ID
         , XA.VER_SEQ
         , XA.DIVISION_ID
         , XA.COMPANY_ID
         , XA.SITE_ID
         , XA.PLANT_ID
         , XA.LINE_ID
         , XA.NICK_NAME
         , XA.OPERATION_ID
         , XA.ELTR_LN_TP_CD' || V_FINAL_BTNK_COLS || '
      FROM (SELECT DV
                 , VER_ID
                 , VER_SEQ
                 , DIVISION_ID
                 , COMPANY_ID
                 , SITE_ID
                 , PLANT_ID
                 , LINE_ID
                 , MDL_NM       AS NICK_NAME
                 , OPERATION_ID
                 , ELTR_LN_TP_CD' || V_SUM_COLS || V_SUM_BTNK_COLS || '
              FROM (SELECT DV
                         , VER_ID
                         , VER_SEQ
                         , DIVISION_ID
                         , COMPANY_ID
                         , SITE_ID
                         , PLANT_ID
                         , LINE_ID
                         , MDL_NM
                         , OPERATION_ID
                         , ELTR_LN_TP_CD' || V_DATE_COLS || V_BTNK_COLS || '
                      FROM GT_SCP0108_RAW) IA
             GROUP BY DV
                    , VER_ID
                    , VER_SEQ
                    , DIVISION_ID
                    , COMPANY_ID
                    , SITE_ID
                    , PLANT_ID
                    , LINE_ID
                    , OPERATION_ID
                    , ELTR_LN_TP_CD
                    , MDL_NM) XA
     ORDER BY FN_ASIS_SORT_KEY(XA.DV) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.VER_ID) NULLS FIRST
            , XA.VER_SEQ NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.DIVISION_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.COMPANY_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.SITE_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.PLANT_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.LINE_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.NICK_NAME) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.OPERATION_ID) NULLS FIRST
            , FN_ASIS_SORT_KEY(XA.ELTR_LN_TP_CD) NULLS FIRST';

    OPEN O_RC2 FOR V_SQL;

    OPEN O_RESULT_CURSOR FOR
        SELECT 'S' AS RESULT_CD
             , NULL AS RESULT_MSG
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        V_RESULT_MSG := '[' || SQLCODE || ']' || SUBSTR(SQLERRM, 1, 1000)
                     || ' @' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 2000);

        IF NOT O_RC1%ISOPEN THEN
            OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 2;
        END IF;

        IF NOT O_RC2%ISOPEN THEN
            OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 2;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT 'F'          AS RESULT_CD
                 , V_RESULT_MSG AS RESULT_MSG
              FROM DUAL;

END P_SCP0108_GET_CAPA_LOB;


/****************************************************************************************************/
/* Program ID  : P_SCP0108_GET_SPREAD_TITLE                                                           */
/* Description : 기간 칸 제목 조회 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE 위임                     */
/*               전달값 등록은 프로시저 한 자리에 한 벌이라 이름 표기가 다른 화면을 위해 자리를 나눈다 */
/* Program History                                                                                  */
/*   2026.10.07   AJS            화면 실측 검증 — 신규                                              */
/****************************************************************************************************/
PROCEDURE P_SCP0108_GET_SPREAD_TITLE   /* AJS 20261007 화면검증 */
(
    P_FROM_YYYYMM           IN  CLOB
  , P_PROGRAM_ID            IN  CLOB
  , P_SHEET_NAME            IN  CLOB
  , O_RC1                   OUT SYS_REFCURSOR
  , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
IS
BEGIN

    PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE( P_FROM_YYYYMM
                                          , P_PROGRAM_ID
                                          , P_SHEET_NAME
                                          , O_RC1
                                          , O_RESULT_CURSOR );

END P_SCP0108_GET_SPREAD_TITLE;

END PKG_SCP0108;
