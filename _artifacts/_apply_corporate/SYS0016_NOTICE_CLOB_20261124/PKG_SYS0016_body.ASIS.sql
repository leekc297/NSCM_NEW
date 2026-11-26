
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_SYS0016" 
AS
    PROCEDURE P_SYS0016_GET_NOTICE_CONTENT_MASTER
    (
        P_MODULE         IN  VARCHAR2,
        P_SUB_MODULE     IN  VARCHAR2,
        P_ACTIVE_YN      IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        C_LANGUAGE_CODE CONSTANT VARCHAR2(4 CHAR) := 'EN';
        V_PROC_INPUT    VARCHAR2(4000 CHAR);
        V_BACKTRACE     VARCHAR2(4000 CHAR);
        V_SQL_CODE      VARCHAR2(100 CHAR);
        V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
        N_LOG_COUNT     PLS_INTEGER := 0;
    BEGIN
        OPEN O_RC1 FOR
            SELECT 
                   TO_CHAR(A.NOTICE_ID)                 AS NOTICE_ID,
                   A.MODULE_CODE                        AS MODULE,
                   A.MODULE_CODE                        AS MODULE_NM,
                   A.SUB_MODULE_CODE                    AS SUB_MODULE,
                   A.SUB_MODULE_CODE                    AS SUB_MODULE_NM,
                   A.NOTICE_TITLE                       AS NOTICE,
                   A.VALID_YN                           AS ACTIVE,
                   TO_CHAR(A.START_DATE, 'YYYY-MM-DD')  AS START_DATE,
                   TO_CHAR(A.END_DATE, 'YYYY-MM-DD')    AS END_DATE,
                   CASE
                       WHEN A.START_DATE IS NULL AND A.END_DATE IS NULL THEN NULL
                       ELSE NVL(TO_CHAR(A.START_DATE, 'YYYY-MM-DD'), '-')
                            || ' ~ '
                            || NVL(TO_CHAR(A.END_DATE, 'YYYY-MM-DD'), '-')
                   END                                  AS PUBLICATION_PERIOD,
                   A.POPUP_YN                           AS POPUP_YN,
                   A.CYCLE_CLASS_CODE                   AS POPUP_MAIN_CD,
                   A.CYCLE_CLASS_CODE                   AS POPUP_MAIN_NM,
                   A.DETAIL_CLASS_CODE                  AS POPUP_SUB1_CD,
                   A.DETAIL_CLASS_CODE                  AS POPUP_SUB1_NM,
                   A.SEND_TIME_TEXT                     AS POPUP_SUB2_CD,
                   A.SEND_TIME_TEXT                     AS POPUP_SUB2_NM,
                   B.NOTICE_TITLE                       AS NOTICE_TITLE,
                   B.NOTICE_CONTENT                     AS NOTICE_CONTENT,
                   B.NOTICE_IMAGE                       AS NOTICE_IMAGE,
                   F.ATCH_FILE_SAVE_NM                  AS IMAGE_FILE_NM,
                   CAST(NULL AS VARCHAR2(1))            AS IMAGE_DATA,
                   C.USER_NM                            AS CREATED_BY,
                   A.CREATION_DATE						AS CREATION_DATE,
                   CAST(NULL AS VARCHAR2(1))            AS ACTION
              FROM SCM_ADM_NOTICE_MASTER A
              LEFT OUTER JOIN SCM_ADM_NOTICE_CONTENT_MASTER B
                ON B.NOTICE_ID = A.NOTICE_ID
               AND B.LANGUAGE_CODE = C_LANGUAGE_CODE
              LEFT OUTER JOIN SCM_COM_ATCH_FILE_M F
                ON F.ATCH_FILE_ID = B.NOTICE_IMAGE
              LEFT OUTER JOIN SCM_ADM_USER_M C
                ON C.USER_ID = A.CREATED_BY
             WHERE (NVL(P_MODULE, 'ALL') = 'ALL'
                    OR A.MODULE_CODE IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_MODULE, ','))))
               AND (NVL(P_SUB_MODULE, 'ALL') = 'ALL' OR A.SUB_MODULE_CODE = P_SUB_MODULE)
               AND (NVL(P_ACTIVE_YN, 'ALL') = 'ALL' OR A.VALID_YN = P_ACTIVE_YN)
             ORDER BY A.MODULE_CODE, A.SUB_MODULE_CODE, A.CREATION_DATE DESC, A.NOTICE_ID DESC;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE,
                   'SUCCESS' AS MSG,
                   CAST(NULL AS VARCHAR2(1)) AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_PROC_INPUT := JSON_OBJECT(
                'P_MODULE' VALUE P_MODULE,
                'P_SUB_MODULE' VALUE P_SUB_MODULE,
                'P_ACTIVE_YN' VALUE P_ACTIVE_YN
            );
            V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            BEGIN
                SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                    $$PLSQL_UNIT,
                    'ERROR',
                    N_LOG_COUNT,
                    'EXCEPTION',
                    '',
                    SYSDATE,
                    V_PROC_INPUT,
                    V_SQL_CODE,
                    V_SQL_ERRMSG,
                    V_BACKTRACE
                );
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            RAISE_APPLICATION_ERROR(
                -20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE
                || ' / SQLERRM=' || V_SQL_ERRMSG
                || ' / BACKTRACE=' || V_BACKTRACE
                || ' / PARAMS=' || V_PROC_INPUT
            );
    END P_SYS0016_GET_NOTICE_CONTENT_MASTER;


    PROCEDURE P_SYS0016_SAVE_NOTICE_CONTENT_MASTER
    (
        P_DATA           IN  CLOB,
        P_USER_ID        IN  VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        V_SQL_CODE       VARCHAR2(100 CHAR);
        V_SQL_ERRMSG     VARCHAR2(1000 CHAR);
        V_BACKTRACE      VARCHAR2(4000 CHAR);
        V_AFFECTED       NUMBER := 0;
        V_USER           VARCHAR2(600 CHAR) := NVL(P_USER_ID, 'admin');
        V_NOTICE_ID      SCM_ADM_NOTICE_MASTER.NOTICE_ID%TYPE;
        V_OLD_FILE_ID    SCM_ADM_NOTICE_CONTENT_MASTER.NOTICE_IMAGE%TYPE;
        V_LANGUAGE_CODE  SCM_ADM_NOTICE_CONTENT_MASTER.LANGUAGE_CODE%TYPE;
    BEGIN
        FOR REC IN (
            SELECT JT.*
              FROM JSON_TABLE(
                       P_DATA,
                       '$[*]'
                       COLUMNS (
                           CRUD_TYPE       VARCHAR2(10)  PATH '$.CRUD_TYPE',
                           NOTICE_ID       NUMBER        PATH '$.NOTICE_ID',
                           MODULE          VARCHAR2(100) PATH '$.MODULE',
                           SUB_MODULE      VARCHAR2(100) PATH '$.SUB_MODULE',
                           NOTICE          VARCHAR2(500) PATH '$.NOTICE',
                           ACTIVE          VARCHAR2(4)   PATH '$.ACTIVE',
                           START_DATE      VARCHAR2(10)  PATH '$.START_DATE',
                           END_DATE        VARCHAR2(10)  PATH '$.END_DATE',
                           POPUP_YN        VARCHAR2(4)   PATH '$.POPUP_YN',
                           LANGUAGE_CODE   VARCHAR2(4)   PATH '$.LANGUAGE_CODE',
                           NOTICE_TITLE    VARCHAR2(500) PATH '$.NOTICE_TITLE',
                           NOTICE_CONTENT  CLOB          PATH '$.NOTICE_CONTENT',
                           NOTICE_IMAGE    VARCHAR2(50)  PATH '$.NOTICE_IMAGE'
                       )
                   ) JT
        ) LOOP
            V_LANGUAGE_CODE := NVL(REC.LANGUAGE_CODE, 'EN');
            V_OLD_FILE_ID := NULL;

            IF REC.CRUD_TYPE = 'I' THEN
                SELECT NVL(MAX(NOTICE_ID), 0) + 1
				INTO V_NOTICE_ID
				FROM SCM_ADM_NOTICE_MASTER;

                INSERT INTO SCM_ADM_NOTICE_MASTER
                (
                    NOTICE_ID,
                    MODULE_CODE,
                    SUB_MODULE_CODE,
                    NOTICE_TITLE,
                    VALID_YN,
                    START_DATE,
                    END_DATE,
                    POPUP_YN,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE
                )
                VALUES
                (
                    V_NOTICE_ID,
                    REC.MODULE,
                    REC.SUB_MODULE,
                    REC.NOTICE,
                    NVL(REC.ACTIVE, 'N'),
                    CASE
                        WHEN REC.START_DATE IS NULL THEN NULL
                        ELSE TO_DATE(REC.START_DATE, 'YYYY-MM-DD')
                    END,
                    CASE
                        WHEN REC.END_DATE IS NULL THEN NULL
                        ELSE TO_DATE(REC.END_DATE, 'YYYY-MM-DD')
                    END,
                    NVL(REC.POPUP_YN, 'N'),
                    V_USER,
                    SYSDATE,
                    V_USER,
                    SYSDATE
                );

                INSERT INTO SCM_ADM_NOTICE_CONTENT_MASTER
                (
                    NOTICE_ID,
                    LANGUAGE_CODE,
                    NOTICE_TITLE,
                    NOTICE_CONTENT,
                    NOTICE_IMAGE,
                    CREATED_BY,
                    CREATION_DATE,
                    LAST_UPDATED_BY,
                    LAST_UPDATE_DATE
                )
                VALUES
                (
                    V_NOTICE_ID,
                    V_LANGUAGE_CODE,
                    REC.NOTICE_TITLE,
                    REC.NOTICE_CONTENT,
                    REC.NOTICE_IMAGE,
                    V_USER,
                    SYSDATE,
                    V_USER,
                    SYSDATE
                );

                V_AFFECTED := V_AFFECTED + 1;

            ELSIF REC.CRUD_TYPE = 'M' THEN
                UPDATE SCM_ADM_NOTICE_MASTER
                   SET MODULE_CODE       = REC.MODULE,
                       SUB_MODULE_CODE   = REC.SUB_MODULE,
                       NOTICE_TITLE      = REC.NOTICE,
                       VALID_YN          = NVL(REC.ACTIVE, VALID_YN),
                       START_DATE        = CASE
                                               WHEN REC.START_DATE IS NULL THEN NULL
                                               ELSE TO_DATE(REC.START_DATE, 'YYYY-MM-DD')
                                           END,
                       END_DATE          = CASE
                                               WHEN REC.END_DATE IS NULL THEN NULL
                                               ELSE TO_DATE(REC.END_DATE, 'YYYY-MM-DD')
                                           END,
                       POPUP_YN          = NVL(REC.POPUP_YN, POPUP_YN),
                       LAST_UPDATED_BY   = V_USER,
                       LAST_UPDATE_DATE  = SYSDATE
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                IF SQL%ROWCOUNT > 0 THEN
                    V_AFFECTED := V_AFFECTED + 1;

                    BEGIN
                        SELECT NOTICE_IMAGE
                          INTO V_OLD_FILE_ID
                          FROM SCM_ADM_NOTICE_CONTENT_MASTER
                         WHERE NOTICE_ID = REC.NOTICE_ID
                           AND LANGUAGE_CODE = V_LANGUAGE_CODE
                         FOR UPDATE;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_OLD_FILE_ID := NULL;
                    END;

                    UPDATE SCM_ADM_NOTICE_CONTENT_MASTER
                       SET NOTICE_TITLE    = REC.NOTICE_TITLE,
                           NOTICE_CONTENT  = REC.NOTICE_CONTENT,
                           NOTICE_IMAGE    = REC.NOTICE_IMAGE,
                           LAST_UPDATED_BY = V_USER,
                           LAST_UPDATE_DATE = SYSDATE
                     WHERE NOTICE_ID = REC.NOTICE_ID
                       AND LANGUAGE_CODE = V_LANGUAGE_CODE;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCM_ADM_NOTICE_CONTENT_MASTER
                        (
                            NOTICE_ID,
                            LANGUAGE_CODE,
                            NOTICE_TITLE,
                            NOTICE_CONTENT,
                            NOTICE_IMAGE,
                            CREATED_BY,
                            CREATION_DATE,
                            LAST_UPDATED_BY,
                            LAST_UPDATE_DATE
                        )
                        VALUES
                        (
                            REC.NOTICE_ID,
                            V_LANGUAGE_CODE,
                            REC.NOTICE_TITLE,
                            REC.NOTICE_CONTENT,
                            REC.NOTICE_IMAGE,
                            V_USER,
                            SYSDATE,
                            V_USER,
                            SYSDATE
                        );
                    END IF;

                    IF V_OLD_FILE_ID IS NOT NULL
                       AND V_OLD_FILE_ID <> NVL(REC.NOTICE_IMAGE, '#') THEN
                        DELETE FROM SCM_COM_ATCH_FILE_M F
                         WHERE F.ATCH_FILE_ID = V_OLD_FILE_ID
                           AND F.ATCH_FILE_KDN_CD = 'NOTICE'
                           AND NOT EXISTS (
                               SELECT 1
                                 FROM SCM_ADM_NOTICE_CONTENT_MASTER C
                                WHERE C.NOTICE_IMAGE = V_OLD_FILE_ID
                           );
                    END IF;
                END IF;

            ELSIF REC.CRUD_TYPE = 'D' THEN
                DELETE FROM SCM_ADM_NOTICE_CONTENT_MASTER
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                DELETE FROM SCM_ADM_NOTICE_MASTER
                 WHERE NOTICE_ID = REC.NOTICE_ID;

                V_AFFECTED := V_AFFECTED + SQL%ROWCOUNT;
            END IF;
        END LOOP;

        OPEN O_RC1 FOR
            SELECT V_AFFECTED AS AFFECTED
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE,
                   'SUCCESS' AS MSG,
                   CAST(NULL AS VARCHAR2(1)) AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            RAISE_APPLICATION_ERROR(
                -20001,
                '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE
                || ' / SQLERRM=' || V_SQL_ERRMSG
                || ' / BACKTRACE=' || V_BACKTRACE
            );
    END P_SYS0016_SAVE_NOTICE_CONTENT_MASTER;
END PKG_SYS0016;