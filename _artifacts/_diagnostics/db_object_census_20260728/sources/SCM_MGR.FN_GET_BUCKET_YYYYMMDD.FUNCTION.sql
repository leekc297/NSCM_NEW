FUNCTION FN_GET_BUCKET_YYYYMMDD
(
    P_BUCKET_NO IN PLS_INTEGER
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_BUCKET_YYYYMMDD
  * DESCRIPTION   : 금주를 버킷번호0로 했을때, 입력버킷번호에 해당하는 시작일자
  *
  * INPUT         : @P_BUCKET_NO : 버킷번호
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
IS

    X_BUCKET_YYYYMMDD VARCHAR2(8 CHAR);

BEGIN

    X_BUCKET_YYYYMMDD := FN_DATE_TO_CHAR(TO_DATE(FN_GET_START_YYYYMMDD(NULL), 'YYYYMMDD') + (0 + 7 * P_BUCKET_NO));

    RETURN X_BUCKET_YYYYMMDD;

EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;

END;