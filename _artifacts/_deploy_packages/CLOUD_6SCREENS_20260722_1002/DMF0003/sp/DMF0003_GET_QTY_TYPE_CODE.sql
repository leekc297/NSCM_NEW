CREATE OR REPLACE PROCEDURE           "DMF0003_GET_QTY_TYPE_CODE"
(
    O_RC1 OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_BUCKET_TYPE_CODE                                                       */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
/* 2026.06.08  ZIONEX       [PJ202650304] NextSCM Migration : 결과셋 반환 복원 — SELECT INTO(ORA-01422)를 OUT SYS_REFCURSOR + OPEN FOR 로 수정 */
BEGIN

  OPEN O_RC1 FOR
  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
  WHERE  L.LOOKUP_TYPE = 'MKT_FCST_UNIT_QTY'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ;

END;
/
