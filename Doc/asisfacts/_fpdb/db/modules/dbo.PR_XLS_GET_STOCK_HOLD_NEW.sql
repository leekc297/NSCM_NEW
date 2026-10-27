
/*
 * Program ID   : PR_XLS_GET_STOCK_HOLD_NEW
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 2024.11.04   shineuiho67      replace(replace(operation,'-W',''),'-E','') : Waiting EOL 하나로 나오도록 수정 (엑셀과 맞추기 위하여)
 *                               iif(type = 'Cell','',type) : 전극 구분이 Cell 일때는 공백으로 나오도록 수정 (엑셀과 맞추기 위하여)
 * 2024.11.05   shineuiho67      Before DGS, After DGS, Waiting EOL-W, Waiting EOL-E : Waiting EOL 로 나오도록 수정 (엑셀과 맞추기 위하여)
 * 2024.11.05   shineuiho67      iif(qms_hold_yn = 'N','','Y') -> qms_hold_yn = 'N' 인 것만 집계 대상이 되도록 조건 추가(Waiting EOL 4가지 대상)
 * 2024.11.05   FP Pjt.          After DGS : available_date >= cutoff_date, Waiting EOL-W, Waiting EOL-E : available_date < cutoff_date
 * 2024.11.14   shineuiho67      keys컬럼에서 Y 제거하고, Waiting EOL 4가지이면서 (wiphold_yn = 'Y' or qms_hold_yn = 'Y') 인 것 대상으로 : avail date vs (VS_PLAN_START_DATE + 7) 비교해서 큰날자를 avail date 로 한다.
 * 2024.11.14   shineuiho67      keys컬럼에 변경된 avail date를 적용.
 * 2025.01.07   shineuiho67      (line_group_id), keys_Line_Group_Id 컬럼 추가 : Waiting EOL(4가지)일 경우만, keys_Line_Group_Id 컬럼에 WEST, EAST 추가 표시, 다른 공정일경우는 서편동편불필요하므로 '' 추가 표시, 그리고 UC2인 경우는 무조건 WEST 표시(UC2는 서편 동편 구분없음) 

 ex) 
   exec [dbo].[PR_XLS_GET_STOCK_HOLD_NEW] 'UC1', '20241025'
 */

CREATE PROCEDURE [dbo].[PR_XLS_GET_STOCK_HOLD_NEW]
    @p_apl_code             nvarchar(max)
,	@p_yyyymmdd				NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE	@v_apl_code				NVARCHAR(MAX)
	DECLARE	@v_yyyymmdd				nvarchar(max)

	declare	@v_company_id			nvarchar(50)
	declare	@v_division_id			NVARCHAR(50) 
	declare	@v_site_id				nvarchar(50)
	declare	@v_plant_id				nvarchar(50)
	declare @v_elec_plant_id		nvarchar(50)

	set @v_apl_code			= @p_apl_code
	set @v_yyyymmdd			= @p_yyyymmdd

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
               , line_group_id          nvarchar(100)
			)



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
	
		insert into #base_info(avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, qty, gubun_order, line_group_id)
		select avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status
			 , sum(qty) as qty
			 , gubun_order
             , LINE_GROUP_ID
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
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
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_elec_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
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
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_elec_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
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
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
			     	      from scm_stock_h as x with(nolock)
			     	    	   join scm_item_m as z with(nolock)
			     	        on x.company_id = z.company_id
			     	       and x.division_id = z.division_id
			     	       and x.site_id = z.site_id
			     	       and x.item_id = z.item_id
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , '-' as LINE_GROUP_ID
			     	      from scm_stock_h as x with(nolock)
			     	    where 1 = 1
			     	      and x.cutoff_date = @p_yyyymmdd
			     	      and x.company_id = @v_company_id
			     	      and x.division_id = @v_division_id
						  and x.site_id = @v_site_id
			     	      and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.UNHOLD_EXP_DATE as avail_date
							 , x.line_id
							 , x.stock_status
                             , z.LINE_GROUP_ID as LINE_GROUP_ID
			     	      from scm_stock_h     as x with(nolock)
                          left join scm_line_m as z with(nolock) 
							on x.COMPANY_ID     = z.COMPANY_ID
						   and x.DIVISION_ID	= z.DIVISION_ID
						   and x.SITE_ID		= z.SITE_ID
						   and x.PLANT_ID		= z.PLANT_ID
                           and x.FACTORY_ID		= z.FACTORY_ID
						   and x.OPERATION_ID	= z.OPERATION_ID
                           and x.LINE_ID	    = z.LINE_ID
						   and z.ACTIVE_FLAG    = 'Y'
                           and z.ELECTRODE_TYPE = '-'
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
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
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
                             , z.LINE_GROUP_ID as LINE_GROUP_ID
			     	      from scm_aging_stock_h as x with(nolock)
                          left join scm_line_m   as z with(nolock) 
							on x.COMPANY_ID     = z.COMPANY_ID
						   and x.DIVISION_ID	= z.DIVISION_ID
						   and x.SITE_ID		= z.SITE_ID
						   and x.PLANT_ID		= z.PLANT_ID
                           and x.FACTORY_ID		= z.FACTORY_ID
                           and x.LINE_ID	    = z.LINE_ID
						   and z.ACTIVE_FLAG    = 'Y'
                           and z.ELECTRODE_TYPE = '-'
                           and z.OPERATION_ID = 'F6000' --Before Dgs, After Dgs는 라인정보가 Waiting EOL하고 동일
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'Y'
						   --and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 8 as gubun_order, 'Cell' as gubun1, 'After DGS' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty  as qty
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
                             , z.LINE_GROUP_ID as LINE_GROUP_ID
			     	      from scm_aging_stock_h as x with(nolock)
                          left join scm_line_m   as z with(nolock) 
							on x.COMPANY_ID     = z.COMPANY_ID
						   and x.DIVISION_ID	= z.DIVISION_ID
						   and x.SITE_ID		= z.SITE_ID
						   and x.PLANT_ID		= z.PLANT_ID
                           and x.FACTORY_ID		= z.FACTORY_ID
                           and x.LINE_ID	    = z.LINE_ID
						   and z.ACTIVE_FLAG    = 'Y'
                           and z.ELECTRODE_TYPE = '-'
                           and z.OPERATION_ID = 'F6000' --Before Dgs, After Dgs는 라인정보가 Waiting EOL하고 동일
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
			     	       and x.company_id = @v_company_id
			     	       and x.division_id = @v_division_id
						   and x.site_id = @v_site_id
			     	       and x.plant_id = @v_plant_id
			     	       and x.before_degas = 'N'
			     	       and x.available_date >= x.cutoff_date
						   --and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 9 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-W' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty  as qty
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
                             , 'WEST' as LINE_GROUP_ID
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
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
			     	       --and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			     	    union all
			     	    
			     	    select 10 as gubun_order, 'Cell' as gubun1, 'Waiting EOL-E' as operation
			     	    	 , x.company_id, x.division_id, x.site_id, x.item_id
			     	    	 ,'Cell' as type
			     	    	 , case when x.wiphold_yn = 'N' and  x.special_YN = 'N' 
			     	    			then 'N' else 'Y' end  as HOLD_YN
							 , x.wiphold_yn
							 , case when x.special_yn = 'N' then 'N' else 'Y' end as qms_hold_yn
			     	    	 , x.original_qty as qty
							 , x.cutoff_date
							 , x.available_date as avail_date
							 , x.line_id
							 , x.TRAY_OP_STATUS as stock_status
                             , 'EAST' as LINE_GROUP_ID
			     	      from scm_aging_stock_h as x with(nolock)
			     	     where 1 = 1
			     	       and x.cutoff_date = @p_yyyymmdd
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
			     	       --and (x.special_yn != 'N' or x.wiphold_yn = 'Y')
			     	    
			          ) as s
			          join scm_item_m as m with(nolock)
			       on s.company_id		= m.company_id
			      and s.division_id		= m.division_id
			      and s.site_id			= m.site_id
			      and s.item_id 		= m.item_id

		       ) as stock
		 group by avail_date, operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, gubun_order, LINE_GROUP_ID

	    select 
             case when operation in ('Before DGS','After DGS','Waiting EOL-W','Waiting EOL-E') and (wiphold_yn = 'Y' or qms_hold_yn = 'Y') 
                  then iif(Format(avail_date, 'yyyy-MM-dd') >= Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'), 
                           Format(avail_date, 'yyyy-MM-dd'), 
                           Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'))
                  else Format(avail_date, 'yyyy-MM-dd') 
              end as avail_date
		     , operation, line_id, model_id, nick_name, item_id, type, wiphold_yn, qms_hold_yn, stock_status, qty, 
             case when operation = 'After Coating'  then 'Pancake'
                  when operation = 'After R/P'      then 'Pancake'
                  when operation = 'After NND'      then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'Before L&S'     then 'Notched Pancake'
                  when operation = 'Before DGS'     then 'Waiting EOL'
                  when operation = 'After DGS'      then 'Waiting EOL'
                  when operation = 'Waiting EOL-W'  then 'Waiting EOL'
                  when operation = 'Waiting EOL-E'  then 'Waiting EOL'
                  else operation
             end as operation_group
             , case when operation in ('Before DGS','After DGS','Waiting EOL-W','Waiting EOL-E') and (wiphold_yn = 'Y' or qms_hold_yn = 'Y') 
                  then iif(Format(avail_date, 'yyyy-MM-dd') >= Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'), 
                           Format(avail_date, 'yyyy-MM-dd'), 
                           Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'))
                  else Format(avail_date, 'yyyy-MM-dd') 
             end + 
             case when operation = 'After Coating'  then 'Pancake'
                  when operation = 'After R/P'      then 'Pancake'
                  when operation = 'After NND'      then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'Before L&S'     then 'Notched Pancake'
                  when operation = 'Before DGS'     then 'Waiting EOL' 
                  when operation = 'After DGS'      then 'Waiting EOL'
                  when operation = 'Waiting EOL-W'  then 'Waiting EOL'
                  when operation = 'Waiting EOL-E'  then 'Waiting EOL'
                  else operation
             end +
             iif(type = 'Cell','',type) +
             right(nick_name,3)  
             as keys
             --2025-01-07 코딩추가 start 
            , case when operation in ('Before DGS','After DGS','Waiting EOL-W','Waiting EOL-E') and (wiphold_yn = 'Y' or qms_hold_yn = 'Y') 
                  then iif(Format(avail_date, 'yyyy-MM-dd') >= Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'), 
                           Format(avail_date, 'yyyy-MM-dd'), 
                           Format(dateadd(DAY, 7, @v_yyyymmdd), 'yyyy-MM-dd'))
                  else Format(avail_date, 'yyyy-MM-dd') 
             end + 
             case when operation = 'After Coating'  then 'Pancake'
                  when operation = 'After R/P'      then 'Pancake'
                  when operation = 'After NND'      then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'V/D Inspection' then 'Notched Pancake'
                  when operation = 'Before L&S'     then 'Notched Pancake'
                  when operation = 'Before DGS'     then 'Waiting EOL' 
                  when operation = 'After DGS'      then 'Waiting EOL'
                  when operation = 'Waiting EOL-W'  then 'Waiting EOL'
                  when operation = 'Waiting EOL-E'  then 'Waiting EOL'
                  else operation
             end +
             iif(type = 'Cell','',type) +
             right(nick_name,3) +
             LINE_GROUP_ID --서편동편 line_group_id 별로 엑셀에서 집계하기 위하여.(L&S, PKG, EOL 공정만 WEST 또는 EAST가 되고, 나머지 공정은 모두 공백의미의 (-) 표시됨.) 
             as keys_Line_Group_Id
             --2025-01-07 코딩추가 end
		  from #base_info
		 order by gubun_order, line_id, avail_date

		PRINT 'OK'

	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()


	END CATCH

	if object_id('tempdb..#base_info') is not null
		drop table #base_info
END
