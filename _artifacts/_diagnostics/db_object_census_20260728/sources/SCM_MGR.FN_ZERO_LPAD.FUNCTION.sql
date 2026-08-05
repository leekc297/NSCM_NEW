FUNCTION FN_ZERO_LPAD
(
    P_STRING  IN VARCHAR2
  , P_INT     IN NUMBER
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_ZERO_LPAD
  * DESCRIPTION   : 특정자릿수만큼 왼쪽에 0을 붙여서 리턴한다.
  *
  * INPUT         : @P_STRING : 문자열,@X_INT 자릿수
  * OUTPUT        : 0으로 자릿수만큼 LPAD처리한 문자열
  * USAGE         : SELECT DBO.FN_ZERO_LPAD('1',2) RETURNS '01'
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-30   YYDOK        INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS
BEGIN

    RETURN NVL(RPAD('0', P_INT - LENGTH(RTRIM(P_STRING)), '0'), '') || P_STRING;

END;