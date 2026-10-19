





CREATE VIEW [dbo].[SCP_ANL_PSI_GLOBAL_V] AS
/****************************************************************************
  * PROJECT       : LG ENSOL SCP PRJ.
  * VIEW NAME     : SCP_ANL_PSI_GLOBAL
  * DESCRIPTION   : WEEKLY SCP FINAL PLAN GLOBAL PSI
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE        IN CHARGE    DESCRIPTION
  *--------------------------------------------------------------
  * 2022.06.22   KSG          INITIAL C20220620-000500 [SCM PI팀] MKT_FCST Waterfall 內 Safety Stock/Gap measure 추가를 위한 View 생성 요청 건 : DM 용
  ****************************************************************************/

SELECT division_id, plan_start_yyyymmdd, plan_type, seq, to_site, item_id, yyyymmdd
     , SUM(ISNULL(WH_IN_BALANCE, 0)) AS WH_IN_BALANCE
     , SUM(ISNULL(SAFETY_STOCK, 0))  AS SAFETY_STOCK
     , SUM(ISNULL(WH_IN_BALANCE, 0)) - SUM(ISNULL(SAFETY_STOCK, 0)) AS GAP
FROM (
        SELECT A.division_id, A.plan_start_yyyymmdd, A.plan_type, A.seq, A.to_site, A.item_id, A.yyyymmdd
             , CASE WHEN A.measure = 'WH_IN_BALANCE' THEN  A.qty ELSE 0 END WH_IN_BALANCE
             , CASE WHEN A.measure = 'SAFETY_STOCK'  THEN  A.qty ELSE 0 END SAFETY_STOCK
        FROM SCP_ANL_PSI_GLOBAL  A WITH(NOLOCK)
           , SCM_MST_PLAN        P WITH(NOLOCK)
           , SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
        WHERE 1=1
        AND D.DIVISION_ID  = A.DIVISION_ID -- EE 존재
        AND D.PLAN_ID      = P.PLAN_ID
        AND D.PLAN_TYPE    = A.PLAN_TYPE
        AND D.PLAN_SEQ     = A.SEQ
        AND A.PLAN_TYPE    = 'FN'
        AND D.CONFIRM_FLAG = 'Y'

        AND P.DIVISION_ID  = A.DIVISION_ID -- EE 존재
        AND P.PLAN_NAME    = A.PLAN_START_YYYYMMDD
        AND P.PLAN_CYCLE   = 'WEEKLY'

        AND measure       IN ('WH_IN_BALANCE', 'SAFETY_STOCK')
        AND qty           <> 0

		-- Safety Stock 대상만 처리
		AND EXISTS (SELECT 1
		            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH(NOLOCK)
                    WHERE  LD.LOOKUP_TYPE =  'DAYS_SAFETY_STOCK'
					AND    LD.valid_yn    = 'Y'
					AND    LD.SEGMENT2    = A.to_site
					AND    LD.SEGMENT3    = A.item_id
		           )

     ) a
GROUP BY division_id, plan_start_yyyymmdd, plan_type, seq, to_site, item_id, yyyymmdd
;

