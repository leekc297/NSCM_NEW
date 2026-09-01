CREATE OR REPLACE FUNCTION SCM_ARR_SPL_VAL
(
    P_STEXT  IN VARCHAR2                /* 대상 문자열 */
  , P_STR    IN VARCHAR2 DEFAULT '|'    /* 구분기호(Default '|') */
  , P_IDX    IN PLS_INTEGER             /* 배열 인덱스 */
)
RETURN VARCHAR2
/*
 * FUNCTION NAME : SCM_ARR_SPL_VAL
 * DESCRIPTION   : 구분기호로 나눈 배열의 인덱스 요소 반환
 * PROGRAM HISTORY
 *--------------------------------------------------------------
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_WORD        VARCHAR2(32767 CHAR);   /* 반환할 문자 */
    V_STEXT_DATA  VARCHAR2(32767 CHAR);
    V_NUM         PLS_INTEGER;
    V_STR         VARCHAR2(32767 CHAR);

BEGIN

    V_NUM        := 1;
    V_STR        := TRIM(P_STR);
    V_STEXT_DATA := TRIM(P_STEXT) || V_STR;

    WHILE P_IDX >= V_NUM LOOP

        IF INSTR(V_STEXT_DATA, V_STR) > 0 THEN
            /* 문자열의 인덱스 위치의 요소를 반환 */
            V_WORD := SUBSTR(V_STEXT_DATA, 1, INSTR(V_STEXT_DATA, V_STR) - 1);
            V_WORD := TRIM(V_WORD);

            /* 반환된 문자는 버린후 좌우공백 제거 */
            V_STEXT_DATA := TRIM(SUBSTR(V_STEXT_DATA, NVL(LENGTH(V_WORD), 0) + 2));
        ELSE
            V_WORD := NULL;
        END IF;

        V_NUM := V_NUM + 1;

    END LOOP;

    RETURN V_WORD;

END;
/
