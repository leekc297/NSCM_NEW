
/*
 * Program ID   : PR_XLS_GET_REPORT_BY_MEASURE
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.12.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_REPORT_BY_MEASURE] 'UC1'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_REPORT_BY_MEASURE]
    @p_apl_code                 nvarchar(max)  = 'UC1'
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE @v_yyyymmdd_from		date --nvarchar(max)
	DECLARE @v_yyyymmdd_to			date --nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	declare @v_version_no           nvarchar(50)
	declare @vt_cal_yyyypw          table (
	        iso_yyyypw		        nvarchar(100)
		  , dt						datetime
		  , yyyymmdd				nvarchar(100)
		  )

	if object_id('tempdb..#REPORT_BY_MEASURE') is not null
		drop table #REPORT_BY_MEASURE

	create table #REPORT_BY_MEASURE (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
			, MEASURE                   nvarchar(1000)
			, DIVISION_ID               nvarchar(1000)
			, ELECTRODE_TYPE            nvarchar(1000)
			, NICK_NAME                 nvarchar(1000)
            , ITEM_ID                   nvarchar(1000)
			, YYYYMMDD 				    nvarchar(1000)
			, QTY                       numeric(20, 10)
			)
			;


	set @v_apl_code			= @p_apl_code
	--set @v_yyyymmdd_from    = cast(dateadd(year, -1, cast(year(getdate()) as varchar) + '0101') as date)
	set @v_yyyymmdd_from    = cast(cast(year(getdate()) as varchar) + '0101' as date)
	set @v_yyyymmdd_to      = eomonth(getdate(), -1)


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

        insert into @vt_cal_yyyypw (  iso_yyyypw, dt, yyyymmdd	)
		select iso_yyyypw, max(dt) as dt, max(yyyymmdd) as yyyymmdd
		from th_uis_cal with(nolock)
		where dt between @v_yyyymmdd_from AND @v_yyyymmdd_to
		group by iso_yyyypw		

	    --DP
		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		select 'DP', x.division_id, '-', t.nick_name, x.item_id, x.yyyymmdd, x.qty
		  from sy_DM_PLN_MKT_FCST x with(nolock)
               join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
            ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
           AND X.DIVISION_ID			= Y.SEGMENT1
           AND X.PLANT_SITE_ID			= Y.SEGMENT2
           AND X.SCM_SITE_ID			= Y.SEGMENT3
			   JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
			ON X.ITEM_ID				= T.ITEM_ID					 
		   AND X.DIVISION_ID			= T.DIVISION_ID				 
		   AND @v_company_id			= T.COMPANY_ID	
		   AND @v_site_id				= T.SITE_ID
		 where 1 = 1
		   and x.division_id = '81_UC'
		   and x.measure = 'MKT_FCST'
		   and x.division_id = @v_division_id
		   and x.PLANT_SITE_ID          like @v_plant_id + '%'
		   and x.yyyymmdd between convert(nvarchar, @v_yyyymmdd_from, 112) and convert(nvarchar, @v_yyyymmdd_to, 112)

		--RTF
		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		select 'RTF'
		     , x.division_id
			 , '-'
			 , x.NICK_NAME
		     , x.item_id
			 , x.YYYYMMDD
			 , SUM(x.QTY ) as QTY
		  from (
			    select e.division_id
				     , t.nick_name
					 , e.item_id
					 , e.exfactory_date as yyyymmdd
					 , e.exfactory_qty as qty
				  from [SY_SCM_DNM_EXFACTORY_RESULT] e with(nolock)
					   JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
					ON E.FROM_SCM_SITE_ID		= S.SCM_SITE_ID				 
				   AND E.DIVISION_ID			= S.DIVISION_ID				 
				   AND S.SITE_TYPE				= 'PLANT'					 				 
					   JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
					ON E.ITEM_ID				= T.ITEM_ID					 
				   AND E.DIVISION_ID			= T.DIVISION_ID				 
				   AND E.COMPANY_ID				= T.COMPANY_ID	
				   AND E.SITE_ID				= T.SITE_ID
				   AND T.ITEM_TYPE				NOT IN ('Q','R')
					   JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE			= 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				   AND L.VALID_YN				= 'Y'
				   AND L.SEGMENT1				= E.SSP_TYPE	
					   join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
					ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
				   AND e.DIVISION_ID			= Y.SEGMENT1
				   AND e.FROM_SCM_SITE_ID			= Y.SEGMENT2
				   AND e.TO_SCM_SITE_ID			= Y.SEGMENT3
				 where 1 = 1
				   AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				   AND E.EXFACTORY_DATE between convert(nvarchar, @v_yyyymmdd_from, 112) and convert(nvarchar, @v_yyyymmdd_to, 112)
				   and e.EXFACTORY_DATE < convert(nvarchar, dbo.FN_SITE_TIME(e.site_id), 112)
				   and e.company_id				= @v_company_id
				   and e.division_id			= @v_division_id
				   and e.site_id				= @v_site_id
				   and e.plant_id				= @v_plant_id
				   and e.CONFIRM_ID LIKE 'C%'
				 union all
			    select e.division_id
				     , t.nick_name
					 , e.item_id
					 , e.exfactory_date as yyyymmdd
					 , e.exfactory_qty as qty
				  from [SY_SCM_DNM_EXFACTORY_RESULT] e with(nolock)
					   JOIN SY_SCM_MST_SITE AS S WITH(NOLOCK)					 
					ON E.FROM_SCM_SITE_ID		= S.SCM_SITE_ID				 
				   AND E.DIVISION_ID			= S.DIVISION_ID				 
				   AND S.SITE_TYPE				= 'PLANT'					 				 
					   JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
					ON E.ITEM_ID				= T.ITEM_ID					 
				   AND E.DIVISION_ID			= T.DIVISION_ID				 
				   AND E.COMPANY_ID				= T.COMPANY_ID	
				   AND E.SITE_ID				= T.SITE_ID
				   AND T.ITEM_TYPE				NOT IN ('Q','R')
					   JOIN SY_SCM_ADM_LOOKUP_MASTER_DETAIL L2 WITH(NOLOCK)
					ON L2.LOOKUP_TYPE			= 'ERP_ORDER_TYPE' -- LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 
				   AND L2.VALID_YN				= 'Y'
				   AND L2.SEGMENT1				= E.ORDER_TYPE_CODE 	
					   join dbo.SCM_SYS_LOOKUP_VALUE as y with(nolock)
					ON Y.LOOKUP_TYPE_CODE		= 'XLS_SSP_PLAN_BOD'
				   AND e.DIVISION_ID			= Y.SEGMENT1
				   AND e.FROM_SCM_SITE_ID			= Y.SEGMENT2
				   AND e.TO_SCM_SITE_ID			= Y.SEGMENT3
				 where 1 = 1
				   AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
				   AND E.EXFACTORY_DATE between convert(nvarchar, @v_yyyymmdd_from, 112) and convert(nvarchar, @v_yyyymmdd_to, 112)
				   and e.EXFACTORY_DATE < convert(nvarchar, dbo.FN_SITE_TIME(e.site_id), 112)
				   and e.company_id				= @v_company_id
				   and e.division_id			= @v_division_id
				   and e.site_id				= @v_site_id
				   and e.plant_id				= @v_plant_id
				   and ISNULL(E.CONFIRM_ID,'') NOT LIKE  'C%'
			   ) as x
		 group by 
		       x.division_id
			 , x.item_id
			 , x.YYYYMMDD
			 , x.NICK_NAME

		--PKG Prod Result
		--Elec Prod Result
		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		SELECT
               case when x.operation_id = 'E2000' then 'Elec Prod Result' else 'PKG Prod Result' end
			 , X.[DIVISION_ID]
			 , X.[ELECTRODE_TYPE]
			 , T.NICK_NAME 
			 , X.ITEM_ID
			 , convert(nvarchar, X.[PLAN_DATE], 112) as yyyymmdd
			 , SUM(case when x.operation_id = 'E2000' then ceiling(X.CELL_OUT_QTY) else X.CELL_OUT_QTY end) AS QTY
		  FROM [dbo].[SCM_DAILY_PRODUCT_RESULT_H]  as x with(nolock)
               join scm_item_m as t with(nolock)
		    on x.division_id   = t.division_id
		   and x.company_id    = t.company_id
		   and x.site_id       = t.site_id
		   and x.item_id       = t.item_id
		 where 1 = 1
		   and x.company_id = @v_company_id
		   and x.division_id = @v_division_id
		   and x.site_id = @v_site_id
		   and x.plant_id in (@v_plant_id, @v_elec_plant_id)
		   and x.operation_id in ('E2000',  'A9000')
		   and x.plan_date BETWEEN  @v_yyyymmdd_from  AND @v_yyyymmdd_to
		   and x.fp_production_type = 'MASS'
		   and x.cell_out_qty > 0
		 group by x.division_id, x.electrode_type, t.nick_name, x.item_id, x.plan_date, x.operation_id

		--Elec Inv
		--Cell Inv
		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		select case when gubun1 in ('Pancake', 'Notched Pancake') then 'Elec Inv' 
		            when gubun1 = 'Cell' then 'Cell Inv' 
		            else 'Cell Inv_OWMS' end
		     , division_id
			 , category
			 , nick_name
			 , item_id
			 , convert(nvarchar, cutoff_date, 112) as yyyymmdd
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
							 , x.cutoff_date
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
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id			= @v_company_id
			     	       and x.division_id		= @v_division_id
						   and x.site_id			= @v_site_id
			     	       and x.plant_id			= @v_elec_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'E3000'
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union all
			     	    
			     	    select 2 as gubun_order, 'Pancake' as gubun1, 'After R/P' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2 * y.value as qty
							 , x.cutoff_date
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
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id			= @v_company_id
			     	       and x.division_id		= @v_division_id
						   and x.site_id			= @v_site_id
			     	       and x.plant_id			= @v_elec_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id in ('E4000', 'E4100', 'E7000')
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all

			     	    select 2 as gubun_order, 'Pancake' as gubun1, 'After R/P' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2 * y.value as qty
							 , x.cutoff_date
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
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000' 
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all
			     	    --Notching
			     	    select 3 as gubun_order, 'Notched Pancake' as gubun1, 'After NND' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5000'
			     	       and x.stock_status = 'END'

			     	    union  all
			     	    --Re-Winding(Notching)'
			     	    select 3 as gubun_order, 'Notched Pancake' as gubun1, 'After NND' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A5100'
						   
			     	    union  all
			     	    
			     	    select 4 as gubun_order, 'Notched Pancake' as gubun1, 'V/D Inspection' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A6100'
			     	       and x.stock_status = 'WAIT'
			     	    
			     	    union  all
			     	    
			     	    select 5 as gubun_order, 'Notched Pancake' as gubun1, 'Before L&S' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 , case when substring(x.item_id, 4, 2) = 'CA' then 'Cathode' else 'Anode' end as category 
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2/isnull(dbo.FN_GET_REQ_QTY_MODEL(x.plant_id, z.applied_model, x.item_id, x.cutoff_date),1)  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A7000'
			     	       and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all
/*			     	    
			     	    select 6 as gubun_order, 'Cell' as gubun1, 'Stack Cell' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	    where 1 = 1
			     	      and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	      and x.company_id = @v_company_id
			     	      and x.division_id = @v_division_id
						  and x.site_id = @v_site_id
			     	      and x.plant_id = @v_plant_id
			     	      and x.stock_type = 'WIP'
			     	      and x.operation_id = 'A9000'
			     	      and x.stock_status in ('PROC','WAIT')
			     	    
			     	    union  all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.QMS_HOLD_YN = 'N' then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.qty2  as qty
							 , x.cutoff_date
			     	      from scm_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.stock_type = 'WIP'
			     	       and x.operation_id = 'A9000'
			     	       and x.stock_status = 'END'
			     	       and x.wip_type_code = 'OUT'
			     	    
			     	    union all
			     	    
			     	    select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N'
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
							 , x.cutoff_date
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'Y'
			     	    
			     	    union all
			     	    
			     	    select 8 as gubun_order, 'Cell' as gubun1, 'After DGS' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
							 , x.cutoff_date
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'N'
			     	       and x.available_date >= x.cutoff_date
			     	    
			     	    union all
*/			     	    
			     	    select 9 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-W' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'-' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty  as qty
							 , x.cutoff_date
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'N'
			     	       and x.line_id in (
											select LINE_ID
											from scm_line_m 
											where 1 = 1
											and COMPANY_ID      = @v_company_id
											and DIVISION_ID		= @v_division_id
											and SITE_ID			= @v_site_id
											and PLANT_ID		= @v_plant_id
											and OPERATION_ID	= 'F6000'
											and LINE_GROUP_ID   = 'WEST'
											AND ACTIVE_FLAG = 'Y'
						       )
			     	       and x.available_date < x.cutoff_date
			     	       --and x.special_yn in ('Y', 'N')
			     	    
			     	    union all
			     	    
			     	    select 10 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-E' as gubun2
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'-' as category
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
			     	    	 , x.original_qty as qty
							 , x.cutoff_date
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date between @v_yyyymmdd_from and @v_yyyymmdd_to
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'N'
			     	       and x.line_id in (
											select LINE_ID
											from scm_line_m 
											where 1 = 1
											and COMPANY_ID      = @v_company_id
											and DIVISION_ID		= @v_division_id
											and SITE_ID			= @v_site_id
											and PLANT_ID		= @v_plant_id
											and OPERATION_ID	= 'F6000'
											and LINE_GROUP_ID   = 'EAST'
											AND ACTIVE_FLAG = 'Y'
						       )			     	       
						   and x.available_date < x.cutoff_date
			     	       --and x.special_yn in ('Y', 'N')
			     	    
			     	    union all 
			     	    
			     	    select 11 as gubun_order, 'Cell' as gubun1, 'OWMS F/G' as gubun2
			     	    	 , x.company_id, x.division_id, y.site_id, x.item_id
			     	    	 ,'-' as category
			     	    	 , case when x.stock_status = '00' then 'N' 
			     	    			when x.stock_status = '40' then 'Y' 
			     	    			else 'Z' end  as HOLD_YN
			     	    	 , x.STOCK_QTY  as qty
							 , dateadd(day, 1, convert(datetime, x.cutoff_date)) as cutoff_date
			     	      FROM SY_SSP_ANL_OWMS_STOCK_C2 x with(nolock)
			     	    	   join sy_scm_mst_site as y with(nolock)
			     	        on x.division_id = y.division_id
			     	       and x.from_site = y.scm_site_id
			     	     WHERE 1 = 1 
						   and x.COMPANY_ID = @v_company_id
			     	       and x.division_id = @v_division_id
						   --and x.from_site = @v_plant_id + '-A'
						   and y.plant_id = @v_plant_id
			     	       AND x.CUTOFF_DATE between format(dateadd(day, -1, @v_yyyymmdd_from), 'yyyyMMdd') and format(dateadd(day, -1, @v_yyyymmdd_to), 'yyyyMMdd')
			     	       and x.STOCK_STATUS IN ('00', '40', '10')

			          ) as s
			          join scm_item_m as m with(nolock)
			       on s.company_id		= m.company_id
			      and s.division_id		= m.division_id
			      and s.site_id			= m.site_id
			      and s.item_id 		= m.item_id

		       ) as stock
			   join @vt_cal_yyyypw as yyyypw
			on stock.cutoff_date = yyyypw.dt
		 where 1 = 1
		   and HOLD_YN = 'N'
		 group by gubun1, division_id, category, nick_name, item_id, cutoff_date

		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		select 'Cell Inv_OWMS' 
		     , division_id
			 , category
			 , nick_name
			 , item_id
			 , convert(nvarchar, cutoff_date, 112) as yyyymmdd
			 , sum(qty) as qty
		  from (
			     select m.applied_model as model_id
			     	  , m.nick_name
			     	  , s.*
			     from (
		     	    
			     	    select 11 as gubun_order, 'Cell Inv_OWMS' as gubun1, 'OWMS F/G' as gubun2
			     	    	 , x.company_id, x.division_id, y.site_id, x.item_id
			     	    	 ,'-' as category
			     	    	 , case when x.stock_status = '00' then 'N' 
			     	    			when x.stock_status = '40' then 'Y' 
			     	    			else 'Z' end  as HOLD_YN
			     	    	 , x.STOCK_QTY  as qty
							 , dateadd(day, 1, convert(datetime, x.cutoff_date)) as cutoff_date
			     	      FROM SY_SSP_ANL_OWMS_STOCK_C2 x with(nolock)
			     	    	   join sy_scm_mst_site as y with(nolock)
			     	        on x.division_id = y.division_id
			     	       and x.from_site = y.scm_site_id
			     	     WHERE 1 = 1 
						   and x.COMPANY_ID = @v_company_id
			     	       and x.division_id = @v_division_id
						   --and x.from_site = @v_plant_id + '-A'
						   and y.plant_id = @v_plant_id
			     	       AND x.CUTOFF_DATE between format(dateadd(day, -1, @v_yyyymmdd_from), 'yyyyMMdd') and format(dateadd(day, -1, @v_yyyymmdd_to), 'yyyyMMdd')
			     	       and x.STOCK_STATUS IN ('00', '40', '10')

			          ) as s
			          join scm_item_m as m with(nolock)
			       on s.company_id		= m.company_id
			      and s.division_id		= m.division_id
			      and s.site_id			= m.site_id
			      and s.item_id 		= m.item_id

		       ) as stock
			   join @vt_cal_yyyypw as yyyypw
			on stock.cutoff_date = yyyypw.dt
		 where 1 = 1
		   and HOLD_YN = 'N'
		 group by gubun1, division_id, category, nick_name, item_id, cutoff_date


		-- WPP
		insert into #REPORT_BY_MEASURE (measure, division_id, electrode_type, nick_name, item_id, yyyymmdd, qty)
		select 'WPP'
		     , x.division_id
			 , x.electrode_type
			 , t.nick_name
			 , x.item_id
			 , convert(nvarchar, x.plan_date, 112) as yyyymmdd
			 , sum(x.cell_out_qty) as qty
		 from FP_DAILY_PRODUCTIOIN_PLAN_H as x with(nolock)
			  JOIN SCM_ITEM_M AS T WITH(NOLOCK)				 
		   ON x.ITEM_ID				= T.ITEM_ID					 
		  AND x.DIVISION_ID			= T.DIVISION_ID				 
		  AND x.COMPANY_ID			= T.COMPANY_ID	
		  AND x.SITE_ID				= T.SITE_ID
		where x.plan_type = 'WPP'
		  and x.company_id   = @v_company_id	
		  and x.division_id  = @v_division_id	
		  and x.site_id	     = @v_site_id		
		  and x.plant_id     = @v_plant_id
		  --and x.plan_date    between @v_yyyymmdd_from and @v_yyyymmdd_to
		  and x.plan_date    >= @v_yyyymmdd_from
		  and x.operation_id = 'A9000'
		  and x.cell_out_qty > 0
        group by 
		      x.division_id, x.electrode_type, t.nick_name, x.item_id, x.plan_date


		select x.measure
		     , x.division_id
			 , x.electrode_type
			 , x.nick_name
			 , y.year
			 , y.month
			 , case when right(y.iso_yyyypw, 1) = 'A' then LEFT(y.iso_yyyypw,6) + 'W_A' 
			        when right(y.iso_yyyypw, 1) = 'B' then LEFT(y.iso_yyyypw,6) + 'W_B' 
					else y.iso_yyyypw + 'W' end
			   as week
			 , sum(x.qty) as qty
		  from #REPORT_BY_MEASURE as x
		       JOIN TH_UIS_CAL as y with(nolock)
		    on x.yyyymmdd = y.yyyymmdd
		 group by 
		       x.measure, x.division_id, x.electrode_type, x.nick_name, y.year, y.month, y.iso_yyyypw
		 order by 
		       x.measure, x.division_id, x.electrode_type, x.nick_name, y.year, y.month, y.iso_yyyypw



		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#REPORT_BY_MEASURE') is not null
		drop table #REPORT_BY_MEASURE

END



