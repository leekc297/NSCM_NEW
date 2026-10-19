-- SOURCE-FRESH: SCM_MGR.SCM_ADM_MAIL_SEND_BATCH PROCEDURE LAST_DDL=2026-09-15 18:59:12 FETCHED=2026-09-15 21:03 DB=ZIOUI1
-- 외부 호출부 — 대상 SP 호출을 PKG 멤버로 전환 (사내 적용 2026-09-15)
SET DEFINE OFF
CREATE OR REPLACE PROCEDURE SCM_MGR."SCM_ADM_MAIL_SEND_BATCH" 
(
    P_CATEGORY_ID   IN NUMBER
)

/*
 * Program ID   : SCM_ADM_MAIL_SEND_BATCH
 * Description  : MAIL 발송 BATCH
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/06   ygkim       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/04/04   ygkim       Email -> UserID@lgchem.com 으로 UserID를 이용하여 만들어 준다.
 * 2018/04/06   ygkim       html 태그 수정
 * 2018/05/03   ygkim       FN_SCM_ADM_GET_MAIL_SQL 컬럼 추가
 * 2018/05/10   ygkim       여러 사용자에게 보낼때 오류 수정
 * 2018/05/17   ygkim       order by  추가
 * 2018/07/16   ywhoon      쿼리분할 삭제
 * 2018/10/08   ygkim       SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 수신자 변경
 * 2020/12/06   KSW         LG 에너지솔루션 분사적용 :: lgchem.com -> lgensol.com 으로 변경
 * 2022/08/11   sclee.lee   PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : 부실(징후) 자재 메일전송 (@p_category_id = 89 ~ 90)은 별도 프로그램 실행구문 수행
 * 2025/08/19   kimcd       adm mail send batch 오류 조치
 *                          권한 승인 메일에서 reject reason이 1000 단위로 관리됨
 * 2026.07.06   ZIONEX      [PJ202650304] NextSCM Migration
 */
AS
    V_RESULT          CLOB;
    V_RESULT4         CLOB;
    V_HTML_HEAD       VARCHAR2(4000 CHAR);

    V_TO_MAIL         VARCHAR2(200 CHAR);
    V_HEAD_CONT       VARCHAR2(32767 CHAR);
    V_BODY_CONT       VARCHAR2(32767 CHAR);
    V_TABLE_BODY      VARCHAR2(32767 CHAR);
    V_BODY_CONTENTS   VARCHAR2(32767 CHAR);
    V_SQL_LONG_TEXT   VARCHAR2(32767 CHAR);

    V_USE_TYPE_CODE   VARCHAR2(10 CHAR);
    V_USER_ID         VARCHAR2(150 CHAR);
    V_MAIL_TITLE      VARCHAR2(100 CHAR);
    V_SEGMENT1        VARCHAR2(100 CHAR);
    V_SEGMENT2        VARCHAR2(100 CHAR);
    V_SEGMENT3        VARCHAR2(100 CHAR);
    V_SEGMENT4        VARCHAR2(100 CHAR);
    V_SEGMENT5        VARCHAR2(1000 CHAR);   /* 2025/08/19 kimcd : 권한 승인 메일 reject reason 1000 단위 관리 */
    V_SEGMENT6        VARCHAR2(100 CHAR);
    V_SEGMENT7        VARCHAR2(100 CHAR);
    V_SEGMENT8        VARCHAR2(100 CHAR);
    V_SEGMENT9        VARCHAR2(100 CHAR);
    V_SEGMENT10       VARCHAR2(100 CHAR);
    V_SEGMENT5_LOG    VARCHAR2(100 CHAR);    /* 2025/08/19 kimcd : log는 100만 남김 */
    V_COLUMN1         VARCHAR2(100 CHAR);
    V_COLUMN2         VARCHAR2(100 CHAR);
    V_COLUMN3         VARCHAR2(100 CHAR);
    V_COLUMN4         VARCHAR2(100 CHAR);
    V_COLUMN5         VARCHAR2(100 CHAR);
    V_COLUMN6         VARCHAR2(100 CHAR);
    V_COLUMN7         VARCHAR2(100 CHAR);
    V_COLUMN8         VARCHAR2(100 CHAR);
    V_COLUMN9         VARCHAR2(100 CHAR);
    V_COLUMN10        VARCHAR2(100 CHAR);
    V_CHECK           INTEGER;
    V_SQL_YN          VARCHAR2(1 CHAR);
    V_RECEIVER_TEMP   VARCHAR2(150 CHAR);
    V_EXC_CNT         INTEGER := 0;

    /* LOG 용 변수 */
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'SCM_ADM_MAIL_SEND_BATCH';
    V_LOG_TYPE        VARCHAR2(30 CHAR);          /* START/END/ERROR/... */
    N_LOG_COUNT       INTEGER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR);
    D_EVENT_DATE      DATE;
    V_ERROR_MESSAGE   VARCHAR2(1000 CHAR);
BEGIN

    V_HTML_HEAD := Q'[ <html>
<head>
<title>Untitled Document</title>
<style>
   * {margin:0;padding:0;}
   body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
   table {border-collapse:collapse;width:100%;}
   table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
   table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
   table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
   table tbody td {text-align:left;padding:6px 8px;font-size:12px}
   table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
   .hori-table table thead td {text-align:center;padding:3px;}
   .hori-table table tbody td {text-align:center;padding:3px;}
   .vertical-table, .hori-table {margin-bottom:20px;}
</style>
</head>
<body>]';

    /* PJ20216994 : 부실(징후) 자재 메일전송 관련 CATEGORY_ID(Long-term stock Report)는 별도 프로그램 수행 */
    SELECT COUNT(*)
      INTO V_EXC_CNT
      FROM SCM_ADM_RECIPIENT_LIST
     WHERE CATEGORY_DESC LIKE 'Long-term stock Report%'
       AND CATEGORY_ID = P_CATEGORY_ID;

    IF V_EXC_CNT > 0 THEN
        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);


        EXECUTE IMMEDIATE 'BEGIN PR_SCM_ADM_LONG_TERM_STOCK_MAIL; END;';

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        RETURN;
    END IF;


    DELETE FROM GT_MAILBATCH;

    /* 발송 SQL(문자열) 획득 : FN_SCM_ADM_GET_MAIL_SQL 는 T_STR_TAB 컬렉션 반환 */
    SELECT COLUMN_VALUE
      INTO V_RESULT
      FROM TABLE(FN_SCM_ADM_GET_MAIL_SQL(P_CATEGORY_ID))
     WHERE ROWNUM = 1;


    V_RESULT4 :=
'  SELECT z.use_type_code'||CHR(10)||
'       , z.user_id'||CHR(10)||
'       , z.user_name'||CHR(10)||
'       , z.email_addr'||CHR(10)||
'       , z.mobile_phone'||CHR(10)||
'       , z.language_code'||CHR(10)||
'       , z.segment1, z.segment2, z.segment3, z.segment4, z.segment5, z.segment6, z.segment7, z.segment8, z.segment9, z.segment10'||CHR(10)||
'       , z.column1, z.column2, z.column3, z.column4, z.column5, z.column6, z.column7, z.column8, z.column9, z.column10'||CHR(10)||
'       , z.mail_title'||CHR(10)||
'       , z.body_contents'||CHR(10)||
'       , z.sql_long_text'||CHR(10)||
'       , COUNT(z.user_id) OVER (PARTITION BY z.user_id) user_cnt'||CHR(10)||
'       , DENSE_RANK() OVER (PARTITION BY z.user_id ORDER BY z.user_id, z.segment1, z.segment2, z.segment3, z.segment4, z.segment5, z.segment6, z.segment7, z.segment8, z.segment9, z.segment10) rank_no'||CHR(10)||
'    FROM ('||CHR(10)||
'  SELECT x.use_type_code'||CHR(10)||
'       , CASE WHEN x.user_id IS NOT NULL THEN x.user_id'||CHR(10)||
'              WHEN y.user_id IS NOT NULL THEN y.user_id'||CHR(10)||
'              ELSE y.user_id'||CHR(10)||
'         END user_id'||CHR(10)||
'       , CASE WHEN x.user_name IS NULL THEN y.user_name'||CHR(10)||
'              WHEN y.user_name IS NULL THEN x.user_name'||CHR(10)||
'              ELSE y.user_name'||CHR(10)||
'         END user_name'||CHR(10)||
'       , CASE WHEN x.email_addr IS NULL THEN y.email_addr'||CHR(10)||
'              WHEN y.email_addr IS NULL THEN x.email_addr'||CHR(10)||
'              ELSE y.email_addr'||CHR(10)||
'         END email_addr'||CHR(10)||
'       , CASE WHEN x.mobile_phone IS NULL THEN y.mobile_phone'||CHR(10)||
'              WHEN y.mobile_phone IS NULL THEN x.mobile_phone'||CHR(10)||
'              ELSE y.mobile_phone'||CHR(10)||
'         END mobile_phone'||CHR(10)||
'       , x.language_code'||CHR(10)||
'       , y.segment1, y.segment2, y.segment3, y.segment4, y.segment5, y.segment6, y.segment7, y.segment8, y.segment9, y.segment10'||CHR(10)||
'       , y.column1, y.column2, y.column3, y.column4, y.column5, y.column6, y.column7, y.column8, y.column9, y.column10'||CHR(10)||
'       , x.mail_title'||CHR(10)||
'       , x.body_contents'||CHR(10)||
'       , x.sql_long_text'||CHR(10)||
'    FROM ('||V_RESULT||') y,'||CHR(10)||
'       ( SELECT a.use_type_code'||CHR(10)||
'              , c.user_id'||CHR(10)||
'              , e.UserName as user_name'||CHR(10)||
'              , e.Email as email_addr'||CHR(10)||
'              , e.CellPhoneNum as mobile_phone'||CHR(10)||
'              , b.language_code'||CHR(10)||
'              , b.mail_title'||CHR(10)||
'              , d.SEGMENT3 header_contents'||CHR(10)||
'              , CASE a.USE_TYPE_CODE WHEN ''MAIL'' THEN REPLACE(b.message_content, CHR(10), ''<br><br>'')'||CHR(10)||
'                                     WHEN ''SMS'' THEN b.message_content'||CHR(10)||
'                END body_contents'||CHR(10)||
'              , d.SEGMENT3 foot_contents'||CHR(10)||
'              , a.SQL_LONG_TEXT'||CHR(10)||
'           FROM SCM_ADM_RECIPIENT_LIST a'||CHR(10)||
'                INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b ON a.CATEGORY_ID = b.CATEGORY_ID'||CHR(10)||
'                LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN c ON b.CATEGORY_ID = c.CATEGORY_ID'||CHR(10)||
'                INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d ON d.SEGMENT1 = b.LANGUAGE_CODE AND d.LOOKUP_TYPE = ''MAIL_HEADER_FOOT'' AND d.VALID_YN = ''Y'''||CHR(10)||
'                LEFT OUTER JOIN TB_FX_USER e ON b.LANGUAGE_CODE = e.Language AND c.USER_ID = e.UserID'||CHR(10)||
'          WHERE a.category_id = '||TO_CHAR(P_CATEGORY_ID)||CHR(10)||
'            AND a.VALID_YN = ''Y'''||CHR(10)||
'          ) x'||CHR(10)||
'   WHERE x.language_code = y.language_code'||CHR(10)||
'       ) z ORDER BY user_id';


    EXECUTE IMMEDIATE 'INSERT INTO GT_MAILBATCH ( USE_TYPE_CODE, USER_ID, USER_NAME, EMAIL_ADDR, MOBILE_PHONE, LANGUAGE_CODE'
        ||', SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6, SEGMENT7, SEGMENT8, SEGMENT9, SEGMENT10'
        ||', COLUMN1, COLUMN2, COLUMN3, COLUMN4, COLUMN5, COLUMN6, COLUMN7, COLUMN8, COLUMN9, COLUMN10'
        ||', MAIL_TITLE, BODY_CONTENTS, SQL_LONG_TEXT, USER_CNT, RANK_NO ) '||V_RESULT4;

    BEGIN
        /* 시작 LOG */
        V_LOG_TYPE := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        V_CHECK := 0;
        V_BODY_CONT := '';
        V_RECEIVER_TEMP := '';

        FOR REC IN (SELECT * FROM GT_MAILBATCH ORDER BY USER_ID) LOOP
            V_USE_TYPE_CODE := REC.USE_TYPE_CODE;
            V_USER_ID       := REC.USER_ID;
            V_MAIL_TITLE    := REC.MAIL_TITLE;
            V_BODY_CONTENTS := REC.BODY_CONTENTS;
            V_SQL_LONG_TEXT := REC.SQL_LONG_TEXT;
            V_SEGMENT1  := REC.SEGMENT1;  V_SEGMENT2  := REC.SEGMENT2;  V_SEGMENT3  := REC.SEGMENT3;
            V_SEGMENT4  := REC.SEGMENT4;  V_SEGMENT5  := REC.SEGMENT5;  V_SEGMENT6  := REC.SEGMENT6;
            V_SEGMENT7  := REC.SEGMENT7;  V_SEGMENT8  := REC.SEGMENT8;  V_SEGMENT9  := REC.SEGMENT9;
            V_SEGMENT10 := REC.SEGMENT10;
            V_COLUMN1  := REC.COLUMN1;  V_COLUMN2  := REC.COLUMN2;  V_COLUMN3  := REC.COLUMN3;
            V_COLUMN4  := REC.COLUMN4;  V_COLUMN5  := REC.COLUMN5;  V_COLUMN6  := REC.COLUMN6;
            V_COLUMN7  := REC.COLUMN7;  V_COLUMN8  := REC.COLUMN8;  V_COLUMN9  := REC.COLUMN9;
            V_COLUMN10 := REC.COLUMN10;

            IF V_USE_TYPE_CODE = 'MAIL' THEN
                V_TO_MAIL := V_USER_ID || '@lgensol.com';

                IF V_SQL_LONG_TEXT IS NULL THEN
                    V_SQL_YN := 'N';
                    /* 메일 발송 */
                    PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_TO_MAIL, V_MAIL_TITLE, V_BODY_CONTENTS, 'N');
                    /* MAIL 발송 LOG 저장 (2025/08/19 kimcd : log 입력용 100자 절단) */
                    V_SEGMENT5_LOG := SUBSTR(V_SEGMENT5, 1, 100);
                    SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(V_USE_TYPE_CODE, P_CATEGORY_ID, V_SEGMENT1, V_SEGMENT2, V_SEGMENT3, V_SEGMENT4
                      , V_SEGMENT5_LOG, V_SEGMENT6, V_SEGMENT7, V_SEGMENT8, V_SEGMENT9, V_SEGMENT10, ' ', V_USER_ID);
                ELSE
                    IF V_RECEIVER_TEMP IS NULL THEN
                        V_RECEIVER_TEMP := V_TO_MAIL;
                    END IF;

                    IF V_RECEIVER_TEMP != V_TO_MAIL THEN
                        IF LENGTH(V_HEAD_CONT) > 0 THEN
                            V_TABLE_BODY := V_HTML_HEAD || '</br>'
                                || '<b>' || REPLACE(V_BODY_CONTENTS, CHR(10), '<br>') || '</b>'
                                || '<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'
                                || '<table style=''border-top:2px solid #c8294b; width:1000px;''>'
                                || '<thead>' || V_HEAD_CONT || '</thead>'
                                || '<tbody>' || V_BODY_CONT || '</tbody>'
                                || '</div></body></html>';
                            /* 메일 발송 */
                            PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_RECEIVER_TEMP, V_MAIL_TITLE, V_TABLE_BODY, 'Y');
                            V_BODY_CONTENTS := '';
                            V_CHECK := 0;
                            V_BODY_CONT := '';
                            /* MAIL 발송 LOG 저장 */
                            V_SEGMENT5_LOG := SUBSTR(V_SEGMENT5, 1, 100);
                            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(V_USE_TYPE_CODE, P_CATEGORY_ID, V_SEGMENT1, V_SEGMENT2, V_SEGMENT3, V_SEGMENT4
                              , V_SEGMENT5_LOG, V_SEGMENT6, V_SEGMENT7, V_SEGMENT8, V_SEGMENT9, V_SEGMENT10, ' ', V_RECEIVER_TEMP);
                            V_RECEIVER_TEMP := V_TO_MAIL;
                        END IF;
                    END IF;

                    V_SQL_YN := 'Y';
                    IF V_CHECK = 0 THEN
                        V_HEAD_CONT := '';
                        V_HEAD_CONT := V_HEAD_CONT || '<tr>';
                        IF V_COLUMN1  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN1  || '</th>'; END IF;
                        IF V_COLUMN2  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN2  || '</th>'; END IF;
                        IF V_COLUMN3  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN3  || '</th>'; END IF;
                        IF V_COLUMN4  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN4  || '</th>'; END IF;
                        IF V_COLUMN5  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN5  || '</th>'; END IF;
                        IF V_COLUMN6  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN6  || '</th>'; END IF;
                        IF V_COLUMN7  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN7  || '</th>'; END IF;
                        IF V_COLUMN8  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN8  || '</th>'; END IF;
                        IF V_COLUMN9  IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN9  || '</th>'; END IF;
                        IF V_COLUMN10 IS NOT NULL THEN V_HEAD_CONT := V_HEAD_CONT || '<th>' || V_COLUMN10 || '</th>'; END IF;
                        V_HEAD_CONT := V_HEAD_CONT || '</tr>';
                        V_CHECK := V_CHECK + 1;
                    END IF;

                    V_BODY_CONT := V_BODY_CONT || '<tr>';
                    IF V_COLUMN1  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT1 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN2  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT2 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN3  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT3 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN4  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT4 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN5  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT5 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN6  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT6 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN7  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT7 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN8  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT8 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN9  IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT9 , CHR(10), ' ') || '</td>'; END IF;
                    IF V_COLUMN10 IS NOT NULL THEN V_BODY_CONT := V_BODY_CONT || '<td>' || REPLACE(V_SEGMENT10, CHR(10), ' ') || '</td>'; END IF;
                    V_BODY_CONT := V_BODY_CONT || '</tr>';
                END IF;
            ELSIF V_USE_TYPE_CODE = 'SMS' THEN

                NULL;
            END IF;
        END LOOP;

        IF V_SQL_YN = 'Y' THEN
            IF LENGTH(V_HEAD_CONT) > 0 THEN
                V_TABLE_BODY := V_HTML_HEAD || '</br>'
                    || '<b>' || REPLACE(V_BODY_CONTENTS, CHR(10), '<br>') || '</b>'
                    || '<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'
                    || '<table style=''border-top:2px solid #c8294b; width:1000px;''>'
                    || '<thead>' || V_HEAD_CONT || '</thead>'
                    || '<tbody>' || V_BODY_CONT || '</tbody>'
                    || '</table></div></body></html>';
                /* 메일 발송 */
                PKG_DMF0003.P_SCM_ADM_MAIL_SEND(V_TO_MAIL, V_MAIL_TITLE, V_TABLE_BODY, 'Y');
                V_BODY_CONTENTS := '';
                V_CHECK := 0;
                V_BODY_CONT := '';
                /* MAIL 발송 LOG 저장 */
                V_SEGMENT5_LOG := SUBSTR(V_SEGMENT5, 1, 100);
                SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG(V_USE_TYPE_CODE, P_CATEGORY_ID, V_SEGMENT1, V_SEGMENT2, V_SEGMENT3, V_SEGMENT4
                  , V_SEGMENT5_LOG, V_SEGMENT6, V_SEGMENT7, V_SEGMENT8, V_SEGMENT9, V_SEGMENT10, ' ', V_TO_MAIL);
            END IF;
        END IF;

        V_LOG_TYPE := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := TO_CHAR(P_CATEGORY_ID);
        D_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    EXCEPTION
        WHEN OTHERS THEN

            V_ERROR_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            INSERT INTO SCM_SYS_LOG_BATCH ( PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, EVENT_DATE
                                          , CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY )
            VALUES ( V_PROGRAM_NAME, 'ERROR', NULL, V_ERROR_MESSAGE, NULL, SYSDATE
                   , SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME );
            COMMIT;

            /* MAIL 발송 LOG 저장 */
            SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG('ERROR', P_CATEGORY_ID, 'MAIN ERROR', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', V_ERROR_MESSAGE, ' ');
            COMMIT;


            DBMS_OUTPUT.PUT_LINE('F');
            DBMS_OUTPUT.PUT_LINE('[' || TO_CHAR(SQLCODE) || ']' || SQLERRM);
    END;
END;
/
