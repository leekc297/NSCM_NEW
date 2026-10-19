



CREATE VIEW [dbo].[SCP_PLN_UTILIZATION_V] 
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_UTILIZATION_V
  * DESCRIPTION   : 
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018.02.02   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
  /*
  PLAN_ID,MODELING_ID,SEQ,PLAN_NAME,MASTER_ID,OUT_VERSION_ID
  */
  ****************************************************************************/
SELECT 
   PLAN_ID
  ,MODELING_ID
  ,SEQ AS PLAN_SEQ
  ,PLAN_NAME
  ,MASTER_ID
  ,OUT_VERSION_ID
  ,RESOURCE_ID
  ,WORK_DATE
  ,DIVISION_ID
  ,PLAN_TYPE
  ,WORK_TIME
  ,RUN_TIME
  ,OFF_TIME
  ,SETUP_TIME
  ,SLACK_TIME
  ,OFF_SETUP_TIME
  
FROM [DBO].[SCP_ENG_UTILIZATION_O_SN] WITH(NOLOCK)
