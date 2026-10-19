
CREATE VIEW [dbo].[SCP_PLN_ESS_ELEC_REQ_V] AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * VIEW NAME     : SCP_PLN_ESS_ELEC_REQ_V
  * DESCRIPTION   : ESS사업부의 자동차전지사업부로의 전극소요량을 
  *                 DM MKT FCST에 반영하기위한 뷰
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-04-25   YYDOK        INITIAL
  ****************************************************************************/
SELECT M.DIVISION_ID,
       M.PLAN_START_YYYYMMDD,
       M.PLAN_TYPE,
       M.SEQ,
       M.ITEM_ID,
       DBO.FN_GET_ITEM_NICKNAME(M.DIVISION_ID,M.ITEM_ID) AS NICK_NAME,
       M.YYYYMMDD,
       M.TO_SITE,
       ROUND((ISNULL(M.REQ_QTY ,0) - ISNULL(M.STOCK_QTY,0)),0) AS DM_FCST_QTY
  FROM SCP_PLN_MATERIAL_PLAN M WITH(NOLOCK)
 WHERE 1=1
   AND M.DIVISION_ID      = '82'
   AND LEFT(M.ITEM_ID,5) IN ('APCAN','APCCA','APCCS')
   AND M.PLAN_TYPE        = 'FN'
   AND (ISNULL(M.REQ_QTY ,0) - ISNULL(M.STOCK_QTY,0)) > 0 
   AND EXISTS ( SELECT 'X'
                  FROM SCP_PLAN_VERSION_V V
                 WHERE V.DIVISION_ID          = M.DIVISION_ID
                   AND V.PLAN_START_YYYYMMDD  = M.PLAN_START_YYYYMMDD
                   AND V.PLAN_TYPE            = M.PLAN_TYPE
                   AND V.PLAN_SEQ             = M.SEQ
                   AND V.CONFIRM_FLAG         = 'Y')
  ;
