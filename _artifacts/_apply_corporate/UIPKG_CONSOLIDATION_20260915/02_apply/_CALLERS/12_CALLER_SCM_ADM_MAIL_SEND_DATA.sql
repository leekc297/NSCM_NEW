-- SOURCE-FRESH: SCM_MGR.SCM_ADM_MAIL_SEND_DATA PROCEDURE LAST_DDL=2026-09-02 17:30:40 FETCHED=2026-09-15 18:54 DB=ZIOUI1
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."SCM_ADM_MAIL_SEND_DATA" 
(
    P_CATEGORY_ID   IN NUMBER
)
/*
 * Program ID   : SCM_ADM_MAIL_SEND_DATA
 * Description  : MAIL 발송 BATCH - UI에서 수신자가 등록되어 있는 경우
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/05   ygkim                   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/10   ygkim                   Mail 내용이 있을 경우에만 발송되도록 수정
 * 2018/10/11   ygkim                   5명 이상일 경우 5명씩 나눠서 보내는걸로 수정
 * 2023/11/24   chaan           V1.1.1  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2        - SQL 결과 컬럼이 10개로 제한 -> 컬럼 갯수에 상관없이 유연하게 대응하도록 변경
 *                                                                                                              - 테스트모드 추가 (메일 개발자에게만 발송)
 * 2023/12/14   chaan           V1.1.2  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2        - SQL 쿼리 결과셋이 n 개 가능하도록 변경
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 *
 * ex) exec SCM_ADM_MAIL_SEND_DATA 8
 */
AS
    V_TEST_MODE             VARCHAR2(1 CHAR) := 'F';
    /* 개발자 이메일(전송 테스트용) */
    V_DEV_EMAIL             VARCHAR2(100 CHAR) := 'kimcd@lgespartner.com';

    /* SQL n개 처리를 위한 쿼리구문 구분자. MSSQL 원본 '†'(dagger, U+2020) = CHR(8224) */
    V_SQL_SEPERATOR         VARCHAR2(1 CHAR) := CHR(8224);


    V_TABLE_CONTENTS        CLOB;
    V_CURR_TABLE_CONTENTS   CLOB;
    V_MAIL_TEXT             CLOB;
    V_SQL                   CLOB;
    V_CURR_SQL              CLOB;
    V_BODY_TITLE            CLOB;

    V_USER_ID               VARCHAR2(40 CHAR);
    V_MAIL_RECEIVER_LIST    VARCHAR2(4000 CHAR);
    V_MAIL_TITLE            VARCHAR2(100 CHAR);
    V_SEND_CNT              INTEGER := 0;
    V_USER_CNT              INTEGER := 0;

    /* LOG 용 변수 설정 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SCM_ADM_MAIL_SEND_DATA';
    V_LOG_TYPE              VARCHAR2(30 CHAR);
    N_LOG_COUNT             INTEGER := 0;
    V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
    V_DESCRIPTION           VARCHAR2(500 CHAR);
    D_EVENT_DATE            DATE;


    V_ERROR_MESSAGE         VARCHAR2(1000 CHAR);
    V_ERR_PROC              VARCHAR2(600 CHAR);
    V_ERR_MSG               VARCHAR2(4000 CHAR);
    V_ERR_CODE              NUMBER;


    CURSOR CUR_SQL_SPLIT(P_STR IN VARCHAR2, P_DELIM IN VARCHAR2) IS
        SELECT TOKEN
          FROM TABLE(FN_STRING_SPLIT(P_STR, P_DELIM));


    CURSOR CUR_USER IS
        SELECT USER_ID
          FROM SCM_ADM_RECIPIENT_ASSIGN
         WHERE 1 = 1
           AND CATEGORY_ID = P_CATEGORY_ID;
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_TABLE_CONTENTS, TRUE);

    SELECT COUNT(USER_ID)
      INTO V_USER_CNT
      FROM SCM_ADM_RECIPIENT_ASSIGN
     WHERE 1 = 1
       AND CATEGORY_ID = P_CATEGORY_ID;

    BEGIN
        SELECT MAIL_TITLE
             , REPLACE(MESSAGE_CONTENT, CHR(10), '<br><br>')
          INTO V_MAIL_TITLE
             , V_BODY_TITLE
          FROM SCM_ADM_RECIPIENT_MESSAGE
         WHERE 1 = 1
           AND CATEGORY_ID = P_CATEGORY_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_MAIL_TITLE := NULL;
            V_BODY_TITLE := NULL;
    END;

    BEGIN
        SELECT SQL_LONG_TEXT
          INTO V_SQL
          FROM SCM_ADM_RECIPIENT_LIST
         WHERE 1 = 1
           AND CATEGORY_ID = P_CATEGORY_ID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_SQL := NULL;
    END;

    BEGIN
        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        DBMS_OUTPUT.PUT_LINE('GET TABLE DATAS - BEGIN ---------------------------------------------------------------------------------');


        FOR R IN CUR_SQL_SPLIT(V_SQL, V_SQL_SEPERATOR) LOOP

            V_CURR_SQL := NVL(R.TOKEN, ' ');

            V_CURR_TABLE_CONTENTS := NULL;

            UP_FX_GETHTMLBYSQL(V_CURR_SQL, 'COLUMN', 'SEGMENT', V_CURR_TABLE_CONTENTS);

            IF V_CURR_TABLE_CONTENTS IS NOT NULL THEN
                DBMS_LOB.APPEND(V_TABLE_CONTENTS, V_CURR_TABLE_CONTENTS);
            END IF;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('GET TABLE DATAS - END ---------------------------------------------------------------------------------');

        /* 대상 데이터가 있을때만 메일 발송 */
        IF DBMS_LOB.GETLENGTH(V_TABLE_CONTENTS) > 0 THEN

            V_MAIL_TEXT :=
                ' <html>
                <head>
                <title>Untitled Document</title>
                <style>
                    * {margin:0;padding:0;}
                    body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:11px;line-height:1.8;color:#333333;}
                    table {border-collapse:collapse;width:100%;}
                    table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
                    table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
                    table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:11px}
                    table tbody td {text-align:left;padding:6px 8px;font-size:11px}
                    table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:11px}
                    .hori-table table thead td {text-align:center;padding:3px;}
                    .hori-table table tbody td {text-align:center;padding:3px;}
                    .vertical-table, .hori-table {margin-bottom:20px;}
                </style>
                </head>
                <body>' || '</br>' || '<b>' || REPLACE(NVL(V_BODY_TITLE, ' '), CHR(10), '<br>') || '</b>' ||
                '<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">' ||
                '<table border=1 style="border-collapse: collapse; width:100%; white-space: nowrap; ">' ||
                V_TABLE_CONTENTS || '
                </div>
                </body>
                </html>';

            /* 메일 발송 루프 */
            V_USER_ID            := NULL;
            V_MAIL_RECEIVER_LIST := NULL;
            V_SEND_CNT           := 1;

            FOR U IN CUR_USER LOOP
                V_USER_ID := U.USER_ID;

                IF NVL(V_MAIL_RECEIVER_LIST, ' ') = ' ' THEN
                    V_MAIL_RECEIVER_LIST := V_USER_ID || '@lgensol.com';
                ELSE
                    V_MAIL_RECEIVER_LIST := V_MAIL_RECEIVER_LIST || ';' || V_USER_ID || '@lgensol.com';
                END IF;

                /* 테스트모드에는 개발자 메일로만 발송!!!!!!! */
                IF V_TEST_MODE = 'T' THEN
                    V_MAIL_RECEIVER_LIST := V_DEV_EMAIL;
                    V_USER_CNT           := 1;
                END IF;

                IF V_USER_CNT = V_SEND_CNT THEN
                    IF NVL(DBMS_LOB.SUBSTR(V_CURR_SQL, 1, 1), ' ') <> ' ' THEN

                        PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_MAIL_RECEIVER_LIST
                                        , V_MAIL_TITLE
                                        , DBMS_LOB.SUBSTR(V_MAIL_TEXT, 32767, 1)
                                        , 'Y');

                        V_BODY_TITLE := NULL;
                        DBMS_LOB.TRIM(V_TABLE_CONTENTS, 0);

                        SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL', P_CATEGORY_ID, 'SCM_ADM_MAIL_SEND_DATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_MAIL_RECEIVER_LIST);
                    ELSE

                        PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_MAIL_RECEIVER_LIST
                                        , V_MAIL_TITLE
                                        , DBMS_LOB.SUBSTR(V_BODY_TITLE, 32767, 1)
                                        , 'N');

                        /* MAIL 발송 LOG 저장 */
                        SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL', P_CATEGORY_ID, 'SCM_ADM_MAIL_SEND_DATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_MAIL_RECEIVER_LIST);
                    END IF;
                ELSE /* 5명 이상일 경우 */
                    IF MOD(V_SEND_CNT, 5) = 0 THEN
                        IF NVL(DBMS_LOB.SUBSTR(V_CURR_SQL, 1, 1), ' ') <> ' ' THEN
                            IF DBMS_LOB.GETLENGTH(V_TABLE_CONTENTS) > 0 THEN

                                PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_MAIL_RECEIVER_LIST
                                                , V_MAIL_TITLE
                                                , DBMS_LOB.SUBSTR(V_MAIL_TEXT, 32767, 1)
                                                , 'Y');

                                V_BODY_TITLE := NULL;
                                DBMS_LOB.TRIM(V_TABLE_CONTENTS, 0);

                                /* MAIL 발송 LOG 저장 */
                                SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL', P_CATEGORY_ID, 'SCM_ADM_MAIL_SEND_DATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_MAIL_RECEIVER_LIST);
                            END IF;
                        ELSE

                            PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_MAIL_RECEIVER_LIST
                                            , V_MAIL_TITLE
                                            , DBMS_LOB.SUBSTR(V_BODY_TITLE, 32767, 1)
                                            , 'N');

                            /* MAIL 발송 LOG 저장 */
                            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('MAIL', P_CATEGORY_ID, 'SCM_ADM_MAIL_SEND_DATA', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_MAIL_RECEIVER_LIST);
                        END IF;

                        V_MAIL_RECEIVER_LIST := NULL;
                    END IF;
                END IF;

                V_SEND_CNT := V_SEND_CNT + 1;

                IF V_TEST_MODE = 'T' THEN
                    EXIT;
                END IF;
            END LOOP;
        END IF;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE  := SYSDATE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_PROC := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 600);
            IF V_ERR_PROC IS NULL THEN
                V_ERR_PROC := 'SCM_ADM_MAIL_SEND_DATA';
            END IF;
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);
            V_ERR_CODE := SQLCODE;


            INSERT
              INTO SCM_SYS_LOG_BATCH
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
            VALUES ( V_ERR_PROC
                 , 'ERROR'
                 , NULL
                 , V_ERR_MSG
                 , 'p_category_id:' || TO_CHAR(P_CATEGORY_ID)
                 , SYSDATE
                 , SYSDATE
                 , V_ERR_PROC
                 , SYSDATE
                 , V_ERR_PROC );
            COMMIT;

            V_ERROR_MESSAGE := SUBSTR(V_ERR_MSG, 1, 1000);

            /* MAIL 발송 LOG 저장 */
            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('ERROR', P_CATEGORY_ID, 'MAIN ERROR', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, V_ERROR_MESSAGE, NULL);
            COMMIT;


    END;
END;
/
