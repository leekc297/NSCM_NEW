PACKAGE BODY         PKG_SYS0003_V2
AS

    PROCEDURE SYS0003_GET_LEVEL_THREE_DATA (
        P_MNU_ID        IN      VARCHAR2,
        P_LANG_CD       IN      VARCHAR2,
        O_CURSOR        OUT     SYS_REFCURSOR,
        O_RESULT_CURSOR OUT     SYS_REFCURSOR
    ) IS
        V_LEVEL_ONE_MNU_ID VARCHAR2(100);
    BEGIN

        SELECT  UPPR_MNU_ID
        INTO    V_LEVEL_ONE_MNU_ID
        FROM    SCM_ADM_MNU_M
        WHERE   MNU_LV_NO = 2
        AND     MNU_ID = P_MNU_ID
        ;

        OPEN O_CURSOR FOR
            SELECT  V_LEVEL_ONE_MNU_ID  AS LEVEL_ONE_MNU_ID
                  , P_MNU_ID            AS LEVEL_TWO_MNU_ID
                  , M.MNU_ID
                  , M.UPPR_MNU_ID
                  , M.MNU_URL
                  , M.ROUTE_PATH        -- V2: 화면 모듈 경로
                  , M.SYS_MNUL_URL
                  , M.MNU_MSG_ID
                  , MSG.MSG_NM          AS MNU_MSG_NM
                  , M.MNU_DESC
                  , M.SORT_ORD
                  , M.MNU_LV_NO
                  , M.MNU_TP_CD
                  , M.UNIT_TP_CD
                  , M.USE_YN
                  , M.N01_ATR_CTN
                  , M.N02_ATR_CTN
                  , M.N03_ATR_CTN
                  , M.N04_ATR_CTN
                  , M.N05_ATR_CTN
                  , M.N06_ATR_CTN
                  , M.N07_ATR_CTN
                  , M.N08_ATR_CTN
                  , M.N09_ATR_CTN
                  , M.N10_ATR_CTN
                  , M.CREATED_BY
                  , M.CREATION_DATE
                  , M.LAST_UPDATED_BY
                  , M.LAST_UPDATE_DATE
            FROM    SCM_ADM_MNU_M M
                LEFT JOIN SCM_ADM_MSG_M MSG
                    ON  1=1
                    AND MSG.MSG_TP_CD = 'MNU'
                    AND MSG.USE_YN = 'Y'
                    AND MSG.LANG_CD = P_LANG_CD
                    AND MSG.MSG_ID = M.MNU_MSG_ID
            WHERE   MNU_LV_NO = 3
            AND     M.UPPR_MNU_ID = P_MNU_ID
            ORDER BY SORT_ORD
            ;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;

        EXCEPTION
            WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
                ' / SQLERRM=' || SQLERRM ||
                ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                ' / PARAMS=' || '-' );

    END SYS0003_GET_LEVEL_THREE_DATA;

    PROCEDURE SYS0003_SAVE_LEVEL_THREE_DATA(
        P_DATA          IN      CLOB,
        P_USER_ID       IN      VARCHAR2,
        O_RESULT_CURSOR OUT     SYS_REFCURSOR
    ) IS
        V_ROW_CNT       NUMBER := 0;
        V_ERR_MSG       VARCHAR2(4000);
    BEGIN

        -- DELETE
        DELETE
        FROM    SCM_ADM_MNU_M
        WHERE   MNU_ID IN (
            SELECT TRIM(V_MNU_ID)
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE         VARCHAR2(200) PATH '$.CRUD_TYPE',
                    V_MNU_ID            VARCHAR2(200) PATH '$.MNU_ID'
                ))
            WHERE V_CRUD_TYPE = 'D'
        );

        V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

        -- MERGE (V2: ROUTE_PATH 추가)
        MERGE INTO SCM_ADM_MNU_M T
        USING (
            SELECT
              TRIM(V_CRUD_TYPE)    AS CRUD_TYPE,
              TRIM(V_MNU_ID)       AS MNU_ID,
              TRIM(V_LEVEL_TWO_MNU_ID) AS UPPR_MNU_ID,
              TRIM(V_MNU_MSG_ID)     AS MNU_MSG_ID,
              TRIM(V_MNU_DESC)       AS MNU_DESC,
              TRIM(V_MNU_URL)        AS MNU_URL,
              TRIM(V_ROUTE_PATH)     AS ROUTE_PATH,
              TRIM(V_MNU_TP_CD)        AS MNU_TP_CD,
              TRIM(V_UNIT_TP_CD)     AS UNIT_TP_CD,
              TRIM(V_SORT_ORD)       AS SORT_ORD,
              TRIM(V_USE_YN)       AS USE_YN
            FROM JSON_TABLE(P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE         VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_LEVEL_TWO_MNU_ID  VARCHAR2(200) PATH '$.LEVEL_TWO_MNU_ID',
                    V_MNU_ID            VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_MSG_ID        VARCHAR2(200) PATH '$.MNU_MSG_ID',
                    V_MNU_DESC          VARCHAR2(200) PATH '$.MNU_DESC',
                    V_MNU_URL           VARCHAR2(200) PATH '$.MNU_URL',
                    V_ROUTE_PATH        VARCHAR2(4000) PATH '$.ROUTE_PATH',
                    V_MNU_TP_CD         VARCHAR2(200) PATH '$.MNU_TP_CD',
                    V_UNIT_TP_CD        VARCHAR2(200) PATH '$.UNIT_TP_CD',
                    V_SORT_ORD          VARCHAR2(200) PATH '$.SORT_ORD',
                    V_USE_YN            VARCHAR2(1)   PATH '$.USE_YN'
                ))
            WHERE V_CRUD_TYPE IN ('I', 'M')
        ) M
        ON (T.MNU_ID = M.MNU_ID AND M.CRUD_TYPE = 'M')
        WHEN MATCHED THEN
            UPDATE SET  T.MNU_MSG_ID        = M.MNU_MSG_ID
                      , T.MNU_DESC          = M.MNU_DESC
                      , T.MNU_URL           = M.MNU_URL
                      , T.ROUTE_PATH        = M.ROUTE_PATH -- V2
                      , T.SORT_ORD          = M.SORT_ORD
                      , T.USE_YN            = M.USE_YN
                      , T.MNU_TP_CD         = M.MNU_TP_CD
                      , T.UNIT_TP_CD        = M.UNIT_TP_CD
                      , T.LAST_UPDATED_BY   = P_USER_ID
                      , T.LAST_UPDATE_DATE  = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (MNU_ID
                  , UPPR_MNU_ID
                  , MNU_URL
                  , ROUTE_PATH -- V2
                  , MNU_MSG_ID
                  , MNU_DESC
                  , SORT_ORD
                  , MNU_LV_NO
                  , MNU_TP_CD
                  , UNIT_TP_CD
                  , USE_YN
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE)
            VALUES (M.MNU_ID
                  , M.UPPR_MNU_ID
                  , M.MNU_URL
                  , M.ROUTE_PATH -- V2
                  , M.MNU_MSG_ID
                  , M.MNU_DESC
                  , M.SORT_ORD
                  , 3
                  , M.MNU_TP_CD
                  , M.UNIT_TP_CD
                  , M.USE_YN
                  , P_USER_ID
                  , SYSDATE
                  , P_USER_ID
                  , SYSDATE)
        ;

        V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    -- 메뉴 권한 자동 부여 (V1 동일)
    MERGE INTO SCM_ADM_USER_GR_MNU_MPG_M T
    USING (
        /* 1) POPUP 메뉴: 전체 그룹 권한 */
        SELECT DISTINCT
               G.USER_GR_ID
             , J.V_MNU_ID AS MNU_ID
        FROM SCM_ADM_USER_GR_M G
           , JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID',
                    V_MNU_TP_CD   VARCHAR2(200) PATH '$.MNU_TP_CD'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ( 'I' , 'M')
          AND TRIM(J.V_MNU_TP_CD) = 'POPUP'
          AND TRIM(J.V_MNU_ID) IS NOT NULL

        UNION ALL

        /* 2) 메뉴 타입 무관: ADMIN 항상 권한 */
        SELECT DISTINCT
               'ADMIN'      AS USER_GR_ID
             , J.V_MNU_ID   AS MNU_ID
        FROM JSON_TABLE(
                P_DATA, '$[*]'
                COLUMNS (
                    V_CRUD_TYPE   VARCHAR2(20)  PATH '$.CRUD_TYPE',
                    V_MNU_ID      VARCHAR2(200) PATH '$.MNU_ID'
                )
             ) J
        WHERE TRIM(J.V_CRUD_TYPE) IN ('I', 'M')
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    ) S
    ON (T.USER_GR_ID = S.USER_GR_ID AND T.MNU_ID = S.MNU_ID)
    WHEN MATCHED THEN
        UPDATE SET
              T.USE_YN           = 'Y'
            , T.LAST_UPDATED_BY  = P_USER_ID
            , T.LAST_UPDATE_DATE = SYSDATE
        WHERE NVL(T.USE_YN, 'N') <> 'Y'
    WHEN NOT MATCHED THEN
        INSERT (
              USER_GR_ID, MNU_ID, USE_YN
            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
        )
        VALUES (
              S.USER_GR_ID, S.MNU_ID, 'Y'
            , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        );

    /* 메뉴 삭제(D) 대상의 모든 그룹 권한 삭제 */
    DELETE FROM SCM_ADM_USER_GR_MNU_MPG_M T
    WHERE T.MNU_ID IN (
        SELECT DISTINCT J.V_MNU_ID
        FROM JSON_TABLE(
            P_DATA, '$[*]'
            COLUMNS (
                V_CRUD_TYPE VARCHAR2(20)  PATH '$.CRUD_TYPE',
                V_MNU_ID    VARCHAR2(200) PATH '$.MNU_ID'
            )
        ) J
        WHERE TRIM(J.V_CRUD_TYPE) = 'D'
          AND TRIM(J.V_MNU_ID) IS NOT NULL
    );

        COMMIT;

        OPEN O_RESULT_CURSOR FOR
             SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;

                IF SQLCODE = -1 THEN
                    V_ERR_MSG := 'Duplicate key error.';
                    OPEN O_RESULT_CURSOR FOR
                        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
                ELSIF SQLCODE = -1400 THEN
                    V_ERR_MSG := 'Required value is missing.';
                    OPEN O_RESULT_CURSOR FOR
                        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
                ELSIF SQLCODE = -12899 THEN
                    V_ERR_MSG := 'Maximum data size exceeded.';
                    OPEN O_RESULT_CURSOR FOR
                        SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;
                ELSE
                    RAISE_APPLICATION_ERROR(-20001,
                    '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
                    ' / SQLERRM=' || SQLERRM ||
                    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
                    ' / PARAMS=' || '-' );
                END IF;

    END SYS0003_SAVE_LEVEL_THREE_DATA;

END PKG_SYS0003_V2;