
/*
 * Program ID   : PR_XLS_GET_PRODUCT_RESULT
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.08.01   FP Pjt.         Create.
 * 2024.11.15   shineuiho67     가장우측에 keys컬럼, 모델컬럼(3자리 : 예140)추가
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_PRODUCT_RESULT] 'UC1', '20241101' , '20241111'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_PRODUCT_RESULT]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymmdd_from			NVARCHAR(MAX)
,	@p_yyyymmdd_to				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code			NVARCHAR(MAX)
	DECLARE @v_yyyymmdd_from	nvarchar(max)
	DECLARE @v_yyyymmdd_to		nvarchar(max)

	declare	@v_company_id		nvarchar(50)
	declare	@v_division_id		NVARCHAR(50) 
	declare	@v_site_id			nvarchar(50)
	declare	@v_plant_id			nvarchar(50)
	declare @v_elec_plant_id	nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd_from	= format( convert(datetime, @p_yyyymmdd_from), 'yyyyMMdd')
	set @v_yyyymmdd_to		= format( convert(datetime, @p_yyyymmdd_to), 'yyyyMMdd')


	BEGIN TRY		

		select @v_company_id		= attribute1
			 , @v_division_id		= attribute2
			 , @v_site_id			= attribute3
			 , @v_plant_id			= attribute4
			 , @v_elec_plant_id		= attribute5
		  from dbo.SCM_SYS_LOOKUP_VALUE with(nolock)
		 where lookup_type_code = 'XLS_PLAN_APL_PLANT'
		   and segment1 = @v_apl_code
		   and active_flag = 'Y'

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

              ,CASE WHEN X.OPERATION_ID    = 'A5000' THEN 'Notching'
                    WHEN X.OPERATION_ID    = 'A8000' THEN 'L&S'
                    WHEN X.OPERATION_ID    = 'A9000' THEN 'PKG'
                    WHEN X.OPERATION_ID    = 'E2000' THEN 'Coating'
                    WHEN X.OPERATION_ID    = 'E3000' THEN 'R/P'
                    WHEN X.OPERATION_ID    = 'F6000' THEN 'EOL'
                    ELSE X.OPERATION_ID
                END 
                + IIF(X.ELECTRODE_TYPE = '-','',' (' + X.ELECTRODE_TYPE + ')')
                + REPLACE(CONCAT('#', SUBSTRING( X.LINE_ID, CAST(ISNULL(NULLIF(PATINDEX('%[0-9]%', X.LINE_ID), 0), 0) AS INT), 2)),'#0','#') 
                + format(X.PLAN_DATE, 'yyyy-MM-dd')
                AS KEYS
                , Z.NICK_NAME 

		  FROM [dbo].[SCM_DAILY_PRODUCT_RESULT_H]   as x with(nolock)
		       join SCM_OPERATION_M                 as y with(nolock)
			on x.company_id     = y.company_id
		   and x.division_id    = y.division_id
		   and x.site_id        = y.site_id
		   and x.operation_id   = y.operation_id

           --2024-11-16 NICK_NAME 보기 위하여
           left join scm_item_m as z with(nolock)
		    on  x.division_id   = z.division_id
		    and x.company_id    = z.company_id
			and x.site_id       = z.site_id
		    and x.item_id       = z.item_id

		 where 1 = 1
		   and x.company_id = @v_company_id
		   and x.division_id = @v_division_id
		   and x.site_id = @v_site_id
		   and x.plant_id in (@v_plant_id, @v_elec_plant_id)
		   and x.operation_id in ('E2000', 'A5000', 'A7000', 'A8000', 'A9000', 'F4000', 'F6000')
		   --and x.operation_id not in ('F4000', 'F6000')
		   and x.plan_date between @p_yyyymmdd_from and @p_yyyymmdd_to
		   and x.fp_production_type = 'MASS'
		   and x.cell_out_qty > 0
		 order by x.factory_id, x.top_item_id, x.operation_id

	    PRINT 'OK'

	END TRY

	BEGIN CATCH

	    PRINT 'NG|' + ERROR_MESSAGE()

	END CATCH

END



