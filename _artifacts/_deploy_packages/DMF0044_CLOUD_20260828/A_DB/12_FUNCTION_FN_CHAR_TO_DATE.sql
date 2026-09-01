CREATE OR REPLACE FUNCTION FN_CHAR_TO_DATE
(
    P_YYYYMMDD  IN VARCHAR2
)
RETURN DATE
/****************************************************************************
  * PROJECT       : LG CHEM RCCP PRJ.
  * FUNCTION NAME : FN_TO_DATE
  * DESCRIPTION   : 년월일 기준으로 DATETIME으로 변환하여 리턴한다.
  *
  * INPUT         : @P_YYYYMMDD : 년월일
  * OUTPUT        : DATETIME
  * USAGE         : SELECT DBO.FN_GET_YYYYWW('20160530')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-31   YYDOK        INITIAL
  * 2026.07.05   ZIONEX   [PJ202650304] NextSCM Migration
  ****************************************************************************/
IS

    X_DATE  DATE;

BEGIN

    X_DATE := TO_DATE(P_YYYYMMDD, 'YYYYMMDD');

    RETURN X_DATE;

END FN_CHAR_TO_DATE;
/
