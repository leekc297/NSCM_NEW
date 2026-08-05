FUNCTION UF_FX_STRING_SPLIT
(
    P_STR    IN VARCHAR2
  , P_DELIM  IN VARCHAR2
)
RETURN T_UF_FX_STRING_SPLIT_TAB PIPELINED
/*
 * FUNCTION NAME : UF_FX_STRING_SPLIT
 * DESCRIPTION   : 구분자로 문자열 분리(nr,token 반환)
 * PROGRAM HISTORY
 *--------------------------------------------------------------
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_IDX        PLS_INTEGER;
    V_FOUND_IDX  PLS_INTEGER;
    V_STR        VARCHAR2(32767) := P_STR;
    V_NR         PLS_INTEGER := 0;

BEGIN

    IF P_STR IS NOT NULL THEN

        V_IDX       := 1;
        V_FOUND_IDX := INSTR(V_STR, P_DELIM);

        WHILE (V_FOUND_IDX > 0) LOOP
            V_NR := V_NR + 1;
            PIPE ROW (T_UF_FX_STRING_SPLIT_ROW(V_NR, TRIM(SUBSTR(V_STR, 1, V_FOUND_IDX - 1))));
            V_STR       := SUBSTR(V_STR, V_FOUND_IDX + 1);
            V_IDX       := V_IDX + 1;
            V_FOUND_IDX := INSTR(V_STR, P_DELIM);
        END LOOP;

        V_NR := V_NR + 1;
        PIPE ROW (T_UF_FX_STRING_SPLIT_ROW(V_NR, TRIM(V_STR)));

    END IF;

    RETURN;

END;