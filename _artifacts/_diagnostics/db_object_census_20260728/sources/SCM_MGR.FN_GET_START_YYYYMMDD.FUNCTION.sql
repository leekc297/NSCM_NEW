FUNCTION FN_GET_START_YYYYMMDD
(
    P_YYYYWW  IN VARCHAR2
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_START_YYYYMMDD
  * DESCRIPTION   : 특정년주차(YYYYWW)의 시작일자YYYYMMDD한다.
  *
  * INPUT         : @P_YYYYWW : 년주차YYYYWW
  * OUTPUT        : 해당주차의 시작일자 YYYYMMDD
  * USAGE         :
  *                SELECT DBO.FN_GET_START_YYYYMMDD('201622');
  *
  *                SELECT DBO.FN_GET_START_YYYYMMDD(NULL);
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  * 2017-05-01   YYDOK        BASIS START DATE가 PARTIAL WEEK기준이라,FULL WEEK기준으로 변경함
  *                           ( MIN(BASIS_YYYYMMDD ) )
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_X_YYYYMMDD VARCHAR2(8 CHAR);

BEGIN

    IF P_YYYYWW IS NULL THEN

        SELECT MIN(B.BASIS_YYYYMMDD)
          INTO V_X_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M B
         WHERE B.ISO_YYYYWW = ( SELECT X.ISO_YYYYWW
                                  FROM SCM_SYS_CALENDAR_M X
                                 WHERE X.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
                                   AND ROWNUM <= 1 );

    ELSE

        SELECT MIN(B.BASIS_YYYYMMDD)
          INTO V_X_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M B
         WHERE B.ISO_YYYYWW = P_YYYYWW;

    END IF;

    RETURN V_X_YYYYMMDD;

END;