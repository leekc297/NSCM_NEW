PACKAGE BODY                     "PKG_SEND_MAIL"
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
            RETURN 'N';
        END IF;

        IF REGEXP_LIKE(TRIM(p_email), '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
            RETURN 'Y';
        ELSE
            RETURN 'N';
        END IF;
    END F_VALIDATE_EMAIL;

    /*===========================================
      다중 메일 주소 유효성 검증 (콤마/세미콜론 구분)
      - 하나라도 유효하지 않으면 'N' 리턴
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
            RETURN 'N';
        END IF;

        -- 세미콜론 -> 콤마 통일
        v_list := F_NORMALIZE_DELIM(p_email_list) || ',';

        LOOP
            v_pos := INSTR(v_list, ',');
            EXIT WHEN v_pos = 0;
            v_addr := TRIM(SUBSTR(v_list, 1, v_pos - 1));
            IF v_addr IS NOT NULL AND F_VALIDATE_EMAIL(v_addr) = 'N' THEN
                RETURN 'N';
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
        p_html_yn        IN VARCHAR2 DEFAULT 'N',
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
        p_html_yn        IN VARCHAR2 DEFAULT 'N',
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
        p_html_yn        IN VARCHAR2 DEFAULT 'N',
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
      대용량 첨부 메일 발송 (파일 없이 CLOB -> UTL_SMTP MIME/Base64)
      - UTL_MAIL 32KB 제한 없음
      - 첨부 CLOB을 UTF-8(+BOM) Base64 로 MIME 첨부
      - 본문/제목 한글 안전(UTF-8 base64)
    ===========================================*/
    PROCEDURE P_SEND_MAIL_CLOB_ATTACH (
        p_to_mail        IN VARCHAR2,
        p_subject        IN VARCHAR2,
        p_body_contents  IN VARCHAR2,
        p_attach_clob    IN CLOB,
        p_attach_name    IN VARCHAR2,
        p_attach_mime    IN VARCHAR2 DEFAULT 'text/csv; charset=UTF-8',
        p_sender         IN VARCHAR2 DEFAULT 'scmpi@lgensol.com',
        p_cc_mail        IN VARCHAR2 DEFAULT NULL,
        p_add_bom        IN VARCHAR2 DEFAULT 'Y'
    )
    IS
        C_BND   CONSTANT VARCHAR2(60) := '====NSCM_MIME_BOUNDARY_8f3a2c====';
        C_STEP  CONSTANT PLS_INTEGER  := 57;   -- 57B -> 76 base64 chars/line
        v_conn      UTL_SMTP.CONNECTION;
        v_to_mail   VARCHAR2(4000);
        v_cc_mail   VARCHAR2(4000);
        v_blob      BLOB;
        v_body_blob BLOB;
        v_destoff   INTEGER := 1;
        v_srcoff    INTEGER := 1;
        v_lang      INTEGER := 0;
        v_warn      INTEGER;
        v_l         INTEGER;
        v_p         INTEGER;

        PROCEDURE rcpt_all(p IN VARCHAR2) IS
            v_s VARCHAR2(4000) := F_NORMALIZE_DELIM(p) || ',';
            v_i NUMBER;
            v_a VARCHAR2(500);
        BEGIN
            LOOP
                v_i := INSTR(v_s, ',');
                EXIT WHEN v_i = 0;
                v_a := TRIM(SUBSTR(v_s, 1, v_i - 1));
                IF v_a IS NOT NULL THEN UTL_SMTP.RCPT(v_conn, v_a); END IF;
                v_s := SUBSTR(v_s, v_i + 1);
            END LOOP;
        END;
    BEGIN
        v_to_mail := F_NORMALIZE_DELIM(p_to_mail);
        v_cc_mail := F_NORMALIZE_DELIM(p_cc_mail);
        IF v_to_mail IS NULL THEN
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', '수신자 없음', 'CLOB_ATTACH', p_sender);
            RETURN;
        END IF;

        -- 첨부 CLOB -> BLOB(UTF-8) (+BOM)
        DBMS_LOB.CREATETEMPORARY(v_blob, TRUE);
        IF NVL(p_add_bom,'Y') = 'Y' THEN
            DBMS_LOB.WRITEAPPEND(v_blob, 3, HEXTORAW('EFBBBF'));
            v_destoff := 4;
        END IF;
        IF p_attach_clob IS NOT NULL AND DBMS_LOB.GETLENGTH(p_attach_clob) > 0 THEN
            DBMS_LOB.CONVERTTOBLOB(v_blob, p_attach_clob, DBMS_LOB.LOBMAXSIZE,
                                   v_destoff, v_srcoff, NLS_CHARSET_ID('AL32UTF8'),
                                   v_lang, v_warn);
        END IF;

        -- 본문 -> BLOB(UTF-8)
        DBMS_LOB.CREATETEMPORARY(v_body_blob, TRUE);
        DBMS_LOB.WRITEAPPEND(v_body_blob,
            UTL_RAW.LENGTH(UTL_RAW.CAST_TO_RAW(NVL(p_body_contents, ' '))),
            UTL_RAW.CAST_TO_RAW(NVL(p_body_contents, ' ')));

        v_conn := UTL_SMTP.OPEN_CONNECTION(C_SMTP_HOST, C_SMTP_PORT);
        UTL_SMTP.HELO(v_conn, C_SMTP_HOST);
        UTL_SMTP.MAIL(v_conn, p_sender);
        rcpt_all(v_to_mail);
        IF v_cc_mail IS NOT NULL THEN rcpt_all(v_cc_mail); END IF;

        UTL_SMTP.OPEN_DATA(v_conn);
        UTL_SMTP.WRITE_DATA(v_conn, 'From: ' || p_sender || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'To: ' || v_to_mail || C_CRLF);
        IF v_cc_mail IS NOT NULL THEN
            UTL_SMTP.WRITE_DATA(v_conn, 'Cc: ' || v_cc_mail || C_CRLF);
        END IF;
        UTL_SMTP.WRITE_DATA(v_conn, 'Subject: =?UTF-8?B?' ||
            UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(p_subject))) ||
            '?=' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'MIME-Version: 1.0' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Type: multipart/mixed; boundary="' || C_BND || '"' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);

        -- 본문 파트
        UTL_SMTP.WRITE_DATA(v_conn, '--' || C_BND || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Type: text/plain; charset=UTF-8' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Transfer-Encoding: base64' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);
        v_l := DBMS_LOB.GETLENGTH(v_body_blob); v_p := 1;
        WHILE v_p <= v_l LOOP
            UTL_SMTP.WRITE_RAW_DATA(v_conn, UTL_ENCODE.BASE64_ENCODE(DBMS_LOB.SUBSTR(v_body_blob, C_STEP, v_p)));
            UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);
            v_p := v_p + C_STEP;
        END LOOP;
        UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);

        -- 첨부 파트
        UTL_SMTP.WRITE_DATA(v_conn, '--' || C_BND || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Type: ' || p_attach_mime || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Transfer-Encoding: base64' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, 'Content-Disposition: attachment; filename="' || p_attach_name || '"' || C_CRLF);
        UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);
        v_l := DBMS_LOB.GETLENGTH(v_blob); v_p := 1;
        WHILE v_p <= v_l LOOP
            UTL_SMTP.WRITE_RAW_DATA(v_conn, UTL_ENCODE.BASE64_ENCODE(DBMS_LOB.SUBSTR(v_blob, C_STEP, v_p)));
            UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);
            v_p := v_p + C_STEP;
        END LOOP;
        UTL_SMTP.WRITE_DATA(v_conn, C_CRLF);

        UTL_SMTP.WRITE_DATA(v_conn, '--' || C_BND || '--' || C_CRLF);
        UTL_SMTP.CLOSE_DATA(v_conn);
        UTL_SMTP.QUIT(v_conn);

        IF DBMS_LOB.ISTEMPORARY(v_blob) = 1 THEN DBMS_LOB.FREETEMPORARY(v_blob); END IF;
        IF DBMS_LOB.ISTEMPORARY(v_body_blob) = 1 THEN DBMS_LOB.FREETEMPORARY(v_body_blob); END IF;

        P_LOG_MAIL(v_to_mail, p_subject, 'SUCCESS', NULL, 'CLOB_ATTACH', p_sender, v_cc_mail);
    EXCEPTION
        WHEN OTHERS THEN
            BEGIN UTL_SMTP.QUIT(v_conn); EXCEPTION WHEN OTHERS THEN NULL; END;
            P_LOG_MAIL(v_to_mail, p_subject, 'FAIL', SQLERRM, 'CLOB_ATTACH', p_sender, v_cc_mail);
            RAISE;
    END P_SEND_MAIL_CLOB_ATTACH;

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