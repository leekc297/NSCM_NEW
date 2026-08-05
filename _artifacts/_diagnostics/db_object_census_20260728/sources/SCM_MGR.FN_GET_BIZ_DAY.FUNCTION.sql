FUNCTION FN_GET_BIZ_DAY
(
    P_CUR_DATE  IN VARCHAR2
  , P_DAY_CNT   IN PLS_INTEGER
)
RETURN VARCHAR2
/****************************************************************************
  * PROJECT       : LG CHEM SCM PRJ.
  * FUNCTION NAME : FN_GET_BIZ_DAY
  * DESCRIPTION   : @P_CUR_DATE 에 영업일로 @P_DAY_CNT 만큼의 일자를 더한 날짜를 리턴함.
  *
  * INPUT         : @P_CUR_DATE : 현재일자
					@P_DAY_CNT : 더해줄 일자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-03-25   HWI1993		INITIAL
  * 2026-07-03   ZIONEX  [PJ202650304]  NextSCM Migration
  ****************************************************************************/
AS

    V_RTN_YYYYMMDD  VARCHAR2(8 CHAR);
    V_CNT           PLS_INTEGER;    /* @ADD_DAY 에 포함된 영업일 갯수 */
    V_ADD_DAY       PLS_INTEGER;    /* 더해야할 총일자수 */
    V_DT            DATE;
    V_DW            PLS_INTEGER;

BEGIN

    V_CNT     := 0;
    V_ADD_DAY := 0;

    WHILE ( V_CNT < P_DAY_CNT ) LOOP

        V_ADD_DAY := V_ADD_DAY + 1;

        /* DATEPART(WEEKDAY): MSSQL @@DATEFIRST 기본(7)=일요일1. NLS 비의존 ISO주 기반 산출. */
        V_DT := TO_DATE(P_CUR_DATE, 'YYYYMMDD') + V_ADD_DAY;
        V_DW := MOD(TRUNC(V_DT) - TRUNC(V_DT, 'IW') + 1, 7) + 1;

        IF (V_DW NOT IN (7, 1)) THEN
            V_CNT := V_CNT + 1;
        END IF;

    END LOOP;

    RETURN TO_CHAR(TO_DATE(P_CUR_DATE, 'YYYYMMDD') + V_ADD_DAY, 'YYYYMMDD');

END;