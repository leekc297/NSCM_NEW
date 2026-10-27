
/*
 * Program ID   : PR_XLS_GET_STOCK_HOLD
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_STOCK_HOLD] '20240801'
 */

create PROCEDURE [dbo].[PR_XLS_GET_STOCK_HOLD_20240830]
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
	

		SELECT FORMAT(STOCK.UNHOLD_EXP_DATE,'yyyy-MM-dd') AS AVAIL_DATE
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
           		SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
				     , A.STOCK_TYPE, A.FP_APPLY_ITEM_ID
					 , B.NICK_NAME
					 , A.FP_APPLY_OPERATION_ID
					 , A.WIPHOLD_YN, A.QMS_HOLD_YN
           		     , A.STOCK_STATUS
					 , A.UNHOLD_EXP_DATE 
					 , case when A.FP_APPLY_OPERATION_ID IN ('E2000', 'E3000') then a.qty2 * y.value else A.QTY2/isnull(dbo.FN_GET_REQ_QTY_MODEL(a.plant_id, b.applied_model, a.item_id, a.cutoff_date),1) end AS QTY2
            	  FROM SCM_STOCK_H as A WITH(NOLOCK) 
					   JOIN SCM_ITEM_M as B WITH(NOLOCK)                                                                                                                                                          
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
				   and a.company_id = 'G670'
           		   AND A.DIVISION_ID = N'81_UC' 
           		   AND A.SITE_ID = N'A003' 
           		   AND A.PLANT_ID IN (N'G671',N'G672') 
           		   AND A.FP_APPLY_OPERATION_ID IN ('E2000', 'E3000', 'A5000', 'A5100', 'A7000', 'A8000','A9000') 
				   AND A.STOCK_TYPE = 'WIP'
				   AND (A.WIPHOLD_YN ='Y'  OR A.QMS_HOLD_YN='Y')
				   --and exists (
				   --             select 1
							--	  from fp_plan_model_change_m as x with(nolock)
							--	 where a.FACTORY_ID = x.factory_id
							--	   and a.line_id = x.line_id
							--	   and a.operation_id = x.operation_id
							--	   and a.item_id = x.item_id
							--	   and a.production_type = x.production_type
							--	   and a.version = x.version
							--	   and a.UNHOLD_EXP_DATE between x.eff_start_date and x.eff_end_date
       --                       )
		      ) as stock
		where 1 = 1
		group by 
		      stock.UNHOLD_EXP_DATE
		    , stock.operation_id
		    , stock.wiphold_yn
		    , stock.qms_hold_yn
		    , stock.line_id
		    , stock.stock_status
		    , stock.fp_apply_item_id
		    , stock.nick_name
		order by 
		      stock.operation_id  
			, stock.line_id
            , stock.UNHOLD_EXP_DATE
			

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END
