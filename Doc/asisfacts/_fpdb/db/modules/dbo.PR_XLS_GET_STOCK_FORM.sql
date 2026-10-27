
/*
 * Program ID   : PR_XLS_GET_STOCK_FORM
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 
 * 
 ex) 
   exec [dbo].[PR_XLS_GET_STOCK_FORM] 'UC1', '20240825', '20240831'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_STOCK_FORM]
    @p_apl_code             nvarchar(max)
,	@p_yyyymmdd_from	    NVARCHAR(MAX)
,	@p_yyyymmdd_to			NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE		@v_apl_code			NVARCHAR(MAX)
	DECLARE		@v_yyyymmdd_from	nvarchar(max)
	DECLARE		@v_yyyymmdd_to		nvarchar(max)

	declare		@v_company_id		nvarchar(50)
	declare		@v_division_id		NVARCHAR(50) 
	declare		@v_site_id			nvarchar(50)
	declare		@v_plant_id			nvarchar(50)
	declare     @v_elec_plant_id	nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd_from	= @p_yyyymmdd_from
	set @v_yyyymmdd_to		= @p_yyyymmdd_to


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


		select
               CONCAT(s.gubun2, DATEDIFF(DAY, '1900-01-01', FORMAT(s.cutoff_date-1, 'yyyy-MM-dd')) + 2, LINE_ID)   AS 'Oper_Date_Line'	
             , format(s.cutoff_date-1, 'yyyy-MM-dd') as cutoff_date
			 , s.company_id
			 , s.division_id
			 , s.site_id
			 , s.gubun2 as operation
			 , s.line_id
			 , sum(s.qty) as qty
		  from (
			   select 7 as gubun_order, 'Cell' as gubun1, 'Before DGS' as gubun2
					, x.company_id, x.division_id, x.site_id, x.item_id, x.line_id
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
					, x.company_id, x.division_id, x.site_id, x.item_id, x.line_id
					, 'Cell' as category
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

/*			     	    
			   union all
			     	    
			  select 8 as gubun_order, 'Cell' as gubun1, 'After DGS' as gubun2
				   , x.company_id, x.division_id, x.site_id, x.item_id, x.line_id
				   , 'Cell' as category
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
*/			     	    
			   union all
			     	    
			  select 9 as gubun_order, 'Cell' as gubun1, 'Waiting EOL' as gubun2
				   , x.company_id, x.division_id, x.site_id, x.item_id, x.line_id
				   , 'Cell' as category
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
			     --and x.line_id in ('ABA01', 'ABA02', 'ABA03', 'ABA04','ABA05')
			     and x.available_date < x.cutoff_date
			     --and x.special_yn in ('Y', 'N')
/*			     	    
			   union all
			     	    
			  select 10 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-E' as gubun2
				   , x.company_id, x.division_id, x.site_id, x.item_id, x.line_id
				   , 'Cell' as category
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
			     and x.line_id in ('ABA06', 'ABA07', 'ABA08', 'ABA09','ABA10')
			     and x.available_date < x.cutoff_date
			     --and x.special_yn in ('Y', 'N')
*/

			) as s
			  join scm_item_m as m with(nolock)
		   on s.company_id		= m.company_id
		  and s.division_id		= m.division_id
		  and s.site_id			= m.site_id
		  and s.item_id 		= m.item_id
		where s.hold_yn = 'N'
	    group by 
              CONCAT(s.gubun2, DATEDIFF(DAY, '1900-01-01', FORMAT(s.cutoff_date-1, 'yyyy-MM-dd')) + 2, LINE_ID)
		    , s.gubun1
			, s.company_id
			, s.division_id
			, s.site_id
			, s.gubun2
			, s.line_id
			, s.cutoff_date
	    order by
             CONCAT(s.gubun2, DATEDIFF(DAY, '1900-01-01', FORMAT(s.cutoff_date-1, 'yyyy-MM-dd')) + 2, LINE_ID)
	        , s.cutoff_date
	        , s.gubun1
		    , s.gubun2
	        , s.line_id


		PRINT 'OK'


	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH


END



