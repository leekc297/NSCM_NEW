
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_CUSTOMER]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [SOLDTO_CODE], NULL as [SHIPTO_CODE], NULL as [SOLDTO_DESCRIPTION], NULL as [SOLDTO_ADDRESS], NULL as [SOLDTO_COUNTRY], NULL as [SOLDTO_REGION], NULL as [SOLDTO_REGION_NAME], NULL as [SOLDTO_CITY_NAME], NULL as [SHIPTO_DESCRIPTION], NULL as [SHIPTO_ADDRESS], NULL as [SHIPTO_COUNTRY], NULL as [SHIPTO_REGION], NULL as [SHIPTO_REGION_NAME], NULL as [SHIPTO_CITY_NAME], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [CITY], NULL as [SHIPTO_CITY]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_CUSTOMER', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[SOLDTO_CODE], t.[SHIPTO_CODE], t.[SOLDTO_DESCRIPTION], t.[SOLDTO_ADDRESS], t.[SOLDTO_COUNTRY], t.[SOLDTO_REGION], t.[SOLDTO_REGION_NAME], t.[SOLDTO_CITY_NAME], t.[SHIPTO_DESCRIPTION], t.[SHIPTO_ADDRESS], t.[SHIPTO_COUNTRY], t.[SHIPTO_REGION], t.[SHIPTO_REGION_NAME], t.[SHIPTO_CITY_NAME], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CITY], t.[SHIPTO_CITY]
	from [cdc].[dbo_SCM_MST_CUSTOMER_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_CUSTOMER', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[SOLDTO_CODE], t.[SHIPTO_CODE], t.[SOLDTO_DESCRIPTION], t.[SOLDTO_ADDRESS], t.[SOLDTO_COUNTRY], t.[SOLDTO_REGION], t.[SOLDTO_REGION_NAME], t.[SOLDTO_CITY_NAME], t.[SHIPTO_DESCRIPTION], t.[SHIPTO_ADDRESS], t.[SHIPTO_COUNTRY], t.[SHIPTO_REGION], t.[SHIPTO_REGION_NAME], t.[SHIPTO_CITY_NAME], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[CITY], t.[SHIPTO_CITY]
	from [cdc].[dbo_SCM_MST_CUSTOMER_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_CUSTOMER', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	