FUNCTION FN_GET_DM_MKT_OWNER_NAME
(
    P_OWNER     IN VARCHAR2
  , P_DELIM     IN VARCHAR2
  , P_LANGUAGE  IN VARCHAR2
)
RETURN VARCHAR2
/*
 * Program ID   : FN_GET_SSP_MKT_OWNER_NAME
 * Description  : PROJECT OWNER
 *
 *
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.11.01   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
 * 2019.12.18	hwi1993	DM 에서 사용하기 위해 복사함 ( FN_GET_SSP_MKT_OWNER_NAME ). 혹시모를 변경을 피하기 위해
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_IDX        PLS_INTEGER;
    V_FOUND_IDX  PLS_INTEGER;
    V_RE_STR     VARCHAR2(32767 CHAR);
    V_USER_NAME  VARCHAR2(32767 CHAR);
    V_OWNER      VARCHAR2(32767 CHAR) := P_OWNER;

BEGIN

    V_IDX       := 1;
    V_FOUND_IDX := INSTR(V_OWNER, P_DELIM);
    V_RE_STR    := '';

    IF (V_FOUND_IDX <> 0) THEN

        WHILE (V_FOUND_IDX > 0) LOOP

            IF (P_LANGUAGE = 'KO') THEN
                BEGIN
                    SELECT USER_NAME || '(' || USER_ID || ')'
                      INTO V_USER_NAME
                      FROM SCM_MST_SSO_USER_INFO
                     WHERE UPPER(USER_ID) = UPPER(TRIM(SUBSTR(V_OWNER, 1, V_FOUND_IDX - 1)));
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;
            ELSE
                BEGIN
                    SELECT USER_NAME_EN || '(' || USER_ID || ')'
                      INTO V_USER_NAME
                      FROM SCM_MST_SSO_USER_INFO
                     WHERE UPPER(USER_ID) = UPPER(TRIM(SUBSTR(V_OWNER, 1, V_FOUND_IDX - 1)));
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;
            END IF;

            V_RE_STR := TRIM(V_RE_STR) || V_USER_NAME || ',';

            V_OWNER     := SUBSTR(V_OWNER, V_FOUND_IDX + 1, LENGTH(V_OWNER) - V_FOUND_IDX);
            V_IDX       := V_IDX + 1;
            V_FOUND_IDX := INSTR(V_OWNER, P_DELIM);

        END LOOP;

        IF (P_LANGUAGE = 'KO') THEN
            BEGIN
                SELECT V_RE_STR || USER_NAME || '(' || USER_ID || ')'
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        ELSE
            BEGIN
                SELECT V_RE_STR || USER_NAME_EN || '(' || USER_ID || ')'
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;

    ELSE

        IF (P_LANGUAGE = 'KO') THEN
            BEGIN
                SELECT USER_NAME || '(' || USER_ID || ')'
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        ELSE
            BEGIN
                SELECT USER_NAME_EN || '(' || USER_ID || ')'
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;

    END IF;

    RETURN V_RE_STR;

END;