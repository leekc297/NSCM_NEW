
/****************************************************************************
  * PROJECT       : PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
  * VIEW NAME     : SCM_MST_BOM_SN_V
  * DESCRIPTION   : SCP 대치 BOM
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-03-08   SDS          PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선: SCM_MST_BOM_SN_V VIEW
  *								- 대치 BOM에서 계획 수립 대상은 한 개로 제한
  ****************************************************************************/

CREATE VIEW [dbo].[SCM_MST_BOM_SN_V] AS

   SELECT *
   FROM DBO.SCM_MST_MODEL_BOM WITH(NOLOCK)
   WHERE 1=1
	;

