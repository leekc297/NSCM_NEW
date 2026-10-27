
/*
 * Program ID   : PR_XLS_GET_PRODUCT_RESULT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_PRODUCT_RESULT] 'UC1', '20240701' , '20240711'
 */

create PROCEDURE [dbo].[PR_XLS_GET_PRODUCT_RESULT_20240802]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymmdd_from			NVARCHAR(MAX)
,	@p_yyyymmdd_to				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_yyyymmdd_from   nvarchar(max)
	DECLARE  @v_yyyymmdd_to     nvarchar(max)

	set @v_yyyymmdd_from	= format( convert(datetime, @p_yyyymmdd_from), 'yyyyMMdd')
	set @v_yyyymmdd_to		= format( convert(datetime, @p_yyyymmdd_to), 'yyyyMMdd')


	BEGIN TRY		

		SELECT
               CASE WHEN X.OPERATION_ID = 'A5000' THEN 'Notching'
                    WHEN X.OPERATION_ID = 'A7000' THEN 'Lamination'
                    WHEN X.OPERATION_ID = 'A8000' THEN 'Stacking'
                    WHEN X.OPERATION_ID = 'A9000' THEN 'Packaging'
                    WHEN X.OPERATION_ID = 'E2000' THEN 'Coating'
                    WHEN X.OPERATION_ID = 'E3000' THEN 'R/P'
                    WHEN X.OPERATION_ID = 'F6000' THEN 'EOL'
               ELSE X.OPERATION_ID
               END AS OPERATION
			   --Y.OPERATION_NAME AS OPERATION
              ,X.[COMPANY_ID]
			  ,X.[DIVISION_ID]
			  ,X.[SITE_ID]
			  ,X.[PLANT_ID]
			  ,X.[FACTORY_ID]
			  ,X.[TOP_ITEM_ID]
			  ,X.[ITEM_ID]
			  ,X.[OPERATION_ID]
			  ,X.[LOCATION]
			  ,X.[PRODUCTION_TYPE]
			  ,X.[MARKET]
			  ,X.[LINE_ID]
			  ,X.[ELECTRODE_TYPE]
			  ,X.[PLAN_DATE]
			  ,X.[ACTUAL_QTY]
			  ,X.[ACTUAL_GOOD_QTY]
			  ,X.[ACTUAL_SCRAP_QTY]
			  ,X.[INSERT_ID]
			  ,X.[INSERT_TIME]
			  ,X.[UPDATE_ID]
			  ,X.[UPDATE_TIME]
			  ,X.[QTY]
			  ,X.[QTY_LANE]
			  ,X.[DFCT_QTY2]
			  ,X.[LOSS_QTY2]
			  ,X.[PRDT_REQ_QTY2]
			  ,X.[TOP_COATING_QTY2]
			  ,X.[YIELD_LOSS_QTY]
			  ,X.[EQUIPMENT_ID]
			  ,X.[FP_PRODUCTION_TYPE]
			  ,X.[ROLL_IN_QTY]
			  ,X.[ROLL_OUT_QTY]
			  ,X.[JR_IN_QTY]
			  ,X.[JR_OUT_QTY]
			  ,X.[BATCH_IN_QTY]
			  ,X.[BATCH_OUT_QTY]
			  ,X.[CELL_IN_QTY]
			  ,CASE WHEN X.OPERATION_ID LIKE 'F%' THEN X.ACTUAL_GOOD_QTY ELSE [CELL_OUT_QTY] END CELL_OUT_QTY
			  ,X.[CELL_MATERIAL_ID]
			  ,X.[TOP_JR_OUT_QTY]
			  ,X.[WORK_REQUEST_MODEL_ID]
			  ,X.[VERSION]
			  ,X.[PROD_SEQ]
			  ,X.[PLM_EC_NO]
		  FROM [dbo].[SCM_DAILY_PRODUCT_RESULT_H] as x with(nolock)
		       join SCM_OPERATION_M as y with(nolock)
			on x.company_id = y.company_id
		   and x.division_id = y.division_id
		   and x.site_id = y.site_id
		   and x.operation_id = y.operation_id
		 where 1 = 1
		   and x.company_id = 'G670'
		   and x.division_id = '81_UC'
		   and x.site_id = 'A003'
		   and x.plant_id in ('G671', 'G672')
		   and x.operation_id in ('E2000', 'A5000', 'A7000', 'A8000', 'A9000', 'F4000', 'F6000')
		   --and x.operation_id not in ('F4000', 'F6000')
		   and x.plan_date between @p_yyyymmdd_from and @p_yyyymmdd_to
		 order by x.factory_id, x.top_item_id, x.operation_id

	    PRINT 'OK'

	END TRY

	BEGIN CATCH

	    PRINT 'NG|' + ERROR_MESSAGE()

	END CATCH

END



