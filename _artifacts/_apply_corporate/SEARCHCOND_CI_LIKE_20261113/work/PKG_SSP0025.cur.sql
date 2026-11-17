PACKAGE BODY PKG_SSP0025
IS
    /*
     * Program ID   : PKG_SSP0025
     * Description  : SSP0025 Shipment Requestor PIC 화면 — 조회 · 저장 · 품목 목록 · 사용자 확인
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          조회 속도 개선 : Material 팝업 사업부 조건을 뷰 안으로 넣고 도착 사이트 조인을 해시 조인으로(결과 동일)
     * 2026.10.07   AJS          조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     */

/****************************************************************************************************/
/* Program ID  : P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC                                               */
/* Description : Shipment Requestor PIC                                                             */
/****************************************************************************************************/
PROCEDURE P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC
(
    P_DIVISION_ID       IN  CLOB
  , P_PLANT_SITE        IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_NICK_NAME         IN  CLOB
  , P_MODEL_ID          IN  CLOB
  , P_LANGUAGE          IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 4000));
    V_PLANT_SITE        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_PLANT_SITE,  1, 4000));
    V_ITEM_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,     1, 4000));
    V_NICK_NAME         VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_NICK_NAME,   1, 4000));
    V_MODEL_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_MODEL_ID,    1, 4000));
    V_LANGUAGE          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LANGUAGE,    1, 4000));

BEGIN

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.TO_SITE                                            AS TO_SITE
             , B.SITE_DESCRIPTION                                   AS SITE_DESCRIPTION
             , A.ITEM_ID
             , IA.ELECTRODE_TYPE
             , IA.MODEL_ID
             , IA.MODEL_ID_NICK_NAME                                AS NICK_NAME
             , IA.CELL_TYPE
             , A.USER_ID
             , NVL(A.VALID_YN, 'Y')                                 AS VALID_YN
             /* 2026.09.30 AJS 수정 (START) */
--             , CASE WHEN V_LANGUAGE = 'KO' THEN C.USERNAME
--                    ELSE C.USERNAME_E END                           AS USER_NAME
             , CASE WHEN V_LANGUAGE = 'KO' THEN C.USER_NM
                    ELSE C.USER_ENG_NM END                          AS USER_NAME
             /* 2026.09.30 AJS 수정 (END) */
             , A.PART_LEADER
             /* 원문은 KO 가 아닐 때 담당자(U) 의 영문 이름을 쓴다 — 원문 그대로 둔다 */
             /* 2026.09.30 AJS 수정 (START) */
--             , CASE WHEN V_LANGUAGE = 'KO' THEN D.USERNAME
--                    ELSE C.USERNAME_E END                           AS PART_LEADER_NAME
             , CASE WHEN V_LANGUAGE = 'KO' THEN D.USER_NM
                    ELSE C.USER_ENG_NM END                          AS PART_LEADER_NAME
             /* 2026.09.30 AJS 수정 (END) */
             , A.TEAM_LEADER
             /* 2026.09.30 AJS 수정 (START) */
--             , CASE WHEN V_LANGUAGE = 'KO' THEN E.USERNAME
--                    ELSE C.USERNAME_E END                           AS TEAM_LEADER_NAME
             , CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM
                    ELSE C.USER_ENG_NM END                          AS TEAM_LEADER_NAME
             /* 2026.09.30 AJS 수정 (END) */
             /* 이름을 못 찾으면 AS-IS 는 이어붙인 값 전체가 값 없음이 된다 — 같게 맞춘다 */
             /* 2026.09.30 AJS 수정 (START) */
--             , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN F.USERNAME
--                               ELSE F.USERNAME_E END) IS NULL
             , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN F.USER_NM
                               ELSE F.USER_ENG_NM END) IS NULL
             /* 2026.09.30 AJS 수정 (END) */
                    THEN NULL
                    /* 2026.09.30 AJS 수정 (START) */
--                    ELSE (CASE WHEN V_LANGUAGE = 'KO' THEN F.USERNAME
--                               ELSE F.USERNAME_E END) || '(' || A.CREATED_BY || ')' END
                    ELSE (CASE WHEN V_LANGUAGE = 'KO' THEN F.USER_NM
                               ELSE F.USER_ENG_NM END) || '(' || A.CREATED_BY || ')' END
                    /* 2026.09.30 AJS 수정 (END) */
                                                                    AS CREATED_BY
             , A.CREATION_DATE
             /* 2026.09.30 AJS 수정 (START) */
--             , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN G.USERNAME
--                               ELSE G.USERNAME_E END) IS NULL
             , CASE WHEN (CASE WHEN V_LANGUAGE = 'KO' THEN G.USER_NM
                               ELSE G.USER_ENG_NM END) IS NULL
             /* 2026.09.30 AJS 수정 (END) */
                    THEN NULL
                    /* 2026.09.30 AJS 수정 (START) */
--                    ELSE (CASE WHEN V_LANGUAGE = 'KO' THEN G.USERNAME
--                               ELSE G.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')' END
                    ELSE (CASE WHEN V_LANGUAGE = 'KO' THEN G.USER_NM
                               ELSE G.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')' END
                    /* 2026.09.30 AJS 수정 (END) */
                                                                    AS LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_MST_MODEL_USER_EE A
             , SCM_MST_SITE B
             , (SELECT XA.SEGMENT5                   AS DIVISION_ID
                     , XA.ATTRIBUTE1                 AS TO_SITE
                     , XB.ITEM_ID                    AS ITEM_ID
                     , MAX(XB.MODEL_ID)              AS MODEL_ID
                     , MAX(XB.MODEL_ID_NICK_NAME)    AS MODEL_ID_NICK_NAME
                     , MAX(XB.CELL_TYPE)             AS CELL_TYPE
                     , MAX(XB.ELECTRODE_TYPE)        AS ELECTRODE_TYPE
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                     , SSP_MST_SITE_ITEM_EE_V XB
                 WHERE XB.DIVISION_ID(+) = XA.SEGMENT2
                   AND XB.SCM_SITE_ID(+) = XA.SEGMENT3
                   AND XA.LOOKUP_TYPE    = 'ELECTRODE_SHIP_FROM_TO'
                   AND UPPER(XA.VALID_YN) = 'Y'   /* 원장에 소문자 y 가 섞여 있고 AS-IS 는 대소문자를 가리지 않는다 */
                 GROUP BY XB.ITEM_ID
                        , XA.SEGMENT5
                        , XA.ATTRIBUTE1) IA
             /* 2026.09.30 AJS 수정 (START) */
--             , TB_FX_USER C
--             , TB_FX_USER D
--             , TB_FX_USER E
--             , TB_FX_USER F
--             , TB_FX_USER G
             , SCM_ADM_USER_M C
             , SCM_ADM_USER_M D
             , SCM_ADM_USER_M E
             , SCM_ADM_USER_M F
             , SCM_ADM_USER_M G
             /* 2026.09.30 AJS 수정 (END) */
         WHERE B.DIVISION_ID   = A.DIVISION_ID
           AND B.SCM_SITE_ID   = A.TO_SITE
           AND IA.DIVISION_ID(+) = A.DIVISION_ID
           AND IA.TO_SITE(+)     = A.TO_SITE
           AND IA.ITEM_ID(+)     = A.ITEM_ID
           /* 2026.09.30 AJS 수정 (START) */
--           AND C.USERID(+)       = A.USER_ID
--           AND D.USERID(+)       = A.PART_LEADER
--           AND E.USERID(+)       = A.TEAM_LEADER
--           AND F.USERID(+)       = A.CREATED_BY
--           AND G.USERID(+)       = A.LAST_UPDATED_BY
           AND C.USER_ID(+)      = A.USER_ID
           AND D.USER_ID(+)      = A.PART_LEADER
           AND E.USER_ID(+)      = A.TEAM_LEADER
           AND F.USER_ID(+)      = A.CREATED_BY
           AND G.USER_ID(+)      = A.LAST_UPDATED_BY
           /* 2026.09.30 AJS 수정 (END) */
           AND (UPPER(V_DIVISION_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID = V_DIVISION_ID)
           AND (TRIM(V_PLANT_SITE) IS NULL
            OR  UPPER(V_PLANT_SITE) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  A.TO_SITE IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_PLANT_SITE, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                            /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
           AND (TRIM(V_NICK_NAME) IS NULL
            OR  UPPER(V_NICK_NAME) = 'ALL'                          /* 조회조건 ALL 은 조건 없음 */
            OR  IA.MODEL_ID_NICK_NAME IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(V_NICK_NAME, ','))))
           AND (TRIM(V_MODEL_ID) IS NULL
            OR  UPPER(V_MODEL_ID) = 'ALL'                           /* 조회조건 ALL 은 조건 없음 */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--          OR  IA.MODEL_ID IN (SELECT COLUMN_VALUE
--                                FROM TABLE(STRING_SPLIT(V_MODEL_ID, ','))))
            OR  EXISTS (SELECT 1
                          FROM TABLE(STRING_SPLIT(V_MODEL_ID, ',')) SZ
                         WHERE TRIM(SZ.COLUMN_VALUE) IS NOT NULL
                           AND ( UPPER(IA.MODEL_ID) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%'
                              OR UPPER(IA.MODEL_ID_NICK_NAME) LIKE '%' || UPPER(TRIM(SZ.COLUMN_VALUE)) || '%' )))
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.TO_SITE) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.USER_ID) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0025_GET_SHIPMENT_REQUESTOR_PIC;

/****************************************************************************************************/
/* Program ID  : P_SSP0025_GET_ITEM_BY_DIVISION_POPUP                                               */
/* Description : Material 조회                                                                      */
/****************************************************************************************************/
PROCEDURE P_SSP0025_GET_ITEM_BY_DIVISION_POPUP
(
    P_DIVISION_ID       IN  CLOB
  , P_FROM_SITE_ID      IN  CLOB
  , P_TO_SITE_ID        IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_MODEL_ID          IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,  1, 4000));
    V_FROM_SITE_ID      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_FROM_SITE_ID, 1, 4000));
    V_TO_SITE_ID        VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_TO_SITE_ID,   1, 4000));
    V_ITEM_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,      1, 4000));
    V_MODEL_ID          VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_MODEL_ID,     1, 4000));

BEGIN

    OPEN O_RC1 FOR
--        SELECT A.DIVISION_ID                AS DIVISION_ID   --  2026.10.06 AJS
        SELECT /*+ USE_HASH(D) */ A.DIVISION_ID                AS DIVISION_ID   --  2026.10.06 AJS
             , A.SCM_SITE_ID                AS FROM_SITE_CODE
             , B.SITE_DESCRIPTION           AS FROM_SITE
             , A.ITEM_ID                    AS ITEM_ID
             , A.MODEL_ID                   AS MODEL_ID
             , A.CELL_TYPE                  AS CELL_TYPE
             , A.ITEM_ID_NICK_NAME          AS NICK_NAME
             , A.ELECTRODE_TYPE             AS ELECTRODE_TYPE
             , A.ITEM_UOM                   AS ITEM_UOM
             , A.UOM_CONVERT_IN_TACT_TIME   AS UOM_CONVERT_IN_TACT_TIME
             , C.SEGMENT5                   AS TO_DIVISION_ID
             , C.ATTRIBUTE1                 AS TO_SITE_CODE
             , D.SITE_DESCRIPTION           AS TO_SITE
          FROM SSP_MST_SITE_ITEM_EE_V A
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
             , SCM_MST_SITE D
         WHERE B.DIVISION_ID    = A.DIVISION_ID
           AND B.SCM_SITE_ID    = A.SCM_SITE_ID
           AND C.SEGMENT2(+)    = A.DIVISION_ID
           AND C.SEGMENT3(+)    = A.SCM_SITE_ID
           AND C.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'
           AND D.DIVISION_ID(+) = C.SEGMENT5
           AND D.SCM_SITE_ID(+) = C.ATTRIBUTE1
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            -- 2026.10.06 AJS 사업부 조건을 문자열 비교로 바꿔 뷰 안으로 넣음 (결과 동일) (START)
--            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
--                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
            OR  INSTR(',' || REGEXP_REPLACE(TRIM(V_DIVISION_ID), ' *, *', ',') || ',', ',' || A.DIVISION_ID || ',') > 0)
            -- 2026.10.06 AJS 사업부 조건을 문자열 비교로 바꿔 뷰 안으로 넣음 (결과 동일) (END)
           AND (TRIM(V_FROM_SITE_ID) IS NULL
            OR  UPPER(V_FROM_SITE_ID) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  B.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(STRING_SPLIT(V_FROM_SITE_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                            /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
           AND (TRIM(V_MODEL_ID) IS NULL
            OR  UPPER(V_MODEL_ID) = 'ALL'                           /* 조회조건 ALL 은 조건 없음 */
            OR  A.MODEL_ID IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_MODEL_ID, ','))))
           AND (TRIM(V_TO_SITE_ID) IS NULL
            OR  UPPER(V_TO_SITE_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  C.ATTRIBUTE1 IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(V_TO_SITE_ID, ','))))
         /* 원문 정렬 키만으로는 같은 값이 많아 차례가 흔들린다 — 뒤에 원장 열쇠를 더한다 */
         ORDER BY FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(B.SCM_SITE_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(B.SITE_DESCRIPTION) NULLS FIRST
                , FN_ASIS_SORT_KEY(C.SEGMENT5) NULLS FIRST
                , FN_ASIS_SORT_KEY(C.ATTRIBUTE1) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0025_GET_ITEM_BY_DIVISION_POPUP;

/****************************************************************************************************/
/* Program ID  : P_SSP0025_GET_USER_ID_CHECK                                                        */
/* Description : Shipment Plan Model PIC UserID Check                                               */
/****************************************************************************************************/
PROCEDURE P_SSP0025_GET_USER_ID_CHECK
(
    P_USER_ID           IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    V_USER_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

BEGIN

    OPEN O_RC1 FOR
        /* 2026.09.30 AJS 수정 (START) */
--        SELECT USERID      AS USER_ID
--          FROM TB_FX_USER
--         WHERE USERID IN (SELECT COLUMN_VALUE
        SELECT USER_ID
          FROM SCM_ADM_USER_M
         WHERE USER_ID IN (SELECT COLUMN_VALUE
        /* 2026.09.30 AJS 수정 (END) */
                            FROM TABLE(STRING_SPLIT(V_USER_ID, '^')));

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SSP0025_GET_USER_ID_CHECK;

/****************************************************************************************************/
/* Program ID  : P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC                                              */
/* Description : Shipment Requestor PIC 저장                                                        */
/****************************************************************************************************/
PROCEDURE P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_TO_SITE           IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_CREATE_ID         IN  CLOB
  , P_PART_LEADER       IN  CLOB
  , P_TEAM_LEADER       IN  CLOB
  , P_VALID_YN          IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    V_CREATE_ID         VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_CREATE_ID, 1, 4000));

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_TO_SITE           VARCHAR2(4000 CHAR);
    V_ITEM_ID           VARCHAR2(4000 CHAR);
    V_USER_ID           VARCHAR2(4000 CHAR);
    V_PART_LEADER       VARCHAR2(4000 CHAR);
    V_TEAM_LEADER       VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);

    N_MAX_LOOP_CNT      NUMBER(10) := 0;
    N_MST_LOOP_CNT      NUMBER(10) := 0;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC';
    V_LOG_TYPE          VARCHAR2(30 CHAR);      /* START/END/ERROR/... */
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;

    V_SQLCODE           NUMBER;
    V_SQLERRM           VARCHAR2(4000 CHAR);

BEGIN

    SAVEPOINT SP_SSP0025_SAVE;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 프로시저 LOOP 길이를 판단 */
    N_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    WHILE N_MST_LOOP_CNT < N_MAX_LOOP_CNT
    LOOP

        /* @mst_loop_cnt 1증가 */
        N_MST_LOOP_CNT := N_MST_LOOP_CNT + 1;

        /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
        V_ACTIVE_FLAG := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG, C_DELIMITER, N_MST_LOOP_CNT);
        V_DIVISION_ID := SCM_ARR_SPL_VAL(P_DIVISION_ID, C_DELIMITER, N_MST_LOOP_CNT);
        V_TO_SITE     := SCM_ARR_SPL_VAL(P_TO_SITE,     C_DELIMITER, N_MST_LOOP_CNT);
        V_ITEM_ID     := SCM_ARR_SPL_VAL(P_ITEM_ID,     C_DELIMITER, N_MST_LOOP_CNT);
        V_USER_ID     := SCM_ARR_SPL_VAL(P_USER_ID,     C_DELIMITER, N_MST_LOOP_CNT);
        V_PART_LEADER := SCM_ARR_SPL_VAL(P_PART_LEADER, C_DELIMITER, N_MST_LOOP_CNT);
        V_TEAM_LEADER := SCM_ARR_SPL_VAL(P_TEAM_LEADER, C_DELIMITER, N_MST_LOOP_CNT);
        V_VALID_YN    := SCM_ARR_SPL_VAL(P_VALID_YN,    C_DELIMITER, N_MST_LOOP_CNT);

        /* 데이터 저장 — 원문은 MERGE 한 문장이나 온라인 SQL 에서 쓰지 않는 규칙이라 두 문장으로 나눈다 */
        IF N_MST_LOOP_CNT > 0
        THEN

            UPDATE SSP_MST_MODEL_USER_EE
               SET USER_ID          = V_USER_ID
                 , VALID_YN         = V_VALID_YN
                 , PART_LEADER      = V_PART_LEADER
                 , TEAM_LEADER      = V_TEAM_LEADER
                 , LAST_UPDATED_BY  = V_CREATE_ID
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID = V_DIVISION_ID
               AND TO_SITE     = V_TO_SITE
               AND ITEM_ID     = V_ITEM_ID;

            IF SQL%ROWCOUNT = 0
            THEN

                INSERT INTO SSP_MST_MODEL_USER_EE
                            ( DIVISION_ID
                            , TO_SITE
                            , ITEM_ID
                            , USER_ID
                            , VALID_YN
                            , PART_LEADER
                            , TEAM_LEADER
                            , CREATED_BY
                            , CREATION_DATE
                            , LAST_UPDATED_BY
                            , LAST_UPDATE_DATE )
                     VALUES ( V_DIVISION_ID
                            , V_TO_SITE
                            , V_ITEM_ID
                            , V_USER_ID
                            , V_VALID_YN
                            , V_PART_LEADER
                            , V_TEAM_LEADER
                            , V_CREATE_ID
                            , SYSDATE
                            , V_CREATE_ID
                            , SYSDATE );

            END IF;

        END IF;   /* END OF STMT. IF( @mst_loop_cnt > 0 ) */

    END LOOP;     /* END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;

    PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
    OPEN O_RC1 FOR
        SELECT 'S'              AS RESULT_CODE
             , N_MAX_LOOP_CNT   AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS
    THEN

        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK TO SP_SSP0025_SAVE;    /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    ( PROGRAM_NAME
                    , LOG_TYPE
                    , LOG_COUNT
                    , LOG_MESSAGE
                    , DESCRIPTION
                    , EVENT_DATE
                    , CREATION_DATE
                    , CREATED_BY
                    , LAST_UPDATE_DATE
                    , LAST_UPDATED_BY )
             VALUES ( V_PROGRAM_NAME
                    , 'ERROR'
                    , NULL
                    , V_SQLERRM
                    , NULL
                    , SYSDATE
                    , SYSDATE
                    , V_PROGRAM_NAME
                    , SYSDATE
                    , V_PROGRAM_NAME );

        COMMIT;

        /* error코드, errror 메시지 반환 */
        OPEN O_RC1 FOR
            SELECT 'F'  AS RESULT_CODE
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || V_SQLERRM    AS ERR_MESSAGE
              FROM DUAL;

END P_SSP0025_SAVE_SHIPMENT_REQUESTOR_PIC;

END PKG_SSP0025;