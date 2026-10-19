
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_ANL_MAT_SUPPLY]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SCP_PLAN_START_YYYYMMDD], NULL as [MRP_PLAN_START_YYYYMMDD], NULL as [PSI], NULL as [MEASURE], NULL as [COMPANY], NULL as [DIVISION_ID], NULL as [ORIGIN_DIVISION_ID], NULL as [PLANT_ID], NULL as [MATERIAL], NULL as [OPERATION_GROUP], NULL as [OPERATION_ID], NULL as [ITEM_ID], NULL as [YYYYMMDD], NULL as [YYYYMM], NULL as [WEEK], NULL as [ISO_WEEK], NULL as [UOM], NULL as [NICKNAME], NULL as [SUPPLIER], NULL as [ITEM_CATEGORY], NULL as [QTY], NULL as [CELL_CF], NULL as [YIELD_RATE], NULL as [REMARK], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SCP_PLAN_START_YYYYMMDD], t.[MRP_PLAN_START_YYYYMMDD], t.[PSI], t.[MEASURE], t.[COMPANY], t.[DIVISION_ID], t.[ORIGIN_DIVISION_ID], t.[PLANT_ID], t.[MATERIAL], t.[OPERATION_GROUP], t.[OPERATION_ID], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK], t.[ISO_WEEK], t.[UOM], t.[NICKNAME], t.[SUPPLIER], t.[ITEM_CATEGORY], t.[QTY], t.[CELL_CF], t.[YIELD_RATE], t.[REMARK], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE]
	from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SCP_PLAN_START_YYYYMMDD], t.[MRP_PLAN_START_YYYYMMDD], t.[PSI], t.[MEASURE], t.[COMPANY], t.[DIVISION_ID], t.[ORIGIN_DIVISION_ID], t.[PLANT_ID], t.[MATERIAL], t.[OPERATION_GROUP], t.[OPERATION_ID], t.[ITEM_ID], t.[YYYYMMDD], t.[YYYYMM], t.[WEEK], t.[ISO_WEEK], t.[UOM], t.[NICKNAME], t.[SUPPLIER], t.[ITEM_CATEGORY], t.[QTY], t.[CELL_CF], t.[YIELD_RATE], t.[REMARK], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE]
	from [cdc].[dbo_SCP_ANL_MAT_SUPPLY_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_ANL_MAT_SUPPLY', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	