/*=============================================================================================
 * File         : 04_Package_PKG_SEND_MAIL.sql
 * Description  : Package — PKG_SEND_MAIL
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - v_program_name 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SEND_MAIL IS
    /*=========================================================================
    * PKG_SEND_MAIL - SMTP 메일 발송 패키지
    * SMTP: mailrelay.lgensol.com:25
    * 발신자: scmpi@lgensol.com
    *
    *   기본 메일 발송 (다중 수신자: 콤마/세미콜론 구분)
    *=========================================================================*/
    -- 기본 메일 발송 (VARCHAR2 본문, 32KB 이하)
    PROCEDURE P_SEND_MAIL
    (
        P_TO_MAIL       IN VARCHAR2
       ,P_SUBJECT       IN VARCHAR2
       ,P_BODY_CONTENTS IN VARCHAR2
       ,P_HTML_YN       IN VARCHAR2 DEFAULT ''
       ,P_SENDER        IN VARCHAR2 DEFAULT 'scmpi@lgensol.com'
       ,P_CC_MAIL       IN VARCHAR2 DEFAULT NULL
       ,P_BCC_MAIL      IN VARCHAR2 DEFAULT NULL
    );

    -- 첨부파일 포함 메일 발송
    PROCEDURE P_SEND_MAIL_ATTACH
    (
        P_TO_MAIL       IN VARCHAR2
       ,P_SUBJECT       IN VARCHAR2
       ,P_BODY_CONTENTS IN VARCHAR2
       ,P_ATTACH_DATA   IN RAW
       ,P_ATTACH_NAME   IN VARCHAR2
       ,P_ATTACH_MIME   IN VARCHAR2 DEFAULT 'application/octet-stream'
       ,P_HTML_YN       IN VARCHAR2 DEFAULT ''
       ,P_SENDER        IN VARCHAR2 DEFAULT 'scmpi@lgensol.com'
       ,P_CC_MAIL       IN VARCHAR2 DEFAULT NULL
    );

    -- CLOB 본문 메일 발송 (32KB 초과, 다중 수신자 지원)
    PROCEDURE P_SEND_MAIL_CLOB
    (
        P_TO_MAIL   IN VARCHAR2
       ,P_SUBJECT   IN VARCHAR2
       ,P_BODY_CLOB IN CLOB
       ,P_HTML_YN   IN VARCHAR2 DEFAULT ''
       ,P_SENDER    IN VARCHAR2 DEFAULT 'scmpi@lgensol.com'
       ,P_CC_MAIL   IN VARCHAR2 DEFAULT NULL
    );

    -- 메일 발송 로그 기록
    PROCEDURE P_LOG_MAIL
    (
        P_TO_MAIL   IN VARCHAR2
       ,P_SUBJECT   IN VARCHAR2
       ,P_STATUS    IN VARCHAR2
       ,P_ERROR_MSG IN VARCHAR2 DEFAULT NULL
       ,P_MAIL_TYPE IN VARCHAR2 DEFAULT 'BASIC'
       ,P_SENDER    IN VARCHAR2 DEFAULT NULL
       ,P_CC_MAIL   IN VARCHAR2 DEFAULT NULL
       ,P_BCC_MAIL  IN VARCHAR2 DEFAULT NULL
    );

    -- 메일 주소 유효성 검증 (단일)
    FUNCTION F_VALIDATE_EMAIL(P_EMAIL IN VARCHAR2) RETURN VARCHAR2;

    -- 다중 메일 주소 유효성 검증 (콤마/세미콜론 구분)
    FUNCTION F_VALIDATE_EMAIL_LIST(P_EMAIL_LIST IN VARCHAR2) RETURN VARCHAR2;

    -- 메일 발송 통계 조회
    -- 메일 통계 레코드 타입
    TYPE T_MAIL_STATS_REC IS RECORD(
         SEND_DT   DATE
        ,MAIL_TYPE VARCHAR2(20)
        ,STATUS    VARCHAR2(10)
        ,CNT       NUMBER
        ,RCPT_CNT  NUMBER);

    TYPE T_MAIL_STATS_TAB IS TABLE OF T_MAIL_STATS_REC;

    -- 메일 발송 통계 조회
    FUNCTION F_MAIL_STATS
    (
        P_FROM_DATE IN DATE DEFAULT TRUNC(SYSDATE, 'MM')
       ,P_TO_DATE   IN DATE DEFAULT SYSDATE
    ) RETURN T_MAIL_STATS_TAB
        PIPELINED;

END PKG_SEND_MAIL;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SEND_MAIL
IS
    -- 패키지 내부 상수
    C_SMTP_HOST  CONSTANT VARCHAR2(256) := 'mailrelay.lgensol.com';
    C_SMTP_PORT  CONSTANT NUMBER       := 25;
    C_CRLF       CONSTANT VARCHAR2(2)  := CHR(13) || CHR(10);
 
    /*===========================================
      [내부] 세미콜론 -> 콤마 통일 함수
      - 모든 프로시저에서 공통 사용
    ===========================================*/
    FUNCTION F_NORMALIZE_DELIM (
        p_str IN VARCHAR2
    ) RETURN VARCHAR2
    IS
    BEGIN
        IF p_str IS NULL THEN
            RETURN NULL;
        END IF;
        RETURN REPLACE(p_str, ';', ',');
    END F_NORMALIZE_DELIM;
 
    /*===========================================
      메일 주소 유효성 검증 (단일)
    ===========================================*/
    FUNCTION F_VALIDATE_EMAIL (
        p_email IN VARCHAR2
    ) RETURN VARCHAR2
    IS
    BEGIN
        IF p_email IS NULL THEN
            RETURN '';
        END IF;
 
        IF REGEXP_LIKE(TRIM(p_email), '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            RETURN 'Y';
        ELSE
            RETURN '';
        END IF;
    END F_VALIDATE_EMAIL;
 
    /*===========================================
      다중 메일 주소 유효성 검증 (콤마/세미콜론 구분)
      - 하나라도 유효하지 않으면 '' 리턴
    ===========================================*/
    FUNCTION F_VALIDATE_EMAIL_LIST (
        p_email_list IN VARCHAR2
    ) RETURN VARCHAR2
    IS
        v_list  VARCHAR2(4000);
        v_addr  VARCHAR2(500);
        v_pos   NUMBER;
    BEGIN
        IF p_email_list IS NULL THEN
            RETURN '';
        END IF;
 
        -- 세미콜론 -> 콤마 통일
        v_list := F_NORMALIZE_DELIM(p_email_list) || ',';
 
        LOOP
            v_pos := INSTR(v_list, ',');
            EXIT WHEN v_pos = 0;
            v_addr := TRIM(SUBSTR(v_list, 1, v_pos - 1));
            IF v_addr IS NOT NULL AND F_VALIDATE_EMAIL(v_addr) = '' THEN
                RETURN '';
            END IF;
            v_list := SUBSTR(v_list, v_pos + 1);
        END LOOP;
 
        RETURN 'Y';
    END F_VALIDATE_EMAIL_LIST;
 
    /*===========================================
      메일 발송 로그 기록 (AUTONOMOUS_TRANSACTION)
    ===========================================*/
    PROCEDURE P_LOG_MAIL (
        p_to_mail    IN VARCHAR2,
        p_subject    IN VARCHAR2,
        p_status     IN VARCHAR2,
        p_error_msg  IN VARCHAR2 DEFAULT NULL,
        p_mail_type  IN VARCHAR2 DEFAULT 'BASIC',
        p_sender     IN VARCHAR2 DEFAULT NULL,
        p_cc_mail    IN VARCHAR2 DEFAULT NULL,
        p_bcc_mail   IN VARCHAR2 DEFAULT NULL
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO TB_MAIL_LOG (
            LOG_SEQ, TO_MAIL, CC_MAIL, BCC_MAIL,
            SUBJECT, STATUS, ERROR_MSG, MAIL_TYPE,
            SENDER, SEND_DATE, REG_ID, REG_DATE
        ) VALUES (
            SEQ1_MAIL_LOG.NEXTVAL, p_to_mail, p_cc_mail, p_bcc_mail,
            p_subject, p_status, p_error_msg, p_mail_type,
            p_sender, SYSDATE, USER, SYSDATE
        );
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END P_LOG_MAIL;
 
    /*===========================================
      기본 메일 발송
      - UTL_MAIL 사용
      - 다중 수신자: 콤마/세미콜론 구분 자동 지원
    ===========================================*/
    PROCEDURE P_SEND_MAIL (
        p_to_mail        IN VARCHAR2,
        p_subject        IN VARCHAR2,
        p_body_contents  IN VARCHAR2,
        p_html_yn        IN VARCHAR2 DEFAULT '',
        p_sender         IN VARCHAR2 DEFAULT 'scmpi@lgensol.com',
        p_cc_mail        IN VARCHAR2 DEFAULT NULL,
        p_bcc_mail       IN VARCHAR2 DEFAULT NULL
    )
    IS
        v_mime_type VARCHAR2(100);
        v_to_mail   VARCHAR2(4000);
        v_cc_mail   VARCHAR2(4000);
        v_bcc_mail  VARCHAR2(4000);
    BEGIN
        -- 구분자 통일 (세미콜론 -> 콤마)
        v_to_mail  := F_NORMALIZE_DELIM(p_to_mail);
        v_cc_mail  := F_NORMALIZE_DELIM(p_cc_mail);
        v_bcc_mail := F_NORMALIZE_DELIM(p_bcc_mail);
 
        -- 수신자 유효성 체크
        IF v_to_mail IS NULL THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', '수신자 없음', 'BASIC', p_sender);
            RETURN;
        END IF;
 
        IF (p_html_yn = 'Y') THEN
            v_mime_type := 'text/html; charset=UTF-8';
        ELSE
            v_mime_type := 'text/plain; charset=UTF-8';
        END IF;
 
        UTL_MAIL.SEND(
            sender     => p_sender,
            recipients => v_to_mail,
            cc         => v_cc_mail,
            bcc        => v_bcc_mail,
            subject    => p_subject,
            message    => p_body_contents,
            mime_type  => v_mime_type
        );
 
        P_LOG_MAIL(v_to_mail, p_subject, 'SUCCESS', NULL, 'BASIC', p_sender, v_cc_mail, v_bcc_mail);
 
    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', SQLERRM, 'BASIC', p_sender, v_cc_mail, v_bcc_mail);
            RAISE;
    END P_SEND_MAIL;
 
    /*===========================================
      첨부파일 포함 메일 발송
      - UTL_MAIL.SEND_ATTACH_RAW 사용
    ===========================================*/
    PROCEDURE P_SEND_MAIL_ATTACH (
        p_to_mail        IN VARCHAR2,
        p_subject        IN VARCHAR2,
        p_body_contents  IN VARCHAR2,
        p_attach_data    IN RAW,
        p_attach_name    IN VARCHAR2,
        p_attach_mime    IN VARCHAR2 DEFAULT 'application/octet-stream',
        p_html_yn        IN VARCHAR2 DEFAULT '',
        p_sender         IN VARCHAR2 DEFAULT 'scmpi@lgensol.com',
        p_cc_mail        IN VARCHAR2 DEFAULT NULL
    )
    IS
        v_mime_type VARCHAR2(100);
        v_to_mail   VARCHAR2(4000);
        v_cc_mail   VARCHAR2(4000);
    BEGIN
        -- 구분자 통일 (세미콜론 -> 콤마)
        v_to_mail := F_NORMALIZE_DELIM(p_to_mail);
        v_cc_mail := F_NORMALIZE_DELIM(p_cc_mail);
 
        IF v_to_mail IS NULL THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', '수신자 없음', 'ATTACH', p_sender);
            RETURN;
        END IF;
 
        IF (p_html_yn = 'Y') THEN
            v_mime_type := 'text/html; charset=UTF-8';
        ELSE
            v_mime_type := 'text/plain; charset=UTF-8';
        END IF;
 
        UTL_MAIL.SEND_ATTACH_RAW(
            sender        => p_sender,
            recipients    => v_to_mail,
            cc            => v_cc_mail,
            subject       => p_subject,
            message       => p_body_contents,
            mime_type     => v_mime_type,
            attachment    => p_attach_data,
            att_inline    => FALSE,
            att_mime_type => p_attach_mime,
            att_filename  => p_attach_name
        );
 
        P_LOG_MAIL(v_to_mail, p_subject, 'SUCCESS', NULL, 'ATTACH', p_sender, v_cc_mail);
 
    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', SQLERRM, 'ATTACH', p_sender, v_cc_mail);
            RAISE;
    END P_SEND_MAIL_ATTACH;
 
    /*===========================================
      CLOB 본문 메일 발송 (32KB 초과)
      - UTL_SMTP 사용 (UTL_MAIL 32KB 제한)
      - 다중 수신자 지원 (콤마/세미콜론 구분)
      - CC 지원
    ===========================================*/
    PROCEDURE P_SEND_MAIL_CLOB (
        p_to_mail        IN VARCHAR2,
        p_subject        IN VARCHAR2,
        p_body_clob      IN CLOB,
        p_html_yn        IN VARCHAR2 DEFAULT '',
        p_sender         IN VARCHAR2 DEFAULT 'scmpi@lgensol.com',
        p_cc_mail        IN VARCHAR2 DEFAULT NULL
    )
    IS
        v_connection  UTL_SMTP.CONNECTION;
        v_mime_type   VARCHAR2(100);
        v_offset      INTEGER := 1;
        v_chunk_size  INTEGER := 4000;
        v_length      INTEGER;
        v_to_mail     VARCHAR2(4000);
        v_cc_mail     VARCHAR2(4000);
        v_list        VARCHAR2(4000);
        v_addr        VARCHAR2(500);
        v_pos         NUMBER;
    BEGIN
        -- 구분자 통일 (세미콜론 -> 콤마)
        v_to_mail := F_NORMALIZE_DELIM(p_to_mail);
        v_cc_mail := F_NORMALIZE_DELIM(p_cc_mail);
 
        IF v_to_mail IS NULL THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', '수신자 없음', 'CLOB', p_sender);
            RETURN;
        END IF;
 
        IF (p_html_yn = 'Y') THEN
            v_mime_type := 'text/html; charset=UTF-8';
        ELSE
            v_mime_type := 'text/plain; charset=UTF-8';
        END IF;
 
        -- SMTP 연결
        v_connection := UTL_SMTP.OPEN_CONNECTION(C_SMTP_HOST, C_SMTP_PORT);
        UTL_SMTP.HELO(v_connection, C_SMTP_HOST);
        UTL_SMTP.MAIL(v_connection, p_sender);
 
        -- TO: 다중 수신자 처리
        v_list := v_to_mail || ',';
        LOOP
            v_pos := INSTR(v_list, ',');
            EXIT WHEN v_pos = 0;
            v_addr := TRIM(SUBSTR(v_list, 1, v_pos - 1));
            IF v_addr IS NOT NULL THEN
                UTL_SMTP.RCPT(v_connection, v_addr);
            END IF;
            v_list := SUBSTR(v_list, v_pos + 1);
        END LOOP;
 
        -- CC: 다중 수신자 처리
        IF v_cc_mail IS NOT NULL THEN
            v_list := v_cc_mail || ',';
            LOOP
                v_pos := INSTR(v_list, ',');
                EXIT WHEN v_pos = 0;
                v_addr := TRIM(SUBSTR(v_list, 1, v_pos - 1));
                IF v_addr IS NOT NULL THEN
                    UTL_SMTP.RCPT(v_connection, v_addr);
                END IF;
                v_list := SUBSTR(v_list, v_pos + 1);
            END LOOP;
        END IF;
 
        -- 헤더 작성
        UTL_SMTP.OPEN_DATA(v_connection);
        UTL_SMTP.WRITE_DATA(v_connection, 'From: '            || p_sender   || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_connection, 'To: '              || v_to_mail  || C_CRLF);
        IF v_cc_mail IS NOT NULL THEN
            UTL_SMTP.WRITE_DATA(v_connection, 'Cc: '          || v_cc_mail  || C_CRLF);
        END IF;
        UTL_SMTP.WRITE_DATA(v_connection, 'Subject: '         || p_subject  || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_connection, 'MIME-Version: 1.0'              || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_connection, 'Content-Type: '    || v_mime_type || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_connection, C_CRLF);
 
        -- CLOB 본문을 청크 단위로 전송
        v_length := DBMS_LOB.GETLENGTH(p_body_clob);
        WHILE v_offset <= v_length LOOP
            UTL_SMTP.WRITE_DATA(v_connection, DBMS_LOB.SUBSTR(p_body_clob, v_chunk_size, v_offset));
            v_offset := v_offset + v_chunk_size;
        END LOOP;
 
        UTL_SMTP.CLOSE_DATA(v_connection);
        UTL_SMTP.QUIT(v_connection);
 
        P_LOG_MAIL(v_to_mail, p_subject, 'SUCCESS', NULL, 'CLOB', p_sender, v_cc_mail);
 
    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', SQLERRM, 'CLOB', p_sender, v_cc_mail);
            BEGIN
                UTL_SMTP.QUIT(v_connection);
            EXCEPTION
                WHEN OTHERS THEN NULL;
            END;
            RAISE;
    END P_SEND_MAIL_CLOB;
 
    /*===========================================
      메일 발송 통계 조회
    ===========================================*/
    FUNCTION F_MAIL_STATS (
        p_from_date  IN DATE DEFAULT TRUNC(SYSDATE, 'MM'),
        p_to_date    IN DATE DEFAULT SYSDATE
    ) RETURN T_MAIL_STATS_TAB PIPELINED
    IS
        v_rec T_MAIL_STATS_REC;
    BEGIN
        FOR r IN (
            SELECT TRUNC(SEND_DATE) AS SEND_DT,
                   MAIL_TYPE,
                   STATUS,
                   COUNT(*)          AS CNT,
                   COUNT(DISTINCT TO_MAIL) AS RCPT_CNT
              FROM TB_MAIL_LOG
             WHERE SEND_DATE BETWEEN p_from_date AND p_to_date + 1
             GROUP BY TRUNC(SEND_DATE), MAIL_TYPE, STATUS
             ORDER BY 1 DESC, 2, 3
        ) LOOP
            v_rec.SEND_DT   := r.SEND_DT;
            v_rec.MAIL_TYPE := r.MAIL_TYPE;
            v_rec.STATUS    := r.STATUS;
            v_rec.CNT       := r.CNT;
            v_rec.RCPT_CNT  := r.RCPT_CNT;
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
    END F_MAIL_STATS;

 
END PKG_SEND_MAIL;
/
