
/*
 * Program ID   : PR_XLS_GET_STOCK
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 
 * 
 * 
 ex) 
 */

create PROCEDURE [dbo].[PR_XLS_GET_STOCK_20240801]
	@p_cutoff_date			NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE  @v_division_id NVARCHAR(MAX)='';
	DECLARE  @v_item_id NVARCHAR(MAX)='';

	DECLARE  @v_cutoff_date   nvarchar(max)
	set @v_cutoff_date = @p_cutoff_date

	if object_id('tempdb..#base_info') is not null
		drop table #base_info


	create table #base_info (
				 model_id				nvarchar (100)
			   , nick_name				nvarchar (100)
			   , category				nvarchar (100)
			   , type				    nvarchar (100)
			   , gubun_order            int
			   , gubun1					nvarchar (100)
			   , gubun2					nvarchar (100)
			   , qty					numeric(28,10)
			)

	BEGIN TRY		
	

		insert into #base_info(model_id, nick_name, category, type, gubun_order, gubun1, gubun2, qty)
		select IIF(gubun_order = 11 , item_id, model_id) , nick_name, category
			 , case when HOLD_YN = 'N' then 'Good' 
				   when HOLD_YN = 'Y' then 'Hold' 
				   else 'Bf.Inspect' end as type
			 , gubun_order, gubun1, gubun2
			 , sum(qty) as qty
		  from (
			     select m.applied_model as model_id
			     	  , m.nick_name
			     	  , s.*
			     from (
			     	    select 1 as gubun_order, 'Pancake' as gubun1, 'After Coating' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as hold_yn
			     	    	 , x.qty2 * y.value as qty
			     	     from  scm_stock_h as x with(nolock)
			     	    	   join scm_item_conv_calc_m  as y with(nolock)
			     	    	on x.company_id = y.company_id
			     	       and x.factory_id = y.factory_id
			     	       and x.work_request_model_id = y.model_id
			     	       and x.version = y.version
			     	       and y.operation = 'E2000'
			     	       and x.item_id = y.item_id
			     	       and y.category = 'Jumbo Roll (cell/m)'
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G672'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'E3000'
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union all
			     	    
			     	    select 2 as gubun_order, 'Pancake' as gubun1, 'After R/P' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2 * y.value as qty
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
			     	       and x.item_id = y.item_id
						   and y.category = 'Pancake (cell/m)'
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000'
			     	       and x.stock_status = 'WAIT'
			     	    
			     	    union  all
			     	    
			     	    select 3 as gubun_order, 'Notched Pancake' as gubun1, 'After NND' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000'
			     	       and x.stock_status = 'END'
			     	    
			     	    union  all
			     	    
			     	    select 4 as gubun_order, 'Notched Pancake' as gubun1, 'V/D Inspection' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A6100'
			     	       and x.stock_status = 'WAIT'
			     	    
			     	    union  all
			     	    
			     	    select 5 as gubun_order, 'Notched Pancake' as gubun1, 'Before L&S' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A7000'
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all
			     	    
			     	    select 6 as gubun_order, 'Cell' as gubun1, 'Stack Cell' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2  as qty
			     	      from scm_stock_h as x with(nolock)
			     	    where 1 = 1
			     	      and x.cutoff_date = @v_cutoff_date
			     	      and x.company_id = 'G670'
			     	      and x.division_id = '81_UC'
			     	      and x.plant_id = 'G671'
			     	      and x.stock_type = 'WIP'
			     	      and x.operation_id = 'A9000'
			     	      and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2  as qty
			     	      from scm_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A9000'
			     	       and x.stock_status = 'END'
			     	       and x.wip_type_code = 'OUT'
			     	    
			     	    union all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' --and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'Y'
			     	    
			     	    union all
			     	    
			     	    select 8 as gubun_order, 'Cell' as gubun1, 'After DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.available_date > x.cutoff_date
			     	    
			     	    union all
			     	    
			     	    select 9 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-W' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.line_id in ('ABA01', 'ABA02', 'ABA03', 'ABA04','ABA05')
			     	       and x.available_date <= x.cutoff_date
			     	       and x.special_yn in ('Y', 'N')
			     	    
			     	    union all
			     	    
			     	    select 10 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-E' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty as qty
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @v_cutoff_date
			     	       and x.company_id = 'G670'
			     	       and x.division_id = '81_UC'
			     	       and x.plant_id = 'G671'
			     	       and x.before_degas = 'N'
			     	       and x.line_id in ('ABA06', 'ABA07', 'ABA08', 'ABA09','ABA10')
			     	       and x.available_date <= x.cutoff_date
			     	       and x.special_yn in ('Y', 'N')
			     	    
			     	    union all 
			     	    
			     	    select 11 as gubun_order, 'Cell' as gubun1, 'OWMS F/G' as gubun2
			     	    	 , x.company_id, x.division_id, y.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.stock_status = '00' then 'N' 
			     	    			when x.stock_status = '40' then 'Y' 
			     	    			else 'Z' end  as HOLD_YN
			     	    	 , x.STOCK_QTY  as qty
			     	      FROM SY_SSP_ANL_OWMS_STOCK_C2 x with(nolock)
			     	    	   join sy_scm_mst_site as y with(nolock)
			     	        on x.division_id = y.division_id
			     	       and x.from_site = y.scm_site_id
			     	     WHERE 1 = 1 
						   and x.COMPANY_ID = 'G670'
			     	       and x.division_id = '81_UC'
						   and x.from_site = 'G671-A' 
			     	       AND x.CUTOFF_DATE = format(dateadd(day, -1, convert(date, @v_cutoff_date)), 'yyyyMMdd')
			     	       and x.STOCK_STATUS IN ('00', '40', '10')

			          ) as s
			          join scm_item_m as m with(nolock)
			       on s.company_id		= m.company_id
			      and s.division_id		= m.division_id
			      and s.site_id			= m.site_id
			      and s.item_id 		= m.item_id

		       ) as stock
		 group by IIF(gubun_order = 11 , item_id, model_id), nick_name, hold_yn, category, gubun_order, gubun1, gubun2
		 order by nick_name, hold_yn, category, gubun_order, gubun1, gubun2



		select x.model_id, x.nick_name, x.category, x.type
			 , y.After_Coating
			 , y.After_RP
			 , y.After_NND
			 , y.VD_Inspection
			 , y.Before_LS
			 , y.Stack_Cell
			 , y.Before_DGS
			 , y.After_DGS
			 , y.Waiting_EOL_W
			 , y.Waiting_EOL_E
			 , y.OWMS_FG
	 	  from (
			     select b.model_id, b.nick_name, a.col_order, a.category, a.type
			       from (
			              select 'Cathode' as category, 'Good'		    as type, 1 as col_order
			              union all									    
			              select 'Cathode' as category, 'Hold'		    as type, 2 as col_order
			              union all									    
			              select 'Anode'   as category, 'Good'		    as type, 4 as col_order
			              union all									    
			              select 'Anode'   as category, 'Hold'		    as type, 5 as col_order
			              union all									    
			              select 'Cell'    as category, 'Good'		    as type, 7 as col_order
			              union all									    
			              select 'Cell'    as category, 'Hold'		    as type, 8 as col_order
			              union all
			              select 'Cell'	   as category, 'Bf.Inspect'	as type, 9 as col_order
			            ) as a 
			            cross apply
			            (
			              select distinct model_id, nick_name
			              from #base_info
			            ) as b
		       ) as x
		       left outer join 
		       (
		         select model_id, category, type
			          , sum(case when gubun_order =  1 then qty else 0 end) as After_Coating
			          , sum(case when gubun_order =  2 then qty else 0 end) as After_RP
			          , sum(case when gubun_order =  3 then qty else 0 end) as After_NND
			          , sum(case when gubun_order =  4 then qty else 0 end) as VD_Inspection
			          , sum(case when gubun_order =  5 then qty else 0 end) as Before_LS
			          , sum(case when gubun_order =  6 then qty else 0 end) as Stack_Cell
			          , sum(case when gubun_order =  7 then qty else 0 end) as Before_DGS
			          , sum(case when gubun_order =  8 then qty else 0 end) as After_DGS
			          , sum(case when gubun_order =  9 then qty else 0 end) as Waiting_EOL_W
			          , sum(case when gubun_order = 10 then qty else 0 end) as Waiting_EOL_E
			          , sum(case when gubun_order = 11 then qty else 0 end) as OWMS_FG
		           from #base_info
		          group by model_id, category, type
		       )  as y
		    on x.model_id  = y.model_id
		   and x.category = y.category
		   and x.type      = y.type
		 order by x.model_id, x.col_order



	END TRY

	BEGIN CATCH
		if object_id('tempdb..#base_info') is not null
			drop table #base_info

	END CATCH

	if object_id('tempdb..#base_info') is not null
		drop table #base_info
END



