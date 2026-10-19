
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_DNM_STOCK_PUR]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [SCM_SITE_ID], NULL as [SITE_ID], NULL as [PLANT_ID], NULL as [FACTORY_ID], NULL as [STORAGE_ID], NULL as [CUTOFF_DATE], NULL as [SEQ], NULL as [STOCK_TYPE], NULL as [ITEM_ID], NULL as [LANE], NULL as [PRODUCTION_TYPE], NULL as [AVAILABLE_DATE], NULL as [REMAIN_LEAD_TIME], NULL as [HOLDING_DATE], NULL as [QTY], NULL as [QTY_UOM], NULL as [STOCK_STATUS], NULL as [OPERATION_ID], NULL as [LINE_ID], NULL as [OUTSOURCING_FLAG], NULL as [OUTSOURCING_FACTORY], NULL as [DESCRIPTION], NULL as [FP_APPLY_OPERATION_ID], NULL as [FP_APPLY_ITEM_ID], NULL as [FP_APPLY_WIPQTY], NULL as [WIPHOLD_YN], NULL as [WIP_TYPE_CODE], NULL as [QTY2], NULL as [MODIFY_FP_APPLY_WIPQTY], NULL as [MODIFY_DESCRIPTION], NULL as [CAL_QTY], NULL as [FORMATION_REWORK_TYPE], NULL as [INSERT_ID], NULL as [INSERT_TIME], NULL as [UPDATE_ID], NULL as [UPDATE_TIME], NULL as [LOCATION], NULL as [RELEASE_DUE_DATE], NULL as [SHIP_AVAILABLE_DATE], NULL as [LONG_TERM_QTY], NULL as [MOVING_QTY], NULL as [CAPA_GRD_CODE], NULL as [VLTG_GRD_CODE], NULL as [RSST_GRD_CODE], NULL as [DEFECT_QTY]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[SEQ], t.[STOCK_TYPE], t.[ITEM_ID], t.[LANE], t.[PRODUCTION_TYPE], t.[AVAILABLE_DATE], t.[REMAIN_LEAD_TIME], t.[HOLDING_DATE], t.[QTY], t.[QTY_UOM], t.[STOCK_STATUS], t.[OPERATION_ID], t.[LINE_ID], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[DESCRIPTION], t.[FP_APPLY_OPERATION_ID], t.[FP_APPLY_ITEM_ID], t.[FP_APPLY_WIPQTY], t.[WIPHOLD_YN], t.[WIP_TYPE_CODE], t.[QTY2], t.[MODIFY_FP_APPLY_WIPQTY], t.[MODIFY_DESCRIPTION], t.[CAL_QTY], t.[FORMATION_REWORK_TYPE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[LOCATION], t.[RELEASE_DUE_DATE], t.[SHIP_AVAILABLE_DATE], t.[LONG_TERM_QTY], t.[MOVING_QTY], t.[CAPA_GRD_CODE], t.[VLTG_GRD_CODE], t.[RSST_GRD_CODE], t.[DEFECT_QTY]
	from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[PLANT_ID], t.[FACTORY_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[SEQ], t.[STOCK_TYPE], t.[ITEM_ID], t.[LANE], t.[PRODUCTION_TYPE], t.[AVAILABLE_DATE], t.[REMAIN_LEAD_TIME], t.[HOLDING_DATE], t.[QTY], t.[QTY_UOM], t.[STOCK_STATUS], t.[OPERATION_ID], t.[LINE_ID], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[DESCRIPTION], t.[FP_APPLY_OPERATION_ID], t.[FP_APPLY_ITEM_ID], t.[FP_APPLY_WIPQTY], t.[WIPHOLD_YN], t.[WIP_TYPE_CODE], t.[QTY2], t.[MODIFY_FP_APPLY_WIPQTY], t.[MODIFY_DESCRIPTION], t.[CAL_QTY], t.[FORMATION_REWORK_TYPE], t.[INSERT_ID], t.[INSERT_TIME], t.[UPDATE_ID], t.[UPDATE_TIME], t.[LOCATION], t.[RELEASE_DUE_DATE], t.[SHIP_AVAILABLE_DATE], t.[LONG_TERM_QTY], t.[MOVING_QTY], t.[CAPA_GRD_CODE], t.[VLTG_GRD_CODE], t.[RSST_GRD_CODE], t.[DEFECT_QTY]
	from [cdc].[dbo_SCM_DNM_STOCK_PUR_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_DNM_STOCK_PUR', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	