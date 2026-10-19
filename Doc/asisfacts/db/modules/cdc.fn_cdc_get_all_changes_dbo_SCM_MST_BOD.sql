
	create function [cdc].[fn_cdc_get_all_changes_dbo_SCM_MST_BOD]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return
	
	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [DIVISION_ID], NULL as [BOD_ID], NULL as [BOD_TYPE], NULL as [FROM_SITE], NULL as [POL], NULL as [POD], NULL as [HUB_SLOC], NULL as [TO_SITE], NULL as [INCOTERMS], NULL as [TRANSPORT_MODE], NULL as [PRIORITY], NULL as [PERIOD_SHIPSCH_MON], NULL as [PERIOD_SHIPSCH_TUE], NULL as [PERIOD_SHIPSCH_WED], NULL as [PERIOD_SHIPSCH_THU], NULL as [PERIOD_SHIPSCH_FRI], NULL as [PERIOD_SHIPSCH_SAT], NULL as [PERIOD_SHIPSCH_SUN], NULL as [FREIGHT_FORWARDER], NULL as [SAFETY_STOCK], NULL as [PERIOD1_LT], NULL as [POL_CLEARANCE_LT], NULL as [PERIOD2_LT], NULL as [POD_CLEARANCE_LT], NULL as [PERIOD3_LT], NULL as [CUSTOMER_LT], NULL as [VALID_YN], NULL as [CREATED_BY], NULL as [CREATION_DATE], NULL as [LAST_UPDATED_BY], NULL as [LAST_UPDATE_DATE], NULL as [ATTRIBUTE1], NULL as [ATTRIBUTE2], NULL as [ATTRIBUTE3], NULL as [ATTRIBUTE4], NULL as [ATTRIBUTE5], NULL as [ATTRIBUTE6], NULL as [ATTRIBUTE7], NULL as [ATTRIBUTE8], NULL as [ATTRIBUTE9], NULL as [ATTRIBUTE10]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all
	
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[BOD_ID], t.[BOD_TYPE], t.[FROM_SITE], t.[POL], t.[POD], t.[HUB_SLOC], t.[TO_SITE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[PRIORITY], t.[PERIOD_SHIPSCH_MON], t.[PERIOD_SHIPSCH_TUE], t.[PERIOD_SHIPSCH_WED], t.[PERIOD_SHIPSCH_THU], t.[PERIOD_SHIPSCH_FRI], t.[PERIOD_SHIPSCH_SAT], t.[PERIOD_SHIPSCH_SUN], t.[FREIGHT_FORWARDER], t.[SAFETY_STOCK], t.[PERIOD1_LT], t.[POL_CLEARANCE_LT], t.[PERIOD2_LT], t.[POD_CLEARANCE_LT], t.[PERIOD3_LT], t.[CUSTOMER_LT], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCM_MST_BOD_CT] t with (nolock)    
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
		
	union all	
		
	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[DIVISION_ID], t.[BOD_ID], t.[BOD_TYPE], t.[FROM_SITE], t.[POL], t.[POD], t.[HUB_SLOC], t.[TO_SITE], t.[INCOTERMS], t.[TRANSPORT_MODE], t.[PRIORITY], t.[PERIOD_SHIPSCH_MON], t.[PERIOD_SHIPSCH_TUE], t.[PERIOD_SHIPSCH_WED], t.[PERIOD_SHIPSCH_THU], t.[PERIOD_SHIPSCH_FRI], t.[PERIOD_SHIPSCH_SAT], t.[PERIOD_SHIPSCH_SUN], t.[FREIGHT_FORWARDER], t.[SAFETY_STOCK], t.[PERIOD1_LT], t.[POL_CLEARANCE_LT], t.[PERIOD2_LT], t.[POD_CLEARANCE_LT], t.[PERIOD3_LT], t.[CUSTOMER_LT], t.[VALID_YN], t.[CREATED_BY], t.[CREATION_DATE], t.[LAST_UPDATED_BY], t.[LAST_UPDATE_DATE], t.[ATTRIBUTE1], t.[ATTRIBUTE2], t.[ATTRIBUTE3], t.[ATTRIBUTE4], t.[ATTRIBUTE5], t.[ATTRIBUTE6], t.[ATTRIBUTE7], t.[ATTRIBUTE8], t.[ATTRIBUTE9], t.[ATTRIBUTE10]
	from [cdc].[dbo_SCM_MST_BOD_CT] t with (nolock)     
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_SCM_MST_BOD', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
	