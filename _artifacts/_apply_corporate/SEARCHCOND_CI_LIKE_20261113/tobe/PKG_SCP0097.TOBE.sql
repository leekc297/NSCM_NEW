-- SOURCE-FRESH: SCM_MGR.PKG_SCP0097 PACKAGE BODY LAST_DDL=2026-10-09 13:38:44 FETCHED=2026-11-13 10:45:19 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY PKG_SCP0097
IS
    /*
     * Program ID   : PKG_SCP0097
     * Description  : SCP0097 SCP BOM Elec 화면 - 전극 BOM 조회 / 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2023/02/16       jahn1501        PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  Initial Release
     * 2023/03/06       vadabi3         PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  [컬럼제거 : PLANT_ID, 컬럼추가 : ELECTRODE_TYPE]
     * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          P_SCP0097_GET_SCP_BOM_ELEC 조회 속도 개선 - 품목 별칭 조회를 품목마다 1회로 변경(결과 동일)
     */

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(32767 CHAR) INDEX BY PLS_INTEGER;

    /* ==============================================================================================
       내부 : 구분자로 문자열을 나눈다 (AS-IS UF_FX_String_Split 과 같은 규칙 · CLOB 대응)
              - 구분자를 찾을 때마다 앞부분을 앞뒤 공백 제거해 담고, 마지막 남은 부분도 담는다
              - 입력이 비어 있으면 AS-IS 도 빈 값 한 자리를 돌려주므로 한 자리를 담는다
                (Oracle 로 이관된 UF_FX_STRING_SPLIT 은 이 경우 0 행이라 AS-IS 와 갈린다)
       ============================================================================================== */
    PROCEDURE P_SPL_ARR
    (
        P_TEXT              IN  CLOB,
        O_TOKEN             OUT T_TOKEN_TAB
    )
    IS
        V_NR                PLS_INTEGER := 0;
        V_OFF               PLS_INTEGER := 1;
        V_POS               PLS_INTEGER;
        V_LEN               PLS_INTEGER;
    BEGIN
        V_LEN := NVL(DBMS_LOB.GETLENGTH(P_TEXT), 0);

        IF V_LEN = 0 THEN
            O_TOKEN(1) := NULL;
            RETURN;
        END IF;

        LOOP
            V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, V_OFF, 1);

            EXIT WHEN V_POS = 0;

            V_NR := V_NR + 1;

            IF V_POS > V_OFF THEN
                O_TOKEN(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_POS - V_OFF, V_OFF));
            ELSE
                O_TOKEN(V_NR) := NULL;
            END IF;

            V_OFF := V_POS + 1;
        END LOOP;

        V_NR := V_NR + 1;

        IF V_OFF <= V_LEN THEN
            O_TOKEN(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_LEN - V_OFF + 1, V_OFF));
        ELSE
            O_TOKEN(V_NR) := NULL;
        END IF;
    END P_SPL_ARR;

    /* ==============================================================================================
       SCP0097_GET_SCP_BOM_ELEC : SCP BOM ELEC 조회
       ============================================================================================== */
    PROCEDURE P_SCP0097_GET_SCP_BOM_ELEC
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_PARENT_ID         IN  VARCHAR2,
        P_CHILD_ID          IN  VARCHAR2,
        P_DEBUG_MODE        IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MESSAGE       VARCHAR2(1000 CHAR);
    BEGIN

        /* 상위 · 하위 품목 이름은 품목 원장의 별칭을 쓰고, 값이 없으면 '-' 로 채운다
           (AS-IS ISNULL(NULLIF(NICK_NAME,''),'-') - 옛 시스템은 공백만 있는 값도 빈 값으로 본다) */
        OPEN O_RC1 FOR
        -- 2026.10.06 AJS 품목 별칭 조회를 품목마다 1회로 변경 (START)
--        SELECT A.DIVISION_ID
--             , A.PARENT_ITEM_ID
--             , (
--                    SELECT NVL(TRIM(SA.NICK_NAME), '-')
--                      FROM SCM_MST_ITEM_SN SA
--                     WHERE SA.DIVISION_ID = A.DIVISION_ID
--                       AND SA.ITEM_ID     = A.PARENT_ITEM_ID
--                       AND ROWNUM         = 1
--               ) AS PARENT_ITEM_NAME
--             , A.CHILD_ITEM_ID
--             , (
--                    SELECT NVL(TRIM(SA.NICK_NAME), '-')
--                      FROM SCM_MST_ITEM_SN SA
--                     WHERE SA.DIVISION_ID = A.DIVISION_ID
--                       AND SA.ITEM_ID     = A.CHILD_ITEM_ID
--                       AND ROWNUM         = 1
--               ) AS CHILD_ITEM_NAME
--             , ROUND(A.USAGE, 3) AS USAGE
--             , A.SCP_YN
--             , A.STOCK_SUM
--             , A.ELECTRODE_TYPE
--             , A.CREATED_BY
--             , A.CREATION_DATE
--             , A.LAST_UPDATED_BY
--             , A.LAST_UPDATE_DATE
--          FROM SCP_MST_BOM_ELEC A
--         /* 옛 시스템은 대문자 · 소문자를 가리지 않고 비교한다.
--            사업부 · 상위 품목 · 하위 품목 칸에는 소문자 값이 없으므로(실측 0 건)
--            입력값만 대문자로 올려 맞춘다 - 칸에 함수를 씌우지 않아 인덱스를 그대로 쓴다 */
--         WHERE 1 = 1
--           AND A.DIVISION_ID = UPPER(P_DIVISION_ID)
--           AND (
--                   TRIM(P_PARENT_ID) IS NULL
--                OR A.PARENT_ITEM_ID IN (
--                                           SELECT UPPER(TOKEN)
--                                             FROM TABLE(UF_FX_STRING_SPLIT(P_PARENT_ID, ','))
--                                       )
--               )
--           AND (
--                   TRIM(P_CHILD_ID) IS NULL
--                OR A.CHILD_ITEM_ID IN (
--                                          SELECT UPPER(TOKEN)
--                                            FROM TABLE(UF_FX_STRING_SPLIT(P_CHILD_ID, ','))
--                                      )
--               )
--         /* 옛 시스템 정렬은 하이픈을 빼고 비교하므로 하이픈을 없앤 값을 첫 열쇠로 둔다
--            (하이픈을 없앤 값이 같아지는 자리를 위해 원래 값을 뒤 열쇠로 둔다) */
--         ORDER BY A.DIVISION_ID
--                , REPLACE(A.PARENT_ITEM_ID, '-', '')
--                , A.PARENT_ITEM_ID
--                , A.ELECTRODE_TYPE
--                , REPLACE(A.CHILD_ITEM_ID, '-', '')
--                , A.CHILD_ITEM_ID;
        /* 원래는 행마다 상위 · 하위 품목 별칭을 각각 품목 원장에서 찾았다(사업부 40 : 19,032 행 × 2 회).
           같은 조회조건의 상위 품목 목록(B) · 하위 품목 목록(C)을 중복 없이 만든 뒤 품목마다 1 회만 찾아 붙인다.
           - 찾는 식(첫 행의 NVL(TRIM(NICK_NAME), '-'))은 원래와 같다. 원장 열쇠 앞자리(품목) 인덱스로 찾는다
           - 사업부 · 품목이 같은 원장 행의 별칭은 모두 같다(2026.10.06 실측 : 다른 값 0 건)
           - B · C 는 A 와 같은 조건으로 만들므로 A 의 모든 행이 B · C 와 한 행씩 이어진다 */
        SELECT A.DIVISION_ID
             , A.PARENT_ITEM_ID
             , B.NICK_NAME AS PARENT_ITEM_NAME
             , A.CHILD_ITEM_ID
             , C.NICK_NAME AS CHILD_ITEM_NAME
             , ROUND(A.USAGE, 3) AS USAGE
             , A.SCP_YN
             , A.STOCK_SUM
             , A.ELECTRODE_TYPE
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SCP_MST_BOM_ELEC A
             , (SELECT /*+ NO_MERGE */
                       IA.DIVISION_ID
                     , IA.ITEM_ID
                     , (
                            SELECT /*+ INDEX(SA PK_SCM_ITEM_M) */
                                   NVL(TRIM(SA.NICK_NAME), '-')
                              FROM SCM_MST_ITEM_SN SA
                             WHERE SA.DIVISION_ID = IA.DIVISION_ID
                               AND SA.ITEM_ID     = IA.ITEM_ID
                               AND ROWNUM         = 1
                       ) AS NICK_NAME
                  FROM (SELECT DISTINCT
                               XA.DIVISION_ID
                             , XA.PARENT_ITEM_ID AS ITEM_ID
                          FROM SCP_MST_BOM_ELEC XA
                         WHERE 1 = 1
                           AND XA.DIVISION_ID = UPPER(P_DIVISION_ID)
                           AND (
                                   TRIM(P_PARENT_ID) IS NULL
                                OR UPPER(XA.PARENT_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                                            SELECT UPPER(TOKEN)
                                                              FROM TABLE(UF_FX_STRING_SPLIT(P_PARENT_ID, ','))
                                                        )
                               )
                           AND (
                                   TRIM(P_CHILD_ID) IS NULL
                                OR UPPER(XA.CHILD_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                                           SELECT UPPER(TOKEN)
                                                             FROM TABLE(UF_FX_STRING_SPLIT(P_CHILD_ID, ','))
                                                       )
                               )
                       ) IA
               ) B
             , (SELECT /*+ NO_MERGE */
                       IA.DIVISION_ID
                     , IA.ITEM_ID
                     , (
                            SELECT /*+ INDEX(SA PK_SCM_ITEM_M) */
                                   NVL(TRIM(SA.NICK_NAME), '-')
                              FROM SCM_MST_ITEM_SN SA
                             WHERE SA.DIVISION_ID = IA.DIVISION_ID
                               AND SA.ITEM_ID     = IA.ITEM_ID
                               AND ROWNUM         = 1
                       ) AS NICK_NAME
                  FROM (SELECT DISTINCT
                               XA.DIVISION_ID
                             , XA.CHILD_ITEM_ID AS ITEM_ID
                          FROM SCP_MST_BOM_ELEC XA
                         WHERE 1 = 1
                           AND XA.DIVISION_ID = UPPER(P_DIVISION_ID)
                           AND (
                                   TRIM(P_PARENT_ID) IS NULL
                                OR UPPER(XA.PARENT_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                                            SELECT UPPER(TOKEN)
                                                              FROM TABLE(UF_FX_STRING_SPLIT(P_PARENT_ID, ','))
                                                        )
                               )
                           AND (
                                   TRIM(P_CHILD_ID) IS NULL
                                OR UPPER(XA.CHILD_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                                           SELECT UPPER(TOKEN)
                                                             FROM TABLE(UF_FX_STRING_SPLIT(P_CHILD_ID, ','))
                                                       )
                               )
                       ) IA
               ) C
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.ITEM_ID     = A.PARENT_ITEM_ID
           AND C.DIVISION_ID = A.DIVISION_ID
           AND C.ITEM_ID     = A.CHILD_ITEM_ID
           AND A.DIVISION_ID = UPPER(P_DIVISION_ID)
           AND (
                   TRIM(P_PARENT_ID) IS NULL
                OR UPPER(A.PARENT_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                           SELECT UPPER(TOKEN)
                                             FROM TABLE(UF_FX_STRING_SPLIT(P_PARENT_ID, ','))
                                       )
               )
           AND (
                   TRIM(P_CHILD_ID) IS NULL
                OR UPPER(A.CHILD_ITEM_ID) IN (   /* 2026.11.13 조회조건 대소문자 무시 */
                                          SELECT UPPER(TOKEN)
                                            FROM TABLE(UF_FX_STRING_SPLIT(P_CHILD_ID, ','))
                                      )
               )
         /* 옛 시스템 정렬은 하이픈을 빼고 비교하므로 하이픈을 없앤 값을 첫 열쇠로 둔다
            (하이픈을 없앤 값이 같아지는 자리를 위해 원래 값을 뒤 열쇠로 둔다) */
         ORDER BY A.DIVISION_ID
                , REPLACE(A.PARENT_ITEM_ID, '-', '')
                , A.PARENT_ITEM_ID
                , A.ELECTRODE_TYPE
                , REPLACE(A.CHILD_ITEM_ID, '-', '')
                , A.CHILD_ITEM_ID;
        -- 2026.10.06 AJS 품목 별칭 조회를 품목마다 1회로 변경 (END)

        OPEN O_RESULT_CURSOR FOR
        SELECT 'S' AS RESULT_CODE
             , NULL AS RESULT_MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* 오류 내용은 변수로 받는다 (SQLERRM 은 SQL 문 안에서 바로 쓸 수 없다) */
            V_ERR_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            IF O_RC1 IS NOT NULL AND O_RC1%ISOPEN THEN
                CLOSE O_RC1;
            END IF;

            OPEN O_RC1 FOR
            SELECT NULL AS DIVISION_ID
                 , NULL AS PARENT_ITEM_ID
                 , NULL AS PARENT_ITEM_NAME
                 , NULL AS CHILD_ITEM_ID
                 , NULL AS CHILD_ITEM_NAME
                 , NULL AS USAGE
                 , NULL AS SCP_YN
                 , NULL AS STOCK_SUM
                 , NULL AS ELECTRODE_TYPE
                 , NULL AS CREATED_BY
                 , NULL AS CREATION_DATE
                 , NULL AS LAST_UPDATED_BY
                 , NULL AS LAST_UPDATE_DATE
              FROM DUAL
             WHERE 1 = 2;

            OPEN O_RESULT_CURSOR FOR
            SELECT 'F' AS RESULT_CODE
                 , V_ERR_MESSAGE AS RESULT_MSG
              FROM DUAL;

    END P_SCP0097_GET_SCP_BOM_ELEC;

    /* ==============================================================================================
       SCP0097_SAVE_SCP_BOM_ELEC : SCP BOM ELEC 저장
       ============================================================================================== */
    PROCEDURE P_SCP0097_SAVE_SCP_BOM_ELEC
    (
        P_ACTIVE_FLAG       IN  CLOB,
        P_DIVISION_ID       IN  CLOB,
        P_PARENT_ITEM_ID    IN  CLOB,
        P_CHILD_ITEM_ID     IN  CLOB,
        P_SCP_YN            IN  CLOB,
        P_STOCK_YN          IN  CLOB,
        P_USER_ID           IN  VARCHAR2,
        P_DEBUG_MODE        IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0097_SAVE_SCP_BOM_ELEC';
        V_LOG_TYPE          VARCHAR2(30 CHAR);          /* START/END/ERROR/... */
        N_LOG_COUNT         NUMBER(10)         := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        /* 결과 반환 변수 설정 */
        V_MOD_CNT           NUMBER(10)         := 0;

        V_DIVISION_ID       T_TOKEN_TAB;
        V_PARENT_ITEM_ID    T_TOKEN_TAB;
        V_CHILD_ITEM_ID     T_TOKEN_TAB;
        V_SCP_YN            T_TOKEN_TAB;
        V_STOCK_YN          T_TOKEN_TAB;

        V_SCP_YN_ALL        VARCHAR2(32767 CHAR);
        V_ERR_MESSAGE       VARCHAR2(1000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0097_SAVE;

        /* LOG start */
        V_LOG_TYPE          := 'START';
        V_LOG_MESSAGE       := '########## Start of procedure ##########';
        V_DESCRIPTION       := '';
        D_EVENT_DATE        := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 화면이 행별 값을 '^' 로 이어 보내므로 인자마다 같은 자리끼리 짝지어 처리한다
           (AS-IS 는 다섯 인자를 나눈 뒤 자리 번호로 이어 붙인다 - 어느 하나에 없는 자리는 제외) */
        P_SPL_ARR(P_DIVISION_ID,    V_DIVISION_ID);
        P_SPL_ARR(P_PARENT_ITEM_ID, V_PARENT_ITEM_ID);
        P_SPL_ARR(P_CHILD_ITEM_ID,  V_CHILD_ITEM_ID);
        P_SPL_ARR(P_SCP_YN,         V_SCP_YN);
        P_SPL_ARR(P_STOCK_YN,       V_STOCK_YN);

        /* AS-IS 는 보낸 값 전체(@p_scp_yn)를 그대로 비교에 쓴다 - 원문 그대로 둔다 */
        V_SCP_YN_ALL := DBMS_LOB.SUBSTR(P_SCP_YN, 32767, 1);

        FOR I IN 1 .. V_DIVISION_ID.COUNT LOOP

            IF  V_PARENT_ITEM_ID.EXISTS(I)
            AND V_CHILD_ITEM_ID.EXISTS(I)
            AND V_SCP_YN.EXISTS(I)
            AND V_STOCK_YN.EXISTS(I) THEN

                V_MOD_CNT := V_MOD_CNT + 1;

                /* 저장 열쇠도 옛 시스템은 대문자 · 소문자를 가리지 않고 찾는다.
                   세 칸 모두 소문자 값이 없으므로(실측 0 건) 보낸 값만 대문자로 올려 맞춘다.
                   저장되는 값 자체는 보낸 그대로 둔다(옛 시스템도 바꾸지 않는다) */
                UPDATE SCP_MST_BOM_ELEC
                   SET SCP_YN           = V_SCP_YN(I)
                     , STOCK_SUM        = V_STOCK_YN(I)
                     , ATTRIBUTE5       = (CASE WHEN SCP_YN <> UPPER(V_SCP_YN_ALL) THEN 'Y' ELSE '' END)
                     , LAST_UPDATED_BY  = P_USER_ID
                     , LAST_UPDATE_DATE = SYSDATE
                 WHERE DIVISION_ID    = UPPER(V_DIVISION_ID(I))
                   AND PARENT_ITEM_ID = UPPER(V_PARENT_ITEM_ID(I))
                   AND CHILD_ITEM_ID  = UPPER(V_CHILD_ITEM_ID(I));

            END IF;

        END LOOP;

        /* LOG end */
        V_LOG_TYPE          := 'END';
        V_LOG_MESSAGE       := '########## END of procedure ##########';
        V_DESCRIPTION       := '';
        D_EVENT_DATE        := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT 'S' AS RESULT_CODE
             , V_MOD_CNT AS RESULT_CNT
             , NULL AS ERR_MESSAGE
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            ROLLBACK TO SP_SCP0097_SAVE;

            INSERT INTO SCM_SYS_LOG_BATCH
            (
                  PROGRAM_NAME
                , LOG_TYPE
                , LOG_COUNT
                , LOG_MESSAGE
                , DESCRIPTION
                , EVENT_DATE
                , CREATION_DATE
                , CREATED_BY
                , LAST_UPDATE_DATE
                , LAST_UPDATED_BY
            )
            VALUES
            (
                  V_PROGRAM_NAME
                , 'ERROR'
                , NULL
                , V_ERR_MESSAGE
                , NULL
                , SYSDATE
                , SYSDATE
                , V_PROGRAM_NAME
                , SYSDATE
                , V_PROGRAM_NAME
            );

            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
            SELECT 'F' AS RESULT_CODE
                 , 0 AS RESULT_CNT
                 , V_ERR_MESSAGE AS ERR_MESSAGE
              FROM DUAL;

    END P_SCP0097_SAVE_SCP_BOM_ELEC;

END PKG_SCP0097;
/
