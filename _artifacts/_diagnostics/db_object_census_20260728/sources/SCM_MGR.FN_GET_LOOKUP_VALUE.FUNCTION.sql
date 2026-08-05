FUNCTION FN_GET_LOOKUP_VALUE
(
    P_PROCEDURE_KEY  IN VARCHAR2   /* using object (table name, xml query file, ) */
  , P_SEQUENCE       IN VARCHAR2   /* 사용 로직 대체 값. 시퀀스 (0,1,2,3) 또는 로직 설명가능한 문자열 CUR_PLAN_COMPANY, CUR_RESULT_PLANT, STORAGE, VENDOR, CUSTOMER */
)
RETURN VARCHAR2
/*
 * Program ID   : [FN_LIST_LOOKUP_VALUE]
 * Description  : hard coding 값 반환
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024/03/01   chkim.68   NERP )  Lookup Value 조회 - 하드코딩 대응 및 개선
 * 2024/03/01   kimcd    COMPANY_ID 등 참고 코드 제외
 ----------------------------------------------------------------------------------------------------
 * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
 */
AS

    V_RTN_VALUE       VARCHAR2(100 CHAR) := '';
    V_PROCEDURE_KEY   VARCHAR2(200 CHAR) := P_PROCEDURE_KEY;
    V_SEQUENCE        VARCHAR2(200 CHAR) := P_SEQUENCE;

BEGIN

    SELECT SEGMENT2
      INTO V_RTN_VALUE
      FROM SCM_CODE_LOOKUP_VALUE
     WHERE LOOKUP_TYPE_CODE = V_PROCEDURE_KEY
       AND SEGMENT1         = V_SEQUENCE
       AND ACTIVE_FLAG      = 'Y'
       AND ROWNUM <= 1;

    RETURN V_RTN_VALUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN V_RTN_VALUE;

END;