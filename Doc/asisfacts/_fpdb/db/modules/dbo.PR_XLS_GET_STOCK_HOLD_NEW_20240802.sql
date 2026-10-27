
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
   exec [dbo].[PR_XLS_GET_STOCK_HOLD_NEW] '20240901'
 */

create PROCEDURE [dbo].[PR_XLS_GET_STOCK_HOLD_NEW_20240802]
	@p_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';

	DECLARE  @v_yyyymmdd   nvarchar(max)
	set @v_yyyymmdd = @p_yyyymmdd

	if object_id('tempdb..#base_info') is not null
		drop table #base_info

	create table #base_info (
	             avail_date             datetime
			   , operation              nvarchar(100)
			   , line_id                nvarchar(100)
			   , model_id				nvarchar(100)
			   , nick_name				nvarchar(100)
			   , item_id                nvarchar(100)
			   , type				    nvarchar(100)
			   , wiphold_yn				nvarchar(1)
			   , qms_hold_yn            nvarchar(1)
			   , stock_status           nvarchar(100)
			   , qty					numeric(28,10)
			   , gubun_order            int
			)



	BEGIN TRY		
	
		insert into #base_info(avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, qty, gubun_order)
		select avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status
			 , sum(qty) as qty
			 , gubun_order
		  from (
			     select m.applied_model as model_id
			     	  , m.nick_name
			     	  , s.*
			     from (
			     	    select 1 as gubun_order, 'Pancake' as gubun1, 'After Coating' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as hold_yn
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2 * y.value as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	     from  scm_stock_h as x with(nolock)
			     	    	   join scm_item_conv_calc_m  as y with(nolock)
			     	    	on x.company_id = y.company_id
			     	       and x.factory_id = y.factory_id
			     	       and x.work_request_model_id = y.model_id
			     	       and x.version = y.version
			     	       and y.operation = 'E2000'
			     	       and x.item_id = y.item_id
			     	       and y.category = 'Pancake (cell/m)' --'Jumbo Roll (cell/m)'
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G672'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'E3000'
			     	       and x.stock_status in ('PROC','WAIT')
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union all
			     	    
			     	    select 2 as gubun_order, 'Pancake' as gubun1, 'After R/P' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
							 , x.qty2 * y.value as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
		     	    	   join scm_item_conv_calc_m as y with(nolock)
			     	        on x.company_id = y.company_id
			     	       and x.factory_id = y.factory_id
			     	       and x.work_request_model_id = y.model_id
			     	       and x.version = y.version
						   and y.operation = 'E2000'
			     	       and x.item_id = y.item_id
						   and y.category = 'Pancake (cell/m)'
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G672'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id in ('E4000', 'E4100', 'E7000')
			     	       and x.stock_status in ('PROC','WAIT')
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union  all

			     	    select 2 as gubun_order, 'Pancake' as gubun1, 'After R/P' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2 * y.value as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	    	   join [DBO].[SCM_SYS_LOOKUP_VALUE] V  WITH(NOLOCK)
			     	        on v.LOOKUP_TYPE_CODE = 'ELEC_ASSY_FACTORY_MAP'
			     	       and v.active_flag = 'Y'
			     	       and x.factory_id = v.segment1
			     	    	   join scm_item_conv_calc_m as y with(nolock)
			     	        on x.company_id = y.company_id
			     	       and v.segment2 = y.factory_id
			     	       and z.applied_model = y.model_id
			     	       and x.version = y.version
						   and y.operation = 'E2000'
			     	       and x.item_id = y.item_id
						   and y.category = 'Pancake (cell/m)'
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000' 
			     	       and x.stock_status in ('PROC','WAIT')
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union  all
			     	    --Notching
			     	    select 3 as gubun_order, 'Notched Pancake' as gubun1, 'After NND' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000'
			     	       and x.stock_status = 'END'
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')

			     	    union  all
			     	    --Re-Winding(Notching)'
			     	    select 3 as gubun_order, 'Notched Pancake' as gubun1, 'After NND' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5100'
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
						   
			     	    union  all
			     	    
			     	    select 4 as gubun_order, 'Notched Pancake' as gubun1, 'V/D Inspection' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A6100'
			     	       and x.stock_status = 'WAIT'
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union  all
			     	    
			     	    select 5 as gubun_order, 'Notched Pancake' as gubun1, 'Before L&S' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as type 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A7000'
			     	       and x.stock_status in ('PROC','WAIT')
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union  all
			     	    
			     	    select 6 as gubun_order, 'Cell' as gubun1, 'Stack Cell' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	    where 1 = 1
			     	      and x.cutoff_date = @p_yyyymmdd
			     	      and x.company_id = 'G670'
			     	      and x.division_id = '81_UC'
						  and x.site_id = 'A003'
			     	      and x.plant_id = 'G671'
			     	      and x.stock_type = 'WIP'
			     	      and x.operation_id = 'A9000'
			     	      and x.stock_status in ('PROC','WAIT')
						  AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union  all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , x.QMS_HOLD_YN
			     	    	 , x.qty2  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
			     	      from scm_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A9000'
			     	       and x.stock_status = 'END'
			     	       and x.wip_type_code = 'OUT'
						   AND (x.WIPHOLD_YN ='Y'  OR x.QMS_HOLD_YN='Y')
			     	    
			     	    union all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'Y'
						   and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 8 as gubun_order, 'Cell' as gubun1, 'After DGS' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.available_date > x.cutoff_date
						   and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 9 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-W' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty  as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.line_id in ('ABA01', 'ABA02', 'ABA03', 'ABA04','ABA05')
			     	       and x.available_date <= x.cutoff_date
			     	       and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 10 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-E' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty as qty
							 --, format(convert(date, x.cutoff_date), 'yyyyMMdd') as cutoff_date
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.site_id = 'A003'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.line_id in ('ABA06', 'ABA07', 'ABA08', 'ABA09','ABA10')
			     	       and x.available_date <= x.cutoff_date
			     	       and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     --	    union all 
			     --	    select 11 as gubun_order, 'Cell' as gubun1, 'OWMS F/G' as operation
			     --	    	 , x.company_id, x.division_id, y.site_id, x.item_id
			     --	    	 ,'Cell' as type
			     --	    	 , case when x.stock_status = '00' then 'N' 
			     --	    			when x.stock_status = '40' then 'Y' 
			     --	    			else 'Z' end  as HOLD_YN
			     --	    	 , x.STOCK_QTY  as qty
							 --, format(dateadd(day, 1, convert(date, x.cutoff_date)), 'yyyyMMdd') as cutoff_date
			     --	      FROM SY_SSP_ANL_OWMS_STOCK_C2 x with(nolock)
			     --	    	   join sy_scm_mst_site as y with(nolock)
			     --	        on x.division_id = y.division_id
			     --	       and x.from_site = y.scm_site_id
			     --	     WHERE 1 = 1 
						  -- and x.COMPANY_ID = 'G670'
			     --	       and x.division_id = '81_UC'
						  -- and x.from_site = 'G671-A' 
			     --	       AND x.CUTOFF_DATE = format(dateadd(day, -1, convert(date, @v_yyyymmdd)), 'yyyyMMdd') 
			     --	       and x.STOCK_STATUS IN ('00', '40', '10')

			          ) as s
			          join scm_item_m as m with(nolock)
			       on s.company_id		= m.company_id
			      and s.division_id		= m.division_id
			      and s.site_id			= m.site_id
			      and s.item_id 		= m.item_id

		       ) as stock
		 group by avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, gubun_order

	    select Format(avail_date, 'yyyy-MM-dd') as avail_date
		     , operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, qty, 
             case when operation = 'After Coating'  then 'Pancake'
                  when operation = 'After R/P'      then 'Pancake'
                  when operation = 'After NND'      then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'Before L&S'     then 'Notched Pancake'
                  else 'Cell'
             end as operation_group
		  from #base_info
		 order by gubun_order, line_id, avail_date

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#base_info') is not null
			drop table #base_info

	END CATCH

	if object_id('tempdb..#base_info') is not null
		drop table #base_info
END
