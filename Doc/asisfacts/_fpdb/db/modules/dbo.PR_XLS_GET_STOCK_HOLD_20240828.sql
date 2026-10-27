
/*
 * Program ID   : PR_XLS_GET_STOCK_HOLD
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
 exec [dbo].[PR_XLS_GET_STOCK_HOLD] '20240801'
 */

create PROCEDURE [dbo].[PR_XLS_GET_STOCK_HOLD_20240828]
	@p_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';

	DECLARE  @v_yyyymmdd   nvarchar(max)


	set @v_yyyymmdd = @p_yyyymmdd


	BEGIN TRY		
	

		SELECT FORMAT(STOCK.AVAILABLE_DATE,'yyyy-MM-dd') AS AVAIL_DATE
		     , STOCK.OPERATION_ID
		     , STOCK.WIPHOLD_YN
		     , STOCK.QMS_HOLD_YN
		     , STOCK.LINE_ID
		     , STOCK.STOCK_STATUS
		     , STOCK.FP_APPLY_ITEM_ID
		     , STOCK.NICK_NAME
		     , SUM(QTY2) AS CELL_QTY
             , case when substring(stock.fp_apply_item_id,4,2)  = 'CA' then 'Cathode' 
                   when substring(stock.fp_apply_item_id,4,2)  = 'AN' then 'Anode' 
                   else '' 
                   end as ELECTRODE_TYPE
		 FROM (
           	   SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.STORAGE_ID, CONVERT(VARCHAR,A.CUTOFF_DATE,112) AS CUTOFF_DATE, SEQ                                                                                    
           		    , CASE WHEN A.STOCK_TYPE = 'WIP' THEN 'GMES' WHEN A.STOCK_TYPE = 'INVENTORY' THEN 'ERP' ELSE A.STOCK_TYPE END AS STOCK_TYPE                                                                                         
           		    , A.SECOND_OCV_EXP_DATE   AS SECOND_OCV_EXP_DATE,   A.FP_APPLY_ITEM_ID, A.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID,  A.OPERATION_ID , A.WIPHOLD_YN, A.QMS_HOLD_YN
					, FP_APPLY_WIPQTY_SUM AS FP_APPLY_WIPQTY                                                                                                                                                                                   
           		    , QTY2_SUM AS QTY2                                                                                                                                                                                                       
           		    , MODIFY_FP_APPLY_WIPQTY_MAX AS MODIFY_FP_APPLY_WIPQTY                                                                                                                                                                    
           		    , CAL_QTY_SUM AS CAL_QTY                                                                                                                                                                                                  
           		    , A.ITEM_UOM, A.ITEM_UOM AS QTY_UOM                                                                                                                                                                                         
           		    , A.LOCATION                                                                                                                                                                                                              
           		    , A.PACK_MOVE_QTY_SUM                                                                                                                                                                                                     
           		    , A.PRODUCTION_TYPE                                                                                                                                                                                                       
           		    , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.UNHOLD_EXP_DATE AS AVAILABLE_DATE 
           		    , A.LOT_COUNT_SUM AS LOT_COUNT   
           		    , A.LONG_TERM_FLAG 
           		    , A.QLTY_NO_INSP_FLAG 
           		    , A.POSITION_CATEGORY 
           		    , A.DETAIL_POSITION 
           		    , A.PACK_MOVE_FLAG 
           		    , A.FROM_PLANT_ID 
           		    , A.WORK_REQUEST_MODEL_ID 
           		    , A.VERSION 
           		    , A.PROD_SEQ 
           		    , A.PLM_EC_NO 
           		    , A.SPECIAL_STOCK_INDICATOR 
           		 FROM (                                                                                                                                                                                                                          
           		       SELECT A.*
					        , B.ITEM_UOM
							, B.NICK_NAME                                                                                                                                                                                   
           		            , DENSE_RANK() OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE, A.STOCK_TYPE
							                                , A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE                                       
           		                                            , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                     ORDER BY CASE WHEN A.OPERATION_ID = 'A6000' THEN 2 ELSE 1 END, A.SEQ
											    ) AS RANK_SEQ                                                                                                                                                          
           		            , SUM(A.FP_APPLY_WIPQTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                                      , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE 
			                                                          , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                                      ) AS FP_APPLY_WIPQTY_SUM 
           		            , MAX(A.MODIFY_FP_APPLY_WIPQTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                                             , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE       
           		                                                             , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                                 ) AS MODIFY_FP_APPLY_WIPQTY_MAX
           		            , SUM(case when A.FP_APPLY_OPERATION_ID = 'E2000' then a.qty2 * y.value else A.QTY2/isnull(dbo.FN_GET_REQ_QTY_MODEL(a.plant_id, b.applied_model, a.item_id, a.cutoff_date),1) end)    
							                  OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                               , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE                   
           		                                               , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                               ) AS QTY2_SUM        
           		            , SUM(a.qty2) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                           , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE                   
           		                                           , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
											               ) AS QTY2_SUM_ORG        
           		            , SUM(A.CAL_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                              , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE                           
           		                                              , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                              ) AS CAL_QTY_SUM   
           		            , SUM(A.PACK_MOVE_QTY) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID,A.OPERATION_ID, A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                                    , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE           
           		                                                    , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                                    ) AS PACK_MOVE_QTY_SUM 
           		            , SUM(A.LOT_COUNT) OVER (PARTITION BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID,A.FACTORY_ID, A.STORAGE_ID, A.CUTOFF_DATE
				                                                , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID, B.NICK_NAME, A.LANE, A.FP_APPLY_OPERATION_ID, A.WIPHOLD_YN, A.QMS_HOLD_YN, B.ITEM_UOM, A.LOCATION, A.PRODUCTION_TYPE           
           		                                                , A.LINE_ID, A.STOCK_STATUS, A.WIP_TYPE_CODE, A.AVAILABLE_DATE, A.LONG_TERM_FLAG, A.QLTY_NO_INSP_FLAG, A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PLM_EC_NO
           		                                                ) AS LOT_COUNT_SUM 
           		         FROM SCM_STOCK_H A WITH(NOLOCK) 
						      JOIN SCM_ITEM_M B WITH(NOLOCK)                                                                                                                                                          
           		           ON A.FP_APPLY_ITEM_ID = B.ITEM_ID                                                                                                                                                                                 
           		          AND A.COMPANY_ID       = B.COMPANY_ID                                                                                                                                                                              
           		          AND A.DIVISION_ID      = B.DIVISION_ID                                                                                                                                                                             
           		          AND A.SITE_ID          = B.SITE_ID 
           		              left outer join scm_item_conv_calc_m as y with(nolock)
           		          on  a.company_id = y.company_id
           		          and a.factory_id = y.factory_id
           		          and a.work_request_model_id = y.model_id
           		          and a.version = y.version
           		          and y.operation = 'E2000'
           		          and a.item_id = y.item_id
           		          and y.category = 'Pancake (cell/m)'
           		        WHERE 1 = 1                                                                                                                                                                                 
           		          AND A.CUTOFF_DATE = @v_yyyymmdd
           		          AND ((A.STORAGE_ID  BETWEEN '1000' AND '1999') OR (A.STORAGE_ID >= '5000' AND A.STORAGE_ID < '6000') OR (ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0))                                                               
           		          AND  B.ITEM_CLASS IN (SELECT CLASS_ID FROM SCM_ITEM_CLASS_M WHERE  USE_FLAG = 'Y')                                                                                                                               
           		         -- AND ISNULL(A.SPECIAL_STOCK_INDICATOR, '') NOT IN ('W', 'E', 'O') 
						  and a.company_id = 'G670'
           		          AND A.DIVISION_ID = N'81_UC' 
           		          AND A.SITE_ID = N'A003' 
           		          AND A.PLANT_ID IN (N'G671',N'G672') 
           		          AND A.FP_APPLY_OPERATION_ID IN (N'A5000',N'A7000',N'A8000',N'A9000',N'E2000') 
						  AND A.STOCK_TYPE = 'WIP'
		              ) A                                                                                                                                                                                                                           
		        WHERE RANK_SEQ = 1                                   
		      ) as stock
		where 1 = 1
		  and (stock.wiphold_yn ='Y'  or stock.qms_hold_yn='Y')
		group by 
		      stock.available_date
		    , stock.operation_id
		    , stock.wiphold_yn
		    , stock.qms_hold_yn
		    , stock.line_id
		    , stock.stock_status
		    , stock.fp_apply_item_id
		    , stock.nick_name
            , case when substring(stock.fp_apply_item_id,4,2)  = 'CA' then 'Cathode' 
                   when substring(stock.fp_apply_item_id,4,2)  = 'AN' then 'Anode' 
                   else '' end
		order by 
		     stock.operation_id  
			, stock.line_id
            , stock.available_date
			

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END



