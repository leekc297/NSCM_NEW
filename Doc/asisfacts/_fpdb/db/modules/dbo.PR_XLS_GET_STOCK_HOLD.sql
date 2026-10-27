
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
   exec [dbo].[PR_XLS_GET_STOCK_HOLD] 'UC1', '20240801'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_STOCK_HOLD]
    @p_apl_code                 nvarchar(max)  = 'UC1'
,	@p_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code			NVARCHAR(MAX)
	DECLARE @v_yyyymmdd			nvarchar(max)

	declare	@v_company_id		nvarchar(50)
	declare	@v_division_id		NVARCHAR(50) 
	declare	@v_site_id			nvarchar(50)
	declare	@v_plant_id			nvarchar(50)
	declare @v_elec_plant_id	nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd = @p_yyyymmdd


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
	
		select *
		  from (
			SELECT FORMAT(STOCK.UNHOLD_EXP_DATE,'yyyy-MM-dd')	AS AVAIL_DATE
				 , STOCK.OPERATION_ID							as operation_id
				 , STOCK.WIPHOLD_YN								as wiphold_yn
				 , STOCK.QMS_HOLD_YN							as qms_hold_yn
				 , STOCK.LINE_ID								as line_id
				 , STOCK.STOCK_STATUS							as stock_status
				 , STOCK.FP_APPLY_ITEM_ID						as item_id
				 , STOCK.NICK_NAME								as nick_name
				 , SUM(QTY2)									AS CELL_QTY
				 , case when substring(stock.fp_apply_item_id,4,2)  = 'CA' then 'Cathode' 
						when substring(stock.fp_apply_item_id,4,2)  = 'AN' then 'Anode' 
						else '' 
						end										as ELECTRODE_TYPE
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
					   and a.company_id			= @v_company_id
           			   AND A.DIVISION_ID		= @v_division_id 
           			   AND A.SITE_ID			= @v_site_id 
           			   AND A.PLANT_ID			IN (@v_plant_id, @v_elec_plant_id) 
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

			 union all
			select FORMAT(x.available_date,'yyyy-MM-dd') 
				  , 'Waiting EOL'
				  , x.Wiphold_yn
				  , case when x.special_yn = 'N' then 'N' else 'Y' end
				  , x.line_id
				  , x.tray_op_status
				  , x.item_id
				  , y.nick_name
				  , sum(x.qty)
				  , '' as electrode_type
			   from scm_aging_stock_h as x with(nolock)
					join scm_item_m as y with(nolock)
				 on x.company_id = y.company_id
				and x.division_id = y.division_id
				and x.site_id = y.site_id
				and x.item_id = y.item_id
			  where 1 = 1                    
				and cutoff_date = @v_yyyymmdd               
				and plant_id in (@v_plant_id)                  
				and before_degas = 'N'     
				and (special_yn != 'N' or wiphold_yn = 'Y')
				and available_date <= @v_yyyymmdd
			group by x.available_date, x.wiphold_yn
				   , case when x.special_yn = 'N' then 'N' else 'Y' end
				   , x.line_id, x.tray_op_status, x.item_id, y.nick_name

			 union all
			select FORMAT(x.available_date,'yyyy-MM-dd')
				  , 'Before DGS'
				  , x.Wiphold_yn
				  , case when x.special_yn = 'N' then 'N' else 'Y' end
				  , x.line_id
				  , x.tray_op_status
				  , x.item_id
				  , y.nick_name
				  , sum(x.qty)
				  , '' as electrode_type
			   from scm_aging_stock_h as x with(nolock)
					join scm_item_m as y with(nolock)
				 on x.company_id = y.company_id
				and x.division_id = y.division_id
				and x.site_id = y.site_id
				and x.item_id = y.item_id
			  where 1 = 1                    
				and cutoff_date = @v_yyyymmdd           
				and plant_id in (@v_plant_id)                  
				and before_degas = 'Y'     
				and (special_yn != 'N' or wiphold_yn = 'Y')
			group by x.available_date, x.wiphold_yn
				   , case when x.special_yn = 'N' then 'N' else 'Y' end
				   , x.line_id, x.tray_op_status, x.item_id, y.nick_name

			 union all
			select FORMAT(x.available_date,'yyyy-MM-dd') 
				  , 'After DGS'
				  , x.Wiphold_yn
				  , case when x.special_yn = 'N' then 'N' else 'Y' end
				  , x.line_id
				  , x.tray_op_status
				  , x.item_id
				  , y.nick_name
				  , sum(x.qty)
				  , '' as electrode_type
			   from scm_aging_stock_h as x with(nolock)
					join scm_item_m as y with(nolock)
				 on x.company_id = y.company_id
				and x.division_id = y.division_id
				and x.site_id = y.site_id
				and x.item_id = y.item_id
			  where 1 = 1                    
				and cutoff_date = @v_yyyymmdd           
				and plant_id in (@v_plant_id)                  
				and before_degas = 'Y'     
				and (special_yn != 'N' or wiphold_yn = 'Y')
				and available_date > @v_yyyymmdd
			group by x.available_date, x.wiphold_yn
				   , case when x.special_yn = 'N' then 'N' else 'Y' end
				   , x.line_id, x.tray_op_status, x.item_id, y.nick_name
			) as stock
		order by 
		      stock.operation_id  
			, stock.line_id
            , stock.AVAIL_DATE

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

END
