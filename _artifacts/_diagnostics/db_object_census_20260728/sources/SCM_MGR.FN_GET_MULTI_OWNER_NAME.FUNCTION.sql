FUNCTION FN_GET_MULTI_OWNER_NAME
(
    P_OWNER  IN VARCHAR2
  , P_DELIM  IN VARCHAR2
  , P_FLAG   IN VARCHAR2
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_MULTI_OWNER_NAME
  * DESCRIPTION   : 여러 Owner(User_ID
  *
  * INPUT         : NVARCHAR
  * OUTPUT        : NVARCHAR
  * USAGE         : SELECT dbo.FN_GET_MULTI_OWNER_NAME('kimsuhyeon,youngsangkim', ',', '1')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-08-03   JYE                  INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
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

            IF (P_FLAG = '1') THEN
                BEGIN
                    SELECT USER_NAME_EN
                      INTO V_USER_NAME
                      FROM SCM_MST_SSO_USER_INFO
                     WHERE UPPER(USER_ID) = UPPER(TRIM(SUBSTR(V_OWNER, 1, V_FOUND_IDX - 1)));
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                END;
            ELSE
                BEGIN
                    SELECT USER_NAME
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

        IF (P_FLAG = '1') THEN
            BEGIN
                SELECT V_RE_STR || USER_NAME_EN
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        ELSE
            BEGIN
                SELECT V_RE_STR || USER_NAME
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        END IF;

    ELSE

        IF (P_FLAG = '1') THEN
            BEGIN
                SELECT USER_NAME_EN
                  INTO V_RE_STR
                  FROM SCM_MST_SSO_USER_INFO
                 WHERE UPPER(USER_ID) = UPPER(TRIM(V_OWNER));
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;
        ELSE
            BEGIN
                SELECT USER_NAME
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