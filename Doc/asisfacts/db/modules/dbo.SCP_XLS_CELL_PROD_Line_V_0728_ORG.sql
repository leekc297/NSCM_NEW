


CREATE VIEW [dbo].[SCP_XLS_CELL_PROD_Line_V_0728_ORG]
 AS
/*
 * Program ID   : SCP_XLS_CELL_PROD_Line_V
 * Description  : SCP_ANL_TACT_TIME 정보와 SCP_XLS_PSI_GLOBAL_SMALL_CELL를 ITEM_ID별로 비교하여 Line 정보를 보여줌
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019. 03. 19  KTH      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.04.08   KTH            LINE LOAD율 수정
 */

      SELECT DISTINCT DIVISION_ID,PLANT_SITE_ID,LINE_ID,ITEM_ID
      FROM SCP_MST_TACT_TIME  WITH (NOLOCK)
      WHERE 0 = 0
      AND DIVISION_ID = '40'
      AND OPERATION_ID         IN ( 'A3000','A9000')
      AND ITEM_ID IN (SELECT DISTINCT CELL_ITEM_ID 
                        FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (NOLOCK) 
                       WHERE  0 = 0
                         AND DIVISION_ID  = '40'
                         AND MEASURE      = 'PROD'
  --                       AND ITEM_ID      = @p_item_id
                      )
      EXCEPT 
      (
        SELECT DISTINCT DIVISION_ID,SITE_ID, PROD_LINE,CELL_ITEM_ID
        FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  WITH (NOLOCK)
        WHERE 0 = 0
        AND DIVISION_ID   = '40'
        AND MEASURE       = 'PROD'
--        AND CELL_ITEM_ID  = @p_item_id
      ) 

    --UNION ALL
    --SELECT DISTINCT DIVISION_ID,SITE_ID, PROD_LINE,CELL_ITEM_ID--,LAST_UPDATED_BY
    --    FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  WITH (NOLOCK)
    --    WHERE 0 = 0
    --    AND DIVISION_ID   = '40'
    --    AND MEASURE       = 'PROD'
    --    AND ATTRIBUTE2    = 'Y'
--        AND LAST_UPDATED_BY NOT IN ( 'scp_batch')--,'PR_SCP_XLS_EXCEL_BODY_QUERY')




