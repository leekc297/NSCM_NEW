
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCP_MST_DISTRIBUTION_ROUTE]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [ROUTE_ID], NULL as [FROM_COUNTRY], NULL as [FROM_CITY], NULL as [TRANSPORT_MODE], NULL as [PRIORITY], NULL as [DAYS_MON], NULL as [DAYS_TUE], NULL as [DAYS_WED], NULL as [DAYS_THU], NULL as [DAYS_FRI], NULL as [DAYS_SAT], NULL as [DAYS_SUN], NULL as [D_COUNTRY], NULL as [D_PORT_CODE], NULL as [D_PORT_NAME], NULL as [A_COUNTRY], NULL as [A_PORT_CODE], NULL as [A_PORT_NAME], NULL as [SHIPPING_COMPANY], NULL as [TO_COUNTRY], NULL as [TO_CITY], NULL as [SHIP_DOC_PREPARATION_DATE], NULL as [LT_DEPARTURE_INLAND], NULL as [LT_WAIT_SHIPPING], NULL as [LT_VOYAGE], NULL as [LT_LAY_OFF_CLEARANCE], NULL as [LT_ARRIVAL_INLAND], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10], NULL as [LT_TYPE]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ROUTE_ID], t.[FROM_COUNTRY], t.[FROM_CITY], t.[TRANSPORT_MODE], t.[PRIORITY], t.[DAYS_MON], t.[DAYS_TUE], t.[DAYS_WED], t.[DAYS_THU], t.[DAYS_FRI], t.[DAYS_SAT], t.[DAYS_SUN], t.[D_COUNTRY], t.[D_PORT_CODE], t.[D_PORT_NAME], t.[A_COUNTRY], t.[A_PORT_CODE], t.[A_PORT_NAME], t.[SHIPPING_COMPANY], t.[TO_COUNTRY], t.[TO_CITY], t.[SHIP_DOC_PREPARATION_DATE], t.[LT_DEPARTURE_INLAND], t.[LT_WAIT_SHIPPING], t.[LT_VOYAGE], t.[LT_LAY_OFF_CLEARANCE], t.[LT_ARRIVAL_INLAND], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[LT_TYPE]
	from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[ROUTE_ID], t.[FROM_COUNTRY], t.[FROM_CITY], t.[TRANSPORT_MODE], t.[PRIORITY], t.[DAYS_MON], t.[DAYS_TUE], t.[DAYS_WED], t.[DAYS_THU], t.[DAYS_FRI], t.[DAYS_SAT], t.[DAYS_SUN], t.[D_COUNTRY], t.[D_PORT_CODE], t.[D_PORT_NAME], t.[A_COUNTRY], t.[A_PORT_CODE], t.[A_PORT_NAME], t.[SHIPPING_COMPANY], t.[TO_COUNTRY], t.[TO_CITY], t.[SHIP_DOC_PREPARATION_DATE], t.[LT_DEPARTURE_INLAND], t.[LT_WAIT_SHIPPING], t.[LT_VOYAGE], t.[LT_LAY_OFF_CLEARANCE], t.[LT_ARRIVAL_INLAND], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10], t.[LT_TYPE]
	from [cdc].[dbo_SCP_MST_DISTRIBUTION_ROUTE_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCP_MST_DISTRIBUTION_ROUTE', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	