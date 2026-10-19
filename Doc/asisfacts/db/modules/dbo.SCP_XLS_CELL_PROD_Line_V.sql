



CREATE VIEW [dbo].[SCP_XLS_CELL_PROD_Line_V]
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
 * 2025.08.01   hrkim	  PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 : Cell 완성 공정 하드코딩 변경
 */

	/* 2025.08.01 PJ20257329 변경전 Start 
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
	 2025.08.01 PJ20257329 변경전 End */
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- 2025.08.01 PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 :  Cell 완성 공정 하드코딩 변경  ----- Start 
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	WITH CELL_ITEM_LIST AS (
		SELECT DISTINCT CELL_ITEM_ID   
          FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (NOLOCK)   
         WHERE  0 = 0  
           AND DIVISION_ID  = '40'  
           AND MEASURE      = 'PROD'  
	), OPERATION_LIST AS (
		SELECT DISTINCT SEGMENT1 AS OPERATION_ID  
		 FROM SCM_ADM_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK)  
		WHERE 1=1  
		  AND LK.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'  
		  AND LK.SEGMENT3	 = 'A'	 -- 공정그룹(Cell)
		  AND LK.ATTRIBUTE1  = 'Y'  -- A3000/A9000 Cell Assembly/Packaging 공정 (SCP가 생산계획을 수립하는 Cell Final공정)  
	 )
     SELECT DISTINCT TT.DIVISION_ID,TT.PLANT_SITE_ID,TT.LINE_ID,TT.ITEM_ID  
      FROM SCP_MST_TACT_TIME TT WITH (NOLOCK) 
		   INNER LOOP JOIN CELL_ITEM_LIST CL
						ON CL.CELL_ITEM_ID = TT.ITEM_ID 
		   INNER LOOP JOIN OPERATION_LIST  OL
						ON OL.OPERATION_ID = TT.OPERATION_ID 
     WHERE 0 = 0  
       AND TT.DIVISION_ID = '40'  
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
 	 -- 2025.08.01 PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 :  Cell 완성 공정 하드코딩 변경 ------- End 
 	----------------------------------------------------------------------------------------------------------------------------------------------------------------------
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




