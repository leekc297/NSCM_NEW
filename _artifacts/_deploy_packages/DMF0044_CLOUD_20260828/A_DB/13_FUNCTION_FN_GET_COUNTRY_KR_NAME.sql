CREATE OR REPLACE FUNCTION FN_GET_COUNTRY_KR_NAME
(
    P_COUNTRY_CODE IN VARCHAR2
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : [FN_GET_COUNTRY_KR_NAME]
  * DESCRIPTION   : COUNTRY 약어를 받아서 KR_NAME 을 리턴함
  *
  * INPUT         : @P_COUNTRY_CODE : 2자리 약어
  * OUTPUT        : COUNTRY_KR_NAME
  * USAGE         : SELECT DBO.[FN_GET_COUNTRY_KR_NAME]('DE')
			        SELECT DBO.[FN_GET_COUNTRY_KR_NAME]('KR')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-05-04   HWI1993	INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_RESULT_NAME VARCHAR2(50 CHAR);

BEGIN

    SELECT A.COUNTRY_KR_NAME
      INTO V_RESULT_NAME
      FROM SCM_MST_COUNTRY A
     WHERE A.COUNTRY = P_COUNTRY_CODE;

    RETURN V_RESULT_NAME;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;

END;
/
