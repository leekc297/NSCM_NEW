/****************************************************************************************************/
/* Program ID  : SCP0070_GET_QTY_TYPE_CODE                                                          */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2021/07/20  KDW       Initial Release PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)  */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SCP0070_GET_QTY_TYPE_CODE]  
AS
BEGIN
	
  SET NOCOUNT ON;

  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
  WHERE  L.LOOKUP_TYPE = 'MKT_FCST_UNIT_QTY'
  AND    L.VALID_YN    = 'Y'
  ORDER BY DISPLAY_SEQ
  ;

END
