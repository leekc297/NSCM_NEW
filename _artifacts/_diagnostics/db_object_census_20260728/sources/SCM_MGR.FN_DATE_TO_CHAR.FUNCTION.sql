FUNCTION FN_DATE_TO_CHAR
(
    P_DATE  IN DATE
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_TO_DATE
  * DESCRIPTION   : 년월일 기준으로 DATETIME으로 변환하여 리턴한다.
  *
  * INPUT         : @P_YYYYMMDD : 년월일
  * OUTPUT        : DATETIME
  * USAGE         : SELECT DBO.FN_DATE_TO_CHAR(GETDATE())
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2016-05-31   YYDOK        INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_X_YYYYMMDD VARCHAR2(8 CHAR);

BEGIN

    V_X_YYYYMMDD := TO_CHAR(P_DATE, 'YYYYMMDD');

    RETURN V_X_YYYYMMDD;

END;