FUNCTION FN_GET_NUMER_TO_STRING
(
    P_INPUT      IN NUMBER
  , P_IDIGITCNT  IN PLS_INTEGER
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_NUMER_TO_STRING
  * DESCRIPTION   : 메일보낼때 숫자표시용
  * INPUT         : 변환할 숫자, 소수점자리수
  * OUTPUT        : 콤마찍힌 스트링숫자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
    DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-06-03   HWI1993 메일보낼때 숫자표시용 ( 인풋이 NUMERIC 형이어야 함. )
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_INPUT       NUMBER := P_INPUT;
    V_IDIGIT_CNT  PLS_INTEGER := P_IDIGITCNT;
    V_STR_INPUT   VARCHAR2(39 CHAR);
    V_RET_VALUE   VARCHAR2(50 CHAR);
    V_IDOT_INDEX  PLS_INTEGER;
    V_STR_INT     VARCHAR2(30 CHAR);
    V_STR_DEC     VARCHAR2(8 CHAR);
    V_SIGN        VARCHAR2(1 CHAR);
    V_I           PLS_INTEGER;

BEGIN

    V_SIGN := '';
    IF ( V_INPUT < 0 ) THEN
        V_SIGN  := '-';
        V_INPUT := V_INPUT * -1;
    END IF;

    V_INPUT      := NVL(V_INPUT, 0);
    V_IDIGIT_CNT := NVL(V_IDIGIT_CNT, 0);

    V_STR_INPUT  := TO_CHAR(V_INPUT, 'FM' || LPAD('0', 30, '9') || '.00000000');
    V_IDOT_INDEX := INSTR(V_STR_INPUT, '.');

    V_STR_INT := SUBSTR(V_STR_INPUT, 1, V_IDOT_INDEX - 1);                                 /* 정수부 */
    V_STR_DEC := SUBSTR(V_STR_INPUT, V_IDOT_INDEX + 1, LENGTH(V_STR_INPUT) - V_IDOT_INDEX); /* 소수부 */

    V_I := 0;
    V_RET_VALUE := SUBSTR(V_STR_INT, 1, MOD(LENGTH(V_STR_INT), 3));

    WHILE ( V_I < FLOOR(LENGTH(V_STR_INT) / 3) ) LOOP

        V_RET_VALUE := V_RET_VALUE || CASE WHEN V_RET_VALUE IS NOT NULL THEN ',' ELSE '' END
                    || SUBSTR(V_STR_INT, MOD(LENGTH(V_STR_INT), 3) + 1 + V_I * 3, 3 );

        V_I := V_I + 1;
    END LOOP;

    V_RET_VALUE := V_RET_VALUE ||
        CASE WHEN V_IDIGIT_CNT > 0
             THEN '.' || SUBSTR(REPLACE(TO_CHAR(TRUNC(V_INPUT - FLOOR(V_INPUT), V_IDIGIT_CNT), 'FM0.00000000'), '0.', ''), 1, V_IDIGIT_CNT)
             ELSE '' END;

    RETURN V_SIGN || V_RET_VALUE;

END;

/* SELECT DBO.TEST_DM_fnSetComma(NULL, 0) */