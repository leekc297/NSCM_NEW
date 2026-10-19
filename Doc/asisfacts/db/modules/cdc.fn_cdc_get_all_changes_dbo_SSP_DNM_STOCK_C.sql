
	create function [cdc].[fn_cdc_get_all_changes_dbo_SSP_DNM_STOCK_C]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [COMPANY_ID], NULL as [DIVISION_ID], NULL as [PLANT_ID], NULL as [STORAGE_ID], NULL as [CUTOFF_DATE], NULL as [STOCK_TYPE], NULL as [ITEM_ID], NULL as [SCM_SITE_ID], NULL as [SITE_ID], NULL as [OPERATION_ID], NULL as [QTY_UOM], NULL as [WIPHOLD_YN], NULL as [HOLDING_DATE], NULL as [AVAILABLE_DATE], NULL as [OUTSOURCING_FLAG], NULL as [OUTSOURCING_FACTORY], NULL as [SCM_QTY], NULL as [SSP_QTY], NULL as [MOVING_QTY], NULL as [DEFECT_QTY], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_DNM_STOCK_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[STOCK_TYPE], t.[ITEM_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[OPERATION_ID], t.[QTY_UOM], t.[WIPHOLD_YN], t.[HOLDING_DATE], t.[AVAILABLE_DATE], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[SCM_QTY], t.[SSP_QTY], t.[MOVING_QTY], t.[DEFECT_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_DNM_STOCK_C_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_DNM_STOCK_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[COMPANY_ID], t.[DIVISION_ID], t.[PLANT_ID], t.[STORAGE_ID], t.[CUTOFF_DATE], t.[STOCK_TYPE], t.[ITEM_ID], t.[SCM_SITE_ID], t.[SITE_ID], t.[OPERATION_ID], t.[QTY_UOM], t.[WIPHOLD_YN], t.[HOLDING_DATE], t.[AVAILABLE_DATE], t.[OUTSOURCING_FLAG], t.[OUTSOURCING_FACTORY], t.[SCM_QTY], t.[SSP_QTY], t.[MOVING_QTY], t.[DEFECT_QTY], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SSP_DNM_STOCK_C_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SSP_DNM_STOCK_C', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	